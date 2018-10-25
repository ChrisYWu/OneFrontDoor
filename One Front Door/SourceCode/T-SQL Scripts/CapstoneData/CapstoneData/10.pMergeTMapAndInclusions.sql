use Portal_Data_SREINT
Go

If Exists (Select * From Sys.procedures Where Object_ID = Object_ID('ETL.pMergeTMapAndInclusions'))
Begin
	Drop Proc ETL.pMergeTMapAndInclusions
End
Go

SET QUOTED_IDENTIFIER ON
GO

/*
Truncate Table BC.TerritoryMap 

exec ETL.pMergeTMapAndInclusions 

*/

Create Proc [ETL].[pMergeTMapAndInclusions]
AS		
	Set NoCount On;
	Declare @LogID int;
	Declare @RecreationLogID int
	INSERT INTO ETL.BCAccountTerritoryMapRecreationLog([StartTime]) Values (GetDate())
	Select @RecreationLogID = SCOPE_IDENTITY()

	-----------------------------------------
	--- Flag the inactive ones --------------
	Merge BC.TerritoryMap tm
	Using (
		Select tm.TradeMarkID, p.ProductTypeID, m.TerritoryTypeID, c.CountyID, map.POSTAL_CODE, b.BottlerID 
		From Staging.BCTmap map
		Join BC.TerritoryType m on m.BCTerritoryTypeID = map.TERR_VW_ID
		Join BC.ProductType p on p.BCProducTypeID = map.PROD_TYPE_ID
		Join SAP.TradeMark tm on tm.SAPTradeMarkID = map.TRADEMARK_ID
		Join Shared.County c on map.CNTRY_CODE = c.BCCountryCode And map.REGION_FIPS = c.BCRegionFIPS And map.CNTY_FIPS = c.BCCountyFIPS
		Join BC.Bottler b on map.BTTLR_ID = b.BCBottlerID 
		Where GetDate() Not Between map.VLD_FROM_DT And map.VLD_TO_DT) Input 
		On tm.TradeMarkID = input.TradeMarkID
		And tm.ProductTypeID = input.ProductTypeID
		And tm.TerritoryTypeID = input.TerritoryTypeID
		And tm.CountyID = input.CountyID
		And tm.PostalCode = input.POSTAL_CODE
		And tm.BottlerID = input.BottlerID
	WHEN MATCHED THEN
		Delete;

	---------------------------------------------------
	---- Merge valid TerritoryMap ---------------------
	Merge BC.TerritoryMap tm
	Using (
		Select tm.TradeMarkID, p.ProductTypeID, m.TerritoryTypeID, c.CountyID, map.POSTAL_CODE, b.BottlerID 
		From Staging.BCTmap map
		Join BC.TerritoryType m on m.BCTerritoryTypeID = map.TERR_VW_ID
		Join BC.ProductType p on p.BCProducTypeID = map.PROD_TYPE_ID
		Join SAP.TradeMark tm on tm.SAPTradeMarkID = map.TRADEMARK_ID
		Join Shared.County c on map.CNTRY_CODE = c.BCCountryCode And map.REGION_FIPS = c.BCRegionFIPS And map.CNTY_FIPS = c.BCCountyFIPS
		Join BC.Bottler b on map.BTTLR_ID = b.BCBottlerID 
		Where GetDate() Between map.VLD_FROM_DT And map.VLD_TO_DT) Input 
		On tm.TradeMarkID = input.TradeMarkID
		And tm.ProductTypeID = input.ProductTypeID
		And tm.TerritoryTypeID = input.TerritoryTypeID
		And tm.CountyID = input.CountyID
		And tm.PostalCode = input.POSTAL_CODE
		And tm.BottlerID = input.BottlerID
	WHEN NOT MATCHED By Target THEN
		Insert(TradeMarkID, ProductTypeID, TerritoryTypeID, CountyID, PostalCode, BottlerID)
		Values(input.TradeMarkID, input.ProductTypeID, input.TerritoryTypeID, input.CountyID, input.POSTAL_CODE, input.BottlerID);

	--@@@--
	Select @LogID = Max(LogID)
	From ETL.BCDataLoadingLog
	Where SchemaName = 'Staging' 
	And TableName = 'BCTmap'

	Update ETL.BCDataLoadingLog

	Set MergeDate = GetDate()
	Where  LogID = @LogID

	Update ETL.BCAccountTerritoryMapRecreationLog
	Set MergeTMapCompleteOffset = DATEDIFF(SECOND, StartTime, GetDate())
	Where LogID = @RecreationLogID

	---------------------------------------------
	---- AccountInclusion -----------------------
	--- Flag the inactive ones ------------------
	Merge BC.AccountInclusion tm
	Using (
		Select tm.TradeMarkID, p.ProductTypeID, m.TerritoryTypeID, c.CountyID, map.INCL_FOR_POSTAL_CODE PostalCode, b.BottlerID, a.AccountID
		From Staging.BCStoreInclusion map
		Join BC.TerritoryType m on m.BCTerritoryTypeID = map.TERR_VW_ID
		Join BC.ProductType p on p.BCProducTypeID = map.PROD_TYPE_ID
		Join SAP.TradeMark tm on tm.SAPTradeMarkID = map.TRADEMARK_ID
		Join Shared.County c on map.CNTRY_CODE = c.BCCountryCode And map.REGION_FIPS = c.BCRegionFIPS And map.CNTY_FIPS = c.BCCountyFIPS
		Join BC.Bottler b on map.BTTLR_ID = b.BCBottlerID
		Join SAP.Account a on map.STR_ID = a.SAPAccountNumber 
		Where [STTS_ID] <> 6  Or GetDate() Not Between [VLD_FRM_DT] And [VLD_TO_DT]) Input 
		On tm.TradeMarkID = input.TradeMarkID
		And tm.ProductTypeID = input.ProductTypeID
		And tm.TerritoryTypeID = input.TerritoryTypeID
		And tm.CountyID = input.CountyID
		And tm.PostalCode = input.PostalCode
		And tm.BottlerID = input.BottlerID
		And tm.AccountID = input.AccountID
	WHEN MATCHED THEN
		Delete;

	--- Insert the new ones ----------------------
	Merge BC.AccountInclusion tm
	Using (
		Select tm.TradeMarkID, p.ProductTypeID, m.TerritoryTypeID, c.CountyID, map.INCL_FOR_POSTAL_CODE PostalCode, b.BottlerID, a.AccountID
		From Staging.BCStoreInclusion map
		Join BC.TerritoryType m on m.BCTerritoryTypeID = map.TERR_VW_ID
		Join BC.ProductType p on p.BCProducTypeID = map.PROD_TYPE_ID
		Join SAP.TradeMark tm on tm.SAPTradeMarkID = map.TRADEMARK_ID
		Join Shared.County c on map.CNTRY_CODE = c.BCCountryCode And map.REGION_FIPS = c.BCRegionFIPS And map.CNTY_FIPS = c.BCCountyFIPS
		Join BC.Bottler b on map.BTTLR_ID = b.BCBottlerID
		Join SAP.Account a on map.STR_ID = a.SAPAccountNumber
		And [STTS_ID] = 6 And GetDate() Between [VLD_FRM_DT] And [VLD_TO_DT]) Input 
		On tm.TradeMarkID = input.TradeMarkID
		And tm.ProductTypeID = input.ProductTypeID
		And tm.TerritoryTypeID = input.TerritoryTypeID
		And tm.CountyID = input.CountyID
		And tm.PostalCode = input.PostalCode
		And tm.BottlerID = input.BottlerID
		And tm.AccountID = input.AccountID
	WHEN NOT MATCHED By Target THEN
		Insert(TradeMarkID, ProductTypeID, TerritoryTypeID, CountyID, PostalCode, BottlerID, AccountID)
		Values(input.TradeMarkID, input.ProductTypeID, input.TerritoryTypeID, input.CountyID, input.PostalCode, input.BottlerID, input.AccountID);

	--@@@--
	Select @LogID = Max(LogID)
	From ETL.BCDataLoadingLog
	Where SchemaName = 'Staging' 
	And TableName = 'BCStoreInclusion'

	Update ETL.BCDataLoadingLog
	Set MergeDate = GetDate()
	Where  LogID = @LogID

	Update ETL.BCAccountTerritoryMapRecreationLog
	Set MergeAccountInclusionCompleteOffset = DATEDIFF(SECOND, StartTime, GetDate())
	Where LogID = @RecreationLogID

	-----------------------------------------------
	------ Calculate the store level map ----------
	Truncate Table BC.BottlerAccountTradeMark;

	--- 4 minutes to load with no non-clustered indexes--
	Insert Into BC.BottlerAccountTradeMark
	Select *
	From 
	(
		Select Distinct map.TerritoryTypeID, map.ProductTypeID, 0 IsStoreInclusion, map.BottlerID, map.TradeMarkID, a.AccountID, a.LocalChainID, a.ChannelID, a.BranchID
		From BC.TerritoryMap map
		Join SAP.Account a on map.PostalCode = a.TMPostalCode and map.CountyID = a.CountyID
		Where a.InCapstone = 1
		And a.CRMActive = 1
		Union
		Select Distinct inc.TerritoryTypeID, inc.ProductTypeID, 1 IsStoreInclusion, inc.BottlerID, inc.TradeMarkID, a.AccountID, a.LocalChainID, a.ChannelID, a.BranchID
		From BC.AccountInclusion inc
		Join SAP.Account a on inc.AccountID = a.AccountID
		Where a.InCapstone = 1
		And a.CRMActive = 1
	) tm

	-- 2s to delete the confliting rows -- 
	-- Need to throtlle the flow from the source, so I don't have to filter it here - 
	Update ETL.BCAccountTerritoryMapRecreationLog
	Set ProcessBottlerAccountTradeMarkCompleteOffset = DATEDIFF(SECOND, StartTime, GetDate())
	Where LogID = @RecreationLogID

	Delete map
	From (Select * From BC.BottlerAccountTradeMark map Where IsStoreInclusion = 0) map
	Join (Select * From BC.BottlerAccountTradeMark map Where IsStoreInclusion = 1) inc 
		on map.AccountID = inc.AccountID 
		And map.TradeMarkID = inc.TradeMarkID 
		And map.ProductTypeID = inc.ProductTypeID
		And map.TerritoryTypeID = inc.TerritoryTypeID

	Update ETL.BCAccountTerritoryMapRecreationLog
	Set ProcessInclusionCompleteOffset = DATEDIFF(SECOND, StartTime, GetDate())
	Where LogID = @RecreationLogID

Go