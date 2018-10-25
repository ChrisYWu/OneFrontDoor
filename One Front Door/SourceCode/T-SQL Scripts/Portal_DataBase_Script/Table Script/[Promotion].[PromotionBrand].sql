USE [Portal_Data]
GO

/****** Object:  Table [Promotion].[PromotionBrand]    Script Date: 3/21/2013 4:41:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Promotion].[PromotionBrand](
	[PromotionID] [int] NOT NULL,
	[BrandName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_PromotionBrand] PRIMARY KEY CLUSTERED 
(
	[PromotionID] ASC,
	[BrandName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [Promotion].[PromotionBrand]  WITH CHECK ADD  CONSTRAINT [FK_PromotionBrand_RetailPromotion] FOREIGN KEY([PromotionID])
REFERENCES [Promotion].[RetailPromotion] ([PromotionID])
GO

ALTER TABLE [Promotion].[PromotionBrand] CHECK CONSTRAINT [FK_PromotionBrand_RetailPromotion]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Brands Promotion Table' , @level0type=N'SCHEMA',@level0name=N'Promotion', @level1type=N'TABLE',@level1name=N'PromotionBrand'
GO


