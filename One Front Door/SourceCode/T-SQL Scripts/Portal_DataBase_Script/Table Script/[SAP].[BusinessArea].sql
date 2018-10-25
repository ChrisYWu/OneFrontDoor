USE [Portal_Data]
GO

/****** Object:  Table [SAP].[BusinessArea]    Script Date: 3/21/2013 4:54:17 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [SAP].[BusinessArea](
	[AreaID] [int] IDENTITY(1,1) NOT NULL,
	[SAPAreaID] [varchar](50) NOT NULL,
	[AreaName] [nvarchar](50) NOT NULL,
	[BUID] [int] NOT NULL,
	[SPAreaName] [varchar](50) NULL,
 CONSTRAINT [PK_BusinessArea] PRIMARY KEY CLUSTERED 
(
	[AreaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [SAP].[BusinessArea]  WITH CHECK ADD  CONSTRAINT [FK_BusinessArea_BusinessUnit] FOREIGN KEY([BUID])
REFERENCES [SAP].[BusinessUnit] ([BUID])
GO

ALTER TABLE [SAP].[BusinessArea] CHECK CONSTRAINT [FK_BusinessArea_BusinessUnit]
GO


