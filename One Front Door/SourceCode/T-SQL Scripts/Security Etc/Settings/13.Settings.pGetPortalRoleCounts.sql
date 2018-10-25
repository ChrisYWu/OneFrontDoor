USE [Portal_Data]
GO

If Exists (Select * From sys.objects Where object_id = object_id('[Settings].[pGetPortalRoles]'))
Begin
	DROP PROCEDURE [Settings].[pGetPortalRoles]
End
GO

SET QUOTED_IDENTIFIER ON
GO
/* Test Bench
exec Settings.pGetPortalRoles @GSN = 'WUXYX001'

*/

Create Proc Settings.pGetPortalRoleCounts
As
Begin
	Set NoCount On;

	Declare @output Table
	(
		PortalRoleID int,
		NumberOfJobCodes int,
		NumberOfUsers int
	)

	Insert Into @output(PortalRoleID, NumberOfJobCodes)
	SELECT [PortalRoleID], Count(*) NumberOfJobCodes
	FROM Settings.JobcodeInRole jir
	Group By [PortalRoleID]

	Merge @output o
	Using (
		SELECT [PortalRoleID], Count(*) NumberOfUsers
		FROM Settings.UserInRole uir
		Group By [PortalRoleID]) input
		On o.PortalRoleID = input.PortalRoleID
	WHEN MATCHED THEN 
		UPDATE SET NumberOfUsers = input.NumberOfUsers
	WHEN NOT MATCHED By Target THEN
		INSERT (PortalRoleID, NumberOfUsers)
		 VALUES
			   (input.PortalRoleID, input.NumberOfUsers);

	Update @output
	Set NumberOfJobCodes = 0
	Where NumberOfJobCodes is null

	Update @output
	Set NumberOfUsers = 0
	Where NumberOfUsers is null

	Select * From @output

End
Go



