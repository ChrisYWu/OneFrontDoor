use Portal_DataVH2
Go

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Alter Table SAP.Account
Add ConnerStoneFlg Bit
Go

Alter Table SAP.Account
Add CRMLocalFlg Bit
Go

Alter Table SAP.Account
Add ProbeFlg Bit
Go

Alter Table SAP.Account
Add DirectCustomerFlg Bit
Go

Update SAP.Account
Set ConnerStoneFlg = 0, CRMLocalFlg = 0, ProbeFlg = 0, DirectCustomerFlg = 0
Go

Alter Table SAP.Account
Alter Column ConnerStoneFlg Bit Not Null
Go

Alter Table SAP.Account
Alter Column CRMLocalFlg Bit Not Null
Go

Alter Table SAP.Account
Alter Column ProbeFlg Bit Not Null
Go

Alter Table SAP.Account
Alter Column DirectCustomerFlg Bit Not Null
Go

--999999999999999999999999999999999999999
/****** Object:  Index [NC_AccountID_BranchIDChannalIDActive]    Script Date: 7/8/2014 4:57:35 PM ******/
DROP INDEX [NC_AccountID_BranchIDChannalIDActive] ON [SAP].[Account]
GO

/****** Object:  Index [NC_AccountID_BranchIDChannalIDActive]    Script Date: 7/8/2014 4:57:35 PM ******/
CREATE NONCLUSTERED INDEX [NC_AccountID_BranchIDChannalIDActive] ON [SAP].[Account]
(
	[BranchID] ASC,
	[AccountID] ASC,
	[ChannelID] ASC,
	[Active] ASC,
	[DirectCustomerFlg] ASC,
	[CRMLocalFlg] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 20)
GO

Alter Table BC.BottlerAccountTradeMark
Add [DirectCustomerFlg] Bit
Go
--- Need to touch the t-tables for creation logic and inlclude those columns.
--999999999999999999999999999999999999999

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
------------------------------
Alter Table Staging.BCStore
Add DIRECT_CUST_FLG Varchar(2)
Go

Alter Table Staging.BCStore
Add PROBE_FLG Varchar(2)
Go

Alter Table Staging.BCStore
Add CSTONE_FLG Varchar(2)
Go

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--DIRECT_CUST_FLG, PROBE_FLG, CSTONE_FLG, CRM_LOCAL_FLG
-------------------------------
ALTER Proc [ETL].[pLoadFromCapstone]
AS		
	Set NoCount On;
	Declare @LastLoadTime DateTime
	Declare @LogID bigint 
	Declare @OPENQUERY nvarchar(4000)
	Declare @RecordCount int
	Declare @LastRecordDate DateTime

	------------------------------------------------------
	------------------------------------------------------
	Truncate Table Staging.BCRegion

	Select @LastLoadTime = IsNull(Max(IsNull(LatestLoadedRecordDate, '2013-1-1')), '2013-1-1')
	From ETL.BCDataLoadingLog l
	Where SchemaName = 'Staging' And TableName = 'BCRegion'
	And l.IsMerged = 1

	Insert ETL.BCDataLoadingLog([SchemaName], [TableName], [StartDate])
	Values ('Staging', 'BCRegion', GetDate())

	Select @LogID = SCOPE_IDENTITY()

	----------------------------------------
	Set @OPENQUERY = BC.udf_SetOpenQuery('SELECT 
	D.CNTRY_CODE, D.REGION_FIPS, D.REGION_ABRV, 
	   D.REGION_NM, D.ROW_MOD_DT
	FROM CAP_DM.DM_REGION D', 'COP', @LastLoadTime, 'D')
	Set @OPENQUERY = Replace(@OpenQuery, 'Select *', 'Insert Into Staging.BCRegion Select *')
	Exec (@OPENQUERY)
	----------------------------------------

	Select @RecordCount = Count(*) From Staging.BCRegion
	Select @LastRecordDate = Max(ROW_MOD_DT) From Staging.BCRegion

	Update ETL.BCDataLoadingLog 
	Set EndDate = GetDate(), NumberOfRecordsLoaded = @RecordCount, LatestLoadedRecordDate = @LastRecordDate
	Where LogID = @LogID

	------------------------------------------------------
	------------------------------------------------------
	Truncate Table Staging.BCCounty

	Select @LastLoadTime = IsNull(Max(IsNull(LatestLoadedRecordDate, '2013-1-1')), '2013-1-1')
	From ETL.BCDataLoadingLog l
	Where SchemaName = 'Staging' And TableName = 'BCCounty'
	And l.IsMerged = 1

	Insert ETL.BCDataLoadingLog([SchemaName], [TableName], [StartDate])
	Values ('Staging', 'BCCounty', GetDate())

	Select @LogID = SCOPE_IDENTITY()

	----------------------------------------
	Set @OPENQUERY = BC.udf_SetOpenQuery('SELECT 
	D.CNTRY_CODE, D.REGION_FIPS, D.CNTY_FIPS, 
	   D.CNTY_NM, D.CNTY_POP, D.ROW_MOD_DT 
	FROM CAP_DM.DM_CNTY D', 'COP', @LastLoadTime, 'D')
	Set @OPENQUERY = Replace(@OpenQuery, 'Select *', 'Insert Into Staging.BCCounty Select *')
	----------------------------------------
	Exec (@OPENQUERY)

	Select @RecordCount = Count(*) From Staging.BCCounty

	Select @LastRecordDate = Max(ROW_MOD_DT) From Staging.BCCounty

	Update ETL.BCDataLoadingLog 
	Set EndDate = GetDate(), NumberOfRecordsLoaded = @RecordCount, LatestLoadedRecordDate = @LastRecordDate
	Where LogID = @LogID

	------------------------------------------------------
	------------------------------------------------------
	Truncate Table Staging.BCStoreInclusion

	Select @LastLoadTime = IsNull(Max(IsNull(LatestLoadedRecordDate, '2013-1-1')), '2013-1-1')
	From ETL.BCDataLoadingLog l
	Where SchemaName = 'Staging' And TableName = 'BCStoreInclusion'
	And l.IsMerged = 1

	Insert ETL.BCDataLoadingLog([SchemaName], [TableName], [StartDate])
	Values ('Staging', 'BCStoreInclusion', GetDate())

	Select @LogID = SCOPE_IDENTITY()
	----------------------------------------
	Set @OPENQUERY = BC.udf_SetOpenQuery('SELECT 
	T.TRADEMARK_ID, T.PROD_TYPE_ID, T.TERR_VW_ID, 
	   T.STR_ID, T.BTTLR_ID, 
	   T.INCL_FOR_POSTAL_CODE, T.CNTRY_CODE, 
	   T.REGION_FIPS, T.CNTY_FIPS, T.STTS_ID, T.VLD_FROM_DT, T.VLD_TO_DT, T.ROW_MOD_DT
	FROM CAP_ODS.TM_STR_INCL T', 'COP', @LastLoadTime, 'T')
	Set @OPENQUERY = Replace(@OpenQuery, 'Select *', 'Insert Into Staging.BCStoreInclusion Select *')
	----------------------------------------
	Exec (@OPENQUERY)

	Select @RecordCount = Count(*) From Staging.BCStoreInclusion

	Select @LastRecordDate = Max(ROW_MOD_DT) From Staging.BCStoreInclusion

	Update ETL.BCDataLoadingLog 
	Set EndDate = GetDate(), NumberOfRecordsLoaded = @RecordCount, LatestLoadedRecordDate = @LastRecordDate
	Where LogID = @LogID

	------------------------------------------------------
	------------------------------------------------------
	Truncate Table Staging.BCStore

	Select @LastLoadTime = IsNull(Max(IsNull(LatestLoadedRecordDate, '2013-1-1')), '2013-1-1')
	From ETL.BCDataLoadingLog l
	Where SchemaName = 'Staging' And TableName = 'BCStore'
	And l.IsMerged = 1

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
		D.ROW_MOD_DT, 
		D.DIRECT_CUST_FLG, 
		D.PROBE_FLG, 
		D.CSTONE_FLG 
		FROM CAP_DM.DM_STR D', 'COP', @LastLoadTime, 'D')
	Set @OPENQUERY = Replace(@OpenQuery, 'Select *', 'Insert Into Staging.BCStore Select *')
	----------------------------------------
	Exec (@OPENQUERY)

	Select @RecordCount = Count(*) From Staging.BCStore

	Select @LastRecordDate = Max(ROW_MOD_DT) From Staging.BCStore

	Update ETL.BCDataLoadingLog 
	Set EndDate = GetDate(), NumberOfRecordsLoaded = @RecordCount, LatestLoadedRecordDate = @LastRecordDate
	Where LogID = @LogID

	------------------------------------------------------
	------------------------------------------------------
	Truncate Table Staging.BCBottlerHierachy

	Select @LastLoadTime = '2013-1-1'
	From ETL.BCDataLoadingLog l
	Where SchemaName = 'Staging' And TableName = 'BCBottlerHierachy'
	And l.IsMerged = 1

	Insert ETL.BCDataLoadingLog([SchemaName], [TableName], [StartDate])
	Values ('Staging', 'BCBottlerHierachy', GetDate())

	Select @LogID = SCOPE_IDENTITY()
	----------------------------------------
	Set @OPENQUERY = BC.udf_SetOpenQuery('SELECT 
	   D.NODE_GUID, 
	   D.SEQ_NBR, 
	   D.NODE_ID, 
	   D.NODE_DESC, 
	   D.NODE_VLD_FRM_DT, 
	   D.NODE_VLD_TO_DT, 
	   D.HIER_LVL_NBR, 
	   D.PRNT_GUID,
	   D.HIER_TYPE, 
	   D.PARTNER_GUID, 
	   D.PARTNER, 
	   D.BP_VLD_FRM_DT, 
	   D.BP_VLD_TO_DT, 
	   D.DEL_FLG, 
	   D.ROW_MOD_DT
	FROM CAP_DM.DM_BTTLR_HIER D', 'COP', @LastLoadTime, 'D')
	Set @OPENQUERY = Replace(@OpenQuery, 'Select *', 'Insert Into Staging.BCBottlerHierachy Select *')
	Set @OPENQUERY = Replace(@OpenQuery, 'MI:SS'''')'')', 'MI:SS'''') AND SYSDATE Between D.NODE_VLD_FRM_DT And D.NODE_VLD_TO_DT '')')
	----------------------------------------
	Exec (@OPENQUERY)

	Select @RecordCount = Count(*) From Staging.BCBottlerHierachy

	Select @LastRecordDate = Max(ROW_MOD_DT) From Staging.BCBottlerHierachy

	Update ETL.BCDataLoadingLog 
	Set EndDate = GetDate(), NumberOfRecordsLoaded = @RecordCount, LatestLoadedRecordDate = @LastRecordDate
	Where LogID = @LogID

	------------------------------------------------------
	------------------------------------------------------
	Truncate Table Staging.BCBottler

	Select @LastLoadTime = IsNull(Max(IsNull(LatestLoadedRecordDate, '2013-1-1')), '2013-1-1')
	From ETL.BCDataLoadingLog l
	Where SchemaName = 'Staging' And TableName = 'BCBottler'
	And l.IsMerged = 1

	Insert ETL.BCDataLoadingLog([SchemaName], [TableName], [StartDate])
	Values ('Staging', 'BCBottler', GetDate())

	Select @LogID = SCOPE_IDENTITY()
	----------------------------------------
	Set @OPENQUERY = BC.udf_SetOpenQuery('SELECT 
	   D.BTTLR_ID, D.BTTLR_NM, 
	   D.CHNL_CODE, D.GLOBAL_STTS, 
	   D.DEL_FLG, D.ROW_MOD_DT, 
	   D.PRODUCER_FLG
	FROM CAP_DM.DM_BTTLR D', 'COP', @LastLoadTime, 'D')
	Set @OPENQUERY = Replace(@OpenQuery, 'Select *', 'Insert Into Staging.BCBottler Select *')
	----------------------------------------
	Exec (@OPENQUERY)

	Select @RecordCount = Count(*) From Staging.BCBottler

	Select @LastRecordDate = Max(ROW_MOD_DT) From Staging.BCBottler

	Update ETL.BCDataLoadingLog 
	Set EndDate = GetDate(), NumberOfRecordsLoaded = @RecordCount, LatestLoadedRecordDate = @LastRecordDate
	Where LogID = @LogID

	------------------------------------------------------
	------------------------------------------------------
	Truncate Table Staging.BCBPAddress

	Select @LastLoadTime = IsNull(Max(IsNull(LatestLoadedRecordDate, '2013-1-1')), '2013-1-1')
	From ETL.BCDataLoadingLog l
	Where SchemaName = 'Staging' And TableName = 'BCBPAddress'
	And l.IsMerged = 1

	Insert ETL.BCDataLoadingLog([SchemaName], [TableName], [StartDate])
	Values ('Staging', 'BCBPAddress', GetDate())

	Select @LogID = SCOPE_IDENTITY()
	----------------------------------------
	Set @OPENQUERY = BC.udf_SetOpenQuery('SELECT 
	   D.ADDR_ID, 
	   D.ADDR_TYPE, 
	   D.BP_ID, 
	   D.ADDR_LINE_1, 
	   D.ADDR_LINE_2, 
	   D.ADDR_CITY, 
	   D.ADDR_REGION_ABRV, 
	   D.ADDR_CNTY_NM, 
	   D.ADDR_PSTL_CODE, 
	   D.ADDR_CNTRY_CODE, 
	   D.PHN_NBR, 
	   D.FAX_NBR, 
	   D.EMAIL, 
	   D.ROW_MOD_DT,
	   D.ADDR_REGION_FIPS, 
	   D.ADDR_CNTY_FIPS 
	FROM CAP_DM.DM_BP_ADDR D', 'COP', @LastLoadTime, 'D')
	Set @OPENQUERY = Replace(@OpenQuery, 'Select *', 'Insert Into Staging.BCBPAddress Select *')
	Set @OPENQUERY = Replace(@OpenQuery, 'MI:SS'''')'')', 'MI:SS'''') AND SYSDATE Between D.VLD_FRM_DT And D.VLD_TO_DT 
	And D.DEL_FLG <> ''''Y'''''')')
	----------------------------------------
	Exec (@OPENQUERY)

	Select @RecordCount = Count(*) From Staging.BCBPAddress

	Select @LastRecordDate = Max(ROW_MOD_DT) From Staging.BCBPAddress

	Update ETL.BCDataLoadingLog 
	Set EndDate = GetDate(), NumberOfRecordsLoaded = @RecordCount, LatestLoadedRecordDate = @LastRecordDate
	Where LogID = @LogID

	------------------------------------------------------
	------------------------------------------------------
	Truncate Table Staging.BCvBottlerExternalHierachy

	Select @LastLoadTime = IsNull(Max(LatestLoadedRecordDate), '2013-1-1')
	From ETL.BCDataLoadingLog l
	Where SchemaName = 'Staging' And TableName = 'BCvBottlerExternalHierachy'
	And l.IsMerged = 1

	Insert ETL.BCDataLoadingLog([SchemaName], [TableName], [StartDate])
	Values ('Staging', 'BCvBottlerExternalHierachy', GetDate())

	Select @LogID = SCOPE_IDENTITY()
	----------------------------------------
	Set @OPENQUERY = 'Insert Into Staging.BCvBottlerExternalHierachy Select * From OpenQuery(COP, ''SELECT 
	V.BTTLR_GUID, V.BTTLR_ID, V.HIER_TYPE, 
	   V.NODE4_GUID, V.NODE4_ID, V.NODE4_DESC, 
	   V.NODE3_GUID, V.NODE3_ID, V.NODE3_DESC, 
	   V.NODE2_GUID, V.NODE2_ID, V.NODE2_DESC, 
	   V.NODE1_GUID, V.NODE1_ID, V.NODE1_DESC
	FROM CAP_DM.VW_DM_BTTLR_EBH_HIER V'')'
	----------------------------------------
	Exec (@OPENQUERY)

	Select @RecordCount = Count(*) From Staging.BCvBottlerExternalHierachy

	Update ETL.BCDataLoadingLog 
	Set EndDate = GetDate(), NumberOfRecordsLoaded = @RecordCount, LatestLoadedRecordDate = StartDate
	Where LogID = @LogID

	------------------------------------------------------
	------------------------------------------------------
	Truncate Table Staging.BCvBottlerSalesHierachy

	Select @LastLoadTime = IsNull(Max(LatestLoadedRecordDate), '2013-1-1')
	From ETL.BCDataLoadingLog l
	Where SchemaName = 'Staging' And TableName = 'BCvBottlerSalesHierachy'
	And l.IsMerged = 1

	Insert ETL.BCDataLoadingLog([SchemaName], [TableName], [StartDate])
	Values ('Staging', 'BCvBottlerSalesHierachy', GetDate())

	Select @LogID = SCOPE_IDENTITY()
	----------------------------------------
	Set @OPENQUERY = 'Insert Into Staging.BCvBottlerSalesHierachy Select * 
	From OpenQuery(COP, ''Select V.BTTLR_GUID, V.BTTLR_ID, V.HIER_TYPE,
	V.REGION_DESC, V.REGION_GUID, V.REGION_ID,
	V.DIVISION_DESC, V.DIVISION_GUID, V.DIVISION_ID, 
	V.ZONE_DESC, V.ZONE_GUID, V.ZONE_ID, 
	V.SYSTEM_DESC, V.SYSTEM_GUID, V.SYSTEM_ID, 
	V.CCNTRY_DESC, V.CCNTRY_GUID, V.CCNTRY_ID, 
	V.TCOMP_DESC, V.TCOMP_GUID, V.TCOMP_ID
	FROM CAP_DM.VW_DM_BTTLR_SA_HIER V'')'
	----------------------------------------
	Exec (@OPENQUERY)

	Select @RecordCount = Count(*) From Staging.BCvBottlerSalesHierachy

	Update ETL.BCDataLoadingLog 
	Set EndDate = GetDate(), NumberOfRecordsLoaded = @RecordCount, LatestLoadedRecordDate = StartDate
	Where LogID = @LogID

	------------------------------------------------------
	------------------------------------------------------
	Truncate Table Staging.BCHierachyEmployee

	Set @LastLoadTime = '1800-1-1'

	Insert ETL.BCDataLoadingLog([SchemaName], [TableName], [StartDate])
	Values ('Staging', 'BCHierachyEmployee', GetDate())

	Select @LogID = SCOPE_IDENTITY()
	----------------------------------------
	Set @OPENQUERY = BC.udf_SetOpenQuery('SELECT 
	   D.NODE_GUID, D.EMP_GUID, D.EMP_FUNC, 
	   D.EMP_GSN, D.EMP_ID, D.NODE_ID, 
	   D.NODE_DESC, D.HIER_TYPE, D.FIRST_NM, 
	   D.LAST_NM, D.PSTN, D.EMAIL, 
	   D.PHN_NBR, D.ADDR_LINE_1, D.FAX_NBR, 
	   D.ADDR_LINE_2, D.ADDR_CITY, D.ADDR_REGION_ABRV, 
	   D.ADDR_POSTAL_CODE, D.VLD_FRM_DT, D.VLD_TO_DT, 
	   D.DEL_FLG, D.ROW_MOD_DT
	FROM CAP_DM.DM_BTTLR_HIER_EMP D', 'COP', @LastLoadTime, 'D')
	Set @OPENQUERY = Replace(@OpenQuery, 'Select *', 'Insert Into Staging.BCHierachyEmployee Select *')

	----------------------------------------
	Exec (@OPENQUERY)

	Select @RecordCount = Count(*) From Staging.BCHierachyEmployee

	Select @LastRecordDate = Max(ROW_MOD_DT) From Staging.BCHierachyEmployee

	Update ETL.BCDataLoadingLog 
	Set EndDate = GetDate(), NumberOfRecordsLoaded = @RecordCount, LatestLoadedRecordDate = @LastRecordDate
	Where LogID = @LogID

	------------------------------------------------------
	------------------------------------------------------
	Truncate Table Staging.BCTMap

	Select @LastLoadTime = IsNull(Max(LatestLoadedRecordDate), '2013-01-01 14:20:15')
	From ETL.BCDataLoadingLog l
	Where SchemaName = 'Staging' And TableName = 'BCTMap'
	And l.IsMerged = 1

	Insert ETL.BCDataLoadingLog([SchemaName], [TableName], [StartDate])
	Values ('Staging', 'BCTMap', GetDate())

	Select @LogID = SCOPE_IDENTITY()
	----------------------------------------
	Set @OPENQUERY = BC.udf_SetOpenQuery('SELECT 
	T.TRADEMARK_ID, T.PROD_TYPE_ID, T.TERR_VW_ID, T.CNTRY_CODE, T.REGION_FIPS, T.CNTY_FIPS, 
	   T.POSTAL_CODE, T.BTTLR_ID, T.VLD_FROM_DT, T.VLD_TO_DT, T.ROW_MOD_DT
	FROM CAP_ODS.TM_TERRITORY_MAP T', 'COP', @LastLoadTime, 'T')
	Set @OPENQUERY = Replace(@OpenQuery, 'Select *', 'Insert Into Staging.BCTMap Select *')
	Set @OPENQUERY = Replace(@OpenQuery, 'Where', 'WHERE T.CNTRY_CODE = ''''US'''' 
	AND T.PROD_TYPE_ID=''''01'''' AND T.TERR_VW_ID IN (''''11'''', ''''12'''') AND SYSDATE BETWEEN T.VLD_FROM_DT AND T.VLD_TO_DT AND')
	----------------------------------------
	Exec (@OPENQUERY)

	Select @RecordCount = Count(*) From Staging.BCTMap

	Select @LastRecordDate = Max(ROW_MOD_DT) From Staging.BCTMap

	Update ETL.BCDataLoadingLog 
	Set EndDate = GetDate(), NumberOfRecordsLoaded = @RecordCount, LatestLoadedRecordDate = @LastRecordDate
	Where LogID = @LogID

	------------------------------------------------------
	------------------------------------------------------
	Truncate Table Staging.BCStoreHier

	Select @LastLoadTime = IsNull(Max(LatestLoadedRecordDate), '2013-01-01')
	From ETL.BCDataLoadingLog l
	Where SchemaName = 'Staging' And TableName = 'BCStoreHier'
	And l.IsMerged = 1

	Insert ETL.BCDataLoadingLog([SchemaName], [TableName], [StartDate])
	Values ('Staging', 'BCStoreHier', GetDate())

	Select @LogID = SCOPE_IDENTITY()
	----------------------------------------
	Set @OPENQUERY = BC.udf_SetOpenQuery('SELECT 
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
	Set @OPENQUERY = Replace(@OpenQuery, 'Select *', 'Insert Into Staging.BCStoreHier Select *')
	----------------------------------------
	Exec (@OPENQUERY)

	Select @RecordCount = Count(*) From Staging.BCStoreHier

	Select @LastRecordDate = Max(ROW_MOD_DT) From Staging.BCStoreHier

	Update ETL.BCDataLoadingLog 
	Set EndDate = GetDate(), NumberOfRecordsLoaded = @RecordCount, LatestLoadedRecordDate = @LastRecordDate
	Where LogID = @LogID

	------------------------------------------------------
	------------------------------------------------------
	Truncate Table Staging.BCProduct1

	Select @LastLoadTime = IsNull(Max(LatestLoadedRecordDate), '2013-01-01')
	From ETL.BCDataLoadingLog l
	Where SchemaName = 'Staging' And TableName = 'BCProduct1'
	And l.IsMerged = 1

	Insert ETL.BCDataLoadingLog([SchemaName], [TableName], [StartDate])
	Values ('Staging', 'BCProduct1', GetDate())

	Select @LogID = SCOPE_IDENTITY()
	----------------------------------------
	Set @OPENQUERY = BC.udf_SetOpenQuery('SELECT PROD_ID
		  ,PROD_DESC
		  ,PROD_STTS
		  ,TRADEMARK_ID
		  ,TRADEMARK_DESC
		  ,TRADEMARK_GRP_ID
		  ,TRADEMARK_GRP_DESC
		  ,CORE_BRND_GRP_ID
		  ,CORE_BRND_GRP_DESC
		  ,CNTNR_TYPE_ID
		  ,CNTNR_TYPE_DESC
		  ,PKG_ID
		  ,PKG_DESC
		  ,CAFF_CLAIM_ID
		  ,CAFF_CLAIM_DESC
		  ,PKG_EXTN_ID
		  ,PKG_EXTN
		  ,BEV_TYPE_ID
		  ,BEV_TYPE_DESC
		  ,FLVR_ID
		  ,FLVR_DESC
		  ,CARB_CODE
		  ,CARB_CODE_DESC
		  ,CNTNR_SZ_DESC
		  ,ROW_MOD_DT
	FROM CAP_DM.DM_PROD D', 'COP', @LastLoadTime, 'D')
	Set @OPENQUERY = Replace(@OpenQuery, 'Select *', 'Insert Into Staging.BCProduct1 Select *')
	----------------------------------------
	Exec (@OPENQUERY)

	Select @RecordCount = Count(*) From Staging.BCProduct1

	Select @LastRecordDate = Max(ROW_MOD_DT) From Staging.BCProduct1

	Update ETL.BCDataLoadingLog 
	Set EndDate = GetDate(), NumberOfRecordsLoaded = @RecordCount, LatestLoadedRecordDate = @LastRecordDate
	Where LogID = @LogID

	------------------------------------------------------
	------------------------------------------------------
	Truncate Table Staging.BCProduct2

	Select @LastLoadTime = IsNull(Max(LatestLoadedRecordDate), '2013-01-01')
	From ETL.BCDataLoadingLog l
	Where SchemaName = 'Staging' And TableName = 'BCProduct2'
	And l.IsMerged = 1

	Insert ETL.BCDataLoadingLog([SchemaName], [TableName], [StartDate])
	Values ('Staging', 'BCProduct2', GetDate())

	Select @LogID = SCOPE_IDENTITY()
	----------------------------------------
	Set @OPENQUERY = BC.udf_SetOpenQuery('SELECT D.PROD_ID,
	   D.PKG_TYPE_ID, D.PKG_TYPE_DESC, D.PKG_CFG_ID, 
	   D.PKG_CFG_DESC, D.PKG_CAT_DESC, D.PKG_VERSION, 
	   D.PCK_VERS_DESC, D.PCK_CONSU_PK_DESC, D.CNSMR_BRND_ID, 
	   D.CNSMR_BRND_DESC, D.CAT_SEG_ID, D.CAT_SEG_DESC, 
	   D.INIT_CAT_SEG_ID, D.INIT_CAT_SEG_DESC, D.CAL_CLASS_ID, 
	   D.CAL_CLASS_DESC, D.BASE_PROD_DESC, D.BS_PR_WEB_PR_FLG, 
	   D.VLD_ALL_CHAINS, D.UNITS_IN_PCK, D.PCKS_IN_CASE, 
	   D.BASE_PCK_TYPE_DESC, D.PKG_WEB_PRC_FLG, D.STARS_ID, 
	   D.NAIS_ID, D.CSTONE_ID, D.PROBE_ID, 
	   D.MDM_ID, D.CONV_CASE_CONV_FCTR, D.RELEVANCE_PRC_FLG, 
	   D.CS_SLS_RELEVANT_FLG, D.GTIN, D.INFO_PROVIDER_GLN, 
	   D.UPC10, D.CNSMR_UPC, D.FRANCHISOR_ID, 
	   D.FRANCHISOR_DE, D.PROD_ALIGN_ID, D.PROD_ALIGN_DESC, D.DEL_FLG, 
	   D.ROW_MOD_DT, D.PROD_GUID, 
	   D.PACK_GRP, D.PACK_GRP_DESC
	   FROM CAP_DM.DM_PROD D', 'COP', @LastLoadTime, 'D')
	Set @OPENQUERY = Replace(@OpenQuery, 'Select *', 'Insert Into Staging.BCProduct2 Select *')
	----------------------------------------
	Exec (@OPENQUERY)

	Select @RecordCount = Count(*) From Staging.BCProduct2

	Select @LastRecordDate = Max(ROW_MOD_DT) From Staging.BCProduct2

	Update ETL.BCDataLoadingLog 
	Set EndDate = GetDate(), NumberOfRecordsLoaded = @RecordCount, LatestLoadedRecordDate = @LastRecordDate
	Where LogID = @LogID

	------------------------------------------------------
	Truncate Table Processing.BCBottlerEBNodes

	Insert Into Processing.BCBottlerEBNodes
	Select NODE_ID, Max(ROW_MOD_DT) ROW_MOD_DT
	From Staging.BCBottlerHierachy h
	Where DEL_FLG <> 'Y'
	Group By NODE_ID	

	------------------------------------------------------

	Truncate Table Processing.BottlerLEGLatestUpdatedDate

	Insert Into Processing.BottlerLEGLatestUpdatedDate
	Select PARTNER, HIER_TYPE, Count(*) LEG_COUNT, MAX(ROW_MOD_DT) ROW_MOD_DT
	From Staging.BCBottlerHierachy
	Where PARTNER is not null
	And DEL_FLG <> 'Y'
	Group By PARTNER, HIER_TYPE
	------------------------------------------------------

	Truncate Table Processing.BCChainLastModified

	Insert Into Processing.BCChainLastModified
	Select NODE_ID, Max(ROW_MOD_DT) ROW_MOD_DT
	From Staging.BCStoreHier l1
	Where GetDate() Between l1.NODE_VLD_FRM_DT And l1.NODE_VLD_TO_DT 
	And l1.DEL_FLG <> 'Y'
	Group By NODE_ID
	------------------------------------------------------
	------------------------------------------------------
Go

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--******************************************
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
			Case When GetDate() Between STR_OPEN_DT And STR_CLOSE_DT And DEL_FLG <> 'Y' And CRM_LOCAL_FLG = 'X' Then 1 Else 0 End CRMActive,
			--DIRECT_CUST_FLG, PROBE_FLG, CSTONE_FLG, CRM_LOCAL_FLG
			Case When IsNull(CRM_LOCAL_FLG, '') = 'X' Then 1 Else 0 End CRMLocalFlg,
			Case When IsNull(DIRECT_CUST_FLG, '') = 'X' Then 1 Else 0 End DirectCustomerFlg,
			Case When IsNull(PROBE_FLG, '') = 'X' Then 1 Else 0 End ProbeFlg,
			Case When IsNull(CSTONE_FLG, '') = 'X' Then 1 Else 0 End ConnerStoneFlg
			--DirectCustomerFlg, ProbeFlg, ConnerStoneFlg, CRMLocalFlg
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
					--Latitude = Case When pc.Latitude is null And pc.Longitude is null Then input.Latitude Else pc.Latitude End,
					--Longitude = Case When pc.Latitude is null And pc.Longitude is null Then input.Longitude Else pc.Longitude End,
					--GeoSource = Case When pc.Latitude is null And pc.Longitude is null Then 'Cap' Else 'RN' End,
					CRMActive = input.CRMActive, -- this is updated from capstone
					CRMLocalFlg = input.CRMActive,
					DirectCustomerFlg = input.DirectCustomerFlg,
					ProbeFlg = input.ProbeFlg,
					ConnerStoneFlg = input.ConnerStoneFlg
					-- LastModified is not updated
	WHEN NOT MATCHED By Target THEN
		INSERT([SAPAccountNumber],[AccountName],[ChannelID],[LocalChainID]
		--,[Longitude],[Latitude]
		,[CRMActive]
		,[LastModified], Format 
		,[TDLinxID],[CapstoneLastModified],GEOSource, InCapstone, DirectCustomerFlg, ProbeFlg, ConnerStoneFlg, CRMLocalFlg)
		VALUES(input.STR_ID, STR_NM, input.ChannelID, input.LocalChainID
		--,input.Latitude, input.Longitude
		,input.CRMActive
		,input.CapstoneLastModified, input.Format 
		,input.TDLinx_ID, input.CapstoneLastModified, input.GeoSource, 1, input.DirectCustomerFlg, input.ProbeFlg, input.ConnerStoneFlg, input.CRMLocalFlg);
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

Go

Select *
Into ETL.BCDataLoadingLogV1
From ETL.BCDataLoadingLog
Go

Update ETL.BCDataLoadingLog
Set LatestLoadedRecordDate = Null
Where TableName = 'BCStore'
Go
