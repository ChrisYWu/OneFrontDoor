USE Portal_Data
GO

If Exists (Select * From sys.procedures Where object_id = object_id('Playbook.pGetChainGroupsBranches'))
	Drop Proc Playbook.pGetChainGroupsBranches
Go

Set QUOTED_IDENTIFIER ON
GO


/*
-- Deployed to 108 --
Declare @StartTime DateTime2(7)
Set @StartTime = SYSDATETIME()
exec Playbook.pGetChainGroupsBranches @BranchIDs = '', @Date = '2015-1-1'
Select replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds


exec Playbook.pGetChainGroupsBranches @BranchIDs = ''
										  ,@Debug = 1
										  ,@Date = '2015-1-1'

---- San Antonio
exec Playbook.pGetChainGroupsBranches @Debug = 1, @BranchIDs = 151, @Date = '2015-1-1'

---- Irving
exec Playbook.pGetChainGroupsBranches @BranchIDs = 161, @Date = '2015-1-1'

exec Playbook.pGetChainGroupsBranches @BranchIDs = 161, @Date = '2015-1-1', @Debug = 1

---- Web BU
exec Playbook.pGetChainGroupsBranches @Debug = 1, @Date = '2015-1-1', @BranchIDs = '118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,154,155,165,167,168,169'

exec Playbook.pGetChainGroupsBranches @Debug = 1, @Date = '2015-1-1', @BUIDs = '7'


Select *
From SAP.BusinessUnit

exec Playbook.pGetChainGroupsBranches @Debug = 1, @Date = '2015-1-1', @AreaIDs = '41'

Select *
From MSTR.RevChainImages
Where RegionalChainID = 245


*/

Create Proc Playbook.pGetChainGroupsBranches
(
	@BUIDs nvarchar(4000) = '',
	@RegionIDs nvarchar(4000) = '',
	@AreaIDs nvarchar(4000) = '',
	@BranchIDs nvarchar(4000) = '',
	@Debug bit = 0, 
	@Date DateTime = null
)
AS
Begin
	/*  Rivision History
	2015-11-03 First Version; Developed on 108


	*/

	Set NoCount On;

	Declare @StartDate DateTime, @EndDate DateTime

	If (@Debug = 1)
	Begin
		Declare @StartTime DateTime2(7)
		Set @StartTime = SYSDATETIME()

		Select '---- Starting ----' Debug, @BUIDs BUIDs, @RegionIDs RegionIDs, @AreaIDs AreaIDs, @BranchIDs BranchIDs, @Date StartDate
	End

	--~~~~~~~~~~~~~~~~~~~~~~ Stage 1. Parameters and User target ~~~~~~~~~~~~~~~~~~~~--
	Declare @BranchIDsTable Table
	(
		BranchID int,
		Primary Key (BranchID ASC)
	)

	Insert Into @BranchIDsTable
	Select Distinct BranchID
	From PreCal.DSDBranch h 
	Join dbo.Split(@BUIDs, ',') s on h.BUID = s.Value
	Union
	Select Distinct BranchID
	From PreCal.DSDBranch h 
	Join dbo.Split(@RegionIDs, ',') s on h.RegionID = s.Value
	Union
	Select Distinct BranchID
	From PreCal.DSDBranch h 
	Join dbo.Split(@AreaIDs, ',') s on h.AreaID = s.Value
	Union
	Select Value
	From dbo.Split(@BranchIDs, ',')
	Where Value <>''

	Declare @BranchCount int
	Set @BranchCount = 0
	Select @BranchCount = count(*) From @BranchIDsTable

	--- Not doing the default value
	--If (@BranchCount = 0)
	--Begin
	--	Insert Into @BranchIDsTable
	--	Select BranchID
	--	From PreCal.DSDBranch
	--End

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

		If (@BranchCount > 0)
		Begin
			Select @BIDS = @BIDS + Convert(Varchar, BranchID) + ','
			From @BranchIDsTable
			Set @BIDS = SUBSTRING(@BIDS, 0, Len(@BIDS) - 1)
		End

		Select '---- Processed Parameters ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
			,@BIDS EffectiveBranchIDs, @StartDate StartDate, @EndDate EndDate
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
	PreCal.PromotionBranchChainGroup pb with (nolock)
	Join @BranchIDsTable brds On pb.BranchID = brds.BranchID
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




