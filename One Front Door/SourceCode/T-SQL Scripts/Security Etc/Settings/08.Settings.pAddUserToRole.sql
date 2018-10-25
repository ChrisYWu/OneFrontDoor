USE [Portal_Data]
GO

If Exists (Select * From sys.objects Where object_id = object_id('[Settings].[pAddUserToRole]'))
Begin
	DROP PROCEDURE [Settings].[pAddUserToRole]
End
GO

SET QUOTED_IDENTIFIER ON
GO
/* Test Bench
exec Settings.pAddUserToRole @GSN = 'WUXYX001', @PortalRoleID = 3, @CreatedBy='WUXYX001'

*/

Create Proc Settings.pAddUserToRole
(
	@GSN varchar(50),
	@PortalRoleID int,
	@CreatedBy varchar(50),
	@ByException bit = 1
)
As
Begin
	Set NoCount On;
	--Assumes both PortalRoleID and GSN are valid, since they are passed from code that has validations set

	Declare @Precedence int
	Declare @Retval int
	Set @Precedence = 0
	Set @Retval = 0

	Select @Precedence = Max(Precedence)
	From Settings.UserInRole
	where GSN = @GSN
	Group BY GSN
	

	If Not Exists (Select UserInRoleID From Settings.UserInRole
					Where GSN = @GSN And PortalRoleID = @PortalRoleID)
	Begin
		INSERT INTO [Settings].[UserInRole]
				   ([PortalRoleID]
				   ,[GSN]
				   ,[AssignedByException]
				   ,[Precedence]
				   ,[CreatedBy]
				   ,[LastMofieidBy])
			 VALUES
				   (@PortalRoleID
				   ,@GSN
				   ,@ByException
				   ,@Precedence + 1
				   ,@CreatedBy
				   ,@CreatedBy);
		Set @Retval = 1
	End
	Else
		Begin
				Update Settings.UserInRole
					set AssignedByException = 1
					where GSN = @gsn and PortalRoleID = @PortalRoleID
					Set @Retval = 1
		End
	
		

	Return @Retval

End
Go



