USE [Portal_Data]
GO

/****** Object:  Table [Promotion].[PromotionShopperObmProg]    Script Date: 3/21/2013 4:46:10 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Promotion].[PromotionShopperObmProg](
	[PromotionID] [int] NULL,
	[ShopperOBMProgramID] [int] NOT NULL,
 CONSTRAINT [PK_PromotionShopperObmProg] PRIMARY KEY CLUSTERED 
(
	[ShopperOBMProgramID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [Promotion].[PromotionShopperObmProg]  WITH CHECK ADD  CONSTRAINT [FK_PromotionShopperObmProg_RetailPromotion] FOREIGN KEY([PromotionID])
REFERENCES [Promotion].[RetailPromotion] ([PromotionID])
GO

ALTER TABLE [Promotion].[PromotionShopperObmProg] CHECK CONSTRAINT [FK_PromotionShopperObmProg_RetailPromotion]
GO


