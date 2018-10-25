USE [Portal_Data]
GO

/****** Object:  Table [BWStaging].[Account]    Script Date: 3/21/2013 3:55:58 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [BWStaging].[Account](
	[CUSTOMER_NUMBER] [bigint] NULL,
	[LOCATION_ID] [varchar](16) NULL,
	[START_DATE] [smalldatetime] NULL,
	[CUSTOMER_NAME] [varchar](128) NULL,
	[CUSTOMER_STREET] [varchar](128) NULL,
	[CITY] [varchar](50) NULL,
	[STATE] [varchar](20) NULL,
	[POSTAL_CODE] [varchar](12) NULL,
	[CONTACT_PERSON] [varchar](50) NULL,
	[PHONE_NUMBER] [varchar](50) NULL,
	[LOCAL_CHAIN] [int] NULL,
	[CHANNEL] [int] NULL,
	[ACTIVE] [bit] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


