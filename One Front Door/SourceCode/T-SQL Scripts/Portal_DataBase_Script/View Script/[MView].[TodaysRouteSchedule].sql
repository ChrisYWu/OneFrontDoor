USE [Portal_Data]
GO

/****** Object:  View [MView].[TodaysRouteSchedule]    Script Date: 3/21/2013 5:26:56 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create View [MView].[TodaysRouteSchedule]
AS
Select sr.SAPRouteNumber, sr.RouteName, a.AccountName, ea.SAPBranchID, ea.BranchName, ea.AreaName, ea.BUName, ea.SPBranchName, 
		ea.SAPChannelID, ea.ChannelName, ea.SAPLocalChainID, ea.LocalChainName, ea.SAPRegionalChainID, 
		ea.RegionalChainName, ea.SAPNationalChainID, ea.NationalChainName
From SAP.RouteScheduleDetail rsd
	JOin SAP.RouteSchedule rs on rsd.RouteScheduleID = rs.RouteScheduleID
	Join SAP.Account a on rs.AccountID = a.AccountID
	Join SAP.SalesRoute sr on sr.RouteID = rs.RouteID
	Join MView.ExtendedAccount ea on rs.AccountID = ea.AccountID
Where DateDiff(Day, StartDate, GetDate()) % 28 = Day
	And SR.Active = 1

GO


