use Portal_Data_INT
Go

----- those have dependency on views -----------------
------------------------------------------------------

If Exists (Select * From Sys.views where object_id = object_id('BC.vBCAccountability'))
Begin
	Drop View BC.vBCAccountability
End
Go

If Exists (Select * From Sys.views where object_id = object_id('BC.vFSAccountability'))
Begin
	Drop View BC.vFSAccountability
End
Go

------------------------------------------------------
------------------ Independent Views -----------------
If Exists (Select * From Sys.views where object_id = object_id('BC.vSalesHierarchy'))
Begin
	Drop View BC.vSalesHierarchy
End
Go

If Exists (Select * From Sys.views where object_id = object_id('BC.vCPIBottler'))
Begin
	Drop View BC.vCPIBottler
End
Go

If Exists (Select * From Sys.views where object_id = object_id('BC.vBottlerExternalHier'))
Begin
	Drop View BC.vBottlerExternalHier
End
Go

If Exists (Select * From Sys.views where object_id = object_id('BC.vBottlerSalesHier'))
Begin
	Drop View BC.vBottlerSalesHier
End
Go

If Exists (Select * From Sys.views where object_id = object_id('Staging.vBCProduct'))
Begin
	Drop View Staging.vBCProduct
End
Go

If Exists (Select * From Sys.views where object_id = object_id('BC.vGSNRegion'))
Begin
	Drop View BC.vGSNRegion
End
Go

If Exists (Select * From Sys.views where object_id = object_id('Processing.BCvStoreERHSDM'))
Begin
	DROP VIEW Processing.BCvStoreERHSDM
End
GO
----- -------------------------------------------
---------- Stored Procs -------------------------
-------------------------------------------------
If Exists (Select * From sys.procedures where object_id = object_id('ETL.pReloadBCSalesAccountability'))
Begin
	DROP PROCEDURE ETL.pReloadBCSalesAccountability
End
GO

If Exists (Select * From sys.procedures where object_id = object_id('ETL.pMergeViewTables'))
Begin
	DROP PROCEDURE ETL.pMergeViewTables
End
GO

If Exists (Select * From sys.procedures where object_id = object_id('ETL.pMergeTMapAndInclusions'))
Begin
	DROP PROCEDURE ETL.pMergeTMapAndInclusions
End
GO

If Exists (Select * From sys.procedures where object_id = object_id('ETL.pMergeStateCounty'))
Begin
	DROP PROCEDURE ETL.pMergeStateCounty
End
GO

If Exists (Select * From sys.procedures where object_id = object_id('ETL.pMergeChainsAccounts'))
Begin
	DROP PROCEDURE ETL.pMergeChainsAccounts
End

If Exists (Select * From sys.procedures where object_id = object_id('ETL.pMergeCapstoneProduct'))
Begin
	DROP PROCEDURE ETL.pMergeCapstoneProduct
End

If Exists (Select * From sys.procedures where object_id = object_id('ETL.pMergeCapstoneBottlerHier'))
Begin
	DROP PROCEDURE ETL.pMergeCapstoneBottlerHier
End

If Exists (Select * From sys.procedures where object_id = object_id('ETL.pMergeCapstoneBottlerERH'))
Begin
	DROP PROCEDURE ETL.pMergeCapstoneBottlerERH
End

If Exists (Select * From sys.procedures where object_id = object_id('ETL.pMergeCapstoneBottler'))
Begin
	DROP PROCEDURE ETL.pMergeCapstoneBottler
End

If Exists (Select * From sys.procedures where object_id = object_id('ETL.pLoadFromCapstone'))
Begin
	DROP PROCEDURE ETL.pLoadFromCapstone
End

If Exists (Select * From sys.procedures Where Object_id = object_id('ETL.pNotifyCapstoneFailedStatus'))
Begin
	Drop Proc ETL.pNotifyCapstoneFailedStatus
End
Go

-------------------------------------------------
------------- Functions -------------------------
If Exists (select * From sys.objects where object_id = object_id('BC.udf_SetOpenQuery') and type = 'FN')
Begin
	DROP FUNCTION  BC.udf_SetOpenQuery
End

If Exists (select * From sys.objects where object_id = object_id('BC.udf_ConvertToPLSqlTimeFilter') and type = 'FN')
Begin
	DROP FUNCTION BC.udf_ConvertToPLSqlTimeFilter
End
GO

-------------------------------------------------
-------------------------------------------------
---------- TABLES -------------------------------
If Exists (Select * From Sys.tables Where object_id= object_id('Shared.StateRegion'))
Begin
	ALTER TABLE Shared.StateRegion DROP CONSTRAINT FK_StateRegion_Country
End
GO

If Exists (Select * From Sys.tables Where object_id= object_id('Shared.County'))
Begin
	ALTER TABLE Shared.County DROP CONSTRAINT FK_County_StateRegion
End
GO

If Exists (Select * From Sys.tables Where object_id= object_id('BC.Zone'))
Begin
	ALTER TABLE BC.Zone DROP CONSTRAINT FK_Zone_System
End
GO

If Exists (Select * From Sys.tables Where object_id= object_id('BC.TerritoryMap'))
Begin
	ALTER TABLE BC.TerritoryMap DROP CONSTRAINT FK_TerritoryMap_TradeMark
	ALTER TABLE BC.TerritoryMap DROP CONSTRAINT FK_TerritoryMap_TerritoryType
	ALTER TABLE BC.TerritoryMap DROP CONSTRAINT FK_TerritoryMap_ProductType
	ALTER TABLE BC.TerritoryMap DROP CONSTRAINT FK_TerritoryMap_County
	ALTER TABLE BC.TerritoryMap DROP CONSTRAINT FK_TerritoryMap_Bottler
End
GO

If Exists (Select * From Sys.tables Where object_id= object_id('BC.tBottlerTrademark'))
Begin
	ALTER TABLE BC.tBottlerTrademark DROP CONSTRAINT FK_tBottlerTrademark_TradeMark
	ALTER TABLE BC.tBottlerTrademark DROP CONSTRAINT FK_tBottlerTrademark_TerritoryType
	ALTER TABLE BC.tBottlerTrademark DROP CONSTRAINT FK_tBottlerTrademark_ProductType
	ALTER TABLE BC.tBottlerTrademark DROP CONSTRAINT FK_tBottlerTrademark_Bottler
End
GO

If Exists (Select * From Sys.tables Where object_id= object_id('BC.tBottlerTerritoryType'))
Begin
	ALTER TABLE BC.tBottlerTerritoryType DROP CONSTRAINT FK_tBottlerTerritoryType_TerritoryType
	ALTER TABLE BC.tBottlerTerritoryType DROP CONSTRAINT FK_tBottlerTerritoryType_ProductType
	ALTER TABLE BC.tBottlerTerritoryType DROP CONSTRAINT FK_tBottlerTerritoryType_Bottler
End
GO

If Exists (Select * From Sys.tables Where object_id= object_id('BC.tBottlerChainTradeMark'))
Begin
	ALTER TABLE BC.tBottlerChainTradeMark DROP CONSTRAINT FK_tBottlerChainTradeMark_TradeMark
	ALTER TABLE BC.tBottlerChainTradeMark DROP CONSTRAINT FK_tBottlerChainTradeMark_TerritoryType
	ALTER TABLE BC.tBottlerChainTradeMark DROP CONSTRAINT FK_tBottlerChainTradeMark_ProductType
	ALTER TABLE BC.tBottlerChainTradeMark DROP CONSTRAINT FK_tBottlerChainTradeMark_LocalChain
	ALTER TABLE BC.tBottlerChainTradeMark DROP CONSTRAINT FK_tBottlerChainTradeMark_Bottler
End
GO

If Exists (Select * From Sys.tables Where object_id= object_id('BC.System'))
Begin
	ALTER TABLE BC.System DROP CONSTRAINT FK_System_Country
End
GO

If Exists (Select * From Sys.tables Where object_id= object_id('BC.Region'))
Begin
	ALTER TABLE BC.Region DROP CONSTRAINT FK_Region_Division
End
GO

If Exists (Select * From Sys.tables Where object_id= object_id('BC.Division'))
Begin
	ALTER TABLE BC.Division DROP CONSTRAINT FK_Division_Zone
End
GO

If Exists (Select * From Sys.tables Where object_id= object_id('BC.Country'))
Begin
	ALTER TABLE BC.Country DROP CONSTRAINT FK_Country_TotalCompany
End
GO

If Exists (Select * From Sys.tables Where object_id= object_id('BC.Bottler'))
Begin
	ALTER TABLE BC.BottlerEB4 DROP CONSTRAINT FK_BottlerEB4_BottlerEB3
	ALTER TABLE BC.BottlerEB3 DROP CONSTRAINT FK_BottlerEB3_BottlerEB2
	ALTER TABLE BC.BottlerEB2 DROP CONSTRAINT FK_BottlerEB2_BottlerEB1
	ALTER TABLE BC.Bottler DROP CONSTRAINT FK_Bottler_Region
	ALTER TABLE BC.Bottler DROP CONSTRAINT FK_Bottler_FSRegion
	ALTER TABLE BC.Bottler DROP CONSTRAINT FK_Bottler_BottlerEB4
End
GO

If Exists (Select * From Sys.tables Where object_id= object_id('BC.AccountInclusion'))
Begin
	ALTER TABLE BC.AccountInclusion DROP CONSTRAINT FK_AccountInclusion_TradeMark
	ALTER TABLE BC.AccountInclusion DROP CONSTRAINT FK_AccountInclusion_TerritoryType
	ALTER TABLE BC.AccountInclusion DROP CONSTRAINT FK_AccountInclusion_ProductType
	ALTER TABLE BC.AccountInclusion DROP CONSTRAINT FK_AccountInclusion_County
	ALTER TABLE BC.AccountInclusion DROP CONSTRAINT FK_AccountInclusion_Bottler
	ALTER TABLE BC.AccountInclusion DROP CONSTRAINT FK_AccountInclusion_Account
End
Go

If Exists (Select * From Sys.tables Where object_id= object_id('Person.BCSalesAccountability'))
Begin
	DROP TABLE Person.BCSalesAccountability
End
GO

If Exists (Select * From Sys.tables Where object_id= object_id('Staging.BCRegion'))
Begin
	DROP TABLE Staging.BCvBottlerSalesHierachy
	DROP TABLE Staging.BCvBottlerExternalHierachy
	DROP TABLE Staging.BCTMap
	DROP TABLE Staging.BCStoreInclusion
	DROP TABLE Staging.BCStoreHier
	DROP TABLE Staging.BCStore
	DROP TABLE Staging.BCRegion
	DROP TABLE Staging.BCProduct2
	DROP TABLE Staging.BCProduct1
	DROP TABLE Staging.BCHierachyEmployee
	DROP TABLE Staging.BCCounty
	DROP TABLE Staging.BCBPAddress
	DROP TABLE Staging.BCBottlerHierachy
	DROP TABLE Staging.BCBottlerEmployee
	DROP TABLE Staging.BCBottler
End
GO

If Exists (Select * From Sys.tables Where object_id= object_id('Shared.StateRegion'))
Begin
	DROP TABLE Shared.StateRegion
	DROP TABLE Shared.County
	DROP TABLE Shared.Country
End
GO

If Exists (Select * From Sys.tables Where object_id= object_id('Processing.BCBottlerEBNodes'))
Begin
	DROP TABLE Processing.BottlerLEGLatestUpdatedDate
	DROP TABLE Processing.BCChainLastModified
	DROP TABLE Processing.BCBottlerEBNodes
End
Go

If Exists (Select * From Sys.tables Where object_id= object_id('ETL.BCDataLoadingLog'))
Begin
	DROP TABLE ETL.BCDataLoadingLog
	DROP TABLE ETL.BCAccountTerritoryMapRecreationLog
End
GO

If Exists (Select * From Sys.tables Where object_id= object_id('BC.Zone'))
Begin
	DROP TABLE BC.Zone
	DROP TABLE BC.TotalCompany
	DROP TABLE BC.TerritoryType
	DROP TABLE BC.TerritoryMap
	DROP TABLE BC.tBottlerTrademark
	DROP TABLE BC.tBottlerTerritoryType
	DROP TABLE BC.tBottlerChainTradeMark
	DROP TABLE BC.tBottlerMapping
	DROP TABLE BC.System
	DROP TABLE BC.Region
	DROP TABLE BC.ProductType
	DROP TABLE BC.GlobalStatus
	DROP TABLE BC.Division
	DROP TABLE BC.Country
	DROP TABLE BC.BottlerEB4
	DROP TABLE BC.BottlerEB3
	DROP TABLE BC.BottlerEB2
	DROP TABLE BC.BottlerEB1
	DROP TABLE BC.BottlerAccountTradeMark
	DROP TABLE BC.Bottler
	DROP TABLE BC.AccountInclusion
End
GO

If Exists (Select * From sys.schemas Where Name = 'BC')
Begin
	exec sp_executesql N'Drop Schema BC'
End
Go

If Exists (Select * From sys.schemas Where Name = 'Processing')
Begin
	exec sp_executesql N'Drop Schema Processing'
End
Go

----------------------------------------
--- Alter Account Table ----
----------------------------------------
If Exists (
Select *
From Sys.columns
Where Name = 'CapstoneLastModified'
And Object_id = object_id('SAP.Account'))
Begin

	Drop Index NC_Account_Capstone_CountyID_PostalCode
	On SAP.Account

	Alter Table SAP.Account
	Drop Column CountryCode 

	Alter Table SAP.Account
	Drop Column CapstoneLastModified 

	Alter Table SAP.Account
	Drop Column  InCapstone 

	Alter Table SAP.Account
	Drop Column  AddressLastModified

	Alter Table SAP.Account
	Drop Column  Format 

	Alter Table SAP.Account
	Drop Column  CountyID 

	Alter Table SAP.Account
	Drop Column  TDLinxID 

	Alter Table SAP.Account
	Drop Column  GeoSource 

	Alter Table SAP.Account
	Drop Column  GlobalActive 

	Alter Table SAP.Account
	Drop Column  CRMActive 

	Alter Table SAP.Account
	Alter Column Address varchar(50)

	Alter Table SAP.Account
	Drop Column TMPostalCode 

	Alter Table SAP.Account
	Drop Column GeoCodingNeeded 

	---------------------------------
	Alter Table SAP.TradeMark
	Drop Column IsCapstone 

	Drop Index UNC_TradeMark_SAPTradeMarkID
	On SAP.TradeMark
End
Go

If Exists (
Select *
From Sys.columns
Where Name = 'CapstoneLastModified'
And Object_id = object_id('SAP.NationalChain'))
Begin
	----------------------------------------
	--- Alter National Chain Table ----
	----------------------------------------
	Alter Table SAP.NationalChain
	Drop Column InCapstone 

	Alter Table SAP.NationalChain
	Drop Column CapstoneLastModified 

	Alter Table SAP.NationalChain
	Drop Column InBW 

	----------------------------------------
	--- Alter Regional Chain Table ----
	----------------------------------------
	Alter Table SAP.RegionalChain
	Drop Column InCapstone 

	Alter Table SAP.RegionalChain
	Drop Column CapstoneLastModified 

	Alter Table SAP.RegionalChain
	Drop Column InBW 

	----------------------------------------
	--- Alter Local Chain Table ----
	----------------------------------------
	Alter Table SAP.LocalChain
	Drop Column InCapstone 

	Alter Table SAP.LocalChain
	Drop Column CapstoneLastModified

	Alter Table SAP.LocalChain
	Drop Column InBW 

End
Go