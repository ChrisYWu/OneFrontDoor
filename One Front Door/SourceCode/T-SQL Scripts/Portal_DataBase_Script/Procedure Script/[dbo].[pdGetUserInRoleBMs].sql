USE [Portal_Data]
GO

/****** Object:  StoredProcedure [dbo].[pdGetUserInRoleBMs]    Script Date: 3/21/2013 6:05:24 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/* Users who are BMs in UserProfile Table but not in AD*/
CREATE procedure [dbo].[pdGetUserInRoleBMs]
as
select a.GSN, b.Title, a.RoleID from Person.UserInRole a
left outer join HRStaging.ADExtractData b on a.gsn=b.userid
where (a.RoleID in (select RoleID from Person.Role where RoleName like '%Branch%') and 
b.title NOT LIKE '%Branch%' and (b.status=3 OR b.status=1))

GO


