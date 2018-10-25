USE Portal_Data
GO

/****** Object:  Table [Apacheta].[FleetLoader]    Script Date: 11/18/2014 2:09:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Apacheta].[FleetLoader](
	[SESSION_DATE] [date] NOT NULL,
	[ROUTE_ID] [varchar](30) NOT NULL,
	[LOCATION_ID] [varchar](30) NOT NULL,
	[ORDER_NUMBER] [varchar](30) NOT NULL,
	[BAY_NUMBER] [varchar](30) NOT NULL,
	[SKU] [varchar](64) NOT NULL,
	[QUANTITY] [int] NOT NULL CONSTRAINT [DF_FleetLoader_QUANTITY]  DEFAULT ((0)),
	[TOTAL_QUANTITY] [int] NOT NULL CONSTRAINT [DF_FleetLoader_TOTAL_QUANTITY]  DEFAULT ((0)),
	[LAST_UPDATE] [datetime2](0) NOT NULL,
 CONSTRAINT [PK_FleetLoader] PRIMARY KEY CLUSTERED 
(
	[SESSION_DATE] ASC,
	[ROUTE_ID] ASC,
	[LOCATION_ID] ASC,
	[ORDER_NUMBER] ASC,
	[BAY_NUMBER] ASC,
	[SKU] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Apacheta].[OriginalOrder]    Script Date: 11/18/2014 2:09:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Apacheta].[OriginalOrder](
	[DeliveryDate] [date] NOT NULL,
	[SAPBranchID] [varchar](4) NOT NULL,
	[RouteNumber] [varchar](12) NOT NULL,
	[SAPMaterialID] [varchar](12) NOT NULL,
	[OrderNumber] [varchar](20) NOT NULL,
	[CaseQuantity] [int] NULL,
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
	[DeliveryDate] ASC,
	[RouteNumber] ASC,
	[SAPMaterialID] ASC,
	[OrderNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SAP].[BP7PlantInventory]    Script Date: 11/18/2014 2:09:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SAP].[BP7PlantInventory](
	[SAPPlantNumber] [varchar](50) NOT NULL,
	[SAPSalesOfficeNumber] [varchar](50) NOT NULL,
	[SAPMaterialID] [varchar](50) NOT NULL,
	[CalendarDate] [varchar](50) NOT NULL,
	[TransferOut] [decimal](9, 1) NULL,
	[CustomerShipment] [decimal](9, 1) NULL,
	[EndingInventory] [decimal](10, 1) NULL,
 CONSTRAINT [PK_BP7PlantInventory] PRIMARY KEY CLUSTERED 
(
	[CalendarDate] ASC,
	[SAPPlantNumber] ASC,
	[SAPMaterialID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SAP].[BP7SalesOfficeInventory]    Script Date: 11/18/2014 2:09:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SAP].[BP7SalesOfficeInventory](
	[SAPSalesOfficeNumber] [varchar](50) NOT NULL,
	[SAPMaterialID] [varchar](50) NOT NULL,
	[CalendarDate] [varchar](50) NOT NULL,
	[TransferOut] [decimal](9, 1) NULL,
	[CustomerShipment] [decimal](9, 1) NULL,
	[EndingInventory] [decimal](10, 1) NULL,
 CONSTRAINT [PK_BP7SalesOfficeInventory] PRIMARY KEY CLUSTERED 
(
	[CalendarDate] ASC,
	[SAPSalesOfficeNumber] ASC,
	[SAPMaterialID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SAP].[BP7SalesOfficeMinMax]    Script Date: 11/18/2014 2:09:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SAP].[BP7SalesOfficeMinMax](
	[SAPSalesOfficeNumber] [varchar](50) NOT NULL,
	[SAPMaterialID] [varchar](50) NOT NULL,
	[CalendarDate] [varchar](50) NOT NULL,
	[EndingInventory] [decimal](10, 1) NULL,
	[MaxStock] [decimal](9, 1) NULL,
	[SafetyStock] [decimal](9, 1) NULL,
 CONSTRAINT [PK_BP7SalesOfficeMinMax] PRIMARY KEY CLUSTERED 
(
	[CalendarDate] ASC,
	[SAPSalesOfficeNumber] ASC,
	[SAPMaterialID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Staging].[BP7DailyPlantInventory]    Script Date: 11/18/2014 2:09:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Staging].[BP7DailyPlantInventory](
	[SAPPlantNumber] [varchar](50) NOT NULL,
	[SAPSalesOfficeNumber] [varchar](50) NOT NULL,
	[SAPMaterialID] [varchar](50) NOT NULL,
	[CalendarDate] [varchar](50) NOT NULL,
	[TransferOut] [decimal](9, 1) NULL,
	[CustomerShipment] [decimal](9, 1) NULL,
	[EndingInventory] [decimal](10, 1) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Staging].[BP7DailySalesOfficeInventory]    Script Date: 11/18/2014 2:09:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Staging].[BP7DailySalesOfficeInventory](
	[SAPSalesOfficeNumber] [varchar](50) NOT NULL,
	[SAPMaterialID] [varchar](50) NOT NULL,
	[CalendarDate] [varchar](50) NOT NULL,
	[TransferOut] [decimal](9, 1) NULL,
	[CustomerShipment] [decimal](9, 1) NULL,
	[EndingInventory] [decimal](10, 1) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Staging].[BP7DailySalesOfficeMinMax]    Script Date: 11/18/2014 2:09:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Staging].[BP7DailySalesOfficeMinMax](
	[SAPSalesOfficeNumber] [varchar](50) NOT NULL,
	[SAPMaterialID] [varchar](50) NOT NULL,
	[CalendarDate] [varchar](50) NOT NULL,
	[EndingInventory] [decimal](10, 1) NULL,
	[MaxStock] [decimal](9, 1) NULL,
	[SafetyStock] [decimal](9, 1) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO

/****** Object:  Table [Shared].[DimDate]    Script Date: 11/18/2014 2:05:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Shared].[DimDate](
	[DateID] [int] NOT NULL,
	[Date] [date] NOT NULL,
	[Day] [tinyint] NOT NULL,
	[DaySuffix] [varchar](4) NOT NULL,
	[DayOfWeek] [varchar](9) NOT NULL,
	[DOWInMonth] [tinyint] NOT NULL,
	[DayOfYear] [int] NOT NULL,
	[WeekOfYear] [tinyint] NOT NULL,
	[WeekOfMonth] [tinyint] NOT NULL,
	[Month] [tinyint] NOT NULL,
	[MonthName] [varchar](9) NOT NULL,
	[Quarter] [tinyint] NOT NULL,
	[QuarterName] [varchar](6) NOT NULL,
	[Year] [char](4) NOT NULL,
	[StandardDate] [varchar](10) NULL,
	[HolidayText] [varchar](50) NULL,
	[WeekBeginingDateID] [int] NULL,
	[MonthBeginingDateID] [int] NULL,
	[YearBeginingDateID] [int] NULL,
	[Last7DaysBeginingDateID] [int] NULL,
	[Last31DaysBeginingDateID] [int] NULL,
	[WeekNumberDisplay]  AS ((('Y'+substring(CONVERT([varchar],datepart(year,[date])),(3),(2)))+' W')+CONVERT([varchar],[WeekOFYear])),
 CONSTRAINT [PK_DimDate] PRIMARY KEY CLUSTERED 
(
	[DateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO