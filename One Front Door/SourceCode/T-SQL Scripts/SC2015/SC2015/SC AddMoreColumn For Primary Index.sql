USE [Portal_Data204]
GO


Alter Table [SupplyChain].[tDsdDailyBranchInventory]
Alter Column [RegionID] Int Not NUll

Alter Table [SupplyChain].[tDsdDailyBranchInventory]
Alter Column TradeMarkID Int Not NUll

Alter Table [SupplyChain].[tDsdDailyBranchInventory]
Alter Column PackageTypeID Int Not NUll

Alter Table [SupplyChain].[tDsdDailyBranchInventory]
Alter Column PackageID Int Not NUll

Alter Table [SupplyChain].tDsdDailyMinMax
Alter Column [RegionID] Int Not NUll

Alter Table [SupplyChain].tDsdDailyMinMax
Alter Column TradeMarkID Int Not NUll

Alter Table [SupplyChain].tDsdDailyMinMax
Alter Column PackageTypeID Int Not NUll

Alter Table [SupplyChain].tDsdDailyMinMax
Alter Column PackageID Int Not NUll


/****** Object:  Index [PK_DsdDailyMinMax]    Script Date: 2/9/2015 12:52:12 PM ******/
ALTER TABLE [SupplyChain].[tDsdDailyMinMax] DROP CONSTRAINT [PK_DsdDailyMinMax]
GO

/****** Object:  Index [PK_DsdDailyMinMax]    Script Date: 2/9/2015 12:52:12 PM ******/
ALTER TABLE [SupplyChain].[tDsdDailyMinMax] ADD  CONSTRAINT [PK_DsdDailyMinMax] PRIMARY KEY CLUSTERED 
(
	[DateID] ASC,
	[BranchID] ASC,
	RegionID ASC,
	[MaterialID] ASC,
	TradeMarkID ASC,
	PackageTypeID ASC,
	PackageID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100)
GO

/****** Object:  Index [PK_DsdDailyBranchInventory]    Script Date: 2/9/2015 12:54:05 PM ******/
ALTER TABLE [SupplyChain].[tDsdDailyBranchInventory] DROP CONSTRAINT [PK_DsdDailyBranchInventory]
GO

/****** Object:  Index [PK_DsdDailyBranchInventory]    Script Date: 2/9/2015 12:54:05 PM ******/
ALTER TABLE [SupplyChain].[tDsdDailyBranchInventory] ADD  CONSTRAINT [PK_DsdDailyBranchInventory] PRIMARY KEY CLUSTERED 
(
	[DateID] ASC,
	[BranchID] ASC,
	RegionID ASC,
	[MaterialID] ASC,
	TradeMarkID ASC,
	PackageTypeID ASC,
	PackageID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100)
GO

