USE [Portal_Data]
GO

/****** Object:  Table [EDGE].[Account]    Script Date: 3/21/2013 4:07:04 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EDGE].[Account](
	[Option Id] [int] NOT NULL,
	[OptionName] [nvarchar](255) NOT NULL,
	[Enabled] [bit] NOT NULL,
	[SAPLocalChainId] [nvarchar](50) NULL,
	[SAPLocalChain] [nvarchar](50) NULL,
	[SAPRegionalChainID] [nvarchar](50) NULL,
	[SAPRegionalChain] [nvarchar](50) NULL,
	[SAPNationalChainID] [nvarchar](50) NULL,
	[SAPNationalChain] [nvarchar](50) NULL,
 CONSTRAINT [PK_Account_1] PRIMARY KEY CLUSTERED 
(
	[Option Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


