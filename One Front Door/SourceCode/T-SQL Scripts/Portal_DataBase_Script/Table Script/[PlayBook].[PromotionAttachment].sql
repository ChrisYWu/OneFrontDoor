USE [Portal_Data]
GO

/****** Object:  Table [PlayBook].[PromotionAttachment]    Script Date: 3/21/2013 4:27:16 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [PlayBook].[PromotionAttachment](
	[AttachmentID] [int] NOT NULL,
	[PromotionId] [int] NOT NULL,
	[PromotionAttachmentName] [varchar](200) NULL,
 CONSTRAINT [PK_PromotionAttachment] PRIMARY KEY CLUSTERED 
(
	[AttachmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [PlayBook].[PromotionAttachment]  WITH CHECK ADD  CONSTRAINT [FK__Promotion__Promo__08012052] FOREIGN KEY([PromotionId])
REFERENCES [PlayBook].[RetailPromotion] ([PromotionID])
GO

ALTER TABLE [PlayBook].[PromotionAttachment] CHECK CONSTRAINT [FK__Promotion__Promo__08012052]
GO


