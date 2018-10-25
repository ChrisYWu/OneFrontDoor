use Portal_Data805
Go

--------------------------
If Exists (
	Select *
	From Sys.Tables
	Where Name = 'PromotionRegion')
Begin
	Drop Table Playbook.PromotionRegion
End
Go

--------------------------
CREATE TABLE [Playbook].[PromotionRegion](
	[RegionID] [int] NOT NULL,
	[PromotionID] [int] NOT NULL,
	PromotionStartDate Date,
	PromotionEndDate Date,
 CONSTRAINT [PK_PromotionRegion] PRIMARY KEY CLUSTERED 
(
	[RegionID] ASC,
	[PromotionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

Go

CREATE NONCLUSTERED INDEX [NCI-PromotionRegion-Dates] ON [Playbook].[PromotionRegion]
(
	[PromotionStartDate] ASC,
	[PromotionEndDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

--------------------------
If Exists (
	Select *
	From Sys.Tables
	Where Name = 'PromotionBottler')
Begin
	Drop Table Playbook.PromotionBottler
End
Go

--------------------------
CREATE TABLE [Playbook].[PromotionBottler](
	[BottlerID] [int] NOT NULL,
	[RegionID] [int] NOT NULL,
	[PromotionID] [int] NOT NULL,
	PromotionStartDate Date,
	PromotionEndDate Date,
 CONSTRAINT [PK_PromotionBottler] PRIMARY KEY CLUSTERED 
(
	[PromotionID] ASC,
	[BottlerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

Go

CREATE NONCLUSTERED INDEX [NCI-PromotionBottler-Dates] ON [Playbook].[PromotionBottler]
(
	[PromotionStartDate] ASC,
	[PromotionEndDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [NCI-PromotionBottler-Region] ON [Playbook].[PromotionBottler]
(
	[RegionID] ASC
) INCLUDE (PromotionID)  WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO


--------------------------
If Exists (
	Select *
	From Sys.Tables
	Where Name = 'PromotionBranch')
Begin
	Drop Table Playbook.PromotionBranch
End
Go

--------------------------
CREATE TABLE Playbook.PromotionBranch (
	[BranchID] [int] NOT NULL,
	[PromotionID] [int] NOT NULL,
	PromotionStartDate Date,
	PromotionEndDate Date,
 CONSTRAINT [PK_PromotionBranch] PRIMARY KEY CLUSTERED 
(
	[BranchID] ASC,
	[PromotionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

Go

CREATE NONCLUSTERED INDEX [NCI-PromotionBranch-Dates] ON [Playbook].[PromotionBranch]
(
	[PromotionStartDate] ASC,
	[PromotionEndDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

-----------------------
/****** Object:  Table [BC].[tRegionTrademarkLocalChainForSeeking]    Script Date: 9/16/2015 11:01:11 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [BC].[tRegionTradeMarkLocalChainForSeeking](
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

Truncate Table BC.tRegionTradeMarkLocalChainForSeeking

Insert BC.tRegionTradeMarkLocalChainForSeeking(RegionID, TradeMarkID, LocalChainID)
Select Distinct RegionID, TradeMarkID, LocalChainID
From BC.tRegionChainTradeMark tmap
Where tmap.TerritoryTypeID <> 10
And tmap.ProductTypeID = 1

----------------------------------------
Create Table BC.tBottlerForSeeking
	(
		SystemID int, 
		ZoneID int, 
		DivisionID int, 
		RegionID int, 
		BottlerID int, 
		StateRegionID int
	)

Truncate Table BC.tBottlerForSeeking

Insert Into BC.tBottlerForSeeking(v.SystemID, v.ZoneID, v.DivisionID, v.RegionID, b.BottlerID, sr.StateRegionID)
Select v.SystemID, v.ZoneID, v.DivisionID, v.RegionID, b.BottlerID, sr.StateRegionID
From BC.vSalesHierarchy v
Join BC.Bottler b on b.BCRegionID = v.RegionID
Join Shared.StateRegion sr on b.State = sr.RegionABRV
Where SystemID in (5, 6,7)

ALTER TABLE [BC].[tBottlerForSeeking] ADD  CONSTRAINT [PK_tBottlerForSeeking] PRIMARY KEY CLUSTERED 
(
	[BottlerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [NCI_tBottlerForSeeking_Bottler_State] ON [BC].[tBottlerForSeeking]
(
	[BottlerID] ASC,
	[StateRegionID] ASC
)
INCLUDE ( 	[RegionID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO


-------------------------------
Create Table BC.tRegionForSeeking
	(
		SystemID int, 
		ZoneID int, 
		DivisionID int, 
		RegionID int
	)

ALTER TABLE [BC].[tRegionForSeeking] ADD  CONSTRAINT [PK_tRegionForSeeking] PRIMARY KEY CLUSTERED 
(
	[RegionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

Truncate Table BC.tRegionForSeeking

Insert Into BC.tRegionForSeeking(v.SystemID, v.ZoneID, v.DivisionID, v.RegionID)
Select Distinct v.SystemID, v.ZoneID, v.DivisionID, v.RegionID
From BC.tBottlerForSeeking v










