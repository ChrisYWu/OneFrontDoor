USE [Portal_Data]
GO

If Exists (Select * From sys.objects Where object_id = object_id('[Settings].[pGetUserRolesByGSN]'))
Begin
	DROP PROCEDURE [Settings].[pGetUserRolesByGSN]
End
GO

SET QUOTED_IDENTIFIER ON
GO
/* Test Bench
exec Settings.pGetUserRolesByGSN 'KAVSX001'

	

*/

Create Proc Settings.pGetUserRolesByGSN
(
	@GSN varchar(25)
)
As
Begin
	Set NoCount On;

	Declare @UserJobCode as varchar(50)
	Select @UserJobCode= JobCode from Person.UserProfile where GSN = @GSN

--- This will return the Role for a USer

SELECT     UIR.AssignedByException, PR.RoleName, PR.InvariantName, PR.PortalRoleID, PR.ShortName, UIR.Precedence,
			Case when Isnull(UIR.AssignedByException ,0) = 1 Then 
						PR.RoleName + (' (through direct assignment)')
					Else
						PR.RoleName + (' (through HR Job Code ' + @UserJobCode + ')')
					End as RoleNameWithException,
					ROW_NUMBER() OVER(ORDER BY UIR.Precedence) AS CalculatedPrecedence

		FROM  Settings.UserInRole as UIR INNER JOIN
                      Settings.PortalRole as PR ON UIR.PortalRoleID = PR.PortalRoleID
                   Where UIR.GSN = @GSN And PR.PortalRoleID Not in (Select PortalRoleID from Settings.UserNotInRole as UNIR where UNIR.GSN = @GSN)
				   And PR.Active = 1
				   Order by UIR.Precedence;


End
Go
   
