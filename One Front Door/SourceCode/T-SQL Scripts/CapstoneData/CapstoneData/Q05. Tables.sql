USE Portal_Data_INT
GO

Set NoCount On;
Go

If Not Exists (Select * From sys.schemas Where Name = 'BC')
Begin
	exec sp_executesql N'Create Schema BC'
End
Go

/****** Object:  Table [BC].[GlobalStatus]    Script Date: 5/1/2014 11:25:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BC].[GlobalStatus](
	[GlobalStatusID] [varchar](20) NOT NULL,
	[BCGlobalStatusID] [varchar](20) NOT NULL,
	[StatusName] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[GlobalStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BC].[ProductType]    Script Date: 5/1/2014 11:25:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BC].[ProductType](
	[ProductTypeID] [int] NOT NULL,
	[BCProducTypeID] [nvarchar](5) NOT NULL,
	[ProductTypeName] [varchar](50) NOT NULL,
	[LastModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_ProductType] PRIMARY KEY CLUSTERED 
(
	[ProductTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BC].[TerritoryType]    Script Date: 5/1/2014 11:25:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BC].[TerritoryType](
	[TerritoryTypeID] [int] NOT NULL,
	[BCTerritoryTypeID] [nvarchar](2) NOT NULL,
	[TerritoryTypeName] [varchar](50) NOT NULL,
	[LastModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_TerritoryType] PRIMARY KEY CLUSTERED 
(
	[TerritoryTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Shared].[Country]    Script Date: 5/1/2014 11:25:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Shared].[Country](
	[CountryCode] [nvarchar](2) NOT NULL,
	[BCCountryCode] [nvarchar](2) NULL,
	[ISOCountryCode] [nvarchar](3) NULL,
	[CountryName] [nvarchar](40) NOT NULL,
	[LastModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Country_1] PRIMARY KEY CLUSTERED 
(
	[CountryCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
INSERT [BC].[GlobalStatus] ([GlobalStatusID], [BCGlobalStatusID], [StatusName]) VALUES (N'01', N'01', N'Draft')
GO
INSERT [BC].[GlobalStatus] ([GlobalStatusID], [BCGlobalStatusID], [StatusName]) VALUES (N'02', N'02', N'Active')
GO
INSERT [BC].[GlobalStatus] ([GlobalStatusID], [BCGlobalStatusID], [StatusName]) VALUES (N'03', N'03', N'Inactive')
GO
INSERT [BC].[GlobalStatus] ([GlobalStatusID], [BCGlobalStatusID], [StatusName]) VALUES (N'99', N'99', N'Deleted')
GO
INSERT [BC].[ProductType] ([ProductTypeID], [BCProducTypeID], [ProductTypeName], [LastModified]) VALUES (1, N'01', N'Beverage Concentrate', CAST(0xA30D0000 AS SmallDateTime))
GO
INSERT [BC].[ProductType] ([ProductTypeID], [BCProducTypeID], [ProductTypeName], [LastModified]) VALUES (2, N'02', N'Fountain & Food Service', CAST(0xA30D0000 AS SmallDateTime))
GO
INSERT [BC].[TerritoryType] ([TerritoryTypeID], [BCTerritoryTypeID], [TerritoryTypeName], [LastModified]) VALUES (10, N'10', N'Licencing', CAST(0xA30D0000 AS SmallDateTime))
GO
INSERT [BC].[TerritoryType] ([TerritoryTypeID], [BCTerritoryTypeID], [TerritoryTypeName], [LastModified]) VALUES (11, N'11', N'Reporting/Marketing', CAST(0xA30D0000 AS SmallDateTime))
GO
INSERT [BC].[TerritoryType] ([TerritoryTypeID], [BCTerritoryTypeID], [TerritoryTypeName], [LastModified]) VALUES (12, N'12', N'Servicing', CAST(0xA30D0000 AS SmallDateTime))
GO
INSERT [Shared].[Country] ([CountryCode], [BCCountryCode], [ISOCountryCode], [CountryName], [LastModified]) VALUES (N'CA', N'', N'CAN', N'Canada', CAST(0xA30D0000 AS SmallDateTime))
GO
INSERT [Shared].[Country] ([CountryCode], [BCCountryCode], [ISOCountryCode], [CountryName], [LastModified]) VALUES (N'US', N'', N'USA', N'United States', CAST(0xA30D0000 AS SmallDateTime))
GO

/****** Object:  Table [BC].[AccountInclusion]    Script Date: 5/1/2014 11:23:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BC].[AccountInclusion](
	[TradeMarkID] [int] NOT NULL,
	[ProductTypeID] [int] NOT NULL,
	[TerritoryTypeID] [int] NOT NULL,
	[CountyID] [int] NOT NULL,
	[PostalCode] [varchar](10) NULL,
	[BottlerID] [int] NOT NULL,
	[AccountID] [int] NOT NULL,
 CONSTRAINT [PK_AccountInclusion] PRIMARY KEY CLUSTERED 
(
	[TradeMarkID] ASC,
	[ProductTypeID] ASC,
	[TerritoryTypeID] ASC,
	[BottlerID] ASC,
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BC].[Bottler]    Script Date: 5/1/2014 11:23:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BC].[Bottler](
	[BottlerID] [int] IDENTITY(1,1) NOT NULL,
	[BCBottlerID] [bigint] NOT NULL,
	[BottlerName] [varchar](128) NOT NULL,
	[ChannelID] [int] NULL,
	[GlobalStatusID] [int] NOT NULL,
	[EB4ID] [int] NULL,
	[BCRegionID] [int] NULL,
	[FSRegionID] [int] NULL,
	[Address] [varchar](200) NULL,
	[City] [varchar](50) NULL,
	[County] [varchar](50) NULL,
	[State] [varchar](50) NULL,
	[PostalCode] [varchar](12) NULL,
	[Country] [varchar](50) NULL,
	[Email] [varchar](50) NULL,
	[PhoneNumber] [varchar](50) NULL,
	[Longitude] [decimal](10, 6) NULL,
	[Latitude] [decimal](10, 6) NULL,
	[AddressLastModified] [datetime2](7) NULL,
	[EB4LastModified] [datetime2](7) NULL,
	[BCRegionLastModified] [datetime2](7) NULL,
	[FSRegionLastModified] [datetime2](7) NULL,
	[Active]  AS (CONVERT([bit],case when [GlobalStatusID]=(2) then (1) else (0) end)),
	[LastModified] [datetime2](7) NOT NULL,
	[GeoCodingNeeded] bit Not Null,
 CONSTRAINT [PK_Bottler] PRIMARY KEY CLUSTERED 
(
	[BottlerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 20) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BC].[BottlerAccountTradeMark]    Script Date: 5/1/2014 11:23:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BC].[BottlerAccountTradeMark](
	[TerritoryTypeID] [int] NOT NULL,
	[ProductTypeID] [int] NOT NULL,
	[IsStoreInclusion] [int] NOT NULL,
	[BottlerID] [int] NOT NULL,
	[TradeMarkID] [int] NOT NULL,
	[AccountID] [int] NOT NULL,
	[LocalChainID] [int] NULL,
	[ChannelID] [int] NULL,
	[BranchID] [int] NULL,
 CONSTRAINT [PK_BottlerAccountTradeMark_BottlerID_AccountID_TradeMarkID_TerritoryTypeID_ProductID] PRIMARY KEY CLUSTERED 
(
	[BottlerID] ASC,
	[TerritoryTypeID] ASC,
	[ProductTypeID] ASC,
	[AccountID] ASC,
	[TradeMarkID] ASC,
	[IsStoreInclusion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [BC].[BottlerEB1]    Script Date: 5/1/2014 11:23:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BC].[BottlerEB1](
	[EB1ID] [int] IDENTITY(1,1) NOT NULL,
	[BCNodeID] [nvarchar](20) NOT NULL,
	[EB1Name] [varchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[LastModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_BottlerEB1] PRIMARY KEY CLUSTERED 
(
	[EB1ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BC].[BottlerEB2]    Script Date: 5/1/2014 11:23:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BC].[BottlerEB2](
	[EB2ID] [int] IDENTITY(1,1) NOT NULL,
	[BCNodeID] [nvarchar](20) NOT NULL,
	[EB1ID] [int] NOT NULL,
	[EB2Name] [varchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[LastModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_BottlerEB2] PRIMARY KEY CLUSTERED 
(
	[EB2ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BC].[BottlerEB3]    Script Date: 5/1/2014 11:23:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BC].[BottlerEB3](
	[EB3ID] [int] IDENTITY(1,1) NOT NULL,
	[BCNodeID] [nvarchar](20) NOT NULL,
	[EB2ID] [int] NOT NULL,
	[EB3Name] [varchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[LastModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_BottlerEB3] PRIMARY KEY CLUSTERED 
(
	[EB3ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BC].[BottlerEB4]    Script Date: 5/1/2014 11:23:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BC].[BottlerEB4](
	[EB4ID] [int] IDENTITY(1,1) NOT NULL,
	[BCNodeID] [nvarchar](20) NOT NULL,
	[EB3ID] [int] NOT NULL,
	[EB4Name] [varchar](64) NOT NULL,
	[Active] [bit] NOT NULL,
	[LastModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_BottlerEB4] PRIMARY KEY CLUSTERED 
(
	[EB4ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO

/****** Object:  Table [BC].[Country]    Script Date: 5/1/2014 11:23:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BC].[Country](
	[CountryID] [int] IDENTITY(1,1) NOT NULL,
	[BCNodeID] [nvarchar](20) NOT NULL,
	[CountryName] [nvarchar](40) NOT NULL,
	[TotalCompanyID] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[LastModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED 
(
	[CountryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [BC].[Division]    Script Date: 5/1/2014 11:23:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BC].[Division](
	[DivisionID] [int] IDENTITY(1,1) NOT NULL,
	[BCNodeID] [nvarchar](20) NOT NULL,
	[DivisionName] [nvarchar](40) NOT NULL,
	[ZoneID] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[LastModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Division] PRIMARY KEY CLUSTERED 
(
	[DivisionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [BC].[Region]    Script Date: 5/1/2014 11:23:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BC].[Region](
	[RegionID] [int] IDENTITY(1,1) NOT NULL,
	[BCNodeID] [nvarchar](20) NOT NULL,
	[RegionName] [nvarchar](40) NOT NULL,
	[DivisionID] [int] NOT NULL,
	[HierType] [varchar](2) NULL,
	[Active] [bit] NOT NULL,
	[LastModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Region] PRIMARY KEY CLUSTERED 
(
	[RegionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BC].[System]    Script Date: 5/1/2014 11:23:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BC].[System](
	[SystemID] [int] IDENTITY(1,1) NOT NULL,
	[BCNodeID] [nvarchar](20) NOT NULL,
	[SystemName] [nvarchar](40) NOT NULL,
	[CountryID] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[LastModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_System] PRIMARY KEY CLUSTERED 
(
	[SystemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [BC].[tBottlerTerritoryType]    Script Date: 5/1/2014 11:23:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BC].[tBottlerTerritoryType](
	[BottlerID] [int] NOT NULL,
	[TerritoryTypeID] [int] NOT NULL,
	[TerritoryTypeName] [varchar](50) NOT NULL,
	[ProductTypeID] [int] NOT NULL,
	[LastModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_tBottlerTerritoryType] PRIMARY KEY CLUSTERED 
(
	[BottlerID] ASC,
	[TerritoryTypeID] ASC,
	[ProductTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BC].[tBottlerTrademark]    Script Date: 5/1/2014 11:23:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BC].[tBottlerTrademark](
	[TerritoryTypeID] [int] NOT NULL,
	[ProductTypeID] [int] NOT NULL,
	[BottlerID] [int] NOT NULL,
	[BCBottlerID] [bigint] NOT NULL,
	[BottlerName] [varchar](128) NOT NULL,
	[TradeMarkID] [int] NOT NULL,
	[SAPTradeMarkID] [varchar](50) NOT NULL,
	[TradeMarkName] [nvarchar](128) NOT NULL,
	[LastModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_tBottlerTrademark] PRIMARY KEY CLUSTERED 
(
	[TerritoryTypeID] ASC,
	[ProductTypeID] ASC,
	[BottlerID] ASC,
	[TradeMarkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BC].[TerritoryMap]    Script Date: 5/1/2014 11:23:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BC].[TerritoryMap](
	[TradeMarkID] [int] NOT NULL,
	[ProductTypeID] [int] NOT NULL,
	[TerritoryTypeID] [int] NOT NULL,
	[CountyID] [int] NOT NULL,
	[PostalCode] [varchar](10) NOT NULL,
	[BottlerID] [int] NOT NULL,
 CONSTRAINT [PK_TerritoryMap] PRIMARY KEY CLUSTERED 
(
	[TradeMarkID] ASC,
	[ProductTypeID] ASC,
	[TerritoryTypeID] ASC,
	[CountyID] ASC,
	[PostalCode] ASC,
	[BottlerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX NCI_TerritoryMap_ProductTypeID_TerritoryTypeID
ON [BC].[TerritoryMap] ([ProductTypeID],[TerritoryTypeID])
INCLUDE ([TradeMarkID],[CountyID],[PostalCode],[BottlerID])
Go

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BC].[TotalCompany]    Script Date: 5/1/2014 11:23:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BC].[TotalCompany](
	[TotalCompanyID] [int] IDENTITY(1,1) NOT NULL,
	[BCNodeID] [nvarchar](20) NOT NULL,
	[TotalCompanyName] [nvarchar](40) NOT NULL,
	[HierType] [varchar](2) NOT NULL,
	[Active] [bit] NOT NULL,
	[LastModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_TotalCompany] PRIMARY KEY CLUSTERED 
(
	[TotalCompanyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BC].[Zone]    Script Date: 5/1/2014 11:23:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BC].[Zone](
	[ZoneID] [int] IDENTITY(1,1) NOT NULL,
	[BCNodeID] [nvarchar](20) NOT NULL,
	[ZoneName] [nvarchar](40) NOT NULL,
	[SystemID] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[LastModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Zone] PRIMARY KEY CLUSTERED 
(
	[ZoneID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Person].[BCSalesAccountability]    Script Date: 5/1/2014 11:23:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Person].[BCSalesAccountability](
	[BCSalesAccountabilityID] [int] IDENTITY(1,1) NOT NULL,
	[GSN] [varchar](50) NOT NULL,
	[TotalCompanyID] [int] NULL,
	[CountryID] [int] NULL,
	[SystemID] [int] NULL,
	[ZoneID] [int] NULL,
	[DivisionID] [int] NULL,
	[RegionID] [int] NULL,
	[IsPrimary] [bit] NOT NULL,
	[IsSystemLoad] [bit] NOT NULL,
	[LastModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_BCSalesAccoutability] PRIMARY KEY CLUSTERED 
(
	[BCSalesAccountabilityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Shared].[County]    Script Date: 5/1/2014 11:23:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Shared].[County](
	[CountyID] [int] IDENTITY(1,1) NOT NULL,
	[BCCountryCode] [nvarchar](2) NULL,
	[BCRegionFIPS] [nvarchar](2) NOT NULL,
	[BCCountyFIPS] [nvarchar](3) NOT NULL,
	[StateRegionID] [int] NOT NULL,
	[CountyName] [nvarchar](40) NOT NULL,
	[Population] [int] NOT NULL,
	[LastModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_County] PRIMARY KEY CLUSTERED 
(
	[CountyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Shared].[StateRegion]    Script Date: 5/1/2014 11:23:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Shared].[StateRegion](
	[StateRegionID] [int] IDENTITY(1,1) NOT NULL,
	[BCRegionFIPS] [nvarchar](2) NOT NULL,
	[CountryCode] [nvarchar](2) NOT NULL,
	[RegionABRV] [nvarchar](2) NOT NULL,
	[RegionName] [nvarchar](20) NOT NULL,
	[LastModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_StateRegion] PRIMARY KEY CLUSTERED 
(
	[StateRegionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [BC].[AccountInclusion]  WITH CHECK ADD  CONSTRAINT [FK_AccountInclusion_Account] FOREIGN KEY([AccountID])
REFERENCES [SAP].[Account] ([AccountID])
GO
ALTER TABLE [BC].[AccountInclusion] CHECK CONSTRAINT [FK_AccountInclusion_Account]
GO
ALTER TABLE [BC].[AccountInclusion]  WITH CHECK ADD  CONSTRAINT [FK_AccountInclusion_Bottler] FOREIGN KEY([BottlerID])
REFERENCES [BC].[Bottler] ([BottlerID])
GO
ALTER TABLE [BC].[AccountInclusion] CHECK CONSTRAINT [FK_AccountInclusion_Bottler]
GO
ALTER TABLE [BC].[AccountInclusion]  WITH CHECK ADD  CONSTRAINT [FK_AccountInclusion_County] FOREIGN KEY([CountyID])
REFERENCES [Shared].[County] ([CountyID])
GO
ALTER TABLE [BC].[AccountInclusion] CHECK CONSTRAINT [FK_AccountInclusion_County]
GO
ALTER TABLE [BC].[AccountInclusion]  WITH CHECK ADD  CONSTRAINT [FK_AccountInclusion_ProductType] FOREIGN KEY([ProductTypeID])
REFERENCES [BC].[ProductType] ([ProductTypeID])
GO
ALTER TABLE [BC].[AccountInclusion] CHECK CONSTRAINT [FK_AccountInclusion_ProductType]
GO
ALTER TABLE [BC].[AccountInclusion]  WITH CHECK ADD  CONSTRAINT [FK_AccountInclusion_TerritoryType] FOREIGN KEY([TerritoryTypeID])
REFERENCES [BC].[TerritoryType] ([TerritoryTypeID])
GO
ALTER TABLE [BC].[AccountInclusion] CHECK CONSTRAINT [FK_AccountInclusion_TerritoryType]
GO
ALTER TABLE [BC].[AccountInclusion]  WITH CHECK ADD  CONSTRAINT [FK_AccountInclusion_TradeMark] FOREIGN KEY([TradeMarkID])
REFERENCES [SAP].[TradeMark] ([TradeMarkID])
GO
ALTER TABLE [BC].[AccountInclusion] CHECK CONSTRAINT [FK_AccountInclusion_TradeMark]
GO
ALTER TABLE [BC].[Bottler]  WITH CHECK ADD  CONSTRAINT [FK_Bottler_BottlerEB4] FOREIGN KEY([EB4ID])
REFERENCES [BC].[BottlerEB4] ([EB4ID])
GO
ALTER TABLE [BC].[Bottler] CHECK CONSTRAINT [FK_Bottler_BottlerEB4]
GO
ALTER TABLE [BC].[Bottler]  WITH CHECK ADD  CONSTRAINT [FK_Bottler_FSRegion] FOREIGN KEY([FSRegionID])
REFERENCES [BC].[Region] ([RegionID])
GO
ALTER TABLE [BC].[Bottler] CHECK CONSTRAINT [FK_Bottler_FSRegion]
GO
ALTER TABLE [BC].[Bottler]  WITH CHECK ADD  CONSTRAINT [FK_Bottler_Region] FOREIGN KEY([BCRegionID])
REFERENCES [BC].[Region] ([RegionID])
GO
ALTER TABLE [BC].[Bottler] CHECK CONSTRAINT [FK_Bottler_Region]
GO
ALTER TABLE [BC].[BottlerEB2]  WITH CHECK ADD  CONSTRAINT [FK_BottlerEB2_BottlerEB1] FOREIGN KEY([EB1ID])
REFERENCES [BC].[BottlerEB1] ([EB1ID])
GO
ALTER TABLE [BC].[BottlerEB2] CHECK CONSTRAINT [FK_BottlerEB2_BottlerEB1]
GO
ALTER TABLE [BC].[BottlerEB3]  WITH CHECK ADD  CONSTRAINT [FK_BottlerEB3_BottlerEB2] FOREIGN KEY([EB2ID])
REFERENCES [BC].[BottlerEB2] ([EB2ID])
GO
ALTER TABLE [BC].[BottlerEB3] CHECK CONSTRAINT [FK_BottlerEB3_BottlerEB2]
GO
ALTER TABLE [BC].[BottlerEB4]  WITH CHECK ADD  CONSTRAINT [FK_BottlerEB4_BottlerEB3] FOREIGN KEY([EB3ID])
REFERENCES [BC].[BottlerEB3] ([EB3ID])
GO
ALTER TABLE [BC].[BottlerEB4] CHECK CONSTRAINT [FK_BottlerEB4_BottlerEB3]
GO
ALTER TABLE [BC].[Country]  WITH CHECK ADD  CONSTRAINT [FK_Country_TotalCompany] FOREIGN KEY([TotalCompanyID])
REFERENCES [BC].[TotalCompany] ([TotalCompanyID])
GO
ALTER TABLE [BC].[Country] CHECK CONSTRAINT [FK_Country_TotalCompany]
GO
ALTER TABLE [BC].[Division]  WITH CHECK ADD  CONSTRAINT [FK_Division_Zone] FOREIGN KEY([ZoneID])
REFERENCES [BC].[Zone] ([ZoneID])
GO
ALTER TABLE [BC].[Division] CHECK CONSTRAINT [FK_Division_Zone]
GO
ALTER TABLE [BC].[Region]  WITH CHECK ADD  CONSTRAINT [FK_Region_Division] FOREIGN KEY([DivisionID])
REFERENCES [BC].[Division] ([DivisionID])
GO
ALTER TABLE [BC].[Region] CHECK CONSTRAINT [FK_Region_Division]
GO
ALTER TABLE [BC].[System]  WITH CHECK ADD  CONSTRAINT [FK_System_Country] FOREIGN KEY([CountryID])
REFERENCES [BC].[Country] ([CountryID])
GO
ALTER TABLE [BC].[System] CHECK CONSTRAINT [FK_System_Country]
GO
ALTER TABLE [BC].[tBottlerTerritoryType]  WITH CHECK ADD  CONSTRAINT [FK_tBottlerTerritoryType_Bottler] FOREIGN KEY([BottlerID])
REFERENCES [BC].[Bottler] ([BottlerID])
GO
ALTER TABLE [BC].[tBottlerTerritoryType] CHECK CONSTRAINT [FK_tBottlerTerritoryType_Bottler]
GO
ALTER TABLE [BC].[tBottlerTerritoryType]  WITH CHECK ADD  CONSTRAINT [FK_tBottlerTerritoryType_ProductType] FOREIGN KEY([ProductTypeID])
REFERENCES [BC].[ProductType] ([ProductTypeID])
GO
ALTER TABLE [BC].[tBottlerTerritoryType] CHECK CONSTRAINT [FK_tBottlerTerritoryType_ProductType]
GO
ALTER TABLE [BC].[tBottlerTerritoryType]  WITH CHECK ADD  CONSTRAINT [FK_tBottlerTerritoryType_TerritoryType] FOREIGN KEY([TerritoryTypeID])
REFERENCES [BC].[TerritoryType] ([TerritoryTypeID])
GO
ALTER TABLE [BC].[tBottlerTerritoryType] CHECK CONSTRAINT [FK_tBottlerTerritoryType_TerritoryType]
GO
ALTER TABLE [BC].[tBottlerTrademark]  WITH CHECK ADD  CONSTRAINT [FK_tBottlerTrademark_Bottler] FOREIGN KEY([BottlerID])
REFERENCES [BC].[Bottler] ([BottlerID])
GO
ALTER TABLE [BC].[tBottlerTrademark] CHECK CONSTRAINT [FK_tBottlerTrademark_Bottler]
GO
ALTER TABLE [BC].[tBottlerTrademark]  WITH CHECK ADD  CONSTRAINT [FK_tBottlerTrademark_ProductType] FOREIGN KEY([ProductTypeID])
REFERENCES [BC].[ProductType] ([ProductTypeID])
GO
ALTER TABLE [BC].[tBottlerTrademark] CHECK CONSTRAINT [FK_tBottlerTrademark_ProductType]
GO
ALTER TABLE [BC].[tBottlerTrademark]  WITH CHECK ADD  CONSTRAINT [FK_tBottlerTrademark_TerritoryType] FOREIGN KEY([TerritoryTypeID])
REFERENCES [BC].[TerritoryType] ([TerritoryTypeID])
GO
ALTER TABLE [BC].[tBottlerTrademark] CHECK CONSTRAINT [FK_tBottlerTrademark_TerritoryType]
GO
ALTER TABLE [BC].[tBottlerTrademark]  WITH CHECK ADD  CONSTRAINT [FK_tBottlerTrademark_TradeMark] FOREIGN KEY([TradeMarkID])
REFERENCES [SAP].[TradeMark] ([TradeMarkID])
GO
ALTER TABLE [BC].[tBottlerTrademark] CHECK CONSTRAINT [FK_tBottlerTrademark_TradeMark]
GO
ALTER TABLE [BC].[TerritoryMap]  WITH CHECK ADD  CONSTRAINT [FK_TerritoryMap_Bottler] FOREIGN KEY([BottlerID])
REFERENCES [BC].[Bottler] ([BottlerID])
GO
ALTER TABLE [BC].[TerritoryMap] CHECK CONSTRAINT [FK_TerritoryMap_Bottler]
GO
ALTER TABLE [BC].[TerritoryMap]  WITH CHECK ADD  CONSTRAINT [FK_TerritoryMap_County] FOREIGN KEY([CountyID])
REFERENCES [Shared].[County] ([CountyID])
GO
ALTER TABLE [BC].[TerritoryMap] CHECK CONSTRAINT [FK_TerritoryMap_County]
GO
ALTER TABLE [BC].[TerritoryMap]  WITH CHECK ADD  CONSTRAINT [FK_TerritoryMap_ProductType] FOREIGN KEY([ProductTypeID])
REFERENCES [BC].[ProductType] ([ProductTypeID])
GO
ALTER TABLE [BC].[TerritoryMap] CHECK CONSTRAINT [FK_TerritoryMap_ProductType]
GO
ALTER TABLE [BC].[TerritoryMap]  WITH CHECK ADD  CONSTRAINT [FK_TerritoryMap_TerritoryType] FOREIGN KEY([TerritoryTypeID])
REFERENCES [BC].[TerritoryType] ([TerritoryTypeID])
GO
ALTER TABLE [BC].[TerritoryMap] CHECK CONSTRAINT [FK_TerritoryMap_TerritoryType]
GO
ALTER TABLE [BC].[TerritoryMap]  WITH CHECK ADD  CONSTRAINT [FK_TerritoryMap_TradeMark] FOREIGN KEY([TradeMarkID])
REFERENCES [SAP].[TradeMark] ([TradeMarkID])
GO
ALTER TABLE [BC].[TerritoryMap] CHECK CONSTRAINT [FK_TerritoryMap_TradeMark]
GO
ALTER TABLE [BC].[Zone]  WITH CHECK ADD  CONSTRAINT [FK_Zone_System] FOREIGN KEY([SystemID])
REFERENCES [BC].[System] ([SystemID])
GO
ALTER TABLE [BC].[Zone] CHECK CONSTRAINT [FK_Zone_System]
GO
ALTER TABLE [Person].[BCSalesAccountability]  WITH CHECK ADD  CONSTRAINT [FK_BCSalesAccoutability_Country] FOREIGN KEY([CountryID])
REFERENCES [BC].[Country] ([CountryID])
GO
ALTER TABLE [Person].[BCSalesAccountability] CHECK CONSTRAINT [FK_BCSalesAccoutability_Country]
GO
ALTER TABLE [Person].[BCSalesAccountability]  WITH CHECK ADD  CONSTRAINT [FK_BCSalesAccoutability_Division] FOREIGN KEY([DivisionID])
REFERENCES [BC].[Division] ([DivisionID])
GO
ALTER TABLE [Person].[BCSalesAccountability] CHECK CONSTRAINT [FK_BCSalesAccoutability_Division]
GO
ALTER TABLE [Person].[BCSalesAccountability]  WITH CHECK ADD  CONSTRAINT [FK_BCSalesAccoutability_Region] FOREIGN KEY([RegionID])
REFERENCES [BC].[Region] ([RegionID])
GO
ALTER TABLE [Person].[BCSalesAccountability] CHECK CONSTRAINT [FK_BCSalesAccoutability_Region]
GO
ALTER TABLE [Person].[BCSalesAccountability]  WITH CHECK ADD  CONSTRAINT [FK_BCSalesAccoutability_System] FOREIGN KEY([SystemID])
REFERENCES [BC].[System] ([SystemID])
GO
ALTER TABLE [Person].[BCSalesAccountability] CHECK CONSTRAINT [FK_BCSalesAccoutability_System]
GO
ALTER TABLE [Person].[BCSalesAccountability]  WITH CHECK ADD  CONSTRAINT [FK_BCSalesAccoutability_TotalCompany] FOREIGN KEY([TotalCompanyID])
REFERENCES [BC].[TotalCompany] ([TotalCompanyID])
GO
ALTER TABLE [Person].[BCSalesAccountability] CHECK CONSTRAINT [FK_BCSalesAccoutability_TotalCompany]
GO
ALTER TABLE [Person].[BCSalesAccountability]  WITH CHECK ADD  CONSTRAINT [FK_BCSalesAccoutability_UserProfile] FOREIGN KEY([GSN])
REFERENCES [Person].[UserProfile] ([GSN])
GO
ALTER TABLE [Person].[BCSalesAccountability] CHECK CONSTRAINT [FK_BCSalesAccoutability_UserProfile]
GO
ALTER TABLE [Person].[BCSalesAccountability]  WITH CHECK ADD  CONSTRAINT [FK_BCSalesAccoutability_Zone] FOREIGN KEY([ZoneID])
REFERENCES [BC].[Zone] ([ZoneID])
GO
ALTER TABLE [Person].[BCSalesAccountability] CHECK CONSTRAINT [FK_BCSalesAccoutability_Zone]
GO
ALTER TABLE [Shared].[County]  WITH CHECK ADD  CONSTRAINT [FK_County_StateRegion] FOREIGN KEY([StateRegionID])
REFERENCES [Shared].[StateRegion] ([StateRegionID])
GO
ALTER TABLE [Shared].[County] CHECK CONSTRAINT [FK_County_StateRegion]
GO
ALTER TABLE [Shared].[StateRegion]  WITH CHECK ADD  CONSTRAINT [FK_StateRegion_Country] FOREIGN KEY([CountryCode])
REFERENCES [Shared].[Country] ([CountryCode])
GO
ALTER TABLE [Shared].[StateRegion] CHECK CONSTRAINT [FK_StateRegion_Country]
GO
ALTER TABLE [Person].[BCSalesAccountability]  WITH CHECK ADD  CONSTRAINT [CK_BCSalesAccountability] CHECK  (((((((isnumeric([TotalCompanyID])+isnumeric([CountryID]))+isnumeric([SystemID]))+isnumeric([ZoneID]))+isnumeric([DivisionID]))+isnumeric([RegionID]))=(1)))
GO
ALTER TABLE [Person].[BCSalesAccountability] CHECK CONSTRAINT [CK_BCSalesAccountability]
GO
/****** Object:  Table [BC].[tBottlerChainTradeMark]    Script Date: 5/1/2014 12:10:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BC].[tBottlerChainTradeMark](
	[TerritoryTypeID] [int] NOT NULL,
	[ProductTypeID] [int] NOT NULL,
	[BottlerID] [int] NOT NULL,
	[BCBottlerID] [bigint] NOT NULL,
	[BottlerName] [varchar](128) NOT NULL,
	[TradeMarkID] [int] NOT NULL,
	[SAPTradeMarkID] [varchar](50) NOT NULL,
	[TradeMarkName] [nvarchar](128) NOT NULL,
	[LocalChainID] [int] NOT NULL,
	[SAPLocalChainID] [int] NULL,
	[LocalChainName] [varchar](50) NOT NULL,
	[RegionalChainID] [int] NOT NULL,
	[SAPRegionalChainID] [int] NULL,
	[RegionalChainName] [varchar](50) NOT NULL,
	[NationalChainID] [int] NOT NULL,
	[SAPNationalChainID] [int] NULL,
	[NationalChainName] [varchar](50) NOT NULL,
	[LastModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_tBottlerChainTradeMark] PRIMARY KEY CLUSTERED 
(
	[TerritoryTypeID] ASC,
	[ProductTypeID] ASC,
	[BottlerID] ASC,
	[TradeMarkID] ASC,
	[LocalChainID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [BC].[tBottlerChainTradeMark]  WITH CHECK ADD  CONSTRAINT [FK_tBottlerChainTradeMark_Bottler] FOREIGN KEY([BottlerID])
REFERENCES [BC].[Bottler] ([BottlerID])
GO
ALTER TABLE [BC].[tBottlerChainTradeMark] CHECK CONSTRAINT [FK_tBottlerChainTradeMark_Bottler]
GO
ALTER TABLE [BC].[tBottlerChainTradeMark]  WITH CHECK ADD  CONSTRAINT [FK_tBottlerChainTradeMark_LocalChain] FOREIGN KEY([LocalChainID])
REFERENCES [SAP].[LocalChain] ([LocalChainID])
GO
ALTER TABLE [BC].[tBottlerChainTradeMark] CHECK CONSTRAINT [FK_tBottlerChainTradeMark_LocalChain]
GO
ALTER TABLE [BC].[tBottlerChainTradeMark]  WITH CHECK ADD  CONSTRAINT [FK_tBottlerChainTradeMark_ProductType] FOREIGN KEY([ProductTypeID])
REFERENCES [BC].[ProductType] ([ProductTypeID])
GO
ALTER TABLE [BC].[tBottlerChainTradeMark] CHECK CONSTRAINT [FK_tBottlerChainTradeMark_ProductType]
GO
ALTER TABLE [BC].[tBottlerChainTradeMark]  WITH CHECK ADD  CONSTRAINT [FK_tBottlerChainTradeMark_TerritoryType] FOREIGN KEY([TerritoryTypeID])
REFERENCES [BC].[TerritoryType] ([TerritoryTypeID])
GO
ALTER TABLE [BC].[tBottlerChainTradeMark] CHECK CONSTRAINT [FK_tBottlerChainTradeMark_TerritoryType]
GO
ALTER TABLE [BC].[tBottlerChainTradeMark]  WITH CHECK ADD  CONSTRAINT [FK_tBottlerChainTradeMark_TradeMark] FOREIGN KEY([TradeMarkID])
REFERENCES [SAP].[TradeMark] ([TradeMarkID])
GO
ALTER TABLE [BC].[tBottlerChainTradeMark] CHECK CONSTRAINT [FK_tBottlerChainTradeMark_TradeMark]
GO
/****** Object:  Table [ETL].[BCAccountTerritoryMapRecreationLog]    Script Date: 5/1/2014 12:17:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ETL].[BCAccountTerritoryMapRecreationLog](
	[LogID] [bigint] IDENTITY(1,1) NOT NULL,
	[Date]  AS (CONVERT([date],[StartTime])),
	[StartTime] [datetime2](7) NOT NULL,
	[MergeTMapCompleteOffset] [int] NULL,
	[MergeAccountInclusionCompleteOffset] [int] NULL,
	[ProcessBottlerAccountTradeMarkCompleteOffset] [int] NULL,
	[ProcessInclusionCompleteOffset] [int] NULL,
 CONSTRAINT [PK_BC.AccountTerritoryMapRecreationLog] PRIMARY KEY CLUSTERED 
(
	[StartTime] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [ETL].[BCDataLoadingLog]    Script Date: 5/1/2014 12:17:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [ETL].[BCDataLoadingLog](
	[LogID] [bigint] IDENTITY(1,1) NOT NULL,
	[LogDate]  AS (CONVERT([date],[StartDate])),
	[LastLoadingTimeInSeconds]  AS (datediff(second,[StartDate],[EndDate])),
	[IsMerged]  AS (CONVERT([bit],case when [MergeDate] IS NULL then (0) else (1) end)),
	[TableName] [varchar](100) NOT NULL,
	[SchemaName] [varchar](50) NOT NULL,
	[StartDate] [datetime2](7) NOT NULL,
	[EndDate] [datetime2](7) NULL,
	[NumberOfRecordsLoaded] [int] NULL,
	[LatestLoadedRecordDate] [datetime2](7) NULL,
	[MergeDate] [datetime2](7) NULL,
 CONSTRAINT [PK_DataLoadingLog] PRIMARY KEY CLUSTERED 
(
	[StartDate] DESC,
	[SchemaName] ASC,
	[TableName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BC].[tBottlerMapping](
	[TradeMarkID] [int] NOT NULL,
	[CountyID] [int] NOT NULL,
	[PostalCode] [varchar](10) NOT NULL,
	[RptgBottlerID] [int] NOT NULL,
	[SvcgBottlerID] [int] NOT NULL,
 CONSTRAINT [PK_tBottlerMapping] PRIMARY KEY CLUSTERED 
(
	[RptgBottlerID] ASC,
	[SvcgBottlerID] ASC,
	[TradeMarkID] ASC,
	[CountyID] ASC,
	[PostalCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
SET ANSI_PADDING OFF
GO
