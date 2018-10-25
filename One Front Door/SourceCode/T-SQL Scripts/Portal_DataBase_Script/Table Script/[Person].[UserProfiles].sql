USE [Portal_Data]
GO

/****** Object:  Table [Person].[UserProfiles]    Script Date: 3/21/2013 4:24:56 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Person].[UserProfiles](
	[GSN] [varchar](50) NOT NULL,
	[BUID] [int] NOT NULL,
	[AreaID] [int] NOT NULL,
	[PrimaryBranchID] [int] NOT NULL,
	[ProfitCenterID] [int] NOT NULL,
	[CostCenterID] [int] NOT NULL,
	[FirstName] [nchar](128) NULL,
	[LastName] [varchar](128) NULL,
	[EmpID] [int] NULL,
 CONSTRAINT [PK_UserProfile] PRIMARY KEY CLUSTERED 
(
	[GSN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


