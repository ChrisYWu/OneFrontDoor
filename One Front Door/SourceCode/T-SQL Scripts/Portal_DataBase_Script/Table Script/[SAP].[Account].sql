USE [Portal_Data]
GO

/****** Object:  Table [SAP].[Account]    Script Date: 3/21/2013 4:49:36 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [SAP].[Account](
	[AccountID] [int] IDENTITY(1,1) NOT NULL,
	[SAPAccountNumber] [bigint] NOT NULL,
	[AccountName] [varchar](128) NOT NULL,
	[ChannelID] [int] NULL,
	[BranchID] [int] NULL,
	[LocalChainID] [int] NULL,
	[Address] [varchar](50) NULL,
	[City] [varchar](50) NULL,
	[State] [varchar](50) NULL,
	[PostalCode] [varchar](12) NULL,
	[Contact] [varchar](50) NULL,
	[PhoneNumber] [varchar](50) NULL,
	[Longitude] [decimal](10, 6) NULL,
	[Latitude] [decimal](10, 6) NULL,
	[Active] [bit] NULL,
 CONSTRAINT [PK_Account] PRIMARY KEY CLUSTERED 
(
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [SAP].[Account]  WITH CHECK ADD  CONSTRAINT [FK_Account_Branch] FOREIGN KEY([BranchID])
REFERENCES [SAP].[Branch] ([BranchID])
GO

ALTER TABLE [SAP].[Account] CHECK CONSTRAINT [FK_Account_Branch]
GO

ALTER TABLE [SAP].[Account]  WITH CHECK ADD  CONSTRAINT [FK_Account_Channel] FOREIGN KEY([ChannelID])
REFERENCES [SAP].[Channel] ([ChannelID])
GO

ALTER TABLE [SAP].[Account] CHECK CONSTRAINT [FK_Account_Channel]
GO

ALTER TABLE [SAP].[Account]  WITH CHECK ADD  CONSTRAINT [FK_Account_LocalChain] FOREIGN KEY([LocalChainID])
REFERENCES [SAP].[LocalChain] ([LocalChainID])
GO

ALTER TABLE [SAP].[Account] CHECK CONSTRAINT [FK_Account_LocalChain]
GO


