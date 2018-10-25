USE [Portal_Data]
GO

/****** Object:  Table [PlayBook].[PromotionAccount]    Script Date: 3/21/2013 4:25:42 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [PlayBook].[PromotionAccount](
	[PromotionID] [int] NOT NULL,
	[LocalChainID] [varchar](120) NULL,
	[RegionalChainID] [varchar](120) NULL,
	[NationalChainID] [varchar](120) NULL,
 CONSTRAINT [PK_PromotionAccount_1] PRIMARY KEY CLUSTERED 
(
	[PromotionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [PlayBook].[PromotionAccount]  WITH CHECK ADD  CONSTRAINT [FK__Promotion__Promo__04308F6E] FOREIGN KEY([PromotionID])
REFERENCES [PlayBook].[RetailPromotion] ([PromotionID])
GO

ALTER TABLE [PlayBook].[PromotionAccount] CHECK CONSTRAINT [FK__Promotion__Promo__04308F6E]
GO


