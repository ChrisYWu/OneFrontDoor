USE [Portal_Data]
GO

/****** Object:  Table [BWStaging].[CostCenterToProfitCenter]    Script Date: 3/21/2013 4:02:40 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [BWStaging].[CostCenterToProfitCenter](
	[CostCenterID] [nvarchar](50) NULL,
	[CostCenter] [nvarchar](500) NULL,
	[ProfitCenterID] [nvarchar](50) NULL,
	[ProfitCenter] [nvarchar](500) NULL
) ON [PRIMARY]

GO


