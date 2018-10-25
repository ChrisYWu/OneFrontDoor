USE [Portal_Data]
GO

/****** Object:  Table [BWStaging].[SalesOffice]    Script Date: 3/21/2013 4:05:53 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [BWStaging].[SalesOffice](
	[SalesOfficeID] [nvarchar](50) NULL,
	[SalesOffice] [nvarchar](500) NULL,
	[BusinessUnitID] [nvarchar](50) NULL,
	[BusinessUnit] [nvarchar](500) NULL,
	[RegionID] [nvarchar](50) NULL,
	[Region] [nvarchar](500) NULL
) ON [PRIMARY]

GO


