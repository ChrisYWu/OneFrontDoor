USE [Portal_Data]
GO

/****** Object:  Table [EDGE].[Channel]    Script Date: 3/21/2013 4:08:41 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EDGE].[Channel](
	[OptionId] [int] NOT NULL,
	[ChannelName] [nvarchar](255) NOT NULL,
	[Enabled] [bit] NOT NULL,
	[SAPChannelId] [nvarchar](50) NULL,
	[SAPChannel] [nvarchar](50) NULL,
	[SAPSuperChannelID] [nvarchar](50) NULL,
	[SAPSuperChannel] [nvarchar](50) NULL,
 CONSTRAINT [PK_Channel_1] PRIMARY KEY CLUSTERED 
(
	[OptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


