Use Portal_Data
Go

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

Select @LastLoadTime '2013-1-1'

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



