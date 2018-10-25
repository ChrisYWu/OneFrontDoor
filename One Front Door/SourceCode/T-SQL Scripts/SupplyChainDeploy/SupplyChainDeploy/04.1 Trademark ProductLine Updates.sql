use Portal_Data
Go

Print 'Creating Table [SAP].[ProductLine] '
Go
/****** Object:  Table [SAP].[ProductLine]    Script Date: 11/19/2014 12:54:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SAP].[ProductLine](
                [ProductLineID] [int] NOT NULL,
                [ProductLineName] [varchar](20) NOT NULL,
                [ProductLineDesc] [varchar](50) NOT NULL,
                [SortOrder] [tinyint] NULL,
CONSTRAINT [PK_ProductLine] PRIMARY KEY CLUSTERED 
(
                [ProductLineID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO


Print 'Insert Data Into Product Line Table'
GO
SET ANSI_PADDING OFF
GO
INSERT [SAP].[ProductLine] ([ProductLineID], [ProductLineName], [ProductLineDesc], [SortOrder]) VALUES (2, N'Allied', N'Allied', 3)
GO
INSERT [SAP].[ProductLine] ([ProductLineID], [ProductLineName], [ProductLineDesc], [SortOrder]) VALUES (3, N'CSD', N'CSD', 1)
GO
INSERT [SAP].[ProductLine] ([ProductLineID], [ProductLineName], [ProductLineDesc], [SortOrder]) VALUES (4, N'IPP', N'IPP', 2)
GO

--SAP.Trademark 
PRINT N'Altering [SAP].[TradeMark]...';
GO
ALTER TABLE [SAP].[TradeMark]
    ADD [ProductLineID]   INT           NULL,
        [ImageID]         INT           NULL
GO

----------------------
Update SAP.TradeMark
Set ProductLineID = (Select top 1 ProductLineID from SAP.ProductLine Where [ProductLineName] = 'IPP')
--Select * from SAP.TradeMark
Where  TradeMarkName in (
'CLAMATO',
'HAWAIIAN PUNCH',
'MISTIC',
'MOTTS',
'NANTUCKET NECTARS',
'ORANGINA',
'REALEMON',
'SNAPPLE',
'STEWARTS',
'VENOM ENERGY',
'YOO-HOO'

)

Update SAP.TradeMark
Set ProductLineID = (Select top 1 ProductLineID from SAP.ProductLine Where [ProductLineName] = 'Allied')
--Select * from SAP.TradeMark
Where  ProductLineID is null and TradeMarkName in (
'7UP',
'A&W',
'ACQUA PANNA',
'ADINA',
'AIR WATER',
'ALL SPORT',
'APPLE & EVE',
'AQUA VISTA',
'ARIZONA',
'ARROWHEAD',
'BAD BOY',
'BADGER MAX',
'BAI',
'BAWLS',
'BIG RED',
'BLOOM',
'BODYARMOR',
'BOO KOO',
'CABANA',
'CANADA DRY',
'CAPITOL',
'CELSIUS',
'CHEERWINE',
'CHIPPEWA',
'CINNABON',
'CLAMATO',
'CLEARLY CANADIAN',
'CLEARWATER SPRINGS',
'COFFEEMATE',
'COKE',
'COMMON CENTS',
'COOL JAVA',
'COTTON CLUB',
'CRUNK',
'CRUSH',
'CRYSTAL CASCADE',
'CRYSTAL GEYSER',
'DIET RITE',
'DR BROWNS',
'DR ENUF',
'DR PEPPER',
'EARTH 2 O',
'EDEN',
'ELK RIVER',
'FIJI',
'FLORIDAS NATURAL',
'FRANKS ENERGY',
'FRUTAZZA',
'FUZE',
'GATORADE',
'GO FAST',
'GO GIRL',
'HANSENS',
'HAWAIIAN PUNCH',
'HERSHEY',
'HIRES',
'HOG WASH',
'HYDRIVE',
'JARRITOS',
'JOLT',
'JONES SODA',
'JUICE TYME',
'KING COLA',
'KJ SPRINGWATER',
'LA CROIX',
'LIFE FORCE',
'LIQUID ICE',
'MAGIC MIXER',
'MARGARITAVILLE',
'MELLOW',
'MISTIC',
'MOTTS',
'MOUNTAIN DEW',
'MOUNTAIN RUSH',
'MR & MRS T',
'NANTUCKET NECTARS',
'NATURE TREE',
'NEHI',
'NESQUIK',
'NESTLE',
'NEURO',
'NIRVANA',
'NOAHS WATER',
'NON-BRANDED',
'NON-PRODUCT',
'O WATER',
'OASIS',
'OH YEAH',
'OL GLORY',
'ORANGINA',
'PARROT',
'PENAFIEL',
'PENNSYLVANIA DUTCH',
'PEPSI',
'PERRIER',
'POLAND SPRINGS',
'POPCHIPS',
'RAILROAD',
'RANIER ICE',
'RC COLA',
'RED JAK',
'ROCKSTAR',
'ROSES',
'RUSH ENERGY',
'SAN PELLEGRINO',
'SBI LIQUID ENERGIZER',
'SCHWEPPES',
'SEAGRAMS',
'SKINNY WATER',
'SNAPPLE',
'SOBE',
'SPARKLING FRUIT 2-0',
'SQUIRT',
'STEWARTS',
'STOP & GO',
'SUN PLUS',
'SUNDROP',
'SUNKIST',
'SUNNY DELIGHT',
'SWITCH',
'TALKING RAIN',
'TAP JUICES',
'TOMMY TUCKER',
'TREE TOP',
'VARIETY PACK',
'VENOM ENERGY',
'VERNORS',
'VERYFINE',
'VITA COCO',
'WELCHS',
'XCAFE',
'YOO-HOO'
)

Update SAP.TradeMark
Set ProductLineID = (Select top 1 ProductLineID from SAP.ProductLine Where [ProductLineName] = 'CSD')
Where ProductLineID is null
Go

Alter Table SAP.Material
Add SupplyChainProductSK int null
Go
