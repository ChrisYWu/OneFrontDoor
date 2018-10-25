USE [Portal_Data]
GO

/****** Object:  View [MView].[PersonalRoleLocation]    Script Date: 03/05/2013 11:12:13 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[MView].[PersonalRoleLocation]'))
DROP VIEW [MView].[PersonalRoleLocation]
GO

USE [Portal_Data]
GO

/****** Object:  View [MView].[PersonalRoleLocation]    Script Date: 03/05/2013 11:12:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create View [MView].[PersonalRoleLocation] 
As
Select  up.GSN, up.FirstName, up.LastName, r.RoleName, lh.*
From Person.UserInRole ur 
	Join Person.UserProfiles up on ur.GSN = up.GSN
	Join Person.Role r on ur.RoleID = r.RoleID
	Join SAP.CostCenter c on up.CostCenterID = c.CostCenterID
	Join SAP.ProfitCenter p on p.ProfitCenterID = c.ProfitCenterID
	Join SAP.Branch b on b.BranchID = p.BranchID
	Join MView.LocationHier lh on b.BranchID = lh.BranchID

GO

Select *
From MView.PersonalRoleLocation
Where RoleName like '%Branch Manager%'
Go

-------------------------------------------------------------
Select count(*)
From SAP.Account a
Join [Portal_Report].[dbo].[TS_LOCATION$] t on a.SAPAccountNumber = t.ID
where a.active=1


Select count(*)
From SAP.Account a
Left Join (Select Distinct ID, LONGITUDE, LATITUDE From [Portal_Report].[dbo].[TS_LOCATION$]) t on a.SAPAccountNumber = t.ID
Where t.ID is not null

Select *
From SAP.Account a 
Left Join [Portal_Report].[dbo].[TS_LOCATION$] t on a.SAPAccountNumber = t.Region_ID
Where t.Region_ID is not null

select * from 
SAP.Account Where SAPAccountNumber in (

Select ID, Count(ID)
From [Portal_Report].[dbo].[TS_LOCATION$]
Group By ID
Having Count(Region_ID) > 1
)
Go

Select *
From [Portal_Report].[dbo].[TS_LOCATION$]
Where ID = 11387310

---------------------------------------
USE [Portal_Data]
GO

Select Distinct NationalChainName
From MView.LocationChain
Where BranchId = 120
Order By NationalChainName

