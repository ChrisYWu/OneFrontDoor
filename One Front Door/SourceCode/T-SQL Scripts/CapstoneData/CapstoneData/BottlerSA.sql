use Portal_DataSRE
Go

Select Distinct HIER_TYPE, REGION_ID, REGION_DESC, DIVISION_ID, DIVISION_DESC, 
	ZONE_ID, ZONE_DESC, SYSTEM_ID, SYSTEM_GUID, CCNTRY_ID, CCNTRY_DESC, TCOMP_ID, TCOMP_DESC
From Staging.BCBottlerSalesHierachy a
Go

Select Distinct REGION_ID
From Staging.BCBottlerSalesHierachy a
Go

Select Bttlr_id, count(*)
From Staging.BCBottlerSalesHierachy
Group By Bttlr_id

Select *
From Staging.BCBottlerSalesHierachy
Where Bttlr_id = 0021912962

Select *
From BC.Bottler
Where BCREgionID is not null and FSRegionID is not null



Select Distinct HIER_TYPE, NODE_ID, NODE_DESC
From Staging.BCBottlerHierachy
Where HIER_TYPE in ('FS', 'BC')
And HIER_LVL_NBR = 5
Go

---------------------------------------------
--Drop Table Staging.BCBottlerSalesHierachy 
Go

DECLARE @OPENQUERY nvarchar(4000)
Set @OPENQUERY = 'Select * Into Staging.BCBottlerSalesHierachy From OpenQuery(COP, ''Select V.BTTLR_GUID, V.BTTLR_ID, V.HIER_TYPE, 
   V.REGION_DESC, V.REGION_GUID, V.REGION_ID, 
   V.DIVISION_DESC, V.DIVISION_GUID, V.DIVISION_ID, 
   V.ZONE_DESC, V.ZONE_GUID, V.ZONE_ID, 
   V.SYSTEM_DESC, V.SYSTEM_GUID, V.SYSTEM_ID, 
   V.CCNTRY_DESC, V.CCNTRY_GUID, V.CCNTRY_ID, 
   V.TCOMP_DESC, V.TCOMP_GUID, V.TCOMP_ID
FROM CAP_DM.VW_DM_BTTLR_SA_HIER V'')'
Exec (@OPENQUERY)
Go

Delete BC.Region
Delete BC.Division
Delete BC.Zone
Delete BC.System
Delete BC.Country
Delete BC.TotalCompany
Go

------------------------------------------------------
If Exists (Select * From Sys.views Where object_id = object_id('BC.BottlerSalesHier'))
Begin
	Drop View BC.BottlerSalesHier
End
Go

Create View BC.BottlerSalesHier
As
	Select tc.TotalCompanyName, tc.TotalCompanyID, tc.HierType, c.CountryName, c.CountryID, s.SystemName, s.SystemID
		,z.ZoneName, z.ZoneID, d.DivisionName, d.DivisionID, r.RegionName, r.RegionID, r.BCNodeID RegionBCNodeID 
	From BC.TotalCompany tc
	Join BC.Country c on tc.TotalCompanyID = c.TotalCompanyID 
	Join BC.System s on c.CountryID = s.CountryID
	Join BC.Zone z on z.SystemID = s.SystemID
	Join BC.Division d on d.ZoneID = z.ZoneID
	Join BC.Region r on d.DivisionID = r.DivisionID
Go

Select *
From BC.BottlerSalesHier
Order By HierType, TotalCompanyName, CountryName, SystemName, ZoneName, DivisionName, RegionName
Go

--- All the CASO, ISO and PASO active bottlers --
Select b.*
From BC.BottlerSalesHier vs
Join BC.Bottler b on vs.RegionID = b.BCRegionID
Where vs.HierType = 'BC' and vs.SystemName in ('RS - Caso System', 'BS - Paso System', 'IS - Iso System')
And b.GlobalStatusID = 02
Order By HierType, TotalCompanyName, CountryName, SystemName, ZoneName, DivisionName, RegionName
Go

Select *
From ETL.BCDataLoadingLog



/* Useful for doing sanity check
Select Distinct h.TCOMP_ID, h.TCOMP_DESC, h.CCNTRY_ID, h.CCNTRY_DESC, h.SYSTEM_ID, h.SYSTEM_DESC, 
		h.ZONE_ID, h.ZONE_DESC,
		h.DIVISION_ID, h.DIVISION_DESC, h.REGION_ID, h.REGION_DESC
From Staging.BCBottlerSalesHierachy h
*/
