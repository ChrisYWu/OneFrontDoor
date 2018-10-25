use Portal_Data
Go

Select *
From ETL.BCDataLoadingLog l
Where SchemaName = 'Staging' And TableName = 'SafetyAirHeader'
