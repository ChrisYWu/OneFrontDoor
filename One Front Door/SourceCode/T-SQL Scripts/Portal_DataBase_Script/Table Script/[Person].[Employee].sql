USE [Portal_Data]
GO

/****** Object:  Table [Person].[Employee]    Script Date: 3/21/2013 4:21:02 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Person].[Employee](
	[PersonID] [varchar](50) NOT NULL,
	[GSN] [varchar](50) NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[BranchID] [int] NULL,
	[Active] [bit] NULL,
	[RMEmployeeID] [varchar](12) NULL,
	[RoleID] [int] NULL,
	[RMLocationID] [int] NULL,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [Person].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Branch] FOREIGN KEY([BranchID])
REFERENCES [SAP].[Branch] ([BranchID])
GO

ALTER TABLE [Person].[Employee] CHECK CONSTRAINT [FK_Employee_Branch]
GO

ALTER TABLE [Person].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Role] FOREIGN KEY([RoleID])
REFERENCES [Person].[Role] ([RoleID])
GO

ALTER TABLE [Person].[Employee] CHECK CONSTRAINT [FK_Employee_Role]
GO


