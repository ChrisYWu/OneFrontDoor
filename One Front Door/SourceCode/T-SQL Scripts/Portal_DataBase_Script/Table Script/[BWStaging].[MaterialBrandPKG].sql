USE [Portal_Data]
GO

/****** Object:  Table [BWStaging].[MaterialBrandPKG]    Script Date: 3/21/2013 4:03:32 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [BWStaging].[MaterialBrandPKG](
	[MaterialID] [nvarchar](50) NULL,
	[Material] [nvarchar](500) NULL,
	[FranchisorID] [nvarchar](50) NULL,
	[Franchisor] [nvarchar](100) NULL,
	[BevTypeID] [nvarchar](50) NULL,
	[BevType] [nvarchar](200) NULL,
	[TrademarkID] [nvarchar](50) NULL,
	[Trademark] [nvarchar](100) NULL,
	[BrandID] [nvarchar](50) NULL,
	[Brand] [nvarchar](500) NULL,
	[FlavorID] [nvarchar](50) NULL,
	[Flavor] [nvarchar](500) NULL,
	[PackTypeID] [nvarchar](50) NULL,
	[PackType] [nvarchar](500) NULL,
	[PackConfID] [nvarchar](50) NULL,
	[PackConf] [nvarchar](1000) NULL
) ON [PRIMARY]

GO


