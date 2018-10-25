USE [Portal_Data]
GO

/****** Object:  Table [SAP].[PackageType]    Script Date: 3/21/2013 5:04:16 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [SAP].[PackageType](
	[PackageTypeID] [int] IDENTITY(1,1) NOT NULL,
	[SAPPackageTypeID] [varchar](50) NOT NULL,
	[PackageTypeName] [varchar](128) NOT NULL,
	[FriendlyName] [varchar](128) NULL,
 CONSTRAINT [PK_PackageType_1] PRIMARY KEY CLUSTERED 
(
	[PackageTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


