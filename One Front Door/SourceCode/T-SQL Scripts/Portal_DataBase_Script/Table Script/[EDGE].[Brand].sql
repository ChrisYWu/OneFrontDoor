USE [Portal_Data]
GO

/****** Object:  Table [EDGE].[Brand]    Script Date: 3/21/2013 4:07:48 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EDGE].[Brand](
	[ContentId] [int] NOT NULL,
	[Name] [nvarchar](255) NULL,
	[ProductCode] [nvarchar](255) NULL,
	[SAPTradeMarkId] [nvarchar](50) NULL,
	[SAPTradeMark] [nvarchar](50) NULL,
	[SAPBrandId] [nvarchar](50) NULL,
	[SAPBrand] [nvarchar](50) NULL,
 CONSTRAINT [PK_Brand_1] PRIMARY KEY CLUSTERED 
(
	[ContentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


