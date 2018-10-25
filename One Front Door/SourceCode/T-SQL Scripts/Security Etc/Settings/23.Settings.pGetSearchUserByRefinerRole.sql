USE [Portal_Data]
GO
/****** Object:  StoredProcedure [Settings].[pGetSearchUserByRefinerRole]   Script Date: 2/12/2014 10:22:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create Proc [Settings].[pGetSearchUserByRefinerRole]
(
@PortalRoleID int,
@SearchKeyword varchar(10)
)
As
Begin
	Set NoCount On;

	SELECT      up.* 
FROM            Person.UserProfile as up INNER JOIN
                         Settings.UserInRole as UIR ON UP.GSN = uir.GSN
						 Where uir.PortalRoleID = @PortalRoleID 
						 And (up.FirstName like '%' + @SearchKeyword + '%'  Or up.LastName like '%' + @SearchKeyword + '%'   
								Or up.JobCode like '%' + @SearchKeyword + '%'  Or  up.Title like '%' + @SearchKeyword + '%'   
								Or up.gsn like '%' + @SearchKeyword + '%'   Or (up.FirstName + ' ' + up.LastName) like '%' + @SearchKeyword + '%'  
								Or (up.LastName + ', ' + up.FirstName) like '%' + @SearchKeyword + '%')
						 And up.GSN not in (Select unir.GSN from Settings.UserNotInRole as unir where unir.PortalRoleID = @PortalRoleID)

End
