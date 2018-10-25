USE [Portal_Data]
GO

/****** Object:  Table [EDGE].[RPLItemPackage]    Script Date: 3/21/2013 4:16:57 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [EDGE].[RPLItemPackage](
	[ItemID] [int] NOT NULL,
	[ContentID] [varchar](50) NULL,
	[SAPConfigurationID] [varchar](50) NULL,
	[SAPTypeID] [varchar](50) NULL,
	[PackageName] [varchar](50) NOT NULL,
	[TestData] [bit] NULL,
 CONSTRAINT [PK_RPLItemPackage] PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [EDGE].[RPLItemPackage]  WITH CHECK ADD  CONSTRAINT [FK_RPLItemPackage_RPLItem] FOREIGN KEY([ItemID])
REFERENCES [EDGE].[RPLItem] ([ItemID])
GO

ALTER TABLE [EDGE].[RPLItemPackage] CHECK CONSTRAINT [FK_RPLItemPackage_RPLItem]
GO


