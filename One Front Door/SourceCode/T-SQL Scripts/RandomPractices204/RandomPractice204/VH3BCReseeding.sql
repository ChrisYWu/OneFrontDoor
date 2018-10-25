use Portal_Data721P
Go

Truncate Table [BC].[tRegionTradeMark]
Go
Truncate Table [BC].[tRegionChainTradeMark]
Go
Truncate Table [BC].[tRegionChain]
Go
Truncate Table [BC].[tBottlerTrademark]
Go
Truncate Table [BC].[tBottlerTerritoryType]
Go
Truncate Table [BC].[tBottlerMapping]
Go
Truncate Table [BC].[tBottlerChainTradeMark]
Go
Truncate Table [BC].[BottlerAccountTradeMark]
Go
Truncate Table [BC].[AccountInclusion]
Go
Delete From BC.Bottler
Go
DBCC CHECKIDENT ('BC.Bottler', RESEED, 1);
GO
Delete From [BC].[BottlerEB4]
Go
DBCC CHECKIDENT ('BC.BottlerEB4', RESEED, 1);
GO
Delete From [BC].[BottlerEB3]
Go
DBCC CHECKIDENT ('BC.BottlerEB3', RESEED, 1);
GO
Delete From [BC].[BottlerEB2]
Go
DBCC CHECKIDENT ('BC.BottlerEB2', RESEED, 1);
GO
Delete From [BC].[BottlerEB1]
Go
DBCC CHECKIDENT ('BC.BottlerEB1', RESEED, 1);
GO
Delete From NationalAccount.ProgramBCRegion Where BCRegionID in (Select RegionID From BC.Region)
Delete From [BC].Region
Go
DBCC CHECKIDENT ('BC.Region', RESEED, 1);
GO
Delete From [BC].Division
Go
DBCC CHECKIDENT ('BC.Division', RESEED, 1);
GO
Delete From [BC].Zone
Go
DBCC CHECKIDENT ('BC.Zone', RESEED, 1);
GO
Delete From NationalAccount.ProgramGeoRelevancy Where SystemID in (Select SystemID From BC.System)
Delete From BCMyday.PriorityBottler Where SystemID in (Select SystemID From BC.System)
Delete From BCMyday.SystemCompetitionBrand Where SystemID in (Select SystemID From BC.System)
Delete From [BC].System
Go
DBCC CHECKIDENT ('BC.System', RESEED, 1);
GO
Delete From [BC].Country
Go
DBCC CHECKIDENT ('BC.Country', RESEED, 1);
GO
Delete From [BC].TotalCompany
Go
DBCC CHECKIDENT ('BC.TotalCompany', RESEED, 1);
GO
Delete From ETL.BCDataLoadingLog
Go
DBCC CHECKIDENT ('ETL.BCDataLoadingLog', RESEED, 1);
GO
Delete From ETL.BCAccountTerritoryMapRecreationLog
Go
DBCC CHECKIDENT ('ETL.BCAccountTerritoryMapRecreationLog', RESEED, 1);
GO

Select * From ETL.BCDataLoadingLog
Select * From ETL.BCAccountTerritoryMapRecreationLog
Select Count(*) [AccountInclusion] From [BC].[AccountInclusion]
Select Count(*) [Bottler] From [BC].[Bottler]
Select Count(*) [BottlerAccountTradeMark] From [BC].[BottlerAccountTradeMark]
Select Count(*) [BottlerEB2] From [BC].[BottlerEB2]
Select Count(*) [BottlerEB1] From [BC].[BottlerEB1]
Select Count(*) [BottlerEB3] From [BC].[BottlerEB3]
Select Count(*) [BottlerEB4] From [BC].[BottlerEB4]
Select Count(*) [Country] From [BC].[Country]
Select Count(*) [Division] From [BC].[Division]
Select Count(*) [GlobalStatus] From [BC].[GlobalStatus]
Select Count(*) [ProductType] From [BC].[ProductType]
Select Count(*) [Region] From [BC].[Region]
Select Count(*) [System] From [BC].[System]
Select Count(*) [tBottlerChainTradeMark] From [BC].[tBottlerChainTradeMark]
Select Count(*) [tBottlerMapping] From [BC].[tBottlerMapping]
Select Count(*) [tBottlerTrademark] From [BC].[tBottlerTrademark]
Select Count(*) [tBottlerTerritoryType] From [BC].[tBottlerTerritoryType]
Select Count(*) [TerritoryMap] From [BC].[TerritoryMap]
Select Count(*) [TerritoryType] From [BC].[TerritoryType]
Select Count(*) [TotalCompany] From [BC].[TotalCompany]
Select Count(*) [tRegionChain] From [BC].[tRegionChain]
Select Count(*) [tRegionChainTradeMark] From [BC].[tRegionChainTradeMark]
Select Count(*) [tRegionTradeMark] From [BC].[tRegionTradeMark]
Select Count(*) [Zone] From [BC].[Zone]
