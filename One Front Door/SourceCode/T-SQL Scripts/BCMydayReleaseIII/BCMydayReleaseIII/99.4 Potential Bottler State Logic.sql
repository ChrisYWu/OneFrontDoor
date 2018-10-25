use Portal_Data204
Go

Select *
From BCMyday.ManagementPriority
Where ManagementPriorityID = 1
Go

Select Distinct RegionID
From Shared.StateBottler sb
Join BC.Bottler b on sb.BottlerID = b.BottlerID
Join BC.vSalesHierarchy v on v.RegionID = b.BCRegionID
Where StateRegionID = 26 -- Param
And BCRegionID is not null
And (
v.SystemID = 5 --- Param
Or v.ZoneID = 32 -- Param
Or v.RegionID = 32 -- Param
Or v.DivisionID = 32 -- Param
Or b.BottlerID = 88 -- Param
)


