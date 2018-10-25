USE [Portal_Data]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ETL].[pLoadFromRM]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ETL].[pLoadFromRM]
GO

CREATE PROCEDURE [ETL].[pLoadFromRM] 
AS
BEGIN
	--------------------------------------------
	---- Package -------------------------------
	--Load Packages into Staging
	Truncate Table Staging.RMPackage

	Insert Into Staging.RMPackage
	Select PACKAGEID, DESCRIPTION, Substring(PACKAGEID, 1, 3) SAPPackageTypeID, SUBSTRING(PACKAGEID, 4, 2) SAPPackageConfigID
	From RM..ACEUSER.PACKAGE;
	
	MERGE SAP.Package AS a
	USING (Select p.PACKAGEID, pt.PackageTypeID, pc.PackageConfID, 
			Replace(Replace(Replace(dbo.udf_TitleCase(p.Description), 'Oz', 'OZ'), 'Ls', 'LS'), 'pk', 'PK') PackageName
			,0 Active
			,Replace(Replace(Replace(dbo.udf_TitleCase(p.Description), 'Oz', 'OZ'), 'Ls', 'LS'), 'pk', 'PK') SPPackageName 
		From Staging.RMPackage p
			Left Join SAP.PackageType pt on p.SAPPackageTypeID = pt.SAPPackageTypeID
			Left Join SAP.PackageConf pc on p.SAPPackageConfigID = pc.SAPPackageConfID
		  ) AS input
		ON a.RMPackageID = input.PACKAGEID
	WHEN MATCHED THEN 
		UPDATE SET PackageTypeID = input.PackageTypeID,
					PackageConfID = input.PackageConfID,
					PackageName = input.PackageName,
					--SPPackageName = input.SPPackageName
					SPPackageName = Case When a.SPPackageName is null Then input.SPPackageName else a.SPPackageName end,
					Source = 'RouteManager'
	WHEN NOT MATCHED By Source THEN
		UPDATE SET Active = 0
	WHEN NOT MATCHED By Target THEN
		INSERT ([RMPackageID]
           ,[PackageTypeID]
           ,[PackageConfID]
           ,[PackageName]
           ,Active
           ,[SPPackageName]
           ,Source)
		 VALUES
			   (PACKAGEID
			   ,PackageTypeID
			   ,PackageConfID
			   ,[PackageName]
			   ,Active
			   ,[SPPackageName]
			   ,'RouteManager');

	--------------------------------------------
	---- Account -------------------------------
	--Load Accounts into Staging
	Truncate Table BWStaging.Account;

	INSERT INTO [BWStaging].[Account](CUSTOMER_NUMBER, LOCATION_ID, CUSTOMER_NAME, CUSTOMER_STREET, CITY, STATE
			, POSTAL_CODE, CONTACT_PERSON, PHONE_NUMBER, LOCAL_CHAIN, CHANNEL, ACTIVE)
	Select CUSTOMER_NUMBER, LOCATION_ID, CUSTOMER_NAME, CUSTOMER_STREET, CITY, STATE
			, POSTAL_CODE, CONTACT_PERSON, PHONE_NUMBER, LOCAL_CHAIN, CHANNEL, ACTIVE
	From RM..ACEUSER.CUSTOMERS
	Where Active = '1';
	
	MERGE SAP.Account AS a
	USING (Select CUSTOMER_NUMBER, LOCATION_ID, CUSTOMER_NAME, CUSTOMER_STREET, CITY, STATE, POSTAL_CODE,
			CONTACT_PERSON, PHONE_NUMBER, LOCAL_CHAIN, CHANNEL, b.BranchID, c.ChannelID, lc.LocalChainID
			From BWStaging.Account a
				Left Join SAP.Branch b on Left(LOCATION_ID, 4) = b.SAPBranchID
				Left Join SAP.CHANNEL c on a.CHANNEL = c.SAPChannelID
				Left Join SAP.LocalChain lc on a.LOCAL_CHAIN = lc.SAPLocalChainID
		  ) AS input
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
	WHEN NOT MATCHED By Source THEN
		UPDATE SET Active = 0
	WHEN NOT MATCHED By Target THEN
		INSERT (SAPAccountNumber
			   ,[AccountName]
			   ,[BranchID]
			   ,[Address]
			   ,[City]
			   ,[State]
			   ,[PostalCode]
			   ,[Contact]
			   ,[PhoneNumber], Active, ChannelID, LocalChainID)
		 VALUES
			   (CUSTOMER_NUMBER
			   ,dbo.udf_TitleCase(input.CUSTOMER_NAME)
			   ,BranchID
			   ,dbo.udf_TitleCase(CUSTOMER_STREET)
			   ,dbo.udf_TitleCase(CITY)
			   ,STATE
			   ,input.POSTAL_CODE
			   ,dbo.udf_TitleCase(CONTACT_PERSON)
			   ,PHONE_NUMBER, 1, ChannelID, LocalChainID);
			   
	--------------------------------------------------
	---- SalesRoute ----------------------------------
	MERGE SAP.SalesRoute AS r
		USING (	Select ROUTE_NUMBER, ROUTE_DESCRIPTION, ACTIVE_ROUTE, ROUTE_TYPE, LOCATION_ID, DEFAULT_EMPLOYEE, e.PersonID, b.BranchID
				From RM..ACEUSER.ROUTE_MASTER r
				Join Person.Employee e on r.DEFAULT_EMPLOYEE = e.RMEmployeeID
				Join SAP.Branch b on Left(LOCATION_ID, 4) = b.SAPBranchID
				Where r.Active = '1'
				And r.Route_Type = '0'
				And Active_Route = '1'
			  ) AS input
			ON r.SAPRouteNumber = input.ROUTE_NUMBER
	WHEN MATCHED THEN
		UPDATE SET SAPRouteNumber = input.ROUTE_NUMBER
		  ,[RouteName] = dbo.udf_TitleCase(input.ROUTE_DESCRIPTION)
		  ,[DefaultEmployeeID] = input.PersonID
		  ,BranchID = input.BranchID
	WHEN NOT MATCHED By Source THEN
		UPDATE SET Active = 0
	WHEN NOT MATCHED By Target THEN
		INSERT (SAPRouteNumber
			   ,[RouteName]
			   ,[DefaultEmployeeID]
			   ,BranchID
			   ,[Active])
		 VALUES
			   (input.ROUTE_NUMBER
			   ,dbo.udf_TitleCase(input.ROUTE_DESCRIPTION)
			   ,input.PersonID
			   ,input.BranchID
			   ,1);
			   

	-----------------------------------------------------
	---- RouteSchedule ----------------------------------
	Truncate Table [BWStaging].[RouteSchedule];

	INSERT INTO [BWStaging].[RouteSchedule]
			   ([ROUTE_NUMBER]
			   ,[CUSTOMER_NUMBER]
			   ,[LOCATION_ID]
			   ,[FREQUENCY]
			   ,[START_DATE]
			   ,[DEFAULT_DELIV_ROUTE]
			   ,[SEQUENCE_NUMBER]
			   ,[SEASONAL]
			   ,[SEASONAL_START_DATE]
			   ,[SEASONAL_END_DATE])
	Select		[ROUTE_NUMBER]
			   ,[CUSTOMER_NUMBER]
			   ,[LOCATION_ID]
			   ,[FREQUENCY]
			   ,[START_DATE]
			   ,[DEFAULT_DELIV_ROUTE]
			   ,[SEQUENCE_NUMBER]
			   ,[SEASONAL]
			   ,[SEASONAL_START_DATE]
			   ,[SEASONAL_END_DATE]
	From RM..ACEUSER.ROUTE_SCHEDULE;

	Declare @activeRoute Table
	(
		RouteID int,
		AccountID int,
		Start_Date Date,
		Sequence_Number char(84),
		Route_Number int,
		Customer_Number int
	)

	Insert @activeRoute
	Select sr.RouteID, a.AccountID, START_Date, SEQUENCE_NUMBER, t.Route_Number, t.Customer_Number
				From [BWStaging].[RouteSchedule] t
					-- Inner joins to take only the active routes and active customers
					Join SAP.SalesRoute sr on t.ROUTE_NUMBER = sr.SAPRouteNumber
					Join SAP.Account a on t.CUSTOMER_NUMBER = a.SAPAccountNumber

	MERGE SAP.RouteSchedule AS bu
		USING (Select sr.RouteID, a.AccountID, START_Date, t.Route_Number, t.Customer_Number
				From [BWStaging].[RouteSchedule] t
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
	Declare @dayCounter int
	Declare @indexStarter int

	Set @indexStarter = 0
	Set @dayCounter = 0
	While @dayCounter < 28
		Begin
			Set @indexStarter = 3*@dayCounter + 1
			Insert Into SAP.RouteScheduleDetail(RouteScheduleID, Day, SequenceNumber)
			Select saprs.RouteScheduleID, @dayCounter, Convert(int, substring(SEQUENCE_NUMBER, @indexStarter, 3)) AS SEQUENCE_NUMBER
			From [BWStaging].[RouteSchedule] t
				Join SAP.SalesRoute sr on t.ROUTE_NUMBER = sr.SAPRouteNumber
				Join SAP.Account a on t.CUSTOMER_NUMBER = a.SAPAccountNumber
				Join SAP.RouteSchedule saprs on saprs.AccountID = a.AccountID and saprs.RouteID = sr.RouteID
			Where Convert(int, substring(SEQUENCE_NUMBER, @indexStarter, 3)) > 0;
			
			Set @dayCounter = @dayCounter + 1;
		End	

End