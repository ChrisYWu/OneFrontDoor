USE [Portal_Data]
GO
/****** Object:  StoredProcedure [ETL].[pMergeViewTables]    Script Date: 7/1/2015 1:56:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

------------------------------------
------------------------------------
------------------------------------
ALTER Proc [ETL].[pMergeViewTables]
AS	
	Set NoCount On;

	----------------------------------------
	Merge BC.tBottlerTerritoryType As t
	Using 
		(Select Distinct a.BottlerID, a.TerritoryTypeID, tt.TerritoryTypeName, a.ProductTypeID
		From BC.BottlerAccountTradeMark a
		Join BC.TerritoryType tt on a.TerritoryTypeID = tt.TerritoryTypeID) input
		On t.BottlerID = input.BottlerID And t.TerritoryTypeID = input.TerritoryTypeID And t.ProductTypeID = input.ProductTypeID
	When Not Matched By Target Then
		Insert(BottlerID, TerritoryTypeID, TerritoryTypeName, ProductTypeID, LastModified)
		Values(input.BottlerID, input.TerritoryTypeID, input.TerritoryTypeName, input.ProductTypeID, GetDate())
	When Not matched By Source Then
		Delete;

	----------------------------------------
	Merge [BC].[tBottlerTrademark] As t
	Using 
		(	Select Distinct a.TerritoryTypeID, a.ProductTypeID, b.BottlerID, b.BCBottlerID, b.BottlerName, 
				t.TradeMarkID, t.SAPTradeMarkID, t.TradeMarkName 
			From BC.BottlerAccountTradeMark a
			Join BC.Bottler b on a.BottlerID = b.BottlerID
			Join SAP.TradeMark t on a.TradeMarkID = t.TradeMarkID) input
		On t.TerritoryTypeID = input.TerritoryTypeID And t.ProductTypeID = input.ProductTypeID And t.BottlerID = input.BottlerID And t.TradeMarkID = input.TradeMarkID
	When Not Matched By Target Then
		Insert(TerritoryTypeID, ProductTypeID, BottlerID, BCBottlerID, BottlerName, 
			   TradeMarkID, SAPTradeMarkID, TradeMarkName, LastModified)
		Values(input.TerritoryTypeID, input.ProductTypeID, input.BottlerID, input.BCBottlerID, input.BottlerName, 
			   input.TradeMarkID, input.SAPTradeMarkID, input.TradeMarkName, GetDate())
	When Not matched By Source Then
		Delete;

	---------------------------------------
	Merge BC.tBottlerChainTradeMark t
	Using
		(
			Select Distinct a.TerritoryTypeID, a.ProductTypeID, b.BottlerID, b.BCBottlerID, b.BottlerName, 
			t.TradeMarkID, t.SAPTradeMarkID, t.TradeMarkName, 
			l.LocalChainID, l.SAPLocalChainID, l.LocalChainName, 
			r.RegionalChainID, r.SAPRegionalChainID, r.RegionalChainName, 
			n.NationalChainID, n.SAPNationalChainID, n.NationalChainName 
			From BC.BottlerAccountTradeMark a
			Join SAP.LocalChain l on a.LocalChainID = l.LocalChainID
			Join SAP.RegionalChain r on r.RegionalChainID = l.RegionalChainID
			Join SAP.NationalChain n on r.NationalChainID = n.NationalChainID
			Join BC.Bottler b on a.BottlerID = b.BottlerID
			Join SAP.TradeMark t on a.TradeMarkID = t.TradeMarkID
		) input
		On t.TerritoryTypeID = input.TerritoryTypeID
			And t.ProductTypeID = input.ProductTypeID
			And t.BottlerID = input.BottlerID
			And t.TradeMarkID = input.TradeMarkID
			And t.LocalChainID = input.LocalChainID
	When Not Matched By Target Then
		Insert(TerritoryTypeID, ProductTypeID, BottlerID, BCBottlerID, BottlerName, 
			TradeMarkID, SAPTradeMarkID, TradeMarkName, 
			LocalChainID, SAPLocalChainID, LocalChainName, 
			RegionalChainID, SAPRegionalChainID, RegionalChainName, 
			NationalChainID, SAPNationalChainID, NationalChainName, LastModified)
		Values(input.TerritoryTypeID, input.ProductTypeID, input.BottlerID, input.BCBottlerID, input.BottlerName, 
			input.TradeMarkID, input.SAPTradeMarkID, input.TradeMarkName, 
			input.LocalChainID, input.SAPLocalChainID, input.LocalChainName, 
			input.RegionalChainID, input.SAPRegionalChainID, input.RegionalChainName, 
			input.NationalChainID, input.SAPNationalChainID, input.NationalChainName, GetDate())
	When Not matched By Source Then
		Delete;

	---------------------------------------------
	Truncate Table BC.tBottlerMapping;

	Insert Into BC.tBottlerMapping
	Select Distinct ServicingBottler.TradeMarkID, ServicingBottler.CountyID, ServicingBottler.PostalCode, RptgBottlerID, SvcgBottlerID
	From 
	(Select CountyID, PostalCode, BottlerID SvcgBottlerID, TradeMarkID 
	From BC.TerritoryMap
	Where TerritoryTypeID = 12
	And ProductTypeID = 1) ServicingBottler
	Join
	(Select CountyID, PostalCode, BottlerID RptgBottlerID, TradeMarkID 
	From BC.TerritoryMap
	Where TerritoryTypeID = 11
	And ProductTypeID = 1) ReportingBottler 
	on ServicingBottler.CountyID = ReportingBottler.CountyID 
		And ServicingBottler.PostalCode = ReportingBottler.PostalCode
		And ServicingBottler.TradeMarkID = ReportingBottler.TradeMarkID
	Where SvcgBottlerID <> RptgBottlerID

	---------------------------------------
	Merge BC.tRegionChainTradeMark t
	Using
		(
			Select Distinct a.TerritoryTypeID, a.ProductTypeID, b.BCRegionID RegionID, 
			t.TradeMarkID,
			l.LocalChainID,
			r.RegionalChainID,
			r.NationalChainID
			From BC.BottlerAccountTradeMark a
			Join SAP.LocalChain l on a.LocalChainID = l.LocalChainID
			Join SAP.RegionalChain r on r.RegionalChainID = l.RegionalChainID
			Join BC.Bottler b on a.BottlerID = b.BottlerID
			Join SAP.TradeMark t on a.TradeMarkID = t.TradeMarkID
			Where b.BCRegionID is not null
		) input
		On t.TerritoryTypeID = input.TerritoryTypeID
			And t.ProductTypeID = input.ProductTypeID
			And t.RegionID = input.RegionID
			And t.TradeMarkID = input.TradeMarkID
			And t.LocalChainID = input.LocalChainID
	When Not Matched By Target Then
		Insert(TerritoryTypeID, ProductTypeID, RegionID, 
			TradeMarkID, 
			LocalChainID, RegionalChainID, NationalChainID, LastModified)
		Values(input.TerritoryTypeID, input.ProductTypeID, input.RegionID, 
			input.TradeMarkID, 
			input.LocalChainID, 
			input.RegionalChainID,
			input.NationalChainID, SysDateTime())
	When Not matched By Source Then
		Delete;

