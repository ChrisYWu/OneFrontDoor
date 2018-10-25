USE [Portal_Data]
GO

/****** Object:  Table [SAP].[Brand]    Script Date: 3/21/2013 4:53:30 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [SAP].[Brand](
	[BrandID] [int] IDENTITY(1,1) NOT NULL,
	[TrademarkID] [int] NOT NULL,
	[SAPBrandID] [varchar](50) NOT NULL,
	[BrandName] [varchar](128) NOT NULL,
 CONSTRAINT [PK_Brand] PRIMARY KEY CLUSTERED 
(
	[BrandID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [SAP].[Brand]  WITH CHECK ADD  CONSTRAINT [FK_Brand_TradeMark] FOREIGN KEY([TrademarkID])
REFERENCES [SAP].[TradeMark] ([TradeMarkID])
GO

ALTER TABLE [SAP].[Brand] CHECK CONSTRAINT [FK_Brand_TradeMark]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Brand Information from SAP' , @level0type=N'SCHEMA',@level0name=N'SAP', @level1type=N'TABLE',@level1name=N'Brand'
GO


