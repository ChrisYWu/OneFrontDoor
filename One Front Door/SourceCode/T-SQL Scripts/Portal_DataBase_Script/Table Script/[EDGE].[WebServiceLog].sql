USE [Portal_Data]
GO

/****** Object:  Table [EDGE].[WebServiceLog]    Script Date: 3/21/2013 4:18:29 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [EDGE].[WebServiceLog](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[ServiceName] [varchar](128) NOT NULL,
	[OperationName] [varchar](50) NOT NULL,
	[ValidationSuccessful] [bit] NOT NULL,
	[Detail] [varchar](500) NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[InternalReferecen] [varchar](50) NULL,
	[InternelReferenceType] [varchar](50) NULL,
	[ExternalReference] [varchar](50) NULL,
	[ExternalReferenceType] [varchar](50) NULL,
	[TestData] [bit] NULL,
 CONSTRAINT [PK_Validation] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [EDGE].[WebServiceLog] ADD  CONSTRAINT [DF_WebServiceLog_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO


