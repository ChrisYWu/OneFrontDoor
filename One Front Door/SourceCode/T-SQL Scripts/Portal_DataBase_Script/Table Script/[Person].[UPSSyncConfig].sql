USE [Portal_Data]
GO

/****** Object:  Table [Person].[UPSSyncConfig]    Script Date: 3/21/2013 4:23:18 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Person].[UPSSyncConfig](
	[ColumnName] [varchar](128) NOT NULL,
	[SPProperty] [varchar](128) NOT NULL,
	[SyncDirection] [varchar](10) NULL,
 CONSTRAINT [PK_UPSSyncConfig] PRIMARY KEY CLUSTERED 
(
	[ColumnName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [Person].[UPSSyncConfig]  WITH CHECK ADD  CONSTRAINT [CK_Vendor_UPSSybnConfig] CHECK  (([SyncDirection]='Down' OR [SyncDirection]='Up'))
GO

ALTER TABLE [Person].[UPSSyncConfig] CHECK CONSTRAINT [CK_Vendor_UPSSybnConfig]
GO


