use Portal_Data_INT
Go

/*
Name: STORES_MAPVIEW_RADIUS_INMILES 
Value: 5
*/


INSERT INTO [BCMyday].[Config]
           ([Key]
           ,[Value]
           ,[Description]
           ,[ModifiedDate]
           ,[SendToMyday])
     VALUES
           ('STORES_MAPVIEW_RADIUS_INMILES'
           ,'5'
           ,'Stores mapview radius in miles'
           ,SYSDATETIME()
           ,1)
GO

Select *
From BCMyday.Config
