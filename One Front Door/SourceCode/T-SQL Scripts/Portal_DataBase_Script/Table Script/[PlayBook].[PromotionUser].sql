USE [Portal_Data]
GO

/****** Object:  Table [PlayBook].[PromotionUser]    Script Date: 3/21/2013 4:34:22 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [PlayBook].[PromotionUser](
	[PromotionID] [int] NOT NULL,
	[PromotionCreatedBy] [varchar](110) NULL,
	[PromotionReviewer] [varchar](110) NULL,
 CONSTRAINT [PK_PromotionUser] PRIMARY KEY CLUSTERED 
(
	[PromotionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [PlayBook].[PromotionUser]  WITH CHECK ADD  CONSTRAINT [FK__Promotion__Promo__005FFE8A] FOREIGN KEY([PromotionID])
REFERENCES [PlayBook].[RetailPromotion] ([PromotionID])
GO

ALTER TABLE [PlayBook].[PromotionUser] CHECK CONSTRAINT [FK__Promotion__Promo__005FFE8A]
GO


