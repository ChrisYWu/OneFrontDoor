use Portal_Data
Go

Select Distinct SystemName, ZoneName, DivisionName, RegionName, SAPAccountNumber, AccountName
From BC.BottlerAccountTradeMark bat
Join SAP.Account a on bat.AccountID = a.AccountID
Join BC.Bottler b on b.BottlerID = bat.BottlerID
Join BC.Region r on b.BCRegionID = r.RegionID
Join BC.Division d on d.DivisionID = r.DivisionID
Join BC.Zone z on z.ZoneID = d.ZoneID
Join BC.System s on s.SystemID = z.SystemID
Where TerritoryTypeID in (11, 12)
And ProductTypeID = 1
And a.ChannelID in (806, 807, 808, 809, 810, 811)
And a.Format in ('SF', 'LF')
And s.SystemID in (5,6,7)
And CRMActive = 1
Order By SystemName, ZoneName, DivisionName, RegionName, SAPAccountNumber, AccountName


Select SystemName, ZoneName, DivisionName, RegionName, Count(SAPAccountNumber) AccountCount
From (
	Select Distinct SystemName, ZoneName, DivisionName, RegionName, SAPAccountNumber, AccountName
	From BC.BottlerAccountTradeMark bat
	Join SAP.Account a on bat.AccountID = a.AccountID
	Join BC.Bottler b on b.BottlerID = bat.BottlerID
	Join BC.Region r on b.BCRegionID = r.RegionID
	Join BC.Division d on d.DivisionID = r.DivisionID
	Join BC.Zone z on z.ZoneID = d.ZoneID
	Join BC.System s on s.SystemID = z.SystemID
	Where TerritoryTypeID in (11, 12)
	And ProductTypeID = 1
	And a.ChannelID in (806, 807, 808, 809, 810, 811)
	And a.Format in ('SF', 'LF')
	And s.SystemID in (5,6,7)
	And CRMActive = 1
) temp
Group By SystemName, ZoneName, DivisionName, RegionName
Order By SystemName, ZoneName, DivisionName, RegionName


--Select *
--From BC.System





