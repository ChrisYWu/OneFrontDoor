USE [Portal_Data]
GO

/****** Object:  Table [Promotion].[BusinessUnitPromotion]    Script Date: 3/21/2013 4:37:52 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Promotion].[BusinessUnitPromotion](
	[PromotionID] [int] NOT NULL,
	[BUID] [int] NOT NULL,
	[NationaltPromotionID] [int] NULL,
 CONSTRAINT [PK_BusinessUnitPromotion] PRIMARY KEY CLUSTERED 
(
	[PromotionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [Promotion].[BusinessUnitPromotion]  WITH CHECK ADD  CONSTRAINT [FK_BusinessUnitPromotion_BusinessUnit] FOREIGN KEY([BUID])
REFERENCES [SAP].[BusinessUnit] ([BUID])
GO

ALTER TABLE [Promotion].[BusinessUnitPromotion] CHECK CONSTRAINT [FK_BusinessUnitPromotion_BusinessUnit]
GO

ALTER TABLE [Promotion].[BusinessUnitPromotion]  WITH CHECK ADD  CONSTRAINT [FK_BusinessUnitPromotion_NationalPromotion] FOREIGN KEY([NationaltPromotionID])
REFERENCES [Promotion].[NationalPromotion] ([PromotionID])
GO

ALTER TABLE [Promotion].[BusinessUnitPromotion] CHECK CONSTRAINT [FK_BusinessUnitPromotion_NationalPromotion]
GO

ALTER TABLE [Promotion].[BusinessUnitPromotion]  WITH CHECK ADD  CONSTRAINT [FK_BusinessUnitPromotion_RetailPromotion] FOREIGN KEY([PromotionID])
REFERENCES [Promotion].[RetailPromotion] ([PromotionID])
GO

ALTER TABLE [Promotion].[BusinessUnitPromotion] CHECK CONSTRAINT [FK_BusinessUnitPromotion_RetailPromotion]
GO


