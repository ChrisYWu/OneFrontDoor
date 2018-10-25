USE [Portal_Data]
GO

/****** Object:  View [MView].[TodaysRouteChains]    Script Date: 3/21/2013 5:25:06 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create View [MView].[TodaysRouteChains]
AS
Select Distinct SAPRouteNumber, LocalChainName, RegionalChainName, NationalChainName
From MView.TodaysRouteSchedule

GO


