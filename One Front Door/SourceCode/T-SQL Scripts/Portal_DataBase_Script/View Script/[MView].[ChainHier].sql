USE [Portal_Data]
GO

/****** Object:  View [MView].[ChainHier]    Script Date: 3/21/2013 5:18:10 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create View [MView].[ChainHier]
As
Select SAPNationalChainID, NationalChainName, SAPRegionalChainID, RegionalChainName, SAPLocalChainID, LocalChainName, lc.LocalChainID, rc.RegionalChainID, nc.NationalChainID
From SAP.LocalChain lc
	Join SAP.RegionalChain rc on lc.RegionalChainID = rc.RegionalChainID
	Join SAP.NationalChain nc on rc.NationalChainID = nc.NationalChainID

GO


