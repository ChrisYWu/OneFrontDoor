USE [Portal_Data]
GO

/****** Object:  Table [EDGE].[Users]    Script Date: 3/21/2013 4:17:44 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EDGE].[Users](
	[UserId] [nvarchar](50) NOT NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[EDGEEmail] [nvarchar](50) NULL,
	[Company] [nvarchar](150) NULL,
	[Title] [nvarchar](150) NULL,
	[CreateDate] [nvarchar](50) NULL,
	[ModifyDate] [nvarchar](50) NULL,
	[Deleted] [nchar](10) NULL,
	[USUserGroup] [nvarchar](50) NULL,
	[CAUserGroup] [nvarchar](50) NULL,
	[Status] [nvarchar](50) NULL,
	[UserLevel] [nvarchar](50) NULL,
	[LastLogin] [nvarchar](50) NULL,
	[DPSGUserID] [nvarchar](50) NULL,
	[DPSGUserEmail] [nvarchar](50) NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


