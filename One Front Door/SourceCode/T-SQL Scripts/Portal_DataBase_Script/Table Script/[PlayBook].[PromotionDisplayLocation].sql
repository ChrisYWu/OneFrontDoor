USE [Portal_Data]
GO

/****** Object:  Table [PlayBook].[PromotionDisplayLocation]    Script Date: 3/21/2013 4:29:57 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [PlayBook].[PromotionDisplayLocation](
	[PromotionDisplayLocationId] [int] IDENTITY(1,1) NOT NULL,
	[PromotionDisplayLocation] [varchar](200) NOT NULL,
 CONSTRAINT [pk_PromotionDisplayLocationId] PRIMARY KEY CLUSTERED 
(
	[PromotionDisplayLocationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


