USE [Portal_Data]
GO

/****** Object:  Table [HRStaging].[ADExtractData]    Script Date: 3/21/2013 4:19:50 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [HRStaging].[ADExtractData](
	[EmpID] [varchar](50) NULL,
	[LastName] [varchar](150) NULL,
	[FirstName] [varchar](150) NULL,
	[Status] [varchar](50) NULL,
	[UserID] [varchar](150) NULL,
	[Band] [varchar](50) NULL,
	[LocationCode] [varchar](150) NULL,
	[Location] [varchar](150) NULL,
	[Adress] [varchar](500) NULL,
	[City] [varchar](250) NULL,
	[State] [varchar](150) NULL,
	[ZipCode] [varchar](150) NULL,
	[ManagerID] [varchar](50) NULL,
	[ManagerGSN] [varchar](50) NULL,
	[Title] [varchar](250) NULL,
	[Role] [varchar](150) NULL,
	[TermDate] [varchar](50) NULL,
	[HireDate] [varchar](50) NULL,
	[OrgUnit] [varchar](500) NULL,
	[CostCenter] [varchar](150) NULL,
	[JobCode] [varchar](150) NULL,
	[IsManager] [varchar](50) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


