USE [Portal_Data]
GO

/****** Object:  Table [Promotion].[PromotionAccount]    Script Date: 3/21/2013 4:40:23 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Promotion].[PromotionAccount](
	[PromotionID] [int] NOT NULL,
	[AccoutID] [int] NOT NULL,
 CONSTRAINT [PK_PromotionAccount] PRIMARY KEY CLUSTERED 
(
	[PromotionID] ASC,
	[AccoutID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [Promotion].[PromotionAccount]  WITH CHECK ADD  CONSTRAINT [FK_PromotionAccount_RetailPromotion] FOREIGN KEY([PromotionID])
REFERENCES [Promotion].[RetailPromotion] ([PromotionID])
GO

ALTER TABLE [Promotion].[PromotionAccount] CHECK CONSTRAINT [FK_PromotionAccount_RetailPromotion]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Account Promotion Table' , @level0type=N'SCHEMA',@level0name=N'Promotion', @level1type=N'TABLE',@level1name=N'PromotionAccount'
GO


