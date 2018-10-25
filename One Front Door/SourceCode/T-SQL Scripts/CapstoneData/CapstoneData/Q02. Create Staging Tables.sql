use Portal_Data_INT
Go

-- 1. BCCountry --------------
/* Not Loading from Capstone, bacause the CAP_DM.DM_CNTRY table does not have US(United States) and CA(Canada)
*/

-- 2. BCRegion ---------------
------------------------------
If Exists (Select * From sys.tables where object_id = object_id('Staging.BCRegion'))
Begin
	Drop Table Staging.BCRegion
End
Go

CREATE TABLE [Staging].[BCRegion](
	[CNTRY_CODE] [nvarchar](2) NOT NULL,
	[REGION_FIPS] [nvarchar](2) NOT NULL,
	[REGION_ABRV] [nvarchar](2) NOT NULL,
	[REGION_NM] [nvarchar](20) NULL,
	[ROW_MOD_DT] [datetime2](7) NOT NULL
) ON [PRIMARY]
Go

-- 3. BCCounty ----------------
-------------------------------
If Exists (Select * From sys.tables where object_id = object_id('Staging.BCCounty'))
Begin
	Drop Table Staging.BCCounty
End
Go

CREATE TABLE [Staging].[BCCounty](
	[CNTRY_CODE] [nvarchar](2) NOT NULL,
	[REGION_FIPS] [nvarchar](2) NOT NULL,
	[CNTY_FIPS] [nvarchar](3) NOT NULL,
	[CNTY_NM] [nvarchar](40) NULL,
	[CNTY_POP] [numeric](10, 0) NULL,
	[ROW_MOD_DT] [datetime2](7) NOT NULL
) ON [PRIMARY]
GO


-- 4. BCStoreInclusion --------
-------------------------------
If Exists (Select * From sys.tables where object_id = object_id('Staging.BCStoreInclusion'))
Begin
	Drop Table Staging.BCStoreInclusion
End
Go

CREATE TABLE [Staging].[BCStoreInclusion](
	[TRADEMARK_ID] [nvarchar](5) NOT NULL,
	[PROD_TYPE_ID] [nvarchar](5) NOT NULL,
	[TERR_VW_ID] [nvarchar](2) NOT NULL,
	[STR_ID] [nvarchar](10) NOT NULL,
	[BTTLR_ID] [nvarchar](10) NULL,
	[INCL_FOR_POSTAL_CODE] [nvarchar](10) NULL,
	[CNTRY_CODE] [nvarchar](3) NOT NULL,
	[REGION_FIPS] [nvarchar](2) NOT NULL,
	[CNTY_FIPS] [nvarchar](3) NOT NULL,
	[STTS_ID] [nvarchar](2) NULL,
	[VLD_FRM_DT] [datetime2](7) NULL,
	[VLD_TO_DT] [datetime2](7) NULL,
	[ROW_MOD_DT] [datetime2](7) NOT NULL
) ON [PRIMARY]
GO

-- 5. BCStoreInclusion --------
-------------------------------
If Exists (Select * From sys.tables where object_id = object_id('Staging.BCStore'))
Begin
	Drop Table Staging.BCStore
End
Go

CREATE TABLE [Staging].[BCStore](
	[STR_ID] [nvarchar](10) NOT NULL,
	[PARTNER_GUID] [nvarchar](32) NOT NULL,
	[STR_NM] [nvarchar](60) NULL,
	[STR_OPEN_DT] [datetime2](7) NULL,
	[STR_CLOSE_DT] [datetime2](7) NULL,
	[TDLINX_ID] [nvarchar](60) NULL,
	[FORMAT] [nvarchar](20) NULL,
	[LATITUDE] [numeric](15, 4) NULL,
	[LONGITUDE] [numeric](15, 4) NULL,
	[LAT_LON_PREC_COD] [nvarchar](5) NULL,
	[CHNL_CODE] [nvarchar](3) NULL,
	[CHNL_DESC] [nvarchar](40) NULL,
	[CHAIN_TYPE] [nvarchar](2) NULL,
	[ERH_LVL_4_NODE_ID] [nvarchar](20) NULL,
	[EXT_STR_STTS_IND] [nvarchar](5) NULL,
	[GLOBAL_STTS] [nvarchar](2) NULL,
	[DEL_FLG] [nvarchar](1) NULL,
	[CRM_LOCAL_FLG] varchar(2) Null,
	[ROW_MOD_DT] [datetime2](7) NOT NULL
) ON [PRIMARY]
GO

-- 6. BCBottlerHierachy -------
-------------------------------
If Exists (Select * From sys.tables where object_id = object_id('Staging.BCBottlerHierachy'))
Begin
	Drop Table Staging.BCBottlerHierachy
End
Go

CREATE TABLE [Staging].BCBottlerHierachy(
	[NODE_GUID] [nvarchar](32) NOT NULL,
	[SEQ_NBR] [nvarchar](20) NOT NULL,
	[NODE_ID] [nvarchar](20) NULL,
	[NODE_DESC] [nvarchar](40) NULL,
	[NODE_VLD_FRM_DT] [datetime2](7) NULL,
	[NODE_VLD_TO_DT] [datetime2](7) NULL,
	[HIER_LVL_NBR] [nvarchar](5) NULL,
	[PRNT_GUID] [nvarchar](32) NULL,
	[HIER_TYPE] [nvarchar](2) NULL,
	[PARTNER_GUID] [nvarchar](32) NULL,
	[PARTNER] [nvarchar](10) NULL,
	[BP_VLD_FRM_DT] [datetime2](7) NULL,
	[BP_VLD_TO_DT] [datetime2](7) NULL,
	[DEL_FLG] [nvarchar](1) NULL,
	[ROW_MOD_DT] [datetime2](7) NOT NULL
) ON [PRIMARY]

GO

-- 7. BCBottler ---------------
-------------------------------
If Exists (Select * From sys.tables where object_id = object_id('Staging.BCBottler'))
Begin
	Drop Table Staging.BCBottler
End
Go

CREATE TABLE [Staging].[BCBottler](
	[BTTLR_ID] [nvarchar](10) NOT NULL,
	[BTTLR_NM] [nvarchar](60) NULL,
	[CHNL_CODE] [nvarchar](3) NULL,
	[GLOBAL_STTS] [nvarchar](2) NULL,
	[DEL_FLG] [nvarchar](1) NULL,
	[ROW_MOD_DT] [datetime2](7) NOT NULL,
	[PRODUCER_FLG] [nvarchar](1) NULL
) ON [PRIMARY]

GO

-- 8. BCBPAddress ---------------
-------------------------------
If Exists (Select * From sys.tables where object_id = object_id('Staging.BCBPAddress'))
Begin
	Drop Table Staging.BCBPAddress
End
Go

CREATE TABLE [Staging].[BCBPAddress](
	[ADDR_ID] [nvarchar](14) NOT NULL,
	[ADDR_TYPE] [nvarchar](10) NULL,
	[BP_ID] [nvarchar](10) NOT NULL,
	[ADDR_LINE_1] [nvarchar](100) NULL,
	[ADDR_LINE_2] [nvarchar](100) NULL,
	[ADDR_CITY] [nvarchar](40) NULL,
	[ADDR_REGION_ABRV] [nvarchar](3) NULL,
	[ADDR_CNTY_NM] [nvarchar](40) NULL,
	[ADDR_PSTL_CODE] [nvarchar](10) NULL,
	[ADDR_CNTRY_CODE] [nvarchar](3) NULL,
	[PHN_NBR] [nvarchar](30) NULL,
	[FAX_NBR] [nvarchar](30) NULL,
	[EMAIL] [nvarchar](241) NULL,
	[ROW_MOD_DT] [datetime2](7) NOT NULL,
	[ADDR_REGION_FIPS] [nvarchar](2) NULL,
	[ADDR_CNTY_FIPS] [nvarchar](3) NULL
) ON [PRIMARY]

GO

-- 9. BCvBottlerExternalHierachy ---------------
------------------------------------------------
If Exists (Select * From sys.tables where object_id = object_id('Staging.BCvBottlerExternalHierachy'))
Begin
	Drop Table Staging.BCvBottlerExternalHierachy
End
Go

CREATE TABLE [Staging].[BCvBottlerExternalHierachy](
	[BTTLR_GUID] [nvarchar](32) NULL,
	[BTTLR_ID] [nvarchar](10) NULL,
	[HIER_TYPE] [nvarchar](2) NULL,
	[NODE4_GUID] [nvarchar](32) NOT NULL,
	[NODE4_ID] [nvarchar](20) NULL,
	[NODE4_DESC] [nvarchar](40) NULL,
	[NODE3_GUID] [nvarchar](32) NOT NULL,
	[NODE3_ID] [nvarchar](20) NULL,
	[NODE3_DESC] [nvarchar](40) NULL,
	[NODE2_GUID] [nvarchar](32) NOT NULL,
	[NODE2_ID] [nvarchar](20) NULL,
	[NODE2_DESC] [nvarchar](40) NULL,
	[NODE1_GUID] [nvarchar](32) NOT NULL,
	[NODE1_ID] [nvarchar](20) NULL,
	[NODE1_DESC] [nvarchar](40) NULL
) ON [PRIMARY]

GO

-- 10. BCvBottlerExternalHierachy --------------
------------------------------------------------
If Exists (Select * From sys.tables where object_id = object_id('Staging.BCvBottlerSalesHierachy'))
Begin
	Drop Table Staging.BCvBottlerSalesHierachy
End
Go

CREATE TABLE [Staging].[BCvBottlerSalesHierachy](
	[BTTLR_GUID] [nvarchar](32) NULL,
	[BTTLR_ID] [nvarchar](10) NULL,
	[HIER_TYPE] [nvarchar](2) NULL,
	[REGION_DESC] [nvarchar](40) NULL,
	[REGION_GUID] [nvarchar](32) NOT NULL,
	[REGION_ID] [nvarchar](20) NULL,
	[DIVISION_DESC] [nvarchar](40) NULL,
	[DIVISION_GUID] [nvarchar](32) NOT NULL,
	[DIVISION_ID] [nvarchar](20) NULL,
	[ZONE_DESC] [nvarchar](40) NULL,
	[ZONE_GUID] [nvarchar](32) NOT NULL,
	[ZONE_ID] [nvarchar](20) NULL,
	[SYSTEM_DESC] [nvarchar](40) NULL,
	[SYSTEM_GUID] [nvarchar](32) NOT NULL,
	[SYSTEM_ID] [nvarchar](20) NULL,
	[CCNTRY_DESC] [nvarchar](40) NULL,
	[CCNTRY_GUID] [nvarchar](32) NOT NULL,
	[CCNTRY_ID] [nvarchar](20) NULL,
	[TCOMP_DESC] [nvarchar](40) NULL,
	[TCOMP_GUID] [nvarchar](32) NOT NULL,
	[TCOMP_ID] [nvarchar](20) NULL
) ON [PRIMARY]

GO

-- 10. BCHierachyEmployee --------------
------------------------------------------------
If Exists (Select * From sys.tables where object_id = object_id('Staging.BCHierachyEmployee'))
Begin
	Drop Table Staging.BCHierachyEmployee
End
Go

CREATE TABLE [Staging].BCHierachyEmployee(
	[NODE_GUID] [nvarchar](32) NOT NULL,
	[EMP_GUID] [nvarchar](32) NOT NULL,
	[EMP_FUNC] [nvarchar](8) NOT NULL,
	[EMP_GSN] [nvarchar](20) NULL,
	[EMP_ID] [nvarchar](20) NULL,
	[NODE_ID] [nvarchar](30) NULL,
	[NODE_DESC] [nvarchar](40) NULL,
	[HIER_TYPE] [nvarchar](2) NULL,
	[FIRST_NM] [nvarchar](40) NULL,
	[LAST_NM] [nvarchar](40) NULL,
	[PSTN] [nvarchar](12) NULL,
	[EMAIL] [nvarchar](241) NULL,
	[PHN_NBR] [nvarchar](30) NULL,
	[ADDR_LINE_1] [nvarchar](100) NULL,
	[FAX_NBR] [nvarchar](30) NULL,
	[ADDR_LINE_2] [nvarchar](100) NULL,
	[ADDR_CITY] [nvarchar](40) NULL,
	[ADDR_REGION_ABRV] [nvarchar](2) NULL,
	[ADDR_POSTAL_CODE] [nvarchar](10) NULL,
	[VLD_FRM_DT] [datetime2](7) NULL,
	[VLD_TO_DT] [datetime2](7) NULL,
	[DEL_FLG] [nvarchar](1) NULL,
	[ROW_MOD_DT] [datetime2](7) NOT NULL
) ON [PRIMARY]

GO

-- 11. BCTMap --------------
------------------------------------------------
If Exists (Select * From sys.tables where object_id = object_id('Staging.BCTMap'))
Begin
	Drop Table Staging.BCTMap
End
Go

CREATE TABLE [Staging].[BCTMap](
	[TRADEMARK_ID] [nvarchar](5) NOT NULL,
	[PROD_TYPE_ID] [nvarchar](5) NOT NULL,
	[TERR_VW_ID] [nvarchar](2) NOT NULL,
	[CNTRY_CODE] [nvarchar](3) NOT NULL,
	[REGION_FIPS] [nvarchar](2) NOT NULL,
	[CNTY_FIPS] [nvarchar](3) NOT NULL,
	[POSTAL_CODE] [nvarchar](10) NOT NULL,
	[BTTLR_ID] [nvarchar](10) NULL,
	VLD_FROM_DT [datetime2](7) NOT NULL,
	VLD_TO_DT [datetime2](7) NOT NULL,
	[ROW_MOD_DT] [datetime2](7) NOT NULL
) ON [PRIMARY]

GO

-- 12. BCBottlerEmployee --------------
------------------------------------------------
If Exists (Select * From sys.tables where object_id = object_id('Staging.BCBottlerEmployee'))
Begin
	Drop Table Staging.BCBottlerEmployee
End
Go

CREATE TABLE [Staging].[BCBottlerEmployee](
	[NODE_GUID] [nvarchar](32) NOT NULL,
	[EMP_GUID] [nvarchar](32) NOT NULL,
	[EMP_FUNC] [nvarchar](8) NOT NULL,
	[EMP_GSN] [nvarchar](20) NULL,
	[EMP_ID] [nvarchar](20) NULL,
	[NODE_ID] [nvarchar](30) NULL,
	[NODE_DESC] [nvarchar](40) NULL,
	[HIER_TYPE] [nvarchar](2) NULL,
	[FIRST_NM] [nvarchar](40) NULL,
	[LAST_NM] [nvarchar](40) NULL,
	[PSTN] [nvarchar](12) NULL,
	[EMAIL] [nvarchar](241) NULL,
	[PHN_NBR] [nvarchar](30) NULL,
	[ADDR_LINE_1] [nvarchar](100) NULL,
	[FAX_NBR] [nvarchar](30) NULL,
	[ADDR_LINE_2] [nvarchar](100) NULL,
	[ADDR_CITY] [nvarchar](40) NULL,
	[ADDR_REGION_ABRV] [nvarchar](2) NULL,
	[ADDR_POSTAL_CODE] [nvarchar](10) NULL,
	[VLD_FRM_DT] [datetime2](7) NULL,
	[VLD_TO_DT] [datetime2](7) NULL,
	[DEL_FLG] [nvarchar](1) NULL,
	[ROW_MOD_DT] [datetime2](7) NOT NULL
) ON [PRIMARY]

GO

-- 13. BCStoreHier --------------
------------------------------------------------
If Exists (Select * From sys.tables where object_id = object_id('Staging.BCStoreHier'))
Begin
	Drop Table Staging.BCStoreHier
End
Go

CREATE TABLE [Staging].[BCStoreHier](
	[TRANS_PRC_FLG] [nvarchar](1) NULL,
	[SEQ_NBR] [nvarchar](20) NOT NULL,
	[ROW_TSK_ID] [nvarchar](100) NOT NULL,
	[ROW_MOD_DT] [datetime2](7) NOT NULL,
	[ROW_MOD_BY] [nvarchar](20) NOT NULL,
	[ROW_CRT_DT] [datetime2](7) NOT NULL,
	[ROW_CRT_BY] [nvarchar](20) NOT NULL,
	[PRNT_GUID] [nvarchar](32) NULL,
	[PARTNER_GUID] [nvarchar](32) NULL,
	[PARTNER] [nvarchar](10) NULL,
	[NODE_WEB_PRC_FLG] [nvarchar](1) NULL,
	[NODE_VNDR_CHAIN_ID] [nvarchar](20) NULL,
	[NODE_VLD_TO_DT] [datetime2](7) NULL,
	[NODE_VLD_FRM_DT] [datetime2](7) NULL,
	[NODE_PRC_TYPE] [nvarchar](2) NULL,
	[NODE_PRC_EDI_MAILBOX] [nvarchar](25) NULL,
	[NODE_ITEM_CHAIN_ID] [nvarchar](20) NULL,
	[NODE_INVLD_PROD_PKG_CHAIN_ID] [nvarchar](20) NULL,
	[NODE_ID] [nvarchar](32) NOT NULL,
	[NODE_GXS_PRC_FLG] [nvarchar](1) NULL,
	[NODE_GUID] [nvarchar](32) NOT NULL,
	[NODE_DESC] [nvarchar](40) NULL,
	[MF_ORG_UNIT] [nvarchar](10) NULL,
	[MD5_KEY] [nvarchar](32) NULL,
	[HIER_TYPE] [nvarchar](2) NULL,
	[HIER_LVL_NBR] [nvarchar](20) NULL,
	[HIER_LVL_DESC] [nvarchar](60) NULL,
	[DEL_FLG] [nvarchar](1) NULL,
	[CHG_NBR] [nvarchar](32) NULL,
	[BP_VLD_TO_DT] [datetime2](7) NULL,
	[BP_VLD_FRM_DT] [datetime2](7) NULL,
	[BATCH_ID] [numeric](10, 0) NULL
) ON [PRIMARY]

GO


-- 14. BCProduct1 ------------------------
------------------------------------------
If Exists (Select * From sys.tables where object_id = object_id('Staging.BCProduct1'))
Begin
	Drop Table Staging.BCProduct1
End
Go

CREATE TABLE [Staging].[BCProduct1](
	[PROD_ID] [nvarchar](40) NOT NULL,
	[PROD_DESC] [nvarchar](40) NULL,
	[PROD_STTS] [nvarchar](5) NULL,
	[TRADEMARK_ID] [nvarchar](5) NULL,
	[TRADEMARK_DESC] [nvarchar](40) NULL,
	[TRADEMARK_GRP_ID] [nvarchar](5) NULL,
	[TRADEMARK_GRP_DESC] [nvarchar](40) NULL,
	[CORE_BRND_GRP_ID] [nvarchar](5) NULL,
	[CORE_BRND_GRP_DESC] [nvarchar](40) NULL,
	[CNTNR_TYPE_ID] [nvarchar](5) NULL,
	[CNTNR_TYPE_DESC] [nvarchar](40) NULL,
	[PKG_ID] [nvarchar](5) NULL,
	[PKG_DESC] [nvarchar](40) NULL,
	[CAFF_CLAIM_ID] [nvarchar](5) NULL,
	[CAFF_CLAIM_DESC] [nvarchar](40) NULL,
	[PKG_EXTN_ID] [nvarchar](5) NULL,
	[PKG_EXTN] [nvarchar](40) NULL,
	[BEV_TYPE_ID] [nvarchar](5) NULL,
	[BEV_TYPE_DESC] [nvarchar](40) NULL,
	[FLVR_ID] [nvarchar](5) NULL,
	[FLVR_DESC] [nvarchar](40) NULL,
	[CARB_CODE] [nvarchar](5) NULL,
	[CARB_CODE_DESC] [nvarchar](40) NULL,
	[CNTNR_SZ_DESC] [nvarchar](40) NULL,
	[ROW_MOD_DT] [datetime2](7) NOT NULL
) ON [PRIMARY]

GO

-- 15. BCProduct2 ------------------------
------------------------------------------
If Exists (Select * From sys.tables where object_id = object_id('Staging.BCProduct2'))
Begin
	Drop Table Staging.BCProduct2
End
Go

CREATE TABLE [Staging].[BCProduct2](
	[PROD_ID] [nvarchar](40) NOT NULL,
	[PKG_TYPE_ID] [nvarchar](5) NULL,
	[PKG_TYPE_DESC] [nvarchar](60) NULL,
	[PKG_CFG_ID] [nvarchar](5) NULL,
	[PKG_CFG_DESC] [nvarchar](20) NULL,
	[PKG_CAT_DESC] [nvarchar](20) NULL,
	[PKG_VERSION] [nvarchar](5) NULL,
	[PCK_VERS_DESC] [nvarchar](20) NULL,
	[PCK_CONSU_PK_DESC] [nvarchar](40) NULL,
	[CNSMR_BRND_ID] [nvarchar](8) NULL,
	[CNSMR_BRND_DESC] [nvarchar](60) NULL,
	[CAT_SEG_ID] [nvarchar](5) NULL,
	[CAT_SEG_DESC] [nvarchar](40) NULL,
	[INIT_CAT_SEG_ID] [nvarchar](5) NULL,
	[INIT_CAT_SEG_DESC] [nvarchar](40) NULL,
	[CAL_CLASS_ID] [nvarchar](5) NULL,
	[CAL_CLASS_DESC] [nvarchar](40) NULL,
	[BASE_PROD_DESC] [nvarchar](70) NULL,
	[BS_PR_WEB_PR_FLG] [nvarchar](1) NULL,
	[VLD_ALL_CHAINS] [nvarchar](1) NULL,
	[UNITS_IN_PCK] [nvarchar](10) NULL,
	[PCKS_IN_CASE] [nvarchar](10) NULL,
	[BASE_PCK_TYPE_DESC] [nvarchar](40) NULL,
	[PKG_WEB_PRC_FLG] [nvarchar](1) NULL,
	[STARS_ID] [nvarchar](20) NULL,
	[NAIS_ID] [nvarchar](20) NULL,
	[CSTONE_ID] [nvarchar](20) NULL,
	[PROBE_ID] [nvarchar](20) NULL,
	[MDM_ID] [nvarchar](20) NULL,
	[CONV_CASE_CONV_FCTR] [nvarchar](3) NULL,
	[RELEVANCE_PRC_FLG] [nvarchar](1) NULL,
	[CS_SLS_RELEVANT_FLG] [nvarchar](1) NULL,
	[GTIN] [nvarchar](40) NULL,
	[INFO_PROVIDER_GLN] [nvarchar](13) NULL,
	[UPC10] [nvarchar](10) NULL,
	[CNSMR_UPC] [nvarchar](12) NULL,
	[FRANCHISOR_ID] [nvarchar](5) NULL,
	[FRANCHISOR_DE] [nvarchar](40) NULL,
	[PROD_ALIGN_ID] [nvarchar](2) NULL,
	[PROD_ALIGN_DESC] [nvarchar](60) NULL,
	[DEL_FLG] [nvarchar](1) NULL,
	[ROW_MOD_DT] [datetime2](7) NOT NULL,
	[PROD_GUID] [nvarchar](32) NULL,
	[PACK_GRP] [nvarchar](3) NULL,
	[PACK_GRP_DESC] [nvarchar](40) NULL
) ON [PRIMARY]

GO












