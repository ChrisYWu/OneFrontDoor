use Portal_DataSRE
Go

Declare @LastLoadTime DateTime
Set @LastLoadTime = '2013-11-18 17:00:28'
DECLARE @OPENQUERY nvarchar(4000)
Set @OPENQUERY = BC.fnSetOpenQuery('SELECT 
   D.NODE_GUID, D.EMP_GUID, D.EMP_FUNC, 
   D.EMP_GSN, D.EMP_ID, D.NODE_ID, 
   D.NODE_DESC, D.HIER_TYPE, D.FIRST_NM, 
   D.LAST_NM, D.PSTN, D.EMAIL, 
   D.PHN_NBR, D.ADDR_LINE_1, D.FAX_NBR, 
   D.ADDR_LINE_2, D.ADDR_CITY, D.ADDR_REGION_ABRV, 
   D.ADDR_POSTAL_CODE, D.VLD_FRM_DT, D.VLD_TO_DT, 
   D.DEL_FLG, D.ROW_MOD_DT
FROM CAP_DM.DM_BTTLR_HIER_EMP D', 'COP', @LastLoadTime, 'D')
Set @OPENQUERY = Replace(@OpenQuery, 'Select *', 'Select * Into Staging.BCBottlerEmployee')

Exec (@OPENQUERY)
Go

USE [Portal_DataSRE]
GO

Delete [Person].[BCSalesAccountability] Where IsSystemLoad = 1
Go
INSERT INTO [Person].[BCSalesAccountability]
           ([IsPrimary]
           ,[GSN]
           ,[TotalCompanyID]
           ,[CountryID]
           ,[SystemID]
           ,[ZoneID]
           ,[DivisionID]
           ,[RegionID]
           ,[IsSystemLoad]
           ,[LastModified])
Select Case When EMP_FUNC = 'Z000010' Then 1 Else 0 End As IsPrimary, 
	EMP_GSN GSN, 
	tc.TotalCompanyID, 
	null CountryID, 
	null SystemID, 
	null ZoneID, 
	null DivisionID, 
	null RegionID, 
	1 IsSystemLoad,
	e.ROW_MOD_DT
From Staging.BCBottlerEmployee e
Join BC.TotalCompany tc on e.NODE_ID = tc.BCNodeID
Join Person.UserProfile u on u.GSN = e.EMP_GSN
Where DEL_FLG <> 'Y'
And GetDate() Between VLD_FRM_DT And VLD_TO_DT
Union
Select Case When EMP_FUNC = 'Z000010' Then 1 Else 0 End As IsPrimary, 
	EMP_GSN, 
	null TotalCompanyID, 
	tc.CountryID, 
	null SystemID, 
	null ZoneID, 
	null DivisionID, 
	null RegionID, 
	1 IsSystemLoad,
	e.ROW_MOD_DT
From Staging.BCBottlerEmployee e
Join BC.Country tc on e.NODE_ID = tc.BCNodeID
Join Person.UserProfile u on u.GSN = e.EMP_GSN
Where DEL_FLG <> 'Y'
And GetDate() Between VLD_FRM_DT And VLD_TO_DT
Union
Select Case When EMP_FUNC = 'Z000010' Then 1 Else 0 End As IsPrimary, 
	EMP_GSN, 
	null TotalCompanyID, 
	null CountryID, 
	tc.SystemID, 
	null ZoneID, 
	null DivisionID, 
	null RegionID, 
	1 IsSystemLoad,
	e.ROW_MOD_DT
From Staging.BCBottlerEmployee e
Join BC.System tc on e.NODE_ID = tc.BCNodeID
Join Person.UserProfile u on u.GSN = e.EMP_GSN
Where DEL_FLG <> 'Y'
And GetDate() Between VLD_FRM_DT And VLD_TO_DT
Union
Select Case When EMP_FUNC = 'Z000010' Then 1 Else 0 End As IsPrimary, 
	EMP_GSN, 
	null TotalCompanyID, 
	null CountryID, 
	null SystemID, 
	tc.ZoneID, 
	null DivisionID, 
	null RegionID, 
	1 IsSystemLoad,
	e.ROW_MOD_DT
From Staging.BCBottlerEmployee e
Join BC.Zone tc on e.NODE_ID = tc.BCNodeID
Join Person.UserProfile u on u.GSN = e.EMP_GSN
Where DEL_FLG <> 'Y'
And GetDate() Between VLD_FRM_DT And VLD_TO_DT
Union
Select Case When EMP_FUNC = 'Z000010' Then 1 Else 0 End As IsPrimary, 
	EMP_GSN, 
	null TotalCompanyID, 
	null CountryID, 
	null SystemID, 
	null ZoneID, 
	tc.DivisionID, 
	null RegionID, 
	1 IsSystemLoad,
	e.ROW_MOD_DT
From Staging.BCBottlerEmployee e
Join BC.Division tc on e.NODE_ID = tc.BCNodeID
Join Person.UserProfile u on u.GSN = e.EMP_GSN
Where DEL_FLG <> 'Y'
And GetDate() Between VLD_FRM_DT And VLD_TO_DT
Union
Select Case When EMP_FUNC = 'Z000010' Then 1 Else 0 End As IsPrimary, 
	EMP_GSN, 
	null TotalCompanyID, 
	null CountryID, 
	null SystemID, 
	null ZoneID, 
	null DivisionID, 
	tc.RegionID, 
	1 IsSystemLoad,
	e.ROW_MOD_DT
From Staging.BCBottlerEmployee e
Join BC.Region tc on e.NODE_ID = tc.BCNodeID
Join Person.UserProfile u on u.GSN = e.EMP_GSN
Where DEL_FLG <> 'Y'
And GetDate() Between VLD_FRM_DT And VLD_TO_DT
Go

Create View BC.GSNRegion
As
	Select GSN, RegionID
	From [Person].[BCSalesAccountability] sa1
	Where RegionID is not null
	Union
	Select GSN, h2.RegionID
	From [Person].[BCSalesAccountability] sa2
	Join BC.BottlerSalesHier h2 on sa2.DivisionID = h2.DivisionID
	Union
	Select GSN, h3.RegionID
	From [Person].[BCSalesAccountability] sa3
	Join BC.BottlerSalesHier h3 on sa3.ZoneID = h3.ZoneID
	Union
	Select GSN, h4.RegionID
	From [Person].[BCSalesAccountability] sa4
	Join BC.BottlerSalesHier h4 on sa4.SystemID = h4.SystemID
	Union
	Select GSN, h5.RegionID
	From [Person].[BCSalesAccountability] sa5
	Join BC.BottlerSalesHier h5 on sa5.CountryID = h5.CountryID
	Union
	Select GSN, h6.RegionID
	From [Person].[BCSalesAccountability] sa6
	Join BC.BottlerSalesHier h6 on sa6.TotalCompanyID = h6.TotalCompanyID
Go

Select *
From BC.BCAccountability
Where GSn = 'SINSX003'
Go

Alter View BC.BCAccountability
As
	Select Distinct u.GSN, u.FirstName, u.LastName, u.Title, u.Email, b.BCBottlerID, b.BottlerName
	From BC.Bottler b
	Join BC.GSNRegion g on b.BCRegionID = g.RegionID
	Join Person.UserProfile u on g.GSN = u.GSN
	Where b.GlobalStatusID = 02
Go

Select *
From BC.Bottler b
Join BC.BottlerSalesHier bh on b.BCRegionID = bh.RegionID --and bh.HierType = 'BC'
Where BCRegionID is not null
And GlobalStatusID = 02
And bh.SystemName in ('BS - Paso System',
'RS - Caso System',
'IS - Iso System')

--6200
--ISO 54k

Select *
From BC.System
Go

Alter View BC.FSAccountability
As
Select u.GSN, u.FirstName, u.LastName, u.Email, u.Title, b.BCBottlerID, b.BottlerName
From BC.Bottler b
Join BC.GSNRegion g on b.FSRegionID = g.RegionID
Join Person.UserProfile u on g.GSN = u.GSN
Where b.GlobalStatusID = 02
Go

Select *
From BC.GSNRegion
Group By GSN, RegionID
Having Count(*) > 1
Go

Select Distinct BCRegionID
From BC.Bottler
Where BCRegionID is not null
Go

Select Distinct FSRegionID
From BC.Bottler
Where FSRegionID is not null
Go

Select Distinct BCRegionID
From BC.Bottler
Where BCRegionID is not null
Union
Select Distinct FSRegionID
From BC.Bottler
Where FSRegionID is not null
Go

/*
Select *
From [Person].[BCSalesAccountability]
Go

Select *
From BC.BottlerSalesHier

/*
Select *
From Staging.BCBottlerEmployee e
Where EMP_GSN Not In
(
	Select Distinct GSN
	From [Person].[BCSalesAccountability]
)

--Select *
--From Staging.BCBottlerHierachy
--Where NODE_GUID = '1CC1DE754AA91ED391EA6362390BC19F'

DECLARE @OPENQUERY nvarchar(4000)
Set @OPENQUERY = 'Select * Into Staging.BCBottlerHierEmployee From OpenQuery(COP, ''SELECT 
V.BTTLR_GUID, V.BTTLR_ID, V.HIER_TYPE, 
   V.REGION_GUID, V.REGION_ID, V.REGION_DESC, 
   V.RSM_GSN, V.RSM_EMP_ID, V.RSM_FUNC, 
   V.RSM_FIRST_NM, V.RSM_LAST_NM, V.RSM_EMAIL, 
   V.DIVISION_GUID, V.DIVISION_ID, V.DIVISION_DESC, 
   V.DSM_GSN, V.DSM_EMP_ID, V.DSM_FUNC, 
   V.DSM_FIRST_NM, V.DSM_LAST_NM, V.DSM_EMAIL, 
   V.ZONE_GUID, V.ZONE_ID, V.ZONE_DESC, 
   V.ZVP_GSN, V.ZVP_EMP_ID, V.ZVP_FUNC, 
   V.ZVP_FIRST_NM, V.ZVP_LAST_NM, V.ZVP_EMAIL, 
   V.SYSTEM_GUID, V.SYSTEM_ID, V.SYSTEM_DESC, 
   V.SVP_GSN, V.SVP_EMP_ID, V.SVP_FUNC, 
   V.SVP_FIRST_NM, V.SVP_LAST_NM, V.SVP_EMAIL, 
   V.CCNTRY_GUID, V.CCNTRY_ID, V.CCNTRY_DESC, 
   V.PRSDNT_GSN, V.PRSDNT_EMP_ID, V.PRSDNT_FUNC, 
   V.PRSDNT_FIRST_NM, V.PRSDNT_LAST_NM, V.PRSDNT_EMAIL, 
   V.TCOMP_GUID, V.TCOMP_ID, V.TCOMP_DESC, 
   V.CEO_GSN, V.CEO_EMP_ID, V.CEO_FUNC, 
   V.CEO_FIRST_NM, V.CEO_LAST_NM, V.CEO_EMAIL
FROM CAP_DM.VW_DM_BTTLR_HIER_EMP V'')'
--Select @OPENQUERY

Exec (@OPENQUERY)
Go

Select BTTLR_ID, Count(*)
From Staging.BCBottlerHierEmployee
Group By BTTLR_ID
Go

*/

Select *
From Staging.BCBottlerHierEmployee
Go

Select GSN, FirstName, LastName, Email
From Person.UserProfile
Where GSN in (Select GSN From Person.BCSalesAccountability)
Go

Select Distinct EMP_GSN, FIRST_NM, LAST_NM, EMAIL
From Staging.BCBottlerEmployee
Where DEL_FLG <> 'Y'
Go
*/