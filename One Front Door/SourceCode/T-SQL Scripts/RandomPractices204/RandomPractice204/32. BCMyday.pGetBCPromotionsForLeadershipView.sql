USE Portal_Data
GO

If Exists (Select * From sys.procedures Where object_id = object_id('BCMyday.pGetBCPromotionsForLeadershipView'))
	Drop Proc BCMyday.pGetBCPromotionsForLeadershipView
Go

SET QUOTED_IDENTIFIER ON
GO

/*
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'ACKTD001' --Regional Sales manager IPDX
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'ADACX010' --RCI Manager
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'ALBDX003' --Regional Sales Manager CT_ME_VT_NH
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'ALBSX006' --VP IT Commercial & Latin America
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'ANDMX003' --Regional Sales Manager IWIS
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'ANDSX516' --Regional Sales Manager CCBCC Carolinas
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'ANGTX003' --Regional Sales Manager IPRM
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'AVABX001' --Divisional Sales Manager New York
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'BARJX603' --Regional Sales Manager
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'BARRX033' --Regional Sales Sr Manager ISO
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'BERDX002' --SVP Sales PASO
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'BERKX005' --Commercial Sales Manager
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'BETTX001' --Regional Sales Manager Salk Lake City
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'BIEJX002' --Sales Technology Manager Retailer Comms
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'BLASX008' --Commercial Sales Manager
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'BOEPX001' --Regional Sales Manager AL
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'BOHSX001' --VP Sales PASO West
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'BOLFX001' --Divisional Sales Manager IRA Central
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'BONJX002' --Regional Sales Manager INWO
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'BRIJX004' --Divisional Sales Manager Southeast
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'BUERX002' --Regional Sales Manager IHDS
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'BUIGS001' --Regional Sales Manager Mid South
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'BUTJX004' --VP Sales Development
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'BUXBX001' --Regional Sales Manager ISOC
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'CALDX002' --Regional Sales Manager Seattle
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'CARPX002' --Regional Sales Manager Philadelphia
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'CHATX003' --Commercial Sales Manager
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'CHEPX008' --IT Manager Business Information Portal
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'CIVJX001' --Regional Sales Manager INCN
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'CLABX010' --Field Marketing Manager
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'COCCA001' --Field Marketing Manager
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'COLGX001' --Regional Sales Manager Great Lakes
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'CONVX002' --Regional Sales Manager IDVP
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'CORCM001' --RCI Manager
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'CRAMG001' --Territory Sales Manager
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'CROPX003' --National Accounts Executive Grocery
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'DAVAX001' --Regional Sales Manager
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'DAVBX003' --Regional Sales Manager Abilene
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'DAVSX533' --Regional Sales Manager AL
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'DAYDX003' --IT Manager DSD West BU
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'DELDX001' --Regional Sales Manager IBWA
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'DESJX002' --Regional Sales Manager Minneapolis
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'DOWMX009' --Field Marketing Manager CSD
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'DOYPF001' --Regional Sales Manager ICHA
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'DURJX510' --Regional Sales Manager NoCal
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'ENTMX001' --Regional Sales Manager IGBP
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'ESPJX511' --Regional Sales Manager INLA
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'FARPV001' --Regional Sales Manager IWID
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'FLOMX001' --Regional Sales Manager Oklahoma
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'FOSTD001' --Regional Sales Manager IBAP
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'FOWJX003' --Regional Sales Manager Nashville
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'FOXKX001' --Divisional Sales Manager IPW
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'GALMX006' --Divisional Sales Manager IMW
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'GIBDX002' --Regional Sales Manager Ozarks
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'GOLCX001' --Regional Sales Manager IHDN
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'GRAWX002' --Regional Sales Manager Boston
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'GREBX018' --Divisional Sales Manager Midwest
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'GRZFM001' --Regional Sales Manager Baltimore
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'HALDC001' --Divisional Sales Manager Midwest
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'HARKX073' --RCI Manager
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'HARTX005' --Regional Sales Manager S Western
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'HEIRX001' --Regional Account Executive
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'HOSJX001' --Regional Sales Manager IMIC
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'HOVEM001' --NAE Grocery Target SuperValu
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'IVECX002' --Regional Sales Manager Portland
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'JELJX001' --Regional Sales Manager IDAV
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'johjx001' --President Bev Con & Latin America Bev
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'JORJX010' --Field Marketing Manager
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'JORPX005' --Dir Sales ISO Field Marketing
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'KLEBX003' --Commercial Sales Manager
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'KUHMJ001' --Regional Sales Manager
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'LABJX001' --Divisional Sales Manager ICW
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'LECLX001' --Divisional Sales Manager ISO
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'LOCDM001' --Regional Sales Manager IPHX
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'LOPEX002' --Regional Sales Manager ICDN
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'LOYMX003' --Regional Sales Manager Tulsa
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'LUKLX001' --Regional Sales Manager IMPC
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'MALBX001' --Divisional Sales Manager Southeast FL
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'MAYJX005' --Regional Sales Manager Marion
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'MCCLX005' --Regional Sales Manager IPEN
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'MCCWX001' --Divisional Sales Manager IHN IHP
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'MCDSX005' --Divisional Sales Manager Heartland
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'MCEDX003' --Divisional Sales Manager Midwest OH
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'MCFBX001' --Regional Sales Manager IPOE
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'MCIMX001' --Regional Sales Manager IWWA
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'MEAMX003' --Regional Sales Manager IPDX
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'MELAX012' --Regional Sales Manager New England
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'METHX002' --Regional Sales Manager UT Rockies
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'MILMJ001' --Regional Sales Manager SC
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'MONJX001' --Regional Sales Manager ISEAAOM
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'MORGX013' --Regional Sales Manager IDVC
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'MORSX034' --Regional Sales Manager Texas
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'MOUDX001' --Regional Sales Manager Midwest
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'ORGJX003' --Regional Sales Manager Atlanta
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'OROVX002' --Regional Sales Manager SoCal
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'PAASX001' --VP Rapid Continuous Improvement
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'PARRX003' --Sales Planning Manager IBS
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'PFAKX001' --Regional Sales Manager ITUC
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'PIECX001' --VP CASO National Retail Accounts
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'PITDX002' --VP Sales PASO East
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'PLUPX001' --VP Sales PASO
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'RELFX001' --Divisional Sales Manager IHM
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'ROOVX001' --Regional Sales Manager W VA
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'ROYJX503' --Regional Sales Manager IPOC
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'ROYMX002' --Regional Sales Manager SoCal
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'ROZAX001' --Regional Sales Manager Orlando
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'RUBSX001' --Dir Sales Operations Capstone
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'RUOWX001' --Regional Sales Manager INPR
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'SANMX001' --Regional Sales Manager ICON
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'SCHDX003' --Regional Sales Manager Ohio
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'SCHJA001' --Regional Sales Manager CCE Gulf
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'SCHMX002' --Regional Sales Manager Miami
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'SEARX001' --Regional Sales Manager S Texas
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'SHAJX002' --National Accounts Executive Grocery
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'SINSX003' --VP Sales CASO West
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'SIRCX001' --Regional Sales Manager IWMA
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'SKOTX001' --Regional Sales Manager Kansas City
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'SOPBX001' --Regional Sales Manager CASO
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'SPRAX001' --SVP Sales CASO
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'STABX002' --Divisional Sales Manager West
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'STIBX002' --Regional Sales Manager INYS
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'STIDX002' --Divisional Sales Manager MidAtlantic MD
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'STRRX001' --Field Marketing Manager
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'STRTX003' --Regional Sales Manager West Texas
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'SULJX005' --Regional Sales Manager IWAS
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'TAYMX517' --RCI Manager
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'THODX014' --Sales Planning Manager Lg Format
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'THOSX003' --Divisional Sales Manager Denver
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'TODJX001' --Regional Sales Manager Indiana
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'TOLLX004' --National Account Executive CASO
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'TREJX003' --Divisional Sales Manager North
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'TUGJL001' --Regional Sales Manager Atlanta
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'UTKMX001' --Divisional Sales Manager West
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'WALJX003' --Regional Sales Manager INNJ
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'WATBX001' --SVP & GM ISO
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'WELJX008' --Divisional Sales Manager Dallas
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'WILBX007' --Regional Sales Manager SD LV

----  These people have all 3 system(>80 Regions) and are the ultimate test cases -----
ALBSX006	Albright	VP IT Commercial & Latin America
BIEJX002	Bien		Sales Technology Manager Retailer Comms
BUTJX004	Butter		VP Sales Development
CHEPX008	Cherthedath	IT Manager Business Information Portal
DODDX001	Dodge		SVP National Accounts
JOHJX001	Johnston	President Bev Con & Latin America Bev
RUBSX001	Rubin		Dir Sales Operations Capstone
WALSC001	Walker		Dir IT National Accounts & WD

--- All the people direct report to Jim Johnson ----
BAYAX001	Bayfield	SVP Canada and International
BERDX002	Berghorn	SVP Sales PASO
BUTJX004	Butter		VP Sales Development
gyskx001	Gyssler		Executive Assistant to President
JOHSX001	Johnson		SVP & GM Fountain Foodservice
MAGMX002	Magro		VP Sales & Marketing Mexico
MAIRX001	Maiella	Jr	VP Customer Info and Licensing
malgx009	Maldonado	Director General Mexico
sprax001	Springate	SVP Sales CASO
WATBX001	Watterson	SVP & GM ISO



exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'BUTJX004', @Debug = 1
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'BERDX002', @Debug = 1
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'sprax001', @Debug = 1
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'WATBX001', @Debug = 1
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'ALBDX003', @Debug = 1

exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'ALBDX003'


------- Jim Johnson
Declare @StartDate DateTime2(7)
Declare @EndDate DateTime2(7)

Set @StartDate = SYSDATETIME()
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'ALBSX006', @Debug = 1
--exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'ALBSX006', @LastModified = '2015-07-18'
Set @EndDate = SYSDATETIME()
Select DateDiff(MICROSECOND, @StartDate, @EndDate)
Go

------- RSM
Declare @StartDate DateTime2(7)
Declare @EndDate DateTime2(7)

Set @StartDate = SYSDATETIME()
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'ALBDX003', @Debug = 1
Set @EndDate = SYSDATETIME()
Select DateDiff(MICROSECOND, @StartDate, @EndDate)
Go

------- ISO SVP
Declare @StartDate DateTime2(7)
Declare @EndDate DateTime2(7)

Set @StartDate = SYSDATETIME()
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'WATBX001', @Debug = 1
Set @EndDate = SYSDATETIME()
Select DateDiff(MICROSECOND, @StartDate, @EndDate)
Go

------- CASO SVP
Declare @StartDate DateTime2(7)
Declare @EndDate DateTime2(7)

Set @StartDate = SYSDATETIME()
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'sprax001', @Debug = 1
Set @EndDate = SYSDATETIME()
Select DateDiff(MICROSECOND, @StartDate, @EndDate)
Go

------- PASO SVP
Declare @StartDate DateTime2(7)
Declare @EndDate DateTime2(7)

Set @StartDate = SYSDATETIME()
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'BERDX002', @Debug = 1
Set @EndDate = SYSDATETIME()
Select DateDiff(MICROSECOND, @StartDate, @EndDate)
Go

---- For Comparisons w/ existing logics ----
exec BCMyday.pGetPromotionsByRegionID @BCRegionID = 18, @LastModified = '2015-07-20'
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'ALBDX003', @LastModified = '2015-07-20', @Debug = 1

exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'ALBDX003', @LastModified = '', @Debug = 1
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'ALBDX003', @Debug = 1

--- 
*/

Create Proc [BCMyday].[pGetBCPromotionsForLeadershipView]
(
	@GSN Varchar(50), 
	@LastModified DateTime = null,
	@Debug bit = 0
)
AS
BEGIN
	Set NoCount On;
	
	--- If parameter is set to be '', then it'll get converted to be the default value of DateTime '1900-1-1'
	Print 'Processing parameters'
	If (@LastModified = '1900-1-1')
		Set @LastModified = null

	If (@Debug is null)
		Set @Debug = 0
	
	If (@Debug = 1)
	Begin
		Declare @StartTime DateTime2(7)
		Set @StartTime = SysDateTime()
		Select '---- Input Parameters ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		
		Select @GSN GSN, Title, FirstName, LastName, @LastModified LastModifiedParameter, @Debug DebugFlagParameter, @@SERVERNAME [Server], DB_NAME() [Database]
		From Person.UserProfile Where GSN = @GSN

		Select g.GSN, r.RegionID, r.RegionName From BC.tGSNRegion g Join BC.Region r on g.RegionID = r.RegionID Where GSN = @GSN
		Select BCRegionID, BottlerID, BottlerName From BC.tGSNRegion t Join BC.Bottler b on t.RegionID = b.BCRegionID Where GSN = @GSN
	End

	Declare @ApplicablePromoStatus Table
	(
		StatusID int
	)

	Insert Into @ApplicablePromoStatus Values(4)	--- The published status is always included.

	--- Differential Updates requires cancelled Promotions as well 
	If (@LastModified is not null)
		Insert Into @ApplicablePromoStatus Values(3)
	
	If (@Debug = 1)
	Begin
		Select '---- ApplicablePromoStatus ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select * From @ApplicablePromoStatus
	End

	---- Interested date range, driven by Configurations ----
	Declare @ConfigPStartDate DateTime, @ConfigPEndDate DateTime
	Select @ConfigPStartDate = dateadd(day,(Select convert(Int,value * -1) from bcmyday.config where [key] = 'PROMOTION_DOWNLOAD_DURATION_PAST'), getdate())
	Select @ConfigPEndDate = dateadd(day,(Select convert(Int,value)  from bcmyday.config where [key] = 'PROMOTION_DOWNLOAD_DURATION_FUTURE'), getdate())

	If (@Debug = 1)
	Begin
		Select '---- Start and End Date ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select @ConfigPStartDate ConfigPStartDate, @ConfigPEndDate ConfigPEndDate
	End
		
	--- For some reason, the temp table is working much faster then table variable
	--- Get all related promotions regardless of last modified
	Print 'Relate Promotions to Territoties'
	Select Distinct p.PromotionID, p.ModifiedDate, p.PromotionStartDate, p.PromotionEndDate
	Into #Promotion
	From Playbook.RetailPromotion p With (nolock),
	Playbook.PromotionGeoHier pgh With (nolock),
	BC.tGSNRegion gr With (nolock),
	(
		Select PromotionID, b.TrademarkID
		From Playbook.PromotionBrand  pb With (nolock)
		Join SAP.Brand b With (nolock) on (pb.BrandID = b.BrandID)
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
	BC.tRegionChainTradeMark tmap With (nolock),
	@ApplicablePromoStatus st
	Where (p.PromotionRelevantStartDate <= @ConfigPEndDate And p.PromotionRelevantEndDate >= @ConfigPStartDate)
	And p.PromotionID = pgh.PromotionID
	And gr.GSN = @GSN
	And gr.RegionID = pgh.BCRegionID
	And ptm.PromotionID = p.PromotionID
	And pc.PromotionID = p.PromotionID
	And tmap.TerritoryTypeID <> 10
	And tmap.ProductTypeID = 1
	And tmap.TradeMarkID = ptm.TradeMarkID
	And tmap.LocalChainID = pc.LocalChainID
	And tmap.RegionID = gr.RegionID 
	And st.StatusID = p.PromotionStatusID
	-------------------------------------------------
	Union
	-------------------------------------------------
	Select Distinct p.PromotionID, p.ModifiedDate, p.PromotionStartDate, p.PromotionEndDate
	From Playbook.RetailPromotion p With (nolock),
	Playbook.PromotionGeoHier pgh With (nolock),
	BC.tGSNRegion gr With (nolock),
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
	@ApplicablePromoStatus st,
	BC.Bottler b With (nolock)
	Where (p.PromotionRelevantStartDate <= @ConfigPEndDate And p.PromotionRelevantEndDate >= @ConfigPStartDate)
	And p.PromotionID = pgh.PromotionID
	And gr.GSN = @GSN
	And b.BottlerID = pgh.BottlerID
	And b.BCRegionID = gr.RegionID
	And pgh.BCRegionID is null
	And ptm.PromotionID = p.PromotionID
	And pc.PromotionID = p.PromotionID
	And tmap.TerritoryTypeID <> 10
	And tmap.ProductTypeID = 1
	And tmap.TradeMarkID = ptm.TradeMarkID
	And tmap.LocalChainID = pc.LocalChainID
	And tmap.BottlerID = b.BottlerID
	And st.StatusID = p.PromotionStatusID

	If (@Debug = 1)
	Begin
		Select '---- Promotion temp table content before applying the Active/Modified filter ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select * From #Promotion Order By PromotionID ASC
	End

	--For delta downloads, need to send all active promtoion as well as date-delta
	If (@LastModified is not null)
	Begin
		Print 'Differential filters'
		Delete
		From #Promotion
		Where Not (
			--In Active Scope 
			PromotionStartDate between Playbook.fGetSunday(getDate()) and Playbook.fGetMonday(getDate())  
			or
			PromotionEndDate between Playbook.fGetSunday(getDate()) and Playbook.fGetMonday(getDate())
			or
			Playbook.fGetSunday(getDate()) BETWEEN PromotionStartDate AND PromotionEndDate
		) And
		ModifiedDate < Coalesce(@LastModified, '1900-01-01')	-- Not in Date-Delta

		If (@Debug = 1)
			Begin
				Select '---- After applying the Active/Modified filter ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
				Select * From #Promotion Order By PromotionID ASC
			End
	End

	----------- Outputs ------------
	If (@Debug = 1)
	Begin
		Select '---- Generating Output 1: Promotions ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

	Print 'Outputs'
	SELECT distinct rp.PromotionID 'PromotionID'
		,PromotionName 'PromotionName'
		,PromotionDescription 'Comment'
		,rp.PromotionStartDate 'InStoreStartDate'
		,rp.PromotionEndDate 'InStoreEndDate'
		,DisplayStartDate 'DisplayStartDate'
		,DisplayEndDate 'DisplayEndDate'
		,PricingStartDate 'PricingStartDate'
		,PricingEndDate 'PricingEndDate'
		,ForecastVolume 'ForecastedVolume'
		,NationalDisplayTarget 'NationalDisplayTarget'
		,PromotionPrice 'RetailPrice'
		,BottlerCommitment 'InvoicePrice'
		,pc.promotioncategoryname 'Category'
		,case pdl.DisplayRequirement when 1 then 'Mandatory' when 2 then 'Local Sell-In' else 'No Display' end as 'DisplayRequirement'
		,DisplayLocationID 'DisplayLocationID'
		,DisplayTypeID 'DisplayTypeID'
		,PromotionType 'PromotionType'
		,pdl.PromotionDisplayLocationOther 'DisplayComments'
		,0 'DisplayRequired'
		,pr.Rank [Priority]
		,rp.promotionstatusid [PromotionStatusID]
		,rp.CreatedDate , rp.ModifiedDate
		--,Case When InformationCategory = 'Promotion' Then 1 Else 0 end InformationCategory
		,InformationCategory
	FROM playbook.retailpromotion rp
	Join #Promotion pids on rp.PromotionID = pids.PromotionID 
	Join playbook.promotiontype pt ON rp.Promotiontypeid = pt.promotiontypeid
	Join playbook.promotioncategory pc ON rp.promotioncategoryid = pc.promotioncategoryid
	Join playbook.promotiondisplaylocation pdl ON rp.promotionid = pdl.promotionid
	left join [Playbook].[PromotionRank] pr on pr.promotionid = rp.PromotionID
		and 
			case when rp.PromotionEndDate < playbook.fGetMonday(getdate()) then  playbook.fGetSunday(rp.PromotionEndDate) 
				when rp.PromotionStartDate > playbook.fGetSunday(getdate()) then  playbook.fGetMonday(rp.PromotionStartDate)
				else playbook.fGetMonday(getDate())
			end = 
			case when rp.PromotionEndDate < playbook.fGetMonday(getdate()) then  pr.PromotionWeekEnd
				when rp.PromotionStartDate > playbook.fGetSunday(getdate()) then  pr.PromotionWeekStart 
				else pr.PromotionWeekStart
			end 
	Order By PromotionID

	If (@Debug = 1)
	Begin
		Select '---- Generating Output 2: Promotion Brands ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

	SELECT a.PromotionID 'PromotionID'
		,a.BrandID 'BrandID'
		,case when isnull(a.TrademarkID,0) = 0 then b.trademarkid else a.TrademarkID end 'TrademarkID'
	FROM playbook.promotionbrand a
	Join #Promotion pids on a.PromotionID = pids.PromotionID 
	left join sap.brand b on a.brandid = b.brandid
	Order By PromotionID, TrademarkID, BrandID

	If (@Debug = 1)
	Begin
		Select '---- Generating Output 3: Promotion Chains----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End
	SELECT a.PromotionID 'PromotionID',		
		case 
			when isnull(a.RegionalChainID ,0) <> 0  then
			(select nationalchainid from sap.regionalchain where RegionalChainID = a.RegionalChainID )
			when isnull(a.LocalChainID ,0) <> 0  then
			(select c.nationalchainid from sap.localchain b
			left join sap.regionalchain c on b.regionalchainid = c.regionalchainid
			where localchainid = a.localchainid )
			else a.nationalchainid
		end 'NationalChainID'
		,
		case when isnull(a.LocalChainID ,0) <> 0  then
			(select regionalchainid from sap.localchain where localchainid = a.localchainid )
		else a.RegionalChainID
		end 'RegionalChainID'
		,LocalChainID 'LocalChainID'
	FROM playbook.promotionaccount a
	Join #Promotion pids on a.PromotionID = pids.PromotionID 
	Order By PromotionID, NationalChainID, RegionalChainID, LocalChainID

	If (@Debug = 1)
	Begin
		Select '---- Generating Output 4: Promotion Attachments ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

	SELECT pa.PromotionID 'PromotionID'
		,AttachmentURL 'FileURL'
		,AttachmentName 'FileName'
		,AttachmentSize 'Size'
		,at.AttachmentTypeName 'Type'
		,pa.PromotionAttachmentID 'AttachmentID',
		pa.AttachmentDateModified 'ModifiedDate'
	FROM playbook.promotionattachment pa
	Join Playbook.AttachmentType at ON pa.AttachmentTypeID = at.AttachmentTypeID
	Join #Promotion pids on pa.PromotionID = pids.PromotionID 
	Order By PromotionID, AttachmentName

	If (@Debug = 1)
	Begin
		Select '---- Generating Output 5: Promotion States ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

	SELECT pa.PromotionID 'PromotionID',
		PackageID 
	FROM playbook.promotionpackage pa
	Join #Promotion pids on pa.PromotionID = pids.PromotionID 
	Order By PromotionID, PackageID

	If (@Debug = 1)
	Begin
		Select '---- Generating Output 6: Promotion States ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

	Select Distinct pgr.PromotionId, sr.RegionABRV StateAbrv
	From Playbook.PromotionGeoRelevancy pgr
	Join Shared.StateRegion sr on pgr.StateID = sr.StateRegionID
	Join #Promotion pids on pgr.PromotionID = pids.PromotionID 
	Order By PromotionID, StateAbrv

	If (@Debug = 1)
	Begin
		Select '---- Generating Output 7: Promotion Geo ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

	---- Get the Promotion to bc locations relationships -----
	Declare @PromoGeo Table
	(
		PromotionID int,
		AllSystems int,
		SystemID int,
		ZoneID int,
		DivisionID int,
		RegionID int,
		BottlerID int,
		StateID int,
		InferredBottlerPromotion bit
	)

	Insert Into @PromoGeo
	Select pgr.PromotionID,
		Case When 
		Coalesce(SystemID, 0) > 0
		Or Coalesce(ZoneID, 0) > 0
		Or Coalesce(DivisionID, 0) > 0
		Or Coalesce(BCRegionID, 0) > 0
		Or Coalesce(BottlerID, 0) > 0 Then null Else 1 End AllSystems, 
		pgr.SystemID, pgr.ZoneID, pgr.DivisionID, pgr.RegionID, pgr.BottlerID, pgr.StateID, 0
	From Playbook.PromotionGeoRelevancy pgr
	Join #Promotion p on pgr.PromotionId = p.PromotionID
	Where 
	Coalesce(SystemID, 0) > 0
	Or Coalesce(ZoneID, 0) > 0
	Or Coalesce(DivisionID, 0) > 0
	Or Coalesce(BCRegionID, 0) > 0
	Or Coalesce(BottlerID, 0) > 0
	Or Coalesce(StateID, 0) > 0

	If ((Select Count(*) From @PromoGeo Where Coalesce(StateID, 0) > 0 ) > 0)
	Begin
		Declare @Bottlers Table
		(
			AllSystems int,
			SystemID int, 
			ZoneID int, 
			DivisionID int, 
			RegionID int, 
			BottlerID int, 
			StateRegionID int
		)

		Insert Into @Bottlers
		Select 1, v.SystemID, v.ZoneID, v.DivisionID, v.RegionID, v.BottlerID, sr.StateRegionID
		From BC.vBCBottlerHier v
		Join BC.Bottler b on v.BottlerID = b.BottlerID
		Join Shared.StateRegion sr on b.State = sr.RegionABRV
		Where SystemID in (5, 6,7)

		Insert Into @PromoGeo(PromotionID, BottlerID, InferredBottlerPromotion) 
		Select pg.PromotionID, b.BottlerID, 1
		From @PromoGeo pg
		Join @Bottlers b on pg.AllSystems = b.AllSystems And pg.StateID = b.StateRegionID
		Where Coalesce(StateID, 0) > 0

		--- It's rare that the following cases are ever executed, code just there for possible data combination ---
		Insert Into @PromoGeo(PromotionID, BottlerID, InferredBottlerPromotion) 
		Select pg.PromotionID, b.BottlerID, 1
		From @PromoGeo pg
		Join @Bottlers b on pg.SystemID = b.SystemID And pg.StateID = b.StateRegionID
		Where Coalesce(StateID, 0) > 0

		Insert Into @PromoGeo(PromotionID, BottlerID, InferredBottlerPromotion) 
		Select pg.PromotionID, b.BottlerID, 1
		From @PromoGeo pg
		Join @Bottlers b on pg.ZoneID = b.ZoneID And pg.StateID = b.StateRegionID
		Where Coalesce(StateID, 0) > 0

		Insert Into @PromoGeo(PromotionID, BottlerID, InferredBottlerPromotion) 
		Select pg.PromotionID, b.BottlerID, 1
		From @PromoGeo pg
		Join @Bottlers b on pg.DivisionID = b.DivisionID And pg.StateID = b.StateRegionID
		Where Coalesce(StateID, 0) > 0

		Insert Into @PromoGeo(PromotionID, BottlerID, InferredBottlerPromotion) 
		Select pg.PromotionID, b.BottlerID, 1
		From @PromoGeo pg
		Join @Bottlers b on pg.RegionID = b.RegionID And pg.StateID = b.StateRegionID
		Where Coalesce(StateID, 0) > 0

		Insert Into @PromoGeo(PromotionID, BottlerID, InferredBottlerPromotion) 
		Select pg.PromotionID, b.BottlerID, 1
		From @PromoGeo pg
		Join @Bottlers b on pg.BottlerID = b.BottlerID And pg.StateID = b.StateRegionID
		Where Coalesce(StateID, 0) > 0

		Delete From @PromoGeo Where Coalesce(StateID, 0) > 0
	End

	If (@Debug = 1)
	Begin
		Select '---- Upward fill @PromoGeo relations ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

	---- Upward fill @PromoGeo relations
	Update pg
	Set pg.RegionID = bh.RegionID, pg.DivisionID = bh.DivisionID, pg.ZoneID = bh.ZoneID, pg.SystemID = bh.SystemID
	From @PromoGeo pg
	Join BC.vBCBottlerHier bh on pg.BottlerID = bh.BottlerID

	Update pg
	Set pg.DivisionID = bh.DivisionID, pg.ZoneID = bh.ZoneID, pg.SystemID = bh.SystemID
	From @PromoGeo pg
	Join BC.vBCSalesHier bh on pg.RegionID = bh.RegionID

	Update pg
	Set pg.ZoneID = d.ZoneID, pg.SystemID = z.SystemID
	From @PromoGeo pg
	Join BC.Division d on pg.DivisionID = d.DivisionID
	Join BC.Zone z on d.ZoneID = z.ZoneID

	Update pg
	Set pg.SystemID = z.SystemID
	From @PromoGeo pg
	Join BC.Zone z on pg.ZoneID = z.ZoneID

	--- Output @PromoGeo relations
	Select PromotionID, SystemID, ZoneID, DivisionID, RegionID, BottlerID 
	From @PromoGeo

	If (@Debug = 1)
	Begin
		Select '---- All done. Here is the more info in PromoGeo ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select * From @PromoGeo
	End

End

Go

--Create Table dbo.BCPromoLeader
--(
--	PromotionID int
--)

--Create Table dbo.BCLeader2
--(
--	PromotionID int
--)

--- 54575, 54580 ---
--exec BCMyday.pGetPromotionsByRegionID2 @BCRegionID = 18, @LastModified = '2015-07-20'

--exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'ALBDX003', @LastModified = '2015-07-20'

--Select *
--From Playbook.PromotionGeoRelevancy
--Where PromotionID in 
--(
--	Select PromotionID From dbo.BCPromoRegion
--	Where PromotionID not In (Select PromotionID From dbo.BCPromoLeader)
--)

--Select *
--From Playbook.PromotionAccount
--Where PromotionID = 54575

--Select *
--From SAP.LocalChain
--Where LocalChainID = 2649

--Select BrandName, br.TrademarkID
--From Playbook.PromotionBrand b
--Join SAP.Brand br on b.BrandID = br.BrandID
--Where PromotionID = 54575

--Select *
--From Shared.StateRegion
--Where StateRegionID in (23, 38, 56)

--Select *
--From BC.Bottler
--Where State in ('CT', 'MA', 'RI')
--And BCRegionID = 18

--Select *
--From BC.tBottlerChainTradeMark
--Where BottlerID = 1389
--And LocalChainID = 2649

--Select BrandName, br.TrademarkID
--From Playbook.PromotionBrand b
--Join SAP.Brand br on b.BrandID = br.BrandID
--Where PromotionID = 54575



--Select *
--From Playbook.RetailPromotion
--Where PromotionID = 54575



--Select *
--From Playbook.PromotionGeoRelevancy
--Where PromotionID in 
--(
--	Select PromotionID From dbo.BCPromoLeader
--	Where PromotionID not In (Select PromotionID From dbo.BCPromoRegion)
--)

--Select *
--From Playbook.PromotionGeoHier
--Where PromotionID in 
--(
--	Select PromotionID From dbo.BCPromoRegion
--	Where PromotionID not In (Select PromotionID From dbo.BCPromoLeader)
--)

--Select *
--From Playbook.PromotionBrand
--Where PromotionID in 
--(
--	Select PromotionID From dbo.BCPromoRegion
--	Where PromotionID not In (Select PromotionID From dbo.BCPromoLeader)
--)

--Select * From Playbook.RetailPromotion
--Where PromotionID in 
--(
--	Select PromotionID From dbo.BCPromoRegion
--	Where PromotionID not In (Select PromotionID From dbo.BCPromoLeader)
--)
---------------------------

--Select *
--From Playbook.PromotionGeoRelevancy
--Where PromotionID in 
--(
--	Select PromotionID From dbo.BCPromoLeader
--	Where PromotionID not In (Select PromotionID From dbo.BCPromoRegion)
--)

--Select *
--From Playbook.PromotionGeoHier
--Where PromotionID in 
--(
--	Select PromotionID From dbo.BCPromoLeader
--	Where PromotionID not In (Select PromotionID From dbo.BCPromoRegion)
--)

--Select *
--From Playbook.PromotionBrand
--Where PromotionID in 
--(
--	Select PromotionID From dbo.BCPromoLeader
--	Where PromotionID not In (Select PromotionID From dbo.BCPromoRegion)
--)

--Select * From Playbook.RetailPromotion
--Where PromotionID in 
--(
--	Select PromotionID From dbo.BCPromoLeader
--	Where PromotionID not In (Select PromotionID From dbo.BCPromoRegion)
--)

--Select *
--From Playbook.PromotionGeoHier
--Where PromotionID = 54582

--Select *
--From Playbook.PromotionGeoRelevancy
--Where PromotionID = 54582

--Select *
--From Playbook.RetailPromotion
--Where PromotionID = 54582

--Select *
--From BC.Bottler
--Where BottlerID = 10945

/*

exec BCMyday.pGetPromotionsByRegionID @BCRegionID = 18, @LastModified = '2015-07-20'
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'ALBDX003', @LastModified = '2015-07-20'
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'ALBDX003', @LastModified = ''
exec BCMyday.pGetBCPromotionsForLeadershipView @GSN = 'ALBDX003'



*/

--Select PromotionID, ModifiedDate
--From Playbook.RetailPromotion
--Where ModifiedDate >= '2015-07-20'

--Select ModifiedDate ModifiedDate1,  *
--From Playbook.RetailPromotion
--Where PromotionID in
--(
--	Select Distinct PromotionId
--	From Playbook.PromotionGeoRelevancy
--	Where StateID is not null
--)
--Order By ModifiedDate Desc, PromotionID

--Select *
--From Playbook.RetailPromotion
--Where PromotionID = 40080

--Select *
--From Playbook.PromotionGeoRelevancy
--Where StateID is not null


