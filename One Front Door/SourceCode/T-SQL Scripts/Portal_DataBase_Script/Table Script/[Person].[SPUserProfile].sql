USE [Portal_Data]
GO

/****** Object:  Table [Person].[SPUserProfile]    Script Date: 3/21/2013 4:22:38 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Person].[SPUserProfile](
	[GSN] [varchar](50) NOT NULL,
	[PrimaryBranch] [varchar](500) NULL,
	[PrimaryRole] [varchar](500) NULL,
	[AdditionalRole] [varchar](5000) NULL,
	[PrimaryArea] [varchar](150) NULL,
	[PrimaryBU] [varchar](150) NULL,
	[AdditionalBranch] [varchar](5000) NULL,
	[KPI] [varchar](5000) NULL,
	[BranchBrand] [varchar](5000) NULL,
 CONSTRAINT [PK_SPUserProfile] PRIMARY KEY CLUSTERED 
(
	[GSN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [Person].[SPUserProfile]  WITH CHECK ADD  CONSTRAINT [FK_SPUserProfile_UserProfile] FOREIGN KEY([GSN])
REFERENCES [Person].[UserProfiles] ([GSN])
GO

ALTER TABLE [Person].[SPUserProfile] CHECK CONSTRAINT [FK_SPUserProfile_UserProfile]
GO


