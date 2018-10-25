USE Portal_Data
GO


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

exec ETL.pMergeChainsAccounts
Go

exec ETL.pLoadFromRM
Go

Update SAP.Account
Set EnforcedModifiedDate = GetDate()
Where InCapstone = 1
Go