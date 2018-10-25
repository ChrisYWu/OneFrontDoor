use Portal_Data
Go

Select AccountID, SAPAccountNumber, Active, CRMActive, Latitude, Longitude
From SAP.Account
Where Address like '%200 E FM 544%'
And InCapstone = 1

Select Top 100 *
From Staging.BWAccount
Where Customer_number in (
'50050917',
'50051064',
'12306527',
'11286576',
'51902607'
)

Select Count(*)
From SAP.Account
Where Active = 1

Select *
From SAP.Account
Where AccountID = 1315442

-------------------------
Select * From OpenQuery(COP, 'SELECT 
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
	FROM CAP_DM.DM_STR D WHERE STR_ID IN (
	''0012306527'',
	''0050050917'',
	''0050051064'',
	''0012306527'',
	''0011286576'',
	''0051902607''	
	)')

--Select Count(*)
--From Staging.BcStore

