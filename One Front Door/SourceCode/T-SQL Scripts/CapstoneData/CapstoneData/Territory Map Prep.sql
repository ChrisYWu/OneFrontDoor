use Portal_DataSRE
Go

--Drop Table Staging.BCCountry
--Go

Declare @LastLoadTime DateTime
Set @LastLoadTime = '2013-11-18 17:00:28'
--Set @LastLoadTime = '2014-3-18 17:00:28'
DECLARE @OPENQUERY nvarchar(4000)
Set @OPENQUERY = BC.fnSetOpenQuery('SELECT D.CNTRY_CODE, D.CNTRY_NM, 
D.ISO_CNTRY_CODE, D.ROW_MOD_DT
FROM CAP_DM.DM_CNTRY D', 'COP', @LastLoadTime, 'D')
Set @OPENQUERY = Replace(@OpenQuery, 'Select *', 'Select * Into Staging.BCCountry')

--Select @OpenQuery
Exec (@OPENQUERY)
Go

------------------------------------------------------
------------------------------------------------------
Declare @LastLoadTime DateTime
Set @LastLoadTime = '2013-11-18 17:00:28'
--Set @LastLoadTime = '2014-3-18 17:00:28'
DECLARE @OPENQUERY nvarchar(4000)
Set @OPENQUERY = BC.fnSetOpenQuery('SELECT 
D.CNTRY_CODE, D.REGION_FIPS, D.REGION_ABRV, 
   D.REGION_NM, D.ROW_MOD_DT
FROM CAP_DM.DM_REGION D', 'COP', @LastLoadTime, 'D')
Set @OPENQUERY = Replace(@OpenQuery, 'Select *', 'Select * Into Staging.BCRegion')

--Select @OpenQuery
Exec (@OPENQUERY)
Go

------------------------------------------------------
------------------------------------------------------
Declare @LastLoadTime DateTime
Set @LastLoadTime = '2013-11-18 17:00:28'
--Set @LastLoadTime = '2014-3-18 17:00:28'
DECLARE @OPENQUERY nvarchar(4000)
Set @OPENQUERY = BC.fnSetOpenQuery('SELECT 
D.CNTRY_CODE, D.REGION_FIPS, D.CNTY_FIPS, 
   D.CNTY_NM, D.CNTY_POP, D.ROW_MOD_DT 
FROM CAP_DM.DM_CNTY D', 'COP', @LastLoadTime, 'D')
Set @OPENQUERY = Replace(@OpenQuery, 'Select *', 'Select * Into Staging.BCCounty')

--Select @OpenQuery
Exec (@OPENQUERY)
Go

------------------------------------------------------
------------------------------------------------------
--- About one million rows, takes 10 minutes to load ---
Declare @LastLoadTime DateTime
Set @LastLoadTime = '2013-11-18 17:00:28'
--Set @LastLoadTime = '2014-3-18 17:00:28'
DECLARE @OPENQUERY nvarchar(4000)
Set @OPENQUERY = BC.fnSetOpenQuery('SELECT 
D.CNTRY_CODE, D.POSTAL_CODE, D.REGION_FIPS, 
   D.CNTY_FIPS, D.CITY_NM, D.PRIMARY_CNTY_FLG, 
   D.PRIMARY_POSTAL_FLG, D.POSTAL_CODE_EXT, D.POSTAL_POP, 
   D.ROW_MOD_DT, D.DEL_FLG
FROM CAP_DM.DM_POSTAL D', 'COP', @LastLoadTime, 'D')
Set @OPENQUERY = Replace(@OpenQuery, 'Select *', 'Select * Into Staging.BCPostal')

--Select @OpenQuery
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

--Select @OpenQuery
Exec (@OPENQUERY)
Go