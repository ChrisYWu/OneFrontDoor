USE Portal_Data
GO

If Exists (Select * From sys.procedures Where object_id = object_id('Playbook.pGetPromotionsForLocCgStartDate'))
	Drop Proc Playbook.pGetPromotionsForLocCgStartDate
Go

Set QUOTED_IDENTIFIER ON
GO


/*
-- Deployed to 108 --
Declare @StartTime DateTime2(7)
Set @StartTime = SYSDATETIME()
exec Playbook.pGetPromotionsForLocCgStartDate @Debug =1, @RegionIDs = 8, @Date = '2015-1-1', @ChainGroups = 'N00055,L00324,L03072,L03076,L02452,N00042,R00161,R00278,R00169,R00126,R00127,R00123,N00066,N00050,R00148,R00144,N00012,R00021,R00017,R00020,N00021,N00121,N00036,R00092,R00106,R00103,N00085'
Select replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds

exec Playbook.pGetPromotionsForLocCgStartDate @RegionIDs = 8, @Date = '2015-1-1', @ChainGroups = 'N00055,L00324,L03072,L03076,L02452,N00042,R00161,R00278,R00169,R00126,R00127,R00123,N00066,N00050,R00148,R00144,N00012,R00021,R00017,R00020,N00021,N00121,N00036,R00092,R00106,R00103,N00085'


*/

Create Proc Playbook.pGetPromotionsForLocCgStartDate
(
	@BUIDs nvarchar(4000) = '',
	@RegionIDs nvarchar(4000) = '',
	@AreaIDs nvarchar(4000) = '',
	@BranchIDs nvarchar(4000) = '',
	@ChainGroups nvarchar(4000) = '',
	@Debug bit = 0, 
	@Date DateTime = null
)
AS
Begin
	/*  Rivision History
	2015-11-03 First Version; Developed on 108


	*/

	Set NoCount On;

	Declare @StartDate DateTime, @EndDate DateTime

	If (@Debug = 1)
	Begin
		Declare @StartTime DateTime2(7)
		Set @StartTime = SYSDATETIME()

		Select '---- Starting ----' Debug, @BUIDs BUIDs, @RegionIDs RegionIDs, @AreaIDs AreaIDs, @BranchIDs BranchIDs, @ChainGroups ChainGroups, @Date StartDate
	End

	--~~~~~~~~~~~~~~~~~~~~~~ Stage 1. Parameters and User target ~~~~~~~~~~~~~~~~~~~~--
	Declare @BranchIDsTable Table
	(
		BranchID int,
		Primary Key (BranchID ASC)
	)

	Insert Into @BranchIDsTable
	Select Distinct BranchID
	From PreCal.DSDBranch h 
	Join dbo.Split(@BUIDs, ',') s on h.BUID = s.Value
	Union
	Select Distinct BranchID
	From PreCal.DSDBranch h 
	Join dbo.Split(@RegionIDs, ',') s on h.RegionID = s.Value
	Union
	Select Distinct BranchID
	From PreCal.DSDBranch h 
	Join dbo.Split(@AreaIDs, ',') s on h.AreaID = s.Value
	Union
	Select Value
	From dbo.Split(@BranchIDs, ',')
	Where Value <>''

	Declare @BranchCount int
	Set @BranchCount = 0
	Select @BranchCount = count(*) From @BranchIDsTable

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

		If (@BranchCount > 0)
		Begin
			Select @BIDS = @BIDS + Convert(Varchar, BranchID) + ','
			From @BranchIDsTable
			Set @BIDS = SUBSTRING(@BIDS, 0, Len(@BIDS) - 1)
		End

		Select '---- Processed Parameters ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
			,@BIDS EffectiveBranchIDs, @StartDate StartDate, @EndDate EndDate

	End

	--~~~~~~~~~~~~~~~~~~~~~~ Stage 2. The query ~~~~~~~~~~~~~~~~~~~~--
	Declare @Promo Table 
	(
		PromotionID int,
		ChainGroupID varchar(20),
		Primary Key(PromotionID ASC, ChainGroupID ASC)
	)

	Insert Into @Promo
	Select Distinct pb.PromotionID, ChainGroupID
	From
	PreCal.PromotionBranchChainGroup pb with (nolock)
	Join @BranchIDsTable brds On pb.BranchID = brds.BranchID
	Join dbo.Split(@ChainGroups, ',') cg On cg.Value = pb.ChainGroupID
	Where pb.PromotionStartDate <= @EndDate And pb.PromotionEndDate > @StartDate -- @EndDate is inclusive, See promotion 34605 for details, 1-1 is not valid for that one
	And pb.IsPromotion = 1

	If (@Debug = 1)
	Begin
		Select '---- Promotions With ChainGroup associated filtered by locations ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
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
	Select p.PromotionID, 'BU: ' + bu.BUName Location
	From PlayBook.PromotionGeoRelevancy pgr
	Join @Promo p on pgr.PromotionID = p.PromotionID
	Join SAP.BUsinessUnit bu on pgr.BUID = bu.BUID
	Union
	Select p.PromotionID, 'R: ' + r.RegionName Location
	From PlayBook.PromotionGeoRelevancy pgr
	Join @Promo p on pgr.PromotionID = p.PromotionID
	Join SAP.Region r on pgr.RegionID = r.RegionID
	Union
	Select p.PromotionID, 'A: ' + a.AreaName Location
	From PlayBook.PromotionGeoRelevancy pgr
	Join @Promo p on pgr.PromotionID = p.PromotionID
	Join SAP.Area a on pgr.AreaID = a.AreaID
	Union
	Select p.PromotionID, 'Br: ' + b.BranchName Location
	From PlayBook.PromotionGeoRelevancy pgr
	Join @Promo p on pgr.PromotionID = p.PromotionID
	Join SAP.Branch b on pgr.BranchID = b.BranchID
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



