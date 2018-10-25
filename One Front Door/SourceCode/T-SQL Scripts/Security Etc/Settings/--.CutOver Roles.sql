use Portal_Data
Go

--Insert Settings.PortalRole(RoleName, InvariantName, ShortName, CreatedBy, LastModifiedBy)
--Select RoleShortName, RoleShortName, RoleShortName, 'WUXYX001', 'WUXYX001'
--From Person.Role
--Where RoleName not in ('SalesPerson', 'Checker', 'Driver')
--Go

--Update Settings.PortalRole
--Set InvariantName = 'Market Development Manager',
--RoleName = 'Market Development Manager'
--Where ShortName = 'MDM'

Declare @Text as Table
(
	SQL nvarchar(500)
)

Declare @PortalRoleID int;
Declare @SQL nvarchar(500);
Declare @SAPHRJobNumber varchar(500);

DECLARE jobcode_cursor1 CURSOR FOR 
Select Distinct PortalRoleID
From Person.Role r
Join Person.Job j on r.RoleID = j.RoleID
Join Settings.PortalRole pr on pr.ShortName = r.RoleShortName

OPEN jobcode_cursor1

FETCH NEXT FROM jobcode_cursor1
INTO @PortalRoleID

WHILE @@FETCH_STATUS = 0
BEGIN
	Set @SAPHRJobNumber = ''
	Select @SAPHRJobNumber = Case When @SAPHRJobNumber = '' Then '''' + SAPHRJobNumber Else @SAPHRJobNumber + ';' + SAPHRJobNumber End
	From Person.Role r
	Join Person.Job j on r.RoleID = j.RoleID
	Join Settings.PortalRole pr on pr.ShortName = r.RoleShortName
	Where pr.PortalRoleID = @PortalRoleID
	Set @SAPHRJobNumber = @SAPHRJobNumber + ''''
	Set @SQL = 'exec Settings.pMaintainJobcodeToRole @PortalRoleID =' + convert(varchar(50), @PortalRoleID) + ', @JobCodes =' + @SAPHRJobNumber + ', @CreatedBy = ''System'''

	EXECUTE sp_executesql @SQL
	Insert Into @Text Values(@SQL)

	FETCH NEXT FROM jobcode_cursor1 
	INTO @PortalRoleID
END 
CLOSE jobcode_cursor1;
DEALLOCATE jobcode_cursor1;

Select *
From @Text 

Delete
From Settings.JobcodeInRole
Where JobCode not in (
	Select distinct JobCode From Settings.UserInRole uir
	Join Staging.ADExtractData ad on uir.GSN = ad.UserID)
Go

-- Need the assigned by Exception thing, right here
-- Need the assigned by Exception thing, right here
-- Need the assigned by Exception thing, right here
-- Need the assigned by Exception thing, right here
-- ****************************************************************** --
-- ****************************************************************** --
-- ****************************************************************** --

Declare @Text as Table
(
	SQL nvarchar(500),
	Result varchar(50)
)

Declare @PortalRoleID int;
Declare @GSN nvarchar(500);
Declare @SQL nvarchar(500);
Declare @Result varchar(500);

DECLARE jobcode_cursor1 CURSOR FOR 
Select up.GSN, pr.PortalRoleID
From Person.UserProfile up
Join Staging.ADExtractData ad on up.GSN = ad.UserID And up.JobCode <> ad.JobCode
Join Person.Job j on up.JobCode = j.SAPHRJobNumber
Join Person.Role r on r.RoleID = j.RoleID
Join Settings.PortalRole pr on pr.ShortName = r.RoleShortName
Where ManualSetup = 1

OPEN jobcode_cursor1

FETCH NEXT FROM jobcode_cursor1
INTO @GSN, @PortalRoleID

WHILE @@FETCH_STATUS = 0
BEGIN
	Set @SQL = 'exec Settings.pAddUserToRole @GSN = ''' + @GSN + ''', @PortalRoleID = ' + convert(varchar(50), @PortalRoleID)  + ', @CreatedBy = ''System'''
	--Set @SQL = 'Select * From Settings.UserInRole Where PortalRoleID =' + convert(varchar(50), @PortalRoleID) + ' And GSN = ''' + @GSN + ''''

	EXECUTE @Result = sp_executesql @SQL
	Insert Into @Text(SQL, Result) Values(@SQL, @Result)

	FETCH NEXT FROM jobcode_cursor1 
	INTO @GSN, @PortalRoleID
END 
CLOSE jobcode_cursor1;
DEALLOCATE jobcode_cursor1;

Select *
From @Text 
Go


/*
Truncate Table Settings.UserInRole
Truncate Table Settings.JobCodeInRole
Truncate Table Settings.PortalRoleOrgUnit
*/

-- Adding myself in for everything --
INSERT INTO [Settings].[UserInRole]([PortalRoleID],[GSN],[AssignedByException],[Precedence],[CreatedBy],[LastMofieidBy]) Values(1,'WUXYX001',1,1,'WUXYX001','WUXYX001')
INSERT INTO [Settings].[UserInRole]([PortalRoleID],[GSN],[AssignedByException],[Precedence],[CreatedBy],[LastMofieidBy]) Values(3,'WUXYX001',1,2,'WUXYX001','WUXYX001')
INSERT INTO [Settings].[UserInRole]([PortalRoleID],[GSN],[AssignedByException],[Precedence],[CreatedBy],[LastMofieidBy]) Values(4,'WUXYX001',1,3,'WUXYX001','WUXYX001')
INSERT INTO [Settings].[UserInRole]([PortalRoleID],[GSN],[AssignedByException],[Precedence],[CreatedBy],[LastMofieidBy]) Values(6,'WUXYX001',1,4,'WUXYX001','WUXYX001')
INSERT INTO [Settings].[UserInRole]([PortalRoleID],[GSN],[AssignedByException],[Precedence],[CreatedBy],[LastMofieidBy]) Values(7,'WUXYX001',1,5,'WUXYX001','WUXYX001')
INSERT INTO [Settings].[UserInRole]([PortalRoleID],[GSN],[AssignedByException],[Precedence],[CreatedBy],[LastMofieidBy]) Values(8,'WUXYX001',1,6,'WUXYX001','WUXYX001')
INSERT INTO [Settings].[UserInRole]([PortalRoleID],[GSN],[AssignedByException],[Precedence],[CreatedBy],[LastMofieidBy]) Values(9,'WUXYX001',1,7,'WUXYX001','WUXYX001')
INSERT INTO [Settings].[UserInRole]([PortalRoleID],[GSN],[AssignedByException],[Precedence],[CreatedBy],[LastMofieidBy]) Values(10,'WUXYX001',1,8,'WUXYX001','WUXYX001')
INSERT INTO [Settings].[UserInRole]([PortalRoleID],[GSN],[AssignedByException],[Precedence],[CreatedBy],[LastMofieidBy]) Values(11,'WUXYX001',1,9,'WUXYX001','WUXYX001')
INSERT INTO [Settings].[UserInRole]([PortalRoleID],[GSN],[AssignedByException],[Precedence],[CreatedBy],[LastMofieidBy]) Values(12,'WUXYX001',1,10,'WUXYX001','WUXYX001')
INSERT INTO [Settings].[UserInRole]([PortalRoleID],[GSN],[AssignedByException],[Precedence],[CreatedBy],[LastMofieidBy]) Values(13,'WUXYX001',1,11,'WUXYX001','WUXYX001')


--- Verify -----
Select jir.*, r.RoleName
From [Settings].[JobcodeInRole] jir
Join [Settings].[PortalRole] r on jir.PortalRoleID = r.PortalRoleID
Order By RoleName


Select uir.*, ad.JobCode, ad.FirstName, ad.LastName, ad.Title, ad.jobCode, r.RoleName
From Settings.UserInRole uir
Join Staging.ADExtractData ad on uir.GSN = ad.UserID
Join [Settings].[PortalRole] r on uir.PortalRoleID = r.PortalRoleID
Where AssignedByException = 1

Update SEttings.PortalRole
Set RoleName = 'Regional Account Executive', Invariantname = 'Regional Account Executive'
Where ShortName = 'RAE'

Select *
From Staging.ADExtractData
Where JobCode in (60019182, 60019574)

Select *
From Settings.JobcodeInRole
Where JobCode in (60019182, 60019574)

Select *
From Staging.ADExtractData
Where JobCode in 
(
	Select JobCode
	From Settings.JobcodeInRole jir
	Where JobCode not in (
		Select distinct JobCode From Settings.UserInRole uir
		Join Staging.ADExtractData ad on uir.GSN = ad.UserID)
)

GO


