USE [Portal_Data]
GO

/****** Object:  Table [Person].[UserInRole]    Script Date: 3/21/2013 4:24:00 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Person].[UserInRole](
	[UserRoleID] [int] IDENTITY(1,1) NOT NULL,
	[GSN] [varchar](50) NOT NULL,
	[RoleID] [int] NOT NULL,
	[IsPrimary] [bit] NOT NULL,
 CONSTRAINT [PK_UserInRole] PRIMARY KEY CLUSTERED 
(
	[UserRoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [Person].[UserInRole]  WITH CHECK ADD  CONSTRAINT [FK_UserInRole_Role] FOREIGN KEY([RoleID])
REFERENCES [Person].[Role] ([RoleID])
GO

ALTER TABLE [Person].[UserInRole] CHECK CONSTRAINT [FK_UserInRole_Role]
GO

ALTER TABLE [Person].[UserInRole]  WITH CHECK ADD  CONSTRAINT [FK_UserInRole_UserProfile] FOREIGN KEY([GSN])
REFERENCES [Person].[UserProfiles] ([GSN])
GO

ALTER TABLE [Person].[UserInRole] CHECK CONSTRAINT [FK_UserInRole_UserProfile]
GO


