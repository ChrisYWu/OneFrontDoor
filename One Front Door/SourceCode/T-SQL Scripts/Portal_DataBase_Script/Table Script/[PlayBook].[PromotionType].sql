USE [Portal_Data]
GO

/****** Object:  Table [PlayBook].[PromotionType]    Script Date: 3/21/2013 4:33:33 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [PlayBook].[PromotionType](
	[PromotionTypeID] [int] IDENTITY(1,1) NOT NULL,
	[PromotionType] [varchar](185) NOT NULL,
 CONSTRAINT [pk_PromotionTypeID] PRIMARY KEY CLUSTERED 
(
	[PromotionTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


