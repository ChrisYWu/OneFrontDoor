USE [Portal_Data]
GO

/****** Object:  Table [SAP].[LocalChain]    Script Date: 3/21/2013 5:00:31 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [SAP].[LocalChain](
	[LocalChainID] [int] IDENTITY(1,1) NOT NULL,
	[SAPLocalChainID] [varchar](50) NULL,
	[LocalChainName] [varchar](50) NOT NULL,
	[RegionalChainID] [int] NOT NULL,
 CONSTRAINT [PK_SAP.LocalChain] PRIMARY KEY CLUSTERED 
(
	[LocalChainID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [SAP].[LocalChain]  WITH CHECK ADD  CONSTRAINT [FK_LocalChain_RegionalChain] FOREIGN KEY([RegionalChainID])
REFERENCES [SAP].[RegionalChain] ([RegionalChainID])
GO

ALTER TABLE [SAP].[LocalChain] CHECK CONSTRAINT [FK_LocalChain_RegionalChain]
GO


