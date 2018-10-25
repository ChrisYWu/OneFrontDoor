USE [Portal_Data]
GO

/****** Object:  Table [Promotion].[PromotionPackageSize]    Script Date: 3/21/2013 4:42:49 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Promotion].[PromotionPackageSize](
	[PromotionID] [int] NOT NULL,
	[PackageSizeName] [varchar](500) NOT NULL,
 CONSTRAINT [PK_PromotionPackageSize] PRIMARY KEY CLUSTERED 
(
	[PromotionID] ASC,
	[PackageSizeName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [Promotion].[PromotionPackageSize]  WITH CHECK ADD  CONSTRAINT [FK_PromotionPackageSize_RetailPromotion] FOREIGN KEY([PromotionID])
REFERENCES [Promotion].[RetailPromotion] ([PromotionID])
GO

ALTER TABLE [Promotion].[PromotionPackageSize] CHECK CONSTRAINT [FK_PromotionPackageSize_RetailPromotion]
GO


