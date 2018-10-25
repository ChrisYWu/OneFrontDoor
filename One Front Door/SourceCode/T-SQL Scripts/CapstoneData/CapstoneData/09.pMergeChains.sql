Use Portal_DataSRE
Go

If Exists (Select * From Sys.procedures Where Object_ID = Object_ID('ETL.pMergeChains'))
Begin
	Drop Proc ETL.pMergeChains
End
Go

-- exec ETL.pMergeChains --

Create Proc ETL.pMergeChains
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
	From BC.DataLoadingLog
	Where SchemaName = 'Staging' 
	And TableName = 'BCStoreHier'

	Update BC.DataLoadingLog
	Set MergeDate = GetDate()
	Where  LogID = @LogID

Go


Select *
From SAP.NationalChain
