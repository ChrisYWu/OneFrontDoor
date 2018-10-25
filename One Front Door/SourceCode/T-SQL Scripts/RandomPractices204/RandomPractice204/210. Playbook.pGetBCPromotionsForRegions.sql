USE Portal_Data805
GO

If Exists (Select * From sys.procedures Where object_id = object_id('Playbook.pGetBCPromotionsForRegions'))
	Drop Proc Playbook.pGetBCPromotionsForRegions
Go

Set QUOTED_IDENTIFIER ON
GO

/*
exec Playbook.pGetBCPromotionsForRegions @RegionIDs = '9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,80,81,82,83,84,236,237,238,239,240,241,242,243,244,277'
										 ,@Debug = 1
										 ,@StartDate = '2015-1-1'
										 ,@EndDate = '2015-4-1'

declare @regions varchar(max)
set @regions = (select convert(varchar(20),RegionID) + ',' from (Select Distinct RegionID From Processing.tBottlerForSeeking) a for xml path ('')) + '0'
Select @regions

*/
Go
Create Proc Playbook.pGetBCPromotionsForRegions
(
	@RegionIDs nvarchar(4000) = '',
	@Debug bit = 0, 
	@StartDate DateTime = null,
	@EndDate DateTime = null
)
AS
Begin
	Set NoCount On;

	If (@Debug = 1)
	Begin
		Declare @StartTime DateTime2(7)
		Set @StartTime = SYSDATETIME()

		Select '---- Starting ----' Debug, @RegionIDs RegionIDs, @StartDate StartDate, @EndDate EndDate
	End

	--~~~~~~~~~~~~~~~~~~~~~~ Stage 1. Parameters and User target ~~~~~~~~~~~~~~~~~~~~--
	--- If parameter is set to be '', then it'll get converted to be the default value of DateTime '1900-1-1'
	Print 'Processing parameters'
	If (@StartDate = '1900-1-1')
		Set @StartDate = null

	If (@EndDate = '1900-1-1')
		Set @EndDate = null

	If (@StartDate is null)
		Set @StartDate = Convert(Date, GetDate())

	If (@EndDate is null)
		Set @EndDate = DateAdd(year, 1, @StartDate)

	If (@StartDate >= @EndDate)
		Set @EndDate = DateAdd(day, 1, @StartDate)
	---------- Date done -----------
	If (@Debug = 1)
	Begin
		Select '---- Processed Parameters ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
									,@RegionIDs RegionIDs, @StartDate StartDate, @EndDate EndDate
	End

	Select Distinct PromotionID, PromotionStartDate, PromotionEndDate
	Into #PromotionIDs
	From
	Playbook.PromotionRegion pb with (nolock)
	Join dbo.Split(@RegionIDs, ',') brds On pb.RegionID = brds.Value
	Where pb.PromotionStartDate <= @EndDate And pb.PromotionEndDate >= @StartDate

	If (@Debug = 1)
	Begin
		Select '---- PromotionIDs ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

	----
	SELECT rp.PromotionID
		,PromotionName
		,PromotionDescription 'Comment'
		,rp.PromotionStartDate
		,rp.PromotionEndDate
		,rp.promotionstatusid [PromotionStatusID]
		,rp.PromotionCategoryID
		,pc.promotioncategoryname 'Category'
		,rp.InformationCategory
	FROM Playbook.RetailPromotion rp With (nolock)
	Join #PromotionIDs pb with (nolock) on pb.PromotionID = rp.PromotionID 
	Join Playbook.PromotionCategory pc With (nolock) ON rp.promotioncategoryid = pc.promotioncategoryid

	If (@Debug = 1)
	Begin
		Select '---- Promotion Retrived ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

	--- Getting Promo Brands, doesn't unfold unnecessariy
	Select pb.PromotionID, pb.BrandID, b.BrandName, b.TrademarkID, t.TradeMarkName
	Into #PromoBrands
	From Playbook.PromotionBrand pb With (nolock)
	Join #PromotionIDs pids on pb.PromotionID = pids.PromotionID
	Join SAP.Brand  b on pb.BrandID = b.BrandID
	Join SAP.TradeMark t on b.TrademarkID = t.TradeMarkID
	Union 
	Select pb.PromotionID, null, null, pb.TrademarkID, t.TradeMarkName 
	From Playbook.PromotionBrand pb With (nolock)
	Join #PromotionIDs pids on pb.PromotionID = pids.PromotionID
	Join SAP.TradeMark t on pb.TrademarkID = t.TradeMarkID

	Select PromotionID, BrandID, TrademarkID From #PromoBrands
	If (@Debug = 1)
	Begin
		Select '---- Promotion Brand Retrived ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

	Select Distinct BrandID, BrandName, TrademarkID, TradeMarkName
	From #PromoBrands

	If (@Debug = 1)
	Begin
		Select '---- Brand/TM master list Retrived ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

	Select pa.PromotionID, ch.LocalChainID, ch.LocalChainName, ch.RegionalChainID, ch.RegionalChainName, ch.NationalChainID, ch.NationalChainName
	Into #PromoChain
	From PlayBook.PromotionAccount pa
	Join MView.ChainHier ch on pa.LocalChainID = ch.LocalChainID
	Join #PromotionIDs pids on pa.PromotionID = pids.PromotionID
	Union
	Select Distinct pa.PromotionID, null, null, rc.RegionalChainID, rc.RegionalChainName, nc.NationalChainID, nc.NationalChainName
	From PlayBook.PromotionAccount pa
	Join SAP.RegionalChain rc on pa.RegionalChainID = rc.RegionalChainID
	Join SAP.NationalChain nc on rc.NationalChainID = nc.NationalChainID
	Join #PromotionIDs pids on pa.PromotionID = pids.PromotionID
	Union
	Select Distinct pa.PromotionID, null, null, null, null, nc.NationalChainID, nc.NationalChainName
	From PlayBook.PromotionAccount pa
	Join SAP.NationalChain nc on pa.NationalChainID = nc.NationalChainID
	Join #PromotionIDs pids on pa.PromotionID = pids.PromotionID

	Select PromotionID, LocalChainID, RegionalChainID, NationalChainID From #PromoChain
	If (@Debug = 1)
	Begin
		Select '---- Promotion Chains Retrived ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

	Select Distinct LocalChainID, LocalChainName, RegionalChainID, RegionalChainName, NationalChainID, NationalChainName From #PromoChain
	If (@Debug = 1)
	Begin
		Select '---- Promotion Chains MasterList Retrived ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

	Select pids.PromotionID, pk.PackageID, p.PackageName
	Into #PromoPackage
	From Playbook.PromotionPackage pk
	Join #PromotionIDs pids on pk.PromotionID = pids.PromotionID
	Join SAP.Package p on pk.PackageID = p.PackageID

	Select PromotionID, PackageID From #PromoPackage
	If (@Debug = 1)
	Begin
		Select '---- Promotion Package Retrived ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

	Select Distinct PackageID, PackageName From #PromoPackage
	If (@Debug = 1)
	Begin
		Select '---- Promotion Packages MasterList Retrived ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

	--Select Distinct v.BottlerID, BottlerName, v.RegionID, RegionName, DivisionID, DivisionName, ZoneID, ZoneName, SystemID, SystemName
	--From
	--Playbook.PromotionBottler pb with (nolock)
	--Join dbo.Split(@RegionIDs, ',') brds On pb.RegionID = brds.Value
	--Join BC.vBCBottlerHier v on pb.BottlerID = v.BottlerID
	--Where pb.PromotionStartDate <= @EndDate And pb.PromotionEndDate >= @StartDate
	--If (@Debug = 1)
	--Begin
	--	Select '---- Bottler Hierachy MasterList Retrived ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	--End

	Select pb.PromotionID, pb.BottlerID
	From
	Playbook.PromotionBottler pb with (nolock)
	Join dbo.Split(@RegionIDs, ',') brds On pb.RegionID = brds.Value
	Where pb.PromotionStartDate <= @EndDate And pb.PromotionEndDate >= @StartDate
	If (@Debug = 1)
	Begin
		Select '---- Promotion Bottler Relationship Retrived ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End


End

Go

