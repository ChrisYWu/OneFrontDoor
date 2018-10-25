USE [Portal_Data]
GO
/****** Object:  StoredProcedure [Settings].[pMaintainJobcodeToRole]    Script Date: 1/8/2014 8:34:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Test Bench
Select b.OrgUnitID, OrgUnit, JobCode, Count(*)
From Staging.ADExtractData a
Join Shared.OrganizationUnit b on a.OrgUnit = b.OrgUnitName
Group By b.OrgUnitID, OrgUnit, JobCode
Having Count(*) > 1
Order By JobCode

--60011321(1,3,4,7,8)
--60000577(7,9)
--60011366(3,9)
--60011772(1,3)

exec Settings.pMaintainJobcodeToRole @PortalRoleID = 2026, @JobCodes = '60012027;60019200', @CreatedBy = 'WUXYX001', @SplitChar = ';', @OrgUnits=null

exec Settings.pMaintainJobcodeToRole @PortalRoleID = 9, @JobCodes = '60019874;60011745;60011641', @CreatedBy = 'WUXYX001'
exec Settings.pMaintainJobcodeToRole @PortalRoleID = 8, @JobCodes = '60019874', @CreatedBy = 'WUXYX001'
exec Settings.pMaintainJobcodeToRole @PortalRoleID = 7, @JobCodes = '60019874', @CreatedBy = 'WUXYX001'
exec Settings.pMaintainJobcodeToRole @PortalRoleID = 6, @JobCodes = '60011641', @CreatedBy = 'WUXYX001'

exec Settings.pMaintainJobcodeToRole @PortalRoleID = 9, @JobCodes = '60011321;60000577', @OrgUnits='7', @CreatedBy = 'WUXYX001'

Select jir.*, r.RoleName
From [Settings].[JobcodeInRole] jir
Join [Settings].[PortalRole] r on jir.PortalRoleID = r.PortalRoleID
Where jir.PortalRoleID = 9

Select uir.*, ad.JobCode
From Settings.UserInRole uir
Join Staging.ADExtractData ad on uir.GSN = ad.UserID

Truncate Table Settings.UserInRole
Truncate Table Settings.JobCodeInRole
Truncate Table Settings.PortalRoleOrgUnit

*/

ALTER Proc [Settings].[pMaintainJobcodeToRole]
(
	@PortalRoleID int,
	@Jobcodes varchar(500),
	@CreatedBy varchar(50),
	@SplitChar char(1) = ';',
	@AssignedByException bit,
	@OrgUnits varchar(500) = null
)
As
Begin
	Set NoCount On;

	--0. Prepare input parameters and also maintain PortalRoleOrgUnit
	Declare @JobcodeTable Table
	(
		Jobcode int not null
	)

	Insert Into @JobcodeTable
	Select LTrim(RTrim(Value))
	From dbo.Split(@Jobcodes, @SplitChar)
	Where LTrim(RTrim(Value)) <> ''

	Declare @OrgUnitTable Table
	(
		OrgUnitID int not null,
		OrgUnitName varchar(50)
	)	
	If (@OrgUnits is null)
	Begin
		Insert @OrgUnitTable
		Select OrgUnitID, OrgUnitName From Shared.OrganizationUnit

		Delete From Settings.PortalRoleOrgUnit Where PortalRoleID = @PortalRoleID and OrgUnitID in (Select OrgUnitID From @OrgUnitTable)
	End
	Else 
	Begin
		Insert @OrgUnitTable
		Select Value, OrgUnitName
		From dbo.Split(@OrgUnits, @SplitChar) s
		Join Shared.OrganizationUnit ou on s.Value = ou.OrgUnitID 

		MERGE Settings.PortalRoleOrgUnit AS pro
		USING (	Select @PortalRoleID PortalRoleID, OrgUnitID From @OrgUnitTable) AS input
			ON pro.PortalRoleID = input.PortalRoleID And pro.OrgUnitID = input.OrgUnitID
		WHEN NOT MATCHED By Target THEN
			INSERT(PortalRoleID, OrgUnitID, CreatedBy, LastModifiedBy)
			VALUES(input.PortalRoleID, input.OrgUnitID, @CreatedBy, @CreatedBy)
		WHEN NOT MATCHED By Source THEN
			Delete;
	End
	------------------------------------------------
	------------------------------------------------

	--1.0 Delete UserInRole(might left holes there with precedence, but it's ok
	Delete uir
	From Settings.UserInRole uir
	Join Person.UserProfile ad on uir.GSN = ad.GSN
	Where JobCode in 
		(
			Select jir.JobCode
			From Settings.JobcodeInRole jir 
			Left Join @JobcodeTable j on j.JobCode = jir.JobCode and jir.PortalRoleID = @PortalRoleID
			Where j.JobCode is null
		)
	And PortalRoleID = @PortalRoleID And AssignedByException = 0
	-- When Creating, nobody in UserInRole, works
	-- When Updating And @AssignedByException 1->0, the exceptions are left in UserInRole, works
	-- When Updating And 1 -> 1, the exceptions are left in UserInRole, works


	--1.1 Delete JobcodeInRole
	Delete jir
	From Settings.JobcodeInRole jir 
	Left Join @JobcodeTable j on j.JobCode = jir.JobCode and jir.PortalRoleID = @PortalRoleID
	Where j.JobCode is null
	And PortalRoleID = @PortalRoleID

	------------------------------------------------
	------------------------------------------------
	--2.0 Insert UserInRole
	Declare @NextPrecedence Table
	(
		GSN varchar(50),
		NextOne int
	)
	Insert Into @NextPrecedence
		Select GSN, Max(Precedence) + 1 NextOne
		From Settings.UserInRole
		Group By GSN
	Declare @JobCode int;

	DECLARE jobcode_cursor CURSOR FOR 
	SELECT JobCode
	FROM @JobcodeTable
	--Where JobCode Not In (Select JobCode From [Settings].[JobcodeInRole] Where PortalRoleID = @PortalRoleID)
	
	OPEN jobcode_cursor

	FETCH NEXT FROM jobcode_cursor 
	INTO @JobCode

	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		if(@AssignedByException = 0)
			-- When Creating, nobody in UserInRole, works
			-- When Updating And @AssignedByException 1->0, jobcode ones are inserted, works
			-- When Updating And 1 -> 1, jobcode ones are inserted, works
			Begin
				INSERT INTO [Settings].[UserInRole]
					([PortalRoleID]
					,[GSN]
					,Precedence
					,[CreatedBy]
					,[LastMofieidBy])
				Select
					@PortalRoleID
					,up.GSN
					,isnull(np.NextOne, 1)
					,@CreatedBy
					,@CreatedBy
				From Person.UserProfile up
				Join @OrgUnitTable ou on up.OrgUnitID = ou.OrgUnitID
				Left Join @NextPrecedence np on up.GSN = np.GSN
				Where JobCode = @JobCode
				And up.GSN Not In (Select GSN From Settings.UserInRole Where PortalRoleID = @PortalRoleID);
			End
		Else
			-- When Creating, nobody in UserInRole/UserNotInRole, works
			-- When Updating And @AssignedByException 1->0, jobcode ones are inserted, works
			-- When Updating And 1 -> 1, jobcode ones are inserted, works
			Begin
				INSERT INTO [Settings].[UserInRole]
			   ([PortalRoleID]
			   ,[GSN]
			   ,Precedence
			   ,[CreatedBy]
			   ,[LastMofieidBy])
				Select
			   @PortalRoleID
			   ,up.GSN
			   ,isnull(np.NextOne, 1)
			   ,@CreatedBy
			   ,@CreatedBy
				 From Person.UserProfile up
				 Join @OrgUnitTable ou on up.OrgUnitID = ou.OrgUnitID
				 Left Join @NextPrecedence np on up.GSN = np.GSN
				 Where JobCode = @JobCode
			--	 And up.GSN Not In (Select GSN From Settings.UserNotInRole Where PortalRoleID = @PortalRoleID) --- As per discussion with Chris Wu we are not dynamically maintaining the both the tables
				 And up.GSN Not In (Select GSN From Settings.UserInRole Where PortalRoleID = @PortalRoleID);
			End
		FETCH NEXT FROM jobcode_cursor 
		INTO @JobCode
	END 
	CLOSE jobcode_cursor;
	DEALLOCATE jobcode_cursor;

	
	--2.2 Insert JobCodeInRole
	Insert Into [Settings].[JobcodeInRole]
			   ([PortalRoleID]
			   ,[JobCode]
			   ,[CreatedBy]
			   ,[LastModifedBy])
	Select @PortalRoleID
			,j.Jobcode
			,@CreatedBy
			,@CreatedBy
	From @JobcodeTable j
	Left Join Settings.JobcodeInRole jir on j.JobCode = jir.JobCode and jir.PortalRoleID = @PortalRoleID
	Where jir.JobCode is null;
	------------------------------------------------
	------------------------------------------------
	------------------------------------------------
	
	-- Adjust the assigned by exception ones
	-- When creating, works
	With TGT as 
	(
		Select * from Settings.UserInRole 
			where PortalRoleID = @PortalRoleID and AssignedByException = 1 And  GSN in (Select GSN
					From Person.UserProfile u  
					Join @JobcodeTable jc on u.JobCode = jc.Jobcode)
	) 
	Merge Into TGT as UIR
	Using (Select * from settings.userinrole where PortalRoleID = @PortalRoleID) SRC
		ON UIR.GSN = SRC.GSN 
	WHEN MATCHED THEN
	    -- When updating, users flag is reset(0), since it's already covered by jobcode
		Update Set AssignedByException = 0, LastMofieidBy = @CreatedBy, LastModified = GetDate()
	WHEN NOT MATCHED by source THEN
		Delete;

	Delete From Settings.UserNotInRole Where PortalRoleID = @PortalRoleID And @AssignedByException = 0

End


