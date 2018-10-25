USE [Portal_Data]
GO

/****** Object:  Table [Promotion].[PromotionChannel]    Script Date: 3/21/2013 4:41:56 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Promotion].[PromotionChannel](
	[PromotionID] [int] NOT NULL,
	[ChannelID] [int] NOT NULL,
 CONSTRAINT [PK_PromotionChannel] PRIMARY KEY CLUSTERED 
(
	[PromotionID] ASC,
	[ChannelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [Promotion].[PromotionChannel]  WITH CHECK ADD  CONSTRAINT [FK_PromotionChannel_RetailPromotion] FOREIGN KEY([PromotionID])
REFERENCES [Promotion].[RetailPromotion] ([PromotionID])
GO

ALTER TABLE [Promotion].[PromotionChannel] CHECK CONSTRAINT [FK_PromotionChannel_RetailPromotion]
GO


