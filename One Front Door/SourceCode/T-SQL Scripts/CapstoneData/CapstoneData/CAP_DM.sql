use Portal_DataSRE
Go

-- BeverageGroup
Select BEV_GRP_ID, BEV_GRP_DESC, ROW_MOD_DT
From COP..CAP_DM.DM_BEV_GRP_HDR

-- Relationship between Trademark to BeverageGroup
Select BEV_GRP_ID, TRADEMARK_ID, ROW_MOD_DT
From COP..CAP_DM.DM_BEV_GRP
Where TRADEMARK_ID
Not IN
(Select SAPTradeMarkID From SAP.TradeMark)
Go

/*
What are those trademarks that's not in SAP BW
------------------------------------
X	C27	2013-11-19 17:00:28.0000000
X	C34	2013-11-19 17:00:28.0000000
X	C36	2013-11-19 17:00:28.0000000
X	O07	2013-11-19 17:00:28.0000000
X	S35	2013-11-19 17:00:28.0000000
X	T13	2013-11-19 17:00:28.0000000
X	U00	2013-11-19 17:00:28.0000000
X	W10	2013-11-19 17:00:28.0000000
*/

-- Don't think this is used
Select * From COP..[CAP_DM].[DM_BILL_TO]

-- The Address table
Select BP_ID, ADDR_BUILDING, ADDR_LINE_1, ADDR_lINE_2, ADDR_CITY, ADDR_REGION_ABRV, ADDR_CNTY_NM, ADDR_PSTL_CODE, ADDR_CNTRY_CODE, PHN_NBR, EMAIL, ROW_MOD_DT 
Into dbo.CSAddressRefresh
From COP..[CAP_DM].[DM_BP_ADDR] -- 209 records that takes 6 minutes to load? need the non-clustered index for the ROW_MOD_DT column
Where ROW_MOD_DT > '2014-3-20'

-- SAP Material 
Select * From COP..[CAP_DM].[DM_PROD] ---- Capstone products are from SAP CRM, CP Joshi knows where it's coming from
Where Prod_Desc like '%5gal Dr Pepper Tank Premix%'

Select *
From SAP.Material
Where MaterialName like '%5gal Dr Pepper Tank Premix%'

Select *
From SAP.Trademark where saptrademarkid = 'D10'


Select * From COP..[CAP_CS].[CM_SRC_TDLINX_MKT]
Select * From COP..[CAP_CS].[CM_SRC_TDLINX_ACCNT]
Select * From COP..[CAP_CS].[CM_SRC_TDLINX_RTLSYNC]
Select * From COP..[CAP_CS].[CM_SRC_TDLINX_STR]
Select * From COP..[CAP_CS].[CM_SRC_TDLINX_STR_ERR]


Select Count(*) From COP..[CAP_DM].[DM_TERRITORY_POSTAL]
Select Top 100 * From COP..[CAP_DM].[DM_TERRITORY_POSTAL]
Select * From COP..[CAP_DM].[DM_BTTLR_HIER]

Select * From COP..[CAP_DM].[DM_BTTLR]
Where DEL_FLG = 'N'

--If Need CRM Bottlers and active
Select * From COP..[CAP_DM].[DM_BTTLR]
Where DEL_FLG = 'N'
And CRM_LOCAL_FLG = 'X' -- Need to verify
And CRM_LOCAL_STTS = 01
--And GLOBAL_STTS = 02

Select Top 1 * From COP..[CAP_DM].[DM_BP_ADDR] -- this is the address for both Bttlers and customers BP stands for business partners that covers both
Where BP_ID = '0011489632'

-- Bottler Hier
Select * From COP..[CAP_DM].[DM_BTTLR_HIER]
Where PARTNER = '0011489632'

Select * From COP..[CAP_DM].[DM_BTTLR_HIER]
Where NODE_DESC = 'BADM - ADMIRAL'

Select * From COP..[CAP_DM].[DM_BTTLR_HIER]
Where NODE_DESC = 'SLCU - SALT LAKE CTY'

-- FS : Fountain Food Service Hier
-- BC: Bottle & Can Hier
-- EB: External Bottler Hier


Select *
From SAP.Channel
Where SAPChannelID in (501, 321)

Select * From COP..CAP_DM.VW_DM_BTTLR_SA_HIER
Where BTTLR_ID = '0011489632'

-- Bottler, Region, Division, Zone, System, CCountry, TCompnay

Select * From COP..CAP_DM.VW_DM_BTTLR_HIER_EMP
Where BTTLR_ID = '0011489632'


-- this is how to get bottler from GSN
Select *
From COP..[CAP_DM].[DM_BTTLR]
Where BTTLR_ID  in (
	Select Distinct BTTLR_ID From COP..CAP_DM.VW_DM_BTTLR_HIER_EMP
	Where 
	(
		RSM_GSN = 'SCAJA001'
		Or DSM_GSN = 'SCAJA001'
		Or ZVP_GSN = 'SCAJA001'
		Or SVP_GSN = 'SCAJA001'
		Or PRSDNT_GSN = 'SCAJA001'
		Or CEO_GSN = 'SCAJA001'
	)
	--And HIER_TYPE in ('FS', 'BC')
);
_FUNC column points to 
CAP_DM.VW_DM_BTTLR_CNTCT


----------------------------
----------------------------
--Operational Data Source ODS
--- From Bottler to Brand ----
/*
3 kinds of bottlers
1. Licensing Bottlers - license holder
2. Reporting Bottlers/Marketing bottlers - reporting case sales for this area + brand combination
3. Servicing Bottlers - delivers the product to stores(ship to)

STARS/
Sales Tracking Analytical Reporting System

NAIS/
National Account Information System


*/

use Portal_Data
Go

Select top 100 *
From COL..CAP_ODS.TM_TERRITORY_MAP
Go

Select *
From SAP.TradeMark
Where SAPTrademarkID = 'P02'
Go

Select Count(*)
From COL..CAP_ODS.TM_TERRITORY_MAP
Go

SElect top 100 *
From COL..CAP_ODS.TM_TERRITORY_MAP

Select count(*)
From COL..CAP_DM.DM_TERRITORY_STR

---- TradeMart -> Bttlr -> Store
Select Top 100 *
From COL..CAP_DM.DM_TERRITORY_STR

--Select *
--From SAP.Account
--Where SAPAccountNumber = '11500029'

Select Count(*)
From COL..CAP_DM.DM_STR

Select Top 1 *
From COL..CAP_DM.DM_STR
Where STR_NM like '%Kroger%'
And STR_Close_DT > GetDate()

Select *
From COL..CAP_DM.DM_STR
Where TDLINX_ID is not null

Select Top 1 *
From COL..CAP_DM.DM_STR
Where TDLINX_ID is not null
And TDLINX_OWNER_NM is not null

Select Top 1 *
From COL..CAP_DM.DM_STR
Where STR_ID = '0011186669'

--Where MSTR_CUST_FLG is null

Select *
From SAP.Account
Where SAPAccountNumber = '11186669'

Select Count(*)
From SAP.Account
Where Longitude is not null and Latitude is not null


-- GSN(RSM) ~ Stores around me. 
-- RSM->Bottlers->
--	  Brands----->
	     ---Geo -> County Public information

Select count(*)
From COL..CAP_DM.DM_STR
Where LATITUDE is not null
And LONGITUDE is not null

Select *
From COL..CAP_DM.DM_STR
Where LATITUDE is not null
And LONGITUDE is not null


/*
TRADEMARK_ID is the SAP Trademark ID
PROD_TYPE_ID - 02 is FS and 01 is BC
-- 10 Li, 11 Mar, 12 Ser

TRADEMARK_ID	- SAP Trademark ID
PROD_TYPE_ID	- 02 is FS and 01 is BC
TERR_VW_ID		- 10 Licensing Bottler, 11 Marketing Bottler, 12 Servicing Bottler
CNTRY_CODE		- US or CA or ME
REGION_FIPS	    - Pointer to Region table
CNTY_FIPS		- Pointer to County table
POSTAL_CODE		- Pointer to Postal Code table
VLD_FROM_DT		- Valid from
VLD_TO_DT		- Valid to
BTTLR_ID		- Bottler ID
STTS_ID			- Not used

*/


Select * From COP..

Select * From COP..

Select * From COP..
Select * From COP..
Select * From COP..
Select * From COP..
Select * From COP..
Select * From COP..
Select * From COP..
Select * From COP..
Select * From COP..
Select * From COP..
Select * From COP..
Select * From COP..
Select * From COP..
Select * From COP..

Select *
From SAP.Material

Select *
From SAP.Account
Where SAPAccountNumber like '%11186477%'

Where Longitude is not null
and accountname like '%walmart%'


MSTR_CUST_ID

ER: External Hierachy
NA: National Account Hier


