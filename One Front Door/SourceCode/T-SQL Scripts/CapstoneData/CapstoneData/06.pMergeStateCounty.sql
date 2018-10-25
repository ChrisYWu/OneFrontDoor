use Portal_Data_SREINT
Go

If Exists (Select * From Sys.procedures Where Object_ID = Object_ID('ETL.pMergeStateCounty'))
Begin
	Drop Proc ETL.pMergeStateCounty
End
Go

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


Select *
From ETL.BCDataLoadingLog

