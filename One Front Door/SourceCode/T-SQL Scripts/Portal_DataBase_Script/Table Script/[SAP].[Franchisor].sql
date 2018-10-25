USE [Portal_Data]
GO

/****** Object:  Table [SAP].[Franchisor]    Script Date: 3/21/2013 4:58:51 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [SAP].[Franchisor](
	[FranchisorID] [int] IDENTITY(1,1) NOT NULL,
	[SAPFranchisorID] [varchar](50) NOT NULL,
	[FranchisorName] [varchar](128) NOT NULL,
 CONSTRAINT [PK_Franchisor] PRIMARY KEY CLUSTERED 
(
	[FranchisorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


