use Portal_DataSRE
Go

----------------------- Map  --------------------------------
------- 23 minutes for full load(2 milliion records) --------
Declare @LastLoadTime DateTime
Set @LastLoadTime = '2013-11-18 17:00:28'
DECLARE @OPENQUERY nvarchar(4000)
Set @OPENQUERY = BC.fnSetOpenQuery('SELECT 
T.TRADEMARK_ID, T.PROD_TYPE_ID, T.TERR_VW_ID, T.CNTRY_CODE, T.REGION_FIPS, T.CNTY_FIPS, 
   T.POSTAL_CODE, T.BTTLR_ID, T.ROW_MOD_DT
FROM CAP_ODS.TM_TERRITORY_MAP T', 'COP', @LastLoadTime, 'T')
Set @OPENQUERY = Replace(@OpenQuery, 'Select *', 'Select * Into Staging.BCTMap')
Set @OPENQUERY = Replace(@OpenQuery, 'Where', 'WHERE T.CNTRY_CODE = ''''US'''' 
AND T.PROD_TYPE_ID=''''01'''' AND T.TERR_VW_ID = ''''12'''' AND SYSDATE BETWEEN T.VLD_FROM_DT AND T.VLD_TO_DT AND')

Select @OPENQUERY
Exec (@OPENQUERY)
Go

---------------------------
---------------------------
Declare @LastLoadTime DateTime
Set @LastLoadTime = '2013-11-18 17:00:28'
DECLARE @OPENQUERY nvarchar(4000)
Set @OPENQUERY = BC.fnSetOpenQuery('SELECT 
T.TRADEMARK_ID, T.PROD_TYPE_ID, T.TERR_VW_ID, 
   T.STR_ID, T.BTTLR_ID, 
   T.INCL_FOR_POSTAL_CODE, T.CNTRY_CODE, 
   T.REGION_FIPS, T.CNTY_FIPS, T.ROW_MOD_DT
FROM CAP_ODS.TM_STR_INCL T', 'COP', @LastLoadTime, 'T')
Set @OPENQUERY = Replace(@OpenQuery, 'Select *', 'Select * Into Staging.BCStoreInclusion')
Set @OPENQUERY = Replace(@OpenQuery, 'Where', 'WHERE T.CNTRY_CODE = ''''US'''' 
AND T.PROD_TYPE_ID=''''01'''' AND SYSDATE BETWEEN T.VLD_FROM_DT AND T.VLD_TO_DT AND')

Exec (@OPENQUERY)
Go

---------------------------
Select Top 100 *
From Staging.BCTmap
Go

----- Some TradeMarks are missing
Select *
From SAP.TradeMark t
Left Join (Select Distinct TRADEMARK_ID From Staging.BCTmap) bc on t.SAPTradeMarkID = bc.TRADEMARK_ID
Where bc.TRADEMARK_ID is not null

/* Missing TradeMarks
R00
W10
C34
O07
U00
*/
Select *
From SAP.TradeMark t
Right Join (Select Distinct TRADEMARK_ID From Staging.BCTmap) bc on t.SAPTradeMarkID = bc.TRADEMARK_ID
Where t.TradeMarkID is null

Select *
From BC.TerritoryMap
Go

----------------------------------------------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--Truncate Table BC.TerritoryMap
--Go

Merge BC.TerritoryMap tm
Using (
	Select tm.TradeMarkID, p.ProductTypeID, m.TerritoryTypeID, c.CountyID, map.POSTAL_CODE, b.BottlerID 
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
WHEN NOT MATCHED By Target THEN
	Insert(TradeMarkID, ProductTypeID, TerritoryTypeID, CountyID, PostalCode, BottlerID)
	Values(input.TradeMarkID, input.ProductTypeID, input.TerritoryTypeID, input.CountyID, input.POSTAL_CODE, input.BottlerID)
WHEN NOT MATCHED By Source THEN
	Delete;
Go

----------------------------------------------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

----------------------------------------------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--Truncate Table BC.BCStoreInclusion
--Go

Merge BC.AccountInclusion tm
Using (
	Select tm.TradeMarkID, p.ProductTypeID, m.TerritoryTypeID, c.CountyID, map.INCL_FOR_POSTAL_CODE PostalCode, b.BottlerID, a.AccountID
	From Staging.BCStoreInclusion map
	Join BC.TerritoryType m on m.BCTerritoryTypeID = map.TERR_VW_ID
	Join BC.ProductType p on p.BCProducTypeID = map.PROD_TYPE_ID
	Join SAP.TradeMark tm on tm.SAPTradeMarkID = map.TRADEMARK_ID
	Join Shared.County c on map.CNTRY_CODE = c.BCCountryCode And map.REGION_FIPS = c.BCRegionFIPS And map.CNTY_FIPS = c.BCCountyFIPS
	Join BC.Bottler b on map.BTTLR_ID = b.BCBottlerID
	Join SAP.Account a on map.STR_ID = a.SAPAccountNumber ) Input 
	On tm.TradeMarkID = input.TradeMarkID
	And tm.ProductTypeID = input.ProductTypeID
	And tm.TerritoryTypeID = input.TerritoryTypeID
	And tm.CountyID = input.CountyID
	And tm.PostalCode = input.PostalCode
	And tm.BottlerID = input.BottlerID
	And tm.AccountID = input.AccountID
WHEN NOT MATCHED By Target THEN
	Insert(TradeMarkID, ProductTypeID, TerritoryTypeID, CountyID, PostalCode, BottlerID, AccountID)
	Values(input.TradeMarkID, input.ProductTypeID, input.TerritoryTypeID, input.CountyID, input.PostalCode, input.BottlerID, input.AccountID)
WHEN NOT MATCHED By Source THEN
	Delete;
Go

----------------------------------------------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Select *
From BC.AccountInclusion

--- TradeMarkID is the only one that's left out ---
--- 90 seconds for calculation and 150 seconds to spit out results. 733,240 k rows.
--- 150 second to complete
Select Distinct map.TerritoryTypeID, map.ProductTypeID, b.BottlerID, b.BCBottlerID, b.BottlerName, 
	t.TradeMarkID, t.SAPTradeMarkID, t.TradeMarkName, 
	l.LocalChainID, l.SAPLocalChainID, l.LocalChainName, 
	r.RegionalChainID, r.SAPRegionalChainID, r.RegionalChainName, 
	n.NationalChainID, n.SAPNationalChainID, n.NationalChainName 
Into BC.BottlerChainTradeMark
From BC.TerritoryMap map
Join SAP.Account a on map.PostalCode = a.PostalCode and map.CountyID = a.CountyID
Join SAP.LocalChain l on a.LocalChainID = l.LocalChainID
Join SAP.RegionalChain r on r.RegionalChainID = l.RegionalChainID
Join SAP.NationalChain n on r.NationalChainID = n.NationalChainID
Join BC.Bottler b on map.BottlerID = b.BottlerID
Join SAP.TradeMark t on map.TradeMarkID = t.TradeMarkID
Where map.TerritoryTypeID = 12
And map.ProductTypeID = 1
And a.InCapstone = 1
And a.Active = 1
Go

--- Inclusion List ---
Select a.CountyID AddressCountyID, a.PostalCode AddressPostalCode, a.County, a.State, a.CountryCode, inc.CountyID, inc.PostalCode, inc.TradeMarkID, a.SAPAccountNumber 
From BC.AccountInclusion inc
Join SAP.Account a on inc.AccountID = a.AccountID
Join BC.Bottler b on inc.BottlerID = b.BottlerID
Join SAP.TradeMark t on inc.TradeMarkID = t.TradeMarkID
Where inc.TerritoryTypeID = 12
And inc.ProductTypeID = 1
And a.InCapstone = 1
And a.Active = 1
Go

Select *
From Staging.BCStoreInclusion

Select *
From BC.AccountInclusion 

Select p.POSTAL_CODE, r.REGION_NM, r.CNTRY_CODE
From Staging.BCPostal p
Join Staging.BCRegion r on p.CNTRY_CODE = r.CNTRY_CODE and p.REGION_FIPS = r.REGION_FIPS
Where POSTAL_CODE = '99356'

Select *
From Staging.BCRegion

Select *
From Staging.BCStoreInclusion
Where STR_ID = 11191464

Select *
From Staging.BCBPAddress
Where BP_ID = 11191464


-- Exclusion List
Select *
From BC.AccountInclusion inc



-- 20 second for calculation
Select Distinct bca.GSN, bca.FirstName, bca.LastName, Title, bcm.BottlerName, bcm.TradeMarkName, bcm.LocalChainName, bcm.RegionalChainName, bcm.NationalChainName
From BC.BottlerChainTradeMark bcm
Join BC.Bottler b on bcm.BottlerID = b.BottlerID
Join BC.BCAccountability bca on bca.BottlerID = b.BottlerID
Go

-- Taking Bottler out(31 seconds to complete, 252K rows)
Select Distinct bca.GSN, bca.FirstName, bca.LastName, Title, bcm.TradeMarkName, bcm.LocalChainName, bcm.RegionalChainName, bcm.NationalChainName
From BC.BottlerChainTradeMark bcm
Join BC.Bottler b on bcm.BottlerID = b.BottlerID
Join BC.BCAccountability bca on bca.BottlerID = b.BottlerID
Go

-- Taking Bottler and trademark out(10 seconds to complete, 31k rows)
Create View BC.GSNChain
As
Select Distinct bca.GSN, bca.FirstName, bca.LastName, Title, bcm.LocalChainName, bcm.RegionalChainName, bcm.NationalChainName
From BC.BottlerChainTradeMark bcm
Join BC.Bottler b on bcm.BottlerID = b.BottlerID
Join BC.BCAccountability bca on bca.BottlerID = b.BottlerID
Go

-------------------------------------------------
---- The query we need --------------------------
-------------------------------------------------
Select distinct TrademarkName, NationalChainName
From BC.GSNChain
Where GSN = 'WILBX007'
Order By NationalChainName
Go



Select *
From BC.BCAccountability
Go

--Select *
--From SAP.Account
--Where InCapstone = 1
--Order By LastModified desc


Select *
From Staging.BCStoreInclusion
Where INCL_FOR_POSTAL_CODE is null
Go

Select *
From BC.AccountInclusion
Go

Select Distinct NationalChainName
From SAP.Account a
Join SAP.LocalChain l on a.LocalChainID = l.LocalChainID
Join SAP.RegionalChain r on r.RegionalChainID = l.RegionalChainID
Join SAP.NationalChain n on r.NationalChainID = n.NationalChainID
Where a.InCapstone = 1
And a.Active = 1
And a.CountyID = 1
Go

Select r.RegionID, b.BottlerID
From BC.Region r
Join BC.Bottler b on r.RegionID = b.BCRegionID
Go













--Select * Into Staging.BCTMap From OpenQuery(COP, 'SELECT 
--T.TRADEMARK_ID, T.REGION_FIPS, T.CNTY_FIPS, 
--   T.POSTAL_CODE, T.BTTLR_ID, T.ROW_MOD_DT
--FROM CAP_ODS.TM_TERRITORY_MAP T Where T.CNTRY_CODE = 'US' AND T.PROD_TYPE_ID='01' AND SYSDATE BETWEEN T.VLD_FROM_DT AND T.VLD_TO_DT AND ROW_MOD_DT > TO_DATE(''2014-03-18 17:00:28'', ''YYYY-MM-DD HH24:MI:SS'')')
--------------------------------------
--Declare @LastLoadTime DateTime
--Set @LastLoadTime = '2013-11-18 17:00:28'
--DECLARE @OPENQUERY nvarchar(4000)
--Set @OPENQUERY = BC.fnSetOpenQuery('SELECT 
--D.CNTRY_CODE, D.REGION_FIPS, D.REGION_ABRV, 
--   D.REGION_NM, D.ROW_MOD_DT
--FROM CAP_DM.DM_REGION D', 'COP', @LastLoadTime, 'T')
--Set @OPENQUERY = Replace(@OpenQuery, 'Select *', 'Select * Into Staging.BCGeoRegion')

--Exec (@OPENQUERY)
--Go

--------------------------------------
--Declare @LastLoadTime DateTime
--Set @LastLoadTime = '2013-11-18 17:00:28'
--DECLARE @OPENQUERY nvarchar(4000)
--Set @OPENQUERY = BC.fnSetOpenQuery('SELECT 
--D.CNTRY_CODE, D.CNTRY_NM, D.ISO_CNTRY_CODE, 
--   D.ROW_MOD_DT
--FROM CAP_DM.DM_CNTRY D', 'COP', @LastLoadTime, 'T')
--Set @OPENQUERY = Replace(@OpenQuery, 'Select *', 'Select * Into Staging.BCGeoCountry')

--Exec (@OPENQUERY)
--Go

--Select *
--From Staging.BCGeoCountry


--Select Distinct CNTRY_CODE
--From Staging.BCGeoRegion
