USE [Portal_Data]
GO

/****** Object:  Table [EDGE].[RPLAttachment]    Script Date: 3/21/2013 4:11:33 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [EDGE].[RPLAttachment](
	[AttachmentID] [int] IDENTITY(1,1) NOT NULL,
	[ItemID] [int] NOT NULL,
	[ContentID] [varchar](50) NULL,
	[FileName] [varchar](128) NULL,
	[PhysicalFile] [varbinary](max) NULL,
	[AttachmentType] [varchar](50) NOT NULL,
	[ReceivedDate] [datetime] NOT NULL,
	[TestData] [bit] NULL,
 CONSTRAINT [PK_RPLAttachment] PRIMARY KEY CLUSTERED 
(
	[AttachmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [EDGE].[RPLAttachment] ADD  CONSTRAINT [DF_RPLAttachment_ReceivedDateUTC]  DEFAULT (getdate()) FOR [ReceivedDate]
GO

ALTER TABLE [EDGE].[RPLAttachment]  WITH CHECK ADD  CONSTRAINT [FK_RPLAttachment_RPLItem] FOREIGN KEY([ItemID])
REFERENCES [EDGE].[RPLItem] ([ItemID])
GO

ALTER TABLE [EDGE].[RPLAttachment] CHECK CONSTRAINT [FK_RPLAttachment_RPLItem]
GO


