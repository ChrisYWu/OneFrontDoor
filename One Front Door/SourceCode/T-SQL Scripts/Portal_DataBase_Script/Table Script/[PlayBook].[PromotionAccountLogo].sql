USE [Portal_Data]
GO

/****** Object:  Table [PlayBook].[PromotionAccountLogo]    Script Date: 3/21/2013 4:26:28 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [PlayBook].[PromotionAccountLogo](
	[ImageID] [int] IDENTITY(1,1) NOT NULL,
	[AccountID] [varchar](120) NOT NULL,
	[Image] [image] NOT NULL,
 CONSTRAINT [pk_ImageID] PRIMARY KEY CLUSTERED 
(
	[ImageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


