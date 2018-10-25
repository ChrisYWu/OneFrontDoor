USE [Portal_Data]
GO

If Exists (Select * From sys.objects Where object_id = object_id('[Settings].[pAddUserToNotInRole]'))
Begin
	DROP PROCEDURE [Settings].[pAddUserToNotInRole]
End
GO

SET QUOTED_IDENTIFIER ON
GO
/* Test Bench
exec Settings.[pAddUserToNotInRole @GSN = 'WUXYX001', @PortalRoleID = 3, @CreatedBy='WUXYX001'

*/

Create Proc Settings.pAddUserToNotInRole
(
	@GSN varchar(50),
	@PortalRoleID int,
	@CreatedBy varchar(50)
	
)
As
Begin
	Set NoCount On;
	--Assumes both PortalRoleID and GSN are valid, since they are passed from code that has validations set

	
	Declare @Retval int
	Set @Retval = 0

	--Delete from UserInRole
	Delete from UserInRole 
		Where PortalRoleID = @PortalRoleID and GSN = @GSN

	If Not Exists (Select [UserNotInRoleID] From Settings.UserNotInRole
					Where GSN = @GSN And PortalRoleID = @PortalRoleID)
	Begin
		INSERT INTO [Settings].[UserNotInRole]
				   ([PortalRoleID]
				   ,[GSN]
				   ,[CreatedBy]
				   )
			 VALUES
				   (@PortalRoleID
				   ,@GSN
				   ,@CreatedBy
				   );
		Set @Retval = 1
	End
	Else
		Set @Retval = 0

	Return @Retval

End
Go



