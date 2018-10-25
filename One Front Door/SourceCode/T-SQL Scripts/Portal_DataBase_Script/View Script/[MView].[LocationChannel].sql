USE [Portal_Data]
GO

/****** Object:  View [MView].[LocationChannel]    Script Date: 3/21/2013 5:22:56 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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


