USE [Portal_Data]
GO

/****** Object:  Table [Promotion].[RetailPromotion]    Script Date: 3/21/2013 4:48:33 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Promotion].[RetailPromotion](
	[PromotionID] [int] IDENTITY(1,1) NOT NULL,
	[PromotionName] [varchar](255) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[Status] [varchar](50) NULL,
	[PromotContentID] [varchar](210) NOT NULL,
 CONSTRAINT [PK_RetailPromotion] PRIMARY KEY CLUSTERED 
(
	[PromotionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [Promotion].[RetailPromotion]  WITH CHECK ADD  CONSTRAINT [FK_RetailPromotion_PromotionStatus] FOREIGN KEY([Status])
REFERENCES [Promotion].[PromotionStatus] ([Status])
GO

ALTER TABLE [Promotion].[RetailPromotion] CHECK CONSTRAINT [FK_RetailPromotion_PromotionStatus]
GO


