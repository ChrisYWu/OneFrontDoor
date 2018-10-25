USE [Portal_Data]
GO

/****** Object:  UserDefinedFunction [MView].[udfGetAllAccoutsForRouteNumber] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MView].[udfGetAllAccoutsForRouteNumber]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [MView].[udfGetAllAccoutsForRouteNumber]
GO

USE [Portal_Data]
GO

/*
Select * 
From [MView].[udfGetAllAccoutsForRouteNumber](113201405)

*/


/****** Object:  UserDefinedFunction [MView].[udfGetAllAccoutsForRouteNumber] ******/
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

--Use Portal_DAta
--Go

--Create View MView.ChannelHier
--As
--	Select sc.SuperChannelID, SAPSuperChannelID, SuperChannelName, ChannelID, SAPChannelID, ChannelName
--	From SAP.Channel c
--		Join SAP.SuperChannel sc on c.SuperChannelID = sc.SuperChannelID
	


