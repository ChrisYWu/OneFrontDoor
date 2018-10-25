use Portal_Data
Go

EXEC sp_change_users_login 'REPORT' 
Go

EXEC sp_change_users_login 'UPDATE_ONE','mstr','mstr'
EXEC sp_change_users_login 'UPDATE_ONE','OnePortal','OnePortal'
EXEC sp_change_users_login 'UPDATE_ONE','SDMReadOnly','SDMReadOnly'
Go
