USE [Portal_Data]
GO

/****** Object:  StoredProcedure [dbo].[pdGetUserProfile]    Script Date: 3/21/2013 6:06:04 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[pdGetUserProfile] @UserID varchar(50)=NULL
as
select a.UserID, f.BUID, f.AreaID, e.BranchID,
d.ProfitCenterID, c.CostCenterID,a.FirstName,a.LastName,a.EmpID 
from HRStaging.ADExtractData a
left outer join Person.UserInRole b on a.userID=b.gsn 
left outer join SAP.CostCenter c on a.CostCenter= c.CostCenterName
left outer join SAP.ProfitCenter d on c.ProfitCenterID=d.ProfitCenterID
left outer join SAP.Branch e on d.BranchID=e.BranchID
left outer join SAP.BusinessArea f on e.AreaID=f.AreaID 

where isnull(b.gsn,'')='' and a.title like '%Branch%' and (a.status=3 or a.status=1)

GO


