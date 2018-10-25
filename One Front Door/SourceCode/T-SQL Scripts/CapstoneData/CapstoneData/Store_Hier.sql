Use Portal_DataSRE
Go

---- Store Hier all the way down to the Store Level -----
--- Loading full from VW_DM_STR_ERH_HIER ---
Select *
From Staging.BCVWStoreERH

-- Filter set at every level already for only the active ones 
-- No dummy leave is taken because of the inner join  --
Select Distinct LVL1_CHAIN_ID, LVL1_CHAIN_GUID, LVL1_CHAIN_DESC
From Staging.BCVWStoreERH

Select Distinct LVL2_CHAIN_ID, LVL2_CHAIN_GUID, LVL2_CHAIN_DESC
From Staging.BCVWStoreERH
Go

---- Local Chain up ----
-- Loading from DM_STR_HIER and cut the leaf nodes --
If Exists (Select * From sys.views Where Object_ID = Object_ID('Staging.BCStoreERHSDM'))
Begin
	Drop View Staging.BCStoreERHSDM	
End
Go

Create View Staging.BCStoreERHSDM
As
Select l1.NODE_ID L1_NODE_ID, l1.NODE_DESC L1_NODE_DESC, 
	l2.NODE_ID L2_NODE_ID, l2.NODE_DESC L2_NODE_DESC, 
	l3.NODE_ID L3_NODE_ID, l3.NODE_DESC L3_NODE_DESC, 
	l4.NODE_ID L4_NODE_ID, l4.NODE_DESC L4_NODE_DESC
From Staging.BCStoreHier l1
Join Staging.BCStoreHier l2 On l2.PRNT_GUID = l1.NODE_GUID
Join Staging.BCStoreHier l3 On l3.PRNT_GUID = l2.NODE_GUID
Join Staging.BCStoreHier l4 On l4.PRNT_GUID = l3.NODE_GUID
Where l1.HIER_TYPE = 'ER'
And l2.HIER_TYPE = 'ER'
And l3.HIER_TYPE = 'ER'
And l4.HIER_TYPE = 'ER'
And GetDate() Between l1.NODE_VLD_FRM_DT And l1.NODE_VLD_TO_DT 
And GetDate() Between l2.NODE_VLD_FRM_DT And l2.NODE_VLD_TO_DT 
And GetDate() Between l3.NODE_VLD_FRM_DT And l3.NODE_VLD_TO_DT 
And GetDate() Between l4.NODE_VLD_FRM_DT And l4.NODE_VLD_TO_DT 
And l1.DEL_FLG <> 'Y'
And l2.DEL_FLG <> 'Y'
And l3.DEL_FLG <> 'Y'
And l4.DEL_FLG <> 'Y'
Go

Select *
From SAP.NationalChain
Where NationalChainName like 'CVS%'

Select *
From SAP.RegionalChain
Where RegionalChainName like 'CVS%'

Select *
From SAP.LocalChain
Where LocalChainName like 'CVS%'


Select Distinct L1_NODE_ID, L1_NODE_DESC
From Staging.BCStoreERHSDM

Select Distinct L2_NODE_ID, L2_NODE_DESC
From Staging.BCStoreERHSDM

Select Distinct L3_NODE_ID, L3_NODE_DESC
From Staging.BCStoreERHSDM

Select *
From SAP.RegionalChain
right join
	(
	Select Distinct L4_NODE_ID, L4_NODE_DESC
	From Staging.BCStoreERHSDM
	) h on l.SAPLocalChainID = L4_NODE_ID
Where l.SAPLocalChainID is null
Go

Select *
From 	
(
	Select Distinct L1_NODE_ID, L1_NODE_DESC
	From Staging.BCStoreERHSDM
) l1 
left join
(
	Select Distinct L2_NODE_ID, L2_NODE_DESC
	From Staging.BCStoreERHSDM
) l2 on l1.L1_NODE_DESC = l2.L2_NODE_DESC
Where l2.L2_NODE_ID is null
Go

-------- this piece of code is useful ---------
Select NODE_ID, Max(ROW_MOD_DT) ROW_MOD_DT
Into Processing.BCChainLastModified
From Staging.BCStoreHier l1
Where GetDate() Between l1.NODE_VLD_FRM_DT And l1.NODE_VLD_TO_DT 
And l1.DEL_FLG <> 'Y'
Group By NODE_ID

Select *
From Processing.BCChainLastModified


---------------------
---------
Select *
From Staging.BCStoreERHSDM
Where L1_NODE_ID
in (1013579,
1013644,
1014266,
1014289)

------------------------------
Select *
From SAP.NationalChain
Where SAPNationalChainID in (1000744,
1001642,
1013761,
1013897)

----------------------------------------
--- Alter National Chain Table ----
----------------------------------------
Alter Table SAP.NationalChain
Add InCapstone Bit 
Go

Alter Table SAP.NationalChain
Add CapstoneLastModified SmallDateTime
Go

Alter Table SAP.NationalChain
Add InBW Bit 
Go
----------------------------------------
--- SAP.NationalChain ----
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
Go

----------------------------------------
--- Alter Regional Chain Table ----
----------------------------------------
Alter Table SAP.RegionalChain
Add InCapstone Bit 
Go

Alter Table SAP.RegionalChain
Add CapstoneLastModified SmallDateTime
Go

Alter Table SAP.RegionalChain
Add InBW Bit 
Go

----------------------------------------
--- SAP.RegionalChain ----
--- Need to update the BW ETL Code in the same release ---
----------------------------------------
MERGE SAP.RegionalChain AS pc
	USING (	Select Distinct nc.NationalChainID, h.L3_NODE_ID NODE_ID, dbo.udf_TitleCase(h.L3_NODE_DESC) NODE_DESC, n.ROW_MOD_DT
			From Staging.BCStoreERHSDM h 
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
Go

----------------------------------------
--- Alter Local Chain Table ----
----------------------------------------
Alter Table SAP.LocalChain
Add InCapstone Bit 
Go

Alter Table SAP.LocalChain
Add CapstoneLastModified SmallDateTime
Go

Alter Table SAP.LocalChain
Add InBW Bit 
Go

----------------------------------------
--- SAP.RegionalChain ----
--- Need to update the BW ETL Code in the same release ---
----------------------------------------
MERGE SAP.LocalChain AS pc
	USING (	Select Distinct nc.RegionalChainID, h.L4_NODE_ID NODE_ID, dbo.udf_TitleCase(h.L4_NODE_DESC) NODE_DESC, n.ROW_MOD_DT
			From Staging.BCStoreERHSDM h 
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
Go

---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------
Select *
From Staging.BC