USE [master]
GO

/****** Object:  LinkedServer [ASCCSQ11\TORPDB02]    Script Date: 1/16/2015 3:52:58 PM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'ASCCSQ11\TORPDB02', @srvproduct=N'SQL Server'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'ASCCSQ11\TORPDB02',@useself=N'False',@locallogin=NULL,@rmtuser=N'OnePortal',@rmtpassword='OnePortalSQ11'

GO

EXEC master.dbo.sp_serveroption @server=N'ASCCSQ11\TORPDB02', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'ASCCSQ11\TORPDB02', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'ASCCSQ11\TORPDB02', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'ASCCSQ11\TORPDB02', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'ASCCSQ11\TORPDB02', @optname=N'rpc', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'ASCCSQ11\TORPDB02', @optname=N'rpc out', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'ASCCSQ11\TORPDB02', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'ASCCSQ11\TORPDB02', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'ASCCSQ11\TORPDB02', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'ASCCSQ11\TORPDB02', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'ASCCSQ11\TORPDB02', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'ASCCSQ11\TORPDB02', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'ASCCSQ11\TORPDB02', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO

