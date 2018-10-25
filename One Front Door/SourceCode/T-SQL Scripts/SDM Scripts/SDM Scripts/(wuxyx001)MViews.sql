-------------------------------------------------
-------------------------------------------------
-------------------------------------------------
-------------------------------------------------
USE [Portal_Data]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[MView].[ChainHier]'))
DROP VIEW [MView].[ChainHier]
GO

Create View [MView].[ChainHier]
As
Select SAPNationalChainID, NationalChainName, SAPRegionalChainID, RegionalChainName, SAPLocalChainID, LocalChainName, lc.LocalChainID, rc.RegionalChainID, nc.NationalChainID
From SAP.LocalChain lc
	Join SAP.RegionalChain rc on lc.RegionalChainID = rc.RegionalChainID
	Join SAP.NationalChain nc on rc.NationalChainID = nc.NationalChainID
GO

-------------------------------------------------
USE [Portal_Data]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[MView].[LocationHier]'))
DROP VIEW [MView].[LocationHier]
GO

Create View [MView].[LocationHier]
As
Select BUName, AreaName, SAPBranchID, BranchName, SPBranchName, bu.BUID, a.AreaID, b.BranchID
From SAP.BusinessUnit bu
	Join SAP.BusinessArea a on bu.BUID = a.BUID
	Join SAP.Branch b on a.AreaID = b.AreaID
GO

Select *
From [MView].[LocationHier]
Go

-------------------------------------------------
USE [Portal_Data]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[MView].[ExtendedAccount]'))
DROP VIEW [MView].[ExtendedAccount]
GO

Create View [MView].[ExtendedAccount]
As
Select a.SAPAccountNumber, a.AccountName, BUName, AreaName, SAPBranchID, BranchName, SPBranchName
		,SAPNationalChainID, NationalChainName, SAPRegionalChainID, RegionalChainName, SAPLocalChainID, LocalChainName, SAPChannelID, ChannelName
		,BUID, AreaID, a.BranchID, a.AccountID
		,ch.LocalChainID, ch.RegionalChainID, ch.NationalChainID, c.ChannelID
From SAP.Account a
	Join MView.LocationHier lh on a.BranchID = lh.BranchID
	Join MView.ChainHier ch on a.LocalChainID = ch.LocalChainID
	Join SAP.Channel c on a.ChannelID = c.ChannelID
Where a.Active = 1
GO

Select *
From [MView].[ExtendedAccount]
Go

-------------------------------------------------
USE [Portal_Data]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[MView].[BrandHier]'))
DROP VIEW [MView].[BrandHier]
GO

Create View [MView].[BrandHier]
AS
Select SAPTradeMarkID, TradeMarkName, SAPBrandID, BrandName, t.TradeMarkID, BrandID
From SAP.TradeMark t
Join SAP.Brand b on t.TrademarkID = b.TrademarkID
Where SAPTradeMarkID <> '#' And SAPTradeMarkID <> 'ZZZ' 
GO

Select *
From [MView].[BrandHier]
Go

-------------------------------------------------
USE [Portal_Data]
GO

Truncate Table [DView].[BranchTradeMark]
Go

INSERT INTO [DView].[BranchTradeMark]
           ([SAPBranchID]
           ,[SAPBranchName]
           ,[SAPTradeMarkID]
           ,[TradeMarkName])
Select Distinct SAPBranchID, BranchName, SAPTrademarkID, TradeMarkName
From SAP.Material m
Join MView.BrandHier b on m.BrandID = b.BrandID
Join SAP.BranchMaterial bm on bm.MaterialID = m.MaterialID
Join SAP.Branch br on bm.BranchID = br.BranchID
GO

-------------------------------------------------
Truncate Table [DView].[BranchTradeMark]
Go

INSERT INTO [DView].[BranchTradeMark]
           ([SAPBranchID]
           ,[SAPBranchName]
           ,[SAPTradeMarkID]
           ,[TradeMarkName])
Select Distinct SAPBranchID, BranchName, SAPTrademarkID, TradeMarkName
From SAP.Material m
Join MView.BrandHier b on m.BrandID = b.BrandID
Join SAP.BranchMaterial bm on bm.MaterialID = m.MaterialID
Join SAP.Branch br on bm.BranchID = br.BranchID
Where SAPTradeMarkID <> 'ZZZ'
GO

Select *
From [DView].[BranchTradeMark]
Go

-------------------------------------------------
Truncate Table [DView].[AreaTrademark]
Go

INSERT INTO [DView].[AreaTrademark]
           ([SAPAreaID]
           ,[AreaName]
           ,[SAPTrademarkID]
           ,[TrademarkName])
Select Distinct SAPAreaID, AreaName, SAPTrademarkID, TradeMarkName
From SAP.Material m
Join MView.BrandHier b on m.BrandID = b.BrandID
Join SAP.BranchMaterial bm on bm.MaterialID = m.MaterialID
Join SAP.Branch br on bm.BranchID = br.BranchID
Join SAP.BusinessArea a on a.AreaID = br.AreaID
Where SAPTradeMarkID <> 'ZZZ'
GO

Select *
From [DView].[AreaTrademark]
Go

-------------------------------------------------
USE [Portal_Data]
GO

Truncate Table [DView].[BUTrademark]
Go

INSERT INTO [DView].[BUTrademark]
           ([BUName]
           ,[SAPTrademarkID]
           ,[TrademarkName])
Select Distinct BUName, SAPTrademarkID, TradeMarkName
From SAP.Material m
Join MView.BrandHier b on m.BrandID = b.BrandID
Join SAP.BranchMaterial bm on bm.MaterialID = m.MaterialID
Join SAP.Branch br on bm.BranchID = br.BranchID
Join SAP.BusinessArea a on a.AreaID = br.AreaID
Join SAP.BusinessUnit bu on bu.BUID = a.BUID
Where SAPTradeMarkID <> 'ZZZ'
GO

Select *
From [DView].[BUTrademark]
Go

-------------------------------------------------
USE [Portal_Data]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[MView].[TodaysRouteSchedule]'))
DROP VIEW [MView].TodaysRouteSchedule
GO

Create View MView.TodaysRouteSchedule
AS
Select sr.SAPRouteNumber, sr.RouteName, a.AccountName, ea.SAPBranchID, ea.BranchName, ea.AreaName, ea.BUName, ea.SPBranchName, 
		ea.SAPChannelID, ea.ChannelName, ea.SAPLocalChainID, ea.LocalChainName, ea.SAPRegionalChainID, 
		ea.RegionalChainName, ea.SAPNationalChainID, ea.NationalChainName
From SAP.RouteScheduleDetail rsd
	JOin SAP.RouteSchedule rs on rsd.RouteScheduleID = rs.RouteScheduleID
	Join SAP.Account a on rs.AccountID = a.AccountID
	Join SAP.SalesRoute sr on sr.RouteID = rs.RouteID
	Join MView.ExtendedAccount ea on rs.AccountID = ea.AccountID
Where DateDiff(Day, StartDate, GetDate()) % 28 = Day
	And SR.Active = 1
Go

Select *
From MView.TodaysRouteSchedule
Where SAPRouteNumber = 113201405

-------------------------------------------------
USE [Portal_Data]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[MView].[TodaysRouteChannel]'))
DROP VIEW [MView].TodaysRouteChannel
GO

Create View MView.TodaysRouteChannel
AS
Select Distinct SAPRouteNumber, SAPChannelID, ChannelName
From MView.TodaysRouteSchedule
Go

Select *
From MView.TodaysRouteChannel
Where SAPRouteNumber = 113201405
Go

-------------------------------------------------
USE [Portal_Data]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[MView].[TodaysRouteChains]'))
DROP VIEW [MView].TodaysRouteChains
GO

Create View MView.TodaysRouteChains
AS
Select Distinct SAPRouteNumber, LocalChainName, RegionalChainName, NationalChainName
From MView.TodaysRouteSchedule
Go

Select *
From MView.TodaysRouteChains
Where SAPRouteNumber = 113201405

-------------------------------------------------

Use Portal_Data
Go

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[MView].[BranchRoute]'))
DROP VIEW [MView].BranchRoute
GO

Create View MView.BranchRoute
As
Select b.*, sr.RouteID, sr.SAPRouteNumber, sr.RouteName
From SAP.Branch b 
	Join SAP.SalesRoute sr on b.BranchID = sr.BranchID
Go








