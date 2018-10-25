USE [Portal_Data]
GO

/****** Object:  View [MView].[BranchRoute]    Script Date: 3/21/2013 5:16:20 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create View [MView].[BranchRoute]
As
Select b.*, sr.RouteID, sr.SAPRouteNumber, sr.RouteName
From SAP.Branch b 
	Join SAP.SalesRoute sr on b.BranchID = sr.BranchID

GO


