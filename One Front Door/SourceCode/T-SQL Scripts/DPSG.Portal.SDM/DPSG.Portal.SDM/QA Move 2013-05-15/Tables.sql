USE [Portal_QA]
GO
/****** Object:  Table [EDGE].[AccountMapping]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EDGE].[AccountMapping](
	[Option Id] [int] NOT NULL,
	[OptionName] [nvarchar](255) NOT NULL,
	[Enabled] [bit] NOT NULL,
	[SAPLocalChainId] [nvarchar](50) NULL,
	[SAPLocalChain] [nvarchar](50) NULL,
	[SAPRegionalChainID] [nvarchar](50) NULL,
	[SAPRegionalChain] [nvarchar](50) NULL,
	[SAPNationalChainID] [nvarchar](50) NULL,
	[SAPNationalChain] [nvarchar](50) NULL,
 CONSTRAINT [PK_Account_1] PRIMARY KEY CLUSTERED 
(
	[Option Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [EDGE].[BrandMapping]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EDGE].[BrandMapping](
	[ContentId] [int] NOT NULL,
	[Name] [nvarchar](255) NULL,
	[ProductCode] [nvarchar](255) NULL,
	[SAPTradeMarkId] [nvarchar](50) NULL,
	[SAPTradeMark] [nvarchar](50) NULL,
	[SAPBrandId] [nvarchar](50) NULL,
	[SAPBrand] [nvarchar](50) NULL,
 CONSTRAINT [PK_Brand_1] PRIMARY KEY CLUSTERED 
(
	[ContentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [EDGE].[ChannelMapping]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EDGE].[ChannelMapping](
	[OptionId] [int] NOT NULL,
	[ChannelName] [nvarchar](255) NOT NULL,
	[Enabled] [bit] NOT NULL,
	[SAPChannelId] [nvarchar](50) NULL,
	[SAPChannel] [nvarchar](50) NULL,
	[SAPSuperChannelID] [nvarchar](50) NULL,
	[SAPSuperChannel] [nvarchar](50) NULL,
 CONSTRAINT [PK_Channel_1] PRIMARY KEY CLUSTERED 
(
	[OptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
USE [Portal_Data]
GO

/****** Object:  Table [EDGE].[ErrorHandler]    Script Date: 5/17/2013 2:05:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [EDGE].[ErrorHandler](
	[ErrorID] [int] IDENTITY(1,1) NOT NULL,
	[ErrorCode] [varchar](85) NOT NULL,
	[ErrorMessgae] [varchar](255) NOT NULL,
	[ErrorDate] [datetime] NOT NULL,
	[ContentID] [varchar](210) NULL,
 CONSTRAINT [PK_ErrorHandler] PRIMARY KEY CLUSTERED 
(
	[ErrorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
/****** Object:  Table [EDGE].[PitPackageSizeMapping]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [EDGE].[PitPackageSizeMapping](
	[PackageSizeId] [int] NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[Ordinal] [int] NOT NULL,
	[Enabled] [bit] NOT NULL,
	[SAPPackConfID] [varchar](50) NULL,
	[SAPPackTypeID] [varchar](50) NULL,
	[PackConfMappingComments] [varchar](500) NULL,
	[PackTypeMappingComments] [varchar](500) NULL,
 CONSTRAINT [PK_PitPackageSize] PRIMARY KEY CLUSTERED 
(
	[PackageSizeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [EDGE].[RPLAttachementType]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [EDGE].[RPLAttachementType](
	[AttachmentType] [varchar](50) NOT NULL,
	[SPContentType] [varchar](50) NULL,
 CONSTRAINT [PK_RPLAttachementType] PRIMARY KEY CLUSTERED 
(
	[AttachmentType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [EDGE].[RPLAttachment]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [EDGE].[RPLAttachment](
	[AttachmentID] [int] IDENTITY(1,1) NOT NULL,
	[ItemID] [int] NOT NULL,
	[ContentID] [varchar](50) NULL,
	[FileName] [varchar](128) NULL,
	[PhysicalFile] [varbinary](max) NULL,
	[AttachmentType] [varchar](50) NOT NULL,
	[ReceivedDate] [datetime] NOT NULL,
	[TestData] [bit] NULL,
 CONSTRAINT [PK_RPLAttachment] PRIMARY KEY CLUSTERED 
(
	[AttachmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [EDGE].[RPLItem]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [EDGE].[RPLItem](
	[ItemID] [int] IDENTITY(1,1) NOT NULL,
	[ContentID] [varchar](50) NOT NULL,
	[Tittle] [varchar](128) NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[ExpirationDateUTC] [datetime] NULL,
	[ReferenceName] [varchar](128) NULL,
	[ProgramNumber] [int] NULL,
	[ProgramDetail] [varchar](512) NULL,
	[Price] [varchar](128) NULL,
	[DateMail] [datetime] NULL,
	[RouteToMarkets] [varchar](255) NULL,
	[BigBetsName] [varchar](255) NULL,
	[CostPerStore] [bit] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[ReceivedDate] [datetime] NOT NULL,
	[TestData] [bit] NULL,
 CONSTRAINT [PK_RPLItem] PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [EDGE].[RPLItemAccount]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [EDGE].[RPLItemAccount](
	[ItemID] [int] NOT NULL,
	[ContentID] [varchar](50) NULL,
	[SAPNationalChainID] [varchar](50) NULL,
	[SAPRegionalChainID] [varchar](50) NULL,
	[SAPLocalChainID] [varchar](50) NULL,
	[AccountName] [varchar](50) NOT NULL,
	[TestData] [bit] NULL,
 CONSTRAINT [PK_RPLItemAccount] PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [EDGE].[RPLItemBrand]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [EDGE].[RPLItemBrand](
	[ItemID] [int] NOT NULL,
	[BrandName] [varchar](50) NOT NULL,
	[ContentID] [varchar](50) NULL,
	[SAPTradeMarkID] [varchar](50) NULL,
	[SAPBrandID] [varchar](50) NULL,
	[TestData] [bit] NULL,
 CONSTRAINT [PK_RPLItemBrand] PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC,
	[BrandName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [EDGE].[RPLItemChannel]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [EDGE].[RPLItemChannel](
	[ItemID] [int] NOT NULL,
	[ContentID] [varchar](50) NULL,
	[SAPSupperChannelID] [varchar](50) NULL,
	[SAPChannelID] [varchar](50) NULL,
	[ChannelName] [varchar](50) NOT NULL,
	[TestData] [bit] NULL,
 CONSTRAINT [PK_RPLItemChannel] PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [EDGE].[RPLItemNAE]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [EDGE].[RPLItemNAE](
	[ItemID] [int] NOT NULL,
	[ContentID] [varchar](50) NULL,
	[FirstName] [varchar](128) NULL,
	[LastName] [varchar](128) NULL,
	[Email] [varchar](255) NULL,
	[GSN] [varchar](20) NULL,
	[TestData] [bit] NULL,
 CONSTRAINT [PK_RPLItemNAE] PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [EDGE].[RPLItemPackage]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [EDGE].[RPLItemPackage](
	[RPLItemPackageID] [int] IDENTITY(1,1) NOT NULL,
	[ItemID] [int] NOT NULL,
	[ContentID] [varchar](50) NULL,
	[SAPConfigurationID] [varchar](50) NULL,
	[SAPTypeID] [varchar](50) NULL,
	[PackageName] [varchar](50) NOT NULL,
	[TestData] [bit] NULL,
 CONSTRAINT [PK_RPLItemPackage_1] PRIMARY KEY CLUSTERED 
(
	[RPLItemPackageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [EDGE].[UserMapping]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EDGE].[UserMapping](
	[UserId] [nvarchar](50) NOT NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[EDGEEmail] [nvarchar](50) NULL,
	[Company] [nvarchar](150) NULL,
	[Title] [nvarchar](150) NULL,
	[CreateDate] [nvarchar](50) NULL,
	[ModifyDate] [nvarchar](50) NULL,
	[Deleted] [nchar](10) NULL,
	[USUserGroup] [nvarchar](50) NULL,
	[CAUserGroup] [nvarchar](50) NULL,
	[Status] [nvarchar](50) NULL,
	[UserLevel] [nvarchar](50) NULL,
	[LastLogin] [nvarchar](50) NULL,
	[DPSGUserID] [nvarchar](50) NULL,
	[DPSGUserEmail] [nvarchar](50) NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [EDGE].[WebServiceLog]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [EDGE].[WebServiceLog](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[ServiceName] [varchar](128) NOT NULL,
	[OperationName] [varchar](50) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[InternalReferecen] [varchar](50) NULL,
	[InternelReferenceType] [varchar](50) NULL,
	[ExternalReference] [varchar](50) NULL,
	[ExternalReferenceType] [varchar](50) NULL,
	[Detail] [varchar](500) NULL,
	[Json] [varchar](max) NULL,
	[ValidationSuccessful] [bit] NULL,
	[ValidationDetail] [varchar](500) NULL,
	[Test] [bit] NULL,
 CONSTRAINT [PK_Validation] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [MSTR].[DimBranchPlan]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MSTR].[DimBranchPlan](
	[monthid] [int] NOT NULL,
	[BranchID] [int] NOT NULL,
	[planVolume] [numeric](10, 2) NOT NULL,
 CONSTRAINT [PK_FactAnnualPlan] PRIMARY KEY CLUSTERED 
(
	[monthid] ASC,
	[BranchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [MSTR].[DimBrandPackageMarginTiers]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [MSTR].[DimBrandPackageMarginTiers](
	[BrandId] [int] NOT NULL,
	[PackageId] [int] NOT NULL,
	[MarginTier] [varchar](10) NOT NULL,
	[CreatedOn] [datetime] NULL,
	[UpdateOn] [datetime] NULL,
 CONSTRAINT [PK_DimBrandPackageMarginTiers] PRIMARY KEY NONCLUSTERED 
(
	[BrandId] ASC,
	[PackageId] ASC,
	[MarginTier] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [MSTR].[DimDay]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MSTR].[DimDay](
	[DayDate] [datetime] NOT NULL,
	[MonthID] [int] NULL,
	[QuarterID] [smallint] NULL,
	[YearID] [smallint] NULL,
	[PrevDayDate] [datetime] NULL,
	[LMDayDate] [datetime] NULL,
	[LQDayDate] [datetime] NULL,
	[LYDayDate] [datetime] NULL,
	[WeekID] [int] NULL,
	[LWDayDate] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [MSTR].[DimGOALMetric]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [MSTR].[DimGOALMetric](
	[MetricID] [int] IDENTITY(1,1) NOT NULL,
	[MetricName] [varchar](100) NULL,
	[LongDescription] [varchar](255) NULL,
	[iPadDescription] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MetricID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [MSTR].[DimMetricName]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [MSTR].[DimMetricName](
	[MetricID] [varchar](4) NOT NULL,
	[MetricName] [varchar](25) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [MSTR].[DimMonth]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MSTR].[DimMonth](
	[MonthID] [int] NOT NULL,
	[MonthDate] [datetime] NULL,
	[MonthDesc] [nvarchar](50) NULL,
	[MonthOfYear] [tinyint] NULL,
	[QuarterID] [smallint] NULL,
	[YearID] [smallint] NULL,
	[MonthDuration] [tinyint] NULL,
	[PrevMonthID] [int] NULL,
	[LQMonthID] [int] NULL,
	[LYMonthID] [int] NULL,
 CONSTRAINT [PK_DimMonth] PRIMARY KEY CLUSTERED 
(
	[MonthID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [MSTR].[DimMydaySalesPlanVersions]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [MSTR].[DimMydaySalesPlanVersions](
	[VersionID] [int] NOT NULL,
	[VersionDesc] [varchar](100) NOT NULL,
	[VersionValue] [int] NOT NULL,
	[CreatedOn] [datetime] NULL,
 CONSTRAINT [PK_DimMydaySalesPlanVersions] PRIMARY KEY CLUSTERED 
(
	[VersionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [MSTR].[DimQuarter]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MSTR].[DimQuarter](
	[QuarterID] [smallint] NOT NULL,
	[QuarterDate] [datetime] NULL,
	[QuarterDesc] [nvarchar](50) NULL,
	[YearID] [smallint] NULL,
	[QuarterDuration] [tinyint] NULL,
	[PrevQuarterID] [int] NULL,
	[LYQuarterID] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [MSTR].[DimSuperChannelForComparison]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MSTR].[DimSuperChannelForComparison](
	[SAPSuperChannelId] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [MSTR].[DimTENBrands]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MSTR].[DimTENBrands](
	[BrandID] [int] NOT NULL,
	[instertedOn] [datetime] NULL,
	[TenBrandDescription] [nvarchar](50) NULL,
 CONSTRAINT [PK_DimTENBrands] PRIMARY KEY CLUSTERED 
(
	[BrandID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [MSTR].[DimWeek]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MSTR].[DimWeek](
	[WeekID] [int] NOT NULL,
	[WeekDate] [datetime] NULL,
	[WeekDesc] [nvarchar](50) NULL,
	[WeekOfYear] [int] NULL,
	[MonthID] [int] NULL,
	[QuarterID] [int] NULL,
	[YearID] [int] NULL,
	[PrevWeekID] [int] NULL,
	[LQWeekID] [int] NULL,
	[LYWeekID] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [MSTR].[DimYear]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MSTR].[DimYear](
	[YearID] [smallint] NOT NULL,
	[YearDate] [datetime] NULL,
	[YearDuration] [smallint] NULL,
	[PrevYearID] [smallint] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [MSTR].[FactGOALDeployment]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MSTR].[FactGOALDeployment](
	[BUID] [int] NOT NULL,
	[RegionID] [int] NOT NULL,
	[BranchID] [int] NOT NULL,
	[Month] [datetime] NOT NULL,
	[MetricID] [int] NOT NULL,
	[Value] [float] NULL,
	[Target] [float] NULL,
	[JOP] [float] NULL,
	[Format] [int] NOT NULL,
	[Threshold] [int] NULL,
	[Load Date] [datetime] NOT NULL,
 CONSTRAINT [PK_FactGOALDeployment] PRIMARY KEY CLUSTERED 
(
	[BUID] ASC,
	[RegionID] ASC,
	[BranchID] ASC,
	[Month] ASC,
	[MetricID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [MSTR].[FactMyDayBranchPlanRanking]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MSTR].[FactMyDayBranchPlanRanking](
	[MonthID] [int] NOT NULL,
	[VersionID] [int] NOT NULL,
	[RouteID] [int] NOT NULL,
	[PlanCases] [numeric](12, 4) NOT NULL,
	[ActualSales] [bigint] NULL,
	[RecordDate] [datetime] NULL,
 CONSTRAINT [PK_FactMyDayBranchPlanRanking] PRIMARY KEY CLUSTERED 
(
	[MonthID] ASC,
	[VersionID] ASC,
	[RouteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [MSTR].[FactMyDayCustomer]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MSTR].[FactMyDayCustomer](
	[MonthID] [int] NOT NULL,
	[AccountID] [int] NOT NULL,
	[BrandID] [int] NOT NULL,
	[PackageID] [int] NOT NULL,
	[BevTypeID] [int] NOT NULL,
	[InternalCategoryID] [int] NOT NULL,
	[MTDConvertedCases] [numeric](18, 4) NULL,
	[YTDConvertedCases] [numeric](18, 4) NULL,
	[LYCMConvertedCases] [numeric](18, 4) NULL,
	[MTDRevenue] [numeric](18, 4) NULL,
	[YTDRevenue] [numeric](18, 4) NULL,
	[LYCMRevenue] [numeric](18, 4) NULL,
	[Avg3MonthProRated] [numeric](18, 4) NULL,
	[Avg3Month] [numeric](18, 4) NULL,
	[RecordDate] [datetime] NULL,
 CONSTRAINT [PK_FactMyDayCustomer] PRIMARY KEY CLUSTERED 
(
	[MonthID] ASC,
	[AccountID] ASC,
	[BrandID] ASC,
	[PackageID] ASC,
	[BevTypeID] ASC,
	[InternalCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [MSTR].[FactMyDayCustomerSummary]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MSTR].[FactMyDayCustomerSummary](
	[AccountID] [int] NOT NULL,
	[BrandID] [int] NOT NULL,
	[PackageID] [int] NOT NULL,
	[BevTypeID] [int] NOT NULL,
	[InternalCategoryID] [int] NOT NULL,
	[MTDConvertedCases] [numeric](18, 4) NULL,
	[YTDConvertedCases] [numeric](18, 4) NULL,
	[LYCMConvertedCases] [numeric](18, 4) NULL,
	[MTDRevenue] [numeric](18, 4) NULL,
	[YTDRevenue] [numeric](18, 4) NULL,
	[LYCMRevenue] [numeric](18, 4) NULL,
	[Avg3MonthProRated] [numeric](18, 4) NULL,
	[Avg3Month] [numeric](18, 4) NULL,
	[RecordDate] [datetime] NULL,
 CONSTRAINT [pk_FactMyDayCustSummary] PRIMARY KEY CLUSTERED 
(
	[AccountID] ASC,
	[BrandID] ASC,
	[PackageID] ASC,
	[BevTypeID] ASC,
	[InternalCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [MSTR].[FactMyDayRoutePlan]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MSTR].[FactMyDayRoutePlan](
	[RouteID] [int] NOT NULL,
	[MonthID] [int] NOT NULL,
	[VersionID] [int] NOT NULL,
	[PlanCases] [numeric](12, 4) NULL,
	[RecordDate] [datetime] NULL,
 CONSTRAINT [PK_FactMyDaySalesOfficePlan] PRIMARY KEY CLUSTERED 
(
	[RouteID] ASC,
	[MonthID] ASC,
	[VersionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [MSTR].[FactOFDCasesCuts]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MSTR].[FactOFDCasesCuts](
	[BranchID] [int] NULL,
	[BrandID] [int] NULL,
	[PackageID] [int] NULL,
	[CasesCut] [int] NULL,
	[RecordDate] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [MSTR].[FactOFDDailyMetrics]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [MSTR].[FactOFDDailyMetrics](
	[BranchID] [int] NULL,
	[MetricDate] [smalldatetime] NULL,
	[MetricID] [varchar](4) NULL,
	[Metric] [numeric](10, 2) NULL,
	[RecordDate] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [MSTR].[GetRouteDetail]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [MSTR].[GetRouteDetail](
	[AccountID] [int] NOT NULL,
	[RouteID] [int] NOT NULL,
	[SAPAccountNumber] [bigint] NOT NULL,
	[AccountName] [varchar](128) NOT NULL,
	[Longitude] [decimal](10, 6) NULL,
	[Latitude] [decimal](10, 6) NULL,
	[Today] [varchar](5) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [MSTR].[LogFactMyDayCustomer]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [MSTR].[LogFactMyDayCustomer](
	[LoadDate] [datetime] NULL,
	[Destination] [varchar](10) NULL,
	[RecordsLoaded] [bigint] NULL,
	[TotalCases] [numeric](18, 4) NULL,
	[TotalRevenue] [numeric](18, 4) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [MSTR].[RelMyDaySalesOfficePlanVersion]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MSTR].[RelMyDaySalesOfficePlanVersion](
	[BranchID] [int] NOT NULL,
	[VersionID] [int] NOT NULL,
 CONSTRAINT [PK_RelMyDaySalesOfficePlanVersion] PRIMARY KEY CLUSTERED 
(
	[BranchID] ASC,
	[VersionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [MSTR].[SourceGOALDeployment]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MSTR].[SourceGOALDeployment](
	[Business Unit] [nvarchar](255) NULL,
	[Region] [nvarchar](255) NOT NULL,
	[Branch] [nvarchar](255) NOT NULL,
	[Month] [datetime] NOT NULL,
	[Metric] [nvarchar](255) NOT NULL,
	[iPad Description] [nvarchar](255) NOT NULL,
	[Value] [float] NULL,
	[Target] [float] NULL,
	[JOP] [nvarchar](255) NULL,
	[Format] [float] NULL,
	[Threshold] [float] NULL,
	[Description] [nvarchar](255) NULL,
	[Load Date] [datetime] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [MSTR].[STG_Hispanic]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [MSTR].[STG_Hispanic](
	[customers] [varchar](50) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [MSTR].[SurveyCustomers]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [MSTR].[SurveyCustomers](
	[SCustId] [int] IDENTITY(1,1) NOT NULL,
	[StoreNo] [int] NULL,
	[GroupName] [varchar](100) NULL,
	[ChainName] [varchar](100) NULL,
	[CustAddress] [varchar](100) NULL,
	[CustCity] [varchar](100) NULL,
	[CustState] [varchar](2) NULL,
	[latitude] [numeric](12, 9) NULL,
	[longitude] [numeric](12, 9) NULL,
 CONSTRAINT [PK_SurveyCustomers] PRIMARY KEY CLUSTERED 
(
	[SCustId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [MSTR].[SurveyPhotos]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [MSTR].[SurveyPhotos](
	[PhotoID] [int] IDENTITY(1,1) NOT NULL,
	[PhotoName] [varchar](200) NULL,
	[PhotoCaption] [varchar](100) NULL,
	[PhotoFlag] [int] NULL,
	[PhotoTimestamp] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[PhotoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [MSTR].[SurveyQuestion]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [MSTR].[SurveyQuestion](
	[surveyId] [int] NOT NULL,
	[questionId] [int] NOT NULL,
	[questionGroup] [varchar](100) NOT NULL,
	[QuestionText] [varchar](5000) NOT NULL,
	[insertdate] [datetime] NULL,
 CONSTRAINT [PK_SurveyQuestion] PRIMARY KEY CLUSTERED 
(
	[surveyId] ASC,
	[questionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [MSTR].[SurveyResults]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [MSTR].[SurveyResults](
	[surveyId] [int] NOT NULL,
	[userId] [varchar](10) NOT NULL,
	[questionId] [int] NOT NULL,
	[response] [varchar](1000) NOT NULL,
	[insertdate] [datetime] NULL,
 CONSTRAINT [PK_SurveyResults] PRIMARY KEY CLUSTERED 
(
	[surveyId] ASC,
	[userId] ASC,
	[questionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [MSTR].[SurveyResultsStaging]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [MSTR].[SurveyResultsStaging](
	[surveyId] [int] NULL,
	[customerId] [int] NULL,
	[userId] [varchar](10) NULL,
	[DQ1] [int] NULL,
	[DQ2] [int] NULL,
	[DQ3] [int] NULL,
	[PDQ1] [int] NULL,
	[PDQ2] [int] NULL,
	[SPQ1] [int] NULL,
	[GMQ1] [int] NULL,
	[GMQ2] [int] NULL,
	[GMQ3] [int] NULL,
	[GMQ4] [int] NULL,
	[insertdate] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [MSTR].[Surveys]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [MSTR].[Surveys](
	[surveyId] [int] NOT NULL,
	[surveyDescription] [varchar](1000) NOT NULL,
	[insertdate] [datetime] NULL,
 CONSTRAINT [PK_Surveys] PRIMARY KEY CLUSTERED 
(
	[surveyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [MSTR].[SurveyUser]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [MSTR].[SurveyUser](
	[surveyId] [int] NOT NULL,
	[userId] [varchar](10) NOT NULL,
	[insertdate] [datetime] NULL,
 CONSTRAINT [PK_SurveyUser] PRIMARY KEY CLUSTERED 
(
	[surveyId] ASC,
	[userId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [MSTR].[TransMTDDay]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MSTR].[TransMTDDay](
	[DayDate] [datetime] NOT NULL,
	[MTDDayDate] [datetime] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [MSTR].[TransQTDDay]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MSTR].[TransQTDDay](
	[DayDate] [datetime] NULL,
	[QTDDayDate] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [MSTR].[TransWTDDay]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MSTR].[TransWTDDay](
	[DayDate] [datetime] NOT NULL,
	[WTDDayDate] [datetime] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [MSTR].[TransYTDDay]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MSTR].[TransYTDDay](
	[DayDate] [datetime] NULL,
	[YTD_DayDate] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [MSTR].[WDDetailSurveyResults]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [MSTR].[WDDetailSurveyResults](
	[Userid] [varchar](10) NULL,
	[customerid] [int] NULL,
	[HPGal_SKU] [int] NULL,
	[HP32_SKU] [int] NULL,
	[Motts64_SKU] [int] NULL,
	[Motts128_SKU] [int] NULL,
	[CLAMATO64_SKU] [int] NULL,
	[CLAMATO32_SKU] [int] NULL,
	[HP10_SKU] [int] NULL,
	[Motts8_SKU] [int] NULL,
	[MottsMFTTetra_SKU] [int] NULL,
	[Yoohoo_SKU] [int] NULL,
	[VITACOCOKIDS_SKU] [int] NULL,
	[CLAMATOCANS_SKU] [int] NULL,
	[Apple636_SKU] [int] NULL,
	[Apple4SP_SKU] [int] NULL,
	[AppleMS_SKU] [int] NULL,
	[IBC_SKU] [int] NULL,
	[CRUSH_SKU] [int] NULL,
	[MrMrsT1L_SKU] [int] NULL,
	[MrMrsT175L_SKU] [int] NULL,
	[Roses_SKU] [int] NULL,
	[HPGal_BLOCKED] [int] NULL,
	[HP32_BLOCKED] [int] NULL,
	[Motts64_BLOCKED] [int] NULL,
	[Motts128_BLOCKED] [int] NULL,
	[CLAMATO64_BLOCKED] [int] NULL,
	[CLAMATO32_BLOCKED] [int] NULL,
	[HP10_BLOCKED] [int] NULL,
	[Motts8_BLOCKED] [int] NULL,
	[MottsMFTTetra_BLOCKED] [int] NULL,
	[Yoohoo_BLOCKED] [int] NULL,
	[VITACOCOKIDS_BLOCKED] [int] NULL,
	[CLAMATOCANS_BLOCKED] [int] NULL,
	[Apple636_BLOCKED] [int] NULL,
	[Apple4SP_BLOCKED] [int] NULL,
	[AppleMS_BLOCKED] [int] NULL,
	[IBC_BLOCKED] [int] NULL,
	[CRUSH_BLOCKED] [int] NULL,
	[MrMrsT1L_BLOCKED] [int] NULL,
	[MrMrsT175L_BLOCKED] [int] NULL,
	[Roses_BLOCKED] [int] NULL,
	[HPGal_EDPRICE] [numeric](7, 2) NULL,
	[HP32_EDPRICE] [numeric](7, 2) NULL,
	[Motts64_EDPRICE] [numeric](7, 2) NULL,
	[Motts128_EDPRICE] [numeric](7, 2) NULL,
	[CLAMATO64_EDPRICE] [numeric](7, 2) NULL,
	[CLAMATO32_EDPRICE] [numeric](7, 2) NULL,
	[HP10_EDPRICE] [numeric](7, 2) NULL,
	[Motts8_EDPRICE] [numeric](7, 2) NULL,
	[MottsMFTTetra_EDPRICE] [numeric](7, 2) NULL,
	[Yoohoo_EDPRICE] [numeric](7, 2) NULL,
	[VITACOCOKIDS_EDPRICE] [numeric](7, 2) NULL,
	[CLAMATOCANS_EDPRICE] [numeric](7, 2) NULL,
	[Apple636_EDPRICE] [numeric](7, 2) NULL,
	[Apple4SP_EDPRICE] [numeric](7, 2) NULL,
	[AppleMS_EDPRICE] [numeric](7, 2) NULL,
	[IBC_EDPRICE] [numeric](7, 2) NULL,
	[CRUSH_EDPRICE] [numeric](7, 2) NULL,
	[MrMrsT1L_EDPRICE] [numeric](7, 2) NULL,
	[MrMrsT175L_EDPRICE] [numeric](7, 2) NULL,
	[Roses_EDPRICE] [numeric](7, 2) NULL,
	[HPGal_EDCOMPPRICE] [int] NULL,
	[HP32_EDCOMPPRICE] [int] NULL,
	[Motts64_EDCOMPPRICE] [int] NULL,
	[Motts128_EDCOMPPRICE] [int] NULL,
	[CLAMATO64_EDCOMPPRICE] [int] NULL,
	[CLAMATO32_EDCOMPPRICE] [int] NULL,
	[HP10_EDCOMPPRICE] [int] NULL,
	[Motts8_EDCOMPPRICE] [int] NULL,
	[MottsMFTTetra_EDCOMPPRICE] [int] NULL,
	[Yoohoo_EDCOMPPRICE] [int] NULL,
	[VITACOCOKIDS_EDCOMPPRICE] [int] NULL,
	[CLAMATOCANS_EDCOMPPRICE] [int] NULL,
	[Apple636_EDCOMPPRICE] [int] NULL,
	[Apple4SP_EDCOMPPRICE] [int] NULL,
	[AppleMS_EDCOMPPRICE] [int] NULL,
	[IBC_EDCOMPPRICE] [int] NULL,
	[CRUSH_EDCOMPPRICE] [int] NULL,
	[MrMrsT1L_EDCOMPPRICE] [int] NULL,
	[MrMrsT175L_EDCOMPPRICE] [int] NULL,
	[Roses_EDCOMPPRICE] [int] NULL,
	[HPGal_PROMO] [int] NULL,
	[HP32_PROMO] [int] NULL,
	[Motts64_PROMO] [int] NULL,
	[Motts128_PROMO] [int] NULL,
	[CLAMATO64_PROMO] [int] NULL,
	[CLAMATO32_PROMO] [int] NULL,
	[HP10_PROMO] [int] NULL,
	[Motts8_PROMO] [int] NULL,
	[MottsMFTTetra_PROMO] [int] NULL,
	[Yoohoo_PROMO] [int] NULL,
	[VITACOCOKIDS_PROMO] [int] NULL,
	[CLAMATOCANS_PROMO] [int] NULL,
	[Apple636_PROMO] [int] NULL,
	[Apple4SP_PROMO] [int] NULL,
	[AppleMS_PROMO] [int] NULL,
	[IBC_PROMO] [int] NULL,
	[CRUSH_PROMO] [int] NULL,
	[MrMrsT1L_PROMO] [int] NULL,
	[MrMrsT175L_PROMO] [int] NULL,
	[Roses_PROMO] [int] NULL,
	[HPGal_PROMOPRICE] [numeric](7, 2) NULL,
	[HP32_PROMOPRICE] [numeric](7, 2) NULL,
	[Motts64_PROMOPRICE] [numeric](7, 2) NULL,
	[Motts128_PROMOPRICE] [numeric](7, 2) NULL,
	[CLAMATO64_PROMOPRICE] [numeric](7, 2) NULL,
	[CLAMATO32_PROMOPRICE] [numeric](7, 2) NULL,
	[HP10_PROMOPRICE] [numeric](7, 2) NULL,
	[Motts8_PROMOPRICE] [numeric](7, 2) NULL,
	[MottsMFTTetra_PROMOPRICE] [numeric](7, 2) NULL,
	[Yoohoo_PROMOPRICE] [numeric](7, 2) NULL,
	[VITACOCOKIDS_PROMOPRICE] [numeric](7, 2) NULL,
	[CLAMATOCANS_PROMOPRICE] [numeric](7, 2) NULL,
	[Apple636_PROMOPRICE] [numeric](7, 2) NULL,
	[Apple4SP_PROMOPRICE] [numeric](7, 2) NULL,
	[AppleMS_PROMOPRICE] [numeric](7, 2) NULL,
	[IBC_PROMOPRICE] [numeric](7, 2) NULL,
	[CRUSH_PROMOPRICE] [numeric](7, 2) NULL,
	[MrMrsT1L_PROMOPRICE] [numeric](7, 2) NULL,
	[MrMrsT175L_PROMOPRICE] [numeric](7, 2) NULL,
	[Roses_PROMOPRICE] [numeric](7, 2) NULL,
	[HPGal_INAD] [int] NULL,
	[HP32_INAD] [int] NULL,
	[Motts64_INAD] [int] NULL,
	[Motts128_INAD] [int] NULL,
	[CLAMATO64_INAD] [int] NULL,
	[CLAMATO32_INAD] [int] NULL,
	[HP10_INAD] [int] NULL,
	[Motts8_INAD] [int] NULL,
	[MottsMFTTetra_INAD] [int] NULL,
	[Yoohoo_INAD] [int] NULL,
	[VITACOCOKIDS_INAD] [int] NULL,
	[CLAMATOCANS_INAD] [int] NULL,
	[Apple636_INAD] [int] NULL,
	[Apple4SP_INAD] [int] NULL,
	[AppleMS_INAD] [int] NULL,
	[IBC_INAD] [int] NULL,
	[CRUSH_INAD] [int] NULL,
	[MrMrsT1L_INAD] [int] NULL,
	[MrMrsT175L_INAD] [int] NULL,
	[Roses_INAD] [int] NULL,
	[HPGal_DISPLAY] [int] NULL,
	[HP32_DISPLAY] [int] NULL,
	[Motts64_DISPLAY] [int] NULL,
	[Motts128_DISPLAY] [int] NULL,
	[CLAMATO64_DISPLAY] [int] NULL,
	[CLAMATO32_DISPLAY] [int] NULL,
	[HP10_DISPLAY] [int] NULL,
	[Motts8_DISPLAY] [int] NULL,
	[MottsMFTTetra_DISPLAY] [int] NULL,
	[Yoohoo_DISPLAY] [int] NULL,
	[VITACOCOKIDS_DISPLAY] [int] NULL,
	[CLAMATOCANS_DISPLAY] [int] NULL,
	[Apple636_DISPLAY] [int] NULL,
	[Apple4SP_DISPLAY] [int] NULL,
	[AppleMS_DISPLAY] [int] NULL,
	[IBC_DISPLAY] [int] NULL,
	[CRUSH_DISPLAY] [int] NULL,
	[MrMrsT1L_DISPLAY] [int] NULL,
	[MrMrsT175L_DISPLAY] [int] NULL,
	[Roses_DISPLAY] [int] NULL,
	[insertdate] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [MSTR].[WDInputsSurveyResults]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [MSTR].[WDInputsSurveyResults](
	[customerId] [int] NULL,
	[userId] [varchar](10) NULL,
	[DISPLAYQ1] [int] NULL,
	[DISPLAYQ2] [int] NULL,
	[DISPLAYQ3] [int] NULL,
	[DISPLAYQ4] [int] NULL,
	[ADQ1] [int] NULL,
	[ADQ2] [int] NULL,
	[ADQ3] [int] NULL,
	[OTHERQ1] [int] NULL,
	[OTHERQ2] [int] NULL,
	[ManagerName] [varchar](50) NULL,
	[ManagerValidation] [int] NULL,
	[insertdate] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Person].[Job]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Person].[Job](
	[JobID] [int] IDENTITY(1,1) NOT NULL,
	[SAPHRJobNumber] [varchar](50) NULL,
	[RoleID] [int] NOT NULL,
 CONSTRAINT [PK_Person.JobCode] PRIMARY KEY CLUSTERED 
(
	[JobID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Person].[Role]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Person].[Role](
	[RoleID] [int] IDENTITY(1,1) NOT NULL,
	[RoleName] [varchar](250) NULL,
	[RoleShortName] [varchar](150) NULL,
	[RoleScope] [varchar](50) NULL,
	[ADGroupName] [varchar](50) NULL,
 CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Person].[SPUserProfile]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Person].[SPUserProfile](
	[GSN] [varchar](50) NOT NULL,
	[PrimaryBranch] [varchar](500) NULL,
	[PrimaryRole] [varchar](500) NULL,
	[AdditionalBranch] [varchar](5000) NULL,
	[BranchTradeMark] [varchar](5000) NULL,
	[RoleID] [int] NULL,
	[BranchCAN] [varchar](1000) NULL,
	[UpdatedInSP] [bit] NULL,
	[LastLoginTime] [datetime] NULL,
 CONSTRAINT [PK_SPUserProfile] PRIMARY KEY CLUSTERED 
(
	[GSN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Person].[UPSSyncConfig]    Script Date: 5/15/2013 1:45:01 PM ******/
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
/****** Object:  Table [Person].[UserBranchTradeMark]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Person].[UserBranchTradeMark](
	[UserBranchTradeMarkID] [int] IDENTITY(1,1) NOT NULL,
	[UserInBranchID] [int] NOT NULL,
	[TradeMarkID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserBranchTradeMarkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Person].[UserCan]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Person].[UserCan](
	[CANID] [int] IDENTITY(1,1) NOT NULL,
	[CANName] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CANID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Person].[UserInBranch]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Person].[UserInBranch](
	[UserInBranchID] [int] IDENTITY(1,1) NOT NULL,
	[GSN] [varchar](50) NOT NULL,
	[BranchID] [int] NOT NULL,
	[IsPrimary] [bit] NOT NULL,
 CONSTRAINT [PK_UserInBranch] PRIMARY KEY CLUSTERED 
(
	[UserInBranchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Person].[UserInRole]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Person].[UserInRole](
	[UserRoleID] [int] IDENTITY(1,1) NOT NULL,
	[GSN] [varchar](50) NOT NULL,
	[RoleID] [int] NOT NULL,
	[IsPrimary] [bit] NOT NULL,
 CONSTRAINT [PK_UserInRole] PRIMARY KEY CLUSTERED 
(
	[UserRoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Person].[UserProfile]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Person].[UserProfile](
	[GSN] [varchar](50) NOT NULL,
	[BUID] [int] NULL,
	[AreaID] [int] NULL,
	[PrimaryBranchID] [int] NULL,
	[ProfitCenterID] [int] NULL,
	[CostCenterID] [int] NULL,
	[FirstName] [nvarchar](128) NULL,
	[LastName] [nvarchar](128) NULL,
	[EmpID] [int] NULL,
	[Email] [varchar](128) NULL,
	[JobCode] [varchar](50) NULL,
	[ManualSetup] [bit] NULL,
 CONSTRAINT [PK_UserProfile] PRIMARY KEY CLUSTERED 
(
	[GSN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [PlayBook].[AttachmentRating]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [PlayBook].[AttachmentRating](
	[AttachmentRatingID] [int] IDENTITY(1,1) NOT NULL,
	[PromotionID] [int] NOT NULL,
	[AttachmentDocumentID] [nvarchar](50) NOT NULL,
	[DocumentRating] [int] NOT NULL,
	[GSN] [varchar](50) NOT NULL,
	[LastModified] [date] NOT NULL,
 CONSTRAINT [PK_AttachmentRating] PRIMARY KEY CLUSTERED 
(
	[AttachmentRatingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [PlayBook].[AttachmentType]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [PlayBook].[AttachmentType](
	[AttachmentTypeID] [int] IDENTITY(1,1) NOT NULL,
	[AttachmentTypeName] [varchar](150) NULL,
 CONSTRAINT [PK_AttachmentType] PRIMARY KEY CLUSTERED 
(
	[AttachmentTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [PlayBook].[Category]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [PlayBook].[Category](
	[CategoryID] [int] NOT NULL,
	[CategoryName] [varchar](150) NULL,
 CONSTRAINT [PK_CategoryException] PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [PlayBook].[DisplayLocation]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [PlayBook].[DisplayLocation](
	[DisplayLocationID] [int] IDENTITY(1,1) NOT NULL,
	[DisplayLocationName] [varchar](200) NOT NULL,
 CONSTRAINT [pk_PromotionDisplayLocationId] PRIMARY KEY CLUSTERED 
(
	[DisplayLocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [PlayBook].[MyDayStatus]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [PlayBook].[MyDayStatus](
	[StatusID] [int] IDENTITY(1,1) NOT NULL,
	[MydayStatusCode] [varchar](50) NOT NULL,
	[MydayStatusMessage] [varchar](1500) NOT NULL,
 CONSTRAINT [PK_MydayStatus_1] PRIMARY KEY CLUSTERED 
(
	[StatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [PlayBook].[PromotionAccount]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PlayBook].[PromotionAccount](
	[PromotionAccountID] [int] IDENTITY(1,1) NOT NULL,
	[PromotionID] [int] NOT NULL,
	[LocalChainID] [int] NULL,
	[RegionalChainID] [int] NULL,
	[NationalChainID] [int] NULL,
 CONSTRAINT [PK__Promotio__1828094A2C7A06CE] PRIMARY KEY CLUSTERED 
(
	[PromotionAccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [PlayBook].[PromotionAttachment]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [PlayBook].[PromotionAttachment](
	[PromotionAttachmentID] [int] IDENTITY(1,1) NOT NULL,
	[PromotionID] [int] NOT NULL,
	[AttachmentName] [varchar](200) NULL,
	[AttachmentURL] [varchar](256) NULL,
	[AttachmentTypeID] [int] NULL,
	[AttachmentSize] [int] NULL,
	[AttachmentDocumentID] [nvarchar](50) NULL,
	[AttachmentDateModified] [datetime] NULL,
 CONSTRAINT [PK__Promotio__94DD6C820AF64F2E] PRIMARY KEY CLUSTERED 
(
	[PromotionAttachmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [PlayBook].[PromotionBrand]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PlayBook].[PromotionBrand](
	[PromotionBrandID] [int] IDENTITY(1,1) NOT NULL,
	[PromotionID] [int] NOT NULL,
	[TrademarkID] [int] NULL,
	[BrandID] [int] NULL,
 CONSTRAINT [PK__Promotio__727E83EB0BE84C8E] PRIMARY KEY CLUSTERED 
(
	[PromotionBrandID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [PlayBook].[PromotionCategory]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [PlayBook].[PromotionCategory](
	[PromotionCategoryID] [int] IDENTITY(1,1) NOT NULL,
	[PromotionCategoryName] [varchar](150) NOT NULL,
	[ShortPromotionCategoryName] [varchar](40) NULL,
 CONSTRAINT [pk_PromotionCategoryID] PRIMARY KEY CLUSTERED 
(
	[PromotionCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [PlayBook].[PromotionChannel]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [PlayBook].[PromotionChannel](
	[PromotionID] [int] NOT NULL,
	[ChannelID] [int] NOT NULL,
	[Channel] [varchar](150) NOT NULL,
 CONSTRAINT [PK_PromotionChannel_1] PRIMARY KEY CLUSTERED 
(
	[PromotionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [PlayBook].[PromotionDisplayLocation]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [PlayBook].[PromotionDisplayLocation](
	[PromoitionDisplayLocationID] [int] IDENTITY(1,1) NOT NULL,
	[PromotionID] [int] NOT NULL,
	[DisplayLocationID] [int] NOT NULL,
	[PromotionDisplayLocationOther] [varchar](150) NULL,
 CONSTRAINT [PK__Promotio__727E838B4492F04E] PRIMARY KEY CLUSTERED 
(
	[PromoitionDisplayLocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [PlayBook].[PromotionGeographic]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PlayBook].[PromotionGeographic](
	[PromotionGeoID] [int] IDENTITY(1,1) NOT NULL,
	[PromotionID] [int] NOT NULL,
	[BUID] [int] NULL,
	[RegionID] [int] NULL,
	[AreaID] [int] NULL,
	[BranchID] [int] NULL,
 CONSTRAINT [PK_PromotionGeographic] PRIMARY KEY CLUSTERED 
(
	[PromotionGeoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [PlayBook].[PromotionPackage]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PlayBook].[PromotionPackage](
	[PromotionPackageID] [int] IDENTITY(1,1) NOT NULL,
	[PromotionID] [int] NULL,
	[PackageTypeID] [int] NULL,
	[PackageConfID] [int] NULL,
	[PackageID] [int] NULL,
 CONSTRAINT [PK_PromotionPackage] PRIMARY KEY CLUSTERED 
(
	[PromotionPackageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [PlayBook].[PromotionRank]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PlayBook].[PromotionRank](
	[PromotionRankID] [int] IDENTITY(1,1) NOT NULL,
	[PromotionID] [int] NULL,
	[PromotionWeekStart] [date] NULL,
	[PromotionWeekEnd] [date] NULL,
	[Rank] [int] NULL,
 CONSTRAINT [PK_PromotionRank] PRIMARY KEY CLUSTERED 
(
	[PromotionRankID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [PlayBook].[PromotionType]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [PlayBook].[PromotionType](
	[PromotionTypeID] [int] IDENTITY(1,1) NOT NULL,
	[PromotionType] [varchar](185) NOT NULL,
 CONSTRAINT [pk_PromotionTypeID] PRIMARY KEY CLUSTERED 
(
	[PromotionTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [PlayBook].[RetailPromotion]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [PlayBook].[RetailPromotion](
	[PromotionID] [int] IDENTITY(1,1) NOT NULL,
	[PromotionName] [varchar](180) NOT NULL,
	[PromotionDescription] [varchar](200) NULL,
	[PromotionTypeID] [int] NULL,
	[PromotionPrice] [varchar](150) NULL,
	[PromotionCategoryID] [int] NULL,
	[PromotionDisplayLocationID] [int] NULL,
	[PromotionStatusID] [int] NULL,
	[CorporatePriorityID] [int] NULL,
	[PromotionStartDate] [date] NULL,
	[PromotionEndDate] [date] NULL,
	[ParentPromotionID] [int] NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [varchar](50) NULL,
	[ModifiedDate] [datetime] NULL,
	[EDGEItemID] [int] NULL,
	[ChannelID] [int] NULL,
	[ForecastVolume] [varchar](50) NULL,
	[PackageJson] [nvarchar](max) NULL,
	[PromotionPackages] [varchar](500) NULL,
	[CreatedPromotionRank] [int] NULL,
	[PromotionBranchID] [int] NULL,
	[PromotionBUID] [int] NULL,
	[PromotionRegionID] [int] NULL,
	[IsLocalized] [bit] NULL,
 CONSTRAINT [PK__RetailPr__52C42F2FE4A83A19] PRIMARY KEY CLUSTERED 
(
	[PromotionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [PlayBook].[Status]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [PlayBook].[Status](
	[StatusID] [int] IDENTITY(1,1) NOT NULL,
	[StatusName] [varchar](100) NOT NULL,
	[IsActive] [int] NOT NULL,
 CONSTRAINT [pk_PromotionStatusID] PRIMARY KEY CLUSTERED 
(
	[StatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [PlayBook].[UserInformation]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [PlayBook].[UserInformation](
	[GSN] [varchar](50) NOT NULL,
	[LastLoginTime] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[GSN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SalesPriority].[DisplayLocation]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SalesPriority].[DisplayLocation](
	[DisplayLocationID] [int] NOT NULL,
	[DisplayLocationName] [varchar](50) NULL,
 CONSTRAINT [PK_DisplayLocation] PRIMARY KEY CLUSTERED 
(
	[DisplayLocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SalesPriority].[SalesPriority]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SalesPriority].[SalesPriority](
	[SalesPriorityID] [int] IDENTITY(1,1) NOT NULL,
	[SalesPriorityName] [varchar](150) NULL,
	[SalesPriorityAlignmentID] [int] NULL,
	[SalesPriorityObjective] [varchar](500) NULL,
	[SalesPriorityFormatID] [int] NULL,
	[SalesPriorityStartDate] [date] NULL,
	[SalesPriorityEndDate] [date] NULL,
	[SalesPriorityMarketingElements] [varchar](1500) NULL,
	[SalesPriorityStatusID] [int] NULL,
	[SalesPriorityCreatedRank] [int] NULL,
 CONSTRAINT [PK_SalesPriority] PRIMARY KEY CLUSTERED 
(
	[SalesPriorityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SalesPriority].[SalesPriorityAlignment]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SalesPriority].[SalesPriorityAlignment](
	[SalesPriorityAlignmentID] [int] NOT NULL,
	[SalesPriorityAlignmentName] [varchar](100) NULL,
 CONSTRAINT [PK_SalesPriorityAlignment] PRIMARY KEY CLUSTERED 
(
	[SalesPriorityAlignmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SalesPriority].[SalesPriorityAttachment]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SalesPriority].[SalesPriorityAttachment](
	[SalesPriorityAttachmentItemID] [int] IDENTITY(1,1) NOT NULL,
	[SalesPriorityID] [int] NULL,
	[SalesPriorityAttachmentName] [varchar](500) NULL,
	[SalesPriorityAttachmentURL] [varchar](1500) NULL,
	[SalesPriorityAttachmentType] [varchar](50) NULL,
	[SalesPrioritySPDocID] [varchar](50) NULL,
 CONSTRAINT [PK_SalesPriorityAttachment] PRIMARY KEY CLUSTERED 
(
	[SalesPriorityAttachmentItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SalesPriority].[SalesPriorityDisplayLocation]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SalesPriority].[SalesPriorityDisplayLocation](
	[SalesPriorityDisplayLocationID] [int] IDENTITY(1,1) NOT NULL,
	[DisplayLocationID] [int] NULL,
	[SalesPriorityID] [int] NOT NULL,
	[SalesPriorityDisplayLocationOther] [varchar](50) NULL,
 CONSTRAINT [PK_SalesPriorityDisplayLocation] PRIMARY KEY CLUSTERED 
(
	[SalesPriorityDisplayLocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SalesPriority].[SalesPriorityFormat]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SalesPriority].[SalesPriorityFormat](
	[SalesPriorityFormatID] [int] NOT NULL,
	[SalesPriorityFormatName] [varchar](50) NULL,
 CONSTRAINT [PK_SalesPriorityFormat_1] PRIMARY KEY CLUSTERED 
(
	[SalesPriorityFormatID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SalesPriority].[SalesPriorityPackage]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SalesPriority].[SalesPriorityPackage](
	[SalesPriorityPackageID] [int] IDENTITY(1,1) NOT NULL,
	[SalesPriorityID] [int] NULL,
	[PackageID] [int] NULL,
 CONSTRAINT [PK_SalesPriorityPackage] PRIMARY KEY CLUSTERED 
(
	[SalesPriorityPackageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SalesPriority].[SalesPriorityRank]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SalesPriority].[SalesPriorityRank](
	[RankID] [int] IDENTITY(1,1) NOT NULL,
	[SalesPriorityRank] [int] NULL,
	[SalesPriorityID] [int] NULL,
	[StartMonth] [varchar](50) NULL,
	[EndMonth] [varchar](50) NULL,
 CONSTRAINT [PK_SalesPriorityRank] PRIMARY KEY CLUSTERED 
(
	[RankID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SalesPriority].[SalesPriorityTrademark]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SalesPriority].[SalesPriorityTrademark](
	[SalesPriorityTrademarkID] [int] NOT NULL,
	[SalesPriorityID] [int] NULL,
	[TrademarkID] [int] NULL,
 CONSTRAINT [PK_SalesPriorityBrands] PRIMARY KEY CLUSTERED 
(
	[SalesPriorityTrademarkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SalesPriority].[Status]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SalesPriority].[Status](
	[StatusID] [int] NOT NULL,
	[StatusName] [varchar](50) NULL,
 CONSTRAINT [PK_SalesPriorityStatus] PRIMARY KEY CLUSTERED 
(
	[StatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SAP].[Account]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SAP].[Account](
	[AccountID] [int] IDENTITY(1,1) NOT NULL,
	[SAPAccountNumber] [bigint] NOT NULL,
	[AccountName] [varchar](128) NOT NULL,
	[ChannelID] [int] NULL,
	[BranchID] [int] NULL,
	[LocalChainID] [int] NULL,
	[Address] [varchar](50) NULL,
	[City] [varchar](50) NULL,
	[State] [varchar](50) NULL,
	[PostalCode] [varchar](12) NULL,
	[Contact] [varchar](50) NULL,
	[PhoneNumber] [varchar](50) NULL,
	[Longitude] [decimal](10, 6) NULL,
	[Latitude] [decimal](10, 6) NULL,
	[Active] [bit] NULL,
	[ChangeTrackNumber] [int] NULL,
	[LastModified] [smalldatetime] NULL,
 CONSTRAINT [PK_Account] PRIMARY KEY CLUSTERED 
(
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SAP].[BevType]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SAP].[BevType](
	[BevTypeID] [int] IDENTITY(1,1) NOT NULL,
	[InternalCategoryID] [int] NULL,
	[SAPBevTypeID] [varchar](50) NOT NULL,
	[BevTypeName] [varchar](128) NULL,
	[ChangeTrackNumber] [int] NULL,
	[LastModified] [smalldatetime] NULL,
 CONSTRAINT [PK_BevType] PRIMARY KEY CLUSTERED 
(
	[BevTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SAP].[Branch]    Script Date: 5/17/2013 3:53:15 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [SAP].[Branch](
	[BranchID] [int] IDENTITY(1,1) NOT NULL,
	[SAPBranchID] [varchar](50) NOT NULL,
	[BranchName] [varchar](50) NOT NULL,
	[RegionID] [int] NULL,
	[RMLocationID] [int] NULL,
	[RMLocationCity] [varchar](50) NULL,
	[SPBranchName] [varchar](50) NULL,
	[Active] [bit] NULL,
	[MySplashNetEnabled] [bit] NULL,
	[ZipCode] [varchar](50) NULL,
	[ChangeTrackNumber] [int] NULL,
	[LastModified] [smalldatetime] NULL,
 CONSTRAINT [PK_Branch] PRIMARY KEY CLUSTERED 
(
	[BranchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [SAP].[Branch]  WITH CHECK ADD  CONSTRAINT [FK_Branch_Region] FOREIGN KEY([RegionID])
REFERENCES [SAP].[Region] ([RegionID])
GO

ALTER TABLE [SAP].[Branch] CHECK CONSTRAINT [FK_Branch_Region]
GO
/****** Object:  Table [SAP].[BranchMaterial]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[BranchMaterial](
	[BranchID] [int] NOT NULL,
	[MaterialID] [int] NOT NULL,
 CONSTRAINT [PK_BranchMaterial] PRIMARY KEY CLUSTERED 
(
	[BranchID] ASC,
	[MaterialID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SAP].[Brand]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SAP].[Brand](
	[BrandID] [int] IDENTITY(1,1) NOT NULL,
	[TrademarkID] [int] NOT NULL,
	[SAPBrandID] [varchar](50) NOT NULL,
	[BrandName] [varchar](128) NOT NULL,
	[SPBrandName] [varchar](128) NULL,
	[ChangeTrackNumber] [int] NULL,
	[LastModified] [smalldatetime] NULL,
 CONSTRAINT [PK_Brand] PRIMARY KEY CLUSTERED 
(
	[BrandID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SAP].[BusinessUnit]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SAP].[BusinessUnit](
	[BUID] [int] IDENTITY(1,1) NOT NULL,
	[SAPBUID] [varchar](50) NOT NULL,
	[BUName] [nvarchar](50) NOT NULL,
	[SPBUName] [varchar](50) NULL,
	[ChangeTrackNumber] [int] NULL,
	[LastModified] [smalldatetime] NULL,
 CONSTRAINT [PK_BusinessUnit] PRIMARY KEY CLUSTERED 
(
	[BUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SAP].[CaffeineClaim]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SAP].[CaffeineClaim](
	[CaffeineClaimID] [int] IDENTITY(1,1) NOT NULL,
	[SAPCaffeineClaimID] [varchar](50) NOT NULL,
	[CaffeineClaimName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_CaffeineClaim] PRIMARY KEY CLUSTERED 
(
	[CaffeineClaimID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SAP].[CalorieClass]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SAP].[CalorieClass](
	[CalorieClassID] [int] IDENTITY(1,1) NOT NULL,
	[SAPCalorieClassID] [varchar](5) NOT NULL,
	[CalorieClassName] [varchar](100) NOT NULL,
 CONSTRAINT [PK__CalorieC__BE1C59431CB4D662] PRIMARY KEY CLUSTERED 
(
	[CalorieClassID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SAP].[Channel]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SAP].[Channel](
	[ChannelID] [int] IDENTITY(1,1) NOT NULL,
	[SuperChannelID] [int] NULL,
	[SAPChannelID] [varchar](50) NOT NULL,
	[ChannelName] [varchar](128) NOT NULL,
	[SPChannelName] [varchar](50) NULL,
 CONSTRAINT [PK_Channel] PRIMARY KEY CLUSTERED 
(
	[ChannelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SAP].[CostCenter]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[CostCenter](
	[CostCenterID] [int] IDENTITY(1,1) NOT NULL,
	[SAPCostCenterID] [nvarchar](64) NOT NULL,
	[CostCenterName] [nvarchar](64) NOT NULL,
	[ProfitCenterID] [int] NULL,
	[ChangeTrackNumber] [int] NULL,
	[LastModified] [smalldatetime] NULL,
 CONSTRAINT [PK_CostCenter] PRIMARY KEY CLUSTERED 
(
	[CostCenterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SAP].[CustomCategory]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SAP].[CustomCategory](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryGroupName] [varchar](50) NULL,
	[TradeMarkID] [int] NULL,
	[BrandID] [int] NULL,
 CONSTRAINT [pk_CategoryID] PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SAP].[Flavor]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SAP].[Flavor](
	[FlavorID] [int] IDENTITY(1,1) NOT NULL,
	[SAPFlavorID] [varchar](50) NOT NULL,
	[FlavorName] [varchar](128) NOT NULL,
	[ChangeTrackNumber] [int] NULL,
	[LastModified] [smalldatetime] NULL,
 CONSTRAINT [PK_Flavor] PRIMARY KEY CLUSTERED 
(
	[FlavorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SAP].[Franchisor]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SAP].[Franchisor](
	[FranchisorID] [int] IDENTITY(1,1) NOT NULL,
	[SAPFranchisorID] [varchar](50) NOT NULL,
	[FranchisorName] [varchar](128) NOT NULL,
	[ChangeTrackNumber] [int] NULL,
	[LastModified] [smalldatetime] NULL,
 CONSTRAINT [PK_Franchisor] PRIMARY KEY CLUSTERED 
(
	[FranchisorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SAP].[InternalCategory]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SAP].[InternalCategory](
	[InternalCategoryID] [int] IDENTITY(1,1) NOT NULL,
	[SAPInternalCategoryID] [varchar](10) NOT NULL,
	[InternalCategoryName] [varchar](100) NOT NULL,
 CONSTRAINT [PK__Internal__97D4FC752A102B96] PRIMARY KEY CLUSTERED 
(
	[InternalCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SAP].[LocalChain]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SAP].[LocalChain](
	[LocalChainID] [int] IDENTITY(1,1) NOT NULL,
	[SAPLocalChainID] [int] NULL,
	[LocalChainName] [varchar](50) NOT NULL,
	[RegionalChainID] [int] NULL,
	[SPLocalChainName] [varchar](50) NULL,
	[ChangeTrackNumber] [int] NULL,
	[LastModified] [smalldatetime] NULL,
 CONSTRAINT [PK_SAP.LocalChain] PRIMARY KEY CLUSTERED 
(
	[LocalChainID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SAP].[Material]    Script Date: 5/15/2013 1:45:01 PM ******/
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
	[PackageID] [int] NULL,
	[CalorieClassID] [int] NULL,
	[InternalCategoryID] [int] NULL,
	[CaffeineClaimID] [int] NULL,
	[ChangeTrackNumber] [int] NULL,
	[LastModified] [smalldatetime] NULL,
 CONSTRAINT [PK_Material] PRIMARY KEY CLUSTERED 
(
	[MaterialID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SAP].[NationalChain]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SAP].[NationalChain](
	[NationalChainID] [int] IDENTITY(1,1) NOT NULL,
	[SAPNationalChainID] [int] NULL,
	[NationalChainName] [varchar](50) NOT NULL,
	[SPNationalChainName] [varchar](30) NULL,
	[ChangeTrackNumber] [int] NULL,
	[LastModified] [smalldatetime] NULL,
 CONSTRAINT [PK_SAP.NationalChain] PRIMARY KEY CLUSTERED 
(
	[NationalChainID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SAP].[Package]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SAP].[Package](
	[PackageID] [int] IDENTITY(1,1) NOT NULL,
	[RMPackageID] [varchar](10) NULL,
	[PackageTypeID] [int] NULL,
	[PackageConfID] [int] NULL,
	[PackageName] [varchar](50) NOT NULL,
	[Source] [varchar](50) NULL,
	[Active] [bit] NOT NULL,
	[SPPackageName] [varchar](50) NULL,
	[FriendlyName] [varchar](50) NULL,
	[ChangeTrackNumber] [int] NULL,
	[LastModified] [smalldatetime] NULL,
 CONSTRAINT [PK_Package] PRIMARY KEY CLUSTERED 
(
	[PackageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SAP].[PackageConf]    Script Date: 5/15/2013 1:45:01 PM ******/
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
	[ChangeTrackNumber] [int] NULL,
	[LastModified] [smalldatetime] NULL,
 CONSTRAINT [PK_PackageConf] PRIMARY KEY CLUSTERED 
(
	[PackageConfID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SAP].[PackageType]    Script Date: 5/15/2013 1:45:01 PM ******/
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
	[SPPackageTypeName] [nvarchar](50) NULL,
	[ChangeTrackNumber] [int] NULL,
	[LastModified] [smalldatetime] NULL,
 CONSTRAINT [PK_PackageType_1] PRIMARY KEY CLUSTERED 
(
	[PackageTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SAP].[ProfitCenter]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SAP].[ProfitCenter](
	[ProfitCenterID] [int] IDENTITY(1,1) NOT NULL,
	[SAPProfitCenterID] [varchar](32) NOT NULL,
	[ProfitCenterName] [nvarchar](64) NOT NULL,
	[BranchID] [int] NULL,
	[ChangeTrackNumber] [int] NULL,
	[LastModified] [smalldatetime] NULL,
 CONSTRAINT [PK_ProfitCenter] PRIMARY KEY CLUSTERED 
(
	[ProfitCenterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SAP].[Region]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SAP].[Region](
	[RegionID] [int] IDENTITY(1,1) NOT NULL,
	[SAPRegionID] [varchar](50) NOT NULL,
	[RegionName] [nvarchar](50) NOT NULL,
	[BUID] [int] NOT NULL,
	[SPRegionName] [varchar](50) NULL,
	[ChangeTrackNumber] [int] NULL,
	[LastModified] [smalldatetime] NULL,
 CONSTRAINT [PK_BusinessArea] PRIMARY KEY CLUSTERED 
(
	[RegionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SAP].[RegionalChain]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SAP].[RegionalChain](
	[RegionalChainID] [int] IDENTITY(1,1) NOT NULL,
	[SAPRegionalChainID] [int] NULL,
	[RegionalChainName] [varchar](50) NOT NULL,
	[NationalChainID] [int] NULL,
	[SPRegionalChainName] [varchar](50) NULL,
	[ChangeTrackNumber] [int] NULL,
	[LastModified] [smalldatetime] NULL,
 CONSTRAINT [PK_SAP.RegionalChain] PRIMARY KEY CLUSTERED 
(
	[RegionalChainID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SAP].[RouteSchedule]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[RouteSchedule](
	[RouteScheduleID] [int] IDENTITY(1,1) NOT NULL,
	[AccountID] [int] NOT NULL,
	[RouteID] [int] NOT NULL,
	[StartDate] [date] NOT NULL,
 CONSTRAINT [PK_RouteSchedule_1] PRIMARY KEY CLUSTERED 
(
	[RouteScheduleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SAP].[RouteScheduleDetail]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[RouteScheduleDetail](
	[RouteScheduleID] [int] NOT NULL,
	[Day] [int] NOT NULL,
	[SequenceNumber] [int] NOT NULL,
 CONSTRAINT [PK_RouteScheduleDetail] PRIMARY KEY CLUSTERED 
(
	[RouteScheduleID] ASC,
	[Day] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SAP].[SalesArea]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SAP].[SalesArea](
	[SalesAreaID] [int] NOT NULL,
	[SalesAreaName] [varchar](50) NOT NULL,
	[SAPSalesAreaID] [varchar](50) NOT NULL,
	[RegionID] [int] NOT NULL,
	[SPSalesAreaName] [varchar](50) NULL,
	[ChangeTrackNumber] [int] NOT NULL,
	[LastModified] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_SalesArea] PRIMARY KEY CLUSTERED 
(
	[SalesAreaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SAP].[SalesRoute]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SAP].[SalesRoute](
	[RouteID] [int] IDENTITY(1,1) NOT NULL,
	[SAPRouteNumber] [varchar](10) NOT NULL,
	[BranchID] [int] NOT NULL,
	[RouteName] [varchar](50) NOT NULL,
	[DefaultEmployeeID] [int] NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_SalesRoute] PRIMARY KEY CLUSTERED 
(
	[RouteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SAP].[SuperChannel]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SAP].[SuperChannel](
	[SuperChannelID] [int] IDENTITY(1,1) NOT NULL,
	[SAPSuperChannelID] [varchar](50) NOT NULL,
	[SuperChannelName] [varchar](50) NOT NULL,
	[Format] [char](1) NOT NULL,
	[SPSuperChannelName] [varchar](50) NULL,
 CONSTRAINT [PK_SAP.SuperChannel] PRIMARY KEY CLUSTERED 
(
	[SuperChannelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SAP].[TradeMark]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SAP].[TradeMark](
	[TradeMarkID] [int] IDENTITY(1,1) NOT NULL,
	[SAPTradeMarkID] [varchar](50) NOT NULL,
	[TradeMarkName] [nvarchar](128) NOT NULL,
	[SPTradeMarkName] [varchar](128) NULL,
	[ChangeTrackNumber] [int] NULL,
	[LastModified] [smalldatetime] NULL,
 CONSTRAINT [PK_TradeMark] PRIMARY KEY CLUSTERED 
(
	[TradeMarkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Staging].[AccountDetails]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Staging].[AccountDetails](
	[SAPAccountNumber] [varchar](50) NULL,
	[SAPBranchID] [varchar](50) NULL,
	[SAPChannelID] [varchar](50) NULL,
	[SAPLocalChainID] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Staging].[ADExtractData]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Staging].[ADExtractData](
	[EmpID] [varchar](50) NULL,
	[LastName] [varchar](150) NULL,
	[FirstName] [varchar](150) NULL,
	[Status] [varchar](50) NULL,
	[UserID] [varchar](150) NULL,
	[Band] [varchar](50) NULL,
	[LocationCode] [varchar](150) NULL,
	[Location] [varchar](150) NULL,
	[Adress] [varchar](500) NULL,
	[City] [varchar](250) NULL,
	[State] [varchar](150) NULL,
	[ZipCode] [varchar](150) NULL,
	[ManagerID] [varchar](50) NULL,
	[ManagerGSN] [varchar](50) NULL,
	[Title] [varchar](250) NULL,
	[Role] [varchar](150) NULL,
	[TermDate] [varchar](50) NULL,
	[HireDate] [varchar](50) NULL,
	[OrgUnit] [varchar](500) NULL,
	[CostCenter] [varchar](150) NULL,
	[JobCode] [varchar](150) NULL,
	[IsManager] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Staging].[BevBrandPack]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[BevBrandPack](
	[BevTypeID] [nvarchar](50) NULL,
	[BevType] [nvarchar](200) NULL,
	[TrademarkID] [nvarchar](50) NULL,
	[Trademark] [nvarchar](100) NULL,
	[BrandID] [nvarchar](50) NULL,
	[Brand] [nvarchar](500) NULL,
	[PackTypeID] [nvarchar](50) NULL,
	[PackType] [nvarchar](500) NULL,
	[PackConfID] [nvarchar](50) NULL,
	[PackConf] [nvarchar](1000) NULL,
	[SLID] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_SLID] PRIMARY KEY CLUSTERED 
(
	[SLID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Staging].[BranchPlan]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[BranchPlan](
	[FISC PER] [float] NULL,
	[Profit Cente] [nvarchar](255) NULL,
	[Sales Office] [float] NULL,
	[Sales Doc Type] [float] NULL,
	[Material] [float] NULL,
	[Extended Net Sales] [float] NULL,
	[Standard Cost] [float] NULL,
	[Margin] [float] NULL,
	[QTY] [float] NULL,
	[F10] [float] NULL,
	[Margin1] [float] NULL,
	[UOM] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [Staging].[BWAccount]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Staging].[BWAccount](
	[CUSTOMER_NUMBER] [bigint] NULL,
	[LOCATION_ID] [varchar](16) NULL,
	[START_DATE] [smalldatetime] NULL,
	[CUSTOMER_NAME] [varchar](128) NULL,
	[CUSTOMER_STREET] [varchar](128) NULL,
	[CITY] [varchar](50) NULL,
	[STATE] [varchar](20) NULL,
	[POSTAL_CODE] [varchar](12) NULL,
	[CONTACT_PERSON] [varchar](50) NULL,
	[PHONE_NUMBER] [varchar](50) NULL,
	[LOCAL_CHAIN] [int] NULL,
	[CHANNEL] [int] NULL,
	[ACTIVE] [bit] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Staging].[Chain]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[Chain](
	[LocalChainID] [nvarchar](50) NULL,
	[LocalChain] [nvarchar](500) NULL,
	[RegionalChainID] [nvarchar](50) NULL,
	[RegionalChain] [nvarchar](500) NULL,
	[NationalChainID] [nvarchar](50) NULL,
	[NationalChain] [nvarchar](500) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [Staging].[Channel]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[Channel](
	[ChannelID] [nvarchar](50) NULL,
	[Channel] [nvarchar](500) NULL,
	[SuperChannelID] [nvarchar](50) NULL,
	[SuperChannel] [nvarchar](500) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [Staging].[CostCenterToProfitCenter]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[CostCenterToProfitCenter](
	[CostCenterID] [nvarchar](50) NULL,
	[CostCenter] [nvarchar](500) NULL,
	[ProfitCenterID] [nvarchar](50) NULL,
	[ProfitCenter] [nvarchar](500) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [Staging].[CustomerToProfitCenter]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[CustomerToProfitCenter](
	[SAPAccountNumber] [nvarchar](50) NULL,
	[SAPProfitCenterID] [nvarchar](500) NULL,
	[SAPBranchID] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [Staging].[FactMyDayCustomerHistLoad]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Staging].[FactMyDayCustomerHistLoad](
	[SAPAccountNumber] [varchar](50) NULL,
	[SAPPackageTypeID] [varchar](50) NULL,
	[SAPPackageConfigID] [varchar](50) NULL,
	[SAPInternalCategoryID] [varchar](50) NULL,
	[SAPBrandID] [varchar](50) NULL,
	[SAPBevTypeID] [varchar](50) NULL,
	[MonthID] [varchar](50) NULL,
	[ConvertedCases] [varchar](50) NULL,
	[CasesUnit] [varchar](50) NULL,
	[Revenue] [varchar](50) NULL,
	[RevenueUnit] [varchar](50) NULL,
	[RMPackageID] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Staging].[FactMyDayCustomerLoad]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Staging].[FactMyDayCustomerLoad](
	[SAPAccountNumber] [varchar](50) NULL,
	[SAPPackageTypeID] [varchar](50) NULL,
	[SAPPackageConfigID] [varchar](50) NULL,
	[SAPInternalCategoryID] [varchar](50) NULL,
	[SAPBrandID] [varchar](50) NULL,
	[SAPBevTypeID] [varchar](50) NULL,
	[MonthID] [varchar](50) NULL,
	[ConvertedCases] [varchar](50) NULL,
	[CasesUnit] [varchar](50) NULL,
	[Revenue] [varchar](50) NULL,
	[RevenueUnit] [varchar](50) NULL,
	[RMPackageID] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Staging].[FactOFDCasesCutsLoad]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[FactOFDCasesCutsLoad](
	[SAPBranchID] [nvarchar](255) NULL,
	[SAPBrandID] [nvarchar](255) NULL,
	[SAPPackageTypeID] [nvarchar](255) NULL,
	[CasesCut] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [Staging].[FactOFDDailyMetricsLoad]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Staging].[FactOFDDailyMetricsLoad](
	[SAPBranchID] [varchar](255) NULL,
	[MetricDate] [varchar](255) NULL,
	[MetricID] [varchar](255) NULL,
	[Metric] [numeric](10, 2) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Staging].[MaterialBrandPKG]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[MaterialBrandPKG](
	[MaterialID] [nvarchar](50) NULL,
	[Material] [nvarchar](500) NULL,
	[FranchisorID] [nvarchar](50) NULL,
	[Franchisor] [nvarchar](100) NULL,
	[BevTypeID] [nvarchar](50) NULL,
	[BevType] [nvarchar](200) NULL,
	[TrademarkID] [nvarchar](50) NULL,
	[Trademark] [nvarchar](100) NULL,
	[BrandID] [nvarchar](50) NULL,
	[Brand] [nvarchar](500) NULL,
	[FlavorID] [nvarchar](50) NULL,
	[Flavor] [nvarchar](500) NULL,
	[PackTypeID] [nvarchar](50) NULL,
	[PackType] [nvarchar](500) NULL,
	[PackConfID] [nvarchar](50) NULL,
	[PackConf] [nvarchar](1000) NULL,
	[CalorieClassID] [nvarchar](50) NULL,
	[CaffeineClaim] [nvarchar](50) NULL,
	[InternalCategoryID] [nvarchar](50) NULL,
	[SLNO] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_SLNO] PRIMARY KEY CLUSTERED 
(
	[SLNO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Staging].[ProfitCenterToSalesOffice]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[ProfitCenterToSalesOffice](
	[ProfitCenterID] [nvarchar](50) NULL,
	[ProfitCenter] [nvarchar](500) NULL,
	[SalesOfficeID] [nvarchar](50) NULL,
	[SalesOffice] [nvarchar](500) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [Staging].[RMAccount]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[RMAccount](
	[CUSTOMER_NUMBER] [nvarchar](10) NOT NULL,
	[LOCATION_ID] [nvarchar](8) NOT NULL,
	[CUSTOMER_NAME] [nvarchar](40) NOT NULL,
	[CUSTOMER_STREET] [nvarchar](40) NOT NULL,
	[CITY] [nvarchar](40) NULL,
	[STATE] [nvarchar](2) NOT NULL,
	[POSTAL_CODE] [nvarchar](10) NOT NULL,
	[CONTACT_PERSON] [nvarchar](35) NOT NULL,
	[PHONE_NUMBER] [nvarchar](20) NOT NULL,
	[LOCAL_CHAIN] [nvarchar](10) NULL,
	[CHANNEL] [nvarchar](3) NOT NULL,
	[ACTIVE] [numeric](1, 0) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [Staging].[RMItemMaster]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[RMItemMaster](
	[Location_ID] [nvarchar](8) NOT NULL,
	[ITEM_NUMBER] [nvarchar](18) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [Staging].[RMLocation]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[RMLocation](
	[LOCATION_ID] [nvarchar](8) NOT NULL,
	[LOCATION_NAME] [nvarchar](40) NOT NULL,
	[LOCATION_ADDR1] [nvarchar](40) NOT NULL,
	[LOCATION_ADDR2] [nvarchar](40) NULL,
	[LOCATION_CITY] [nvarchar](40) NOT NULL,
	[LOCATION_STATE] [nvarchar](2) NOT NULL,
	[LOCATION_ZIP] [nvarchar](10) NOT NULL,
	[LOCATION_PHONE] [nvarchar](30) NULL,
	[LOCATION_FAX] [nvarchar](30) NULL,
	[COMPANY_NAME] [nvarchar](40) NOT NULL,
	[SUPPLIER_LOCATION_NUMBER] [nvarchar](10) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [Staging].[RMPackage]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[RMPackage](
	[PACKAGEID] [nvarchar](5) NOT NULL,
	[DESCRIPTION] [nvarchar](40) NOT NULL,
	[SAPPackageTypeID] [nvarchar](3) NULL,
	[SAPPackageConfigID] [nvarchar](2) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [Staging].[RMRouteMaster]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[RMRouteMaster](
	[ROUTE_NUMBER] [nvarchar](10) NOT NULL,
	[ROUTE_DESCRIPTION] [nvarchar](35) NOT NULL,
	[ACTIVE_ROUTE] [nvarchar](1) NOT NULL,
	[ROUTE_TYPE] [nvarchar](1) NOT NULL,
	[LOCATION_ID] [nvarchar](8) NOT NULL,
	[DEFAULT_EMPLOYEE] [nvarchar](10) NOT NULL,
	[ACTIVE] [numeric](1, 0) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [Staging].[RMRouteSchedule]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Staging].[RMRouteSchedule](
	[ROUTE_NUMBER] [int] NULL,
	[CUSTOMER_NUMBER] [int] NULL,
	[LOCATION_ID] [int] NULL,
	[FREQUENCY] [char](1) NULL,
	[START_DATE] [date] NULL,
	[DEFAULT_DELIV_ROUTE] [int] NULL,
	[SEQUENCE_NUMBER] [char](84) NULL,
	[SEASONAL] [bit] NULL,
	[SEASONAL_START_DATE] [date] NULL,
	[SEASONAL_END_DATE] [date] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Staging].[RNLocation]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[RNLocation](
	[AccountNumber] [nvarchar](15) NOT NULL,
	[LONGITUDE] [numeric](38, 6) NULL,
	[LATITUDE] [numeric](38, 6) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [Staging].[SalesOffice]    Script Date: 5/15/2013 1:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[SalesOffice](
	[SalesOfficeID] [nvarchar](50) NULL,
	[SalesOffice] [nvarchar](500) NULL,
	[RegionID] [nvarchar](50) NULL,
	[Region] [nvarchar](500) NULL,
	[AreaID] [nvarchar](50) NULL,
	[Area] [nvarchar](500) NULL,
	[BusinessUnitID] [nvarchar](50) NULL,
	[BusinessUnit] [nvarchar](500) NULL
) ON [PRIMARY]

GO
ALTER TABLE [EDGE].[RPLAttachment] ADD  CONSTRAINT [DF_RPLAttachment_ReceivedDateUTC]  DEFAULT (getdate()) FOR [ReceivedDate]
GO
ALTER TABLE [EDGE].[RPLItem] ADD  CONSTRAINT [DF_RPLItem_LastModified]  DEFAULT (getdate()) FOR [ReceivedDate]
GO
ALTER TABLE [EDGE].[WebServiceLog] ADD  CONSTRAINT [DF_WebServiceLog_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [MSTR].[DimMydaySalesPlanVersions] ADD  CONSTRAINT [DF_DimMydaySalesPlanVersions_VersionValue]  DEFAULT ((0)) FOR [VersionValue]
GO
ALTER TABLE [MSTR].[DimTENBrands] ADD  CONSTRAINT [DF__DimTENBra__inste__18C19800]  DEFAULT (getdate()) FOR [instertedOn]
GO
ALTER TABLE [MSTR].[FactMyDayBranchPlanRanking] ADD  DEFAULT (getdate()) FOR [RecordDate]
GO
ALTER TABLE [MSTR].[FactMyDayCustomer] ADD  CONSTRAINT [DF_FactMyDayCustomer_RecordDate]  DEFAULT (getdate()) FOR [RecordDate]
GO
ALTER TABLE [MSTR].[FactMyDayCustomerSummary] ADD  DEFAULT ((0)) FOR [MTDConvertedCases]
GO
ALTER TABLE [MSTR].[FactMyDayCustomerSummary] ADD  DEFAULT ((0)) FOR [YTDConvertedCases]
GO
ALTER TABLE [MSTR].[FactMyDayCustomerSummary] ADD  DEFAULT ((0)) FOR [LYCMConvertedCases]
GO
ALTER TABLE [MSTR].[FactMyDayCustomerSummary] ADD  DEFAULT ((0)) FOR [MTDRevenue]
GO
ALTER TABLE [MSTR].[FactMyDayCustomerSummary] ADD  DEFAULT ((0)) FOR [YTDRevenue]
GO
ALTER TABLE [MSTR].[FactMyDayCustomerSummary] ADD  DEFAULT ((0)) FOR [LYCMRevenue]
GO
ALTER TABLE [MSTR].[FactMyDayCustomerSummary] ADD  DEFAULT ((0)) FOR [Avg3MonthProRated]
GO
ALTER TABLE [MSTR].[FactMyDayCustomerSummary] ADD  DEFAULT ((0)) FOR [Avg3Month]
GO
ALTER TABLE [MSTR].[FactMyDayCustomerSummary] ADD  DEFAULT ((0)) FOR [RecordDate]
GO
ALTER TABLE [MSTR].[FactMyDayRoutePlan] ADD  CONSTRAINT [DF__FactMyDay__Recor__3E923B2D]  DEFAULT (getdate()) FOR [RecordDate]
GO
ALTER TABLE [MSTR].[FactOFDCasesCuts] ADD  CONSTRAINT [DF_FactOFDCasesCuts_BranchID]  DEFAULT ((0)) FOR [BranchID]
GO
ALTER TABLE [MSTR].[FactOFDCasesCuts] ADD  CONSTRAINT [DF_FactOFDCasesCuts_BrandID]  DEFAULT ((0)) FOR [BrandID]
GO
ALTER TABLE [MSTR].[FactOFDCasesCuts] ADD  CONSTRAINT [DF_FactOFDCasesCuts_PackageTypeID]  DEFAULT ((0)) FOR [PackageID]
GO
ALTER TABLE [MSTR].[FactOFDCasesCuts] ADD  CONSTRAINT [DF_FactOFDCasesCuts_RecordDate]  DEFAULT (getdate()) FOR [RecordDate]
GO
ALTER TABLE [MSTR].[FactOFDDailyMetrics] ADD  CONSTRAINT [DF_FactOFDDailyMetrics_RecordDate]  DEFAULT (getdate()) FOR [RecordDate]
GO
ALTER TABLE [MSTR].[LogFactMyDayCustomer] ADD  CONSTRAINT [DF_LogFactMyDayCustomer_LoadDate]  DEFAULT (getdate()) FOR [LoadDate]
GO
ALTER TABLE [MSTR].[LogFactMyDayCustomer] ADD  CONSTRAINT [DF_LogFactMyDayCustomer_RecordsLoaded]  DEFAULT ((0)) FOR [RecordsLoaded]
GO
ALTER TABLE [MSTR].[LogFactMyDayCustomer] ADD  CONSTRAINT [DF_LogFactMyDayCustomer_TotalCases]  DEFAULT ((0)) FOR [TotalCases]
GO
ALTER TABLE [MSTR].[LogFactMyDayCustomer] ADD  CONSTRAINT [DF_LogFactMyDayCustomer_TotalRevenue]  DEFAULT ((0)) FOR [TotalRevenue]
GO
ALTER TABLE [MSTR].[SurveyPhotos] ADD  DEFAULT (getdate()) FOR [PhotoTimestamp]
GO
ALTER TABLE [MSTR].[SurveyQuestion] ADD  CONSTRAINT [DF__SurveyQue__inser__59D0414E]  DEFAULT (getdate()) FOR [insertdate]
GO
ALTER TABLE [MSTR].[SurveyResults] ADD  DEFAULT (getdate()) FOR [insertdate]
GO
ALTER TABLE [MSTR].[SurveyResultsStaging] ADD  CONSTRAINT [DF_SurveyResultsStaging_DQ1]  DEFAULT ((0)) FOR [DQ1]
GO
ALTER TABLE [MSTR].[SurveyResultsStaging] ADD  CONSTRAINT [DF_SurveyResultsStaging_DQ2]  DEFAULT ((0)) FOR [DQ2]
GO
ALTER TABLE [MSTR].[SurveyResultsStaging] ADD  CONSTRAINT [DF_SurveyResultsStaging_DQ3]  DEFAULT ((0)) FOR [DQ3]
GO
ALTER TABLE [MSTR].[SurveyResultsStaging] ADD  CONSTRAINT [DF_SurveyResultsStaging_PDQ1]  DEFAULT ((0)) FOR [PDQ1]
GO
ALTER TABLE [MSTR].[SurveyResultsStaging] ADD  CONSTRAINT [DF_SurveyResultsStaging_PDQ2]  DEFAULT ((0)) FOR [PDQ2]
GO
ALTER TABLE [MSTR].[SurveyResultsStaging] ADD  CONSTRAINT [DF_SurveyResultsStaging_SPQ1]  DEFAULT ((0)) FOR [SPQ1]
GO
ALTER TABLE [MSTR].[SurveyResultsStaging] ADD  CONSTRAINT [DF_SurveyResultsStaging_GMQ1]  DEFAULT ((0)) FOR [GMQ1]
GO
ALTER TABLE [MSTR].[SurveyResultsStaging] ADD  CONSTRAINT [DF_SurveyResultsStaging_GMQ2]  DEFAULT ((0)) FOR [GMQ2]
GO
ALTER TABLE [MSTR].[SurveyResultsStaging] ADD  CONSTRAINT [DF_SurveyResultsStaging_GMQ3]  DEFAULT ((0)) FOR [GMQ3]
GO
ALTER TABLE [MSTR].[SurveyResultsStaging] ADD  CONSTRAINT [DF_SurveyResultsStaging_GMQ4]  DEFAULT ((0)) FOR [GMQ4]
GO
ALTER TABLE [MSTR].[SurveyResultsStaging] ADD  DEFAULT (getdate()) FOR [insertdate]
GO
ALTER TABLE [MSTR].[Surveys] ADD  DEFAULT (getdate()) FOR [insertdate]
GO
ALTER TABLE [MSTR].[SurveyUser] ADD  DEFAULT (getdate()) FOR [insertdate]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_HPGal_SKU]  DEFAULT ((0)) FOR [HPGal_SKU]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_HP32_SKU]  DEFAULT ((0)) FOR [HP32_SKU]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Motts64_SKU]  DEFAULT ((0)) FOR [Motts64_SKU]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Motts128_SKU]  DEFAULT ((0)) FOR [Motts128_SKU]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_CLAMATO64_SKU]  DEFAULT ((0)) FOR [CLAMATO64_SKU]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_CLAMATO32_SKU]  DEFAULT ((0)) FOR [CLAMATO32_SKU]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_HP10_SKU]  DEFAULT ((0)) FOR [HP10_SKU]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Motts8_SKU]  DEFAULT ((0)) FOR [Motts8_SKU]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_MottsMFTTetra_SKU]  DEFAULT ((0)) FOR [MottsMFTTetra_SKU]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Yoohoo_SKU]  DEFAULT ((0)) FOR [Yoohoo_SKU]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_VITACOCOKIDS_SKU]  DEFAULT ((0)) FOR [VITACOCOKIDS_SKU]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_CLAMATOCANS_SKU]  DEFAULT ((0)) FOR [CLAMATOCANS_SKU]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Apple636_SKU]  DEFAULT ((0)) FOR [Apple636_SKU]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Apple4SP_SKU]  DEFAULT ((0)) FOR [Apple4SP_SKU]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_AppleMS_SKU]  DEFAULT ((0)) FOR [AppleMS_SKU]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_IBC_SKU]  DEFAULT ((0)) FOR [IBC_SKU]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_CRUSH_SKU]  DEFAULT ((0)) FOR [CRUSH_SKU]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_MrMrsT1L_SKU]  DEFAULT ((0)) FOR [MrMrsT1L_SKU]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_MrMrsT175L_SKU]  DEFAULT ((0)) FOR [MrMrsT175L_SKU]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Roses_SKU]  DEFAULT ((0)) FOR [Roses_SKU]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_HPGal_BLOCKED]  DEFAULT ((0)) FOR [HPGal_BLOCKED]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_HP32_BLOCKED]  DEFAULT ((0)) FOR [HP32_BLOCKED]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Motts64_BLOCKED]  DEFAULT ((0)) FOR [Motts64_BLOCKED]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Motts128_BLOCKED]  DEFAULT ((0)) FOR [Motts128_BLOCKED]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_CLAMATO64_BLOCKED]  DEFAULT ((0)) FOR [CLAMATO64_BLOCKED]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_CLAMATO32_BLOCKED]  DEFAULT ((0)) FOR [CLAMATO32_BLOCKED]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_HP10_BLOCKED]  DEFAULT ((0)) FOR [HP10_BLOCKED]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Motts8_BLOCKED]  DEFAULT ((0)) FOR [Motts8_BLOCKED]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_MottsMFTTetra_BLOCKED]  DEFAULT ((0)) FOR [MottsMFTTetra_BLOCKED]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Yoohoo_BLOCKED]  DEFAULT ((0)) FOR [Yoohoo_BLOCKED]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_VITACOCOKIDS_BLOCKED]  DEFAULT ((0)) FOR [VITACOCOKIDS_BLOCKED]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_CLAMATOCANS_BLOCKED]  DEFAULT ((0)) FOR [CLAMATOCANS_BLOCKED]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Apple636_BLOCKED]  DEFAULT ((0)) FOR [Apple636_BLOCKED]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Apple4SP_BLOCKED]  DEFAULT ((0)) FOR [Apple4SP_BLOCKED]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_AppleMS_BLOCKED]  DEFAULT ((0)) FOR [AppleMS_BLOCKED]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_IBC_BLOCKED]  DEFAULT ((0)) FOR [IBC_BLOCKED]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_CRUSH_BLOCKED]  DEFAULT ((0)) FOR [CRUSH_BLOCKED]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_MrMrsT1L_BLOCKED]  DEFAULT ((0)) FOR [MrMrsT1L_BLOCKED]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_MrMrsT175L_BLOCKED]  DEFAULT ((0)) FOR [MrMrsT175L_BLOCKED]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Roses_BLOCKED]  DEFAULT ((0)) FOR [Roses_BLOCKED]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_HPGal_EDPRICE]  DEFAULT ((0)) FOR [HPGal_EDPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_HP32_EDPRICE]  DEFAULT ((0)) FOR [HP32_EDPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Motts64_EDPRICE]  DEFAULT ((0)) FOR [Motts64_EDPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Motts128_EDPRICE]  DEFAULT ((0)) FOR [Motts128_EDPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_CLAMATO64_EDPRICE]  DEFAULT ((0)) FOR [CLAMATO64_EDPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_CLAMATO32_EDPRICE]  DEFAULT ((0)) FOR [CLAMATO32_EDPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_HP10_EDPRICE]  DEFAULT ((0)) FOR [HP10_EDPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Motts8_EDPRICE]  DEFAULT ((0)) FOR [Motts8_EDPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_MottsMFTTetra_EDPRICE]  DEFAULT ((0)) FOR [MottsMFTTetra_EDPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Yoohoo_EDPRICE]  DEFAULT ((0)) FOR [Yoohoo_EDPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_VITACOCOKIDS_EDPRICE]  DEFAULT ((0)) FOR [VITACOCOKIDS_EDPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_CLAMATOCANS_EDPRICE]  DEFAULT ((0)) FOR [CLAMATOCANS_EDPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Apple636_EDPRICE]  DEFAULT ((0)) FOR [Apple636_EDPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Apple4SP_EDPRICE]  DEFAULT ((0)) FOR [Apple4SP_EDPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_AppleMS_EDPRICE]  DEFAULT ((0)) FOR [AppleMS_EDPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_IBC_EDPRICE]  DEFAULT ((0)) FOR [IBC_EDPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_CRUSH_EDPRICE]  DEFAULT ((0)) FOR [CRUSH_EDPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_MrMrsT1L_EDPRICE]  DEFAULT ((0)) FOR [MrMrsT1L_EDPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_MrMrsT175L_EDPRICE]  DEFAULT ((0)) FOR [MrMrsT175L_EDPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Roses_EDPRICE]  DEFAULT ((0)) FOR [Roses_EDPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_HPGal_EDCOMPPRICE]  DEFAULT ((0)) FOR [HPGal_EDCOMPPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_HP32_EDCOMPPRICE]  DEFAULT ((0)) FOR [HP32_EDCOMPPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Motts64_EDCOMPPRICE]  DEFAULT ((0)) FOR [Motts64_EDCOMPPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Motts128_EDCOMPPRICE]  DEFAULT ((0)) FOR [Motts128_EDCOMPPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_CLAMATO64_EDCOMPPRICE]  DEFAULT ((0)) FOR [CLAMATO64_EDCOMPPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_CLAMATO32_EDCOMPPRICE]  DEFAULT ((0)) FOR [CLAMATO32_EDCOMPPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_HP10_EDCOMPPRICE]  DEFAULT ((0)) FOR [HP10_EDCOMPPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Motts8_EDCOMPPRICE]  DEFAULT ((0)) FOR [Motts8_EDCOMPPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_MottsMFTTetra_EDCOMPPRICE]  DEFAULT ((0)) FOR [MottsMFTTetra_EDCOMPPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Yoohoo_EDCOMPPRICE]  DEFAULT ((0)) FOR [Yoohoo_EDCOMPPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_VITACOCOKIDS_EDCOMPPRICE]  DEFAULT ((0)) FOR [VITACOCOKIDS_EDCOMPPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_CLAMATOCANS_EDCOMPPRICE]  DEFAULT ((0)) FOR [CLAMATOCANS_EDCOMPPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Apple636_EDCOMPPRICE]  DEFAULT ((0)) FOR [Apple636_EDCOMPPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Apple4SP_EDCOMPPRICE]  DEFAULT ((0)) FOR [Apple4SP_EDCOMPPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_AppleMS_EDCOMPPRICE]  DEFAULT ((0)) FOR [AppleMS_EDCOMPPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_IBC_EDCOMPPRICE]  DEFAULT ((0)) FOR [IBC_EDCOMPPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_CRUSH_EDCOMPPRICE]  DEFAULT ((0)) FOR [CRUSH_EDCOMPPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_MrMrsT1L_EDCOMPPRICE]  DEFAULT ((0)) FOR [MrMrsT1L_EDCOMPPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_MrMrsT175L_EDCOMPPRICE]  DEFAULT ((0)) FOR [MrMrsT175L_EDCOMPPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Roses_EDCOMPPRICE]  DEFAULT ((0)) FOR [Roses_EDCOMPPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_HPGal_PROMO]  DEFAULT ((0)) FOR [HPGal_PROMO]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_HP32_PROMO]  DEFAULT ((0)) FOR [HP32_PROMO]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Motts64_PROMO]  DEFAULT ((0)) FOR [Motts64_PROMO]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Motts128_PROMO]  DEFAULT ((0)) FOR [Motts128_PROMO]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_CLAMATO64_PROMO]  DEFAULT ((0)) FOR [CLAMATO64_PROMO]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_CLAMATO32_PROMO]  DEFAULT ((0)) FOR [CLAMATO32_PROMO]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_HP10_PROMO]  DEFAULT ((0)) FOR [HP10_PROMO]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Motts8_PROMO]  DEFAULT ((0)) FOR [Motts8_PROMO]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_MottsMFTTetra_PROMO]  DEFAULT ((0)) FOR [MottsMFTTetra_PROMO]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Yoohoo_PROMO]  DEFAULT ((0)) FOR [Yoohoo_PROMO]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_VITACOCOKIDS_PROMO]  DEFAULT ((0)) FOR [VITACOCOKIDS_PROMO]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_CLAMATOCANS_PROMO]  DEFAULT ((0)) FOR [CLAMATOCANS_PROMO]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Apple636_PROMO]  DEFAULT ((0)) FOR [Apple636_PROMO]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Apple4SP_PROMO]  DEFAULT ((0)) FOR [Apple4SP_PROMO]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_AppleMS_PROMO]  DEFAULT ((0)) FOR [AppleMS_PROMO]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_IBC_PROMO]  DEFAULT ((0)) FOR [IBC_PROMO]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_CRUSH_PROMO]  DEFAULT ((0)) FOR [CRUSH_PROMO]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_MrMrsT1L_PROMO]  DEFAULT ((0)) FOR [MrMrsT1L_PROMO]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_MrMrsT175L_PROMO]  DEFAULT ((0)) FOR [MrMrsT175L_PROMO]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Roses_PROMO]  DEFAULT ((0)) FOR [Roses_PROMO]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_HPGal_PROMOPRICE]  DEFAULT ((0)) FOR [HPGal_PROMOPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_HP32_PROMOPRICE]  DEFAULT ((0)) FOR [HP32_PROMOPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Motts64_PROMOPRICE]  DEFAULT ((0)) FOR [Motts64_PROMOPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Motts128_PROMOPRICE]  DEFAULT ((0)) FOR [Motts128_PROMOPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_CLAMATO64_PROMOPRICE]  DEFAULT ((0)) FOR [CLAMATO64_PROMOPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_CLAMATO32_PROMOPRICE]  DEFAULT ((0)) FOR [CLAMATO32_PROMOPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_HP10_PROMOPRICE]  DEFAULT ((0)) FOR [HP10_PROMOPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Motts8_PROMOPRICE]  DEFAULT ((0)) FOR [Motts8_PROMOPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_MottsMFTTetra_PROMOPRICE]  DEFAULT ((0)) FOR [MottsMFTTetra_PROMOPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Yoohoo_PROMOPRICE]  DEFAULT ((0)) FOR [Yoohoo_PROMOPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_VITACOCOKIDS_PROMOPRICE]  DEFAULT ((0)) FOR [VITACOCOKIDS_PROMOPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_CLAMATOKIDS_PROMOPRICE]  DEFAULT ((0)) FOR [CLAMATOCANS_PROMOPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Apple636_PROMOPRICE]  DEFAULT ((0)) FOR [Apple636_PROMOPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Apple4SP_PROMOPRICE]  DEFAULT ((0)) FOR [Apple4SP_PROMOPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_AppleMS_PROMOPRICE]  DEFAULT ((0)) FOR [AppleMS_PROMOPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_IBC_PROMOPRICE]  DEFAULT ((0)) FOR [IBC_PROMOPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_CRUSH_PROMOPRICE]  DEFAULT ((0)) FOR [CRUSH_PROMOPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_MrMrsT1L_PROMOPRICE]  DEFAULT ((0)) FOR [MrMrsT1L_PROMOPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_MrMrsT175L_PROMOPRICE]  DEFAULT ((0)) FOR [MrMrsT175L_PROMOPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Roses_PROMOPRICE]  DEFAULT ((0)) FOR [Roses_PROMOPRICE]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_HPGal_INAD]  DEFAULT ((0)) FOR [HPGal_INAD]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_HP32_INAD]  DEFAULT ((0)) FOR [HP32_INAD]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Motts64_INAD]  DEFAULT ((0)) FOR [Motts64_INAD]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Motts128_INAD]  DEFAULT ((0)) FOR [Motts128_INAD]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_CLAMATO64_INAD]  DEFAULT ((0)) FOR [CLAMATO64_INAD]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_CLAMATO32_INAD]  DEFAULT ((0)) FOR [CLAMATO32_INAD]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_HP10_INAD]  DEFAULT ((0)) FOR [HP10_INAD]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Motts8_INAD]  DEFAULT ((0)) FOR [Motts8_INAD]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_MottsMFTTetra_INAD]  DEFAULT ((0)) FOR [MottsMFTTetra_INAD]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Yoohoo_INAD]  DEFAULT ((0)) FOR [Yoohoo_INAD]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_VITACOCOKIDS_INAD]  DEFAULT ((0)) FOR [VITACOCOKIDS_INAD]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_CLAMATOCANS_INAD]  DEFAULT ((0)) FOR [CLAMATOCANS_INAD]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Apple636_INAD]  DEFAULT ((0)) FOR [Apple636_INAD]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Apple4SP_INAD]  DEFAULT ((0)) FOR [Apple4SP_INAD]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_AppleMS_INAD]  DEFAULT ((0)) FOR [AppleMS_INAD]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_IBC_INAD]  DEFAULT ((0)) FOR [IBC_INAD]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_CRUSH_INAD]  DEFAULT ((0)) FOR [CRUSH_INAD]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_MrMrsT1L_INAD]  DEFAULT ((0)) FOR [MrMrsT1L_INAD]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_MrMrsT175L_INAD]  DEFAULT ((0)) FOR [MrMrsT175L_INAD]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Roses_INAD]  DEFAULT ((0)) FOR [Roses_INAD]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_HPGal_DISPLAY]  DEFAULT ((0)) FOR [HPGal_DISPLAY]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_HP32_DISPLAY]  DEFAULT ((0)) FOR [HP32_DISPLAY]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Motts64_DISPLAY]  DEFAULT ((0)) FOR [Motts64_DISPLAY]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Motts128_DISPLAY]  DEFAULT ((0)) FOR [Motts128_DISPLAY]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_CLAMATO64_DISPLAY]  DEFAULT ((0)) FOR [CLAMATO64_DISPLAY]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_CLAMATO32_DISPLAY]  DEFAULT ((0)) FOR [CLAMATO32_DISPLAY]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_HP10_DISPLAY]  DEFAULT ((0)) FOR [HP10_DISPLAY]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Motts8_DISPLAY]  DEFAULT ((0)) FOR [Motts8_DISPLAY]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_MottsMFTTetra_DISPLAY]  DEFAULT ((0)) FOR [MottsMFTTetra_DISPLAY]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Yoohoo_DISPLAY]  DEFAULT ((0)) FOR [Yoohoo_DISPLAY]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_VITACOCOKIDS_DISPLAY]  DEFAULT ((0)) FOR [VITACOCOKIDS_DISPLAY]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_CLAMATOCANS_DISPLAY]  DEFAULT ((0)) FOR [CLAMATOCANS_DISPLAY]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Apple636_DISPLAY]  DEFAULT ((0)) FOR [Apple636_DISPLAY]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Apple4SP_DISPLAY]  DEFAULT ((0)) FOR [Apple4SP_DISPLAY]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_AppleMS_DISPLAY]  DEFAULT ((0)) FOR [AppleMS_DISPLAY]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_IBC_DISPLAY]  DEFAULT ((0)) FOR [IBC_DISPLAY]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_CRUSH_DISPLAY]  DEFAULT ((0)) FOR [CRUSH_DISPLAY]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_MrMrsT1L_DISPLAY]  DEFAULT ((0)) FOR [MrMrsT1L_DISPLAY]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_MrMrsT175L_DISPLAY]  DEFAULT ((0)) FOR [MrMrsT175L_DISPLAY]
GO
ALTER TABLE [MSTR].[WDDetailSurveyResults] ADD  CONSTRAINT [DF_WDDetailSurveyResults_Roses_DISPLAY]  DEFAULT ((0)) FOR [Roses_DISPLAY]
GO
ALTER TABLE [MSTR].[WDInputsSurveyResults] ADD  CONSTRAINT [DF_WDInputsSurveyResults_ManagerValidation]  DEFAULT ((1)) FOR [ManagerValidation]
GO
ALTER TABLE [Person].[SPUserProfile] ADD  CONSTRAINT [DF_SPUserProfile_UpdatedInSP]  DEFAULT ((0)) FOR [UpdatedInSP]
GO
ALTER TABLE [PlayBook].[Status] ADD  CONSTRAINT [DF__Promotion__IsAct__7AA72534]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [EDGE].[RPLAttachment]  WITH CHECK ADD  CONSTRAINT [FK_RPLAttachment_RPLItem] FOREIGN KEY([ItemID])
REFERENCES [EDGE].[RPLItem] ([ItemID])
GO
ALTER TABLE [EDGE].[RPLAttachment] CHECK CONSTRAINT [FK_RPLAttachment_RPLItem]
GO
ALTER TABLE [EDGE].[RPLItemAccount]  WITH CHECK ADD  CONSTRAINT [FK_RPLItemAccount_RPLItem] FOREIGN KEY([ItemID])
REFERENCES [EDGE].[RPLItem] ([ItemID])
GO
ALTER TABLE [EDGE].[RPLItemAccount] CHECK CONSTRAINT [FK_RPLItemAccount_RPLItem]
GO
ALTER TABLE [EDGE].[RPLItemBrand]  WITH CHECK ADD  CONSTRAINT [FK_RPLItemBrand_RPLItem] FOREIGN KEY([ItemID])
REFERENCES [EDGE].[RPLItem] ([ItemID])
GO
ALTER TABLE [EDGE].[RPLItemBrand] CHECK CONSTRAINT [FK_RPLItemBrand_RPLItem]
GO
ALTER TABLE [EDGE].[RPLItemChannel]  WITH CHECK ADD  CONSTRAINT [FK_RPLItemChannel_RPLItem] FOREIGN KEY([ItemID])
REFERENCES [EDGE].[RPLItem] ([ItemID])
GO
ALTER TABLE [EDGE].[RPLItemChannel] CHECK CONSTRAINT [FK_RPLItemChannel_RPLItem]
GO
ALTER TABLE [EDGE].[RPLItemNAE]  WITH CHECK ADD  CONSTRAINT [FK_RPLItemNAE_RPLItem] FOREIGN KEY([ItemID])
REFERENCES [EDGE].[RPLItem] ([ItemID])
GO
ALTER TABLE [EDGE].[RPLItemNAE] CHECK CONSTRAINT [FK_RPLItemNAE_RPLItem]
GO
ALTER TABLE [EDGE].[RPLItemPackage]  WITH CHECK ADD  CONSTRAINT [FK_RPLItemPackage_RPLItem] FOREIGN KEY([ItemID])
REFERENCES [EDGE].[RPLItem] ([ItemID])
GO
ALTER TABLE [EDGE].[RPLItemPackage] CHECK CONSTRAINT [FK_RPLItemPackage_RPLItem]
GO
ALTER TABLE [MSTR].[DimBranchPlan]  WITH NOCHECK ADD  CONSTRAINT [FK_FactAnnualPlan_Branch] FOREIGN KEY([BranchID])
REFERENCES [SAP].[Branch] ([BranchID])
NOT FOR REPLICATION 
GO
ALTER TABLE [MSTR].[DimBranchPlan] NOCHECK CONSTRAINT [FK_FactAnnualPlan_Branch]
GO
ALTER TABLE [MSTR].[DimBranchPlan]  WITH NOCHECK ADD  CONSTRAINT [FK_FactAnnualPlan_DimMonth] FOREIGN KEY([monthid])
REFERENCES [MSTR].[DimMonth] ([MonthID])
NOT FOR REPLICATION 
GO
ALTER TABLE [MSTR].[DimBranchPlan] NOCHECK CONSTRAINT [FK_FactAnnualPlan_DimMonth]
GO
ALTER TABLE [MSTR].[DimBrandPackageMarginTiers]  WITH NOCHECK ADD  CONSTRAINT [FK_DimBrandPackageMarginTiers_Brand] FOREIGN KEY([BrandId])
REFERENCES [SAP].[Brand] ([BrandID])
NOT FOR REPLICATION 
GO
ALTER TABLE [MSTR].[DimBrandPackageMarginTiers] NOCHECK CONSTRAINT [FK_DimBrandPackageMarginTiers_Brand]
GO
ALTER TABLE [MSTR].[DimBrandPackageMarginTiers]  WITH NOCHECK ADD  CONSTRAINT [FK_DimBrandPackageMarginTiers_Package] FOREIGN KEY([PackageId])
REFERENCES [SAP].[Package] ([PackageID])
NOT FOR REPLICATION 
GO
ALTER TABLE [MSTR].[DimBrandPackageMarginTiers] NOCHECK CONSTRAINT [FK_DimBrandPackageMarginTiers_Package]
GO
ALTER TABLE [MSTR].[DimTENBrands]  WITH NOCHECK ADD  CONSTRAINT [FK_DimTENBrands_Brand] FOREIGN KEY([BrandID])
REFERENCES [SAP].[Brand] ([BrandID])
NOT FOR REPLICATION 
GO
ALTER TABLE [MSTR].[DimTENBrands] NOCHECK CONSTRAINT [FK_DimTENBrands_Brand]
GO
ALTER TABLE [MSTR].[FactMyDayBranchPlanRanking]  WITH NOCHECK ADD  CONSTRAINT [FK_FactMyDayBranchPlanRanking_DimMonth] FOREIGN KEY([MonthID])
REFERENCES [MSTR].[DimMonth] ([MonthID])
NOT FOR REPLICATION 
GO
ALTER TABLE [MSTR].[FactMyDayBranchPlanRanking] NOCHECK CONSTRAINT [FK_FactMyDayBranchPlanRanking_DimMonth]
GO
ALTER TABLE [MSTR].[FactMyDayBranchPlanRanking]  WITH NOCHECK ADD  CONSTRAINT [FK_FactMyDayBranchPlanRanking_DimMydaySalesPlanVersions] FOREIGN KEY([VersionID])
REFERENCES [MSTR].[DimMydaySalesPlanVersions] ([VersionID])
NOT FOR REPLICATION 
GO
ALTER TABLE [MSTR].[FactMyDayBranchPlanRanking] NOCHECK CONSTRAINT [FK_FactMyDayBranchPlanRanking_DimMydaySalesPlanVersions]
GO
ALTER TABLE [MSTR].[FactMyDayBranchPlanRanking]  WITH NOCHECK ADD  CONSTRAINT [FK_FactMyDayBranchPlanRanking_SalesRoute] FOREIGN KEY([RouteID])
REFERENCES [SAP].[SalesRoute] ([RouteID])
NOT FOR REPLICATION 
GO
ALTER TABLE [MSTR].[FactMyDayBranchPlanRanking] NOCHECK CONSTRAINT [FK_FactMyDayBranchPlanRanking_SalesRoute]
GO
ALTER TABLE [MSTR].[FactMyDayRoutePlan]  WITH NOCHECK ADD  CONSTRAINT [FK_FactMyDaySalesOfficePlan_DimMonth] FOREIGN KEY([MonthID])
REFERENCES [MSTR].[DimMonth] ([MonthID])
NOT FOR REPLICATION 
GO
ALTER TABLE [MSTR].[FactMyDayRoutePlan] NOCHECK CONSTRAINT [FK_FactMyDaySalesOfficePlan_DimMonth]
GO
ALTER TABLE [MSTR].[FactMyDayRoutePlan]  WITH NOCHECK ADD  CONSTRAINT [FK_FactMyDaySalesOfficePlan_DimMydaySalesPlanVersions] FOREIGN KEY([VersionID])
REFERENCES [MSTR].[DimMydaySalesPlanVersions] ([VersionID])
NOT FOR REPLICATION 
GO
ALTER TABLE [MSTR].[FactMyDayRoutePlan] NOCHECK CONSTRAINT [FK_FactMyDaySalesOfficePlan_DimMydaySalesPlanVersions]
GO
ALTER TABLE [MSTR].[FactMyDayRoutePlan]  WITH NOCHECK ADD  CONSTRAINT [FK_FactMyDaySalesOfficePlan_SalesRoute] FOREIGN KEY([RouteID])
REFERENCES [SAP].[SalesRoute] ([RouteID])
NOT FOR REPLICATION 
GO
ALTER TABLE [MSTR].[FactMyDayRoutePlan] NOCHECK CONSTRAINT [FK_FactMyDaySalesOfficePlan_SalesRoute]
GO
ALTER TABLE [MSTR].[RelMyDaySalesOfficePlanVersion]  WITH NOCHECK ADD  CONSTRAINT [FK_RelMyDaySalesOfficePlanVersion_Branch] FOREIGN KEY([BranchID])
REFERENCES [SAP].[Branch] ([BranchID])
NOT FOR REPLICATION 
GO
ALTER TABLE [MSTR].[RelMyDaySalesOfficePlanVersion] NOCHECK CONSTRAINT [FK_RelMyDaySalesOfficePlanVersion_Branch]
GO
ALTER TABLE [MSTR].[RelMyDaySalesOfficePlanVersion]  WITH NOCHECK ADD  CONSTRAINT [FK_RelMyDaySalesOfficePlanVersion_DimMydaySalesPlanVersions] FOREIGN KEY([VersionID])
REFERENCES [MSTR].[DimMydaySalesPlanVersions] ([VersionID])
NOT FOR REPLICATION 
GO
ALTER TABLE [MSTR].[RelMyDaySalesOfficePlanVersion] NOCHECK CONSTRAINT [FK_RelMyDaySalesOfficePlanVersion_DimMydaySalesPlanVersions]
GO
ALTER TABLE [MSTR].[SurveyQuestion]  WITH NOCHECK ADD  CONSTRAINT [FK_SurveyQuestion_Surveys] FOREIGN KEY([surveyId])
REFERENCES [MSTR].[Surveys] ([surveyId])
NOT FOR REPLICATION 
GO
ALTER TABLE [MSTR].[SurveyQuestion] NOCHECK CONSTRAINT [FK_SurveyQuestion_Surveys]
GO
ALTER TABLE [MSTR].[SurveyResults]  WITH NOCHECK ADD  CONSTRAINT [FK_SurveyResults_Surveys] FOREIGN KEY([surveyId])
REFERENCES [MSTR].[Surveys] ([surveyId])
NOT FOR REPLICATION 
GO
ALTER TABLE [MSTR].[SurveyResults] NOCHECK CONSTRAINT [FK_SurveyResults_Surveys]
GO
ALTER TABLE [MSTR].[SurveyUser]  WITH NOCHECK ADD  CONSTRAINT [FK_SurveyUser_Surveys] FOREIGN KEY([surveyId])
REFERENCES [MSTR].[Surveys] ([surveyId])
NOT FOR REPLICATION 
GO
ALTER TABLE [MSTR].[SurveyUser] NOCHECK CONSTRAINT [FK_SurveyUser_Surveys]
GO
ALTER TABLE [Person].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Branch] FOREIGN KEY([BranchID])
REFERENCES [SAP].[Branch] ([BranchID])
GO
ALTER TABLE [Person].[Employee] CHECK CONSTRAINT [FK_Employee_Branch]
GO
ALTER TABLE [Person].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Role] FOREIGN KEY([RoleID])
REFERENCES [Person].[Role] ([RoleID])
GO
ALTER TABLE [Person].[Employee] CHECK CONSTRAINT [FK_Employee_Role]
GO
ALTER TABLE [Person].[Job]  WITH CHECK ADD  CONSTRAINT [FK_JobCode_Role] FOREIGN KEY([RoleID])
REFERENCES [Person].[Role] ([RoleID])
GO
ALTER TABLE [Person].[Job] CHECK CONSTRAINT [FK_JobCode_Role]
GO
ALTER TABLE [Person].[SPUserProfile]  WITH CHECK ADD FOREIGN KEY([RoleID])
REFERENCES [Person].[Role] ([RoleID])
GO
ALTER TABLE [Person].[SPUserProfile]  WITH CHECK ADD  CONSTRAINT [FK_SPUserProfile_UserProfile] FOREIGN KEY([GSN])
REFERENCES [Person].[UserProfile] ([GSN])
GO
ALTER TABLE [Person].[SPUserProfile] CHECK CONSTRAINT [FK_SPUserProfile_UserProfile]
GO
ALTER TABLE [Person].[UserBranchTradeMark]  WITH CHECK ADD FOREIGN KEY([TradeMarkID])
REFERENCES [SAP].[TradeMark] ([TradeMarkID])
GO
ALTER TABLE [Person].[UserBranchTradeMark]  WITH CHECK ADD FOREIGN KEY([UserInBranchID])
REFERENCES [Person].[UserInBranch] ([UserInBranchID])
GO
ALTER TABLE [Person].[UserInBranch]  WITH CHECK ADD  CONSTRAINT [FK_UserInBranch_Branch] FOREIGN KEY([BranchID])
REFERENCES [SAP].[Branch] ([BranchID])
GO
ALTER TABLE [Person].[UserInBranch] CHECK CONSTRAINT [FK_UserInBranch_Branch]
GO
ALTER TABLE [Person].[UserInBranch]  WITH CHECK ADD  CONSTRAINT [FK_UserInBranch_UserProfile] FOREIGN KEY([GSN])
REFERENCES [Person].[UserProfile] ([GSN])
GO
ALTER TABLE [Person].[UserInBranch] CHECK CONSTRAINT [FK_UserInBranch_UserProfile]
GO
ALTER TABLE [Person].[UserInRole]  WITH CHECK ADD  CONSTRAINT [FK_UserInRole_Role] FOREIGN KEY([RoleID])
REFERENCES [Person].[Role] ([RoleID])
GO
ALTER TABLE [Person].[UserInRole] CHECK CONSTRAINT [FK_UserInRole_Role]
GO
ALTER TABLE [Person].[UserInRole]  WITH CHECK ADD  CONSTRAINT [FK_UserInRole_UserProfile] FOREIGN KEY([GSN])
REFERENCES [Person].[UserProfile] ([GSN])
GO
ALTER TABLE [Person].[UserInRole] CHECK CONSTRAINT [FK_UserInRole_UserProfile]
GO
ALTER TABLE [Person].[UserProfile]  WITH CHECK ADD  CONSTRAINT [FK_UserProfile_CostCenter] FOREIGN KEY([CostCenterID])
REFERENCES [SAP].[CostCenter] ([CostCenterID])
GO
ALTER TABLE [Person].[UserProfile] CHECK CONSTRAINT [FK_UserProfile_CostCenter]
GO
ALTER TABLE [PlayBook].[AttachmentRating]  WITH CHECK ADD  CONSTRAINT [FK_AttachmentRating_RetailPromotion] FOREIGN KEY([PromotionID])
REFERENCES [PlayBook].[RetailPromotion] ([PromotionID])
GO
ALTER TABLE [PlayBook].[AttachmentRating] CHECK CONSTRAINT [FK_AttachmentRating_RetailPromotion]
GO
ALTER TABLE [PlayBook].[AttachmentRating]  WITH CHECK ADD  CONSTRAINT [FK_AttachmentRating_UserProfile] FOREIGN KEY([GSN])
REFERENCES [Person].[UserProfile] ([GSN])
GO
ALTER TABLE [PlayBook].[AttachmentRating] CHECK CONSTRAINT [FK_AttachmentRating_UserProfile]
GO
ALTER TABLE [PlayBook].[PromotionAccount]  WITH CHECK ADD  CONSTRAINT [FK__Promotion__Promo__04308F6E] FOREIGN KEY([PromotionID])
REFERENCES [PlayBook].[RetailPromotion] ([PromotionID])
GO
ALTER TABLE [PlayBook].[PromotionAccount] CHECK CONSTRAINT [FK__Promotion__Promo__04308F6E]
GO
ALTER TABLE [PlayBook].[PromotionAttachment]  WITH CHECK ADD  CONSTRAINT [FK__Promotion__Promo__08012052] FOREIGN KEY([PromotionID])
REFERENCES [PlayBook].[RetailPromotion] ([PromotionID])
GO
ALTER TABLE [PlayBook].[PromotionAttachment] CHECK CONSTRAINT [FK__Promotion__Promo__08012052]
GO
ALTER TABLE [PlayBook].[PromotionAttachment]  WITH CHECK ADD  CONSTRAINT [FK_PromotionAttachment_AttachmentType] FOREIGN KEY([AttachmentTypeID])
REFERENCES [PlayBook].[AttachmentType] ([AttachmentTypeID])
GO
ALTER TABLE [PlayBook].[PromotionAttachment] CHECK CONSTRAINT [FK_PromotionAttachment_AttachmentType]
GO
ALTER TABLE [PlayBook].[PromotionBrand]  WITH CHECK ADD  CONSTRAINT [FK_PromotionBrand_RetailPromotion] FOREIGN KEY([PromotionID])
REFERENCES [PlayBook].[RetailPromotion] ([PromotionID])
GO
ALTER TABLE [PlayBook].[PromotionBrand] CHECK CONSTRAINT [FK_PromotionBrand_RetailPromotion]
GO
ALTER TABLE [PlayBook].[PromotionChannel]  WITH CHECK ADD  CONSTRAINT [FK_PromotionChannel_RetailPromotion] FOREIGN KEY([PromotionID])
REFERENCES [PlayBook].[RetailPromotion] ([PromotionID])
GO
ALTER TABLE [PlayBook].[PromotionChannel] CHECK CONSTRAINT [FK_PromotionChannel_RetailPromotion]
GO
ALTER TABLE [PlayBook].[PromotionDisplayLocation]  WITH CHECK ADD  CONSTRAINT [FK_PromotionDisplayLocation_DisplayLocation] FOREIGN KEY([DisplayLocationID])
REFERENCES [PlayBook].[DisplayLocation] ([DisplayLocationID])
GO
ALTER TABLE [PlayBook].[PromotionDisplayLocation] CHECK CONSTRAINT [FK_PromotionDisplayLocation_DisplayLocation]
GO
ALTER TABLE [PlayBook].[PromotionDisplayLocation]  WITH CHECK ADD  CONSTRAINT [FK_PromotionDisplayLocation_RetailPromotion1] FOREIGN KEY([PromotionID])
REFERENCES [PlayBook].[RetailPromotion] ([PromotionID])
GO
ALTER TABLE [PlayBook].[PromotionDisplayLocation] CHECK CONSTRAINT [FK_PromotionDisplayLocation_RetailPromotion1]
GO
ALTER TABLE [PlayBook].[PromotionGeographic]  WITH NOCHECK ADD  CONSTRAINT [FK_PromotionGeographic_RetailPromotion] FOREIGN KEY([PromotionID])
REFERENCES [PlayBook].[RetailPromotion] ([PromotionID])
GO
ALTER TABLE [PlayBook].[PromotionGeographic] NOCHECK CONSTRAINT [FK_PromotionGeographic_RetailPromotion]
GO
ALTER TABLE [PlayBook].[RetailPromotion]  WITH CHECK ADD  CONSTRAINT [FK__RetailPro__ItemI__04EFA97D] FOREIGN KEY([EDGEItemID])
REFERENCES [EDGE].[RPLItem] ([ItemID])
GO
ALTER TABLE [PlayBook].[RetailPromotion] CHECK CONSTRAINT [FK__RetailPro__ItemI__04EFA97D]
GO
ALTER TABLE [PlayBook].[RetailPromotion]  WITH CHECK ADD  CONSTRAINT [FK__RetailPro__Promo__7D8391DF] FOREIGN KEY([PromotionStatusID])
REFERENCES [PlayBook].[Status] ([StatusID])
GO
ALTER TABLE [PlayBook].[RetailPromotion] CHECK CONSTRAINT [FK__RetailPro__Promo__7D8391DF]
GO
ALTER TABLE [PlayBook].[RetailPromotion]  WITH CHECK ADD  CONSTRAINT [FK_RetailPromotion_PromotionCategory] FOREIGN KEY([PromotionCategoryID])
REFERENCES [PlayBook].[PromotionCategory] ([PromotionCategoryID])
GO
ALTER TABLE [PlayBook].[RetailPromotion] CHECK CONSTRAINT [FK_RetailPromotion_PromotionCategory]
GO
ALTER TABLE [SalesPriority].[SalesPriority]  WITH CHECK ADD  CONSTRAINT [FK_SalesPriority_SalesPriorityAlignment] FOREIGN KEY([SalesPriorityAlignmentID])
REFERENCES [SalesPriority].[SalesPriorityAlignment] ([SalesPriorityAlignmentID])
GO
ALTER TABLE [SalesPriority].[SalesPriority] CHECK CONSTRAINT [FK_SalesPriority_SalesPriorityAlignment]
GO
ALTER TABLE [SalesPriority].[SalesPriority]  WITH CHECK ADD  CONSTRAINT [FK_SalesPriority_SalesPriorityFormat] FOREIGN KEY([SalesPriorityFormatID])
REFERENCES [SalesPriority].[SalesPriorityFormat] ([SalesPriorityFormatID])
GO
ALTER TABLE [SalesPriority].[SalesPriority] CHECK CONSTRAINT [FK_SalesPriority_SalesPriorityFormat]
GO
ALTER TABLE [SalesPriority].[SalesPriority]  WITH CHECK ADD  CONSTRAINT [FK_SalesPriority_SalesPriorityStatus] FOREIGN KEY([SalesPriorityStatusID])
REFERENCES [SalesPriority].[Status] ([StatusID])
GO
ALTER TABLE [SalesPriority].[SalesPriority] CHECK CONSTRAINT [FK_SalesPriority_SalesPriorityStatus]
GO
ALTER TABLE [SalesPriority].[SalesPriorityAttachment]  WITH CHECK ADD  CONSTRAINT [FK_SalesPriorityAttachment_SalesPriority] FOREIGN KEY([SalesPriorityID])
REFERENCES [SalesPriority].[SalesPriority] ([SalesPriorityID])
GO
ALTER TABLE [SalesPriority].[SalesPriorityAttachment] CHECK CONSTRAINT [FK_SalesPriorityAttachment_SalesPriority]
GO
ALTER TABLE [SalesPriority].[SalesPriorityDisplayLocation]  WITH CHECK ADD  CONSTRAINT [FK_SalesPriorityDisplayLocation_DisplayLocation] FOREIGN KEY([DisplayLocationID])
REFERENCES [SalesPriority].[DisplayLocation] ([DisplayLocationID])
GO
ALTER TABLE [SalesPriority].[SalesPriorityDisplayLocation] CHECK CONSTRAINT [FK_SalesPriorityDisplayLocation_DisplayLocation]
GO
ALTER TABLE [SalesPriority].[SalesPriorityDisplayLocation]  WITH CHECK ADD  CONSTRAINT [FK_SalesPriorityDisplayLocation_SalesPriority] FOREIGN KEY([SalesPriorityID])
REFERENCES [SalesPriority].[SalesPriority] ([SalesPriorityID])
GO
ALTER TABLE [SalesPriority].[SalesPriorityDisplayLocation] CHECK CONSTRAINT [FK_SalesPriorityDisplayLocation_SalesPriority]
GO
ALTER TABLE [SalesPriority].[SalesPriorityPackage]  WITH CHECK ADD  CONSTRAINT [FK_SalesPriorityPackage_SalesPriority] FOREIGN KEY([SalesPriorityID])
REFERENCES [SalesPriority].[SalesPriority] ([SalesPriorityID])
GO
ALTER TABLE [SalesPriority].[SalesPriorityPackage] CHECK CONSTRAINT [FK_SalesPriorityPackage_SalesPriority]
GO
ALTER TABLE [SalesPriority].[SalesPriorityRank]  WITH CHECK ADD  CONSTRAINT [FK_SalesPriorityRank_SalesPriority] FOREIGN KEY([SalesPriorityID])
REFERENCES [SalesPriority].[SalesPriority] ([SalesPriorityID])
GO
ALTER TABLE [SalesPriority].[SalesPriorityRank] CHECK CONSTRAINT [FK_SalesPriorityRank_SalesPriority]
GO
ALTER TABLE [SalesPriority].[SalesPriorityTrademark]  WITH CHECK ADD  CONSTRAINT [FK_SalesPriorityBrands_SalesPriority] FOREIGN KEY([SalesPriorityID])
REFERENCES [SalesPriority].[SalesPriority] ([SalesPriorityID])
GO
ALTER TABLE [SalesPriority].[SalesPriorityTrademark] CHECK CONSTRAINT [FK_SalesPriorityBrands_SalesPriority]
GO
ALTER TABLE [SAP].[Account]  WITH CHECK ADD  CONSTRAINT [FK_Account_Branch] FOREIGN KEY([BranchID])
REFERENCES [SAP].[Branch] ([BranchID])
GO
ALTER TABLE [SAP].[Account] CHECK CONSTRAINT [FK_Account_Branch]
GO
ALTER TABLE [SAP].[Account]  WITH CHECK ADD  CONSTRAINT [FK_Account_Channel] FOREIGN KEY([ChannelID])
REFERENCES [SAP].[Channel] ([ChannelID])
GO
ALTER TABLE [SAP].[Account] CHECK CONSTRAINT [FK_Account_Channel]
GO
ALTER TABLE [SAP].[Account]  WITH CHECK ADD  CONSTRAINT [FK_Account_LocalChain] FOREIGN KEY([LocalChainID])
REFERENCES [SAP].[LocalChain] ([LocalChainID])
GO
ALTER TABLE [SAP].[Account] CHECK CONSTRAINT [FK_Account_LocalChain]
GO
ALTER TABLE [SAP].[Branch]  WITH CHECK ADD  CONSTRAINT [FK_Branch_Region] FOREIGN KEY([RegionID])
REFERENCES [SAP].[Region] ([RegionID])
GO
ALTER TABLE [SAP].[Branch] CHECK CONSTRAINT [FK_Branch_Region]
GO
ALTER TABLE [SAP].[BranchMaterial]  WITH CHECK ADD  CONSTRAINT [FK_BranchMaterial_Branch] FOREIGN KEY([BranchID])
REFERENCES [SAP].[Branch] ([BranchID])
GO
ALTER TABLE [SAP].[BranchMaterial] CHECK CONSTRAINT [FK_BranchMaterial_Branch]
GO
ALTER TABLE [SAP].[BranchMaterial]  WITH CHECK ADD  CONSTRAINT [FK_BranchMaterial_Material] FOREIGN KEY([MaterialID])
REFERENCES [SAP].[Material] ([MaterialID])
GO
ALTER TABLE [SAP].[BranchMaterial] CHECK CONSTRAINT [FK_BranchMaterial_Material]
GO
ALTER TABLE [SAP].[Brand]  WITH CHECK ADD  CONSTRAINT [FK_Brand_TradeMark] FOREIGN KEY([TrademarkID])
REFERENCES [SAP].[TradeMark] ([TradeMarkID])
GO
ALTER TABLE [SAP].[Brand] CHECK CONSTRAINT [FK_Brand_TradeMark]
GO
ALTER TABLE [SAP].[Channel]  WITH CHECK ADD  CONSTRAINT [FK_Channel_SuperChannel] FOREIGN KEY([SuperChannelID])
REFERENCES [SAP].[SuperChannel] ([SuperChannelID])
GO
ALTER TABLE [SAP].[Channel] CHECK CONSTRAINT [FK_Channel_SuperChannel]
GO
ALTER TABLE [SAP].[CostCenter]  WITH CHECK ADD  CONSTRAINT [FK_CostCenter_ProfitCenter] FOREIGN KEY([ProfitCenterID])
REFERENCES [SAP].[ProfitCenter] ([ProfitCenterID])
GO
ALTER TABLE [SAP].[CostCenter] CHECK CONSTRAINT [FK_CostCenter_ProfitCenter]
GO
ALTER TABLE [SAP].[LocalChain]  WITH CHECK ADD  CONSTRAINT [FK_LocalChain_RegionalChain] FOREIGN KEY([RegionalChainID])
REFERENCES [SAP].[RegionalChain] ([RegionalChainID])
GO
ALTER TABLE [SAP].[LocalChain] CHECK CONSTRAINT [FK_LocalChain_RegionalChain]
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
ALTER TABLE [SAP].[Material]  WITH CHECK ADD  CONSTRAINT [FK_Material_CaffeineClaim] FOREIGN KEY([CaffeineClaimID])
REFERENCES [SAP].[CaffeineClaim] ([CaffeineClaimID])
GO
ALTER TABLE [SAP].[Material] CHECK CONSTRAINT [FK_Material_CaffeineClaim]
GO
ALTER TABLE [SAP].[Material]  WITH NOCHECK ADD  CONSTRAINT [FK_Material_CalorieClass] FOREIGN KEY([CalorieClassID])
REFERENCES [SAP].[CalorieClass] ([CalorieClassID])
NOT FOR REPLICATION 
GO
ALTER TABLE [SAP].[Material] CHECK CONSTRAINT [FK_Material_CalorieClass]
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
ALTER TABLE [SAP].[Material]  WITH CHECK ADD  CONSTRAINT [FK_Material_InternalCategory] FOREIGN KEY([InternalCategoryID])
REFERENCES [SAP].[InternalCategory] ([InternalCategoryID])
GO
ALTER TABLE [SAP].[Material] CHECK CONSTRAINT [FK_Material_InternalCategory]
GO
ALTER TABLE [SAP].[Material]  WITH CHECK ADD  CONSTRAINT [FK_Material_Package] FOREIGN KEY([PackageID])
REFERENCES [SAP].[Package] ([PackageID])
GO
ALTER TABLE [SAP].[Material] CHECK CONSTRAINT [FK_Material_Package]
GO
ALTER TABLE [SAP].[Package]  WITH CHECK ADD  CONSTRAINT [FK_Package_PackageConf] FOREIGN KEY([PackageConfID])
REFERENCES [SAP].[PackageConf] ([PackageConfID])
GO
ALTER TABLE [SAP].[Package] CHECK CONSTRAINT [FK_Package_PackageConf]
GO
ALTER TABLE [SAP].[Package]  WITH CHECK ADD  CONSTRAINT [FK_Package_PackageType] FOREIGN KEY([PackageTypeID])
REFERENCES [SAP].[PackageType] ([PackageTypeID])
GO
ALTER TABLE [SAP].[Package] CHECK CONSTRAINT [FK_Package_PackageType]
GO
ALTER TABLE [SAP].[ProfitCenter]  WITH CHECK ADD  CONSTRAINT [FK_ProfitCenter_Branch] FOREIGN KEY([BranchID])
REFERENCES [SAP].[Branch] ([BranchID])
GO
ALTER TABLE [SAP].[ProfitCenter] CHECK CONSTRAINT [FK_ProfitCenter_Branch]
GO
ALTER TABLE [SAP].[Region]  WITH CHECK ADD  CONSTRAINT [FK_Region_BusinessUnit] FOREIGN KEY([BUID])
REFERENCES [SAP].[BusinessUnit] ([BUID])
GO
ALTER TABLE [SAP].[Region] CHECK CONSTRAINT [FK_Region_BusinessUnit]
GO
ALTER TABLE [SAP].[RegionalChain]  WITH CHECK ADD  CONSTRAINT [FK_RegionalChain_NationalChain] FOREIGN KEY([NationalChainID])
REFERENCES [SAP].[NationalChain] ([NationalChainID])
GO
ALTER TABLE [SAP].[RegionalChain] CHECK CONSTRAINT [FK_RegionalChain_NationalChain]
GO
ALTER TABLE [SAP].[RouteSchedule]  WITH NOCHECK ADD  CONSTRAINT [FK_RouteSchedule_Account] FOREIGN KEY([AccountID])
REFERENCES [SAP].[Account] ([AccountID])
NOT FOR REPLICATION 
GO
ALTER TABLE [SAP].[RouteSchedule] NOCHECK CONSTRAINT [FK_RouteSchedule_Account]
GO
ALTER TABLE [SAP].[RouteSchedule]  WITH CHECK ADD  CONSTRAINT [FK_RouteSchedule_SalesRoute] FOREIGN KEY([RouteID])
REFERENCES [SAP].[SalesRoute] ([RouteID])
GO
ALTER TABLE [SAP].[RouteSchedule] CHECK CONSTRAINT [FK_RouteSchedule_SalesRoute]
GO
ALTER TABLE [SAP].[RouteScheduleDetail]  WITH CHECK ADD  CONSTRAINT [FK_RouteScheduleDetail_RouteSchedule] FOREIGN KEY([RouteScheduleID])
REFERENCES [SAP].[RouteSchedule] ([RouteScheduleID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [SAP].[RouteScheduleDetail] CHECK CONSTRAINT [FK_RouteScheduleDetail_RouteSchedule]
GO
ALTER TABLE [SAP].[SalesArea]  WITH CHECK ADD  CONSTRAINT [FK_SalesArea_Region] FOREIGN KEY([RegionID])
REFERENCES [SAP].[Region] ([RegionID])
GO
ALTER TABLE [SAP].[SalesArea] CHECK CONSTRAINT [FK_SalesArea_Region]
GO
ALTER TABLE [SAP].[SalesRoute]  WITH CHECK ADD  CONSTRAINT [FK_SalesRoute_Branch] FOREIGN KEY([BranchID])
REFERENCES [SAP].[Branch] ([BranchID])
GO
ALTER TABLE [SAP].[SalesRoute] CHECK CONSTRAINT [FK_SalesRoute_Branch]
GO
ALTER TABLE [MSTR].[SurveyResultsStaging]  WITH CHECK ADD  CONSTRAINT [CK_SurveyResultsStaging] CHECK  (([DQ1]=(0) OR [DQ1]=(1)))
GO
ALTER TABLE [MSTR].[SurveyResultsStaging] CHECK CONSTRAINT [CK_SurveyResultsStaging]
GO
ALTER TABLE [Person].[UPSSyncConfig]  WITH CHECK ADD  CONSTRAINT [CK_Vendor_UPSSybnConfig] CHECK  (([SyncDirection]='Down' OR [SyncDirection]='Up'))
GO
ALTER TABLE [Person].[UPSSyncConfig] CHECK CONSTRAINT [CK_Vendor_UPSSybnConfig]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Brand Information from SAP' , @level0type=N'SCHEMA',@level0name=N'SAP', @level1type=N'TABLE',@level1name=N'Brand'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Promotion Channel Information from SAP' , @level0type=N'SCHEMA',@level0name=N'SAP', @level1type=N'TABLE',@level1name=N'Channel'
GO
