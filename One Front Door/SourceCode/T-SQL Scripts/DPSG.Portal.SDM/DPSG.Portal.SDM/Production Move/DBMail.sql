-- Provided by Murali

sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
sp_configure 'Database Mail XPs', 1;
GO
RECONFIGURE
GO

Declare @Prof as Int=0
Declare @Acct as int=0

/*If Profile and account is already existing in Database then Delete it*/

Select @Prof = profile_id from msdb.dbo.sysmail_profile where name='AmplifyProfile'
Select @Acct = account_id from msdb.dbo.sysmail_account where name='AmplifyAccount'

If @Prof is not Null
	Begin
		Delete from msdb.dbo.sysmail_profile where name='AmplifyProfile'
	End 

If @Acct is not Null
	Begin
		Delete from msdb.dbo.sysmail_account where name='AmplifyAccount'
	End 


-- Create a Database Mail account

EXECUTE msdb.dbo.sysmail_add_account_sp
    @account_name = 'AmplifyAccount',
    @description = 'Amplify Mail account for use by all database users.',
    @email_address = 'Rajeev.Unnikrishnan@dpsg.com',
    @replyto_address = 'Rajeev.Unnikrishnan@dpsg.com',
    @display_name = 'Amplify Job Mailer',
    @mailserver_name = 'relay01.dpsg.net' ;

	--@port = 25,     
	--@username = 'xyz',     
	--@password = 'xxyyzz',     
	--@enable_ssl = 1   


-- Create a Database Mail profile
EXECUTE msdb.dbo.sysmail_add_profile_sp
    @profile_name = 'AmplifyProfile',
    @description = 'Profile used for administrative mail.' ;


-- Add the account to the profile
EXECUTE msdb.dbo.sysmail_add_profileaccount_sp
    @profile_name = 'AmplifyProfile',
    @account_name = 'AmplifyAccount',
    @sequence_number = 1 ;


-- Grant access to the profile to all users in the msdb database
EXECUTE msdb.dbo.sysmail_add_principalprofile_sp
    @profile_name = 'AmplifyProfile',
    @principal_name = 'public',
    @is_default = 1 ;


-- Sending a Test email after configuring
EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'AmplifyProfile',
    @recipients = 'Chris.Wu@dpsg.com',
--	@copy_recipients = 'Renu.Bonthala@dpsg.com; sriram.jetti@dpsg.com',
    @body = 'The stored procedure finished successfully and Send email is Setup.',
    @subject = 'Automated Email Setup Success Message' ;

/* All jusk code*/

--select * from msdb.dbo.sysmail_profile 
--select * from msdb.dbo.sysmail_account where name='MuraliAccountTest'

--Delete from msdb.dbo.sysmail_profile where name='ABCD'
--Delete from msdb.dbo.sysmail_account where name='MuraliAccountTest'
