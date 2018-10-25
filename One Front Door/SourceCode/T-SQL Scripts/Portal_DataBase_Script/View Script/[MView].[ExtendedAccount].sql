USE [Portal_Data]
GO

/****** Object:  View [MView].[ExtendedAccount]    Script Date: 3/21/2013 5:20:38 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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


