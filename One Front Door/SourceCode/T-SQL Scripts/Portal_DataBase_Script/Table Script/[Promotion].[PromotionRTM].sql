USE [Portal_Data]
GO

/****** Object:  Table [Promotion].[PromotionRTM]    Script Date: 3/21/2013 4:45:18 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Promotion].[PromotionRTM](
	[PromotionID] [int] NOT NULL,
	[RouteToMarketName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_PromotionRTM] PRIMARY KEY CLUSTERED 
(
	[PromotionID] ASC,
	[RouteToMarketName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [Promotion].[PromotionRTM]  WITH CHECK ADD  CONSTRAINT [FK_PromotionRTM_RetailPromotion] FOREIGN KEY([PromotionID])
REFERENCES [Promotion].[RetailPromotion] ([PromotionID])
GO

ALTER TABLE [Promotion].[PromotionRTM] CHECK CONSTRAINT [FK_PromotionRTM_RetailPromotion]
GO

ALTER TABLE [Promotion].[PromotionRTM]  WITH CHECK ADD  CONSTRAINT [FK_PromotionRTM_RouteToMarket] FOREIGN KEY([RouteToMarketName])
REFERENCES [SAP].[RouteToMarket] ([RouteToMarketName])
GO

ALTER TABLE [Promotion].[PromotionRTM] CHECK CONSTRAINT [FK_PromotionRTM_RouteToMarket]
GO


