USE [Portal_Data]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ETL].[pNomalizeLocations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ETL].[pNomalizeLocations]
GO

CREATE PROCEDURE [ETL].[pNomalizeLocations] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--------------------------------------------
	---- BU ------------------------------------
	Declare @bu Table
	(
		BUID varchar(50),
		BUName nvarchar(50)
	)

	Insert @bu
	Select Distinct BusinessUnit, BusinessUnit
	From BWStaging.SalesOffice
	Where BusinessUnit <> 'Not assigned'

	MERGE SAP.BusinessUnit AS bu
		USING (SELECT BUID,BUName FROM @bu) AS input
			ON bu.SAPBUID = input.BUID
	WHEN MATCHED THEN 
		UPDATE SET bu.BUName = dbo.udf_TitleCase(input.BUName)
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPBUID,BUName)
	VALUES(input.BUID, dbo.udf_TitleCase(input.BUName));

	--------------------------------------------

	--------------------------------------------
	---AREA-------------------------------------
	Declare @region Table
	(
		SAPBUID varchar(50),
		AreaID varchar(50),
		AreaName nvarchar(50)
	)

	Insert @region
	Select Distinct BusinessUnit, RegionID, Region
	From BWStaging.SalesOffice
	Where BusinessUnit <> 'Not assigned'

	MERGE SAP.BusinessArea AS ba
		USING ( SELECT r.SAPBUID,AreaID,AreaName,bu.BUID 
				FROM @region r Join SAP.BusinessUnit bu on r.SAPBUID = bu.SAPBUID) AS input
			ON ba.SAPAreaID = input.AreaID
	WHEN MATCHED THEN
		UPDATE SET ba.AreaName = dbo.udf_TitleCase(input.AreaName)
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPAreaID,AreaName,BUID)
	VALUES(input.AreaID, dbo.udf_TitleCase(input.AreaName), input.BUID);

	Update SAP.BusinessArea
	Set AreaName = 'Metro NY/NJ'
	Where AreaName = 'Metro Ny/Nj'

	Update SAP.BusinessArea
	Set AreaName = 'Mid-South'
	Where AreaName = 'Mid-South,Mid-South'

	Update SAP.BusinessArea
	Set AreaName = 'South Texas New Mexico'
	Where AreaName = 'South Texas New Mexi'

	--------------------------------------------
	---BRANCH-----------------------------------
	Declare @branch Table
	(
		SAPAreaID varchar(50),
		SalesOfficeID varchar(50),
		SalesOffice nvarchar(50)
	)

	Insert @branch
	Select Distinct RegionID, SalesOfficeID, SalesOffice
	From BWStaging.SalesOffice
	Where BusinessUnit <> 'Not assigned'

	MERGE SAP.Branch AS ba
		USING ( SELECT b.SalesOfficeID, b.SalesOffice, area.AreaID, l.Location_ID, l.Location_City
				FROM @branch b 
				Join SAP.BusinessArea area on b.SapAreaID = area.SapAreaID
				Join RM..ACEUSER.LOCATION l on (b.SalesOfficeID = Left(l.Location_ID, 4))
				) AS input
			ON ba.SAPBranchID = input.SalesOfficeID
	WHEN MATCHED THEN
		UPDATE SET ba.BranchName = dbo.udf_TitleCase(input.SalesOffice),
					ba.RMLocationID = Location_ID,
					ba.RMLocationCity = Location_City
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPBranchID,BranchName,AreaID,RMLocationID, RMLocationCity)
	VALUES(input.SalesOfficeID, dbo.udf_TitleCase(input.SalesOffice), input.AreaID, Location_ID, Location_City);

	--------------------------------------------
	---PROFIT CENTER----------------------------
	Select *
	From BWStaging.ProfitCenterToSalesOffice

	Declare @pc Table
	(
		ProfitCenterID varchar(50),
		ProfitCenter nvarchar(50),
		SalesOfficeID varchar(50)
	)

	Insert @pc
	Select Distinct ProfitCenterID, ProfitCenter, SalesOfficeID
	From BWStaging.ProfitCenterToSalesOffice

	MERGE SAP.ProfitCenter AS ba
		USING ( SELECT p.ProfitCenterID, p.ProfitCenter, br.BranchID
				FROM @pc p Join SAP.Branch br on p.SalesOfficeID = br.SAPBranchID) AS input
			ON ba.SAPProfitCenterID = input.ProfitCenterID
	WHEN MATCHED THEN
		UPDATE SET ba.ProfitCenterName = dbo.udf_TitleCase(input.ProfitCenter)
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPProfitCenterID, ProfitCenterName, BranchID)
	VALUES(input.ProfitCenterID, dbo.udf_TitleCase(input.ProfitCenter), input.BranchID);

	--------------------------------------------
	---COST CENTER----------------------------
	Declare @cc Table
	(
		CostCenterID varchar(50),
		CostCenter nvarchar(50),
		ProfitCenterID varchar(50)
	)

	Insert @cc
	Select Distinct CostCenterID, CostCenter, ProfitCenterID
	From BWStaging.CostCenterToProfitCenter

	MERGE SAP.CostCenter AS ba
		USING ( SELECT c.CostCenterID, c.CostCenter, pc.ProfitCenterID
				FROM @cc c Join SAP.ProfitCenter pc on c.ProfitCenterID = pc.SAPProfitCenterID) AS input
			ON ba.SAPCostCenterID = input.CostCenterID
	WHEN MATCHED THEN
		UPDATE SET ba.CostCenterName = dbo.udf_TitleCase(input.CostCenter)
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPCostCenterID, CostCenterName, ProfitCenterID)
	VALUES(input.CostCenterID, dbo.udf_TitleCase(input.CostCenter), input.ProfitCenterID);
	
	-------------------------------------------------
	------------- Update SPName for locations -------
	Select *
	FROM SAP.BusinessUnit

	Update SAP.BusinessUnit
	Set SPBUName = BUName

	Update SAP.BusinessArea
	Set SPAreaName = AreaName
	Where SAPAreaID <> 'CENTRAL'

	Update SAP.BusinessArea
	Set SPAreaName = 'So. Cal / Nevada'
	Where SAPAreaID = 'SOCAL - NEVADA'

	Update SAP.BusinessArea
	Set SPAreaName = null
	Where SAPAreaID = 'SOUTH TEXAS NEW MEXICO'

	-----------------------------------------
	Update SAP.Branch
	Set SPBranchName = BranchName

	Update SAP.Branch
	Set SPBranchName = null
	Where BranchName in ('Northlake Fran Dist', 'Racine Fran Dist', '"jackson', '"hzlwd Dst-Clmbia', '"jeffcty Dst-Clmba' )

	------------ Plains -----------------------
	-------------------------------------------
	Update SAP.Branch
	Set SPBranchName = 'St Joseph'
	Where BranchName = 'St. Joseph'

	Update SAP.Branch
	Set SPBranchName = 'West Fargo'
	Where BranchName = 'Fargo'

	Update SAP.Branch
	Set SPBranchName = 'South St.Paul'
	Where BranchName = 'Twin Cities'

	Update SAP.Branch
	Set SPBranchName = null
	Where BranchName in ('Des Moines Fran Dist', 'Lenexa Fran Dist',
	'Omaha Fran Dist', 'Ottumwa Mfg', 'Twin Cities Fran Dst')

	------------ Southeast --------------------
	-------------------------------------------
	Update SAP.Branch
	Set SPBranchName = 'Mobile'
	Where BranchName = 'Mobile Fran Dist'

	Update SAP.Branch
	Set SPBranchName = 'Ft Myers'
	Where BranchName = 'Fort Myers'

	Update SAP.Branch
	Set SPBranchName = null
	Where BranchName in ('Birmingham Fran Dist', 'Jackson Fran Dist', 'Jacksonville Mfg')

	------------ Pacific - Northwest ----------
	Update SAP.Branch
	Set SPBranchName = 'McKinleyville'
	Where BranchName = 'Eureka'

	Update SAP.Branch
	Set SPBranchName = null
	Where BranchName in ('Sacramento Mfg', 'Vallejo')

	------------ Pacific - So. Cal/Nevada ----------
	Update SAP.Branch
	Set SPBranchName = null
	Where BranchName in ('Buena Park', 'Camarillo', 'Victorville')

	Update SAP.Branch
	Set SPBranchName = 'Los Angeles'
	Where BranchName = 'LA/Vernon' -- There is a split in SP for this

	Update SAP.Branch
	Set SPBranchName = 'LA/Vernon'
	Where BranchName = 'Vernon' -- There is a split in SP for this

	Update SAP.Branch
	Set SPBranchName = 'North Las Vegas'
	Where BranchName = 'Las Vegas'

End