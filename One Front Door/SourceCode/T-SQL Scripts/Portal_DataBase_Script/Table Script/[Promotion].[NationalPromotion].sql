USE [Portal_Data]
GO

/****** Object:  Table [Promotion].[NationalPromotion]    Script Date: 3/21/2013 4:38:46 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Promotion].[NationalPromotion](
	[PromotionID] [int] NOT NULL,
	[NAE] [varchar](50) NOT NULL,
	[Director] [nchar](10) NOT NULL,
	[VP] [nchar](10) NOT NULL,
	[BottlerInfo] [varchar](50) NULL,
	[CostPerStore] [bit] NOT NULL,
	[IdentifyIncrementalBottlerLMFCost] [varchar](50) NULL,
	[EverydayRetail] [varchar](50) NULL,
	[PromotionalRetail] [varchar](50) NULL,
	[ProgramDetails] [nchar](10) NULL,
	[BottlerCommitment] [nchar](10) NULL,
	[AdditionalComments] [nchar](10) NULL,
	[NationalPromotionId] [int] NULL,
 CONSTRAINT [PK_NationalPromotion] PRIMARY KEY CLUSTERED 
(
	[PromotionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [Promotion].[NationalPromotion]  WITH CHECK ADD  CONSTRAINT [FK_NationalPromotion_RetailPromotion] FOREIGN KEY([PromotionID])
REFERENCES [Promotion].[RetailPromotion] ([PromotionID])
GO

ALTER TABLE [Promotion].[NationalPromotion] CHECK CONSTRAINT [FK_NationalPromotion_RetailPromotion]
GO


