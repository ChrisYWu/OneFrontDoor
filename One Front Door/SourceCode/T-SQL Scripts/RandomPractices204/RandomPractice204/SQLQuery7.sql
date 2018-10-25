use Portal_Data_INT
Go

--Set Identity_Insert Playbook.PromotionRank On;
--Go

--Insert Into Playbook.PromotionRank(PromotionRankID, PromotionID, PromotionWeekStart, PromotionWeekEnd, Rank)
--Select *
--From BSCCAP121.Portal_Data.Playbook.PromotionRank
--Where PromotionID in (Select PromotionID From PlayBook.RetailPromotion)
--Go

--Set Identity_Insert Playbook.PromotionRank Off;
--Go

/*
1. Deployed to 108 on 2015-10-26
2. Changes made and depolyed to 108 for U00000

*/

--##############################################
------------------------------------------------
If Exists (
	Select *
	From sys.indexes
	Where Name like 'NCI-RevChainImages-LocalChainID'
)

CREATE NONCLUSTERED INDEX [NCI-RevChainImages-LocalChainID]
ON [MSTR].[RevChainImages] ([LocalChainID])
INCLUDE ([ChainID])
Go

--##############################################

If Exists (Select * From sys.indexes Where Name = 'NCI_PromotionAccount_NationalChainID')
	Drop Index NCI_PromotionAccount_NationalChainID On [Playbook].[PromotionAccount]
Go

CREATE NONCLUSTERED INDEX NCI_PromotionAccount_NationalChainID
ON [Playbook].[PromotionAccount] ([PromotionID])
INCLUDE ([NationalChainID])
Go

--##############################################

If Exists (Select * From sys.indexes Where Name = 'NCI_PromotionAccount_RegionalChainID')
	Drop Index NCI_PromotionAccount_RegionalChainID On [Playbook].[PromotionAccount]
Go

CREATE NONCLUSTERED INDEX NCI_PromotionAccount_RegionalChainID
ON [Playbook].[PromotionAccount] ([PromotionID])
INCLUDE ([RegionalChainID])
Go

--##############################################

If Exists (Select * From sys.indexes Where Name = 'NCI_PromotionAccount_LocalChainID')
	Drop Index NCI_PromotionAccount_LocalChainID On [Playbook].[PromotionAccount]
Go

CREATE NONCLUSTERED INDEX NCI_PromotionAccount_LocalChainID
ON [Playbook].[PromotionAccount] ([PromotionID])
INCLUDE ([LocalChainID])
Go

--##############################################

If Not Exists (
	Select *
	From Sys.Tables
	Where Object_ID = object_id('PlayBook.PromotionRankBackup'))
Begin
	Select *
	Into PlayBook.PromotionRankBackup
	From PlayBook.PromotionRank 

	Drop Table PlayBook.PromotionRank 
End
Go

If Exists (
	Select *
	From Sys.Tables
	Where Object_ID = object_id('PlayBook.PromotionRank'))
Begin
	Drop Table PlayBook.PromotionRank 
End
Go

CREATE TABLE PlayBook.PromotionRank(
	PromotionID [int] NOT NULL,
	ChainGroupID Varchar(20) NOT NULL,
	PromotionWeekStart Date NOT NULL,
	PromotionWeekEnd Date NOT NULL,
	[Rank] Int NOT NULL,
 CONSTRAINT [PK_PromotionRank] PRIMARY KEY CLUSTERED 
(
	PromotionID ASC,
	ChainGroupID ASC,
	PromotionWeekStart ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

---------------------- First Run ------------------------------
---------------------- First Run ------------------------------
---------------------- First Run ------------------------------

exec PreCal.pRefreshLookups
exec PreCal.pPupulateChainGroupTree @Debug = 1;

With PromotionRank1 As
(
	Select pr.PromotionID, PromotionWeekStart, PromotionWeekEnd, Coalesce(ChainGroupID, 'U00000') ChainGroupID, [Rank]
	From PlayBook.PromotionRankBackup pr
	Left Join PreCal.PromotionChainGroup pgr on pr.PromotionID = pgr.PromotionID
)

Insert PlayBook.PromotionRank(PromotionID, PromotionWeekStart, PromotionWeekEnd, ChainGroupID, [Rank])
Select PromotionID, PromotionWeekStart, PromotionWeekEnd, ChainGroupID, IsNull([Rank], 100)
From PromotionRank1
Go

exec PreCal.pReMapDSDPromotions @Debug = 1
exec PreCal.pReMapBCPromotions @Debug = 1
Go

---------------------- Job ------------------------------
---------------------- Job ------------------------------
USE [msdb]
GO

IF  EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = N'DPSG.SDM.JobRemapPromotions')
Begin
	EXEC msdb.dbo.sp_delete_job @job_name=N'DPSG.SDM.JobRemapPromotions', @delete_unused_schedule=1
End
GO

/****** Object:  Job [DPSG.SDM.JobRemapPromotions]    Script Date: 11/20/2015 12:15:05 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
DECLARE @DBname nvarchar(20)
Set @DBname = 'Portal_Data'

SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 11/20/2015 12:15:05 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'DPSG.SDM.JobRemapPromotions', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'DPSG\WUXYX001', 
		@job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Refresh Lookups]    Script Date: 11/20/2015 12:15:07 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Refresh Lookups', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec Precal.pRefreshLookups', 
		@database_name=@DBname, 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Refresh ChainGroup Tree]    Script Date: 11/20/2015 12:15:07 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Refresh ChainGroup Tree', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec PreCal.pPupulateChainGroupTree', 
		@database_name=@DBname, 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Remap DSD Promotions]    Script Date: 11/20/2015 12:15:07 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Remap DSD Promotions', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec PreCal.pRemapDSDPromotions', 
		@database_name=@DBname, 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Remap BC Promotions]    Script Date: 11/20/2015 12:15:07 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Remap BC Promotions', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'PreCal.pRemapBCPromotions', 
		@database_name=@DBname, 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Executes Everynight at 4:15 AM', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20151120, 
		@active_end_date=99991231, 
		@active_start_time=41500, 
		@active_end_time=235959, 
		@schedule_uid=N'10598aea-d1e2-4c6a-93e8-9ebcc069b5a4'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO

Print '--- SQL AgentJob DPSG.SDM.JobRemapPromotions created with schedule ---'
GO
