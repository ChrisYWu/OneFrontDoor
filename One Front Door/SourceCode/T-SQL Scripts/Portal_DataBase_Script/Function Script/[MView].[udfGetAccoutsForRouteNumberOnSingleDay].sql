USE [Portal_Data]
GO

/****** Object:  UserDefinedFunction [MView].[udfGetAccoutsForRouteNumberOnSingleDay]    Script Date: 3/21/2013 5:32:20 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create Function [MView].[udfGetAccoutsForRouteNumberOnSingleDay]
(
	@SAPRouteNumber int,
	@InputDate Date
)
Returns Table
AS
Return
	Select ROW_NUMBER() OVER(ORDER BY SequenceNumber, AccountName) AS StopSequence, 
		a.AccountID, a.SAPAccountNumber, a.AccountName, a.Address, a.City, a.State, rsd.SequenceNumber
		,ch.*, c.*
	From SAP.RouteScheduleDetail rsd
		JOin SAP.RouteSchedule rs on rsd.RouteScheduleID = rs.RouteScheduleID
		Join SAP.Account a on rs.AccountID = a.AccountID
		Join SAP.SalesRoute sr on sr.RouteID = rs.RouteID
		Join MView.ChainHier ch on a.LocalChainID = ch.LocalChainID
		Join SAP.Channel c on a.ChannelID = c.ChannelID
	Where SAPRouteNumber = @SAPRouteNumber -- 113201405
		And DateDiff(Day, StartDate, @InputDate) % 28 = Day
		And sr.Active = 1
		And a.Active = 1

GO


