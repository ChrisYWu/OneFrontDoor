USE [Portal_Data]
GO

/****** Object:  Table [SAP].[CostCenter]    Script Date: 3/21/2013 4:57:16 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [SAP].[CostCenter](
	[CostCenterID] [int] IDENTITY(1,1) NOT NULL,
	[SAPCostCenterID] [nvarchar](64) NOT NULL,
	[CostCenterName] [nvarchar](64) NOT NULL,
	[ProfitCenterID] [int] NOT NULL,
 CONSTRAINT [PK_CostCenter] PRIMARY KEY CLUSTERED 
(
	[CostCenterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [SAP].[CostCenter]  WITH CHECK ADD  CONSTRAINT [FK_CostCenter_ProfitCenter] FOREIGN KEY([ProfitCenterID])
REFERENCES [SAP].[ProfitCenter] ([ProfitCenterID])
GO

ALTER TABLE [SAP].[CostCenter] CHECK CONSTRAINT [FK_CostCenter_ProfitCenter]
GO


