USE [Portal_Data]
GO

/****** Object:  Table [EDGE].[ErrorHandler]    Script Date: 3/21/2013 4:09:26 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [EDGE].[ErrorHandler](
	[ErrorId] [int] IDENTITY(1,1) NOT NULL,
	[ErrorCode] [varchar](85) NOT NULL,
	[ErrorMessgae] [varchar](255) NOT NULL,
	[ErrorDate] [datetime] NOT NULL,
	[ContentID] [varchar](210) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


