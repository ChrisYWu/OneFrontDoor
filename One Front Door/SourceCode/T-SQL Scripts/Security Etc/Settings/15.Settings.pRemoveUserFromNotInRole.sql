USE [Portal_Data]
GO
If Exists (Select * From sys.objects Where object_id = object_id('[Settings].[pRemoveUserFromNotInRole]'))
Begin
	DROP PROCEDURE [Settings].[pRemoveUserFromNotInRole]
End
GO
/****** Object:  StoredProcedure [Settings].[pRemoveUserFromNotInRole]    Script Date: 12/17/2013 1:22:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Test Bench
exec Settings.pRemoveUserFromNotInRole @GSN = 'WUXYX001', @PortalRoleID = 3, @CreatedBy='WUXYX001'

*/

Create Proc [Settings].[pRemoveUserFromNotInRole]
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

	--- Check whether user should be a part of the Jobcode, If user belongs to that job code, then just uncheck the By Exception flag.
	if exists(select GSN from Person.UserProfile where GSN = @GSN and (JobCode in (Select JobCode from JobcodeInRole where PortalRoleID = @PortalRoleID)) )
		Begin
			Declare @Precedence int
			Set @Precedence = 0
			Select @Precedence = Precedence
				From Settings.UserInRole
				Where GSN = @GSN
				--If user not exists in UserInRoleID then Add user to the role, If exists then update the exception flag
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
				   ,0
				   ,@Precedence + 1
				   ,@CreatedBy
				   ,@CreatedBy);
					Set @Retval = 1
				End
			Else
				Begin
					Update Settings.UserInRole
					set AssignedByException = 0
					where GSN = @gsn and PortalRoleID = @PortalRoleID
					Set @Retval = 1
				End
		End
			Delete Settings.UserNotInRole
			Where GSN = @GSN And PortalRoleID = @PortalRoleID
			Set @Retval = 1
Return @Retval

End
