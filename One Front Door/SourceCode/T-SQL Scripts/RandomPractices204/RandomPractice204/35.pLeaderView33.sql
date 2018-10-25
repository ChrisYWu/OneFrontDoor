USE [Portal_Data]
GO

/****** Object:  StoredProcedure [BCMyday].[pGetBCPromotionsForLeadershipView33]    Script Date: 8/6/2015 11:32:59 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'ACKTD001', @EnableLogging = 1 --Regional Sales manager IPDX
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'ADACX010', @EnableLogging = 1 --RCI Manager
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'ALBDX003', @EnableLogging = 1 --Regional Sales Manager CT_ME_VT_NH
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'ALBSX006', @EnableLogging = 1 --VP IT Commercial & Latin America
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'ANDMX003', @EnableLogging = 1 --Regional Sales Manager IWIS
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'ANDSX516', @EnableLogging = 1 --Regional Sales Manager CCBCC Carolinas
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'ANGTX003', @EnableLogging = 1 --Regional Sales Manager IPRM
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'AVABX001', @EnableLogging = 1 --Divisional Sales Manager New York
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'BARJX603', @EnableLogging = 1 --Regional Sales Manager
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'BARRX033', @EnableLogging = 1 --Regional Sales Sr Manager ISO
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'BERDX002', @EnableLogging = 1 --SVP Sales PASO
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'BERKX005', @EnableLogging = 1 --Commercial Sales Manager
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'BETTX001', @EnableLogging = 1 --Regional Sales Manager Salk Lake City
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'BIEJX002', @EnableLogging = 1 --Sales Technology Manager Retailer Comms
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'BLASX008', @EnableLogging = 1 --Commercial Sales Manager
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'BOEPX001', @EnableLogging = 1 --Regional Sales Manager AL
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'BOHSX001', @EnableLogging = 1 --VP Sales PASO West
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'BOLFX001', @EnableLogging = 1 --Divisional Sales Manager IRA Central
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'BONJX002', @EnableLogging = 1 --Regional Sales Manager INWO
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'BRIJX004', @EnableLogging = 1 --Divisional Sales Manager Southeast
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'BUERX002', @EnableLogging = 1 --Regional Sales Manager IHDS
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'BUIGS001', @EnableLogging = 1 --Regional Sales Manager Mid South
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'BUTJX004', @EnableLogging = 1 --VP Sales Development
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'BUXBX001', @EnableLogging = 1 --Regional Sales Manager ISOC
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'CALDX002', @EnableLogging = 1 --Regional Sales Manager Seattle
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'CARPX002', @EnableLogging = 1 --Regional Sales Manager Philadelphia
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'CHATX003', @EnableLogging = 1 --Commercial Sales Manager
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'CHEPX008', @EnableLogging = 1 --IT Manager Business Information Portal
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'CIVJX001', @EnableLogging = 1 --Regional Sales Manager INCN
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'CLABX010', @EnableLogging = 1 --Field Marketing Manager
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'COCCA001', @EnableLogging = 1 --Field Marketing Manager
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'COLGX001', @EnableLogging = 1 --Regional Sales Manager Great Lakes
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'CONVX002', @EnableLogging = 1 --Regional Sales Manager IDVP
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'CORCM001', @EnableLogging = 1 --RCI Manager
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'CRAMG001', @EnableLogging = 1 --Territory Sales Manager
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'CROPX003', @EnableLogging = 1 --National Accounts Executive Grocery
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'DAVAX001', @EnableLogging = 1 --Regional Sales Manager
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'DAVBX003', @EnableLogging = 1 --Regional Sales Manager Abilene
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'DAVSX533', @EnableLogging = 1 --Regional Sales Manager AL
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'DAYDX003', @EnableLogging = 1 --IT Manager DSD West BU
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'DELDX001', @EnableLogging = 1 --Regional Sales Manager IBWA
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'DESJX002', @EnableLogging = 1 --Regional Sales Manager Minneapolis
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'DOWMX009', @EnableLogging = 1 --Field Marketing Manager CSD
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'DOYPF001', @EnableLogging = 1 --Regional Sales Manager ICHA
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'DURJX510', @EnableLogging = 1 --Regional Sales Manager NoCal
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'ENTMX001', @EnableLogging = 1 --Regional Sales Manager IGBP
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'ESPJX511', @EnableLogging = 1 --Regional Sales Manager INLA
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'FARPV001', @EnableLogging = 1 --Regional Sales Manager IWID
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'FLOMX001', @EnableLogging = 1 --Regional Sales Manager Oklahoma
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'FOSTD001', @EnableLogging = 1 --Regional Sales Manager IBAP
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'FOWJX003', @EnableLogging = 1 --Regional Sales Manager Nashville
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'FOXKX001', @EnableLogging = 1 --Divisional Sales Manager IPW
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'GALMX006', @EnableLogging = 1 --Divisional Sales Manager IMW
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'GIBDX002', @EnableLogging = 1 --Regional Sales Manager Ozarks
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'GOLCX001', @EnableLogging = 1 --Regional Sales Manager IHDN
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'GRAWX002', @EnableLogging = 1 --Regional Sales Manager Boston
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'GREBX018', @EnableLogging = 1 --Divisional Sales Manager Midwest
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'GRZFM001', @EnableLogging = 1 --Regional Sales Manager Baltimore
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'HALDC001', @EnableLogging = 1 --Divisional Sales Manager Midwest
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'HARKX073', @EnableLogging = 1 --RCI Manager
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'HARTX005', @EnableLogging = 1 --Regional Sales Manager S Western
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'HEIRX001', @EnableLogging = 1 --Regional Account Executive
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'HOSJX001', @EnableLogging = 1 --Regional Sales Manager IMIC
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'HOVEM001', @EnableLogging = 1 --NAE Grocery Target SuperValu
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'IVECX002', @EnableLogging = 1 --Regional Sales Manager Portland
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'JELJX001', @EnableLogging = 1 --Regional Sales Manager IDAV
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'johjx001', @EnableLogging = 1 --President Bev Con & Latin America Bev
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'JORJX010', @EnableLogging = 1 --Field Marketing Manager
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'JORPX005', @EnableLogging = 1 --Dir Sales ISO Field Marketing
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'KLEBX003', @EnableLogging = 1 --Commercial Sales Manager
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'KUHMJ001', @EnableLogging = 1 --Regional Sales Manager
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'LABJX001', @EnableLogging = 1 --Divisional Sales Manager ICW
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'LECLX001', @EnableLogging = 1 --Divisional Sales Manager ISO
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'LOCDM001', @EnableLogging = 1 --Regional Sales Manager IPHX
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'LOPEX002', @EnableLogging = 1 --Regional Sales Manager ICDN
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'LOYMX003', @EnableLogging = 1 --Regional Sales Manager Tulsa
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'LUKLX001', @EnableLogging = 1 --Regional Sales Manager IMPC
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'MALBX001', @EnableLogging = 1 --Divisional Sales Manager Southeast FL
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'MAYJX005', @EnableLogging = 1 --Regional Sales Manager Marion
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'MCCLX005', @EnableLogging = 1 --Regional Sales Manager IPEN
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'MCCWX001', @EnableLogging = 1 --Divisional Sales Manager IHN IHP
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'MCDSX005', @EnableLogging = 1 --Divisional Sales Manager Heartland
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'MCEDX003', @EnableLogging = 1 --Divisional Sales Manager Midwest OH
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'MCFBX001', @EnableLogging = 1 --Regional Sales Manager IPOE
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'MCIMX001', @EnableLogging = 1 --Regional Sales Manager IWWA
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'MEAMX003', @EnableLogging = 1 --Regional Sales Manager IPDX
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'MELAX012', @EnableLogging = 1 --Regional Sales Manager New England
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'METHX002', @EnableLogging = 1 --Regional Sales Manager UT Rockies
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'MILMJ001', @EnableLogging = 1 --Regional Sales Manager SC
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'MONJX001', @EnableLogging = 1 --Regional Sales Manager ISEAAOM
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'MORGX013', @EnableLogging = 1 --Regional Sales Manager IDVC
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'MORSX034', @EnableLogging = 1 --Regional Sales Manager Texas
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'MOUDX001', @EnableLogging = 1 --Regional Sales Manager Midwest
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'ORGJX003', @EnableLogging = 1 --Regional Sales Manager Atlanta
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'OROVX002', @EnableLogging = 1 --Regional Sales Manager SoCal
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'PAASX001', @EnableLogging = 1 --VP Rapid Continuous Improvement
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'PARRX003', @EnableLogging = 1 --Sales Planning Manager IBS
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'PFAKX001', @EnableLogging = 1 --Regional Sales Manager ITUC
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'PIECX001', @EnableLogging = 1 --VP CASO National Retail Accounts
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'PITDX002', @EnableLogging = 1 --VP Sales PASO East
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'PLUPX001', @EnableLogging = 1 --VP Sales PASO
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'RELFX001', @EnableLogging = 1 --Divisional Sales Manager IHM
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'ROOVX001', @EnableLogging = 1 --Regional Sales Manager W VA
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'ROYJX503', @EnableLogging = 1 --Regional Sales Manager IPOC
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'ROYMX002', @EnableLogging = 1 --Regional Sales Manager SoCal
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'ROZAX001', @EnableLogging = 1 --Regional Sales Manager Orlando
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'RUBSX001', @EnableLogging = 1 --Dir Sales Operations Capstone
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'RUOWX001', @EnableLogging = 1 --Regional Sales Manager INPR
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'SANMX001', @EnableLogging = 1 --Regional Sales Manager ICON
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'SCHDX003', @EnableLogging = 1 --Regional Sales Manager Ohio
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'SCHJA001', @EnableLogging = 1 --Regional Sales Manager CCE Gulf
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'SCHMX002', @EnableLogging = 1 --Regional Sales Manager Miami
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'SEARX001', @EnableLogging = 1 --Regional Sales Manager S Texas
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'SHAJX002', @EnableLogging = 1 --National Accounts Executive Grocery
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'SINSX003', @EnableLogging = 1 --VP Sales CASO West
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'SIRCX001', @EnableLogging = 1 --Regional Sales Manager IWMA
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'SKOTX001', @EnableLogging = 1 --Regional Sales Manager Kansas City
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'SOPBX001', @EnableLogging = 1 --Regional Sales Manager CASO
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'SPRAX001', @EnableLogging = 1 --SVP Sales CASO
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'STABX002', @EnableLogging = 1 --Divisional Sales Manager West
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'STIBX002', @EnableLogging = 1 --Regional Sales Manager INYS
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'STIDX002', @EnableLogging = 1 --Divisional Sales Manager MidAtlantic MD
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'STRRX001', @EnableLogging = 1 --Field Marketing Manager
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'STRTX003', @EnableLogging = 1 --Regional Sales Manager West Texas
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'SULJX005', @EnableLogging = 1 --Regional Sales Manager IWAS
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'TAYMX517', @EnableLogging = 1 --RCI Manager
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'THODX014', @EnableLogging = 1 --Sales Planning Manager Lg Format
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'THOSX003', @EnableLogging = 1 --Divisional Sales Manager Denver
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'TODJX001', @EnableLogging = 1 --Regional Sales Manager Indiana
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'TOLLX004', @EnableLogging = 1 --National Account Executive CASO
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'TREJX003', @EnableLogging = 1 --Divisional Sales Manager North
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'TUGJL001', @EnableLogging = 1 --Regional Sales Manager Atlanta
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'UTKMX001', @EnableLogging = 1 --Divisional Sales Manager West
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'WALJX003', @EnableLogging = 1 --Regional Sales Manager INNJ
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'WATBX001', @EnableLogging = 1 --SVP & GM ISO
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'WELJX008', @EnableLogging = 1 --Divisional Sales Manager Dallas
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'WILBX007', @EnableLogging = 1 --Regional Sales Manager SD LV

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

exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'BERDX002', @Debug = 1
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'BUTJX004', @Debug = 1
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'gyskx001', @Debug = 1
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'JOHSX001', @Debug = 1
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'MAGMX002', @Debug = 1
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'MAIRX001', @Debug = 1
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'malgx009', @Debug = 1
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'sprax001', @Debug = 1
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'WATBX001', @Debug = 1
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'ALBDX003', @Debug = 1

exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'ALBDX003'


------- Jim Johnson
Declare @StartDate DateTime2(7)
Declare @EndDate DateTime2(7)

Set @StartDate = SYSDATETIME()
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'ALBSX006', @Debug = 1
--exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'ALBSX006', @LastModified = '2015-07-18'
Set @EndDate = SYSDATETIME()
Select DateDiff(MICROSECOND, @StartDate, @EndDate)
Go

------- RSM
Declare @StartDate DateTime2(7)
Declare @EndDate DateTime2(7)

Set @StartDate = SYSDATETIME()
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'ALBDX003', @Debug = 1
Set @EndDate = SYSDATETIME()
Select DateDiff(MICROSECOND, @StartDate, @EndDate)
Go

------- ISO SVP
Declare @StartDate DateTime2(7)
Declare @EndDate DateTime2(7)

Set @StartDate = SYSDATETIME()
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'WATBX001', @Debug = 1
Set @EndDate = SYSDATETIME()
Select DateDiff(MICROSECOND, @StartDate, @EndDate)
Go

------- CASO SVP
Declare @StartDate DateTime2(7)
Declare @EndDate DateTime2(7)

Set @StartDate = SYSDATETIME()
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'sprax001', @Debug = 1
Set @EndDate = SYSDATETIME()
Select DateDiff(MICROSECOND, @StartDate, @EndDate)
Go

------- PASO SVP
Declare @StartDate DateTime2(7)
Declare @EndDate DateTime2(7)

Set @StartDate = SYSDATETIME()
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'BERDX002', @Debug = 1
Set @EndDate = SYSDATETIME()
Select DateDiff(MICROSECOND, @StartDate, @EndDate)
Go

---- For Comparisons w/ existing logics ----
exec BCMyday.pGetPromotionsByRegionID @BCRegionID = 18, @LastModified = '2015-07-20'
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'ALBDX003', @LastModified = '2010-05-20', @Debug = 1, @EnableLogging = 1

exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'ALBDX003', @LastModified = '', @Debug = 1, @EnableLogging = 1

exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'JOHJX001', @Debug = 1, @EnableLogging = 1

exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'JOHJX001', @EnableLogging = 1



Select *
From BCMyDay.PromotionRequestLog

--- 
*/

--Drop Table BCMyDay.PromotionRequestLog

--Create Table BCMyDay.PromotionRequestLog
--(
--	LogID int IDENTITY(1,1),
--	[LogDate]  AS (CONVERT([date],[StartDate])),
--	[Duration]  AS (datediff(millisecond,[StartDate],[EndDate])),
--	GSN varchar(50) not null,
--	MDate DateTime null,
--	StartDate datetime2(7) not null,
--	EndDate datetime2(7) null,
--	NumberOfPromotion int null,
--	NumberOfRegion int null,
--	NumberOfBottler int null
--CONSTRAINT [PK_PromotionRequestLog] PRIMARY KEY CLUSTERED 
--(
--	[StartDate] DESC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
--) ON [PRIMARY]
--Go

/*
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'ALBDX003', @Debug = 1, @EnableLogging = 1

*/

Alter Proc [BCMyday].[pGetBCPromotionsForLeadershipView33]
(
	@GSN Varchar(50), 
	@LastModified DateTime = null,
	@Debug bit = 0,
	@EnableLogging bit = 0
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
	
	If (@EnableLogging is null)
		Set @EnableLogging = 0

	If(@EnableLogging = 1)
	Begin
		Declare @LogID int
		Insert Into BCMyDay.PromotionRequestLog(GSN, MDate, StartDate) Values(@GSN, @LastModified, SYSDATETIME())
		Select @LogID = Scope_Identity()
	End

	--------------------
	Declare @Hier Table
	(
		SystemID int,
		ZoneID int,
		DivisionID int,
		RegionID int,
		BCRegionID int, 
		BottlerID int,
		BottlerName varchar(400)
	)

	Insert into @Hier
	Select v.SystemID, v.ZoneID, v.DivisionID, v.RegionID, v.RegionNodeID, v.BottlerID, v.BottlerName
	From BC.vBCBottlerHier v
	Join BC.tGSNRegion t on v.RegionID = t.RegionID
	Where t.GSN = @GSN

	---???????????????????????????---
	If Exists (Select * From sys.tables where object_id = object_id('dbo.UserHier'))
		Drop Table dbo.UserHier

	Select *
	Into dbo.UserHier
	From @Hier	
	---???????????????????????????---

	If (@Debug = 1)
	Begin
		Declare @StartTime DateTime2(7)
		Set @StartTime = SysDateTime()
		Select '---- Input Parameters ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		
		Select @GSN GSN, Title, FirstName, LastName, @LastModified LastModifiedParameter, @Debug DebugFlagParameter, @@SERVERNAME [Server], DB_NAME() [Database]
		From Person.UserProfile Where GSN = @GSN

		Select g.GSN, r.RegionID, r.RegionName From BC.tGSNRegion g Join BC.Region r on g.RegionID = r.RegionID Where GSN = @GSN

		Select '---- User relevant bottlers with hierachy ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select SystemID, ZoneID, DivisionID, RegionID, BCRegionID, BottlerID, BottlerName From @Hier

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

	Select Distinct p.PromotionID, p.ModifiedDate, p.PromotionStartDate, p.PromotionEndDate
	Into #PromotionsInScope
	From Playbook.RetailPromotion p With (nolock),
	Playbook.PromotionGeoRelevancy pgr With (nolock),
	@ApplicablePromoStatus st
	Where (
		Coalesce(SystemID, 0) > 0
		Or Coalesce(ZoneID, 0) > 0
		Or Coalesce(DivisionID, 0) > 0
		Or Coalesce(BCRegionID, 0) > 0
		Or Coalesce(BottlerID, 0) > 0
		Or Coalesce(StateID, 0) > 0
	)
	And (p.PromotionRelevantStartDate <= @ConfigPEndDate And p.PromotionRelevantEndDate >= @ConfigPStartDate)
	And st.StatusID = p.PromotionStatusID
	And (
		(@LastModified is null) Or
		 (
			 (
					--In Active Scope 
					PromotionStartDate between Playbook.fGetSunday(getDate()) and Playbook.fGetMonday(getDate())  
					or
					PromotionEndDate between Playbook.fGetSunday(getDate()) and Playbook.fGetMonday(getDate())
					or
					Playbook.fGetSunday(getDate()) BETWEEN PromotionStartDate AND PromotionEndDate
			  ) Or
			ModifiedDate >= Coalesce(@LastModified, '1900-01-01')	-- In Date-Delta
		)
	)

	If (@Debug = 1)
	Begin
		Select '---- Promotion pre filter completed ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select * From #PromotionsInScope
	End

	--- Extended Bttler table, that has state id ---
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

	--- Expand GeoRelevancy Tree
	Select pgr.PromotionId PromotionID, pgr.SystemID, pgr.ZoneID, pgr.DivisionID, pgr.BCRegionID RegionID, pgr.BottlerID, pgr.StateId StateID
	Into #PromoGeoR
	From Playbook.PromotionGeoRelevancy pgr
	Join #PromotionsInScope p on pgr.PromotionId = p.PromotionID
	Where (
		Coalesce(SystemID, 0) > 0
		Or Coalesce(ZoneID, 0) > 0
		Or Coalesce(DivisionID, 0) > 0
		Or Coalesce(BCRegionID, 0) > 0
		Or Coalesce(BottlerID, 0) > 0
		Or Coalesce(StateID, 0) > 0
	)

	If (@Debug = 1)
	Begin
		Select '---- Promotion geo relevancy ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select * From #PromoGeoR
	End

	---???????????????????????????---
	If Exists (Select * From sys.tables where object_id = object_id('dbo.PromoGeoExtended'))
		Drop Table dbo.PromoGeoExtended

	Select *
	Into dbo.PromoGeoExtended
	From #PromoGeoR	
	---???????????????????????????---

	----- BTTLR driver table -----
	Create Table #PGR
	(
		PromotionID int not null,
		SystemID int,
		ZoneID int,
		DivisionID int,
		RegionID int,
		BottlerID int,
	)

	Create Clustered Index IDX_PGR_PromotionID_BottlerID ON #PGR(PromotionID, BottlerID)

	---------------
	Insert Into #PGR(PromotionID, SystemID, ZoneID, DivisionID, RegionID, BottlerID)
	Select Distinct pgr.PromotionID, v.SystemID, v.ZoneID, v.DivisionID, v.RegionID, v.BottlerID
	from #PromoGeoR pgr
	Join @Hier v on pgr.SystemID = v.SystemID
	Where StateID is null
	Union
	Select Distinct pgr.PromotionID, v.SystemID, v.ZoneID, v.DivisionID, v.RegionID, v.BottlerID
	from #PromoGeoR pgr
	Join @Hier v on pgr.ZoneID = v.ZoneID
	Where StateID is null And pgr.SystemID is null
	Union
	Select Distinct pgr.PromotionID, v.SystemID, v.ZoneID, v.DivisionID, v.RegionID, v.BottlerID
	from #PromoGeoR pgr
	Join @Hier v on pgr.DivisionID = v.DivisionID
	Where StateID is null And pgr.ZoneID is null And pgr.SystemID is null
	Union
	Select Distinct pgr.PromotionID, v.SystemID, v.ZoneID, v.DivisionID, v.RegionID, v.BottlerID
	from #PromoGeoR pgr
	Join @Hier v on pgr.RegionID = v.RegionID
	Where StateID is null And pgr.ZoneID is null And pgr.SystemID is null And pgr.DivisionID is null
	Union
	Select Distinct pgr.PromotionID, v.SystemID, v.ZoneID, v.DivisionID, v.RegionID, v.BottlerID
	from #PromoGeoR pgr
	Join @Hier v on pgr.BottlerID = v.BottlerID
	Where StateID is null And pgr.ZoneID is null And pgr.SystemID is null And pgr.DivisionID is null and pgr.RegionID is null
	Union
	Select Distinct pgr.PromotionID, v.SystemID, v.ZoneID, v.DivisionID, v.RegionID, v.BottlerID
	from #PromoGeoR pgr
	Join @Bottlers b on pgr.StateID = b.StateRegionID
	Join @Hier v on b.BottlerID = v.BottlerID

	If (@Debug = 1)
	Begin
		Select '---- Expanded Promotion Geo Relevancy ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select Count(*) NumberOfExpandedRelations From #PGR		
		Select * From #PGR 
	End

	------------------------------------------------------------------------------
	--- For some reason, the temp table is working much faster then table variable
	--- Get all related promotions regardless of last modified
	Print 'Relate Promotions to Territoties'
	-------------------------------------------------
	Select Distinct pgh.PromotionID
	Into #Promotion
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
	BC.tBottlerChainTradeMark tmap With (nolock)
	Where ptm.PromotionID = pgh.PromotionID
	And pc.PromotionID = pgh.PromotionID
	And tmap.TerritoryTypeID <> 10
	And tmap.ProductTypeID = 1
	And tmap.TradeMarkID = ptm.TradeMarkID
	And tmap.LocalChainID = pc.LocalChainID
	And tmap.BottlerID = pgh.BottlerID

	If (@Debug = 1)
	Begin
		Select '---- Promotion table content after applying territory ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select Count(*) NumberOfPromotions_ReducedByTerrirotyMap From #Promotion
	End

	-----~~~~~~~~~~~~~~~~~~~~~~~----
	----------- Outputs ------------
	-----~~~~~~~~~~~~~~~~~~~~~~~----
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
	--- Output @PromoGeo relations
	Select pgr.PromotionID, SystemID, ZoneID, DivisionID, RegionID, BottlerID 
	From #Promotion p
	Join #PGR pgr on p.PromotionID = pgr.PromotionID

	---???????????????????????????---
	If Exists (Select * From sys.tables where object_id = object_id('dbo.JJAnalysis'))
		Drop Table dbo.JJAnalysis

	Select pgr.PromotionID, SystemID, ZoneID, DivisionID, RegionID, BottlerID 
	Into dbo.JJAnalysis
	From #Promotion p	
	Join #PGR pgr on p.PromotionID = pgr.PromotionID
	---???????????????????????????---

	If (@Debug = 1)
	Begin
		Select '---- All done. Updating logging if needed ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

	If(@EnableLogging = 1)
	Begin
		Declare @NumberOfPromotion int, @NumberOfRegion int, @NumberOfBottler int, @EndDate DateTime2(7), @CurrentPromotionCount int
		
		Set @EndDate  = SYSDATETIME()
		Select @NumberOfPromotion = count(*) From #Promotion
		Select @NumberOfRegion = count(*) From BC.tGSNRegion g Join BC.Region r on g.RegionID = r.RegionID Where GSN = @GSN
		Select @NumberOfBottler = count(*) From BC.tGSNRegion t Join BC.Bottler b on t.RegionID = b.BCRegionID Where GSN = @GSN
		Select @CurrentPromotionCount = Count(*) From Playbook.RetailPromotion Where PromotionID in (Select PromotionID From #Promotion) And GetDate() Between PromotionStartDate And PromotionEndDate

		Update BCMyDay.PromotionRequestLog
		Set EndDate = SYSDATETIME()
		, NumberOfPromotion = @NumberOfPromotion
		, NumberOfRegion = @NumberOfRegion
		, NumberOfBottler = @NumberOfBottler
		, NumberOfCurrentPromotion = @CurrentPromotionCount
		Where LogID = @LogID

		Select LogID,
			LogDate,
			Duration, 
			GSN, 
			MDate, 
			StartDate, 
			EndDate, 
			NumberOfPromotion,
			NumberOfCurrentPromotion,
			NumberOfRegion,
			NumberOfBottler
		From BCMyDay.PromotionRequestLog
		Where LogID = @LogID
	End

End


GO

--Select *
--From dbo.JJAnalysis
--Where PromotionId = 41383
exec BCMyday.pGetBCPromotionsForLeadershipView33 @GSN = 'BUTJX004', @Debug = 1

Select *
From dbo.UserHier
