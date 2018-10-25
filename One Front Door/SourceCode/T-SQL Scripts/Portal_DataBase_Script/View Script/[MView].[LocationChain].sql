USE [Portal_Data]
GO

/****** Object:  View [MView].[LocationChain]    Script Date: 3/21/2013 5:21:50 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



Create View [MView].[LocationChain]
AS
Select Distinct ch.*, lh.*
From SAP.Account a
Join SAP.Branch br on br.BranchID = a.BranchID
Join MView.ChainHier ch on a.LocalChainID = ch.LocalChainID
Join MView.LocationHier lh on br.BranchID = lh.BranchID
Where a.Active = 1

GO


