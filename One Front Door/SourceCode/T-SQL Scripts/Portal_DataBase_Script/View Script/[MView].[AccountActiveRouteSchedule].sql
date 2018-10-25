USE [Portal_Data]
GO

/****** Object:  View [MView].[AccountActiveRouteSchedule]    Script Date: 3/21/2013 5:13:53 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



Create View [MView].[AccountActiveRouteSchedule]
As
	Select SequenceNumber AS StopSequence, Day, b.BranchID, 
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
	Where sr.Active = 1
		And a.Active = 1


GO


