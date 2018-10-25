use Portal_Data
Go

If Exists (Select * From sys.objects Where object_id = object_id('[Settings].[vUserRole]') And Type = 'V')
Begin
	DROP View [Settings].vUserRole
End
GO

SET QUOTED_IDENTIFIER ON
GO
/*

Select *
From Settings.vUserRole
Where GSN = 'WUXYX001'
*/

Create View Settings.vUserRole
As
SELECT [UserInRoleID]
      ,ur.[GSN]
	  ,up.FirstName
	  ,up.LastName
      ,ur.[PortalRoleID]
      ,pr.RoleName
	  ,ur.Precedence
  FROM [Settings].[UserInRole] ur
  Join Settings.PortalRole pr on ur.PortalRoleID = pr.PortalRoleID
  Join Person.UserProfile up on ur.GSN = up.GSN
  Where pr.Active = 1
Go

