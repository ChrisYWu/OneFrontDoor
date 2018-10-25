USE [Portal_Data]
GO

/****** Object:  View [MView].[PersonalRoleLocation]    Script Date: 3/21/2013 5:24:14 AM ******/
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


