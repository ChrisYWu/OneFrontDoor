USE [Portal_Data]
GO

/****** Object:  Table [SAP].[SalesRoute]    Script Date: 3/21/2013 5:10:13 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [SAP].[SalesRoute](
	[RouteID] [int] IDENTITY(1,1) NOT NULL,
	[SAPRouteNumber] [varchar](10) NOT NULL,
	[BranchID] [int] NOT NULL,
	[RouteName] [varchar](50) NOT NULL,
	[DefaultEmployeeID] [int] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_SalesRoute] PRIMARY KEY CLUSTERED 
(
	[RouteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


