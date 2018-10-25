USE [Portal_Data]
GO

/****** Object:  Table [PlayBook].[PromotionStatus]    Script Date: 3/21/2013 4:32:47 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [PlayBook].[PromotionStatus](
	[PromotionStatusID] [int] IDENTITY(1,1) NOT NULL,
	[PromotionStatus] [varchar](110) NOT NULL,
	[IsActive] [char](1) NOT NULL,
 CONSTRAINT [pk_PromotionStatusID] PRIMARY KEY CLUSTERED 
(
	[PromotionStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [PlayBook].[PromotionStatus] ADD  DEFAULT ('Y') FOR [IsActive]
GO


