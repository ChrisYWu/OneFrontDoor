USE [Portal_Data]
GO

/****** Object:  Table [PlayBook].[PromotionCategory]    Script Date: 3/21/2013 4:28:57 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [PlayBook].[PromotionCategory](
	[PromotionCategoryID] [int] IDENTITY(1,1) NOT NULL,
	[PromotionCategory] [varchar](150) NOT NULL,
	[ShortPromotionCategory] [varchar](40) NULL,
 CONSTRAINT [pk_PromotionCategoryID] PRIMARY KEY CLUSTERED 
(
	[PromotionCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


