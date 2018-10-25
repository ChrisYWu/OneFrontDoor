USE [Portal_Data]
GO

/****** Object:  Table [SAP].[Material]    Script Date: 3/21/2013 5:01:31 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [SAP].[Material](
	[MaterialID] [int] IDENTITY(1,1) NOT NULL,
	[SAPMaterialID] [varchar](12) NOT NULL,
	[MaterialName] [varchar](128) NOT NULL,
	[FranchisorID] [int] NULL,
	[BevTypeID] [int] NULL,
	[BrandID] [int] NULL,
	[FlavorID] [int] NULL,
	[PackageConfID] [int] NULL,
	[PackageTypeID] [int] NULL,
 CONSTRAINT [PK_Material] PRIMARY KEY CLUSTERED 
(
	[MaterialID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [SAP].[Material]  WITH CHECK ADD  CONSTRAINT [FK_Material_BevType] FOREIGN KEY([BevTypeID])
REFERENCES [SAP].[BevType] ([BevTypeID])
GO

ALTER TABLE [SAP].[Material] CHECK CONSTRAINT [FK_Material_BevType]
GO

ALTER TABLE [SAP].[Material]  WITH CHECK ADD  CONSTRAINT [FK_Material_Brand] FOREIGN KEY([BrandID])
REFERENCES [SAP].[Brand] ([BrandID])
GO

ALTER TABLE [SAP].[Material] CHECK CONSTRAINT [FK_Material_Brand]
GO

ALTER TABLE [SAP].[Material]  WITH CHECK ADD  CONSTRAINT [FK_Material_Flavor] FOREIGN KEY([FlavorID])
REFERENCES [SAP].[Flavor] ([FlavorID])
GO

ALTER TABLE [SAP].[Material] CHECK CONSTRAINT [FK_Material_Flavor]
GO

ALTER TABLE [SAP].[Material]  WITH CHECK ADD  CONSTRAINT [FK_Material_Franchisor] FOREIGN KEY([FranchisorID])
REFERENCES [SAP].[Franchisor] ([FranchisorID])
GO

ALTER TABLE [SAP].[Material] CHECK CONSTRAINT [FK_Material_Franchisor]
GO

ALTER TABLE [SAP].[Material]  WITH CHECK ADD  CONSTRAINT [FK_Material_PackageConf] FOREIGN KEY([PackageConfID])
REFERENCES [SAP].[PackageConf] ([PackageConfID])
GO

ALTER TABLE [SAP].[Material] CHECK CONSTRAINT [FK_Material_PackageConf]
GO

ALTER TABLE [SAP].[Material]  WITH CHECK ADD  CONSTRAINT [FK_Material_PackageType] FOREIGN KEY([PackageTypeID])
REFERENCES [SAP].[PackageType] ([PackageTypeID])
GO

ALTER TABLE [SAP].[Material] CHECK CONSTRAINT [FK_Material_PackageType]
GO


