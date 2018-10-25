USE [Portal_Data]
GO
/****** Object:  Table [Apacheta].[FleetLoader]    Script Date: 12/12/2014 10:50:28 AM ******/
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
/****** Object:  Table [Apacheta].[OriginalOrder]    Script Date: 12/12/2014 10:50:28 AM ******/
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
/****** Object:  Table [SAP].[BP7PlantInventory]    Script Date: 12/12/2014 10:50:28 AM ******/
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
/****** Object:  Table [SAP].[BP7SalesOfficeInventory]    Script Date: 12/12/2014 10:50:28 AM ******/
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
/****** Object:  Table [SAP].[BP7SalesOfficeMinMax]    Script Date: 12/12/2014 10:50:28 AM ******/
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
	[AvailableStock] [decimal](10, 1) NULL,
	[MinSafetyStock] [decimal](10, 1) NULL,
	[SAPPlantNumber] [int] NULL,
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
/****** Object:  Table [Shared].[DimDate]    Script Date: 12/12/2014 10:50:28 AM ******/
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
/****** Object:  Table [Staging].[BP7DailyPlantInventory]    Script Date: 12/12/2014 10:50:28 AM ******/
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
/****** Object:  Table [Staging].[BP7DailySalesOfficeInventory]    Script Date: 12/12/2014 10:50:28 AM ******/
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
/****** Object:  Table [Staging].[BP7DailySalesOfficeMinMax]    Script Date: 12/12/2014 10:50:28 AM ******/
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
	[SafetyStock] [decimal](9, 1) NULL,
	[AvailableStock] [decimal](10, 1) NULL,
	[MinSafetyStock] [decimal](10, 1) NULL,
	[SAPPlantNumber] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SupplyChain].[BranchProductLineThresholdOverRide]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain].[BranchProductLineThresholdOverRide](
	[BranchID] [int] NOT NULL,
	[TradeMarkID] [int] NOT NULL,
	[BPOOSLeftThreshold] [decimal](10, 2) NOT NULL,
	[BPOOSRightThreshold] [decimal](10, 2) NOT NULL,
	[BPDOSLeftThreshold] [decimal](10, 2) NOT NULL,
	[BPDOSRightThreshold] [decimal](10, 2) NOT NULL,
	[BPMinMaxLeftThreshold] [decimal](10, 2) NOT NULL,
	[BPMinMaxRightThreshold] [decimal](10, 2) NOT NULL,
 CONSTRAINT [PK_BranchProductLineThresholdOverRide] PRIMARY KEY CLUSTERED 
(
	[BranchID] ASC,
	[TradeMarkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SupplyChain].[BranchThreshold]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain].[BranchThreshold](
	[BranchID] [int] NOT NULL,
	[BranchOOSLeftThreshold] [decimal](10, 2) NOT NULL,
	[BranchOOSRightThreshold] [decimal](10, 2) NOT NULL,
	[BranchDOSLeftThreshold] [decimal](10, 2) NOT NULL,
	[BranchDOSRightThreshold] [decimal](10, 2) NOT NULL,
	[BranchMinMaxLeftThreshold] [decimal](10, 2) NOT NULL,
	[BranchMinMaxRightThreshold] [decimal](10, 2) NOT NULL,
 CONSTRAINT [PK_BranchThreshold] PRIMARY KEY CLUSTERED 
(
	[BranchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SupplyChain].[BranchTradeMarkThresholdOverRide]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain].[BranchTradeMarkThresholdOverRide](
	[BranchID] [int] NOT NULL,
	[TradeMarkID] [int] NOT NULL,
	[BTOOSLeftThreshold] [decimal](10, 2) NOT NULL,
	[BTOOSRightThreshold] [decimal](10, 2) NOT NULL,
	[BTDOSLeftThreshold] [decimal](10, 2) NOT NULL,
	[BTDOSRightThreshold] [decimal](10, 2) NOT NULL,
	[BTMinMaxLeftThreshold] [decimal](10, 2) NOT NULL,
	[BTMinMaxRightThreshold] [decimal](10, 2) NOT NULL,
 CONSTRAINT [PK_BranchTradeMarkThresholdOverRide] PRIMARY KEY CLUSTERED 
(
	[BranchID] ASC,
	[TradeMarkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SupplyChain].[DayLineShift]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SupplyChain].[DayLineShift](
	[DayLineShiftID] [int] IDENTITY(1,1) NOT NULL,
	[DayLineShiftSK] [int] NOT NULL,
	[ShiftDownTime] [int] NULL,
	[ShiftDuration] [int] NOT NULL,
	[RunDateID] [int] NOT NULL,
	[LineID] [int] NOT NULL,
	[ShiftID] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [varchar](50) NOT NULL,
 CONSTRAINT [PK_DayLineShift] PRIMARY KEY CLUSTERED 
(
	[DayLineShiftID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SupplyChain].[Departments]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SupplyChain].[Departments](
	[DeptID] [int] IDENTITY(1,1) NOT NULL,
	[DeptName] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[DeptID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SupplyChain].[Division]    Script Date: 12/12/2014 10:50:28 AM ******/
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
/****** Object:  Table [SupplyChain].[DownTime]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SupplyChain].[DownTime](
	[DownTimeID] [int] IDENTITY(1,1) NOT NULL,
	[DownTimeSK] [int] NOT NULL,
	[DayLineShiftID] [int] NOT NULL,
	[ItemNumber] [int] NOT NULL,
	[Duration] [int] NULL,
	[ReasonDetailID] [int] NULL,
	[ClaimedReasonID] [int] NULL,
	[LaborReleased] [bit] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [varchar](50) NOT NULL,
 CONSTRAINT [PK_DownTime] PRIMARY KEY CLUSTERED 
(
	[DownTimeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SupplyChain].[DownTimeReason]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SupplyChain].[DownTimeReason](
	[ReasonID] [int] IDENTITY(1,1) NOT NULL,
	[ReasonSK] [int] NOT NULL,
	[ReasonCode] [varchar](10) NOT NULL,
	[ReasonDesc] [varchar](50) NULL,
	[DownTimeReasonTypeID] [int] NOT NULL,
	[Active] [bit] NULL,
	[LastModified] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_DownTimeReason] PRIMARY KEY CLUSTERED 
(
	[ReasonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SupplyChain].[DownTimeReasonDetail]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SupplyChain].[DownTimeReasonDetail](
	[ReasonDetailID] [int] IDENTITY(1,1) NOT NULL,
	[ReasonDetailSK] [int] NOT NULL,
	[ReasonID] [int] NOT NULL,
	[ReasonDetailCode] [varchar](10) NULL,
	[ReasonDetailDesc] [varchar](50) NULL,
	[Active] [bit] NULL,
	[LastModified] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_DownTimeReasonDetail] PRIMARY KEY CLUSTERED 
(
	[ReasonDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SupplyChain].[DownTimeReasonType]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SupplyChain].[DownTimeReasonType](
	[DownTimeReasonTypeID] [int] IDENTITY(1,1) NOT NULL,
	[DownTimeReasonTypeName] [varchar](20) NOT NULL,
	[LastModified] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_DownTimeReasonType] PRIMARY KEY CLUSTERED 
(
	[DownTimeReasonTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SupplyChain].[FillerType]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SupplyChain].[FillerType](
	[FillerTypeID] [int] IDENTITY(1,1) NOT NULL,
	[FillerTypeName] [varchar](50) NOT NULL,
	[LastModified] [smalldatetime] NOT NULL CONSTRAINT [DF_FillerType_LastModified]  DEFAULT (getdate()),
 CONSTRAINT [PK_FillerType] PRIMARY KEY CLUSTERED 
(
	[FillerTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SupplyChain].[Line]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SupplyChain].[Line](
	[LineID] [int] IDENTITY(1,1) NOT NULL,
	[LineSK] [int] NOT NULL,
	[LineName] [varchar](50) NOT NULL,
	[PlantID] [int] NOT NULL,
	[LineTypeID] [int] NULL,
	[FillerTypeID] [int] NULL,
	[ChangeTrackNumber] [int] NOT NULL,
	[LastModified] [smalldatetime] NOT NULL CONSTRAINT [DF_Line_LastModified]  DEFAULT (getdate()),
 CONSTRAINT [PK_Line] PRIMARY KEY CLUSTERED 
(
	[LineID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SupplyChain].[LineType]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SupplyChain].[LineType](
	[LineTypeID] [int] IDENTITY(1,1) NOT NULL,
	[LineTypeName] [varchar](50) NOT NULL,
	[LastModified] [smalldatetime] NOT NULL CONSTRAINT [DF_LineType_LastModified]  DEFAULT (getdate()),
 CONSTRAINT [PK_LineType] PRIMARY KEY CLUSTERED 
(
	[LineTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SupplyChain].[MeasursType]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SupplyChain].[MeasursType](
	[MeasursID] [int] IDENTITY(1,1) NOT NULL,
	[DeptID] [int] NULL,
	[MeasursType] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[MeasursID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SupplyChain].[OverAllThreshold]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain].[OverAllThreshold](
	[OverAllThresholdID] [int] NOT NULL,
	[OverAllOOSLeftThreshold] [decimal](10, 2) NOT NULL,
	[OverAllOOSRightThreshold] [decimal](10, 2) NOT NULL,
	[OverAllDOSLeftThreshold] [decimal](10, 2) NOT NULL,
	[OverAllDOSRightThreshold] [decimal](10, 2) NOT NULL,
	[OverAllMinMaxLeftThreshold] [decimal](10, 2) NOT NULL,
	[OverAllMinMaxRightThreshold] [decimal](10, 2) NOT NULL,
 CONSTRAINT [PK_OverAllThreshold] PRIMARY KEY CLUSTERED 
(
	[OverAllThresholdID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SupplyChain].[ProductLineThreshold]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain].[ProductLineThreshold](
	[ProductLineID] [int] NOT NULL,
	[ProductLineOOSLeftThreshold] [decimal](10, 2) NOT NULL,
	[ProductLineOOSRightThreshold] [decimal](10, 2) NOT NULL,
	[ProductLineDOSLeftThreshold] [decimal](10, 2) NOT NULL,
	[ProductLineDOSRightThreshold] [decimal](10, 2) NOT NULL,
	[ProductLineMinMaxLeftThreshold] [decimal](10, 2) NOT NULL,
	[ProductLineMinMaxRightThreshold] [decimal](10, 2) NOT NULL,
 CONSTRAINT [PK_ProductLineID] PRIMARY KEY CLUSTERED 
(
	[ProductLineID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SupplyChain].[RefreshLog]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SupplyChain].[RefreshLog](
	[RefreshLogID] [int] IDENTITY(1,1) NOT NULL,
	[DurationInSeconds]  AS (datediff(second,[StartTime],[EndTime])),
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NULL,
	[HDRLastModified] [datetime] NULL,
	[RunLastModified] [datetime] NULL,
	[DownTimeLastModified] [datetime] NULL,
	[SanityCheck] [varchar](128) NULL,
 CONSTRAINT [PK_RefreshLog] PRIMARY KEY CLUSTERED 
(
	[RefreshLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SupplyChain].[RegionProductLineThresholdOverRide]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain].[RegionProductLineThresholdOverRide](
	[RegionID] [int] NOT NULL,
	[TradeMarkID] [int] NOT NULL,
	[RPOOSLeftThreshold] [decimal](10, 2) NOT NULL,
	[RPOOSRightThreshold] [decimal](10, 2) NOT NULL,
	[RPDOSLeftThreshold] [decimal](10, 2) NOT NULL,
	[RPDOSRightThreshold] [decimal](10, 2) NOT NULL,
	[RPMinMaxLeftThreshold] [decimal](10, 2) NOT NULL,
	[RPMinMaxRightThreshold] [decimal](10, 2) NOT NULL,
 CONSTRAINT [PK_RegionProductLineThresholdOverRide] PRIMARY KEY CLUSTERED 
(
	[RegionID] ASC,
	[TradeMarkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SupplyChain].[RegionThreshold]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain].[RegionThreshold](
	[RegionID] [int] NOT NULL,
	[RegionOOSLeftThreshold] [decimal](10, 2) NOT NULL,
	[RegionOOSRightThreshold] [decimal](10, 2) NOT NULL,
	[RegionDOSLeftThreshold] [decimal](10, 2) NOT NULL,
	[RegionDOSRightThreshold] [decimal](10, 2) NOT NULL,
	[RegionMinMaxLeftThreshold] [decimal](10, 2) NOT NULL,
	[RegionMinMaxRightThreshold] [decimal](10, 2) NOT NULL,
 CONSTRAINT [PK_RegionThreshold] PRIMARY KEY CLUSTERED 
(
	[RegionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SupplyChain].[RegionTradeMarkThresholdOverRide]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain].[RegionTradeMarkThresholdOverRide](
	[RegionID] [int] NOT NULL,
	[TradeMarkID] [int] NOT NULL,
	[RTOOSLeftThreshold] [decimal](10, 2) NOT NULL,
	[RTOOSRightThreshold] [decimal](10, 2) NOT NULL,
	[RTDOSLeftThreshold] [decimal](10, 2) NOT NULL,
	[RTDOSRightThreshold] [decimal](10, 2) NOT NULL,
	[RTMinMaxLeftThreshold] [decimal](10, 2) NOT NULL,
	[RTMinMaxRightThreshold] [decimal](10, 2) NOT NULL,
 CONSTRAINT [PK_RegionTradeMarkThresholdOverRide] PRIMARY KEY CLUSTERED 
(
	[RegionID] ASC,
	[TradeMarkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SupplyChain].[Run]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SupplyChain].[Run](
	[RunID] [int] IDENTITY(1,1) NOT NULL,
	[RunSK] [int] NOT NULL,
	[DayLineShiftID] [int] NOT NULL,
	[DayLineShiftSK] [int] NOT NULL,
	[ItemNumber] [int] NOT NULL,
	[MaterialID] [int] NULL,
	[RunDuration] [int] NOT NULL,
	[ActualQty] [decimal](9, 2) NOT NULL,
	[CapacityQty] [decimal](9, 2) NOT NULL,
	[PlanQty] [decimal](9, 2) NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Run] PRIMARY KEY CLUSTERED 
(
	[RunID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SupplyChain].[Shift]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SupplyChain].[Shift](
	[ShiftID] [int] NOT NULL,
	[ShiftSK] [int] NOT NULL,
	[ShiftName] [varchar](50) NOT NULL,
	[LastModified] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_Shift] PRIMARY KEY CLUSTERED 
(
	[ShiftID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SupplyChain].[tDsdCaseCut]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain].[tDsdCaseCut](
	[AnchorDateID] [int] NOT NULL,
	[RegionID] [int] NULL,
	[BranchID] [int] NOT NULL,
	[ProductLineID] [int] NULL,
	[TradeMarkID] [int] NULL,
	[BrandID] [int] NULL,
	[MaterialID] [int] NOT NULL,
	[PackageID] [int] NULL,
	[PackageConfID] [int] NULL,
	[PackageTypeID] [int] NULL,
	[AggregationID] [tinyint] NOT NULL,
	[Quantity] [int] NOT NULL,
	[CaseCut] [int] NULL,
	[OOS]  AS (([CaseCut]*(1.0))/[Quantity]),
	[UpdateTime] [datetime2](7) NULL CONSTRAINT [DF_tDsdCaseCut_UpdateTime]  DEFAULT (sysdatetime()),
 CONSTRAINT [PK_tDsdCaseCut] PRIMARY KEY CLUSTERED 
(
	[AnchorDateID] ASC,
	[AggregationID] ASC,
	[BranchID] ASC,
	[MaterialID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SupplyChain].[tDsdDailyBranchInventory]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain].[tDsdDailyBranchInventory](
	[DateID] [int] NOT NULL,
	[BUID] [int] NOT NULL,
	[RegionID] [int] NOT NULL,
	[AreaID] [int] NOT NULL,
	[BranchID] [int] NOT NULL,
	[ProductLineID] [int] NULL,
	[TradeMarkID] [int] NULL,
	[BrandID] [int] NULL,
	[MaterialID] [int] NOT NULL,
	[PackageID] [int] NULL,
	[PackageConfID] [int] NULL,
	[PackageTypeID] [int] NULL,
	[EndingInventory] [int] NOT NULL,
	[EndingInventoryCapped] [int] NOT NULL CONSTRAINT [DF_tDsdDailyBranchInventory_EndingInventoryCapped]  DEFAULT ((0)),
	[TransferOut] [int] NOT NULL,
	[TransferOutCapped] [int] NOT NULL CONSTRAINT [DF_tDsdDailyBranchInventory_TransferOutCapped]  DEFAULT ((0)),
	[CustomerShipment] [int] NOT NULL,
	[CustomerShipmentCapped] [int] NOT NULL CONSTRAINT [DF_tDsdDailyBranchInventory_CustomerShipmentCapped]  DEFAULT ((0)),
	[Past31DaysXferOutPlusShipment] [decimal](9, 1) NOT NULL CONSTRAINT [DF_tDsdDailyBranchInventory_Past31DaysXferOutPlusShipment]  DEFAULT ((0)),
	[DOS] [decimal](9, 1) NOT NULL CONSTRAINT [DF_tDsdDailyBranchInventory_DOS]  DEFAULT ((-1)),
	[UpdateDate] [datetime2](7) NOT NULL CONSTRAINT [DF_tDsdDailyBranchInventory_UpdateDate]  DEFAULT (sysdatetime()),
	[Past31DaysShipment] [decimal](9, 1) NULL,
	[DOSShipment] [decimal](9, 1) NULL,
 CONSTRAINT [PK_DsdDailyBranchInventory] PRIMARY KEY CLUSTERED 
(
	[DateID] ASC,
	[BranchID] ASC,
	[MaterialID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SupplyChain].[tDsdDailyCaseCut]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain].[tDsdDailyCaseCut](
	[DateID] [int] NOT NULL,
	[RegionID] [int] NOT NULL,
	[BranchID] [int] NOT NULL,
	[ProductLineID] [int] NULL,
	[TradeMarkID] [int] NULL,
	[BrandID] [int] NULL,
	[MaterialID] [int] NOT NULL,
	[PackageID] [int] NULL,
	[PackageConfID] [int] NULL,
	[PackageTypeID] [int] NULL,
	[Quantity] [int] NOT NULL,
	[CaseCut] [int] NOT NULL,
	[OOS]  AS (([CaseCut]*(1.0))/[Quantity]),
	[UpdateDate] [datetime2](7) NOT NULL CONSTRAINT [DF_tDsdDailyCaseCut_UpdateDate]  DEFAULT (sysdatetime()),
 CONSTRAINT [PK_DsdDailyCaseCut] PRIMARY KEY CLUSTERED 
(
	[DateID] ASC,
	[BranchID] ASC,
	[MaterialID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SupplyChain].[tDsdDailyMinMax]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain].[tDsdDailyMinMax](
	[DateID] [int] NOT NULL,
	[BUID] [int] NOT NULL,
	[RegionID] [int] NOT NULL,
	[AreaID] [int] NOT NULL,
	[BranchID] [int] NOT NULL,
	[ProductLineID] [int] NULL,
	[TradeMarkID] [int] NULL,
	[BrandID] [int] NULL,
	[MaterialID] [int] NOT NULL,
	[PackageID] [int] NULL,
	[PackageConfID] [int] NULL,
	[PackageTypeID] [int] NULL,
	[EndingInventory] [int] NOT NULL,
	[EndingInventoryCapped] [int] NOT NULL CONSTRAINT [DF_tDsdDailyMinMax_EndingInventoryCapped]  DEFAULT ((0)),
	[MaxStock] [int] NOT NULL,
	[SafetyStock] [int] NOT NULL,
	[IsBelowMin] [int] NOT NULL,
	[IsCompliant] [int] NOT NULL,
	[IsAboveMax] [int] NOT NULL,
	[UpdateDate] [datetime2](7) NOT NULL CONSTRAINT [DF_tDsdDailyMinMax_UpdateDate]  DEFAULT (sysdatetime()),
	[AvailableStock] [decimal](10, 1) NULL,
	[MinSafetyStock] [decimal](10, 1) NULL,
 CONSTRAINT [PK_DsdDailyMinMax] PRIMARY KEY CLUSTERED 
(
	[DateID] ASC,
	[BranchID] ASC,
	[MaterialID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SupplyChain].[tDsdOpenOrder]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain].[tDsdOpenOrder](
	[DateID] [int] NOT NULL,
	[RegionID] [int] NULL,
	[BranchID] [int] NOT NULL,
	[ProductLineID] [int] NULL,
	[TradeMarkID] [int] NULL,
	[BrandID] [int] NULL,
	[MaterialID] [int] NOT NULL,
	[PackageID] [int] NULL,
	[PackageConfID] [int] NULL,
	[PackageTypeID] [int] NULL,
	[Quantity] [int] NULL,
 CONSTRAINT [PK_tDsdOpenOrder] PRIMARY KEY CLUSTERED 
(
	[DateID] ASC,
	[BranchID] ASC,
	[MaterialID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SupplyChain].[tDsdPotentialCaseCut]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain].[tDsdPotentialCaseCut](
	[RegionID] [int] NOT NULL,
	[TradeMarkID] [int] NOT NULL,
	[PackageID] [int] NOT NULL,
	[PackageTypeID] [int] NOT NULL,
	[BranchID] [int] NOT NULL,
	[MaterialID] [int] NOT NULL,
	[HowFarInFuture] [int] NOT NULL,
	[EndingInventory] [int] NOT NULL,
	[Shipment] [int] NOT NULL,
	[OpenOrder] [int] NOT NULL,
	[PotentialCaseCut] [int] NOT NULL,
	[PotentialOOS] [decimal](6, 4) NOT NULL,
 CONSTRAINT [PK_tDsdPotentialCaseCut] PRIMARY KEY CLUSTERED 
(
	[BranchID] ASC,
	[MaterialID] ASC,
	[HowFarInFuture] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SupplyChain].[tLineDailyKPI]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain].[tLineDailyKPI](
	[DateID] [int] NOT NULL,
	[LineID] [int] NOT NULL,
	[TME] [decimal](7, 6) NULL,
	[AvgFlavorCODuration] [decimal](12, 7) NULL,
	[AvgPkgCODuration] [decimal](12, 7) NULL,
	[SumDuration] [decimal](9, 1) NULL,
	[SumActualQty] [decimal](9, 1) NOT NULL,
	[SumCapacityQty] [decimal](9, 1) NOT NULL,
	[SumPlanQty] [decimal](9, 1) NOT NULL,
	[CountRun] [smallint] NOT NULL,
	[CountFlavorCO] [smallint] NULL,
	[CountPkgCO] [smallint] NULL,
	[SumFlavorCODuration] [decimal](9, 1) NULL,
	[SumPkgCODuration] [decimal](9, 1) NULL,
	[CountCO] [smallint] NULL,
	[SumCODuration] [decimal](9, 1) NULL,
	[AdjustedSumCODuration] [decimal](16, 8) NULL,
	[IsCODurationAdjusted]  AS (CONVERT([bit],case when [SumCODuration]=[AdjustedSumCODuration] then (0) else (1) end)),
 CONSTRAINT [PK_tLineDailyReport] PRIMARY KEY CLUSTERED 
(
	[DateID] ASC,
	[LineID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SupplyChain].[tLineKPI]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain].[tLineKPI](
	[AnchorDateID] [int] NOT NULL,
	[AggregationID] [tinyint] NOT NULL,
	[LineID] [int] NOT NULL,
	[TME]  AS ([SumActualQty]/[SumCapacityQty]+[SumCODuration]/[SumDuration]),
	[AvgFlavorCODuration]  AS (case when [CountFlavorCO]=(0) then NULL else [SumFlavorCODuration]/[CountFlavorCO] end),
	[SumFlavorCODuration] [decimal](9, 1) NULL,
	[CountFlavorCO] [int] NULL,
	[SumActualQty] [decimal](9, 1) NULL,
	[SumCapacityQty] [decimal](9, 1) NULL,
	[SumPlanQty] [decimal](9, 1) NULL,
	[SumDuration] [decimal](9, 1) NULL,
	[SumCODuration] [decimal](9, 1) NULL,
 CONSTRAINT [PK_tLineKPIDetail] PRIMARY KEY CLUSTERED 
(
	[AnchorDateID] ASC,
	[AggregationID] ASC,
	[LineID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SupplyChain].[tManufacturingMeasures_ToBeDeleted]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain].[tManufacturingMeasures_ToBeDeleted](
	[PlantID] [int] NOT NULL,
	[AFCOMDT] [decimal](5, 2) NOT NULL,
	[AFCOMDTPY] [decimal](5, 2) NOT NULL,
	[RecordableMDT] [int] NOT NULL,
	[RecordableMDTPY] [int] NOT NULL,
	[InvCasesMDT] [int] NOT NULL,
	[InvCasesMDTPy] [int] NOT NULL,
	[AnchorDateID] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [SupplyChain].[tPlantDailyKPI]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain].[tPlantDailyKPI](
	[DateID] [int] NOT NULL,
	[PlantID] [int] NOT NULL,
	[TME] [decimal](7, 6) NULL,
	[SumCODuration] [decimal](9, 1) NULL,
	[SumDuration] [decimal](9, 1) NULL,
	[SumActualQty] [decimal](9, 1) NULL,
	[SumCapacityQty] [decimal](9, 1) NULL,
	[AvgFlavorCODuration] [decimal](12, 7) NULL,
	[SumFlavorCODuration] [decimal](9, 1) NULL,
 CONSTRAINT [PK_tPlantDailyReport] PRIMARY KEY CLUSTERED 
(
	[DateID] ASC,
	[PlantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SupplyChain].[tPlantKPI]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain].[tPlantKPI](
	[AnchorDateID] [int] NOT NULL,
	[AggregationID] [tinyint] NOT NULL,
	[PlantID] [int] NOT NULL,
	[TME] [decimal](7, 6) NULL,
	[SumCODuration] [decimal](9, 1) NULL,
	[SumDuration] [decimal](9, 1) NULL,
	[SumActualQty] [decimal](9, 1) NULL,
	[SumCapacityQty] [decimal](9, 1) NULL,
	[AvgFlavorCODuration] [decimal](12, 7) NULL,
	[SumFlavorCODuration] [decimal](9, 1) NULL,
	[CountFlavorCO] [int] NULL,
	[SumPlanQty] [decimal](9, 1) NULL,
 CONSTRAINT [PK_tPlantKPIDetail] PRIMARY KEY CLUSTERED 
(
	[AnchorDateID] ASC,
	[AggregationID] ASC,
	[PlantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SupplyChain].[tRegionBranchTradeMark]    Script Date: 12/12/2014 10:50:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain].[tRegionBranchTradeMark](
	[RegionID] [int] NOT NULL,
	[BranchID] [int] NOT NULL,
	[TradeMarkID] [int] NOT NULL,
 CONSTRAINT [PK_tRegionBranchTradeMark] PRIMARY KEY CLUSTERED 
(
	[RegionID] ASC,
	[BranchID] ASC,
	[TradeMarkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [SupplyChain].[DayLineShift]  WITH CHECK ADD  CONSTRAINT [FK_DayLineShift_DimDate] FOREIGN KEY([RunDateID])
REFERENCES [Shared].[DimDate] ([DateID])
GO
ALTER TABLE [SupplyChain].[DayLineShift] CHECK CONSTRAINT [FK_DayLineShift_DimDate]
GO
ALTER TABLE [SupplyChain].[DayLineShift]  WITH CHECK ADD  CONSTRAINT [FK_DayLineShift_Line] FOREIGN KEY([LineID])
REFERENCES [SupplyChain].[Line] ([LineID])
GO
ALTER TABLE [SupplyChain].[DayLineShift] CHECK CONSTRAINT [FK_DayLineShift_Line]
GO
ALTER TABLE [SupplyChain].[DayLineShift]  WITH CHECK ADD  CONSTRAINT [FK_DayLineShift_Shift] FOREIGN KEY([ShiftID])
REFERENCES [SupplyChain].[Shift] ([ShiftID])
GO
ALTER TABLE [SupplyChain].[DayLineShift] CHECK CONSTRAINT [FK_DayLineShift_Shift]
GO
ALTER TABLE [SupplyChain].[DownTime]  WITH CHECK ADD  CONSTRAINT [FK_DownTime_DayLineShift] FOREIGN KEY([DayLineShiftID])
REFERENCES [SupplyChain].[DayLineShift] ([DayLineShiftID])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain].[DownTime] CHECK CONSTRAINT [FK_DownTime_DayLineShift]
GO
ALTER TABLE [SupplyChain].[DownTime]  WITH CHECK ADD  CONSTRAINT [FK_DownTime_DownTimeReasonDetail] FOREIGN KEY([ReasonDetailID])
REFERENCES [SupplyChain].[DownTimeReasonDetail] ([ReasonDetailID])
GO
ALTER TABLE [SupplyChain].[DownTime] CHECK CONSTRAINT [FK_DownTime_DownTimeReasonDetail]
GO
ALTER TABLE [SupplyChain].[DownTimeReason]  WITH CHECK ADD  CONSTRAINT [FK_DownTimeReason_DownTimeReasonType] FOREIGN KEY([DownTimeReasonTypeID])
REFERENCES [SupplyChain].[DownTimeReasonType] ([DownTimeReasonTypeID])
GO
ALTER TABLE [SupplyChain].[DownTimeReason] CHECK CONSTRAINT [FK_DownTimeReason_DownTimeReasonType]
GO
ALTER TABLE [SupplyChain].[DownTimeReasonDetail]  WITH CHECK ADD  CONSTRAINT [FK_DownTimeReasonDetail_DownTimeReason] FOREIGN KEY([ReasonID])
REFERENCES [SupplyChain].[DownTimeReason] ([ReasonID])
GO
ALTER TABLE [SupplyChain].[DownTimeReasonDetail] CHECK CONSTRAINT [FK_DownTimeReasonDetail_DownTimeReason]
GO
ALTER TABLE [SupplyChain].[MeasursType]  WITH CHECK ADD FOREIGN KEY([DeptID])
REFERENCES [SupplyChain].[Departments] ([DeptID])
GO
ALTER TABLE [SupplyChain].[Run]  WITH CHECK ADD  CONSTRAINT [FK_Run_DayLineShift] FOREIGN KEY([DayLineShiftID])
REFERENCES [SupplyChain].[DayLineShift] ([DayLineShiftID])
GO
ALTER TABLE [SupplyChain].[Run] CHECK CONSTRAINT [FK_Run_DayLineShift]
GO
ALTER TABLE [SupplyChain].[Run]  WITH CHECK ADD  CONSTRAINT [FK_Run_Material] FOREIGN KEY([MaterialID])
REFERENCES [SAP].[Material] ([MaterialID])
GO
ALTER TABLE [SupplyChain].[Run] CHECK CONSTRAINT [FK_Run_Material]
GO
ALTER TABLE [SupplyChain].[tDsdCaseCut]  WITH CHECK ADD  CONSTRAINT [FK_tDsdCaseCut_AggregationID] FOREIGN KEY([AggregationID])
REFERENCES [SupplyChain].[TimeAggregation] ([AggregationID])
GO
ALTER TABLE [SupplyChain].[tDsdCaseCut] CHECK CONSTRAINT [FK_tDsdCaseCut_AggregationID]
GO
ALTER TABLE [SupplyChain].[tDsdCaseCut]  WITH CHECK ADD  CONSTRAINT [FK_tDsdCaseCut_Branch] FOREIGN KEY([BranchID])
REFERENCES [SAP].[Branch] ([BranchID])
GO
ALTER TABLE [SupplyChain].[tDsdCaseCut] CHECK CONSTRAINT [FK_tDsdCaseCut_Branch]
GO
ALTER TABLE [SupplyChain].[tDsdCaseCut]  WITH CHECK ADD  CONSTRAINT [FK_tDsdCaseCut_DimDate] FOREIGN KEY([AnchorDateID])
REFERENCES [Shared].[DimDate] ([DateID])
GO
ALTER TABLE [SupplyChain].[tDsdCaseCut] CHECK CONSTRAINT [FK_tDsdCaseCut_DimDate]
GO
ALTER TABLE [SupplyChain].[tDsdCaseCut]  WITH CHECK ADD  CONSTRAINT [FK_tDsdCaseCut_Material] FOREIGN KEY([MaterialID])
REFERENCES [SAP].[Material] ([MaterialID])
GO
ALTER TABLE [SupplyChain].[tDsdCaseCut] CHECK CONSTRAINT [FK_tDsdCaseCut_Material]
GO
ALTER TABLE [SupplyChain].[tDsdDailyBranchInventory]  WITH CHECK ADD  CONSTRAINT [FK_DsdDailyBranchInventory_Branch] FOREIGN KEY([BranchID])
REFERENCES [SAP].[Branch] ([BranchID])
GO
ALTER TABLE [SupplyChain].[tDsdDailyBranchInventory] CHECK CONSTRAINT [FK_DsdDailyBranchInventory_Branch]
GO
ALTER TABLE [SupplyChain].[tDsdDailyBranchInventory]  WITH CHECK ADD  CONSTRAINT [FK_DsdDailyBranchInventory_DimDate] FOREIGN KEY([DateID])
REFERENCES [Shared].[DimDate] ([DateID])
GO
ALTER TABLE [SupplyChain].[tDsdDailyBranchInventory] CHECK CONSTRAINT [FK_DsdDailyBranchInventory_DimDate]
GO
ALTER TABLE [SupplyChain].[tDsdDailyBranchInventory]  WITH CHECK ADD  CONSTRAINT [FK_DsdDailyBranchInventory_Material] FOREIGN KEY([MaterialID])
REFERENCES [SAP].[Material] ([MaterialID])
GO
ALTER TABLE [SupplyChain].[tDsdDailyBranchInventory] CHECK CONSTRAINT [FK_DsdDailyBranchInventory_Material]
GO
ALTER TABLE [SupplyChain].[tDsdDailyCaseCut]  WITH CHECK ADD  CONSTRAINT [FK_DsdDailyCaseCut_Branch] FOREIGN KEY([BranchID])
REFERENCES [SAP].[Branch] ([BranchID])
GO
ALTER TABLE [SupplyChain].[tDsdDailyCaseCut] CHECK CONSTRAINT [FK_DsdDailyCaseCut_Branch]
GO
ALTER TABLE [SupplyChain].[tDsdDailyCaseCut]  WITH CHECK ADD  CONSTRAINT [FK_DsdDailyCaseCut_DimDate] FOREIGN KEY([DateID])
REFERENCES [Shared].[DimDate] ([DateID])
GO
ALTER TABLE [SupplyChain].[tDsdDailyCaseCut] CHECK CONSTRAINT [FK_DsdDailyCaseCut_DimDate]
GO
ALTER TABLE [SupplyChain].[tDsdDailyCaseCut]  WITH CHECK ADD  CONSTRAINT [FK_DsdDailyCaseCut_Material] FOREIGN KEY([MaterialID])
REFERENCES [SAP].[Material] ([MaterialID])
GO
ALTER TABLE [SupplyChain].[tDsdDailyCaseCut] CHECK CONSTRAINT [FK_DsdDailyCaseCut_Material]
GO
ALTER TABLE [SupplyChain].[tDsdDailyMinMax]  WITH CHECK ADD  CONSTRAINT [FK_DsdDailyMinMax_Branch] FOREIGN KEY([BranchID])
REFERENCES [SAP].[Branch] ([BranchID])
GO
ALTER TABLE [SupplyChain].[tDsdDailyMinMax] CHECK CONSTRAINT [FK_DsdDailyMinMax_Branch]
GO
ALTER TABLE [SupplyChain].[tDsdDailyMinMax]  WITH CHECK ADD  CONSTRAINT [FK_DsdDailyMinMax_DimDate] FOREIGN KEY([DateID])
REFERENCES [Shared].[DimDate] ([DateID])
GO
ALTER TABLE [SupplyChain].[tDsdDailyMinMax] CHECK CONSTRAINT [FK_DsdDailyMinMax_DimDate]
GO
ALTER TABLE [SupplyChain].[tDsdDailyMinMax]  WITH CHECK ADD  CONSTRAINT [FK_DsdDailyMinMax_Material] FOREIGN KEY([MaterialID])
REFERENCES [SAP].[Material] ([MaterialID])
GO
ALTER TABLE [SupplyChain].[tDsdDailyMinMax] CHECK CONSTRAINT [FK_DsdDailyMinMax_Material]
GO
ALTER TABLE [SupplyChain].[tLineDailyKPI]  WITH CHECK ADD  CONSTRAINT [FK_tLineDailyReport_DimDate] FOREIGN KEY([DateID])
REFERENCES [Shared].[DimDate] ([DateID])
GO
ALTER TABLE [SupplyChain].[tLineDailyKPI] CHECK CONSTRAINT [FK_tLineDailyReport_DimDate]
GO
ALTER TABLE [SupplyChain].[tLineDailyKPI]  WITH CHECK ADD  CONSTRAINT [FK_tLineDailyReport_Line] FOREIGN KEY([LineID])
REFERENCES [SupplyChain].[Line] ([LineID])
GO
ALTER TABLE [SupplyChain].[tLineDailyKPI] CHECK CONSTRAINT [FK_tLineDailyReport_Line]
GO
ALTER TABLE [SupplyChain].[tLineKPI]  WITH CHECK ADD  CONSTRAINT [FK_tLineKPI_TimeAggregation] FOREIGN KEY([AggregationID])
REFERENCES [SupplyChain].[TimeAggregation] ([AggregationID])
GO
ALTER TABLE [SupplyChain].[tLineKPI] CHECK CONSTRAINT [FK_tLineKPI_TimeAggregation]
GO
ALTER TABLE [SupplyChain].[tLineKPI]  WITH CHECK ADD  CONSTRAINT [FK_tLineKPIDetail_Line] FOREIGN KEY([LineID])
REFERENCES [SupplyChain].[Line] ([LineID])
GO
ALTER TABLE [SupplyChain].[tLineKPI] CHECK CONSTRAINT [FK_tLineKPIDetail_Line]
GO
ALTER TABLE [SupplyChain].[tPlantDailyKPI]  WITH CHECK ADD  CONSTRAINT [FK_tPlantDailyReport_DimDate] FOREIGN KEY([DateID])
REFERENCES [Shared].[DimDate] ([DateID])
GO
ALTER TABLE [SupplyChain].[tPlantDailyKPI] CHECK CONSTRAINT [FK_tPlantDailyReport_DimDate]
GO
ALTER TABLE [SupplyChain].[tPlantDailyKPI]  WITH CHECK ADD  CONSTRAINT [FK_tPlantDailyReport_Plant] FOREIGN KEY([PlantID])
REFERENCES [SupplyChain].[Plant] ([PlantID])
GO
ALTER TABLE [SupplyChain].[tPlantDailyKPI] CHECK CONSTRAINT [FK_tPlantDailyReport_Plant]
GO
ALTER TABLE [SupplyChain].[tPlantKPI]  WITH CHECK ADD  CONSTRAINT [FK_tPlantKPI_TimeAggregation] FOREIGN KEY([AggregationID])
REFERENCES [SupplyChain].[TimeAggregation] ([AggregationID])
GO
ALTER TABLE [SupplyChain].[tPlantKPI] CHECK CONSTRAINT [FK_tPlantKPI_TimeAggregation]
GO
ALTER TABLE [SupplyChain].[tPlantKPI]  WITH CHECK ADD  CONSTRAINT [FK_tPlantKPIDetail_Plant] FOREIGN KEY([PlantID])
REFERENCES [SupplyChain].[Plant] ([PlantID])
GO
ALTER TABLE [SupplyChain].[tPlantKPI] CHECK CONSTRAINT [FK_tPlantKPIDetail_Plant]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'hdr_id column from dbo.production_hdr' , @level0type=N'SCHEMA',@level0name=N'SupplyChain', @level1type=N'TABLE',@level1name=N'DayLineShift', @level2type=N'COLUMN',@level2name=N'DayLineShiftSK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The normalized version of production_hdr table. RunDateID, LineID and ShiftID is the combo key.' , @level0type=N'SCHEMA',@level0name=N'SupplyChain', @level1type=N'TABLE',@level1name=N'DayLineShift'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'run_id in production_run table' , @level0type=N'SCHEMA',@level0name=N'SupplyChain', @level1type=N'TABLE',@level1name=N'Run', @level2type=N'COLUMN',@level2name=N'RunSK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mirrors production_run table. Contains 2 pairs of combo keys for looking up: DayLineShiftID and ItemNumber as well as DayLIneShiftSK and ItemNumber' , @level0type=N'SCHEMA',@level0name=N'SupplyChain', @level1type=N'TABLE',@level1name=N'Run'
GO
