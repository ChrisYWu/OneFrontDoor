use Portal_Data805
Go

/*
-- Deployed in 108

Select * 
From Playbook.ufnDSDPromotionLocation(null)

*/

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

Truncate Table Processing.tBranchStateMapping

Insert Into Processing.tBranchStateMapping(BranchID, StateRegionID)
Select a.BranchID, c.StateRegionID
From SAP.Account a
Join Shared.StateRegion c on a.State = c.RegionABRV
Where a.Active = 1 --- This is DSD Active Flag
Group By a.BranchID, c.StateRegionID
Having Count(*) > 4   --- Threshhold for the bad data, 5 or more account to represent the state for any branch
Go

--@@@@@@@@@@@@@@@@@@@@@

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

------------
Truncate Table Processing.tBranchForSeeking

Insert Into Processing.tBranchForSeeking(BUID, RegionID, AreaID, BranchID)
Select BUID, RegionID, AreaID, BranchID
From Mview.LocationHier
Go

--@@@@@@@@@@@@@@@@@@@@@
IF OBJECT_ID(N'Playbook.ufnDSDPromotionLocation', N'TF') IS NOT NULL
    Drop Function Playbook.ufnDSDPromotionLocation;
GO
Create Function Playbook.ufnDSDPromotionLocation(@BackToDate Date = null)
RETURNS @PromotionBranch Table 
(
    -- Columns returned by the function
    PromotionID int,
	BranchID int,
	Primary Key(PromotionID, BranchID)
)
AS 
Begin
	If (@BackToDate is null)
	Begin
		Set @BackToDate = DateAdd(Year, -100, GetDate())
	End

	--- GeoRelevancy Expansion with Date Cut
	Declare @PromoGeoR Table
	(
		PromotionID int,
		BUID int,
		RegionID int, 
		AreaID int,
		BranchID int,
		StateID int,
		HierDefined int,
		StateDefined int,
		TYP int  -- Type of Promotion, 1 Init; 2 State And Hier; 3 HierOnly; 4 StateOnly; 5 AnytingElse; 6 Assume All DSD Promotion For StateOnly
	)

	Insert Into @PromoGeoR
	Select pgr.PromotionID, BUID, RegionID, AreaID, BranchID, StateID, 
		Case When (Coalesce(BUID, 0) > 0
		Or Coalesce(RegionID, 0) > 0
		Or Coalesce(AreaID, 0) > 0
		Or Coalesce(BranchID, 0) > 0) Then 1 Else 0 End HierDefined, 
		Case When (Coalesce(StateID, 0) > 0) Then 1 Else 0 End StateDefined,
		1 TYP 
	From Playbook.PromotionGeoRelevancy pgr
	Join Playbook.RetailPromotion rp on pgr.PromotionID = rp.PromotionID
	Where rp.PromotionEndDate >= @BackToDate
	And (
		Coalesce(BUID, 0) > 0
		Or Coalesce(RegionID, 0) > 0
		Or Coalesce(AreaID, 0) > 0
		Or Coalesce(BranchID, 0) > 0
		Or Coalesce(StateID, 0) > 0
	)

	-- 1 Init; 2 State And Hier; 3 HierOnly; 4 StateOnly; 5 AnytingElse; 6 Assume All DSD Promotion For StateOnly
	Update pgr
	Set TYP = Case When t.HierP > 0 And t.StateP > 0 Then 2 When t.HierP > 0 Then 3 When t.StateP > 0 Then 4 Else 5 End
	From @PromoGeoR pgr
	Join (
	Select PromotionID, Sum(HierDefined) HierP, Sum(StateDefined) StateP
	From @PromoGeoR
	Group By PromotionID) t on pgr.PromotionID = t.PromotionID

	-- Note: This is a cross join, for state only promotions, we add all the BUs to them
	Insert Into @PromoGeoR(PromotionID, BUID, TYP)
	Select PromotionID, BUID, 6
	From SAP.BusinessUnit,
	(Select Distinct PromotionID From @PromoGeoR Where TYP = 4) Temp

	-- Now there is no State-Only Promotions, they are converted to be State and Hier Promotions
	Update @PromoGeoR
	Set TYP = 2
	Where TYP in (4,6)

	-- Hier Only
	Insert Into @PromotionBranch(PromotionID, BranchID)
	Select Distinct pgr.PromotionID, v.BranchID
	From @PromoGeoR pgr
	Join Processing.tBranchForSeeking v on pgr.BUID = v.BUID
	Where TYP = 3
	Union
	Select Distinct pgr.PromotionID, v.BranchID
	from @PromoGeoR pgr
	Join Processing.tBranchForSeeking v on pgr.RegionId = v.RegionId
	Where TYP = 3 And pgr.BUID is null
	Union
	Select Distinct pgr.PromotionID, v.BranchID
	from @PromoGeoR pgr
	Join Processing.tBranchForSeeking v on pgr.AreaId = v.AreaId
	Where TYP = 3 And pgr.BUID is null And pgr.RegionID is null
	Union
	Select pgr.PromotionID, pgr.BranchID
	From @PromoGeoR pgr
	Where TYP = 3 And pgr.BranchID Is Not Null;

	-- State & Hier
	Insert Into @PromotionBranch(PromotionID, BranchID)
	Select r.PromotionID, r.BranchID
	From (
		Select Distinct pgr.PromotionID, v.BranchID
		From @PromoGeoR pgr
		Join Processing.tBranchForSeeking v on pgr.BUID = v.BUID
		Where TYP = 2
		Union
		Select Distinct pgr.PromotionID, v.BranchID
		from @PromoGeoR pgr
		Join Processing.tBranchForSeeking v on pgr.RegionId = v.RegionId
		Where TYP = 2 And pgr.BUID is null
		Union
		Select Distinct pgr.PromotionID, v.BranchID
		from @PromoGeoR pgr
		Join Processing.tBranchForSeeking v on pgr.AreaId = v.AreaId
		Where TYP = 2 And pgr.BUID is null And pgr.RegionId is null
		Union
		Select pgr.PromotionID, pgr.BranchID
		From @PromoGeoR pgr
		Where TYP = 2 And pgr.BranchID Is Not Null
	) l
	Join (
		Select Distinct PromotionID, h.BranchID
		From @PromoGeoR pgr
		Join Processing.tBranchStateMapping h on pgr.StateID = h.StateRegionID
		Where TYP = 2) r On l.PromotionID = r.PromotionID And l.BranchID = r.BranchID;

	Return;
End
Go