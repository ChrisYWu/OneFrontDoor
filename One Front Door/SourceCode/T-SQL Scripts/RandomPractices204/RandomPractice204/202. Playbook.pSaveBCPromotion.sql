USE Portal_Data
GO

If Exists (Select * From sys.procedures Where object_id = object_id('Playbook.pSaveBCPromotion'))
	Drop Proc Playbook.pSaveBCPromotion
Go

SET QUOTED_IDENTIFIER ON
GO

/*
-- Hierachy Only, All System
Select *
From PreCal.PromotionBottlerChainGroup
Where PromotionID = 16402

exec Playbook.pSaveBCPromotion @PromotionID = 16402, @Debug = 1

-- Hierachy Only, One Zone
Select *
From PreCal.PromotionBottlerChainGroup
Where PromotionID = 59433

exec Playbook.pSaveBCPromotion @PromotionID = 59433, @Debug = 1

-- Hierachy And State, in this case there is nothing
Select *
From PreCal.PromotionBottlerChainGroup
Where PromotionID = 64363

exec Playbook.pSaveBCPromotion @PromotionID = 64363, @Debug = 1

-- Hierachy And State
Select *
From PreCal.PromotionBottlerChainGroup
Where PromotionID = 56714

exec Playbook.pSaveBCPromotion @PromotionID = 56714, @Debug = 1

-- Hierachy And State, the intersection will filter down relevancy --- 
Select *
From PreCal.PromotionBottlerChainGroup
Where PromotionID = 41652

exec Playbook.pSaveBCPromotion @PromotionID = 41652, @Debug = 1

--- State Only Promotion
Select *
From PreCal.PromotionBottlerChainGroup
Where PromotionID = 64071

exec Playbook.pSaveBCPromotion @PromotionID = 64071, @Debug = 1


Select *
From PlayBook.PromotionGeoRelevancy
Where PromotionID = 16402

Select *
From PlayBook.PromotionGeoRelevancy
Where Coalesce(SystemID, ZoneID, DivisionID, BCRegionID, BottlerID, 0) > 0
And PromotionID in
(
	Select Distinct PromotionID 
	From PlayBook.PromotionGeoRelevancy
	Where Coalesce(StateID, 0) > 0
)
Order By PromotionID DESC

Select *
From PlayBook.PromotionGeoRelevancy
Where Coalesce(SystemID, ZoneID, DivisionID, BCRegionID, BottlerID, 0) = 0
And Coalesce(StateID, 0) > 0
Order By PromotionID desc

--- Speed Test
Declare @StartTime DateTime2(7)
Set @StartTime = SYSDATETIME()

Select '---- Starting ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
exec Playbook.pSaveBCPromotion @PromotionID = 41652
Select '---- Ending ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds


*/

Go
Create Proc Playbook.pSaveBCPromotion
(
	@PromotionID int,
	@Debug bit = 0
)
AS
Begin
	Set NoCount On;

	If (@Debug = 1)
	Begin
		Declare @StartTime DateTime2(7)
		Set @StartTime = SYSDATETIME()

		Select '---- Starting ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
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
	Select SystemID, ZoneID, DivisionID, BCRegionID, BottlerID, StateID
	From Playbook.PromotionGeoRelevancy
	Where PromotionID = @PromotionID
	And Coalesce(SystemID, ZoneID, DivisionID, BCRegionID, BottlerID, StateID, 0) > 0

	If (@Debug = 1)
	Begin
		Select '---- Creating @PGRPromo Table done----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select * From @PGRPromo
	End

	Declare @TotalRelevancyCount int
	Declare @TotalStateCount int

	Select @TotalRelevancyCount = Count(*) From @PGRPromo
	If (@Debug = 1)
	Begin
		Select '---- Filling Logic 1----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds, @TotalRelevancyCount TotalRelevancyCount
	End

	If (@TotalRelevancyCount = 0)
	Begin
		Return
	End

	Select @TotalStateCount = Count(*)
	From @PGRPromo
	Where Coalesce(StateID, 0) > 0

	If (@Debug = 1)
	Begin
		Select '---- Filling Logic 2----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds, @TotalStateCount TotalStateCount
	End

	----- Region driver table -----
	Declare @PGR Table 
	(
		BottlerID int
	)

	--- @TotalRelevancyCount > 0 
	If (@TotalStateCount > 0 And @TotalRelevancyCount = @TotalStateCount)
	Begin
		-- State is the only thing specified
		Insert Into @PGR(BottlerID)
		Select Distinct bs.BottlerID
		From PreCal.BottlerState bs
		Join @PGRPromo p on bs.StateRegionID = p.StateID
		
		If (@Debug = 1)
		Begin
			Select 'State Only Promotion' PromoType
		End

	End
	Else 
	Begin
		-- At least hierachy definition exists		
		Insert Into @PGR(BottlerID)
		Select v.BottlerID
		from @PGRPromo pgr
		Join PreCal.BottlerHier v on pgr.SystemID = v.SystemID
		Union
		Select v.BottlerID
		from @PGRPromo pgr
		Join PreCal.BottlerHier v on pgr.ZoneID = v.ZoneID
		Where Coalesce(pgr.SystemID, 0) = 0
		Union
		Select v.BottlerID
		from @PGRPromo pgr
		Join PreCal.BottlerHier v on pgr.DivisionID = v.DivisionID
		Where Coalesce(pgr.SystemID, pgr.ZoneID, 0) = 0
		Union
		Select v.BottlerID
		from @PGRPromo pgr
		Join PreCal.BottlerHier v on pgr.RegionID = v.RegionID
		Where Coalesce(pgr.SystemID, pgr.ZoneID, pgr.DivisionID, 0) = 0
		Union
		Select BottlerID
		from @PGRPromo pgr
		Where Coalesce(pgr.SystemID, pgr.ZoneID, pgr.DivisionID, pgr.RegionID, 0) = 0
		And ISNull(BottlerID, 0) > 0

		If (@TotalStateCount > 0)
		Begin
			-- State definition exists as well
			Delete From @PGR
			Where BottlerID Not IN
			(	Select Distinct bs.BottlerID 
				From PreCal.BottlerState bs
				Join @PGRPromo p on bs.StateRegionID = p.StateID )
			If (@Debug = 1)
			Begin
				Select 'State And Hierachy Promotion' PromoType
			End
		End
		Else 
		Begin
			If (@Debug = 1)
			Begin
				Select 'Hierachy Promotion' PromoType
			End
		End

	End

	If (@Debug = 1)
	Begin
		Select '---- Expand @PGRPromo done ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select * From @PGR
	End

	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	--Delete From PreCal.PromotionBottlerChainGroup Where PromotionID = @PromotionID
	Declare @PBCG Table
	(
		PromotionID int,
		BottlerID int,
		ChainGroupID Varchar(20)
	)

	Insert Into @PBCG(PromotionID, BottlerID, ChainGroupID)
	Select Distinct @PromotionID, pgh.BottlerID, rci.ChainID ChainGroupID
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
	BC.tBottlerChainTradeMark tmap With (nolock),
	MSTR.RevChainImages rci
	Where ptm.PromotionID = @PromotionID
	And pc.PromotionID = @PromotionID
	And tmap.TerritoryTypeID <> 10
	And tmap.ProductTypeID = 1
	And tmap.TradeMarkID = ptm.TradeMarkID
	And tmap.LocalChainID = pc.LocalChainID
	And tmap.BottlerID = pgh.BottlerID
	And rci.LocalChainID = pc.LocalChainID

	If (@Debug = 1)
	Begin
		Select '---- TM/Chain/Bottler Filtering with referencing to ChainGroup done ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select * From @PBCG
	End

	--- Comitting ---
	Begin Transaction
		Delete From PreCal.PromotionBottlerChainGroup Where PromotionID = @PromotionID

		Insert Into PreCal.PromotionBottlerChainGroup(BottlerID, RegionID, PromotionID, ChainGroupID, PromotionStartDate, PromotionEndDate, IsPromotion)
		Select pgr.BottlerID, s.RegionID, pgr.PromotionID, pgr.ChainGroupID, rp.PromotionStartDate, rp.PromotionEndDate, Case When rp.InformationCategory = 'Promotion' Then 1 Else 0 End IsPromotion
		From @PBCG pgr
		Join Playbook.RetailPromotion rp on pgr.PromotionID = rp.PromotionID
		Join PreCal.BottlerHier s on pgr.BottlerID = s.BottlerID

		Delete From PreCal.PromotionRegionChainGroup Where PromotionID = @PromotionID

		Insert Into PreCal.PromotionRegionChainGroup(PromotionID, RegionID, ChainGroupID, PromotionStartDate, PromotionEndDate, IsPromotion)
		Select Distinct PromotionID, RegionID, ChainGroupID, PromotionStartDate, PromotionEndDate, IsPromotion
		From PreCal.PromotionBottlerChainGroup pb
		Where PromotionID = @PromotionID
	Commit Transaction

	If (@Debug = 1)
	Begin
		Select '---- Comitting done ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select * From PreCal.PromotionBottlerChainGroup Where PromotionID = @PromotionID
		Select * From PreCal.PromotionRegionChainGroup Where PromotionID = @PromotionID
	End

End

Go



