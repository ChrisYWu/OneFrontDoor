USE [Portal_Data]
GO

/****** Object:  Table [PlayBook].[PromotionBrand]    Script Date: 3/21/2013 4:28:00 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [PlayBook].[PromotionBrand](
	[PromotionID] [int] NOT NULL,
	[BrandID] [int] NULL,
	[ItemID] [nchar](10) NOT NULL,
	[Brand] [varchar](120) NULL,
 CONSTRAINT [PK_PromotionBrand_1] PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [PlayBook].[PromotionBrand]  WITH CHECK ADD  CONSTRAINT [FK__Promotion__Promo__024846FC] FOREIGN KEY([PromotionID])
REFERENCES [PlayBook].[RetailPromotion] ([PromotionID])
GO

ALTER TABLE [PlayBook].[PromotionBrand] CHECK CONSTRAINT [FK__Promotion__Promo__024846FC]
GO

ALTER TABLE [PlayBook].[PromotionBrand]  WITH CHECK ADD  CONSTRAINT [FK_PromotionBrand_Brand] FOREIGN KEY([BrandID])
REFERENCES [SAP].[Brand] ([BrandID])
GO

ALTER TABLE [PlayBook].[PromotionBrand] CHECK CONSTRAINT [FK_PromotionBrand_Brand]
GO


