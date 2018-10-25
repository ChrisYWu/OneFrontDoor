USE [Portal_Data805]
GO

/****** Object:  Table [BCMyday].[PromotionRequestLog]    Script Date: 9/9/2015 1:14:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Playbook].[PromotionRequestLog](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[LogDate]  AS (CONVERT([date],[StartDate])),
	[Duration]  AS (datediff(millisecond,[StartDate],[EndDate])),
	[GSN] [varchar](50) NOT NULL,
	[PromotionStartDate] [datetime] NULL,
	[PromotionEndDate] [datetime] NULL,
	[StartDate] [datetime2](7) NOT NULL,
	[EndDate] [datetime2](7) NULL,
	[NumberOfPromotion] [int] NULL,
	[NumberOfCurrentPromotion] [int] NULL,
	[NumberOfBranch] [int] NULL,
 CONSTRAINT [PK_DSDPromotionRequestLog] PRIMARY KEY CLUSTERED 
(
	[StartDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


