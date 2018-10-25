USE [Portal_Data]
GO

If Exists (Select * From sys.objects Where object_id = object_id('[Settings].[pGetUserRightsByGSN]'))
Begin
	DROP PROCEDURE [Settings].[pGetUserRightsByGSN]
End
GO

SET QUOTED_IDENTIFIER ON
GO
/* Test Bench
exec Settings.pGetUserRightsByGSN 'KAVSX001'
*/

Create Proc Settings.pGetUserRightsByGSN
(
	@GSN varchar(25)
)
As
Begin
	Set NoCount On;

	Declare @UserRoles Table
	(
		PortalRoleID int
	)
-- Load the all the roles for the user to the temp table
	Insert Into @UserRoles
		SELECT  PR.PortalRoleID
		FROM  Settings.UserInRole as UIR INNER JOIN
                      Settings.PortalRole as PR ON UIR.PortalRoleID = PR.PortalRoleID
                   Where UIR.GSN = @GSN And PR.PortalRoleID Not in (Select PortalRoleID from Settings.UserNotInRole as UNIR where UNIR.GSN = @GSN)
				   And PR.Active = 1
				   Order by UIR.Precedence;

--Then use the Role Temp table to find the Rights
Declare @UserRoleRights Table
	(
		PortalRoleID int,
		RightID int,
		IsParent Bit
	)
	Insert into @UserRoleRights
		Select RR.PortalRoleID, RR.RightID, 1 
			from Settings.RoleRight as RR 
			Join Settings.ApplicationRight ar on rr.RightID = ar.RightID
			Join Shared.Application a on ar.ApplicationID = a.ApplicationID
			where RR.PortalRoleID in (Select PortalRoleID from @UserRoles)
			And a.Active = 1

	Insert into @UserRoleRights
		Select udfGR.* from @UserRoleRights as URR
			cross Apply [Settings].[udfGetRightsBYParentID](Urr.PortalRoleID, URR.RightID) as udfGR
		Where Isnull(URR.IsParent,0) = 1



Select Distinct  app.ApplicationName, URR.PortalRoleID, AR.RightName, Ar.RightID, Ar.InvariantName, Ar.Description, Ar.LastModified, Ar.LastModifiedBy
					,(Select RoleName from Settings.PortalRole pr where pr.PortalRoleID = urr.PortalRoleID) as RoleName
		from  @UserRoleRights URR Left Outer Join ApplicationRight AR on URR.RightID = AR.RightID 
				Inner Join Shared.Application app on Ar.ApplicationID = app.ApplicationID


		

End
Go


  
 