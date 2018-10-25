USE [Portal_Data]
GO

/****** Object:  Table [SAP].[Branch]    Script Date: 3/21/2013 4:51:33 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [SAP].[Branch](
	[BranchID] [int] IDENTITY(1,1) NOT NULL,
	[SAPBranchID] [varchar](50) NOT NULL,
	[BranchName] [varchar](50) NOT NULL,
	[AreaID] [int] NOT NULL,
	[RMLocationID] [int] NULL,
	[RMLocationCity] [varchar](50) NULL,
	[SPBranchName] [varchar](50) NULL,
 CONSTRAINT [PK_Branch] PRIMARY KEY CLUSTERED 
(
	[BranchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [SAP].[Branch]  WITH CHECK ADD  CONSTRAINT [FK_Branch_BusinessArea] FOREIGN KEY([AreaID])
REFERENCES [SAP].[BusinessArea] ([AreaID])
GO

ALTER TABLE [SAP].[Branch] CHECK CONSTRAINT [FK_Branch_BusinessArea]
GO


