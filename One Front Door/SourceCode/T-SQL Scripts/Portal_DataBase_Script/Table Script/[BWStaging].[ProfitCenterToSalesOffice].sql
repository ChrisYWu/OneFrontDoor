USE [Portal_Data]
GO

/****** Object:  Table [BWStaging].[ProfitCenterToSalesOffice]    Script Date: 3/21/2013 4:04:24 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [BWStaging].[ProfitCenterToSalesOffice](
	[ProfitCenterID] [nvarchar](50) NULL,
	[ProfitCenter] [nvarchar](500) NULL,
	[SalesOfficeID] [nvarchar](50) NULL,
	[SalesOffice] [nvarchar](500) NULL
) ON [PRIMARY]

GO


