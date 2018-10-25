USE [Portal_Data]
GO
/****** Object:  StoredProcedure [SupplyChain].[pGetMyPromotion]    Script Date: 12/12/2014 5:43:52 PM ******/
DROP PROCEDURE [SupplyChain].[pGetMyPromotion]
GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdOverAllScoresForLanding]    Script Date: 12/12/2014 5:43:52 PM ******/
DROP PROCEDURE [SupplyChain].[pGetDsdOverAllScoresForLanding]
GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdMostImpactedTrademarksByRegion]    Script Date: 12/12/2014 5:43:52 PM ******/
DROP PROCEDURE [SupplyChain].[pGetDsdMostImpactedTrademarksByRegion]
GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdMostImpactedTrademarksByBranch]    Script Date: 12/12/2014 5:43:52 PM ******/
DROP PROCEDURE [SupplyChain].[pGetDsdMostImpactedTrademarksByBranch]
GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdMostImpactedPackageTypesByRegion]    Script Date: 12/12/2014 5:43:52 PM ******/
DROP PROCEDURE [SupplyChain].[pGetDsdMostImpactedPackageTypesByRegion]
GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdMostImpactedPackageTypesByBranch]    Script Date: 12/12/2014 5:43:52 PM ******/
DROP PROCEDURE [SupplyChain].[pGetDsdMostImpactedPackageTypesByBranch]
GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdMostImpactedPackagesForLanding]    Script Date: 12/12/2014 5:43:52 PM ******/
DROP PROCEDURE [SupplyChain].[pGetDsdMostImpactedPackagesForLanding]
GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdInventoryRegionMeasuresForLanding]    Script Date: 12/12/2014 5:43:52 PM ******/
DROP PROCEDURE [SupplyChain].[pGetDsdInventoryRegionMeasuresForLanding]
GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdInventoryMeasuresByRegionAggregated]    Script Date: 12/12/2014 5:43:52 PM ******/
DROP PROCEDURE [SupplyChain].[pGetDsdInventoryMeasuresByRegionAggregated]
GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdInventoryMeasuresByRegion]    Script Date: 12/12/2014 5:43:52 PM ******/
DROP PROCEDURE [SupplyChain].[pGetDsdInventoryMeasuresByRegion]
GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdInventoryMeasuresByBranchAggregated]    Script Date: 12/12/2014 5:43:52 PM ******/
DROP PROCEDURE [SupplyChain].[pGetDsdInventoryMeasuresByBranchAggregated]
GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdInventoryMeasuresByBranch]    Script Date: 12/12/2014 5:43:52 PM ******/
DROP PROCEDURE [SupplyChain].[pGetDsdInventoryMeasuresByBranch]
GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdInventoryBranchMeasuresForLanding]    Script Date: 12/12/2014 5:43:52 PM ******/
DROP PROCEDURE [SupplyChain].[pGetDsdInventoryBranchMeasuresForLanding]
GO
/****** Object:  StoredProcedure [SupplyChain].[pGetCalFilteredPromotionId]    Script Date: 12/12/2014 5:43:52 PM ******/
DROP PROCEDURE [SupplyChain].[pGetCalFilteredPromotionId]
GO
/****** Object:  StoredProcedure [SupplyChain].[GetProductLineWithTradeMark]    Script Date: 12/12/2014 5:43:52 PM ******/
DROP PROCEDURE [SupplyChain].[GetProductLineWithTradeMark]
GO
/****** Object:  StoredProcedure [SupplyChain].[GetManuFacturingMeasures]    Script Date: 12/12/2014 5:43:52 PM ******/
DROP PROCEDURE [SupplyChain].[GetManuFacturingMeasures]
GO
/****** Object:  StoredProcedure [Playbook].[pInsertUpdatePromotion]    Script Date: 12/12/2014 5:43:52 PM ******/
DROP PROCEDURE [Playbook].[pInsertUpdatePromotion]
GO
/****** Object:  StoredProcedure [Playbook].[pGetPromotionDetailsForCalendar]    Script Date: 12/12/2014 5:43:52 PM ******/
DROP PROCEDURE [Playbook].[pGetPromotionDetailsForCalendar]
GO
/****** Object:  StoredProcedure [Playbook].[pGetFilteredPromotionId]    Script Date: 12/12/2014 5:43:52 PM ******/
DROP PROCEDURE [Playbook].[pGetFilteredPromotionId]
GO
/****** Object:  StoredProcedure [ETL].[pLoadFromRM]    Script Date: 12/12/2014 5:43:52 PM ******/
DROP PROCEDURE [ETL].[pLoadFromRM]
GO
/****** Object:  StoredProcedure [ETL].[pLoadFromRM]    Script Date: 12/12/2014 5:43:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--------------------------------------
--------------------------------------
CREATE PROCEDURE [ETL].[pLoadFromRM]
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
				,a.CITY
				,a.STATE
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
		,GeoCodingNeeded = 0
	FROM (
		SELECT AccountNumber,
			LONGITUDE,
			LATITUDE,
			SalesOffice
		FROM Staging.RNLocation
		WHERE ISNUMERIC(AccountNumber) = 1
		And   Charindex('.', AccountNumber) = 0
		) rnl
	JOIN SAP.Account acc ON rnl.AccountNumber = acc.SAPAccountNumber
	Join SAP.Branch b on acc.BranchID = b.BranchID
	Where b.SAPBranchID = rnl.SalesOffice
	And rnl.Longitude <> 0

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

GO
/****** Object:  StoredProcedure [Playbook].[pGetFilteredPromotionId]    Script Date: 12/12/2014 5:43:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Playbook.pGetFilteredPromotionId @Brand='Dr Pepper',@package='',@Account='', @Bottler =''

--17475

CREATE procedure [Playbook].[pGetFilteredPromotionId]
	@Brand varchar(50) = null,
	@Package varchar(50) = null,
	@Account varchar(50) = null,
	@Channel varchar(50) = null,
	@Bottler varchar(50) = null
as
declare @flag int
set @flag = 0
select 0 flag,-1 Promotionid into #FilterPromotionID

if @Channel = 'My Channel' or @Channel = 'All Channel'
	set @Channel = ''

if @Account = 'My Account' or @Account = 'All Account'
	set @Account = ''





IF @Package = 'All Package'
	OR @Package = 'All Packages'
	SET @Package = ''

IF @Brand = 'All Brand'
	OR @Brand = 'All Brands'
	SET @Brand = ''

IF @Bottler = 'All Bottler'
	OR @Bottler = 'All Bottlers'
	SET @Bottler = ''

IF @Channel = 'My Channel'
	OR @Channel = 'All Channel'
	OR @Channel = 'My Channels'
	OR @Channel = 'All Channels'
	SET @Channel = ''

IF @Account = 'My Account'
	OR @Account = 'All Account'
	OR @Account = 'My Accounts'
	OR @Account = 'All Accounts'
	SET @Account = ''




if(isnull(@Brand,'')<>'')
begin
	insert into #FilterPromotionID
	select 1, promotionid from playbook.promotionbrand where brandid in (select brandid from sap.brand where brandname = @Brand)
	union
	select 1, promotionid from playbook.promotionbrand where trademarkid in (select trademarkid from sap.trademark where TradeMarkName = @Brand)
	set @flag = 1
end

if(isnull(@Package,'')<>'')
begin
	insert into #FilterPromotionID
	select 1,promotionid from playbook.promotionpackage where packageid in (select packageid from sap.package where packagename = @Package)
	set @flag = @flag+1
end

if(isnull(@Account,'')<>'')
begin
	insert into #FilterPromotionID
	select 1,promotionid from playbook.promotionaccount where localchainid in (select localchainid from sap.localchain where localchainname = @Account)
	union
	select 1,promotionid from playbook.promotionaccount where regionalchainid in (select regionalchainid from sap.regionalchain where regionalchainname = @Account)
	union
	select 1,promotionid from playbook.promotionaccount where nationalchainid in (select nationalchainid from sap.nationalchain where nationalchainname = @Account)
	set @flag = @flag + 1
end

if(isnull(@Channel,'')<>'')
begin
	insert into #FilterPromotionID
	select 1,promotionid from playbook.promotionchannel where channelid in (select channelid from sap.channel where ChannelName = @Channel)
	union
	select 1,promotionid from playbook.promotionchannel where superchannelid in (select SuperChannelID from sap.SuperChannel where SuperChannelName = @Channel)
	set @flag = @flag + 1
end

if(isnull(@Bottler,'')<>'')
begin
	declare @BottlerID int
	select @BottlerID = bottlerid from bc.bottler where bottlername= @Bottler
	select * into #BottlerChain from bc.tBottlerChainTradeMark where bottlerid = @BottlerID

	insert into #FilterPromotionID
	SELECT distinct 1, a.promotionid 
	FROM Playbook.RetailPromotion a
	left Join Playbook.PromotionAccountHier b on a.promotionid = b.promotionid
	left JOIN Playbook.promotiongeohier c ON c.promotionid = a.promotionid
	left join playbook.PromotionBrand d on d.promotionid = a.promotionid
	left join sap.brand brnd on brnd.BrandID = d.BrandID
	--JOIN #BottlerChain tc ON tc.bottlerid = c.bottlerid
		--AND tc.trademarkid = case when isnull(d.trademarkid,0) = 0  then brnd.Trademarkid else d.trademarkid end
		--AND tc.localchainid = b.localchainid
	where c.BottlerID =  @BottlerID

	set @flag = @flag + 1
end

--select * from #FilterPromotionID 
declare @retval varchar(max)
set @retval = (
select distinct Convert(varchar(20),Promotionid)  + ',' 
from #FilterPromotionID 
where promotionid <> -1 
group by promotionid 
having sum(flag)=@flag
for xml path(''))

select @retval 



GO
/****** Object:  StoredProcedure [Playbook].[pGetPromotionDetailsForCalendar]    Script Date: 12/12/2014 5:43:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Playbook].[pGetPromotionDetailsForCalendar]     
  @StartDate DATE --= '10/1/2014 12:00:00 AM'-- Promotion Start date                                         
 ,@EndDate DATE --= '12/31/2014 12:00:00 AM' -- Promotion End Date                                           
 ,@currentuser VARCHAR(20) --='tesbm001' -- Current user                                          
 ,@Branchid INT --='139'-- Current Branch                                          
 ,@VIEW_DRAFT_NA BIT --='false'-- True/False : if the user has the rights to View National Account promotion in draft mode for Promotion Activities                                          
 ,@ViewNatProm BIT --='false'-- True/False :  if the user has the rights to View National Promotion for Promotion Activities                                          
 ,@RolledOutAccount VARCHAR(MAX) = '' --= '12,13,20,21,47,60,85,87,173'--'' -- Optional parameter with default null value for rolled out account, passed from front end using SRE                                          
 ,@BCRegionId VARCHAR(max) --=0                         
 ,@CurrentPersonaID INT --= 6        
 ,@TradeMarkId VARCHAR(MAX) =''  
 ,@PackageId VARCHAR(MAX) =''  
AS      
BEGIN      
 DECLARE @LOCAL_startdate DATETIME      
 DECLARE @LOCAL_enddate DATETIME      
 DECLARE @LOCAL_currentuser VARCHAR(20)      
 DECLARE @LOCAL_Branchid INT      
 DECLARE @Local_IsExport BIT      
 DECLARE @TypeId INT      
 DECLARE @bool INT      
      
 --set @Branchid = 120                                    
 SET @LOCAL_startdate = @StartDate      
 SET @LOCAL_enddate = @EndDate      
 SET @LOCAL_currentuser = @currentuser      
 SET @LOCAL_Branchid = @Branchid      
 SET @Local_IsExport = 0      
 SET @TypeId = 2      
 SET @bool = 1      
      
 SELECT 1 Promotionid      
 INTO #PromoIds      
      
 IF (@BCRegionId > 0)      
 BEGIN      
  INSERT INTO #PromoIds      
  EXEC [Playbook].[pGetBCPromotionsByRole] @LOCAL_startdate      
   ,@LOCAL_enddate      
   ,@currentuser      
   ,@BCRegionId      
   ,@VIEW_DRAFT_NA      
   ,@ViewNatProm      
   ,@Local_IsExport      
   ,NULL      
   ,@CurrentPersonaID      
 END      
 ELSE      
 BEGIN      
  IF (@TradeMarkId = '' AND @PackageId = '')      
  BEGIN      
   INSERT INTO #PromoIds      
   EXEC [Playbook].[pGetPromotionsByRole] @LOCAL_startdate      
    ,@LOCAL_enddate      
    ,@LOCAL_currentuser      
    ,@LOCAL_Branchid      
    ,@VIEW_DRAFT_NA      
    ,@ViewNatProm      
    ,@RolledOutAccount      
    ,@Local_IsExport      
    ,@CurrentPersonaID      
  END      
  ELSE      
  BEGIN      
   INSERT INTO #PromoIds      
   EXEC [SupplyChain].[pGetMyPromotion] @LOCAL_Branchid      
    ,@TradeMarkId      
    ,@PackageId      
    ,@TypeId      
    ,@bool      
    ,@LOCAL_startdate      
    ,@LOCAL_enddate    
    ,@LOCAL_currentuser      
    ,@CurrentPersonaID       
  END      
 END      
      
 -- Implement IsMyAccount                    
 DECLARE @SPUserPRofileID INT      
      
 SELECT @SPUserPRofileID = SPUserprofileid      
 FROM Person.SPUserPRofile      
 WHERE GSn = @currentuser      
      
 SELECT DISTINCT b.LocalChainID      
  ,b.RegionalChainID      
  ,b.NationalChainID      
 INTO #UserAccount      
 FROM Person.UserAccount a      
 LEFT JOIN Shared.tLocationChain b ON (      
   a.LocalChainID = b.LocalChainID      
   OR a.RegionalChainID = b.RegionalChainID      
   OR a.NationalChainID = b.NationalChainID      
   )      
 WHERE a.SPUserPRofileID = @SPUserPRofileID      
      
 SELECT - 1 Channelid      
 INTO #UserChannel      
      
 INSERT INTO #UserChannel      
 SELECT DISTINCT a.Channelid      
 FROM Person.UserChannel a      
 WHERE a.SPUserPRofileID = @SPUserPRofileID      
  AND a.Channelid IS NOT NULL      
       
 UNION      
       
 SELECT DISTINCT b.Channelid      
 FROM Person.UserChannel a      
 LEFT JOIN sap.channel b ON a.superchannelid = b.superchannelid      
 WHERE a.SPUserPRofileID = @SPUserPRofileID      
  AND a.superchannelid IS NOT NULL      
      
 SELECT DISTINCT retail.PromotionID      
  ,retail.PromotionName      
  ,retail.PromotionStartdate      
  ,retail.PromotionEnddate      
  ,retail.ProgramId      
  ,retail.IsNationalAccount 'IsNationalAccountPromotion'      
  ,PromotionType.PromotionType      
  ,retail.PromotionGroupID      
  ,retail.createdby AS CreatedBy      
  ,retail.UserGroupName AS UserGroupName -- Added new                    
  ,CASE -- For Is My Account                    
   WHEN retail.PromotionGroupID = 1      
    THEN (      
      CASE       
       WHEN (      
         SELECT TOP 1 1      
         FROM PlayBook.PromotionAccountHier AS account      
         WHERE account.PromotionID = retail.PromotionID      
          AND account.LocalChainID IN (      
           SELECT uAccount.LocalChainID      
           FROM #UserAccount uAccount      
           )      
         ) = 1      
        THEN 1      
       ELSE 0      
       END      
      )      
   WHEN retail.PromotionGroupID = 2      
    THEN 0      
   END AS 'IsMyAccount'      
  ,CASE       
   WHEN retail.PromotioNGroupID = 2      
    THEN (      
      CASE       
       WHEN (      
         SELECT TOP 1 1      
         FROM Playbook.PromotionChannel a      
         LEFT JOIN sap.channel b ON a.superchannelid = b.superchannelid      
         WHERE a.PromotionID = retail.PromotionID      
          AND CASE       
           WHEN isnull(a.SuperChannelid, 0) <> 0      
            THEN b.ChannelID      
           ELSE a.channelId      
           END IN (      
           SELECT channelid      
           FROM #UserChannel      
           )      
         ) = 1      
        THEN 1      
       ELSE 0      
       END      
      )      
   WHEN retail.PromotionGroupID = 1      
    THEN 0      
   END AS 'IsMyChannel'      
 INTO #TempPromotionData      
 FROM PlayBook.RetailPromotion AS retail      
 LEFT JOIN playbook.PromotionType PromotionType ON retail.PromotionTypeID = PromotionType.PromotionTypeID      
 INNER JOIN PlayBook.PromotionGroup promoGroup ON promoGroup.PromotionGroupID = retail.PromotionGroupID      
 WHERE retail.PromotionStatusID = 4      
  AND retail.PromotionID IN (      
   SELECT promotionid      
   FROM #PromoIds      
   )      
      
 --Get All Account                                                                                                                                    
 SELECT DISTINCT retail.PromotionID      
  ,_account.localchainID AS LocalchainID      
  ,_account.RegionalchainID AS RegionalchainID      
  ,_account.NationalchainID AS NationalchainID      
  ,CASE       
   WHEN _account.localchainID <> 0      
    THEN (      
      SELECT LocalChainName      
      FROM SAP.LocalChain AS _sapLocal      
      WHERE _account.LocalChainID = _sapLocal.LocalChainID      
      )      
   WHEN _account.RegionalchainID <> 0      
    THEN (      
      SELECT RegionalChainName      
      FROM SAP.RegionalChain AS _sapRegional      
      WHERE _account.RegionalChainID = _sapRegional.RegionalChainID      
      )      
   WHEN _account.NationalchainID <> 0      
    THEN (      
      SELECT NationalChainName      
      FROM SAP.NationalChain AS _sapNational      
      WHERE _account.NationalChainID = _sapNational.NationalChainID      
      )      
   END AS AccountName      
  ,'True' AS IsMyAccount      
 FROM #TempPromotionData AS retail      
 INNER JOIN Playbook.PromotionAccount _account ON retail.promotionId = _account.PromotionId      
 WHERE retail.PromotionGroupID = 1      
      
 --Get All Channel                                                          
 SELECT DISTINCT retail.PromotionID      
  ,_channel.SuperChannelID AS SuperChannelID      
  ,_channel.ChannelID AS ChannelID      
  ,CASE       
   WHEN _channel.SuperChannelID IS NOT NULL      
    THEN (      
      SELECT SuperChannelName      
      FROM SAP.SuperChannel AS _sapSuperChannel      
      WHERE _channel.SuperChannelID = _sapSuperChannel.SuperChannelID      
      )      
   WHEN _channel.ChannelID IS NOT NULL      
    THEN (      
 SELECT ChannelName      
      FROM SAP.Channel AS _sapChannel      
      WHERE _channel.ChannelID = _sapChannel.ChannelID      
      )      
   END AS ChannelName      
 FROM #TempPromotionData AS retail      
 INNER JOIN Playbook.PromotionChannel _channel ON retail.promotionId = _channel.PromotionId      
 WHERE retail.PromotionGroupID = 2      
      
 -- Get Promotion                                          
 SELECT *      
 FROM #TempPromotionData      
      
 --Get All Programs                                               
 SELECT DISTINCT retail.PromotionID      
  ,_program.ProgramID      
  ,_program.ProgramName      
 FROM #TempPromotionData AS retail      
 INNER JOIN NationalAccount.Program _program ON retail.ProgramID = _program.ProgramID      
END


GO
/****** Object:  StoredProcedure [Playbook].[pInsertUpdatePromotion]    Script Date: 12/12/2014 5:43:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

      
CREATE PROCEDURE [Playbook].[pInsertUpdatePromotion] (      
 --we will add column to save brand-package in json format                                                                                                                     
 @Mode VARCHAR(500)      
 ,@PromotionID INT      
 ,@PromotionDescription VARCHAR(500)      
 ,@PromotionName VARCHAR(500)      
 ,@PromotionTypeID INT      
 ,@GEOInfo XML      
 ,@AccountInfo XML      
 ,@ChannelInfo XML      
 ,@StateXML XML      
 ,@AccountId INT      
 ,@EdgeItemId INT      
 ,@IsLocalized BIT      
 ,@PromotionTradeMarkID VARCHAR(500)      
 ,@PromotionBrandId VARCHAR(500)      
 ,@PromotionPackageID VARCHAR(500)      
 ,@PromotionPrice VARCHAR(500)      
 ,@PromotionCategoryId INT      
 ,@PromotionDisplayLocationId INT      
 ,@PromotionDisplayLocationOther VARCHAR(500)      
 ,@PromotionDisplayRequirement VARCHAR(20)      
 ,@PromotionStartDate DATETIME      
 ,@PromotionEndDate DATETIME      
 ,@PromotionStatus VARCHAR(500)      
 ,@SystemID VARCHAR(500)      
 --,@IsDuplicate BIT              
 ,@ParentPromoId INT      
 ,@IsNewVersion BIT      
 ,@ForecastVolume VARCHAR(500)      
 ,@NationalDisplayTarget VARCHAR(500)      
 ,@BottlerCommitment VARCHAR(500)      
 ,@BranchId INT      
 ,@BUID INT      
 ,@RegionId INT      
 ,@CreatedBy VARCHAR(500)      
 ,@ModifiedBy VARCHAR(500)      
 ,@AccountImageName VARCHAR(50)      
 ,@PromotionGroupID INT      
 ,@ProgramId INT      
 ,@BestBets NVARCHAR(48)      
 ,@EdgeComments NVARCHAR(250)      
 ,@IsNationalPromotion BIT -- True/False if the user has the permission to create NA Promotions                                      
 ,@PromotionDisplayStartDate DATETIME      
 ,@PromotionDisplayEndDate DATETIME      
 ,@PromotionPricingStartDate DATETIME      
 ,@PromotionPricingEndDate DATETIME      
 ,@IsSMA BIT      
 ,@IsCostPerStore BIT      
 ,@TPMNumberCASO VARCHAR(20)      
 ,@TPMNumberPASO VARCHAR(20)      
 ,@TPMNumberISO VARCHAR(20)      
 ,@TPMNumberPB VARCHAR(100)      
 ,@RoleName VARCHAR(50) -- Add new Pram as Role Name for get persona             
 ,@PromotionDisplayTypeId INT      
 ,@PersonaID INT      
 ,@COSTPerStore VARCHAR(50)      
 ,@Status INT OUT      
 ,@Message VARCHAR(500) OUT      
 ,@NewPromoId INT OUT      ,
 @InformationCategory nvarchar(100)
 )      
AS      
BEGIN      
 DECLARE @PromotionStatusId INT      
      
 --Fetch promotion status id by promotion status                                                               
 SELECT @PromotionStatusId = StatusID      
 FROM PlayBook.STATUS      
 WHERE LOWER(StatusName) = LOWER(@PromotionStatus)      
      
 DECLARE @Attachments TABLE (      
  Id INT identity      
  ,PromoId INT      
  ,Url VARCHAR(500)      
  ,NAME VARCHAR(500)      
  )      
 DECLARE @tblTradeMark TABLE (      
  Id INT identity(1, 1)      
  ,TradeMarkId VARCHAR(100)      
  )      
 DECLARE @tblBrands TABLE (      
  Id INT identity(1, 1)      
  ,BrandId VARCHAR(100)      
  )      
 DECLARE @tblPackage TABLE (      
  Id INT identity(1, 1)      
  ,PackageId VARCHAR(100)      
  )      
 -- Fatching User Group Name from  table                            
 DECLARE @UserGroupName VARCHAR(50)      
      
 SELECT @UserGroupName = UserGroupName      
 FROM Playbook.UserGroup      
 WHERE RoleName = @RoleName      
      
 --print @UserGroupName                    
 IF (@Mode = 'Insert')      
 BEGIN      
  -- Insert promotion                                                                                                               
  INSERT INTO PlayBook.RetailPromotion (      
   PromotionName      
   ,PromotionDescription      
   ,PromotionTypeID      
   ,PromotionPrice      
   ,PromotionCategoryID      
   ,PromotionStatusID      
   ,PromotionStartDate      
   ,PromotionEndDate      
   ,ForecastVolume      
   ,NationalDisplayTarget      
   ,BottlerCommitment      
  ,PromotionBranchID      
   ,PromotionBUID      
   ,PromotionRegionID      
   ,EDGEItemID      
   ,IsLocalized      
   ,CreatedBy      
   ,CreatedDate      
   ,ModifiedBy      
   ,ModifiedDate      
   ,AccountImageName      
,InformationCategory      
   ,PromotionGroupID      
   ,ProgramId      
   ,NationalChainID      
   ,IsNationalAccount      
   ,StatusModifiedDate      
   ,BestBets      
   ,EdgeComments      
   ,PromotionRelevantStartDate      
   ,PromotionRelevantEndDate      
,DisplayStartDate -- new date fields                                    
   ,DisplayEndDate -- new date fields                                    
   ,PricingStartDate -- new date fields                                    
   ,PricingEndDate -- new date fields                 
   ,IsSMA      
   ,IsCostPerStore      
   ,TPMCASO      
   ,TPMPASO      
   ,TPMISO      
   ,TPMPB      
   ,PersonaID      
   ,UserGroupName      
   ,DisplayTypeID      
   ,CostPerStore      
   )      
  VALUES (      
   @PromotionName      
   ,@PromotionDescription      
   ,@PromotionTypeID      
   ,@PromotionPrice      
   ,@PromotionCategoryId      
   ,@PromotionStatusId      
   ,@PromotionStartDate      
   ,@PromotionEndDate      
   ,@ForecastVolume      
   ,@NationalDisplayTarget      
   ,@BottlerCommitment      
   ,@BranchId      
   ,@BUID      
   ,@RegionId      
   ,@EdgeItemId      
   ,@IsLocalized      
   ,@CreatedBy      
   ,GETUTCDATE()      
   ,@ModifiedBy      
   ,GETUTCDATE()      
   ,@AccountImageName      
   ,'Promotion'      
   ,@PromotionGroupID      
   ,@ProgramId      
   ,@AccountId      
   ,@IsNationalPromotion      
   ,GETUTCDATE()      
   ,@BestBets      
   ,@EdgeComments      
   ,CASE       
    WHEN DATENAME(DW, @PromotionStartDate) = 'Sunday'      
     THEN DATEADD(wk, DATEDIFF(wk, 0, @PromotionStartDate), - 7)      
    ELSE DATEADD(wk, DATEDIFF(wk, 7, @PromotionStartDate), 7)      
    END      
   ,CASE       
    WHEN DATENAME(DW, @PromotionEndDate) = 'Sunday'      
     THEN @PromotionEndDate      
    ELSE DATEADD(wk, DATEDIFF(wk, 6, @PromotionEndDate), 6 + 7)      
    END      
   ,@PromotionDisplayStartDate      
   ,@PromotionDisplayEndDate      
   ,@PromotionPricingStartDate      
   ,@PromotionPricingEndDate      
   ,@IsSMA      
   ,@IsCostPerStore      
   ,@TPMNumberCASO      
   ,@TPMNumberPASO      
   ,@TPMNumberISO      
   ,@TPMNumberPB      
   ,@PersonaID      
   ,@UserGroupName      
   ,@PromotionDisplayTypeId      
   ,@COSTPerStore      
   )      
      
  SET @PromotionID = SCOPE_IDENTITY()      
  SET @NewPromoId = @PromotionID;      
      
  ----To create duplicate promotion                                                                           
  IF (@IsNewVersion = 1)      
   UPDATE PlayBook.RetailPromotion      
   SET ParentPromotionID = @ParentPromoId      
    ,islocalized = 1      
   WHERE PromotionID = @PromotionID      
      
  ----Save data for display location . for other option we have update PromotionDisplayLocationOther column in PlayBook.PromotionDisplayLocation                                                                                                               

  
   
  --IF (@PromotionDisplayLocationId = 23) --23 id for other option in display location                                                                                                                  
  --BEGIN                                      
  INSERT INTO PlayBook.PromotionDisplayLocation (      
   PromotionID      
   ,DisplayLocationID      
   ,PromotionDisplayLocationOther      
   ,DisplayRequirement      
   )      
  VALUES (      
   @PromotionID      
   ,@PromotionDisplayLocationId      
   ,@PromotionDisplayLocationOther      
   ,@PromotionDisplayRequirement      
   )      
      
  --END                                      
 --ELSE                                      
  --BEGIN                                      
  -- INSERT INTO PlayBook.PromotionDisplayLocation (                                      
  --  PromotionID                                      
  --  ,DisplayLocationID                                      
  --  )                                      
  -- VALUES (                                      
  --  @PromotionID                                      
  --  ,@PromotionDisplayLocationId                                      
  --  )                                      
  --END                                      
  ----Add account for Promotion                                                                                                                  
  --IF(@PromotionTypeID=2)--Regional chain                                                                                          
  --INSERT INTO PlayBook.PromotionAccount(PromotionID,RegionalChainID) VALUES(@PromotionID,@AccountId)                                                                
  --IF(@PromotionTypeID=1)--National chain                                                                                                           
  --INSERT INTO PlayBook.PromotionAccount( PromotionID , NationalChainID ) VALUES( @PromotionID , @AccountId )                                                                                  
  --IF(@PromotionTypeID=3)--Local chain                                                                
  -- INSERT INTO PlayBook.PromotionAccount(PromotionID, LocalChainID) VALUES(@PromotionID,@AccountId)                                                                              
  INSERT INTO PlayBook.PromotionAccount (      
   PromotionID      
   ,LocalChainID      
   ,RegionalChainID      
   ,NationalChainID      
   )      
  SELECT DISTINCT @PromotionID AS PromotionID      
   ,item.value('LocalChainID[1]', 'varchar(100)') AS LocalChainID      
   ,item.value('RegionalChainID[1]', 'varchar(100)') AS RegionalChainID      
   ,item.value('NationalChainID[1]', 'varchar(100)') AS NationalChainID      
  --,item.value('IsRoot[1]', 'varchar(100)') AS IsRoot          
  FROM @AccountInfo.nodes('Account/Item') AS items(item)      
      
  --   -- Insert trade mark for promotion                                                                                     
  INSERT INTO @tblTradeMark (TradeMarkId)      
  SELECT *      
  FROM CDE.udfSplit(@PromotionTradeMarkID, ',')      
  WHERE Value != ''      
   AND Value IS NOT NULL      
      
  INSERT INTO PlayBook.PromotionBrand (      
   PromotionID      
   ,TrademarkID      
   )      
  SELECT @PromotionID      
   ,CAST(TradeMarkId AS INT)      
  FROM @tblTradeMark      
      
  ----   -- Insert System for promotion                                                          
  --INSERT INTO @tblPromotionSystem (SystemId)                            
  --SELECT *                            
  --FROM CDE.udfSplit(@SystemID, ',')                            
  --INSERT INTO PlayBook.PromotionSystem (                            
  -- PromotionID                            
  -- ,SystemID                            
  -- )                            
  --SELECT @PromotionID                            
  -- ,CAST(SystemId AS INT)                            
  --FROM @tblPromotionSystem                            
  --Insert Brand instead of trademark for Core Ten Category                                                                                            
  IF (@PromotionBrandId != '')      
  BEGIN      
   INSERT INTO @tblBrands (BrandId)      
   SELECT *      
   FROM CDE.udfSplit(@PromotionBrandId, ',')      
   WHERE Value != ''      
    AND Value IS NOT NULL      
      
   INSERT INTO PlayBook.PromotionBrand (      
    PromotionID      
    ,BrandID      
    )      
   SELECT @PromotionID      
    ,CAST(BrandId AS INT)      
   FROM @tblBrands      
  END      
      
  --Insert Package for promotion                                                                                                                  
  INSERT INTO @tblPackage (PackageId)      
  SELECT *      
  FROM CDE.udfSplit(@PromotionPackageID, ',')      
  WHERE Value != ''      
   AND Value IS NOT NULL      
      
  INSERT INTO PlayBook.PromotionPackage (      
   PromotionID      
   ,PackageID      
   )      
  SELECT @PromotionID      
   ,CAST(PackageId AS INT)      
  FROM @tblPackage      
      
  -- Insert GEO relevancy                                                                   
  EXEC Playbook.[PInsertUpdatePromotionGEORelevancy] @PromotionID      
   ,@GEOInfo      
   ,@SystemID      
      
  --INSERT INTO PlayBook.PromotionGeoRelevancy (                              
  -- PromotionID                              
  -- ,BUID                              
  -- ,RegionId                              
  -- ,BranchId                              
  -- ,AreaId                              
  -- )                              
  --SELECT @PromotionID AS PromotionID                              
  -- ,item.value('BUID[1]', 'varchar(500)') AS BUID                              
  -- ,item.value('RegionId[1]', 'varchar(500)') AS RegionID                              
  -- ,item.value('BranchId[1]', 'varchar(500)') AS BranchId                              
  -- ,item.value('AreaId[1]', 'varchar(500)') AS AreaId                              
  --FROM @GEOInfo.nodes('GEO/Item') AS items(item)                      
  ---Channel---                                                                  
  INSERT INTO PlayBook.PromotionChannel      
  SELECT (      
    CASE       
     WHEN item.value('SuperChannelID[1]', 'varchar(100)') = ''      
      THEN NULL      
     ELSE CAST(item.value('SuperChannelID[1]', 'varchar(100)') AS INT)      
     END      
    ) AS SuperChannelID      
   ,(      
    CASE       
     WHEN item.value('ChannelID[1]', 'varchar(100)') = ''      
      THEN NULL      
     ELSE CAST(item.value('ChannelID[1]', 'varchar(100)') AS INT)      
     END      
    ) AS ChannelID      
   ,@PromotionID AS PromotionID      
  FROM @ChannelInfo.nodes('Channel/Item') AS items(item)      
      
  SET @Status = 1      
  SET @Message = 'Promotion has been inserted successfully.'      
 END      
      
 --Update Promotion                         
 IF (@Mode = 'Update')      
 BEGIN      
  UPDATE PlayBook.RetailPromotion      
  SET PromotionName = @PromotionName      
   ,PromotionDescription = @PromotionDescription      
   ,PromotionTypeID = @PromotionTypeID      
   ,PromotionPrice = @PromotionPrice      
   ,PromotionCategoryID = @PromotionCategoryId      
   ,PromotionDisplayLocationID = @PromotionDisplayLocationID      
   ,PromotionStatusID = @PromotionStatusId      
   ,PromotionStartDate = @PromotionStartDate      
   ,PromotionEndDate = @PromotionEndDate      
   ,ForecastVolume = @ForecastVolume      
   ,NationalDisplayTarget = @NationalDisplayTarget      
   ,BottlerCommitment = @BottlerCommitment      
   ,PromotionBranchID = @BranchId      
   ,PromotionBUID = @BUID      
   ,PromotionRegionID = @RegionId      
   ,EDGEItemID = @EdgeItemId      
   ,ModifiedBy = @ModifiedBy      
   ,ModifiedDate = GETUTCDATE()      
   ,AccountImageName = @AccountImageName      
   ,PromotionGroupID = @PromotionGroupID      
   ,ProgramId = @ProgramID      
   ,NationalChainID = @AccountId      
   ,BestBets = @BestBets      
   ,EdgeComments = @EdgeComments      
   ,StatusModifiedDate = CASE       
    WHEN PromotionStatusID = @PromotionStatusId      
     THEN StatusModifiedDate      
    ELSE GETUTCDATE()      
    END      
   ,PromotionRelevantStartDate = CASE       
    WHEN DATENAME(DW, @PromotionStartDate) = 'Sunday'      
     THEN DATEADD(wk, DATEDIFF(wk, 0, @PromotionStartDate), - 7)      
    ELSE DATEADD(wk, DATEDIFF(wk, 7, @PromotionStartDate), 7)      
    END      
   ,PromotionRelevantEndDate = CASE       
    WHEN DATENAME(DW, @PromotionEndDate) = 'Sunday'      
     THEN @PromotionEndDate      
    ELSE DATEADD(wk, DATEDIFF(wk, 6, @PromotionEndDate), 6 + 7)      
    END      
   ,DisplayStartDate = @PromotionDisplayStartDate      
   ,DisplayEndDate = @PromotionDisplayEndDate      
   ,PricingStartDate = @PromotionPricingStartDate      
   ,PricingEndDate = @PromotionPricingEndDate      
   ,IsSMA = @IsSMA      
   ,IsCostPerStore = @IsCostPerStore      
   ,TPMCASO = @TPMNumberCASO      
   ,TPMPASO = @TPMNumberPASO      
   ,TPMISO = @TPMNumberISO      
   ,TPMPB = @TPMNumberPB      
   ,DisplayTypeID = @PromotionDisplayTypeId      
   ,CostPerStore = @COSTPerStore      
  WHERE PromotionId = @PromotionID      
      
  --IF (@PromotionDisplayLocationId = 23)                                      
  --BEGIN                                      
  UPDATE PlayBook.PromotionDisplayLocation      
  SET DisplayLocationID = @PromotionDisplayLocationId      
   ,PromotionDisplayLocationOther = @PromotionDisplayLocationOther      
   ,DisplayRequirement = @PromotionDisplayRequirement      
  WHERE PromotionID = @PromotionID;      
      
  
	--Deleting priority if change in account
	if exists(Select isnull(localchainid,0)+isnull(regionalchainid,0)+isnull(nationalchainid,0)
			from PlayBook.PromotionAccount
			where PromotionID = @PromotionID and 
			isnull(localchainid,0)+isnull(regionalchainid,0)+isnull(nationalchainid,0) not in 
			(SELECT  isnull(item.value('LocalChainID[1]', 'varchar(100)') ,0) +
			   isnull(item.value('RegionalChainID[1]', 'varchar(100)') ,0) +
			   isnull(item.value('NationalChainID[1]', 'varchar(100)') ,0) 
			FROM @AccountInfo.nodes('Account/Item') AS items(item)  )
			)
	begin
		update playbook.promotionrank 
		set Rank = null
		where PromotionID = @PromotionID  
	end

  --Promotion account      
  DELETE PlayBook.PromotionAccount      
  WHERE PromotionID = @PromotionID      
      
  INSERT INTO PlayBook.PromotionAccount (      
   PromotionID      
   ,LocalChainID      
   ,RegionalChainID      
   ,NationalChainID      
   )      
  SELECT DISTINCT @PromotionID AS PromotionID      
   ,item.value('LocalChainID[1]', 'varchar(100)') AS LocalChainID      
   ,item.value('RegionalChainID[1]', 'varchar(100)') AS RegionalChainID      
   ,item.value('NationalChainID[1]', 'varchar(100)') AS NationalChainID      
  --,item.value('IsRoot[1]', 'varchar(100)') AS IsRoot          
  FROM @AccountInfo.nodes('Account/Item') AS items(item)      
      
  --Delete Brands and Insert new so that we can have updated brands for promotion.                                                                                                                  
  DELETE PlayBook.PromotionBrand      
  WHERE PromotionID = @PromotionID      
      
  --Insert TradeMark for promotion                                                                                                                    
  INSERT INTO @tblTradeMark (TradeMarkId)      
  SELECT *      
  FROM CDE.udfSplit(@PromotionTradeMarkID, ',')      
      
  INSERT INTO PlayBook.PromotionBrand (      
   PromotionID      
   ,TrademarkID      
   )      
  SELECT @PromotionID      
   ,CAST(TradeMarkId AS INT)      
  FROM @tblTradeMark      
      
  SET @Message = 'Promotion brand has been updated successfully.'      
      
  ----  -- Insert System for promotion                                                          
  --DELETE PlayBook.PromotionSystem                            
  --WHERE PromotionID = @PromotionID                            
  --INSERT INTO @tblPromotionSystem (SystemId)                            
  --SELECT *                            
  --FROM CDE.udfSplit(@SystemID, ',')                            
  --INSERT INTO PlayBook.PromotionSystem (                            
  -- PromotionID                            
  -- ,SystemID                            
  -- )                            
  --SELECT @PromotionID                            
  -- ,CAST(SystemId AS INT)                            
  --FROM @tblPromotionSystem                            
  --Insert brandid instead of trademarkid for core ten category                                                                                            
  IF (@PromotionBrandId != '')      
  BEGIN      
   INSERT INTO @tblBrands (BrandId)      
   SELECT *      
   FROM CDE.udfSplit(@PromotionBrandId, ',')      
      
   INSERT INTO PlayBook.PromotionBrand (      
    PromotionID      
    ,BrandID      
    )      
   SELECT @PromotionID      
    ,CAST(BrandId AS INT)      
   FROM @tblBrands      
  END      
      
  --Insert Package for promotion                                                                           
  DELETE PlayBook.PromotionPackage      
  WHERE PromotionID = @PromotionID      
      
  INSERT INTO @tblPackage (PackageId)      
  SELECT *      
  FROM CDE.udfSplit(@PromotionPackageID, ',')      
      
  INSERT INTO PlayBook.PromotionPackage (      
   PromotionID      
   ,PackageID      
   )      
  SELECT @PromotionID      
   ,CAST(PackageId AS INT)      
  FROM @tblPackage      
      
  SET @NewPromoId = 0;      
      
  PRINT 'Pro=' + convert(VARCHAR, @PromotionID)      
      
  --Update GEO Relevancy             
  --delete existing promotion with same id                                  
  EXEC Playbook.[PInsertUpdatePromotionGEORelevancy] @PromotionID      
   ,@GEOInfo      
   ,@SystemID      
      
  --INSERT INTO PlayBook.PromotionGeoRelevancy (                              
  -- PromotionID                              
  -- ,BUID                              
  -- ,RegionId                              
  -- ,BranchId                              
  -- ,AreaId                              
  -- )                              
  --SELECT @PromotionID AS PromotionID                              
  -- ,item.value('BUID[1]', 'varchar(500)') AS BUID                              
  -- ,item.value('RegionId[1]', 'varchar(500)') AS RegionID                              
  -- ,item.value('BranchId[1]', 'varchar(500)') AS BranchId                              
  -- ,item.value('AreaId[1]', 'varchar(500)') AS AreaId                              
  --FROM @GEOInfo.nodes('GEO/Item') AS items(item)                              
  ----Promotion Channel                                                     
  DELETE PlayBook.PromotionChannel      
  WHERE PromotionId = @PromotionID      
      
  INSERT INTO PlayBook.PromotionChannel      
  SELECT (      
    CASE       
     WHEN item.value('SuperChannelID[1]', 'varchar(100)') = ''      
      THEN NULL      
     ELSE CAST(item.value('SuperChannelID[1]', 'varchar(100)') AS INT)      
     END      
    ) AS SuperChannelID      
   ,(      
    CASE       
     WHEN item.value('ChannelID[1]', 'varchar(100)') = ''      
      THEN NULL      
     ELSE CAST(item.value('ChannelID[1]', 'varchar(100)') AS INT)      
     END      
    ) AS ChannelID      
   ,@PromotionID AS PromotionID      
  FROM @ChannelInfo.nodes('Channel/Item') AS items(item)      
      
  SET @Status = 1      
  SET @Message = 'Promotion has been updated successfully.'      
 END      
      
 IF @IsNationalPromotion = 1 --Approve                                                
 BEGIN      
  --if @PromotionStatusId = 4                                                 
  -- --copying promotions                                                
  -- exec Playbook.pCreatePromotionCopies @PromotionID                                      
  IF @PromotionStatusId = 3 --Cancelled                        
  BEGIN      
   --Cancelling all promotions                                                
   UPDATE PlayBook.RetailPromotion      
   SET PromotionStatusID = @PromotionStatusId      
    ,StatusModifiedDate = GETUTCDATE()      
   WHERE EDGEItemID = @PromotionID      
  END      
 END      
      
 IF (@IsNationalPromotion = 1)      
 BEGIN      
  UPDATE PlayBook.RetailPromotion      
  SET PromotionName = @PromotionName      
   ,PromotionDescription = @PromotionDescription      
   ,PromotionStatusID = @PromotionStatusId      
  WHERE ParentPromotionId = @PromotionID      
 END      
      
 --Updating Account Hier                
 EXEC Playbook.pInsertUpdatePromotionAccountHier @PromotionID      
      
 declare @NationalChainID int      
 set @NationalChainID = 0      
 set @NationalChainID = (select top 1 NationalChainID from playbook.PromotionAccount where promotionid = @PromotionID and isnull(NationalChainID,0) <>0)      
 if(isnull(@NationalChainID,0) =0 )      
  set @NationalChainID = (select top 1 b.NationalChainID from       
       playbook.PromotionAccount a      
       left join Sap.regionalchain b on a.regionalchainid = b.regionalchainid      
       where a.promotionid = @PromotionID and isnull(a.regionalchainid,0) <>0)      
 if(isnull(@NationalChainID,0)=0 )      
  set @NationalChainID = (select top 1 c.NationalChainID from       
       playbook.PromotionAccount a      
       left join Sap.localchain b on a.localchainid = b.localchainid      
       left join Sap.regionalchain c on c.regionalchainid = b.regionalchainid      
       where a.promotionid = @PromotionID and isnull(a.localchainid,0) <>0)      
      
 -- Update Account Info, GEO and Brands                
 UPDATE PlayBook.RetailPromotion      
 SET       
 NationalChainID = @NationalChainID      
      
 ,PromotionBrands = STUFF((      
    SELECT TradeMarkName      
    FROM (      
     SELECT DISTINCT ' | ' + trademark.TradeMarkName AS TradeMarkName      
     FROM SAP.TradeMark AS trademark      
     WHERE trademark.TradeMarkID IN (      
       SELECT _brand.TrademarkID      
       FROM PlayBook.PromotionBrand AS _brand      
       WHERE _brand.PromotionID = @PromotionID      
       )      
           
     UNION      
           
     SELECT DISTINCT ' | ' + brands.brandName AS TradeMarkName      
     FROM SAP.Brand AS brands      
     WHERE brands.BrandId IN (      
       SELECT _brand.BrandID      
       FROM PlayBook.PromotionBrand AS _brand      
       WHERE _brand.PromotionID = @PromotionID      
       )      
     ) AS table1      
    FOR XML PATH('')      
     ,TYPE      
    ).value('.', 'NVARCHAR(MAX)'), 1, 2, '')      
  ,promotionPackages = STUFF((      
    SELECT DISTINCT ' | ' + _package.PackageName      
    FROM SAP.Package AS _package      
    WHERE _package.PackageID IN (      
      SELECT _pPackage.PackageID      
      FROM PlayBook.PromotionPackage AS _pPackage      
      WHERE _pPackage.PromotionID = @PromotionID      
      )      
    FOR XML PATH('')      
     ,TYPE      
    ).value('.', 'NVARCHAR(MAX)'), 1, 2, '')      
  ,AccountInfo = STUFF((      
    SELECT DISTINCT ' | ' + CASE       
      WHEN _account.localchainID <> 0      
       THEN (      
         SELECT LocalChainName      
         FROM SAP.LocalChain AS _sapLocal      
         WHERE _account.LocalChainID = _sapLocal.LocalChainID      
         )      
      WHEN _account.RegionalchainID <> 0      
       THEN (      
         SELECT RegionalChainName      
         FROM SAP.RegionalChain AS _sapRegional      
         WHERE _account.RegionalChainID = _sapRegional.RegionalChainID      
         )      
      WHEN _account.NationalchainID <> 0      
       THEN (      
         SELECT NationalChainName      
         FROM SAP.NationalChain AS _sapNational      
         WHERE _account.NationalChainID = _sapNational.NationalChainID      
         )      
      END AS _account      
    FROM PlayBook.PromotionAccount AS _account      
    WHERE _account.PromotionID = @PromotionID      
     --AND _account.IsRoot = 0                
     AND PromotionGroupID = 1      
    FOR XML PATH('')      
     ,TYPE      
    ).value('.', 'NVARCHAR(MAX)'), 1, 2, '')      
  ,GEORelavency = STUFF((      
    SELECT DISTINCT ' | ' + CASE       
      WHEN IsNull(_geoRel.BUID, 0) <> 0      
       THEN (      
         'BU - ' + (      
          SELECT BUName      
          FROM SAP.BusinessUnit _sapBU      
          WHERE _geoRel.BUID = _sapBU.BUID      
          )      
         )      
      WHEN IsNull(_geoRel.RegionID, 0) <> 0      
       THEN (      
         'Region - ' + (      
          SELECT RegionName      
          FROM SAP.Region _sapRegion      
          WHERE _geoRel.RegionID = _sapRegion.RegionID      
          )      
         )      
      WHEN IsNull(_geoRel.BranchId, 0) <> 0      
       THEN (      
         'Branch - ' + (      
          SELECT BranchName      
          FROM SAP.Branch _sapBranch      
          WHERE _geoRel.BranchID = _sapBranch.BranchID      
          )      
         )      
      WHEN IsNull(_geoRel.AreaId, 0) <> 0      
       THEN (      
         'Area - ' + (      
          SELECT AreaName      
          FROM SAP.Area _sapArea      
          WHERE _geoRel.AreaID = _sapArea.AreaID      
          )      
         )      
        -- -- FOR SYSTEM, ZONE, Division, BCRegionID,StateID                  
      WHEN IsNull(_geoRel.SystemID, 0) <> 0      
       THEN (      
         'System - ' + (      
          SELECT SystemName      
          FROM NationalAccount.System      
          WHERE bcsystemID = _geoRel.SystemID      
          )      
         )      
      WHEN isnull(_geoRel.ZoneID, 0) <> 0      
       THEN (      
         'Zone - ' + (      
SELECT zonename      
          FROM bc.zone      
          WHERE zoneid = _geoRel.ZoneID      
          )      
         )      
      WHEN isnull(_geoRel.DivisionID, 0) <> 0      
       THEN (      
         'Division - ' + (      
          SELECT divisionname      
          FROM bc.division      
          WHERE divisionid = _geoRel.DivisionID      
          )      
         )      
      WHEN isnull(_geoRel.BCRegionID, 0) <> 0      
       THEN (      
         'BC Region - ' + (      
          SELECT regionname      
          FROM bc.region      
          WHERE regionid = _geoRel.BCRegionID      
          )      
         )      
      WHEN isnull(_geoRel.BottlerID, 0) <> 0      
       THEN (      
         'Bottler - ' + (      
          SELECT bottlername      
          FROM bc.bottler      
          WHERE bottlerid = _geoRel.BottlerID      
          )      
         )      
      WHEN isnull(_geoRel.StateID, 0) <> 0      
       THEN (      
         'State - ' + (      
          SELECT RegionName      
          FROM shared.stateregion      
          WHERE StateRegionID = _geoRel.StateID      
          )      
         )      
      END AS _geoRel      
    FROM PlayBook.PromotionGeoRelevancy AS _geoRel      
    WHERE _geoRel.PromotionID = @PromotionID      
    FOR XML PATH('')      
     ,TYPE      
    ).value('.', 'NVARCHAR(MAX)'), 1, 2, '')      
  ,PromotionChannel = STUFF((      
    SELECT DISTINCT ' | ' + CASE       
      WHEN _channel.SuperChannelID IS NOT NULL      
       THEN (      
       SELECT SuperChannelName      
         FROM SAP.SuperChannel AS _sapSuperChannel      
         WHERE _channel.SuperChannelID = _sapSuperChannel.SuperChannelID      
         )      
      WHEN _channel.ChannelID IS NOT NULL      
       THEN (      
         SELECT ChannelName      
         FROM SAP.Channel AS _sapChannel      
         WHERE _channel.ChannelID = _sapChannel.ChannelID      
     )      
      END AS _channel      
    FROM PlayBook.PromotionChannel AS _channel      
    WHERE _channel.PromotionID = @PromotionID      
    FOR XML PATH('')      
     ,TYPE      
    ).value('.', 'NVARCHAR(MAX)'), 1, 2, '')      
 WHERE PromotionId = @PromotionID      
      
 --Update all System if all system are selected        
 DECLARE @sysCount INT = 0      
  ,@buCount INT = 0      
      
 SELECT @sysCount = count(1)      
 FROM playbook.PromotionGeoRelevancy      
 WHERE PromotionID = @PromotionID      
  AND SystemID IS NOT NULL      
      
 SELECT @buCount = count(1)      
 FROM playbook.PromotionGeoRelevancy      
 WHERE PromotionID = @PromotionID      
  AND BUID IS NOT NULL      
      
 IF (      
   @sysCount = 3      
   AND @buCount = 3      
   )      
 BEGIN      
  UPDATE playbook.RetailPromotion      
  SET GEORelavency = 'All Systems'      
  WHERE PromotionID = @PromotionID      
      
  --As all systems and BU are selected, addin flag for WD as well      
  Insert into playbook.promotionGeoRelevancy(PromotioniD, WD)      
  values(@PromotionID,1)      
  --Update Systems    
   
 END     
  exec Playbook.pUpdatePromotionSystem @PromotionID    
END 



GO
/****** Object:  StoredProcedure [SupplyChain].[GetManuFacturingMeasures]    Script Date: 12/12/2014 5:43:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


  
/*    
Select * from SupplyChain.Plant Where SAPPlantNumber in ('1118','1304','1331','1213','1212')
[SupplyChain].[GetManuFacturingMeasures] '2014-12-08','3,8,13,16,19'
[SupplyChain].[GetManuFacturingMeasures] '2014-12-08','19,16,13,15,26,21,1,2,20,3,24,5,7,8,17,18,27'  
    
  select * from 'Supplychain.plant'  
    
*/    
CREATE PROC [SupplyChain].[GetManuFacturingMeasures](@Date as SmallDateTime, @PlantID varchar(500))    
AS    
BEGIN    
     
Declare @SupplyChainManufacutringTME Table    
 (    
  AnchorDateID int not null,    
  PlantID int not null,    
  PlantName varchar(10) not null,    
  PlantDesc varchar(50) not null,    
  SAPPlantNumber varchar(50) null,    
  Latitude varchar(100),  
  Longitude Varchar(100),  
  IsMyPlant Bit null,    
  TMEMTD decimal(21,1)  null,    
  TMEMTDPY decimal(21,1) null,  
   TMETotal decimal(5,1) null,
  TMETotalPY decimal(5,1) null,
   TMEFavUnFav decimal(10,1) null,   
   TMERank int null,  
  AFCOMTD decimal(5,1) null,    
  AFCOMTDPY decimal(5,1) null,
  AFCOTotal decimal (18,1) null,
  AFCOTotalPY decimal (18,1) null, 
   AFCOFAVUnFAV decimal(10,1) null,  
   AFCOFAVUnFAVPercent decimal(5,1) null,  
    AFCORank int null,  
  RecordableMTD int,    
  RecordableMTDPY int,    
   RecordableTotal int null,  
  RecordableTotalPY int null,
  RecordableFavUnFav decimal(10,1) null, 
  RecordableRank int null,  
  InventoryCasesMTD int,    
  InventoryCasesMTDPY int,  
  InventoryCasesTotal decimal(18,1) null,  
  InventoryCasesTotalPY decimal(18,1) null, 
  InvCasesFavUnFav int null,
  InvCasesFavUnFavPercent decimal(10,1) null,
  InventoryCasesRank int null
 )  
 
 Declare @SelectedPlantIDs Table
		(
			PlantID int
		)
Insert into @SelectedPlantIDs
Select Value from dbo.Split(@PlantID,',')  

 Declare @AnchorDate Int  
 Declare @AnchorDatePrev int  
 Set @AnchorDate = [SupplyChain].[udfConvertToDateID](@Date)  
 Set @AnchorDatePrev = [SupplyChain].[udfConvertToDateID](DATEADD(YY,-1,@Date))  
 Insert into @SupplyChainManufacutringTME(AnchorDateID,PlantID,PlantName,PlantDesc,SAPPlantNumber,Latitude,Longitude, TMEMTD, TMEMTDPY, RecordableMTD, RecordableMTDPY,InventoryCasesMTD, InventoryCasesMTDPY, IsMyPlant)  
  Select @AnchorDate, p.PlantID, PlantName,PlantDesc,SAPPlantNumber,Latitude  ,Logitude  
    ,(Select TME * 100 from SupplyChain.tPlantKPI Where AnchorDateID=@AnchorDate And AggregationID = 3 And PlantID=p.PlantID)  
    ,(Select TME * 100 from SupplyChain.tPlantKPI Where AnchorDateID=@AnchorDatePrev And AggregationID = 3 And PlantID=p.PlantID)  
   -- ,(Select AvgFlavorCODuration from SupplyChain.tPlantKPI Where AnchorDateID=@AnchorDate And AggregationID = 3 And PlantID=p.PlantID)  
    --,(Select AvgFlavorCODuration from SupplyChain.tPlantKPI Where AnchorDateID=@AnchorDatePrev And AggregationID = 3 And PlantID=p.PlantID)  
    ,(Select [RecordableMDT] from [SupplyChain].[tManufacturingMeasures_ToBeDeleted] as tmD where tmd.plantID = p.PlantID)  
    ,(Select [RecordableMDTPY] from [SupplyChain].[tManufacturingMeasures_ToBeDeleted] as tmD where tmd.plantID = p.PlantID)  
    ,(Select SUM(Isnull(EndingInventory,0))  from SAP.BP7PlantInventory Where SAPPlantNumber = p.SAPPlantNumber And CalendarDate=@AnchorDate And  EndingInventory > 0 Group by SAPPlantNumber)  
    ,(Select SUM(Isnull(EndingInventory,0)) from SAP.BP7PlantInventory Where SAPPlantNumber = p.SAPPlantNumber And CalendarDate=@AnchorDatePrev And  EndingInventory > 0 Group by SAPPlantNumber)
	,Case When myPlant.PlantID is not null Then 1 Else null end  
    from SupplyChain.Plant p  Left Outer Join @SelectedPlantIDs as myPlant on p.PlantID = myPlant.PlantID
--  
Declare @TMETotal decimal(5,3)  
Declare @TMETotalPY decimal(5,3)
Declare @AFCOTotal decimal(18,1)  
Declare @AFCOTotalPY decimal(18,1)  
Select  @TMETotal = (Select Convert(decimal(5,3), Case When SUM(isnull(SumCapacityQty,0)) > 0 And SUM(isnull(SumDuration,0)) > 0 Then SUM(isnull(SumCODuration,0))/SUM(isnull(SumDuration,0)) + SUM(isnull(SumActualQty,0))/SUM(isnull(SumCapacityQty ,0))  
    When SUM(isnull(SumCapacityQty,0)) > 0 Then SUM(isnull(SumActualQty,0))/SUM(isnull(SumCapacityQty,0))   
    When SUM(isnull(SumDuration,0)) > 0 Then SUM(isnull(SumCODuration,0))/SUM(isnull(SumDuration,0))    
    Else Null   
    End)  
 from  @SelectedPlantIDs as  myPlant   
 join SupplyChain.tPlantKPI as p on p.PlantID = myPlant.PlantID And p.AggregationID = 3 And p.AnchorDateID = @AnchorDate)  

 ----Previous Year Plant TME Total
Select  @TMETotalPY = (Select Convert(decimal(5,3), Case When SUM(isnull(SumCapacityQty,0)) > 0 And SUM(isnull(SumDuration,0)) > 0 Then SUM(isnull(SumCODuration,0))/SUM(isnull(SumDuration,0)) + SUM(isnull(SumActualQty,0))/SUM(isnull(SumCapacityQty ,0))  
    When SUM(isnull(SumCapacityQty,0)) > 0 Then SUM(isnull(SumActualQty,0))/SUM(isnull(SumCapacityQty,0))   
    When SUM(isnull(SumDuration,0)) > 0 Then SUM(isnull(SumCODuration,0))/SUM(isnull(SumDuration,0))    
    Else Null   
    End)  
 from  @SelectedPlantIDs as  myPlant   
 join SupplyChain.tPlantKPI as p on p.PlantID = myPlant.PlantID And p.AggregationID = 3 And p.AnchorDateID = @AnchorDatePrev)  
 
 --Select @TMETotal  
Declare @TotalFlavor Decimal(18,1)  
Declare @Total Decimal(18,1)

Declare @TotalFlavorPY Decimal(18,1)  
Declare @TotalPY Decimal(18,1)
Declare @TotalCOPY Decimal(9,1)
Declare @TotalCO Decimal(9,1)

Declare @LYBaseLine Table 
(
	LineID int,
	PlantDesc varchar(200),
	LineName varchar(200),
	LYWeightAverage decimal(10,7),
	LYBaseLinePercentage decimal(10,7)
)  
  
Select @TotalFlavorPY = Sum(SumFlavorCODuration), @TotalPY = Sum(SumActualQty) , @TotalCOPY = Sum(SumFlavorCODuration)
From SupplyChain.tPlantKPI pk  
Join @SelectedPlantIDs v on pk.PlantID = v.PlantID  
Where AnchorDateID = @AnchorDatePrev And AggregationID = 3  

Insert @LYBaseLine 
Select lk.LineID, p.PlantDesc, l.LineName,
	Case When @TotalFlavorPY > 0 And lk.CountFlavorCO > 0 Then 
	 lk.SumFlavorCODuration*lk.SumFlavorCODuration/lk.CountFlavorCO/@TotalFlavorPY
    Else 0 End AFCO,
	lk.SumFlavorCODuration/@TotalCOPY
From SupplyChain.tLineKPI lk  
Join SupplyChain.Line l on lk.LineID = l.LineID
Join SupplyChain.Plant p on p.PlantID = l.PlantID  
Join @SelectedPlantIDs myPlant on l.PlantID = myPlant.PlantID  
Where lk.AggregationID = 3 And lk.AnchorDateID = @AnchorDatePrev

--Select * From @LYBaseLine Order By PlantDesc, LineName

Select @AFCOTotalPY = Sum(LYWeightAverage)
From @LYBaseLine

If @AFCOTotalPY = 0 
Begin
	Select @TotalFlavor = Sum(SumFlavorCODuration), @TotalCO = Sum(SumFlavorCODuration)
	From SupplyChain.tPlantKPI pk  
	Join @SelectedPlantIDs v on pk.PlantID = v.PlantID  
	Where AnchorDateID = @AnchorDate And AggregationID = 3  

	Delete From @LYBaseLine

	Insert @LYBaseLine 
	Select lk.LineID, p.PlantDesc, l.LineName, 0 AFCO,
		lk.SumFlavorCODuration/@TotalCO
	From SupplyChain.tLineKPI lk  
	Join SupplyChain.Line l on lk.LineID = l.LineID
	Join SupplyChain.Plant p on p.PlantID = l.PlantID  
	Join @SelectedPlantIDs myPlant on l.PlantID = myPlant.PlantID  
	Where lk.AggregationID = 3 And lk.AnchorDateID = @AnchorDate
End

--Select py.PlantDesc, py.LineID, py.LineName, py.LYBaseLinePercentage, Case When CountFlavorCO = 0 Then 0 Else SumFlavorCODuration*py.LYBaseLinePercentage/CountFlavorCO End AVThisYear
--From SupplyChain.tLineKPI lk  
--Join SupplyChain.Line l on lk.LineID = l.LineID  
--Join @SelectedPlantIDs myPlant on l.PlantID = myPlant.PlantID
--Join @LYBaseLine py on py.LineID = lk.LineID
--Where lk.AggregationID = 3 And lk.AnchorDateID = @AnchorDate  
 
Select @AFCOTotal =  ( 
Select Sum(AFCO)
From  
	(   
		Select lk.LineID,   
			Case When CountFlavorCO = 0 Then 0 Else SumFlavorCODuration*py.LYBaseLinePercentage/CountFlavorCO End AFCO  
		From SupplyChain.tLineKPI lk  
		Join SupplyChain.Line l on lk.LineID = l.LineID  
		Join @SelectedPlantIDs myPlant on l.PlantID = myPlant.PlantID
		Join @LYBaseLine py on py.LineID = lk.LineID
		Where lk.AggregationID = 3 And lk.AnchorDateID = @AnchorDate  
	) temp
)

------------------------------------------AFCO Wieghted Average Start-----------------------------------------------------

Declare @Output Table
(
	PlantID int,
	PlantName varchar(128),
	LineName varchar(128),
	LineID int,
	TimePeroidDisplay varchar(128),
	TimePeriodSortOrder int,
	YearName varchar(128),
	YearSortOrder int,
	SumFlavorCODuration Decimal(18, 8), 
	CountFlavorCO int,
	SumDuration Decimal(18, 8)
)

----------------- This year place holder -------------------------
Insert Into @Output(PlantID, PlantName, LineName, LineID, TimePeriodSortOrder, TimePeroidDisplay, YearSortOrder, YearName, 
		 CountFlavorCO, SumFlavorCODuration, SumDuration)
Select temp.PlantID, temp.PlantName, temp.LineName, temp.LineID,
ta.SortOrder TimePeriodSortOrder, 
Case When ta.Name = 'Today' Then 'Yesterday (' + Substring(DateName(Month, SupplyChain.udfConvertToDate(@AnchorDate)), 1, 3) + ' ' + Convert(varchar, Day(SupplyChain.udfConvertToDate(@AnchorDate))) + ')' 
--Case When ta.Name = 'Today' Then 'Yesterday (' + Substring(DateName(WeekDay, SupplyChain.udfConvertToDate(@AnchorDate)), 1, 3) + ', ' + Substring(DateName(Month, SupplyChain.udfConvertToDate(@AnchorDate)), 1, 3) + ' ' + Convert(varchar, Day(SupplyChain.udfConvertToDate(@AnchorDate))) + ')' 
--Case When ta.Name = 'Today' Then 'Yesterday (' + Convert(varchar(5), SupplyChain.udfConvertToDate(@AnchorDate), 110) + ')' 
When ta.Name = 'MTD' Then 'MTD (Last ' + convert(varchar(3), @AnchorDate%100) + ' Days)'
When ta.Name = 'MTD' Then DATENAME(month, SupplyChain.udfConvertToDate(@AnchorDate)) + '(Last ' + convert(varchar(3), @AnchorDate%100) + ' Days)'
When ta.Name = 'YTD' Then 'YTD (Last ' + convert(varchar, datepart(dayofyear,SupplyChain.udfConvertToDate(@AnchorDate))) + ' Days)'
When ta.Name = 'YTD' Then DATENAME(year, SupplyChain.udfConvertToDate(@AnchorDate)) + '(Last ' + convert(varchar, datepart(dayofyear,SupplyChain.udfConvertToDate(@AnchorDate))) + ' Days)'
Else ta.Name End TimePeroidDisplay,
1 YearSortOrder, 'This Year', 0,0,0
From SupplyChain.TimeAggregation ta
Cross Join 
(Select l.LineID, LineName, p.PlantID, PlantDesc PlantName
From SupplyChain.Line l
Join SupplyChain.LineType lt on l.LineTypeID = lt.LineTypeID
Join SupplyChain.Plant p on l.PlantID = p.PlantID) Temp
Where PlantID in 
(
	Select PlantID From SupplyChain.Plant Where Logitude is not null And Latitude is not null 
)
And ta.Active = 1 And ta.AggregationID = 3

----------------- Last year place holder -------------------------
Insert Into @Output(PlantID, PlantName, LineName, LineID, TimePeriodSortOrder, TimePeroidDisplay, YearSortOrder, YearName, 
		 CountFlavorCO, SumFlavorCODuration, SumDuration)
Select temp.PlantID, temp.PlantName, temp.LineName, temp.LineID,
ta.SortOrder TimePeriodSortOrder, 
Case When ta.Name = 'Today' Then 'Yesterday(' + Convert(varchar(5), SupplyChain.udfConvertToDate(@AnchorDate), 110) + ')' Else ta.Name End TimePeroidDisplay,
2 YearSortOrder, 'Last Year', 0,0,0
From SupplyChain.TimeAggregation ta
Cross Join 
(Select l.LineID, LineName, p.PlantID, PlantDesc PlantName
From SupplyChain.Line l
Join SupplyChain.LineType lt on l.LineTypeID = lt.LineTypeID
Join SupplyChain.Plant p on l.PlantID = p.PlantID) Temp
Where PlantID in
(
	Select PlantID From SupplyChain.Plant Where Logitude is not null And Latitude is not null 
)
And ta.Active = 1

Update op Set
	CountFlavorCO = fact.CountFlavorCO, 
	SumFlavorCODuration = fact.SumFlavorCODuration,
	SumDuration = fact.SumActualQty
From @Output op
Left Join 
(
	Select LIneID, LineName + ' - ' + LineTypeName As LineName, 
	Case When TimePeroid = 'Today' Then Convert(varchar, SupplyChain.udfConvertToDate(@AnchorDate))  Else TimePeroid End TimePeroidDisplay,
	v.SortOrder TimePeriodSortOrder, 'This Year' YearName, 1 YearSortOrder, SumActualQty, SumCapacityQty, SumPlanQty, SumDuration, SumCODuration, CountFlavorCO, SumFlavorCODuration
	From SupplyChain.vPTKPIs v
	Where PlantID in
	(
		Select PlantID From SupplyChain.Plant Where Logitude is not null And Latitude is not null 
	)
	And DateID = @AnchorDate
	Union All
	Select LIneID, LineName + ' - ' + LineTypeName As LineName, 
	Case When TimePeroid = 'Today' Then Convert(varchar, SupplyChain.udfConvertToDate(@AnchorDate))  Else TimePeroid End TimePeroidDisplay,
	v.SortOrder TimePeriodSortOrder, 'Last Year' YearName, 2 YearSortOrder, SumActualQty, SumCapacityQty, SumPlanQty, SumDuration, SumCODuration, CountFlavorCO, SumFlavorCODuration
	From SupplyChain.vPTKPIs v
	Where PlantID in
	(
		Select PlantID From SupplyChain.Plant Where Logitude is not null And Latitude is not null 
	)
	And DateID = @AnchorDate % 10000 + ((@AnchorDate / 10000) - 1) * 10000
) fact 
On op.LineID = fact.LineID And op.YearSortOrder = fact.YearSortOrder And op.TimePeriodSortOrder = fact.TimePeriodSortOrder

------------------------------------
--- Remove the inactive line, that is defined as no year to date actual capacity ---
Delete 
From @Output
Where LineName in (
Select LineName
From @Output
Where YearSortOrder = 1 And TimePeriodSortOrder = 4
And Isnull(SumDuration, 0) = 0)

------ Remove the Year Grouping and instead create addtional columns -------------
------------------------------------
Declare @Out2 Table
(
	PlantID int,
	PlantName varchar(200),
	LineID int,
	LineName varchar(200),
	TimePeroidDisplay varchar(100),
	TimePeriodSortOrder int,
	CountFlavorCO int,
	SumFlavorCODuration decimal(10,1),
	LYCountFlavorCO int,
	LYSumFlavorCODuration decimal(10, 1),
	SumDuration decimal(10, 1),
	LYSumDuration decimal(10, 1),
	LineWeight Decimal(5,4),
	LYLineWeight Decimal(5,4),
	TYLineWeight Decimal(5,4),
	AVCO decimal(10,4),
	LYAVCO decimal(10,4),
	WeightedAVCO decimal(10,4),
	WeightedLYAVCO decimal(10,4)
)

Insert @Out2
Select TY.PlantID, TY.PlantName, TY.LineID, TY.LineName,
	TY.TimePeroidDisplay,
	TY.TimePeriodSortOrder,
	isnull(TY.CountFlavorCO, 0) CountFlavorCO, 
	isnull(TY.SumFlavorCODuration, 0) SumFlavorCODuration,
	isnull(LY.LYCountFlavorCO, 0) LYCountFlavorCO, 
	isnull(LY.LYSumFlavorCODuration, 0) LYSumFlavorCODuration, 
	Isnull(TY.SumDuration,0) SumDuration,
	Isnull(LY.LYSumDuration, 0) LYSumDuration
	, 0 LineWeight, 0, 0, 0, 0, 0, 0
From (
Select PlantID, PlantName, LineID, LineName,
	TimePeroidDisplay,
	TimePeriodSortOrder,
	YearName,
	YearSortOrder,
	CountFlavorCO, 
	SumFlavorCODuration,
	SumDuration
From @Output
Where YearSortOrder = 1) TY
Left Join
(
Select PlantID, PlantName, LineID, LineName,
	TimePeroidDisplay,
	TimePeriodSortOrder,
	YearName,
	YearSortOrder,
	CountFlavorCO LYCountFlavorCO, 
	SumFlavorCODuration LYSumFlavorCODuration,
	SumDuration LYSumDuration
From @Output
Where YearSortOrder = 2
) LY On TY.PlantName = LY.PlantName And TY.LineName = LY.LineName And TY.TimePeriodSortOrder = LY.TimePeriodSortOrder
Order By TY.PlantName, LineName, TimePeriodSortOrder

Declare @PlantSum Table
(
	PlantID int,
	TimePeriodSortOrder int,
	FCODuration decimal(10,1),
	LYFCODuration decimal(10,1)
)
Insert @PlantSum
Select PlantID, TimePeriodSortOrder, Sum(SumFlavorCODuration), Sum(LYSumFlavorCODuration)
From @Out2
Group By PlantID, TimePeriodSortOrder

Update o2
Set LineWeight = Case When LYFCODuration = 0 And FCODuration = 0 Then 0 
					  When LYFCODuration = 0 Then SumFlavorCODuration/FCODuration
					  Else LYSumFlavorCODuration/LYFCODuration
					  End,
	LYLineWeight = Case When LYFCODuration > 0 Then LYSumFlavorCODuration/LYFCODuration
					  Else 0
					  End,
	TYLineWeight = Case When FCODuration > 0 Then SumFlavorCODuration/FCODuration
					  Else 0
					  End,
	AVCO = Case When CountFlavorCO = 0 Then 0
				Else SumFlavorCODuration/CountFlavorCO End,
	LYAVCO = Case When LYCountFlavorCO = 0 Then 0
				Else LYSumFlavorCODuration/LYCountFlavorCO End
From @Out2 o2
Join @PlantSum s on o2.PlantID = s.PlantID And o2.TimePeriodSortOrder = s.TimePeriodSortOrder

Update @Out2
Set WeightedAVCO = Case When TYLineWeight = 0 Then 0
		Else AVCO*LineWeight/TYLineWeight End,
	WeightedLYAVCO = LYAVCO
From @Out2 o2

----Now Update the Plant Level Data
Update t1
Set AFCOMTD = t2.AFCO, AFCOMTDPY = t2.AFCOPY
from @SupplyChainManufacutringTME as t1 Join (Select PlantID, SUM(AVCO*LineWeight) as AFCO, SUM(LYAVCO*LineWeight) as AFCOPY From @Out2 as t
Group By PlantID) as t2 on t1.PlantID = t2.PlantID 

------------------------------------------AFCO Wieghted Average Complete-----------------------------------------------------
   
  
Update m  
Set TMETotal = @TMETotal * 100  
	,TMETotalPY = @TMETotalPY * 100
	,AFCOTotal = @AFCOTotal
	,AFCOTotalPY = @AFCOTotalPY  
	,InventoryCasesTotal = (Select SUM(Isnull(EndingInventory,0)/1000) from SAP.BP7PlantInventory Where SAPPlantNumber in (Select SAPPlantNumber from SupplyChain.Plant Where PlantID in (Select PlantID from @SelectedPlantIDs)) And CalendarDate=@AnchorDate)
	,InventoryCasesTotalPY = (Select SUM(Isnull(EndingInventory,0)/1000) from SAP.BP7PlantInventory Where SAPPlantNumber in (Select SAPPlantNumber from SupplyChain.Plant Where PlantID in (Select PlantID from @SelectedPlantIDs)) And CalendarDate=@AnchorDatePrev)  
	,RecordableTotal = (Select SUM(RecordableMDT) from [SupplyChain].[tManufacturingMeasures_ToBeDeleted] Where PlantID in (Select PlantID from @SelectedPlantIDs))  
	,RecordableTotalPY = (Select SUM(RecordableMDT) from [SupplyChain].[tManufacturingMeasures_ToBeDeleted] Where PlantID in (Select PlantID from @SelectedPlantIDs))  
	,TMEFavUnFav = (TMEMTD-TMEMTDPY)  
	,AFCOFAVUnFAVPercent = (CONVERT(DECIMAL(9,2),((AFCOMTD - AFCOMTDPY)/nullif(AFCOMTDPY,0)) * 100))  
	,AFCOFAVUnFAV = (CONVERT(DECIMAL(9,2),((AFCOMTD - AFCOMTDPY))))
	,RecordableFavUnFav=(RecordableMTD - RecordableMTDPY)  
	,InvCasesFavUnFav=(InventoryCasesMTD - InventoryCasesMTDPY)
,InvCasesFavUnFavPercent=(((InventoryCasesMTD - InventoryCasesMTDPY)*1.0/nullif(InventoryCasesMTDPY,0))* 100)
from @SupplyChainManufacutringTME as m  
  
 -- ,  
 --AFCORank = temp.AFCORank,  
 --RecordableRank = temp.RecordableRank,  
 --InventoryCasesRank = temp.InvCaseRank, 
--TME Rank
Update m  
set TMERank=temp.TMERank
from @SupplyChainManufacutringTME as m Inner Join   
(Select myPlant.PlantID, Rank() Over (ORDER BY  TMEFavUnFav Desc) as  TMERank
 --Rank() Over (ORDER BY InvCasesFavUnFav Asc) as InvCaseRank  
from @SupplyChainManufacutringTME as m inner join @SelectedPlantIDs myPlant on m.PlantID = myPlant.PlantID  
Where Longitude is not null And Latitude is not null And TMEFavUnFav is not null)temp on m.PlantID = temp.PlantID  

--AFCO Rank
Update m  
Set AFCORank = temp.AFCORank
from @SupplyChainManufacutringTME as m Inner Join   
(Select myPlant.PlantID, Rank() Over (ORDER BY  AFCOFAVUnFAVPercent Asc) as  AFCORank
 --Rank() Over (ORDER BY InvCasesFavUnFav Asc) as InvCaseRank  
from @SupplyChainManufacutringTME as m inner join @SelectedPlantIDs myPlant on m.PlantID = myPlant.PlantID  
Where Longitude is not null And Latitude is not null And AFCOFAVUnFAVPercent is not null)temp on m.PlantID = temp.PlantID
  
--Recordables Rank
Update m  
Set RecordableRank = temp.RecordableRank
from @SupplyChainManufacutringTME as m Inner Join   
(Select myPlant.PlantID, Rank() Over (ORDER BY RecordableFavUnFav Asc) as RecordableRank
 --Rank() Over (ORDER BY InvCasesFavUnFav Asc) as InvCaseRank  
from @SupplyChainManufacutringTME as m inner join @SelectedPlantIDs myPlant on m.PlantID = myPlant.PlantID  
Where Longitude is not null And Latitude is not null And RecordableFavUnFav is not null)temp on m.PlantID = temp.PlantID


--Inventory Rank
Update m  
Set InventoryCasesRank = temp.InventoryCasesRank
from @SupplyChainManufacutringTME as m Inner Join   
(Select myPlant.PlantID, Rank() Over (ORDER BY InvCasesFavUnFavPercent Asc) as  InventoryCasesRank
from @SupplyChainManufacutringTME as m inner join @SelectedPlantIDs myPlant on m.PlantID = myPlant.PlantID  
Where Longitude is not null And Latitude is not null And InvCasesFavUnFav is not null)temp on m.PlantID = temp.PlantID

---My Plants
Select *
--, 1 [HardValue_TMEPlan],1 [HardValue_TMEFU],1 [HardValue_2012],1 [HardValue_PacevsPY],
--  1 [HardValue_AFCOThreshold],1  [HardValue_AFCOFU],1  [HardValue_InvCasesYesterday],
--  1 [HardValue_InvCasesAvCM],1  [HardValue_InvCaseAvCY],1  [HardValue_InvCasePYsameMonth]
From @SupplyChainManufacutringTME Where Longitude is not null And Latitude is not null 
--And PlantID in (17,18,19,20,21)
     
END    
  

GO
/****** Object:  StoredProcedure [SupplyChain].[GetProductLineWithTradeMark]    Script Date: 12/12/2014 5:43:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [SupplyChain].[GetProductLineWithTradeMark]    
      
AS        
BEGIN     
                                                            
SET NOCOUNT ON;                  
   --SET @query = ' where BranchID IN ('+@BranchIds+') ORDER BY 1'    
     --SELECT Distinct ProductLineID,ProductLineName,TradeMarkID,SAPTradeMarkID,TradeMarkName    
     --          FROM [MView].[BranchProductLine] Order by ProductLineID              
	 Select pl.ProductLineID, pl.ProductLineName,t.TradeMarkID, t.SAPTradeMarkID,t.TradeMarkName from SAP.TradeMark as t inner join SAP.ProductLine as pl on t.ProductLineID = pl.ProductLineID Order by ProductLineID, TradeMarkName
   --EXECUTE sp_executesql @query                 
END 



GO
/****** Object:  StoredProcedure [SupplyChain].[pGetCalFilteredPromotionId]    Script Date: 12/12/2014 5:43:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [SupplyChain].[pGetCalFilteredPromotionId] @Brand VARCHAR(50) = NULL
	,@Package VARCHAR(50) = NULL
	,@Account VARCHAR(50) = NULL
	,@Channel VARCHAR(50) = NULL
	,@Bottler VARCHAR(50) = NULL
AS
DECLARE @flag INT

SET @flag = 0

SELECT 0 flag
	,- 1 Promotionid
INTO #FilterPromotionID

IF @Channel = 'My Channel'
	OR @Channel = 'All Channel'
	SET @Channel = ''

IF @Account = 'My Account'
	OR @Account = 'All Account'
	SET @Account = ''

IF (isnull(@Brand, '') <> '')
BEGIN
	INSERT INTO #FilterPromotionID
	SELECT 1
		,promotionid
	FROM playbook.promotionbrand
	WHERE brandid IN (
			SELECT brandid
			FROM sap.brand
			WHERE brandname IN (
					SELECT value
					FROM [CDE].[udfSplit](@Brand, ',')
					)
			)
	
	UNION
	
	SELECT 1
		,promotionid
	FROM playbook.promotionbrand
	WHERE trademarkid IN (
			SELECT trademarkid
			FROM sap.trademark
			WHERE TradeMarkName IN (
					SELECT value
					FROM [CDE].[udfSplit](@Brand, ',')
					)
			)

	SET @flag = 1
END

IF (isnull(@Package, '') <> '')
BEGIN
	INSERT INTO #FilterPromotionID
	SELECT 1
		,promotionid
	FROM playbook.promotionpackage
	WHERE packageid IN (
			SELECT packageid
			FROM sap.package
			WHERE packagename IN (
					SELECT value
					FROM [CDE].[udfSplit](@Package, ',')
					)
			)

	SET @flag = @flag + 1
END

IF (isnull(@Account, '') <> '')
BEGIN
	INSERT INTO #FilterPromotionID
	SELECT 1
		,promotionid
	FROM playbook.promotionaccount
	WHERE localchainid IN (
			SELECT localchainid
			FROM sap.localchain
			WHERE localchainname IN (
					SELECT value
					FROM [CDE].[udfSplit](@Account, ',')
					)
			)
	
	UNION
	
	SELECT 1
		,promotionid
	FROM playbook.promotionaccount
	WHERE regionalchainid IN (
			SELECT regionalchainid
			FROM sap.regionalchain
			WHERE regionalchainname IN (
					SELECT value
					FROM [CDE].[udfSplit](@Account, ',')
					)
			)
	
	UNION
	
	SELECT 1
		,promotionid
	FROM playbook.promotionaccount
	WHERE nationalchainid IN (
			SELECT nationalchainid
			FROM sap.nationalchain
			WHERE nationalchainname IN (
					SELECT value
					FROM [CDE].[udfSplit](@Account, ',')
					)
			)

	SET @flag = @flag + 1
END

IF (isnull(@Channel, '') <> '')
BEGIN
	INSERT INTO #FilterPromotionID
	SELECT 1
		,promotionid
	FROM playbook.promotionchannel
	WHERE channelid IN (
			SELECT channelid
			FROM sap.channel
			WHERE ChannelName IN (
					SELECT value
					FROM [CDE].[udfSplit](@Channel, ',')
					)
			)
	
	UNION
	
	SELECT 1
		,promotionid
	FROM playbook.promotionchannel
	WHERE superchannelid IN (
			SELECT SuperChannelID
			FROM sap.SuperChannel
			WHERE SuperChannelName IN (
					SELECT value
					FROM [CDE].[udfSplit](@Channel, ',')
					)
			)

	SET @flag = @flag + 1
END

IF (isnull(@Bottler, '') <> '')
BEGIN
	DECLARE @BottlerID INT

	SELECT @BottlerID = bottlerid
	FROM bc.bottler
	WHERE bottlername = @Bottler

	SELECT *
	INTO #BottlerChain
	FROM bc.tBottlerChainTradeMark
	WHERE bottlerid = @BottlerID

	INSERT INTO #FilterPromotionID
	SELECT DISTINCT 1
		,a.promotionid
	FROM Playbook.RetailPromotion a
	LEFT JOIN Playbook.PromotionAccountHier b ON a.promotionid = b.promotionid
	LEFT JOIN Playbook.promotiongeohier c ON c.promotionid = a.promotionid
	LEFT JOIN playbook.PromotionBrand d ON d.promotionid = a.promotionid
	LEFT JOIN sap.brand brnd ON brnd.BrandID = d.BrandID --JOIN #BottlerChain tc ON tc.bottlerid = c.bottlerid    
	--AND tc.trademarkid = case when isnull(d.trademarkid,0) = 0  then brnd.Trademarkid else d.trademarkid end    
	--AND tc.localchainid = b.localchainid    
	WHERE c.BottlerID = @BottlerID

	SET @flag = @flag + 1
END --select * from #FilterPromotionID    

DECLARE @retval VARCHAR(MAX)

SET @retval = (
		SELECT DISTINCT Convert(VARCHAR(20), Promotionid) + ','
		FROM #FilterPromotionID
		WHERE promotionid <> - 1
		GROUP BY promotionid
		HAVING sum(flag) = @flag
		FOR XML path('')
		)

SELECT @retval

GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdInventoryBranchMeasuresForLanding]    Script Date: 12/12/2014 5:43:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/* Test Bench
exec [SupplyChain].[pGetDsdInventoryBranchMeasuresForLanding] 20141014,'118,8,11,12,13,14,15,18,19,21,25,29,33,35,36,37,42,44,47,48,50,52,53,54,58','69,192,138,29,232,221,75,158,195,3,12,35,129,49,190,184,64,101', '46,69,138,152,118,78,129,86,64,44,150,47,70,30,124,133,61,36','MinMax'
exec [SupplyChain].[pGetDsdInventoryBranchMeasuresForLanding] 20141106,'1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,167,168,169,170,172,173,174', '1,3,5,20,22,33,59,35,37,60,44,61,46,49,50,51,65,67,68,34,64,89,173,54,97,129,130,154,187,216,228','22,27,30,33,38,39,44,46,47,51,59,62,63,64,67,68,77,78,79,86,90,94,108,117,124,129,133,134,138,139,140,143,145,146,150,151,152,154','DOS'

	24.SupplyChain.pGetDsdInventoryBranchMeasuresForLanding.sql

*/

CREATE Proc [SupplyChain].[pGetDsdInventoryBranchMeasuresForLanding]
(
	@DateID int,
	@BranchIDs varchar(4000),
	@TrademarkIDs varchar(4000),
	@PackageTypeIDs varchar(4000),
	@MeasureType varchar(10),
	@AggregationID int = 0
)
AS	
	Set NoCount On;
	
	Declare @SupplyChainDsdInventoryMeasuresByBranch Table  
			 (  
			   BranchID int not null
			  ,BranchName varchar(50) not null
			  ,Longitude varchar(20) null
			  ,Latitude varchar(20) null
			  ,CaseCut int  null
			  ,OOS Decimal(10,1) null
			  ,OOSDiff Decimal(10,1) null
			  ,DaysOfSupply Decimal(10,1) null
			  ,DaysOfSupplyDiff Decimal(10,1) null
			  ,DaysOfSupplyEndingInventory Decimal(10,1) null
			  ,MinMaxMiddle Decimal(10,1) null
			  ,MinMaxMiddleDiff Decimal(10,2) null
			  ,MinMaxLeftAbs int null
			  ,MinMaxMiddleAbs int null
			  ,MinMaxRightAbs int null
			  ,OOSRed Decimal(10,1) null
			  ,OOSGreen Decimal(10,1) null
			  ,DOSRed Decimal(10,1) null
			  ,DOSGreen Decimal(10,1) null
			  ,MinMaxRed Decimal(10,1) null
			  ,MinMaxGreen Decimal(10,1) null
			  ,KPILevel varchar(10) null
			 )

Declare @SelectedBranchIDs Table
		(
			BranchID int
		)

Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)

Declare @SelectedPackageTypeIDs Table
		(
			PackageTypeID int
		)

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')

Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')


Insert into @SelectedPackageTypeIDs
Select Value from dbo.Split(@PackageTypeIDs,',')

	Insert into @SupplyChainDsdInventoryMeasuresByBranch (BranchID,BranchName, Longitude, Latitude, OOSRed, OOSGreen, DOSRed, DOSGreen, MinMaxRed, MinMaxGreen) 
			Select b.BranchID, b.BranchName, b.Longitude, b.Latitude, bt.BranchOOSLeftThreshold, bt.BranchOOSRightThreshold, bt.BranchDOSLeftThreshold, bt.BranchDOSRightThreshold, bt.BranchMinMaxLeftThreshold, bt.BranchMinMaxRightThreshold
			from SAP.Branch as b 
			Inner Join SupplyChain.vBranchThreshold as bt on b.BranchID = bt.BranchID 
			Where bt.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)

	If(@MeasureType = 'OOS') 
		Begin
			Update mb
			Set mb.OOS = OOSTemp.OOS,
			mb.CaseCut = OOSTemp.CaseCut,
			mb.OOSDiff = (OOSTemp.OOS - mb.OOSGreen),  --- This will negative values for the Green Branches. So we can ignore if the difference is less than 0
			mb.KPILevel = Case 
							When OOSTemp.OOS > mb.OOSRed Then 'Red' 
							When (OOSTemp.OOS >= mb.OOSGreen And OOSTemp.OOS <= mb.OOSRed) Then 'Amber' 
							When OOSTemp.OOS < mb.OOSGreen Then 'Green' End
			from @SupplyChainDsdInventoryMeasuresByBranch as mb
			 Inner Join (Select BranchID
								,((SUM(oos.CaseCut) * 1.0)/NUllIF(sum(Isnull(oos.Quantity, 0)),0)) * 100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut 
						 from SupplyChain.tDsdDailyCaseCut as OOS
							Where  OOS.DateID = @DateID 
							And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
							And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		
							Group By OOS.BranchID) as OOSTemp on mb.BranchID= OOSTemp.BranchID
			 Select top 5 *, Rank() Over (ORDER BY mb.OOSDiff Desc) as MeasureRank  from @SupplyChainDsdInventoryMeasuresByBranch as mb where mb.CaseCut is not null And mb.OOSDiff > 0 order by OOSDiff Desc
		End
	Else If(@MeasureType = 'DOS') 
		Begin
			Update mb
				Set mb.DaysOfSupply = DOSTemp.DaysOfSupply,
					mb.DaysOfSupplyDiff = (DOSTemp.DaysOfSupply - mb.DOSGreen),  --- This will negative values for the Green Branches. So we can ignore if the difference is less than 0
					mb.DaysOfSupplyEndingInventory = DOSTemp.DaysOfSupplyEndingInventory,
					mb.KPILevel = Case 
								When DOSTemp.DaysOfSupply > mb.DOSRed Then 'Red' 
								When (DOSTemp.DaysOfSupply >= mb.DOSGreen And DOSTemp.DaysOfSupply <= mb.DOSRed) Then 'Amber' 
								When DOSTemp.DaysOfSupply < mb.DOSGreen Then 'Green' End
			from @SupplyChainDsdInventoryMeasuresByBranch as mb
			Inner Join (Select BranchID
							   ,  ((SUM(dos.EndingInventory)*1.0)/NullIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 30  as DaysOfSupply
							   , ((SUM(dos.EndingInventory)*1.0)/1000) as DaysOfSupplyEndingInventory
						 from SupplyChain.tDsdDailyBranchInventory as DOS 
						 Where DOS.DateID = @DateID 
								And dos.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
								And dos.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
								And dos.PackageTypeID in (Select PackageTypeID from @SelectedPackageTypeIDs)
								Group By BranchID) as DOSTemp on mb.BranchID=DOSTemp.BranchID
			Select  top 5 *, Rank() Over (ORDER BY mb.DaysOfSupplyDiff Desc) as MeasureRank  from @SupplyChainDsdInventoryMeasuresByBranch as mb where mb.DaysOfSupply > 0 And  mb.DaysOfSupplyDiff > 0 order by mb.DaysOfSupplyDiff Desc
		End
	Else If(@MeasureType = 'MinMax')
		Begin
			Update mb
			Set 
				mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle,
				mb.MinMaxMiddleDiff = (mb.MinMAxGreen - minmaxTemp.MinMaxMiddle),--- This will negative values for the Green Branches. So we can ignore if the difference is less than 0
				mb.MinMaxLeftAbs = minmaxtemp.MinMaxLeftAbs,
				mb.MinMaxMiddleAbs = minmaxtemp.MinMaxMiddleAbs,
				mb.MinMaxRightAbs = minmaxtemp.MinMaxRightAbs,
				mb.KPILevel = Case 
							When minmaxTemp.MinMaxMiddle < mb.MinMaxRed Then 'Red' 
							When (minmaxTemp.MinMaxMiddle >= mb.MinMaxRed And minmaxTemp.MinMaxMiddle <= mb.MinMaxGreen) Then 'Amber' 
							When minmaxTemp.MinMaxMiddle > mb.MinMaxGreen Then 'Green' End
				
			from @SupplyChainDsdInventoryMeasuresByBranch as mb
			Inner Join (Select BranchID
								,(SUm(IsCompliant) * 1.0 )/ SUM(IsBelowMin + IsCompliant + IsAboveMax)*100 as MinMaxMiddle
								,SUM(IsBelowMin) as MinMaxLeftAbs
								,SUM(IsCompliant) as MinMaxMiddleAbs
								,SUM(IsAboveMax) as MinMaxRightAbs
								from SupplyChain.tDsdDailyMinMax as minmax
								Where minmax.DateID = @DateID 
								And minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
								And minmax.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)			
								And minmax.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)	
								Group By BranchID) as minmaxTemp on mb.BranchId = minmaxTemp.BranchId
			Select  top 5 *, Rank() Over (ORDER BY MinMaxMiddleDiff) as MeasureRank  from @SupplyChainDsdInventoryMeasuresByBranch as mb where mb.MinMaxMiddle <> mb.MinMAxGreen And mb.MinMaxMiddleDiff > 0 order by mb.MinMaxMiddleDiff
		  End




GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdInventoryMeasuresByBranch]    Script Date: 12/12/2014 5:43:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
/* Test Bench  
exec [SupplyChain].[pGetDsdInventoryMeasuresByBranch] 20141014,'8,11,12,13,14,15,18,19,21,25,29,33,35,36,37,42,44,47,48,50,52,53,54,58','69,192,138,29,232,221,75,158,195,3,12,35,129,49,190,184,64,101', '46,69,138,152,118,78,129,86,64,44,150,47,70,30,124,1', 'MinMax'
33,61,36'  
  
   
  
*/  
  
CREATE Proc [SupplyChain].[pGetDsdInventoryMeasuresByBranch]  
(  
 @DateID int,  
 @BranchIDs varchar(4000),  
 @TrademarkIDs varchar(4000),  
 @PackageTypeIDs varchar(4000),
 @MeasureType varchar(20)  ,
 @AggregationID int = 0  
)  
AS   
 Set NoCount On;  
   
 Declare @SupplyChainDsdInventoryMeasuresByBranch Table    
    (    
     BranchID int not null  
     ,BranchName varchar(50) not null  
     ,Longitude Decimal(10,6) null  
     ,Latitude Decimal(10,6) null  
     ,CaseCut int  null  
     ,OOS Decimal(10,1) null
	 ,OOSDiff Decimal(10,1) null 
     ,DaysOfSupply Decimal(10,1) null  
     ,DaysOfSupplyInventory Decimal(10,1) null  
     ,DaysOfSupplyDiff Decimal(10,1) null  
	 ,MinMaxLeft Decimal(10,1) null  
     ,MinMaxMiddle Decimal(10,1) null  
     ,MinMaxRight Decimal(10,1) null
	 ,MinMaxMiddleDiff Decimal(10,1) null    
      ,MinMaxLeftAbs int null  
     ,MinMaxMiddleAbs int null  
     ,MinMaxRightAbs int null  
     ,OOSRed Decimal(10,1) null  
     ,OOSGreen Decimal(10,1) null  
     ,DOSRed Decimal(10,1) null  
     ,DOSGreen Decimal(10,1) null  
     ,MinMaxRed Decimal(10,1) null  
     ,MinMAxGreen Decimal(10,1) null  
     --,OOSRank int null  
     --,DOSRank int null  
     --,MinMaxRank int null  
    )  
  
Declare @SelectedBranchIDs Table  
  (  
   BranchID int  
  )  
  
Declare @SelectedTradeMarkIDs Table  
  (  
   TradeMarkID int  
  )  
  
Declare @SelectedPackageTypeIDs Table  
  (  
   PackageTypeID int  
  )  
  
Insert into @SelectedBranchIDs  
Select Value from dbo.Split(@BranchIDs,',')  
  
Insert into @SelectedTradeMarkIDs  
Select Value from dbo.Split(@TrademarkIDs,',')  
  
  
Insert into @SelectedPackageTypeIDs  
Select Value from dbo.Split(@PackageTypeIDs,',')  
  
 Insert into @SupplyChainDsdInventoryMeasuresByBranch (BranchID,BranchName, Longitude, Latitude, OOSRed, OOSGreen, DOSRed, DOSGreen, MinMaxRed, MinMaxGreen)   
   Select b.BranchID, b.BranchName, b.Longitude, b.Latitude, bt.BranchOOSLeftThreshold, bt.BranchOOSRightThreshold, bt.BranchDOSLeftThreshold, bt.BranchDOSRightThreshold, bt.BranchMinMaxLeftThreshold, bt.BranchMinMaxRightThreshold  
   from SAP.Branch as b   
   Inner Join SupplyChain.vBranchThreshold as bt on b.BranchID = bt.BranchID   
   Where bt.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)  
  
 If(@MeasureType = 'OOS')
	Begin
		Update mb  
		  Set mb.OOS = OOSTemp.OOS,  
		  mb.CaseCut = OOSTemp.CaseCut,
		  	mb.OOSDiff = (OOSTemp.OOS - mb.OOSGreen)  --- This will negative values for the Green Branches. So we can ignore if the difference is less than 0  
		  from @SupplyChainDsdInventoryMeasuresByBranch as mb  
		   Inner Join (Select BranchID,((SUM(oos.CaseCut) * 1.0)/NUllIF(sum(Isnull(oos.Quantity, 0)),0))*100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from     
			  SupplyChain.tDsdDailyCaseCut as OOS  
			  Where  OOS.DateID = @DateID   
			  And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)  
			  And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)   
			  And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)    
			  Group By OOS.BranchID) as OOSTemp on mb.BranchID= OOSTemp.BranchID
		Select b.*, tRanking.MeasureRank as 'MeasureRank'
				from @SupplyChainDsdInventoryMeasuresByBranch as b Left Outer Join
					 (Select top 5 *, Rank() Over (ORDER BY mb.OOSDiff Desc) as MeasureRank  
							from @SupplyChainDsdInventoryMeasuresByBranch as mb 
							where mb.CaseCut is not null And mb.OOSDiff > 0 order by OOSDiff Desc) as tRanking on b.BranchID = tRanking.BranchID
	End  
 Else If (@MeasureType = 'DOS')
	Begin
		Update mb  
		  Set mb.DaysOfSupply = DOSTemp.DaysOfSupply,
		  mb.DaysOfSupplyDiff = (DOSTemp.DaysOfSupply - mb.DOSGreen),  --- This will negative values for the Green Branches. So we can ignore if the difference is less than 0  
		   mb.DaysOfSupplyInventory = DOSTemp.DaysOfSupplyInventory  
		  from @SupplyChainDsdInventoryMeasuresByBranch as mb  
		  Inner Join (Select BranchID  
							 , Case When sum(dos.Past31DaysXferOutPlusShipment) = 0  Then 0 else ((SUM(dos.EndingInventory)*1.0)/NullIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 30 End as DaysOfSupply  
							 ,(SUM(dos.EndingInventory)*1.0)/1000 as DaysOfSupplyInventory  
						  from SupplyChain.tDsdDailyBranchInventory as DOS   
						  Where DOS.DateID = @DateID   
						   And dos.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)  
						   And dos.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)   
						   And dos.PackageTypeID in (Select PackageTypeID from @SelectedPackageTypeIDs)  
						   Group By BranchID) as DOSTemp on mb.BranchID=DOSTemp.BranchID
		Select b.*, tRanking.MeasureRank as 'MeasureRank'
				from @SupplyChainDsdInventoryMeasuresByBranch as b Left Outer Join
					 (Select  top 5 *, Rank() Over (ORDER BY mb.DaysOfSupplyDiff Desc) as MeasureRank  
								from @SupplyChainDsdInventoryMeasuresByBranch as mb where mb.DaysOfSupply > 0 And  mb.DaysOfSupplyDiff > 0 order by mb.DaysOfSupplyDiff Desc) as tRanking on b.BranchID = tRanking.BranchID
  
	End
 Else If (@MeasureType = 'MinMax')
	Begin
		  Update mb  
			  Set mb.MinMaxLeft = minmaxTemp.MinMaxLeft,  
			   mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle,  
			   mb.MinMaxMiddleDiff = (mb.MinMAxGreen - minmaxTemp.MinMaxMiddle),--- This will negative values for the Green Branches. So we can ignore if the difference is less than 0
			   mb.MinMaxRight = minmaxTemp.MinMaxRight,  
			   mb.MinMaxLeftAbs = minmaxTemp.MinMaxLeftAbs,  
			   mb.MinMaxMiddleAbs = minmaxTemp.MinMaxMiddleAbs,  
			   mb.MinMaxRightAbs = minmaxTemp.MinMaxRightAbs  
			  from @SupplyChainDsdInventoryMeasuresByBranch as mb  
			  Inner Join (Select BranchID  
				   , (SUm(IsBelowMin) * 1.0 )/ SUM(IsBelowMin + IsCompliant + IsAboveMax)*100 as MinMaxLeft  
				   ,(SUm(IsCompliant) * 1.0 )/ SUM(IsBelowMin + IsCompliant + IsAboveMax)*100 as MinMaxMiddle  
				   , (SUm(IsAboveMax) * 1.0 )/ SUM(IsBelowMin + IsCompliant + IsAboveMax)*100 as MinMaxRight  
				   ,(SUm(IsBelowMin) * 1.0 ) as MinMaxLeftAbs  
				   ,(SUm(IsCompliant) * 1.0 ) as MinMaxMiddleAbs  
				   ,(SUm(IsAboveMax) * 1.0 ) as MinMaxRightAbs  
				   from SupplyChain.tDsdDailyMinMax as minmax  
				   Where minmax.DateID = @DateID   
				   And minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)  
				   And minmax.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)     
				   And minmax.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)   
				   Group By BranchID) as minmaxTemp on mb.BranchId = minmaxTemp.BranchId 
			Select b.*, tRanking.MeasureRank as 'MeasureRank'
						from @SupplyChainDsdInventoryMeasuresByBranch as b Left Outer Join
					 ( Select  top 5 *, Rank() Over (ORDER BY MinMaxMiddleDiff) as MeasureRank  
							from @SupplyChainDsdInventoryMeasuresByBranch as mb where mb.MinMaxMiddle <> mb.MinMAxGreen And mb.MinMaxMiddleDiff > 0 order by mb.MinMaxMiddleDiff) as tRanking on b.BranchID = tRanking.BranchID 
	End 
  


GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdInventoryMeasuresByBranchAggregated]    Script Date: 12/12/2014 5:43:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Test Bench
exec [SupplyChain].[pGetDsdInventoryMeasuresByBranchAggregated] 20141014,'8,11,12,13,14,15,18,19,21,25,29,33,35,36,37,42,44,47,48,50,52,53,54,58','69,192,138,29,232,221,75,158,195,3,12,35,129,49,190,184,64,101', '46,69,138,152,118,78,129,86,64,44,150,47,70,30,124,133,61,36'
exec [SupplyChain].[pGetDsdInventoryMeasuresByBranchAggregated] 20141118, '1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 146, 147, 148, 149, 150, 151, 152, 153, 163, 170, 172, 174'
																		, '1, 3, 7, 22, 29, 33, 35, 49, 65, 69, 75, 232, 101, 138, 145, 158, 170, 190, 194, 195, 196, 217, 221, 223, 231, 131, 160, 141, 12, 174, 68, 99, 184, 9, 67, 147, 162, 113, 44, 219, 154'
																		,'22, 27, 30, 32, 33, 38, 39, 44, 46, 47, 51, 59, 62, 63, 64, 67, 68, 73, 77, 78, 79, 85, 86, 88, 91, 94, 105, 108, 117, 124, 129, 133, 134, 138, 139, 140, 143, 145, 146, 150, 151, 152, 153, 154, 158, 159, 160, 162, 165'					

	
	
*/

CREATE PROC [SupplyChain].[pGetDsdInventoryMeasuresByBranchAggregated] (  
 @DateID INT =0  
 ,@BranchIDs VARCHAR(4000) =''  
 ,@TrademarkIDs VARCHAR(4000) = ''  
 ,@PackageTypeIDs varchar(4000)  
 ,@AggregationID INT = 0  
 )  
AS  
SET NOCOUNT ON;  

Declare @SupplyChainDsdInventoryMeasuresByBranchAggregated Table  
			 (  
				 IncomingOrderCases int  null
				 ,IncomingOrderCasesDayAfterTomorrow int  null
				,IncomingOrderUpdated Datetime2
				,CaseCut int null
				,OOS Decimal(10,1) null
				,DaysOfSupply Decimal(10,1) null
				,MinMaxLeft Decimal(10,1) null
				,MinMaxMiddle Decimal(10,1) null
				,MinMaxRight Decimal(10,1) null
				,OOSRed Decimal(10,1) null
				,OOSGreen Decimal(10,1) null
				,DOSRed Decimal(10,1) null
				,DOSGreen Decimal(10,1) null
				,MinMaxRed Decimal(10,1) null
				,MinMAxGreen Decimal(10,1) null
			 )

Declare @SelectedBranchIDs Table
		(
			BranchID int
		)

Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)

Declare @SelectedPackageTypeIDs Table
		(
			PackageTypeID int
		)
Declare @TomorrowDate int
Declare @DayAfterTomorrowDate int
Set @TomorrowDate = SupplyChain.udfConvertToDateID(getdate())
Set @DayAfterTomorrowDate = SupplyChain.udfConvertToDateID(DATEADD(d,1, GETDATE())) 

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')

Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')


Insert into @SelectedPackageTypeIDs
Select Value from dbo.Split(@PackageTypeIDs,',')

	----If we are showing only one branch, then need to return the threshold data for that one branch. If it's more than one branch and under one region we need to return the region threshold. If branches are falling under multiple region then need to return the OverAllThreshold
		If (Select Count(*) from @SelectedBranchIDs) = 1  
			Begin
				Insert into @SupplyChainDsdInventoryMeasuresByBranchAggregated (OOSRed, OOSGreen, DOSRed, DOSGreen, MinMaxRed, MinMaxGreen) 
					Select bt.BranchOOSLeftThreshold, bt.BranchOOSRightThreshold, bt.BranchDOSLeftThreshold, bt.BranchDOSRightThreshold, bt.BranchMinMaxLeftThreshold, bt.BranchMinMaxRightThreshold
					from SAP.Branch as b 
					Inner Join SupplyChain.vBranchThreshold as bt on b.BranchID = bt.BranchID 
					Where bt.BranchID in (Select BranchID from @SelectedBranchIDs)

			End
		Else If (Select Count(Distinct RegionID) from @SelectedBranchIDs sb inner Join Mview.LocationHier as lh on lh.BranchID = sb.BranchID) = 1 
			Begin
				Insert into @SupplyChainDsdInventoryMeasuresByBranchAggregated (OOSRed, OOSGreen, DOSRed, DOSGreen, MinMaxRed, MinMaxGreen) 
					Select Top 1 rt.RegionOOSLeftThreshold, rt.RegionOOSRightThreshold, rt.RegionDOSLeftThreshold, rt.RegionDOSRightThreshold, rt.RegionMinMaxLeftThreshold, rt.RegionMinMaxRightThreshold
					from MView.LocationHier as lh 
					Inner Join SupplyChain.vRegionThreshold as rt on lh.RegionID = rt.RegionID 
					Where Lh.BranchID in (Select BranchID from  @SelectedBranchIDs)

			End
		Else
			Begin 
				Insert into @SupplyChainDsdInventoryMeasuresByBranchAggregated (OOSRed, OOSGreen, DOSRed, DOSGreen, MinMaxRed, MinMaxGreen) 
					Select OAT.OverAllOOSLeftThreshold, OAT.OverAllOOSRightThreshold, OAT.OverAllDOSLeftThreshold, OAT.OverAllDOSRightThreshold, OAT.OverAllMinMaxLeftThreshold, OAT.OverAllMinMaxRightThreshold
						from SupplyChain.OverAllThreshold as OAT

			End
	
		Update mb
		Set mb.OOS = OOSTemp.OOS,
		mb.CaseCut = OOSTemp.CaseCut,
		mb.IncomingOrderUpdated = (Select Top 1 MergeDate From ETL.BCDataLoadingLog Where SchemaName = 'Apacheta'And TableName = 'OriginalOrder'),
		mb.IncomingOrderCases = Isnull((Select Sum(dcc.Quantity) from SupplyChain.tDsdDailyCaseCut as dcc  inner Join  SAP.Branch as b on dcc.BranchID = b.BranchID
										Where b.BranchID in (Select BranchID from @SelectedBranchIDs)
											  And dcc.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
											  And dcc.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)	
											 And DateID = @TomorrowDate),0),
		mb.IncomingOrderCasesDayAfterTomorrow = isnull((Select Sum(dor.Quantity) from SupplyChain.tDSDOpenOrder as DOR  inner Join  SAP.Branch as b on dor.BranchID = b.BranchID
										Where b.BranchID in (Select BranchID from @SelectedBranchIDs) 
											  And DOR.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
											  And DOR.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)
											  And DateID = @DayAfterTomorrowDate),0)
		from @SupplyChainDsdInventoryMeasuresByBranchAggregated as mb
		 Cross Join (Select ((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0)) * 100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
						SupplyChain.tDsdDailyCaseCut as OOS
						Where  OOS.DateID = @DateID 
						And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
						And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
						And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)	
						) as OOSTemp 

		Update mb
		Set mb.DaysOfSupply = DOSTemp.DaysOfSupply
		from @SupplyChainDsdInventoryMeasuresByBranchAggregated as mb
		Cross Join (Select Case When sum(dos.Past31DaysXferOutPlusShipment) = 0 Then 0 Else ((SUM(dos.EndingInventory)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 30 End as DaysOfSupply
					 from SupplyChain.tDsdDailyBranchInventory as DOS 
					 Where  DOS.DateID = @DateID 
						And DOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
						And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
						And DOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		 
						) as DOSTemp 

		Update mb
		Set mb.MinMaxLeft = minmaxTemp.MinMaxLeft,
			mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle,
			mb.MinMaxRight = minmaxTemp.MinMaxRight
		from @SupplyChainDsdInventoryMeasuresByBranchAggregated as mb
		Cross Join (Select  ((SUm(minMax.IsBelowMin) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxLeft
							,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
							, ((SUm(minMax.IsAboveMax) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxRight
							from SupplyChain.tDsdDailyMinMax as minmax
							 Where  minmax.DateID = @DateID And  minmax.BranchID in (Select BranchID from @SelectedBranchIDs)
						And minmax.TradeMarkID in (Select TradeMarkID from @SelectedTradeMarkIDs)	
						And minmax.PackageTypeID in (Select PackageTypeID from @SelectedPackageTypeIDs)
						) as minmaxTemp 
  Select * from @SupplyChainDsdInventoryMeasuresByBranchAggregated
--SELECT 2338 IncomingOrderCases  
-- ,getutcdate() IncomingOrderUpdated  
-- ,4 CaseCut  
-- ,2.5 OOS  
-- ,6.1 DaysOfSupply  
-- ,2.5 MinMaxleft  
-- ,89.1 MinMaxMiddle  
-- ,12.2 MinMaxRight  
-- ,-- Actuals  
-- 1.1 OOSRed  
-- ,1.2 OOSGreen  
-- ,2.3 DOSRed  
-- ,2.6 DOSGreen  
-- ,2.6 MinMaxRed  
-- ,2.9 MinMaxGreen --- Borders Threshholds  




GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdInventoryMeasuresByRegion]    Script Date: 12/12/2014 5:43:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Test Bench
exec [SupplyChain].[pGetDsdInventoryMeasuresByRegion] 20141014,'3,4,5','69,192,138,29,232,221,75,9,158,195,3,12,35,129,49,190,184,67', '46,69,138,175,152,118,78,129,86,64,38,44,150,47,70,30,124', 'MinMax'
*/

CREATE Proc [SupplyChain].[pGetDsdInventoryMeasuresByRegion]

(

	@DateID int,
	@RegionIDs varchar(4000),
	@BranchIDs varchar(4000),
	@TrademarkIDs varchar(4000),
	@PackageTypeIDs varchar(4000),
	@MeasureType varchar(20),
	@AggregationID int = 0
)

AS	
	Set NoCount On;
	Declare @SupplyChainDsdInventoryMeasuresByRegion Table  
			 (  
			  RegionID int not null
			  ,RegionName varchar(50) not null
			  ,Longitude Decimal(10,6) null
			  ,Latitude Decimal(10,6) null
			  ,CaseCut int  null
			  ,OOS Decimal(10,1) null
			  ,OOSDiff Decimal(10,1) null
			  ,DaysOfSupply Decimal(10,1) null
			  ,DaysOfSupplyInventory Decimal(10,1) null
			  ,DaysOfSupplyDiff Decimal(10,1) null  
			  ,MinMaxLeft Decimal(10,1) null
			  ,MinMaxMiddle Decimal(10,1) null
			  ,MinMaxMiddleDiff Decimal(10,1) null    
			  ,MinMaxRight Decimal(10,1) null
			  ,MinMaxLeftAbs int null
			  ,MinMaxMiddleAbs int null
			  ,MinMaxRightAbs int null
			  ,OOSRed Decimal(10,1) null
			  ,OOSGreen Decimal(10,1) null
			  ,DOSRed Decimal(10,1) null
			  ,DOSGreen Decimal(10,1) null
			  ,MinMaxRed Decimal(10,1) null
			  ,MinMAxGreen Decimal(10,1) null
			  --,OOSRank int null
			  --,DOSRank int null
			  --,MinMaxRank int null
			 )
Declare @SelectedRegionIDs Table
		(
			RegionID int
		)
Declare @SelectedBranchIDs Table
(
	BranchID int
)
Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)
Declare @SelectedPackageTypeIDs Table
		(
			PackageTypeID int
		)
Insert into @SelectedRegionIDs
Select Value from dbo.Split(@RegionIDs,',')

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')

Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')

Insert into @SelectedPackageTypeIDs
Select Value from dbo.Split(@PackageTypeIDs,',')


	Insert into @SupplyChainDsdInventoryMeasuresByRegion (RegionID,RegionName, Longitude, Latitude, OOSRed, OOSGreen, DOSRed, DOSGreen, MinMaxRed, MinMaxGreen) 
			Select r.RegionID, r.RegionName, r.Longitude, r.Latitude, rt.RegionOOSLeftThreshold, rt.RegionOOSRightThreshold, rt.RegionDOSLeftThreshold, rt.RegionDOSRightThreshold, rt.RegionMinMaxLeftThreshold, rt.RegionMinMaxRightThreshold
			from SAP.Region as r 
			Inner Join SupplyChain.vRegionThreshold as rt on r.RegionID = rt.RegionID 
			Where rt.RegionID in (Select RegionID from @SelectedRegionIDs)

If(@MeasureType = 'OOS')
	Begin
		Update mb
		Set mb.OOS = OOSTemp.OOS,
		mb.CaseCut = OOSTemp.CaseCut,
		 	mb.OOSDiff = (OOSTemp.OOS - mb.OOSGreen)  --- This will negative values for the Green Branches. So we can ignore if the difference is less than 0  
		from @SupplyChainDsdInventoryMeasuresByRegion as mb
		 Inner Join (Select RegionID,((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0)) * 100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
						SupplyChain.tDsdDailyCaseCut as OOS
						Where  OOS.DateID = @DateID 
						And OOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
						And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
						And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
						And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		
						Group By RegionID) as OOSTemp on mb.RegionID= OOSTemp.RegionID
		Select r.*, tRanking.MeasureRank as 'MeasureRank'
				from @SupplyChainDsdInventoryMeasuresByRegion as r Left Outer Join
					 (Select top 5 *, Rank() Over (ORDER BY mb.OOSDiff Desc) as MeasureRank  
							from @SupplyChainDsdInventoryMeasuresByRegion as mb 
							where mb.CaseCut is not null And mb.OOSDiff > 0 order by OOSDiff Desc) as tRanking on r.RegionID = tRanking.RegionID

	End
Else If(@MeasureType = 'DOS')
	Begin
		Update mb
		Set mb.DaysOfSupply = DOSTemp.DaysOfSupply,
			mb.DaysOfSupplyDiff = (DOSTemp.DaysOfSupply - mb.DOSGreen),  --- This will negative values for the Green Branches. So we can ignore if the difference is less than 0  
			mb.DaysOfSupplyInventory = DOSTemp.DaysOfSupplyInventory
		from @SupplyChainDsdInventoryMeasuresByRegion as mb
		Inner Join (Select RegionID
							, Case When sum(dos.Past31DaysXferOutPlusShipment) = 0 Then 0 Else ((SUM(dos.EndingInventory)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 30 End as DaysOfSupply
							,(SUM(dos.EndingInventory)*1.0)/1000 as DaysOfSupplyInventory
					 from SupplyChain.tDsdDailyBranchInventory as DOS 
					 Where DOS.DateID = @DateID 
							And dos.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
							And dos.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
							And dos.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And dos.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)	
							Group By RegionID) as DOSTemp on mb.RegionID=DOSTemp.RegionID
			Select r.*, tRanking.MeasureRank as 'MeasureRank'
				from @SupplyChainDsdInventoryMeasuresByRegion as r Left Outer Join
					 (Select  top 5 *, Rank() Over (ORDER BY mb.DaysOfSupplyDiff Desc) as MeasureRank  
								from @SupplyChainDsdInventoryMeasuresByRegion as mb where mb.DaysOfSupply > 0 And  mb.DaysOfSupplyDiff > 0 order by mb.DaysOfSupplyDiff Desc) as tRanking on r.RegionID = tRanking.RegionID

	End
Else If(@MeasureType = 'MinMax')
	Begin
		Update mb
		Set mb.MinMaxLeft = minmaxTemp.MinMaxLeft,
			mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle,
			mb.MinMaxMiddleDiff = (mb.MinMAxGreen - minmaxTemp.MinMaxMiddle),--- This will negative values for the Green Branches. So we can ignore if the difference is less than 0
			mb.MinMaxRight = minmaxTemp.MinMaxRight,
			mb.MinMaxLeftAbs = minmaxTemp.MinMaxLeftAbs,
			mb.MinMaxMiddleAbs = minmaxTemp.MinMaxMiddleAbs,
			mb.MinMaxRightAbs = minmaxTemp.MinMaxRightAbs
		from @SupplyChainDsdInventoryMeasuresByRegion as mb
		Inner Join (Select RegionID
							,((SUm(minMax.IsBelowMin) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxLeft
							,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
							, ((SUm(minMax.IsAboveMax) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxRight
							,(SUm(IsBelowMin) * 1.0 ) as MinMaxLeftAbs
							,(SUm(IsCompliant) * 1.0 ) as MinMaxMiddleAbs
							,(SUm(IsAboveMax) * 1.0 ) as MinMaxRightAbs
							from SupplyChain.tDsdDailyMinMax as minmax
							Where minmax.DateID = @DateID 
							And minmax.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
							And minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
							And minmax.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)		
							And minmax.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)	
							Group By RegionID) as minmaxTemp on mb.RegionID = minmaxTemp.RegionID
		
			Select r.*, tRanking.MeasureRank as 'MeasureRank'
						from @SupplyChainDsdInventoryMeasuresByRegion as r Left Outer Join
					 ( Select  top 5 *, Rank() Over (ORDER BY MinMaxMiddleDiff) as MeasureRank  
							from @SupplyChainDsdInventoryMeasuresByRegion as mb where mb.MinMaxMiddle <> mb.MinMAxGreen And mb.MinMaxMiddleDiff > 0 order by mb.MinMaxMiddleDiff) as tRanking on r.RegionID = tRanking.RegionID

	End


GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdInventoryMeasuresByRegionAggregated]    Script Date: 12/12/2014 5:43:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Test Bench
exec [SupplyChain].[pGetDsdInventoryMeasuresByRegionAggregated] 20141014,'3,4,5','69,192,138,29,232,221,75,9,158,195,3,12,35,129,49,190,184,67', '46,69,138,175,152,118,78,129,86,64,38,44,150,47,70,30,124'
exec [SupplyChain].[pGetDsdInventoryMeasuresByRegionAggregated] 20141117, '1, 2, 3, 5, 6, 11','1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 146, 147, 148, 149, 150, 151, 152, 153, 163, 170, 172, 174'
																		, '1, 3, 7, 22, 29, 33, 35, 49, 65, 69, 75, 232, 101, 138, 145, 158, 170, 190, 194, 195, 196, 217, 221, 223, 231, 131, 160, 141, 12, 174, 68, 99, 184, 9, 67, 147, 162, 113, 44, 219, 154'
																		,'22, 27, 30, 32, 33, 38, 39, 44, 46, 47, 51, 59, 62, 63, 64, 67, 68, 73, 77, 78, 79, 85, 86, 88, 91, 94, 105, 108, 117, 124, 129, 133, 134, 138, 139, 140, 143, 145, 146, 150, 151, 152, 153, 154, 158, 159, 160, 162, 165'					

	
	

*/

CREATE PROC [SupplyChain].[pGetDsdInventoryMeasuresByRegionAggregated] (  
 @DateID INT =0  
 ,@RegionIDs VARCHAR(4000) =''  
 ,@BranchIDs varchar(4000)=''
 ,@TrademarkIDs VARCHAR(4000) = ''  
 ,@PackageTypeIDs varchar(4000)  
 ,@AggregationID INT = 0  
 )  
AS  
SET NOCOUNT ON;  

Declare @SupplyChainDsdInventoryMeasuresByRegionAggregated Table  
			 (  
				 IncomingOrderCases int  null
				  ,IncomingOrderCasesDayAfterTomorrow int  null
				,IncomingOrderUpdated Datetime2
				,CaseCut int null
				,OOS Decimal(10,1) null
				,DaysOfSupply Decimal(10,1) null
				,MinMaxLeft Decimal(10,1) null
				,MinMaxMiddle Decimal(10,1) null
				,MinMaxRight Decimal(10,1) null
				,OOSRed Decimal(10,1) null
				,OOSGreen Decimal(10,1) null
				,DOSRed Decimal(10,1) null
				,DOSGreen Decimal(10,1) null
				,MinMaxRed Decimal(10,1) null
				,MinMAxGreen Decimal(10,1) null
			 )

Declare @SelectedRegionIDs Table
		(
			RegionID int
		)
Declare @SelectedBranchIDs Table
(
	BranchID int
)
Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)

Declare @SelectedPackageTypeIDs Table
		(
			PackageTypeID int
		)


Declare @TomorrowDate int
Declare @DayAfterTomorrowDate int
Set @TomorrowDate = SupplyChain.udfConvertToDateID(GETDATE())
Set @DayAfterTomorrowDate = SupplyChain.udfConvertToDateID(DATEADD(d,1, GETDATE())) 


Insert into @SelectedRegionIDs
Select Value from dbo.Split(@RegionIDs,',')

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')

Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')


Insert into @SelectedPackageTypeIDs
Select Value from dbo.Split(@PackageTypeIDs,',')

	----If we are showing only one branch, then need to return the threshold data for that one branch. If it's more than one branch and under one region we need to return the region threshold. If branches are falling under multiple region then need to return the OverAllThreshold
		If (Select Count(*) from @SelectedRegionIDs) = 1  
			Begin
				Insert into @SupplyChainDsdInventoryMeasuresByRegionAggregated (OOSRed, OOSGreen, DOSRed, DOSGreen, MinMaxRed, MinMaxGreen) 
					Select rt.RegionOOSLeftThreshold, rt.RegionOOSRightThreshold, rt.RegionDOSLeftThreshold, rt.RegionDOSRightThreshold, rt.RegionMinMaxLeftThreshold, rt.RegionMinMaxRightThreshold
					from SAP.Region as r 
					Inner Join SupplyChain.vRegionThreshold as rt on r.RegionID = rt.RegionID
					Where rt.RegionID in (Select RegionID from @SelectedRegionIDs)

			End
		Else
			Begin 
				Insert into @SupplyChainDsdInventoryMeasuresByRegionAggregated (OOSRed, OOSGreen, DOSRed, DOSGreen, MinMaxRed, MinMaxGreen) 
					Select OAT.OverAllOOSLeftThreshold, OAT.OverAllOOSRightThreshold, OAT.OverAllDOSLeftThreshold, OAT.OverAllDOSRightThreshold, OAT.OverAllMinMaxLeftThreshold, OAT.OverAllMinMaxRightThreshold
						from SupplyChain.OverAllThreshold as OAT

			End
	
		Update mb
		Set mb.OOS = OOSTemp.OOS,
		mb.CaseCut = OOSTemp.CaseCut,
		mb.IncomingOrderUpdated = (Select Top 1 MergeDate From ETL.BCDataLoadingLog Where SchemaName = 'Apacheta'And TableName = 'OriginalOrder'),
		mb.IncomingOrderCases = Isnull((Select Sum(dcc.Quantity) from SupplyChain.tDsdDailyCaseCut as dcc  inner Join  MView.LocationHier as lh on dcc.BranchID = lh.BranchID
										Where lh.RegionID in (Select RegionID from @SelectedRegionIDs) 
											  And lh.BranchID in (Select BranchID from @SelectedBranchIDs)
											  And dcc.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
											  And dcc.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		
											  And DateID = @TomorrowDate),0),
		mb.IncomingOrderCasesDayAfterTomorrow = Isnull((Select Sum(DOR.Quantity) from SupplyChain.tDSDOpenOrder as DOR  inner Join  MView.LocationHier as lh on dor.BranchID = lh.BranchID
										Where lh.RegionID in (Select RegionID from @SelectedRegionIDs) 
											   And lh.BranchID in (Select BranchID from @SelectedBranchIDs)
											  And DOR.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
											  And DOR.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)	
											  And DateID = @DayAfterTomorrowDate),0)
		from @SupplyChainDsdInventoryMeasuresByRegionAggregated as mb
		 Cross Join (Select ((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0))* 100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
						SupplyChain.tDsdDailyCaseCut as OOS
						Where  OOS.DateID = @DateID
						And OOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
						And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
						And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
						And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		
						) as OOSTemp 

		Update mb
		Set mb.DaysOfSupply = DOSTemp.DaysOfSupply
		from @SupplyChainDsdInventoryMeasuresByRegionAggregated as mb
		Cross Join (Select Case When sum(dos.Past31DaysXferOutPlusShipment) = 0 Then 0 Else ((SUM(dos.EndingInventory)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 30 End as DaysOfSupply
					 from SupplyChain.tDsdDailyBranchInventory as DOS 
					 Where  DOS.DateID = @DateID 
						And DOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
						And DOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
						And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
						And DOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		 
						) as DOSTemp 

		Update mb
		Set mb.MinMaxLeft = minmaxTemp.MinMaxLeft,
			mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle,
			mb.MinMaxRight = minmaxTemp.MinMaxRight
		from @SupplyChainDsdInventoryMeasuresByRegionAggregated as mb
		Cross Join (Select  ((SUm(minMax.IsBelowMin) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxLeft
							,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
							, ((SUm(minMax.IsAboveMax) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxRight
							from SupplyChain.tDsdDailyMinMax as minmax
							 Where  minmax.DateID = @DateID 
									And minmax.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
									And minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
									And minmax.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
									And minmax.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)	
					) as minmaxTemp 
  Select * from @SupplyChainDsdInventoryMeasuresByRegionAggregated
--SELECT 2338 IncomingOrderCases  
-- ,getutcdate() IncomingOrderUpdated  
-- ,4 CaseCut  
-- ,2.5 OOS  
-- ,6.1 DaysOfSupply  
-- ,2.5 MinMaxleft  
-- ,89.1 MinMaxMiddle  
-- ,12.2 MinMaxRight  
-- ,-- Actuals  
-- 1.1 OOSRed  
-- ,1.2 OOSGreen  
-- ,2.3 DOSRed  
-- ,2.6 DOSGreen  
-- ,2.6 MinMaxRed  
-- ,2.9 MinMaxGreen --- Borders Threshholds  




GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdInventoryRegionMeasuresForLanding]    Script Date: 12/12/2014 5:43:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Test Bench
exec [SupplyChain].[pGetDsdInventoryRegionMeasuresForLanding] 20141014,'3,4,5', '42,43,44,45,46,47,48,49,50,51,52', '69,192,138,29,232,221,75,9,158,195,3,12,35,129,49,190,184,67', '46,69,138,175,152,118,78,129,86,64,38,44,150,47,70,30,124', 'OOS'

exec [SupplyChain].[pGetDsdInventoryRegionMeasuresForLanding] 20141111,'1,2,3,4,5,6,7,8,9,11,14,12','1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,167,168,169,170,172,173,174',
'1,3,5,20,22,33,59,35,37,60,44,61,46,49,50,51,65,67,68,34,64,89,173,54,97,129,130,154,187,216,228',
'22,27,30,33,38,39,44,46,47,51,59,62,63,64,67,68,77,78,79,86,90,94,108,117,124,129,133,134,138,139,140,143,145,146,150,151,152,154','OOS'

*/
CREATE Proc [SupplyChain].[pGetDsdInventoryRegionMeasuresForLanding]
(
	@DateID int,
	@RegionIDs varchar(4000),
	@BranchIDs Varchar(4000),
	@TrademarkIDs varchar(4000),
	@PackageTypeIDs varchar(4000),
	@MeasureType varchar(10),
	@AggregationID int = 0
	
)
AS	
	Set NoCount On;

	Declare @SupplyChainDsdInventoryMeasuresByRegion Table  
			 (  
			  RegionID int not null
			  ,RegionName varchar(50) not null
			  ,Longitude varchar(50) null
			  ,Latitude varchar(50) null
			  ,CaseCut int  null
			  ,OOS Decimal(10,1) null
			  ,DaysOfSupply Decimal(10,1) null
			  ,MinMaxMiddle Decimal(10,1) null
			  ,IsSelectedRegion bit
			  ,OOSRed Decimal(10,1) null
			  ,OOSGreen Decimal(10,1) null
			  ,DOSRed Decimal(10,1) null
			  ,DOSGreen Decimal(10,1) null
			  ,MinMaxRed Decimal(10,1) null
			  ,MinMaxGreen Decimal(10,1) null
			  ,KPILevel varchar(10) null
			  ,BUSortOrder int	
			 )

Declare @SelectedRegionIDs Table
		(
			RegionID int
		)
Declare @SelectedBranchIDs Table
		(
			BranchID int
		)
Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)

Declare @SelectedPackageTypeIDs Table
		(
			PackageTypeID int
		)
Insert into @SelectedRegionIDs
Select Value from dbo.Split(@RegionIDs,',')

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')

Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')

Insert into @SelectedPackageTypeIDs
Select Value from dbo.Split(@PackageTypeIDs,',')

	Insert into @SupplyChainDsdInventoryMeasuresByRegion (RegionID,RegionName, Longitude, Latitude, IsSelectedRegion, OOSRed, OOSGreen, DOSRed, DOSGreen, MinMaxRed, MinMaxGreen,BUSortOrder) 
			Select r.RegionID, r.ShortName as RegionName, r.Longitude, r.Latitude
					,Case When sr.RegionID is not null then 1 Else 0 End
					, rt.RegionOOSLeftThreshold, rt.RegionOOSRightThreshold, rt.RegionDOSLeftThreshold, rt.RegionDOSRightThreshold, rt.RegionMinMaxLeftThreshold, rt.RegionMinMaxRightThreshold
					, bu.SortOrder
			from SAP.Region as r 
			Left Outer Join @SelectedRegionIDs as sr on r.RegionID = sr.RegionID
			Inner Join SupplyChain.vRegionThreshold as rt on rt.RegionID = r.RegionID 
			Inner Join SAP.BusinessUnit as bu on r.BUID = bu.BUID 
			

	If(@MeasureType = 'OOS')
		Begin 
			Update mb
			Set mb.OOS = OOSTemp.OOS,
			mb.CaseCut = OOSTemp.CaseCut,
			mb.KPILevel = Case 
							When OOSTemp.OOS > mb.OOSRed Then 'Red' 
							When (OOSTemp.OOS >= mb.OOSGreen And OOSTemp.OOS <= mb.OOSRed) Then 'Amber' 
							When OOSTemp.OOS < mb.OOSGreen Then 'Green' End
			from @SupplyChainDsdInventoryMeasuresByRegion as mb
			 Inner Join (Select RegionID,((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0))*100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
							SupplyChain.tDsdDailyCaseCut as OOS
							Where  OOS.DateID = @DateID 
							And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)
							And OOS.RegionID Not in (Select sr.RegionID from @SelectedRegionIDs as sr)		
							Group By RegionID) as OOSTemp on mb.RegionID= OOSTemp.RegionID
			Update mb
			Set mb.OOS = OOSTemp.OOS,
			mb.CaseCut = OOSTemp.CaseCut,
			mb.KPILevel = Case 
							When OOSTemp.OOS > mb.OOSRed Then 'Red' 
							When (OOSTemp.OOS >= mb.OOSGreen And OOSTemp.OOS <= mb.OOSRed) Then 'Amber' 
							When OOSTemp.OOS < mb.OOSGreen Then 'Green' End
			from @SupplyChainDsdInventoryMeasuresByRegion as mb
			 Inner Join (Select RegionID,((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0))*100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
							SupplyChain.tDsdDailyCaseCut as OOS
							Where  OOS.DateID = @DateID 
							And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)	
							And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)
							And OOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)		
							Group By RegionID) as OOSTemp on mb.RegionID= OOSTemp.RegionID
		End
    Else if(@MeasureType = 'DOS')
		Begin
			Update mb
			Set mb.DaysOfSupply = DOSTemp.DaysOfSupply,
			mb.KPILevel = Case 
								When DOSTemp.DaysOfSupply > mb.DOSRed Then 'Red' 
								When (DOSTemp.DaysOfSupply >= mb.DOSGreen And DOSTemp.DaysOfSupply <= mb.DOSRed) Then 'Amber' 
								When DOSTemp.DaysOfSupply < mb.DOSGreen Then 'Green' End
			from @SupplyChainDsdInventoryMeasuresByRegion as mb
			Inner Join (Select RegionID, Case When sum(dos.Past31DaysXferOutPlusShipment) = 0 Then 0 Else ((SUM(dos.EndingInventory)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 30 End as DaysOfSupply
						 from SupplyChain.tDsdDailyBranchInventory as DOS 
						Where  DOS.DateID = @DateID 
							And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And DOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)
							And DOS.RegionID Not in (Select sr.RegionID from @SelectedRegionIDs as sr)		
							Group By RegionID) as DOSTemp on mb.RegionID= DOSTemp.RegionID
			Update mb
			Set mb.DaysOfSupply = DOSTemp.DaysOfSupply,
			mb.KPILevel = Case 
								When DOSTemp.DaysOfSupply > mb.DOSRed Then 'Red' 
								When (DOSTemp.DaysOfSupply >= mb.DOSGreen And DOSTemp.DaysOfSupply <= mb.DOSRed) Then 'Amber' 
								When DOSTemp.DaysOfSupply < mb.DOSGreen Then 'Green' End
			from @SupplyChainDsdInventoryMeasuresByRegion as mb
			Inner Join (Select RegionID, Case When sum(dos.Past31DaysXferOutPlusShipment) = 0 Then 0 Else ((SUM(dos.EndingInventory)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 30 End as DaysOfSupply
						 from SupplyChain.tDsdDailyBranchInventory as DOS 
						Where  DOS.DateID = @DateID 
							And DOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)	
							And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And DOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)
							And DOS.RegionID  in (Select sr.RegionID from @SelectedRegionIDs as sr)		
							Group By RegionID) as DOSTemp on mb.RegionID= DOSTemp.RegionID
		End
	Else if(@MeasureType = 'MinMax')
		Begin
			Update mb
			Set mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle,
				mb.KPILevel = Case 
							When minmaxTemp.MinMaxMiddle < mb.MinMaxRed Then 'Red' 
							When (minmaxTemp.MinMaxMiddle >= mb.MinMaxRed And minmaxTemp.MinMaxMiddle <= mb.MinMaxGreen) Then 'Amber' 
							When minmaxTemp.MinMaxMiddle > mb.MinMaxGreen Then 'Green' End
			from @SupplyChainDsdInventoryMeasuresByRegion as mb
			Inner Join (Select RegionID								
								,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
							from SupplyChain.tDsdDailyMinMax as minmax
							Where  minmax.DateID = @DateID 
							And minmax.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And minmax.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)
							And minmax.RegionID Not in (Select sr.RegionID from @SelectedRegionIDs as sr)		
							Group By RegionID) as MinMaxTemp on mb.RegionID= MinMaxTemp.RegionID
			Update mb
			Set mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle,
				mb.KPILevel = Case 
							When minmaxTemp.MinMaxMiddle < mb.MinMaxRed Then 'Red' 
							When (minmaxTemp.MinMaxMiddle >= mb.MinMaxRed And minmaxTemp.MinMaxMiddle <= mb.MinMaxGreen) Then 'Amber' 
							When minmaxTemp.MinMaxMiddle > mb.MinMaxGreen Then 'Green' End
			from @SupplyChainDsdInventoryMeasuresByRegion as mb
			Inner Join (Select RegionID								
								,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
							from SupplyChain.tDsdDailyMinMax as minmax
							Where  minmax.DateID = @DateID
							And minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)	
							And minmax.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And minmax.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)
							And minmax.RegionID  in (Select sr.RegionID from @SelectedRegionIDs as sr)		
							Group By RegionID) as MinMaxTemp on mb.RegionID= MinMaxTemp.RegionID
		End

		Select * from @SupplyChainDsdInventoryMeasuresByRegion order by BUSortOrder, RegionName



GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdMostImpactedPackagesForLanding]    Script Date: 12/12/2014 5:43:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

exec [SupplyChain].[pGetDsdMostImpactedPackagesForLanding] 20141104,'3,4,5','69,192,138,29,232,221,75,158,195,3,12,35,129,49,190,184,64,101', '46,69,138,152,118,78,129,86,64,44,150,47,70,30,124,133,61,36','MinMax'
20141014,'24,25,26,27','69', '325'
select top 10 * from sap.Package
SupplyChain.pGetDsdMostImpactedPackagesForLanding
exec [SupplyChain].[pGetDsdMostImpactedPackagesForLanding] 20141110,'1,5,12','5,11,84,85,160,161','47,97,194','22,32,44,46,47,67,68,78,79,124,129,138,140,150,151,152','DOS'
*/
CREATE PROC [SupplyChain].[pGetDsdMostImpactedPackagesForLanding] (
	@DateID INT
	,@RegionIDs VARCHAR(4000)
	,@BranchIDs varchar(4000)
	,@TrademarkIDs VARCHAR(4000)
	,@packageIDs VARCHAR(4000)
	,@MeasureType varchar(10)
	,@AggregationID INT = 0
	)
AS
SET NOCOUNT ON;

Declare @SupplyChainDsdMostImpactedPackagesByRegion Table  
			 (  
				 PackageID int  null
				,SAPPackageID varchar(10) null
				--,PackageName Varchar(50) null
				--,PackageTypeID int null
				,TradeMarkID int null
				--,TradeMarkName varchar(50) null
				--	,TradeMarkURL varchar(512) null
				,RegionID int null
				--,RegionName varchar(50) null
				,CaseCut int null
				,OOS Decimal(10,1) null
				,DOS Decimal(10,1) null
				,DOSEndingInventory Decimal(10,1) null
				,MinMaxMiddle Decimal(10,1) null
				,MinMaxLeftAbs int null
			    ,MinMaxMiddleAbs int null
			    ,MinMaxRightAbs int null
				
			 )

Declare @SelectedRegionIDs Table
		(
			RegionID int
		)
Declare @SelectedBranchIDs Table
		(
			BranchID int
		)
Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)

Declare @SelectedPackageIDs Table
		(
			PackageID int
		)

Insert into @SelectedRegionIDs
Select Value from dbo.Split(@RegionIDs,',')

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')

Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')


Insert into @SelectedPackageIDs
Select Value from dbo.Split(@PackageIDs,',')

--Insert into @SupplyChainDsdMostImpactedPackagesByRegion (PackageID, PackageName, SAPPackageID,PackageTypeID)
--	Select PackageID, Substring(PackageName,1,14) as PackageName, '', PackageTypeID  from SAP.Package Where PackageID in (Select PackageID from @SelectedPackageIDs)

	If(@MeasureType = 'OOS')
		Begin
		Insert into @SupplyChainDsdMostImpactedPackagesByRegion (PackageID, TradeMarkID, RegionID, OOS, CaseCut)
			Select PackageID, TradeMarkID, RegionID, ((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0)) * 100  as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
							SupplyChain.tDsdDailyCaseCut as OOS
							Where  OOS.DateID = @DateID 
							And OOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
							And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
							And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And OOS.PackageID in (Select sp.PackageID from @SelectedPackageIDs as sp)		
							Group by OOS.PackageID, OOS.TradeMarkID, OOS.RegionID
			 Select top 5 *
			 			, (Select RegionName from SAP.Region as r Where r.RegionID = mb.RegionID) as RegionName
						, (Select TradeMarkName from SAP.TradeMark as t Where t.TradeMarkID = mb.TradeMarkID) as TradeMarkName
						, (Select ImageURL from Shared.[Image]  as I Where I.ImageID  in (Select t.ImageID from SAP.TradeMark as t where t.TradeMarkID = mb.TradeMarkID)) as TradeMarkURL
						, (Select PackageName from SAP.Package as p Where p.PackageID = mb.PackageID) as PackageName
						, (Select PackageTypeID from SAP.Package as p Where p.PackageID = mb.PackageID) as PackageTypeID
						,stuff((SELECT ','+ Cast(BranchID as varchar(10)) FROM Mview.LocationHier as lh WHERE lh.RegionID = mb.RegionID And lh.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb) FOR XML PATH('')),1,1,'') as 'BranchesInRegion'
			 from @SupplyChainDsdMostImpactedPackagesByRegion as mb 
			 Where mb.OOS is not null
			 order by mb.CaseCut desc
		End
	Else If(@MeasureType = 'DOS')
		Begin
		Insert into @SupplyChainDsdMostImpactedPackagesByRegion (PackageID, TradeMarkID, RegionID, DOS, DOSEndingInventory)
			Select  PackageID, TradeMarkID, RegionID
									,Case When sum(dos.Past31DaysXferOutPlusShipment) = 0 Then 0 Else ((SUM(dos.EndingInventory)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 30 End as DaysOfSupply
									,((SUM(dos.EndingInventory)*1.0)/1000) as DOSEndingInventory
							 from SupplyChain.tDsdDailyBranchInventory as DOS 
							 Where  DOS.DateID = @DateID 
									And DOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
									And DOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
									And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
									And DOS.PackageID in (Select sp.PackageID from @SelectedPackageIDs as sp)		 
									Group by DOS.PackageID, DOS.TradeMarkID, DOS.RegionID
							
			 Select top 5 *
						, (Select RegionName from SAP.Region as r Where r.RegionID = mb.RegionID) as RegionName
						, (Select TradeMarkName from SAP.TradeMark as t Where t.TradeMarkID = mb.TradeMarkID) as TradeMarkName
						, (Select ImageURL from Shared.[Image]  as I Where I.ImageID  in (Select t.ImageID from SAP.TradeMark as t where t.TradeMarkID = mb.TradeMarkID)) as TradeMarkURL
						, (Select PackageName from SAP.Package as p Where p.PackageID = mb.PackageID) as PackageName
						, (Select PackageTypeID from SAP.Package as p Where p.PackageID = mb.PackageID) as PackageTypeID
						,stuff((SELECT ','+ Cast(BranchID as varchar(10)) FROM Mview.LocationHier as lh WHERE lh.RegionID = mb.RegionID And lh.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb) FOR XML PATH('')),1,1,'') as 'BranchesInRegion'
			 from @SupplyChainDsdMostImpactedPackagesByRegion as mb 
			 Where mb.DOS is not null
			 order by mb.DOS desc
		End
		
	Else If(@MeasureType = 'MinMax')
		Begin
			Insert into @SupplyChainDsdMostImpactedPackagesByRegion (PackageID, TradeMarkID, RegionID, MinMaxMiddle, MinMaxLeftAbs, MinMaxMiddleAbs, MinMaxRightAbs)
				Select  PackageID, TradeMarkID, RegionID
								,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
								,SUM(IsBelowMin) as MinMaxLeftAbs
								,SUM(IsCompliant) as MinMaxMiddleAbs
								,SUM(IsAboveMax) as MinMaxRightAbs
								from SupplyChain.tDsdDailyMinMax as minmax
								 Where  minmax.DateID = @DateID 
										And minmax.RegionID in (Select RegionID from @SelectedRegionIDs)
										And minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
										And minmax.TradeMarkID in (Select TradeMarkID from @SelectedTradeMarkIDs)	
										And minmax.PackageID in (Select PackageID from @SelectedPackageIDs)	
										Group by minmax.PackageID, minmax.TradeMarkID, minmax.RegionID
						
			 Select top 5 *
						, (Select RegionName from SAP.Region as r Where r.RegionID = mb.RegionID) as RegionName
						, (Select TradeMarkName from SAP.TradeMark as t Where t.TradeMarkID = mb.TradeMarkID) as TradeMarkName
						, (Select ImageURL from Shared.[Image]  as I Where I.ImageID  in (Select t.ImageID from SAP.TradeMark as t where t.TradeMarkID = mb.TradeMarkID)) as TradeMarkURL
						, (Select PackageName from SAP.Package as p Where p.PackageID = mb.PackageID) as PackageName
						, (Select PackageTypeID from SAP.Package as p Where p.PackageID = mb.PackageID) as PackageTypeID
						,stuff((SELECT ','+ Cast(BranchID as varchar(10)) FROM Mview.LocationHier as lh WHERE lh.RegionID = mb.RegionID And lh.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb) FOR XML PATH('')),1,1,'') as 'BranchesInRegion'
			 from @SupplyChainDsdMostImpactedPackagesByRegion as mb
			 Where mb.MinMaxMiddle is not null
			 order by mb.MinMaxMiddle asc
		End



GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdMostImpactedPackageTypesByBranch]    Script Date: 12/12/2014 5:43:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
exec [SupplyChain].[pGetDsdMostImpactedPackageTypesByBranch] 20141014,'8,11,12,13,14,15,18,19,21,25,29,33,35,36,37,42,44,47,48,50,52,53,54,58','69,192,138,29,232,221,75,158,195,3,12,35,129,49,190,184,64,101', '46,69,138,152,118,78,129,86,64,44,150,47,70,30,124,133,61,36','MinMax'
select top 10 * from sap.Package

*/
CREATE PROC [SupplyChain].[pGetDsdMostImpactedPackageTypesByBranch] (
	@DateID INT
	,@BranchIDs VARCHAR(4000)
	,@TrademarkIDs VARCHAR(4000)
	,@packageTypeIDs VARCHAR(4000)
	,@MeasureType Varchar(20)
	,@AggregationID INT = 0
	)
AS
SET NOCOUNT ON;

Declare @SupplyChainDsdMostImpactedPackagesByBranch Table  
			 (  
				 PackageTypeID int  null
				,SAPPackageTypeID varchar(10) null
				,PackageTypeName Varchar(50) null
				,CaseCut int null
				,OOS Decimal(10,1) null
				,DOS Decimal(10,1) null
				,MinMaxMiddle Decimal(10,1) null
			 )

Declare @SelectedBranchIDs Table
		(
			BranchID int
		)

Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)

Declare @SelectedPackageTypeIDs Table
		(
			PackageTypeID int
		)

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')

Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')


Insert into @SelectedPackageTypeIDs
Select Value from dbo.Split(@PackageTypeIDs,',')

Insert into @SupplyChainDsdMostImpactedPackagesByBranch (PackageTypeID, PackageTypeName, SAPPackageTypeID)
	Select PackageTypeID, PackageTypeName, SAPPackageTypeID from SAP.PackageType Where PackageTypeID in (Select PackageTypeID from @SelectedPackageTypeIDs)

If(@MeasureType = 'OOS')
	Begin
		Update mb
		Set mb.OOS = OOSTemp.OOS,
		mb.CaseCut = OOSTemp.CaseCut
			from @SupplyChainDsdMostImpactedPackagesByBranch as mb
		 Inner Join (Select PackageTypeID, ((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0))*100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
						SupplyChain.tDsdDailyCaseCut as OOS
						Where  OOS.DateID = @DateID 
						And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
						And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
						And OOS.PackageTYpeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		
						Group by OOS.PackageTypeID) as OOSTemp on mb.PackageTypeID = OOSTemp.PackageTypeID
			Select * 
			from @SupplyChainDsdMostImpactedPackagesByBranch as mb
				Where mb.OOS is not null	
				Order by mb.OOS Desc
	End
Else If(@MeasureType = 'DOS')
	Begin
		Update mb
			Set mb.DOS = DOSTemp.DaysOfSupply
			from @SupplyChainDsdMostImpactedPackagesByBranch as mb
			Inner Join (Select PackageTypeID,Case When sum(dos.Past31DaysXferOutPlusShipment) = 0 Then 0 Else ((SUM(dos.EndingInventory)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 30 End as DaysOfSupply
						 from SupplyChain.tDsdDailyBranchInventory as DOS 
						 Where  DOS.DateID = @DateID 
							And DOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
							And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And DOS.PackageTYpeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		 
							Group by DOS.PackageTypeID) as DOSTemp   on mb.PackageTypeID = DOSTemp.PackageTypeID
		Select * 
			from @SupplyChainDsdMostImpactedPackagesByBranch as mb
				Where mb.DOS is not null	
				Order by mb.DOS Desc
	End
Else If(@MeasureType = 'MinMax')
	Begin
		Update mb
			Set mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle
			from @SupplyChainDsdMostImpactedPackagesByBranch as mb
			Inner Join (Select PackageTypeID 
								,((SUm(minMax.IsBelowMin) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxLeft
								,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
								, ((SUm(minMax.IsAboveMax) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxRight
								from SupplyChain.tDsdDailyMinMax as minmax
								 Where  minmax.DateID = @DateID 
										And  minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
										And minmax.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
										And minmax.PackageTYpeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		
										Group by minmax.PackageTypeID
						) as minmaxTemp   on mb.PackageTypeID = minmaxTemp.PackageTypeID
		Select * 
			from @SupplyChainDsdMostImpactedPackagesByBranch as mb
				Where mb.MinMaxMiddle is not null	
				Order by mb.MinMaxMiddle

	End


GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdMostImpactedPackageTypesByRegion]    Script Date: 12/12/2014 5:43:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

exec [SupplyChain].[pGetDsdMostImpactedPackageTypesByRegion] 20141014,'3,4,5','69,192,138,29,232,221,75,9,158,195,3,12,35,129,49,190,184,67', '46,69,138,175,152,118,78,129,86,64,38,44,150,47,70,30,124','MinMax'
20141014,'24,25,26,27','69', '325'
select top 10 * from sap.Package

*/
CREATE PROC [SupplyChain].[pGetDsdMostImpactedPackageTypesByRegion] (
	@DateID INT
	,@RegionIDs VARCHAR(4000)
	,@BranchIDs VARCHAR(4000)
	,@TrademarkIDs VARCHAR(4000)
	,@packageTypeIDs VARCHAR(4000)
	,@MeasureType varchar(20)
	,@AggregationID INT = 0
	)
AS
SET NOCOUNT ON;

Declare @SupplyChainDsdMostImpactedPackagesByRegion Table  
			 (  
				 PackageTypeID int  null
				,SAPPackageTypeID varchar(10) null
				,PackageTypeName Varchar(50) null
				,CaseCut int null
				,OOS Decimal(10,1) null
				,DOS Decimal(10,1) null
				,MinMaxMiddle Decimal(10,1) null
			 )

Declare @SelectedRegionIDs Table
		(
			RegionID int
		)
Declare @SelectedBranchIDs Table
(
	BranchID int
)
Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)

Declare @SelectedPackageTypeIDs Table
		(
			PackageTypeID int
		)

Insert into @SelectedRegionIDs
Select Value from dbo.Split(@RegionIDs,',')

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')


Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')


Insert into @SelectedPackageTypeIDs
Select Value from dbo.Split(@PackageTypeIDs,',')

Insert into @SupplyChainDsdMostImpactedPackagesByRegion (PackageTypeID, PackageTypeName, SAPPackageTypeID)
	Select PackageTypeID, PackageTypeName, SAPPackageTypeID  from SAP.PackageType Where PackageTypeID in (Select PackageTypeID from @SelectedPackageTypeIDs)
If(@MeasureType = 'OOS')
	Begin
		Update mb
				Set mb.OOS = OOSTemp.OOS,
				mb.CaseCut = OOSTemp.CaseCut
					from @SupplyChainDsdMostImpactedPackagesByRegion as mb
				 Inner Join (Select PackageTypeID, ((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0))*100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
								SupplyChain.tDsdDailyCaseCut as OOS
								Where  OOS.DateID = @DateID 
								And OOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
								And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
								And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
								And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		
								Group by OOS.PackageTypeID
							) as OOSTemp on mb.PackageTypeID = OOSTemp.PackageTypeID
			Select * 
			from @SupplyChainDsdMostImpactedPackagesByRegion as mb
				Where mb.OOS is not null	
				Order by mb.OOS Desc
	End
Else If(@MeasureType = 'DOS')
	Begin
		Update mb
				Set mb.DOS = DOSTemp.DaysOfSupply
				from @SupplyChainDsdMostImpactedPackagesByRegion as mb
				Inner Join (Select PackageTypeID,Case When sum(dos.Past31DaysXferOutPlusShipment) = 0 Then 0 Else ((SUM(dos.EndingInventory)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 30 End as DaysOfSupply
							 from SupplyChain.tDsdDailyBranchInventory as DOS 
							 Where  DOS.DateID = @DateID 
									And DOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
									And DOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
									And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
									And DOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		 
									Group by DOS.PackageTypeID
							) as DOSTemp   on mb.PackageTypeID = DOSTemp.PackageTypeID
		Select * 
			from @SupplyChainDsdMostImpactedPackagesByRegion as mb
				Where mb.DOS is not null	
				Order by mb.DOS Desc
	End
Else If(@MeasureType = 'MinMax')
	Begin
		Update mb
		Set mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle
		from @SupplyChainDsdMostImpactedPackagesByRegion as mb
		Inner Join (Select PackageTypeID
							,((SUm(minMax.IsBelowMin) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxLeft
							,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
							, ((SUm(minMax.IsAboveMax) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxRight
							from SupplyChain.tDsdDailyMinMax as minmax
							 Where  minmax.DateID = @DateID 
									And minmax.RegionID in (Select RegionID from @SelectedRegionIDs)
									And minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
									And minmax.TradeMarkID in (Select TradeMarkID from @SelectedTradeMarkIDs)	
									And minmax.PackageTypeID in (Select PackageTypeID from @SelectedPackageTypeIDs)	
									Group by minmax.PackageTypeID
					) as minmaxTemp   on mb.PackageTypeID = minmaxTemp.PackageTypeID
			Select * 
			from @SupplyChainDsdMostImpactedPackagesByRegion as mb
				Where mb.MinMaxMiddle is not null	
				Order by mb.MinMaxMiddle

	End


GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdMostImpactedTrademarksByBranch]    Script Date: 12/12/2014 5:43:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

exec [SupplyChain].[pGetDsdMostImpactedTrademarksByBranch] 20141014,'8,11,12,13,14,15,18,19,21,25,29,33,35,36,37,42,44,47,48,50,52,53,54,58','69,192,138,29,232,221,75,158,195,3,12,35,129,49,190,184,64,101', '46,69,138,152,118,78,129,86,64,44,150,47,70,30,124,133,61,36','MinMax'
20141014,'24,25,26,27','69', '325'
select top 10 * from sap.Package

*/
CREATE PROC [SupplyChain].[pGetDsdMostImpactedTrademarksByBranch] (
	@DateID INT
	,@BranchIDs VARCHAR(4000)
	,@TrademarkIDs VARCHAR(4000)
	,@packageTypeIDs VARCHAR(4000)
	,@MeasureType Varchar(20)
	,@AggregationID INT = 0
	)
AS
SET NOCOUNT ON;

Declare @SupplyChainDsdMostImpactedTrademarksByBranch Table  
			 (  
				 TradeMarkID int  null
				,SAPTradeMarkID varchar(10) null
				,TradeMarkName Varchar(50) null
				,CaseCut int null
				,OOS Decimal(10,1) null
				,DOS Decimal(10,1) null
				,MinMaxMiddle Decimal(10,1) null
			 )

Declare @SelectedBranchIDs Table
		(
			BranchID int
		)

Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)

Declare @SelectedPackageTypeIDs Table
		(
			PackageTypeID int
		)

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')

Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')


Insert into @SelectedPackageTypeIDs
Select Value from dbo.Split(@PackageTypeIDs,',')

Insert into @SupplyChainDsdMostImpactedTrademarksByBranch (TradeMarkID, TradeMarkName, SAPTradeMarkID)
	Select TradeMarkID, TradeMarkName, SAPTradeMarkID  from SAP.TradeMark Where TradeMarkID in (Select TradeMarkID from @SelectedTradeMarkIDs)

If(@MeasureType = 'OOS')
	Begin
		Update mb
				Set mb.OOS = OOSTemp.OOS,
				mb.CaseCut = OOSTemp.CaseCut
					from @SupplyChainDsdMostImpactedTrademarksByBranch as mb
				 Inner Join (Select TradeMarkID, ((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0))*100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
								SupplyChain.tDsdDailyCaseCut as OOS
								Where  OOS.DateID = @DateID 
								And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
								And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
								And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		
								Group by OOS.TradeMarkID) as OOSTemp on mb.TradeMarkID = OOSTemp.TradeMarkID
		Select * 
			from @SupplyChainDsdMostImpactedTrademarksByBranch as mb
				Where mb.OOS is not null	
				Order by mb.OOS Desc
	End
Else If(@MeasureType = 'DOS')
	Begin
		Update mb
			Set mb.DOS = DOSTemp.DaysOfSupply
			from @SupplyChainDsdMostImpactedTrademarksByBranch as mb
			Inner Join (Select TradeMarkID,Case When sum(dos.Past31DaysXferOutPlusShipment) = 0 Then 0 Else ((SUM(dos.EndingInventory)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 30 End as DaysOfSupply
					 from SupplyChain.tDsdDailyBranchInventory as DOS 
					 Where  DOS.DateID = @DateID 
						And  DOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
						And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
						And DOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		 
						Group by DOS.TradeMarkID) as DOSTemp   on mb.TradeMarkID = DOSTemp.TradeMarkID
			Select * 
			from @SupplyChainDsdMostImpactedTrademarksByBranch as mb
				Where mb.DOS is not null	
				Order by mb.DOS Desc
	End
Else If(@MeasureType = 'MinMax')
	Begin
		Update mb
		Set mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle
		from @SupplyChainDsdMostImpactedTrademarksByBranch as mb
		Inner Join (Select TradeMarkID
							,((SUm(minMax.IsBelowMin) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxLeft
							,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
							, ((SUm(minMax.IsAboveMax) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxRight
							from SupplyChain.tDsdDailyMinMax as minmax
							Where  minmax.DateID = @DateID 
							And  minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
							And minmax.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And minmax.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)	
							Group by minmax.TradeMarkID
				  ) as minmaxTemp   on mb.TradeMarkID = minmaxTemp.TradeMarkID
		Select * 
			from @SupplyChainDsdMostImpactedTrademarksByBranch as mb
				Where mb.MinMaxMiddle is not null	
				Order by mb.MinMaxMiddle
	End


GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdMostImpactedTrademarksByRegion]    Script Date: 12/12/2014 5:43:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

exec [SupplyChain].[pGetDsdMostImpactedTrademarksByRegion] 20141014,'3,4,5','69,192,138,29,232,221,75,9,158,195,3,12,35,129,49,190,184,67', '46,69,138,175,152,118,78,129,86,64,38,44,150,47,70,30,124', 'MinMax'
20141014,'24,25,26,27','69', '325'
select top 10 * from sap.Package

*/
CREATE PROC [SupplyChain].[pGetDsdMostImpactedTrademarksByRegion] (
	@DateID INT
	,@RegionIDs VARCHAR(4000)
	,@BranchIDs VARCHAR(4000)
	,@TrademarkIDs VARCHAR(4000)
	,@packageTypeIDs VARCHAR(4000)
	,@MeasureType Varchar(20)
	,@AggregationID INT = 0
	)
AS
SET NOCOUNT ON;

Declare @SupplyChainDsdMostImpactedTrademarksByRegion Table  
			 (  
				 TrademarkID int  null
				,SAPTrademarkID varchar(10) null
				,TrademarkName Varchar(50) null
				,CaseCut int null
				,OOS Decimal(10,1) null
				,DOS Decimal(10,1) null
				,MinMaxMiddle Decimal(10,1) null
			 )

Declare @SelectedRegionIDs Table
		(
			RegionID int
		)

Declare @SelectedBranchIDs Table
		(
			BranchID int
		)
Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)

Declare @SelectedPackageTypeIDs Table
		(
			PackageTypeID int
		)

Insert into @SelectedRegionIDs
Select Value from dbo.Split(@RegionIDs,',')

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')

Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')


Insert into @SelectedPackageTypeIDs
Select Value from dbo.Split(@PackageTypeIDs,',')

Insert into @SupplyChainDsdMostImpactedTrademarksByRegion (TrademarkID, TrademarkName, SAPTrademarkID)
	Select TrademarkID, TrademarkName, SAPTradeMarkID  from SAP.Trademark Where TrademarkID in (Select TrademarkID from @SelectedTrademarkIDs)
If(@MeasureType = 'OOS')
	Begin
		Update mb
				Set mb.OOS = OOSTemp.OOS,
				mb.CaseCut = OOSTemp.CaseCut
					from @SupplyChainDsdMostImpactedTrademarksByRegion as mb
				 Inner Join (Select TrademarkID, ((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0))*100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
								SupplyChain.tDsdDailyCaseCut as OOS
								Where  OOS.DateID = @DateID 
								And OOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
								And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
								And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
								And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		
								Group by OOS.TrademarkID) as OOSTemp on mb.TrademarkID = OOSTemp.TrademarkID
		Select * 
			from @SupplyChainDsdMostImpactedTrademarksByRegion as mb
				Where mb.OOS is not null	
				Order by mb.CaseCut Desc
	 End
Else If(@MeasureType = 'DOS')
	Begin
		Update mb
				Set mb.DOS = DOSTemp.DaysOfSupply
				from @SupplyChainDsdMostImpactedTrademarksByRegion as mb
				Inner Join (Select TrademarkID,Case When sum(dos.Past31DaysXferOutPlusShipment) = 0 Then 0 Else ((SUM(dos.EndingInventory)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 30 End as DaysOfSupply
 							 from SupplyChain.tDsdDailyBranchInventory as DOS 
							 Where  DOS.DateID = @DateID 
								And DOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
								And DOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
								And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
								And DOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		 
								Group by DOS.TrademarkID) as DOSTemp   on mb.TrademarkID = DOSTemp.TrademarkID
		Select * 
			from @SupplyChainDsdMostImpactedTrademarksByRegion as mb
				Where mb.DOS is not null	
				Order by mb.DOS Desc
	End
Else If(@MeasureType = 'MinMax')
	Begin
		Update mb
		Set mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle
		from @SupplyChainDsdMostImpactedTrademarksByRegion as mb
		Inner Join (Select TrademarkID
							,((SUm(minMax.IsBelowMin) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxLeft
							,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
							, ((SUm(minMax.IsAboveMax) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxRight
							from SupplyChain.tDsdDailyMinMax as minmax
							 Where  minmax.DateID = @DateID 
							 And minmax.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
							 And minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
							And minmax.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And minmax.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)	
							Group by minmax.TrademarkID
					) as minmaxTemp   on mb.TrademarkID = minmaxTemp.TrademarkID
		Select * 
			from @SupplyChainDsdMostImpactedTrademarksByRegion as mb
				Where mb.MinMaxMiddle is not null	
				Order by mb.MinMaxMiddle
	End


GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdOverAllScoresForLanding]    Script Date: 12/12/2014 5:43:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
26.SupplyChain.pGetDsdOverAllScoresForLanding
exec [SupplyChain].[pGetDsdOverAllScoresForLanding] 20141103,'3,4,5', '42,43,44,45,46,47,48,49,50,51,52', '69,192,138,29,232,221,75,9,158,195,3,12,35,129,49,190,184,67', '46,69,138,175,152,118,78,129,86,64,38,44,150,47,70,30,124', 'MinMax'
20141014,'24,25,26,27','69', '325'
exec [SupplyChain].[pGetDsdInventoryBranchMeasuresForLanding] 20141106,'1,2,3,4,5,6,7,8,9,11,12,14','1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,167,168,169,170,172,173,174', '1,3,5,20,22,33,59,35,37,60,44,61,46,49,50,51,65,67,68,34,64,89,173,54,97,129,130,154,187,216,228','22,27,30,33,38,39,44,46,47,51,59,62,63,64,67,68,77,78,79,86,90,94,108,117,124,129,133,134,138,139,140,143,145,146,150,151,152,154','DOS'
select top 10 * from sap.Package
SupplyChain.pGetDsdOverAllScoresForLanding
exec [SupplyChain].[pGetDsdOverAllScoresForLanding] 20141110,'1,5,12','5,11,84,85,160,161','47,97,194','22,32,44,46,47,67,68,78,79,124,129,138,140,150,151,152','OOS'
*/
CREATE PROC [SupplyChain].[pGetDsdOverAllScoresForLanding] (
	@DateID INT
	,@RegionIDs VARCHAR(4000)
	,@BranchIDs varchar(4000)
	,@TrademarkIDs VARCHAR(4000)
	,@PackageIDs VARCHAR(4000)
	,@MeasureType varchar(10)
	,@AggregationID INT = 0
	)
AS
SET NOCOUNT ON;

Declare @SupplyChainDsdOverAllScoresForLanding Table  
			 (  
				 ProductLineID int null
				,ProductLineName varchar(50) null
				,CaseCut int null
				,OOS Decimal(10,1) null
				,DOS Decimal(10,1) null
				,DOSCases int null
				,MinMaxLeft Decimal(10,1) null
				,MinMaxMiddle Decimal(10,1) null
				,MinMaxRight Decimal(10,1) null
				,OOSRed Decimal(10,1) null
				,OOSGreen Decimal(10,1) null
				,DOSRed Decimal(10,1) null
				,DOSGreen Decimal(10,1) null
				,MinMaxRed Decimal(10,1) null
				,MinMaxGreen Decimal(10,1) null
			 )

Declare @SelectedRegionIDs Table
		(
			RegionID int
		)

Declare @SelectedBranchIDs Table
		(
			BranchID int
		)

Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)

Declare @SelectedPackageTypeIDs Table
		(
			PackageTypeID int
		)

Insert into @SelectedRegionIDs
Select Value from dbo.Split(@RegionIDs,',')

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')

Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')


Insert into @SelectedPackageTypeIDs
Select Value from dbo.Split(@PackageIDs,',')

--- These Records are for Product Lines
Insert into @SupplyChainDsdOverAllScoresForLanding (ProductLineID, ProductLineName, OOSRed, OOSGreen, DOSRed, DOSGreen, MinMaxRed, MinMaxGreen)
	Select pl.ProductLineID, pl.ProductLineName,OAT.OverAllOOSLeftThreshold, OAT.OverAllOOSRightThreshold, OAT.OverAllDOSLeftThreshold, OAT.OverAllDOSRightThreshold, OAT.OverAllMinMaxLeftThreshold, OAT.OverAllMinMaxRightThreshold  from SAP.ProductLine as pl cross join SupplyChain.OverAllThreshold as OAT
	Union
	Select -1,'OverAll',OAT.OverAllOOSLeftThreshold, OAT.OverAllOOSRightThreshold, OAT.OverAllDOSLeftThreshold, OAT.OverAllDOSRightThreshold, OAT.OverAllMinMaxLeftThreshold, OAT.OverAllMinMaxRightThreshold  from SupplyChain.OverAllThreshold as OAT
---- This one is for Over All Scores

	If(@MeasureType = 'OOS')
		Begin
			Update mb
			Set mb.OOS = OOSTemp.OOS,
			mb.CaseCut = OOSTemp.CaseCut
				from @SupplyChainDsdOverAllScoresForLanding as mb
				Inner Join (Select ProductLineID, ((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0)) * 100  as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
							SupplyChain.tDsdDailyCaseCut as OOS
							Where  OOS.DateID = @DateID 
							And OOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
							And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
							And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		
							Group by OOS.ProductLineID
						) as OOSTemp on mb.ProductLineID = OOSTemp.ProductLineID
			Update mb
			Set mb.OOS = OOSTemp.OOS,
			mb.CaseCut = OOSTemp.CaseCut,
			mb.ProductLineID = OOSTemp.OverAllID
				from @SupplyChainDsdOverAllScoresForLanding as mb
				Inner Join (Select -1 as OverAllID, ((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0)) * 100  as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
							SupplyChain.tDsdDailyCaseCut as OOS
							Where  OOS.DateID = @DateID 
							And OOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
							And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
							And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)
						) as OOSTemp on mb.ProductLineID = OOSTemp.OverAllID


			 Select * from @SupplyChainDsdOverAllScoresForLanding
		End
	Else If(@MeasureType = 'DOS')
		Begin
			Update mb
				Set mb.DOS = DOSTemp.DaysOfSupply
					,mb.DOSCases = DOSTemp.DOSCases
				from @SupplyChainDsdOverAllScoresForLanding as mb
				Inner Join (Select  ProductLineID,Case When sum(dos.Past31DaysXferOutPlusShipment) = 0 Then 0 Else ((SUM(dos.EndingInventory)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 30 End as DaysOfSupply, SUM(dos.EndingInventory) as DOSCases
							 from SupplyChain.tDsdDailyBranchInventory as DOS 
							 Where  DOS.DateID = @DateID 
									And DOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
									And DOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
									And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
									And DOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		 
									Group by DOS.ProductLineID
							) as DOSTemp   on mb.ProductLineID = DOSTemp.ProductLineID
			Update mb
				Set mb.DOS = DOSTemp.DaysOfSupply
					,mb.DOSCases = DOSTemp.DOSCases
					,mb.ProductLineID = DOSTemp.OverAllID
				from @SupplyChainDsdOverAllScoresForLanding as mb
				Inner Join (Select  -1 as OverAllID,Case When sum(dos.Past31DaysXferOutPlusShipment) = 0 Then 0 Else ((SUM(dos.EndingInventory)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 30 End as DaysOfSupply, SUM(dos.EndingInventory) as DOSCases
							 from SupplyChain.tDsdDailyBranchInventory as DOS 
							 Where  DOS.DateID = @DateID 
									And DOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
									And DOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
									And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
									And DOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		 
									Group by DOS.ProductLineID
							) as DOSTemp   on mb.ProductLineID = DOSTemp.OverAllID
			 Select * from @SupplyChainDsdOverAllScoresForLanding
		End
		
	Else If(@MeasureType = 'MinMax')
		Begin
			Update mb
			Set  mb.MinMaxLeft = minmaxTemp.MinMaxLeft
				,mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle
				,mb.MinMaxRight = minmaxTemp.MinMaxRight
			from @SupplyChainDsdOverAllScoresForLanding as mb
			Inner Join (Select   ProductLineID
								,((SUm(minMax.IsBelowMin) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxLeft
								,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
								,((SUm(minMax.IsAboveMax) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxRight
								from SupplyChain.tDsdDailyMinMax as minmax
								 Where  minmax.DateID = @DateID 
										And minmax.RegionID in (Select RegionID from @SelectedRegionIDs)
										And minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
										And minmax.TradeMarkID in (Select TradeMarkID from @SelectedTradeMarkIDs)	
										And minmax.PackageTypeID in (Select PackageTypeID from @SelectedPackageTypeIDs)	
										Group by minmax.ProductLineID
						) as minmaxTemp   on mb.ProductLineID = minmaxTemp.ProductLineID
			Update mb
			Set mb.MinMaxLeft = minmaxTemp.MinMaxLeft
				,mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle
				,mb.MinMaxRight = minmaxTemp.MinMaxRight
				,mb.ProductLineID = minmaxTemp.OverAllID
			from @SupplyChainDsdOverAllScoresForLanding as mb
			Inner Join (Select   -1 as OverAllID
								,((SUm(minMax.IsBelowMin) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxLeft
								,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
								,((SUm(minMax.IsAboveMax) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxRight
								from SupplyChain.tDsdDailyMinMax as minmax
								 Where  minmax.DateID = @DateID 
										And minmax.RegionID in (Select RegionID from @SelectedRegionIDs)
										And minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
										And minmax.TradeMarkID in (Select TradeMarkID from @SelectedTradeMarkIDs)	
										And minmax.PackageTypeID in (Select PackageTypeID from @SelectedPackageTypeIDs)	
										Group by minmax.ProductLineID
						) as minmaxTemp   on mb.ProductLineID = minmaxTemp.OverAllID
			 Select * from @SupplyChainDsdOverAllScoresForLanding
		End



GO
/****** Object:  StoredProcedure [SupplyChain].[pGetMyPromotion]    Script Date: 12/12/2014 5:43:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [SupplyChain].[pGetMyPromotion] (          
  @LocationId VARCHAR(MAX)       
 ,@TradeMarkId VARCHAR(MAX)        
 ,@PackageId VARCHAR(MAX)        
 ,@TypeId VARCHAR(MAX)        
 ,@bool int = NULL       
 ,@StartDate DATETIME = NULL --= '12/1/2014 12:00:00 AM'--NULL --'11/1/2014 12:00:00 AM' --NULL --'10/1/2014 12:00:00 AM'            
 ,@EndDate DATETIME =NULL --'12/31/2014 12:00:00 AM'--NULL --'11/15/2014 12:00:00 AM' --NULL --'12/31/2014 12:00:00 AM'            
 ,@GSN VARCHAR(20)       
 ,@PersonaID int       
 )          
AS          
BEGIN          
 BEGIN TRY          
  DECLARE @LastweekStartDate DATE          
   ,@LastweekEndDate DATE          
   ,@NextweekStartDate DATE          
   ,@NextweekEndDate DATE          
   ,@ClosedLastweek INT          
   ,@Ongoing INT          
   ,@StartingNextWeek INT          
   ,@SubQuery VARCHAR(max) = ''          
   ,@Query VARCHAR(max) = ''          
   ,@IsMyAccountQuery VARCHAR(max) = ''          
   ,@JOINPromotionGeoHier VARCHAR(max) = '';
          
  CREATE TABLE #Durationtemp (          
   LastweekStartDate DATETIME          
   ,LastweekEndDate DATETIME          
   ,NextweekStartDate DATETIME          
   ,NextweekEndDate DATETIME          
   ,CurrentWeekStart DATETIME          
   ,CurrentWeekEnd DATETIME          
   );          
          
  CREATE TABLE #Counttemp (RecordCount INT);          
          
  CREATE TABLE #PromotionIDtemp (PromotionID INT);          
          
  -----------Last Week Date and Next Week Date Set-------------------                            
  INSERT INTO #Durationtemp (          
   LastweekStartDate          
   ,LastweekEndDate          
   ,NextweekStartDate          
   ,NextweekEndDate          
   ,CurrentWeekStart          
   ,CurrentWeekEnd          
   )          
  SELECT Dateadd(dd, - (Datepart(dw, getdate())) - 5, getdate()) [LastweekStartDate]          
   ,Dateadd(dd, - (Datepart(dw, getdate())) + 1, getdate()) [LastweekEndDate]          
   ,Dateadd(dd, (9 - Datepart(dw, getdate())), getdate()) [NextweekStartDate]          
   ,Dateadd(dd, 15 - (Datepart(dw, getdate())), getdate()) [NextweekEndDate]          
   ,DATEADD(DAY, 1 - DATEPART(WEEKDAY, GETDATE()), CAST(GETDATE() AS DATE)) [CurrentWeekStart]          
   ,DATEADD(DAY, 7 - DATEPART(WEEKDAY, GETDATE()), CAST(GETDATE() AS DATE)) [CurrentWeekEnd];          
          
  -- For Is My Account      
                 
  DECLARE @SPUserPRofileID INT                              
  SELECT @SPUserPRofileID = SPUserprofileid                              
  FROM Person.SPUserPRofile                              
  WHERE GSn = @GSN AND personaid = @PersonaID                             
  SELECT DISTINCT b.LocalChainID                              
   ,b.RegionalChainID                              
   ,b.NationalChainID                              
  INTO #UserAccount                              
  FROM Person.UserAccount a                              
  LEFT JOIN mview.ChainHier b ON (                              
    a.LocalChainID = b.LocalChainID                              
    OR a.RegionalChainID = b.RegionalChainID                              
    OR a.NationalChainID = b.NationalChainID                              
    )                              
  WHERE a.SPUserPRofileID = @SPUserPRofileID       
                  
  ----------------------------------------------------------------------------                            
  ---------Query Prepare regarding LocationID,TradeMarkID,PackageID--------                   
  IF (ISNULL(@bool, 0) <> 0)          
  BEGIN          
   -- Promotion IDs --                  
   DECLARE @LOCAL_startdate DATETIME;          
   DECLARE @LOCAL_enddate DATETIME;          
          
   SET @LOCAL_startdate = @StartDate;          
   SET @LOCAL_enddate = @EndDate;          
          
   INSERT INTO #PromotionIDtemp (PromotionID)          
   SELECT DISTINCT Rprmtn.PromotionID          
   FROM Playbook.Retailpromotion Rprmtn          
   JOIN Playbook.Promotionbrand Pbrand ON Rprmtn.PromotionID = Pbrand.PromotionID          
   JOIN Playbook.promotionPackage Ppackage ON Rprmtn.PromotionID = Ppackage.PromotionID          
   JOIN Playbook.PromotionGeoRelevancy PromGeo ON Rprmtn.PromotionID = PromGeo.PromotionID
   JOIN mview.LocationHier mviewLoc ON PromGeo.RegionID = mviewLoc.RegionId          
    OR PromGeo.BranchId = mviewLoc.BranchId          
    OR PromGeo.BUID = mviewLoc.BUID          
    OR PromGeo.AreaId = mviewLoc.AreaId
   JOIN [Playbook].[PromotionGeoHier] PGeoHier on  PGeoHier.PromotionId = Rprmtn.PromotionID
   WHERE PGeoHier.BranchId = @LocationId          
    AND Pbrand.TrademarkID IN (          
     SELECT value          
     FROM [CDE].[udfSplit](@TradeMarkId, ',')          
     )          
    AND Ppackage.PackageID IN (          
     SELECT value          
     FROM [CDE].[udfSplit](@PackageId, ',')          
     )      
    AND Rprmtn.PromotionStatusID = 4          
    AND (      
      --@LOCAL_startdate BETWEEN Rprmtn.PromotionStartDate AND Rprmtn.PromotionEndDate        
      --OR Rprmtn.PromotionRelevantStartdate BETWEEN @LOCAL_startdate AND @LOCAL_enddate        
      --OR Rprmtn.PromotionRelevantEnddate BETWEEN @LOCAL_startdate AND @LOCAL_enddate           
     Convert(Date,Rprmtn.PromotionStartDate) <= Convert(Date,@LOCAL_enddate)--@LOCAL_enddate /*Quater End Date   PromotionStartDate  */      
     AND Convert(Date,Rprmtn.PromotionEndDate) >= Convert(Date,@LOCAL_startdate )--@LOCAL_startdate /*Quater Start Date  PromotionEndDate */          
     )          
    --IsMyAccount              
    AND (Rprmtn.PromotionGroupID = 1               
    AND 1 = CASE               
      WHEN (SELECT TOP 1 1                     
          FROM PlayBook.PromotionAccountHier AS account                              
          WHERE account.PromotionID = Rprmtn.PromotionID                              
          and account.LocalChainID IN (SELECT uAccount.LocalChainID FROM #UserAccount uAccount)) =1 THEN 1                              
          ELSE 0              
      END               
   )      
                              
   SELECT PromotionID          
   FROM #PromotionIDtemp          
  END          
  ELSE          
   -- Promotion Count --              
  BEGIN          
   SET @IsMyAccountQuery = 'AND (Rprmtn.PromotionGroupID = 1 AND 1 = CASE WHEN (SELECT TOP 1 1 FROM PlayBook.PromotionAccountHier AS account WHERE account.PromotionID = Rprmtn.PromotionID and account.LocalChainID IN (SELECT uAccount.LocalChainID FROM #UserAccount uAccount)) =1 THEN 1 ELSE 0 END )'
   SET @JOINPromotionGeoHier = 'JOIN [Playbook].[PromotionGeoHier] PGeoHier on  PGeoHier.PromotionId = Rprmtn.PromotionID '
          
   IF (Isnull(@LocationId, '') != '0')          
   BEGIN          
    IF (Isnull(@TypeId, '') != '0')          
    BEGIN          
     IF (@TypeId = 1)          
     BEGIN          
      SET @SubQuery += ' and mviewLoc.RegionId IN (SELECT value FROM [CDE].[udfSplit](''' + @LocationId + ''','',''))';          
     END          
     ELSE IF (@TypeId = 2)          
     BEGIN          
      SET @SubQuery += ' and PGeoHier.BranchId IN (SELECT value FROM [CDE].[udfSplit](''' + @LocationId + ''','',''))';          
     END          
    END          
   END          
          
   IF (ISNULL(@TradeMarkId, '') != '0')          
   BEGIN          
    --SET @SubQuery += ' and Pbrand.TrademarkID=' + Convert(VARCHAR(100), @TradeMarkId) + ' ';                        
    SET @SubQuery += ' and Pbrand.TrademarkID IN (SELECT value FROM [CDE].[udfSplit](''' + @TradeMarkId + ''','',''))';          
   END          
          
   IF (ISNULL(@PackageId, '') != '0')          
   BEGIN          
    SET @SubQuery += ' and Ppackage.PackageID IN (SELECT value FROM [CDE].[udfSplit](''' + @PackageId + ''','',''))';          
   END          
   
   IF (@TypeId = 1)          
   BEGIN        
	   SET @Query = ' Select Count(distinct Rprmtn.PromotionID)  from Playbook.Retailpromotion Rprmtn join Playbook.Promotionbrand Pbrand  on Rprmtn.PromotionID=Pbrand.PromotionID  join Playbook.promotionPackage Ppackage on Rprmtn.PromotionID=Ppackage.PromotionID           
	   join Playbook.PromotionGeoRelevancy PromGeo on Rprmtn.PromotionID= PromGeo.PromotionID JOIN mview.LocationHier mviewLoc ON PromGeo.RegionID=mviewLoc.RegionId OR PromGeo.BranchId=mviewLoc.BranchId OR PromGeo.BUID=mviewLoc.BUID OR PromGeo.AreaId=mviewLoc.AreaId            
	   Where Convert(Date,Rprmtn.PromotionEndDate)>=Convert(Date,(Select Top 1 LastweekStartDate from #Durationtemp )) and Convert(Date,Rprmtn.PromotionEndDate)<=Convert(Date,(Select Top 1 LastweekEndDate from #Durationtemp )) and Rprmtn.PromotionStatusID =4'+ @SubQuery + '' + @IsMyAccountQuery + ' ';
   END
   ELSE IF (@TypeId=2)
   BEGIN
	   SET @Query = ' Select Count(distinct Rprmtn.PromotionID)  from Playbook.Retailpromotion Rprmtn join Playbook.Promotionbrand Pbrand  on Rprmtn.PromotionID=Pbrand.PromotionID  join Playbook.promotionPackage Ppackage on Rprmtn.PromotionID=Ppackage.PromotionID           
	   JOIN Playbook.PromotionGeoRelevancy PromGeo on Rprmtn.PromotionID= PromGeo.PromotionID JOIN mview.LocationHier mviewLoc ON PromGeo.RegionID=mviewLoc.RegionId OR PromGeo.BranchId=mviewLoc.BranchId OR PromGeo.BUID=mviewLoc.BUID OR PromGeo.AreaId=mviewLoc.AreaId
	   JOIN [Playbook].[PromotionGeoHier] PGeoHier on  PGeoHier.PromotionId = Rprmtn.PromotionID
	   Where Convert(Date,Rprmtn.PromotionEndDate)>=Convert(Date,(Select Top 1 LastweekStartDate from #Durationtemp )) and Convert(Date,Rprmtn.PromotionEndDate)<=Convert(Date,(Select Top 1 LastweekEndDate from #Durationtemp )) and Rprmtn.PromotionStatusID =4'+ @SubQuery + '' + @IsMyAccountQuery + ' ';
   END
   DELETE          
   FROM #Counttemp          
          
   PRINT @Query;          
          
   INSERT INTO #Counttemp (RecordCount)          
   EXEC (@Query);          
          
   SELECT @ClosedLastweek = RecordCount          
   FROM #Counttemp;          
   
   IF (@TypeId = 1)          
   BEGIN       
	   SET @Query = ' Select Count(distinct Rprmtn.PromotionID)  from Playbook.Retailpromotion Rprmtn join Playbook.Promotionbrand Pbrand on Rprmtn.PromotionID=Pbrand.PromotionID join Playbook.promotionPackage Ppackage on Rprmtn.PromotionID=Ppackage.PromotionID        
	   join Playbook.PromotionGeoRelevancy PromGeo on Rprmtn.PromotionID= PromGeo.PromotionID  JOIN mview.LocationHier mviewLoc ON PromGeo.RegionID=mviewLoc.RegionId OR PromGeo.BranchId=mviewLoc.BranchId OR PromGeo.BUID=mviewLoc.BUID OR PromGeo.AreaId=mviewLoc.AreaId        
	   Where Convert(Date,Rprmtn.PromotionEndDate)>=Convert(Date,(Select Top 1 CurrentWeekStart from #Durationtemp )) and Convert(Date,Rprmtn.PromotionStartDate)<= Convert(Date,(Select Top 1 CurrentWeekEnd from #Durationtemp)) and Rprmtn.PromotionStatusID =4'+@SubQuery + '' + @IsMyAccountQuery + ' ';              
   END
   ELSE IF(@TypeId=2)
   BEGIN
	   SET @Query = ' Select Count(distinct Rprmtn.PromotionID)  from Playbook.Retailpromotion Rprmtn join Playbook.Promotionbrand Pbrand on Rprmtn.PromotionID=Pbrand.PromotionID join Playbook.promotionPackage Ppackage on Rprmtn.PromotionID=Ppackage.PromotionID        
	   JOIN Playbook.PromotionGeoRelevancy PromGeo on Rprmtn.PromotionID= PromGeo.PromotionID  JOIN mview.LocationHier mviewLoc ON PromGeo.RegionID=mviewLoc.RegionId OR PromGeo.BranchId=mviewLoc.BranchId OR PromGeo.BUID=mviewLoc.BUID OR PromGeo.AreaId=mviewLoc.AreaId        
	   JOIN [Playbook].[PromotionGeoHier] PGeoHier on  PGeoHier.PromotionId = Rprmtn.PromotionID
	   Where Convert(Date,Rprmtn.PromotionEndDate)>=Convert(Date,(Select Top 1 CurrentWeekStart from #Durationtemp )) and Convert(Date,Rprmtn.PromotionStartDate)<= Convert(Date,(Select Top 1 CurrentWeekEnd from #Durationtemp)) and Rprmtn.PromotionStatusID =4'+@SubQuery + '' + @IsMyAccountQuery + ' ';
   END       
   DELETE          
   FROM #Counttemp          
          
   PRINT @Query;          
          
   INSERT INTO #Counttemp (RecordCount)          
   EXEC (@Query);          
          
   SELECT @Ongoing = RecordCount          
   FROM #Counttemp;          
   
   IF (@TypeId = 1)          
   BEGIN       
	   SET @Query = ' Select Count(distinct Rprmtn.PromotionID)  from Playbook.Retailpromotion Rprmtn join Playbook.Promotionbrand Pbrand  on Rprmtn.PromotionID=Pbrand.PromotionID  join Playbook.promotionPackage Ppackage on Rprmtn.PromotionID=Ppackage.PromotionID join                       
		Playbook.PromotionGeoRelevancy PromGeo on Rprmtn.PromotionID= PromGeo.PromotionID JOIN mview.LocationHier mviewLoc ON PromGeo.RegionID=mviewLoc.RegionId OR PromGeo.BranchId=mviewLoc.BranchId OR PromGeo.BUID=mviewLoc.BUID OR PromGeo.AreaId=mviewLoc.AreaId       
		Where Convert(Date,Rprmtn.PromotionStartDate)>=Convert(Date,(Select Top 1 NextweekStartDate from #Durationtemp )) and Convert(Date,Rprmtn.PromotionStartDate)<=Convert(Date,(Select Top 1 NextweekEndDate from #Durationtemp )) and Rprmtn.PromotionStatusID= 4' + @SubQuery + '' + @IsMyAccountQuery + ' ';              
   END   
   ELSE IF(@TypeId=2)
   BEGIN
		SET @Query = ' Select Count(distinct Rprmtn.PromotionID)  from Playbook.Retailpromotion Rprmtn join Playbook.Promotionbrand Pbrand  on Rprmtn.PromotionID=Pbrand.PromotionID  join Playbook.promotionPackage Ppackage on Rprmtn.PromotionID=Ppackage.PromotionID
		JOIN Playbook.PromotionGeoRelevancy PromGeo on Rprmtn.PromotionID= PromGeo.PromotionID JOIN mview.LocationHier mviewLoc ON PromGeo.RegionID=mviewLoc.RegionId OR PromGeo.BranchId=mviewLoc.BranchId OR PromGeo.BUID=mviewLoc.BUID OR PromGeo.AreaId=mviewLoc.AreaId
		JOIN [Playbook].[PromotionGeoHier] PGeoHier on  PGeoHier.PromotionId = Rprmtn.PromotionID       
		Where Convert(Date,Rprmtn.PromotionStartDate)>=Convert(Date,(Select Top 1 NextweekStartDate from #Durationtemp )) and Convert(Date,Rprmtn.PromotionStartDate)<=Convert(Date,(Select Top 1 NextweekEndDate from #Durationtemp )) and Rprmtn.PromotionStatusID= 4' + @SubQuery + '' + @IsMyAccountQuery + ' ';              
   END    
   DELETE          
   FROM #Counttemp;          
          
   PRINT @Query;          
          
   INSERT INTO #Counttemp (RecordCount)          
   EXEC (@Query);          
          
   SELECT @StartingNextWeek = RecordCount          
   FROM #Counttemp;          
          
   SELECT @ClosedLastweek [ClosedLastWeekValue]          
    ,@Ongoing [OngoingValue]          
    ,@StartingNextWeek [StartingNextWeekValue]          
  END          
 END TRY          
          
 BEGIN CATCH          
  SELECT Error_Message() [Error Message];          
 END CATCH          
END     
    
--GO          
--  SupplyChain.pGetMyPromotion          
--  @LocationId ='88'          
-- ,@TradeMarkId ='4,5,6,7,11,12,94,95,96,98,104,2,1,3,16,10,19,28,54,97,125,129,130,133,137,154,175,187,192,216,228'          
-- ,@PackageId='3,4,6,8,12,13,17,18,19,20,21,22,24,25,26,27,29,30,31,32,34,38,39,40,41,43,44,46,47,50,51,52,54,55,58,59,60,61,62,63,64,65,66,67,68,71,72,74,77,78,79,80,82,84,85,86,87,88,90,91,92,93,94,95,96,97,98,100,101,103,105,106,108,109,110,112,113,117,118,119,120,124,126,127,128,129,133,134,135,136,137,138,139,140,141,142,143,145,146,150,151,152,153,154,157,158,159,160,162,163,164,165,166,169,172,173,177,179,180'           
-- ,@TypeId=2           
-- ,@bool = 1--NULL           
-- ,@StartDate  ='10/1/2014 12:00:00 AM'--= NULL --= '12/1/2014 12:00:00 AM'--NULL --'11/1/2014 12:00:00 AM' --NULL --'10/1/2014 12:00:00 AM'                
-- ,@EndDate  ='12/31/2014 12:00:00 AM'--=NULL --'12/31/2014 12:00:00 AM'--NULL --'11/15/2014 12:00:00 AM' --NULL --'12/31/2014 12:00:00 AM'                
-- ,@GSN ='tessc001'          
-- ,@PersonaID =6
GO
