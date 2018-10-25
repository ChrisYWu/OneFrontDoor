USE [Portal_Data]
GO

/****** Object:  Table [EDGE].[PitPackageSize]    Script Date: 3/21/2013 4:10:07 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [EDGE].[PitPackageSize](
	[PackageSizeId] [int] NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Enabled] [bit] NOT NULL,
	[SAPPackConfID] [varchar](50) NULL,
	[SAPPackTypeID] [varchar](50) NULL,
	[PackConfMappingComments] [varchar](500) NULL,
	[PackTypeMappingComments] [varchar](500) NULL,
 CONSTRAINT [PK_PitPackageSize] PRIMARY KEY CLUSTERED 
(
	[PackageSizeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


