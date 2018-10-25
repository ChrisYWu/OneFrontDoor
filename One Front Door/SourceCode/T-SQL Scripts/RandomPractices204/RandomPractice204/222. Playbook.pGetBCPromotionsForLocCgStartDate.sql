USE Portal_Data
GO

If Exists (Select * From sys.procedures Where object_id = object_id('Playbook.pGetBCPromotionsForLocCgStartDate'))
	Drop Proc Playbook.pGetBCPromotionsForLocCgStartDate
Go

Set QUOTED_IDENTIFIER ON
GO


/*
-- Deployed to 108 --
Declare @StartTime DateTime2(7)
Set @StartTime = SYSDATETIME()
exec Playbook.pGetBCPromotionsForLocCgStartDate @Debug =1, @SystemIDs = 7, @Date = '2015-1-1', @ChainGroups = 'N00055,L00324,L03072,L03076,L02452,N00042,R00161,R00278,R00169,R00126,R00127,R00123,N00066,N00050,R00148,R00144,N00012,R00021,R00017,R00020,N00021,N00121,N00036,R00092,R00106,R00103,N00085'
Select replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds

exec Playbook.pGetBCPromotionsForLocCgStartDate @SystemIDs = 7, @Date = '2015-1-1', @ChainGroups = 'N00055,L00324,L03072,L03076,L02452,N00042,R00161,R00278,R00169,R00126,R00127,R00123,N00066,N00050,R00148,R00144,N00012,R00021,R00017,R00020,N00021,N00121,N00036,R00092,R00106,R00103,N00085'

Declare @StartTime DateTime2(7)
Set @StartTime = SYSDATETIME()
exec Playbook.pGetBCPromotionsForLocCgStartDate @SystemIDs = '6', @Date = '2015-4-30', @ChainGroups = 'L03068'
Select replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds



*/

Create Proc Playbook.pGetBCPromotionsForLocCgStartDate
(
	@SystemIDs nvarchar(4000) = '',
	@ZoneIDs nvarchar(4000) = '',
	@DivisionIDs nvarchar(4000) = '',
	@RegionIDs nvarchar(4000) = '',
	@BottlerIDs nvarchar(4000) = '',
	@ChainGroups nvarchar(4000) = '',
	@Debug bit = 0, 
	@Date DateTime = null
)
AS
Begin
	/*  Rivision History
	2015-11-13 First Version; Developed on 108


	*/

	Set NoCount On;

	Declare @StartDate DateTime, @EndDate DateTime

	If (@Debug = 1)
	Begin
		Declare @StartTime DateTime2(7)
		Set @StartTime = SYSDATETIME()

		Select '---- Starting ----' Debug, @SystemIDs BUIDs, @ZoneIDs ZoneIDs, @DivisionIDs DivisionIDs, @RegionIDs RegionIDs, @BottlerIDs BottlerIDs, @ChainGroups ChainGroups, @Date StartDate
	End

	--~~~~~~~~~~~~~~~~~~~~~~ Stage 1. Parameters and User target ~~~~~~~~~~~~~~~~~~~~--
	Declare @RegionIDsTable Table
	(
		RegionID int,
		Primary Key (RegionID ASC)
	)

	Insert Into @RegionIDsTable
	Select Distinct RegionID
	From PreCal.BottlerHier h 
	Join dbo.Split(@SystemIDs, ',') s on h.SystemID = s.Value
	Union
	Select Distinct RegionID
	From PreCal.BottlerHier h 
	Join dbo.Split(@ZoneIDs, ',') s on h.ZoneID = s.Value
	Union
	Select Distinct RegionID
	From PreCal.BottlerHier h 
	Join dbo.Split(@DivisionIDs, ',') s on h.DivisionID = s.Value
	Union
	Select Distinct RegionID
	From PreCal.BottlerHier h 
	Join dbo.Split(@RegionIDs, ',') s on h.RegionID = s.Value

	--****
	Declare @BottlerIDsTable Table
	(
		BottlerID int,
		Primary Key (BottlerID ASC)
	)
	Insert Into @BottlerIDsTable 
	Select Distinct BottlerID
	From PreCal.BottlerHier h 
	Join dbo.Split(@BottlerIDs, ',') s on h.BottlerID = s.Value

	---------------
	If (@Date = '') 
		Set @Date = null

	If (@Date is null)
		Set @Date = GetDate()

	Set @StartDate = @Date
	Set @EndDate = DateAdd(week, 4, @StartDate)

	If (@Debug = 1)
	Begin
		Declare @BIDS varchar(4000)
		Set @BIDS = ''

		Select @BIDS = @BIDS + Convert(Varchar, RegionID) + ','
		From @RegionIDsTable

		If(@BIDS <> '')
		Begin
			Set @BIDS = SUBSTRING(@BIDS, 0, Len(@BIDS) - 1)
		End

		----
		Declare @BttlrIDS varchar(4000)
		Set @BttlrIDS = ''
		
		Select @BttlrIDS = @BttlrIDS + Convert(Varchar, BottlerID) + ','
		From @BottlerIDsTable

		If (@BttlrIDS <> '')
		Begin
			Set @BttlrIDS = SUBSTRING(@BttlrIDS, 0, Len(@BttlrIDS) - 1)
		End

		Select '---- Processed Parameters ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
			,@BIDS EffectiveRegionIDs
			,@BttlrIDS EffectiveBottlerIDs
			,@StartDate StartDate, @EndDate EndDate
	End

	--~~~~~~~~~~~~~~~~~~~~~~ Stage 2. The query ~~~~~~~~~~~~~~~~~~~~--
	Declare @Promo Table 
	(
		PromotionID int,
		ChainGroupID varchar(20),
		Primary Key(PromotionID ASC, ChainGroupID ASC)
	)

	Insert Into @Promo
	Select Distinct pb.PromotionID, pb.ChainGroupID
	From
	PreCal.PromotionRegionChainGroup pb with (nolock)
	Join @RegionIDsTable brds On pb.RegionID = brds.RegionID
	Join dbo.Split(@ChainGroups, ',') cg On cg.Value = pb.ChainGroupID
	Where pb.PromotionStartDate <= @EndDate And pb.PromotionEndDate > @StartDate -- @EndDate is inclusive, See promotion 34605 for details, 1-1 is not valid for that one
	And pb.IsPromotion = 1
	Union
	Select Distinct pb.PromotionID, pb.ChainGroupID
	From
	PreCal.PromotionBottlerChainGroup pb with (nolock)
	Join @BottlerIDsTable brds On pb.BottlerID = brds.BottlerID
	Join dbo.Split(@ChainGroups, ',') cg On cg.Value = pb.ChainGroupID
	Where pb.PromotionStartDate <= @EndDate And pb.PromotionEndDate > @StartDate -- @EndDate is inclusive, See promotion 34605 for details, 1-1 is not valid for that one
	And pb.IsPromotion = 1

	If (@Debug = 1)
	Begin
		Select '---- Promotions With ChainGroup associated filtered by locations ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select * From @Promo
	End;

	----
	Select Distinct cg.ChainGroupID, ChainGroupName, MobileImageURL
	From PlayBook.ChainGroup cg
	Join @Promo p on cg.ChainGroupID = p.ChainGroupID
	Order By ChainGroupName

	--- 
	Select ChainGroupID, rp.PromotionID, PromotionName, PromotionStartDate Start, PromotionEndDate [End], StatusName Status
	From PlayBook.RetailPromotion rp
	Join @Promo p on rp.PromotionID = p.PromotionID
	Join Playbook.Status s on rp.PromotionStatusID = StatusID
	Order By PromotionName

	--- Getting Promo Brands, doesn't unfold unnecessariy
	Select Distinct pb.PromotionID, 'B:' + b.BrandName Brand
	From Playbook.PromotionBrand pb With (nolock)
	Join @Promo pids on pb.PromotionID = pids.PromotionID
	Join SAP.Brand  b on pb.BrandID = b.BrandID
	Union 
	Select Distinct pb.PromotionID, 'T:' + t.TradeMarkName  Brand
	From Playbook.PromotionBrand pb With (nolock)
	Join @Promo pids on pb.PromotionID = pids.PromotionID
	Join SAP.TradeMark t on pb.TrademarkID = t.TradeMarkID
	Order By Brand

	---
	Select Distinct pa.PromotionID, 'L:' + ch.LocalChainName Chain
	From PlayBook.PromotionAccount pa
	Join SAP.Localchain ch on pa.LocalChainID = ch.LocalChainID
	Join @Promo pids on pa.PromotionID = pids.PromotionID
	Union
	Select Distinct pa.PromotionID, 'R:' + rc.RegionalChainName Chain
	From PlayBook.PromotionAccount pa
	Join SAP.RegionalChain rc on pa.RegionalChainID = rc.RegionalChainID
	Join @Promo pids on pa.PromotionID = pids.PromotionID
	Union
	Select Distinct pa.PromotionID, 'N:' + nc.NationalChainName Chain
	From PlayBook.PromotionAccount pa
	Join SAP.NationalChain nc on pa.NationalChainID = nc.NationalChainID
	Join @Promo pids on pa.PromotionID = pids.PromotionID
	Order By Chain

	----
	Select Distinct pids.PromotionID, p.PackageName
	From Playbook.PromotionPackage pk
	Join @Promo pids on pk.PromotionID = pids.PromotionID
	Join SAP.Package p on pk.PackageID = p.PackageID
	Order By PackageName

	----
	Select p.PromotionID, 'S: ' + bu.SystemName Location
	From PlayBook.PromotionGeoRelevancy pgr
	Join @Promo p on pgr.PromotionID = p.PromotionID
	Join BC.System bu on pgr.SystemID = bu.SystemID
	Union
	Select p.PromotionID, 'Z: ' + r.ZoneName Location
	From PlayBook.PromotionGeoRelevancy pgr
	Join @Promo p on pgr.PromotionID = p.PromotionID
	Join BC.Zone r on pgr.ZoneID = r.ZoneID
	Union
	Select p.PromotionID, 'D: ' + a.DivisionName Location
	From PlayBook.PromotionGeoRelevancy pgr
	Join @Promo p on pgr.PromotionID = p.PromotionID
	Join BC.Division a on pgr.DivisionID = a.DivisionID
	Union
	Select p.PromotionID, 'R: ' + b.RegionName Location
	From PlayBook.PromotionGeoRelevancy pgr
	Join @Promo p on pgr.PromotionID = p.PromotionID
	Join BC.Region b on pgr.BCRegionID = b.RegionID
	Union
	Select p.PromotionID, 'B: ' + b.Bottlername Location
	From PlayBook.PromotionGeoRelevancy pgr
	Join @Promo p on pgr.PromotionID = p.PromotionID
	Join BC.Bottler b on pgr.BottlerID = b.BottlerID
	Union
	Select p.PromotionID, 'S: ' + sr.RegionName Location
	From PlayBook.PromotionGeoRelevancy pgr
	Join @Promo p on pgr.PromotionID = p.PromotionID
	Join Shared.StateRegion sr on pgr.StateID = sr.StateRegionID
	Order By Location

	If (@Debug = 1)
	Begin
		Select '---- Promotion ChainGroups and parent chaingroups retrived ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

End

Go



