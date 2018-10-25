USE [Portal_Data]
GO

/****** Object:  Table [SAP].[ProfitCenter]    Script Date: 3/21/2013 5:05:38 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [SAP].[ProfitCenter](
	[ProfitCenterID] [int] IDENTITY(1,1) NOT NULL,
	[SAPProfitCenterID] [varchar](32) NOT NULL,
	[ProfitCenterName] [nvarchar](64) NOT NULL,
	[BranchID] [int] NOT NULL,
 CONSTRAINT [PK_ProfitCenter] PRIMARY KEY CLUSTERED 
(
	[ProfitCenterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [SAP].[ProfitCenter]  WITH CHECK ADD  CONSTRAINT [FK_ProfitCenter_Branch] FOREIGN KEY([BranchID])
REFERENCES [SAP].[Branch] ([BranchID])
GO

ALTER TABLE [SAP].[ProfitCenter] CHECK CONSTRAINT [FK_ProfitCenter_Branch]
GO


