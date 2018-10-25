USE [Portal_Data]
GO

/****** Object:  StoredProcedure [ETL].[pNormalizeLocations]    Script Date: 8/7/2013 3:44:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [ETL].[pNormalizeLocations] 
AS
BEGIN
    -- exec [ETL].[pNormalizeLocations]
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--------------------------------------------
	---- BU ------------------------------------
	-- 1. Extract the source table
	Declare @bu Table
	(
		BUID varchar(50),
		BUName nvarchar(50)
	)
	Insert @bu
	Select Distinct BusinessUnit, BusinessUnit
	From Staging.SalesOffice
	Where BusinessUnit Not In ('Not assigned', '')

	-- 2. Mirror the target table inlcuding checksum
	Declare @sapbu Table
	(
		BUID varchar(50),
		SAPBUID varchar(50),
		BUName nvarchar(50),
		ChangeTrackNumber int
	)
	Insert Into @sapbu
	Select BUID, SAPBUID, BUName, ChangeTrackNumber
	From SAP.BusinessUnit

	-- 3. Merge the mirror with the lastest source
	MERGE @sapbu AS bu
		USING (SELECT BUID,BUName FROM @bu) AS input
			ON bu.SAPBUID = input.BUID
	WHEN MATCHED THEN 
		UPDATE SET bu.BUName = dbo.udf_TitleCase(input.BUName)
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPBUID,BUName)
	VALUES(input.BUID, dbo.udf_TitleCase(input.BUName));
	-- 3.1 Recalculate the Checksum
	Update @sapbu Set ChangeTrackNumber = CheckSum(SAPBUID, BUName)

	-- 4. Update and Insert
	-- 4.1 Insert when no skey is found
	MERGE SAP.BusinessUnit AS bu
		USING (SELECT BUID, SAPBUID, BUName, ChangeTrackNumber FROM @sapbu) AS input
			ON bu.BUID = input.BUID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPBUID, BUName, ChangeTrackNumber, LastModified)
		VALUES(input.SAPBUID, input.BUName, input.ChangeTrackNumber, GetDate());
	-- 4.2 Update when skey is found but the checksum is not right
	Update bu
	Set SAPBUID = sapbu.SAPBUID, BUName = sapbu.BUName, ChangeTrackNumber = sapbu.ChangeTrackNumber, LastModified = GetDate()
	From SAP.BusinessUnit bu 
		Join @sapBU sapbu on bu.BUID = sapbu.BUID And isnull(bu.ChangeTrackNumber, 0) != isnull(sapbu.ChangeTrackNumber, 0)

	--------------------------------------------

	--------------------------------------------
	---Region-------------------------------------
	-- 1. Extract the source table
	Declare @region Table
	(
		SAPBUID varchar(50),
		RegionID varchar(50),
		RegionName nvarchar(50)
	)
	Insert @region
	Select Distinct BusinessUnit, RegionID, Region
	From Staging.SalesOffice
	Where BusinessUnit not in ('Not assigned', '')

	-- 2. Mirror the target table inlcuding checksum
	Declare @sapregion Table
	(
		RegionID int,
		SAPRegionID varchar(50),
		RegionName nvarchar(50),
		BUID int,
		ChangeTrackNumber int
	)
	Insert Into @sapregion
	Select RegionID, SAPRegionID, RegionName, BUID, ChangeTrackNumber
	From SAP.Region

	-- 3. Merge the mirror with the lastest source
	MERGE @SAPRegion AS ba
		USING ( SELECT r.SAPBUID,RegionID,RegionName,bu.BUID 
				FROM @region r Join SAP.BusinessUnit bu on r.SAPBUID = bu.SAPBUID) AS input
			ON ba.SAPRegionID = input.RegionID
	WHEN MATCHED THEN
		UPDATE SET ba.RegionName = dbo.udf_TitleCase(input.RegionName), ba.BUID = input.BUID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPRegionID,RegionName,BUID)
	VALUES(input.RegionID, dbo.udf_TitleCase(input.RegionName), input.BUID);
	-- 3.1. Hardcode to fix the Captitalization
	Update @sapregion
	Set RegionName = 'Metro NY/NJ'
	Where RegionName = 'Metro Ny/Nj'
	Update @sapregion Set ChangeTrackNumber = CHECKSUM(SAPRegionID, RegionName, BUID)

	-- 4. Update and Insert
	-- 4.1 Insert when no skey is found
	MERGE SAP.Region AS ba
		USING ( SELECT RegionID, SAPRegionID, RegionName, BUID, ChangeTrackNumber from @sapRegion) AS input
			ON ba.RegionID = input.RegionID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPRegionID,RegionName,BUID, ChangeTrackNumber, LastModified)
	VALUES(input.SAPRegionID, input.RegionName, input.BUID, input.ChangeTrackNumber, GetDate());

	-- 4.2 Update when skey is found but the checksum is not right
	Update bu
	Set SAPRegionID = sapbu.SAPRegionID, RegionName = sapbu.RegionName, BUID = sapbu.BUID, ChangeTrackNumber = sapbu.ChangeTrackNumber, LastModified = GetDate()
	From SAP.Region bu 
		Join @sapRegion sapbu on bu.RegionID = sapbu.RegionID And isnull(bu.ChangeTrackNumber, 0) != isnull(sapbu.ChangeTrackNumber, 0)

    ----------------------------------------------
	--- Area -------------------------------------
	-- 1. Extract the source table
	Declare @area Table
	(
		SAPRegionID varchar(50),
		AreaID varchar(50),
		AreaName nvarchar(50)
	)
	Insert @area
	Select Distinct RegionID, AreaID, Area
	From Staging.SalesOffice
	Where Area not in ('')

	-- 2. Mirror the target table inlcuding checksum
	Declare @saparea Table
	(
		AreaID int,
		SAPAreaID varchar(50),
		AreaName nvarchar(50),
		RegionID int,
		ChangeTrackNumber int
	)
	Insert Into @saparea
	Select AreaID, SAPAreaID, AreaName, RegionID, ChangeTrackNumber
	From SAP.Area
	
	-- 3. Merge the mirror with the lastest source
	MERGE @SAPArea AS ba
		USING ( SELECT a.SAPRegionID, AreaID, AreaName, r.RegionID
				FROM @area a Join SAP.Region r on r.SAPRegionID = a.SAPRegionID) AS input
			ON ba.SAPAreaID = input.AreaID
	WHEN MATCHED THEN
		UPDATE SET ba.AreaName = dbo.udf_TitleCase(input.AreaName), ba.RegionID = input.RegionID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPAreaID,AreaName,RegionID)
	VALUES(input.AreaID, dbo.udf_TitleCase(input.AreaName), input.RegionID);

	Update @SAPArea Set AreaName = 'Metro NY/NJ I/O' Where AreaName = 'Metro Ny/Nj I/O'
	Update @SAPArea Set AreaName = 'Metro NY/NJ C/O' Where AreaName = 'Metro Ny/Nj C/O'
	Update @SAPArea Set ChangeTrackNumber = CHECKSUM(SAPAreaID, AreaName, RegionID)

	-- 4. Update and Insert
	-- 4.1 Insert when no skey is found
	MERGE SAP.Area AS ba
		USING ( SELECT AreaID, SAPAreaID, AreaName, RegionID, ChangeTrackNumber from @saparea) AS input
			ON ba.AreaID = input.AreaID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPAreaID,AreaName,RegionID, ChangeTrackNumber, LastModified)
	VALUES(input.SAPAreaID, input.AreaName, input.RegionID, input.ChangeTrackNumber, GetDate());

	-- 4.2 Update when skey is found but the checksum is not right
	Update bu
	Set SAPAreaID = sapbu.SAPAreaID, AreaName = sapbu.AreaName, RegionID = sapbu.RegionID, 
			ChangeTrackNumber = sapbu.ChangeTrackNumber, LastModified = GetDate()
	From SAP.Area bu
		Join @sapArea sapbu on bu.AreaID = sapbu.AreaID And isnull(bu.ChangeTrackNumber, 0) != isnull(sapbu.ChangeTrackNumber, 0)

	--------------------------------------------
	---BRANCH-----------------------------------
	-- 1. Extract the source table
	Declare @branch Table
	(
		SAPAreaID varchar(50),
		SalesOfficeID varchar(50),
		SalesOffice nvarchar(50)
	)
	Insert @branch
	Select Distinct AreaID, SalesOfficeID, SalesOffice
	From Staging.SalesOffice
	Where AreaID not in ('')

	Insert @branch values('100029', '1085', 'NEWBURGH')
	Insert @branch values('100023', '1176', 'TULSA')
	
	-- 2. Mirror the target table inlcuding checksum
	Declare @sapbr Table
	(
		BranchID int,
		SAPBranchID varchar(50),
		BranchName varchar(50),
		AreaID int,
		RMLocationID int,
		RMLocationCity varchar(50),
		ChangeTrackNumber int
	)
	Insert Into @sapbr
	Select BranchID, SAPBranchID,BranchName,AreaID,RMLocationID,RMLocationCity,ChangeTrackNumber From SAP.Branch

	-- 3. Merge the mirror with the lastest source
	MERGE @sapbr AS ba
		USING ( SELECT b.SalesOfficeID, b.SalesOffice, area.AreaID, l.Location_ID, l.Location_City
				FROM @branch b 
				Join SAP.Area area on b.SapAreaID = area.SapAreaID
				Left Join Staging.RMLocation l on (b.SalesOfficeID = Left(l.Location_ID, 4))
				) AS input
			ON ba.SAPBranchID = input.SalesOfficeID
	WHEN MATCHED THEN
		UPDATE SET ba.BranchName = dbo.udf_TitleCase(input.SalesOffice),
					ba.AreaID = input.AreaID,
					ba.RMLocationID = Location_ID,
					ba.RMLocationCity = Location_City
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPBranchID,BranchName,AreaID,RMLocationID, RMLocationCity)
	VALUES(input.SalesOfficeID, dbo.udf_TitleCase(input.SalesOffice), input.AreaID, Location_ID, Location_City);
	Update @sapbr Set ChangeTrackNumber = CHECKSUM(SAPBranchID, BranchName, AreaID, RMLocationID, RMLocationCity)

	-- 4. Update and Insert
	-- 4.1 Insert when no skey is found
	MERGE SAP.Branch AS ba
		USING ( SELECT BranchID, SAPBranchID,BranchName,AreaID,RMLocationID,RMLocationCity,ChangeTrackNumber from @sapbr) AS input
			ON ba.BranchID = input.BranchID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPBranchID, BranchName, AreaID, RMLocationID, RMLocationCity, ChangeTrackNumber, LastModified)
	VALUES(input.SAPBranchID, input.BranchName, input.AreaID, input.RMLocationID, input.RMLocationCity, input.ChangeTrackNumber, GetDate());

	-- 4.2 Update when skey is found but the checksum is not right
	Update bu
	Set SAPBranchID = sapbu.SAPBranchID, BranchName = sapbu.BranchName, AreaID = sapbu.AreaID, RMLocationID = sapbu.RMLocationID, 
		RMLocationCity = sapbu.RMLocationCity, ChangeTrackNumber = sapbu.ChangeTrackNumber, LastModified = GetDate()
	From SAP.Branch bu 
		Join @sapbr sapbu on bu.BranchID = sapbu.BranchID And isnull(bu.ChangeTrackNumber, 0) != isnull(sapbu.ChangeTrackNumber, 0)

	--------------------------------------------
	---PROFIT CENTER----------------------------
	-- 1. Extract the source table
	--Select ProfitCenterID, ProfitCenter, SalesOfficeID, SalesOffice
	--From Staging.ProfitCenterToSalesOffice

	-- 2. Mirror the target table inlcuding checksum
	Declare @sppc Table
	(
		ProfitCenterID int,
		SAPProfitCenterID varchar(50),
		ProfitCenterName varchar(64),
		BranchID int,
		BWSalesOfficeID varchar(50),
		BWSalesOffice varchar(50), 
		ChangeTrackNumber int
	)
	Insert Into @sppc(ProfitCenterID, SAPProfitCenterID, ProfitCenterName, BranchID, ChangeTrackNumber)
	Select ProfitCenterID, SAPProfitCenterID, ProfitCenterName, BranchID, ChangeTrackNumber From SAP.ProfitCenter

	-- 3. Merge the mirror with the lastest source
	Declare @temppc Table
	(
		ProfitCenterID varchar(128), 
		ProfitCenter varchar(128), 
		SalesOfficeID varchar(128), 
		SalesOffice varchar(128), 
		BranchID int
	)
	Insert Into @temppc
	SELECT ProfitCenterID, ProfitCenter, SalesOfficeID, SalesOffice, br.BranchID
	FROM Staging.ProfitCenterToSalesOffice p Left Join SAP.Branch br on p.SalesOfficeID = br.SAPBranchID
	Where ISNUMERIC(ProfitCenterID) = 1 And ProfitCenterID != '101196.'

	MERGE @sppc AS ba
		USING (Select Convert(bigint, ProfitCenterID) ProfitCenterID, ProfitCenter, SalesOfficeID, SalesOffice, BranchID From @temppc) AS input
			ON ba.SAPProfitCenterID = input.ProfitCenterID
	WHEN MATCHED THEN
		UPDATE SET ba.ProfitCenterName = dbo.udf_TitleCase(input.ProfitCenter),
			ba.BranchID = input.BranchID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPProfitCenterID, ProfitCenterName, BranchID)
	VALUES(case when ISNUMEric(input.ProfitCenterID) = 1 Then Convert(bigint, input.ProfitCenterID) Else input.ProfitCenterID End, dbo.udf_TitleCase(input.ProfitCenter), input.BranchID);
	Update @sppc Set ChangeTrackNumber = CHECKSUM(SAPProfitCenterID, ProfitCenterName, BranchID);

	-- 4. Update and Insert
	-- 4.1 Insert when no skey is found
	MERGE SAP.ProfitCenter AS ba
		USING ( SELECT ProfitCenterID, SAPProfitCenterID, ProfitCenterName, BranchID,ChangeTrackNumber from @sppc) AS input
			ON ba.ProfitCenterID = input.ProfitCenterID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPProfitCenterID, ProfitCenterName, BranchID, ChangeTrackNumber, LastModified)
	VALUES(input.SAPProfitCenterID, input.ProfitCenterName, input.BranchID, input.ChangeTrackNumber, GetDate());

	-- 4.2 Update when skey is found but the checksum is not right
	Update bu
	Set SAPProfitCenterID = sapbu.SAPProfitCenterID, ProfitCenterName = sapbu.ProfitCenterName, BranchID = sapbu.BranchID, 
		ChangeTrackNumber = sapbu.ChangeTrackNumber, LastModified = GetDate()
	From SAP.ProfitCenter bu 
		Join @sppc sapbu on bu.ProfitCenterID = sapbu.ProfitCenterID And isnull(bu.ChangeTrackNumber, 0) != isnull(sapbu.ChangeTrackNumber, 0)


	--------------------------------------------
	---COST CENTER----------------------------
	--Select CostCenterID, CostCenter, ProfitCenterID
	--From Staging.CostCenterToProfitCenter
	
	-- 2. Mirror the target table inlcuding checksum
	Declare @sapcc Table
	(
		CostCenterID int,
		SAPCostCenterID varchar(64),
		CostCenterName varchar(64),
		ProfitCenterID int,
		ChangeTrackNumber int
	)
	Insert Into @sapcc(CostCenterID, SAPCostCenterID, CostCenterName, ProfitCenterID, ChangeTrackNumber)
	Select CostCenterID, SAPCostCenterID, CostCenterName, ProfitCenterID, ChangeTrackNumber From SAP.CostCenter

	-- 3. Merge the mirror with the lastest source
	MERGE @sapcc AS ba
		USING ( Select c.CostCenterID, c.CostCenter, pc.ProfitCenterID
				From Staging.CostCenterToProfitCenter c Left Join SAP.ProfitCenter pc on convert(bigint, c.ProfitCenterID) = pc.SAPProfitCenterID
			  ) AS input
			ON ba.SAPCostCenterID = case when isnumeric(input.CostCenterID) = 1 then convert(bigint, input.CostCenterID) else input.CostCenterID end
	WHEN MATCHED THEN
		UPDATE SET ba.CostCenterName = dbo.udf_TitleCase(input.CostCenter), ba.ProfitCenterID = input.ProfitCenterID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPCostCenterID, CostCenterName, ProfitCenterID)
	VALUES(case when isnumeric(input.CostCenterID) = 1 then convert(bigint, input.CostCenterID) else input.CostCenterID end, dbo.udf_TitleCase(input.CostCenter), input.ProfitCenterID);
	Update @sapcc Set ChangeTrackNumber = CHECKSUM(SAPCostCenterID, CostCenterName, ProfitCenterID);
	
	-- 4. Update and Insert
	-- 4.1 Insert when no skey is found
	MERGE SAP.CostCenter AS ba
		USING @sapcc AS input
		ON ba.CostCenterID = input.CostCenterID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPCostCenterID, CostCenterName, ProfitCenterID, ChangeTrackNumber, LastModified)
	VALUES(input.SAPCostCenterID, input.CostCenterName, input.ProfitCenterID, input.ChangeTrackNumber, GetDate());

	-- 4.2 Update when skey is found but the checksum is not right
	Update bu
	Set SAPCostCenterID = sapbu.SAPCostCenterID, CostCenterName = sapbu.CostCenterName, ProfitCenterID = sapbu.ProfitCenterID, 
		ChangeTrackNumber = sapbu.ChangeTrackNumber, LastModified = GetDate()
	From SAP.CostCenter bu 
		Join @sapcc sapbu on bu.CostCenterID = sapbu.CostCenterID And isnull(bu.ChangeTrackNumber, 0) != isnull(sapbu.ChangeTrackNumber, 0)
	
	-------------------------------------------------
	------------- Update SPName for locations -------
	----Update SAP.BusinessUnit
	----Set SPBUName = BUName

	----Update SAP.Region
	----Set SPRegionName = RegionName
	----Where SAPRegionID <> 'CENTRAL'

	----Update SAP.Region
	----Set SPRegionName = 'So. Cal / Nevada'
	----Where SAPRegionID = 'SOCAL - NEVADA'

	----Update SAP.Region
	----Set SPRegionName = null
	----Where SAPRegionID = 'SOUTH TEXAS NEW MEXICO'

	---------------------------------------------
	----Update SAP.Branch
	----Set SPBranchName = BranchName

	----Update SAP.Branch
	----Set SPBranchName = null
	----Where BranchName in ('Northlake Fran Dist', 'Racine Fran Dist', '"jackson', '"hzlwd Dst-Clmbia', '"jeffcty Dst-Clmba' )

	---------------- Plains -----------------------
	-----------------------------------------------
	----Update SAP.Branch
	----Set SPBranchName = 'St Joseph'
	----Where BranchName = 'St. Joseph'

	----Update SAP.Branch
	----Set SPBranchName = 'West Fargo'
	----Where BranchName = 'Fargo'

	----Update SAP.Branch
	----Set SPBranchName = 'South St.Paul'
	----Where BranchName = 'Twin Cities'

	----Update SAP.Branch
	----Set SPBranchName = null
	----Where BranchName in ('Des Moines Fran Dist', 'Lenexa Fran Dist',
	----'Omaha Fran Dist', 'Ottumwa Mfg', 'Twin Cities Fran Dst')

	---------------- Southeast --------------------
	-----------------------------------------------
	----Update SAP.Branch
	----Set SPBranchName = 'Mobile'
	----Where BranchName = 'Mobile Fran Dist'

	----Update SAP.Branch
	----Set SPBranchName = 'Ft Myers'
	----Where BranchName = 'Fort Myers'

	----Update SAP.Branch
	----Set SPBranchName = null
	----Where BranchName in ('Birmingham Fran Dist', 'Jackson Fran Dist', 'Jacksonville Mfg')

	---------------- Pacific - Northwest ----------
	----Update SAP.Branch
	----Set SPBranchName = 'McKinleyville'
	----Where BranchName = 'Eureka'

	----Update SAP.Branch
	----Set SPBranchName = null
	----Where BranchName in ('Sacramento Mfg', 'Vallejo')

	---------------- Pacific - So. Cal/Nevada ----------
	----Update SAP.Branch
	----Set SPBranchName = null
	----Where BranchName in ('Buena Park', 'Camarillo', 'Victorville')

	----Update SAP.Branch
	----Set SPBranchName = 'Los Angeles'
	----Where BranchName = 'LA/Vernon' -- There is a split in SP for this

	----Update SAP.Branch
	----Set SPBranchName = 'LA/Vernon'
	----Where BranchName = 'Vernon' -- There is a split in SP for this

	----Update SAP.Branch
	----Set SPBranchName = 'North Las Vegas'
	----Where BranchName = 'Las Vegas'

End
Go

USE [Portal_Data]
GO
/****** Object:  StoredProcedure [ETL].[pLoadUserProfile]    Script Date: 8/7/2013 4:00:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------
------Load User Profile --------------------------------
ALTER PROCEDURE [ETL].[pLoadUserProfile] 
AS
BEGIN
	--------------------------------------------
	---User Profile ----------------------------
	MERGE Person.UserProfile AS up
		USING ( Select hr.UserID, hr.FirstName, hr.LastName, hr.EmpID, cc.CostCenterID, pc.ProfitCenterID, b.BranchID, a.AreaID, r.RegionID, bu.BUID, hr.JobCode, hr.ManagerGSN
				From [Staging].[ADExtractData] hr
				Left Join Person.userprofile up1 on hr.userid = up1.gsn
				Left Join SAP.CostCenter cc on cc.SAPCostCenterID = substring(hr.CostCenter, patindex('%[^0]%',hr.CostCenter), 10)  
				Left Join SAP.ProfitCenter pc on pc.ProfitCenterID = cc.ProfitCenterID
				Left Join SAP.Branch b on pc.BranchId = b.BranchID
				Left Join SAP.Area a on a.AreaID = b.AreaID
				Left Join SAP.Region r on a.RegionID = r.RegionID
				Left Join SAP.BusinessUnit bu on bu.BUID = r.BUID
				where IsNull(up1.ManualSetup, 0) = 0 
				And hr.ManagerGSN in (Select GSN From Person.userprofile) ) AS input
					ON up.GSN = input.UserID
	WHEN MATCHED THEN
		UPDATE SET up.BUID = input.BUID,
					up.AreaID = input.AreaID,
					up.RegionID = input.RegionID,
					up.PrimaryBranchID = input.BranchID,
					up.ProfitCenterID = input.ProfitCenterID,
					up.CostCenterID = input.CostCenterID,
					up.FirstName = input.FirstName,
					up.LastName = input.LastName,
					up.EmpID = input.EmpID,		
					up.JobCode = input.JobCode,
					up.ManagerGSN = input.ManagerGSN
	WHEN NOT MATCHED By Target THEN
		INSERT(GSN, BUID, AreaID, RegionID, PrimaryBranchID, ProfitCenterID, 
			CostCenterID, FirstName, LastName, EmpID, JobCode, ManualSetup, ManagerGSN)
		VALUES(input.UserID, input.BUID, input.AreaID, input.RegionID, input.BranchID, input.ProfitCenterID, 
			input.CostCenterID, input.FirstName, input.LastName, input.EmpID, input.JobCode, 0, ManagerGSN);
	
	--------------------------------------------
	---SP User Profile -------------------------
	MERGE Person.SPUserProfile AS sup
		USING ( Select hr.UserID, hr.FirstName, hr.LastName, hr.EmpID, cc.CostCenterID, pc.ProfitCenterID, 
						b.BranchID, area.AreaID, a.RegionID, bu.BUID, hr.Title, b.BranchName, a.RegionName, BU.BUName, area.AreaName, area.SAPAreaID,
						b.SAPBranchID, a.SAPRegionID, bu.SAPBUID,
						role.RoleID, role.RoleName
				From [Staging].[ADExtractData] hr
				Join SAP.CostCenter cc on cc.SAPCostCenterID = substring(hr.CostCenter, patindex('%[^0]%',hr.CostCenter), 10)  
				Join SAP.ProfitCenter pc on pc.ProfitCenterID = cc.ProfitCenterID
				Join SAP.Branch b on pc.BranchId = b.BranchID
				Join SAP.Area area on area.AreaID = b.AreaID
				Join SAP.Region a on area.RegionID = a.RegionID
				Join SAP.BusinessUnit bu on bu.BUID = a.BUID
				left outer join Person.userprofile up1 on hr.userid = up1.gsn
				Left Outer join Person.Job job on job.SAPHRJobNumber = hr.JobCode
				Left Outer join Person.Role role on role.RoleID = job.RoleID
				where IsNull(up1.ManualSetup, 0) = 0 And hr.UserID in (Select GSN From Person.userprofile) ) AS input
					ON sup.GSN = input.UserID
	WHEN MATCHED 
		and (sup.PrimaryBranch <> '{"AreaId":' + convert(varchar, input.AreaID) + ',"SAPAreaID":"' + convert(varchar, input.SAPAreaID) + ',"AreaName":"' + convert(varchar, input.AreaName) 
			+ '","RegionId":' + convert(varchar, input.RegionId) + ',"SAPRegionID":"' + convert(varchar, input.SAPRegionID) + ',"RegionName":"' + input.RegionName 
			+ '","BUId":' + convert(varchar, input.BUID) + ',"SAPBUID":"' + convert(varchar, input.SAPBUID) + ',"BUName":"' + input.BUName 
			+ '","BranchId":' + convert(varchar, input.BranchID) + ',"SAPBranchID":"' + convert(varchar, input.SAPBranchID) + ',"BranchName":"'+ input.BranchName +'"}'
		or sup.RoleID <> input.RoleID)
		THEN
		UPDATE SET sup.GSN = input.UserID,
					sup.PrimaryBranch = '{"AreaId":' + convert(varchar, input.AreaID) + ',"SAPAreaID":"' + convert(varchar, input.SAPAreaID) + ',"AreaName":"' + convert(varchar, input.AreaName) 
					+ '","RegionId":' + convert(varchar, input.RegionId) + ',"SAPRegionID":"' + convert(varchar, input.SAPRegionID) + ',"RegionName":"' + input.RegionName 
					+ '","BUId":' + convert(varchar, input.BUID) + ',"SAPBUID":"' + convert(varchar, input.SAPBUID) + ',"BUName":"' + input.BUName 
					+ '","BranchId":' + convert(varchar, input.BranchID) + ',"SAPBranchID":"' + convert(varchar, input.SAPBranchID) + ',"BranchName":"'+ input.BranchName +'"}',
					sup.PrimaryRole = input.RoleName,
					sup.RoleID = input.RoleID,
					sup.updatedinsp = 0
	WHEN NOT MATCHED By Target THEN
		INSERT(GSN, PrimaryBranch, PrimaryRole, RoleID)
	VALUES(	input.UserID, '{"AreaId":' + convert(varchar, input.AreaID) + ',"SAPAreaID":"' + convert(varchar, input.SAPAreaID) + ',"AreaName":"' + convert(varchar, input.AreaName) 
					+ '","RegionId":' + convert(varchar, input.RegionId) + ',"SAPRegionID":"' + convert(varchar, input.SAPRegionID) + ',"RegionName":"' + input.RegionName 
					+ '","BUId":' + convert(varchar, input.BUID) + ',"SAPBUID":"' + convert(varchar, input.SAPBUID) + ',"BUName":"' + input.BUName 
					+ '","BranchId":' + convert(varchar, input.BranchID) + ',"SAPBranchID":"' + convert(varchar, input.SAPBranchID) + ',"BranchName":"'+ input.BranchName +'"}',
			input.RoleName, 
			 input.RoleID);

	-----SP User Profile Role-------------------------
	MERGE Person.UserInRole AS uir
		USING ( Select hr.UserID, role.RoleID, role.RoleName
				From [Staging].[ADExtractData] hr
				join Person.userprofile up1 on hr.userid = up1.gsn
				join Person.Job job on job.SAPHRJobNumber = hr.JobCode
				join Person.Role role on role.RoleID = job.RoleID
				where IsNull(up1.ManualSetup, 0) = 0) AS input
					ON uir.GSN = input.UserID and uir.IsPrimary = 1
	WHEN MATCHED THEN
		UPDATE SET uir.RoleID= input.RoleID
	WHEN NOT MATCHED By Target THEN
		INSERT(GSN, RoleID, IsPrimary)
		VALUES(	input.UserID, input.RoleId,1)
	--WHEN NOT MATCHED By Source Then
		--Delete 
		;

	-----User in Branch Table-------------------------
	MERGE Person.UserInBranch AS uib
		USING ( Select hr.UserID, up1.PrimaryBranchID
				From [Staging].[ADExtractData] hr
				join Person.userprofile up1 on hr.userid = up1.gsn
				where IsNull(up1.ManualSetup, 0) = 0 and not up1.PrimaryBranchId is null ) AS input
				ON uib.GSN = input.UserID and uib.IsPrimary = 1
	WHEN MATCHED THEN
		UPDATE SET uib.BranchId = input.PrimaryBranchID
	WHEN NOT MATCHED By Target THEN
		INSERT(GSN, BranchID, IsPrimary)
		VALUES(	input.UserID, input.PrimaryBranchID, 1);

End
Go
