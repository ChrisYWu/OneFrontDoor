USE [Portal_Data]
GO

/****** Object:  Table [BWStaging].[Channel]    Script Date: 3/21/2013 4:01:49 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [BWStaging].[Channel](
	[ChannelID] [nvarchar](50) NULL,
	[Channel] [nvarchar](500) NULL,
	[SuperChannelID] [nvarchar](50) NULL,
	[SuperChannel] [nvarchar](500) NULL
) ON [PRIMARY]

GO


