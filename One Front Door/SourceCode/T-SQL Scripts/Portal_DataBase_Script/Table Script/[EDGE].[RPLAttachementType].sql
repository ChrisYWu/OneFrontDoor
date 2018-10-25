USE [Portal_Data]
GO

/****** Object:  Table [EDGE].[RPLAttachementType]    Script Date: 3/21/2013 4:10:52 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [EDGE].[RPLAttachementType](
	[AttachmentType] [varchar](50) NOT NULL,
	[SPContentType] [varchar](50) NULL,
 CONSTRAINT [PK_RPLAttachementType] PRIMARY KEY CLUSTERED 
(
	[AttachmentType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


