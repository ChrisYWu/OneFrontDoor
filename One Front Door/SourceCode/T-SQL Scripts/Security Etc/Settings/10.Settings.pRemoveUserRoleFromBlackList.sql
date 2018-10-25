USE [Portal_Data]
GO

If Exists (Select * From sys.objects Where object_id = object_id('[Settings].[pRemoveUserRoleFromBlackList]'))
Begin
	DROP PROCEDURE [Settings].[pRemoveUserRoleFromBlackList]
End
GO

SET QUOTED_IDENTIFIER ON
GO
/* Test Bench
exec Settings.pRemoveUserRoleFromBlackList @GSN = 'WUXYX001', @PortalRoleID = 3, @CreatedBy='WUXYX001'

*/

Create Proc Settings.pRemoveUserRoleFromBlackList
(
	@GSN varchar(50),
	@PortalRoleID int,
	@CreatedBy varchar(50)
)
As
Begin
	Set NoCount On;
	--Assumes both PortalRoleID and GSN are valid, since they are passed from code that has validations set

	Delete Settings.UserNotInRole
	Where GSN = @GSN And PortalRoleID = @PortalRoleID

	If Exists (Select jir.JobCodeInRoleID
			From Staging.ADExtractData ad
			Join Settings.JobcodeInRole jir on ad.JobCode = jir.JobCode
			Where PortalRoleID = @PortalRoleID
			And ad.UserID = @GSN)
	Begin
		exec Settings.pAddUserToRole @GSN, @PortalRoleID, @CreatedBy, @ByException = 0
	End

End
Go



