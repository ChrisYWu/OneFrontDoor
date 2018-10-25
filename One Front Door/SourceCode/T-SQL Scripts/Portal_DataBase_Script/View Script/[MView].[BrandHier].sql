USE [Portal_Data]
GO

/****** Object:  View [MView].[BrandHier]    Script Date: 3/21/2013 5:17:10 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create View [MView].[BrandHier]
AS
Select SAPTradeMarkID, TradeMarkName, SAPBrandID, BrandName, t.TradeMarkID, BrandID
From SAP.TradeMark t
Join SAP.Brand b on t.TrademarkID = b.TrademarkID
Where SAPTradeMarkID <> '#' And SAPTradeMarkID <> 'ZZZ' 

GO


