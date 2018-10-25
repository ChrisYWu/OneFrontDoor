USE [Portal_Data]
GO

/****** Object:  View [MView].[LocationHier]    Script Date: 3/21/2013 5:23:34 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create View [MView].[LocationHier]
As
Select BUName, AreaName, SAPBranchID, BranchName, SPBranchName, bu.BUID, a.AreaID, b.BranchID
From SAP.BusinessUnit bu
	Join SAP.BusinessArea a on bu.BUID = a.BUID
	Join SAP.Branch b on a.AreaID = b.AreaID

GO


