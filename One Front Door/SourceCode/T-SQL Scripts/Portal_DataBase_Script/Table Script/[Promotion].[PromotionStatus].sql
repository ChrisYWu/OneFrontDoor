USE [Portal_Data]
GO

/****** Object:  Table [Promotion].[PromotionStatus]    Script Date: 3/21/2013 4:46:52 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Promotion].[PromotionStatus](
	[Status] [varchar](50) NOT NULL,
 CONSTRAINT [PK_PromotionStatus] PRIMARY KEY CLUSTERED 
(
	[Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


