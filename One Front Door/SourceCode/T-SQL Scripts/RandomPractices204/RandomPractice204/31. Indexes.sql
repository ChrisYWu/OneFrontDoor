USE [Portal_Data805]
GO

If Exists (Select * From sys.tables Where object_id = object_id('BCMyDay.PromotionRequestLog'))
	Drop Table BCMyDay.PromotionRequestLog
Go

-------------------------------------------------
Create Table BCMyDay.PromotionRequestLog
(
	LogID int IDENTITY(1,1),
	[LogDate]  AS (CONVERT([date],[StartDate])),
	[Duration]  AS (datediff(millisecond,[StartDate],[EndDate])),
	GSN varchar(50) not null,
	MDate DateTime null,
	StartDate datetime2(7) not null,
	EndDate datetime2(7) null,
	NumberOfPromotion int null,
	NumberOfCurrentPromotion int null,
	NumberOfRegion int null,
	NumberOfBottler int null,
	NumberOfAttachments int,
	NumberOfPromoBottler int,
	TotalAttachmentSize bigint
CONSTRAINT [PK_PromotionRequestLog] PRIMARY KEY CLUSTERED 
(
	[StartDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
Go

-------------------------------------------------
If Exists (Select * From sys.indexes Where name = 'NCI_Promo_Dates' And object_id = object_id('Playbook.RetailPromotion'))
	DROP INDEX [NCI_Promo_Dates] ON [Playbook].[RetailPromotion]
Go

CREATE NONCLUSTERED INDEX [NCI_Promo_Dates] ON [Playbook].[RetailPromotion]
(
	[PromotionStatusID],
	[PromotionRelevantStartDate],
	[PromotionRelevantEndDate]
)
INCLUDE ([PromotionID],[PromotionStartDate],[PromotionEndDate],[ModifiedDate])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

----------------------------------------
If Exists (Select * From sys.indexes Where name = 'NCI_PromoGeo_BC' And object_id = object_id('Playbook.PromotionGeoHier'))
	DROP INDEX [NCI_PromoGeo_BC] ON [Playbook].[PromotionGeoHier]
GO

/****** Object:  Index [NCI_PromoGeo_BC]    Script Date: 7/28/2015 12:16:20 PM ******/
CREATE NONCLUSTERED INDEX [NCI_PromoGeo_BC] ON [Playbook].[PromotionGeoHier]
(
	[PromotionID] ASC,
	[SystemID] ASC,
	[BCRegionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO


/****** Object:  Index [NCI_PromoGeo_PromotionID]    Script Date: 7/28/2015 4:16:28 PM ******/
If Exists (Select * From sys.indexes Where name = 'NCI_PromoGeo_PromotionID' And object_id = object_id('Playbook.PromotionGeoHier'))
	DROP INDEX [NCI_PromoGeo_PromotionID] ON [Playbook].[PromotionGeoHier]
GO

/****** Object:  Index [NCI_PromoGeo_PromotionID]    Script Date: 7/28/2015 4:16:28 PM ******/
CREATE NONCLUSTERED INDEX [NCI_PromoGeo_PromotionID] ON [Playbook].[PromotionGeoHier]
(
	[PromotionID] ASC
)
INCLUDE ( 	[BCRegionID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

----------------------------------------
/****** Object:  Index [NCI_PromoTradeMark_TM]    Script Date: 7/27/2015 2:22:15 PM ******/
If Exists (Select * From sys.indexes Where name = 'NCI_PromoTradeMark_TM' And object_id = object_id('Playbook.PromotionBrand'))
	DROP INDEX [NCI_PromoTradeMark_TM] ON [Playbook].[PromotionBrand]
GO

/****** Object:  Index [NCI_PromoTradeMark_TM]    Script Date: 7/27/2015 2:22:15 PM ******/
CREATE NONCLUSTERED INDEX [NCI_PromoTradeMark_TM] ON [Playbook].[PromotionBrand]
(
	[PromotionID] ASC,
	[TrademarkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

GO

/****** Object:  Index [20150730-101929]    Script Date: 7/30/2015 4:19:32 PM ******/
If Exists (Select * From sys.indexes Where name = 'NCI_PromoTradeMark_TM2' And object_id = object_id('Playbook.PromotionBrand'))
	DROP INDEX [NCI_PromoTradeMark_TM2] ON [Playbook].[PromotionBrand]
GO

/****** Object:  Index [20150730-101929]    Script Date: 7/30/2015 4:19:32 PM ******/
CREATE NONCLUSTERED INDEX [NCI_PromoTradeMark_TM2] ON [Playbook].[PromotionBrand]
(
	[TrademarkID] ASC
)
INCLUDE ([PromotionID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

------------------------------------------
/****** Object:  Index [NCI_PromoTradeMark_B]    Script Date: 7/27/2015 2:23:25 PM ******/
If Exists (Select * From sys.indexes Where name = 'NCI_PromoTradeMark_B' And object_id = object_id('Playbook.PromotionBrand'))
	DROP INDEX [NCI_PromoTradeMark_B] ON [Playbook].[PromotionBrand]
GO

/****** Object:  Index [NCI_PromoTradeMark_B]    Script Date: 7/27/2015 2:23:25 PM ******/
CREATE NONCLUSTERED INDEX [NCI_PromoTradeMark_B] ON [Playbook].[PromotionBrand]
(
	[PromotionID] ASC,
	[BrandID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)


GO

--------------------------------------------
/****** Object:  Index [NCI_PromotionAccount_NC]    Script Date: 7/27/2015 2:34:30 PM ******/
If Exists (Select * From sys.indexes Where name = 'NCI_PromotionAccount_NC' And object_id = object_id('Playbook.PromotionAccount'))
	DROP INDEX [NCI_PromotionAccount_NC] ON [Playbook].[PromotionAccount]
GO

/****** Object:  Index [NCI_PromotionAccount_NC]    Script Date: 7/27/2015 2:34:30 PM ******/
CREATE NONCLUSTERED INDEX [NCI_PromotionAccount_NC] ON [Playbook].[PromotionAccount]
(
	[PromotionID] ASC,
	[NationalChainID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

----------------------------------------------
/****** Object:  Index [NCI_PromotionAccount_RC]    Script Date: 7/27/2015 2:35:24 PM ******/
If Exists (Select * From sys.indexes Where name = 'NCI_PromotionAccount_RC' And object_id = object_id('Playbook.PromotionAccount'))
DROP INDEX [NCI_PromotionAccount_RC] ON [Playbook].[PromotionAccount]
GO

/****** Object:  Index [NCI_PromotionAccount_RC]    Script Date: 7/27/2015 2:35:24 PM ******/
CREATE NONCLUSTERED INDEX [NCI_PromotionAccount_RC] ON [Playbook].[PromotionAccount]
(
	[PromotionID] ASC,
	[RegionalChainID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

----------------------------------------------
/****** Object:  Index [NCI_PromotionAccount_RC]    Script Date: 7/27/2015 2:35:24 PM ******/
If Exists (Select * From sys.indexes Where name = 'NCI_PromotionAccount_LC' And object_id = object_id('Playbook.PromotionAccount'))
	DROP INDEX [NCI_PromotionAccount_LC] ON [Playbook].[PromotionAccount]
GO

/****** Object:  Index [NCI_PromotionAccount_RC]    Script Date: 7/27/2015 2:35:24 PM ******/
CREATE NONCLUSTERED INDEX [NCI_PromotionAccount_LC] ON [Playbook].[PromotionAccount]
(
	[PromotionID] ASC,
	[LocalChainID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

-----------------------------------------------
/****** Object:  Index [NCI_RegionalChain_NC]    Script Date: 7/27/2015 2:42:22 PM ******/
If Exists (Select * From sys.indexes Where name = 'NCI_RegionalChain_NC' And object_id = object_id('SAP.RegionalChain'))
	DROP INDEX [NCI_RegionalChain_NC] ON [SAP].[RegionalChain]
GO

/****** Object:  Index [NCI_RegionalChain_NC]    Script Date: 7/27/2015 2:42:22 PM ******/
CREATE NONCLUSTERED INDEX [NCI_RegionalChain_NC] ON [SAP].[RegionalChain]
(
	[NationalChainID] ASC
)
INCLUDE ( 	[RegionalChainID],
	[SAPRegionalChainID],
	[RegionalChainName]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

----------------------------------
If Exists (Select * From sys.indexes Where name = 'NCI_RegionChainTrademark' And object_id = object_id('BC.tRegionChainTradeMark'))
	DROP INDEX NCI_RegionChainTrademark ON [BC].[tRegionChainTradeMark]
GO

----------------------------------
If Exists (Select * From sys.indexes Where name = 'NCI_tBottlerChainTradeMark_PTL' And object_id = object_id('BC.tBottlerChainTradeMark'))
	DROP INDEX NCI_tBottlerChainTradeMark_PTL ON [BC].tBottlerChainTradeMark
GO

CREATE NONCLUSTERED INDEX NCI_tBottlerChainTradeMark_PTL
ON [BC].[tBottlerChainTradeMark] ([ProductTypeID],[TradeMarkID],[LocalChainID])
INCLUDE ([TerritoryTypeID],[BottlerID])
Go
