USE [Portal_Data]
GO

/****** Object:  Table [PlayBook].[RetailPromotion]    Script Date: 3/21/2013 4:35:12 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [PlayBook].[RetailPromotion](
	[PromotionID] [int] IDENTITY(1,1) NOT NULL,
	[PromotionName] [varchar](180) NOT NULL,
	[PromotionDescription] [varchar](200) NULL,
	[PromotionTypeID] [int] NULL,
	[PromotionPrice] [varchar](150) NULL,
	[PromotionCategoryID] [int] NULL,
	[PromotionDisplayLocationID] [int] NULL,
	[PromotionStatusID] [int] NULL,
	[CorporatePriorityID] [int] NULL,
	[PromotionStartDate] [datetime] NULL,
	[PromotionEndDate] [datetime] NULL,
	[ParentPromotionID] [int] NULL,
	[CreatedBY] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBY] [varchar](155) NULL,
	[ModifiedDate] [datetime] NULL,
	[ItemID] [int] NULL,
 CONSTRAINT [PK__RetailPr__52C42F2FE4A83A19] PRIMARY KEY CLUSTERED 
(
	[PromotionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [PlayBook].[RetailPromotion]  WITH CHECK ADD FOREIGN KEY([ItemID])
REFERENCES [EDGE].[RPLItem] ([ItemID])
GO

ALTER TABLE [PlayBook].[RetailPromotion]  WITH CHECK ADD  CONSTRAINT [FK__RetailPro__Promo__7D8391DF] FOREIGN KEY([PromotionStatusID])
REFERENCES [PlayBook].[PromotionStatus] ([PromotionStatusID])
GO

ALTER TABLE [PlayBook].[RetailPromotion] CHECK CONSTRAINT [FK__RetailPro__Promo__7D8391DF]
GO

ALTER TABLE [PlayBook].[RetailPromotion]  WITH CHECK ADD  CONSTRAINT [FK__RetailPro__Promo__7E77B618] FOREIGN KEY([PromotionTypeID])
REFERENCES [PlayBook].[PromotionType] ([PromotionTypeID])
GO

ALTER TABLE [PlayBook].[RetailPromotion] CHECK CONSTRAINT [FK__RetailPro__Promo__7E77B618]
GO

ALTER TABLE [PlayBook].[RetailPromotion]  WITH CHECK ADD  CONSTRAINT [FK_RetailPromotion_CorporatePriority] FOREIGN KEY([CorporatePriorityID])
REFERENCES [dbo].[CorporatePriority] ([CorporatePriorityID])
GO

ALTER TABLE [PlayBook].[RetailPromotion] CHECK CONSTRAINT [FK_RetailPromotion_CorporatePriority]
GO

ALTER TABLE [PlayBook].[RetailPromotion]  WITH CHECK ADD  CONSTRAINT [FK_RetailPromotion_Employee] FOREIGN KEY([CreatedBY])
REFERENCES [Person].[Employee] ([PersonID])
GO

ALTER TABLE [PlayBook].[RetailPromotion] CHECK CONSTRAINT [FK_RetailPromotion_Employee]
GO

ALTER TABLE [PlayBook].[RetailPromotion]  WITH CHECK ADD  CONSTRAINT [FK_RetailPromotion_PromotionCategory] FOREIGN KEY([PromotionCategoryID])
REFERENCES [PlayBook].[PromotionCategory] ([PromotionCategoryID])
GO

ALTER TABLE [PlayBook].[RetailPromotion] CHECK CONSTRAINT [FK_RetailPromotion_PromotionCategory]
GO

ALTER TABLE [PlayBook].[RetailPromotion]  WITH CHECK ADD  CONSTRAINT [FK_RetailPromotion_PromotionDisplayLocation] FOREIGN KEY([PromotionDisplayLocationID])
REFERENCES [PlayBook].[PromotionDisplayLocation] ([PromotionDisplayLocationId])
GO

ALTER TABLE [PlayBook].[RetailPromotion] CHECK CONSTRAINT [FK_RetailPromotion_PromotionDisplayLocation]
GO


