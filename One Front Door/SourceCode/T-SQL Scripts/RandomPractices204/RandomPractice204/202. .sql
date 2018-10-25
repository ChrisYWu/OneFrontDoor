USE Portal_Data805
GO

If Exists (Select * From sys.procedures Where object_id = object_id('Playbook.pSaveBCPromotion'))
	Drop Proc Playbook.pSaveBCPromotion
Go

SET QUOTED_IDENTIFIER ON
GO

/*
exec Playbook.pSaveBCPromotion @PromotionID = 16402, @Debug = 1
exec Playbook.pSaveBCPromotion @PromotionID = 59433, @Debug = 1

16402
16407
16406
23994
57376
59569
59433

	Select *
	From Playbook.PromotionGeoRelevancy
	Where Coalesce(SystemID, ZoneID, DivisionID, RegionID, 0) > 0
	And Coalesce(StateID, 0) > 0

Select * From Playbook.PromotionRegion

Select *
From Playbook.PromotionGeoRelevancy
Where PromotionID = 59433

*/

Create Proc Playbook.pSaveBCPromotion
(
	@PromotionID int,
	@Debug bit = 0
)
AS
Begin
	Set NoCount On;

	Declare @StartTime DateTime2(7)
	Set @StartTime = SYSDATETIME()

	If (@Debug = 1)
	Begin
		Select '---- Starting ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End
	
	--- Extended Bttler table, that has state id ---
	Declare @Bottlers Table
	(
		SystemID int, 
		ZoneID int, 
		DivisionID int, 
		RegionID int, 
		BottlerID int, 
		StateRegionID int
	)

	Insert Into @Bottlers
	Select v.SystemID, v.ZoneID, v.DivisionID, v.RegionID, b.BottlerID, sr.StateRegionID
	From BC.vSalesHierarchy v
	Join BC.Bottler b on b.BCRegionID = v.RegionID
	Join Shared.StateRegion sr on b.State = sr.RegionABRV
	Where SystemID in (5, 6,7)

	If (@Debug = 1)
	Begin
		Select '---- Creating Bottler Table done----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

	--- Extended Bttler table, that has state id ---
	Declare @Regions Table
	(
		SystemID int, 
		ZoneID int, 
		DivisionID int, 
		RegionID int
	)

	Insert Into @Regions
	Select v.SystemID, v.ZoneID, v.DivisionID, v.RegionID
	From BC.vBCSalesHier v
	Where SystemID in (5, 6,7)

	If (@Debug = 1)
	Begin
		Select '---- Creating @Regions Table done----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

	Declare @PGRPromo Table
	(
		SystemID int, 
		ZoneID int, 
		DivisionID int, 
		RegionID int,
		BottlerID int,
		StateID int
	)

	Insert Into @PGRPromo
	Select SystemID, ZoneID, DivisionID, RegionID, BottlerID, StateID
	From Playbook.PromotionGeoRelevancy
	Where PromotionID = @PromotionID

	If (@Debug = 1)
	Begin
		Select '---- Creating @PGRPromo Table done----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End
	
	----- Region driver table -----
	Declare @PGR Table 
	(
		RegionID int
	)

	---------------
	Insert Into @PGR(RegionID)
	Select Distinct v.RegionID
	from @PGRPromo pgr
	Join @Regions v on pgr.SystemID = v.SystemID
	Union
	Select Distinct v.RegionID
	from @PGRPromo pgr
	Join @Regions v on pgr.ZoneID = v.ZoneID
	Where  pgr.SystemID is null
	Union
	Select Distinct v.RegionID
	from @PGRPromo pgr
	Join @Regions v on pgr.DivisionID = v.DivisionID
	Where pgr.ZoneID is null And pgr.SystemID is null
	Union
	Select Distinct v.RegionID
	from @PGRPromo pgr
	Join @Regions v on pgr.RegionID = v.RegionID
	Where pgr.ZoneID is null And pgr.SystemID is null And pgr.DivisionID is null
	Union
	Select Distinct v.RegionID
	from @PGRPromo pgr
	Join @Bottlers v on pgr.BottlerID = v.BottlerID
	Where pgr.ZoneID is null And pgr.SystemID is null And pgr.DivisionID is null and pgr.RegionID is null
	Union
	Select Distinct b.RegionID
	from @PGRPromo pgr
	Join @Bottlers b on pgr.StateID = b.StateRegionID

	If (@Debug = 1)
	Begin
		Select '---- Expand @PGRPromo done ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	Delete From [Playbook].[PromotionRegion] Where PromotionID = @PromotionID

	Insert Into [Playbook].[PromotionRegion] (RegionID, PromotionID)
	Select Distinct pgh.RegionID, @PromotionID
	From 
	@PGR pgh,
	(
		Select PromotionID, b.TrademarkID
		From Playbook.PromotionBrand pb With (nolock)
		Join SAP.Brand b on (pb.BrandID = b.BrandID)
		Union
		Select PromotionID, TrademarkID
		From Playbook.PromotionBrand With (nolock)) ptm,
	(
		Select PromotionID, LocalChainID
		From Playbook.PromotionAccount With (nolock) Where Coalesce(LocalChainID, 0) > 0
		Union
		Select PromotionID, lc.LocalChainID
		From Playbook.PromotionAccount pa With (nolock)
		Join SAP.LocalChain lc on(pa.RegionalChainID = lc.RegionalChainID) Where Coalesce(pa.RegionalChainID, 0) > 0
		Union
		Select PromotionID, lc.LocalChainID
		From Playbook.PromotionAccount pa With (nolock)
		Join SAP.RegionalChain rc on pa.NationalChainID = rc.NationalChainID
		Join SAP.LocalChain lc on rc.RegionalChainID = lc.RegionalChainID Where Coalesce(pa.NationalChainID, 0) > 0
	) pc,
	BC.tRegionChainTradeMark tmap With (nolock)
	Where ptm.PromotionID = @PromotionID
	And pc.PromotionID = @PromotionID
	And tmap.TerritoryTypeID <> 10
	And tmap.ProductTypeID = 1
	And tmap.TradeMarkID = ptm.TradeMarkID
	And tmap.LocalChainID = pc.LocalChainID
	And tmap.RegionID = pgh.RegionID

	If (@Debug = 1)
	Begin
		Select '---- TM/Chain/Region Filtering done ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End


End

Go

