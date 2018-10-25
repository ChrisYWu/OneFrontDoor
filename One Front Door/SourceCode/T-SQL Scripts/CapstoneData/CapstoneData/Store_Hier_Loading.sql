use Portal_DataSRE
Go

-------------------------------------------
---- Staging.BCVWStoreHierEmp -------------
Drop Table Staging.BCVWStoreHier
Go 

DECLARE @OPENQUERY nvarchar(4000)
Set @OPENQUERY = 'Select * Into Staging.BCVWStoreHierEmp From OpenQuery(COP, ''SELECT 
V.HIER_TYPE, V.CHAIN_GUID, V.CHAIN_ID, 
   V.CHAIN_DESC, V.NAE_NODE_GUID, V.NAE_NODE_ID, 
   V.NAE_NODE_DESC, V.NAE_GSN, V.NAE_EMP_ID, 
   V.NAE_FIRST_NM, V.NAE_LAST_NM, V.NAE_EMAIL, 
   V.NAE_PHN_NBR, V.NAE_FAX_NBR, V.NDI_NODE_GUID, 
   V.NDI_NODE_ID, V.NDI_NODE_DESC, V.NDI_GSN, 
   V.NDI_EMP_ID, V.NDI_FIRST_NM, V.NDI_LAST_NM, 
   V.NDI_EMAIL, V.NDI_PHN_NBR, V.NDI_FAX_NBR, 
   V.NVP_NODE_GUID, V.NVP_NODE_ID, V.NVP_NODE_DESC, 
   V.NVP_GSN, V.NVP_EMP_ID, V.NVP_FIRST_NM, 
   V.NVP_LAST_NM, V.NVP_EMAIL, V.NVP_PHN_NBR, 
   V.NVP_FAX_NBR, V.SVP_NODE_GUID, V.SVP_NODE_ID, 
   V.SVP_NODE_DESC, V.SVP_GSN, V.SVP_EMP_ID, 
   V.SVP_FIRST_NM, V.SVP_LAST_NM, V.SVP_EMAIL, 
   V.SVP_PHN_NBR, V.SVP_FAX_NBR, V.TCOMP_NODE_GUID, 
   V.TCOMP_NODE_ID, V.TCOMP_NODE_DESC, V.CEO_GSN, 
   V.CEO_EMP_ID, V.CEO_FIRST_NM, V.CEO_LAST_NM, 
   V.CEO_EMAIL, V.CEO_PHN_NBR, V.CEO_FAX_NBR
FROM CAP_DM.VW_DM_STR_HIER_EMP V'')'
Exec (@OPENQUERY)
Go

-------------------------------------------
---- Staging.BCVWStoreHierEmp -------------
Drop Table Staging.BCVWStoreNAHier
Go 

DECLARE @OPENQUERY nvarchar(4000)
Set @OPENQUERY = 'Select * Into Staging.BCVWStoreNAHier From OpenQuery(COP, ''SELECT 
V.HIER_TYPE, V.CHAIN_GUID, V.CHAIN_ID, 
   V.CHAIN_DESC, V.NAE_NODE_GUID, V.NAE_NODE_ID, 
   V.NAE_NODE_DESC, V.NDI_NODE_GUID, V.NDI_NODE_ID, 
   V.NDI_NODE_DESC, V.NVP_NODE_GUID, V.NVP_NODE_ID, 
   V.NVP_NODE_DESC, V.SVP_NODE_GUID, V.SVP_NODE_ID, 
   V.SVP_NODE_DESC, V.TCOMP_NODE_GUID, V.TCOMP_NODE_ID, 
   V.TCOMP_NODE_DESC
FROM CAP_DM.VW_DM_STR_NA_HIER V'')'
Exec (@OPENQUERY)
Go

Select *
From Staging.BCVWStoreNAHier

-------------------------------------------
---- Staging.BCVWStoreHierEmp -------------
Drop Table Staging.BCVWStoreERH
Go 

DECLARE @OPENQUERY nvarchar(4000)
Set @OPENQUERY = 'Select * Into Staging.BCVWStoreERH From OpenQuery(COP, ''SELECT 
V.STR_GUID, V.STR_ID, V.HIER_TYPE, 
   V.LVL4_CHAIN_GUID, V.LVL4_CHAIN_ID, V.LVL4_CHAIN_DESC, 
   V.LVL3_CHAIN_GUID, V.LVL3_CHAIN_ID, V.LVL3_CHAIN_DESC, 
   V.LVL2_CHAIN_GUID, V.LVL2_CHAIN_ID, V.LVL2_CHAIN_DESC, 
   V.LVL1_CHAIN_GUID, V.LVL1_CHAIN_ID, V.LVL1_CHAIN_DESC
FROM CAP_DM.VW_DM_STR_ERH_HIER V'')'
Exec (@OPENQUERY)
Go

Select Distinct LVL4_CHAIN_ID, LVL4_CHAIN_DESC
From Staging.BCVWStoreERH


--------------------------------------
----- Staging.BCStoreHier ------------
Drop Table Staging.BCStoreHier

Declare @LastLoadTime DateTime
Set @LastLoadTime = '2013-11-18 17:00:28'
DECLARE @OPENQUERY nvarchar(4000)
Set @OPENQUERY = BC.fnSetOpenQuery('SELECT 
D.TRANS_PRC_FLG, D.SEQ_NBR, D.ROW_TSK_ID, 
   D.ROW_MOD_DT, D.ROW_MOD_BY, D.ROW_CRT_DT, 
   D.ROW_CRT_BY, D.PRNT_GUID, D.PARTNER_GUID, 
   D.PARTNER, D.NODE_WEB_PRC_FLG, D.NODE_VNDR_CHAIN_ID, 
   D.NODE_VLD_TO_DT, D.NODE_VLD_FRM_DT, D.NODE_PRC_TYPE, 
   D.NODE_PRC_EDI_MAILBOX, D.NODE_ITEM_CHAIN_ID, D.NODE_INVLD_PROD_PKG_CHAIN_ID, 
   D.NODE_ID, D.NODE_GXS_PRC_FLG, D.NODE_GUID, 
   D.NODE_DESC, D.MF_ORG_UNIT, D.MD5_KEY, 
   D.HIER_TYPE, D.HIER_LVL_NBR, D.HIER_LVL_DESC, 
   D.DEL_FLG, D.CHG_NBR, D.BP_VLD_TO_DT, 
   D.BP_VLD_FRM_DT, D.BATCH_ID
FROM CAP_DM.DM_STR_HIER D', 'COP', @LastLoadTime, 'D')
Set @OPENQUERY = Replace(@OPENQUERY, 'WHERE', 'WHERE PARTNER IS NULL AND')
Set @OPENQUERY = Replace(@OpenQuery, 'Select *', 'Select * Into Staging.BCStoreHier')
Exec (@OPENQUERY)
Go

Select *
From Staging.BCStoreHier


Select n.SAPNationalChainID, n.NationalChainName, Cap.*
From SAP.NationalChain n
Left Join 
(
	Select NODE_ID, NODE_DESC, NODE_GUID, ROW_MOD_DT
	From Staging.BCStoreHier h
	Where HIER_TYPE = 'ER'
	And GetDate() Between NODE_VLD_FRM_DT And NODE_VLD_TO_DT 
	And DEL_FLG <> 'Y'
	And PRNT_GUID = '00000000000000000000000000000000'
	And NODE_DESC like '%Walmart%'
) Cap On n.SAPNationalChainID = Cap.NODE_ID


-------- Walmart is not really Walmart ---------
Select *
From SAP.NationalChain
Where NationalChainName like '%Walmart%'
Go

Select NODE_ID, NODE_DESC, NODE_GUID, ROW_MOD_DT
From Staging.BCStoreHier h
Where HIER_TYPE = 'ER'
And GetDate() Between NODE_VLD_FRM_DT And NODE_VLD_TO_DT 
And DEL_FLG <> 'Y'
And PRNT_GUID = '00000000000000000000000000000000'
And NODE_DESC like '%Walmart%'
Go

--- Good the key is not reused at least ---
Select NOde_ID, Count(*) CNT
From Staging.BCStoreHier
Where HIER_TYPE = 'ER'
And GetDate() Between NODE_VLD_FRM_DT And NODE_VLD_TO_DT 
And DEL_FLG <> 'Y'
Group By NOde_ID
Having Count(*) > 1
Go
----------------------------
Select *
From Staging.BCStoreHier
Where NODE_ID = '1000350'

-----------------------------
Select NODE_ID, NODE_DESC, NODE_GUID, ROW_MOD_DT
From Staging.BCStoreHier h
Where HIER_TYPE = 'ER'
And GetDate() Between NODE_VLD_FRM_DT And NODE_VLD_TO_DT 
And DEL_FLG <> 'Y'
And PRNT_GUID = '00000000000000000000000000000000'
Go

