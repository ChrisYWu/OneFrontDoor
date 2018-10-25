USE [Portal_Data]
GO

/****** Object:  Table [PlayBook].[PromotionLatestUpdate]    Script Date: 3/21/2013 4:30:56 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [PlayBook].[PromotionLatestUpdate](
	[ItemID] [int] NOT NULL,
	[PromotionId] [int] NOT NULL,
	[UpdatedField] [varchar](120) NULL,
	[UpdatedFieldValue] [varchar](120) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_PromotionLatestUpdate] PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [PlayBook].[PromotionLatestUpdate]  WITH CHECK ADD  CONSTRAINT [FK__Promotion__Creat__09E968C4] FOREIGN KEY([PromotionId])
REFERENCES [PlayBook].[RetailPromotion] ([PromotionID])
GO

ALTER TABLE [PlayBook].[PromotionLatestUpdate] CHECK CONSTRAINT [FK__Promotion__Creat__09E968C4]
GO


