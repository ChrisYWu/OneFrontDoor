USE [Portal_Data]
GO

/****** Object:  Table [SAP].[PackageConf]    Script Date: 3/21/2013 5:03:18 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [SAP].[PackageConf](
	[PackageConfID] [int] IDENTITY(1,1) NOT NULL,
	[SAPPackageConfID] [varchar](50) NOT NULL,
	[PackageConfName] [varchar](128) NOT NULL,
	[FriendlyName] [varchar](128) NULL,
 CONSTRAINT [PK_PackageConf] PRIMARY KEY CLUSTERED 
(
	[PackageConfID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


