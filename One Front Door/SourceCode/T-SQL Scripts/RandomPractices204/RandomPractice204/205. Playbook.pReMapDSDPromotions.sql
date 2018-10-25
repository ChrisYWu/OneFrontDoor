use Portal_Data
Go

If Exists (Select * From sys.procedures Where object_id = object_id('PreCal.pReMapDSDPromotions'))
Begin
	Drop Proc PreCal.pReMapDSDPromotions
	Print 'Precal.pReMapDSDPromotions dropped'
End
Go

SET QUOTED_IDENTIFIER ON
GO

/*
Select pgr.PromotionID
From
(Select Distinct PromotionID
From Playbook.PromotionGeoRelevancy
Where isnull(StateID, 0) > 0)  pgr
Join 
(
Select Distinct PromotionID
From Playbook.PromotionChannel
) pc on pgr.PromotionID = pc.PromotionID

-- Testing Parameters
exec PreCal.pReMapDSDPromotions @BackToDate = null, @Debug = 1
exec PreCal.pReMapDSDPromotions @Debug = 1
exec PreCal.pReMapDSDPromotions @BackToDate = '2014-7-1', @Debug = 1

exec PreCal.pReMapDSDPromotions -- Non-Param is the most executed version
Select Count(*) PromotionBranchCnt From Precal.PromotionBranch
Select Count(Distinct PromotionID) PromoCnt From Precal.PromotionBranch
Select Count(Distinct BranchID) BranchCnt From Precal.PromotionBranch
Select Min(PromotionEndDate) MinPromotionEndDate From Precal.PromotionBranch

-- Different Conbinations
----- State Only
Select * From Precal.PromotionBranch Where PromotionID = 59515   -- Expected No record found
Select * From Precal.PromotionBranch Where PromotionID = 41651   -- Goes to 38 Branches, translated from 18 States
Select * From Playbook.PromotionGeoHier Where PromotionID = 41651   -- Used to Go to every branch, cause all BU was there

*/
Create Proc PreCal.pReMapDSDPromotions
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
		BUID int,
		RegionID int, 
		AreaID int,
		BranchID int,
		StateID int,
		HierDefined int,
		StateDefined int,
		TYP int  -- Type of Promotion, 1 Init; 2 State And Hier; 3 HierOnly; 4 StateOnly; 5 AnytingElse; 6 Assume All DSD Promotion For StateOnly
	)

	Insert Into #PromoGeoR
	Select pgr.PromotionID, BUID, RegionID, AreaID, BranchID, StateID, 
		Case When (Coalesce(Case When BUID < 1 Then Null Else BUID End, 
			Case When RegionID < 1 Then Null Else RegionID End, 
			Case When AreaID < 1 Then Null Else AreaID End, 
			Case When BranchID < 1 Then Null Else BranchID End, 0) > 0) Then 1 Else 0 End HierDefined, 
		Case When (Coalesce(StateID, 0) > 0) Then 1 Else 0 End StateDefined,
		1 TYP 
	From Playbook.PromotionGeoRelevancy pgr
	Join Playbook.RetailPromotion rp on pgr.PromotionID = rp.PromotionID
	Where rp.PromotionEndDate > @BackToDate
	And (
		Coalesce(Case When BUID < 1 Then Null Else BUID End, 
			Case When RegionID < 1 Then Null Else RegionID End, 
			Case When AreaID < 1 Then Null Else AreaID End, 
			Case When BranchID < 1 Then Null Else BranchID End, StateID, 0) > 0
	)

	If (@Debug = 1)
	Begin
		Select '---- Creating #PromoGeoR Table done----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select Count(*) NumberOfGeoRelevancy From #PromoGeoR
		Select * From #PromoGeoR Where PromotionID = 8510
	End

	-- 1 Init; 2 State And Hier; 3 HierOnly; 4 StateOnly; 5 AnytingElse; 6 Assume All DSD Promotion For StateOnly
	Update pgr
	Set TYP = Case When t.HierP > 0 And t.StateP > 0 Then 2 When t.HierP > 0 Then 3 When t.StateP > 0 Then 4 Else 5 End
	From #PromoGeoR pgr
	Join (
	Select PromotionID, Sum(HierDefined) HierP, Sum(StateDefined) StateP
	From #PromoGeoR
	Group By PromotionID) t on pgr.PromotionID = t.PromotionID

	-- Note: This is a cross join, for state only promotions, we add all the BUs to them
	Insert Into #PromoGeoR(PromotionID, BUID, TYP)
	Select PromotionID, BUID, 6
	From SAP.BusinessUnit,
	(Select Distinct PromotionID From #PromoGeoR Where TYP = 4) Temp

	-- Now there is no State-Only Promotions, they are converted to be State and Hier Promotions
	Update #PromoGeoR
	Set TYP = 2
	Where TYP in (4,6)

	If (@Debug = 1)
	Begin
		Select '---- Promotion Classification done----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select TYP, Count(*) CountOfPromotions 
		From (Select Distinct PromotionID, TYP From #PromoGeoR) temp
		Group By TYP Order By TYP

		Select * From #PromoGeoR Where PromotionID = 8510
	End

	--- Branch Driver table -----
	Create Table #PGR
	(
		PromotionID int not null,
		BranchID int
	)

	Create Clustered Index IDX_PGR_PromotionID_BranchID ON #PGR(PromotionID, BranchID)

	-- Hier Only
	Insert Into #PGR(PromotionID, BranchID)
	Select Distinct pgr.PromotionID, v.BranchID
	From #PromoGeoR pgr
	Join PreCal.DSDBranch v on pgr.BUID = v.BUID
	Where TYP = 3
	Union
	Select Distinct pgr.PromotionID, v.BranchID
	from #PromoGeoR pgr
	Join PreCal.DSDBranch v on pgr.RegionId = v.RegionId
	Where TYP = 3 And isnull(pgr.BUID, 0) < 1
	Union
	Select Distinct pgr.PromotionID, v.BranchID
	from #PromoGeoR pgr
	Join PreCal.DSDBranch v on pgr.AreaId = v.AreaId
	Where TYP = 3 And isnull(pgr.BUID, 0) < 1 And isnull(pgr.RegionID, 0) < 1
	Union
	Select pgr.PromotionID, pgr.BranchID
	From #PromoGeoR pgr
	Where TYP = 3 And isnull(pgr.BranchID, 0) > 0

	If (@Debug = 1)
	Begin
		Select '---- Type 3(Hier Only) Expanded ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select Count(*) NumberOfPromoBranchesForType3 From #PGR
		Select * From #PGR Where PromotionID = 8510
	End

	-- State & Hier
	Insert Into #PGR(PromotionID, BranchID)
	Select r.PromotionID, r.BranchID
	From (
		Select Distinct pgr.PromotionID, v.BranchID
		From #PromoGeoR pgr
		Join PreCal.DSDBranch v on pgr.BUID = v.BUID
		Where TYP = 2
		Union
		Select Distinct pgr.PromotionID, v.BranchID
		from #PromoGeoR pgr
		Join PreCal.DSDBranch v on pgr.RegionId = v.RegionId
		Where TYP = 2 And isnull(pgr.BUID, 0) < 1
		Union
		Select Distinct pgr.PromotionID, v.BranchID
		from #PromoGeoR pgr
		Join PreCal.DSDBranch v on pgr.AreaId = v.AreaId
		Where TYP = 2 And isnull(pgr.BUID, 0) < 1 And isnull(pgr.RegionId, 0) < 1
		Union
		Select pgr.PromotionID, pgr.BranchID
		From #PromoGeoR pgr
		Where TYP = 2 And isnull(pgr.BranchID, 0) < 1
	) l
	Join (
		Select Distinct PromotionID, h.BranchID
		From #PromoGeoR pgr
		Join PreCal.BranchState h on pgr.StateID = h.StateRegionID
		Where TYP = 2) r On l.PromotionID = r.PromotionID And l.BranchID = r.BranchID
	
	If (@Debug = 1)
	Begin
		Select '---- All Expansions(both type 2 and 3) done ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select Count(*) NumberOfPromoBranchesForType2And3 From #PGR
		Select * From #PGR Where PromotionID = 8510
	End

	---- 
	Declare @PromoChannel Table
	(
		PromotionID int,
		ChannelID int
	)

	Insert @PromoChannel(PromotionID, ChannelID)
	Select PromotionID, ChannelID
	From Playbook.PromotionChannel
	Where isnull(ChannelID, 0) > 0
	Union
	Select Distinct PromotionID, c.ChannelID
	From Playbook.PromotionChannel pc
	Join SAP.Channel c on pc.SuperChannelID = c.SuperChannelID
	Where isnull(pc.SuperChannelID, 0) > 0

	If (@Debug = 1)
	Begin
		Select '---- Channel expansion done ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select Count(*) PromoChannelCount From @PromoChannel
		Select * From @PromoChannel Where PromotionID = 8510
	End
	
	--- Filtering
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	--- First by brand ---
	Select Distinct pgr.*
	Into #PGR1
	From PreCal.BranchBrand bb, -- Branch Brand Association
	(
		Select Distinct PromotionID, b.BrandID
		From Playbook.PromotionBrand pb With (nolock)
		Join SAP.Brand b on (pb.TrademarkID = b.TrademarkID)
		Union
		Select PromotionID, BrandID
		From Playbook.PromotionBrand With (nolock) Where Coalesce(TradeMarkID, 0) = 0 
	) ptm, -- Promotion Brand
	#PGR pgr  --Promotion Geo
	Where pgr.BranchID = bb.BranchID
	And bb.BrandID = ptm.BrandID
	And pgr.PromotionID = ptm.PromotionID
	
	If (@Debug = 1)
	Begin
		Select '---- Promotion filtered by Brands ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select Count(*) NumberOfPromoBranches From #PGR1
		Select * From #PGR1 Where PromotionID = 8510
	End

	--- Then by chain or channel ---
	Select Distinct pgr.*, Case When rp.InformationCategory = 'Promotion' Then 1 Else 0 End IsPromotion
	Into #PGR2
	From 	
	#PGR1 pgr, -- Promotion Geo
	Precal.PromotionLocalChain pc, --- Promotion Chain
	Shared.tLocationChain tlc,  -- This table was created by Jag and used in production reliably
	Playbook.RetailPromotion rp
	Where pgr.BranchID = tlc.BranchID
	And tlc.LocalChainID = pc.LocalChainID
	And pc.PromotionID = pgr.PromotionID
	And rp.PromotionID = pgr.PromotionID
	Union
	Select Distinct pgr.*, Case When rp.InformationCategory = 'Promotion' Then 1 Else 0 End IsPromotion
	From 	
	#PGR1 pgr, -- Promotion Geo
	@PromoChannel pc, --- Promotion Chain
	Precal.BranchChannel tlc,  -- This table was created by Jag and used in production reliably
	Playbook.RetailPromotion rp
	Where pgr.BranchID = tlc.BranchID
	And tlc.ChannelID = pc.ChannelID
	And pc.PromotionID = pgr.PromotionID
	And rp.PromotionID = pgr.PromotionID

	If (@Debug = 1)
	Begin
		Select '---- Promotion further filtered further by Chains ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select * From #PGR2 Where PromotionID = 8510
	End
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	----- Commiting -----
	Begin Transaction

		Truncate Table PreCal.PromotionBranch

		Insert Into PreCal.PromotionBranch(BranchID, PromotionID, PromotionStartDate, PromotionEndDate, IsPromotion, PromotionGroupID)
		Select pgr.BranchID, pgr.PromotionID, rp.PromotionStartDate, rp.PromotionEndDate, IsPromotion, PromotionGroupID
		From #PGR2 pgr
		Join Playbook.RetailPromotion rp on pgr.PromotionID = rp.PromotionID


		Truncate Table PreCal.PromotionBranchChainGroup;

		Insert Into PreCal.PromotionBranchChainGroup(PromotionID, BranchID, PromotionStartDate, PromotionEndDate, IsPromotion, ChainGroupID)
		Select pb.PromotionID, pb.BranchID, pb.PromotionStartDate, pb.PromotionEndDate, pb.IsPromotion, pcg.ChainGroupID
		From PreCal.PromotionBranch pb with (nolock)
		Join PreCal.PromotionChainGroup pcg on pb.PromotionID = pcg.PromotionID
		Join PreCal.BranchChainGroup bcg on bcg.BranchID = pb.BranchID and bcg.ChainGroupID = pcg.ChainGroupID

	Commit Transaction

	If (@Debug = 1)
	Begin
		Select '---- Commiting done. That''s it ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select Count(*) PromotionBranchCnt From Precal.PromotionBranch
		Select Count(Distinct PromotionID) PromoCnt From Precal.PromotionBranch
		Select Count(Distinct BranchID) BranchCnt From Precal.PromotionBranch
		Select Min(PromotionEndDate) MinPromotionEndDate From Precal.PromotionBranch
	End

End

Go
Print 'Precal.pReMapDSDPromotions created'
Go

exec Precal.pReMapDSDPromotions @Debug = 1

