USE Portal_Data_INT
GO

--exec PreCal.pRefreshLookups
--exec PreCal.pRemapDSDPromotions
--Go

--Select *
--From PreCal.PromotionBranch
--Where PromotionID = 8510

/*
1. Deployed to 108 on 2015-10-26
2. Changes made on Coalesce and deployed to 108 2015-10-27

*/

--------------------------------
If Exists (Select * From sys.procedures Where object_id = object_id('Precal.pRefreshLookups'))
Begin
	Drop Proc Precal.pRefreshLookups
	Print '<-- Precal.pRefreshLookups dropped'
End
Go

Create Proc Precal.pRefreshLookups
As
Begin
	Set NoCount On

	-----
	Truncate Table PreCal.BottlerHier

	Insert Into PreCal.BottlerHier(SystemID, ZoneID, DivisionID, RegionID, BottlerID)
	Select v.SystemID, v.ZoneID, v.DivisionID, v.RegionID, b.BottlerID
	From BC.vSalesHierarchy v
	Join BC.Bottler b on b.BCRegionID = v.RegionID
	Where SystemID in (5, 6,7)

	-----
	Truncate Table PreCal.BottlerState

	Insert Into PreCal.BottlerState(BottlerID, StateRegionID)
	Select Distinct tmap.BottlerID, c.StateRegionID
	From BC.BottlerAccountTradeMark tmap
	Join SAP.Account a on a.AccountID = tmap.AccountID
	Join Shared.County c on a.CountyID = c.CountyID
	Where tmap.TerritoryTypeID <> 10
	And tmap.ProductTypeID = 1
	And a.CRMActive = 1

	-----
	Truncate Table PreCal.BranchState

	Insert Into PreCal.BranchState(BranchID, StateRegionID)
	Select a.BranchID, c.StateRegionID
	From SAP.Account a
	Join Shared.StateRegion c on a.State = c.RegionABRV
	Where a.Active = 1 --- This is DSD Active Flag
	Group By a.BranchID, c.StateRegionID
	Having Count(*) > 4   --- Threshhold for the bad data, 5 or more account to represent the state for any branch

	-----
	Truncate Table PreCal.DSDBranch

	Insert Into PreCal.DSDBranch(BUID, RegionID, AreaID, BranchID)
	Select BUID, RegionID, AreaID, BranchID
	From Mview.LocationHier

	-----
	Truncate Table PreCal.BranchBrand

	Insert Into PreCal.BranchBrand(BUID, b.RegionID, b.AreaID, b.BranchID, BrandID)
	Select Distinct b.BUID, b.RegionID, b.AreaID, bm.BranchID, m.BrandID
	From SAP.BranchMaterial bm
	Join SAP.Material m on bm.MaterialID = m.MaterialID
	Join PreCal.DSDBranch b on bm.BranchID = b.BranchID

	-----
	Truncate Table PreCal.BranchChannel

	Insert Into PreCal.BranchChannel(BranchID, ChannelID)
	Select Distinct BranchID, ChannelID
	From SAP.Account a
	Where BranchID is not null
	And ChannelID is not null
	And Active = 1

	-----
	Truncate Table PreCal.ChainHier

	Insert Into PreCal.ChainHier(NationalChainID, NationalChainName, RegionalChainID, RegionalChainName, LocalChainID, LocalChainName)
	Select NationalChainID, NationalChainName, RegionalChainID, RegionalChainName, LocalChainID, LocalChainName
	From MView.ChainHier v

	-----
	Truncate Table Precal.PromotionLocalChain

	Insert Into Precal.PromotionLocalChain(PromotionID, LocalChainID, PromotionStartDate, PromotionEndDate, IsPromotion)
	Select p.PromotionID, LocalChainID, rp.PromotionStartDate, rp.PromotionEndDate, Case When rp.InformationCategory = 'Promotion' Then 1 Else 0 End
	From Playbook.PromotionAccount p With (nolock)
	Join Playbook.RetailPromotion rp on p.PromotionID = rp.PromotionID
	Where Coalesce(LocalChainID, 0) > 0
	Union
	Select pa.PromotionID, lc.LocalChainID, PromotionStartDate, PromotionEndDate, Case When InformationCategory = 'Promotion' Then 1 Else 0 End
	From Playbook.PromotionAccount pa With (nolock)
	Join SAP.LocalChain lc on(pa.RegionalChainID = lc.RegionalChainID) 
	Join Playbook.RetailPromotion rp on pa.PromotionID = rp.PromotionID
	Where Coalesce(pa.RegionalChainID, 0) > 0
	Union
	Select pa.PromotionID, rc.LocalChainID, PromotionStartDate, PromotionEndDate, Case When InformationCategory = 'Promotion' Then 1 Else 0 End
	From Playbook.PromotionAccount pa With (nolock)
	Join PreCal.ChainHier rc on pa.NationalChainID = rc.NationalChainID
	Join Playbook.RetailPromotion rp on pa.PromotionID = rp.PromotionID
	And Coalesce(pa.NationalChainID, 0) > 0

	-----
	Merge Playbook.ChainGroup cg
	Using (
		Select ChainID, Count(*) Cnt, Min(Chain) Chain, Min(ImageName) ImageName
		From (
			Select Distinct ChainID, Chain, ImageName
			From [MSTR].[RevChainImages]) temp
		Group by ChainID) input
		On input.ChainID = cg.ChainGroupID
	When Not Matched By Target Then
		Insert (ChainGroupID, ChainGroupName, ImageName, WebImageURL, MobileImageURL, Active, CreatedDate, CreateBy, ModifiedDate, ModifiedBy)
		Values (input.ChainID, input.Chain, input.ImageName, 
		'https://dpsg.cloud.microstrategy.com/MicroStrategy/images/DPSG/Amplify%20MyScores/' + ImageName,
		'https://dpsg.cloud.microstrategy.com/MicroStrategy/images/DPSG/Amplify%20MyScores/Mobile/' + ImageName,
		1, GetDate(), 'System', GetDate(), 'System')
	When Not Matched By Source And (ChainGroupID <> 'U00000') Then
		Update
		Set Active = 0, ModifiedDate = GetDate(), ModifiedBy = 'System'
	When Matched And (Active = 0 Or cg.ChainGroupName <> input.Chain Or cg.ImageName <> input.ImageName) Then
		Update
		Set Active = 1, ModifiedDate = GetDate(), ModifiedBy = 'System',
		ChainGroupName = input.Chain,
		ImageName = input.ImageName,
		WebImageURL = 'https://dpsg.cloud.microstrategy.com/MicroStrategy/images/DPSG/Amplify%20MyScores/' + input.ImageName,
		MobileImageURL = 'https://dpsg.cloud.microstrategy.com/MicroStrategy/images/DPSG/Amplify%20MyScores/Mobile/' + input.ImageName;

	Update Playbook.ChainGroup
	Set IsAllOther = 0, CoveredByNational = 0, TrueRegional = 0;

	Update cg
	Set IsAllOther = Case When s.NationalChainID = 62 And s.RegionalChainID = 242 Then 1 Else 0 End,
		TrueRegional = Case When s.NationalChainID = 62 And s.RegionalChainID <> 242 Then 1 Else 0 End,
		CoveredByNational = Case When s.NationalChainID <> 62 Then 1 Else 0 End
	From Playbook.ChainGroup cg
	Join (Select Distinct LocalChainID, ChainID ChainGroupID From MSTR.RevChainImages Where ChainID like 'L%') l on cg.ChainGroupID = l.ChainGroupID
	Join PreCal.ChainHier s on l.LocalChainID = s.LocalChainID;

	Update cg
	Set 
		TrueRegional = Case When s.NationalChainID = 62 Then 1 Else 0 End,
		CoveredByNational = Case When s.NationalChainID <> 62 Then 1 Else 0 End
	From Playbook.ChainGroup cg
	Join (Select Distinct RegionalChainID, ChainID ChainGroupID From MSTR.RevChainImages Where ChainID like 'R%') l on cg.ChainGroupID = l.ChainGroupID
	Join SAP.RegionalChain s on l.RegionalChainID = s.RegionalChainID;

	Update cg
	Set CoveredByNational = 1
	From Playbook.ChainGroup cg
	Join (Select Distinct NationalChainID, ChainID ChainGroupID From MSTR.RevChainImages Where ChainID like 'N%') l on cg.ChainGroupID = l.ChainGroupID;

	--- Expect to See nothing ----
	--Select 'Expect to See nothing'
	--Select ChainGroupID, Sum(Convert(int, TrueRegional) + Convert(int, IsAllOther) + Convert(int, CoveredByNational))
	--From Playbook.ChainGroup cg
	--Group By ChainGroupID
	--Having Sum(Convert(int, TrueRegional) + Convert(int, IsAllOther) + Convert(int, CoveredByNational)) <> 1

	-----
	Truncate Table PreCal.BranchChainGroup

	Insert Into PreCal.BranchChainGroup(BranchID, ChainGroupID)
	Select Distinct a.BranchID, rci.ChainID
	From SAP.Account a,
	MSTR.RevChainImages rci
	Where a.BranchID is not null
	And a.LocalChainID = rci.LocalChainID
	Union
	Select Distinct a.BranchID, b.ChainID
	From
	(
		Select Distinct a.BranchID, ch.RegionalChainID
		From SAP.Account a,
		PreCal.ChainHier ch
		Where a.BranchID is not null
		And a.LocalChainID = ch.LocalChainID
	) a,
	(
		Select Distinct RegionalChainID, ChainID, Chain
		From MSTR.RevChainImages
		Where ChainID Like 'R%'
	) b
	Where a.RegionalChainID = b.RegionalChainID
	Union
	Select Distinct a.BranchID, b.ChainID
	From
	(
		Select Distinct a.BranchID, ch.NationalChainID
		From SAP.Account a,
		PreCal.ChainHier ch
		Where a.BranchID is not null
		And a.LocalChainID = ch.LocalChainID
	) a,
	(
		Select Distinct NationalChainID, ChainID, Chain
		From MSTR.RevChainImages
		Where ChainID Like 'N%'
	) b
	Where a.NationalChainID = b.NationalChainID

	-----
	Truncate Table PreCal.PromotionChainGroup;

	With PromotionRegionalChain As
	(
		Select pa.PromotionID, pa.RegionalChainID
		From Playbook.PromotionAccount pa With (nolock)
		Where Coalesce(pa.RegionalChainID, 0) > 0
		Union
		Select Distinct pa.PromotionID, rc.RegionalChainID
		From Playbook.PromotionAccount pa With (nolock)
		Join PreCal.ChainHier rc on pa.NationalChainID = rc.NationalChainID
		Join Playbook.RetailPromotion rp on pa.PromotionID = rp.PromotionID
		And Coalesce(pa.NationalChainID, 0) > 0
	)

	Insert PreCal.PromotionChainGroup(PromotionID, ChainGroupID)
	Select Distinct PromotionID, ChainID
	From PreCal.PromotionLocalChain plc
	Join MSTR.RevChainImages rci on (plc.LocalChainID = rci.LocalChainID)
	Union
	Select Distinct PromotionID, ChainID
	From PromotionRegionalChain plc
	Join MSTR.RevChainImages rci on (plc.RegionalChainID = rci.RegionalChainID And rci.ChainID Like 'R%')
	Union
	Select Distinct PromotionID, ChainID
	From PlayBook.PromotionAccount pa
	Join PreCal.ChainHier ch on pa.LocalChainID = ch.LocalChainID
	Join MSTR.RevChainImages rci on (ch.NationalChainID = rci.NationalChainID And rci.ChainID Like 'N%');

	---
	Truncate Table PreCal.RegionTMLocalChain;

	Insert PreCal.RegionTMLocalChain(RegionID, TradeMarkID, LocalChainID)
	Select Distinct RegionID, TradeMarkID, LocalChainID
	From BC.tRegionChainTradeMark tmap
	Where tmap.TerritoryTypeID <> 10
	And tmap.ProductTypeID = 1;

	---
End

Go
Print '--> Precal.pRefreshLookups created'
Go

---#################
If Exists (Select * From sys.procedures Where object_id = object_id('PreCal.pReMapDSDPromotions'))
	Drop Proc PreCal.pReMapDSDPromotions
	Print '<-- Precal.pReMapDSDPromotions dropped'
Go

SET QUOTED_IDENTIFIER ON
GO

/*
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
		Where TYP = 2 And isnull(pgr.BranchID, 0) > 0
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
		Select Count(*) NumberOfPromoBranches From #PGR2
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
Print '--> Precal.pReMapDSDPromotions created'
Go

---##################
If Exists (Select * From sys.procedures Where object_id = object_id('PreCal.pReMapBCPromotions'))
Begin
	Drop Proc PreCal.pReMapBCPromotions
	Print '<-- Precal.pReMapBCPromotions dropped'
End
Go

SET QUOTED_IDENTIFIER ON
GO

/*
exec PreCal.pReMapBCPromotions @BackToDate = null, @Debug = 1

exec PreCal.pReMapBCPromotions @Debug = 1

-- Different Conbinations
----- State Only
Select * From PreCal.PromotionBottler Where PromotionID = 59515   -- Goes to 10 Bottlers, instead of all 63 in RI, CT and MA

*/
Go
Create Proc PreCal.pReMapBCPromotions
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
		Case When (Coalesce(		
			Case When SystemID = 0 Then Null Else SystemID End, 
			Case When ZoneID = 0 Then Null Else ZoneID End, 
			Case When DivisionID = 0 Then Null Else DivisionID End, 
			Case When BCRegionID = 0 Then Null Else BCRegionID End, 
			Case When BottlerID = 0 Then Null Else BottlerID End, 0) > 0) Then 1 Else 0 End HierDefined, 
		Case When (Coalesce(StateID, 0) > 0) Then 1 Else 0 End StateDefined,
		1 TYP 
	From Playbook.PromotionGeoRelevancy pgr
	Join Playbook.RetailPromotion rp on pgr.PromotionID = rp.PromotionID
	Where rp.PromotionEndDate > @BackToDate
	And (
		Coalesce(		
			Case When SystemID = 0 Then Null Else SystemID End, 
			Case When ZoneID = 0 Then Null Else ZoneID End, 
			Case When DivisionID = 0 Then Null Else DivisionID End, 
			Case When BCRegionID = 0 Then Null Else BCRegionID End, 
			Case When BottlerID = 0 Then Null Else BottlerID End, 
			Case When StateID = 0 Then Null Else StateID End, 0) > 0
	)

	If (@Debug = 1)
	Begin
		Select '---- Creating #PromoGeoR Table done----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select Count(*) NumberOfGeoRelevancy From #PromoGeoR
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
		Select TYP, Count(*) CountOfPromotions 
		From (Select Distinct PromotionID, TYP From #PromoGeoR) temp 
		Group By TYP Order By TYP 
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
		Select Count(*) NumberOfPromoBottlersForType2 From #PGR
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
		Select Count(*) NumberOfPromoBottlersForType2And3 From #PGR
		Select * From #PGR
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
		Select Count(*) NumberOfPromotions_ReducedByTerrirotyMap From #ReducedPGR
	End

	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	----- Commiting -----
	Begin Transaction
		Truncate Table PreCal.PromotionBottlerChainGroup

		Insert Into PreCal.PromotionBottlerChainGroup(BottlerID, RegionID, PromotionID, ChainGroupID, PromotionStartDate, PromotionEndDate, IsPromotion)
		Select pgr.BottlerID, s.RegionID, pgr.PromotionID, pgr.ChainGroupID, rp.PromotionStartDate, rp.PromotionEndDate, Case When rp.InformationCategory = 'Promotion' Then 1 Else 0 End IsPromotion
		From #ReducedPGR pgr
		Join Playbook.RetailPromotion rp on pgr.PromotionID = rp.PromotionID
		Join PreCal.BottlerHier s on pgr.BottlerID = s.BottlerID

		Truncate Table PreCal.PromotionRegionChainGroup

		Insert Into PreCal.PromotionRegionChainGroup(PromotionID, RegionID, ChainGroupID, PromotionStartDate, PromotionEndDate, IsPromotion)
		Select Distinct PromotionID, RegionID, ChainGroupID, PromotionStartDate, PromotionEndDate, IsPromotion
		From PreCal.PromotionBottlerChainGroup pb
	Commit Transaction

	If (@Debug = 1)
	Begin
		Select '---- Commiting done. That''s it ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select Count(*) PromoBottlerCnt From PreCal.PromotionBottlerChainGroup
		Select Count(Distinct PromotionID) PromoCnt From PreCal.PromotionBottlerChainGroup
		Select Count(Distinct BottlerID) BottlerCnt From PreCal.PromotionBottlerChainGroup
		Select Min(PromotionEndDate) MinPromotionEndDate From PreCal.PromotionBottlerChainGroup

		Select Count(*) PromoRegionCnt From PreCal.PromotionRegionChainGroup
		Select Count(Distinct PromotionID) PromoCnt From PreCal.PromotionRegionChainGroup
		Select Count(Distinct RegionID) RegionCnt From PreCal.PromotionRegionChainGroup
		Select Min(PromotionEndDate) MinPromotionEndDate From PreCal.PromotionRegionChainGroup
	End

End

Go
Print '--> Precal.pReMapBCPromotions created'
Go

If Exists (Select * From sys.procedures Where object_id = object_id('Precal.pPupulateChainGroupTree'))
Begin
	Drop Proc Precal.pPupulateChainGroupTree
	Print '<-- Precal.pPupulateChainGroupTree dropped'
End
Go

Create Proc PreCal.pPupulateChainGroupTree(@Debug bit = 1)
As
Begin

	Declare @AllNodes Table
	(
		ChainGroupID varchar(20),
		ChainGroupName varchar(100),
		ParentChainGroupID varchar(20),
		NodeType varchar(100),
		SequenceOrder int
	);

	Declare @Dup Table
	(
		ChainGroupID varchar(20),
		ChainGroupName varchar(100),
		ParentChainGroupID varchar(20),
		NodeType varchar(100),
		SequenceOrder int
	);

	With TrueN As
	(
		Select Distinct ChainID, 
						Chain, 
						'0--Null-Nil-Null--' ParentChainID, 
						'National Chain(Scuh as Walmart, CVS and Aramark)' NodeType,
						1 SequenceOrder
		--'Examples scuh as Walmart, CVS, Dollar General and Aramark. Usually shield all chindren, with exception such as Spartan Nash.' Descr
		From MSTR.RevChainImages
		Where ChainHierType = 'N'
	),

	RealR As
	(
		Select Distinct ChainID, 
						Chain,
						Case When NationalChainName = 'All Other' Then '0--Null-Nil-Null--' 
							Else 'N' + REPLACE(STR(NationalChainID,5),' ','0') End ParentChainID, 
						Case When NationalChainName = 'All Other' Then 'Regional Chain with [All Other] Parent' 
							Else 'Regional chain with a national cover' End NodeType,
						Case When NationalChainName = 'All Other' Then 2 
							Else 1 End SequenceOrder
		From MSTR.RevChainImages
		Where ChainHierType = 'R'
	),

	RParent As
	(
		Select Distinct r.ParentChainID ChainID, NationalChainName Chain, 
				'0--Null-Nil-Null--' ParentChainID, 
				'Regional Chain Parent' NodeType, 1 SequenceOrder
		From MSTR.RevChainImages rci
		Join RealR r on Substring(r.ParentChainID, 2, 5) = rci.NationalChainID
		Where ParentChainID <> '0--Null-Nil-Null--'
	),

	HardL As
	(
		Select Distinct ChainID, 
						Chain, 
						Case When RegionalChainName = 'All Other' Then '0--Null-Nil-Null--' 
							 When NationalChainName = 'All Other' Then 'R' + REPLACE(STR(RegionalChainID,5),' ','0')
							 Else 'N' + REPLACE(STR(NationalChainID,5),' ','0') End ParentChainID, 
						Case When RegionalChainName = 'All Other' Then 'Local Chain with [All Other]/[All Other] Parents' 
							 When NationalChainName = 'All Other' Then 'Local Chain with Regional Chain Parents' 
							 Else 'Local Chain attached to national name(skipping the regional level)'
							 End NodeType,
						Case When RegionalChainName = 'All Other' Then 3 
							 When NationalChainName = 'All Other' Then 2 
							 Else 1
							 End SequenceOrder  
		From MSTR.RevChainImages
		Where ChainHierType = 'L'
	),

	LParent As
	(
		Select Distinct l.ParentChainID ChainID, 
						NationalChainName Chain, 
						'0--Null-Nil-Null--' ParentChainID, 
						'Local chain''s national chain grand parent' NodeType,
						1 SequenceOrder  
		From MSTR.RevChainImages rci
		Join HardL l on Substring(l.ParentChainID, 2, 5) = rci.NationalChainID
		Where Substring(l.ParentChainID, 1, 1) = 'N'
		And ParentChainID <> '0--Null-Nil-Null--'
		Union
		Select Distinct l.ParentChainID ChainID, 
						RegionalChainName Chain, 
						'0--Null-Nil-Null--' ParentChainID, 
						'Local chain''s regional chain parent' NodeType,
						2 SequenceOrder  
		From MSTR.RevChainImages rci
		Join HardL l on Substring(l.ParentChainID, 2, 5) = rci.RegionalChainID
		Where Substring(l.ParentChainID, 1, 1) = 'R'
		And ParentChainID <> '0--Null-Nil-Null--'
	)

	Insert Into @AllNodes(ChainGroupID, ChainGroupName, ParentChainGroupID, NodeType, SequenceOrder)
	Select ChainID, Chain, ParentChainID, NodeType, SequenceOrder
	From TrueN
	Union 
	Select ChainID, Chain, ParentChainID, NodeType, SequenceOrder
	From RealR
	Union 
	Select ChainID, Chain, ParentChainID, NodeType, SequenceOrder
	From RParent
	Union
	Select ChainID, Chain, ParentChainID, NodeType, SequenceOrder
	From HardL
	Union
	Select ChainID, Chain, ParentChainID, NodeType, SequenceOrder
	From LParent

	-- Get rid of old Albertsons nodes
	Delete From @AllNodes Where ChainGroupID = 'N00172' Or ParentChainGroupID = 'N00172' 

	-- Get rid of old Safeway nodes
	Delete From @AllNodes Where ChainGroupName = 'Safeway Us'

	--- Merge the duplicated national nodes cause they play more than one role ---
	Insert Into @Dup(ChainGroupID, ChainGroupName, ParentChainGroupID, NodeType, SequenceOrder)
	Select ChainGroupID, ChainGroupName, ParentChainGroupID, Min(NodeType) + '; ' + Max(NodeType) NodeType, SequenceOrder
	From @AllNodes
	Group By ChainGroupID, ChainGroupName, ParentChainGroupID, SequenceOrder
	Having Count(*) > 1

	Delete From @AllNodes
	Where ChainGroupID in (Select ChainGroupID From @Dup)

	Insert Into @AllNodes
	Select ChainGroupID, ChainGroupName, ParentChainGroupID, NodeType, SequenceOrder
	From @Dup

	---------------
	Begin Transaction
	Truncate Table PreCal.ChainGroupTree

	Insert Into PreCal.ChainGroupTree(ChainGroupID, ChainGroupName, ParentChainGroupID, NodeType, SequenceOrder, IsMSTRChainGroup)
	Select a.ChainGroupID, a.ChainGroupName, Case When a.ParentChainGroupID = '0--Null-Nil-Null--' Then Null Else a.ParentChainGroupID End, 
		a.NodeType, a.SequenceOrder, Case When cg.ChainGroupID is Null Then 0 Else 1 End
	From @AllNodes a
	Left Join PlayBook.ChainGroup cg on a.ChainGroupID = cg.ChainGroupID
	Commit Transaction

	If (@Debug = 1)
	Begin
		--- Expecting Nothing ----
		Select 'Expecting Nothing '
		Select *
		From @AllNodes
		Where ChainGroupID in 
		(
			Select ChainGroupID
			From @AllNodes
			Group By ChainGroupID
			Having Count(*) > 1
		)
		Order By ChainGroupID
	End
End
Go
Print '--> Precal.pPupulateChainGroupTree created'
Go

---##################
If Exists (Select * From sys.procedures Where object_id = object_id('Playbook.pSaveBCPromotion'))
Begin
	Drop Proc Playbook.pSaveBCPromotion
	Print '<-- Playbook.pSaveBCPromotion dropped'
End
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
	And Coalesce(
		Case When SystemID = 0 Then Null Else SystemID End, 
		Case When ZoneID = 0 Then Null Else ZoneID End, 
		Case When DivisionID = 0 Then Null Else DivisionID End, 
		Case When BCRegionID = 0 Then Null Else BCRegionID End, 
		Case When BottlerID = 0 Then Null Else BottlerID End, 
		Case When StateID = 0 Then Null Else StateID End, 0) > 0

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
Print '--> Playbook.pSaveBCPromotion created'
Go

---##################
If Exists (Select * From sys.procedures Where object_id = object_id('Playbook.pSaveDSDPromotion'))
Begin
	Drop Proc Playbook.pSaveDSDPromotion
	Print '<-- Playbook.pSaveDSDPromotion dropped'
End
Go

SET QUOTED_IDENTIFIER ON
GO

/*
exec Playbook.pSaveDSDPromotion @PromotionID = 16402


--- Hier Only
Select * 
From PreCal.PromotionBranch
Where PromotionID = 59433

exec Playbook.pSaveDSDPromotion @PromotionID = 59433, @Debug = 1

--- Hier Only
Select * 
From PreCal.PromotionBranch
Where PromotionID = 64292

exec Playbook.pSaveDSDPromotion @PromotionID = 64292, @Debug = 1

--- State and Hier 41652
Select * 
From PreCal.PromotionBranch
Where PromotionID = 41652

exec Playbook.pSaveDSDPromotion @PromotionID = 41652, @Debug = 1

--- State and Hier 35661
Select * 
From PreCal.PromotionBranch
Where PromotionID = 35661

exec Playbook.pSaveDSDPromotion @PromotionID = 35661, @Debug = 1

--- State and Hier 36816
Select * 
From PreCal.PromotionBranch
Where PromotionID = 36816

Select * 
From PreCal.PromotionBranchChainGroup
Where PromotionID = 36816

exec Playbook.pSaveDSDPromotion @PromotionID = 36816, @Debug = 1

--- State Only 33704
Select * 
From PreCal.PromotionBranch
Where PromotionID = 33704

exec Playbook.pSaveDSDPromotion @PromotionID = 33704, @Debug = 1

---
Select *
From PlayBook.PromotionGeoRelevancy
Where Coalesce(BUID, RegionID, AreaID, BranchID, 0) = 0
And PromotionID in 
(	Select Distinct PromotionID
	From PlayBook.PromotionGeoRelevancy
	Where Coalesce(StateID, 0) > 0
)
Order By PromotionID Desc

Select * From PlayBook.PromotionGeoRelevancy
Where PromotionID = 33704

*/

Create Proc Playbook.pSaveDSDPromotion
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

		Select '---- Starting ----' Debug, @PromotionID PromotionID
	End

	--- GeoRelevancy Expansion with Date Cut
	Declare @PromoGeoR Table 
	(
		BUID int,
		RegionID int, 
		AreaID int,
		BranchID int,
		StateID int,
		HierDefined int,
		StateDefined int,
		TYP int  -- Type of Promotion, 1 Init; 2 State And Hier; 3 HierOnly; 4 StateOnly; 5 AnytingElse; 6 Assume All DSD Promotion For StateOnly
	)

	Insert Into @PromoGeoR
	Select BUID, RegionID, AreaID, BranchID, StateID, 
		Case When (Coalesce(Case When BUID < 1 Then Null Else BUID End, 
			Case When RegionID < 1 Then Null Else RegionID End, 
			Case When AreaID < 1 Then Null Else AreaID End, 
			Case When BranchID < 1 Then Null Else BranchID End, 0) > 0) Then 1 Else 0 End HierDefined, 
		Case When (Coalesce(StateID, 0) > 0) Then 1 Else 0 End StateDefined,
		1 TYP 
	From Playbook.PromotionGeoRelevancy pgr
	Join Playbook.RetailPromotion rp on pgr.PromotionID = rp.PromotionID
	Where (
		Coalesce(
			Case When BUID < 1 Then Null Else BUID End, 
			Case When RegionID < 1 Then Null Else RegionID End, 
			Case When AreaID < 1 Then Null Else AreaID End, 
			Case When BranchID < 1 Then Null Else BranchID End, 0) > 0
	)
	And pgr.PromotionID = @PromotionID

	If (@Debug = 1)
	Begin
		Select '---- Creating @PromoGeoR Table done----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select * From @PromoGeoR
	End

	-- 1 Init; 2 State And Hier; 3 HierOnly; 4 StateOnly; 5 AnytingElse; 6 Assume All DSD Promotion For StateOnly
	Declare @HierDefined int
	Declare @StateDefined int

	Select @HierDefined = Sum(HierDefined), @StateDefined = Sum(StateDefined)
	From @PromoGeoR

	Update pgr
	Set TYP = Case When @HierDefined > 0 And @StateDefined  > 0 Then 2 When @HierDefined > 0 Then 3 When @StateDefined > 0 Then 4 Else 5 End
	From @PromoGeoR pgr


	-- Note: This is a cross join, for state only promotions, we add all the BUs to them
	If Exists (Select * From @PromoGeoR Where TYP = 4)
	Begin
		Insert Into @PromoGeoR(BUID, TYP)
		Select BUID, 6
		From SAP.BusinessUnit
	End

	-- Now there is no State-Only Promotions, they are converted to be State and Hier Promotions
	Update @PromoGeoR
	Set TYP = 2
	Where TYP in (4,6)

	If (@Debug = 1)
	Begin
		Select '---- Promotion Classification done----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select *, 
		Case When TYP = 2 Then 'State And Hier'
			When TYP = 3 Then 'Hier Only'
			When TYP = 4 Then 'State Only'
		End PromotionType
		From @PromoGeoR temp
	End

	--- Branch Driver table -----
	Declare @PGR Table 
	(
		PromotionID int not null,
		BranchID int
		Primary Key (PromotionID, BranchID)
	)

	-- Hier Only
	Insert Into @PGR(PromotionID, BranchID)
	Select @PromotionID, v.BranchID
	From @PromoGeoR pgr
	Join PreCal.DSDBranch v on pgr.BUID = v.BUID
	Where TYP = 3
	Union
	Select @PromotionID, v.BranchID
	from @PromoGeoR pgr
	Join PreCal.DSDBranch v on pgr.RegionID = v.RegionID
	Where TYP = 3 And Coalesce(pgr.BUID, 0) = 0
	Union
	Select @PromotionID, v.BranchID
	from @PromoGeoR pgr
	Join PreCal.DSDBranch v on pgr.AreaID = v.AreaID
	Where TYP = 3 And Coalesce(pgr.BUID, pgr.RegionID, 0) = 0
	Union
	Select @PromotionID, pgr.BranchID
	From @PromoGeoR pgr
	Where TYP = 3 And Coalesce(pgr.BranchID, 0) > 0

	If (@Debug = 1)
	Begin
		Select '---- Type 3(Hier Only) Expanded ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select * From @PGR
	End

	-- State & Hier
	Insert Into @PGR(PromotionID, BranchID)
	Select @PromotionID, r.BranchID
	From (
		Select v.BranchID
		From @PromoGeoR pgr
		Join PreCal.DSDBranch v on pgr.BUID = v.BUID
		Where TYP = 2
		Union
		Select v.BranchID
		from @PromoGeoR pgr
		Join PreCal.DSDBranch v on pgr.RegionId = v.RegionId
		Where TYP = 2 And pgr.BUID is null
		Union
		Select v.BranchID
		from @PromoGeoR pgr
		Join PreCal.DSDBranch v on pgr.AreaId = v.AreaId
		Where TYP = 2 And Coalesce(pgr.BUID, pgr.RegionId, 0) = 0
		Union
		Select pgr.BranchID
		From @PromoGeoR pgr
		Where TYP = 2 And Coalesce(pgr.BranchID, 0) > 0
	) l
	Join (
		Select Distinct h.BranchID
		From @PromoGeoR pgr
		Join PreCal.BranchState h on pgr.StateID = h.StateRegionID
		Where TYP = 2) r On l.BranchID = r.BranchID
	
	If (@Debug = 1)
	Begin
		Select '---- All Expansions(both type 2 and 3) done ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select * From @PGR
	End

	--- Filtering
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	Declare @PGR1 Table 
	(
		PromotionID int not null,
		BranchID int
		Primary Key (PromotionID, BranchID)
	)

	--- First by brand ---
	Insert Into @PGR1
	Select Distinct pgr.PromotionID, pgr.BranchID
	From PreCal.BranchBrand bb, -- Branch Brand Association
	(
		Select Distinct PromotionID, b.BrandID
		From Playbook.PromotionBrand pb With (nolock)
		Join SAP.Brand b on (pb.TrademarkID = b.TrademarkID)
		Union
		Select PromotionID, BrandID
		From Playbook.PromotionBrand With (nolock) Where Coalesce(TradeMarkID, 0) = 0 
	) ptm, -- Promotion Brand
	@PGR pgr  --Promotion Geo
	Where pgr.BranchID = bb.BranchID
	And bb.BrandID = ptm.BrandID
	And pgr.PromotionID = ptm.PromotionID
	
	If (@Debug = 1)
	Begin
		Select '---- Promotion filtered by Brands ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select * From @PGR1
	End

	--- Then by chain ---
	Delete From @PGR

	Insert Into @PGR
	Select Distinct pgr.PromotionID, pgr.BranchID
	From 	
	@PGR1 pgr, -- Promotion Geo
	Precal.PromotionLocalChain pc, --- Promotion Chain
	Shared.tLocationChain tlc,  -- This table was created by Jag and used in production reliably
	Playbook.RetailPromotion rp
	Where pgr.BranchID = tlc.BranchID
	And tlc.LocalChainID = pc.LocalChainID
	And pc.PromotionID = pgr.PromotionID
	And rp.PromotionID = pgr.PromotionID
	Union
	Select Distinct pgr.PromotionID, pgr.BranchID
	From 	
	@PGR1 pgr, --- Promotion Geo
	(
		Select PromotionID, ChannelID
		From Playbook.PromotionChannel
		Where isnull(ChannelID, 0) > 0
		Union
		Select Distinct PromotionID, c.ChannelID
		From Playbook.PromotionChannel pc
		Join SAP.Channel c on pc.SuperChannelID = c.SuperChannelID
		Where isnull(pc.SuperChannelID, 0) > 0
	) pc, --- Promotion Chain
	PreCal.BranchChannel tlc,  -- This table was created by Jag and used in production reliably
	Playbook.RetailPromotion rp
	Where pgr.BranchID = tlc.BranchID
	And tlc.ChannelID = pc.ChannelID
	And pc.PromotionID = pgr.PromotionID
	And rp.PromotionID = pgr.PromotionID

	If (@Debug = 1)
	Begin
		Select '---- Promotion further filtered further by Chains Or Channels ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select * From @PGR
	End
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	----- Commiting -----
	Begin Transaction
		Delete PreCal.PromotionBranch
		Where PromotionID = @PromotionID

		Insert Into PreCal.PromotionBranch(BranchID, PromotionID, PromotionStartDate, PromotionEndDate, IsPromotion, PromotionGroupID)
		Select pgr.BranchID, pgr.PromotionID, rp.PromotionStartDate, rp.PromotionEndDate, Case When rp.InformationCategory = 'Promotion' Then 1 Else 0 End IsPromotion, PromotionGroupID
		From @PGR pgr
		Join Playbook.RetailPromotion rp on pgr.PromotionID = rp.PromotionID

		Delete PreCal.PromotionBranchChainGroup
		Where PromotionID = @PromotionID

		Insert Into PreCal.PromotionBranchChainGroup(PromotionID, BranchID, PromotionStartDate, PromotionEndDate, IsPromotion, ChainGroupID)
		Select pb.PromotionID, pb.BranchID, pb.PromotionStartDate, pb.PromotionEndDate, pb.IsPromotion, pcg.ChainGroupID
		From PreCal.PromotionBranch pb with (nolock)
		Join PreCal.PromotionChainGroup pcg on pb.PromotionID = pcg.PromotionID
		Join PreCal.BranchChainGroup bcg on bcg.BranchID = pb.BranchID and bcg.ChainGroupID = pcg.ChainGroupID
		Where pb.PromotionID = @PromotionID

	Commit Transaction

	If (@Debug = 1)
	Begin
		Select '---- Commiting done. That''s it ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select * 
		From PreCal.PromotionBranchChainGroup
		Where PromotionID = @PromotionID
	End

End

Go
Print '--> Playbook.pSaveDSDPromotion created'
Go

---##################
SET QUOTED_IDENTIFIER ON
GO

--ALTER TABLE playbook.retailpromotion ADD VariableRPC VARCHAR(50)
--	,Redemption INT
--	,FixedCost FLOAT
--	,AccrualComments VARCHAR(500)
--ALTER TABLE playbook.retailpromotion add RPC VARCHAR(50)
--ALTER TABLE playbook.retailpromotion drop column  VariableRPC 
ALTER PROCEDURE [Playbook].[pInsertUpdatePromotion] (
	--we will add column to save brand-package in json format                                                                                                                     
	@Mode VARCHAR(500)
	,@PromotionID INT
	,@PromotionDescription VARCHAR(500)
	,@PromotionName VARCHAR(500)
	,@PromotionTypeID INT
	,@GEOInfo XML
	,@AccountInfo XML
	,@ChannelInfo XML
	,@StateXML XML
	,@AccountId INT
	,@EdgeItemId INT
	,@IsLocalized BIT
	,@PromotionTradeMarkID VARCHAR(500)
	,@PromotionBrandId VARCHAR(500)
	,@PromotionPackageID VARCHAR(500)
	,@PromotionPrice VARCHAR(500)
	,@PromotionCategoryId INT
	,@PromotionDisplayLocationId INT
	,@PromotionDisplayLocationOther VARCHAR(500)
	,@PromotionDisplayRequirement VARCHAR(20)
	,@PromotionStartDate DATETIME
	,@PromotionEndDate DATETIME
	,@PromotionStatus VARCHAR(500)
	,@SystemID VARCHAR(500)
	--,@IsDuplicate BIT              
	,@ParentPromoId INT
	,@IsNewVersion BIT
	,@ForecastVolume VARCHAR(500)
	,@NationalDisplayTarget VARCHAR(500)
	,@BottlerCommitment VARCHAR(500)
	,@BranchId INT
	,@BUID INT
	,@RegionId INT
	,@CreatedBy VARCHAR(500)
	,@ModifiedBy VARCHAR(500)
	,@AccountImageName VARCHAR(50)
	,@PromotionGroupID INT
	,@ProgramId INT
	,@BestBets NVARCHAR(48)
	,@EdgeComments NVARCHAR(250)
	,@IsNationalPromotion BIT -- True/False if the user has the permission to create NA Promotions                                      
	,@PromotionDisplayStartDate DATETIME
	,@PromotionDisplayEndDate DATETIME
	,@PromotionPricingStartDate DATETIME
	,@PromotionPricingEndDate DATETIME
	,@VariableRPC VARCHAR(50)
	,@Redemption INT
	,@FixedCost VARCHAR(50)
	,@AccrualComments VARCHAR(500)
	,@Unit VARCHAR(50)
	,@Accounting VARCHAR(50)
	,@IsSMA BIT
	,@IsCostPerStore BIT
	,@TPMNumberCASO VARCHAR(20)
	,@TPMNumberPASO VARCHAR(20)
	,@TPMNumberISO VARCHAR(20)
	,@TPMNumberPB VARCHAR(100)
	,@RoleName VARCHAR(50) -- Add new Pram as Role Name for get persona             
	,@PromotionDisplayTypeId INT
	,@PersonaID INT
	,@COSTPerStore VARCHAR(50)
	,@Status INT OUT
	,@Message VARCHAR(500) OUT
	,@NewPromoId INT OUT
	,@InformationCategory NVARCHAR(100)
	)
AS
BEGIN
	DECLARE @PromotionStatusId INT

	if(convert(varchar(30),@PromotionDisplayStartDate,101)='01/01/1900')
		set @PromotionDisplayStartDate = null
	if(convert(varchar(30),@PromotionDisplayEndDate,101)='01/01/1900')
		set @PromotionDisplayEndDate = null
	if(convert(varchar(30),@PromotionPricingStartDate,101)='01/01/1900')
		set @PromotionPricingStartDate = null
	if(convert(varchar(30),@PromotionPricingEndDate,101)='01/01/1900')
		set @PromotionPricingEndDate = null

	--Fetch promotion status id by promotion status                                                               
	SELECT @PromotionStatusId = StatusID
	FROM PlayBook.STATUS
	WHERE LOWER(StatusName) = LOWER(@PromotionStatus)

	DECLARE @Attachments TABLE (
		Id INT identity
		,PromoId INT
		,Url VARCHAR(500)
		,NAME VARCHAR(500)
		)
	DECLARE @tblTradeMark TABLE (
		Id INT identity(1, 1)
		,TradeMarkId VARCHAR(100)
		)
	DECLARE @tblBrands TABLE (
		Id INT identity(1, 1)
		,BrandId VARCHAR(100)
		)
	DECLARE @tblPackage TABLE (
		Id INT identity(1, 1)
		,PackageId VARCHAR(100)
		)
	-- Fatching User Group Name from  table                            
	DECLARE @UserGroupName VARCHAR(50)

	SELECT @UserGroupName = UserGroupName
	FROM Playbook.UserGroup
	WHERE RoleName = @RoleName

	--print @UserGroupName                    
	IF (@Mode = 'Insert')
	BEGIN
		-- Insert promotion
		--select MAX(promotionid) from PlayBook.RetailPromotion
		--SELECT * from PlayBook.RetailPromotion where promotionid = 24571
		INSERT INTO PlayBook.RetailPromotion (
			PromotionName
			,PromotionDescription
			,PromotionTypeID
			,PromotionPrice
			,PromotionCategoryID
			,PromotionStatusID
			,PromotionStartDate
			,PromotionEndDate
			,ForecastVolume
			,NationalDisplayTarget
			,BottlerCommitment
			,PromotionBranchID
			,PromotionBUID
			,PromotionRegionID
			,EDGEItemID
			,IsLocalized
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,AccountImageName
			,InformationCategory
			,PromotionGroupID
			,ProgramId
			,NationalChainID
			,IsNationalAccount
			,StatusModifiedDate
			,BestBets
			,EdgeComments
			,PromotionRelevantStartDate
			,PromotionRelevantEndDate
			,DisplayStartDate -- new date fields                                    
			,DisplayEndDate -- new date fields                                    
			,PricingStartDate -- new date fields                                    
			,PricingEndDate -- new date fields                 
			,IsSMA
			,IsCostPerStore
			,TPMCASO
			,TPMPASO
			,TPMISO
			,TPMPB
			,PersonaID
			,UserGroupName
			,DisplayTypeID
			,CostPerStore
			,RPC
			,Redemption
			,FixedCost
			,AccrualComments
			,Unit
			,Accounting
			)
		VALUES (
			@PromotionName
			,@PromotionDescription
			,@PromotionTypeID
			,@PromotionPrice
			,@PromotionCategoryId
			,@PromotionStatusId
			,@PromotionStartDate
			,@PromotionEndDate
			,@ForecastVolume
			,@NationalDisplayTarget
			,@BottlerCommitment
			,@BranchId
			,@BUID
			,@RegionId
			,@EdgeItemId
			,@IsLocalized
			,@CreatedBy
			,GETUTCDATE()
			,@ModifiedBy
			,GETUTCDATE()
			,@AccountImageName
			,@InformationCategory
			,@PromotionGroupID
			,@ProgramId
			,@AccountId
			,@IsNationalPromotion
			,GETUTCDATE()
			,@BestBets
			,@EdgeComments
			,CASE 
				WHEN DATENAME(DW, @PromotionStartDate) = 'Sunday'
					THEN DATEADD(wk, DATEDIFF(wk, 0, @PromotionStartDate), - 7)
				ELSE DATEADD(wk, DATEDIFF(wk, 7, @PromotionStartDate), 7)
				END
			,CASE 
				WHEN DATENAME(DW, @PromotionEndDate) = 'Sunday'
					THEN @PromotionEndDate
				ELSE DATEADD(wk, DATEDIFF(wk, 6, @PromotionEndDate), 6 + 7)
				END
			,@PromotionDisplayStartDate
			,@PromotionDisplayEndDate
			,@PromotionPricingStartDate
			,@PromotionPricingEndDate
			,@IsSMA
			,@IsCostPerStore
			,@TPMNumberCASO
			,@TPMNumberPASO
			,@TPMNumberISO
			,@TPMNumberPB
			,@PersonaID
			,@UserGroupName
			,@PromotionDisplayTypeId
			,@COSTPerStore
			,@VariableRPC
			,@Redemption
			,@FixedCost
			,@AccrualComments
			,@Unit
			,@Accounting
			)

		SET @PromotionID = SCOPE_IDENTITY()
		SET @NewPromoId = @PromotionID;

		----To create duplicate promotion                                                                           
		IF (@IsNewVersion = 1)
			UPDATE PlayBook.RetailPromotion
			SET ParentPromotionID = @ParentPromoId
				,islocalized = 1
			WHERE PromotionID = @PromotionID

		----Save data for display location . for other option we have update PromotionDisplayLocationOther column in PlayBook.PromotionDisplayLocation                                                                                                              
		--IF (@PromotionDisplayLocationId = 23) --23 id for other option in display location                                                                                                                  
		--BEGIN                                      
		INSERT INTO PlayBook.PromotionDisplayLocation (
			PromotionID
			,DisplayLocationID
			,PromotionDisplayLocationOther
			,DisplayRequirement
			)
		VALUES (
			@PromotionID
			,@PromotionDisplayLocationId
			,@PromotionDisplayLocationOther
			,@PromotionDisplayRequirement
			)

		--END                                 
		--ELSE                                      
		--BEGIN                                      
		-- INSERT INTO PlayBook.PromotionDisplayLocation (                                      
		--  PromotionID                                      
		--  ,DisplayLocationID                                      
		--  )                                      
		-- VALUES (                                      
		--  @PromotionID                                      
		--  ,@PromotionDisplayLocationId                                      
		--  )                                      
		--END                 
		----Add account for Promotion                                                                
		--IF(@PromotionTypeID=2)--Regional chain                                                                                          
		--INSERT INTO PlayBook.PromotionAccount(PromotionID,RegionalChainID) VALUES(@PromotionID,@AccountId)                                                                
		--IF(@PromotionTypeID=1)--National chain                                                                                                           
		--INSERT INTO PlayBook.PromotionAccount( PromotionID , NationalChainID ) VALUES( @PromotionID , @AccountId )                                                                                  
		--IF(@PromotionTypeID=3)--Local chain                                                                
		-- INSERT INTO PlayBook.PromotionAccount(PromotionID, LocalChainID) VALUES(@PromotionID,@AccountId)                                                                              
		INSERT INTO PlayBook.PromotionAccount (
			PromotionID
			,LocalChainID
			,RegionalChainID
			,NationalChainID
			)
		SELECT DISTINCT @PromotionID AS PromotionID
			,item.value('LocalChainID[1]', 'varchar(100)') AS LocalChainID
			,item.value('RegionalChainID[1]', 'varchar(100)') AS RegionalChainID
			,item.value('NationalChainID[1]', 'varchar(100)') AS NationalChainID
		--,item.value('IsRoot[1]', 'varchar(100)') AS IsRoot          
		FROM @AccountInfo.nodes('Account/Item') AS items(item)

		--   -- Insert trade mark for promotion                                                                                     
		INSERT INTO @tblTradeMark (TradeMarkId)
		SELECT *
		FROM CDE.udfSplit(@PromotionTradeMarkID, ',')
		WHERE Value != ''
			AND Value IS NOT NULL

		INSERT INTO PlayBook.PromotionBrand (
			PromotionID
			,TrademarkID
			)
		SELECT @PromotionID
			,CAST(TradeMarkId AS INT)
		FROM @tblTradeMark

		----   -- Insert System for promotion                                                          
		--INSERT INTO @tblPromotionSystem (SystemId)                            
		--SELECT *                            
		--FROM CDE.udfSplit(@SystemID, ',')                            
		--INSERT INTO PlayBook.PromotionSystem (                            
		-- PromotionID                            
		-- ,SystemID                            
		-- )                            
		--SELECT @PromotionID                            
		-- ,CAST(SystemId AS INT)                            
		--FROM @tblPromotionSystem                            
		--Insert Brand instead of trademark for Core Ten Category                                                                                            
		IF (@PromotionBrandId != '')
		BEGIN
			INSERT INTO @tblBrands (BrandId)
			SELECT *
			FROM CDE.udfSplit(@PromotionBrandId, ',')
			WHERE Value != ''
				AND Value IS NOT NULL

			INSERT INTO PlayBook.PromotionBrand (
				PromotionID
				,BrandID
				)
			SELECT @PromotionID
				,CAST(BrandId AS INT)
			FROM @tblBrands
		END

		--Insert Package for promotion                                                                                                                  
		INSERT INTO @tblPackage (PackageId)
		SELECT *
		FROM CDE.udfSplit(@PromotionPackageID, ',')
		WHERE Value != ''
			AND Value IS NOT NULL

		INSERT INTO PlayBook.PromotionPackage (
			PromotionID
			,PackageID
			)
		SELECT @PromotionID
			,CAST(PackageId AS INT)
		FROM @tblPackage

		-- Insert GEO relevancy                                                                   
		EXEC Playbook.[PInsertUpdatePromotionGEORelevancy] @PromotionID
			,@GEOInfo
			,@SystemID

		--INSERT INTO PlayBook.PromotionGeoRelevancy (                              
		-- PromotionID                              
		-- ,BUID                              
		-- ,RegionId   
		-- ,BranchId                              
		-- ,AreaId                              
		-- )                              
		--SELECT @PromotionID AS PromotionID                              
		-- ,item.value('BUID[1]', 'varchar(500)') AS BUID                              
		-- ,item.value('RegionId[1]', 'varchar(500)') AS RegionID                              
		-- ,item.value('BranchId[1]', 'varchar(500)') AS BranchId                              
		-- ,item.value('AreaId[1]', 'varchar(500)') AS AreaId                              
		--FROM @GEOInfo.nodes('GEO/Item') AS items(item)                      
		---Channel---                                                                  
		INSERT INTO PlayBook.PromotionChannel
		SELECT (
				CASE 
					WHEN item.value('SuperChannelID[1]', 'varchar(100)') = ''
						THEN NULL
					ELSE CAST(item.value('SuperChannelID[1]', 'varchar(100)') AS INT)
					END
				) AS SuperChannelID
			,(
				CASE 
					WHEN item.value('ChannelID[1]', 'varchar(100)') = ''
						THEN NULL
					ELSE CAST(item.value('ChannelID[1]', 'varchar(100)') AS INT)
					END
				) AS ChannelID
			,@PromotionID AS PromotionID
		FROM @ChannelInfo.nodes('Channel/Item') AS items(item)

		SET @Status = 1
		SET @Message = 'Promotion has been inserted successfully.'
	END

	--Update Promotion                         
	IF (@Mode = 'Update')
	BEGIN
		UPDATE PlayBook.RetailPromotion
		SET PromotionName = @PromotionName
			,PromotionDescription = @PromotionDescription
			,PromotionTypeID = @PromotionTypeID
			,PromotionPrice = @PromotionPrice
			,PromotionCategoryID = @PromotionCategoryId
			,PromotionDisplayLocationID = @PromotionDisplayLocationID
			,PromotionStatusID = @PromotionStatusId
			,PromotionStartDate = @PromotionStartDate
			,PromotionEndDate = @PromotionEndDate
			,ForecastVolume = @ForecastVolume
			,NationalDisplayTarget = @NationalDisplayTarget
			,BottlerCommitment = @BottlerCommitment
			,PromotionBranchID = @BranchId
			,PromotionBUID = @BUID
			,PromotionRegionID = @RegionId
			,EDGEItemID = @EdgeItemId
			,ModifiedBy = @ModifiedBy
			,ModifiedDate = GETUTCDATE()
			,AccountImageName = @AccountImageName
			,PromotionGroupID = @PromotionGroupID
			,ProgramId = @ProgramID
			,NationalChainID = @AccountId
			,BestBets = @BestBets
			,InformationCategory = @InformationCategory
			,EdgeComments = @EdgeComments
			,StatusModifiedDate = CASE 
				WHEN PromotionStatusID = @PromotionStatusId
					THEN StatusModifiedDate
				ELSE GETUTCDATE()
				END
			,PromotionRelevantStartDate = CASE 
				WHEN DATENAME(DW, @PromotionStartDate) = 'Sunday'
					THEN DATEADD(wk, DATEDIFF(wk, 0, @PromotionStartDate), - 7)
				ELSE DATEADD(wk, DATEDIFF(wk, 7, @PromotionStartDate), 7)
				END
			,PromotionRelevantEndDate = CASE 
				WHEN DATENAME(DW, @PromotionEndDate) = 'Sunday'
					THEN @PromotionEndDate
				ELSE DATEADD(wk, DATEDIFF(wk, 6, @PromotionEndDate), 6 + 7)
				END
			,DisplayStartDate = @PromotionDisplayStartDate
			,DisplayEndDate = @PromotionDisplayEndDate
			,PricingStartDate = @PromotionPricingStartDate
			,PricingEndDate = @PromotionPricingEndDate
			,IsSMA = @IsSMA
			,IsCostPerStore = @IsCostPerStore
			,TPMCASO = @TPMNumberCASO
			,TPMPASO = @TPMNumberPASO
			,TPMISO = @TPMNumberISO
			,TPMPB = @TPMNumberPB
			,DisplayTypeID = @PromotionDisplayTypeId
			,CostPerStore = @COSTPerStore
			,RPC = @VariableRPC
			,Redemption = @Redemption
			,FixedCost = @FixedCost
			,AccrualComments = @AccrualComments
			,Unit = @Unit
			,Accounting = @Accounting
		WHERE PromotionId = @PromotionID

		--IF (@PromotionDisplayLocationId = 23)                                      
		--BEGIN                                      
		UPDATE PlayBook.PromotionDisplayLocation
		SET DisplayLocationID = @PromotionDisplayLocationId
			,PromotionDisplayLocationOther = @PromotionDisplayLocationOther
			,DisplayRequirement = @PromotionDisplayRequirement
		WHERE PromotionID = @PromotionID;

		--Deleting priority if change in account
		IF EXISTS (
				SELECT isnull(localchainid, 0) + isnull(regionalchainid, 0) + isnull(nationalchainid, 0)
				FROM PlayBook.PromotionAccount
				WHERE PromotionID = @PromotionID
					AND isnull(localchainid, 0) + isnull(regionalchainid, 0) + isnull(nationalchainid, 0) NOT IN (
						SELECT isnull(item.value('LocalChainID[1]', 'varchar(100)'), 0) + isnull(item.value('RegionalChainID[1]', 'varchar(100)'), 0) + isnull(item.value('NationalChainID[1]', 'varchar(100)'), 0)
						FROM @AccountInfo.nodes('Account/Item') AS items(item)
						)
				)
		BEGIN
			UPDATE playbook.promotionrank
			SET Rank = NULL
			WHERE PromotionID = @PromotionID
		END

		--Promotion account      
		DELETE PlayBook.PromotionAccount
		WHERE PromotionID = @PromotionID

		INSERT INTO PlayBook.PromotionAccount (
			PromotionID
			,LocalChainID
			,RegionalChainID
			,NationalChainID
			)
		SELECT DISTINCT @PromotionID AS PromotionID
			,item.value('LocalChainID[1]', 'varchar(100)') AS LocalChainID
			,item.value('RegionalChainID[1]', 'varchar(100)') AS RegionalChainID
			,item.value('NationalChainID[1]', 'varchar(100)') AS NationalChainID
		--,item.value('IsRoot[1]', 'varchar(100)') AS IsRoot          
		FROM @AccountInfo.nodes('Account/Item') AS items(item)

		--Delete Brands and Insert new so that we can have updated brands for promotion.                                                                                                                  
		DELETE PlayBook.PromotionBrand
		WHERE PromotionID = @PromotionID

		--Insert TradeMark for promotion                                                                                                                    
		INSERT INTO @tblTradeMark (TradeMarkId)
		SELECT *
		FROM CDE.udfSplit(@PromotionTradeMarkID, ',')

		INSERT INTO PlayBook.PromotionBrand (
			PromotionID
			,TrademarkID
			)
		SELECT @PromotionID
			,CAST(TradeMarkId AS INT)
		FROM @tblTradeMark

		SET @Message = 'Promotion brand has been updated successfully.'

		----  -- Insert System for promotion                                                          
		--DELETE PlayBook.PromotionSystem                            
		--WHERE PromotionID = @PromotionID                            
		--INSERT INTO @tblPromotionSystem (SystemId)       
		--SELECT *                            
		--FROM CDE.udfSplit(@SystemID, ',')                            
		--INSERT INTO PlayBook.PromotionSystem (                            
		-- PromotionID                            
		-- ,SystemID                            
		-- )                            
		--SELECT @PromotionID                            
		-- ,CAST(SystemId AS INT)                            
		--FROM @tblPromotionSystem                            
		--Insert brandid instead of trademarkid for core ten category                                                                                            
		IF (@PromotionBrandId != '')
		BEGIN
			INSERT INTO @tblBrands (BrandId)
			SELECT *
			FROM CDE.udfSplit(@PromotionBrandId, ',')

			INSERT INTO PlayBook.PromotionBrand (
				PromotionID
				,BrandID
				)
			SELECT @PromotionID
				,CAST(BrandId AS INT)
			FROM @tblBrands
		END

		--Insert Package for promotion                                                                           
		DELETE PlayBook.PromotionPackage
		WHERE PromotionID = @PromotionID

		INSERT INTO @tblPackage (PackageId)
		SELECT *
		FROM CDE.udfSplit(@PromotionPackageID, ',')

		INSERT INTO PlayBook.PromotionPackage (
			PromotionID
			,PackageID
			)
		SELECT @PromotionID
			,CAST(PackageId AS INT)
		FROM @tblPackage

		SET @NewPromoId = 0;

		PRINT 'Pro=' + convert(VARCHAR, @PromotionID)

		--Update GEO Relevancy             
		--delete existing promotion with same id                                  
		EXEC Playbook.[PInsertUpdatePromotionGEORelevancy] @PromotionID
			,@GEOInfo
			,@SystemID

		--INSERT INTO PlayBook.PromotionGeoRelevancy (                              
		-- PromotionID                              
		-- ,BUID                              
		-- ,RegionId                              
		-- ,BranchId                              
		-- ,AreaId                              
		-- )                              
		--SELECT @PromotionID AS PromotionID                              
		-- ,item.value('BUID[1]', 'varchar(500)') AS BUID                              
		-- ,item.value('RegionId[1]', 'varchar(500)') AS RegionID                              
		-- ,item.value('BranchId[1]', 'varchar(500)') AS BranchId                              
		-- ,item.value('AreaId[1]', 'varchar(500)') AS AreaId                              
		--FROM @GEOInfo.nodes('GEO/Item') AS items(item)                              
		----Promotion Channel                                                     
		DELETE PlayBook.PromotionChannel
		WHERE PromotionId = @PromotionID

		INSERT INTO PlayBook.PromotionChannel
		SELECT (
				CASE 
					WHEN item.value('SuperChannelID[1]', 'varchar(100)') = ''
						THEN NULL
					ELSE CAST(item.value('SuperChannelID[1]', 'varchar(100)') AS INT)
					END
				) AS SuperChannelID
			,(
				CASE 
					WHEN item.value('ChannelID[1]', 'varchar(100)') = ''
						THEN NULL
					ELSE CAST(item.value('ChannelID[1]', 'varchar(100)') AS INT)
					END
				) AS ChannelID
			,@PromotionID AS PromotionID
		FROM @ChannelInfo.nodes('Channel/Item') AS items(item)

		SET @Status = 1
		SET @Message = 'Promotion has been updated successfully.'
	END

	IF @IsNationalPromotion = 1 --Approve                                                
	BEGIN
		--if @PromotionStatusId = 4                                                 
		-- --copying promotions                                                
		-- exec Playbook.pCreatePromotionCopies @PromotionID                   
		IF @PromotionStatusId = 3 --Cancelled                        
		BEGIN
			--Cancelling all promotions                                                
			UPDATE PlayBook.RetailPromotion
			SET PromotionStatusID = @PromotionStatusId
				,StatusModifiedDate = GETUTCDATE()
			WHERE EDGEItemID = @PromotionID
		END
	END

	IF (@IsNationalPromotion = 1)
	BEGIN
		UPDATE PlayBook.RetailPromotion
		SET PromotionName = @PromotionName
			,PromotionDescription = @PromotionDescription
			,PromotionStatusID = @PromotionStatusId
		WHERE ParentPromotionId = @PromotionID
	END

	--Updating Account Hier                
	EXEC Playbook.pInsertUpdatePromotionAccountHier @PromotionID

	DECLARE @NationalChainID INT

	SET @NationalChainID = 0
	SET @NationalChainID = (
			SELECT TOP 1 NationalChainID
			FROM playbook.PromotionAccount
			WHERE promotionid = @PromotionID
				AND isnull(NationalChainID, 0) <> 0
			)

	IF (isnull(@NationalChainID, 0) = 0)
		SET @NationalChainID = (
				SELECT TOP 1 b.NationalChainID
				FROM playbook.PromotionAccount a
				LEFT JOIN Sap.regionalchain b ON a.regionalchainid = b.regionalchainid
				WHERE a.promotionid = @PromotionID
					AND isnull(a.regionalchainid, 0) <> 0
				)

	IF (isnull(@NationalChainID, 0) = 0)
		SET @NationalChainID = (
				SELECT TOP 1 c.NationalChainID
				FROM playbook.PromotionAccount a
				LEFT JOIN Sap.localchain b ON a.localchainid = b.localchainid
				LEFT JOIN Sap.regionalchain c ON c.regionalchainid = b.regionalchainid
				WHERE a.promotionid = @PromotionID
					AND isnull(a.localchainid, 0) <> 0
				)

	-- Update Account Info, GEO and Brands                
	UPDATE PlayBook.RetailPromotion
	SET NationalChainID = @NationalChainID
		,PromotionBrands = STUFF((
				SELECT TradeMarkName
				FROM (
					SELECT DISTINCT ' | ' + trademark.TradeMarkName AS TradeMarkName
					FROM SAP.TradeMark AS trademark
					WHERE trademark.TradeMarkID IN (
							SELECT _brand.TrademarkID
							FROM PlayBook.PromotionBrand AS _brand
							WHERE _brand.PromotionID = @PromotionID
							)
					
					UNION
					
					SELECT DISTINCT ' | ' + brands.brandName AS TradeMarkName
					FROM SAP.Brand AS brands
					WHERE brands.BrandId IN (
							SELECT _brand.BrandID
							FROM PlayBook.PromotionBrand AS _brand
							WHERE _brand.PromotionID = @PromotionID
							)
					) AS table1
				FOR XML PATH('')
					,TYPE
				).value('.', 'NVARCHAR(MAX)'), 1, 2, '')
		,promotionPackages = STUFF((
				SELECT DISTINCT ' | ' + _package.PackageName
				FROM SAP.Package AS _package
				WHERE _package.PackageID IN (
						SELECT _pPackage.PackageID
						FROM PlayBook.PromotionPackage AS _pPackage
						WHERE _pPackage.PromotionID = @PromotionID
						)
				FOR XML PATH('')
					,TYPE
				).value('.', 'NVARCHAR(MAX)'), 1, 2, '')
		,AccountInfo = STUFF((
				SELECT DISTINCT ' | ' + CASE 
						WHEN _account.localchainID <> 0
							THEN (
									SELECT LocalChainName
									FROM SAP.LocalChain AS _sapLocal
									WHERE _account.LocalChainID = _sapLocal.LocalChainID
									)
						WHEN _account.RegionalchainID <> 0
							THEN (
									SELECT RegionalChainName
									FROM SAP.RegionalChain AS _sapRegional
									WHERE _account.RegionalChainID = _sapRegional.RegionalChainID
									)
						WHEN _account.NationalchainID <> 0
							THEN (
									SELECT NationalChainName
									FROM SAP.NationalChain AS _sapNational
									WHERE _account.NationalChainID = _sapNational.NationalChainID
									)
						END AS _account
				FROM PlayBook.PromotionAccount AS _account
				WHERE _account.PromotionID = @PromotionID
					--AND _account.IsRoot = 0                
					AND PromotionGroupID = 1
				FOR XML PATH('')
					,TYPE
				).value('.', 'NVARCHAR(MAX)'), 1, 2, '')
		,GEORelavency = STUFF((
				SELECT DISTINCT ' | ' + CASE 
						WHEN IsNull(_geoRel.BUID, 0) <> 0
							THEN (
									'BU - ' + (
										SELECT BUName
										FROM SAP.BusinessUnit _sapBU
										WHERE _geoRel.BUID = _sapBU.BUID
										)
									)
						WHEN IsNull(_geoRel.RegionID, 0) <> 0
							THEN (
									'Region - ' + (
										SELECT RegionName
										FROM SAP.Region _sapRegion
										WHERE _geoRel.RegionID = _sapRegion.RegionID
										)
									)
						WHEN IsNull(_geoRel.BranchId, 0) <> 0
							THEN (
									'Branch - ' + (
										SELECT BranchName
										FROM SAP.Branch _sapBranch
										WHERE _geoRel.BranchID = _sapBranch.BranchID
										)
									)
						WHEN IsNull(_geoRel.AreaId, 0) <> 0
							THEN (
									'Area - ' + (
										SELECT AreaName
										FROM SAP.Area _sapArea
										WHERE _geoRel.AreaID = _sapArea.AreaID
										)
									)
								-- -- FOR SYSTEM, ZONE, Division, BCRegionID,StateID                  
						WHEN IsNull(_geoRel.SystemID, 0) <> 0
							THEN (
									'System - ' + (
										SELECT SystemName
										FROM NationalAccount.System
										WHERE bcsystemID = _geoRel.SystemID
										)
									)
						WHEN isnull(_geoRel.ZoneID, 0) <> 0
							THEN (
									'Zone - ' + (
										SELECT zonename
										FROM bc.zone
										WHERE zoneid = _geoRel.ZoneID
										)
									)
						WHEN isnull(_geoRel.DivisionID, 0) <> 0
							THEN (
									'Division - ' + (
										SELECT divisionname
										FROM bc.division
										WHERE divisionid = _geoRel.DivisionID
										)
									)
						WHEN isnull(_geoRel.BCRegionID, 0) <> 0
							THEN (
									'BC Region - ' + (
										SELECT regionname
										FROM bc.region
										WHERE regionid = _geoRel.BCRegionID
										)
									)
						WHEN isnull(_geoRel.BottlerID, 0) <> 0
							THEN (
									'Bottler - ' + (
										SELECT bottlername
										FROM bc.bottler
										WHERE bottlerid = _geoRel.BottlerID
										)
									)
						WHEN isnull(_geoRel.StateID, 0) <> 0
							THEN (
									'State - ' + (
										SELECT RegionName
										FROM shared.stateregion
										WHERE StateRegionID = _geoRel.StateID
										)
									)
						END AS _geoRel
				FROM PlayBook.PromotionGeoRelevancy AS _geoRel
				WHERE _geoRel.PromotionID = @PromotionID
				FOR XML PATH('')
					,TYPE
				).value('.', 'NVARCHAR(MAX)'), 1, 2, '')
		,PromotionChannel = STUFF((
				SELECT DISTINCT ' | ' + CASE 
						WHEN _channel.SuperChannelID IS NOT NULL
							THEN (
									SELECT SuperChannelName
									FROM SAP.SuperChannel AS _sapSuperChannel
									WHERE _channel.SuperChannelID = _sapSuperChannel.SuperChannelID
									)
						WHEN _channel.ChannelID IS NOT NULL
							THEN (
									SELECT ChannelName
									FROM SAP.Channel AS _sapChannel
									WHERE _channel.ChannelID = _sapChannel.ChannelID
									)
						END AS _channel
				FROM PlayBook.PromotionChannel AS _channel
				WHERE _channel.PromotionID = @PromotionID
				FOR XML PATH('')
					,TYPE
				).value('.', 'NVARCHAR(MAX)'), 1, 2, '')
	WHERE PromotionId = @PromotionID

	--Update all System if all system are selected        
	DECLARE @sysCount INT = 0
		,@buCount INT = 0

	SELECT @sysCount = count(1)
	FROM playbook.PromotionGeoRelevancy
	WHERE PromotionID = @PromotionID
		AND SystemID IS NOT NULL

	SELECT @buCount = count(1)
	FROM playbook.PromotionGeoRelevancy
	WHERE PromotionID = @PromotionID
		AND BUID IS NOT NULL

	IF (
			@sysCount = 3
			AND @buCount = 3
			)
	BEGIN
		UPDATE playbook.RetailPromotion
		SET GEORelavency = 'All Systems'
		WHERE PromotionID = @PromotionID

		--As all systems and BU are selected, addin flag for WD as well      
		INSERT INTO playbook.promotionGeoRelevancy (
			PromotioniD
			,WD
			)
		VALUES (
			@PromotionID
			,1
			)
			--Update Systems    
	END

	----------------------------
	Delete From PreCal.PromotionLocalChain Where PromotionID = @PromotionID

	Insert Into Precal.PromotionLocalChain(PromotionID, LocalChainID, PromotionStartDate, PromotionEndDate, IsPromotion)
	Select p.PromotionID, LocalChainID, rp.PromotionStartDate, rp.PromotionEndDate, Case When rp.InformationCategory = 'Promotion' Then 1 Else 0 End
	From Playbook.PromotionAccount p With (nolock)
	Join Playbook.RetailPromotion rp on p.PromotionID = rp.PromotionID
	Where Coalesce(LocalChainID, 0) > 0
	And rp.PromotionID = @PromotionID
	Union
	Select pa.PromotionID, lc.LocalChainID, PromotionStartDate, PromotionEndDate, Case When InformationCategory = 'Promotion' Then 1 Else 0 End
	From Playbook.PromotionAccount pa With (nolock)
	Join SAP.LocalChain lc on(pa.RegionalChainID = lc.RegionalChainID) 
	Join Playbook.RetailPromotion rp on pa.PromotionID = rp.PromotionID
	Where Coalesce(pa.RegionalChainID, 0) > 0
	And rp.PromotionID = @PromotionID
	Union
	Select pa.PromotionID, rc.LocalChainID, PromotionStartDate, PromotionEndDate, Case When InformationCategory = 'Promotion' Then 1 Else 0 End
	From Playbook.PromotionAccount pa With (nolock)
	Join PreCal.ChainHier rc on pa.NationalChainID = rc.NationalChainID
	Join Playbook.RetailPromotion rp on pa.PromotionID = rp.PromotionID
	And Coalesce(pa.NationalChainID, 0) > 0
	And rp.PromotionID = @PromotionID
	---------------------------------
	
	Delete From PreCal.PromotionChainGroup Where PromotionID = @PromotionID;
	
	With PromotionRegionalChain As
	(
		Select pa.PromotionID, pa.RegionalChainID
		From Playbook.PromotionAccount pa With (nolock)
		Where PromotionID = @PromotionID And Coalesce(pa.RegionalChainID, 0) > 0
		Union
		Select Distinct pa.PromotionID, rc.RegionalChainID
		From Playbook.PromotionAccount pa With (nolock)
		Join PreCal.ChainHier rc on pa.NationalChainID = rc.NationalChainID
		Join Playbook.RetailPromotion rp on pa.PromotionID = rp.PromotionID
		And pa.PromotionID = @PromotionID
		And Coalesce(pa.NationalChainID, 0) > 0
	)

	Insert PreCal.PromotionChainGroup(PromotionID, ChainGroupID)
	Select Distinct PromotionID, ChainID
	From PreCal.PromotionLocalChain plc
	Join MSTR.RevChainImages rci on (plc.LocalChainID = rci.LocalChainID)
	Where PromotionID = @PromotionID
	Union
	Select Distinct PromotionID, ChainID
	From PromotionRegionalChain plc
	Join MSTR.RevChainImages rci on (plc.RegionalChainID = rci.RegionalChainID And rci.ChainID Like 'R%')
	Where PromotionID = @PromotionID
	Union
	Select Distinct PromotionID, ChainID
	From PlayBook.PromotionAccount pa
	Join PreCal.ChainHier ch on pa.LocalChainID = ch.LocalChainID
	Join MSTR.RevChainImages rci on (ch.NationalChainID = rci.NationalChainID And rci.ChainID Like 'N%')
	Where PromotionID = @PromotionID
	---------------------------------

	EXEC Playbook.pUpdatePromotionSystem @PromotionID
	Exec Playbook.pSaveDSDPromotion @PromotionID = @PromotionID
	Exec Playbook.pSaveBCPromotion @PromotionID = @PromotionID
END

Go
Print '--> Playbook.pInsertUpdatePromotion altered'
Go

---##################
If Exists (Select * From sys.procedures Where object_id = object_id('Playbook.pGetLocationTree'))
	Drop Proc Playbook.pGetLocationTree
Go

Set QUOTED_IDENTIFIER ON
GO

Create Proc Playbook.pGetLocationTree
AS
Begin
	Set NoCount On;

	Select '0All' NodeID, 'All BUs' NodeName, '#' ParentID
	Union
	Select '1B' + Convert(varchar, BUID) NodeID, BUName NodeName, '0All' ParentID
	From SAP.BusinessUnit
	Union
	Select '2R' + Convert(Varchar, RegionID) NodeID, RegionName NodeName, '1B' + Convert(varchar, BUID) ParentID
	From SAP.Region
	Union
	Select '3A' + Convert(Varchar, AreaID) NodeID, AreaName NodeName, '2R' + Convert(varchar, RegionID) ParentID
	From SAP.Area
	Where AreaID in (Select Distinct AreaID From PreCal.PromotionBranchChainGroup g Join SAP.Branch b on b.BranchID = g.BranchID)
	Union
	Select '4B' + Convert(Varchar, BranchID) NodeID, BranchName NodeName, '3A' + Convert(varchar, AreaID) ParentID
	From SAP.Branch
	Where BranchID in (Select Distinct BranchID From PreCal.PromotionBranchChainGroup)
	Order By NodeName
End
Go

---##################
If Exists (Select * From sys.procedures Where object_id = object_id('Playbook.pGetPromotionsForLocCgStartDate'))
	Drop Proc Playbook.pGetPromotionsForLocCgStartDate
Go

Set QUOTED_IDENTIFIER ON
GO

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

---##################
If Exists (Select * From sys.procedures Where object_id = object_id('Playbook.pGetChainGroupsBranches'))
	Drop Proc Playbook.pGetChainGroupsBranches
Go

Set QUOTED_IDENTIFIER ON
GO

Create Proc Playbook.pGetChainGroupsBranches
(
	@BUIDs nvarchar(4000) = '',
	@RegionIDs nvarchar(4000) = '',
	@AreaIDs nvarchar(4000) = '',
	@BranchIDs nvarchar(4000) = '',
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

		Select '---- Starting ----' Debug, @BUIDs BUIDs, @RegionIDs RegionIDs, @AreaIDs AreaIDs, @BranchIDs BranchIDs, @Date StartDate
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

	--- Not doing the default value
	--If (@BranchCount = 0)
	--Begin
	--	Insert Into @BranchIDsTable
	--	Select BranchID
	--	From PreCal.DSDBranch
	--End

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
	Declare @PromoGroups Table 
	(
		PromotionID int,
		ChainGroupID varchar(20),
		Primary Key(PromotionID ASC, ChainGroupID ASC)
	)

	Insert Into @PromoGroups
	Select Distinct pb.PromotionID, pb.ChainGroupID
	From
	PreCal.PromotionBranchChainGroup pb with (nolock)
	Join @BranchIDsTable brds On pb.BranchID = brds.BranchID
	Where pb.PromotionStartDate <= @EndDate And pb.PromotionEndDate > @StartDate -- @EndDate is inclusive, See promotion 34605 for details, 1-1 is not valid for that one
	And pb.IsPromotion = 1

	If (@Debug = 1)
	Begin
		Select '---- Promotions With ChainGroup associated filtered by locations ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select * From @PromoGroups
	End;

	Declare @Output Table
	(
		ChainGroupID varchar(20) not null, 
		ChainGroupName varchar(100) not null,
		ParentChainGroupID varchar(20), 
		SequenceOrder int,
		PromotionCount int
	);

	If (@Debug = 1)
	Begin
		Select '---- Promotion ChainGroups and parent chaingroups retrived ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds;

		With RealCGCount As
		(
			Select ChainGroupID, Count(*) PromotionCount
			From @PromoGroups
			Group By ChainGroupID
		)
		Select t.ChainGroupID, t.ChainGroupName, t.ParentChainGroupID, t.SequenceOrder, PromotionCount
		From RealCGCount r
		Join PreCal.ChainGroupTree t on r.ChainGroupID = t.ChainGroupID
		Order By ChainGroupName

	End;
	
	With RealCGCount As
	(
		Select ChainGroupID, Count(*) PromotionCount
		From @PromoGroups
		Group By ChainGroupID
	)

	Insert Into @Output(ChainGroupID, ChainGroupName, ParentChainGroupID, SequenceOrder, PromotionCount)
	Select t.ChainGroupID, t.ChainGroupName, t.ParentChainGroupID, t.SequenceOrder, PromotionCount
	From RealCGCount r
	Join PreCal.ChainGroupTree t on r.ChainGroupID = t.ChainGroupID
	Union
	Select t.ChainGroupID, t.ChainGroupName, t.ParentChainGroupID, t.SequenceOrder, PromotionCount
	From (
		Select t.ParentChainGroupID ChainGroupID, Sum(PromotionCount) PromotionCount
		From RealCGCount r
		Join PreCal.ChainGroupTree t on r.ChainGroupID = t.ChainGroupID
		Where t.ParentChainGroupID is not null
		Group By t.ParentChainGroupID	
		Having Count(*) > 1   --- Reduce the single child to his parent
	) parentCount
	Join PreCal.ChainGroupTree t on parentCount.ChainGroupID = t.ChainGroupID

	Update @Output
	Set ParentChainGroupID = null
	Where ParentChainGroupID Not In (Select ChainGroupID From @Output)

	Select ChainGroupID, 
		ChainGroupName + '[' + Convert(varchar, ChainT) + ']'  ChainGroupName, 
		ParentChainGroupID, o.SequenceOrder, Max(PromotionCount) PromotionCount
	From @Output o
	Join (Select 1 SequenceOrder, 'N' ChainT Union Select 2, 'R' Union Select 3, 'L') t on o.SequenceOrder = t.SequenceOrder
	Group By ChainGroupID, ChainGroupName, ParentChainGroupID, o.SequenceOrder, ChainT
	Order By ChainGroupName

	If (@Debug = 1)
	Begin
		Select '---- Promotion ChainGroups and parent chaingroups retrived ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

End



---##################

Print '--- All Steps executed ---'
Print '---> Utility procs for testing pages ---'
Go

---##################
If Exists (Select * From sys.procedures Where object_id = object_id('Playbook.pGetBCLocationTree'))
	Drop Proc Playbook.pGetBCLocationTree
Go

Set QUOTED_IDENTIFIER ON
GO

Create Proc Playbook.pGetBCLocationTree
AS
Begin
	Set NoCount On;

	Select '0All' NodeID, 'All Systems' NodeName, '#' ParentID
	Union
	Select '1S' + Convert(varchar, SystemID) NodeID, SystemName NodeName, '0All' ParentID
	From BC.System Where SystemID in (5,6,7)
	Union
	Select '2Z' + Convert(Varchar, ZoneID) NodeID, ZoneName NodeName, '1S' + Convert(varchar, s.SystemID) ParentID
	From BC.Zone z Join BC.System s on z.SystemID = s.SystemID Where s.SystemID in (5,6,7)
	Union
	Select Distinct '3D' + Convert(Varchar, d.DivisionID) NodeID, d.DivisionName NodeName, '2Z' + Convert(varchar, d.ZoneID) ParentID
	From PreCal.BottlerHier h Join BC.Division d on h.DivisionID = d.DivisionID
	Union
	Select Distinct '4R' + Convert(Varchar, r.RegionID) NodeID, r.RegionName NodeName, '3D' + Convert(varchar, r.DivisionID) ParentID
	From PreCal.BottlerHier h Join BC.Region r on h.RegionID = r.RegionID
	Union
	Select Distinct '5B' + Convert(Varchar, b.BottlerID) NodeID, b.BottlerName NodeName, '4R' + Convert(varchar, h.RegionID) ParentID
	From PreCal.BottlerHier h Join BC.Bottler b on h.BottlerID = b.BottlerID
	Order By NodeName
End
Go

---##################
If Exists (Select * From sys.procedures Where object_id = object_id('Playbook.pGetChainGroupsFromBCPromos'))
	Drop Proc Playbook.pGetChainGroupsFromBCPromos
Go

Set QUOTED_IDENTIFIER ON
GO

Create Proc Playbook.pGetChainGroupsFromBCPromos
(
	@SystemIDs nvarchar(4000) = '',
	@ZoneIDs nvarchar(4000) = '',
	@DivisionIDs nvarchar(4000) = '',
	@RegionIDs nvarchar(4000) = '',
	@BottlerIDs nvarchar(4000) = '',
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

		Select '---- Starting ----' Debug, @SystemIDs BUIDs, @ZoneIDs ZoneIDs, @DivisionIDs DivisionIDs, @RegionIDs RegionIDs, @BottlerIDs BottlerIDs, @Date StartDate
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
	Declare @PromoGroups Table 
	(
		PromotionID int,
		ChainGroupID varchar(20),
		Primary Key(PromotionID ASC, ChainGroupID ASC)
	)

	Insert Into @PromoGroups
	Select Distinct pb.PromotionID, pb.ChainGroupID
	From
	PreCal.PromotionRegionChainGroup pb with (nolock)
	Join @RegionIDsTable brds On pb.RegionID = brds.RegionID
	Where pb.PromotionStartDate <= @EndDate And pb.PromotionEndDate > @StartDate -- @EndDate is inclusive, See promotion 34605 for details, 1-1 is not valid for that one
	And pb.IsPromotion = 1
	Union
	Select Distinct pb.PromotionID, pb.ChainGroupID
	From
	PreCal.PromotionBottlerChainGroup pb with (nolock)
	Join @BottlerIDsTable brds On pb.BottlerID = brds.BottlerID
	Where pb.PromotionStartDate <= @EndDate And pb.PromotionEndDate > @StartDate -- @EndDate is inclusive, See promotion 34605 for details, 1-1 is not valid for that one
	And pb.IsPromotion = 1

	If (@Debug = 1)
	Begin
		Select '---- Promotions With ChainGroup associated filtered by locations ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select * From @PromoGroups
	End;

	Declare @Output Table
	(
		ChainGroupID varchar(20) not null, 
		ChainGroupName varchar(100) not null,
		ParentChainGroupID varchar(20), 
		SequenceOrder int,
		PromotionCount int
	);

	If (@Debug = 1)
	Begin
		Select '---- Promotion ChainGroups and parent chaingroups retrived ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds;

		With RealCGCount As
		(
			Select ChainGroupID, Count(*) PromotionCount
			From @PromoGroups
			Group By ChainGroupID
		)
		Select t.ChainGroupID, t.ChainGroupName, t.ParentChainGroupID, t.SequenceOrder, PromotionCount
		From RealCGCount r
		Join PreCal.ChainGroupTree t on r.ChainGroupID = t.ChainGroupID
		Order By ChainGroupName

	End;
	
	With RealCGCount As
	(
		Select ChainGroupID, Count(*) PromotionCount
		From @PromoGroups
		Group By ChainGroupID
	)

	Insert Into @Output(ChainGroupID, ChainGroupName, ParentChainGroupID, SequenceOrder, PromotionCount)
	Select t.ChainGroupID, t.ChainGroupName, t.ParentChainGroupID, t.SequenceOrder, PromotionCount
	From RealCGCount r
	Join PreCal.ChainGroupTree t on r.ChainGroupID = t.ChainGroupID
	Union
	Select t.ChainGroupID, t.ChainGroupName, t.ParentChainGroupID, t.SequenceOrder, PromotionCount
	From (
		Select t.ParentChainGroupID ChainGroupID, Sum(PromotionCount) PromotionCount
		From RealCGCount r
		Join PreCal.ChainGroupTree t on r.ChainGroupID = t.ChainGroupID
		Where t.ParentChainGroupID is not null
		Group By t.ParentChainGroupID	
		Having Count(*) > 1   --- Reduce the single child to his parent
	) parentCount
	Join PreCal.ChainGroupTree t on parentCount.ChainGroupID = t.ChainGroupID

	Update @Output
	Set ParentChainGroupID = null
	Where ParentChainGroupID Not In (Select ChainGroupID From @Output)

	Select ChainGroupID, 
		ChainGroupName + '[' + Convert(varchar, ChainT) + ']'  ChainGroupName, 
		ParentChainGroupID, o.SequenceOrder, Max(PromotionCount) PromotionCount
	From @Output o
	Join (Select 1 SequenceOrder, 'N' ChainT Union Select 2, 'R' Union Select 3, 'L') t on o.SequenceOrder = t.SequenceOrder
	Group By ChainGroupID, ChainGroupName, ParentChainGroupID, o.SequenceOrder, ChainT
	Order By ChainGroupName

	If (@Debug = 1)
	Begin
		Select '---- Promotion ChainGroups and parent chaingroups retrived ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

End

Go

---##################
If Exists (Select * From sys.procedures Where object_id = object_id('Playbook.pGetBCPromotionsForLocCgStartDate'))
	Drop Proc Playbook.pGetBCPromotionsForLocCgStartDate
Go

Set QUOTED_IDENTIFIER ON
GO

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

Print ''
Print 'Server Name:' + @@ServerName
Print 'Database Name:' + DB_Name()
Print '*** All Stored Procedure changes performed ***'
Go

------------------------- TESTING -----------------------
------------------------- TESTING -----------------------
------------------------- TESTING -----------------------
------------------------- TESTING -----------------------
--Select *
--From Playbook.RetailPromotion
--Where PromotionName like '%Glob%'

--Declare @PromotionID int
--Set @PromotionID = 64375

--	Delete From PreCal.PromotionLocalChain Where PromotionID = @PromotionID

--	Insert Into Precal.PromotionLocalChain(PromotionID, LocalChainID, PromotionStartDate, PromotionEndDate, IsPromotion)
--	Select p.PromotionID, LocalChainID, rp.PromotionStartDate, rp.PromotionEndDate, Case When rp.InformationCategory = 'Promotion' Then 1 Else 0 End
--	From Playbook.PromotionAccount p With (nolock)
--	Join Playbook.RetailPromotion rp on p.PromotionID = rp.PromotionID
--	Where Coalesce(LocalChainID, 0) > 0
--	And rp.PromotionID = @PromotionID
--	Union
--	Select pa.PromotionID, lc.LocalChainID, PromotionStartDate, PromotionEndDate, Case When InformationCategory = 'Promotion' Then 1 Else 0 End
--	From Playbook.PromotionAccount pa With (nolock)
--	Join SAP.LocalChain lc on(pa.RegionalChainID = lc.RegionalChainID) 
--	Join Playbook.RetailPromotion rp on pa.PromotionID = rp.PromotionID
--	Where Coalesce(pa.RegionalChainID, 0) > 0
--	And rp.PromotionID = @PromotionID
--	Union
--	Select pa.PromotionID, rc.LocalChainID, PromotionStartDate, PromotionEndDate, Case When InformationCategory = 'Promotion' Then 1 Else 0 End
--	From Playbook.PromotionAccount pa With (nolock)
--	Join PreCal.ChainHier rc on pa.NationalChainID = rc.NationalChainID
--	Join Playbook.RetailPromotion rp on pa.PromotionID = rp.PromotionID
--	And Coalesce(pa.NationalChainID, 0) > 0
--	And rp.PromotionID = @PromotionID

--		Delete From PreCal.PromotionChainGroup Where PromotionID = @PromotionID;
	
--	With PromotionRegionalChain As
--	(
--		Select pa.PromotionID, pa.RegionalChainID
--		From Playbook.PromotionAccount pa With (nolock)
--		Where PromotionID = @PromotionID And Coalesce(pa.RegionalChainID, 0) > 0
--		Union
--		Select Distinct pa.PromotionID, rc.RegionalChainID
--		From Playbook.PromotionAccount pa With (nolock)
--		Join PreCal.ChainHier rc on pa.NationalChainID = rc.NationalChainID
--		Join Playbook.RetailPromotion rp on pa.PromotionID = rp.PromotionID
--		And pa.PromotionID = @PromotionID
--		And Coalesce(pa.NationalChainID, 0) > 0
--	)

--	Insert PreCal.PromotionChainGroup(PromotionID, ChainGroupID)
--	Select Distinct PromotionID, ChainID
--	From PreCal.PromotionLocalChain plc
--	Join MSTR.RevChainImages rci on (plc.LocalChainID = rci.LocalChainID)
--	Where PromotionID = @PromotionID
--	Union
--	Select Distinct PromotionID, ChainID
--	From PromotionRegionalChain plc
--	Join MSTR.RevChainImages rci on (plc.RegionalChainID = rci.RegionalChainID And rci.ChainID Like 'R%')
--	Where PromotionID = @PromotionID
--	Union
--	Select Distinct PromotionID, ChainID
--	From PlayBook.PromotionAccount pa
--	Join PreCal.ChainHier ch on pa.LocalChainID = ch.LocalChainID
--	Join MSTR.RevChainImages rci on (ch.NationalChainID = rci.NationalChainID And rci.ChainID Like 'N%')
--	Where PromotionID = @PromotionID


--exec Playbook.pSaveDSDPromotion @PromotionID = 64375, @Debug = 1

--Select Distinct PromotionID From PreCal.PromotionBranch
--Where PromotionID >= 64375

--Select *
--From Playbook.RetailPromotion
--Where PromotionID >= 64375

