USE [Portal_Data]
GO

/****** Object:  Table [SAP].[SuperChannel]    Script Date: 3/21/2013 5:11:09 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [SAP].[SuperChannel](
	[SuperChannelID] [int] IDENTITY(1,1) NOT NULL,
	[SAPSuperChannelID] [varchar](50) NOT NULL,
	[SuperChannelName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SAP.SuperChannel] PRIMARY KEY CLUSTERED 
(
	[SuperChannelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


