USE [Portal_Data]
GO

/****** Object:  Table [SAP].[Channel]    Script Date: 3/21/2013 4:56:20 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [SAP].[Channel](
	[ChannelID] [int] IDENTITY(1,1) NOT NULL,
	[SuperChannelID] [int] NULL,
	[SAPChannelID] [varchar](50) NOT NULL,
	[ChannelName] [varchar](128) NOT NULL,
	[SPChannelName] [varchar](50) NULL,
 CONSTRAINT [PK_Channel] PRIMARY KEY CLUSTERED 
(
	[ChannelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [SAP].[Channel]  WITH CHECK ADD  CONSTRAINT [FK_Channel_SuperChannel] FOREIGN KEY([SuperChannelID])
REFERENCES [SAP].[SuperChannel] ([SuperChannelID])
GO

ALTER TABLE [SAP].[Channel] CHECK CONSTRAINT [FK_Channel_SuperChannel]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Promotion Channel Information from SAP' , @level0type=N'SCHEMA',@level0name=N'SAP', @level1type=N'TABLE',@level1name=N'Channel'
GO


