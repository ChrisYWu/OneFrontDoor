USE [Portal_Data]
GO

/****** Object:  Table [SAP].[RouteToMarket]    Script Date: 3/21/2013 5:09:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [SAP].[RouteToMarket](
	[RouteToMarketName] [nvarchar](50) NOT NULL,
	[SAPRouteToMarketID] [int] NOT NULL,
 CONSTRAINT [PK_RouteToMarket_1] PRIMARY KEY CLUSTERED 
(
	[RouteToMarketName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


