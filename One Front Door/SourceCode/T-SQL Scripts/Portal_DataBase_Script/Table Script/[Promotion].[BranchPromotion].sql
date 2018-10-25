USE [Portal_Data]
GO

/****** Object:  Table [Promotion].[BranchPromotion]    Script Date: 3/21/2013 4:37:04 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Promotion].[BranchPromotion](
	[PromotionID] [int] NOT NULL,
	[BranchID] [int] NOT NULL,
	[ParentPromotionID] [int] NULL,
 CONSTRAINT [PK_BranchPromotion] PRIMARY KEY CLUSTERED 
(
	[PromotionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [Promotion].[BranchPromotion]  WITH CHECK ADD  CONSTRAINT [FK_BranchPromotion_AreaPromotion] FOREIGN KEY([ParentPromotionID])
REFERENCES [Promotion].[AreaPromotion] ([PromotionID])
GO

ALTER TABLE [Promotion].[BranchPromotion] CHECK CONSTRAINT [FK_BranchPromotion_AreaPromotion]
GO

ALTER TABLE [Promotion].[BranchPromotion]  WITH CHECK ADD  CONSTRAINT [FK_BranchPromotion_Branch] FOREIGN KEY([BranchID])
REFERENCES [SAP].[Branch] ([BranchID])
GO

ALTER TABLE [Promotion].[BranchPromotion] CHECK CONSTRAINT [FK_BranchPromotion_Branch]
GO

ALTER TABLE [Promotion].[BranchPromotion]  WITH CHECK ADD  CONSTRAINT [FK_BranchPromotion_RetailPromotion] FOREIGN KEY([PromotionID])
REFERENCES [Promotion].[RetailPromotion] ([PromotionID])
GO

ALTER TABLE [Promotion].[BranchPromotion] CHECK CONSTRAINT [FK_BranchPromotion_RetailPromotion]
GO


