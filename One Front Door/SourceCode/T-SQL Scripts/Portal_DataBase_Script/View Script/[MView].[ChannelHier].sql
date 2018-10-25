USE [Portal_Data]
GO

/****** Object:  View [MView].[ChannelHier]    Script Date: 3/21/2013 5:19:18 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create View [MView].[ChannelHier]
As
	Select sc.SuperChannelID, SAPSuperChannelID, SuperChannelName, ChannelID, SAPChannelID, ChannelName
	From SAP.Channel c
		Join SAP.SuperChannel sc on c.SuperChannelID = sc.SuperChannelID

GO


