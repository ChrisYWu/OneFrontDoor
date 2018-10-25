use Portal_Data204
Go

Alter Table SupplyChain.Plant
Add SAPPlantType Varchar(50) not null Default 'Manufacturing'
Go

--Exec sp_rename 'SupplyChain.Plant.PlantType', 'SAPPlantType', 'Column'

Alter Table SupplyChain.Plant
Add Notes Varchar(250) null
Go

Insert Into [SupplyChain].[Plant]
           ([PlantSK]
           ,[SAPPlantNumber]
           ,[SAPSource]
           ,[PlantName]
           ,[PlantDesc]
           ,[Address1]
           ,[Address2]
           ,[City]
           ,[State]
           ,[ZipCode]
           ,[Logitude]
           ,[Latitude]
           ,[PlantManagerGSN]
           ,[PlantRTM]
           ,[RegionID]
           ,[PlantTypeID]
           ,[ChangeTrackNumber]
           ,[LastModified]
           ,[Active]
           ,[SafetyPlantName]
           ,[SafetyLocationID]
           ,[Country]
           ,SAPPlantType)
     VALUES
           (0
           ,1148
           ,'SP7'
           ,'WD Dallas RDC'
           ,'WD Dallas RDC'
           ,'4040 Pipestone Road'
           ,null
           ,'Dallas'
           ,'TX'
           ,75212
           ,-96.887648
           ,32.773516 
           ,null
           ,null
           ,1
           ,1
           ,1000
           ,GetDate()
           ,1
           ,'Dallas, TX -- RDC'
           ,769
           ,'US'
           ,'RDC')
Go

Insert Into [SupplyChain].[Plant]
           ([PlantSK]
           ,[SAPPlantNumber]
           ,[SAPSource]
           ,[PlantName]
           ,[PlantDesc]
           ,[Address1]
           ,[Address2]
           ,[City]
           ,[State]
           ,[ZipCode]
           ,[Logitude]
           ,[Latitude]
           ,[PlantManagerGSN]
           ,[PlantRTM]
           ,[RegionID]
           ,[PlantTypeID]
           ,[ChangeTrackNumber]
           ,[LastModified]
           ,[Active]
           ,[SafetyPlantName]
           ,[SafetyLocationID]
           ,[Country]
           ,SAPPlantType)
     VALUES
           (0
           ,1418
           ,'SP7'
           ,'WD Jacksonville RDC'
           ,'WD Jacksonville RDC'
           ,'2300 Pickettville Road'
           ,null
           ,'Jacksonville'
           ,'FL'
           ,32220
           ,-81.766157
           ,30.351864
           ,null
           ,null
           ,1
           ,1
           ,1000
           ,GetDate()
           ,1
           ,'Jacksonville, FL -- RDC'
           ,879
           ,'US'
           ,'RDC')
Go

Update SupplyChain.Plant
Set SAPPlantNumber = 1219, SAPSource = 'SP7', Notes = 'Other Plant Number: 1211'
Where PlantDesc = 'Bethlehem'
Go

Update SupplyChain.Plant
Set Notes = 'Other Plant Number: 1404'
Where PlantDesc = 'Jacksonville'
Go

Select SAPPlantNumber, SAPSource, Count(*) Cnt
From SupplyChain.Plant
Where SAPPlantNumber is not null
Group By SAPPlantNumber, SAPSource
Order By SAPPlantNumber
Go


