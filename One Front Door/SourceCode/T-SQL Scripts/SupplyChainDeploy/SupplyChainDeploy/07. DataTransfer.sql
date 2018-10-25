use Portal_DAta1118
go

INSERT INTO [Apacheta].[FleetLoader]
           ([SESSION_DATE]
           ,[ROUTE_ID]
           ,[LOCATION_ID]
           ,[ORDER_NUMBER]
           ,[BAY_NUMBER]
           ,[SKU]
           ,[QUANTITY]
           ,[TOTAL_QUANTITY]
           ,[LAST_UPDATE])
Select *
From [VH-PORTAL2.DPSG.NET].[Portal_Data818].[Apacheta].[FleetLoader]
GO


