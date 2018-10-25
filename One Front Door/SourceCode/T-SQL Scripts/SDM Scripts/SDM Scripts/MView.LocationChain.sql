USE [Portal_Data]
GO
----------------------------------------------------
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[MView].[LocationChain]'))
DROP VIEW [MView].[LocationChain]
GO

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

----------------------------------------------------
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[MView].[LocationChannel]'))
DROP VIEW [MView].[LocationChannel]
GO

Create View [MView].[LocationChannel]
AS
Select Distinct ch.*, lh.*
From SAP.Account a
Join SAP.Branch br on br.BranchID = a.BranchID
Join SAP.Channel ch on a.ChannelID = ch.ChannelID
Join MView.LocationHier lh on br.BranchID = lh.BranchID
Where a.Active = 1
GO
