USE [Portal_Data]
GO

/****** Object:  Table [BWStaging].[ActiveItem]    Script Date: 3/21/2013 3:57:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [BWStaging].[ActiveItem](
	[LOCATION_ID] [int] NOT NULL,
	[ITEM_NUMBER] [varchar](12) NOT NULL,
	[HANDHELD_DESCRIPTION] [varchar](50) NULL,
	[PRINTOUT_DESCRIPTION] [varchar](50) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


