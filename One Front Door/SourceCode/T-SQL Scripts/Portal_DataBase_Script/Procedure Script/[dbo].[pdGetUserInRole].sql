USE [Portal_Data]
GO

/****** Object:  StoredProcedure [dbo].[pdGetUserInRole]    Script Date: 3/21/2013 6:04:42 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/* Users who are BMs in AD but not in UserProfile table */
CREATE procedure [dbo].[pdGetUserInRole] 
as
select a.UserID, c.gsn, a.Title, b.RoleID
from HRStaging.ADExtractData a
left outer join Person.UserInRole c on a.userID=c.gsn 
left outer join Person.Role b on a.Title like '%'+ b.RoleName+'%'
where isnull(c.gsn,'')='' and a.title like '%Branch%' and (a.status='3' or a.status='1')

GO


