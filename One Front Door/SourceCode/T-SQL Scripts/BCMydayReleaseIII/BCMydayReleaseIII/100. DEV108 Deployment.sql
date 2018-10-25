USE [Portal_Data]
GO

/****** Object:  Table [BCMyday].[ManagementPriority]    Script Date: 3/10/2015 11:57:52 AM ******/
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
	[TypeID] [int] NULL,
	[Attachment] [varchar](200) NULL,
 CONSTRAINT [PK_ManagementPriority] PRIMARY KEY CLUSTERED 
(
	[ManagementPriorityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BCMyday].[PriorityBottler]    Script Date: 3/10/2015 11:57:52 AM ******/
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
/****** Object:  Table [BCMyday].[PriorityBrand]    Script Date: 3/10/2015 11:57:52 AM ******/
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
/****** Object:  Table [BCMyday].[PriorityChain]    Script Date: 3/10/2015 11:57:52 AM ******/
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
/****** Object:  Table [BCMyday].[PriorityExecutionStatus]    Script Date: 3/10/2015 11:57:52 AM ******/
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
/****** Object:  Table [BCMyday].[PriorityPackage]    Script Date: 3/10/2015 11:57:52 AM ******/
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
/****** Object:  Table [BCMyday].[PriorityPublishingStatus]    Script Date: 3/10/2015 11:57:52 AM ******/
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
/****** Object:  Table [BCMyday].[PriorityStoreConditionExecution]    Script Date: 3/10/2015 11:57:52 AM ******/
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
/****** Object:  Table [BCMyday].[PromotionExecution]    Script Date: 3/10/2015 11:57:52 AM ******/
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
	[DisplayLocationID] [int] NULL,
	[PromotionExecutionStatusID] [int] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL CONSTRAINT [DF_PromotionExecution_CreatedBy]  DEFAULT ('System'),
	[Created] [datetime2](7) NOT NULL CONSTRAINT [DF_PromotionExecution_Created]  DEFAULT (sysdatetime()),
	[LastModifiedBy] [varchar](50) NOT NULL CONSTRAINT [DF_PromotionExecution_LastModifiedBy]  DEFAULT ('System'),
	[LastModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_PromotionExecution] PRIMARY KEY CLUSTERED 
(
	[ExecutionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BCMyday].[PromotionExecutionStatus]    Script Date: 3/10/2015 11:57:52 AM ******/
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
/****** Object:  Table [BCMyday].[StoreConditionNote]    Script Date: 3/10/2015 11:57:52 AM ******/
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
INSERT [BCMyday].[PriorityExecutionStatus] ([PriorityExecutionStatusID], [Description], [Active]) VALUES (-1, N'Not Specified', 1)
GO
INSERT [BCMyday].[PriorityExecutionStatus] ([PriorityExecutionStatusID], [Description], [Active]) VALUES (0, N'Not Executed', 1)
GO
INSERT [BCMyday].[PriorityExecutionStatus] ([PriorityExecutionStatusID], [Description], [Active]) VALUES (1, N'Executed', 1)
GO
SET IDENTITY_INSERT [BCMyday].[PriorityPublishingStatus] ON 

GO
INSERT [BCMyday].[PriorityPublishingStatus] ([PublishingStatusID], [Description], [Active]) VALUES (1, N'Draft', 1)
GO
INSERT [BCMyday].[PriorityPublishingStatus] ([PublishingStatusID], [Description], [Active]) VALUES (2, N'Sent to MyDay', 1)
GO
INSERT [BCMyday].[PriorityPublishingStatus] ([PublishingStatusID], [Description], [Active]) VALUES (3, N'Recalled from MyDay', 1)
GO
INSERT [BCMyday].[PriorityPublishingStatus] ([PublishingStatusID], [Description], [Active]) VALUES (5, N'Deleted', 1)
GO
SET IDENTITY_INSERT [BCMyday].[PriorityPublishingStatus] OFF
GO

SET IDENTITY_INSERT [BCMyday].[PromotionExecutionStatus] ON 

GO
INSERT [BCMyday].[PromotionExecutionStatus] ([PromotionExectuionStatusID], [Description], [Active], [LastModified]) VALUES (1, N'Executed', 1, CAST(N'2015-03-02 10:10:44.7000000' AS DateTime2))
GO
INSERT [BCMyday].[PromotionExecutionStatus] ([PromotionExectuionStatusID], [Description], [Active], [LastModified]) VALUES (2, N'Not Executed', 1, CAST(N'2015-03-02 10:10:44.7000000' AS DateTime2))
GO
SET IDENTITY_INSERT [BCMyday].[PromotionExecutionStatus] OFF
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
----
ALTER TABLE [BCMyday].[PromotionExecution]  WITH CHECK ADD  CONSTRAINT [FK_PromotionExecution_DisplayLocation] FOREIGN KEY([DisplayLocationID])
REFERENCES [Playbook].[DisplayLocation] ([DisplayLocationID])
GO
ALTER TABLE [BCMyday].[PromotionExecution] CHECK CONSTRAINT [FK_PromotionExecution_DisplayLocation]
GO
--
ALTER TABLE [BCMyday].[PromotionExecution]  WITH CHECK ADD  CONSTRAINT [FK_PromotionExecution_PromotionExecutionStatus] FOREIGN KEY([PromotionExecutionStatusID])
REFERENCES [BCMyday].[PromotionExecutionStatus] ([PromotionExectuionStatusID])
GO
ALTER TABLE [BCMyday].[PromotionExecution] CHECK CONSTRAINT [FK_PromotionExecution_PromotionExecutionStatus]
GO
--
select *
from [BCMyday].[PromotionExecution] 

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
/****** Object:  View [BCMyday].[vSystemCompetition]    Script Date: 3/10/2015 11:58:47 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create View [BCMyday].[vSystemCompetition]
As
Select s.BCNodeID, s.SystemName, b.ExternalBrandName, t.ExternalTradeMarkName, m.TradeMarkID, m.TradeMarkName
From BCMyday.SystemCompetitionBrand c
Join BC.System s on c.SystemID = s.SystemID
Join BCMyday.SystemBrand b on c.SystemBrandID = b.SystemBrandID
Join BCMyday.SystemTradeMark t on b.SystemTradeMarkID = t.SystemTradeMarkID
Left Join SAP.TradeMark m on c.TradeMarkID = m.TradeMarkID

GO

/****** Object:  StoredProcedure [BCMyday].[pGetLOSMaster]    Script Date: 2/27/2015 4:01:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Testing 
exec BCMyday.pGetLOSMaster @lastmodified = '2015-01-01'
exec BCMyday.pGetLOSMaster @lastmodified='2015-02-01 00:00:00'
exec BCMyday.pGetLOSMaster @lastmodified='2016-02-01 00:00:00'

*/

-- BCMyday.pGetLOSMaster ''                      
ALTER Procedure [BCMyday].[pGetLOSMaster]                      
(                      
  @lastmodified Date = null                    
)                      
As                      
Begin                      
                      
 If ISNULL(@lastmodified, '') = ''                        
	Begin                       
		SELECT  LOSID,      
				ChannelID,      
				LOSImageID,      
				ModifiedDate,      
				ImageURL,  
				IsActive ,      
				case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted,
				localchainid
			  --  IsDeleted          
		FROM BCMyday.LOS  LOS  
		INNER JOIN Shared.Image IMG  
		ON LOS.LOSImageID=IMG.ImageID  
		WHERE IsActive=1    
   
		SELECT LOSID,      
			   DisplayLocationID,      
			   DisplaySequence,          
			   GridX,      
			   GridY,      
			   ModifiedDate,      
			case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted           ,
				IsActive 
		FROM BCMyday.LOSDisplayLocation                      
		WHERE IsActive=1                     
                      
		SELECT TieReasonId,      
			   Description,                  
			   ModifiedDate,      
			   IsActive ,      
		  case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted             
		FROM BCMyday.TieInReason  
		WHERE IsActive=1                  
                      
		SELECT DisplayTypeId,      
			   Description,      
			   ModifiedDate,      
			  IsActive ,      
		  case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted           
			   FROM              
		BCMyday.DISPLAYTYPEMASTER  
		WHERE IsActive=1                     
                      
  
		SELECT a.SystemBrandID,      
		  case when isnull(a.ExternalBrandName,'') <> '' then a.ExternalBrandName else b.BrandName end ExternalBrandName,      
			   a.BrandID,      
			   a.TieInType,      
			   a.BrandLevelSort,          
			   a.ModifiedDate,  
			   IMG.ImageURL,      
			  a.IsActive ,  
			  a.SystemTradeMarkID    ,
		  case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted                         
		FROM BCMyday.SystemBrand a    
		left JOIN Shared.Image IMG  
		ON A.ImageID=IMG.ImageID  
		left join sap.brand b on a.brandid=b.brandid    
		WHERE IsActive=1          
                      
		SELECT SystemPackageID,      
		 ContainerType + '|' + Isnull(Conf.SAPPackageConfID,'') ContainerType,      
		 PackageConfigID,      
		 BCSystemID,          
		 PackageLevelSort,      
		 ModifiedDate,      
		 IsActive ,      
		 case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted,    
		 Isnull(Conf.SAPPackageConfID,'') SAPPackageConfID,    
		 PackageName    
		FROM   BCMyday.SystemPackage     
		Left Join SAP.PackageConf Conf on Conf.PackageConfID = BCMyday.SystemPackage.PackageConfigID    
		WHERE IsActive=1                      
                      
		SELECT SystemPackageID SystemPackageID,      
			   SystemBrandId SystemBrandID,      
			  IsActive ,      
		  case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted           
		FROM BCMyday.SystemPackageBrand  
		 WHERE IsActive=1          
        
		SELECT ConfigID,      
			   [Key],      
			   Value,      
			   Description,      
			   ModifiedDate         
		FROM BCMyday.Config                  
		where SendToMyday = 1                  
	End                      
                      
ELSE                      
	Begin                      
                      
		SELECT  LOSID,      
				ChannelID,      
				LOSImageID,      
				ModifiedDate,      
				ImageURL,  
				IsActive ,      
				localchainid,
				case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted           
			  into  #LOS        
		FROM BCMyday.LOS  LOS  
		INNER JOIN Shared.Image IMG  
		ON LOS.LOSImageID=IMG.ImageID  
		WHERE ModifiedDate>=@lastmodified
    
		select * from #LOS    
                     
		SELECT LOSID,      
			   DisplayLocationID,      
			   DisplaySequence,      
			   GridX,      
			   GridY,      
			   ModifiedDate,      
		  IsActive ,      
		  case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted           
		FROM BCMyday.LOSDisplayLocation                      
		WHERE   losid in (select losid from #LOS)    
                      
		SELECT TieReasonId,      
			   Description,      
			   ModifiedDate,      
			  IsActive ,      
		  case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted           
		FROM BCMyday.TieInReason                      
		WHERE ModifiedDate >= @lastmodified         
		--AND IsActive=1                                           
                      
		SELECT DisplayTypeId,      
			   Description,      
			   ModifiedDate,      
			 IsActive ,      
		  case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted           
		FROM BCMyday.DISPLAYTYPEMASTER                       
		WHERE ModifiedDate >= @lastmodified       
		--AND IsActive=1                                            
                      
		SELECT a.SystemBrandID,      
		  case when isnull(a.ExternalBrandName,'') <> '' then a.ExternalBrandName else b.BrandName end ExternalBrandName,      
			   a.BrandID,      
			   a.TieInType,      
			   a.BrandLevelSort,          
			   a.ModifiedDate,  
			   IMG.ImageURL,      
			  a.IsActive ,  
			  SystemTradeMarkID    ,
		  case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted                         
		FROM BCMyday.SystemBrand a    
		LEFT JOIN Shared.Image IMG  
		ON A.ImageID=IMG.ImageID  
		left join sap.brand b on a.brandid=b.brandid    
		WHERE      
		-- IsActive=1 AND          
		ModifiedDate >= @lastmodified       
                     
                       
		SELECT SystemPackageID,      
			ContainerType + '|' + Isnull(Conf.SAPPackageConfID,'') ContainerType,      
			PackageConfigID,      
			BCSystemID,      
			PackageLevelSort,                      
			ModifiedDate,      
			IsActive ,      
		 case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted ,    
		 Isnull(Conf.SAPPackageConfID,'') SAPPackageConfID,    
		 PackageName    
		FROM BCMyday.SystemPackage     
		Left Join SAP.PackageConf Conf on Conf.PackageConfID = BCMyday.SystemPackage.PackageConfigID    
		WHERE 
		--IsActive=1                      
		--AND 
		ModifiedDate >= @lastmodified                      
                      
		SELECT SystemPackageID SystemPackageID,      
			   SystemBrandId SystemBrandID,          
			   IsActive ,      
		  case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted           
		FROM BCMyday.SystemPackageBrand        
		--WHERE IsActive=1                                          
                    
		SELECT ConfigID,      
			   [Key],      
			   Value,      
			   Description,      
			   ModifiedDate         
		FROM BCMyday.Config        
		WHERE ModifiedDate > @lastmodified         
		and SendToMyday=1                                                         
	End     
  
  
  
select DisplayLocationID,DisplayLocationName from playbook.displaylocation                   
    
SELECT SystemTradeMarkID, Case when ST.TradeMarkID is null then ST.ExternalTradeMarkName Else T.TrademarkName End ExternalTradeMarkName,    
 ST.TradeMarkID,  
 TradeMarkLevelSort,    
 IsActive,  
 CreatedBy,  
 CreatedDate,  
 ModifiedBy,  
 ModifiedDate,  
 ImageURL          
FROM BCMyday.SystemTradeMark ST   
LEFT JOIN Shared.Image IMG  
ON ST.ImageID=IMG.ImageID  
Left join sap.trademark T on ST.trademarkid = t.trademarkid    
WHERE 
IsActive = case when isnull(@lastmodified,'')='' Then 1 else IsActive End
and modifieddate >= case when isnull(@lastmodified,'')='' Then modifieddate else @lastmodified End

------ System Competition Brand, added for BC Release III ---------    
Select SystemID As NodeID , Isnull(SystemBrandID, 0) SystemBrandID, coalesce(SystemTradeMarkID, 0) As SystemDPSTrademarkID, Active
From BCMyDay.SystemCompetitionBrand
Where @lastmodified is null Or LastModified >= @lastmodified

------ BC Promotion Execution Status -------------
Select PromotionExectuionStatusID StatusID, Description StatusDesc, Active
From BCMyday.PromotionExecutionStatus
                     
End

Go

------------
/****** Object:  StoredProcedure [BCMyday].[pGetPromotionsByRegionID]    Script Date: 3/9/2015 1:44:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--26318

--BCMyDay.pGetPromotionsByRegionID 240,'2015-01-01'
--BCMyDay.pGetPromotionsByRegionID 9,'2015-01-01'
ALTER PROCEDURE [BCMyday].[pGetPromotionsByRegionID] @BCRegionID INT
	,@lastmodified DATETIME = NULL
AS
BEGIN
	select -1 PromotionID into #Promotions
	select -1 PromotionID into #ValidPromotions

	--Only approved promotion
	select 4 value into #PromotionStatus

	if isnull(@lastmodified,'') <> ''
		insert into #PromotionStatus values(3)	--Cancel promotion also required for delta


	IF (isnull(@lastmodified, '') = '')
	BEGIN
		--If there is no delta, send promotion as per dates in comfig
		DECLARE @ConfigPStartDate DATETIME
			,@ConfigPEndDate DATETIME

		SELECT @ConfigPStartDate = dateadd(day,(select convert(int,value * -1) from bcmyday.config where [key] = 'PROMOTION_DOWNLOAD_DURATION_PAST'), getdate())
		SELECT @ConfigPEndDate = dateadd(day,(select convert(int,value)  from bcmyday.config where [key] = 'PROMOTION_DOWNLOAD_DURATION_FUTURE'), getdate())
	END
	ELSE
	BEGIN
		--getting all promotion, will filter by modified date
		SET @ConfigPStartDate = '2000-01-01'
		SET @ConfigPEndDate = '9999-01-01'	
	END

	insert into #Promotions
	exec playbook.pgetbcpromotionsbyrole @StartDate= @ConfigPStartDate, @EndDate = @ConfigPEndDate, @currentuser = '', 
		@Regionid = @BCRegionID, @VIEW_DRAFT_NA = 1, @ViewNatProm =1 , @IsExport = 0, @BottlerID = '', @CurrentPersonaID = -1

	insert into #ValidPromotions
	select distinct a.promotionId
	from playbook.retailpromotion a
	left join playbook.promotiongeohier b on a.promotionid = b.promotionid
	where a.ModifiedDate >= case when isnull(@lastmodified,'') = '' then a.ModifiedDate else @lastmodified end	--For delta only modifed promotion else all
	and a.promotionstatusid in (select value from #PromotionStatus)	
	and a.promotionid in (select promotionid from #Promotions)

	if isnull(@lastmodified,'') <> ''
	begin
		--For delta , need to send all active promtoion (irrespective of delta)
		insert into #ValidPromotions
		select distinct a.promotionId
		from playbook.retailpromotion a
		left join playbook.promotiongeohier b on a.promotionid = b.promotionid
		where a.PromotionStatusID in (select value from #PromotionStatus)
		and (
			a.PromotionStartDate between Playbook.fGetSunday(getDate()) and Playbook.fGetMonday(getDate())  
			or
			a.PromotionEndDate between Playbook.fGetSunday(getDate()) and Playbook.fGetMonday(getDate())
			or
			Playbook.fGetSunday(getDate()) BETWEEN a.PromotionStartDate AND a.PromotionEndDate
			)
		and a.promotionid in (select promotionid from #Promotions)
	end


	
	SELECT distinct rp.PromotionID 'PromotionID'
		,PromotionName 'PromotionName'
		,PromotionDescription 'Comment'
		,PromotionStartDate 'InStoreStartDate'
		,PromotionEndDate 'InStoreEndDate'
		,DisplayStartDate 'DisplayStartDate'
		,DisplayEndDate 'DisplayEndDate'
		,PricingStartDate 'PricingStartDate'
		,PricingEndDate 'PricingEndDate'
		,ForecastVolume 'ForecastedVolume'
		,NationalDisplayTarget 'NationalDisplayTarget'
		,PromotionPrice 'RetailPrice'
		,BottlerCommitment 'InvoicePrice'
		,pc.promotioncategoryname 'Category'
		,case pdl.DisplayRequirement when 1 then 'Mandatory' when 2 then 'Local Sell-In' else 'No Display' end as 'DisplayRequirement'
		,DisplayLocationID 'DisplayLocationID'
		,DisplayTypeID 'DisplayTypeID'
		,PromotionType 'PromotionType'
		,pdl.PromotionDisplayLocationOther 'DisplayComments'
		,0 'DisplayRequired'
		,pr.Rank [Priority]
		,rp.promotionstatusid [PromotionStatusID]
		,rp.CreatedDate , rp.ModifiedDate
		,Case When InformationCategory = 'Promotion' Then 1 Else 0 end InformationCategory
	FROM playbook.retailpromotion rp
	INNER JOIN playbook.promotiontype pt ON rp.Promotiontypeid = pt.promotiontypeid
	INNER JOIN playbook.promotioncategory pc ON rp.promotioncategoryid = pc.promotioncategoryid
	INNER JOIN playbook.promotiondisplaylocation pdl ON rp.promotionid = pdl.promotionid
	left join [Playbook].[PromotionRank] pr on pr.promotionid = rp.PromotionID
		and 
		case when rp.PromotionEndDate < playbook.fGetMonday(getdate()) then  playbook.fGetSunday(rp.PromotionEndDate) 
			when rp.PromotionStartDate > playbook.fGetSunday(getdate()) then  playbook.fGetMonday(rp.PromotionStartDate)
			else playbook.fGetMonday(getDate())
		end = 
		case when rp.PromotionEndDate < playbook.fGetMonday(getdate()) then  pr.PromotionWeekEnd
			when rp.PromotionStartDate > playbook.fGetSunday(getdate()) then  pr.PromotionWeekStart 
			else pr.PromotionWeekStart
		end 

	WHERE rp.PromotionID IN (
			SELECT PromotionID
			FROM #ValidPromotions
			)

	SELECT PromotionID 'PromotionID'
		,a.BrandID 'BrandID'
		,case when isnull(a.TrademarkID,0) = 0 then b.trademarkid else a.TrademarkID end 'TrademarkID'
	FROM playbook.promotionbrand a
	left join sap.brand b on a.brandid = b.brandid
	WHERE promotionid IN (
			SELECT PromotionID
			FROM #ValidPromotions
			)

	SELECT PromotionID 'PromotionID',
		
		case 
			when isnull(a.RegionalChainID ,0) <> 0  then
			(select nationalchainid from sap.regionalchain where RegionalChainID = a.RegionalChainID )
			when isnull(a.LocalChainID ,0) <> 0  then
			(select c.nationalchainid from sap.localchain b
			left join sap.regionalchain c on b.regionalchainid = c.regionalchainid
			where localchainid = a.localchainid )
			else a.nationalchainid
		end 'NationalChainID'
		,
		case when isnull(a.LocalChainID ,0) <> 0  then
			(select regionalchainid from sap.localchain where localchainid = a.localchainid )
		else a.RegionalChainID
		end 'RegionalChainID'
		,LocalChainID 'LocalChainID'
	FROM playbook.promotionaccount a
	WHERE promotionid IN (
			SELECT PromotionID
			FROM #ValidPromotions
			)

	SELECT PromotionID 'PromotionID'
		,AttachmentURL 'FileURL'
		,AttachmentName 'FileName'
		,AttachmentSize 'Size'
		,at.AttachmentTypeName 'Type'
		,pa.PromotionAttachmentID 'AttachmentID',
		pa.AttachmentDateModified 'ModifiedDate'
	FROM playbook.promotionattachment pa
	INNER JOIN Playbook.AttachmentType at ON pa.AttachmentTypeID = at.AttachmentTypeID
	WHERE promotionid IN (
			SELECT PromotionID
			FROM #ValidPromotions
			)


	SELECT PromotionID 'PromotionID',
		PackageID 
	FROM playbook.promotionpackage pa
	WHERE promotionid IN (
			SELECT PromotionID
			FROM #ValidPromotions
			)

END
Go

-----------
/****** Object:  StoredProcedure [BCMyday].[pGetStoreTieInsHistory]    Script Date: 3/4/2015 2:00:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
/*
exec BCMyday.pGetStoreTieInsHistory @BottlerID = 6017, @LastModifiedDate='2015-02-01'
exec BCMyday.pGetStoreTieInsHistory @BottlerID = 12016, @LastModifiedDate='2015-03-01'

	SELECT distinct StoreConditionID,                      
	a.AccountId,                      
	a.ConditionDate,                      
	a.GSN,                      
	a.BCSystemID,                      
	a.Longitude,                      
	a.Latitude,                      
	StoreNote,                      
	CreatedBy,                      
	CreatedDate,                      
	ModifiedBy,                      
	ModifiedDate,                      
	a.BottlerID,            
	IsActive,            
	case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted                        
	FROM BCMyday.StoreCondition a              
	WHERE             
	a.BottlerID = 6017
	and ConditionDate >= '2015-01-01'

*/

ALTER Procedure [BCMyday].[pGetStoreTieInsHistory]                      
(                                
	@BottlerID int 
	,@LastModifiedDate datetime     = null
)                      
As                      
Begin                      
   
	DECLARE @StoreTieinHistory int;  
	SELECT @StoreTieinHistory= value from BCMyday.Config  
	where [Key]='History'                               
                            
	SELECT distinct StoreConditionID,                      
	a.AccountId,                      
	a.ConditionDate,                      
	a.GSN,                      
	a.BCSystemID,                      
	a.Longitude,                      
	a.Latitude,                      
	StoreNote,                      
	CreatedBy,                      
	CreatedDate,                      
	ModifiedBy,                      
	ModifiedDate,                      
	a.BottlerID,            
	IsActive,            
	case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted                        
	into #StoreCondition            
	FROM BCMyday.StoreCondition a              
	WHERE             
	a.BottlerID = @BottlerID            
	--and ConditionDate >= DATEADD(MONTH,-@StoreTieinHistory,GETDATE())  
	and ConditionDate >= case when isnull(@LastModifiedDate,'') = '' then  DATEADD(MONTH,-@StoreTieinHistory,GETDATE())  else @LastModifiedDate end
	--AND IsActive=1            
             
	select * from #StoreCondition            
                      
	SELECT StoreConditionDisplayID,                      
	StoreConditionID,                      
	DisplayLocationID,                      
	PromotionID,                      
	DisplayLocationNote,                                      
	OtherNote,                      
	DisplayImageURL,                      
	GridX,                      
	GridY,                      
	CreatedBy,                      
	CreatedDate,                      
	ModifiedBy,                      
	ModifiedDate,            
	IsActive,            
	case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted ,
	DisplayTypeID,
	ReasonID
	into #StoreConditionDisplay            
	FROM BCMyday.StoreConditionDisplay                      
	WHERE StoreConditionID in          
	(SELECT StoreConditionID from #StoreCondition )        
	--AND IsActive=1             
                
	select * from #StoreConditionDisplay            
                   
	SELECT StoreConditionDisplayID,                      
	SystemPackageID,                      
	SystemBrandID,                      
	ModifiedDate,            
	IsActive,            
	case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted                      
	FROM BCMyDay.StoreConditionDisplayDetail                      
	WHERE StoreConditionDisplayID in          
	(SELECT StoreConditionDisplayID from #StoreConditionDisplay )         
	--AND IsActive=1            
              
	SELECT StoreConditionID,                      
	TieInRate,                      
	SystemBrandId,                      
	ModifiedDate,            
	IsActive,            
	case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted                        
	FROM BCMyday.StoreTieInRate                      
	WHERE StoreConditionID in          
	(SELECT StoreConditionID from #StoreCondition )            
	--AND IsActive=1                    
                      
	-------------------------------------------
	Select pe.StoreConditionID, PromotionID, DisplayLocationID StoreConditionDisplayID, PromotionExecutionStatusID 
	From BCMyDay.PromotionExecution pe
	Join #StoreCondition se on pe.StoreConditionID = se.StoreConditionID

	Select pe.StoreConditionID, Note, ImageURL, ImageName
	From BCMyDay.StoreConditionNote pe
	Join #StoreCondition se on pe.StoreConditionID = se.StoreConditionID

	Select pe.StoreConditionID, ManagementPriorityID, PriorityExecutionStatusID
	From BCMyDay.PriorityStoreConditionExecution pe
	Join #StoreCondition se on pe.StoreConditionID = se.StoreConditionID                      
                      
End
go

-----------------
/****** Object:  StoredProcedure [BCMyday].[pGetStoreTieInsHistoryByRegionID]    Script Date: 3/3/2015 11:02:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- BCMyday.pGetStoreTieInsHistoryByREgionID 239, '2015-2-4'
-- BCMyday.pGetStoreTieInsHistoryByREgionID 22, '2015-2-4'

ALTER Procedure BCMyday.pGetStoreTieInsHistoryByRegionID
(                                
	@RegionID int
	,@LastModifiedDate datetime = null
)                      
As                      
Begin                      
   
	DECLARE @StoreTieinHistory int;  
	SELECT @StoreTieinHistory= value from BCMyday.Config  
	where [Key]='History'

	SELECT distinct StoreConditionID,                      
	a.AccountId,                      
	a.ConditionDate,                      
	a.GSN,                      
	a.BCSystemID,                      
	a.Longitude,                      
	a.Latitude,                      
	StoreNote,                      
	CreatedBy,                      
	CreatedDate,                      
	ModifiedBy,                      
	ModifiedDate,                      
	a.BottlerID,            
	IsActive,            
	case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted                        
	into #StoreCondition            
	FROM BCMyday.StoreCondition a
	Left Join BC.Bottler b on a.BottlerID = b.BottlerID
	WHERE             
	b.BCRegionID = @RegionID            
	--and ConditionDate >= DATEADD(MONTH,-@StoreTieinHistory,GETDATE())  
	and ConditionDate >= case when isnull(@LastModifiedDate,'') = '' then  DATEADD(MONTH,-@StoreTieinHistory,GETDATE())  else @LastModifiedDate end
	--AND IsActive=1            
             
	select * from #StoreCondition            
                      
	SELECT StoreConditionDisplayID,                      
	StoreConditionID,                      
	DisplayLocationID,                      
	PromotionID,                      
	DisplayLocationNote,                                      
	OtherNote,                      
	DisplayImageURL,                      
	GridX,                      
	GridY,                      
	CreatedBy,                      
	CreatedDate,                      
	ModifiedBy,                      
	ModifiedDate,            
	IsActive,            
	case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted,
	DisplayTypeID,
	ReasonID
	into #StoreConditionDisplay            
	FROM BCMyday.StoreConditionDisplay                      
	WHERE StoreConditionID in          
	(SELECT StoreConditionID from #StoreCondition )        
	--AND IsActive=1             
                
	select * from #StoreConditionDisplay            
                   
	SELECT StoreConditionDisplayID,                      
	SystemPackageID,                      
	SystemBrandID,                      
	ModifiedDate,            
	IsActive,            
	case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted                      
	FROM BCMyDay.StoreConditionDisplayDetail                      
	WHERE StoreConditionDisplayID in          
	(SELECT StoreConditionDisplayID from #StoreConditionDisplay )         
	--AND IsActive=1            
              
	SELECT StoreConditionID,                      
	TieInRate,                      
	SystemBrandId,                      
	ModifiedDate,            
	IsActive,            
	case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted                        
	FROM BCMyday.StoreTieInRate                      
	WHERE StoreConditionID in          
	(SELECT StoreConditionID from #StoreCondition )            
	--AND IsActive=1
	  
	-------------------------------------------
	Select pe.StoreConditionID, PromotionID, DisplayLocationID StoreConditionDisplayID, PromotionExecutionStatusID 
	From BCMyDay.PromotionExecution pe
	Join #StoreCondition se on pe.StoreConditionID = se.StoreConditionID

	Select pe.StoreConditionID, Note, ImageURL, ImageName
	From BCMyDay.StoreConditionNote pe
	Join #StoreCondition se on pe.StoreConditionID = se.StoreConditionID

	Select pe.StoreConditionID, ManagementPriorityID, PriorityExecutionStatusID
	From BCMyDay.PriorityStoreConditionExecution pe
	Join #StoreCondition se on pe.StoreConditionID = se.StoreConditionID
                                  
End 
Go

---%%%%%%%%%%%%% Make sure this script runs ---------------------
----------
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


---%%%%%%%%%%%%% Make sure this script runs ---------------------

----------------------------------

Alter Table BCMyDay.StoreConditionDisplay
Add ImageSharePointID varchar(50) not null default ''
Go

------------
If exists (Select *
	From Sys.procedures p
	Join Sys.schemas s on p.schema_id = s.schema_id
	Where p.name = 'pGetBCPrioritiesByRegionID' and s.name = 'BCMyDay')
	Drop Proc BCMyDay.pGetBCPrioritiesByRegionID
Go

-------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* ----------- Testing bench -------
exec BCMyDay.pGetBCPrioritiesByRegionID @RegionID = 36

*/



Create Proc BCMyDay.pGetBCPrioritiesByRegionID
(
	@RegionID int,
	@LastModifiedTime datetime2(7) = '1970-01-01'
)
As

	Declare @MP Table
	(
		ManagementPriorityID int, 
		Description varchar(200), 
		StartDate Date, 
		EndDate Date, 
		Created DateTime2(7), 
		LastModified DateTime2(7), 
		Active bit, 
		ForAllBottlers bit, 
		ForAllBrands bit, 
		ForAllChains bit, 
		ForAllPackages bit
	)

	Insert Into @MP
	Select ManagementPriorityID, Description, StartDate, EndDate, Created, LastModified, Active, ForAllBottlers, ForAllBrands, ForAllChains, ForAllPackages
	From BCMyday.ManagementPriority
	Where GetDate() Between StartDate And EndDate
	And LastModified >= @LastModifiedTime
	And TypeID = 1
	And ForAllBottlers = 1
	--------------
	Union
	Select distinct mp.ManagementPriorityID, Description, StartDate, EndDate, Created, LastModified, Active, ForAllBottlers, ForAllBrands, ForAllChains, ForAllPackages
	From BCMyday.ManagementPriority mp
	Join
		(
		Select ManagementPriorityID, RegionID
		From BCMyday.PriorityBottler
		Where RegionID > 0 and BottlerID is null
		Union
		Select ManagementPriorityID, r.RegionID
		From BCMyday.PriorityBottler pb
		Join BC.Region r on pb.DivisionID = r.DivisionID  
		Where pb.DivisionID > 0 and pb.RegionID is null
		Union
		Select ManagementPriorityID, r.RegionID
		From BCMyday.PriorityBottler pb
		Join BC.Division d on pb.ZoneID = d.ZoneID
		Join BC.Region r on d.DivisionID = r.DivisionID
		Where pb.ZoneID > 0 and pb.DivisionID is null
		Union
		Select ManagementPriorityID, r.RegionID
		From BCMyday.PriorityBottler pb
		Join BC.Zone z on pb.SystemID = z.SystemID
		Join BC.Division d on z.ZoneID = d.ZoneID
		Join BC.Region r on d.DivisionID = r.DivisionID
		Where pb.SystemID > 0 and pb.ZoneID is null
		Union
		Select Distinct ManagementPriorityID, b.BCRegionID RegionID
		From BCMyday.PriorityBottler pb
		Join BC.Bottler b on pb.BottlerID = b.BottlerID
	) reg on reg.ManagementPriorityID = mp.ManagementPriorityID
	Where GetDate() Between StartDate And EndDate
	And LastModified >= @LastModifiedTime
	And ForAllBottlers = 0
	And reg.RegionID = @RegionID

	--------------------------------------
	Select * From @MP

	Select pc.ManagementPriorityID, NationalChainID, RegionalChainID, LocalChainID, pc.LastModified
	From BCMyDay.PriorityChain pc
	Join @MP mp on pc.ManagementPriorityID = mp.ManagementPriorityID
	Union
	Select mp.ManagementPriorityID, -1, null, null, mp.LastModified
	From @MP mp
	Where mp.ForAllChains = 1
	Order By pc.ManagementPriorityID, NationalChainID, RegionalChainID, LocalChainID

	Select pc.ManagementPriorityID, TradeMarkID, BrandID, pc.LastModified
	From BCMyDay.PriorityBrand pc
	Join @MP mp on pc.ManagementPriorityID = mp.ManagementPriorityID
	Union
	Select mp.ManagementPriorityID, -1, null, mp.LastModified
	From @MP mp 
	Where mp.ForAllBrands = 1
	Order By pc.ManagementPriorityID, TradeMarkID, BrandID, pc.LastModified

Go

Update BCMyDay.ManagementPriority
Set TypeID = 1
Go

Alter Table BCMyDay.ManagementPriority
Alter Column TypeID int not null
Go

/****** Object:  Table [BCMyday].[SystemCompetitionBrand]    Script Date: 3/11/2015 10:47:43 AM ******/
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
SET IDENTITY_INSERT [BCMyday].[SystemCompetitionBrand] ON 

GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (1, 5, 56, 9, 49, 1, N'System', CAST(N'2015-03-04 21:50:05.3857657' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3857657' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (2, 5, 57, 9, 49, 1, N'System', CAST(N'2015-03-04 21:50:05.3867640' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3867640' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (3, 5, 58, 9, 49, 1, N'System', CAST(N'2015-03-04 21:50:05.3867640' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3867640' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (4, 5, 59, 9, 49, 1, N'System', CAST(N'2015-03-04 21:50:05.3867640' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3867640' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (5, 5, 60, 9, 49, 1, N'System', CAST(N'2015-03-04 21:50:05.3867640' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3867640' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (6, 5, 61, 9, 49, 1, N'System', CAST(N'2015-03-04 21:50:05.3867640' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3867640' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (7, 5, 62, 9, 49, 1, N'System', CAST(N'2015-03-04 21:50:05.3867640' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3867640' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (8, 5, 63, 9, 49, 1, N'System', CAST(N'2015-03-04 21:50:05.3867640' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3867640' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (9, 5, 64, 10, 184, 1, N'System', CAST(N'2015-03-04 21:50:05.3877623' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3877623' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (10, 5, 65, NULL, NULL, 1, N'System', CAST(N'2015-03-04 21:50:05.3877623' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3877623' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (11, 6, 66, NULL, NULL, 1, N'System', CAST(N'2015-03-04 21:50:05.3877623' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3877623' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (12, 7, 5, 13, 1, 1, N'System', CAST(N'2015-03-04 21:50:05.3877623' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3877623' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (13, 7, 56, 9, 49, 1, N'System', CAST(N'2015-03-04 21:50:05.3877623' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3877623' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (14, 7, 58, 9, 49, 1, N'System', CAST(N'2015-03-04 21:50:05.3877623' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3877623' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (15, 7, 59, 9, 49, 1, N'System', CAST(N'2015-03-04 21:50:05.3877623' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3877623' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (16, 7, 56, 11, 195, 1, N'System', CAST(N'2015-03-04 21:50:05.3877623' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3877623' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (17, 7, 58, 11, 195, 1, N'System', CAST(N'2015-03-04 21:50:05.3877623' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3877623' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (18, 7, 59, 11, 195, 1, N'System', CAST(N'2015-03-04 21:50:05.3877623' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3877623' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (19, 7, 67, 12, 3, 1, N'System', CAST(N'2015-03-04 21:50:05.3877623' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3877623' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (20, 7, 68, 10, 184, 1, N'System', CAST(N'2015-03-04 21:50:05.3887607' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3887607' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (21, 7, 69, 10, 184, 1, N'System', CAST(N'2015-03-04 21:50:05.3887607' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3887607' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (22, 7, 68, 16, 35, 1, N'System', CAST(N'2015-03-04 21:50:05.3887607' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3887607' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (23, 7, 69, 16, 35, 1, N'System', CAST(N'2015-03-04 21:50:05.3887607' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3887607' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (24, 7, 70, 16, 35, 1, N'System', CAST(N'2015-03-04 21:50:05.3887607' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3887607' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (25, 7, 71, 7, 69, 1, N'System', CAST(N'2015-03-04 21:50:05.3887607' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3887607' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (26, 7, 17, 21, 194, 1, N'System', CAST(N'2015-03-04 21:50:05.3887607' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3887607' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (27, 7, 20, 13, 1, 1, N'System', CAST(N'2015-03-04 21:50:05.3887607' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3887607' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (28, 7, 73, 12, 3, 1, N'System', CAST(N'2015-03-04 21:50:05.3887607' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3887607' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (29, 7, 74, 16, 35, 1, N'System', CAST(N'2015-03-04 21:50:05.3887607' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3887607' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (30, 7, 75, 11, 195, 1, N'System', CAST(N'2015-03-04 21:50:05.3897586' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3897586' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (31, 7, 76, NULL, NULL, 1, N'System', CAST(N'2015-03-04 21:50:05.3897586' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3897586' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (32, 7, 77, 15, 187, 1, N'System', CAST(N'2015-03-04 21:50:05.3897586' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3897586' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (33, 7, 78, 15, 187, 1, N'System', CAST(N'2015-03-04 21:50:05.3897586' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3897586' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (34, 7, 79, 15, 187, 1, N'System', CAST(N'2015-03-04 21:50:05.3897586' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3897586' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (35, 7, 80, 15, 187, 1, N'System', CAST(N'2015-03-04 21:50:05.3897586' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3897586' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (36, 7, 81, 15, 187, 1, N'System', CAST(N'2015-03-04 21:50:05.3897586' AS DateTime2), N'System', CAST(N'2015-03-04 21:50:05.3897586' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (37, 7, 5, 13, 1, 1, N'System', CAST(N'2015-03-05 21:52:46.8619408' AS DateTime2), N'System', CAST(N'2015-03-05 21:52:46.8619408' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (38, 7, 56, 9, 49, 1, N'System', CAST(N'2015-03-05 21:52:46.8689278' AS DateTime2), N'System', CAST(N'2015-03-05 21:52:46.8689278' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (39, 7, 58, 9, 49, 1, N'System', CAST(N'2015-03-05 21:52:46.8709312' AS DateTime2), N'System', CAST(N'2015-03-05 21:52:46.8709312' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (40, 7, 59, 9, 49, 1, N'System', CAST(N'2015-03-05 21:52:46.8739191' AS DateTime2), N'System', CAST(N'2015-03-05 21:52:46.8739191' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (41, 7, 56, 11, 195, 1, N'System', CAST(N'2015-03-05 21:52:46.8759225' AS DateTime2), N'System', CAST(N'2015-03-05 21:52:46.8759225' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (42, 7, 58, 11, 195, 1, N'System', CAST(N'2015-03-05 21:52:46.8779187' AS DateTime2), N'System', CAST(N'2015-03-05 21:52:46.8779187' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (43, 7, 59, 11, 195, 1, N'System', CAST(N'2015-03-05 21:52:46.8799154' AS DateTime2), N'System', CAST(N'2015-03-05 21:52:46.8799154' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (44, 7, 67, 12, 3, 1, N'System', CAST(N'2015-03-05 21:52:46.8819049' AS DateTime2), N'System', CAST(N'2015-03-05 21:52:46.8819049' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (45, 7, 68, 10, 184, 1, N'System', CAST(N'2015-03-05 21:52:46.8848995' AS DateTime2), N'System', CAST(N'2015-03-05 21:52:46.8848995' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (46, 7, 69, 10, 184, 1, N'System', CAST(N'2015-03-05 21:52:46.8868961' AS DateTime2), N'System', CAST(N'2015-03-05 21:52:46.8868961' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (47, 7, 68, 16, 35, 1, N'System', CAST(N'2015-03-05 21:52:46.8888919' AS DateTime2), N'System', CAST(N'2015-03-05 21:52:46.8888919' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (48, 7, 69, 16, 35, 1, N'System', CAST(N'2015-03-05 21:52:46.8908886' AS DateTime2), N'System', CAST(N'2015-03-05 21:52:46.8908886' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (49, 7, 70, 16, 35, 1, N'System', CAST(N'2015-03-05 21:52:46.9038657' AS DateTime2), N'System', CAST(N'2015-03-05 21:52:46.9038657' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (50, 7, 71, 7, 69, 1, N'System', CAST(N'2015-03-05 21:52:46.9058623' AS DateTime2), N'System', CAST(N'2015-03-05 21:52:46.9058623' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (51, 7, 17, 21, 194, 1, N'System', CAST(N'2015-03-05 21:52:46.9078653' AS DateTime2), N'System', CAST(N'2015-03-05 21:52:46.9078653' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (52, 7, 20, 13, 1, 1, N'System', CAST(N'2015-03-05 21:52:46.9098548' AS DateTime2), N'System', CAST(N'2015-03-05 21:52:46.9098548' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (53, 7, 73, 12, 3, 1, N'System', CAST(N'2015-03-05 21:52:46.9118586' AS DateTime2), N'System', CAST(N'2015-03-05 21:52:46.9118586' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (54, 7, 74, 16, 35, 1, N'System', CAST(N'2015-03-05 21:52:46.9138548' AS DateTime2), N'System', CAST(N'2015-03-05 21:52:46.9138548' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (55, 7, 75, 11, 195, 1, N'System', CAST(N'2015-03-05 21:52:46.9158515' AS DateTime2), N'System', CAST(N'2015-03-05 21:52:46.9158515' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (56, 7, 76, NULL, NULL, 1, N'System', CAST(N'2015-03-05 21:52:46.9218344' AS DateTime2), N'System', CAST(N'2015-03-05 21:52:46.9218344' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (57, 7, 77, 15, 187, 1, N'System', CAST(N'2015-03-05 21:52:46.9238306' AS DateTime2), N'System', CAST(N'2015-03-05 21:52:46.9238306' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (58, 7, 78, 15, 187, 1, N'System', CAST(N'2015-03-05 21:52:46.9258273' AS DateTime2), N'System', CAST(N'2015-03-05 21:52:46.9258273' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (59, 7, 79, 15, 187, 1, N'System', CAST(N'2015-03-05 21:52:46.9278235' AS DateTime2), N'System', CAST(N'2015-03-05 21:52:46.9278235' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (60, 7, 80, 15, 187, 1, N'System', CAST(N'2015-03-05 21:52:46.9298202' AS DateTime2), N'System', CAST(N'2015-03-05 21:52:46.9298202' AS DateTime2))
GO
INSERT [BCMyday].[SystemCompetitionBrand] ([SystemCompetionBrandID], [SystemID], [SystemBrandID], [SystemTradeMarkID], [TradeMarkID], [Active], [CreatedBy], [Created], [LastModifiedBy], [LastModified]) VALUES (61, 7, 81, 15, 187, 1, N'System', CAST(N'2015-03-05 21:52:46.9318164' AS DateTime2), N'System', CAST(N'2015-03-05 21:52:46.9318164' AS DateTime2))
GO
SET IDENTITY_INSERT [BCMyday].[SystemCompetitionBrand] OFF
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

Alter Table [BCMyday].[ManagementPriority]
Add PriorityNote varchar(200) default '' null
Go

------------------------------
ALTER TABLE BCMyday.PriorityChain DROP CONSTRAINT FK_PriorityChain_ManagementPriority
GO

ALTER TABLE BCMyday.PriorityChain  WITH CHECK ADD  CONSTRAINT FK_PriorityChain_ManagementPriority FOREIGN KEY(ManagementPriorityID)
REFERENCES BCMyday.ManagementPriority (ManagementPriorityID)
ON DELETE CASCADE
GO

ALTER TABLE BCMyday.PriorityChain CHECK CONSTRAINT FK_PriorityChain_ManagementPriority
GO
------------------------------
ALTER TABLE BCMyday.PriorityBrand DROP CONSTRAINT FK_PriorityBrand_ManagementPriority
GO

ALTER TABLE BCMyday.PriorityBrand  WITH CHECK ADD  CONSTRAINT FK_PriorityBrand_ManagementPriority FOREIGN KEY(ManagementPriorityID)
REFERENCES BCMyday.ManagementPriority (ManagementPriorityID)
ON DELETE CASCADE
GO

ALTER TABLE BCMyday.PriorityBrand CHECK CONSTRAINT FK_PriorityBrand_ManagementPriority
GO
-------------------------------
ALTER TABLE BCMyday.PriorityPackage DROP CONSTRAINT FK_PriorityPackage_ManagementPriority
GO

ALTER TABLE BCMyday.PriorityPackage  WITH CHECK ADD  CONSTRAINT FK_PriorityPackage_ManagementPriority FOREIGN KEY(ManagementPriorityID)
REFERENCES BCMyday.ManagementPriority (ManagementPriorityID)
ON DELETE CASCADE
GO

ALTER TABLE BCMyday.PriorityPackage CHECK CONSTRAINT FK_PriorityPackage_ManagementPriority
GO
-------------------------------
ALTER TABLE BCMyday.PriorityBottler DROP CONSTRAINT FK_PriorityBottler_ManagementPriority
GO

ALTER TABLE BCMyday.PriorityBottler  WITH CHECK ADD  CONSTRAINT FK_PriorityBottler_ManagementPriority FOREIGN KEY(ManagementPriorityID)
REFERENCES BCMyday.ManagementPriority (ManagementPriorityID)
ON DELETE CASCADE
GO

ALTER TABLE BCMyday.PriorityBottler CHECK CONSTRAINT FK_PriorityBottler_ManagementPriority
GO
-------------------------------
ALTER TABLE BCMyday.PriorityStoreConditionExecution DROP CONSTRAINT FK_PriorityStoreConditionExecution_ManagementPriority
GO

ALTER TABLE BCMyday.PriorityStoreConditionExecution  WITH CHECK ADD  CONSTRAINT FK_PriorityStoreConditionExecution_ManagementPriority FOREIGN KEY(ManagementPriorityID)
REFERENCES BCMyday.ManagementPriority (ManagementPriorityID)
ON DELETE CASCADE
GO

ALTER TABLE BCMyday.PriorityStoreConditionExecution CHECK CONSTRAINT FK_PriorityStoreConditionExecution_ManagementPriority
GO

-------------------------------

Alter Table [BCMyday].[StoreConditionDisplay]
Add IsFairShare bit not null default 0
Go

-------------------------------
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--SET ANSI_PADDING ON
--GO

--CREATE TABLE [BCMyday].[PriorityBottlerForUI](
--	[PriorityBottlerForUIID] [int] IDENTITY(1,1) NOT NULL,
--	[ManagementPriorityID] [int] NOT NULL,
--	[BottlerID] [int] NULL,
--	[RegionID] [int] NULL,
--	[DivisionID] [int] NULL,
--	[ZoneID] [int] NULL,
--	[SystemID] [int] NULL,
--	[StateRegionID] [int] NULL,
--	[CreatedBy] [varchar](50) NOT NULL,
--	[Created] [datetime2](7) NOT NULL,
--	[LastModifiedBy] [varchar](50) NOT NULL,
--	[LastModified] [datetime2](7) NOT NULL,
-- CONSTRAINT [PK_PriorityBottlerForUI] PRIMARY KEY CLUSTERED 
--(
--	[PriorityBottlerForUIID]  ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
--) ON [PRIMARY]

--GO

--SET ANSI_PADDING OFF
--GO

--ALTER TABLE [BCMyday].[PriorityBottlerForUI]  WITH CHECK ADD  CONSTRAINT [FK_PriorityBottlerForUI_Bottler] FOREIGN KEY([BottlerID])
--REFERENCES [BC].[Bottler] ([BottlerID])
--GO

--ALTER TABLE [BCMyday].[PriorityBottlerForUI] CHECK CONSTRAINT [FK_PriorityBottlerForUI_Bottler]
--GO

--ALTER TABLE [BCMyday].[PriorityBottlerForUI]  WITH CHECK ADD  CONSTRAINT [FK_PriorityBottlerForUI_Division] FOREIGN KEY([DivisionID])
--REFERENCES [BC].[Division] ([DivisionID])
--GO

--ALTER TABLE [BCMyday].[PriorityBottlerForUI]  WITH CHECK ADD  CONSTRAINT [FK_PriorityBottlerForUI_StateRegion] FOREIGN KEY(StateRegionID)
--REFERENCES Shared.StateRegion (StateRegionID)
--GO

--ALTER TABLE [BCMyday].[PriorityBottlerForUI] CHECK CONSTRAINT [FK_PriorityBottlerForUI_Division]
--GO

--ALTER TABLE [BCMyday].[PriorityBottlerForUI]  WITH CHECK ADD  CONSTRAINT [FK_PriorityBottlerForUI_ManagementPriority] FOREIGN KEY([ManagementPriorityID])
--REFERENCES [BCMyday].[ManagementPriority] ([ManagementPriorityID])
--ON DELETE CASCADE
--GO

--ALTER TABLE [BCMyday].[PriorityBottlerForUI] CHECK CONSTRAINT [FK_PriorityBottlerForUI_ManagementPriority]
--GO

--ALTER TABLE [BCMyday].[PriorityBottlerForUI]  WITH CHECK ADD  CONSTRAINT [FK_PriorityBottlerForUI_Region] FOREIGN KEY([RegionID])
--REFERENCES [BC].[Region] ([RegionID])
--GO

--ALTER TABLE [BCMyday].[PriorityBottlerForUI] CHECK CONSTRAINT [FK_PriorityBottlerForUI_Region]
--GO

--ALTER TABLE [BCMyday].[PriorityBottlerForUI]  WITH CHECK ADD  CONSTRAINT [FK_PriorityBottlerForUI_System] FOREIGN KEY([SystemID])
--REFERENCES [BC].[System] ([SystemID])
--GO

--ALTER TABLE [BCMyday].[PriorityBottlerForUI] CHECK CONSTRAINT [FK_PriorityBottlerForUI_System]
--GO

--ALTER TABLE [BCMyday].[PriorityBottlerForUI]  WITH CHECK ADD  CONSTRAINT [FK_PriorityBottlerForUI_Zone] FOREIGN KEY([ZoneID])
--REFERENCES [BC].[Zone] ([ZoneID])
--GO

--ALTER TABLE [BCMyday].[PriorityBottlerForUI] CHECK CONSTRAINT [FK_PriorityBottlerForUI_Zone]
--GO

-----------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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

