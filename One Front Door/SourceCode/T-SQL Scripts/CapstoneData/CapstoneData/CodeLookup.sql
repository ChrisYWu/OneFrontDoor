use Portal_DataSRE
Go

/* --- Work Area ---
Declare @LastLoadTime DateTime
Set @LastLoadTime = '2013-11-18 17:00:28'
DECLARE @OPENQUERY nvarchar(4000)
Set @OPENQUERY = BC.fnSetOpenQuery('SELECT D.CODE_TYPE, D.CODE_ID, D.CODE_DESC, D.ROW_MOD_DT FROM CAP_DM.DM_CODE_LKP D', 'COP', @LastLoadTime, 'D')
Set @OPENQUERY = Replace(@OpenQuery, 'Select *', 'Select * Into Staging.BCCodeLookup')
Exec (@OPENQUERY)
*/

--- Staging.CodeLookup ---
-- DDL Code
If Exists (Select * From Sys.Objects Where name = 'BCCodeLookup' And Type = 'U')
	DROP TABLE [Staging].[BCCodeLookup]
GO

CREATE TABLE [Staging].[BCCodeLookup](
	[CODE_TYPE] [nvarchar](20) NOT NULL,
	[CODE_ID] [nvarchar](60) NOT NULL,
	[CODE_DESC] [nvarchar](60) NULL,
	[ROW_MOD_DT] SmallDateTime NOT NULL
) ON [PRIMARY]
GO

-- Staging Code
Truncate Table Staging.BCCodeLookup
Go

Declare @LastLoadTime DateTime
Set @LastLoadTime = '2013-11-18 17:00:28'
DECLARE @OPENQUERY nvarchar(4000)
Set @OPENQUERY = BC.fnSetOpenQuery('SELECT D.CODE_TYPE, D.CODE_ID, D.CODE_DESC, D.ROW_MOD_DT FROM CAP_DM.DM_CODE_LKP D', 'COP', @LastLoadTime, 'D')
Set @OPENQUERY = 'Insert Staging.BCCodeLookup ' + @OPENQUERY
Exec (@OPENQUERY)

Select * From Staging.BCCodeLookup
Select Distinct CODE_TYPE From Staging.BCCodeLookup Order By CODE_TYPE 
Go

------------------------------------------
------------------------------------------
---- Just DPSG, not worth loading ----
Select CODE_ID, CODE_DESC
From Staging.BCCodeLookup
Where CODE_TYPE = 'TRADE_OWNER'

--- SAp ID, can be used. Need to indicate in TradeMark table about the primary source
Select CODE_ID, CODE_DESC
From Staging.BCCodeLookup
Where CODE_TYPE = 'TRADEMARK'
And Code_id not in (Select SAPTradeMarkID From SAP.TradeMark)

--- Non SAP code, don't know how to merge with Brand ---
Select CODE_ID, CODE_DESC
From Staging.BCCodeLookup
Where CODE_TYPE = 'CONSUMER_BRAND'
And CODE_DESC like '%Sunkist%'
-- S0018108 SUNKIST STRWBRY

Select *
From SAP.Brand
Where BrandName like '%Sunkist%'
-- S54	Sunkist Strawberry

--- BevType, should be used to compliment SDM, source need to be indicated
Select CODE_ID, CODE_DESC, bt.BevTypeName
From Staging.BCCodeLookup b
Left Join SAP.BevType bt on b.CODE_ID = bt.SAPBevTypeID
Where CODE_TYPE = 'BEVERAGE_TYPE'


--- New Table BC.BottlerGroup, Business Key is a Guid
Select CODE_ID, CODE_DESC
From Staging.BCCodeLookup b
Where CODE_TYPE = 'BTTLR_GRP'

-- Not Needed, just 4 reocrds on each side
Select CODE_ID, CODE_DESC
From Staging.BCCodeLookup b
Where CODE_TYPE = 'CAFF_CLAIM'

Select *
From SAP.CaffeineClaim

-- Not Needed, just 4 reocrds on each side
Select CODE_ID, CODE_DESC
From Staging.BCCodeLookup b
Where CODE_TYPE = 'CAL_CLASS'

Select *
From SAP.CalorieClass

-- New Table CategorySegment
Select CODE_ID, CODE_DESC
From Staging.BCCodeLookup b
Where CODE_TYPE = 'CAT_SEG'

-- New Table ContainerSize
Select CODE_ID, CODE_DESC
From Staging.BCCodeLookup b
Where CODE_TYPE = 'CNTNR_SIZE'

-- New Table ContainerType
Select CODE_ID, CODE_DESC
From Staging.BCCodeLookup b
Where CODE_TYPE = 'CNTNR_TYPE'

--- All 245 flavors are in so we're good
Select CODE_ID, CODE_DESC, f.FlavorName
From Staging.BCCodeLookup b
Left Join SAP.Flavor f on b.CODE_ID = f.SAPFlavorID
Where CODE_TYPE = 'FLVR'

--- Let's just import it and complement Internal Category
Select CODE_ID, CODE_DESC, ic.InternalCategoryName
From Staging.BCCodeLookup b
Left Join SAP.InternalCategory ic on b.CODE_ID = ic.SAPInternalCategoryID
Where CODE_TYPE = 'INT_CAT_SEG'

	/* Need to have functional and non-functional requirement */
Select *
From SAP.InternalCategory

--- Need to have this package table, but what is relationship to SAP.Package? Or PackageType, Or PackageConfig?
Select CODE_ID, CODE_DESC
From Staging.BCCodeLookup b
Where CODE_TYPE = 'PKG'

--- Do we need this, what are the relationships between this and Package? ----------
Select CODE_ID, CODE_DESC
From Staging.BCCodeLookup b
Where CODE_TYPE = 'PKG_CAT'

----Need to complement SAP.PackageConfig, ---------------
Select CODE_ID, CODE_DESC, pc.SAPPackageConfID, pc.PackageConfName 
From Staging.BCCodeLookup b
Left Join SAP.PackageConf pc on b.CODE_ID = pc.SAPPackageConfID
Where CODE_TYPE = 'PKG_CONFIG'

----- Package Group - do we need this? 
Select CODE_ID, CODE_DESC
From Staging.BCCodeLookup b
Where CODE_TYPE = 'PKG_GRP'

----- Complement Package Pack
Select CODE_ID, CODE_DESC, SAPPackageTypeID, PackageTypeName
From Staging.BCCodeLookup b
Left Join SAP.PackageType pt on b.CODE_ID = pt.SAPPackageTypeID
Where CODE_TYPE = 'PKG_TYPE'

----- ProductGroup, don't know if we need it
Select CODE_ID, CODE_DESC
From Staging.BCCodeLookup b
Where CODE_TYPE = 'PROD_GRP'

----- Store Group, don't know if we need it
Select CODE_ID, CODE_DESC
From Staging.BCCodeLookup b
Where CODE_TYPE = 'STR_GRP'




