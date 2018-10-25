USE [master]
GO

/****** Object:  LinkedServer [AIRVDB02]    Script Date: 11/18/2014 4:04:03 PM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'AIRVDB02', @srvproduct=N'', @provider=N'SQLNCLI', @datasrc=N'AIRVDB02', @catalog=N'Production'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'AIRVDB02',@useself=N'False',@locallogin=NULL,@rmtuser=N'SDM_ReadOnly',@rmtpassword='SDM_ReadOnly@123'

GO

EXEC master.dbo.sp_serveroption @server=N'AIRVDB02', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'AIRVDB02', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'AIRVDB02', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'AIRVDB02', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'AIRVDB02', @optname=N'rpc', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'AIRVDB02', @optname=N'rpc out', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'AIRVDB02', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'AIRVDB02', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'AIRVDB02', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'AIRVDB02', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'AIRVDB02', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'AIRVDB02', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'AIRVDB02', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO

