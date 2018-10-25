USE [Portal_Data]
GO

/****** Object:  Table [SAP].[NationalChain]    Script Date: 3/21/2013 5:02:22 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [SAP].[NationalChain](
	[NationalChainID] [int] IDENTITY(1,1) NOT NULL,
	[SAPNationalChainID] [varchar](50) NULL,
	[NationalChainName] [varchar](50) NOT NULL,
	[SPNationalChainName] [varchar](30) NULL,
 CONSTRAINT [PK_SAP.NationalChain] PRIMARY KEY CLUSTERED 
(
	[NationalChainID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


