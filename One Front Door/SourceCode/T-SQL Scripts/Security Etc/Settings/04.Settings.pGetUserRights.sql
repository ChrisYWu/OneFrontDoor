USE [Portal_Data]
GO

If Exists (Select * From sys.objects Where object_id = object_id('[Settings].[pGetUserRights]'))
Begin
	DROP PROCEDURE [Settings].[pGetUserRights]
End
GO

SET QUOTED_IDENTIFIER ON
GO
/* Test Bench
exec Settings.pGetUserRights @GSN = 'WUXYX001'

*/

Create Proc Settings.pGetUserRights
(
	@GSN varchar(50)
)
As
Begin
	Set NoCount On;

	Select Distinct a.ApplicationID, a.ApplicationName, ar.RightID, ar.RightName
	From Settings.UserInRole uir
		Join Settings.RoleRight rr on uir.PortalRoleID = rr.PortalRoleID
		Join Settings.ApplicationRight ar on rr.RightID = ar.RightID
		Join Shared.Application a on ar.ApplicationID = a.ApplicationID
	Where uir.GSN = @GSN

End
Go



