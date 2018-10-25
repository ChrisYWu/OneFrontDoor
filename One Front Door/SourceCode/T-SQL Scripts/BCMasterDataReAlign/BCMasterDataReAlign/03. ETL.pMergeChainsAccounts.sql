use Portal_Data
Go

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