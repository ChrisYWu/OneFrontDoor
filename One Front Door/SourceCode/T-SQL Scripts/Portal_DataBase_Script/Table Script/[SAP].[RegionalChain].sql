USE [Portal_Data]
GO

/****** Object:  Table [SAP].[RegionalChain]    Script Date: 3/21/2013 5:06:34 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [SAP].[RegionalChain](
	[RegionalChainID] [int] IDENTITY(1,1) NOT NULL,
	[SAPRegionalChainID] [varchar](50) NULL,
	[RegionalChainName] [varchar](50) NOT NULL,
	[NationalChainID] [int] NOT NULL,
 CONSTRAINT [PK_SAP.RegionalChain] PRIMARY KEY CLUSTERED 
(
	[RegionalChainID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [SAP].[RegionalChain]  WITH CHECK ADD  CONSTRAINT [FK_RegionalChain_NationalChain] FOREIGN KEY([NationalChainID])
REFERENCES [SAP].[NationalChain] ([NationalChainID])
GO

ALTER TABLE [SAP].[RegionalChain] CHECK CONSTRAINT [FK_RegionalChain_NationalChain]
GO


