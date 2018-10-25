USE [Portal_Data]
GO

/****** Object:  View [MView].[TodaysRouteChannel]    Script Date: 3/21/2013 5:25:50 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create View [MView].[TodaysRouteChannel]
AS
Select Distinct SAPRouteNumber, SAPChannelID, ChannelName
From MView.TodaysRouteSchedule

GO


