USE [Portal_Data]
GO

If Exists (Select * From sys.objects Where object_id = object_id('[Settings].[pGetOrgUnitsByRoleID]'))
Begin
	DROP PROCEDURE [Settings].[pGetOrgUnitsByRoleID]
End
GO

SET QUOTED_IDENTIFIER ON
GO
/* Test Bench
exec Settings.pGetOrgUnitsByRoleID @GSN = 'WUXYX001', @PortalRoleID = 3, @CreatedBy='WUXYX001'

*/

Create Proc Settings.pGetOrgUnitsByRoleID
(
	@PortalRoleID int
)
As
Begin
	Set NoCount On;
	--Assumes both PortalRoleID and GSN are valid, since they are passed from code that has validations set
	Select ou.OrgUnitID, ou.OrgUnitName
	From Shared.OrganizationUnit ou
	Join Settings.PortalRoleOrgUnit p on ou.OrgUnitID = p.OrgUnitID
	Where PortalRoleID = @PortalRoleID

End
Go



