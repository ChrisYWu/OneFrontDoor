USE [Portal_Data]
GO

/****** Object:  StoredProcedure [dbo].[pdGetSPUserProfileBMs]    Script Date: 3/21/2013 6:03:01 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/* Users who are BMs in User Profile but not in AD */
CREATE procedure [dbo].[pdGetSPUserProfileBMs]
as
select a.UserID as GSN,e.BranchName as PrimaryBranch, a.Title as PrimaryRole,
f.AreaName as PrimaryArea, g.BUName as PrimaryBU
from HRStaging.ADExtractData a
left outer join Person.UserInRole b on a.userID=b.gsn 
left outer join SAP.CostCenter c on a.CostCenter= c.CostCenterName
left outer join SAP.ProfitCenter d on c.ProfitCenterID=d.ProfitCenterID
left outer join SAP.Branch e on d.BranchID=e.BranchID
left outer join SAP.BusinessArea f on e.AreaID=f.AreaID
left outer join SAP.BusinessUnit g on f.BUID= g.BUID

where (b.RoleID in (select RoleID from Person.Role where RoleName like '%Branch%') and 
a.title NOT LIKE '%Branch%' and (a.status=3 OR a.status=1))

GO


