--it doesn't help, so not executed on QA

USE Portal_Data;
GO
EXEC sp_configure 'show advanced options', 1;
GO
RECONFIGURE ;
GO
EXEC sp_configure 'network packet size', 8192;
GO
RECONFIGURE;
GO