Use Portal_Data
Go

-- deployed to 108 ---

------------------------------------------------
If Exists (
	Select *
	From Sys.Tables
	Where Name = 'PromotionBranch')
Begin
	Drop Table Playbook.PromotionBranch
End
Go

CREATE TABLE Playbook.PromotionBranch (
	[BranchID] [int] NOT NULL,
	[PromotionID] [int] NOT NULL,
	PromotionStartDate Date,
	PromotionEndDate Date,
 CONSTRAINT [PK_PromotionBranch100] PRIMARY KEY CLUSTERED 
(
	[BranchID] ASC,
	[PromotionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

Go

CREATE NONCLUSTERED INDEX [NCI-PromotionBranch-Dates] ON [Playbook].[PromotionBranch]
(
	[PromotionStartDate] ASC,
	[PromotionEndDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

Create Proc Playbook.pReMapDSDPromotions
(
	@BackToDate Date = null,
	@Debug bit = 0
)
AS
Begin
	Set NoCount On;

	If (@BackToDate is null)
	Begin
		Set @BackToDate = DateAdd(Year, -2, GetDate())
	End

	If (@Debug = 1)
	Begin
		Declare @StartTime DateTime2(7)
		Set @StartTime = SYSDATETIME()

		Select '---- Starting ----' Debug, @BackToDate BackToDate
	End

	---- Create Hier table for location expansion
	Create Table #Hier 
	(
		BUID int,
		RegionID int,
		AreaID int,
		BranchID int,
		StateRegionID int
	)

	Insert into #Hier(BUID, RegionID, AreaID, BranchID)
	Select lh.BUID, lh.RegionID, lh.AreaID, lh.BranchID
	From MView.LocationHier lh

	Update h
	Set h.StateRegionID = sr.StateRegionID
	From #Hier h
	Join SAP.Branch b on h.BranchID = b.BranchID
	Join Shared.StateRegion sr on sr.RegionABRV = b.State

	If (@Debug = 1)
	Begin
		Select '---- Creating Hierachy table for looking up----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select h.*, b.BranchName, b.State, sr.RegionName StateName From #Hier h Join SAP.Branch b on h.BranchID = b.BranchID Join Shared.StateRegion sr on sr.StateRegionID = h.StateRegionID
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
		TYP int
	)

	Insert Into #PromoGeoR
	Select pgr.PromotionID, BUID, RegionID, AreaID, BranchID, StateID, 
		Case When (Coalesce(BUID, 0) > 0
		Or Coalesce(RegionID, 0) > 0
		Or Coalesce(AreaID, 0) > 0
		Or Coalesce(BranchID, 0) > 0) Then 1 Else 0 End HierDefined, 
		Case When (Coalesce(StateID, 0) > 0) Then 1 Else 0 End StateDefined,
		1 TYP 
	From Playbook.PromotionGeoRelevancy pgr
	Join Playbook.RetailPromotion rp on pgr.PromotionID = rp.PromotionID
	Where rp.PromotionEndDate > @BackToDate
	And (
		Coalesce(BUID, 0) > 0
		Or Coalesce(RegionID, 0) > 0
		Or Coalesce(AreaID, 0) > 0
		Or Coalesce(BranchID, 0) > 0
		Or Coalesce(StateID, 0) > 0
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

	Insert Into #PromoGeoR(PromotionID, BUID, TYP)
	Select PromotionID, BUID, 6
	From SAP.BusinessUnit,
	(Select Distinct PromotionID From #PromoGeoR Where TYP = 4) Temp

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
	Join #Hier v on pgr.BUID = v.BUID
	Where TYP = 3
	Union
	Select Distinct pgr.PromotionID, v.BranchID
	from #PromoGeoR pgr
	Join #Hier v on pgr.RegionId = v.RegionId
	Where TYP = 3 And pgr.BUID is null
	Union
	Select Distinct pgr.PromotionID, v.BranchID
	from #PromoGeoR pgr
	Join #Hier v on pgr.AreaId = v.AreaId
	Where TYP = 3 And pgr.BUID is null And pgr.RegionId is null
	Union
	Select pgr.PromotionID, pgr.BranchID
	From #PromoGeoR pgr
	Where TYP = 3 And pgr.BranchID Is Not Null

	If (@Debug = 1)
	Begin
		Select '---- Type 3 Expanded ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select Count(*) NumberOfPromoBranchesForType2 From #PGR
	End

	-- State & Hier
	Insert Into #PGR(PromotionID, BranchID)
	Select r.PromotionID, r.BranchID
	From (
		Select Distinct pgr.PromotionID, v.BranchID
		From #PromoGeoR pgr
		Join #Hier v on pgr.BUID = v.BUID
		Where TYP = 2
		Union
		Select Distinct pgr.PromotionID, v.BranchID
		from #PromoGeoR pgr
		Join #Hier v on pgr.RegionId = v.RegionId
		Where TYP = 2 And pgr.BUID is null
		Union
		Select Distinct pgr.PromotionID, v.BranchID
		from #PromoGeoR pgr
		Join #Hier v on pgr.AreaId = v.AreaId
		Where TYP = 2 And pgr.BUID is null And pgr.RegionId is null
		Union
		Select pgr.PromotionID, pgr.BranchID
		From #PromoGeoR pgr
		Where TYP = 2 And pgr.BranchID Is Not Null
	) l
	Join (
		Select PromotionID, h.BranchID
		From #PromoGeoR pgr
		Join #Hier h on pgr.StateID = h.StateRegionID
		Where TYP = 2) r On l.PromotionID = r.PromotionID And l.BranchID = r.BranchID
	
	If (@Debug = 1)
	Begin
		Select '---- Expansion done ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		--Select PromotionID, Count(*) NumberOfBranches From #PGR Group By PromotionID 
		Select Count(*) NumberOfPromoBranchesForType2And3 From #PGR
	End

	--- Filtering
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	Select Distinct pgr.*
	Into #PGR1
	From MView.BranchBrand bb, -- Promotion Brand Association
	(
		Select Distinct PromotionID, b.BrandID
		From Playbook.PromotionBrand pb With (nolock)
		Join SAP.Brand b on (pb.TrademarkID = b.TrademarkID)
		Union
		Select PromotionID, BrandID
		From Playbook.PromotionBrand With (nolock) Where Coalesce(TradeMarkID,0) = 0 
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

	Select Distinct pgr.*
	Into #PGR2
	From 	
	#PGR1 pgr, -- Promotion Geo
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
	) pc, --- Promotion Chain
	Shared.tLocationChain tlc
	Where pgr.BranchID = tlc.BranchID
	And tlc.LocalChainID = pc.LocalChainID
	And pc.PromotionID = pgr.PromotionID

	If (@Debug = 1)
	Begin
		Select '---- Promotion further filtered further by Chains ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select Count(*) NumberOfPromoBranches From #PGR2
	End
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	-- Commiting
	Truncate Table Playbook.PromotionBranch

	Insert Into Playbook.PromotionBranch(BranchID, PromotionID, PromotionStartDate, PromotionEndDate)
	Select pgr.BranchID, pgr.PromotionID, rp.PromotionStartDate, rp.PromotionEndDate
	From #PGR2 pgr
	Join Playbook.RetailPromotion rp on pgr.PromotionID = rp.PromotionID

	If (@Debug = 1)
	Begin
		Select '---- All done ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select Count(*) Cnt From Playbook.PromotionBranch
		Select Count(Distinct PromotionID) PromoCnt From Playbook.PromotionBranch
		Select Count(Distinct BranchID) BranchCnt From Playbook.PromotionBranch
		Select Min(PromotionEndDate) MinPromotionEndDate From Playbook.PromotionBranch
	End

End

Go

Exec Playbook.pReMapDSDPromotions
Go

Drop Proc Playbook.pReMapDSDPromotions
Go

--------------------------------------------
If Exists (Select * From sys.procedures Where object_id = object_id('Playbook.pGetDSDPromotionsForBranches'))
	Drop Proc Playbook.pGetDSDPromotionsForBranches
Go

SET QUOTED_IDENTIFIER ON
GO

/*
exec Playbook.pGetDSDPromotionsForBranches @BranchIDs = '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,167,168,169,170,172,173,174,175,176,177,178,179'
										  ,@Debug = 1
										  ,@StartDate = '2015-1-1'
										  ,@EndDate = '2015-4-1'


*/
Go
Create Proc Playbook.pGetDSDPromotionsForBranches
(
	@BranchIDs nvarchar(4000) = '',
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

		Select '---- Starting ----' Debug, @BranchIDs BranchIDs, @StartDate StartDate, @EndDate EndDate
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
									,@BranchIDs BranchIDs, @StartDate StartDate, @EndDate EndDate
	End

	Select Distinct PromotionID, PromotionStartDate, PromotionEndDate
	Into #PromotionIDs
	From
	Playbook.PromotionBranch pb with (nolock)
	Join dbo.Split(@BranchIDs, ',') brds On pb.BranchID = brds.Value
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
	FROM playbook.retailpromotion rp With (nolock)
	Join #PromotionIDs pb with (nolock) on pb.PromotionID = rp.PromotionID 
	Join playbook.promotioncategory pc With (nolock) ON rp.promotioncategoryid = pc.promotioncategoryid

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

End

Go
