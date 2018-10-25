use Portal_Data805
Go

Truncate Table BCMyDay.PromotionRequestLog
Go

Declare @Query Nvarchar(1000)

Declare db_cursor Cursor For
Select 'exec BCMyday.pGetBCPromotionsForGSN9 @GSN = ''' 
	+ a.GSN + ''', @EnableLogging = 1 --[' + Coalesce(ad.Band, 'None') + '] ' + Coalesce(u.LastName, '') + ', ' + Coalesce(u.FirstName, '')
	+ '(' + Coalesce(u.Title, '') + ')'
From Person.BCSalesAccountability a
Join Person.UserProfile u on a.GSN = u.GSN
Left Join Staging.ADExtractData ad on a.GSN = ad.UserID

Open db_cursor
Fetch Next From db_cursor Into @Query

While @@FETCH_STATUS = 0
Begin
	Print @Query
	EXECUTE sp_executesql @Query

	Fetch Next From db_cursor Into @Query
End

Close db_cursor   
Deallocate db_cursor
Go

--Select Distinct 'exec BCMyday.pGetBCPromotionsForGSN9 @GSN = ''' 
--	+ a.GSN + ''', @EnableLogging = 1 --[' + ad.Band + '] ' + u.LastName + ', ' + u.FirstName 
--	+ '(' + u.Title + ')'
--From Person.BCSalesAccountability a
--Join Person.UserProfile u on a.GSN = u.GSN
--Left Join Staging.ADExtractData ad on a.GSN = ad.UserID
--Go

--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'ACKTD001', @EnableLogging = 1 --Regional Sales manager IPDX
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'ADACX010', @EnableLogging = 1 --RCI Manager
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'ALBDX003', @EnableLogging = 1 --Regional Sales Manager CT_ME_VT_NH
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'ALBSX006', @EnableLogging = 1 --VP IT Commercial & Latin America
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'ANDMX003', @EnableLogging = 1 --Regional Sales Manager IWIS
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'ANDSX516', @EnableLogging = 1 --Regional Sales Manager CCBCC Carolinas
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'ANGTX003', @EnableLogging = 1 --Regional Sales Manager IPRM
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'AVABX001', @EnableLogging = 1 --Divisional Sales Manager New York
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'BARJX603', @EnableLogging = 1 --Regional Sales Manager
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'BARRX033', @EnableLogging = 1 --Regional Sales Sr Manager ISO
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'BERDX002', @EnableLogging = 1 --SVP Sales PASO
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'BERKX005', @EnableLogging = 1 --Commercial Sales Manager
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'BETTX001', @EnableLogging = 1 --Regional Sales Manager Salk Lake City
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'BIEJX002', @EnableLogging = 1 --Sales Technology Manager Retailer Comms
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'BLASX008', @EnableLogging = 1 --Commercial Sales Manager
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'BOEPX001', @EnableLogging = 1 --Regional Sales Manager AL
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'BOHSX001', @EnableLogging = 1 --VP Sales PASO West
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'BOLFX001', @EnableLogging = 1 --Divisional Sales Manager IRA Central
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'BONJX002', @EnableLogging = 1 --Regional Sales Manager INWO
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'BRIJX004', @EnableLogging = 1 --Divisional Sales Manager Southeast
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'BUERX002', @EnableLogging = 1 --Regional Sales Manager IHDS
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'BUIGS001', @EnableLogging = 1 --Regional Sales Manager Mid South
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'BUTJX004', @EnableLogging = 1 --VP Sales Development
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'BUXBX001', @EnableLogging = 1 --Regional Sales Manager ISOC
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'CALDX002', @EnableLogging = 1 --Regional Sales Manager Seattle
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'CARPX002', @EnableLogging = 1 --Regional Sales Manager Philadelphia
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'CHATX003', @EnableLogging = 1 --Commercial Sales Manager
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'CHEPX008', @EnableLogging = 1 --IT Manager Business Information Portal
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'CIVJX001', @EnableLogging = 1 --Regional Sales Manager INCN
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'CLABX010', @EnableLogging = 1 --Field Marketing Manager
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'COCCA001', @EnableLogging = 1 --Field Marketing Manager
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'COLGX001', @EnableLogging = 1 --Regional Sales Manager Great Lakes
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'CONVX002', @EnableLogging = 1 --Regional Sales Manager IDVP
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'CORCM001', @EnableLogging = 1 --RCI Manager
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'CRAMG001', @EnableLogging = 1 --Territory Sales Manager
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'CROPX003', @EnableLogging = 1 --National Accounts Executive Grocery
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'DAVAX001', @EnableLogging = 1 --Regional Sales Manager
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'DAVBX003', @EnableLogging = 1 --Regional Sales Manager Abilene
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'DAVSX533', @EnableLogging = 1 --Regional Sales Manager AL
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'DAYDX003', @EnableLogging = 1 --IT Manager DSD West BU
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'DELDX001', @EnableLogging = 1 --Regional Sales Manager IBWA
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'DESJX002', @EnableLogging = 1 --Regional Sales Manager Minneapolis
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'DOWMX009', @EnableLogging = 1 --Field Marketing Manager CSD
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'DOYPF001', @EnableLogging = 1 --Regional Sales Manager ICHA
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'DURJX510', @EnableLogging = 1 --Regional Sales Manager NoCal
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'ENTMX001', @EnableLogging = 1 --Regional Sales Manager IGBP
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'ESPJX511', @EnableLogging = 1 --Regional Sales Manager INLA
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'FARPV001', @EnableLogging = 1 --Regional Sales Manager IWID
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'FLOMX001', @EnableLogging = 1 --Regional Sales Manager Oklahoma
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'FOSTD001', @EnableLogging = 1 --Regional Sales Manager IBAP
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'FOWJX003', @EnableLogging = 1 --Regional Sales Manager Nashville
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'FOXKX001', @EnableLogging = 1 --Divisional Sales Manager IPW
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'GALMX006', @EnableLogging = 1 --Divisional Sales Manager IMW
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'GIBDX002', @EnableLogging = 1 --Regional Sales Manager Ozarks
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'GOLCX001', @EnableLogging = 1 --Regional Sales Manager IHDN
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'GRAWX002', @EnableLogging = 1 --Regional Sales Manager Boston
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'GREBX018', @EnableLogging = 1 --Divisional Sales Manager Midwest
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'GRZFM001', @EnableLogging = 1 --Regional Sales Manager Baltimore
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'HALDC001', @EnableLogging = 1 --Divisional Sales Manager Midwest
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'HARKX073', @EnableLogging = 1 --RCI Manager
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'HARTX005', @EnableLogging = 1 --Regional Sales Manager S Western
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'HEIRX001', @EnableLogging = 1 --Regional Account Executive
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'HOSJX001', @EnableLogging = 1 --Regional Sales Manager IMIC
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'HOVEM001', @EnableLogging = 1 --NAE Grocery Target SuperValu
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'IVECX002', @EnableLogging = 1 --Regional Sales Manager Portland
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'JELJX001', @EnableLogging = 1 --Regional Sales Manager IDAV
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'johjx001', @EnableLogging = 1 --President Bev Con & Latin America Bev
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'JORJX010', @EnableLogging = 1 --Field Marketing Manager
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'JORPX005', @EnableLogging = 1 --Dir Sales ISO Field Marketing
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'KLEBX003', @EnableLogging = 1 --Commercial Sales Manager
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'KUHMJ001', @EnableLogging = 1 --Regional Sales Manager
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'LABJX001', @EnableLogging = 1 --Divisional Sales Manager ICW
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'LECLX001', @EnableLogging = 1 --Divisional Sales Manager ISO
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'LOCDM001', @EnableLogging = 1 --Regional Sales Manager IPHX
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'LOPEX002', @EnableLogging = 1 --Regional Sales Manager ICDN
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'LOYMX003', @EnableLogging = 1 --Regional Sales Manager Tulsa
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'LUKLX001', @EnableLogging = 1 --Regional Sales Manager IMPC
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'MALBX001', @EnableLogging = 1 --Divisional Sales Manager Southeast FL
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'MAYJX005', @EnableLogging = 1 --Regional Sales Manager Marion
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'MCCLX005', @EnableLogging = 1 --Regional Sales Manager IPEN
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'MCCWX001', @EnableLogging = 1 --Divisional Sales Manager IHN IHP
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'MCDSX005', @EnableLogging = 1 --Divisional Sales Manager Heartland
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'MCEDX003', @EnableLogging = 1 --Divisional Sales Manager Midwest OH
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'MCFBX001', @EnableLogging = 1 --Regional Sales Manager IPOE
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'MCIMX001', @EnableLogging = 1 --Regional Sales Manager IWWA
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'MEAMX003', @EnableLogging = 1 --Regional Sales Manager IPDX
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'MELAX012', @EnableLogging = 1 --Regional Sales Manager New England
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'METHX002', @EnableLogging = 1 --Regional Sales Manager UT Rockies
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'MILMJ001', @EnableLogging = 1 --Regional Sales Manager SC
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'MONJX001', @EnableLogging = 1 --Regional Sales Manager ISEAAOM
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'MORGX013', @EnableLogging = 1 --Regional Sales Manager IDVC
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'MORSX034', @EnableLogging = 1 --Regional Sales Manager Texas
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'MOUDX001', @EnableLogging = 1 --Regional Sales Manager Midwest
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'ORGJX003', @EnableLogging = 1 --Regional Sales Manager Atlanta
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'OROVX002', @EnableLogging = 1 --Regional Sales Manager SoCal
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'PAASX001', @EnableLogging = 1 --VP Rapid Continuous Improvement
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'PARRX003', @EnableLogging = 1 --Sales Planning Manager IBS
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'PFAKX001', @EnableLogging = 1 --Regional Sales Manager ITUC
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'PIECX001', @EnableLogging = 1 --VP CASO National Retail Accounts
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'PITDX002', @EnableLogging = 1 --VP Sales PASO East
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'PLUPX001', @EnableLogging = 1 --VP Sales PASO
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'RELFX001', @EnableLogging = 1 --Divisional Sales Manager IHM
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'ROOVX001', @EnableLogging = 1 --Regional Sales Manager W VA
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'ROYJX503', @EnableLogging = 1 --Regional Sales Manager IPOC
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'ROYMX002', @EnableLogging = 1 --Regional Sales Manager SoCal
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'ROZAX001', @EnableLogging = 1 --Regional Sales Manager Orlando
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'RUBSX001', @EnableLogging = 1 --Dir Sales Operations Capstone
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'RUOWX001', @EnableLogging = 1 --Regional Sales Manager INPR
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'SANMX001', @EnableLogging = 1 --Regional Sales Manager ICON
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'SCHDX003', @EnableLogging = 1 --Regional Sales Manager Ohio
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'SCHJA001', @EnableLogging = 1 --Regional Sales Manager CCE Gulf
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'SCHMX002', @EnableLogging = 1 --Regional Sales Manager Miami
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'SEARX001', @EnableLogging = 1 --Regional Sales Manager S Texas
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'SHAJX002', @EnableLogging = 1 --National Accounts Executive Grocery
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'SINSX003', @EnableLogging = 1 --VP Sales CASO West
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'SIRCX001', @EnableLogging = 1 --Regional Sales Manager IWMA
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'SKOTX001', @EnableLogging = 1 --Regional Sales Manager Kansas City
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'SOPBX001', @EnableLogging = 1 --Regional Sales Manager CASO
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'SPRAX001', @EnableLogging = 1 --SVP Sales CASO
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'STABX002', @EnableLogging = 1 --Divisional Sales Manager West
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'STIBX002', @EnableLogging = 1 --Regional Sales Manager INYS
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'STIDX002', @EnableLogging = 1 --Divisional Sales Manager MidAtlantic MD
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'STRRX001', @EnableLogging = 1 --Field Marketing Manager
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'STRTX003', @EnableLogging = 1 --Regional Sales Manager West Texas
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'SULJX005', @EnableLogging = 1 --Regional Sales Manager IWAS
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'TAYMX517', @EnableLogging = 1 --RCI Manager
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'THODX014', @EnableLogging = 1 --Sales Planning Manager Lg Format
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'THOSX003', @EnableLogging = 1 --Divisional Sales Manager Denver
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'TODJX001', @EnableLogging = 1 --Regional Sales Manager Indiana
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'TOLLX004', @EnableLogging = 1 --National Account Executive CASO
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'TREJX003', @EnableLogging = 1 --Divisional Sales Manager North
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'TUGJL001', @EnableLogging = 1 --Regional Sales Manager Atlanta
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'UTKMX001', @EnableLogging = 1 --Divisional Sales Manager West
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'WALJX003', @EnableLogging = 1 --Regional Sales Manager INNJ
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'WATBX001', @EnableLogging = 1 --SVP & GM ISO
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'WELJX008', @EnableLogging = 1 --Divisional Sales Manager Dallas
--exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'WILBX007', @EnableLogging = 1 --Regional Sales Manager SD LV
