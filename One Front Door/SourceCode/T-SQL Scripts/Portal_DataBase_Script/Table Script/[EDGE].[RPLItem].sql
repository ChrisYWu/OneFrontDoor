USE [Portal_Data]
GO

/****** Object:  Table [EDGE].[RPLItem]    Script Date: 3/21/2013 4:12:31 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [EDGE].[RPLItem](
	[ItemID] [int] IDENTITY(1,1) NOT NULL,
	[ContentID] [varchar](50) NOT NULL,
	[Tittle] [varchar](128) NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[ExpirationDateUTC] [datetime] NULL,
	[ReferenceName] [varchar](128) NULL,
	[ProgramNumber] [int] NULL,
	[ProgramDetail] [varchar](512) NULL,
	[Price] [varchar](128) NULL,
	[DateMail] [datetime] NULL,
	[RouteToMarkets] [varchar](255) NULL,
	[BigBetsName] [varchar](255) NULL,
	[CostPerStore] [bit] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[ReceivedDate] [datetime] NOT NULL,
	[TestData] [bit] NULL,
 CONSTRAINT [PK_RPLItem] PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [EDGE].[RPLItem] ADD  CONSTRAINT [DF_RPLItem_LastModified]  DEFAULT (getdate()) FOR [ReceivedDate]
GO


