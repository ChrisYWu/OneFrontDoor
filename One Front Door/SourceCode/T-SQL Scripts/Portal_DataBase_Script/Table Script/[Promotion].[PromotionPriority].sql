USE [Portal_Data]
GO

/****** Object:  Table [Promotion].[PromotionPriority]    Script Date: 3/21/2013 4:44:29 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Promotion].[PromotionPriority](
	[PromotionID] [int] NOT NULL,
	[PrioritiesID] [int] NOT NULL,
 CONSTRAINT [PK_PromotionPriority] PRIMARY KEY CLUSTERED 
(
	[PromotionID] ASC,
	[PrioritiesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [Promotion].[PromotionPriority]  WITH CHECK ADD  CONSTRAINT [FK_PromotionPriority_Priority] FOREIGN KEY([PrioritiesID])
REFERENCES [Promotion].[Priority] ([PrioritiesID])
GO

ALTER TABLE [Promotion].[PromotionPriority] CHECK CONSTRAINT [FK_PromotionPriority_Priority]
GO

ALTER TABLE [Promotion].[PromotionPriority]  WITH CHECK ADD  CONSTRAINT [FK_PromotionPriority_RetailPromotion] FOREIGN KEY([PromotionID])
REFERENCES [Promotion].[RetailPromotion] ([PromotionID])
GO

ALTER TABLE [Promotion].[PromotionPriority] CHECK CONSTRAINT [FK_PromotionPriority_RetailPromotion]
GO


