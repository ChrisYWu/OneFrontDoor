Use Portal_Data
Go

-------0.0------------------------
/****** Object:  Table [BC].[TerritoryMap]    Script Date: 7/1/2015 1:10:25 PM ******/
DROP TABLE [BC].[TerritoryMap]
GO

/****** Object:  Table [BC].[TerritoryMap]    Script Date: 7/1/2015 1:10:25 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [BC].[TerritoryMap](
	[TradeMarkID] [int] NOT NULL,
	[ProductTypeID] [int] NOT NULL,
	[TerritoryTypeID] [int] NOT NULL,
	[CountyID] [int] NOT NULL,
	[PostalCode] [varchar](10) NOT NULL,
	[BottlerID] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_TerritoryMap] PRIMARY KEY CLUSTERED 
(
	[TradeMarkID] ASC,
	[ProductTypeID] ASC,
	[TerritoryTypeID] ASC,
	[CountyID] ASC,
	[PostalCode] ASC,
	[BottlerID] ASC,
	[ValidFrom] ASC,
	[ValidTo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [BC].[TerritoryMap] ADD  DEFAULT ('1970-1-1') FOR [ValidFrom]
GO

ALTER TABLE [BC].[TerritoryMap] ADD  DEFAULT ('1970-1-1') FOR [ValidTo]
GO

ALTER TABLE [BC].[TerritoryMap]  WITH CHECK ADD  CONSTRAINT [FK_TerritoryMap_Bottler] FOREIGN KEY([BottlerID])
REFERENCES [BC].[Bottler] ([BottlerID])
GO

ALTER TABLE [BC].[TerritoryMap] CHECK CONSTRAINT [FK_TerritoryMap_Bottler]
GO

ALTER TABLE [BC].[TerritoryMap]  WITH CHECK ADD  CONSTRAINT [FK_TerritoryMap_County] FOREIGN KEY([CountyID])
REFERENCES [Shared].[County] ([CountyID])
GO

ALTER TABLE [BC].[TerritoryMap] CHECK CONSTRAINT [FK_TerritoryMap_County]
GO

ALTER TABLE [BC].[TerritoryMap]  WITH CHECK ADD  CONSTRAINT [FK_TerritoryMap_ProductType] FOREIGN KEY([ProductTypeID])
REFERENCES [BC].[ProductType] ([ProductTypeID])
GO

ALTER TABLE [BC].[TerritoryMap] CHECK CONSTRAINT [FK_TerritoryMap_ProductType]
GO

ALTER TABLE [BC].[TerritoryMap]  WITH CHECK ADD  CONSTRAINT [FK_TerritoryMap_TerritoryType] FOREIGN KEY([TerritoryTypeID])
REFERENCES [BC].[TerritoryType] ([TerritoryTypeID])
GO

ALTER TABLE [BC].[TerritoryMap] CHECK CONSTRAINT [FK_TerritoryMap_TerritoryType]
GO

ALTER TABLE [BC].[TerritoryMap]  WITH CHECK ADD  CONSTRAINT [FK_TerritoryMap_TradeMark] FOREIGN KEY([TradeMarkID])
REFERENCES [SAP].[TradeMark] ([TradeMarkID])
GO

ALTER TABLE [BC].[TerritoryMap] CHECK CONSTRAINT [FK_TerritoryMap_TradeMark]
GO

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Drop Table [BC].[AccountInclusion]
Go

SET ANSI_PADDING ON
GO

CREATE TABLE [BC].[AccountInclusion](
	[TradeMarkID] [int] NOT NULL,
	[ProductTypeID] [int] NOT NULL,
	[TerritoryTypeID] [int] NOT NULL,
	[CountyID] [int] NOT NULL,
	[PostalCode] [varchar](10) NULL,
	[BottlerID] [int] NOT NULL,
	[AccountID] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL DEFAULT ('1970-1-1'),
	[ValidTo] [datetime2](7) NOT NULL DEFAULT ('1970-1-1'),
 CONSTRAINT [PK_AccountInclusion] PRIMARY KEY CLUSTERED 
(
	[TradeMarkID] ASC,
	[ProductTypeID] ASC,
	[TerritoryTypeID] ASC,
	[BottlerID] ASC,
	[AccountID] ASC,
	[ValidFrom] ASC,
	[ValidTo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [BC].[AccountInclusion]  WITH CHECK ADD  CONSTRAINT [FK_AccountInclusion_Account] FOREIGN KEY([AccountID])
REFERENCES [SAP].[Account] ([AccountID])
GO

ALTER TABLE [BC].[AccountInclusion] CHECK CONSTRAINT [FK_AccountInclusion_Account]
GO

ALTER TABLE [BC].[AccountInclusion]  WITH CHECK ADD  CONSTRAINT [FK_AccountInclusion_Bottler] FOREIGN KEY([BottlerID])
REFERENCES [BC].[Bottler] ([BottlerID])
GO

ALTER TABLE [BC].[AccountInclusion] CHECK CONSTRAINT [FK_AccountInclusion_Bottler]
GO

ALTER TABLE [BC].[AccountInclusion]  WITH CHECK ADD  CONSTRAINT [FK_AccountInclusion_County] FOREIGN KEY([CountyID])
REFERENCES [Shared].[County] ([CountyID])
GO

ALTER TABLE [BC].[AccountInclusion] CHECK CONSTRAINT [FK_AccountInclusion_County]
GO

ALTER TABLE [BC].[AccountInclusion]  WITH CHECK ADD  CONSTRAINT [FK_AccountInclusion_ProductType] FOREIGN KEY([ProductTypeID])
REFERENCES [BC].[ProductType] ([ProductTypeID])
GO

ALTER TABLE [BC].[AccountInclusion] CHECK CONSTRAINT [FK_AccountInclusion_ProductType]
GO

ALTER TABLE [BC].[AccountInclusion]  WITH CHECK ADD  CONSTRAINT [FK_AccountInclusion_TerritoryType] FOREIGN KEY([TerritoryTypeID])
REFERENCES [BC].[TerritoryType] ([TerritoryTypeID])
GO

ALTER TABLE [BC].[AccountInclusion] CHECK CONSTRAINT [FK_AccountInclusion_TerritoryType]
GO

ALTER TABLE [BC].[AccountInclusion]  WITH CHECK ADD  CONSTRAINT [FK_AccountInclusion_TradeMark] FOREIGN KEY([TradeMarkID])
REFERENCES [SAP].[TradeMark] ([TradeMarkID])
GO

ALTER TABLE [BC].[AccountInclusion] CHECK CONSTRAINT [FK_AccountInclusion_TradeMark]
GO

-------0.1------------------------
Set NoCount On;
Declare @LastLoadTime DateTime
Declare @LogID bigint 
Declare @OPENQUERY nvarchar(4000)
Declare @RecordCount int
Declare @LastRecordDate DateTime

------------------------------------------------------
------------------------------------------------------
Truncate Table Staging.BCTMap

Set @LastLoadTime  = '2013-01-01'

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
AND T.PROD_TYPE_ID=''''01'''' AND T.TERR_VW_ID IN (''''11'''', ''''12'''') AND ')
----------------------------------------
Exec (@OPENQUERY)

Select @RecordCount = Count(*) From Staging.BCTMap

Select @LastRecordDate = Max(ROW_MOD_DT) From Staging.BCTMap

Update ETL.BCDataLoadingLog 
Set EndDate = GetDate(), NumberOfRecordsLoaded = @RecordCount, LatestLoadedRecordDate = @LastRecordDate
Where LogID = @LogID

------------------------------------------------------
------------------------------------------------------
Truncate Table Staging.BCStoreInclusion

Select @LastLoadTime = '2013-1-1'

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
Go

------------------------------------------------------
------------------------------------------------------
--- 2.0 ----
ALTER PROCEDURE [ETL].[pLoadFromCapstone]
AS		
--- ======================================================================================
--- Change Log (Most recent on top):
--- Date       INIT  Change Descrition
--- ---------- ----- ---------------------------------------------------------------------
--- 2015-05-26 KTY - Pull ALL valid Chain Hier records since 2013-01-01 into Staging.BCStoreHier table
--- ======================================================================================

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

	Select @LastLoadTime = '2013-1-1'
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
	AND T.PROD_TYPE_ID=''''01'''' AND T.TERR_VW_ID IN (''''11'''', ''''12'''') AND ')
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

--	Select @LastLoadTime = IsNull(Max(LatestLoadedRecordDate), '2013-01-01')
--	From ETL.BCDataLoadingLog l
--	Where SchemaName = 'Staging' And TableName = 'BCStoreHier'
--	And l.IsMerged = 1

    -- 2015-05-26 KTY - Pull all Chain Hier records since 2013-01-01
    Select @LastLoadTime = '2013-01-01'     --IsNull(Max(LatestLoadedRecordDate), '2013-01-01')

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
	--Set @OPENQUERY = Replace(@OPENQUERY, 'WHERE', 'WHERE PARTNER IS NULL AND')
    -- 2015-05-26 KTY - Pull only valid Chain Hier records
	Set @OPENQUERY = Replace(@OPENQUERY, 'WHERE', 'WHERE D.PARTNER IS NULL AND D.HIER_TYPE = ''''ER'''' AND D.DEL_FLG = ''''N'''' AND')
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

---- 3.0 ------
/****** Object:  StoredProcedure [ETL].[pMergeTMapAndInclusions]    Script Date: 6/30/2015 10:51:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Truncate Table BC.TerritoryMap 

exec ETL.pMergeTMapAndInclusions 

*/

--Select Top 1 *
--From Staging.BCTmap


ALTER Proc [ETL].[pMergeTMapAndInclusions]
AS		
	Set NoCount On;
	Declare @LogID int;
	Declare @RecreationLogID int
	INSERT INTO ETL.BCAccountTerritoryMapRecreationLog([StartTime]) Values (GetDate())
	Select @RecreationLogID = SCOPE_IDENTITY()

	---------------------------------------------------
	---- Merge valid TerritoryMap ---------------------
	Merge BC.TerritoryMap tm
	Using (
		Select tm.TradeMarkID, p.ProductTypeID, m.TerritoryTypeID, c.CountyID, map.POSTAL_CODE, b.BottlerID, map.[VLD_FROM_DT], map.[VLD_TO_DT]
		From Staging.BCTmap map
		Join BC.TerritoryType m on m.BCTerritoryTypeID = map.TERR_VW_ID
		Join BC.ProductType p on p.BCProducTypeID = map.PROD_TYPE_ID
		Join SAP.TradeMark tm on tm.SAPTradeMarkID = map.TRADEMARK_ID
		Join Shared.County c on map.CNTRY_CODE = c.BCCountryCode And map.REGION_FIPS = c.BCRegionFIPS And map.CNTY_FIPS = c.BCCountyFIPS
		Join BC.Bottler b on map.BTTLR_ID = b.BCBottlerID ) Input 
		On tm.TradeMarkID = input.TradeMarkID
		And tm.ProductTypeID = input.ProductTypeID
		And tm.TerritoryTypeID = input.TerritoryTypeID
		And tm.CountyID = input.CountyID
		And tm.PostalCode = input.POSTAL_CODE
		And tm.BottlerID = input.BottlerID
		And tm.ValidFrom = input.VLD_FROM_DT
		And tm.ValidTo = input.VLD_TO_DT
	WHEN NOT MATCHED By Target THEN
		Insert(TradeMarkID, ProductTypeID, TerritoryTypeID, CountyID, PostalCode, BottlerID, ValidFrom, ValidTo)
		Values(input.TradeMarkID, input.ProductTypeID, input.TerritoryTypeID, input.CountyID, input.POSTAL_CODE, input.BottlerID, input.[VLD_FROM_DT], input.[VLD_TO_DT]);

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

	---------------------------------------------------
	---- AccountInclusion -----------------------------
	Merge BC.AccountInclusion tm
	Using (
		Select tm.TradeMarkID, p.ProductTypeID, m.TerritoryTypeID, c.CountyID, map.INCL_FOR_POSTAL_CODE PostalCode, b.BottlerID, a.AccountID, map.VLD_FRM_DT, map.VLD_TO_DT
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
		And tm.BottlerID = input.BottlerID
		And tm.AccountID = input.AccountID
		And tm.ValidFrom = input.VLD_FRM_DT
		And tm.ValidTo = input.VLD_TO_DT
	WHEN Matched Then
		Update Set CountyID = input.CountyID,
		PostalCode = input.PostalCode
	WHEN NOT MATCHED By Target THEN
		Insert(TradeMarkID, ProductTypeID, TerritoryTypeID, CountyID, PostalCode, BottlerID, AccountID, ValidFrom, ValidTo)
		Values(input.TradeMarkID, input.ProductTypeID, input.TerritoryTypeID, input.CountyID, input.PostalCode, input.BottlerID, input.AccountID, input.VLD_FRM_DT, input.VLD_TO_DT);

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
		And GetDate() Between map.[ValidFrom] And map.ValidTo
		Union
		Select Distinct inc.TerritoryTypeID, inc.ProductTypeID, 1 IsStoreInclusion, inc.BottlerID, inc.TradeMarkID, a.AccountID, a.LocalChainID, a.ChannelID, a.BranchID
		From BC.AccountInclusion inc
		Join SAP.Account a on inc.AccountID = a.AccountID
		Where a.InCapstone = 1 
		And GetDate() Between inc.ValidFrom And inc.ValidTo
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

--- 4.0 ------
/****** Object:  StoredProcedure [ETL].[pMergeViewTables]    Script Date: 7/1/2015 1:56:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

------------------------------------
------------------------------------
------------------------------------
ALTER Proc [ETL].[pMergeViewTables]
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

	---------------------------------------
	Merge BC.tRegionChainTradeMark t
	Using
		(
			Select Distinct a.TerritoryTypeID, a.ProductTypeID, b.BCRegionID RegionID, 
			t.TradeMarkID,
			l.LocalChainID,
			r.RegionalChainID,
			r.NationalChainID
			From BC.BottlerAccountTradeMark a
			Join SAP.LocalChain l on a.LocalChainID = l.LocalChainID
			Join SAP.RegionalChain r on r.RegionalChainID = l.RegionalChainID
			Join BC.Bottler b on a.BottlerID = b.BottlerID
			Join SAP.TradeMark t on a.TradeMarkID = t.TradeMarkID
			Where b.BCRegionID is not null
		) input
		On t.TerritoryTypeID = input.TerritoryTypeID
			And t.ProductTypeID = input.ProductTypeID
			And t.RegionID = input.RegionID
			And t.TradeMarkID = input.TradeMarkID
			And t.LocalChainID = input.LocalChainID
	When Not Matched By Target Then
		Insert(TerritoryTypeID, ProductTypeID, RegionID, 
			TradeMarkID, 
			LocalChainID, RegionalChainID, NationalChainID, LastModified)
		Values(input.TerritoryTypeID, input.ProductTypeID, input.RegionID, 
			input.TradeMarkID, 
			input.LocalChainID, 
			input.RegionalChainID,
			input.NationalChainID, SysDateTime())
	When Not matched By Source Then
		Delete;
Go

---5.0 -----------------------------
exec ETL.pMergeTMapAndInclusions
Go

exec ETL.pMergeViewTables
Go

------------------------------------

