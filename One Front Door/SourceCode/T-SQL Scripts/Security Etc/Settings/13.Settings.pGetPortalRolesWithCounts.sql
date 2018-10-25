USE [Portal_Data]
GO

If Exists (Select * From sys.objects Where object_id = object_id('[Settings].[pGetPortalRolesWithCounts]'))
Begin
	DROP PROCEDURE [Settings].[pGetPortalRolesWithCounts]
End
GO

SET QUOTED_IDENTIFIER ON
GO
/* Test Bench
exec Settings.pGetPortalRolesWithCounts 


SElect *
From Settings.PortalRole

	SELECT *
	FROM Settings.JobcodeInRole jir
	Where PortalRoleID = 1

*/

Create Proc Settings.pGetPortalRolesWithCounts
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

	Select * from @output Where PortalRoleID = 2052
	Select *
	From Settings.JobcodeInRole
	Where PortalRoleID = 2052


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

	Merge @output o
	Using (
		SELECT [PortalRoleID]
		FROM Settings.PortalRole ) As input
		On o.PortalRoleID = input.PortalRoleID
	--WHEN MATCHED THEN 
		--UPDATE SET NumberOfJobCodes = 0,
		--			NumberOfUsers = 0
	WHEN NOT MATCHED By Target THEN
		INSERT (PortalRoleID, NumberOfUsers, NumberOfJobCodes)
		 VALUES
			   (input.PortalRoleID, 0, 0);

	Update @output
	Set NumberOfJobCodes = 0
	Where NumberOfJobCodes is null

	Update @output
	Set NumberOfUsers = 0
	Where NumberOfUsers is null

	--Select *
	--From @output

	Select pr.AllowUserException, pr.ByJobcode, pr.CreatedBy, pr.Description, pr.InvariantName, pr.IsBuiltInRole, pr.JobCodes, pr.LastModified, pr.LastModifiedBy, pr.PortalRoleID, pr.RoleName, pr.ShortName
			,o.NumberOfJobCodes, o.NumberOfUsers 
	From @output o
	Join Settings.PortalRole pr on o.PortalRoleID = pr.PortalRoleID
	Where pr.Active = 1

End
Go



