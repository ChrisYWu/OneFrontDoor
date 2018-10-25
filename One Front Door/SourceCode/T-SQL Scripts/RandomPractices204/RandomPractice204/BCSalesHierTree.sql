use Portal_Data204
Go

Select *
From BC.vSalesHierarchy
Where SystemID in (5, 6, 7)
Go

Select * From sys.views Where object_id = object_id('MView.BCSalesHierTree')

Drop View MView.BCSalesHierTree
Go

Create View MView.BCSalesHierNode
As
Select 10000000 + SystemID NodeID, SystemName NodeName, null ParentID
From BC.System
Where SystemID in (5, 6, 7)
Union
Select 20000000 + ZoneID, ZoneName, 10000000 + SystemID ParentID
From BC.Zone
Where SystemID in (5, 6, 7)
Union
Select 30000000 + DivisionID, DivisionName, 20000000 + d.ZoneID ParentID
From BC.Division d Join BC.Zone z on d.ZoneID = z.ZoneID 
Where SystemID in (5, 6, 7)
Union
Select 40000000 + RegionID, RegionName, 30000000 + r.DivisionID ParentID
From BC.Region r 
	Join BC.Division d on r.DivisionID = d.DivisionID
	Join BC.Zone z on d.ZoneID = z.ZoneID
Where SystemID in (5, 6, 7)
Go
