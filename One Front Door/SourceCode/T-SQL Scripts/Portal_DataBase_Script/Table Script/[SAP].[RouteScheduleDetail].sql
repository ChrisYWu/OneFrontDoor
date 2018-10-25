USE [Portal_Data]
GO

/****** Object:  Table [SAP].[RouteScheduleDetail]    Script Date: 3/21/2013 5:08:17 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [SAP].[RouteScheduleDetail](
	[RouteScheduleID] [int] NOT NULL,
	[Day] [int] NOT NULL,
	[SequenceNumber] [int] NOT NULL,
 CONSTRAINT [PK_RouteScheduleDetail] PRIMARY KEY CLUSTERED 
(
	[RouteScheduleID] ASC,
	[Day] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [SAP].[RouteScheduleDetail]  WITH CHECK ADD  CONSTRAINT [FK_RouteScheduleDetail_RouteSchedule] FOREIGN KEY([RouteScheduleID])
REFERENCES [SAP].[RouteSchedule] ([RouteScheduleID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [SAP].[RouteScheduleDetail] CHECK CONSTRAINT [FK_RouteScheduleDetail_RouteSchedule]
GO


