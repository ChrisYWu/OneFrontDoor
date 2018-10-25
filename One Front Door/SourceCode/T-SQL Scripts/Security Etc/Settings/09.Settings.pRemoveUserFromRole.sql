USE [Portal_Data]
GO

If Exists (Select * From sys.objects Where object_id = object_id('[Settings].[pRemoveUserFromRole]'))
Begin
	DROP PROCEDURE [Settings].[pRemoveUserFromRole]
End
GO

SET QUOTED_IDENTIFIER ON
GO
/* Test Bench
exec Settings.pRemoveUserFromRole @GSN = 'ABSPX001', @PortalRoleID = 2037, @CreatedBy='WUXYX001',@BlackList =0

*/

Create Proc Settings.pRemoveUserFromRole
(
	@GSN varchar(50),
	@PortalRoleID int,
	@CreatedBy varchar(50),
	@BlackList bit
)
As
Begin
	Set NoCount On;
	--Assumes both PortalRoleID and GSN are valid, since they are passed from code that has validations set

	--- Check whether user should be a part of the Jobcode, If user belongs to that job code, then just uncheck the By Exception flag.
	--Declare @JobcodeTable Table
	--(
	--	Jobcode int not null
	--)

	--Insert Into @JobcodeTable
	--Select Value
	--From dbo.Split((select JobCodes from Settings.PortalRole), ';')
	if exists(select GSN from Person.UserProfile where GSN = @GSN and (JobCode in (Select JobCode from JobcodeInRole where PortalRoleID = @PortalRoleID)) )
		Begin
			Update Settings.UserInRole
				set AssignedByException = 0
				where GSN = @gsn and PortalRoleID = @PortalRoleID

		End
		Else
		Begin
			Delete Settings.UserInRole
			Where GSN = @GSN And PortalRoleID = @PortalRoleID
		
		End
	If (@BlackList = 0)
	Begin
		INSERT INTO [Settings].[UserNotInRole]
				   ([PortalRoleID]
				   ,[GSN]
				   ,[CreatedBy])
			 VALUES
				   (@PortalRoleID
				   ,@GSN
				   ,@CreatedBy)
	End

End
Go



--select * from [Settings].[UserInRole] where GSN = 'ABSPX001' and PortalRoleID = 2037