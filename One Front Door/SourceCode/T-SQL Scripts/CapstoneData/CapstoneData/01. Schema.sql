use Portal_DataSRE
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
	[ROW_MOD_DT] [datetime2](7) NOT NULL
) ON [PRIMARY]
GO







