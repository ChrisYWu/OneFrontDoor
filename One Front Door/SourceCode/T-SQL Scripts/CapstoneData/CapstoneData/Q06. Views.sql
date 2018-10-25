USE Portal_Data_INT
GO

-----------------------------------------------
-----------------------------------------------
If Exists (Select * From Sys.views where object_id = object_id('BC.vBottlerSalesHier'))
Begin
	Drop View BC.vBottlerSalesHier
End
Go

Create View BC.vBottlerSalesHier
As
	Select tc.TotalCompanyName, tc.TotalCompanyID, tc.HierType, c.CountryName, c.CountryID, s.SystemName, s.SystemID
		,z.ZoneName, z.ZoneID, d.DivisionName, d.DivisionID, r.RegionName, r.RegionID, r.BCNodeID RegionBCNodeID 
	From BC.TotalCompany tc
	Join BC.Country c on tc.TotalCompanyID = c.TotalCompanyID 
	Join BC.System s on c.CountryID = s.CountryID
	Join BC.Zone z on z.SystemID = s.SystemID
	Join BC.Division d on d.ZoneID = z.ZoneID
	Join BC.Region r on d.DivisionID = r.DivisionID

GO

-----------------------------------------------
-----------------------------------------------
If Exists (Select * From Sys.views where object_id = object_id('Staging.vBCProduct'))
Begin
	Drop View Staging.vBCProduct
End
Go

Create View [Staging].[vBCProduct]
As
Select p1.[PROD_ID]
      ,[PROD_DESC]
      ,[PROD_STTS]
      ,[TRADEMARK_ID]
      ,[TRADEMARK_DESC]
      ,[TRADEMARK_GRP_ID]
      ,[TRADEMARK_GRP_DESC]
      ,[CORE_BRND_GRP_ID]
      ,[CORE_BRND_GRP_DESC]
      ,[CNTNR_TYPE_ID]
      ,[CNTNR_TYPE_DESC]
      ,[PKG_ID]
      ,[PKG_DESC]
      ,[CAFF_CLAIM_ID]
      ,[CAFF_CLAIM_DESC]
      ,[PKG_EXTN_ID]
      ,[PKG_EXTN]
      ,[BEV_TYPE_ID]
      ,[BEV_TYPE_DESC]
      ,[FLVR_ID]
      ,[FLVR_DESC]
      ,[CARB_CODE]
      ,[CARB_CODE_DESC]
      ,[CNTNR_SZ_DESC],
   D.PKG_TYPE_ID, D.PKG_TYPE_DESC, D.PKG_CFG_ID, 
   D.PKG_CFG_DESC, D.PKG_CAT_DESC, D.PKG_VERSION, 
   D.PCK_VERS_DESC, D.PCK_CONSU_PK_DESC, D.CNSMR_BRND_ID, 
   D.CNSMR_BRND_DESC, D.CAT_SEG_ID, D.CAT_SEG_DESC, 
   D.INIT_CAT_SEG_ID, D.INIT_CAT_SEG_DESC, D.CAL_CLASS_ID, 
   D.CAL_CLASS_DESC, D.BASE_PROD_DESC, D.BS_PR_WEB_PR_FLG, 
   D.VLD_ALL_CHAINS, D.UNITS_IN_PCK, D.PCKS_IN_CASE, 
   D.BASE_PCK_TYPE_DESC, D.PKG_WEB_PRC_FLG, D.STARS_ID, 
   D.NAIS_ID, D.CSTONE_ID, D.PROBE_ID, 
   D.MDM_ID, D.CONV_CASE_CONV_FCTR, D.RELEVANCE_PRC_FLG, 
   D.CS_SLS_RELEVANT_FLG, D.GTIN, D.INFO_PROVIDER_GLN, 
   D.UPC10, D.CNSMR_UPC, D.FRANCHISOR_ID, 
   D.FRANCHISOR_DE, D.PROD_ALIGN_ID, D.PROD_ALIGN_DESC, 
   D.DEL_FLG, 
   D.ROW_MOD_DT, D.PROD_GUID, 
   D.PACK_GRP, D.PACK_GRP_DESC
From Staging.BCProduct1 p1
Join Staging.BCProduct2 D on p1.PROD_ID = D.PROD_ID

GO

-----------------------------------------------
-----------------------------------------------
If Exists (Select * From Sys.views where object_id = object_id('BC.vGSNRegion'))
Begin
	Drop View BC.vGSNRegion
End
Go

CREATE View [BC].[vGSNRegion]
As
	Select r.RegionName, acctability.*
	From BC.Region r Join
	(
	Select GSN, RegionID, RegionID AssignedRegionID, DivisionID AssignedDivisionID, ZoneID AssignedZoneID, SystemID AssignedSystemID
	From [Person].[BCSalesAccountability] sa1
	Where RegionID is not null
	Union
	Select GSN, h2.RegionID, sa2.RegionID AssignedRegionID, sa2.DivisionID AssignedDivisionID, sa2.ZoneID AssignedZoneID, sa2.SystemID AssignedSystemID
	From [Person].[BCSalesAccountability] sa2
	Join BC.vBottlerSalesHier h2 on sa2.DivisionID = h2.DivisionID
	Union
	Select GSN, h3.RegionID, sa3.RegionID AssignedRegionID, sa3.DivisionID AssignedDivisionID, sa3.ZoneID AssignedZoneID, sa3.SystemID AssignedSystemID
	From [Person].[BCSalesAccountability] sa3
	Join BC.vBottlerSalesHier h3 on sa3.ZoneID = h3.ZoneID
	Union
	Select GSN, h4.RegionID, sa4.RegionID AssignedRegionID, sa4.DivisionID AssignedDivisionID, sa4.ZoneID AssignedZoneID, sa4.SystemID AssignedSystemID
	From [Person].[BCSalesAccountability] sa4
	Join BC.vBottlerSalesHier h4 on sa4.SystemID = h4.SystemID
	Union
	Select GSN, h5.RegionID, sa5.RegionID AssignedRegionID, sa5.DivisionID AssignedDivisionID, sa5.ZoneID AssignedZoneID, sa5.SystemID AssignedSystemID
	From [Person].[BCSalesAccountability] sa5
	Join BC.vBottlerSalesHier h5 on sa5.CountryID = h5.CountryID
	Union
	Select GSN, h6.RegionID, sa6.RegionID AssignedRegionID, sa6.DivisionID AssignedDivisionID, sa6.ZoneID AssignedZoneID, sa6.SystemID AssignedSystemID
	From [Person].[BCSalesAccountability] sa6
	Join BC.vBottlerSalesHier h6 on sa6.TotalCompanyID = h6.TotalCompanyID) acctability on acctability.RegionID = r.RegionID

GO

-----------------------------------------------
-----------------------------------------------
If Exists (Select * From Sys.views where object_id = object_id('BC.vFSAccountability'))
Begin
	Drop View BC.vFSAccountability
End
Go

CREATE View BC.vFSAccountability
As
Select u.GSN, u.FirstName, u.LastName, u.Email, u.Title, b.BCBottlerID, b.BottlerName
From BC.Bottler b
Join BC.vGSNRegion g on b.FSRegionID = g.RegionID
Join Person.UserProfile u on g.GSN = u.GSN
Where b.GlobalStatusID = 02

GO

-----------------------------------------------
-----------------------------------------------
If Exists (Select * From Sys.views where object_id = object_id('BC.[vBCAccountability]'))
Begin
	Drop View BC.[vBCAccountability]
End
Go

CREATE View [BC].[vBCAccountability]
As
	Select Distinct u.GSN, u.FirstName, u.LastName, u.Title, u.Email, b.BottlerID, b.BCBottlerID, b.BottlerName
	From BC.Bottler b
	Join BC.vGSNRegion g on b.BCRegionID = g.RegionID
	Join Person.UserProfile u on g.GSN = u.GSN
	Where b.GlobalStatusID = 02

GO

-----------------------------------------------
-----------------------------------------------
If Exists (Select * From Sys.views where object_id = object_id('BC.vBottlerExternalHier'))
Begin
	Drop View BC.vBottlerExternalHier
End
Go

Create View [BC].vBottlerExternalHier
As
	Select 
	--eb1.BCNodeID BCNode1ID,
	  eb1.EB1Name, eb1.EB1ID,
	--eb2.BCNodeID BCNode2ID,
	  eb2.EB2Name, eb2.EB2ID,
	--eb3.BCNodeID BCNode3ID,
	  eb3.EB3Name, eb3.EB3ID,
	--eb4.BCNodeID BCNode4ID
	  eb4.EB4Name, eb4.EB4ID
	From BC.BottlerEB1 eb1
	Join BC.BottlerEB2 eb2 on eb1.EB1ID = eb2.EB1ID
	Join BC.BottlerEB3 eb3 on eb2.EB2ID = eb3.EB2ID
	Join BC.BottlerEB4 eb4 on eb3.EB3ID = eb4.EB3ID
	Where eb1.Active = 1 and eb1.Active = 1 and eb3.Active = 1 and eb4.Active = 1

GO

-----------------------------------------------
-----------------------------------------------
If Exists (Select * From Sys.views where object_id = object_id('BC.vCPIBottler'))
Begin
	Drop View BC.vCPIBottler
End
Go

Create View BC.vCPIBottler
As
Select b.BottlerID, b.BCBottlerID, b.BottlerName, r.RegionID, r.RegionName BCRegionName, b.GlobalStatusID
From BC.Bottler b
Join BC.Region r on b.BCRegionID = r.RegionID And r.HierType = 'BC'
Join Bc.Division d on r.DivisionID = d.DivisionID
Join BC.Zone z on d.ZoneID = z.ZoneID
Join BC.System s on z.SystemID = s.SystemID
Where s.BCNodeID in (30004, 30005, 30006)
And b.GlobalStatusID = 2
Go

-----------------------------------------------
-----------------------------------------------
If Exists (Select * From Sys.views where object_id = object_id('BC.vSalesHierarchy'))
Begin
	Drop View BC.vSalesHierarchy
End
Go

Create View BC.vSalesHierarchy
As
Select s.SystemID, s.BCNodeID SystemNodeID, s.SystemName, z.ZoneID, z.BCNodeID ZoneNodeID, z.ZoneName, 
	d.DivisionID, d.BCNodeID DivisionNodeID, d.DivisionName, r.RegionID, r.BCNodeID RegionNodeID, r.RegionName
From BC.System s
Join BC.Zone z on s.SystemID = z.SystemID
Join BC.Division d on z.ZoneID = d.ZoneID
Join BC.Region r on d.DivisionID = r.DivisionID
Go
