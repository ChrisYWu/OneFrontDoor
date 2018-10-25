USE [Portal_Data]
GO

/****** Object:  Table [EDGE].[RPLItemNAE]    Script Date: 3/21/2013 4:16:12 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [EDGE].[RPLItemNAE](
	[ItemID] [int] NOT NULL,
	[ContentID] [varchar](50) NULL,
	[FirstName] [varchar](128) NULL,
	[LastName] [varchar](128) NULL,
	[Email] [varchar](255) NULL,
	[GSN] [varchar](20) NULL,
	[TestData] [bit] NULL,
 CONSTRAINT [PK_RPLItemNAE] PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [EDGE].[RPLItemNAE]  WITH CHECK ADD  CONSTRAINT [FK_RPLItemNAE_RPLItem] FOREIGN KEY([ItemID])
REFERENCES [EDGE].[RPLItem] ([ItemID])
GO

ALTER TABLE [EDGE].[RPLItemNAE] CHECK CONSTRAINT [FK_RPLItemNAE_RPLItem]
GO

