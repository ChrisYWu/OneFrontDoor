USE [Portal_Data]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ETL].[pDViews]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ETL].[pDViews]
GO

CREATE PROCEDURE [ETL].[pDViews] 
AS
BEGIN
	--------------------------------------------
	Truncate Table [DView].[BUTrademark]

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
	Where SAPTradeMarkID <> 'ZZZ';
	
	--------------------------------------------	
	Truncate Table [DView].[BranchTradeMark]

	INSERT INTO [DView].[BranchTradeMark]
			   ([SAPBranchID]
			   ,[SAPBranchName]
			   ,[SAPTradeMarkID]
			   ,[TradeMarkName])
	Select Distinct SAPBranchID, BranchName, SAPTrademarkID, TradeMarkName
	From SAP.Material m
	Join MView.BrandHier b on m.BrandID = b.BrandID
	Join SAP.BranchMaterial bm on bm.MaterialID = m.MaterialID
	Join SAP.Branch br on bm.BranchID = br.BranchID;
	
	--------------------------------------------	
	Truncate Table [DView].[AreaTrademark]

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

	--------------------------------------------	
	Truncate Table DVIEW.TodayRouteAccount

	Insert DVIEW.TodayRouteAccount
	Select SequenceNumber AS StopSequence, 
		a.SAPAccountNumber, SAPRouteNumber, a.AccountName, a.Address, a.City, a.State, a.PostalCode, 
		nc.SPNationalChainName, ch.SAPNationalChainID, 
		ch.RegionalChainName, ch.SAPRegionalChainID, 
		ch.LocalChainName, ch.SAPLocalChainID, 
		c.SPChannelName, c.SAPChannelID, b.SAPBranchID, b.SPBranchName
	From SAP.RouteScheduleDetail rsd
		JOin SAP.RouteSchedule rs on rsd.RouteScheduleID = rs.RouteScheduleID
		Join SAP.Account a on rs.AccountID = a.AccountID
		Join SAP.Branch b on a.BranchID = b.BranchID
		Join SAP.SalesRoute sr on sr.RouteID = rs.RouteID
		Join MView.ChainHier ch on a.LocalChainID = ch.LocalChainID
		Join SAP.NationalChain nc on nc.NationalChainID = ch.NationalChainID
		Join SAP.Channel c on a.ChannelID = c.ChannelID
	Where DateDiff(Day, StartDate, GetDate()) % 28 = Day
		And sr.Active = 1
		And a.Active = 1

End

