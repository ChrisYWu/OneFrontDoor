Use Portal_Data805
Go

-----------
-----------
If Exists (Select * From sys.tables Where Object_id = Object_ID('Processing.tBottlerForSeeking'))
Begin
	Drop Table Processing.tBottlerForSeeking
End
Go

Create Table Processing.tBottlerForSeeking
	(
		SystemID int Not Null, 
		ZoneID int Not Null, 
		DivisionID int Not Null, 
		RegionID int Not Null, 
		BottlerID int Not Null, 
	)
Go

ALTER TABLE Processing.tBottlerForSeeking ADD  CONSTRAINT [PK_tBottlerForSeeking] PRIMARY KEY CLUSTERED 
(
	[BottlerID] ASC
)
GO

CREATE NONCLUSTERED INDEX [NCI-tBottlerForSeeking-Region] ON Processing.tBottlerForSeeking
(
	SystemID ASC, ZoneID ASC, DivisionID ASC, RegionID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [NCI-tBottlerForSeeking-System] ON Processing.tBottlerForSeeking
(
	SystemID ASC
) INCLUDE ([BottlerID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [NCI-tBottlerForSeeking-Zone] ON Processing.tBottlerForSeeking
(
	ZoneID ASC
) INCLUDE ([BottlerID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [NCI-tBottlerForSeeking-Division] ON Processing.tBottlerForSeeking
(
	DivisionID ASC
) INCLUDE ([BottlerID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [NCI-tBottlerForSeeking-Region-Bottler] ON Processing.tBottlerForSeeking
(
	RegionID ASC
) INCLUDE ([BottlerID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

--=============================
Truncate Table Processing.tBottlerForSeeking

Insert Into Processing.tBottlerForSeeking(SystemID, ZoneID, DivisionID, RegionID, BottlerID)
Select v.SystemID, v.ZoneID, v.DivisionID, v.RegionID, b.BottlerID
From BC.vSalesHierarchy v
Join BC.Bottler b on b.BCRegionID = v.RegionID
Where SystemID in (5, 6,7)
Go

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-----------
-----------

If Exists (Select * From sys.tables Where Object_id = Object_ID('Processing.tBottlerStateMapping'))
Begin
	Drop Table Processing.tBottlerStateMapping
End
Go

Create Table Processing.tBottlerStateMapping
	(
		BottlerID int Not Null, 
		StateRegionID int not null
	)
Go

ALTER TABLE Processing.tBottlerStateMapping ADD  CONSTRAINT [PK_tBottlerStateMapping] PRIMARY KEY CLUSTERED 
(
	StateRegionID ASC, [BottlerID] ASC
)
GO

--=============================
Truncate Table Processing.tBottlerStateMapping

Insert Into Processing.tBottlerStateMapping(BottlerID, StateRegionID)
Select Distinct tmap.BottlerID, c.StateRegionID
From BC.BottlerAccountTradeMark tmap
Join SAP.Account a on a.AccountID = tmap.AccountID
Join Shared.County c on a.CountyID = c.CountyID
Where tmap.TerritoryTypeID <> 10
And tmap.ProductTypeID = 1
And a.CRMActive = 1
Go

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-----------
-----------

If Exists (Select * From sys.tables Where Object_id = Object_ID('Processing.tBranchStateMapping'))
Begin
	Drop Table Processing.tBranchStateMapping
End
Go

Create Table Processing.tBranchStateMapping
	(
		BranchID int Not Null, 
		StateRegionID int not null
	)
Go

ALTER TABLE Processing.tBranchStateMapping ADD  CONSTRAINT [PK_tBranchStateMapping] PRIMARY KEY CLUSTERED 
(
	StateRegionID ASC, BranchID ASC
)
GO

--=============================
Truncate Table Processing.tBranchStateMapping

Insert Into Processing.tBranchStateMapping(BranchID, StateRegionID)
Select a.BranchID, c.StateRegionID
From SAP.Account a
Join Shared.StateRegion c on a.State = c.RegionABRV
Where a.Active = 1 --- This is DSD Active Flag
Group By a.BranchID, c.StateRegionID
Having Count(*) > 4   --- Threshhold for the bad data, 5 or more account to represent the state for any branch
Go
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

-----------
-----------
If Exists (Select * From sys.tables Where Object_id = Object_ID('Processing.tBranchForSeeking'))
Begin
	Drop Table Processing.tBranchForSeeking
End
Go

Create Table Processing.tBranchForSeeking
	(
		BUID int Not Null, 
		RegionID int Not Null, 
		AreaID int Not Null, 
		BranchID int Not Null 
	)
Go

ALTER TABLE Processing.tBranchForSeeking ADD  CONSTRAINT [PK_tBranchForSeeking] PRIMARY KEY CLUSTERED 
(
	BranchID ASC
)
GO

CREATE NONCLUSTERED INDEX [NCI-tBranchForSeeking-BUID] ON Processing.tBranchForSeeking
(
	BUID ASC
) INCLUDE (BranchID) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [NCI-tBranchForSeeking-RegionID] ON Processing.tBranchForSeeking
(
	RegionID ASC
) INCLUDE (BranchID) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [NCI-tBranchForSeeking-AreaID] ON Processing.tBranchForSeeking
(
	AreaID ASC
) INCLUDE (BranchID) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

--=============================
Truncate Table Processing.tBranchForSeeking

Insert Into Processing.tBranchForSeeking(BUID, RegionID, AreaID, BranchID)
Select BUID, RegionID, AreaID, BranchID
From Mview.LocationHier
Go
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-----------
-----------
If Exists (Select * From sys.tables Where Object_id = Object_ID('Processing.tBranchBrand'))
Begin
	Drop Table Processing.tBranchBrand
End
Go

Create Table Processing.tBranchBrand
	(
		BranchID int Not Null,
		BrandID int not null 
	)
Go

ALTER TABLE Processing.tBranchBrand ADD  CONSTRAINT [PK_tBranchBrand] PRIMARY KEY CLUSTERED 
(
	BranchID ASC, BrandID ASC
)
GO

CREATE NONCLUSTERED INDEX [NCI-tBranchBrand-BrandID] ON Processing.tBranchBrand
(
	BrandID ASC
) INCLUDE (BranchID) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

--=============================
Truncate Table Processing.tBranchBrand

Insert Into Processing.tBranchBrand(BranchID, BrandID)
Select Distinct bm.BranchID, m.BrandID
From SAP.BranchMaterial bm
Join SAP.Material m on bm.MaterialID = m.MaterialID
Go
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-----------
-----------

If Exists (Select * From sys.tables Where Object_id = Object_ID('Processing.tChainSeeking'))
Begin
	Drop Table Processing.tChainSeeking
End
Go

Create Table Processing.tChainSeeking
	(
		NationalChainID int Not Null, 
		RegionalChainID int Not Null, 
		LocalChainID int Not Null
	)
Go

ALTER TABLE Processing.tChainSeeking ADD  CONSTRAINT [PK_tChainSeeking] PRIMARY KEY CLUSTERED 
(
	LocalChainID ASC
)
GO

CREATE NONCLUSTERED INDEX [NCI-tChainSeeking-NationalChainID] ON Processing.tChainSeeking
(
	NationalChainID ASC
) INCLUDE (LocalChainID) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [NCI-tChainSeeking-RegionalChainID] ON Processing.tChainSeeking
(
	RegionalChainID ASC
) INCLUDE (LocalChainID) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO


--=============================
Truncate Table Processing.tChainSeeking

Insert Into Processing.tChainSeeking(NationalChainID, RegionalChainID, LocalChainID)
Select NationalChainID, RegionalChainID, LocalChainID
From MView.ChainHier v
Go

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-----------
-----------

If Exists (Select * From sys.tables Where Object_id = Object_ID('Processing.tBranchChainGroup'))
Begin
	Drop Table Processing.tBranchChainGroup
End
Go

Create Table Processing.tBranchChainGroup
	(
		BranchID int Not Null, 
		ChainGroupID int Not Null
	)
Go

ALTER TABLE Processing.tBranchChainGroup ADD  CONSTRAINT [PK_tBranchChainGroup] PRIMARY KEY CLUSTERED 
(
	BranchID,ChainGroupID ASC
)
GO

--=============================
Truncate Table Processing.tBranchChainGroup

Insert Into Processing.tBranchChainGroup(BranchID, ChainGroupID)
Select Distinct a.BranchID, m.ChainGroupID
From SAP.Account a
Join PreCal.ChainHier ch on a.LocalChainID = ch.LocalChainID
Join Playbook.ChainGroupLocalChain m on ch.LocalChainID = m.LocalChainID
Where BranchID is not null

Insert Into Processing.tBranchChainGroup(BranchID, ChainGroupID)
Select Distinct a.BranchID, m.ChainGroupID
From SAP.Account a
Join PreCal.ChainHier ch on a.LocalChainID = ch.LocalChainID
Join Playbook.ChainGroupRegionalChain m on ch.RegionalChainID = m.RegionalChainID
Where BranchID is not null

Insert Into Processing.tBranchChainGroup(BranchID, ChainGroupID)
Select Distinct a.BranchID, m.ChainGroupID
From SAP.Account a
Join PreCal.ChainHier ch on a.LocalChainID = ch.LocalChainID
Join Playbook.ChainGroupNationalChain m on ch.NationalChainID = m.NationalChainID
Where BranchID is not null
Go
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

--Select *
--From Processing.tBranchChainGroup cg
--Join SAP.Branch b on cg.BranchID = b.BranchID
--Join MView.LocationHier lh on b.BranchID = lh.BranchID
--Where ChainGroupID = 2951

--SElect *
--From Playbook.ChainGroup
--Where ChainGroupID = 2951



