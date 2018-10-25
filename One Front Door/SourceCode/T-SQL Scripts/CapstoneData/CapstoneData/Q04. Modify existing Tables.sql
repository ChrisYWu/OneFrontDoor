USE Portal_Data_INT
GO

----------------------------------------
--- Alter National Chain Table ----
----------------------------------------
Alter Table SAP.NationalChain
Add InCapstone Bit 
Go

Alter Table SAP.NationalChain
Add CapstoneLastModified [datetime2](7)
Go

Alter Table SAP.NationalChain
Add InBW Bit
Go

----------------------------------------
--- Alter Regional Chain Table ----
----------------------------------------
Alter Table SAP.RegionalChain
Add InCapstone Bit 
Go

Alter Table SAP.RegionalChain
Add CapstoneLastModified [datetime2](7)
Go

Alter Table SAP.RegionalChain
Add InBW Bit 
Go

----------------------------------------
--- Alter Local Chain Table ----
----------------------------------------
Alter Table SAP.LocalChain
Add InCapstone Bit 
Go

Alter Table SAP.LocalChain
Add CapstoneLastModified [datetime2](7)
Go

Alter Table SAP.LocalChain
Add InBW Bit 
Go

----------------------------------------
--- Alter Account Table ----
----------------------------------------

Alter Table SAP.Account
Add CountryCode varchar(2)
Go

Alter Table SAP.Account
Add CapstoneLastModified [datetime2](7) Null
Go

Alter Table SAP.Account
Add InCapstone Bit
Go

Alter Table SAP.Account
Add AddressLastModified [datetime2](7) Null
Go

Alter Table SAP.Account
Add Format varchar(2) Null
Go

Alter Table SAP.Account
Add CountyID int Null
Go

Alter Table SAP.Account
Add TDLinxID nvarchar(60) Null
Go

Alter Table SAP.Account
Add GeoSource varchar(5) Null
Go

Update SAP.Account
Set GeoSource = 'RN'
Where Latitude > 0
Go

Alter Table SAP.Account
Add CRMActive bit Null
Go

Alter Table SAP.Account
Add GlobalActive As Case When CRMActive = 1 And Active = 1 Then 1 Else 0 End
Go

Alter Table SAP.Account
Alter Column Address varchar(60)
Go

Alter Table SAP.Account
Add TMPostalCode varchar (10)
Go

Alter Table SAP.Account
Add GeoCodingNeeded bit
Go

--Drop Index NC_Account_Capstone_CountyID_PostalCode
--On SAP.Account

CREATE NONCLUSTERED INDEX [NC_Account_Capstone_CountyID_PostalCode] ON [SAP].[Account]
(
	[InCapstone] ASC,
	[CRMActive] ASC,
	[TMPostalCode] ASC,
	[CountyID] ASC
)
INCLUDE ([LocalChainID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
Go

----- TradeMark---------------------------------
------------------------------------------------
Alter Table SAP.TradeMark
Add IsCapstone bit Null
Go

CREATE UNIQUE NONCLUSTERED INDEX [UNC_TradeMark_SAPTradeMarkID] ON [SAP].[TradeMark]
(
	[SAPTradeMarkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

--------------------------------------
--------------------------------------
ALTER PROCEDURE [ETL].[pLoadFromRM]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--------------------------------------------------------
	---Package----------------------------------------------
	DECLARE @sappk TABLE (
		PackageID INT
		,RMPackageID VARCHAR(10)
		,PackageTypeID INT
		,PackageConfID INT
		,PackageName VARCHAR(50)
		,Source VARCHAR(50)
		,Active VARCHAR(50)
		,ChangeTrackNumber INT
		)

	INSERT @sappk
	SELECT PackageID
		,RMPackageID
		,PackageTypeID
		,PackageConfID
		,PackageName
		,Source
		,Active
		,ChangeTrackNumber
	FROM SAP.Package

	MERGE @sappk AS a
	USING (
		SELECT p.PACKAGEID
			,pt.PackageTypeID
			,pc.PackageConfID
			,Replace(Replace(dbo.udf_TitleCase(p.Description), 'Oz', 'OZ'), 'Ls', 'LS') PackageName
			,0 Active
			,Replace(Replace(dbo.udf_TitleCase(p.Description), 'Oz', 'OZ'), 'Ls', 'LS') SPPackageName
		FROM Staging.RMPackage p
		LEFT JOIN SAP.PackageType pt ON p.SAPPackageTypeID = pt.SAPPackageTypeID
		LEFT JOIN SAP.PackageConf pc ON p.SAPPackageConfigID = pc.SAPPackageConfID
		) AS input
		ON a.RMPackageID = input.PACKAGEID
	WHEN MATCHED
		THEN
			UPDATE
			SET PackageTypeID = input.PackageTypeID
				,PackageConfID = input.PackageConfID
				,PackageName = input.PackageName
				,Source = 'RouteManager'
	WHEN NOT MATCHED BY Source
		THEN
			UPDATE
			SET Active = 0
	WHEN NOT MATCHED BY Target
		THEN
			INSERT (
				[RMPackageID]
				,[PackageTypeID]
				,[PackageConfID]
				,[PackageName]
				,Source
				,Active
				)
			VALUES (
				PACKAGEID
				,PackageTypeID
				,PackageConfID
				,[PackageName]
				,'RouteManager'
				,Active
				);

	MERGE @sappk AS bu
	USING (
		SELECT DISTINCT Rtrim(mbp.PackTypeID) + Rtrim(mbp.PackConfID) PACKAGEID
			,Replace(Replace(Replace(dbo.udf_TitleCase(Rtrim(mbp.PackType) + ' ' + Rtrim(mbp.PackConf)), 'Oz', 'OZ'), 'Ls', 'LS'), 'pk', 'PK') PACKAGEName
			,pc.PackageConfID
			,pt.PackageTypeID
		FROM Staging.MaterialBrandPKG mbp
		JOIN SAP.PackageConf pc ON mbp.PackConfID = pc.SAPPackageConfID
		JOIN SAP.PackageType pt ON mbp.PackTypeID = pt.SAPPackageTypeID
		) AS input
		ON bu.RMPackageID = input.PACKAGEID
	WHEN MATCHED
		THEN
			UPDATE
			SET bu.Active = 1
	WHEN NOT MATCHED BY Source
		THEN
			UPDATE
			SET bu.Active = 0
	WHEN NOT MATCHED BY Target
		THEN
			INSERT (
				[RMPackageID]
				,[PackageTypeID]
				,[PackageConfID]
				,[PackageName]
				,Active
				,Source
				)
			VALUES (
				PACKAGEID
				,PackageTypeID
				,PackageConfID
				,CASE 
					WHEN [PackageName] = 'Not Assigned Not Assigned'
						THEN 'Not Assigned'
					ELSE PackageName
					END
				,1
				,'SAPBW'
				);

	UPDATE @sappk
	SET ChangeTrackNumber = CHECKSUM(RMPackageID, PackageTypeID, PackageConfID, PackageName, Source, Active)

	MERGE SAP.Package AS pc
	USING @sappk AS input
		ON pc.PackageID = input.PackageID
	WHEN NOT MATCHED BY Target
		THEN
			INSERT (
				RMPackageID
				,PackageTypeID
				,PackageConfID
				,PackageName
				,Source
				,Active
				,ChangeTrackNumber
				,LastModified
				)
			VALUES (
				input.RMPackageID
				,input.PackageTypeID
				,input.PackageConfID
				,input.PackageName
				,input.Source
				,input.Active
				,input.ChangeTrackNumber
				,GetDate()
				);

	UPDATE sdm
	SET RMPackageID = sap.RMPackageID
		,PackageTypeID = sap.PackageTypeID
		,PackageConfID = sap.PackageConfID
		,PackageName = sap.PackageName
		,Source = sap.Source
		,Active = sap.Active
		,FriendlyName = sap.PackageName
		,ChangeTrackNumber = sap.ChangeTrackNumber
		,LastModified = GetDate()
	FROM @sappk sap
	JOIN SAP.Package sdm ON sap.PackageID = sdm.PackageID
		AND sap.ChangeTrackNumber != isnull(sdm.ChangeTrackNumber, 0)

	Select top 1 *
	From SAP.Account

	--------------------------------------------
	---- Account -------------------------------
	-- Merge From BW records
	MERGE SAP.Account AS a
	USING (
		SELECT CUSTOMER_NUMBER
			,max(CUSTOMER_NAME) CUSTOMER_NAME
			,max(CUSTOMER_STREET) CUSTOMER_STREET
			,max(CITY) CITY
			,max(STATE) STATE
			,max(POSTAL_CODE) POSTAL_CODE
			,max(CONTACT_PERSON) CONTACT_PERSON
			,max(PHONE_NUMBER) PHONE_NUMBER
			,max(BranchID) BranchID
			,max(ChannelID) ChannelID
			,max(LocalChainID) LocalChainID
		FROM (
			SELECT convert(BIGINT, CUSTOMER_NUMBER) CUSTOMER_NUMBER
				,CUSTOMER_NAME
				,CUSTOMER_STREET
				,CITY
				,STATE
				,POSTAL_CODE
				,CONTACT_PERSON
				,PHONE_NUMBER
				,b.BranchID
				,c.ChannelID
				,lc.LocalChainID
			FROM Staging.BWAccount a
			LEFT JOIN Staging.AccountDetails ad ON ISNUMERIC(ad.SAPAccountNumber) = 1
				AND convert(BIGINT, a.CUSTOMER_NUMBER) = convert(BIGINT, ad.SAPAccountNumber)
			LEFT JOIN SAP.Branch b ON b.SAPBranchID = ad.SAPBranchID
			LEFT JOIN SAP.CHANNEL c ON ad.SAPChannelID = c.SAPChannelID
			LEFT JOIN SAP.LocalChain lc ON Right(ad.SAPLocalChainID, 7) = lc.SAPLocalChainID
			) tmp
		GROUP BY CUSTOMER_NUMBER
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
	WHEN MATCHED
		THEN
			UPDATE
			SET [AccountName] = dbo.udf_TitleCase(input.CUSTOMER_NAME)
				,[ChannelID] = input.ChannelID
				,[BranchID] = input.BranchID
				,[LocalChainID] = input.LocalChainID
				,[Address] = dbo.udf_TitleCase(input.CUSTOMER_STREET)
				,[City] = dbo.udf_TitleCase(input.CITY)
				,[State] = input.STATE
				,[PostalCode] = input.POSTAL_CODE
				,[Contact] = dbo.udf_TitleCase(input.CONTACT_PERSON)
				,[PhoneNumber] = input.PHONE_NUMBER
	WHEN NOT MATCHED BY Target
		THEN
			INSERT (
				SAPAccountNumber
				,[AccountName]
				,[BranchID]
				,[Address]
				,[City]
				,[State]
				,[PostalCode]
				,[Contact]
				,[PhoneNumber]
				,ChannelID
				,LocalChainID
				)
			VALUES (
				CUSTOMER_NUMBER
				,dbo.udf_TitleCase(input.CUSTOMER_NAME)
				,BranchID
				,dbo.udf_TitleCase(CUSTOMER_STREET)
				,dbo.udf_TitleCase(CITY)
				,STATE
				,input.POSTAL_CODE
				,dbo.udf_TitleCase(CONTACT_PERSON)
				,PHONE_NUMBER
				,ChannelID
				,LocalChainID
				);

	-- Merge From RM records for Active Flag Only
	MERGE SAP.Account AS a
	USING (
		SELECT convert(BIGINT, CUSTOMER_NUMBER) CUSTOMER_NUMBER
			,a.ACTIVE
		FROM (
			SELECT CUSTOMER_NUMBER
				,Max(ACTIVE) ACTIVE
			FROM Staging.RMAccount
			GROUP BY CUSTOMER_NUMBER
			) a
		) AS input
		ON a.SAPAccountNumber = input.CUSTOMER_NUMBER
	WHEN MATCHED
		THEN
			UPDATE
			SET ACTIVE = input.ACTIVE;

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
	UPDATE acc
	SET acc.Longitude = rnl.LONGITUDE
		,acc.Latitude = rnl.LATITUDE
		,GeoSource = 'RN'
		,GoecodingNeeded = 0
	FROM (
		SELECT AccountNumber
			,Min(LONGITUDE) LONGITUDE
			,Min(LATITUDE) LATITUDE
		FROM Staging.RNLocation
		WHERE ISNUMERIC(AccountNumber) = 1
		And  Charindex('.', AccountNumber) = 0
		And Isnull(LONGITUDE, 0.0) <> 0
		GROUP BY AccountNumber
		) rnl
	JOIN SAP.Account acc ON rnl.AccountNumber = acc.SAPAccountNumber
	Where rnl.Longitude <> 0

	UPDATE SAP.Account
	SET ChangeTrackNumber = CHECKSUM(SAPAccountNumber, AccountName, ChannelID, BranchID, LocalChainID, Address, City, STATE, PostalCode, Contact, PhoneNumber, Longitude, Latitude, Active)
		,LastModified = GetDate()
	WHERE isnull(ChangeTrackNumber, 0) != CHECKSUM(SAPAccountNumber, AccountName, ChannelID, BranchID, LocalChainID, Address, City, STATE, PostalCode, Contact, PhoneNumber, Longitude, Latitude, Active)

	--------------------------------------------------
	---- Person.RMEmployee ---------------------------
	MERGE Person.RMEmployee AS A --Target
	USING (
		SELECT EmployeeID
			,RoleID
			,dbo.udf_TitleCase(FirstName) FirstName
			,dbo.udf_TitleCase(LastName) LastName
			,BranchID
			,A.Active
			,GSN
		FROM Staging.RMEmployee A
			,SAP.Branch B
			,Person.ROLE C
		WHERE Left(A.Location_ID, 4) = B.SAPBranchID
			AND C.RoleName = A.JobRole
		) AS B --Source
		ON A.EmployeeID = B.EmployeeID
	WHEN MATCHED
		THEN
			UPDATE
			SET RoleID = B.RoleID
				,FirstName = B.FirstName
				,LastName = B.LastName
				,BranchID = B.BranchID
				,Active = B.Active
				,GSN = B.GSN
	WHEN NOT MATCHED BY Target
		THEN
			INSERT (
				EmployeeID
				,RoleID
				,FirstName
				,LastName
				,BranchID
				,Active
				,GSN
				)
			VALUES (
				B.EmployeeID
				,B.RoleID
				,B.FirstName
				,B.LastName
				,B.BranchID
				,B.Active
				,B.GSN
				);

	--------------------------------------------------
	---- Route ----------------------------------
	MERGE SAP.Route AS r
	USING (
		SELECT ROUTE_NUMBER
			,ROUTE_DESCRIPTION
			,ACTIVE_ROUTE
			,ROUTE_TYPE
			,r.LOCATION_ID
			,DEFAULT_EMPLOYEE
			,b.BranchID
			,up.GSN
			,DISPLAYALLOWANCE
			,SALES_GROUP
		FROM Staging.RMROUTEMASTER r
		LEFT JOIN Staging.RMEmployee e ON r.Default_Employee = e.EmployeeID
		LEFT JOIN Person.UserProfile up ON e.GSN = up.GSN
		LEFT JOIN SAP.Branch b ON Left(r.LOCATION_ID, 4) = b.SAPBranchID
		WHERE r.Active = '1'
			--And r.Route_Type = '0'
			AND Active_Route = '1'
		) AS input
		ON r.SAPRouteNumber = input.ROUTE_NUMBER
	WHEN MATCHED
		THEN
			UPDATE
			SET SAPRouteNumber = input.ROUTE_NUMBER
				,[RouteName] = dbo.udf_TitleCase(input.ROUTE_DESCRIPTION)
				,[DefaultAccountManagerGSN] = input.GSN
				,BranchID = input.BranchID
				,EmployeeID = DEFAULT_EMPLOYEE
				,RouteTypeID = ROUTE_TYPE
				,Active = 1
				,DisplayAllowance = input.DISPLAYALLOWANCE
				,SalesGroup = SALES_GROUP
	WHEN NOT MATCHED BY Source
		THEN
			UPDATE
			SET Active = 0
	WHEN NOT MATCHED BY Target
		THEN
			INSERT (
				SAPRouteNumber
				,[RouteName]
				,BranchID
				,[Active]
				,[DefaultAccountManagerGSN]
				,EmployeeID
				,RouteTypeID
				,DisplayAllowance
				,SalesGroup
				)
			VALUES (
				input.ROUTE_NUMBER
				,dbo.udf_TitleCase(input.ROUTE_DESCRIPTION)
				,input.BranchID
				,1
				,input.GSN
				,DEFAULT_EMPLOYEE
				,input.ROUTE_TYPE
				,input.DISPLAYALLOWANCE
				,input.SALES_GROUP
				);

	-----------------------------------------------------
	---- RouteSchedule ----------------------------------
	MERGE SAP.RouteSchedule AS bu
	USING (
		SELECT sr.RouteID
			,a.AccountID
			,START_Date
			,t.Route_Number
			,t.Customer_Number
		FROM [Staging].[RMRouteSchedule] t
		-- Inner joins to take only the active routes and active customers
		JOIN SAP.Route sr ON t.ROUTE_NUMBER = sr.SAPRouteNumber
		JOIN SAP.Account a ON t.CUSTOMER_NUMBER = a.SAPAccountNumber
		) AS input
		ON bu.RouteID = input.RouteID
			AND bu.AccountID = input.AccountID
	WHEN MATCHED
		THEN
			UPDATE
			SET bu.StartDate = input.Start_Date
	WHEN NOT MATCHED BY Target
		THEN
			INSERT (
				RouteID
				,AccountID
				,StartDate
				)
			VALUES (
				input.RouteID
				,input.AccountID
				,input.Start_Date
				)
	WHEN NOT MATCHED BY Source
		THEN
			DELETE;

	-----------------------------------------------------------
	---- RouteScheduleDetail ----------------------------------
	TRUNCATE TABLE SAP.RouteScheduleDetail

	DECLARE @dayCounter INT
	DECLARE @indexStarter INT

	SET @indexStarter = 0
	SET @dayCounter = 0

	WHILE @dayCounter < 28
	BEGIN
		SET @indexStarter = 3 * @dayCounter + 1

		INSERT INTO SAP.RouteScheduleDetail (
			RouteScheduleID
			,Day
			,SequenceNumber
			)
		SELECT saprs.RouteScheduleID
			,@dayCounter
			,Convert(INT, substring(SEQUENCE_NUMBER, @indexStarter, 3)) AS SEQUENCE_NUMBER
		FROM [Staging].[RMRouteSchedule] t
		JOIN SAP.Route sr ON t.ROUTE_NUMBER = sr.SAPRouteNumber
		JOIN SAP.Account a ON t.CUSTOMER_NUMBER = a.SAPAccountNumber
		JOIN SAP.RouteSchedule saprs ON saprs.AccountID = a.AccountID
			AND saprs.RouteID = sr.RouteID
		WHERE Convert(INT, substring(SEQUENCE_NUMBER, @indexStarter, 3)) > 0;

		SET @dayCounter = @dayCounter + 1;
	END
END
Go

ALTER PROCEDURE [ETL].[pNormalizeChains] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--------------------------------------------
    --- Channel Loading is disabled per discussion with Rajeev. 
	---- Super Channel -------------------------
	--MERGE SAP.SuperChannel AS bu
	--	USING (SELECT Distinct SuperChannelID, SuperChannel 
	--			From Staging.Channel
	--			Where SuperChannelID <> '#') AS input
	--		ON bu.SAPSuperChannelID = input.SuperChannelID
	--WHEN MATCHED THEN 
	--	UPDATE SET bu.SuperChannelName = dbo.udf_TitleCase(input.SuperChannel)
	--WHEN NOT MATCHED By Target THEN
	--	INSERT(SAPSuperChannelID, SuperChannelName)
	--VALUES(input.SuperChannelID, dbo.udf_TitleCase(input.SuperChannel));
	--GO

	--Select *
	--From SAP.SuperChannel 
	--Go

	--------------------------------------------

	-----------------------------------------------
	---Channel-------------------------------------
	--MERGE SAP.Channel AS ba
	--	USING ( SELECT Distinct ChannelID, Channel
	--			FROM Staging.Channel r
	--			Where Rtrim(Ltrim(ChannelID)) <> '#') AS input
	--		ON ba.SAPChannelID = input.ChannelID
	--WHEN MATCHED THEN
	--	UPDATE SET ba.ChannelName = dbo.udf_TitleCase(input.Channel)
	--WHEN NOT MATCHED By Target THEN
	--	INSERT(SAPChannelID, ChannelName)
	--VALUES(input.ChannelID, dbo.udf_TitleCase(input.Channel));
	--GO

	--Select *
	--From SAP.Channel
	--Go

	--Merge SAP.SuperChannelChannel scc
	--Using (Select s.SuperChannelID, c.ChannelID
	--		From Staging.Channel bw
	--		Join SAP.SuperChannel s on BW.SuperChannelID = s.SAPSuperChannelID
	--		Join SAP.Channel c on BW.ChannelID = c.SAPChannelID) as input
	--	On scc.SuperChannelID = input.SuperChannelID
	--	And scc.ChannelID = input.ChannelID
	--When Not Matched By Target Then
	--	Insert(SuperChannelID, ChannelID)
	--	Values(input.SuperChannelID, input.ChannelID)
	--When Not Matched By Source Then
	--	Delete;
	--Go

	--------------------------------------------
	---- National Chain ------------------------
	Declare @sapch Table
	(
		[NationalChainID] int,
		[SAPNationalChainID] int, 
		[NationalChainName] varchar(50),
		[ChangeTrackNumber] int
	)

	Insert Into @sapch(NationalChainID, SAPNationalChainID, NationalChainName, ChangeTrackNumber)
	Select NationalChainID, SAPNationalChainID, NationalChainName, ChangeTrackNumber From SAP.NationalChain

	MERGE @sapch AS bu
	USING (SELECT Distinct NationalChainID, NationalChain
				From Staging.Chain
				Where NationalChainID Not in ('#', '')) AS input
			ON bu.SAPNationalChainID = input.NationalChainID
	WHEN MATCHED THEN 
		UPDATE SET bu.NationalChainName = dbo.udf_TitleCase(input.NationalChain)
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPNationalChainID, NationalChainName)
	VALUES(input.NationalChainID, dbo.udf_TitleCase(input.NationalChain));

	Update @sapch Set NationalChainName = 'CVS/Pharmacy' Where NationalChainName = 'Cvs/Pharmacy'
	Update @sapch Set NationalChainName = 'Walmart US' Where NationalChainName = 'Walmart Us'
	Update @sapch Set ChangeTrackNumber = Checksum(SAPNationalChainID, NationalChainName);
	
	MERGE SAP.NationalChain AS pc
	USING (Select NationalChainID, SAPNationalChainID, NationalChainName, ChangeTrackNumber
			   From @sapch) AS input
			ON pc.NationalChainID = input.NationalChainID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPNationalChainID, NationalChainName, ChangeTrackNumber, LastModified, InBW)
	VALUES(input.SAPNationalChainID, input.NationalChainName, input.ChangeTrackNumber, GetDate(), 1);

	Update sdm
	Set SAPNationalChainID = sap.SAPNationalChainID, NationalChainName = sap.NationalChainName, ChangeTrackNumber = sap.ChangeTrackNumber, 
		LastModified = GetDate(), InBW = 1
	From @sapch sap
	Join SAP.NationalChain sdm on sap.NationalChainID = sdm.NationalChainID and sap.ChangeTrackNumber != isnull(sdm.ChangeTrackNumber, 0)

	--------------------------------------------
	---- Regional Chain ------------------------
	Declare @saprc Table
	(
		[RegionalChainID] int,
		[SAPRegionalChainID] int, 
		[RegionalChainName] varchar(50),
		[NationalChainID] int,
		[ChangeTrackNumber] int,
		InBW bit
	)
	Insert @saprc
	Select [RegionalChainID], [SAPRegionalChainID], [RegionalChainName], [NationalChainID], ChangeTrackNumber, InBW
	From SAP.RegionalChain 

	MERGE @saprc AS bu
		USING ( Select nc.NationalChainID, RegionalChainID, c.RegionalChain 
				From (SELECT Distinct NationalChainID, NationalChain, RegionalChainID, RegionalChain
						From Staging.Chain Where Rtrim(RegionalChain) != '' And NationalChain != '') c
				Left Join SAP.NationalChain nc on nc.SAPNationalChainID = c.NationalChainID) AS input
			ON bu.SAPRegionalChainID = input.RegionalChainID
	WHEN MATCHED THEN 
		UPDATE SET bu.RegionalChainName = dbo.udf_TitleCase(input.RegionalChain),
				   bu.NationalChainID = input.NationalChainID,
				   InBW = 1
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPRegionalChainID, RegionalChainName, NationalChainID, INBW)
	VALUES(RegionalChainID, dbo.udf_TitleCase(input.RegionalChain), NationalChainID, 1);

	Update @saprc Set RegionalChainName = 'CVS/Pharmacy' Where RegionalChainName = 'Cvs/Pharmacy'
	Update @saprc Set ChangeTrackNumber = CHECKSUM(SAPRegionalChainID, RegionalChainName, NationalChainID)
	
	MERGE SAP.RegionalChain AS pc
	USING @saprc AS input ON pc.RegionalChainID = input.RegionalChainID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPRegionalChainID, RegionalChainName, NationalChainID, ChangeTrackNumber, LastModified, INBW)
	VALUES(input.SAPRegionalChainID, input.RegionalChainName, input.NationalChainID, input.ChangeTrackNumber, GetDate(), 1);

	Update sdm
	Set SAPRegionalChainID = sap.SAPRegionalChainID, RegionalChainName = sap.RegionalChainName, 
		NationalChainID = sap.NationalChainID, ChangeTrackNumber = sap.ChangeTrackNumber, LastModified = GetDate(), InBW = 1
	From @saprc sap
	Join SAP.RegionalChain sdm on sap.RegionalChainID = sdm.RegionalChainID and sap.ChangeTrackNumber != isnull(sdm.ChangeTrackNumber, 0)
	--------------------------------------------

	--------------------------------------------
	---Local Chain------------------------------
	Declare @saplc Table
	(
		LocalChainID int, 
		SAPLocalChainID int,
		LocalChainName varchar(128), 
		RegionalChainID int, 
		ChangeTrackNumber int,
		InBW bit
	)
	Insert @saplc(LocalChainID, SAPLocalChainID, LocalChainName, RegionalChainID, ChangeTrackNumber, InBW)
	Select LocalChainID, SAPLocalChainID, LocalChainName, RegionalChainID, ChangeTrackNumber, InBW From SAP.LocalChain

	MERGE @saplc AS ba
		USING ( Select LocalChain, rc.RegionalChainID, l.LocalChainID From
				( Select Distinct LocalChainID, LocalChain, RegionalChainId, RegionalChain
					From Staging.Chain 
					Where LocalChainID Not In ('#', '', 'test hier2', 'Test Hierr 02') And 
						(Not (Convert(int, LocalChainID) = '1000105' And Convert(int, RegionalChainID) = '1000265'))) l
				Left Join SAP.RegionalChain rc on l.RegionalChainID = rc.SAPRegionalChainID) AS input
			ON ba.SAPLocalChainID = input.LocalChainID
	WHEN MATCHED THEN
		UPDATE SET ba.LocalChainName = dbo.udf_TitleCase(input.LocalChain),
					ba.RegionalChainID = input.RegionalChainID,
					InBW = 1
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPLocalChainID, LocalChainName, RegionalChainID, INBW)
	VALUES(input.LocalChainID, dbo.udf_TitleCase(input.LocalChain), input.RegionalChainID, 1);

	Update @saplc Set LocalChainName = 'CVS/Pharmacy' Where LocalChainName = 'Cvs/Pharmacy'
	Update @saplc Set ChangeTrackNumber = CHECKSUM(SAPLocalChainID, LocalChainName, RegionalChainID)

	MERGE SAP.LocalChain AS pc
	USING @saplc AS input ON pc.LocalChainID = input.LocalChainID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPLocalChainID, LocalChainName, RegionalChainID, ChangeTrackNumber, LastModified, InBW)
	VALUES(input.SAPLocalChainID, input.LocalChainName, input.RegionalChainID, input.ChangeTrackNumber, GetDate(), 1);

	Update sdm
	Set SAPLocalChainID = sap.SAPLocalChainID, LocalChainName = sap.LocalChainName, 
		RegionalChainID = sap.RegionalChainID, ChangeTrackNumber = sap.ChangeTrackNumber, LastModified = GetDate(), InBW = 1
	From @saplc sap
	Join SAP.LocalChain sdm on sap.LocalChainID = sdm.LocalChainID and sap.ChangeTrackNumber != isnull(sdm.ChangeTrackNumber, 0)

End

Go

Update SAP.NationalChain Set InBW = 1
Update SAP.LocalChain Set InBW = 1
Update SAP.RegionalChain Set InBW = 1
Go

--Update ETL.BCDAtaLoadingLog
--Set LatestLoadedRecordDate = '2000-1-1'
--Where TableName = 'BCStoreHier'

--Select *
--From ETL.BCDAtaLoadingLog
--Where TableName = 'BCStoreHier'

--Select *
--From SAP.NationalChain

--Select *
--From SAP.RegionalChain

