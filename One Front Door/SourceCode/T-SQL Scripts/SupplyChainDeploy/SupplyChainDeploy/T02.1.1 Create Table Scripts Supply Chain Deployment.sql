use Portal_Data
Go

Print 'Creating Table [Person].[MyPlants]'
GO
/****** Object:  Table [Person].[MyPlants]    Script Date: 11/19/2014 12:54:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Person].[MyPlants](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SPUserProfileID] [int] NULL,
	[PlantID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
Print 'Creating Table [Person].[UserProductLine] '
GO
/****** Object:  Table [Person].[UserProductLine]    Script Date: 11/19/2014 12:54:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Person].[UserProductLine](
	[UserProductLineID] [int] IDENTITY(1,1) NOT NULL,
	[GSN] [varchar](50) NULL,
	[SPUserProfileID] [int] NULL,
	[ProductLineID] [int] NULL,
	[TradeMarkID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserProductLineID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO