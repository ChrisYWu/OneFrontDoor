USE [Portal_Data]
GO

/****** Object:  Table [EDGE].[RPLItemChannel]    Script Date: 3/21/2013 4:15:21 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [EDGE].[RPLItemChannel](
	[ItemID] [int] NOT NULL,
	[ContentID] [varchar](50) NULL,
	[SAPSupperChannelID] [varchar](50) NULL,
	[SAPChannelID] [varchar](50) NULL,
	[ChannelName] [varchar](50) NOT NULL,
	[TestData] [bit] NULL,
 CONSTRAINT [PK_RPLItemChannel] PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [EDGE].[RPLItemChannel]  WITH CHECK ADD  CONSTRAINT [FK_RPLItemChannel_RPLItem] FOREIGN KEY([ItemID])
REFERENCES [EDGE].[RPLItem] ([ItemID])
GO

ALTER TABLE [EDGE].[RPLItemChannel] CHECK CONSTRAINT [FK_RPLItemChannel_RPLItem]
GO


