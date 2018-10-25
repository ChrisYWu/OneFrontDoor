USE [Portal_Data]
GO

/****** Object:  Table [Promotion].[PromotionType]    Script Date: 3/21/2013 4:47:36 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Promotion].[PromotionType](
	[PromotionID] [int] NULL,
	[PromotionTypeID] [int] NULL,
	[PromotionTypeDesc] [varchar](50) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [Promotion].[PromotionType]  WITH CHECK ADD  CONSTRAINT [FK_PromotionType_RetailPromotion] FOREIGN KEY([PromotionID])
REFERENCES [Promotion].[RetailPromotion] ([PromotionID])
GO

ALTER TABLE [Promotion].[PromotionType] CHECK CONSTRAINT [FK_PromotionType_RetailPromotion]
GO


