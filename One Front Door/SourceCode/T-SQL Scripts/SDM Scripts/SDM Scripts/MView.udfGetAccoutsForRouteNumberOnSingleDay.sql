USE [Portal_Data]
GO

/****** Object:  UserDefinedFunction [MView].[udfGetAccoutsForRouteNumberOnSingleDay] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MView].[udfGetAccoutsForRouteNumberOnSingleDay]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [MView].[udfGetAccoutsForRouteNumberOnSingleDay]
GO

USE [Portal_Data]
GO

/*
Select * 
From [MView].[udfGetAccoutsForRouteNumberOnSingleDay](113201405, GetDate())

*/


/****** Object:  UserDefinedFunction [MView].[udfGetAccoutsForRouteNumberOnSingleDay] ******/
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

-------------------------------------------------

Use Portal_Data
Go

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[MView].[AccountActiveRouteSchedule]'))
DROP VIEW [MView].AccountActiveRouteSchedule
GO

Create View MView.AccountActiveRouteSchedule
As
	Select ROW_NUMBER() OVER(ORDER BY SequenceNumber, AccountName) AS StopSequence, rsd.Day, rs.StartDate, SAPRouteNumber
		,a.AccountID, a.SAPAccountNumber, a.AccountName, a.Address, a.City, a.State, rsd.SequenceNumber
		,ch.*, c.*
	From SAP.RouteScheduleDetail rsd
		JOin SAP.RouteSchedule rs on rsd.RouteScheduleID = rs.RouteScheduleID
		Join SAP.Account a on rs.AccountID = a.AccountID
		Join SAP.SalesRoute sr on sr.RouteID = rs.RouteID
		Join MView.ChainHier ch on a.LocalChainID = ch.LocalChainID
		Join SAP.Channel c on a.ChannelID = c.ChannelID
	Where sr.Active = 1 And a.Active = 1
	And a.BranchID = 120
	Order By SAPRouteNumber
Go

Select top 1 *
From MView.AccountActiveRouteSchedule

Select StartDAte, Count(*)
From SAP.RouteSchedule rs
Group By StartDAte

