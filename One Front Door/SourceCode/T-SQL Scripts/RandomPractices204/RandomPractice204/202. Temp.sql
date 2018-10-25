USE Portal_Data
GO

---##################
If Exists (Select * From sys.procedures Where object_id = object_id('PreCal.pReMapBCPromotions1'))
	Drop Proc PreCal.pReMapBCPromotions1
Go

SET QUOTED_IDENTIFIER ON
GO

/*
41652

exec PreCal.pReMapBCPromotions1 @BackToDate = null, @Debug = 1

exec PreCal.pReMapBCPromotions1 @Debug = 1

-- Different Conbinations
----- State Only
Select * From PreCal.PromotionBottler Where PromotionID = 59515   -- Goes to 10 Bottlers, instead of all 63 in RI, CT and MA

*/
Go
Create Proc PreCal.pReMapBCPromotions1
(
	@BackToDate Date = null,
	@Debug bit = 0
)
AS
Begin
	Set NoCount On;

	If (@BackToDate is null)
	Begin
		Set @BackToDate = DateAdd(Year, -100, GetDate())
	End

	If (@Debug = 1)
	Begin
		Declare @StartTime DateTime2(7)
		Set @StartTime = SYSDATETIME()

		Select '---- Starting ----' Debug, @BackToDate BackToDate
	End

	--- GeoRelevancy Expansion with Date Cut
	Create Table #PromoGeoR
	(
		PromotionID int,
		SystemID int, 
		ZoneID int, 
		DivisionID int, 
		RegionID int, 
		BottlerID int, 
		StateID int, 
		HierDefined int,   --- Hierachy Defined 
		StateDefined int,  --- StateDefined
		TYP int			   --- State Transalation Status
	)

	Insert Into #PromoGeoR
	Select pgr.PromotionID, SystemID, ZoneID, DivisionID, BCRegionID, BottlerID, StateID, 
		Case When (Coalesce(SystemID, ZoneID, DivisionID, BCRegionID, BottlerID, 0) > 0) Then 1 Else 0 End HierDefined, 
		Case When (Coalesce(StateID, 0) > 0) Then 1 Else 0 End StateDefined,
		1 TYP 
	From Playbook.PromotionGeoRelevancy pgr
	Join Playbook.RetailPromotion rp on pgr.PromotionID = rp.PromotionID
	Where rp.PromotionEndDate > @BackToDate
	And (
		Coalesce(SystemID, ZoneID, DivisionID, BCRegionID, BottlerID, StateID, 0) > 0
	)
	And pgr.PromotionID = 41652

	If (@Debug = 1)
	Begin
		Select '---- Creating #PromoGeoR Table done----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select * From #PromoGeoR Where PromotionID = 41652
	End

	-- 1 Init; 2 State And Hier; 3 HierOnly; 4 StateOnly; 5 AnytingElse; 6 Assume All BC Promotion For StateOnly
	Update pgr
	Set TYP = Case When t.HierP > 0 And t.StateP > 0 Then 2 
				   When t.HierP > 0 Then 3 
				   When t.StateP > 0 Then 4 
				   Else 5 End
	From #PromoGeoR pgr
	Join (
	Select PromotionID, Sum(HierDefined) HierP, Sum(StateDefined) StateP
	From #PromoGeoR
	Group By PromotionID) t on pgr.PromotionID = t.PromotionID

	Insert Into #PromoGeoR(PromotionID, SystemID, TYP)
	Select PromotionID, SystemID, 6
	From (Select Distinct SystemID From PreCal.BottlerHier) a,
	(Select Distinct PromotionID From #PromoGeoR Where TYP = 4) Temp

	Update #PromoGeoR
	Set TYP = 2
	Where TYP in (4,6)

	If (@Debug = 1)
	Begin
		Select '---- Promotion Classification done----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		--- Only Valid Type for State is 2 and 3
		Select *
		From #PromoGeoR Where PromotionID = 41652
	End

	--->>>> This is where I stopped ----
	----- BTTLR driver table -----
	Create Table #PGR
	(
		PromotionID int not null,
		BottlerID int  not null
	)

	Create Clustered Index IDX_PGRforBC_PromotionID_BottlerID ON #PGR(PromotionID, BottlerID)

	-- Geo Hier Expansion
	Insert Into #PGR(PromotionID, BottlerID)
	Select Distinct pgr.PromotionID, v.BottlerID
	From #PromoGeoR pgr
	Join PreCal.BottlerHier v on pgr.SystemID = v.SystemID
	Where TYP = 3
	Union
	Select Distinct pgr.PromotionID, v.BottlerID
	from #PromoGeoR pgr
	Join PreCal.BottlerHier v on pgr.ZoneID = v.ZoneID
	Where TYP = 3 And pgr.SystemID is null
	Union
	Select Distinct pgr.PromotionID, v.BottlerID
	from #PromoGeoR pgr
	Join PreCal.BottlerHier v on pgr.DivisionID = v.DivisionID
	Where TYP = 3 And pgr.SystemID is null And pgr.ZoneID is null
	Union
	Select Distinct pgr.PromotionID, v.BottlerID
	From #PromoGeoR pgr
	Join PreCal.BottlerHier v on pgr.RegionID = v.RegionID
	Where TYP = 3 And pgr.SystemID is null And pgr.ZoneID is null and pgr.DivisionID is null
	Union
	Select Distinct pgr.PromotionID, pgr.BottlerID
	From #PromoGeoR pgr
	Where TYP = 3 And pgr.BottlerID is not null

	If (@Debug = 1)
	Begin
		Select '---- Type 2 Expanded ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select * From #PGR Where PromotionID = 41652
	End

	-- State & Hier
	Insert Into #PGR(PromotionID, BottlerID)
	Select r.PromotionID, r.BottlerID
	From (
		Select Distinct pgr.PromotionID, v.BottlerID
		From #PromoGeoR pgr
		Join PreCal.BottlerHier v on pgr.SystemID = v.SystemID
		Where TYP = 2
		Union
		Select Distinct pgr.PromotionID, v.BottlerID
		from #PromoGeoR pgr
		Join PreCal.BottlerHier v on pgr.ZoneID = v.ZoneID
		Where TYP = 2 And Coalesce(pgr.SystemID, -1) = -1
		Union
		Select Distinct pgr.PromotionID, v.BottlerID
		from #PromoGeoR pgr
		Join PreCal.BottlerHier v on pgr.DivisionID = v.DivisionID
		Where TYP = 2 And Coalesce(pgr.SystemID, pgr.ZoneID, -1) = -1
		Union
		Select Distinct pgr.PromotionID, v.BottlerID
		From #PromoGeoR pgr
		Join PreCal.BottlerHier v on pgr.RegionID = v.RegionID
		Where TYP = 2 And Coalesce(pgr.SystemID, pgr.ZoneID, pgr.DivisionID, -1) = -1
		Union
		Select Distinct pgr.PromotionID, pgr.BottlerID
		From #PromoGeoR pgr
		Where TYP = 2 And Coalesce(pgr.BottlerID, -1) = -1
	) l
	Join (
		Select Distinct PromotionID, h.BottlerID
		From #PromoGeoR pgr
		Join PreCal.BottlerState h on pgr.StateID = h.StateRegionID
		Where TYP = 2) r On l.PromotionID = r.PromotionID And l.BottlerID = r.BottlerID
	
	If (@Debug = 1)
	Begin
		Select '---- All expansion(2 and 3) done ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select * From #PGR Where PromotionID = 41652
	End

	--- Filtering
	--~~~~~~~~~~~~ Stage 3. Bottler Chain Trademark territoties correlation ~~~~~~~~--
	Select Distinct pgh.PromotionID, pgh.BottlerID, rci.ChainID ChainGroupID
	Into #ReducedPGR
	From 
	#PGR pgh,
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
	Where ptm.PromotionID = pgh.PromotionID
	And pc.PromotionID = pgh.PromotionID
	And tmap.TerritoryTypeID <> 10
	And tmap.ProductTypeID = 1
	And tmap.TradeMarkID = ptm.TradeMarkID
	And tmap.LocalChainID = pc.LocalChainID
	And tmap.BottlerID = pgh.BottlerID
	And pc.LocalChainID = rci.LocalChainID

	If (@Debug = 1)
	Begin
		Select '---- Promo~Bottler relations after terrirory reduction ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select * From #ReducedPGR Where PromotionID = 41652
	End

	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	----- Commiting -----
	--Truncate Table PreCal.PromotionBottlerChainGroup

	--Insert Into PreCal.PromotionBottlerChainGroup(BottlerID, RegionID, PromotionID, ChainGroupID, PromotionStartDate, PromotionEndDate, IsPromotion)
	--Select pgr.BottlerID, s.RegionID, pgr.PromotionID, pgr.ChainGroupID, rp.PromotionStartDate, rp.PromotionEndDate, Case When rp.InformationCategory = 'Promotion' Then 1 Else 0 End IsPromotion
	--From #ReducedPGR pgr
	--Join Playbook.RetailPromotion rp on pgr.PromotionID = rp.PromotionID
	--Join PreCal.BottlerHier s on pgr.BottlerID = s.BottlerID

	--Truncate Table PreCal.PromotionRegionChainGroup

	--Insert Into PreCal.PromotionRegionChainGroup(PromotionID, RegionID, ChainGroupID, PromotionStartDate, PromotionEndDate, IsPromotion)
	--Select Distinct PromotionID, RegionID, ChainGroupID, PromotionStartDate, PromotionEndDate, IsPromotion
	--From PreCal.PromotionBottlerChainGroup pb

	If (@Debug = 1)
	Begin
		Select '---- Commiting done. That''s it ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select pgr.BottlerID, s.RegionID, pgr.PromotionID, pgr.ChainGroupID, rp.PromotionStartDate, rp.PromotionEndDate, Case When rp.InformationCategory = 'Promotion' Then 1 Else 0 End IsPromotion
		From #ReducedPGR pgr
		Join Playbook.RetailPromotion rp on pgr.PromotionID = rp.PromotionID
		Join PreCal.BottlerHier s on pgr.BottlerID = s.BottlerID
	End

End

Go


If Exists (Select * From sys.procedures Where object_id = object_id('Playbook.pSaveBCPromotion'))
	Drop Proc Playbook.pSaveBCPromotion
Go

SET QUOTED_IDENTIFIER ON
GO