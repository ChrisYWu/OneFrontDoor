USE [Portal_Data]
GO

/****** Object:  UserDefinedFunction [MView].[udfGetAllAccoutsForRouteNumber]    Script Date: 3/21/2013 5:34:07 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create Function [MView].[udfGetAllAccoutsForRouteNumber]
(
	@SAPRouteNumber int
)
Returns Table
AS
Return
	Select Distinct a.AccountID, a.SAPAccountNumber, a.AccountName, lh.*, chh.*, c.*, a.Longitude, a.Latitude
	From SAP.RouteScheduleDetail rsd
		JOin SAP.RouteSchedule rs on rsd.RouteScheduleID = rs.RouteScheduleID
		Join SAP.Account a on rs.AccountID = a.AccountID
		Join SAP.SalesRoute sr on sr.RouteID = rs.RouteID
		Join Mview.LocationHier lh on a.BranchID = lh.BranchID
		Join MView.ChannelHier chh on a.ChannelID = chh.ChannelID
		Join MView.ChainHier c on a.LocalChainID = c.LocalChainID
	Where SAPRouteNumber = @SAPRouteNumber -- 113201405
	And sr.Active = 1
	And a.Active = 1


GO


