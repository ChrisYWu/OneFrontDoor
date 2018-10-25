use Portal_Data204
Go

SElect *
From SupplyChain.tLineDailyKPI

use Portal_Data
Go

Select *
From SAP.Branch
Where BranchName = 'Chico'

Select *
From SAP.Branch b
Join SAP.Area a on b.AreaID = a.AreaID
Join SAP.Region r on a.RegionID = r.RegionID
Join SAP.BusinessUnit bu on r.BUID = bu.BUID
Where AreaName = 'Nw North'

Select up.GSN, up.Title, FirstName, LastName, Branch, sp.PrimaryBranch, sp.PrimaryBranchID
From Person.SPUserProfile sp
JOin Person.UserProfile up on sp.GSN = up.GSN
Where sp.PrimaryBranchID = 131

