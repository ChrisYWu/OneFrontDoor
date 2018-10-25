USE [Portal_Data]
GO

/****** Object:  Table [SAP].[RouteSchedule]    Script Date: 3/21/2013 5:07:30 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [SAP].[RouteSchedule](
	[RouteScheduleID] [int] IDENTITY(1,1) NOT NULL,
	[AccountID] [int] NOT NULL,
	[RouteID] [int] NOT NULL,
	[StartDate] [date] NOT NULL,
 CONSTRAINT [PK_RouteSchedule_1] PRIMARY KEY CLUSTERED 
(
	[RouteScheduleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


