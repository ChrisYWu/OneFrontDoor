USE [Portal_Data]
GO

/****** Object:  Table [EDGE].[RPLItemBrand]    Script Date: 3/21/2013 4:14:25 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [EDGE].[RPLItemBrand](
	[ItemID] [int] NOT NULL,
	[BrandName] [varchar](50) NOT NULL,
	[ContentID] [varchar](50) NULL,
	[SAPTradeMarkID] [varchar](50) NULL,
	[SAPBrandID] [varchar](50) NULL,
	[TestData] [bit] NULL,
 CONSTRAINT [PK_RPLItemBrand] PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC,
	[BrandName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [EDGE].[RPLItemBrand]  WITH CHECK ADD  CONSTRAINT [FK_RPLItemBrand_RPLItem] FOREIGN KEY([ItemID])
REFERENCES [EDGE].[RPLItem] ([ItemID])
GO

ALTER TABLE [EDGE].[RPLItemBrand] CHECK CONSTRAINT [FK_RPLItemBrand_RPLItem]
GO


