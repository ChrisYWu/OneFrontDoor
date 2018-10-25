use Portal_Data805
Go

--Drop Table [BC].[tGSNRegion]
--Go

/****** Object:  Table [BC].[tGSNRegion]    Script Date: 7/27/2015 12:17:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

If Exists (Select * From sys.objects Where object_id = object_id('BC.tGSNRegion'))
	Drop Table BC.tGSNRegion
Go

CREATE TABLE [BC].[tGSNRegion](
	[GSN] [varchar](50) NOT NULL,
	[RegionID] [int] NOT NULL,
 CONSTRAINT [PK_tGSNRegion] PRIMARY KEY CLUSTERED 
(
	[GSN] ASC,
	[RegionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

--- This is the stuff the need to go into the MergeTTables ----
----------------------- 
Truncate Table BC.tGSNRegion
Go

Insert Into [BC].[tGSNRegion](GSN, RegionID)
Select Distinct GSN, RegionID
From(
Select GSN, RegionID
From [Person].[BCSalesAccountability] sa1
Where RegionID is not null
Union
Select GSN, h2.RegionID
From [Person].[BCSalesAccountability] sa2
Join BC.vBottlerSalesHier h2 on sa2.DivisionID = h2.DivisionID
Union
Select GSN, h3.RegionID
From [Person].[BCSalesAccountability] sa3
Join BC.vBottlerSalesHier h3 on sa3.ZoneID = h3.ZoneID
Union
Select GSN, h4.RegionID
From [Person].[BCSalesAccountability] sa4
Join BC.vBottlerSalesHier h4 on sa4.SystemID = h4.SystemID) t
Go

-----------------------------------
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
	Select ServicingBottler.TradeMarkID, ServicingBottler.CountyID, ServicingBottler.PostalCode, RptgBottlerID, SvcgBottlerID
	From 
	(Select CountyID, PostalCode, BottlerID SvcgBottlerID, TradeMarkID 
	From BC.TerritoryMap
	Where TerritoryTypeID = 12
	And ProductTypeID = 1 And GetDate() Between ValidFrom And ValidTo ) ServicingBottler
	Join
	(Select CountyID, PostalCode, BottlerID RptgBottlerID, TradeMarkID 
	From BC.TerritoryMap
	Where TerritoryTypeID = 11
	And ProductTypeID = 1 And GetDate() Between ValidFrom And ValidTo ) ReportingBottler 
	on ServicingBottler.CountyID = ReportingBottler.CountyID 
		And ServicingBottler.PostalCode = ReportingBottler.PostalCode
		And ServicingBottler.TradeMarkID = ReportingBottler.TradeMarkID
	Where SvcgBottlerID <> RptgBottlerID

	Truncate Table BC.tGSNRegion;

	---------------------------------------
	Insert Into [BC].[tGSNRegion](GSN, RegionID)
	Select Distinct GSN, RegionID
	From(
	Select GSN, RegionID
	From [Person].[BCSalesAccountability] sa1
	Where RegionID is not null
	Union
	Select GSN, h2.RegionID
	From [Person].[BCSalesAccountability] sa2
	Join BC.vBottlerSalesHier h2 on sa2.DivisionID = h2.DivisionID
	Union
	Select GSN, h3.RegionID
	From [Person].[BCSalesAccountability] sa3
	Join BC.vBottlerSalesHier h3 on sa3.ZoneID = h3.ZoneID
	Union
	Select GSN, h4.RegionID
	From [Person].[BCSalesAccountability] sa4
	Join BC.vBottlerSalesHier h4 on sa4.SystemID = h4.SystemID) t

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
Go
