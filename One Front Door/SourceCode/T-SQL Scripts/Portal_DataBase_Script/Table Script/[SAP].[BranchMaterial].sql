USE [Portal_Data]
GO

/****** Object:  Table [SAP].[BranchMaterial]    Script Date: 3/21/2013 4:52:37 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [SAP].[BranchMaterial](
	[BranchID] [int] NOT NULL,
	[MaterialID] [int] NOT NULL,
	[HandheldDesc] [varchar](50) NULL,
	[PrintoutDesc] [varchar](50) NULL,
 CONSTRAINT [PK_BranchMaterial] PRIMARY KEY CLUSTERED 
(
	[BranchID] ASC,
	[MaterialID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [SAP].[BranchMaterial]  WITH CHECK ADD  CONSTRAINT [FK_BranchMaterial_Branch] FOREIGN KEY([BranchID])
REFERENCES [SAP].[Branch] ([BranchID])
GO

ALTER TABLE [SAP].[BranchMaterial] CHECK CONSTRAINT [FK_BranchMaterial_Branch]
GO

ALTER TABLE [SAP].[BranchMaterial]  WITH CHECK ADD  CONSTRAINT [FK_BranchMaterial_Material] FOREIGN KEY([MaterialID])
REFERENCES [SAP].[Material] ([MaterialID])
GO

ALTER TABLE [SAP].[BranchMaterial] CHECK CONSTRAINT [FK_BranchMaterial_Material]
GO


