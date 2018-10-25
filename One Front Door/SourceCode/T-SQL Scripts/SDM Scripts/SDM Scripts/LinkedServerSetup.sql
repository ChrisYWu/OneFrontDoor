USE [master]
GO

-------------------------------------------------------------------------------------------------
-------Route Manager-----------------------------------------------------------------------------
/****** Object:  LinkedServer [RM]    Script Date: 4/1/2013 11:23:44 AM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'RM', @srvproduct=N'Oracle', @provider=N'OraOLEDB.Oracle', @datasrc=N'RM.WORLD'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'RM',@useself=N'False',@locallogin=NULL,@rmtuser=N'SDMRM',@rmtpassword='sdmrm'

GO

-------------------------------------------------------------------------------------------------
-------RoadNet-----------------------------------------------------------------------------
/****** Object:  LinkedServer [RN]    Script Date: 4/1/2013 11:26:28 AM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'RN', @srvproduct=N'Oracle', @provider=N'OraOLEDB.Oracle', @datasrc=N'RN.World'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'RN',@useself=N'False',@locallogin=NULL,@rmtuser=N'WUXYX001',@rmtpassword='WUXYX001_HP'

GO

-------------------------------------------------------------------------------------------------
-------Capstone DM ------------------------------------------------------------------------------
/****** Object:  LinkedServer [COD]    Script Date: 4/1/2013 11:26:58 AM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'COD', @srvproduct=N'Oracle', @provider=N'OraOLEDB.Oracle', @datasrc=N'COD.WORLD', @provstr=N'bsccdb02.dpsg.net:1521/COD'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'COD',@useself=N'False',@locallogin=NULL,@rmtuser=N'WUXYX001',@rmtpassword='WUXYX001_HP'

GO


