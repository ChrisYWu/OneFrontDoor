---- Executed on 5/23/2013 14:45 ----

USE [Portal_Data]
GO

-------------------------------------------------------
--Staging----------------------------------------------

If Exists (Select * From Sys.objects where object_id = object_id('Staging.RMEmployee'))
Begin
 DROP TABLE [Staging].[RMEmployee]
End
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Staging].[RMEmployee](
	[EMPLOYEEID] [nvarchar](10) NOT NULL,
	[JOBROLE] [nvarchar](20) NOT NULL,
	[FIRSTNAME] [nvarchar](20) NOT NULL,
	[LASTNAME] [nvarchar](20) NOT NULL,
	[LOCATION_ID] [nvarchar](8) NOT NULL,
	[ACTIVE] [numeric](1, 0) NULL,
	[GSN] [nvarchar](20) NULL
) ON [PRIMARY]

GO

ALTER Proc [ETL].[pStageRM]
AS
	/*
	1. Location
	2. Accounts
	3. Route Master
	4. Route Schedule
	5. Item Master
	6. Package
	7. Employee

	*/

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	-- 1. Locations
	Truncate Table Staging.RMLocation

	Insert Into Staging.RMLocation(LOCATION_ID, LOCATION_NAME, LOCATION_ADDR1, LOCATION_ADDR2, LOCATION_CITY, LOCATION_STATE, LOCATION_ZIP, LOCATION_PHONE, LOCATION_FAX, COMPANY_NAME, SUPPLIER_LOCATION_NUMBER)
	SElect LOCATION_ID, LOCATION_NAME, LOCATION_ADDR1, LOCATION_ADDR2, LOCATION_CITY, LOCATION_STATE, LOCATION_ZIP, LOCATION_PHONE, LOCATION_FAX, COMPANY_NAME, SUPPLIER_LOCATION_NUMBER
	From RM..ACEUSER.LOCATION;

	-- 2. Load Accounts into Staging
	Truncate Table Staging.RMAccount;

	INSERT INTO Staging.RMAccount(CUSTOMER_NUMBER, LOCATION_ID, CUSTOMER_NAME, CUSTOMER_STREET, CITY, STATE
			, POSTAL_CODE, CONTACT_PERSON, PHONE_NUMBER, LOCAL_CHAIN, CHANNEL, ACTIVE)
	Select CUSTOMER_NUMBER, LOCATION_ID, CUSTOMER_NAME, CUSTOMER_STREET, CITY, STATE
			,POSTAL_CODE, CONTACT_PERSON, PHONE_NUMBER, LOCAL_CHAIN, CHANNEL, ACTIVE
	From RM..ACEUSER.CUSTOMERS

	-- 3. Route Master
	Truncate Table Staging.RMRouteMaster;

	Insert Into Staging.RMRouteMaster(ROUTE_NUMBER, ROUTE_DESCRIPTION, ACTIVE_ROUTE, ROUTE_TYPE, LOCATION_ID, DEFAULT_EMPLOYEE, ACTIVE)
	Select ROUTE_NUMBER, ROUTE_DESCRIPTION, ACTIVE_ROUTE, ROUTE_TYPE, LOCATION_ID, DEFAULT_EMPLOYEE, ACTIVE	
	From RM..ACEUSER.ROUTE_MASTER

	-----------------------------------------------------
	-- 4. RouteSchedule ----------------------------------
	Truncate Table Staging.RMRouteSchedule;

	Insert Into Staging.RMRouteSchedule(ROUTE_NUMBER,CUSTOMER_NUMBER,LOCATION_ID,FREQUENCY,START_DATE,DEFAULT_DELIV_ROUTE,SEQUENCE_NUMBER,SEASONAL,SEASONAL_START_DATE,SEASONAL_END_DATE)
	Select		ROUTE_NUMBER,CUSTOMER_NUMBER,LOCATION_ID,FREQUENCY,START_DATE,DEFAULT_DELIV_ROUTE,SEQUENCE_NUMBER,SEASONAL,SEASONAL_START_DATE,SEASONAL_END_DATE
	From RM..ACEUSER.ROUTE_SCHEDULE;

	-----------------------------------------------------
	-- 5. ItemMaster ----------------------------------
	Truncate Table Staging.RMItemMaster

	Insert Into Staging.RMItemMaster
	Select Distinct Location_ID, ITEM_NUMBER
	From RM..ACEUSER.ITEM_MASTER
	Where Active = 1
		
	--------------------------------------------
	-- 6. Package -------------------------------
	--Load Packages into Staging
	Truncate Table Staging.RMPackage

	Insert Into Staging.RMPackage
	Select PACKAGEID, DESCRIPTION, Substring(PACKAGEID, 1, 3) SAPPackageTypeID, SUBSTRING(PACKAGEID, 4, 2) SAPPackageConfigID
	From RM..ACEUSER.PACKAGE;

	--------------------------------------------------------
	-- 7. Employee -----------------------------------------
	Truncate Table Staging.RMEmployee

	Insert Into Staging.RMEmployee
	Select EMPLOYEEID, JOBROLE, FIRSTNAME, LASTNAME, LOCATION_ID, ACTIVE, GSN
	From RM..ACEUSER.EMPLOYEES
Go

-------------------------------------------------------
--Dropping existing table that are not used -----------
If Exists (Select * From Sys.objects where object_id = object_id('Person.Employee'))
Begin
	DROP TABLE Person.Employee
End
GO

--------------------------------------------------------
--------Manager GSN-------------------------------------
If Not Exists (Select * From sys.columns Where name = 'ManagerGSN' and Object_id = object_id('Person.UserProfile'))
Begin
	Alter Table Person.UserProfile
	Add ManagerGSN Varchar(50)

	ALTER TABLE [Person].[UserProfile]  WITH CHECK ADD CONSTRAINT [FK_UserProfile_ManagerGSN] FOREIGN KEY(ManagerGSN)
	REFERENCES Person.UserProfile (GSN)
End
Go

--------------------------------------------------------
----DefaultAccountManagerGSN----------------------------
If Not Exists (Select * From sys.columns Where name = 'DefaultAccountManagerGSN' and Object_id = object_id('SAP.SalesRoute'))
Begin
	Alter Table SAP.SalesRoute
	Add DefaultAccountManagerGSN Varchar(50)

	Alter Table SAP.SalesRoute
	Drop Column DefaultEmployeeID

	ALTER TABLE [SAP].[SalesRoute]  WITH CHECK ADD CONSTRAINT [FK_SalesRoute_UserProfile] FOREIGN KEY(DefaultAccountManagerGSN)
	REFERENCES Person.UserProfile (GSN)
End
Go
--------------------------------------------------------
----Account Manager Role--------------------------------

SET IDENTITY_INSERT [Person].[Role] ON 
GO
INSERT [Person].[Role] ([RoleID], [RoleName], [RoleShortName], [RoleScope], [ADGroupName]) VALUES (23039, N'Account Manager', 'AM', NULL, NULL)
GO
SET IDENTITY_INSERT [Person].[Role] Off 
Go

Insert Person.Job
Select Distinct JobCode, 23039
From Staging.ADExtractData
Where Title in ('Account Manager Bulk', 'Account Manager UDS', 'Account Manager Combination')
Go

--------------------------------------------------------
------Load User Profile --------------------------------
ALTER PROCEDURE [ETL].[pLoadUserProfile] 
AS
BEGIN
	--------------------------------------------
	---User Profile ----------------------------
	MERGE Person.UserProfile AS up
		USING ( Select hr.UserID, hr.FirstName, hr.LastName, hr.EmpID, cc.CostCenterID, pc.ProfitCenterID, b.BranchID, a.RegionID, bu.BUID, hr.JobCode, hr.ManagerGSN
				From [Staging].[ADExtractData] hr
				Left Join Person.userprofile up1 on hr.userid = up1.gsn
				Left Join SAP.CostCenter cc on cc.SAPCostCenterID = substring(hr.CostCenter, patindex('%[^0]%',hr.CostCenter), 10)  
				Left Join SAP.ProfitCenter pc on pc.ProfitCenterID = cc.ProfitCenterID
				Left Join SAP.Branch b on pc.BranchId = b.BranchID
				Left Join SAP.Region a on a.RegionID = b.RegionID
				Left Join SAP.BusinessUnit bu on bu.BUID = a.BUID
				where IsNull(up1.ManualSetup, 0) = 0 ) AS input
					ON up.GSN = input.UserID
	WHEN MATCHED THEN
		UPDATE SET up.BUID = input.BUID,
					up.AreaID = input.RegionID,
					up.PrimaryBranchID = input.BranchID,
					up.ProfitCenterID = input.ProfitCenterID,
					up.CostCenterID = input.CostCenterID,
					up.FirstName = input.FirstName,
					up.LastName = input.LastName,
					up.EmpID = input.EmpID,		
					up.JobCode = input.JobCode,
					up.ManagerGSN = input.ManagerGSN
	WHEN NOT MATCHED By Target THEN
		INSERT(GSN, BUID, AreaID, PrimaryBranchID, ProfitCenterID, CostCenterID, FirstName, LastName, EmpID, JobCode, ManualSetup, ManagerGSN)
		VALUES(input.UserID, input.BUID, input.RegionID, input.BranchID, input.ProfitCenterID, input.CostCenterID, input.FirstName, input.LastName, input.EmpID, input.JobCode, 0, ManagerGSN);
	
	--------------------------------------------
	---SP User Profile -------------------------
	MERGE Person.SPUserProfile AS sup
		USING ( Select hr.UserID, hr.FirstName, hr.LastName, hr.EmpID, cc.CostCenterID, pc.ProfitCenterID, 
						b.BranchID, a.RegionID, bu.BUID, hr.Title, b.BranchName, a.RegionName, BU.BUName,
						b.SAPBranchID, a.SAPRegionID, bu.SAPBUID,
						role.RoleID, role.RoleName
				From [Staging].[ADExtractData] hr
				Join SAP.CostCenter cc on cc.SAPCostCenterID = substring(hr.CostCenter, patindex('%[^0]%',hr.CostCenter), 10)  
				Join SAP.ProfitCenter pc on pc.ProfitCenterID = cc.ProfitCenterID
				Join SAP.Branch b on pc.BranchId = b.BranchID
				Join SAP.Region a on a.RegionID = b.RegionID
				Join SAP.BusinessUnit bu on bu.BUID = a.BUID
				left outer join Person.userprofile up1 on hr.userid = up1.gsn
				Left Outer join Person.Job job on job.SAPHRJobNumber = hr.JobCode
				Left Outer join Person.Role role on role.RoleID = job.RoleID
				where IsNull(up1.ManualSetup, 0) = 0 And hr.UserID in (Select GSN From Person.userprofile) ) AS input
					ON sup.GSN = input.UserID
	WHEN MATCHED 
		and (sup.PrimaryBranch <> '{"AreaId":,"AreaName":"","BUId":' + convert(varchar, input.BUID) + ',"BUName":"' + input.BUName + '","BranchId":' + convert(varchar, input.BranchID) + ',"BranchName":"'+ input.BranchName +'"}'
		or sup.RoleID <> input.RoleID)
		THEN
		UPDATE SET sup.GSN = input.UserID,
					--{"AreaId":9,"AreaName":"Northwest","BUId":11,"BUName":"Pacific","BranchId":116,"BranchName":"Fremont"}
					sup.PrimaryBranch = '{"AreaId":,"AreaName":"","BUId":' + convert(varchar, input.BUID) + ',"BUName":"' + input.BUName + '","BranchId":' + convert(varchar, input.BranchID) + ',"BranchName":"'+ input.BranchName +'"}',
					--sup.PrimaryBranch = input.BranchName + '|SAP:'  + input.SAPBranchID + '|ID:' + '0',
					sup.PrimaryRole = input.RoleName,
					--sup.PrimaryArea = input.RegionName + '|SAP:' + input.SAPRegionID + '|ID:' + '0',
					--sup.PrimaryBU = input.BUName + '|SAP:' + input.SAPBUID + '|ID:' + '0',
					sup.RoleID = input.RoleID,
					sup.updatedinsp = 0
	WHEN NOT MATCHED By Target THEN
		INSERT(GSN, PrimaryBranch, PrimaryRole, RoleID)
	VALUES(	input.UserID, '{"AreaId":,"AreaName":"","BUId":' + convert(varchar, input.BUID)+ ',"BUName":"' + input.BUName + '","BranchId":' + convert(varchar, input.BranchID) + ',"BranchName":"'+ input.BranchName +'"}',
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
----------------------------------------------------------
------Account Manager View--------------------------------
--If Exists (Select * From sys.objects where object_id = object_id('MView.AccountManager'))
--Begin
--	Drop View MView.AccountManager
--End
--Go

--------------------------------------------------------
------Load Sales Route ---------------------------------
ALTER PROCEDURE [ETL].[pLoadFromRM] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--------------------------------------------------------
	---Package----------------------------------------------
	Declare @sappk Table
	(
		PackageID int,
		RMPackageID varchar(10),
		PackageTypeID int,
		PackageConfID int,
		PackageName varchar(50),
		Source varchar(50),
		Active varchar(50),
		ChangeTrackNumber int
	)
	Insert @sappk
	Select PackageID, RMPackageID, PackageTypeID, PackageConfID, PackageName, Source, Active, ChangeTrackNumber 
	From SAP.Package

	MERGE @sappk AS a
	USING (Select p.PACKAGEID, pt.PackageTypeID, pc.PackageConfID, 
			Replace(Replace(dbo.udf_TitleCase(p.Description), 'Oz', 'OZ'), 'Ls', 'LS') PackageName
			,0 Active
			,Replace(Replace(dbo.udf_TitleCase(p.Description), 'Oz', 'OZ'), 'Ls', 'LS') SPPackageName 
		From Staging.RMPackage p
			Left Join SAP.PackageType pt on p.SAPPackageTypeID = pt.SAPPackageTypeID
			Left Join SAP.PackageConf pc on p.SAPPackageConfigID = pc.SAPPackageConfID
		  ) AS input
		ON a.RMPackageID = input.PACKAGEID
	WHEN MATCHED THEN 
		UPDATE SET PackageTypeID = input.PackageTypeID,
					PackageConfID = input.PackageConfID,
					PackageName = input.PackageName,
					Source = 'RouteManager'
	WHEN NOT MATCHED By Source THEN
		UPDATE SET Active = 0
	WHEN NOT MATCHED By Target THEN
		INSERT ([RMPackageID]
           ,[PackageTypeID]
           ,[PackageConfID]
           ,[PackageName]
           ,Source
		   ,Active)
		 VALUES
			   (PACKAGEID
			   ,PackageTypeID
			   ,PackageConfID
			   ,[PackageName]
			   ,'RouteManager'
			   ,Active);

	MERGE @sappk AS bu
	USING (Select Distinct Rtrim(mbp.PackTypeID) + Rtrim(mbp.PackConfID) PACKAGEID, 
							Replace(Replace(Replace(dbo.udf_TitleCase(Rtrim(mbp.PackType) + ' ' + Rtrim(mbp.PackConf)), 'Oz', 'OZ'), 'Ls', 'LS'), 'pk', 'PK') PACKAGEName
							,pc.PackageConfID, pt.PackageTypeID								
			From Staging.MaterialBrandPKG mbp
			   	Join SAP.PackageConf pc on mbp.PackConfID = pc.SAPPackageConfID
				Join SAP.PackageType pt on mbp.PackTypeID = pt.SAPPackageTypeID) AS input
		ON bu.RMPackageID = input.PACKAGEID
	WHEN MATCHED THEN 
		UPDATE SET bu.Active = 1
	WHEN NOT MATCHED By Source THEN
		UPDATE SET bu.Active = 0
	WHEN NOT MATCHED By Target THEN
				INSERT ([RMPackageID]
           ,[PackageTypeID]
           ,[PackageConfID]
           ,[PackageName]
           ,Active
           ,Source)
		 VALUES
			   (PACKAGEID
			   ,PackageTypeID
			   ,PackageConfID
			   ,Case When [PackageName] = 'Not Assigned Not Assigned' Then 'Not Assigned' Else PackageName End
			   ,1
			   ,'SAPBW');

	Update @sappk Set ChangeTrackNumber = CHECKSUM(RMPackageID, PackageTypeID, PackageConfID, PackageName, Source, Active)

	MERGE SAP.Package AS pc
	USING @sappk AS input
			ON pc.PackageID = input.PackageID
	WHEN NOT MATCHED By Target THEN
		INSERT(RMPackageID, PackageTypeID, PackageConfID, PackageName, Source, Active, ChangeTrackNumber, LastModified)
	VALUES(input.RMPackageID, input.PackageTypeID, input.PackageConfID, input.PackageName, input.Source, input.Active, input.ChangeTrackNumber, GetDate());

	Update sdm
	Set RMPackageID = sap.RMPackageID, PackageTypeID = sap.PackageTypeID, PackageConfID = sap.PackageConfID, PackageName = sap.PackageName, 
		Source = sap.Source, Active = sap.Active, FriendlyName = sap.PackageName, ChangeTrackNumber = sap.ChangeTrackNumber, LastModified = GetDate()
	From @sappk sap
	Join SAP.Package sdm on sap.PackageID = sdm.PackageID and sap.ChangeTrackNumber != isnull(sdm.ChangeTrackNumber, 0)

	--------------------------------------------
	---- Account -------------------------------
	-- Merge From BW records
	MERGE SAP.Account AS a
		USING ( select CUSTOMER_NUMBER, max(CUSTOMER_NAME) CUSTOMER_NAME, max(CUSTOMER_STREET) CUSTOMER_STREET, max(CITY) CITY, max(STATE) STATE, max(POSTAL_CODE) POSTAL_CODE,
				max(CONTACT_PERSON) CONTACT_PERSON, max(PHONE_NUMBER) PHONE_NUMBER, max(BranchID) BranchID, max(ChannelID) ChannelID, max(LocalChainID) LocalChainID
				from (Select convert(bigint, CUSTOMER_NUMBER) CUSTOMER_NUMBER, CUSTOMER_NAME, CUSTOMER_STREET, CITY, STATE, POSTAL_CODE,
							CONTACT_PERSON, PHONE_NUMBER, b.BranchID, c.ChannelID, lc.LocalChainID
						From Staging.BWAccount a
							Left Join Staging.AccountDetails ad on ISNUMERIC(ad.SAPAccountNumber) = 1 And convert(bigint, a.CUSTOMER_NUMBER) = convert(bigint, ad.SAPAccountNumber)
							Left Join SAP.Branch b on b.SAPBranchID = ad.SAPBranchID
							Left Join SAP.CHANNEL c on ad.SAPChannelID = c.SAPChannelID
							Left Join SAP.LocalChain lc on Right(ad.SAPLocalChainID, 7) = lc.SAPLocalChainID
						) tmp
				group by CUSTOMER_NUMBER
			  ) AS input
	--USING (Select convert(bigint, CUSTOMER_NUMBER) CUSTOMER_NUMBER, CUSTOMER_NAME, CUSTOMER_STREET, CITY, STATE, POSTAL_CODE,
	--			CONTACT_PERSON, PHONE_NUMBER, b.BranchID, c.ChannelID, lc.LocalChainID
	--		From Staging.BWAccount a
	--			Left Join Staging.AccountDetails ad on ISNUMERIC(ad.SAPAccountNumber) = 1 And convert(bigint, a.CUSTOMER_NUMBER) = convert(bigint, ad.SAPAccountNumber)
	--			Left Join SAP.Branch b on b.SAPBranchID = ad.SAPBranchID
	--			Left Join SAP.CHANNEL c on ad.SAPChannelID = c.SAPChannelID
	--			Left Join SAP.LocalChain lc on Right(ad.SAPLocalChainID, 7) = lc.SAPLocalChainID
	--	  ) AS input
		ON a.SAPAccountNumber = input.CUSTOMER_NUMBER
	WHEN MATCHED THEN 
		UPDATE SET [AccountName] = dbo.udf_TitleCase(input.CUSTOMER_NAME)
		  ,[ChannelID] = input.ChannelID
		  ,[BranchID] = input.BranchID
		  ,[LocalChainID] = input.LocalChainID
		  ,[Address] = dbo.udf_TitleCase(input.CUSTOMER_STREET)
		  ,[City] = dbo.udf_TitleCase(input.CITY)
		  ,[State] = input.STATE
		  ,[PostalCode] = input.POSTAL_CODE
		  ,[Contact] = dbo.udf_TitleCase(input.CONTACT_PERSON)
		  ,[PhoneNumber] = input.PHONE_NUMBER
	WHEN NOT MATCHED By Target THEN
		INSERT (SAPAccountNumber
			   ,[AccountName]
			   ,[BranchID]
			   ,[Address]
			   ,[City]
			   ,[State]
			   ,[PostalCode]
			   ,[Contact]
			   ,[PhoneNumber], ChannelID, LocalChainID)
		 VALUES
			   (CUSTOMER_NUMBER
			   ,dbo.udf_TitleCase(input.CUSTOMER_NAME)
			   ,BranchID
			   ,dbo.udf_TitleCase(CUSTOMER_STREET)
			   ,dbo.udf_TitleCase(CITY)
			   ,STATE
			   ,input.POSTAL_CODE
			   ,dbo.udf_TitleCase(CONTACT_PERSON)
			   ,PHONE_NUMBER, ChannelID, LocalChainID);

	-- Merge From RM records for Active Flag Only
	MERGE SAP.Account AS a
	USING (Select convert(bigint, CUSTOMER_NUMBER) CUSTOMER_NUMBER, a.ACTIVE 
			From (Select CUSTOMER_NUMBER, Max(ACTIVE) ACTIVE
					From Staging.RMAccount 
					Group By CUSTOMER_NUMBER) a
		  ) AS input
		ON a.SAPAccountNumber = input.CUSTOMER_NUMBER
	WHEN MATCHED THEN 
		UPDATE SET ACTIVE = input.ACTIVE;

	--MERGE SAP.Account AS a
	--USING (Select convert(bigint, CUSTOMER_NUMBER) CUSTOMER_NUMBER, CUSTOMER_NAME, CUSTOMER_STREET, CITY, STATE, POSTAL_CODE, a.ACTIVE, 
	--			CONTACT_PERSON, PHONE_NUMBER, b.BranchID, c.ChannelID, lc.LocalChainID
	--		From (Select CUSTOMER_NUMBER, Max(LOCATION_ID) LOCATION_ID, Max(CONTACT_PERSON) CONTACT_PERSON, Max(LOCAL_CHAIN) LOCAL_CHAIN, Max(CHANNEL) CHANNEL,
	--					Max(CUSTOMER_NAME) CUSTOMER_NAME, Max(CUSTOMER_STREET) CUSTOMER_STREET, Max(CITY) CITY, Max(STATE) STATE, Max(POSTAL_CODE) POSTAL_CODE,
	--					Max(PHONE_NUMBER) PHONE_NUMBER, Max(ACTIVE) ACTIVE
	--				From Staging.RMAccount 
	--				Group By CUSTOMER_NUMBER) a
	--				Left Join SAP.Branch b on Left(LOCATION_ID, 4) = b.SAPBranchID
	--				Left Join SAP.CHANNEL c on a.CHANNEL = c.SAPChannelID
	--				Left Join SAP.LocalChain lc on a.LOCAL_CHAIN = lc.SAPLocalChainID
	--	  ) AS input
	--	ON a.SAPAccountNumber = input.CUSTOMER_NUMBER
	--WHEN MATCHED THEN 
	--	UPDATE SET ACTIVE = input.ACTIVE
	--	  ,[AccountName] = dbo.udf_TitleCase(input.CUSTOMER_NAME)
	--	  ,[ChannelID] = input.ChannelID
	--	  ,[BranchID] = input.BranchID
	--	  ,[LocalChainID] = input.LocalChainID
	--	  ,[Address] = dbo.udf_TitleCase(input.CUSTOMER_STREET)
	--	  ,[City] = dbo.udf_TitleCase(input.CITY)
	--	  ,[State] = input.STATE
	--	  ,[PostalCode] = input.POSTAL_CODE
	--	  ,[Contact] = dbo.udf_TitleCase(input.CONTACT_PERSON)
	--	  ,[PhoneNumber] = input.PHONE_NUMBER
	--WHEN NOT MATCHED By Target THEN
	--	INSERT (SAPAccountNumber
	--		   ,[AccountName]
	--		   ,[BranchID]
	--		   ,[Address]
	--		   ,[City]
	--		   ,[State]
	--		   ,[PostalCode]
	--		   ,[Contact]
	--		   ,[PhoneNumber]
	--		   ,ACTIVE
	--		   ,ChannelID
	--		   ,LocalChainID
	--		   )
	--	 VALUES
	--		   (CUSTOMER_NUMBER
	--		   ,dbo.udf_TitleCase(input.CUSTOMER_NAME)
	--		   ,BranchID
	--		   ,dbo.udf_TitleCase(CUSTOMER_STREET)
	--		   ,dbo.udf_TitleCase(CITY)
	--		   ,STATE
	--		   ,input.POSTAL_CODE
	--		   ,dbo.udf_TitleCase(CONTACT_PERSON)
	--		   ,PHONE_NUMBER
	--		   ,ACTIVE
	--		   ,ChannelID
	--		   ,LocalChainID);

	Update acc
	Set acc.Longitude = rnl.LONGITUDE, acc.Latitude = rnl.LATITUDE
	From (	Select AccountNumber, Min(LONGITUDE) LONGITUDE, Min(LATITUDE) LATITUDE
				From Staging.RNLocation
				Where ISNUMERIC(AccountNumber) = 1
				Group By AccountNumber) rnl
    Join SAP.Account acc on rnl.AccountNumber = acc.SAPAccountNumber

	Update SAP.Account Set ChangeTrackNumber = CHECKSUM(SAPAccountNumber, AccountName, ChannelID, BranchID, LocalChainID, 
		Address, City, State, PostalCode, Contact, PhoneNumber, Longitude, Latitude, Active), LastModified = GetDate()
	Where isnull(ChangeTrackNumber,0) != CHECKSUM(SAPAccountNumber, AccountName, ChannelID, BranchID, LocalChainID, 
		Address, City, State, PostalCode, Contact, PhoneNumber, Longitude, Latitude, Active)
			   
	--------------------------------------------------
	---- SalesRoute ----------------------------------
	MERGE SAP.SalesRoute AS r
		USING (	Select ROUTE_NUMBER, ROUTE_DESCRIPTION, ACTIVE_ROUTE, ROUTE_TYPE, r.LOCATION_ID, DEFAULT_EMPLOYEE, b.BranchID, up.GSN
				From Staging.RMROUTEMASTER r
				Left Join Staging.RMEmployee e On r.Default_Employee = e.EmployeeID
				Left Join Person.UserProfile up on e.GSN = up.GSN
				Left Join SAP.Branch b on Left(r.LOCATION_ID, 4) = b.SAPBranchID
				Where r.Active = '1'
				And r.Route_Type = '0'
				And Active_Route = '1'
			  ) AS input
			ON r.SAPRouteNumber = input.ROUTE_NUMBER
	WHEN MATCHED THEN
		UPDATE SET SAPRouteNumber = input.ROUTE_NUMBER
		  ,[RouteName] = dbo.udf_TitleCase(input.ROUTE_DESCRIPTION)
		  ,[DefaultAccountManagerGSN] = input.GSN
		  ,BranchID = input.BranchID
	WHEN NOT MATCHED By Source THEN
		UPDATE SET Active = 0
	WHEN NOT MATCHED By Target THEN
		INSERT (SAPRouteNumber
			   ,[RouteName]
			   ,BranchID
			   ,[Active]
			   ,[DefaultAccountManagerGSN])
		 VALUES
			   (input.ROUTE_NUMBER
			   ,dbo.udf_TitleCase(input.ROUTE_DESCRIPTION)
			   ,input.BranchID
			   ,1
			   ,input.GSN);
			   
	-----------------------------------------------------
	---- RouteSchedule ----------------------------------
	MERGE SAP.RouteSchedule AS bu
		USING (Select sr.RouteID, a.AccountID, START_Date, t.Route_Number, t.Customer_Number
				From [Staging].[RMRouteSchedule] t
					-- Inner joins to take only the active routes and active customers
					Join SAP.SalesRoute sr on t.ROUTE_NUMBER = sr.SAPRouteNumber
					Join SAP.Account a on t.CUSTOMER_NUMBER = a.SAPAccountNumber) AS input
			ON bu.RouteID = input.RouteID
			And bu.AccountID = input.AccountID
	WHEN MATCHED THEN 
		UPDATE SET bu.StartDate = input.Start_Date
	WHEN NOT MATCHED By Target THEN
		INSERT(RouteID, AccountID, StartDate)
	VALUES(input.RouteID, input.AccountID, input.Start_Date)
	WHEN NOT MATCHED By Source THEN
		Delete;

	-----------------------------------------------------------
	---- RouteScheduleDetail ----------------------------------
	Truncate Table SAP.routeScheduleDetail

	Declare @dayCounter int
	Declare @indexStarter int

	Set @indexStarter = 0
	Set @dayCounter = 0
	While @dayCounter < 28
		Begin
			Set @indexStarter = 3*@dayCounter + 1
			Insert Into SAP.RouteScheduleDetail(RouteScheduleID, Day, SequenceNumber)
			Select saprs.RouteScheduleID, @dayCounter, Convert(int, substring(SEQUENCE_NUMBER, @indexStarter, 3)) AS SEQUENCE_NUMBER
			From [Staging].[RMRouteSchedule] t
				Join SAP.SalesRoute sr on t.ROUTE_NUMBER = sr.SAPRouteNumber
				Join SAP.Account a on t.CUSTOMER_NUMBER = a.SAPAccountNumber
				Join SAP.RouteSchedule saprs on saprs.AccountID = a.AccountID and saprs.RouteID = sr.RouteID
			Where Convert(int, substring(SEQUENCE_NUMBER, @indexStarter, 3)) > 0;
			
			Set @dayCounter = @dayCounter + 1;
		End	

End
Go

---------------------------------------------------------------------
------Views for Account Manager and District Manager-----------------
If Exists (Select * From sys.objects where object_id = object_id('MView.AccountManager'))
Begin
	Drop View MView.AccountManager
End
Go

Create View MView.AccountManager
As
Select ups.GSN, ups.Firstname, ups.LastName, b.BranchID, b.SAPBranchID, b.BranchName, ups.ManagerGSN
From Person.UserProfile ups
Join Person.Job j on (ups.JobCode = j.SAPHRJobNumber)
Join Person.Role r on j.RoleID = r.RoleID
Join SAP.Branch b on ups.PrimaryBranchID = b.BranchID
Where r.RoleName = 'Account Manager'
Go

If Exists (Select * From sys.objects where object_id = object_id('MView.DistrictManager'))
Begin
	Drop View MView.DistrictManager
End
Go

Create View MView.DistrictManager
As
Select ups.GSN, ups.Firstname, ups.LastName, b.BranchID, b.SAPBranchID, b.BranchName
From Person.UserProfile ups
Join Person.Job j on (ups.JobCode = j.SAPHRJobNumber)
Join Person.Role r on j.RoleID = r.RoleID
Join SAP.Branch b on ups.PrimaryBranchID = b.BranchID
Where r.RoleName = 'DM'
Go

If Exists (Select * From sys.objects where object_id = object_id('Person.RouteDistrictManagers'))
Begin
	Drop View Person.RouteDistrictManagers
End
Go

Create View Person.RouteDistrictManagers
AS
Select dm.BranchID, dm.GSN DistrictManagerGSN, dm.FirstName DistrictManagerFirstName, dm.LastName DistrictManagerLastName, 
am.GSN AccountManagerGSN, am.FirstName AccountManagerFirstName, am.LastName AccountManagerLastName 
From MView.DistrictManager dm
Join MView.AccountManager am on am.ManagerGSN = dm.GSN
Go
