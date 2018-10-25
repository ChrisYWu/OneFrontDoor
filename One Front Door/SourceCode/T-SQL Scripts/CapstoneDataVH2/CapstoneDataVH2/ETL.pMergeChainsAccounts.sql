USE Portal_Data
GO


/****** Object:  StoredProcedure [ETL].[pMergeChainsAccounts]    Script Date: 8/14/2014 3:28:06 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- exec ETL.pMergeChainsAccounts --

ALTER Proc [ETL].[pMergeChainsAccounts]
AS		
	Set NoCount On;
	----------------------------------------
	--- SAP.NationalChain ---- Need to have the acive flag
	--- Need to update the BW ETL Code in the same release ---
	----------------------------------------
	MERGE SAP.NationalChain AS pc
		USING (	Select Distinct h.L2_NODE_ID NODE_ID, dbo.udf_TitleCase(h.L2_NODE_DESC) NODE_DESC, n.ROW_MOD_DT
				From Processing.BCvStoreERHSDM h 
				Join Processing.BCChainLastModified n on h.L2_NODE_ID = n.NODE_ID
				) AS input
			ON pc.SAPNationalChainID = input.NODE_ID
	WHEN MATCHED THEN
		UPDATE SET pc.CapstoneLastModified = input.ROW_MOD_DT,
					pc.InCapstone = 1
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPNationalChainID, NationalChainName, ChangeTrackNumber, LastModified, InCapstone, CapstoneLastModified)
		VALUES(input.NODE_ID, input.NODE_DESC, Checksum(input.NODE_ID, input.NODE_DESC), GetDate(), 1, input.ROW_MOD_DT);

	----------------------------------------
	--- SAP.RegionalChain ----
	--- Need to update the BW ETL Code in the same release ---
	----------------------------------------
	MERGE SAP.RegionalChain AS pc
		USING (	Select Distinct nc.NationalChainID, h.L3_NODE_ID NODE_ID, dbo.udf_TitleCase(h.L3_NODE_DESC) NODE_DESC, n.ROW_MOD_DT
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
		VALUES(input.NODE_ID, input.NODE_DESC, input.NationalChainID, Checksum(NationalChainID, input.NODE_ID, input.NODE_DESC), GetDate(), 1, input.ROW_MOD_DT);

	----------------------------------------
	--- SAP.RegionalChain ----
	--- Need to update the BW ETL Code in the same release ---
	----------------------------------------
	MERGE SAP.LocalChain AS pc
	USING (	Select Distinct nc.RegionalChainID, h.L4_NODE_ID NODE_ID, dbo.udf_TitleCase(h.L4_NODE_DESC) NODE_DESC, n.ROW_MOD_DT
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
	VALUES(input.NODE_ID, input.NODE_DESC, input.RegionalChainID, Checksum(RegionalChainID, input.NODE_ID, input.NODE_DESC), GetDate(), 1, input.ROW_MOD_DT);

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
			Case When s.Latitude is null And s.Longitude is null then null else 'Cap' end GeoSource,
			c.ChannelID,
			s.CHNL_CODE,
			lc.LocalChainID,
			Case When GetDate() Between STR_OPEN_DT And STR_CLOSE_DT And DEL_FLG <> 'Y' And CRM_LOCAL_FLG = 'X' Then 1 Else 0 End CRMActive
			From staging.BCStore s
			Left Join SAP.Channel c on s.CHNL_CODE = SAPChannelID
			Left Join SAP.LocalChain lc on lc.SAPLocalChainID = s.ERH_LVL_4_NODE_ID
			) AS input
		ON pc.SAPAccountNumber = input.STR_ID
	WHEN MATCHED THEN
		UPDATE SET pc.CapstoneLastModified = input.CapstoneLastModified,
					pc.InCapstone = 1,
					Format = input.Format,
					TDLinxID = input.TDLinx_ID,
					ChannelID = input.ChannelID,
					--Latitude = Case When pc.Latitude is null And pc.Longitude is null Then input.Latitude Else pc.Latitude End,
					--Longitude = Case When pc.Latitude is null And pc.Longitude is null Then input.Longitude Else pc.Longitude End,
					--GeoSource = Case When pc.Latitude is null And pc.Longitude is null Then 'Cap' Else 'RN' End,
					CRMActive = input.CRMActive -- this is updated from capstone
					-- LastModified is not updated
	WHEN NOT MATCHED By Target THEN
		INSERT([SAPAccountNumber],[AccountName],[ChannelID],[LocalChainID]
		--,[Longitude],[Latitude]
		,[CRMActive]
		,[LastModified], Format 
		,[TDLinxID],[CapstoneLastModified],GEOSource,[InCapstone])
		VALUES(input.STR_ID, STR_NM, input.ChannelID, input.LocalChainID
		--,input.Latitude, input.Longitude
		,input.CRMActive
		,input.CapstoneLastModified, input.Format 
		,input.TDLinx_ID, input.CapstoneLastModified, input.GeoSource, 1);
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
		GeoCodingNeeded = Case When GeoSource = 'RN' then 0 Else 1 End;

	------------------------------------------
	------------------------------------------
	Select @LogID = Max(LogID)
	From ETL.BCDataLoadingLog
	Where SchemaName = 'Staging' 
	And TableName = 'BCBPAddress'

	Update ETL.BCDataLoadingLog
	Set MergeDate = GetDate()
	Where  LogID = @LogID

	Update SAP.Account
	Set [ChangeTrackNumber] = CHECKSUM(SAPAccountNumber, AccountName, ChannelID, BranchID, LocalChainID, 
			Address, City, State, CountryCode, PostalCode, Contact, PhoneNumber, Longitude, Latitude, Active)
	Where InCapstone = 1


GO

