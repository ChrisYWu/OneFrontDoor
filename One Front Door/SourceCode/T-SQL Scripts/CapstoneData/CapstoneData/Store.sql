use Portal_DataSRE
Go

--- 7:30 minutes to take over the entire record set ---
--- Need to reset to do the distinct to get the channel --
Declare @LastLoadTime DateTime
Set @LastLoadTime = '2013-11-18 17:00:28'
DECLARE @OPENQUERY nvarchar(4000)
Set @OPENQUERY = BC.fnSetOpenQuery('SELECT 
D.STR_ID, D.PARTNER_GUID, D.STR_NM, 
   D.STR_CLOSE_DT, D.TDLINX_ID, 
   D.FORMAT, 
   D.LATITUDE, D.LONGITUDE, D.LAT_LON_PREC_COD, 
   D.CHNL_CODE, D.CHNL_DESC, D.CHAIN_TYPE, D.ERH_LVL_4_NODE_ID, 
   D.EXT_STR_STTS_IND, D.GLOBAL_STTS, 
   D.DEL_FLG, 
   D.ROW_MOD_DT FROM CAP_DM.DM_STR D', 'COP', @LastLoadTime, 'D')
Set @OPENQUERY = Replace(@OpenQuery, 'Select *', 'Select * Into Staging.BCStore')

Exec (@OPENQUERY)
Go

--- Need to understand timing for system update ---
--- Use Capstone data to update BW data ---
Select a.AccountName, s.STR_NM, s.GLOBAL_STTS, a.Active
From Staging.BCStore s
Join SAP.Account a On s.STR_ID = a.SAPAccountNumber
Where a.AccountName <> s.STR_NM

Insert Into SAP.Channel Values(29, 505, 'Franchise Non Prod')
Go

Select *
From Staging.BCBPAddress
Go

--Select Count(*)
--From [Staging].[BCStoreHier]

-------------------------------
-------------------------------
-------------------------------
MERGE SAP.Account AS pc
	USING (	Select 
			s.STR_ID,
			dbo.udf_TitleCase(s.STR_NM) STR_NM, 
			s.ROW_MOD_DT CapstoneLastModified,
			s.Format,
			s.Latitude,
			s.Longitude,
			s.TDLinx_ID,
			dbo.udf_TitleCase(a.[ADDR_LINE_1]) ADDR_LINE_1,
			dbo.udf_TitleCase(a.[ADDR_CITY]) ADDR_CITY,
			dbo.udf_TitleCase(a.ADDR_CNTY_NM) ADDR_CNTY_NM,
			a.ADDR_CNTRY_CODE,
			a.ADDR_REGION_ABRV,
			a.ADDR_PSTL_CODE,
			a.EMAIL,
			a.PHN_NBR,
			a.ROW_MOD_DT AddressLastModified,
			1 IsCapstoneStore,
			'Cap' GeoSource,
			c.ChannelID,
			s.CHNL_CODE,
			lc.LocalChainID,
			Case When GLOBAL_STTS <> 02 Then 0 When DEL_FLG = 'Y' Then 0 When (GetDate() > STR_CLOSE_DT) Then 0 Else 1 End Active,
			cty.CountyID
			From staging.BCStore s
			Left Join Staging.BCBPAddress a on s.STR_ID = a.BP_ID
			Left Join SAP.Channel c on s.CHNL_CODE = SAPChannelID
			Left Join SAP.LocalChain lc on lc.SAPLocalChainID = s.ERH_LVL_4_NODE_ID
			Left Join Shared.County cty on cty.BCCountryCode = a.ADDR_CNTRY_CODE And cty.BCRegionFIPS = a.ADDR_REGION_FIPS And cty.BCCountyFIPS = a.ADDR_CNTY_FIPS
		  ) AS input
		ON pc.SAPAccountNumber = input.STR_ID
WHEN MATCHED THEN
	UPDATE SET pc.CapstoneLastModified = input.CapstoneLastModified,
			   pc.InCapstone = 1,
			   --County = input.ADDR_CNTY_NM,
			   PostalCode = IsNull(input.ADDR_PSTL_CODE, PostalCode),
			   AddressLastModified = input.AddressLastModified,
			   Format = input.Format,
			   TDLinxID = input.TDLinx_ID,
			   Latitude = Case When pc.Latitude is null And pc.Longitude is null Then input.Latitude Else pc.Latitude End,
			   Longitude = Case When pc.Latitude is null And pc.Longitude is null Then input.Longitude Else pc.Longitude End,
			   GeoSource = Case When pc.Latitude is null And pc.Longitude is null Then 'Cap' Else 'RN' End,
			   Active = input.Active,
			   CountryCode = ADDR_CNTRY_CODE,
			   CountyID = input.CountyID
WHEN NOT MATCHED By Target THEN
	INSERT([SAPAccountNumber],[AccountName],[ChannelID],[LocalChainID]
	,[Address],[City],
	--[County],
	[State],[PostalCode]
	,[PhoneNumber],[Longitude],[Latitude],[Active]
	,[LastModified], Format, CountryCode, CountyID
	,[TDLinxID],[CapstoneLastModified],[AddressLastModified],GEOSource,[InCapstone])
	VALUES(input.STR_ID, STR_NM, input.ChannelID, input.LocalChainID
	,Input.ADDR_LINE_1, input.ADDR_CITY, 
	--input.ADDR_CNTY_NM, 
	input.ADDR_REGION_ABRV, input.ADDR_PSTL_CODE
	,input.PHN_NBR, input.Latitude, input.Longitude, input.Active
	,GetDate(), input.Format, input.ADDR_CNTRY_CODE, input.CountyID
	,input.TDLinx_ID, input.CapstoneLastModified, input.AddressLastModified, 'Cap', 1);

Update SAP.Account
Set [ChangeTrackNumber] = CHECKSUM(SAPAccountNumber, AccountName, ChannelID, BranchID, LocalChainID, 
		Address, City, State, CountryCode, PostalCode, Contact, PhoneNumber, Longitude, Latitude, Active)
Where InCapstone = 1
Go

USE [Portal_DataSRE]
GO
Drop Index 
NC_Account_Capstone_CountyID_PostalCode
ON [SAP].[Account]

CREATE NONCLUSTERED INDEX [NC_Account_Capstone_CountyID_PostalCode] ON [SAP].[Account]
(
	[InCapstone] ASC,
	[Active] ASC,
	[PostalCode] ASC,
	[CountyID] ASC
)
INCLUDE ([LocalChainID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

Drop view BC.CapstoneStore
Go

Create View BC.CapstoneStore
As
Select Distinct ch.NationalChainName
From SAP.Account a
Join MView.ChainHier ch on a.LocalChainID = ch.LocalChainID
Where InCapstone = 1
And Active = 1
And CountryCode = 'US'
Go

--Select Top 1 *
--From Staging.BCVWStoreERH

-----------------------------
-----------------------------
-----------------------------
Alter Table SAP.Account
Add InCapstone Bit 
Go

Alter Table SAP.Account
Add CountryCode varchar(2)
Go

Alter Table SAP.Account
Add County Varchar(50) Null
Go

Alter Table SAP.Account
Add CapstoneLastModified SmallDateTime Null
Go

Alter Table SAP.Account
Add AddressLastModified SmallDateTime Null
Go

Alter Table SAP.Account
Add Format varchar(2) Null
Go

Alter Table SAP.Account
Add CountyID int Null
Go

Alter Table SAP.Account
Add TDLinxID varchar(2) Null
Go

Alter Table SAP.Account
Add GeoSource varchar(5) Null
Go

-----------------------------
-----------------------------
-----------------------------
/*
Select GLOBAL_STTS, count(*)
From staging.BCStore s
Group By GLOBAL_STTS
Select *
From Staging.BCBPAddress

Declare @LastLoadTime DateTime
Set @LastLoadTime = '2013-11-18 17:00:28'
DECLARE @OPENQUERY nvarchar(4000)
Set @OPENQUERY = BC.fnSetOpenQuery('SELECT 
D.STR_ID, D.PARTNER_GUID, D.STR_NM, 
   D.STR_CLOSE_DT, D.TDLINX_ID, 
   D.FORMAT, 
   D.LATITUDE, D.LONGITUDE, D.LAT_LON_PREC_COD, 
   D.CHNL_CODE, D.CHAIN_TYPE, D.ERH_LVL_4_NODE_ID, 
   D.EXT_STR_STTS_IND, D.GLOBAL_STTS, 
   D.DEL_FLG, 
   D.ROW_MOD_DT FROM CAP_DM.DM_STR D', 'COP', @LastLoadTime, 'D')
Set @OPENQUERY = Replace(@OpenQuery, 'Select *', 'Select * Into Staging.BCStore')

Exec (@OPENQUERY)
Go
*/
-----
