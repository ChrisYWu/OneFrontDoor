Use Portal_Data
Go

PRINT N'Altering View [MView].[BrandHier]...';
GO
ALTER VIEW [MView].[BrandHier]
AS
SELECT SAPTradeMarkID
	,TradeMarkName
	,SAPBrandID
	,BrandName
	,t.TradeMarkID
	,BrandID
	,t.ProductLineID
FROM SAP.TradeMark t
JOIN SAP.Brand b ON t.TrademarkID = b.TrademarkID
WHERE SAPTradeMarkID <> '#'
	AND SAPTradeMarkID <> 'ZZZ'

GO

/****** Object:  View [MView].[LocationHier]    Script Date: 11/19/2014 5:49:00 PM ******/
SET ANSI_NULLS ON
GO
 
SET QUOTED_IDENTIFIER ON
GO
 
Alter VIEW [MView].[LocationHier]
AS
SELECT SAPAreaID
,AreaName
,area.AreaID
,BUName
,SPBUName
,SAPBUID
,RegionName
,SPRegionName
,SAPRegionID
,SAPBranchID
,BranchName
,SPBranchName
,bu.BUID
,a.RegionID
,b.BranchID
,b.Longitude as BLongitude
,b.Latitude as BLatitude
,a.Longitude as RLongitude
,a.Latitude as RLatitude
FROM SAP.BusinessUnit bu
JOIN SAP.Region a ON bu.BUID = a.BUID
JOIN SAP.Area area ON area.RegionID = a.RegionID
JOIN SAP.Branch b ON area.AreaID = b.AreaID 
 
GO
