USE [Portal_Data]
GO

/****** Object:  Table [Promotion].[AreaPromotion]    Script Date: 3/21/2013 4:36:12 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Promotion].[AreaPromotion](
	[PromotionID] [int] NOT NULL,
	[AreaID] [int] NOT NULL,
	[BUPromotionID] [int] NULL,
 CONSTRAINT [PK_AreaPromotion] PRIMARY KEY CLUSTERED 
(
	[PromotionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [Promotion].[AreaPromotion]  WITH CHECK ADD  CONSTRAINT [FK_AreaPromotion_BusinessArea] FOREIGN KEY([AreaID])
REFERENCES [SAP].[BusinessArea] ([AreaID])
GO

ALTER TABLE [Promotion].[AreaPromotion] CHECK CONSTRAINT [FK_AreaPromotion_BusinessArea]
GO

ALTER TABLE [Promotion].[AreaPromotion]  WITH CHECK ADD  CONSTRAINT [FK_AreaPromotion_BusinessUnitPromotion] FOREIGN KEY([PromotionID])
REFERENCES [Promotion].[BusinessUnitPromotion] ([PromotionID])
GO

ALTER TABLE [Promotion].[AreaPromotion] CHECK CONSTRAINT [FK_AreaPromotion_BusinessUnitPromotion]
GO

ALTER TABLE [Promotion].[AreaPromotion]  WITH CHECK ADD  CONSTRAINT [FK_AreaPromotion_BusinessUnitPromotion1] FOREIGN KEY([AreaID])
REFERENCES [Promotion].[BusinessUnitPromotion] ([PromotionID])
GO

ALTER TABLE [Promotion].[AreaPromotion] CHECK CONSTRAINT [FK_AreaPromotion_BusinessUnitPromotion1]
GO

ALTER TABLE [Promotion].[AreaPromotion]  WITH CHECK ADD  CONSTRAINT [FK_AreaPromotion_RetailPromotion] FOREIGN KEY([PromotionID])
REFERENCES [Promotion].[RetailPromotion] ([PromotionID])
GO

ALTER TABLE [Promotion].[AreaPromotion] CHECK CONSTRAINT [FK_AreaPromotion_RetailPromotion]
GO


