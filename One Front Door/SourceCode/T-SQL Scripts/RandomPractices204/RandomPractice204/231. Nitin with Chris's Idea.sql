USE Portal_Data805
GO

If Exists (Select * From sys.procedures Where object_id = object_id('Playbook.pDataAnalysisForNitin2'))
	Drop Proc Playbook.pDataAnalysisForNitin2
Go

Set QUOTED_IDENTIFIER ON
GO

/*
--- Irving ---
exec Playbook.pDataAnalysisForNitin2 @BranchIDs = 161, @Date = '2015-1-1'
exec Playbook.pDataAnalysisForNitin2 @BranchIDs = '118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,154,155,165,167,168,169', @Date = '2015-1-1'

Select *
From SAP.NationalChain
Where NationalChainName = 'H-E-B'

Select *
From SAP.RegionalChain
Where RegionalChainName = 'H-E-B'

Select *
From SAP.RegionalChain
Where RegionalChainName = 'All other'

Select *
From SAP.LocalChain
Where RegionalChainName = 'H-E-B'

--- West BU ---
exec Playbook.pDataAnalysisForNitin2 @Debug = 1, @Date = '2015-1-1', @BranchIDs = '118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,154,155,165,167,168,169'

*/
Create Proc Playbook.pDataAnalysisForNitin2
(
	@BranchIDs nvarchar(4000) = '',
	@Debug bit = 0, 
	@Date DateTime = null
)
AS
Begin
	Set NoCount On;

	Declare @StartDate DateTime, @EndDate DateTime, @FourWeekEndDate DateTime

	If (@Debug = 1)
	Begin
		Declare @StartTime DateTime2(7)
		Set @StartTime = SYSDATETIME()

		Select '---- Starting ----' Debug, @BranchIDs BranchIDs, @StartDate StartDate, @EndDate EndDate
	End

	--~~~~~~~~~~~~~~~~~~~~~~ Stage 1. Parameters and User target ~~~~~~~~~~~~~~~~~~~~--
	--- If @BranchIDs parameter is set to be '', then it'll get converted to be null
	Print 'Processing parameters'
	If (@BranchIDs = '')
		Set @BranchIDs = null

	If (@Date = '') 
		Set @Date = null

	If (@Date is null)
		Set @Date = GetDate()

	Set @StartDate = @Date
	Set @EndDate = DateAdd(week, 8, @StartDate)
	Set @FourWeekEndDate = DateAdd(week, 4, @StartDate)

	If (@Debug = 1)
	Begin
		Select '---- Processed Parameters ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
									,@BranchIDs BranchIDs, @StartDate StartDate, @EndDate EndDate
	End

	--~~~~~~~~~~~~~~~~~~~~~~ Stage 2. The query ~~~~~~~~~~~~~~~~~~~~--
	Declare @Promos Table 
	(
		PromotionID int,
		WeekEndsIdentifier varchar(20),
		Primary Key(PromotionID, WeekEndsIdentifier)
	)

	If (@BranchIDs is null)
	Begin
		Insert Into @Promos
		Select Distinct PromotionID, 
		Case When pb.PromotionStartDate < @FourWeekEndDate And pb.PromotionEndDate >= @StartDate Then 'Week 1~4' 
			 When pb.PromotionStartDate <= @EndDate And pb.PromotionEndDate >= @FourWeekEndDate Then 'Week 5~8'
		End WeekEndsIdentifier	  
		From
		Playbook.PromotionBranch pb with (nolock)
		Where pb.PromotionStartDate <= @EndDate And pb.PromotionEndDate >= @StartDate
	End
	Else
	Begin
		Insert Into @Promos
		Select Distinct PromotionID,
		Case When pb.PromotionStartDate < @FourWeekEndDate And pb.PromotionEndDate >= @StartDate Then 'Week 1~4' 
			 When pb.PromotionStartDate <= @EndDate And pb.PromotionEndDate >= @FourWeekEndDate Then 'Week 5~8'
		End WeekEndsIdentifier	  
		From
		Playbook.PromotionBranch pb with (nolock)
		Join dbo.Split(@BranchIDs, ',') brds On pb.BranchID = brds.Value
		Where pb.PromotionStartDate <= @EndDate And pb.PromotionEndDate >= @StartDate
	End

	If (@Debug = 1)
	Begin
		Select '---- PromotionIDs ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select Count(*) NumberOfPromotions From @Promos
	End

	--~~~~~~~~~~~~~~~~~~~~~~ Stage 3. The Expand Account Hier ~~~~~~~~~~~~~~~~~~~~--
	Declare @PromoAccountHier Table
	(
		PromotionID int,
		NationalChainID int,
		RegionalChainID int,
		LocalChainID int,
		WeekEndsIdentifier varchar(20),
		Primary Key(PromotionID, NationalChainID, RegionalChainID, LocalChainID, WeekEndsIdentifier)
	) 

	Insert @PromoAccountHier
	Select Distinct pa.PromotionID, hier.NationalChainID, hier.RegionalChainID, hier.LocalChainID, pids.WeekEndsIdentifier
	From PlayBook.PromotionAccount pa
	Join @Promos pids on pa.PromotionID = pids.PromotionID
	Join Processing.tChainSeeking hier on pa.NationalChainID = hier.NationalChainID

	Insert @PromoAccountHier
	Select Distinct pa.PromotionID, -1, hier.RegionalChainID, hier.LocalChainID, pids.WeekEndsIdentifier
	From PlayBook.PromotionAccount pa
	Join @Promos pids on pa.PromotionID = pids.PromotionID
	Join Processing.tChainSeeking hier on pa.RegionalChainID = hier.RegionalChainID

	Insert @PromoAccountHier
	Select Distinct pa.PromotionID, -1, -1, pa.LocalChainID, pids.WeekEndsIdentifier
	From PlayBook.PromotionAccount pa
	Join @Promos pids on pa.PromotionID = pids.PromotionID
	Where isnull(pa.LocalChainID, 0) > 0

	If (@Debug = 1)
	Begin
		Select '---- @PromoAccountHier Expansion ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		--Select * From @PromoAccountHier Order By WeekEndsIdentifier, PromotionID, NationalChainID, RegionalChainID, LocalChainID
		Select Count(*) PromotionAccountHierCount From @PromoAccountHier
	End

	--~~~~~~~~~~~~~~~~~~~~~~ Stage 4. ChainGroups and grouping ~~~~~~~~~~~~~~~~~~~~--
	Select Distinct 
		Case When NationalChainID <> 62 Or RegionalChainID <> 242 Then 'Covered By Top Level Chain' Else 'All Other' End ChainIdentifierType,
		LocalChainID, LocalChainName, RegionalChainID, RegionalChainName, NationalChainID, NationalChainName		
	From
	(
	Select pids.PromotionID, ch.LocalChainID, ch.LocalChainName, ch.RegionalChainID, ch.RegionalChainName, ch.NationalChainID, ch.NationalChainName
	From PlayBook.PromotionAccount pa
	Join MView.ChainHier ch on pa.LocalChainID = ch.LocalChainID
	Join @Promos pids on pa.PromotionID = pids.PromotionID
	Union
	Select Distinct pids.PromotionID, Null ChainID, Null ChainName, ch.RegionalChainID, ch.RegionalChainName, ch.NationalChainID, ch.NationalChainName
	From PlayBook.PromotionAccount pa
	Join MView.ChainHier ch on pa.RegionalChainID = ch.RegionalChainID
	Join @Promos pids on pa.PromotionID = pids.PromotionID
	Union
	Select pids.PromotionID, Null ChainID, Null ChainName, null, null, ch.NationalChainID, ch.NationalChainName
	From PlayBook.PromotionAccount pa
	Join MView.ChainHier ch on pa.NationalChainID = ch.NationalChainID
	Join @Promos pids on pa.PromotionID = pids.PromotionID) temp
	Order By ChainIdentifierType, NationalChainName, RegionalChainName, LocalChainName

	Select Distinct NationalChainID, NationalChainName
	From
	(
	Select pids.PromotionID, ch.LocalChainID, ch.LocalChainName, ch.RegionalChainID, ch.RegionalChainName, ch.NationalChainID, ch.NationalChainName
	From PlayBook.PromotionAccount pa
	Join MView.ChainHier ch on pa.LocalChainID = ch.LocalChainID
	Join @Promos pids on pa.PromotionID = pids.PromotionID
	Union
	Select Distinct pids.PromotionID, Null ChainID, Null ChainName, ch.RegionalChainID, ch.RegionalChainName, ch.NationalChainID, ch.NationalChainName
	From PlayBook.PromotionAccount pa
	Join MView.ChainHier ch on pa.RegionalChainID = ch.RegionalChainID
	Join @Promos pids on pa.PromotionID = pids.PromotionID
	Union
	Select pids.PromotionID, Null ChainID, Null ChainName, null, null, ch.NationalChainID, ch.NationalChainName
	From PlayBook.PromotionAccount pa
	Join MView.ChainHier ch on pa.NationalChainID = ch.NationalChainID
	Join @Promos pids on pa.PromotionID = pids.PromotionID) temp
	Where NationalChainID <> 62
	Order By NationalChainID, NationalChainName

	Select Distinct RegionalChainID, RegionalChainName
	From
	(
	Select pids.PromotionID, ch.LocalChainID, ch.LocalChainName, ch.RegionalChainID, ch.RegionalChainName, ch.NationalChainID, ch.NationalChainName
	From PlayBook.PromotionAccount pa
	Join MView.ChainHier ch on pa.LocalChainID = ch.LocalChainID
	Join @Promos pids on pa.PromotionID = pids.PromotionID
	Union
	Select Distinct pids.PromotionID, Null ChainID, Null ChainName, ch.RegionalChainID, ch.RegionalChainName, ch.NationalChainID, ch.NationalChainName
	From PlayBook.PromotionAccount pa
	Join MView.ChainHier ch on pa.RegionalChainID = ch.RegionalChainID
	Join @Promos pids on pa.PromotionID = pids.PromotionID
	Union
	Select pids.PromotionID, Null ChainID, Null ChainName, null, null, ch.NationalChainID, ch.NationalChainName
	From PlayBook.PromotionAccount pa
	Join MView.ChainHier ch on pa.NationalChainID = ch.NationalChainID
	Join @Promos pids on pa.PromotionID = pids.PromotionID) temp
	Where NationalChainID = 62 And RegionalChainID <> 242
	Order By RegionalChainID, RegionalChainName

	If (@Debug = 1)
	Begin
		Select '---- Promotion ChainGroups Retrived ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

End

Go

--Select pa.*, rp.*
--From Playbook.PromotionAccount pa
--Join Playbook.RetailPromotion rp on pa.PromotionID = rp.PromotionID
--Where LocalChainID = 38
--Order By rp.PromotionID desc

--Select *
--From MSTR.RevChainImages
--Where ChainID = 'L00010'


