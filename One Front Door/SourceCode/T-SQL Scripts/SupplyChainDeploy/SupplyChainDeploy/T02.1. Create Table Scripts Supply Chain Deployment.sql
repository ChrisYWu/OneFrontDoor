Use Portal_Data
Go

If Not Exists (Select * From sys.schemas Where Name = 'SupplyChain')
Begin
Print 'Creating SupplyChain Schema'
	Exec('Create SCHEMA SupplyChain')
	
End

Print 'Creating Table [Person].[MyPlants]'
GO
/****** Object:  Table [Person].[MyPlants]    Script Date: 11/19/2014 12:54:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Person].[MyPlants](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SPUserProfileID] [int] NULL,
	[PlantID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
Print 'Creating Table [Person].[UserProductLine] '
GO
/****** Object:  Table [Person].[UserProductLine]    Script Date: 11/19/2014 12:54:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Person].[UserProductLine](
	[UserProductLineID] [int] IDENTITY(1,1) NOT NULL,
	[GSN] [varchar](50) NULL,
	[SPUserProfileID] [int] NULL,
	[ProductLineID] [int] NULL,
	[TradeMarkID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserProductLineID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO

Print 'Creating Table [SupplyChain].[Departments]  '
GO
/****** Object:  Table [SupplyChain].[Departments]    Script Date: 11/19/2014 12:54:22 PM ******/
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
Print 'Creating Table [SupplyChain].[MeasursType] '
GO
/****** Object:  Table [SupplyChain].[MeasursType]    Script Date: 11/19/2014 12:54:22 PM ******/
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
-------------------------------------------
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
/****** Object:  Table [SupplyChain].[BranchThreshold]    Script Date: 11/19/2014 3:25:31 PM ******/
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
/****** Object:  Table [SupplyChain].[BranchTradeMarkThresholdOverRide]    Script Date: 11/19/2014 3:25:31 PM ******/
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
/****** Object:  Table [SupplyChain].[OverAllThreshold]    Script Date: 11/19/2014 3:25:31 PM ******/
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
/****** Object:  Table [SupplyChain].[ProductLineThreshold]    Script Date: 11/19/2014 3:25:31 PM ******/
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
/****** Object:  Table [SupplyChain].[RegionProductLineThresholdOverRide]    Script Date: 11/19/2014 3:25:31 PM ******/
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
/****** Object:  Table [SupplyChain].[RegionThreshold]    Script Date: 11/19/2014 3:25:31 PM ******/
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
/****** Object:  Table [SupplyChain].[RegionTradeMarkThresholdOverRide]    Script Date: 11/19/2014 3:25:31 PM ******/
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

/****** Object:  Table [SupplyChain].[tManufacturingMeasures_ToBeDeleted]    Script Date: 11/19/2014 5:58:24 PM ******/
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
Go 
