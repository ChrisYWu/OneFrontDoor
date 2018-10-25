USE [Portal_Data]
GO

/****** Object:  Table [PlayBook].[PromotionPackage]    Script Date: 3/21/2013 4:31:48 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [PlayBook].[PromotionPackage](
	[ItemId] [int] NOT NULL,
	[PromotionID] [int] NOT NULL,
	[PackageID] [varchar](120) NULL,
	[Package] [varchar](150) NULL,
 CONSTRAINT [PK_PromotionPackage] PRIMARY KEY CLUSTERED 
(
	[ItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [PlayBook].[PromotionPackage]  WITH CHECK ADD  CONSTRAINT [FK__Promotion__Promo__0618D7E0] FOREIGN KEY([PromotionID])
REFERENCES [PlayBook].[RetailPromotion] ([PromotionID])
GO

ALTER TABLE [PlayBook].[PromotionPackage] CHECK CONSTRAINT [FK__Promotion__Promo__0618D7E0]
GO


