Use Portal_Data_INT
Go

----------------------------------
Alter Table [BCMyday].[StoreConditionDisplayDetail]
Add StoreConditionDisplayDetailID int identity(1,1) primary key
Go

----------------------------------
ALTER TABLE [BCMyday].[StoreConditionDisplayDetail]  WITH CHECK ADD CONSTRAINT [FK_StoreConditionDisplayDetail_StoreConditionDisplay] FOREIGN KEY([StoreConditionDisplayID])
REFERENCES [BCMyday].[StoreConditionDisplay] ([StoreConditionDisplayID])
ON DELETE CASCADE
GO

ALTER TABLE [BCMyday].[StoreConditionDisplayDetail] CHECK CONSTRAINT [FK_StoreConditionDisplayDetail_StoreConditionDisplay]
GO

----------------------------------
ALTER TABLE [BCMyday].[StoreConditionDisplay]  WITH CHECK ADD CONSTRAINT [FK_StoreConditionDisplay_StoreCondition] FOREIGN KEY([StoreConditionID])
REFERENCES [BCMyday].[StoreCondition] ([StoreConditionID])
ON DELETE CASCADE
GO

ALTER TABLE [BCMyday].[StoreConditionDisplay] CHECK CONSTRAINT [FK_StoreConditionDisplay_StoreCondition]
GO

Alter Table [BCMyday].[StoreConditionDisplay]
Alter Column StoreConditionID int not null
Go

----------------------------------
ALTER TABLE [BCMyday].[StoreTieInRate]  WITH CHECK ADD CONSTRAINT [FK_StoreTieInRate_StoreCondition] FOREIGN KEY([StoreConditionID])
REFERENCES [BCMyday].[StoreCondition] ([StoreConditionID])
ON DELETE CASCADE
GO

ALTER TABLE [BCMyday].[StoreTieInRate] CHECK CONSTRAINT [FK_StoreTieInRate_StoreCondition]
GO

----------------------------------

Alter Table BCMyDay.StoreConditionDisplay
Add ImageSharePointID varchar(50) not null default ''
Go
----------------------------------

CREATE TABLE [BC].[tRegionChainTradeMark](
	[TerritoryTypeID] [int] NOT NULL,
	[ProductTypeID] [int] NOT NULL,
	[RegionID] [int] NOT NULL,
	[TradeMarkID] [int] NOT NULL,
	[LocalChainID] [int] NOT NULL,
	[RegionalChainID] [int] NOT NULL,
	[NationalChainID] [int] NOT NULL,
	[LastModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_tRegionChainTradeMark] PRIMARY KEY CLUSTERED 
(
	[TerritoryTypeID] ASC,
	[ProductTypeID] ASC,
	[RegionID] ASC,
	[TradeMarkID] ASC,
	[LocalChainID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
----------------------------------

/****** Object:  Table [BCMyday].[ManagementPriority]    Script Date: 3/30/2015 9:18:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BCMyday].[ManagementPriority](
	[ManagementPriorityID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](200) NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NOT NULL,
	[ForAllChains] [bit] NOT NULL CONSTRAINT [DF_ManagementPriority_ForAllChains]  DEFAULT ((1)),
	[ForAllBrands] [bit] NOT NULL CONSTRAINT [DF_ManagementPriority_ForAllBrands]  DEFAULT ((1)),
	[ForAllPackages] [bit] NOT NULL CONSTRAINT [DF_ManagementPriority_ForAllPackages]  DEFAULT ((1)),
	[ForAllBottlers] [bit] NOT NULL CONSTRAINT [DF_ManagementPriority_ForAllBottlers]  DEFAULT ((1)),
	[CreatedBy] [varchar](50) NOT NULL CONSTRAINT [DF_ManagementPriority_CreatedBy]  DEFAULT ('System'),
	[Created] [datetime2](7) NOT NULL CONSTRAINT [DF_ManagementPriority_Created]  DEFAULT (sysdatetime()),
	[LastModifiedBy] [varchar](50) NOT NULL CONSTRAINT [DF_ManagementPriority_LastModifiedBy]  DEFAULT ('System'),
	[LastModified] [datetime2](7) NOT NULL CONSTRAINT [DF_ManagementPriority_LastModified]  DEFAULT (sysdatetime()),
	[PublishingStatus] [int] NOT NULL,
	[Active]  AS (CONVERT([bit],case when [PublishingStatus]=(2) then (1) else (0) end)),
	[TypeID] [int] NOT NULL,
	[Attachment] [varchar](200) NULL,
	[PriorityNote] [varchar](200) NULL DEFAULT (''),
 CONSTRAINT [PK_ManagementPriority] PRIMARY KEY CLUSTERED 
(
	[ManagementPriorityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BCMyday].[PriorityBottler]    Script Date: 3/30/2015 9:18:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BCMyday].[PriorityBottler](
	[PriorityBottlerID] [int] IDENTITY(1,1) NOT NULL,
	[ManagementPriorityID] [int] NOT NULL,
	[BottlerID] [int] NULL,
	[RegionID] [int] NULL,
	[DivisionID] [int] NULL,
	[ZoneID] [int] NULL,
	[SystemID] [int] NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[LastModifiedBy] [varchar](50) NOT NULL,
	[LastModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_PriorityBottler] PRIMARY KEY CLUSTERED 
(
	[PriorityBottlerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BCMyday].[PriorityBrand]    Script Date: 3/30/2015 9:18:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BCMyday].[PriorityBrand](
	[PriorityBrandID] [int] IDENTITY(1,1) NOT NULL,
	[ManagementPriorityID] [int] NOT NULL,
	[TradeMarkID] [int] NULL,
	[BrandID] [int] NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[LastModifiedBy] [varchar](50) NOT NULL,
	[LastModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_PriorityBrand] PRIMARY KEY CLUSTERED 
(
	[PriorityBrandID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BCMyday].[PriorityChain]    Script Date: 3/30/2015 9:18:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BCMyday].[PriorityChain](
	[PriorityChainID] [int] IDENTITY(1,1) NOT NULL,
	[ManagementPriorityID] [int] NOT NULL,
	[NationalChainID] [int] NULL,
	[RegionalChainID] [int] NULL,
	[LocalChainID] [int] NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[LastModifiedBy] [varchar](50) NOT NULL,
	[LastModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_PriorityChain] PRIMARY KEY CLUSTERED 
(
	[PriorityChainID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BCMyday].[PriorityExecutionStatus]    Script Date: 3/30/2015 9:18:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BCMyday].[PriorityExecutionStatus](
	[PriorityExecutionStatusID] [int] NOT NULL,
	[Description] [varchar](50) NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_PriorityExecutionStatus] PRIMARY KEY CLUSTERED 
(
	[PriorityExecutionStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BCMyday].[PriorityPackage]    Script Date: 3/30/2015 9:18:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BCMyday].[PriorityPackage](
	[PriorityPackageID] [int] IDENTITY(1,1) NOT NULL,
	[ManagementPriorityID] [int] NOT NULL,
	[PackageID] [int] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[LastModifiedBy] [varchar](50) NOT NULL,
	[LastModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_PriorityPackage] PRIMARY KEY CLUSTERED 
(
	[PriorityPackageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BCMyday].[PriorityPublishingStatus]    Script Date: 3/30/2015 9:18:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BCMyday].[PriorityPublishingStatus](
	[PublishingStatusID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](50) NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_PriorityPublishingStatus] PRIMARY KEY CLUSTERED 
(
	[PublishingStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BCMyday].[PriorityStoreConditionExecution]    Script Date: 3/30/2015 9:18:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BCMyday].[PriorityStoreConditionExecution](
	[PriorityExecutionID] [int] IDENTITY(1,1) NOT NULL,
	[StoreConditionID] [int] NOT NULL,
	[ManagementPriorityID] [int] NOT NULL,
	[PriorityExecutionStatusID] [int] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[LastModifiedBy] [varchar](50) NOT NULL,
	[LastModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_PriorityStoreConditionExecution] PRIMARY KEY CLUSTERED 
(
	[PriorityExecutionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BCMyday].[PromotionExecution]    Script Date: 3/30/2015 9:18:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BCMyday].[PromotionExecution](
	[ExecutionID] [int] IDENTITY(1,1) NOT NULL,
	[PromotionID] [int] NOT NULL,
	[StoreConditionID] [int] NOT NULL,
	[PromotionExecutionStatusID] [int] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL CONSTRAINT [DF_PromotionExecution_CreatedBy]  DEFAULT ('System'),
	[Created] [datetime2](7) NOT NULL CONSTRAINT [DF_PromotionExecution_Created]  DEFAULT (sysdatetime()),
	[LastModifiedBy] [varchar](50) NOT NULL CONSTRAINT [DF_PromotionExecution_LastModifiedBy]  DEFAULT ('System'),
	[LastModified] [datetime2](7) NOT NULL,
	[StoreConditionDisplayID] [int] NULL,
 CONSTRAINT [PK_PromotionExecution] PRIMARY KEY CLUSTERED 
(
	[ExecutionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BCMyday].[PromotionExecutionStatus]    Script Date: 3/30/2015 9:18:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BCMyday].[PromotionExecutionStatus](
	[PromotionExectuionStatusID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](50) NOT NULL,
	[Active] [bit] NOT NULL,
	[LastModified] [datetime2](7) NOT NULL CONSTRAINT [DF_PromotionExecutionStatus_LastModified]  DEFAULT (getdate()),
 CONSTRAINT [PK_PromotionExecutionStatus] PRIMARY KEY CLUSTERED 
(
	[PromotionExectuionStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BCMyday].[StoreConditionNote]    Script Date: 3/30/2015 9:18:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BCMyday].[StoreConditionNote](
	[NoteID] [int] IDENTITY(1,1) NOT NULL,
	[StoreConditionID] [int] NOT NULL,
	[Note] [varchar](250) NOT NULL,
	[ImageSharePointID] [varchar](50) NOT NULL CONSTRAINT [DF_StoreConditionNote_ImageSharePointID]  DEFAULT (''),
	[ImageURL] [varchar](200) NOT NULL CONSTRAINT [DF_StoreConditionNote_ImageURL]  DEFAULT (''),
	[ImageName] [varchar](200) NOT NULL CONSTRAINT [DF_StoreConditionNote_ImageName]  DEFAULT (''),
	[CreatedBy] [varchar](50) NOT NULL CONSTRAINT [DF_StoreConditionNote_CreatedBy]  DEFAULT ('System'),
	[Created] [datetime2](7) NOT NULL CONSTRAINT [DF_StoreConditionNote_Created]  DEFAULT (sysdatetime()),
	[LastModifiedBy] [varchar](50) NOT NULL CONSTRAINT [DF_StoreConditionNote_LastModifiedBy]  DEFAULT ('System'),
	[LastModified] [datetime2](7) NOT NULL CONSTRAINT [DF_StoreConditionNote_LastModified]  DEFAULT (sysdatetime()),
 CONSTRAINT [PK_StoreConditionNote] PRIMARY KEY CLUSTERED 
(
	[NoteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BCMyday].[SystemCompetitionBrand]    Script Date: 3/30/2015 9:18:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BCMyday].[SystemCompetitionBrand](
	[SystemCompetionBrandID] [int] IDENTITY(1,1) NOT NULL,
	[SystemID] [int] NOT NULL,
	[SystemBrandID] [int] NOT NULL,
	[SystemTradeMarkID] [int] NULL,
	[TradeMarkID] [int] NULL,
	[Active] [bit] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[LastModifiedBy] [varchar](50) NOT NULL,
	[LastModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_SystemCompetitionBrand] PRIMARY KEY CLUSTERED 
(
	[SystemCompetionBrandID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BCMyday].[TieInFairShareStatus]    Script Date: 3/30/2015 9:18:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BCMyday].[TieInFairShareStatus](
	[TieInFairShareStatusID] [int] NOT NULL,
	[Description] [varchar](50) NULL,
	[Active] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[TieInFairShareStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [BCMyday].[ManagementPriority]  WITH CHECK ADD  CONSTRAINT [FK_ManagementPriority_PriorityPublishingStatus] FOREIGN KEY([PublishingStatus])
REFERENCES [BCMyday].[PriorityPublishingStatus] ([PublishingStatusID])
GO
ALTER TABLE [BCMyday].[ManagementPriority] CHECK CONSTRAINT [FK_ManagementPriority_PriorityPublishingStatus]
GO
ALTER TABLE [BCMyday].[PriorityBottler]  WITH CHECK ADD  CONSTRAINT [FK_PriorityBottler_Bottler] FOREIGN KEY([BottlerID])
REFERENCES [BC].[Bottler] ([BottlerID])
GO
ALTER TABLE [BCMyday].[PriorityBottler] CHECK CONSTRAINT [FK_PriorityBottler_Bottler]
GO
ALTER TABLE [BCMyday].[PriorityBottler]  WITH CHECK ADD  CONSTRAINT [FK_PriorityBottler_Division] FOREIGN KEY([DivisionID])
REFERENCES [BC].[Division] ([DivisionID])
GO
ALTER TABLE [BCMyday].[PriorityBottler] CHECK CONSTRAINT [FK_PriorityBottler_Division]
GO
ALTER TABLE [BCMyday].[PriorityBottler]  WITH CHECK ADD  CONSTRAINT [FK_PriorityBottler_ManagementPriority] FOREIGN KEY([ManagementPriorityID])
REFERENCES [BCMyday].[ManagementPriority] ([ManagementPriorityID])
ON DELETE CASCADE
GO
ALTER TABLE [BCMyday].[PriorityBottler] CHECK CONSTRAINT [FK_PriorityBottler_ManagementPriority]
GO
ALTER TABLE [BCMyday].[PriorityBottler]  WITH CHECK ADD  CONSTRAINT [FK_PriorityBottler_Region] FOREIGN KEY([RegionID])
REFERENCES [BC].[Region] ([RegionID])
GO
ALTER TABLE [BCMyday].[PriorityBottler] CHECK CONSTRAINT [FK_PriorityBottler_Region]
GO
ALTER TABLE [BCMyday].[PriorityBottler]  WITH CHECK ADD  CONSTRAINT [FK_PriorityBottler_System] FOREIGN KEY([SystemID])
REFERENCES [BC].[System] ([SystemID])
GO
ALTER TABLE [BCMyday].[PriorityBottler] CHECK CONSTRAINT [FK_PriorityBottler_System]
GO
ALTER TABLE [BCMyday].[PriorityBottler]  WITH CHECK ADD  CONSTRAINT [FK_PriorityBottler_Zone] FOREIGN KEY([ZoneID])
REFERENCES [BC].[Zone] ([ZoneID])
GO
ALTER TABLE [BCMyday].[PriorityBottler] CHECK CONSTRAINT [FK_PriorityBottler_Zone]
GO
ALTER TABLE [BCMyday].[PriorityBrand]  WITH CHECK ADD  CONSTRAINT [FK_PriorityBrand_Brand] FOREIGN KEY([BrandID])
REFERENCES [SAP].[Brand] ([BrandID])
GO
ALTER TABLE [BCMyday].[PriorityBrand] CHECK CONSTRAINT [FK_PriorityBrand_Brand]
GO
ALTER TABLE [BCMyday].[PriorityBrand]  WITH CHECK ADD  CONSTRAINT [FK_PriorityBrand_ManagementPriority] FOREIGN KEY([ManagementPriorityID])
REFERENCES [BCMyday].[ManagementPriority] ([ManagementPriorityID])
ON DELETE CASCADE
GO
ALTER TABLE [BCMyday].[PriorityBrand] CHECK CONSTRAINT [FK_PriorityBrand_ManagementPriority]
GO
ALTER TABLE [BCMyday].[PriorityBrand]  WITH CHECK ADD  CONSTRAINT [FK_PriorityBrand_TradeMark] FOREIGN KEY([TradeMarkID])
REFERENCES [SAP].[TradeMark] ([TradeMarkID])
GO
ALTER TABLE [BCMyday].[PriorityBrand] CHECK CONSTRAINT [FK_PriorityBrand_TradeMark]
GO
ALTER TABLE [BCMyday].[PriorityChain]  WITH CHECK ADD  CONSTRAINT [FK_PriorityChain_LocalChain] FOREIGN KEY([LocalChainID])
REFERENCES [SAP].[LocalChain] ([LocalChainID])
GO
ALTER TABLE [BCMyday].[PriorityChain] CHECK CONSTRAINT [FK_PriorityChain_LocalChain]
GO
ALTER TABLE [BCMyday].[PriorityChain]  WITH CHECK ADD  CONSTRAINT [FK_PriorityChain_ManagementPriority] FOREIGN KEY([ManagementPriorityID])
REFERENCES [BCMyday].[ManagementPriority] ([ManagementPriorityID])
ON DELETE CASCADE
GO
ALTER TABLE [BCMyday].[PriorityChain] CHECK CONSTRAINT [FK_PriorityChain_ManagementPriority]
GO
ALTER TABLE [BCMyday].[PriorityChain]  WITH CHECK ADD  CONSTRAINT [FK_PriorityChain_NationalChain] FOREIGN KEY([NationalChainID])
REFERENCES [SAP].[NationalChain] ([NationalChainID])
GO
ALTER TABLE [BCMyday].[PriorityChain] CHECK CONSTRAINT [FK_PriorityChain_NationalChain]
GO
ALTER TABLE [BCMyday].[PriorityChain]  WITH CHECK ADD  CONSTRAINT [FK_PriorityChain_RegionalChain] FOREIGN KEY([RegionalChainID])
REFERENCES [SAP].[RegionalChain] ([RegionalChainID])
GO
ALTER TABLE [BCMyday].[PriorityChain] CHECK CONSTRAINT [FK_PriorityChain_RegionalChain]
GO
ALTER TABLE [BCMyday].[PriorityPackage]  WITH CHECK ADD  CONSTRAINT [FK_PriorityPackage_ManagementPriority] FOREIGN KEY([ManagementPriorityID])
REFERENCES [BCMyday].[ManagementPriority] ([ManagementPriorityID])
ON DELETE CASCADE
GO
ALTER TABLE [BCMyday].[PriorityPackage] CHECK CONSTRAINT [FK_PriorityPackage_ManagementPriority]
GO
ALTER TABLE [BCMyday].[PriorityPackage]  WITH CHECK ADD  CONSTRAINT [FK_PriorityPackage_Package] FOREIGN KEY([PackageID])
REFERENCES [SAP].[Package] ([PackageID])
GO
ALTER TABLE [BCMyday].[PriorityPackage] CHECK CONSTRAINT [FK_PriorityPackage_Package]
GO
ALTER TABLE [BCMyday].[PriorityStoreConditionExecution]  WITH CHECK ADD  CONSTRAINT [FK_PriorityStoreConditionExecution_ManagementPriority] FOREIGN KEY([ManagementPriorityID])
REFERENCES [BCMyday].[ManagementPriority] ([ManagementPriorityID])
ON DELETE CASCADE
GO
ALTER TABLE [BCMyday].[PriorityStoreConditionExecution] CHECK CONSTRAINT [FK_PriorityStoreConditionExecution_ManagementPriority]
GO
ALTER TABLE [BCMyday].[PriorityStoreConditionExecution]  WITH CHECK ADD  CONSTRAINT [FK_PriorityStoreConditionExecution_PriorityExecutionStatus] FOREIGN KEY([PriorityExecutionStatusID])
REFERENCES [BCMyday].[PriorityExecutionStatus] ([PriorityExecutionStatusID])
GO
ALTER TABLE [BCMyday].[PriorityStoreConditionExecution] CHECK CONSTRAINT [FK_PriorityStoreConditionExecution_PriorityExecutionStatus]
GO
ALTER TABLE [BCMyday].[PriorityStoreConditionExecution]  WITH CHECK ADD  CONSTRAINT [FK_PriorityStoreConditionExecution_StoreCondition] FOREIGN KEY([StoreConditionID])
REFERENCES [BCMyday].[StoreCondition] ([StoreConditionID])
ON DELETE CASCADE
GO
ALTER TABLE [BCMyday].[PriorityStoreConditionExecution] CHECK CONSTRAINT [FK_PriorityStoreConditionExecution_StoreCondition]
GO
ALTER TABLE [BCMyday].[PromotionExecution]  WITH CHECK ADD  CONSTRAINT [FK_PromotionExecution_PromotionExecutionStatus] FOREIGN KEY([PromotionExecutionStatusID])
REFERENCES [BCMyday].[PromotionExecutionStatus] ([PromotionExectuionStatusID])
GO
ALTER TABLE [BCMyday].[PromotionExecution] CHECK CONSTRAINT [FK_PromotionExecution_PromotionExecutionStatus]
GO
ALTER TABLE [BCMyday].[PromotionExecution]  WITH CHECK ADD  CONSTRAINT [FK_PromotionExecution_RetailPromotion] FOREIGN KEY([PromotionID])
REFERENCES [Playbook].[RetailPromotion] ([PromotionID])
GO
ALTER TABLE [BCMyday].[PromotionExecution] CHECK CONSTRAINT [FK_PromotionExecution_RetailPromotion]
GO
ALTER TABLE [BCMyday].[PromotionExecution]  WITH CHECK ADD  CONSTRAINT [FK_PromotionExecution_StoreCondition] FOREIGN KEY([StoreConditionID])
REFERENCES [BCMyday].[StoreCondition] ([StoreConditionID])
ON DELETE CASCADE
GO
ALTER TABLE [BCMyday].[PromotionExecution] CHECK CONSTRAINT [FK_PromotionExecution_StoreCondition]
GO
ALTER TABLE [BCMyday].[StoreConditionNote]  WITH CHECK ADD  CONSTRAINT [FK_StoreConditionNote_StoreCondition] FOREIGN KEY([StoreConditionID])
REFERENCES [BCMyday].[StoreCondition] ([StoreConditionID])
ON DELETE CASCADE
GO
ALTER TABLE [BCMyday].[StoreConditionNote] CHECK CONSTRAINT [FK_StoreConditionNote_StoreCondition]
GO
ALTER TABLE [BCMyday].[SystemCompetitionBrand]  WITH CHECK ADD  CONSTRAINT [FK_SystemCompetitionBrand_System] FOREIGN KEY([SystemID])
REFERENCES [BC].[System] ([SystemID])
GO
ALTER TABLE [BCMyday].[SystemCompetitionBrand] CHECK CONSTRAINT [FK_SystemCompetitionBrand_System]
GO
ALTER TABLE [BCMyday].[SystemCompetitionBrand]  WITH CHECK ADD  CONSTRAINT [FK_SystemCompetitionBrand_SystemBrand] FOREIGN KEY([SystemBrandID])
REFERENCES [BCMyday].[SystemBrand] ([SystemBrandID])
GO
ALTER TABLE [BCMyday].[SystemCompetitionBrand] CHECK CONSTRAINT [FK_SystemCompetitionBrand_SystemBrand]
GO
ALTER TABLE [BCMyday].[SystemCompetitionBrand]  WITH CHECK ADD  CONSTRAINT [FK_SystemCompetitionBrand_SystemTradeMark] FOREIGN KEY([SystemTradeMarkID])
REFERENCES [BCMyday].[SystemTradeMark] ([SystemTradeMarkID])
GO
ALTER TABLE [BCMyday].[SystemCompetitionBrand] CHECK CONSTRAINT [FK_SystemCompetitionBrand_SystemTradeMark]
GO

---------------------------
Insert BCMyDay.TieInFairShareStatus
Values(0, 'Not Answered', 1)

Insert BCMyDay.TieInFairShareStatus
Values(1, 'Fair', 1)

Insert BCMyDay.TieInFairShareStatus
Values(2, 'Not Fair', 1)
Go

Alter Table [BCMyday].[StoreConditionDisplay]
Add TieInFairShareStatusID Int Null 
Go

Update [BCMyday].[StoreConditionDisplay]
Set TieInFairShareStatusID = 0
Go

Alter Table [BCMyday].[StoreConditionDisplay]
Alter Column TieInFairShareStatusID Int Not Null
Go

ALTER TABLE [BCMyday].[StoreConditionDisplay]  WITH CHECK ADD  CONSTRAINT [FK_StoreConditionDisplay_TieInFairShareStatus] FOREIGN KEY(TieInFairShareStatusID)
REFERENCES BCMyDay.TieInFairShareStatus (TieInFairShareStatusID)
ON DELETE CASCADE
GO

ALTER TABLE [BCMyday].[StoreConditionDisplay] CHECK CONSTRAINT [FK_StoreConditionDisplay_TieInFairShareStatus]
GO
