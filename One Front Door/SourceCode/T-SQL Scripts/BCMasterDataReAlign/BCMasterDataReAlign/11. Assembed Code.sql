use Portal_Data_INT
Go

--*********************************************************
--1. Full load of BCStore ---------------------------------
--*********************************************************
Set NoCount On;
Declare @LastLoadTime DateTime
Declare @LogID bigint 
Declare @OPENQUERY nvarchar(4000)
Declare @RecordCount int
Declare @LastRecordDate DateTime

Truncate Table Staging.BCStore

Select @LastLoadTime = '2013-1-1'

Insert ETL.BCDataLoadingLog([SchemaName], [TableName], [StartDate])
Values ('Staging', 'BCStore', GetDate())

Select @LogID = SCOPE_IDENTITY()

----------------------------------------
Set @OPENQUERY = BC.udf_SetOpenQuery('SELECT 
	D.STR_ID, 
	D.PARTNER_GUID, 
	D.STR_NM, 
	D.STR_OPEN_DT, 
	D.STR_CLOSE_DT, 
	D.TDLINX_ID, 
	D.FORMAT, 
	D.LATITUDE, 
	D.LONGITUDE, 
	D.LAT_LON_PREC_COD, 
	D.CHNL_CODE, 
	D.CHNL_DESC, 
	D.CHAIN_TYPE, 
	D.ERH_LVL_4_NODE_ID, 
	D.EXT_STR_STTS_IND, D.GLOBAL_STTS, 
	D.DEL_FLG, 
	D.CRM_LOCAL_FLG,
	D.ROW_MOD_DT 
	FROM CAP_DM.DM_STR D', 'COP', @LastLoadTime, 'D')
Set @OPENQUERY = Replace(@OpenQuery, 'Select *', 'Insert Into Staging.BCStore Select *')
----------------------------------------
Exec (@OPENQUERY)

Select @RecordCount = Count(*) From Staging.BCStore

Select @LastRecordDate = Max(ROW_MOD_DT) From Staging.BCStore

Update ETL.BCDataLoadingLog 
Set EndDate = GetDate(), NumberOfRecordsLoaded = @RecordCount, LatestLoadedRecordDate = @LastRecordDate
Where LogID = @LogID
Go

Print 'Full Load of CAP_DM.DM_STR Completed' 
Go

--*********************************************************
--2. Modify SAP.Account ---------------------------------
--*********************************************************
Alter Table SAP.Account
Add CRMStoreOpenDate Date

Alter Table SAP.Account
Add CRMStoreCloseDate Date

Alter Table SAP.Account
Add CRMLocal Bit

Alter Table SAP.Account
Add CRMDeleted Bit
Go

---- Columns for archiving data ---
Alter Table SAP.Account
Add LocalChainID1 int
Go

Alter Table SAP.Account
Add ChannelID1 int
Go

Alter Table SAP.Account
Add Longitude1 Decimal(10,6)
Go

Alter Table SAP.Account
Add Latitude1 Decimal(10,6)
Go

Alter Table SAP.Account
Add GeoSource1 Varchar (5)
Go

Alter Table SAP.Account
Add GeoCodingNeeded1 bit
Go

Alter Table SAP.Account
Add CapstoneChecksum int
Go

Alter Table SAP.Account
Add InBW bit default 0
Go

Alter Table SAP.Account
Add StoreLastModified DateTime
Go
-------------------------

Update SAP.Account
Set StoreLastModified = LastModified
Go

-------------------------
-------------------------
Update SAP.Account
Set LocalChainID1 = LocalChainID,
	ChannelID1 = ChannelID,
	Latitude1 = Latitude,
	Longitude1 = Longitude,
	GeoSource1 = GeoSource,
	GeoCodingNeeded1 = GeoCodingNeeded
Go

CREATE UNIQUE NONCLUSTERED INDEX [UNCI-Account-SAPAccountNumber] ON [SAP].[Account]
(
	[SAPAccountNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

Print 'SAP.Account table changes Completed' 
Go

--*********************************************************
--3. Update pMergeChainAccount SP ---------------------------------
--*********************************************************
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- exec ETL.pMergeChainsAccounts --

ALTER Proc [ETL].[pMergeChainsAccounts]
AS		
	Set NoCount On;
--- ======================================================================================
--- Change Log (Most recent on top):
--- Date       INIT  Change Descrition
--- ---------- ----- ---------------------------------------------------------------------
--- 2015-06-06 YWU - Updated Capstone account update logic to include Geo, chain and channel
--- 2015-05-28 KTY - Added CAST() and IsNull() to Checksum()
--- 2015-05-25 KTY - Create and populate [SAP].[InternationalChain] table
--- ======================================================================================
    Set NoCount On;
    ----------------------------------------
    --- SAP.InternationalChain ---- Need to have the active flag
    ----------------------------------------
    MERGE SAP.InternationalChain AS pc
        USING (
            Select Distinct h.L1_NODE_ID NODE_ID, dbo.udf_TitleCase(h.L1_NODE_DESC) NODE_DESC, n.ROW_MOD_DT
                ,ChangeTrackNumber_New  = Checksum(CAST(h.L1_NODE_ID AS INT), dbo.udf_TitleCase(h.L1_NODE_DESC))
                ,ChangeTrackNumber_Old  = ic.ChangeTrackNumber
            From Processing.BCvStoreERHSDM h 
            Join Processing.BCChainLastModified n  on n.NODE_ID                  = h.L1_NODE_ID
            Left Join SAP.InternationalChain    ic on ic.SAPInternationalChainID = h.L1_NODE_ID
            WHERE ic.ChangeTrackNumber IS NULL
               OR Checksum(CAST(h.L1_NODE_ID AS INT), dbo.udf_TitleCase(h.L1_NODE_DESC)) <> ic.ChangeTrackNumber
            ) AS input
            ON pc.SAPInternationalChainID = input.NODE_ID
    WHEN MATCHED THEN
        UPDATE SET pc.InternationalChainName = input.NODE_DESC,
                   pc.ChangeTrackNumber      = input.ChangeTrackNumber_New,
                   pc.CapstoneLastModified   = input.ROW_MOD_DT,
                   pc.InCapstone   = 1,
                   pc.LastModified = GETDATE()
    WHEN NOT MATCHED By Target THEN
        INSERT(SAPInternationalChainID, InternationalChainName, ChangeTrackNumber, LastModified, InCapstone, CapstoneLastModified)
        VALUES(input.NODE_ID, input.NODE_DESC, input.ChangeTrackNumber_New, GetDate(), 1, input.ROW_MOD_DT);
    --- ------------------------------------------------------------------

	UPDATE SAP.InternationalChain
	SET InternationalChainName   = 'CVS/Pharmacy'
	WHERE InternationalChainName = 'Cvs/Pharmacy';

	UPDATE SAP.InternationalChain
	SET InternationalChainName   = 'Walmart US'
	WHERE InternationalChainName = 'Walmart Us';

    ----------------------------------------
    --- SAP.NationalChain ---- Need to have the active flag
    --- Need to update the BW ETL Code in the same release ---
    ----------------------------------------
    MERGE SAP.NationalChain AS pc
        USING (
            Select DISTINCT
                 h.L2_NODE_ID NODE_ID
				,Replace(Replace(dbo.udf_TitleCase(h.L2_NODE_DESC), 'Cvs/Pharmacy', 'CVS/Pharmacy'), 'Walmart Us', 'Walmart US') NODE_DESC
                ,n.ROW_MOD_DT
                ,ic.InternationalChainID
              --,ChangeTrackNumber_New  = Checksum(IsNull(nc.InternationalChainID, -1), CAST(h.L2_NODE_ID AS INT), dbo.udf_TitleCase(h.L2_NODE_DESC))
				,ChangeTrackNumber_New  = Checksum(nc.InternationalChainID
                                                  ,CAST(h.L2_NODE_ID AS INT)
                                                  ,Replace(Replace(dbo.udf_TitleCase(h.L2_NODE_DESC), 'Cvs/Pharmacy', 'CVS/Pharmacy'), 'Walmart Us', 'Walmart US'))
                ,ChangeTrackNumber_Old  = nc.ChangeTrackNumber
            From Processing.BCvStoreERHSDM h 
            Join Processing.BCChainLastModified n  on n.NODE_ID                  = h.L2_NODE_ID
            Join SAP.InternationalChain         ic on ic.SAPInternationalChainID = h.L1_NODE_ID
            LEFT JOIN SAP.NationalChain         nc ON nc.SAPNationalChainID      = h.L2_NODE_ID
            WHERE nc.ChangeTrackNumber IS NULL
             --OR Checksum(IsNull(nc.InternationalChainID, -1), CAST(h.L2_NODE_ID AS INT), dbo.udf_TitleCase(h.L2_NODE_DESC)) <> nc.ChangeTrackNumber
			   OR Checksum(nc.InternationalChainID
                          ,CAST(h.L2_NODE_ID AS INT)
                          ,Replace(Replace(dbo.udf_TitleCase(h.L2_NODE_DESC), 'Cvs/Pharmacy', 'CVS/Pharmacy'), 'Walmart Us', 'Walmart US')
                          ) <> nc.ChangeTrackNumber
            ) AS input
            ON pc.SAPNationalChainID = input.NODE_ID
    WHEN MATCHED THEN
        UPDATE SET pc.InternationalChainID = input.InternationalChainID,
                   pc.NationalChainName    = input.NODE_DESC,
                   pc.ChangeTrackNumber    = input.ChangeTrackNumber_New,
                   pc.CapstoneLastModified = input.ROW_MOD_DT,
                   pc.InCapstone = 1
    WHEN NOT MATCHED By Target THEN
        INSERT(SAPNationalChainID, NationalChainName, ChangeTrackNumber, LastModified, InCapstone, CapstoneLastModified, InternationalChainID)
        VALUES(input.NODE_ID, input.NODE_DESC, input.ChangeTrackNumber_New, GetDate(), 1, input.ROW_MOD_DT, input.InternationalChainID);
    --- ------------------------------------------------------------------

    ----------------------------------------
    --- SAP.RegionalChain ----
    --- Need to update the BW ETL Code in the same release ---
    ----------------------------------------
    MERGE SAP.RegionalChain AS pc
        USING ( Select Distinct nc.NationalChainID, h.L3_NODE_ID NODE_ID, dbo.udf_TitleCase(h.L3_NODE_DESC) NODE_DESC, n.ROW_MOD_DT
                From Processing.BCvStoreERHSDM  h 
                Join Processing.BCChainLastModified n on h.L3_NODE_ID = n.NODE_ID
                Join SAP.NationalChain nc on h.L2_NODE_ID = nc.SAPNationalChainID
                ) AS input
            ON pc.SAPRegionalChainID = input.NODE_ID
    WHEN MATCHED THEN
        UPDATE SET pc.CapstoneLastModified = input.ROW_MOD_DT,
                   pc.InCapstone = 1
    WHEN NOT MATCHED By Target THEN
        INSERT(SAPRegionalChainID, RegionalChainName, NationalChainID, ChangeTrackNumber, LastModified, InCapstone, CapstoneLastModified)
        VALUES(input.NODE_ID, input.NODE_DESC, input.NationalChainID, Checksum(input.NationalChainID, input.NODE_ID, input.NODE_DESC), GetDate(), 1, input.ROW_MOD_DT);

    ----------------------------------------
    --- SAP.LocalChain ----
    --- Need to update the BW ETL Code in the same release ---
    ----------------------------------------
    MERGE SAP.LocalChain AS pc
    USING ( Select Distinct nc.RegionalChainID, h.L4_NODE_ID NODE_ID, dbo.udf_TitleCase(h.L4_NODE_DESC) NODE_DESC, n.ROW_MOD_DT
            From Processing.BCvStoreERHSDM  h 
            Join Processing.BCChainLastModified n on h.L4_NODE_ID = n.NODE_ID
            Join SAP.RegionalChain nc on h.L3_NODE_ID = nc.SAPRegionalChainID
            ) AS input
        ON pc.SAPLocalChainID = input.NODE_ID
    WHEN MATCHED THEN
    UPDATE SET pc.CapstoneLastModified = input.ROW_MOD_DT,
               pc.InCapstone = 1
    WHEN NOT MATCHED By Target THEN
    INSERT(SAPLocalChainID, LocalChainName, RegionalChainID, ChangeTrackNumber, LastModified, InCapstone, CapstoneLastModified)
    VALUES(input.NODE_ID, input.NODE_DESC, input.RegionalChainID, Checksum(input.RegionalChainID, input.NODE_ID, input.NODE_DESC), GetDate(), 1, input.ROW_MOD_DT);

    ----------------------------------------
	----------------------------------------
	Declare @LogID int

	Select @LogID = Max(LogID)
	From ETL.BCDataLoadingLog
	Where SchemaName = 'Staging' 
	And TableName = 'BCStoreHier'

	Update ETL.BCDataLoadingLog
	Set MergeDate = GetDate()
	Where  LogID = @LogID

	----------------------------------------
	--- SAP.Account ----
	----------------------------------------
	MERGE SAP.Account AS pc
	USING (	Select 
			s.STR_ID,
			dbo.udf_TitleCase(s.STR_NM) STR_NM, 
			s.ROW_MOD_DT CapstoneLastModified,
			s.Format,
			s.Latitude,
			s.Longitude,
			s.TDLinx_ID,
			1 IsCapstoneStore,
			'Cap' GeoSource,
			c.ChannelID,
			s.CHNL_CODE,
			lc.LocalChainID,
			STR_OPEN_DT,
			STR_CLOSE_DT,
			DEL_FLG,
			CRM_LOCAL_FLG
			From staging.BCStore s
			Left Join SAP.Channel c on s.CHNL_CODE = SAPChannelID
			Left Join SAP.LocalChain lc on lc.SAPLocalChainID = s.ERH_LVL_4_NODE_ID
			) AS input
		ON pc.SAPAccountNumber = input.STR_ID
	WHEN MATCHED THEN
		UPDATE SET pc.CapstoneLastModified = input.CapstoneLastModified,
		/* SAPAccountNumber, AccountName, ChannelID, LocalChainID, 
		Address, City, STATE, PostalCode, PhoneNumber, Format, TDLinxID, CRMActive
		Longitude, Latitude
		--- BranchID, Active, Contact Should be taking care of by the BW source
		*/
					pc.AccountName = input.STR_NM,
					pc.InCapstone = 1,
					Format = input.Format,
					TDLinxID = input.TDLinx_ID,
					Latitude = input.Latitude,
					Longitude = input.Longitude,
					GeoSource = input.GeoSource,
					GeoCodingNeeded = 0,
					LocalChainID = input.LocalChainID,
					ChannelID = input.ChannelID,
					CRMStoreOpenDate = input.STR_OPEN_DT,
					CRMStoreCloseDate = input.STR_CLOSE_DT,
					CRMDeleted = Case When input.DEL_FLG = 'Y' Then 1 Else 0 End,
					CRMLocal = Case When input.CRM_LOCAL_FLG = 'X' Then 1 Else 0 End
	WHEN NOT MATCHED By Target THEN
		INSERT([SAPAccountNumber],[AccountName],[ChannelID],[LocalChainID]
		,[Longitude],[Latitude]
		,[LastModified], Format 
		,[TDLinxID],[CapstoneLastModified],GEOSource,[InCapstone]
		,CRMStoreOpenDate, CRMStoreCloseDate,CRMDeleted, CRMLocal)
		VALUES(input.STR_ID, STR_NM, input.ChannelID, input.LocalChainID
		,input.Latitude, input.Longitude
		,input.CapstoneLastModified, input.Format 
		,input.TDLinx_ID, input.CapstoneLastModified, input.GeoSource, 1
		,input.STR_OPEN_DT,input.STR_CLOSE_DT
		,Case When input.DEL_FLG = 'Y' Then 1 Else 0 End
		,Case When input.CRM_LOCAL_FLG = 'X' Then 1 Else 0 End);

	Update SAP.Account
	SEt CRMActive = 
		(Case When
			--- Not in Capstone, so the column value is not relevant
			IsNull(InCapstone, 0) = 0 Then Null 
			--- In Capstone and CRM Active
			When
			InCapstone = 1 
			And GetDate() Between CRMStoreOpenDate And CRMStoreCloseDate 
			And CRMDeleted = 0 
			And CRMLocal = 1 Then 1 
			Else 0 -- In Capstone But Not CRM Active
			End
		)

	------------------------------------------
	------------------------------------------
	Select @LogID = Max(LogID)
	From ETL.BCDataLoadingLog
	Where SchemaName = 'Staging' 
	And TableName = 'BCStore'

	Update ETL.BCDataLoadingLog
	Set MergeDate = GetDate()
	Where  LogID = @LogID

	------------------------------------------
	MERGE SAP.Account AS pc
	USING (	Select 
			dbo.udf_TitleCase(Case When a.[ADDR_LINE_1] like 'xxx%' Then Null Else a.[ADDR_LINE_1] End) ADDR_LINE_1,
			dbo.udf_TitleCase(Case When a.[ADDR_CITY] = 'xxx%' Then Null Else a.[ADDR_CITY] End) ADDR_CITY,
			dbo.udf_TitleCase(a.ADDR_CNTY_NM) ADDR_CNTY_NM,
			a.ADDR_CNTRY_CODE,
			a.ADDR_REGION_ABRV,
			a.ADDR_PSTL_CODE,
			a.EMAIL,
			a.PHN_NBR,
			a.ROW_MOD_DT AddressLastModified,
			cty.CountyID,
			a.BP_ID
			From Staging.BCBPAddress a
			Left Join Shared.County cty on cty.BCCountryCode = a.ADDR_CNTRY_CODE And cty.BCRegionFIPS = a.ADDR_REGION_FIPS And cty.BCCountyFIPS = a.ADDR_CNTY_FIPS
			) AS input
		ON pc.SAPAccountNumber = input.BP_ID 
	WHEN MATCHED THEN Update Set
		PostalCode = IsNull(PostalCode, input.ADDR_PSTL_CODE),  -- keep BW PostalCode if some value is provided
		TMPostalCode = input.ADDR_PSTL_CODE,
		Address = IsNull(Input.ADDR_LINE_1, Address), 
		City = IsNull(input.ADDR_CITY, City),
		CountyID = input.CountyID,
		State = IsNull(input.ADDR_REGION_ABRV, State),
		CountryCode = IsNull(input.ADDR_CNTRY_CODE, CountryCode),
		PhoneNumber = IsNull(input.PHN_NBR, PhoneNumber),
		AddressLastModified = input.AddressLastModified,
		GeoCodingNeeded = 0;

	UPDATE SAP.Account
	SET CapstoneChecksum = CHECKSUM(SAPAccountNumber, AccountName, ChannelID, LocalChainID, 
		Address, City, STATE, PostalCode, PhoneNumber, Format, TDLinxID, CRMActive,
		Longitude, Latitude, GeoSource)
		,LastModified = GetDate(), StoreLastModified = GetDate()
	WHERE isnull(CapstoneChecksum, 0) != CHECKSUM(SAPAccountNumber, AccountName, ChannelID, LocalChainID, 
		Address, City, STATE, PostalCode, PhoneNumber, Format, TDLinxID, CRMActive,
		Longitude, Latitude, GeoSource)
	And IsNUll(InCapstone,0) = 1

	--Select CHECKSUM(SAPAccountNumber, AccountName, ChannelID, LocalChainID, 
	--	Address, City, STATE, PostalCode, PhoneNumber, Format, TDLinxID, CRMActive,
	--	Longitude, Latitude, GeoSource) Cal, CapstoneChecksum
	--From SAP.Account 
	--Where IsNUll(InCapstone,0) = 1

	------------------------------------------
	------------------------------------------
	Select @LogID = Max(LogID)
	From ETL.BCDataLoadingLog
	Where SchemaName = 'Staging' 
	And TableName = 'BCBPAddress'

	Update ETL.BCDataLoadingLog
	Set MergeDate = GetDate()
	Where  LogID = @LogID

	--Update SAP.Account
	--Set [ChangeTrackNumber] = CHECKSUM(SAPAccountNumber, AccountName, ChannelID, BranchID, LocalChainID, 
	--		Address, City, State, CountryCode, PostalCode, Contact, PhoneNumber, Longitude, Latitude, Active)
	--Where InCapstone = 1
Go

Print 'ETL.pMergeChainsAccounts SP changes Completed' 
Go

--*********************************************************
--4. Update ETL.pLoadFromRM SP ---------------------------------
--*********************************************************
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
exec ETL.pLoadFromRM

Truncate Table [Staging].[RMRouteSchedule]

Select Top 100 * From [Staging].[RMRouteSchedule]

Select Top 100 * From SAP.RouteSchedule

*/
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
			--- BranchID, Active, Contact  always in ---
			SET [AccountName] = Case When isnull(InCapstone, 0) = 0 Then dbo.udf_TitleCase(input.CUSTOMER_NAME) Else [AccountName] End
				,[ChannelID] = Case When isnull(InCapstone, 0) = 0 Then input.ChannelID Else a.ChannelID End
				,[BranchID] = input.BranchID
				,[LocalChainID] = Case When isnull(InCapstone, 0) = 0 Then input.LocalChainID Else a.LocalChainID End
				,[Address] = Case When isnull(InCapstone, 0) = 0 Then dbo.udf_TitleCase(input.CUSTOMER_STREET) Else a.Address End
				,[City] = Case When isnull(InCapstone, 0) = 0 Then dbo.udf_TitleCase(input.CITY) Else a.City End
				,[State] = Case When isnull(InCapstone, 0) = 0 Then input.STATE Else a.State End
				,[PostalCode] = Case When isnull(InCapstone, 0) = 0 Then input.POSTAL_CODE Else a.PostalCode End
				,[Contact] = dbo.udf_TitleCase(input.CONTACT_PERSON)
				,[PhoneNumber] = Case When isnull(InCapstone, 0) = 0 Then input.PHONE_NUMBER Else a.PhoneNumber End
				,InBW = 1
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
				,LocalChainID, InBW
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
				,LocalChainID, 1
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

	-- We used to merge from RM as well(code commented)
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

	--- Accounts Geo from RoadNet
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
	And isnull(acc.InCapstone, 0) = 0

	--- That's what BW only account cares about
	--- CHECKSUM( SAPAccountNumber, AccountName, ChannelID, BranchID, LocalChainID, 
	---           Address, City, STATE, PostalCode, Contact, PhoneNumber, Longitude, Latitude, Active)
	UPDATE SAP.Account
	SET ChangeTrackNumber = CHECKSUM(SAPAccountNumber, AccountName, ChannelID, BranchID, LocalChainID, Address, City, STATE, PostalCode, Contact, PhoneNumber, Longitude, Latitude, Active)
		,LastModified = GetDate(), StoreLastModified = GetDate()
	WHERE isnull(ChangeTrackNumber, 0) != CHECKSUM(SAPAccountNumber, AccountName, ChannelID, BranchID, LocalChainID, Address, City, STATE, PostalCode, Contact, PhoneNumber, Longitude, Latitude, Active)
	And IsNUll(InCapstone,0) = 0

	--------------------------------------------------
	---- Person.RMEmployee ---------------------------
	Declare @Count int

	Select @Count = Count(*) From Staging.RMEmployee
	
	If (@Count > 0)
	Begin
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
    End

	--------------------------------------------------
	---- Route ----------------------------------
	Select @Count = Count(*) From Staging.RMROUTEMASTER
	
	If (@Count > 0)
	Begin
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
	End

	-----------------------------------------------------
	---- RouteSchedule ----------------------------------
	Select @Count = Count(*) From Staging.RMRouteSchedule

	If (@Count > 0)
	Begin	
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
	End
	-----------------------------------------------------------
	---- RouteScheduleDetail ----------------------------------
	If (@Count > 0)
	Begin
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
	End
END
Go

Print 'ETL.pLoadFromRM SP changes Completed' 
Go

--*********************************************************
--5. Update BCMyday.pGetStoresByRegionID SP ---------------------------------
--*********************************************************
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- BCMyDay.[pGetStoresByBottlerID]  14872,'','SF,LF',12,1            
ALTER Procedure [BCMyday].[pGetStoresByRegionID]                        
(                        
	@RegionID int,               
	@lastmodified datetime=null             
)                        
As                        
Begin                                 
  
	DECLARE @TerritoryTypeID int;
	DECLARE @ProductTypeID int;
	DECLARE @Format varchar(500);
	DECLARE @SupportedChannels varchar(1000);
  
	SELECT @TerritoryTypeID = Value FROM BCMyday.Config WHERE [Key]='TType' 
	SELECT @ProductTypeID = Value FROM BCMyday.Config WHERE [Key]='PType'  
	SELECT @Format = Value FROM BCMyday.Config WHERE [Key]='Format'  
	SELECT @SupportedChannels = Value FROM BCMyday.Config WHERE [Key]='CHANNELS_FOR_STORES'  
    
  
	select distinct AC.AccountID,AC.SAPAccountNumber SAPAccountID,                    
	BTLR.BottlerID BottlerID,                    
	AC.AccountName,                    
	AC.Address,AC.City,AC.State,AC.PostalCode,AC.PhoneNumber,                    
	AC.Latitude,AC.Longitude,                    
	AC.ChannelID,                    
	NationalChainID,                    
	RGN.RegionalChainID,                    
	AC.LocalChainID,BTLR.BCRegionID,AC.CRMActive IsActive,AC.StoreLastModified LastModified                                   
	from Bc.BottlerAccountTradeMark BA  
	Left Join BC.Bottler BTLR ON BTLR.BottlerId = BA.BottlerId  
	Left Join SAP.Account AC on AC.AccountID = BA.AccountId  
	LEFT JOIN SAP.LOCALCHAIN LOCLCHN ON  AC.LOCALCHAINID=LOCLCHN.LOCALCHAINID  
	LEFT JOIN SAP.REGIONALCHAIN RGN ON LOCLCHN.RegionalChainID=RGN.RegionalChainID  
	LEFT JOIN SAP.Channel CH on CH.ChannelID = BA.ChannelID
	WHERE BTLR.BCRegionId = @RegionID AND BA.TerritoryTypeID in (11,12)
		AND BA.ProductTypeID = @ProductTypeID
		AND AC.Format in (SELECT value FROM CDE.udfSplit (@Format,','))  
		AND CH.SAPChannelID in (SELECT value FROM CDE.udfSplit (@SupportedChannels,','))  
		and Ac.StoreLastModified >= Case when Isnull(@lastmodified, '')  = '' Then Ac.StoreLastModified Else @lastmodified end  
		And AC.CRMActive = Case when  Isnull(@lastmodified, '') = '' Then 1  Else AC.CRMActive end  
  
  
--If ISNULL(@lastmodified, '') = ''                                     
--Begin          
                    
--SELECT AC.AccountID,AC.SAPAccountNumber SAPAccountID,                    
--@BottlerID BottlerID,                    
--AC.AccountName,                    
--AC.Address,AC.City,AC.State,AC.PostalCode,AC.PhoneNumber,                    
--AC.Latitude,AC.Longitude,                    
--AC.ChannelID,                    
--NationalChainID,                    
--RGN.RegionalChainID,                    
--AC.LocalChainID,BTLR.BCRegionID,AC.Active IsActive,AC.LastModified                                   
--FROM SAP.ACCOUNT AC                      
--LEFT JOIN SAP.LOCALCHAIN LOCLCHN ON                      
--AC.LOCALCHAINID=LOCLCHN.LOCALCHAINID                      
--LEFT JOIN SAP.REGIONALCHAIN RGN                       
--ON LOCLCHN.RegionalChainID=RGN.RegionalChainID      
--INNER JOIN BC.Bottler BTLR ON  BTLR.BottlerID= @BottlerID                  
--WHERE accountID                      
--In (SELECT distinct                      
--AccountID FROM   BC.BottlerAccountTradeMark                        
--WHERE BottlerID=@BottlerID AND TerritoryTypeID=@TerritoryTypeID    
--AND ProductTypeID=@ProductTypeID)                   
--AND AC.Format in (SELECT value FROM CDE.udfSplit (@Format,','))                
    
              
--End              
              
--Else            
--Begin      
     
--SELECT  AC.AccountID,AC.SAPAccountNumber SAPAccountID,                    
--@BottlerID BottlerID,                    
--AC.AccountName,                    
--AC.Address,AC.City,AC.State,AC.PostalCode,AC.PhoneNumber,                    
--AC.Latitude,AC.Longitude,                    
--AC.ChannelID,                    
--NationalChainID,                    
--RGN.RegionalChainID,                    
--AC.LocalChainID,BTLR.BCRegionID,AC.Active IsActive,AC.LastModified                                   
--FROM SAP.ACCOUNT AC                      
--LEFT JOIN SAP.LOCALCHAIN LOCLCHN ON                      
--AC.LOCALCHAINID=LOCLCHN.LOCALCHAINID                      
--LEFT JOIN SAP.REGIONALCHAIN RGN                       
--ON LOCLCHN.RegionalChainID=RGN.RegionalChainID      
--INNER JOIN BC.Bottler BTLR ON  BTLR.BottlerID= @BottlerID                  
--WHERE accountID                      
--In (SELECT distinct                      
--AccountID FROM   BC.BottlerAccountTradeMark                
--WHERE BottlerID=@BottlerID AND TerritoryTypeID=@TerritoryTypeID    
--AND ProductTypeID=@ProductTypeID)                   
--AND AC.Format in (SELECT value FROM CDE.udfSplit (@Format,','))                  
--AND AC.LastModified > @lastmodified              
              
--End              
                      
                        
End 

Go

Print 'BCMyday.pGetStoresByRegionID SP changes Completed' 
Go

--*********************************************************
--6. Update BCMyday.pGetStoresByBottlerID SP ---------------------------------
--*********************************************************
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- BCMyDay.[pGetStoresByBottlerID]  14872,'','SF,LF',12,1            
ALTER Procedure [BCMyday].[pGetStoresByBottlerID]                        
(                        
	@BottlerID int,               
	@lastmodified datetime=null             
)                        
As                        
Begin                                 
  
	DECLARE @TerritoryTypeID int;
	DECLARE @ProductTypeID int;
	DECLARE @Format varchar(500);
	DECLARE @SupportedChannels varchar(1000);
  
	SELECT @TerritoryTypeID = Value FROM BCMyday.Config WHERE [Key]='TType' 
	SELECT @ProductTypeID = Value FROM BCMyday.Config WHERE [Key]='PType'  
	SELECT @Format = Value FROM BCMyday.Config WHERE [Key]='Format'  
	SELECT @SupportedChannels = Value FROM BCMyday.Config WHERE [Key]='CHANNELS_FOR_STORES'  
    
  
	select distinct AC.AccountID,AC.SAPAccountNumber SAPAccountID,                    
	BTLR.BottlerID BottlerID,                    
	AC.AccountName,                    
	AC.Address,AC.City,AC.State,AC.PostalCode,AC.PhoneNumber,                    
	AC.Latitude,AC.Longitude,                    
	AC.ChannelID,                    
	NationalChainID,                    
	RGN.RegionalChainID,                    
	AC.LocalChainID,BTLR.BCRegionID,AC.CRMActive IsActive,AC.StoreLastModified LastModified                                   
	from Bc.BottlerAccountTradeMark BA  
	Left Join BC.Bottler BTLR ON BTLR.BottlerId = BA.BottlerId  
	Left Join SAP.Account AC on AC.AccountID = BA.AccountId  
	LEFT JOIN SAP.LOCALCHAIN LOCLCHN ON  AC.LOCALCHAINID=LOCLCHN.LOCALCHAINID  
	LEFT JOIN SAP.REGIONALCHAIN RGN ON LOCLCHN.RegionalChainID=RGN.RegionalChainID  
	LEFT JOIN SAP.Channel CH on CH.ChannelID = BA.ChannelID
	WHERE BA.BottlerID = @BottlerID AND BA.TerritoryTypeID = @TerritoryTypeID
		AND BA.ProductTypeID = @ProductTypeID
		AND AC.Format in (SELECT value FROM CDE.udfSplit (@Format,','))  
		AND CH.SAPChannelID in (SELECT value FROM CDE.udfSplit (@SupportedChannels,','))  
		and Ac.StoreLastModified >= Case when Isnull(@lastmodified, '')  = '' Then Ac.StoreLastModified Else @lastmodified end  
		And AC.CRMActive = Case when  Isnull(@lastmodified, '') = '' Then 1  Else AC.CRMActive end  
  
  
--If ISNULL(@lastmodified, '') = ''                                     
--Begin          
                    
--SELECT AC.AccountID,AC.SAPAccountNumber SAPAccountID,                    
--@BottlerID BottlerID,                    
--AC.AccountName,                    
--AC.Address,AC.City,AC.State,AC.PostalCode,AC.PhoneNumber,                    
--AC.Latitude,AC.Longitude,                    
--AC.ChannelID,                    
--NationalChainID,                    
--RGN.RegionalChainID,                    
--AC.LocalChainID,BTLR.BCRegionID,AC.Active IsActive,AC.LastModified                                   
--FROM SAP.ACCOUNT AC                      
--LEFT JOIN SAP.LOCALCHAIN LOCLCHN ON                      
--AC.LOCALCHAINID=LOCLCHN.LOCALCHAINID                      
--LEFT JOIN SAP.REGIONALCHAIN RGN                       
--ON LOCLCHN.RegionalChainID=RGN.RegionalChainID      
--INNER JOIN BC.Bottler BTLR ON  BTLR.BottlerID= @BottlerID                  
--WHERE accountID                      
--In (SELECT distinct                      
--AccountID FROM   BC.BottlerAccountTradeMark                        
--WHERE BottlerID=@BottlerID AND TerritoryTypeID=@TerritoryTypeID    
--AND ProductTypeID=@ProductTypeID)                   
--AND AC.Format in (SELECT value FROM CDE.udfSplit (@Format,','))                
    
              
--End              
              
--Else            
--Begin      
     
--SELECT  AC.AccountID,AC.SAPAccountNumber SAPAccountID,                    
--@BottlerID BottlerID,                    
--AC.AccountName,                    
--AC.Address,AC.City,AC.State,AC.PostalCode,AC.PhoneNumber,                    
--AC.Latitude,AC.Longitude,                    
--AC.ChannelID,                    
--NationalChainID,                    
--RGN.RegionalChainID,                    
--AC.LocalChainID,BTLR.BCRegionID,AC.Active IsActive,AC.LastModified                                   
--FROM SAP.ACCOUNT AC                      
--LEFT JOIN SAP.LOCALCHAIN LOCLCHN ON                      
--AC.LOCALCHAINID=LOCLCHN.LOCALCHAINID                      
--LEFT JOIN SAP.REGIONALCHAIN RGN                       
--ON LOCLCHN.RegionalChainID=RGN.RegionalChainID      
--INNER JOIN BC.Bottler BTLR ON  BTLR.BottlerID= @BottlerID                  
--WHERE accountID                      
--In (SELECT distinct                      
--AccountID FROM   BC.BottlerAccountTradeMark                
--WHERE BottlerID=@BottlerID AND TerritoryTypeID=@TerritoryTypeID    
--AND ProductTypeID=@ProductTypeID)                   
--AND AC.Format in (SELECT value FROM CDE.udfSplit (@Format,','))                  
--AND AC.LastModified > @lastmodified              
              
--End              
                      
                        
End 


Go

Print 'BCMyday.pGetStoresByBottlerID SP changes Completed' 
Go

Print 'Start resync and calcuate TMap, takes about 15 mins...' 
Go

exec ETL.pNormalizeChains
exec ETL.pLoadFromRM
exec ETL.pMergeChainsAccounts
exec ETL.pReloadBCSalesAccountability
exec ETL.pMergeCapstoneProduct
exec ETL.pMergeTMapAndInclusions
exec ETL.pMergeViewTables
Go

Print 'All done.' 
Go
