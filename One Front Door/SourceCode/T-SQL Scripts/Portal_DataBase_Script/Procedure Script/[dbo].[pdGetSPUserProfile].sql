USE [Portal_Data]
GO

/****** Object:  StoredProcedure [dbo].[pdGetSPUserProfile]    Script Date: 3/21/2013 6:02:10 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[pdGetSPUserProfile] --@UserID varchar(50)= NULL, @Title varchar(250)= NULL
as
select a.UserID as GSN, e.BranchName as PrimaryBranch, a.Title as PrimaryRole,
 f.AreaName as PrimaryArea, g.BUName as PrimaryBU
from HRStaging.ADExtractData a
left outer join Person.UserInRole b on a.userID=b.gsn 
join SAP.CostCenter c on a.CostCenter= c.CostCenterName
join SAP.ProfitCenter d on c.ProfitCenterID=d.ProfitCenterID
join SAP.Branch e on d.BranchID=e.BranchID
join SAP.BusinessArea f on e.AreaID=f.AreaID
join SAP.BusinessUnit g on f.BUID= g.BUID
where isnull(b.gsn,'')='' and a.title like '%Branch%' and (a.status=3 or a.status=1)

GO


