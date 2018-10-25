use Portal_Data_INT
Go

/*
---- Deployment log ----
1. to 108 20151026
2. Developed from BSCCAP108 since 11/2/2015

*/
------------------------------------------------
If Not Exists (Select *
	From sys.schemas
	Where name = 'PreCal')
Begin
	Execute('Create Schema PreCal')
	Print 'Schema PreCal created'
End
Go
--##############################################
------------------------------------------------
If Exists (
	Select *
	From Sys.Tables t Join sys.schemas s on t.schema_id = s.schema_id
	Where t.Name = 'PromotionBranch' and s.name = 'Playbook')
Begin
	Drop Table Playbook.PromotionBranch
End
Go

If Exists (
	Select *
	From Sys.Tables t Join sys.schemas s on t.schema_id = s.schema_id
	Where t.Name = 'PromotionBranch' and s.name = 'PreCal')
Begin
	Drop Table PreCal.PromotionBranch
End
Go

CREATE TABLE PreCal.PromotionBranch (
	[PromotionID] [int] NOT NULL,
	[BranchID] [int] NOT NULL,
	PromotionStartDate Date,
	PromotionEndDate Date,
	IsPromotion Bit,
	PromotionGroupID int
 CONSTRAINT [PK_PromotionBranch] PRIMARY KEY CLUSTERED 
(
	[BranchID] ASC,
	[PromotionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

Go

CREATE NONCLUSTERED INDEX [NCI-PromotionBranch-Dates] ON PreCal.[PromotionBranch]
(
	[PromotionStartDate] ASC,
	[PromotionEndDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [NCI-PromotionBranch-IsPromotion] ON PreCal.[PromotionBranch]
(
	IsPromotion ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [NCI-PromotionBranch-PromotionGroupID] ON PreCal.[PromotionBranch]
(
	PromotionGroupID ASC
) Include (PromotionID) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

Print 'Table PreCal.PromotionBranch created'
Go

--##############################################
------------------------------------------------
If Exists (
	Select *
	From Sys.Tables
	Where object_id = object_id('PreCal.PromotionBranchChainGroup'))
Begin
	Drop Table PreCal.PromotionBranchChainGroup
End
Go

CREATE TABLE PreCal.PromotionBranchChainGroup (
	[PromotionID] [int] NOT NULL,
	[BranchID] [int] NOT NULL,
	ChainGroupID varchar(20) not null,
	PromotionStartDate Date not null,
	PromotionEndDate Date not null,
	IsPromotion Bit not null,
 CONSTRAINT [PK_PromotionBranchChainGroup] PRIMARY KEY CLUSTERED 
(
	[BranchID] ASC,
	[PromotionID] ASC,
	[ChainGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

Go

CREATE NONCLUSTERED INDEX [NCI-PromotionBranchChainGroup-Dates] ON PreCal.[PromotionBranchChainGroup]
(
	[PromotionStartDate] ASC,
	[PromotionEndDate] ASC
) Include (ChainGroupID) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [NCI-PromotionBranchChainGroup-IsPromotion] ON PreCal.[PromotionBranchChainGroup]
(
	IsPromotion ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

Print 'Table PreCal.PromotionBranchChainGroup created'
Go

--##############################################
------------------------------------------------
If Exists (
	Select *
	From Sys.Tables t Join sys.schemas s on t.schema_id = s.schema_id
	Where t.Name = 'BranchChannel' and s.name = 'PreCal')
Begin
	Drop Table PreCal.BranchChannel
End
Go

CREATE TABLE PreCal.BranchChannel (
	BranchID [int] NOT NULL,
	ChannelID [int] NOT NULL
 CONSTRAINT [PK_BranchChannel] PRIMARY KEY CLUSTERED 
(
	BranchID ASC,
	ChannelID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

Go

Print 'Table PreCal.BranchChannel created'
Go

--##############################################
------------------------------------------------
If Exists (
	Select *
	From Sys.Tables t Join sys.schemas s on t.schema_id = s.schema_id
	Where t.Name = 'PromotionLocalChain' and s.name = 'PreCal')
Begin
	Drop Table PreCal.PromotionLocalChain
End
Go

CREATE TABLE PreCal.PromotionLocalChain (
	LocalChainID [int] NOT NULL,
	[PromotionID] [int] NOT NULL,
	PromotionStartDate Date,
	PromotionEndDate Date,
	IsPromotion Bit
 CONSTRAINT [PK_PromotionLocalChain] PRIMARY KEY CLUSTERED 
(
	LocalChainID ASC,
	[PromotionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

Go

Print 'Table PreCal.PromotionLocalChain created'
Go

--##############################################
------------------------------------------------
If Exists (Select * From sys.tables Where Object_id = Object_ID('Processing.tBottlerForSeeking'))
Begin
	Drop Table Processing.tBottlerForSeeking
End
Go

If Exists (Select * From sys.tables Where Object_id = Object_ID('Precal.BottlerHier'))
Begin
	Drop Table Precal.BottlerHier
End
Go

Create Table Precal.BottlerHier
(
	BottlerID int Not Null,
	RegionID int Not Null, 
	DivisionID int Not Null, 
	ZoneID int Not Null, 		 
	SystemID int Not Null, 
)
Go

ALTER TABLE Precal.BottlerHier ADD  CONSTRAINT [PK_BottlerHier] PRIMARY KEY CLUSTERED 
(
	[BottlerID] ASC
)
GO

CREATE NONCLUSTERED INDEX [NCI-BCBottler-Region] ON Precal.BottlerHier
(
	SystemID ASC, ZoneID ASC, DivisionID ASC, RegionID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [NCI-BCBottler-System] ON Precal.BottlerHier
(
	SystemID ASC
) INCLUDE ([BottlerID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [NCI-BCBottler-Zone] ON Precal.BottlerHier
(
	ZoneID ASC
) INCLUDE ([BottlerID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [NCI-BCBottler-Division] ON Precal.BottlerHier
(
	DivisionID ASC
) INCLUDE ([BottlerID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [NCI-BCBottler-Region-Bottler] ON Precal.BottlerHier
(
	RegionID ASC
) INCLUDE ([BottlerID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

Print 'Table PreCal.BottlerHier created'
Go

--##############################################
------------------------------------------------
If Exists (Select * From sys.tables Where Object_id = Object_ID('Processing.tBottlerStateMapping'))
Begin
	Drop Table Processing.tBottlerStateMapping
End
Go

If Exists (Select * From sys.tables Where Object_id = Object_ID('PreCal.BottlerState'))
Begin
	Drop Table PreCal.BottlerState
End
Go

Create Table PreCal.BottlerState
(
	BottlerID int Not Null, 
	StateRegionID int not null
)
Go

ALTER TABLE PreCal.BottlerState ADD  CONSTRAINT [PK_BottlerState] PRIMARY KEY CLUSTERED 
(
	StateRegionID ASC, BottlerID ASC
)
GO

Print 'Table PreCal.BottlerState created'
Go

--##############################################
------------------------------------------------
If Exists (Select * From sys.tables Where Object_id = Object_ID('Processing.tBranchStateMapping'))
Begin
	Drop Table Processing.tBranchStateMapping
End
Go

If Exists (Select * From sys.tables Where Object_id = Object_ID('PreCal.BranchState'))
Begin
	Drop Table PreCal.BranchState
End
Go

Create Table PreCal.BranchState
	(
		BranchID int Not Null, 
		StateRegionID int not null
	)
Go

ALTER TABLE PreCal.BranchState ADD  CONSTRAINT [PK_BranchState] PRIMARY KEY CLUSTERED 
(
	StateRegionID ASC, BranchID ASC
)
GO

Print 'Table PreCal.BranchState created'
Go
--##############################################
------------------------------------------------
If Exists (Select * From sys.tables Where Object_id = Object_ID('Processing.tBranchForSeeking'))
Begin
	Drop Table Processing.tBranchForSeeking
End
Go

If Exists (Select * From sys.tables Where Object_id = Object_ID('PreCal.DSDBranch'))
Begin
	Drop Table PreCal.DSDBranch
End
Go

Create Table PreCal.DSDBranch
(
	BranchID int Not Null, 
	AreaID int Not Null, 
	RegionID int Not Null, 
	BUID int Not Null, 
)
Go

ALTER TABLE PreCal.DSDBranch ADD  CONSTRAINT [PK_DSDBranch] PRIMARY KEY CLUSTERED 
(
	BranchID ASC
)
GO

CREATE NONCLUSTERED INDEX [NCI-DSDBranch-BUID] ON PreCal.DSDBranch
(
	BUID ASC
) INCLUDE (BranchID) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [NCI-DSDBranch-RegionID] ON PreCal.DSDBranch
(
	RegionID ASC
) INCLUDE (BranchID) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [NCI-DSDBranch-AreaID] ON PreCal.DSDBranch
(
	AreaID ASC
) INCLUDE (BranchID) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

Print 'Table PreCal.DSDBranch created'
Go
--##############################################
------------------------------------------------
If Exists (Select * From sys.tables Where Object_id = Object_ID('Processing.tBranchBrand'))
Begin
	Drop Table Processing.tBranchBrand
End
Go

If Exists (Select * From sys.tables Where Object_id = Object_ID('PreCal.BranchBrand'))
Begin
	Drop Table PreCal.BranchBrand
End
Go

Create Table PreCal.BranchBrand
(
	BranchID int Not Null,
	BrandID int not null,
	AreaID int not null,
	RegionID int not null,
	BUID int not null,
)
Go

ALTER TABLE PreCal.BranchBrand ADD  CONSTRAINT [PK_BranchBrand] PRIMARY KEY CLUSTERED 
(
	BranchID ASC, BrandID ASC
)
GO

CREATE NONCLUSTERED INDEX [NCI-BranchBrand-BrandID] ON PreCal.BranchBrand
(
	BrandID ASC
) INCLUDE (BranchID) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

Print 'Table PreCal.BranchBrand created'
Go

--##############################################
------------------------------------------------
If Exists (Select * From sys.tables Where Object_id = Object_ID('Processing.tChainSeeking'))
Begin
	Drop Table Processing.tChainSeeking
End
Go

If Exists (Select * From sys.tables Where Object_id = Object_ID('PreCal.ChainHier'))
Begin
	Drop Table PreCal.ChainHier
End
Go

Create Table PreCal.ChainHier
(
	LocalChainID int Not Null,
	LocalChainName varchar(128) not null,
	RegionalChainID int Not Null, 
	RegionalChainName varchar(128) not null,
	NationalChainID int Not Null, 
	NationalChainName varchar(128) not null,
)
Go

ALTER TABLE PreCal.ChainHier ADD  CONSTRAINT [PK_ChainHier] PRIMARY KEY CLUSTERED 
(
	LocalChainID ASC
)
GO

CREATE NONCLUSTERED INDEX [NCI-ChainHier-NationalChainID] ON PreCal.ChainHier
(
	NationalChainID ASC
) INCLUDE (LocalChainID) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [NCI-ChainHier-RegionalChainID] ON PreCal.ChainHier
(
	RegionalChainID ASC
) INCLUDE (LocalChainID) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

Print 'Table PreCal.ChainHier created'
Go

--##############################################
------------------------------------------------
If Exists (
	Select *
	From Sys.Tables
	Where Object_ID = object_id('PlayBook.ChainGroupLocalChain'))
Begin
	Drop Table PlayBook.ChainGroupLocalChain
End
Go

If Exists (
	Select *
	From Sys.Tables
	Where Object_ID = object_id('PlayBook.ChainGroupRegionalChain'))
Begin
	Drop Table PlayBook.ChainGroupRegionalChain
End
Go

If Exists (
	Select *
	From Sys.Tables
	Where Object_ID = object_id('PlayBook.ChainGroupNationalChain'))
Begin
	Drop Table PlayBook.ChainGroupNationalChain
End
Go


If Exists (
	Select *
	From Sys.Tables t 
	Join Sys.schemas s on t.schema_id = s.schema_id
	Where t.Name = 'ChainGroup' and s.name = 'Playbook')
Begin
	Drop Table Playbook.ChainGroup
End
Go

--------------------------
CREATE TABLE Playbook.ChainGroup(
	ChainGroupID varchar(20) Not Null,
	ChainGroupName varchar(100) NOT NULL,
	ImageName varchar(100) NOT NULL,
	WebImageURL varchar(512) not null,
	MobileImageURL varchar(512) not null,
	Active bit not null,
	CoveredByNational bit,
	TrueRegional bit,
	IsAllOther bit null,
	CreatedDate SmallDateTime Not Null,
	CreateBy varchar(50) Not Null,
	ModifiedDate SmallDatetime Not Null,
	ModifiedBy varchar(50) Not Null,
 CONSTRAINT [PK_ChainGroup] PRIMARY KEY CLUSTERED 
(
	ChainGroupID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

Go

Set NoCount on;
Go

Insert Into PlayBook.ChainGroup
(ChainGroupID, ChainGroupName, ImageName, WebImageURL, MobileImageURL, Active, CreatedDate, CreateBy, ModifiedDate, ModifiedBy)
Values
('U00000', 'Unknown', 'Image-Unavailable2.png', 
'https://dpsg.cloud.microstrategy.com/MicroStrategy/images/DPSG/Amplify%20MyScores/Image-Unavailable2.png',
'https://dpsg.cloud.microstrategy.com/MicroStrategy/images/DPSG/Amplify%20MyScores/Mobile/Image-Unavailable2.png',
1,
GetDate(), 'System', GetDate(), 'System')
Go

Print 'Table Playbook.ChainGroup created and ''Unknown'' added'
Go

--##############################################
------------------------------------------------
If Exists (Select * From sys.tables Where Object_id = Object_ID('Processing.tBranchChainGroup'))
Begin
	Drop Table Processing.tBranchChainGroup
End
Go

If Exists (Select * From sys.tables Where Object_id = Object_ID('PreCal.BranchChainGroup'))
Begin
	Drop Table PreCal.BranchChainGroup
End
Go

Create Table PreCal.BranchChainGroup
	(
		BranchID int Not Null,
		ChainGroupID varchar(20) Not nUll
	)
Go

ALTER TABLE PreCal.BranchChainGroup ADD  CONSTRAINT [PK_BranchChainGroup] PRIMARY KEY CLUSTERED 
(
	BranchID, ChainGroupID ASC
)
GO

Print 'Table PreCal.BranchChainGroup created'
Go

--##############################################
------------------------------------------------
If Exists (Select * From sys.tables Where Object_id = Object_ID('PreCal.PromotionChainGroup'))
Begin
	Drop Table PreCal.PromotionChainGroup
End
Go

Create Table PreCal.PromotionChainGroup
	(
		PromotionID int Not Null,
		ChainGroupID varchar(20) Not nUll
	)
Go

ALTER TABLE PreCal.PromotionChainGroup ADD  CONSTRAINT [PK_PromotionChainGroup] PRIMARY KEY CLUSTERED 
(
	PromotionID, ChainGroupID ASC
)
GO

Print 'Table PreCal.PromotionChainGroup created'
Go

--##############################################
------------------------------------------------
If Exists (
	Select *
	From Sys.Objects
	Where Object_id = Object_id('Playbook.PromotionRegion'))
Begin
	Drop Table Playbook.PromotionRegion
End
Go

If Exists (
	Select *
	From Sys.Objects
	Where Object_id = Object_id('PreCal.PromotionRegionChainGroup'))
Begin
	Drop Table PreCal.PromotionRegionChainGroup
End
Go

CREATE TABLE PreCal.PromotionRegionChainGroup(
	[PromotionID] [int] NOT NULL,
	[RegionID] [int] NOT NULL,
	ChainGroupID varchar(20) not null,
	PromotionStartDate Date Not Null,
	PromotionEndDate Date Not Null,
	IsPromotion Bit Not Null,
 CONSTRAINT [PK_PromotionRegionChainGroup] PRIMARY KEY CLUSTERED 
(
	[RegionID] ASC,
	ChainGroupID ASC,
	[PromotionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

Go

CREATE NONCLUSTERED INDEX [NCI-PromotionRegionChainGroup-Dates] ON PreCal.PromotionRegionChainGroup
(
	[PromotionStartDate] ASC,
	[PromotionEndDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [NCI-PromotionRegionChainGroup-IsPromotion] ON PreCal.PromotionRegionChainGroup
(
	IsPromotion ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [NCI-PromotionRegionChainGroup-PromotionID]
ON [PreCal].[PromotionRegionChainGroup] ([PromotionID])
Go

Print 'Table PreCal.PromotionRegionChainGroup created'
Go

--##############################################
------------------------------------------------
If Exists (
	Select *
	From Sys.Tables
	Where Object_ID = object_id('Playbook.PromotionBottler'))
Begin
	Drop Table Playbook.PromotionBottler
End
Go

If Exists (
	Select *
	From Sys.Tables
	Where Object_ID = object_id('PreCal.PromotionBottlerChainGroup'))
Begin
	Drop Table PreCal.PromotionBottlerChainGroup
End
Go

--------------------------
CREATE TABLE PreCal.PromotionBottlerChainGroup(
	[PromotionID] [int] NOT NULL,
	[BottlerID] [int] NOT NULL,
	[RegionID] [int] NOT NULL,
	ChainGroupID varchar(20) not null,
	PromotionStartDate Date,
	PromotionEndDate Date,
	IsPromotion Bit Not Null,
 CONSTRAINT [PK_PromotionBottlerChainGroup] PRIMARY KEY CLUSTERED 
(
	[BottlerID] ASC,
	ChainGroupID ASC,
	[PromotionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

Go

CREATE NONCLUSTERED INDEX [NCI-PromotionBottlerChainGroup-Dates] ON PreCal.PromotionBottlerChainGroup
(
	[PromotionStartDate] ASC,
	[PromotionEndDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [NCI-PromotionBottlerChainGroup-Bottler] ON PreCal.PromotionBottlerChainGroup
(
	BottlerID ASC, PromotionID ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO


CREATE NONCLUSTERED INDEX [NCI-PromotionBottlerChainGroup-IsPromotion] ON PreCal.PromotionBottlerChainGroup
(
	IsPromotion ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [NCI-PromotionBottlerChainGroup-PromotionID]
ON [PreCal].[PromotionBottlerChainGroup] ([PromotionID])
Go

Print 'Table PreCal.PromotionBottlerChainGroup created'
Go

--##############################################
------------------------------------------------
If Exists (
	Select *
	From Sys.Tables
	Where Object_ID = object_id('BC.tRegionTradeMarkLocalChainForSeeking'))
Begin
	Drop Table BC.tRegionTradeMarkLocalChainForSeeking
End
Go

If Exists (
	Select *
	From Sys.Tables
	Where Object_ID = object_id('PreCal.RegionTMLocalChain'))
Begin
	Drop Table PreCal.RegionTMLocalChain
End
Go

CREATE TABLE PreCal.RegionTMLocalChain(
	[RegionID] [int] NOT NULL,
	[TradeMarkID] [int] NOT NULL,
	[LocalChainID] [int] NOT NULL,
 CONSTRAINT [PK_tRegionTrademarkLocalChainForSeeking] PRIMARY KEY CLUSTERED 
(
	[RegionID] ASC,
	[TradeMarkID] ASC,
	[LocalChainID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

Print 'Table PreCal.RegionTMLocalChain created'
Go

--##############################################
------------------------------------------------
If Exists (
	Select *
	From Sys.Tables
	Where Object_ID = object_id('PreCal.ChainGroupTree'))
Begin
	Drop Table PreCal.ChainGroupTree
End
Go

CREATE TABLE PreCal.ChainGroupTree(
	ChainGroupID varchar(20) Not Null,
	ChainGroupName varchar(100) Not Null,
	ParentChainGroupID varchar(20) Null,
	NodeType varchar(100) Not Null,
	SequenceOrder int Not Null,
	IsMSTRChainGroup bit Not Null
 CONSTRAINT [PK_ChainGroupTree] PRIMARY KEY CLUSTERED 
(
	ChainGroupID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE NONCLUSTERED INDEX [NCI-ChainGroupTree-ParentChainGroupID] ON PreCal.[ChainGroupTree]
(
	ParentChainGroupID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

Print 'Table PreCal.ChainGroupTree created'
Go

Print ''
Print 'Server Name:' + @@ServerName
Print 'Database Name:' + DB_Name()
Print '--- All Schema and Tables Created OK ---'
Go

If Exists (Select * From sys.objects Where object_ID = OBJECT_ID('PreCal.vSchemaDocument'))
Begin
	Drop View [PreCal].[vSchemaDocument]
End
Go

Create View [PreCal].[vSchemaDocument]
As
	Select s.name + '.' + o.name TableName, c.name ColumnName, case when t.name = 'varchar' 
																		then t.name + '(' + convert(varchar, c.max_length) + ')' 
																	else t.name 
																	end  TypeName
	From sys.tables o 
	join sys.schemas s on s.schema_id = o.schema_id
	join sys.columns c on o.object_id = c.object_id
	join sys.types t on c.system_type_id = t.system_type_id
	Where s.name = 'PreCal'

GO

