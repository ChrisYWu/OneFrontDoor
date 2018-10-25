Use Portal_DataSRE
Go

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Declare @BranchName Varchar(50)
--Set @BranchName = 'Irving'
--Set @BranchName = 'Denver'
--Set @BranchName = 'Northlake'
--Set @BranchName = 'San Leandro'

Select Distinct m.BUName, m.PBRegionName, m.AreaName, m.BranchName, m.BCRegionName, m.BCRegionID, m.BCDivisionName, m.BCZoneName, m.BCSystemName
From BC.PBBCMapping m
Where BranchName = @BranchName
And m.BCSystemName in ('BS - Paso System', 'RS - Caso System', 'IS - Iso System') 





--Select BranchName
--From SAP.Branch
--Order By BranchName














--- DSD Location is messy --
--Select Distinct m.BranchName, m.AreaName, m.PBRegionName, m.BUName, up.GSN DSD_GSN, up.FirstName DSDFirstName, up.LastName DSDLastName, up.Title DSDTitle,
--	m.BCRegionName, m.BCDivisionName, m.BCZoneName, m.BCSystemName,
--	bcup.GSN BCGSN, bcup.FirstName BCFirstName, bcup.LastName BCLastName, bcup.Title BCTitle
--From BC.PBBCMapping m
--Join BC.GSNRegion g on m.BCRegionID = g.RegionID
--Join Person.UserProfile bcup on g.GSN = bcup.GSN
--Join Person.UserLocation ul on m.BranchID = ul.BranchID
--Join Person.UserProfile up on ul.GSN = up.GSN
--Where BranchName = 'Northlake'


