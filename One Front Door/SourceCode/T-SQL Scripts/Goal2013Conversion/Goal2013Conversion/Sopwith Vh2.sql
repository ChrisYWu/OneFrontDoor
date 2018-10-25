Use Portal_DataVH2
Go

Select GeoSource, AccountName, SAPAccountNumber, AccountID, Latitude, Longitude, Address, City, State, PostalCode
From SAP.Account
Where AccountName in ('Speedy Stop 000118', 'Walmart Sc 005189', 'Fry''s Food 000610')

Select r.RegionID, r.BCNodeID, r.RegionName, s.GSN, s.IsPrimary, up.FirstName, up.LastName
From BC.Region r
Join Person.BCSalesAccountability s on r.RegionID = s.RegionID
Join Person.UserProfile up on s.GSN = up.GSN
Where r.RegionID in 
(
	Select BCRegionID
	From BC.Bottler
	Where BottlerID in 
	(
		Select Distinct BottlerID
		From BC.BottlerAccountTradeMark
		Where AccountID in (1018275, 979680)
		--Where AccountID in (1018275)
		--Where AccountID in (979680)
		And ProductTypeID = 1 And TerritoryTypeID in (11, 12)
	)
)
