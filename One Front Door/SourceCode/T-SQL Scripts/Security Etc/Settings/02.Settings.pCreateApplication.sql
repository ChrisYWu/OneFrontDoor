USE [Portal_Data]
GO

If Exists (Select * From sys.objects Where object_id = object_id('[Settings].[pCreateApplication]'))
Begin
	DROP PROCEDURE [Settings].[pCreateApplication]
End
GO

SET QUOTED_IDENTIFIER ON
GO
/* Test Bench
exec Settings.pCreateApplication @ApplicationName = 'Promotion Activities', @CreatedBy = 'WUXYX001'
select * 
From [Shared].[Application] a
Join [Settings].[ApplicationRight] ar on a.ApplicationID = ar.ApplicationID
Where applicationName = 'Promotion Activities'
Go

delete From [Shared].[Application] Where ApplicationName = 'Promotion Activities'
Go

exec Settings.pCreateApplication @ApplicationName = 'Promotion Activities', @CreatedBy = 'WUXYX001', @Description = 'test desc', @SiteURL = '~/SomeSite'
delete From [Shared].[Application] Where ApplicationName = 'Promotion Activities'
Go

exec Settings.pCreateApplication @ApplicationName = 'Test', @InvariantName = 'Test', @CreatedBy = 'WUXYX001', @Description = 'test desc', @SiteURL = '~/SomeSite'


*/

Create Proc Settings.pCreateApplication
(
	@ApplicationName varchar(50),
	@InvariantName varchar(50),
	@CreatedBy varchar(50),
	@Description varchar(500) = null,
	@SiteURL varchar(128) = null
)
As
Begin
	Set NoCount On
	INSERT INTO [Shared].[Application]
			   ([ApplicationName]
			   ,[InvariantName]
			   ,[Description]
			   ,[SiteURL]
			   ,[CreatedBy]
			   ,[LastModifiedBy]
			   ,Active)
		 VALUES
			   (@ApplicationName
			   ,@InvariantName
			   ,@Description 
			   ,@SiteURL
			   ,@CreatedBy
			   ,@CreatedBy
			   ,1)

	Declare @ApplicationID int
	SELECT @ApplicationID = SCOPE_IDENTITY()

	If (@ApplicationID is not null)
	Begin
		INSERT INTO [Settings].[ApplicationRight]
			   ([ApplicationID]
			   ,[RightName]
			   ,[InvariantName]
			   ,[Description]
			   ,[BuiltInRight]
			   ,[CreatedBy]
			   ,[LastModifiedBy])
		 VALUES
			   (@ApplicationID
			   ,'All Rights'
			   ,'All Rights'
			   ,'Created by System as a builtin right'
			   ,1
			   ,'System'
			   ,'System')
	End

	Select @ApplicationID ApplicationID

End

Go

