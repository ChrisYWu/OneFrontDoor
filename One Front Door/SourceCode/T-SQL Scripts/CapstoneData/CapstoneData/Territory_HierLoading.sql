Use Portal_DataSRE
Go



Select *
From Staging.BCRegion


----------------------------------------
--- Country ----
-- Nothing is loaded, 2 records are manually done.
----------------------------------------
MERGE Shared.Country AS pc
	USING (	Select e.ROW_MOD_DT, e.CNTRY_CODE, 
			dbo.udf_TitleCase(e.CNTRY_NM) CNTRY_NM, ISO_CNTRY_CODE
			From Staging.BCCountry e 
			Where RTrim(CNTRY_CODE) in ('CA', 'US')
			) AS input
		ON pc.BCCountryCode = input.CNTRY_CODE
WHEN MATCHED THEN
	UPDATE SET pc.CountryName = input.CNTRY_NM,
			   pc.LastModified = input.ROW_MOD_DT, 
			   pc.ISOCountryCode = input.ISO_CNTRY_CODE
WHEN NOT MATCHED THEN
	INSERT(CountryName, LastModified, ISOCountryCode, BCCountryCode, CountryCode)
	VALUES(ROW_MOD_DT, CNTRY_NM, ISO_CNTRY_CODE, CNTRY_CODE,CNTRY_CODE);
Go

----------------------------------------
--- State ----
----------------------------------------
MERGE Shared.StateRegion AS pc
	USING (	Select ROW_MOD_DT, CNTRY_CODE, REGION_FIPS, REGION_ABRV, dbo.udf_TitleCase(REGION_NM) REGION_NM
			From Staging.BCRegion e ) AS input
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
Go

Select *
From Shared.StateRegion
Go

CREATE UNIQUE NONCLUSTERED INDEX [UNCI_StateRegion_REGIONFIPS] ON [Shared].[StateRegion]
(
	CountryCode, BCRegionFIPS ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

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
Go

Select *
From Shared.County
Go

CREATE UNIQUE NONCLUSTERED INDEX [UNCI_County_BusinessKey] ON [Shared].[County]
(
	BCCountryCode, BCRegionFIPS, BCCountyFIPS ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
Go

------------------------------------------------------------------------------
---BCPostal table is not very useful, all good combinations of Postal code----
------------------------------------------------------------------------------
Select Top 100 *
From [Staging].[BCPostal]

Select Count(*)
From [Staging].[BCPostal]

Select POstal_CODE, Count(*)
From [Staging].[BCPostal]
Group By POstal_CODE
Having Count(*) > 1
Order By POstal_CODE

Select POstal_CODE, Count(*)
From [Staging].[BCPostal]
Where CNTRY_CODE = 'CA'
Group By POstal_CODE
Having Count(*) > 1
