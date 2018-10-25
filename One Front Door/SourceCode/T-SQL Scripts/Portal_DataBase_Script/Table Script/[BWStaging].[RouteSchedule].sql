USE [Portal_Data]
GO

/****** Object:  Table [BWStaging].[RouteSchedule]    Script Date: 3/21/2013 4:05:10 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [BWStaging].[RouteSchedule](
	[ROUTE_NUMBER] [int] NULL,
	[CUSTOMER_NUMBER] [int] NULL,
	[LOCATION_ID] [int] NULL,
	[FREQUENCY] [char](1) NULL,
	[START_DATE] [date] NULL,
	[DEFAULT_DELIV_ROUTE] [int] NULL,
	[SEQUENCE_NUMBER] [char](84) NULL,
	[SEASONAL] [bit] NULL,
	[SEASONAL_START_DATE] [date] NULL,
	[SEASONAL_END_DATE] [date] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


