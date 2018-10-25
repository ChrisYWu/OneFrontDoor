SELECT * FROM sys.dm_exec_requests where DB_NAME(database_id)='Portal_Data' and blocking_session_id <>0

SELECT * FROM sys.dm_exec_requests CROSS APPLY sys.dm_exec_sql_text(sql_handle) where blocking_session_id <> 0

sp_who 65
Go
sp_who 67
Go
sp_who 75
Go

sp_who2 'active'

sp_lock
sp_who2

select cmd,* from sys.sysprocesses
where blocked > 0
