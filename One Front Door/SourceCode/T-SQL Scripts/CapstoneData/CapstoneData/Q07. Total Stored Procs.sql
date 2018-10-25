USE Portal_Data_INT
GO

/****** Object:  UserDefinedFunction [BC].[udf_SetOpenQuery]    Script Date: 5/1/2014 12:18:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  UserDefinedFunction [BC].[udf_SetOpenQuery]    Script Date: 5/1/2014 12:18:47 PM ******/
CREATE Function [BC].[udf_ConvertToPLSqlTimeFilter]
(
	@InputTime DateTime,
	@ObjectAlias Varchar(20) = null
)
Returns Varchar(200)
As
	Begin
		Declare @retval varchar(200)
		Set @retval = 'WHERE '
		If (IsNUll(@ObjectAlias, '') <> '')
			Set @retval += @ObjectAlias + '.'
		Set @retval += 'ROW_MOD_DT > TO_DATE('''''
		Set @retval += convert(varchar, @InputTime, 120)
		Set @retval += ''''', ''''YYYY-MM-DD HH24:MI:SS'''')'

		Return @retval
	End

GO

CREATE Function [BC].[udf_SetOpenQuery]
(
	@Query Varchar(1024),
	@LinkedServerName Varchar(20) = 'COP',
	@InputTime DateTime,
	@ObjectAlias Varchar(20) = null
)
Returns Varchar(1024)
As
	Begin
		Declare @retval varchar(1024)
		Set @retval = 'Select * From OpenQuery(' 
		Set @retval += @LinkedServerName +  ', ''';
		Set @retval += @Query;
		Set @retval += ' ' + BC.udf_ConvertToPLSqlTimeFilter(@InputTime, Default)
		Set @retval += ''')'

		Return @retval
	End

GO

/****** Object:  StoredProcedure [ETL].[pLoadFromCapstone]    Script Date: 5/1/2014 11:28:50 AM ******/
If Exists (Select * From Sys.procedures Where Object_ID = Object_ID('ETL.pLoadFromCapstone'))
Begin
	Drop Proc ETL.pLoadFromCapstone
End
Go

-- exec ETL.pLoadFromCapstone --

Create Proc [ETL].[pLoadFromCapstone]
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
GO

/****** Object:  StoredProcedure [ETL].[pMergeCapstoneBottler]    Script Date: 5/1/2014 11:28:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- exec ETL.pMergeCapstoneBottler --
CREATE Proc [ETL].[pMergeCapstoneBottler]
AS		
	Set NoCount On;

	-- first round is bottler --
	Merge BC.Bottler As BTTR
	Using ( 
			Select B.BTTLR_ID, Replace(Replace(Replace(dbo.udf_TitleCase(BTTLR_NM), 'Pb - ', 'PB - '), 'Ccr ', 'CCR '), 'Usf ', 'USF ') BTTLR_NM, c.ChannelID, 
				Case When b.DEL_FLG = 'Y' 
					Then 99 
					Else b.GLOBAL_STTS
				End GLOBAL_STTS, 
			r.RegionID BCRegionID, r2.RegionID FSRegionID, eb4.EB4ID,
			b.ROW_MOD_DT,
			tempMDT1.ROW_MOD_DT EB_ROW_MOD_DT,
			tempMDT2.ROW_MOD_DT BC_ROW_MOD_DT,
			tempMDT3.ROW_MOD_DT FS_ROW_MOD_DT
		From Staging.BCBottler b
			Left Join SAP.Channel c on b.CHNL_CODE = c.SAPChannelID
			Left Join Staging.BCvBottlerExternalHierachy e on e.BTTLR_ID = b.BTTLR_ID
			Left Join Processing.BottlerLEGLatestUpdatedDate tempMDT1 on tempMDT1.Partner = b.BTTLR_ID And tempMDT1.HIER_TYPE = 'EB'
			Left Join BC.BottlerEB4 eb4 on eb4.BCNodeID = e.NODE4_ID
			Left Join Staging.BCvBottlerSalesHierachy sh on sh.BTTLR_ID = b.BTTLR_ID and sh.HIER_TYPE = 'BC'
			Left Join BC.Region r on r.BCNodeID = sh.REGION_ID
			Left Join Processing.BottlerLEGLatestUpdatedDate tempMDT2 on tempMDT2.Partner = b.BTTLR_ID And tempMDT2.HIER_TYPE = 'BC'
			Left Join Staging.BCvBottlerSalesHierachy shfs on shfs.BTTLR_ID = b.BTTLR_ID and shfs.HIER_TYPE = 'FS'
			Left Join BC.Region r2 on r2.BCNodeID = shfs.REGION_ID
			Left Join Processing.BottlerLEGLatestUpdatedDate tempMDT3 on tempMDT3.Partner = b.BTTLR_ID And tempMDT3.HIER_TYPE = 'FS'
			Where b.DEL_FLG <> 'Y' And GLOBAL_STTS = 02
		) As input
	On BTTR.[BCBottlerID] = Convert(bigint, input.BTTLR_ID)
	When Matched Then
		Update Set BottlerName = input.BTTLR_NM,
				ChannelID = input.ChannelID,
				GlobalStatusID = input.GLOBAL_STTS,
				EB4ID = input.EB4ID,
				BCRegionID = input.BCRegionID,
				FSRegionID = input.FSRegionID,
				LastModified = input.ROW_MOD_DT,
				EB4LastModified = input.EB_ROW_MOD_DT,
				[BCRegionLastModified] = input.BC_ROW_MOD_DT,
				[FSRegionLastModified] = input.FS_ROW_MOD_DT
	When Not Matched By Target Then
		Insert([BCBottlerID],[BottlerName],[ChannelID],[GlobalStatusID],[EB4ID],
		[BCRegionID],[FSRegionID],[LastModified],
		EB4LastModified,[BCRegionLastModified],[FSRegionLastModified], GeoCodingNeeded)
		Values(input.BTTLR_ID,input.BTTLR_NM,input.ChannelID,input.GLOBAL_STTS,input.EB4ID,
		input.BCRegionID,input.FSRegionID,input.ROW_MOD_DT,
		input.EB_ROW_MOD_DT,input.BC_ROW_MOD_DT,input.FS_ROW_MOD_DT, 0);

	-- second round is bottler address--
	Merge BC.Bottler As BTTR
	Using ( 
			Select a.BP_ID,
			dbo.udf_TitleCase(Case When a.[ADDR_LINE_1] Like 'Xxx%' Then Null Else a.[ADDR_LINE_1] End) ADDR_LINE_1,
			dbo.udf_TitleCase(Case When a.[ADDR_CITY] Like 'Xxx%' Then Null Else a.[ADDR_CITY] End) ADDR_CITY,
			a.ADDR_REGION_ABRV,
			a.[ADDR_PSTL_CODE],
			a.EMAIL,
			a.PHN_NBR,
			a.ADDR_CNTRY_CODE,
			a.ROW_MOD_DT Address_ROW_MOD_DT,
			dbo.udf_TitleCase(a.ADDR_CNTY_NM) ADDR_CNTY_NM
		From Staging.BCBPAddress a 
		) As input
	On BTTR.BCBottlerID = input.BP_ID
	When Matched Then
		Update Set 
				Address = input.ADDR_LINE_1,
				City = input.ADDR_CITY,
				County = input.ADDR_CNTY_NM,
				State = input.ADDR_REGION_ABRV,
				PostalCode = input.ADDR_PSTL_CODE,
				Email = input.EMAIL,
				PhoneNumber = input.PHN_NBR,
				GeoCodingNeeded = 1,
				AddressLastModified = input.Address_ROW_MOD_DT;

	----------------------------------------
	----------------------------------------
	Declare @LogID int

	Select @LogID = Max(LogID)
	From ETL.BCDataLoadingLog
	Where SchemaName = 'Staging' 
	And TableName = 'BCvBottlerExternalHierachy'

	Update ETL.BCDataLoadingLog
	Set MergeDate = GetDate()
	Where  LogID = @LogID

	Select @LogID = Max(LogID)
	From ETL.BCDataLoadingLog
	Where SchemaName = 'Staging' 
	And TableName = 'BCvBottlerSalesHierachy'

	Update ETL.BCDataLoadingLog
	Set MergeDate = GetDate()
	Where LogID = @LogID

	Select @LogID = Max(LogID)
	From ETL.BCDataLoadingLog
	Where SchemaName = 'Staging' 
	And TableName = 'BCBottlerHierachy'

	Update ETL.BCDataLoadingLog
	Set MergeDate = GetDate()
	Where LogID = @LogID

	Select @LogID = Max(LogID)
	From ETL.BCDataLoadingLog
	Where SchemaName = 'Staging' 
	And TableName = 'BCBottler'

	Update ETL.BCDataLoadingLog
	Set MergeDate = GetDate()
	Where LogID = @LogID
	----------------------------------------
	----------------------------------------

GO
/****** Object:  StoredProcedure [ETL].[pMergeCapstoneBottlerERH]    Script Date: 5/1/2014 11:28:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
Assuming Full Set of Bottler Hier Table is loaded.

exec ETL.pMergeCapstoneBottlerERH

SElect *
From Staging.BCvBottlerExternalHierachy
 
Select *
From Processing.BCBottlerEBNodes

*/ 

Create Proc [ETL].[pMergeCapstoneBottlerERH]
AS
	Set NoCount On;
	----------------------------------------
	--- EB1 ----
	----------------------------------------
	MERGE BC.BottlerEB1 AS pc
		USING (	Select e.ROW_MOD_DT, b.NODE_ID, b.NODE_DESC
				From Processing.BCBottlerEBNodes e 
				Join (Select Distinct NODE1_ID NODE_ID, 
						Replace(dbo.udf_TitleCase(NODE1_DESC), '_', ' ') NODE_DESC
						From Staging.BCvBottlerExternalHierachy) b on e.NODE_ID = b.NODE_ID
				) AS input
			ON pc.BCNodeID = input.NODE_ID
	WHEN MATCHED THEN
		UPDATE SET pc.EB1Name = input.NODE_DESC,
				   pc.LastModified = input.ROW_MOD_DT, 
				   pc.Active = 1
	WHEN NOT MATCHED By Target THEN
		INSERT(EB1Name, BCNodeID, Active, LastModified)
		VALUES(input.NODE_DESC, input.NODE_ID, 1, ROW_MOD_DT)
	WHEN NOT MATCHED By Source THEN
		Update Set pc.Active = 0;

	Update BC.BottlerEB1
	Set Active = 0
	Where BCNodeID = 'ZINACTV'

	----------------------------------------
	--- EB2 ----
	----------------------------------------
	MERGE BC.BottlerEB2 AS pc
		USING (	Select e.ROW_MOD_DT, b.NODE_ID, b.NODE_DESC, b1.EB1ID
				From Processing.BCBottlerEBNodes e 
				Join (Select Distinct NODE2_ID NODE_ID, NODE1_ID PRNT_ID,
						Replace(dbo.udf_TitleCase(NODE2_DESC), '_', ' ') NODE_DESC
						From Staging.BCvBottlerExternalHierachy) b on e.NODE_ID = b.NODE_ID
				Join BC.BottlerEB1 b1 on b1.BCNodeID = b.PRNT_ID) AS input
			ON pc.BCNodeID = input.NODE_ID
	WHEN MATCHED THEN
		UPDATE SET pc.EB2Name = input.NODE_DESC,
					pc.BCNodeID = input.NODE_ID,
					pc.LastModified = input.ROW_MOD_DT,
					pc.Active = 1,
					pc.EB1ID = input.EB1ID
	WHEN NOT MATCHED By Target THEN
		INSERT([EB2Name], [BCNodeID], Active, [LastModified], EB1ID)
		VALUES(input.NODE_DESC, input.NODE_ID, 1, input.ROW_MOD_DT, input.EB1ID)
	WHEN NOT MATCHED By Source THEN
		Update Set pc.Active = 0;

	Update eb2
	Set Active = 0
	From BC.BottlerEB1 eb1
	Join BC.BottlerEB2 eb2 on eb1.EB1ID = eb2.EB1ID
	Where eb1.BCNodeID = 'ZINACTV'

	----------------------------------------
	--- EB3 ----
	----------------------------------------
	MERGE BC.BottlerEB3 AS pc
		USING (	Select e.ROW_MOD_DT, b.NODE_ID, b.NODE_DESC, b2.EB2ID
				From Processing.BCBottlerEBNodes e 
				Join (Select Distinct NODE3_ID NODE_ID, NODE2_ID PRNT_ID,
						Replace(dbo.udf_TitleCase(NODE3_DESC), '_', ' ') NODE_DESC
						From Staging.BCvBottlerExternalHierachy) b on e.NODE_ID = b.NODE_ID
				Join BC.BottlerEB2 b2 on b2.BCNodeID = b.PRNT_ID) AS input
			ON pc.BCNodeID = input.NODE_ID
	WHEN MATCHED THEN
		UPDATE SET pc.EB3Name = input.NODE_DESC,
					pc.BCNodeID = input.NODE_ID,
					pc.LastModified = input.ROW_MOD_DT,
					pc.Active = 1,
					pc.EB2ID = input.EB2ID
	WHEN NOT MATCHED By Target THEN
		INSERT(EB3Name, BCNodeID, Active, LastModified, EB2ID)
		VALUES(input.NODE_DESC, input.NODE_ID, 1, input.ROW_MOD_DT, input.EB2ID)
	WHEN NOT MATCHED By Source THEN
		Update Set pc.Active = 0;

	Update eb3
	Set Active = 0
	From BC.BottlerEB1 eb1
	Join BC.BottlerEB2 eb2 on eb1.EB1ID = eb2.EB1ID
	Join BC.BottlerEB3 eb3 on eb2.EB2ID = eb3.EB2ID
	Where eb1.BCNodeID = 'ZINACTV'

	----------------------------------------
	--- EB4 ----
	----------------------------------------
	MERGE BC.BottlerEB4 AS pc
		USING (	Select e.ROW_MOD_DT, b.NODE_ID, b.NODE_DESC, b3.EB3ID
				From Processing.BCBottlerEBNodes e 
				Join (Select Distinct NODE4_ID NODE_ID, NODE3_ID PRNT_ID,
						Replace(dbo.udf_TitleCase(NODE4_DESC), '_', ' ') NODE_DESC
						From Staging.BCvBottlerExternalHierachy) b on e.NODE_ID = b.NODE_ID
				Join BC.BottlerEB3 b3 on b3.BCNodeID = b.PRNT_ID) AS input
			ON pc.BCNodeID = input.NODE_ID
	WHEN MATCHED THEN
		UPDATE SET pc.EB4Name = input.NODE_DESC,
					pc.BCNodeID = input.NODE_ID,
					pc.LastModified = input.ROW_MOD_DT,
					pc.Active = 1,
					pc.EB3ID = input.EB3ID
	WHEN NOT MATCHED By Target THEN
		INSERT(EB4Name, BCNodeID, Active, LastModified, EB3ID)
		VALUES(input.NODE_DESC, input.NODE_ID, 1, input.ROW_MOD_DT, input.EB3ID)
	WHEN NOT MATCHED By Source THEN
		Update Set pc.Active = 0;

	Update eb4
	Set Active = 0
	From BC.BottlerEB1 eb1
	Join BC.BottlerEB2 eb2 on eb1.EB1ID = eb2.EB1ID
	Join BC.BottlerEB3 eb3 on eb2.EB2ID = eb3.EB2ID
	Join BC.BottlerEB4 eb4 on eb3.EB3ID = eb4.EB3ID
	Where eb1.BCNodeID = 'ZINACTV'

	Declare @LogID int

	Select @LogID = Max(LogID)
	From ETL.BCDataLoadingLog
	Where SchemaName = 'Staging' 
	And TableName = 'BCvBottlerExternalHierachy'

	Update ETL.BCDataLoadingLog
	Set MergeDate = GetDate()
	Where  LogID = @LogID

GO

/****** Object:  StoredProcedure [ETL].[pMergeCapstoneBottlerHier]    Script Date: 5/1/2014 11:28:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
exec ETL.pMergeCapstoneBottlerHier
*/ 

Create Proc [ETL].[pMergeCapstoneBottlerHier]
AS

	Set NoCount On;
	----------------------------------------
	--- BC.TotalCompany ----
	----------------------------------------
	MERGE BC.TotalCompany AS pc
		USING (	Select e.ROW_MOD_DT, b.NODE_ID, b.NODE_DESC, b.HIER_TYPE
				From Processing.BCBottlerEBNodes e 
				Join (  Select Distinct TCOMP_ID NODE_ID, dbo.udf_TitleCase(TCOMP_DESC) NODE_DESC, HIER_TYPE
						From Staging.BCvBottlerSalesHierachy) b on e.NODE_ID = b.NODE_ID
			  ) AS input
			ON pc.BCNodeID = input.NODE_ID
	WHEN MATCHED THEN
		UPDATE SET pc.TotalCompanyName = input.NODE_DESC,
				   pc.LastModified = input.ROW_MOD_DT, 
				   pc.HierType = input.HIER_TYPE,
				   pc.Active = 1
	WHEN NOT MATCHED By Target THEN
		INSERT(TotalCompanyName, BCNodeID, Active, LastModified, HierType)
		VALUES(input.NODE_DESC, input.NODE_ID, 1, ROW_MOD_DT, HIER_TYPE)
	WHEN NOT MATCHED By Source THEN
		Update Set pc.Active = 0;

	----------------------------------------
	--- BC.Country ----
	----------------------------------------
	MERGE BC.Country AS pc
		USING (	Select e.ROW_MOD_DT, b.NODE_ID, b.NODE_DESC, b2.TotalCompanyID
				From Processing.BCBottlerEBNodes e 
				Join (  Select Distinct TCOMP_ID PRNT_ID, CCNTRY_ID NODE_ID, dbo.udf_TitleCase([CCNTRY_DESC]) NODE_DESC
						From Staging.BCvBottlerSalesHierachy) b on e.NODE_ID = b.NODE_ID
				Join BC.TotalCompany b2 on b2.BCNodeID = b.PRNT_ID
				) AS input
			ON pc.BCNodeID = input.NODE_ID
	WHEN MATCHED THEN
		UPDATE SET pc.CountryName = Upper(Substring(input.NODE_DESC, 1, 5)) + Substring(input.NODE_DESC, 6, 99),
				   pc.LastModified = input.ROW_MOD_DT, 
				   pc.TotalCompanyID = input.TotalCompanyID,
				   pc.Active = 1
	WHEN NOT MATCHED By Target THEN
		INSERT(CountryName, BCNodeID, Active, LastModified, TotalCompanyID)
		VALUES(Upper(Substring(input.NODE_DESC, 1, 5)) + Substring(input.NODE_DESC, 6, 99), input.NODE_ID, 1, ROW_MOD_DT, TotalCompanyID)
	WHEN NOT MATCHED By Source THEN
		Update Set pc.Active = 0;
	
	----------------------------------------
	--- BC.System ----
	----------------------------------------
	MERGE BC.System AS pc
		USING (	Select e.ROW_MOD_DT, b.NODE_ID, b.NODE_DESC, b2.CountryID
				From Processing.BCBottlerEBNodes e 
				Join (  Select Distinct CCNTRY_ID PRNT_ID, [SYSTEM_ID] NODE_ID, dbo.udf_TitleCase([SYSTEM_DESC]) NODE_DESC
						From Staging.BCvBottlerSalesHierachy) b on e.NODE_ID = b.NODE_ID
				Join BC.Country b2 on b2.BCNodeID = b.PRNT_ID
				) AS input
			ON pc.BCNodeID = input.NODE_ID
	WHEN MATCHED THEN
		UPDATE SET pc.SystemName = 
		Replace(Upper(Substring(input.NODE_DESC, 1, 4)) + Substring(input.NODE_DESC, 5, 99), 'Oth - ', 'OTH - '),
		pc.LastModified = input.ROW_MOD_DT, 
		pc.CountryID = input.CountryID,
		pc.Active = 1
	WHEN NOT MATCHED By Target THEN
		INSERT(SystemName, BCNodeID, Active, LastModified, CountryID)
		VALUES(Replace(Upper(Substring(input.NODE_DESC, 1, 4)) + Substring(input.NODE_DESC, 5, 99), 'Oth - ', 'OTH - '), input.NODE_ID, 1, ROW_MOD_DT, CountryID)
	WHEN NOT MATCHED By Source THEN
		Update Set pc.Active = 0;

	----------------------------------------
	--- BC.Zone ----
	----------------------------------------
	MERGE BC.Zone AS pc
		USING (	Select e.ROW_MOD_DT, b.NODE_ID, b.NODE_DESC, b2.SystemID
				From Processing.BCBottlerEBNodes e 
				Join (  Select Distinct SYSTEM_ID PRNT_ID, [ZONE_ID] NODE_ID, dbo.udf_TitleCase([ZONE_DESC]) NODE_DESC
						From Staging.BCvBottlerSalesHierachy) b on e.NODE_ID = b.NODE_ID
				Join BC.System b2 on b2.BCNodeID = b.PRNT_ID
				) AS input
			ON pc.BCNodeID = input.NODE_ID
	WHEN MATCHED THEN
		UPDATE SET pc.ZONEName = 
			Upper(Substring(input.NODE_DESC, 1, 4)) + Substring(input.NODE_DESC, 5, 99),
		pc.LastModified = input.ROW_MOD_DT, 
		pc.SystemID = input.SystemID,
		pc.Active = 1
	WHEN NOT MATCHED By Target THEN
		INSERT(ZONEName, BCNodeID, Active, LastModified, SystemID)
		VALUES(Upper(Substring(input.NODE_DESC, 1, 4)) + Substring(input.NODE_DESC, 5, 99), input.NODE_ID, 1, ROW_MOD_DT, SystemID)
	WHEN NOT MATCHED By Source THEN
		Update Set pc.Active = 0;

	----------------------------------------
	--- BC.Division ----
	----------------------------------------
	MERGE BC.Division AS pc
		USING (	Select e.ROW_MOD_DT, b.NODE_ID, b.NODE_DESC, b2.ZoneID
				From Processing.BCBottlerEBNodes e 
				Join (  Select Distinct ZONE_ID PRNT_ID, DIVISION_ID NODE_ID, dbo.udf_TitleCase(DIVISION_DESC) NODE_DESC
						From Staging.BCvBottlerSalesHierachy) b on e.NODE_ID = b.NODE_ID
				Join BC.Zone b2 on b2.BCNodeID = b.PRNT_ID
				) AS input
			ON pc.BCNodeID = input.NODE_ID
	WHEN MATCHED THEN
		UPDATE SET pc.DivisionName = 
			Replace(Upper(Substring(input.NODE_DESC, 1, 4)) + Substring(input.NODE_DESC, 5, 99), 'Ny/Nj', 'NY/NJ'),
		pc.LastModified = input.ROW_MOD_DT, 
		pc.ZoneID = input.ZoneID,
		pc.Active = 1
	WHEN NOT MATCHED By Target THEN
		INSERT(DivisionName, BCNodeID, Active, LastModified, ZoneID)
		VALUES(Replace(Upper(Substring(input.NODE_DESC, 1, 4)) + Substring(input.NODE_DESC, 5, 99), 'Ny/Nj', 'NY/NJ'), input.NODE_ID, 1, ROW_MOD_DT, ZoneID)
	WHEN NOT MATCHED By Source THEN
		Update Set pc.Active = 0;
 
	----------------------------------------
	--- BC.Region ----
	----------------------------------------
	MERGE BC.Region AS pc
		USING (	Select e.ROW_MOD_DT, b.NODE_ID, b.NODE_DESC, b2.DivisionID, HIER_TYPE
				From Processing.BCBottlerEBNodes e 
				Join (  Select Distinct DIVISION_ID PRNT_ID, REGION_ID NODE_ID, dbo.udf_TitleCase(REGION_DESC) NODE_DESC, HIER_TYPE
						From Staging.BCvBottlerSalesHierachy) b on e.NODE_ID = b.NODE_ID
				Join BC.Division b2 on b2.BCNodeID = b.PRNT_ID
				) AS input
			ON pc.BCNodeID = input.NODE_ID
	WHEN MATCHED THEN
		UPDATE SET pc.RegionName = 
			Upper(Substring(input.NODE_DESC, 1, 5)) + Substring(input.NODE_DESC, 6, 99),
		pc.LastModified = input.ROW_MOD_DT, 
		pc.DivisionID = input.DivisionID,
		pc.HierType = input.HIER_TYPE,
		pc.Active = 1
	WHEN NOT MATCHED By Target THEN
		INSERT(RegionName, BCNodeID, Active, LastModified, DivisionID, HierType)
		VALUES(Upper(Substring(input.NODE_DESC, 1, 5)) + Substring(input.NODE_DESC, 6, 99), input.NODE_ID, 1, ROW_MOD_DT, DivisionID, HIER_TYPE)
	WHEN NOT MATCHED By Source THEN
		Update Set pc.Active = 0;

	Declare @LogID int

	Select @LogID = Max(LogID)
	From ETL.BCDataLoadingLog
	Where SchemaName = 'Staging' 
	And TableName = 'BCvBottlerSalesHierachy'

	Update ETL.BCDataLoadingLog
	Set MergeDate = GetDate()
	Where LogID = @LogID

GO

/****** Object:  StoredProcedure [ETL].[pMergeCapstoneProduct]    Script Date: 5/1/2014 11:28:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Select * From SAP.TradeMark

Delete From SAP.TradeMark Where IsCapstone = 1

Exec ETL.pMergeCapstoneProduct

Select * From ETL.BCDataLoadingLog

Delete From ETL.BCDataLoadingLog Where LogID = 206
*/

Create Proc [ETL].[pMergeCapstoneProduct]
AS		
	Set NoCount On;
	Declare @LogID int;

	--------------------------------------------
	---- TradeMark -----------------------------
	Declare @saptm Table
	(
		TradeMarkID int,
		SAPTradeMarkID varchar(50),
		TradeMarkName nvarchar(128),
		IsCapstone bit,
		ChangeTrackNumber int
	)

	-- Trademarks are loaded from SDM here --
	Insert @saptm(TradeMarkID, SAPTradeMarkID, TradeMarkName, ChangeTrackNumber, IsCapstone)
	SElect TradeMarkID, SAPTradeMarkID, TradeMarkName, ChangeTrackNumber, IsCapstone
	From SAP.TradeMark

	--- All the Capstone trademarks
	Declare @CapstoneTrademarks Table
	(
		SAPTradeMarkID varchar(50),
		TradeMarkName nvarchar(128)
	)

	Insert Into @CapstoneTrademarks
	Select Distinct TRADEMARK_ID TradeMarkID, TRADEMARK_DESC TradeMark
	From Staging.vBCProduct
	Where DEL_FLG <> 'Y'

	--- Adding new Capstone trademarks 
	MERGE @saptm AS pc
		USING (Select SAPTradeMarkID, TradeMarkName From @CapstoneTrademarks) input
		ON pc.SAPTradeMarkID = input.SAPTradeMarkID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPTradeMarkID, TradeMarkName, IsCapstone)
	VALUES(input.SAPTradeMarkID, dbo.udf_TitleCase(input.TradeMarkName), 1);

	--- Updating the trademark name exclusive to Capstone
	--- If a trademark is ever seen in BW feed, Capstone data can never update the trademark name any more
	Update SDM
	Set TradeMarkName = dbo.udf_TitleCase(c.TradeMarkName)
	From @CapstoneTrademarks c
	Join @saptm SDM on c.SAPTradeMarkID = SDM.SAPTradeMarkID
	And SDM.IsCapstone = 1 -- this update the ones that are just inserted, it's OK

	Update @saptm Set ChangeTrackNumber = CHECKSUM(SAPTradeMarkID, TradeMarkName) -- checksum is defined to be the businesskey and business name

	-- Use the table veriable to update SDM Trademark table based on CheckSum --
	MERGE SAP.TradeMark AS pc
	USING (Select TradeMarkID, SAPTradeMarkID, TradeMarkName, ChangeTrackNumber, IsCapstone From @saptm) AS input
			ON pc.TradeMarkID = input.TradeMarkID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPTradeMarkID, TradeMarkName, ChangeTrackNumber, LastModified, IsCapstone)
	VALUES(input.SAPTradeMarkID, input.TradeMarkName, input.ChangeTrackNumber, GetDate(), input.IsCapstone);

	Update sdm
	Set SAPTradeMarkID = sap.SAPTradeMarkID, TradeMarkName = sap.TradeMarkName, ChangeTrackNumber = sap.ChangeTrackNumber, LastModified = GetDate()
	From @saptm sap
	Join SAP.TradeMark sdm on sap.TradeMarkID = sdm.TradeMarkID and sap.ChangeTrackNumber != isnull(sdm.ChangeTrackNumber, 0);

	--@@@-- Set the merged flag 
	Select @LogID = Max(LogID)
	From ETL.BCDataLoadingLog
	Where SchemaName = 'Staging' 
	And TableName = 'BCProduct1'

	Update ETL.BCDataLoadingLog
	Set MergeDate = GetDate()
	Where  LogID = @LogID

	Select @LogID = Max(LogID)
	From ETL.BCDataLoadingLog
	Where SchemaName = 'Staging' 
	And TableName = 'BCProduct2'

	Update ETL.BCDataLoadingLog
	Set MergeDate = GetDate()
	Where  LogID = @LogID
Go
/****** Object:  StoredProcedure [ETL].[pMergeChainsAccounts]    Script Date: 5/1/2014 11:28:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- exec ETL.pMergeChainsAccounts --

CREATE Proc [ETL].[pMergeChainsAccounts]
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
/****** Object:  StoredProcedure [ETL].[pMergeStateCounty]    Script Date: 5/1/2014 11:28:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
exec ETL.pMergeStateCounty
*/ 

CREATE Proc [ETL].[pMergeStateCounty]
AS

	Set NoCount On;
	----------------------------------------
	--- Country ----
	-- Nothing is loaded, 2 records are manually done.
	----------------------------------------

	----------------------------------------
	--- State ----
	----------------------------------------
	MERGE Shared.StateRegion AS pc
		USING (	Select ROW_MOD_DT, CNTRY_CODE, REGION_FIPS, REGION_ABRV, dbo.udf_TitleCase(REGION_NM) REGION_NM
				From Staging.BCRegion e 
				Where CNTRY_CODE in ('US', 'CA')) AS input
			ON pc.BCRegionFIPS = input.REGION_FIPS
			And pc.CountryCode = input.CNTRY_CODE
	WHEN MATCHED THEN
		UPDATE SET pc.CountryCode = input.CNTRY_CODE,
					pc.RegionABRV = input.REGION_ABRV,
					pc.LastModified = input.ROW_MOD_DT,
					pc.RegionName = input.REGION_NM
	WHEN NOT MATCHED By Target THEN
		INSERT(BCRegionFIPS, CountryCode, RegionABRV, RegionName, LastModified)
		VALUES(input.REGION_FIPS, input.CNTRY_CODE, REGION_ABRV, input.REGION_NM, input.ROW_MOD_DT);

	----------------------------------------
	--- County ----
	----------------------------------------
	MERGE Shared.County AS pc
		USING (	Select ROW_MOD_DT, CNTRY_CODE, REGION_FIPS, CNTY_FIPS, 
					dbo.udf_TitleCase(CNTY_NM) CNTY_NM, CNTY_POP, sr.StateRegionID
				From Staging.BCCounty c
				Join Shared.StateRegion sr on c.REGION_FIPS = sr.BCREGIONFIPS And sr.CountryCode = c.CNTRY_CODE
			  ) 
			  AS input
			ON pc.BCRegionFIPS = input.REGION_FIPS
				And pc.BCCountryCode = input.CNTRY_CODE
				And pc.BCCountyFIPS = input.CNTY_FIPS
	WHEN MATCHED THEN
		UPDATE SET pc.StateRegionID = input.StateRegionID,
					pc.CountyName = input.CNTY_NM,
					pc.LastModified = input.ROW_MOD_DT,
					pc.Population = input.CNTY_POP
	WHEN NOT MATCHED By Target THEN
		INSERT([BCCountryCode],[BCRegionFIPS],[BCCountyFIPS],[StateRegionID],
			[CountyName],[Population],LastModified)
		VALUES(input.CNTRY_CODE, input.REGION_FIPS, input.CNTY_FIPS, input.StateRegionID,
			input.CNTY_NM, input.CNTY_POP, input.ROW_MOD_DT);

	Declare @LogID int

	Select @LogID = Max(LogID)
	From ETL.BCDataLoadingLog
	Where SchemaName = 'Staging' 
	And TableName = 'BCRegion'

	Update ETL.BCDataLoadingLog
	Set MergeDate = GetDate()
	Where LogID = @LogID

	Select @LogID = Max(LogID)
	From ETL.BCDataLoadingLog
	Where SchemaName = 'Staging' 
	And TableName = 'BCCounty'

	Update ETL.BCDataLoadingLog
	Set MergeDate = GetDate()
	Where LogID = @LogID

GO
/****** Object:  StoredProcedure [ETL].[pMergeTMapAndInclusions]    Script Date: 5/1/2014 11:28:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Truncate Table BC.TerritoryMap 

exec ETL.pMergeTMapAndInclusions 

*/

Create Proc [ETL].[pMergeTMapAndInclusions]
AS		
	Set NoCount On;
	Declare @LogID int;
	Declare @RecreationLogID int
	INSERT INTO ETL.BCAccountTerritoryMapRecreationLog([StartTime]) Values (GetDate())
	Select @RecreationLogID = SCOPE_IDENTITY()

	-----------------------------------------
	--- Flag the inactive ones --------------
	Merge BC.TerritoryMap tm
	Using (
		Select tm.TradeMarkID, p.ProductTypeID, m.TerritoryTypeID, c.CountyID, map.POSTAL_CODE, b.BottlerID 
		From Staging.BCTmap map
		Join BC.TerritoryType m on m.BCTerritoryTypeID = map.TERR_VW_ID
		Join BC.ProductType p on p.BCProducTypeID = map.PROD_TYPE_ID
		Join SAP.TradeMark tm on tm.SAPTradeMarkID = map.TRADEMARK_ID
		Join Shared.County c on map.CNTRY_CODE = c.BCCountryCode And map.REGION_FIPS = c.BCRegionFIPS And map.CNTY_FIPS = c.BCCountyFIPS
		Join BC.Bottler b on map.BTTLR_ID = b.BCBottlerID 
		Where GetDate() Not Between map.VLD_FROM_DT And map.VLD_TO_DT) Input 
		On tm.TradeMarkID = input.TradeMarkID
		And tm.ProductTypeID = input.ProductTypeID
		And tm.TerritoryTypeID = input.TerritoryTypeID
		And tm.CountyID = input.CountyID
		And tm.PostalCode = input.POSTAL_CODE
		And tm.BottlerID = input.BottlerID
	WHEN MATCHED THEN
		Delete;

	---------------------------------------------------
	---- Merge valid TerritoryMap ---------------------
	Merge BC.TerritoryMap tm
	Using (
		Select tm.TradeMarkID, p.ProductTypeID, m.TerritoryTypeID, c.CountyID, map.POSTAL_CODE, b.BottlerID 
		From Staging.BCTmap map
		Join BC.TerritoryType m on m.BCTerritoryTypeID = map.TERR_VW_ID
		Join BC.ProductType p on p.BCProducTypeID = map.PROD_TYPE_ID
		Join SAP.TradeMark tm on tm.SAPTradeMarkID = map.TRADEMARK_ID
		Join Shared.County c on map.CNTRY_CODE = c.BCCountryCode And map.REGION_FIPS = c.BCRegionFIPS And map.CNTY_FIPS = c.BCCountyFIPS
		Join BC.Bottler b on map.BTTLR_ID = b.BCBottlerID 
		Where GetDate() Between map.VLD_FROM_DT And map.VLD_TO_DT) Input 
		On tm.TradeMarkID = input.TradeMarkID
		And tm.ProductTypeID = input.ProductTypeID
		And tm.TerritoryTypeID = input.TerritoryTypeID
		And tm.CountyID = input.CountyID
		And tm.PostalCode = input.POSTAL_CODE
		And tm.BottlerID = input.BottlerID
	WHEN NOT MATCHED By Target THEN
		Insert(TradeMarkID, ProductTypeID, TerritoryTypeID, CountyID, PostalCode, BottlerID)
		Values(input.TradeMarkID, input.ProductTypeID, input.TerritoryTypeID, input.CountyID, input.POSTAL_CODE, input.BottlerID);

	--@@@--
	Select @LogID = Max(LogID)
	From ETL.BCDataLoadingLog
	Where SchemaName = 'Staging' 
	And TableName = 'BCTmap'

	Update ETL.BCDataLoadingLog

	Set MergeDate = GetDate()
	Where  LogID = @LogID

	Update ETL.BCAccountTerritoryMapRecreationLog
	Set MergeTMapCompleteOffset = DATEDIFF(SECOND, StartTime, GetDate())
	Where LogID = @RecreationLogID

	---------------------------------------------
	---- AccountInclusion -----------------------
	--- Flag the inactive ones ------------------
	Merge BC.AccountInclusion tm
	Using (
		Select tm.TradeMarkID, p.ProductTypeID, m.TerritoryTypeID, c.CountyID, map.INCL_FOR_POSTAL_CODE PostalCode, b.BottlerID, a.AccountID
		From Staging.BCStoreInclusion map
		Join BC.TerritoryType m on m.BCTerritoryTypeID = map.TERR_VW_ID
		Join BC.ProductType p on p.BCProducTypeID = map.PROD_TYPE_ID
		Join SAP.TradeMark tm on tm.SAPTradeMarkID = map.TRADEMARK_ID
		Join Shared.County c on map.CNTRY_CODE = c.BCCountryCode And map.REGION_FIPS = c.BCRegionFIPS And map.CNTY_FIPS = c.BCCountyFIPS
		Join BC.Bottler b on map.BTTLR_ID = b.BCBottlerID
		Join SAP.Account a on map.STR_ID = a.SAPAccountNumber 
		Where [STTS_ID] <> 6  Or GetDate() Not Between [VLD_FRM_DT] And [VLD_TO_DT]) Input 
		On tm.TradeMarkID = input.TradeMarkID
		And tm.ProductTypeID = input.ProductTypeID
		And tm.TerritoryTypeID = input.TerritoryTypeID
		And tm.CountyID = input.CountyID
		And tm.PostalCode = input.PostalCode
		And tm.BottlerID = input.BottlerID
		And tm.AccountID = input.AccountID
	WHEN MATCHED THEN
		Delete;

	--- Insert the new ones ----------------------
	Merge BC.AccountInclusion tm
	Using (
		Select tm.TradeMarkID, p.ProductTypeID, m.TerritoryTypeID, c.CountyID, map.INCL_FOR_POSTAL_CODE PostalCode, b.BottlerID, a.AccountID
		From Staging.BCStoreInclusion map
		Join BC.TerritoryType m on m.BCTerritoryTypeID = map.TERR_VW_ID
		Join BC.ProductType p on p.BCProducTypeID = map.PROD_TYPE_ID
		Join SAP.TradeMark tm on tm.SAPTradeMarkID = map.TRADEMARK_ID
		Join Shared.County c on map.CNTRY_CODE = c.BCCountryCode And map.REGION_FIPS = c.BCRegionFIPS And map.CNTY_FIPS = c.BCCountyFIPS
		Join BC.Bottler b on map.BTTLR_ID = b.BCBottlerID
		Join SAP.Account a on map.STR_ID = a.SAPAccountNumber
		And [STTS_ID] = 6 And GetDate() Between [VLD_FRM_DT] And [VLD_TO_DT]) Input 
		On tm.TradeMarkID = input.TradeMarkID
		And tm.ProductTypeID = input.ProductTypeID
		And tm.TerritoryTypeID = input.TerritoryTypeID
		And tm.CountyID = input.CountyID
		And tm.PostalCode = input.PostalCode
		And tm.BottlerID = input.BottlerID
		And tm.AccountID = input.AccountID
	WHEN NOT MATCHED By Target THEN
		Insert(TradeMarkID, ProductTypeID, TerritoryTypeID, CountyID, PostalCode, BottlerID, AccountID)
		Values(input.TradeMarkID, input.ProductTypeID, input.TerritoryTypeID, input.CountyID, input.PostalCode, input.BottlerID, input.AccountID);

	--@@@--
	Select @LogID = Max(LogID)
	From ETL.BCDataLoadingLog
	Where SchemaName = 'Staging' 
	And TableName = 'BCStoreInclusion'

	Update ETL.BCDataLoadingLog
	Set MergeDate = GetDate()
	Where  LogID = @LogID

	Update ETL.BCAccountTerritoryMapRecreationLog
	Set MergeAccountInclusionCompleteOffset = DATEDIFF(SECOND, StartTime, GetDate())
	Where LogID = @RecreationLogID

	-----------------------------------------------
	------ Calculate the store level map ----------
	Truncate Table BC.BottlerAccountTradeMark;

	--- 4 minutes to load with no non-clustered indexes--
	Insert Into BC.BottlerAccountTradeMark
	Select *
	From 
	(
		Select Distinct map.TerritoryTypeID, map.ProductTypeID, 0 IsStoreInclusion, map.BottlerID, map.TradeMarkID, a.AccountID, a.LocalChainID, a.ChannelID, a.BranchID
		From BC.TerritoryMap map
		Join SAP.Account a on map.PostalCode = a.TMPostalCode and map.CountyID = a.CountyID
		Where a.InCapstone = 1
		And a.CRMActive = 1
		Union
		Select Distinct inc.TerritoryTypeID, inc.ProductTypeID, 1 IsStoreInclusion, inc.BottlerID, inc.TradeMarkID, a.AccountID, a.LocalChainID, a.ChannelID, a.BranchID
		From BC.AccountInclusion inc
		Join SAP.Account a on inc.AccountID = a.AccountID
		Where a.InCapstone = 1
		And a.CRMActive = 1
	) tm

	-- 2s to delete the confliting rows -- 
	-- Need to throtlle the flow from the source, so I don't have to filter it here - 
	Update ETL.BCAccountTerritoryMapRecreationLog
	Set ProcessBottlerAccountTradeMarkCompleteOffset = DATEDIFF(SECOND, StartTime, GetDate())
	Where LogID = @RecreationLogID

	Delete map
	From (Select * From BC.BottlerAccountTradeMark map Where IsStoreInclusion = 0) map
	Join (Select * From BC.BottlerAccountTradeMark map Where IsStoreInclusion = 1) inc 
		on map.AccountID = inc.AccountID 
		And map.TradeMarkID = inc.TradeMarkID 
		And map.ProductTypeID = inc.ProductTypeID
		And map.TerritoryTypeID = inc.TerritoryTypeID

	Update ETL.BCAccountTerritoryMapRecreationLog
	Set ProcessInclusionCompleteOffset = DATEDIFF(SECOND, StartTime, GetDate())
	Where LogID = @RecreationLogID

Go
/****** Object:  StoredProcedure [ETL].[pMergeViewTables]    Script Date: 5/1/2014 11:28:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
exec ETL.pMergeViewTables

*/

Create Proc ETL.pMergeViewTables
AS	
	Set NoCount On;

	----------------------------------------
	Merge BC.tBottlerTerritoryType As t
	Using 
		(Select Distinct a.BottlerID, a.TerritoryTypeID, tt.TerritoryTypeName, a.ProductTypeID
		From BC.BottlerAccountTradeMark a
		Join BC.TerritoryType tt on a.TerritoryTypeID = tt.TerritoryTypeID) input
		On t.BottlerID = input.BottlerID And t.TerritoryTypeID = input.TerritoryTypeID And t.ProductTypeID = input.ProductTypeID
	When Not Matched By Target Then
		Insert(BottlerID, TerritoryTypeID, TerritoryTypeName, ProductTypeID, LastModified)
		Values(input.BottlerID, input.TerritoryTypeID, input.TerritoryTypeName, input.ProductTypeID, GetDate())
	When Not matched By Source Then
		Delete;

	----------------------------------------
	Merge [BC].[tBottlerTrademark] As t
	Using 
		(	Select Distinct a.TerritoryTypeID, a.ProductTypeID, b.BottlerID, b.BCBottlerID, b.BottlerName, 
				t.TradeMarkID, t.SAPTradeMarkID, t.TradeMarkName 
			From BC.BottlerAccountTradeMark a
			Join BC.Bottler b on a.BottlerID = b.BottlerID
			Join SAP.TradeMark t on a.TradeMarkID = t.TradeMarkID) input
		On t.TerritoryTypeID = input.TerritoryTypeID And t.ProductTypeID = input.ProductTypeID And t.BottlerID = input.BottlerID And t.TradeMarkID = input.TradeMarkID
	When Not Matched By Target Then
		Insert(TerritoryTypeID, ProductTypeID, BottlerID, BCBottlerID, BottlerName, 
			   TradeMarkID, SAPTradeMarkID, TradeMarkName, LastModified)
		Values(input.TerritoryTypeID, input.ProductTypeID, input.BottlerID, input.BCBottlerID, input.BottlerName, 
			   input.TradeMarkID, input.SAPTradeMarkID, input.TradeMarkName, GetDate())
	When Not matched By Source Then
		Delete;

	---------------------------------------
	Merge BC.tBottlerChainTradeMark t
	Using
		(
			Select Distinct a.TerritoryTypeID, a.ProductTypeID, b.BottlerID, b.BCBottlerID, b.BottlerName, 
			t.TradeMarkID, t.SAPTradeMarkID, t.TradeMarkName, 
			l.LocalChainID, l.SAPLocalChainID, l.LocalChainName, 
			r.RegionalChainID, r.SAPRegionalChainID, r.RegionalChainName, 
			n.NationalChainID, n.SAPNationalChainID, n.NationalChainName 
			From BC.BottlerAccountTradeMark a
			Join SAP.LocalChain l on a.LocalChainID = l.LocalChainID
			Join SAP.RegionalChain r on r.RegionalChainID = l.RegionalChainID
			Join SAP.NationalChain n on r.NationalChainID = n.NationalChainID
			Join BC.Bottler b on a.BottlerID = b.BottlerID
			Join SAP.TradeMark t on a.TradeMarkID = t.TradeMarkID
		) input
		On t.TerritoryTypeID = input.TerritoryTypeID
			And t.ProductTypeID = input.ProductTypeID
			And t.BottlerID = input.BottlerID
			And t.TradeMarkID = input.TradeMarkID
			And t.LocalChainID = input.LocalChainID
	When Not Matched By Target Then
		Insert(TerritoryTypeID, ProductTypeID, BottlerID, BCBottlerID, BottlerName, 
			TradeMarkID, SAPTradeMarkID, TradeMarkName, 
			LocalChainID, SAPLocalChainID, LocalChainName, 
			RegionalChainID, SAPRegionalChainID, RegionalChainName, 
			NationalChainID, SAPNationalChainID, NationalChainName, LastModified)
		Values(input.TerritoryTypeID, input.ProductTypeID, input.BottlerID, input.BCBottlerID, input.BottlerName, 
			input.TradeMarkID, input.SAPTradeMarkID, input.TradeMarkName, 
			input.LocalChainID, input.SAPLocalChainID, input.LocalChainName, 
			input.RegionalChainID, input.SAPRegionalChainID, input.RegionalChainName, 
			input.NationalChainID, input.SAPNationalChainID, input.NationalChainName, GetDate())
	When Not matched By Source Then
		Delete;

	---------------------------------------------
	Truncate Table BC.tBottlerMapping;

	Insert Into BC.tBottlerMapping
	Select ServicingBottler.TradeMarkID, ServicingBottler.CountyID, ServicingBottler.PostalCode, RptgBottlerID, SvcgBottlerID
	From 
	(Select CountyID, PostalCode, BottlerID SvcgBottlerID, TradeMarkID 
	From BC.TerritoryMap
	Where TerritoryTypeID = 12
	And ProductTypeID = 1) ServicingBottler
	Join
	(Select CountyID, PostalCode, BottlerID RptgBottlerID, TradeMarkID 
	From BC.TerritoryMap
	Where TerritoryTypeID = 11
	And ProductTypeID = 1) ReportingBottler 
	on ServicingBottler.CountyID = ReportingBottler.CountyID 
		And ServicingBottler.PostalCode = ReportingBottler.PostalCode
		And ServicingBottler.TradeMarkID = ReportingBottler.TradeMarkID
	Where SvcgBottlerID <> RptgBottlerID

GO

/****** Object:  StoredProcedure [ETL].pReloadBCSalesAccountability    Script Date: 5/1/2014 11:28:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- exec ETL.pReloadBCSalesAccountability --

Create Proc [ETL].[pReloadBCSalesAccountability]
AS		
	Set NoCount On;

	Delete [Person].[BCSalesAccountability] Where IsSystemLoad = 1;
	
	INSERT INTO [Person].[BCSalesAccountability]
			   ([IsPrimary]
			   ,[GSN]
			   ,[TotalCompanyID]
			   ,[CountryID]
			   ,[SystemID]
			   ,[ZoneID]
			   ,[DivisionID]
			   ,[RegionID]
			   ,[IsSystemLoad]
			   ,[LastModified])
	Select Case When EMP_FUNC = 'Z000010' Then 1 Else 0 End As IsPrimary, 
		EMP_GSN GSN, 
		tc.TotalCompanyID, 
		null CountryID, 
		null SystemID, 
		null ZoneID, 
		null DivisionID, 
		null RegionID, 
		1 IsSystemLoad,
		e.ROW_MOD_DT
	From Staging.BCHierachyEmployee e
	Join BC.TotalCompany tc on e.NODE_ID = tc.BCNodeID
	Join Person.UserProfile u on u.GSN = e.EMP_GSN
	Where DEL_FLG <> 'Y'
	And GetDate() Between VLD_FRM_DT And VLD_TO_DT
	Union
	Select Case When EMP_FUNC = 'Z000010' Then 1 Else 0 End As IsPrimary, 
		EMP_GSN, 
		null TotalCompanyID, 
		tc.CountryID, 
		null SystemID, 
		null ZoneID, 
		null DivisionID, 
		null RegionID, 
		1 IsSystemLoad,
		e.ROW_MOD_DT
	From Staging.BCHierachyEmployee e
	Join BC.Country tc on e.NODE_ID = tc.BCNodeID
	Join Person.UserProfile u on u.GSN = e.EMP_GSN
	Where DEL_FLG <> 'Y'
	And GetDate() Between VLD_FRM_DT And VLD_TO_DT
	Union
	Select Case When EMP_FUNC = 'Z000010' Then 1 Else 0 End As IsPrimary, 
		EMP_GSN, 
		null TotalCompanyID, 
		null CountryID, 
		tc.SystemID, 
		null ZoneID, 
		null DivisionID, 
		null RegionID, 
		1 IsSystemLoad,
		e.ROW_MOD_DT
	From Staging.BCHierachyEmployee e
	Join BC.System tc on e.NODE_ID = tc.BCNodeID
	Join Person.UserProfile u on u.GSN = e.EMP_GSN
	Where DEL_FLG <> 'Y'
	And GetDate() Between VLD_FRM_DT And VLD_TO_DT
	Union
	Select Case When EMP_FUNC = 'Z000010' Then 1 Else 0 End As IsPrimary, 
		EMP_GSN, 
		null TotalCompanyID, 
		null CountryID, 
		null SystemID, 
		tc.ZoneID, 
		null DivisionID, 
		null RegionID, 
		1 IsSystemLoad,
		e.ROW_MOD_DT
	From Staging.BCHierachyEmployee  e
	Join BC.Zone tc on e.NODE_ID = tc.BCNodeID
	Join Person.UserProfile u on u.GSN = e.EMP_GSN
	Where DEL_FLG <> 'Y'
	And GetDate() Between VLD_FRM_DT And VLD_TO_DT
	Union
	Select Case When EMP_FUNC = 'Z000010' Then 1 Else 0 End As IsPrimary, 
		EMP_GSN, 
		null TotalCompanyID, 
		null CountryID, 
		null SystemID, 
		null ZoneID, 
		tc.DivisionID, 
		null RegionID, 
		1 IsSystemLoad,
		e.ROW_MOD_DT
	From Staging.BCHierachyEmployee  e
	Join BC.Division tc on e.NODE_ID = tc.BCNodeID
	Join Person.UserProfile u on u.GSN = e.EMP_GSN
	Where DEL_FLG <> 'Y'
	And GetDate() Between VLD_FRM_DT And VLD_TO_DT
	Union
	Select Case When EMP_FUNC = 'Z000010' Then 1 Else 0 End As IsPrimary, 
		EMP_GSN, 
		null TotalCompanyID, 
		null CountryID, 
		null SystemID, 
		null ZoneID, 
		null DivisionID, 
		tc.RegionID, 
		1 IsSystemLoad,
		e.ROW_MOD_DT
	From Staging.BCHierachyEmployee  e
	Join BC.Region tc on e.NODE_ID = tc.BCNodeID
	Join Person.UserProfile u on u.GSN = e.EMP_GSN
	Where DEL_FLG <> 'Y'
	And GetDate() Between VLD_FRM_DT And VLD_TO_DT
	----------------------------------------
	----------------------------------------
	Declare @LogID int

	Select @LogID = Max(LogID)
	From ETL.BCDataLoadingLog
	Where SchemaName = 'Staging' 
	And TableName = 'BCHierachyEmployee'

	Update ETL.BCDataLoadingLog
	Set MergeDate = GetDate()
	Where  LogID = @LogID

Go


------------------------------------------------------------------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec ETL.pNotifyCapstoneFailedStatus 14
--go

Create Proc ETL.pNotifyCapstoneFailedStatus
	@ObjectCount int
As
Begin
	Declare @ObjectLoadCount int
	Declare @MergedObjectLoadCount int
	Declare @Message varchar(4000)
	Declare @LoadFailedObjects varchar(4000)
	Declare @MergedFailedObjects varchar(4000)
	Declare @BCRegionLoadingStart DateTime2(7)

	Set @LoadFailedObjects = ''
	Set @MergedFailedObjects = ''

	Select @BCRegionLoadingStart = Max(StartDate)
	From ETL.BCDataLoadingLog
	Where TableName = 'BCRegion'

	SELECT @ObjectLoadCount = Count(*)
	FROM ETL.BCDataLoadingLog
	Where LogDate = Convert(date, GetDate())
	And EndDate is not null
	And StartDate >= @BCRegionLoadingStart

	If (@ObjectLoadCount < @ObjectCount)
	Begin
		Set @Message = 'Error: Capstone data load is incomplete for date ' + Convert(varchar, Convert(date, GetDate()));

		Select @LoadFailedObjects = @LoadFailedObjects + TableName + ';'
		FROM ETL.BCDataLoadingLog
		Where LogDate = Convert(date, GetDate())
		And EndDate is null
		And StartDate >= @BCRegionLoadingStart

		Set @Message = @Message + CHAR(13);
		Set @Message = @Message + 'Details: Data load is failed for table(s) ' + @MergedFailedObjects;
	End
	Else 
	Begin
		Select @MergedObjectLoadCount = Count(*)
		FROM ETL.BCDataLoadingLog
		Where LogDate = Convert(date, GetDate())
		And EndDate is not null
		And StartDate >= @BCRegionLoadingStart
		And IsMerged = 1

		If (@MergedObjectLoadCount <> @ObjectCount)
		Begin
			Set @Message = 'Error: Capstone data merge is incomplete for date ' + Convert(varchar, Convert(date, GetDate()));
		
			Select @MergedFailedObjects = @MergedFailedObjects + TableName + ';'
			FROM ETL.BCDataLoadingLog
			Where LogDate = Convert(date, GetDate())
			And EndDate is not null
			And StartDate >= @BCRegionLoadingStart
			And IsMerged <> 1

			Set @Message = @Message + CHAR(13);
			Set @Message = @Message + 'Details: Data merge is incomplete for table(s) ' + @MergedFailedObjects;

		End
	End

	If (@Message is not null)
	Begin
		EXEC msdb.dbo.sp_send_dbmail
			@recipients = 'Chris.Wu@dpsg.com', 
			@body = @Message,
			@subject = 'Capstone Master Data Loading Failed'; 
	End
End

Go