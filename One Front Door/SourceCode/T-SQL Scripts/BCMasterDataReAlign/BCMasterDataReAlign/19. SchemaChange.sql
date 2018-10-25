use Portal_Data
Go

Alter Table BC.TerritoryMap
Add ValidFrom DateTime2(7) Default '1970-1-1' Not Null

Alter Table BC.TerritoryMap
Add ValidTo DateTime2(7) Default '1970-1-1' Not Null
Go

Alter Table BC.AccountInclusion
Add ValidFrom DateTime2(7) Default '1970-1-1' Not Null
Go

Alter Table BC.AccountInclusion
Add ValidTo DateTime2(7) Default '1970-1-1' Not Null
Go

ALTER TABLE [BC].[TerritoryMap] DROP CONSTRAINT [FK_TerritoryMap_TradeMark]
GO

ALTER TABLE [BC].[TerritoryMap] DROP CONSTRAINT [FK_TerritoryMap_TerritoryType]
GO

ALTER TABLE [BC].[TerritoryMap] DROP CONSTRAINT [FK_TerritoryMap_ProductType]
GO

ALTER TABLE [BC].[TerritoryMap] DROP CONSTRAINT [FK_TerritoryMap_County]
GO

ALTER TABLE [BC].[TerritoryMap] DROP CONSTRAINT [FK_TerritoryMap_Bottler]
GO

ALTER TABLE [BC].[TerritoryMap] DROP CONSTRAINT [DF__Territory__Valid__57EBF18F]
GO

ALTER TABLE [BC].[TerritoryMap] DROP CONSTRAINT [DF__Territory__Valid__56F7CD56]
GO

/****** Object:  Table [BC].[TerritoryMap]    Script Date: 7/1/2015 1:10:25 PM ******/
DROP TABLE [BC].[TerritoryMap]
GO

/****** Object:  Table [BC].[TerritoryMap]    Script Date: 7/1/2015 1:10:25 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [BC].[TerritoryMap](
	[TradeMarkID] [int] NOT NULL,
	[ProductTypeID] [int] NOT NULL,
	[TerritoryTypeID] [int] NOT NULL,
	[CountyID] [int] NOT NULL,
	[PostalCode] [varchar](10) NOT NULL,
	[BottlerID] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_TerritoryMap] PRIMARY KEY CLUSTERED 
(
	[TradeMarkID] ASC,
	[ProductTypeID] ASC,
	[TerritoryTypeID] ASC,
	[CountyID] ASC,
	[PostalCode] ASC,
	[BottlerID] ASC,
	[ValidFrom] ASC,
	[ValidTo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [BC].[TerritoryMap] ADD  DEFAULT ('1970-1-1') FOR [ValidFrom]
GO

ALTER TABLE [BC].[TerritoryMap] ADD  DEFAULT ('1970-1-1') FOR [ValidTo]
GO

ALTER TABLE [BC].[TerritoryMap]  WITH CHECK ADD  CONSTRAINT [FK_TerritoryMap_Bottler] FOREIGN KEY([BottlerID])
REFERENCES [BC].[Bottler] ([BottlerID])
GO

ALTER TABLE [BC].[TerritoryMap] CHECK CONSTRAINT [FK_TerritoryMap_Bottler]
GO

ALTER TABLE [BC].[TerritoryMap]  WITH CHECK ADD  CONSTRAINT [FK_TerritoryMap_County] FOREIGN KEY([CountyID])
REFERENCES [Shared].[County] ([CountyID])
GO

ALTER TABLE [BC].[TerritoryMap] CHECK CONSTRAINT [FK_TerritoryMap_County]
GO

ALTER TABLE [BC].[TerritoryMap]  WITH CHECK ADD  CONSTRAINT [FK_TerritoryMap_ProductType] FOREIGN KEY([ProductTypeID])
REFERENCES [BC].[ProductType] ([ProductTypeID])
GO

ALTER TABLE [BC].[TerritoryMap] CHECK CONSTRAINT [FK_TerritoryMap_ProductType]
GO

ALTER TABLE [BC].[TerritoryMap]  WITH CHECK ADD  CONSTRAINT [FK_TerritoryMap_TerritoryType] FOREIGN KEY([TerritoryTypeID])
REFERENCES [BC].[TerritoryType] ([TerritoryTypeID])
GO

ALTER TABLE [BC].[TerritoryMap] CHECK CONSTRAINT [FK_TerritoryMap_TerritoryType]
GO

ALTER TABLE [BC].[TerritoryMap]  WITH CHECK ADD  CONSTRAINT [FK_TerritoryMap_TradeMark] FOREIGN KEY([TradeMarkID])
REFERENCES [SAP].[TradeMark] ([TradeMarkID])
GO

ALTER TABLE [BC].[TerritoryMap] CHECK CONSTRAINT [FK_TerritoryMap_TradeMark]
GO






