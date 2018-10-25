USE [Portal_Data]
GO

/****** Object:  Table [BWStaging].[Chain]    Script Date: 3/21/2013 4:00:56 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [BWStaging].[Chain](
	[LocalChainID] [nvarchar](50) NULL,
	[LocalChain] [nvarchar](500) NULL,
	[RegionalChainID] [nvarchar](50) NULL,
	[RegionalChain] [nvarchar](500) NULL,
	[NationalChainID] [nvarchar](50) NULL,
	[NationalChain] [nvarchar](500) NULL
) ON [PRIMARY]

GO


