/*  The ORA entry

# ----- Capstone Prod -------------------
COP.world = 
	(DESCRIPTION = 
        (ADDRESS = 
          (PROTOCOL = TCP)
          (Host = bsccdb04.dpsg.net)
          (Port = 1521)
        )
      (CONNECT_DATA = (SID = COP)
        (SERVICE_NAME = COP)           
      )
  )

*/


USE [master]
GO

/****** Object:  LinkedServer [COP]    Script Date: 5/1/2014 1:23:49 PM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'COP', @srvproduct=N'Oracle', @provider=N'OraOLEDB.Oracle', @datasrc=N'COP.world'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'COP',@useself=N'False',@locallogin=NULL,@rmtuser=N'SDMREAD',@rmtpassword='26dFUsR'

GO

EXEC master.dbo.sp_serveroption @server=N'COP', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'COP', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'COP', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'COP', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'COP', @optname=N'rpc', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'COP', @optname=N'rpc out', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'COP', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'COP', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'COP', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'COP', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'COP', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'COP', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'COP', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO

