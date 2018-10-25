USE [Portal_Data]
GO

/****** Object:  Table [SAP].[BevType]    Script Date: 3/21/2013 4:50:37 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [SAP].[BevType](
	[BevTypeID] [int] IDENTITY(1,1) NOT NULL,
	[SAPBevTypeID] [varchar](50) NOT NULL,
	[BevTypeName] [varchar](128) NULL,
 CONSTRAINT [PK_BevType] PRIMARY KEY CLUSTERED 
(
	[BevTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

