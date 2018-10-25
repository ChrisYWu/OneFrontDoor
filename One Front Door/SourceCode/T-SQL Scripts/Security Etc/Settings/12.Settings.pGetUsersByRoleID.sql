USE [Portal_Data]
GO

If Exists (Select * From sys.objects Where object_id = object_id('[Settings].[pGetUsersByRoleID]'))
Begin
	DROP PROCEDURE [Settings].[pGetUsersByRoleID]
End
GO

SET QUOTED_IDENTIFIER ON
GO
/* Test Bench
exec Settings.pGetUsersByRoleID @PortalRoleID = 3

*/

Create Proc Settings.pGetUsersByRoleID
(
	@PortalRoleID int,
	@UserType int
)
As
Begin
	Set NoCount On;
	if(@UserType = 0)
	Begin
		Select up.FirstName + ' ' +  up.LastName as UserName, up.GSN, Title, up.JobCode
		From Settings.UserInRole uir
		Join Person.UserProfile up on uir.GSN = up.GSN
		Where PortalRoleID = @PortalRoleID And up.GSN not in (Select UNIR.GSN from UserNotInRole UNIR where UNIR.PortalRoleID = @PortalRoleID) 
	End
	Else If(@UserType = 1)
		Begin
			Select up.FirstName + ' ' +  up.LastName as UserName, up.GSN, Title, up.JobCode
			From Settings.UserInRole uir
			Join Person.UserProfile up on uir.GSN = up.GSN
			Where PortalRoleID = @PortalRoleID
			And AssignedByException = 1
		End
	Else If(@UserType = 2)
		Begin
			Select up.FirstName + ' ' +  up.LastName as UserName, up.GSN, Title, up.JobCode
			From Settings.UserNotInRole uir
			Join Person.UserProfile up on uir.GSN = up.GSN
			Where PortalRoleID = @PortalRoleID
		End
End
Go



