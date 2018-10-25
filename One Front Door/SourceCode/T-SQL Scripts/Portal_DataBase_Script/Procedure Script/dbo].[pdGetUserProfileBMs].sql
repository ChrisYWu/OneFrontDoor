USE [Portal_Data]
GO

/****** Object:  StoredProcedure [dbo].[pdGetUserProfileBMs]    Script Date: 3/21/2013 6:06:37 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/* Users who are BMs in User Profile but not in AD */
CREATE procedure [dbo].[pdGetUserProfileBMs]
as
select a.UserID as GSN,f.BUID , e.BranchID,f.AreaID, d.ProfitCenterID,
c.CostCenterID, a.FirstName,a.LastName, a.EmpID
from HRStaging.ADExtractData a
left outer join Person.UserInRole b on a.userID=b.gsn 
left outer join SAP.CostCenter c on a.CostCenter= c.CostCenterName
left outer join SAP.ProfitCenter d on c.ProfitCenterID=d.ProfitCenterID
left outer join SAP.Branch e on d.BranchID=e.BranchID
left outer join SAP.BusinessArea f on e.AreaID=f.AreaID 

where (b.RoleID in (select RoleID from Person.Role where RoleName like '%Branch%') and 
a.title NOT LIKE '%Branch%' and (a.status=3 OR a.status=1))

GO


