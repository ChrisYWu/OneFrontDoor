USE [Portal_Data]
GO

/****** Object:  Table [EDGE].[RPLItemAccount]    Script Date: 3/21/2013 4:13:40 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [EDGE].[RPLItemAccount](
	[ItemID] [int] NOT NULL,
	[ContentID] [varchar](50) NULL,
	[SAPNationalChainID] [varchar](50) NULL,
	[SAPRegionalChainID] [varchar](50) NULL,
	[SAPLocalChainID] [varchar](50) NULL,
	[AccountName] [varchar](50) NOT NULL,
	[TestData] [bit] NULL,
 CONSTRAINT [PK_RPLItemAccount] PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [EDGE].[RPLItemAccount]  WITH CHECK ADD  CONSTRAINT [FK_RPLItemAccount_RPLItem] FOREIGN KEY([ItemID])
REFERENCES [EDGE].[RPLItem] ([ItemID])
GO

ALTER TABLE [EDGE].[RPLItemAccount] CHECK CONSTRAINT [FK_RPLItemAccount_RPLItem]
GO


