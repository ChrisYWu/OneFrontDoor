USE [Portal_Data]
GO

/****** Object:  UserDefinedFunction [MView].[udfGetAccoutsForRouteNumberWithDateRange]    Script Date: 3/21/2013 5:33:16 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create Function [MView].[udfGetAccoutsForRouteNumberWithDateRange]
(
	@SAPRouteNumber int,
	@StartDate Date,
	@EndDate Date
)
Returns @retval Table
(
	AccountID int,
	SAPAccountNumber int,
	AccountName varchar(50),
	Day int,
	SequenceNumber int
)
AS
Begin
	If @StartDate > @EndDate
	Begin
		Insert Into @retval
		Select 0, 0, 'Date Range Wrong', 0, 0
	End
	
	If (DATEDIFF(Day, @StartDate, @EndDate) > 27)
	Begin
		Insert Into @retval
		Select a.AccountID, a.SAPAccountNumber, a.AccountName, Day, SequenceNumber
		From SAP.RouteScheduleDetail rsd
			JOin SAP.RouteSchedule rs on rsd.RouteScheduleID = rs.RouteScheduleID
			Join SAP.Account a on rs.AccountID = a.AccountID
			Join SAP.SalesRoute sr on sr.RouteID = rs.RouteID
		Where SAPRouteNumber = @SAPRouteNumber	
		And SR.Active = 1
		And a.Active = 1
	End
	
	Declare @StartOffSet int
	Declare @EndOffSet int
	Set @StartOffSet  = (DateDiff(Day, @StartDate, GetDate())) % 28 
	Set @EndOffSet  = (DateDiff(Day, @EndDate, GetDate())) % 28 

	If @EndOffSet < @StartOffSet
	Begin
		Insert Into @retval
		Select a.AccountID, a.SAPAccountNumber, a.AccountName, Day, SequenceNumber
		From SAP.RouteScheduleDetail rsd
			JOin SAP.RouteSchedule rs on rsd.RouteScheduleID = rs.RouteScheduleID
			Join SAP.Account a on rs.AccountID = a.AccountID
			Join SAP.SalesRoute sr on sr.RouteID = rs.RouteID
		Where SAPRouteNumber = @SAPRouteNumber
		And 
		(  (Day Between @StartOffSet And 28)
		Or (Day Between 1 And @EndOffSet))
		And SR.Active = 1
		And a.Active = 1
	End
	Else
	Begin
		Insert Into @retval
		Select a.AccountID, a.SAPAccountNumber, a.AccountName, Day, SequenceNumber
		From SAP.RouteScheduleDetail rsd
			JOin SAP.RouteSchedule rs on rsd.RouteScheduleID = rs.RouteScheduleID
			Join SAP.Account a on rs.AccountID = a.AccountID
			Join SAP.SalesRoute sr on sr.RouteID = rs.RouteID
		Where SAPRouteNumber = @SAPRouteNumber
		And Day Between @StartOffSet And @EndOffSet
		And SR.Active = 1
		And a.Active = 1
	End
	
	Return
End

GO


