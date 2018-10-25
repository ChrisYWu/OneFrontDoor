use Portal_Data
Go

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [SAP].[RouteType](
	[RouteTypeID] [int] NOT NULL,
	[RMRouteTypeID] varchar(10) not null,
	[RouteTypeName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_RouteType] PRIMARY KEY CLUSTERED 
(
	[RouteTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

Insert Into [SAP].[RouteType] Values (0,  0, 'Sales')
Insert Into [SAP].[RouteType] Values (1,  1, 'Delivery')
Insert Into [SAP].[RouteType] Values (2,  2, 'Full Service')
Go

ALTER TABLE [SAP].[SalesRoute] 
Add RouteTypeID int Null
Go 

ALTER TABLE [SAP].[SalesRoute]  WITH CHECK ADD CONSTRAINT [FK_Route_RouteType] FOREIGN KEY([RouteTypeID])
REFERENCES [SAP].[RouteType] ([RouteTypeID])
GO

Update [SAP].[SalesRoute] Set RouteTypeID = 0
Go

ALTER TABLE [SAP].[SalesRoute] 
Alter Column RouteTypeID int Not Null
Go 

sp_RENAME 'SAP.SalesRoute' , 'Route'
Go

CREATE View [SAP].[SalesRoute]
As
	SELECT * from SAP.Route where ROuteTypeID=0
GO

Alter Table SAP.Route Drop Constraint FK_SalesRoute_RMEmployee
Go

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
	---- Person.RMEmployee ---------------------------
	Merge Person.RMEmployee as A  --Target
	Using 
		(Select EmployeeID, RoleID, dbo.udf_TitleCase(FirstName) FirstName, dbo.udf_TitleCase(LastName) LastName, BranchID, A.Active, GSN 
			from Staging.RMEmployee A, SAP.Branch B, Person.Role C
			where Left(A.Location_ID,4) = B.SAPBranchID
			and C.RoleName = A.JobRole ) as B --Source
			on A.EmployeeID = B.EmployeeID 
	When Matched Then
		UpDate Set RoleID = B.RoleID, FirstName = B.FirstName, LastName = B.LastName, 
			BranchID = B.BranchID, Active = B.Active, GSN = B.GSN
	When Not Matched By Target then
		Insert (EmployeeID, RoleID, FirstName, LastName, BranchID, Active, GSN) 
		Values (B.EmployeeID, B.RoleID, B.FirstName, B.LastName, B.BranchID, B.Active, B.GSN);

	--------------------------------------------------
	---- Route ----------------------------------
	MERGE SAP.Route AS r
		USING (	Select ROUTE_NUMBER, ROUTE_DESCRIPTION, ACTIVE_ROUTE, ROUTE_TYPE, r.LOCATION_ID, DEFAULT_EMPLOYEE, b.BranchID, up.GSN
				From Staging.RMROUTEMASTER r
				Left Join Staging.RMEmployee e On r.Default_Employee = e.EmployeeID
				Left Join Person.UserProfile up on e.GSN = up.GSN
				Left Join SAP.Branch b on Left(r.LOCATION_ID, 4) = b.SAPBranchID
				Where r.Active = '1'
				--And r.Route_Type = '0'
				And Active_Route = '1'
			  ) AS input
			ON r.SAPRouteNumber = input.ROUTE_NUMBER
	WHEN MATCHED THEN
		UPDATE SET SAPRouteNumber = input.ROUTE_NUMBER
		  ,[RouteName] = dbo.udf_TitleCase(input.ROUTE_DESCRIPTION)
		  ,[DefaultAccountManagerGSN] = input.GSN
		  ,BranchID = input.BranchID
		  ,EmployeeID = DEFAULT_EMPLOYEE
		  ,RouteTypeID = ROUTE_TYPE
		  ,Active = 1
	WHEN NOT MATCHED By Source THEN
		UPDATE SET Active = 0
	WHEN NOT MATCHED By Target THEN
		INSERT (SAPRouteNumber
			   ,[RouteName]
			   ,BranchID
			   ,[Active]
			   ,[DefaultAccountManagerGSN], EmployeeID, RouteTypeID)
		 VALUES
			   (input.ROUTE_NUMBER
			   ,dbo.udf_TitleCase(input.ROUTE_DESCRIPTION)
			   ,input.BranchID
			   ,1
			   ,input.GSN, DEFAULT_EMPLOYEE, input.ROUTE_TYPE);
			   
	-----------------------------------------------------
	---- RouteSchedule ----------------------------------
	MERGE SAP.RouteSchedule AS bu
		USING (Select sr.RouteID, a.AccountID, START_Date, t.Route_Number, t.Customer_Number
				From [Staging].[RMRouteSchedule] t
					-- Inner joins to take only the active routes and active customers
					Join SAP.Route sr on t.ROUTE_NUMBER = sr.SAPRouteNumber
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
	Truncate Table SAP.RouteScheduleDetail

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
				Join SAP.Route sr on t.ROUTE_NUMBER = sr.SAPRouteNumber
				Join SAP.Account a on t.CUSTOMER_NUMBER = a.SAPAccountNumber
				Join SAP.RouteSchedule saprs on saprs.AccountID = a.AccountID and saprs.RouteID = sr.RouteID
			Where Convert(int, substring(SEQUENCE_NUMBER, @indexStarter, 3)) > 0;
			
			Set @dayCounter = @dayCounter + 1;
		End	

End
GO

Drop View [MView].[AccountActiveRouteSchedule]
Go

Exec [ETL].[pLoadFromRM]
Go

Select *
From MSTR.GetRouteDetail
Go
