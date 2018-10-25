use Portal_Data805
Go

Select up.LastName + ', ' + up.FirstName Name, up.Title, pr.GSN, NumberOfRegion, NumberOfBottler
From BCMyDay.PromotionRequestLog pr
Join Person.UserProfile up on pr.GSN = up.GSN
Where pr.GSN in 
(
	Select Distinct GSN
	From BC.tGSNRegion t
	Join BC.vSalesHierarchy r on t.RegionID = r.RegionID
	Where r.SystemID in (5,6,7)
)
And LogID < 204
Order By NumberOfBottler

Select up.LastName + ', ' + up.FirstName Name, up.Title, pr.*
From BCMyDay.PromotionRequestLog pr
Join Person.UserProfile up on pr.GSN = up.GSN
Where pr.GSN in 
(
	Select Distinct GSN
	From BC.tGSNRegion t
	Join BC.vSalesHierarchy r on t.RegionID = r.RegionID
	Where r.SystemID in (5,6,7)
)
And LogID < 204
Order By NumberOfBottler

