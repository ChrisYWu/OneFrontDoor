USE [Portal_Data]
GO
/****** Object:  Table [SupplyChain].[Division]    Script Date: 12/12/2014 10:29:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SupplyChain].[Division](
	[DivisionID] [int] IDENTITY(1,1) NOT NULL,
	[DivisionName] [varchar](50) NOT NULL,
	[LastModified] [smalldatetime] NOT NULL CONSTRAINT [DF_Division_LastModified]  DEFAULT (getdate()),
 CONSTRAINT [PK_Division] PRIMARY KEY CLUSTERED 
(
	[DivisionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SupplyChain].[Plant]    Script Date: 12/12/2014 10:29:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SupplyChain].[Plant](
	[PlantID] [int] IDENTITY(1,1) NOT NULL,
	[PlantSK] [int] NOT NULL,
	[SAPPlantNumber] [varchar](4) NULL,
	[SAPSource] [varchar](50) NULL,
	[PlantName] [varchar](50) NOT NULL,
	[PlantDesc] [varchar](50) NOT NULL,
	[Address1] [nvarchar](100) NULL,
	[Address2] [nvarchar](100) NULL,
	[City] [nvarchar](50) NULL,
	[State] [nvarchar](50) NULL,
	[ZipCode] [varchar](50) NULL,
	[Logitude] [decimal](10, 6) NULL,
	[Latitude] [decimal](10, 6) NULL,
	[PlantManagerGSN] [varchar](10) NULL,
	[PlantRTM] [varchar](20) NULL,
	[RegionID] [int] NOT NULL,
	[PlantTypeID] [int] NOT NULL,
	[ChangeTrackNumber] [int] NOT NULL,
	[LastModified] [smalldatetime] NOT NULL,
	[Active] [bit] NULL,
 CONSTRAINT [PK_Plant] PRIMARY KEY CLUSTERED 
(
	[PlantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SupplyChain].[PlantType]    Script Date: 12/12/2014 10:29:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SupplyChain].[PlantType](
	[PlantTypeID] [int] IDENTITY(1,1) NOT NULL,
	[PlantTypeName] [varchar](50) NOT NULL,
	[LastModified] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_PlantType] PRIMARY KEY CLUSTERED 
(
	[PlantTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SupplyChain].[Region]    Script Date: 12/12/2014 10:29:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SupplyChain].[Region](
	[RegionID] [int] IDENTITY(1,1) NOT NULL,
	[RegionName] [varchar](50) NOT NULL,
	[DivisionID] [int] NOT NULL,
	[LastModified] [smalldatetime] NOT NULL CONSTRAINT [DF_Region_LastModified]  DEFAULT (getdate()),
 CONSTRAINT [PK_Region] PRIMARY KEY CLUSTERED 
(
	[RegionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SupplyChain].[TimeAggregation]    Script Date: 12/12/2014 10:29:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SupplyChain].[TimeAggregation](
	[AggregationID] [tinyint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[SortOrder] [tinyint] NOT NULL,
	[StartAt] [varchar](50) NULL,
	[Description] [varchar](50) NULL,
	[Note] [varchar](200) NULL,
	[Active] [bit] NULL,
 CONSTRAINT [PK_TimeAggregation] PRIMARY KEY CLUSTERED 
(
	[AggregationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [SupplyChain].[Division] ON 

GO
INSERT [SupplyChain].[Division] ([DivisionID], [DivisionName], [LastModified]) VALUES (1, N'Central/NE WD ', CAST(N'2014-09-08 16:41:00' AS SmallDateTime))
GO
INSERT [SupplyChain].[Division] ([DivisionID], [DivisionName], [LastModified]) VALUES (2, N'Mexico', CAST(N'2014-09-08 16:41:00' AS SmallDateTime))
GO
INSERT [SupplyChain].[Division] ([DivisionID], [DivisionName], [LastModified]) VALUES (3, N'NE/SE', CAST(N'2014-09-08 16:41:00' AS SmallDateTime))
GO
INSERT [SupplyChain].[Division] ([DivisionID], [DivisionName], [LastModified]) VALUES (4, N'Southwest', CAST(N'2014-09-08 16:41:00' AS SmallDateTime))
GO
INSERT [SupplyChain].[Division] ([DivisionID], [DivisionName], [LastModified]) VALUES (5, N'St. Louis', CAST(N'2014-09-08 16:41:00' AS SmallDateTime))
GO
INSERT [SupplyChain].[Division] ([DivisionID], [DivisionName], [LastModified]) VALUES (6, N'West', CAST(N'2014-09-08 16:41:00' AS SmallDateTime))
GO
SET IDENTITY_INSERT [SupplyChain].[Division] OFF
GO
SET IDENTITY_INSERT [SupplyChain].[Plant] ON 

GO
INSERT [SupplyChain].[Plant] ([PlantID], [PlantSK], [SAPPlantNumber], [SAPSource], [PlantName], [PlantDesc], [Address1], [Address2], [City], [State], [ZipCode], [Logitude], [Latitude], [PlantManagerGSN], [PlantRTM], [RegionID], [PlantTypeID], [ChangeTrackNumber], [LastModified], [Active]) VALUES (1, 10, N'1309', N'SP7', N'NOR', N'Northlake', N'401 N.Railroad Ave.', NULL, N'Northlake', N'IL', N'60164', CAST(-87.899151 AS Decimal(10, 6)), CAST(41.915378 AS Decimal(10, 6)), N'GRADX002', N'DSD', 1, 3, -2059898810, CAST(N'2014-09-08 16:41:00' AS SmallDateTime), 1)
GO
INSERT [SupplyChain].[Plant] ([PlantID], [PlantSK], [SAPPlantNumber], [SAPSource], [PlantName], [PlantDesc], [Address1], [Address2], [City], [State], [ZipCode], [Logitude], [Latitude], [PlantManagerGSN], [PlantRTM], [RegionID], [PlantTypeID], [ChangeTrackNumber], [LastModified], [Active]) VALUES (2, 11, N'1343', N'SP7', N'OTT', N'Ottumwa', N'14955 Truman Street', NULL, N'Ottumwa', N'IA', N'52501', CAST(-92.434797 AS Decimal(10, 6)), CAST(41.106966 AS Decimal(10, 6)), N'MURJX027', N'DSD', 2, 3, -1294934347, CAST(N'2014-09-08 16:41:00' AS SmallDateTime), 1)
GO
INSERT [SupplyChain].[Plant] ([PlantID], [PlantSK], [SAPPlantNumber], [SAPSource], [PlantName], [PlantDesc], [Address1], [Address2], [City], [State], [ZipCode], [Logitude], [Latitude], [PlantManagerGSN], [PlantRTM], [RegionID], [PlantTypeID], [ChangeTrackNumber], [LastModified], [Active]) VALUES (3, 13, N'1212', N'SP7', N'CAR', N'Carlstadt', N'600 Commercial Avenue', NULL, N'Carlstadt', N'NJ', N'07072', CAST(-74.240132 AS Decimal(10, 6)), CAST(41.884618 AS Decimal(10, 6)), N'PEDWX001', N'WD', 3, 1, 857594183, CAST(N'2014-09-08 16:41:00' AS SmallDateTime), 1)
GO
INSERT [SupplyChain].[Plant] ([PlantID], [PlantSK], [SAPPlantNumber], [SAPSource], [PlantName], [PlantDesc], [Address1], [Address2], [City], [State], [ZipCode], [Logitude], [Latitude], [PlantManagerGSN], [PlantRTM], [RegionID], [PlantTypeID], [ChangeTrackNumber], [LastModified], [Active]) VALUES (4, 14, NULL, NULL, N'OPE', N'Opelousas', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 1, 265483642, CAST(N'2014-09-08 16:41:00' AS SmallDateTime), 0)
GO
INSERT [SupplyChain].[Plant] ([PlantID], [PlantSK], [SAPPlantNumber], [SAPSource], [PlantName], [PlantDesc], [Address1], [Address2], [City], [State], [ZipCode], [Logitude], [Latitude], [PlantManagerGSN], [PlantRTM], [RegionID], [PlantTypeID], [ChangeTrackNumber], [LastModified], [Active]) VALUES (5, 17, N'1214', N'SP7', N'CAT', N'Carteret', N'1200 MILIK STREET', NULL, N'CARTERET', N'NJ', N'07008', CAST(-72.490540 AS Decimal(10, 6)), CAST(40.831725 AS Decimal(10, 6)), N'CRUSX001', N'WD', 3, 1, 1361287350, CAST(N'2014-09-08 16:41:00' AS SmallDateTime), 1)
GO
INSERT [SupplyChain].[Plant] ([PlantID], [PlantSK], [SAPPlantNumber], [SAPSource], [PlantName], [PlantDesc], [Address1], [Address2], [City], [State], [ZipCode], [Logitude], [Latitude], [PlantManagerGSN], [PlantRTM], [RegionID], [PlantTypeID], [ChangeTrackNumber], [LastModified], [Active]) VALUES (6, 18, NULL, NULL, N'WAT', N'Waterloo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 1, -2118760715, CAST(N'2014-09-08 16:41:00' AS SmallDateTime), 0)
GO
INSERT [SupplyChain].[Plant] ([PlantID], [PlantSK], [SAPPlantNumber], [SAPSource], [PlantName], [PlantDesc], [Address1], [Address2], [City], [State], [ZipCode], [Logitude], [Latitude], [PlantManagerGSN], [PlantRTM], [RegionID], [PlantTypeID], [ChangeTrackNumber], [LastModified], [Active]) VALUES (7, 19, N'1215', N'SP7', N'WIL', N'Williamson', N'4363 Route 104', NULL, N'Williamson', N'NY', N'14589', CAST(-77.177062 AS Decimal(10, 6)), CAST(43.239266 AS Decimal(10, 6)), N'TOBGX001', N'WD', 3, 1, -305195983, CAST(N'2014-09-08 16:41:00' AS SmallDateTime), 1)
GO
INSERT [SupplyChain].[Plant] ([PlantID], [PlantSK], [SAPPlantNumber], [SAPSource], [PlantName], [PlantDesc], [Address1], [Address2], [City], [State], [ZipCode], [Logitude], [Latitude], [PlantManagerGSN], [PlantRTM], [RegionID], [PlantTypeID], [ChangeTrackNumber], [LastModified], [Active]) VALUES (8, 20, N'1213', N'SP7', N'ASP', N'Aspers', N'45 Aspers Road North', NULL, N'Aspers', N'PA', N'17304', CAST(-77.222792 AS Decimal(10, 6)), CAST(39.977947 AS Decimal(10, 6)), N'GROBX001', N'WD', 3, 1, 1091993657, CAST(N'2014-09-08 16:41:00' AS SmallDateTime), 1)
GO
INSERT [SupplyChain].[Plant] ([PlantID], [PlantSK], [SAPPlantNumber], [SAPSource], [PlantName], [PlantDesc], [Address1], [Address2], [City], [State], [ZipCode], [Logitude], [Latitude], [PlantManagerGSN], [PlantRTM], [RegionID], [PlantTypeID], [ChangeTrackNumber], [LastModified], [Active]) VALUES (9, 16, NULL, NULL, N'TEC', N'Tecate', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4, 1, -2128641461, CAST(N'2014-09-08 16:41:00' AS SmallDateTime), 0)
GO
INSERT [SupplyChain].[Plant] ([PlantID], [PlantSK], [SAPPlantNumber], [SAPSource], [PlantName], [PlantDesc], [Address1], [Address2], [City], [State], [ZipCode], [Logitude], [Latitude], [PlantManagerGSN], [PlantRTM], [RegionID], [PlantTypeID], [ChangeTrackNumber], [LastModified], [Active]) VALUES (10, 25, N'5100', N'SP8', N'XAL', N'Xalostoc', N'TENOCHTITLAN 20', NULL, N'ECATEPEC', N'MEX', N'55310', CAST(-99.076366 AS Decimal(10, 6)), CAST(19.530917 AS Decimal(10, 6)), N'SERJL002', N'DSD', 4, 4, 208063123, CAST(N'2014-09-08 16:41:00' AS SmallDateTime), 1)
GO
INSERT [SupplyChain].[Plant] ([PlantID], [PlantSK], [SAPPlantNumber], [SAPSource], [PlantName], [PlantDesc], [Address1], [Address2], [City], [State], [ZipCode], [Logitude], [Latitude], [PlantManagerGSN], [PlantRTM], [RegionID], [PlantTypeID], [ChangeTrackNumber], [LastModified], [Active]) VALUES (11, 26, N'3200', N'SP8', N'TLA', N'Tlajomulco', N'CRR. TLAJOMULCO SN.MIGUEL, KM 8', NULL, N'TLAJOMULCO DE ZUNIGA', N'JAL', N'45640', CAST(-103.444737 AS Decimal(10, 6)), CAST(20.480424 AS Decimal(10, 6)), N'PERFX007', N'DSD', 4, 3, 1512176957, CAST(N'2014-09-08 16:41:00' AS SmallDateTime), 1)
GO
INSERT [SupplyChain].[Plant] ([PlantID], [PlantSK], [SAPPlantNumber], [SAPSource], [PlantName], [PlantDesc], [Address1], [Address2], [City], [State], [ZipCode], [Logitude], [Latitude], [PlantManagerGSN], [PlantRTM], [RegionID], [PlantTypeID], [ChangeTrackNumber], [LastModified], [Active]) VALUES (12, 27, N'3100', N'SP8', N'TEH', N'Tehuacan', N'AV. JOSE GARCI CRESPO 2805', NULL, N'TEHUACAN', N'PUE', N'75710', CAST(-97.400759 AS Decimal(10, 6)), CAST(18.482539 AS Decimal(10, 6)), N'HUEOX001', N'DSD', 4, 3, -253222456, CAST(N'2014-09-08 16:41:00' AS SmallDateTime), 1)
GO
INSERT [SupplyChain].[Plant] ([PlantID], [PlantSK], [SAPPlantNumber], [SAPSource], [PlantName], [PlantDesc], [Address1], [Address2], [City], [State], [ZipCode], [Logitude], [Latitude], [PlantManagerGSN], [PlantRTM], [RegionID], [PlantTypeID], [ChangeTrackNumber], [LastModified], [Active]) VALUES (13, 5, N'1331', N'SP7', N'COL', N'Columbus', N'950 Stelzer Rd.', NULL, N'Columbus', N'OH', N'43219', CAST(-82.910405 AS Decimal(10, 6)), CAST(39.989749 AS Decimal(10, 6)), N'JASJX002', N'DSD', 5, 3, 850729414, CAST(N'2014-09-08 16:41:00' AS SmallDateTime), 1)
GO
INSERT [SupplyChain].[Plant] ([PlantID], [PlantSK], [SAPPlantNumber], [SAPSource], [PlantName], [PlantDesc], [Address1], [Address2], [City], [State], [ZipCode], [Logitude], [Latitude], [PlantManagerGSN], [PlantRTM], [RegionID], [PlantTypeID], [ChangeTrackNumber], [LastModified], [Active]) VALUES (14, 6, NULL, NULL, N'PRO', N'Propak', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6, 2, 1326823531, CAST(N'2014-09-08 16:41:00' AS SmallDateTime), 0)
GO
INSERT [SupplyChain].[Plant] ([PlantID], [PlantSK], [SAPPlantNumber], [SAPSource], [PlantName], [PlantDesc], [Address1], [Address2], [City], [State], [ZipCode], [Logitude], [Latitude], [PlantManagerGSN], [PlantRTM], [RegionID], [PlantTypeID], [ChangeTrackNumber], [LastModified], [Active]) VALUES (15, 7, N'1323', N'SP7', N'HOL', N'Holland', N'777 Brooks Ave.', NULL, N'Holland', N'MI', N'49423', CAST(-86.083593 AS Decimal(10, 6)), CAST(42.766723 AS Decimal(10, 6)), N'MURCX010', N'DSD', 6, 3, 1507176959, CAST(N'2014-09-08 16:41:00' AS SmallDateTime), 1)
GO
INSERT [SupplyChain].[Plant] ([PlantID], [PlantSK], [SAPPlantNumber], [SAPSource], [PlantName], [PlantDesc], [Address1], [Address2], [City], [State], [ZipCode], [Logitude], [Latitude], [PlantManagerGSN], [PlantRTM], [RegionID], [PlantTypeID], [ChangeTrackNumber], [LastModified], [Active]) VALUES (16, 4, N'1304', N'SP7', N'LOU', N'Louisville', N'6207 Strawberry Lane', NULL, N'Louisville', N'KY', N'40214', CAST(-85.755203 AS Decimal(10, 6)), CAST(38.167544 AS Decimal(10, 6)), N'CORLX004', N'DSD', 7, 3, -1543822129, CAST(N'2014-09-08 16:41:00' AS SmallDateTime), 1)
GO
INSERT [SupplyChain].[Plant] ([PlantID], [PlantSK], [SAPPlantNumber], [SAPSource], [PlantName], [PlantDesc], [Address1], [Address2], [City], [State], [ZipCode], [Logitude], [Latitude], [PlantManagerGSN], [PlantRTM], [RegionID], [PlantTypeID], [ChangeTrackNumber], [LastModified], [Active]) VALUES (17, 22, N'1403', N'SP7', N'JAX', N'Jacksonville', N'6045 Bowdendale Avenue', NULL, N'Jacksonville', N'FL', N'32216', CAST(-81.608042 AS Decimal(10, 6)), CAST(30.260270 AS Decimal(10, 6)), N'FITEX002', N'DSD', 7, 3, 451264742, CAST(N'2014-09-08 16:41:00' AS SmallDateTime), 1)
GO
INSERT [SupplyChain].[Plant] ([PlantID], [PlantSK], [SAPPlantNumber], [SAPSource], [PlantName], [PlantDesc], [Address1], [Address2], [City], [State], [ZipCode], [Logitude], [Latitude], [PlantManagerGSN], [PlantRTM], [RegionID], [PlantTypeID], [ChangeTrackNumber], [LastModified], [Active]) VALUES (18, 23, N'1408', N'SP7', N'MIA', N'Miami', N'5900 N.W. 72nd Avenue', NULL, N'Miami', N'FL', N'33166', CAST(-80.310168 AS Decimal(10, 6)), CAST(25.823504 AS Decimal(10, 6)), N'LANSX013', N'DSD', 7, 3, -1697720717, CAST(N'2014-09-08 16:41:00' AS SmallDateTime), 1)
GO
INSERT [SupplyChain].[Plant] ([PlantID], [PlantSK], [SAPPlantNumber], [SAPSource], [PlantName], [PlantDesc], [Address1], [Address2], [City], [State], [ZipCode], [Logitude], [Latitude], [PlantManagerGSN], [PlantRTM], [RegionID], [PlantTypeID], [ChangeTrackNumber], [LastModified], [Active]) VALUES (19, 3, N'1118', N'SP7', N'HOU', N'Houston', N'2400 Holly Hall', NULL, N'Houston', N'TX', N'77054', CAST(-95.399190 AS Decimal(10, 6)), CAST(29.684978 AS Decimal(10, 6)), N'FEHSX002', N'DSD', 8, 3, 1634564895, CAST(N'2014-09-08 16:41:00' AS SmallDateTime), 1)
GO
INSERT [SupplyChain].[Plant] ([PlantID], [PlantSK], [SAPPlantNumber], [SAPSource], [PlantName], [PlantDesc], [Address1], [Address2], [City], [State], [ZipCode], [Logitude], [Latitude], [PlantManagerGSN], [PlantRTM], [RegionID], [PlantTypeID], [ChangeTrackNumber], [LastModified], [Active]) VALUES (20, 12, N'1110', N'SP7', N'IRV', N'Irving', N'2304 Century Center Blvd', NULL, N'Irving', N'TX', N'75062', CAST(-96.892745 AS Decimal(10, 6)), CAST(32.841236 AS Decimal(10, 6)), N'DAVSX003', N'DSD', 9, 3, -61467494, CAST(N'2014-09-08 16:41:00' AS SmallDateTime), 1)
GO
INSERT [SupplyChain].[Plant] ([PlantID], [PlantSK], [SAPPlantNumber], [SAPSource], [PlantName], [PlantDesc], [Address1], [Address2], [City], [State], [ZipCode], [Logitude], [Latitude], [PlantManagerGSN], [PlantRTM], [RegionID], [PlantTypeID], [ChangeTrackNumber], [LastModified], [Active]) VALUES (21, 9, N'1120', N'SP7', N'SAN', N'San Antonio', N'4518 Seguin Road', NULL, N'San Antonio', N'TX', N'78219', CAST(-98.391012 AS Decimal(10, 6)), CAST(29.448914 AS Decimal(10, 6)), N'BELVX007', N'DSD', 10, 3, 309605668, CAST(N'2014-09-08 16:41:00' AS SmallDateTime), 1)
GO
INSERT [SupplyChain].[Plant] ([PlantID], [PlantSK], [SAPPlantNumber], [SAPSource], [PlantName], [PlantDesc], [Address1], [Address2], [City], [State], [ZipCode], [Logitude], [Latitude], [PlantManagerGSN], [PlantRTM], [RegionID], [PlantTypeID], [ChangeTrackNumber], [LastModified], [Active]) VALUES (22, 21, N'1146', N'SP2', N'CON', N'Concentrate (STL)', N'8900 Page Avenue', NULL, N'St Louis', N'MO', N'63114', CAST(-90.355457 AS Decimal(10, 6)), CAST(38.685544 AS Decimal(10, 6)), N'HOWRX001', N'Concentrate', 11, 3, -1338973087, CAST(N'2014-09-08 16:41:00' AS SmallDateTime), 1)
GO
INSERT [SupplyChain].[Plant] ([PlantID], [PlantSK], [SAPPlantNumber], [SAPSource], [PlantName], [PlantDesc], [Address1], [Address2], [City], [State], [ZipCode], [Logitude], [Latitude], [PlantManagerGSN], [PlantRTM], [RegionID], [PlantTypeID], [ChangeTrackNumber], [LastModified], [Active]) VALUES (23, 1, NULL, NULL, N'DEN', N'Denver', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12, 3, -2104487990, CAST(N'2014-09-08 16:41:00' AS SmallDateTime), 0)
GO
INSERT [SupplyChain].[Plant] ([PlantID], [PlantSK], [SAPPlantNumber], [SAPSource], [PlantName], [PlantDesc], [Address1], [Address2], [City], [State], [ZipCode], [Logitude], [Latitude], [PlantManagerGSN], [PlantRTM], [RegionID], [PlantTypeID], [ChangeTrackNumber], [LastModified], [Active]) VALUES (24, 15, N'1517', N'SP7', N'SAC', N'Sacramento', N'2670 Land Ave.', NULL, N'Sacramento', N'CA', N'95815', CAST(-121.433449 AS Decimal(10, 6)), CAST(38.616131 AS Decimal(10, 6)), N'KUBDX001', N'DSD', 12, 3, 2033388372, CAST(N'2014-09-08 16:41:00' AS SmallDateTime), 1)
GO
INSERT [SupplyChain].[Plant] ([PlantID], [PlantSK], [SAPPlantNumber], [SAPSource], [PlantName], [PlantDesc], [Address1], [Address2], [City], [State], [ZipCode], [Logitude], [Latitude], [PlantManagerGSN], [PlantRTM], [RegionID], [PlantTypeID], [ChangeTrackNumber], [LastModified], [Active]) VALUES (25, 2, NULL, NULL, N'BUE', N'Buena Park', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13, 2, -1056566431, CAST(N'2014-09-08 16:41:00' AS SmallDateTime), 0)
GO
INSERT [SupplyChain].[Plant] ([PlantID], [PlantSK], [SAPPlantNumber], [SAPSource], [PlantName], [PlantDesc], [Address1], [Address2], [City], [State], [ZipCode], [Logitude], [Latitude], [PlantManagerGSN], [PlantRTM], [RegionID], [PlantTypeID], [ChangeTrackNumber], [LastModified], [Active]) VALUES (26, 8, N'1526', N'SP7', N'VER', N'Vernon', N'3220 E. 26th Street', NULL, N'Vernon', N'CA', N'90058', CAST(-118.223422 AS Decimal(10, 6)), CAST(34.006374 AS Decimal(10, 6)), N'SZAPX001', N'DSD', 13, 3, -1581143079, CAST(N'2014-09-08 16:41:00' AS SmallDateTime), 1)
GO
INSERT [SupplyChain].[Plant] ([PlantID], [PlantSK], [SAPPlantNumber], [SAPSource], [PlantName], [PlantDesc], [Address1], [Address2], [City], [State], [ZipCode], [Logitude], [Latitude], [PlantManagerGSN], [PlantRTM], [RegionID], [PlantTypeID], [ChangeTrackNumber], [LastModified], [Active]) VALUES (27, 28, N'1528', N'SP7', N'VIC', N'Victorville', N'18180 Gateway Drive', NULL, N'Victorville', N'CA', N'92394', CAST(-116.692221 AS Decimal(10, 6)), CAST(35.590017 AS Decimal(10, 6)), N'MALDX008', N'WD', 13, 1, 1357510740, CAST(N'2014-09-08 16:41:00' AS SmallDateTime), 1)
GO
INSERT [SupplyChain].[Plant] ([PlantID], [PlantSK], [SAPPlantNumber], [SAPSource], [PlantName], [PlantDesc], [Address1], [Address2], [City], [State], [ZipCode], [Logitude], [Latitude], [PlantManagerGSN], [PlantRTM], [RegionID], [PlantTypeID], [ChangeTrackNumber], [LastModified], [Active]) VALUES (28, 29, NULL, NULL, N'DBC', N'Bethlehem', N'2172 City Line Rd', NULL, N'Bethlehem', N'PA', N'18017', CAST(-75.423410 AS Decimal(10, 6)), CAST(40.653214 AS Decimal(10, 6)), NULL, NULL, 3, 1, -919126855, CAST(N'2014-11-13 02:30:00' AS SmallDateTime), 1)
GO
SET IDENTITY_INSERT [SupplyChain].[Plant] OFF
GO
SET IDENTITY_INSERT [SupplyChain].[PlantType] ON 

GO
INSERT [SupplyChain].[PlantType] ([PlantTypeID], [PlantTypeName], [LastModified]) VALUES (1, N'ASP', CAST(N'2014-09-08 16:41:00' AS SmallDateTime))
GO
INSERT [SupplyChain].[PlantType] ([PlantTypeID], [PlantTypeName], [LastModified]) VALUES (2, N'CPK', CAST(N'2014-09-08 16:41:00' AS SmallDateTime))
GO
INSERT [SupplyChain].[PlantType] ([PlantTypeID], [PlantTypeName], [LastModified]) VALUES (3, N'CSD', CAST(N'2014-09-08 16:41:00' AS SmallDateTime))
GO
INSERT [SupplyChain].[PlantType] ([PlantTypeID], [PlantTypeName], [LastModified]) VALUES (4, N'Water', CAST(N'2014-09-08 16:41:00' AS SmallDateTime))
GO
SET IDENTITY_INSERT [SupplyChain].[PlantType] OFF
GO
SET IDENTITY_INSERT [SupplyChain].[Region] ON 

GO
INSERT [SupplyChain].[Region] ([RegionID], [RegionName], [DivisionID], [LastModified]) VALUES (1, N'MW - Central', 1, CAST(N'2014-09-08 16:41:00' AS SmallDateTime))
GO
INSERT [SupplyChain].[Region] ([RegionID], [RegionName], [DivisionID], [LastModified]) VALUES (2, N'MW - West', 1, CAST(N'2014-09-08 16:41:00' AS SmallDateTime))
GO
INSERT [SupplyChain].[Region] ([RegionID], [RegionName], [DivisionID], [LastModified]) VALUES (3, N'NE - Northeast', 1, CAST(N'2014-09-08 16:41:00' AS SmallDateTime))
GO
INSERT [SupplyChain].[Region] ([RegionID], [RegionName], [DivisionID], [LastModified]) VALUES (4, N'Mexico', 2, CAST(N'2014-09-08 16:41:00' AS SmallDateTime))
GO
INSERT [SupplyChain].[Region] ([RegionID], [RegionName], [DivisionID], [LastModified]) VALUES (5, N'MW - East', 3, CAST(N'2014-09-08 16:41:00' AS SmallDateTime))
GO
INSERT [SupplyChain].[Region] ([RegionID], [RegionName], [DivisionID], [LastModified]) VALUES (6, N'MW - North', 3, CAST(N'2014-09-08 16:41:00' AS SmallDateTime))
GO
INSERT [SupplyChain].[Region] ([RegionID], [RegionName], [DivisionID], [LastModified]) VALUES (7, N'MW - Southeast', 3, CAST(N'2014-09-08 16:41:00' AS SmallDateTime))
GO
INSERT [SupplyChain].[Region] ([RegionID], [RegionName], [DivisionID], [LastModified]) VALUES (8, N'SW - Houston', 4, CAST(N'2014-09-08 16:41:00' AS SmallDateTime))
GO
INSERT [SupplyChain].[Region] ([RegionID], [RegionName], [DivisionID], [LastModified]) VALUES (9, N'SW - No. Texas', 4, CAST(N'2014-09-08 16:41:00' AS SmallDateTime))
GO
INSERT [SupplyChain].[Region] ([RegionID], [RegionName], [DivisionID], [LastModified]) VALUES (10, N'SW - So Texas', 4, CAST(N'2014-09-08 16:41:00' AS SmallDateTime))
GO
INSERT [SupplyChain].[Region] ([RegionID], [RegionName], [DivisionID], [LastModified]) VALUES (11, N'CO - Concentrate', 5, CAST(N'2014-09-08 16:41:00' AS SmallDateTime))
GO
INSERT [SupplyChain].[Region] ([RegionID], [RegionName], [DivisionID], [LastModified]) VALUES (12, N'SW - Northwest', 6, CAST(N'2014-09-08 16:41:00' AS SmallDateTime))
GO
INSERT [SupplyChain].[Region] ([RegionID], [RegionName], [DivisionID], [LastModified]) VALUES (13, N'SW - West Coast', 6, CAST(N'2014-09-08 16:41:00' AS SmallDateTime))
GO
SET IDENTITY_INSERT [SupplyChain].[Region] OFF
GO
SET IDENTITY_INSERT [SupplyChain].[TimeAggregation] ON 

GO
INSERT [SupplyChain].[TimeAggregation] ([AggregationID], [Name], [SortOrder], [StartAt], [Description], [Note], [Active]) VALUES (1, N'Today', 1, NULL, NULL, NULL, 1)
GO
INSERT [SupplyChain].[TimeAggregation] ([AggregationID], [Name], [SortOrder], [StartAt], [Description], [Note], [Active]) VALUES (2, N'WTD', 5, N'Monday', N'Week to Date', N'Average excluding empty date points', 0)
GO
INSERT [SupplyChain].[TimeAggregation] ([AggregationID], [Name], [SortOrder], [StartAt], [Description], [Note], [Active]) VALUES (3, N'MTD', 3, N'1st', N'Month to Date', N'Average excluding empty date points', 1)
GO
INSERT [SupplyChain].[TimeAggregation] ([AggregationID], [Name], [SortOrder], [StartAt], [Description], [Note], [Active]) VALUES (4, N'YTD', 4, N'1/1', N'Year to Date', N'Average excluding empty date points', 1)
GO
INSERT [SupplyChain].[TimeAggregation] ([AggregationID], [Name], [SortOrder], [StartAt], [Description], [Note], [Active]) VALUES (5, N'Last 7 Days', 2, NULL, N'Last 7 Days', NULL, 1)
GO
INSERT [SupplyChain].[TimeAggregation] ([AggregationID], [Name], [SortOrder], [StartAt], [Description], [Note], [Active]) VALUES (6, N'Last 30 Days', 6, NULL, N'Last 30 Days', NULL, 0)
GO
SET IDENTITY_INSERT [SupplyChain].[TimeAggregation] OFF
GO
ALTER TABLE [SupplyChain].[Plant]  WITH CHECK ADD  CONSTRAINT [FK_Plant_PlantType] FOREIGN KEY([PlantTypeID])
REFERENCES [SupplyChain].[PlantType] ([PlantTypeID])
GO
ALTER TABLE [SupplyChain].[Plant] CHECK CONSTRAINT [FK_Plant_PlantType]
GO
ALTER TABLE [SupplyChain].[Plant]  WITH CHECK ADD  CONSTRAINT [FK_Plant_Region] FOREIGN KEY([RegionID])
REFERENCES [SupplyChain].[Region] ([RegionID])
GO
ALTER TABLE [SupplyChain].[Plant] CHECK CONSTRAINT [FK_Plant_Region]
GO
ALTER TABLE [SupplyChain].[Region]  WITH CHECK ADD  CONSTRAINT [FK_Region_Division] FOREIGN KEY([DivisionID])
REFERENCES [SupplyChain].[Division] ([DivisionID])
GO
ALTER TABLE [SupplyChain].[Region] CHECK CONSTRAINT [FK_Region_Division]
GO
