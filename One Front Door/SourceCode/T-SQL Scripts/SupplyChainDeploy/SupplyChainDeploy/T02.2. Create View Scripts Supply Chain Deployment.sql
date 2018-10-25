Use Portal_Data
Go

Print 'Creating Table [MView].[BranchProductLine]'
GO
-- view
CREATE VIEW [MView].[BranchProductLine]
AS
SELECT DISTINCT br.BranchID
	,b.SAPTradeMarkID
	,b.TradeMarkID
	,b.TradeMarkName
	,b.ProductLineID
	,PL.ProductLineName
FROM SAP.Material AS m
INNER JOIN MView.BrandHier AS b ON m.BrandID = b.BrandID
INNER JOIN SAP.BranchMaterial AS bm ON bm.MaterialID = m.MaterialID
INNER JOIN SAP.Branch AS br ON bm.BranchID = br.BranchID
INNER JOIN SAP.ProductLine PL ON PL.ProductLineID = b.ProductLineID
WHERE (b.SAPTradeMarkID <> 'ZZZ')
GO

PRINT N'Creating [MView].[ProductLineLocationChain]...';

GO
CREATE VIEW [MView].[ProductLineLocationChain]
AS
SELECT DISTINCT ch.SAPNationalChainID
	,ch.NationalChainName
	,ch.SAPRegionalChainID
	,ch.RegionalChainName
	,ch.SAPLocalChainID
	,ch.LocalChainName
	,ch.LocalChainID
	,ch.RegionalChainID
	,ch.NationalChainID
	,lh.BUName AS BU
	,lh.BUID AS BUID
	,lh.RegionName AS Region
	,lh.RegionID
	,lh.BranchName AS BranchName
	,lh.BranchID AS BranchID
	,lh.AreaID
	,lh.SAPAreaID
	,lh.AreaName
--,BProd.TradeMarkID  
--,BProd.ProductLineID  
FROM SAP.Account AS a
INNER JOIN SAP.Branch AS br ON br.BranchID = a.BranchID
INNER JOIN MView.ChainHier AS ch ON a.LocalChainID = ch.LocalChainID
INNER JOIN MView.LocationHier AS lh ON br.BranchID = lh.BranchID
	--INNER JOIN MView.BranchProductLine BProd ON a.BranchID = BProd.BranchID 
	--select * from [MView].[ProductLineLocationChain]
	
GO	

PRINT N'Creating [SupplyChain].[vRegionThreshold]...';

GO
/****** Object:  View [SupplyChain].[vRegionThreshold]   Script Date: 10/27/2014 10:03:28 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create View [SupplyChain].[vRegionThreshold]
As
Select r.RegionID
	   ,coalesce(rt.RegionOOSLeftThreshold, OAT.OverAllOOSLeftThreshold) as RegionOOSLeftThreshold
	   ,coalesce(rt.RegionOOSRightThreshold, OAT.OverAllOOSRightThreshold) as RegionOOSRightThreshold
	   ,coalesce(rt.RegionDOSLeftThreshold, OAT.OverAllDOSLeftThreshold) as RegionDOSLeftThreshold
	   ,coalesce(rt.RegionDOSRightThreshold, OAT.OverAllDOSRightThreshold) as RegionDOSRightThreshold
	   ,coalesce(rt.RegionMinMaxLeftThreshold, OAT.OverAllMinMaxLeftThreshold) as RegionMinMaxLeftThreshold
	   ,coalesce(rt.RegionMinMaxRightThreshold, OAT.OverAllMinMaxRightThreshold) as RegionMinMaxRightThreshold
		from SAP.Region as r 
		Inner Join SupplyChain.RegionThreshold as rt on r.RegionID = rt.RegionID
		Cross Join SupplyChain.OverAllThreshold as OAT
GO


/****** Object:  View [SupplyChain].[vBranchThreshold]    Script Date: 10/27/2014 10:03:28 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

PRINT N'Creating [SupplyChain].[vBranchThreshold]...';
Go

Create View [SupplyChain].[vBranchThreshold]
As
Select b.BranchID
	   ,coalesce(bt.BranchOOSLeftThreshold,rt.RegionOOSLeftThreshold, OAT.OverAllOOSLeftThreshold) as BranchOOSLeftThreshold
	   ,coalesce(bt.BranchOOSRightThreshold,rt.RegionOOSRightThreshold, OAT.OverAllOOSRightThreshold) as BranchOOSRightThreshold
	   ,coalesce(bt.BranchDOSLeftThreshold,rt.RegionDOSLeftThreshold, OAT.OverAllDOSLeftThreshold) as BranchDOSLeftThreshold
	   ,coalesce(bt.BranchDOSRightThreshold,rt.RegionDOSRightThreshold, OAT.OverAllDOSRightThreshold) as BranchDOSRightThreshold
	   ,coalesce(bt.BranchMinMaxLeftThreshold,rt.RegionMinMaxLeftThreshold, OAT.OverAllMinMaxLeftThreshold) as BranchMinMaxLeftThreshold
	   ,coalesce(bt.BranchMinMaxRightThreshold,rt.RegionMinMaxRightThreshold, OAT.OverAllMinMaxRightThreshold) as BranchMinMaxRightThreshold
		from MView.LocationHier as b 
		Left Outer Join SupplyChain.BranchThreshold as bt on b.BranchID = bt.BranchID
		Left Outer Join SupplyChain.RegionThreshold as rt on b.RegionID = rt.RegionID
		Cross Join SupplyChain.OverAllThreshold as OAT
GO


