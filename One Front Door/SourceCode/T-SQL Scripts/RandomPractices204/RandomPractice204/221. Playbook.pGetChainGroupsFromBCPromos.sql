USE Portal_Data
GO

If Exists (Select * From sys.procedures Where object_id = object_id('Playbook.pGetChainGroupsFromBCPromos'))
	Drop Proc Playbook.pGetChainGroupsFromBCPromos
Go

Set QUOTED_IDENTIFIER ON
GO


/*
-- Deployed to 108 --
Declare @StartTime DateTime2(7)
Set @StartTime = SYSDATETIME()
exec Playbook.pGetChainGroupsFromBCPromos @RegionIDs = '9,10,11,12', @Date = '2015-1-1'
Select replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds

Select *
From PreCal.BottlerHier


exec Playbook.pGetChainGroupsFromBCPromos @RegionIDs = '9,10,11,12'
										  ,@Debug = 1
										  ,@Date = '2015-1-1'

Declare @StartTime DateTime2(7)
Set @StartTime = SYSDATETIME()
exec Playbook.pGetChainGroupsFromBCPromos @SystemIDs = '7', @Date = '2015-1-1'
Select replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds

Declare @StartTime DateTime2(7)
Set @StartTime = SYSDATETIME()
exec Playbook.pGetChainGroupsFromBCPromos @BottlerIDs = '39,369,470,480,482', @Date = '2015-1-1'
Select replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds

Declare @StartTime DateTime2(7)
Set @StartTime = SYSDATETIME()
exec Playbook.pGetChainGroupsFromBCPromos @SystemIDs = '7', @BottlerIDs = '11538,517,5758,6255', @Date = '2015-1-1'
Select replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds

*/

Create Proc Playbook.pGetChainGroupsFromBCPromos
(
	@SystemIDs nvarchar(4000) = '',
	@ZoneIDs nvarchar(4000) = '',
	@DivisionIDs nvarchar(4000) = '',
	@RegionIDs nvarchar(4000) = '',
	@BottlerIDs nvarchar(4000) = '',
	@Debug bit = 0, 
	@Date DateTime = null
)
AS
Begin
	/*  Rivision History
	2015-11-13 First Version; Developed on 108


	*/

	Set NoCount On;

	Declare @StartDate DateTime, @EndDate DateTime

	If (@Debug = 1)
	Begin
		Declare @StartTime DateTime2(7)
		Set @StartTime = SYSDATETIME()

		Select '---- Starting ----' Debug, @SystemIDs BUIDs, @ZoneIDs ZoneIDs, @DivisionIDs DivisionIDs, @RegionIDs RegionIDs, @BottlerIDs BottlerIDs, @Date StartDate
	End

	--~~~~~~~~~~~~~~~~~~~~~~ Stage 1. Parameters and User target ~~~~~~~~~~~~~~~~~~~~--
	Declare @RegionIDsTable Table
	(
		RegionID int,
		Primary Key (RegionID ASC)
	)

	Insert Into @RegionIDsTable
	Select Distinct RegionID
	From PreCal.BottlerHier h 
	Join dbo.Split(@SystemIDs, ',') s on h.SystemID = s.Value
	Union
	Select Distinct RegionID
	From PreCal.BottlerHier h 
	Join dbo.Split(@ZoneIDs, ',') s on h.ZoneID = s.Value
	Union
	Select Distinct RegionID
	From PreCal.BottlerHier h 
	Join dbo.Split(@DivisionIDs, ',') s on h.DivisionID = s.Value
	Union
	Select Distinct RegionID
	From PreCal.BottlerHier h 
	Join dbo.Split(@RegionIDs, ',') s on h.RegionID = s.Value

	--****
	Declare @BottlerIDsTable Table
	(
		BottlerID int,
		Primary Key (BottlerID ASC)
	)
	Insert Into @BottlerIDsTable 
	Select Distinct BottlerID
	From PreCal.BottlerHier h 
	Join dbo.Split(@BottlerIDs, ',') s on h.BottlerID = s.Value

	---------------
	If (@Date = '') 
		Set @Date = null

	If (@Date is null)
		Set @Date = GetDate()

	Set @StartDate = @Date
	Set @EndDate = DateAdd(week, 4, @StartDate)

	If (@Debug = 1)
	Begin
		Declare @BIDS varchar(4000)
		Set @BIDS = ''

		Select @BIDS = @BIDS + Convert(Varchar, RegionID) + ','
		From @RegionIDsTable

		If(@BIDS <> '')
		Begin
			Set @BIDS = SUBSTRING(@BIDS, 0, Len(@BIDS) - 1)
		End

		----
		Declare @BttlrIDS varchar(4000)
		Set @BttlrIDS = ''
		
		Select @BttlrIDS = @BttlrIDS + Convert(Varchar, BottlerID) + ','
		From @BottlerIDsTable

		If (@BttlrIDS <> '')
		Begin
			Set @BttlrIDS = SUBSTRING(@BttlrIDS, 0, Len(@BttlrIDS) - 1)
		End

		Select '---- Processed Parameters ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
			,@BIDS EffectiveRegionIDs
			,@BttlrIDS EffectiveBottlerIDs
			,@StartDate StartDate, @EndDate EndDate
	End

	--~~~~~~~~~~~~~~~~~~~~~~ Stage 2. The query ~~~~~~~~~~~~~~~~~~~~--
	Declare @PromoGroups Table 
	(
		PromotionID int,
		ChainGroupID varchar(20),
		Primary Key(PromotionID ASC, ChainGroupID ASC)
	)

	Insert Into @PromoGroups
	Select Distinct pb.PromotionID, pb.ChainGroupID
	From
	PreCal.PromotionRegionChainGroup pb with (nolock)
	Join @RegionIDsTable brds On pb.RegionID = brds.RegionID
	Where pb.PromotionStartDate <= @EndDate And pb.PromotionEndDate > @StartDate -- @EndDate is inclusive, See promotion 34605 for details, 1-1 is not valid for that one
	And pb.IsPromotion = 1
	Union
	Select Distinct pb.PromotionID, pb.ChainGroupID
	From
	PreCal.PromotionBottlerChainGroup pb with (nolock)
	Join @BottlerIDsTable brds On pb.BottlerID = brds.BottlerID
	Where pb.PromotionStartDate <= @EndDate And pb.PromotionEndDate > @StartDate -- @EndDate is inclusive, See promotion 34605 for details, 1-1 is not valid for that one
	And pb.IsPromotion = 1

	If (@Debug = 1)
	Begin
		Select '---- Promotions With ChainGroup associated filtered by locations ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select * From @PromoGroups
	End;

	Declare @Output Table
	(
		ChainGroupID varchar(20) not null, 
		ChainGroupName varchar(100) not null,
		ParentChainGroupID varchar(20), 
		SequenceOrder int,
		PromotionCount int
	);

	If (@Debug = 1)
	Begin
		Select '---- Promotion ChainGroups and parent chaingroups retrived ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds;

		With RealCGCount As
		(
			Select ChainGroupID, Count(*) PromotionCount
			From @PromoGroups
			Group By ChainGroupID
		)
		Select t.ChainGroupID, t.ChainGroupName, t.ParentChainGroupID, t.SequenceOrder, PromotionCount
		From RealCGCount r
		Join PreCal.ChainGroupTree t on r.ChainGroupID = t.ChainGroupID
		Order By ChainGroupName

	End;
	
	With RealCGCount As
	(
		Select ChainGroupID, Count(*) PromotionCount
		From @PromoGroups
		Group By ChainGroupID
	)

	Insert Into @Output(ChainGroupID, ChainGroupName, ParentChainGroupID, SequenceOrder, PromotionCount)
	Select t.ChainGroupID, t.ChainGroupName, t.ParentChainGroupID, t.SequenceOrder, PromotionCount
	From RealCGCount r
	Join PreCal.ChainGroupTree t on r.ChainGroupID = t.ChainGroupID
	Union
	Select t.ChainGroupID, t.ChainGroupName, t.ParentChainGroupID, t.SequenceOrder, PromotionCount
	From (
		Select t.ParentChainGroupID ChainGroupID, Sum(PromotionCount) PromotionCount
		From RealCGCount r
		Join PreCal.ChainGroupTree t on r.ChainGroupID = t.ChainGroupID
		Where t.ParentChainGroupID is not null
		Group By t.ParentChainGroupID	
		Having Count(*) > 1   --- Reduce the single child to his parent
	) parentCount
	Join PreCal.ChainGroupTree t on parentCount.ChainGroupID = t.ChainGroupID

	Update @Output
	Set ParentChainGroupID = null
	Where ParentChainGroupID Not In (Select ChainGroupID From @Output)

	Select ChainGroupID, 
		ChainGroupName + '[' + Convert(varchar, ChainT) + ']'  ChainGroupName, 
		ParentChainGroupID, o.SequenceOrder, Max(PromotionCount) PromotionCount
	From @Output o
	Join (Select 1 SequenceOrder, 'N' ChainT Union Select 2, 'R' Union Select 3, 'L') t on o.SequenceOrder = t.SequenceOrder
	Group By ChainGroupID, ChainGroupName, ParentChainGroupID, o.SequenceOrder, ChainT
	Order By ChainGroupName

	If (@Debug = 1)
	Begin
		Select '---- Promotion ChainGroups and parent chaingroups retrived ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

End

Go


--Select *
--From PreCal.ChainGroupTree
--Where ChainGroupID = 'N00190'

--SElect *
--From PreCal.ChainGroupTree
--Where ChainGroupName = 'H-E-B'

--Select PromotionID, PromotionName, PromotionStartDate StartDate, PromotionEndDate EndDate
--From Playbook.RetailPromotion
--Where PromotionID = 10000


--Select 'T:' + TrademarkName As Trademark
--From PlayBook.PromotionBrand pb
--Join SAP.TradeMark t on pb.TrademarkID = t.TradeMarkID
--Where PromotionID = 10000
--For XML Raw




