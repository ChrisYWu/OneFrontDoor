use Portal_Data_SREINT
Go

Update BC.Bottler
Set GeoCodingNeeded = 1

Declare @LastLoadTime DateTime
Set @LastLoadTime = '2013-11-18 17:00:28'
DECLARE @OPENQUERY nvarchar(4000)
Set @OPENQUERY = BC.fnSetOpenQuery('SELECT 
   D.BTTLR_ID, D.BTTLR_NM, 
   D.CHNL_CODE, D.GLOBAL_STTS, 
   D.DEL_FLG, D.ROW_MOD_DT, 
   D.PRODUCER_FLG
FROM CAP_DM.DM_BTTLR D', 'COP', @LastLoadTime, 'D')
Set @OPENQUERY = Replace(@OpenQuery, 'Select *', 'Select * Into Staging.BCBottler')

Exec (@OPENQUERY)

--Drop Table Staging.BCBottler

Select * From Staging.BCBottler
Where Del_Flg = 'N'
Go

-- What is channel 505?
Select Distinct Chnl_Code
From Staging.BCBottler
Where Chnl_Code not in (
	Select SAPChannelID From SAP.Channel
	Where SAPChannelID in (
	Select Distinct Chnl_Code From Staging.BCBottler
	)
)



----------------------------------------------------
----------------------------------------------------
----------------------------------------------------
--- Staging.BeverageGroup ---
If Exists (Select * From Sys.Objects Where name = 'BCBeverageGroup' And Type = 'U')
	DROP TABLE [Staging].[BCBeverageGroup]
GO

CREATE TABLE [Staging].[BCBeverageGroup](
	[BEV_GRP_ID] [nvarchar](10) Primary Key NOT NULL,
	[BEV_GRP_DESC] [nvarchar](40) NULL,
	[DEL_FLG] [nvarchar](1) NULL,
	[ROW_MOD_DT] SmallDateTime NOT NULL
) ON [PRIMARY]
GO

Truncate Table Staging.BCBeverageGroup
Go

Declare @LastLoadTime DateTime
Set @LastLoadTime = '2013-11-18 17:00:28'
DECLARE @OPENQUERY nvarchar(4000)
Set @OPENQUERY = BC.fnSetOpenQuery('SELECT BEV_GRP_ID, BEV_GRP_DESC, DEL_FLG, ROW_MOD_DT FROM CAP_DM.DM_BEV_GRP_HDR', 'COP', @LastLoadTime, Default)
Set @OPENQUERY = 'Insert Staging.BCBeverageGroup ' + @OPENQUERY
Exec (@OPENQUERY)

Select * From Staging.BCBeverageGroup
Go

----------------------------------------------------
----------------------------------------------------
--- Staging.BCTradeMarkBeverageGroup ---
If Exists (Select * From Sys.Objects Where name = 'BCTradeMarkBeverageGroup' And Type = 'U')
	DROP TABLE Staging.BCTradeMarkBeverageGroup
GO

CREATE TABLE [Staging].[BCTradeMarkBeverageGroup](
	[BEV_GRP_ID] [nvarchar](10) NOT NULL,
	[TRADEMARK_ID] [nvarchar](5) NOT NULL,
	[DEL_FLG] [nvarchar](1) NULL,
	[ROW_MOD_DT] SmallDateTime NOT NULL
) ON [PRIMARY]
GO

Truncate Table Staging.BCBeverageGroup
Go

Declare @LastLoadTime DateTime
Set @LastLoadTime = '2013-11-18 17:00:28'
DECLARE @OPENQUERY nvarchar(4000)
Set @OPENQUERY = BC.fnSetOpenQuery('SELECT D.BEV_GRP_ID, D.TRADEMARK_ID, D.DEL_FLG, D.ROW_MOD_DT FROM CAP_DM.DM_BEV_GRP D', 'COP', @LastLoadTime, 'D')
Set @OPENQUERY = 'Insert Staging.BCTradeMarkBeverageGroup ' + @OPENQUERY
Exec (@OPENQUERY)

Select * From Staging.BCTradeMarkBeverageGroup
Go

----------------------------------------------------
----------------------------------------------------
-- Staging.Bottler --
If Exists (Select * From Sys.Objects Where name = 'BCBottler' And Type = 'U')
	DROP TABLE Staging.BCBottler
GO

CREATE TABLE [Staging].[BCBottler](
	[BTTLR_ID] [nvarchar](10) Primary Key NOT NULL,
	[BTTLR_NM] [nvarchar](60) NULL,
	[CHNL_CODE] [nvarchar](3) NULL,
	[GLOBAL_STTS] [nvarchar](2) NULL,
	[DEL_FLG] [nvarchar](1) NULL,
	[ROW_MOD_DT] SmallDateTime NOT NULL,
	[PRODUCER_FLG] [nvarchar](1) NULL
) ON [PRIMARY]
GO

Truncate Table Staging.BCBottler
Go

Declare @LastLoadTime DateTime
Set @LastLoadTime = '2013-11-18 17:00:28'
DECLARE @OPENQUERY nvarchar(4000)
Set @OPENQUERY = BC.fnSetOpenQuery('SELECT D.BTTLR_ID, D.BTTLR_NM, D.CHNL_CODE, D.GLOBAL_STTS, D.DEL_FLG, D.ROW_MOD_DT, D.PRODUCER_FLG FROM CAP_DM.DM_BTTLR D', 'COP', @LastLoadTime, 'D')
Set @OPENQUERY = 'Insert Staging.BCBottler ' + @OPENQUERY
Exec (@OPENQUERY)

Select * From Staging.BCBottler
Go

----------------------------------------------------
----------------------------------------------------
Drop Table Staging.BCBPAddress
Go

SELECT 
D.ADDR_REGION_FIPS, D.ADDR_CNTY_FIPS
FROM CAP_DM.DM_BP_ADDR D;

--Staging.BCBPAddress  Takes 7 minutes for full load, differential is negligible

--Initial Table Create Query for development
Declare @LastLoadTime DateTime
Set @LastLoadTime = '2013-11-18 17:00:28'
DECLARE @OPENQUERY nvarchar(4000)
Set @OPENQUERY = BC.fnSetOpenQuery('SELECT 
   D.ADDR_ID, D.ADDR_TYPE, D.BP_ID, 
   D.ADDR_LINE_1, D.ADDR_LINE_2, 
   D.ADDR_CITY, 
   D.ADDR_REGION_ABRV, D.ADDR_CNTY_NM, 
   D.ADDR_PSTL_CODE, 
   D.ADDR_CNTRY_CODE, D.PHN_NBR, 
   D.FAX_NBR, D.EMAIL, 
   D.ROW_MOD_DT,
   D.ADDR_REGION_FIPS, D.ADDR_CNTY_FIPS 
FROM CAP_DM.DM_BP_ADDR D', 'COP', @LastLoadTime, 'D')
Set @OPENQUERY = Replace(@OpenQuery, 'Select *', 'Select * Into Staging.BCBPAddress')
Set @OPENQUERY = Replace(@OpenQuery, 'MI:SS'''')'')', 'MI:SS'''') AND SYSDATE Between D.VLD_FRM_DT And D.VLD_TO_DT 
And D.DEL_FLG <> ''''Y'''''')')
Exec (@OPENQUERY)

------------------------------
If Exists (Select * From Sys.Objects Where name = 'BCBPAddress' And Type = 'U')
	DROP TABLE Staging.BCBPAddress
GO

CREATE TABLE [Staging].[BCBPAddress](
	[ADDR_ID] [nvarchar](14) Primary Key NOT NULL,
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
	[ROW_MOD_DT] SmallDateTime NOT NULL
) ON [PRIMARY]
GO

--Only For Initial Load Can we do this
--Truncate Table Staging.BCBPAddress
--Go

Declare @LastLoadTime DateTime
Select @LastLoadTime = Max(ROW_MOD_DT) From Staging.BCBPAddress;
DECLARE @OPENQUERY nvarchar(4000)
Set @OPENQUERY = BC.fnSetOpenQuery('SELECT 
   D.ADDR_ID, D.ADDR_TYPE, D.BP_ID, 
   D.ADDR_LINE_1, D.ADDR_LINE_2, 
   D.ADDR_CITY, 
   D.ADDR_REGION_ABRV, D.ADDR_CNTY_NM, 
   D.ADDR_PSTL_CODE, 
   D.ADDR_CNTRY_CODE, D.PHN_NBR, 
   D.FAX_NBR, D.EMAIL, 
   D.ROW_MOD_DT,
   D.ADDR_REGION_FIPS, D.ADDR_CNTY_FIPS 
FROM CAP_DM.DM_BP_ADDR D', 'COP', @LastLoadTime, 'D')
Set @OPENQUERY = 'Insert Staging.BCBPAddress ' + @OPENQUERY
-- Do want the everything from the last load, even if it's an update of Valid Date or Delete flag
--Set @OPENQUERY = Replace(@OpenQuery, 'MI:SS'''')'')', 'MI:SS'''') AND SYSDATE Between D.VLD_FRM_DT And D.VLD_TO_DT 
--And D.DEL_FLG <> ''''Y'''''')')
Exec (@OPENQUERY)

/* Every one business partner has at most one address
Select Top 1000 * From Staging.BCBPAddress Order By ROW_MOD_DT DESC
Select Distinct ADDR_TYPE From Staging.BCBPAddress

Select BP_ID 
From Staging.BCBPAddress
Group By BP_ID
Having Count(*) > 1
*/

Go

----------------------------------------------------
----------------------------------------------------
Drop Table Staging.BCBottlerHierachy

-- Staging.BCBottlerHierachy Takes 9 second for full load, differential is negligible
-- Artificial 4-level hairachy ---
Declare @LastLoadTime DateTime
Set @LastLoadTime = '2013-11-18 17:00:28'
DECLARE @OPENQUERY nvarchar(4000)
Set @OPENQUERY = BC.fnSetOpenQuery('SELECT 
   D.NODE_GUID, D.SEQ_NBR, D.NODE_ID, 
   D.NODE_DESC, D.NODE_VLD_FRM_DT, D.NODE_VLD_TO_DT, 
   D.HIER_LVL_NBR, D.PRNT_GUID, D.HIER_TYPE, 
   D.PARTNER_GUID, D.PARTNER, D.BP_VLD_FRM_DT, 
   D.BP_VLD_TO_DT, D.CHG_NBR, D.MD5_KEY, 
   D.BATCH_ID, D.DEL_FLG, D.ROW_TSK_ID, 
   D.ROW_CRT_DT, D.ROW_CRT_BY, D.ROW_MOD_DT, 
   D.ROW_MOD_BY
FROM CAP_DM.DM_BTTLR_HIER D', 'COP', @LastLoadTime, 'D')
Set @OPENQUERY = Replace(@OpenQuery, 'Select *', 'Select * Into Staging.BCBottlerHierachy')
Set @OPENQUERY = Replace(@OpenQuery, 'MI:SS'''')'')', 'MI:SS'''') AND SYSDATE Between D.NODE_VLD_FRM_DT And D.NODE_VLD_TO_DT '')')
--Set @OPENQUERY = Replace(@OpenQuery, 'MI:SS'''')'')', 'MI:SS'''') AND SYSDATE Between D.NODE_VLD_FRM_DT And D.NODE_VLD_TO_DT 
--And D.DEL_FLG = ''''N'''''')')
Exec (@OPENQUERY)
Go

Select * From Staging.BCBottler
Where DEL_FLG <> 'Y'



Select * From Staging.BCBottlerHierachy
Where DEL_FLG <> 'N'

Select Distinct Hier_Type
From Staging.BCBottlerHierachy


/*
Look at the following example - a real 4 - level heirachy
There is self referecing node - bad data 
135 top level bottler banners connected to 3061 bottlers for EB
I can't find a logical key for this table? is there a key. According to design - this is the key NODE_GUID, SEQ_NBR

*/
Select *
From Staging.BCBottler
Where DEL_FLG <> 'Y'


Select * From Staging.BCBottlerHierachy
Where HIER_TYPE = 'EB'
And HIER_LVL_NBR = '4'
And NODE_ID = 'CCB_MARI'

Select * From Staging.BCBottlerHierachy
Where HIER_TYPE = 'EB'
And HIER_LVL_NBR = '4'
And PARTNER is not null

Select Max(HIER_LVL_NBR) From Staging.BCBottlerHierachy
-- HIER_LVL_NBR is redundant data, so there is a chance that it's screwed up --
-- While it might be used consistently, the hier is from 0~5
-- Seems stage the view data then do distinct makes more sense

Select * From Staging.BCBottlerHierachy
Where HIER_TYPE in ('FS', 'BC')
And HIER_LVL_NBR = '5'
And PARTNER is not null

Select * From Staging.BCBottlerHierachy
Where NODE_ID in ('600336', '5000093', '400035', '30015', '2010', '11')

Select Count(Distinct Seq_Nbr)
From Staging.BCBottlerHierachy

Select Count(*)
From Staging.BCBottlerHierachy

Select * From Staging.BCBottlerHierachy
Where HIER_TYPE = 'EB'
And HIER_LVL_NBR = '3'
And PARTNER is not null

Select * From Staging.BCBottlerHierachy
Where HIER_TYPE = 'EB'
And HIER_LVL_NBR = '2'
And PARTNER is not null

--- 135 Bottler Baners ---
Select * From Staging.BCBottlerHierachy
Where HIER_TYPE = 'EB'
And HIER_LVL_NBR = '1'

Select Distinct NODE_ID, NODE_DESC From Staging.BCBottlerHierachy

Select *
From Staging.BCBottler
Where BTTLR_ID in ('0012008012',
'0012008118',
'0012008847',
'0012014282',
'0012014668',
'0012015037')
Go

