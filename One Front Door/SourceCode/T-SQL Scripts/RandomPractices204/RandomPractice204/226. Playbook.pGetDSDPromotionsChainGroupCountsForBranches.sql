USE Portal_Data805
GO

If Exists (Select * From sys.procedures Where object_id = object_id('Playbook.pGetDSDPromotionsChainGroupCountsForBranches'))
	Drop Proc Playbook.pGetDSDPromotionsChainGroupCountsForBranches
Go

Set QUOTED_IDENTIFIER ON
GO


/*
-- Deployed to 108 --

exec Playbook.pGetDSDPromotionsChainGroupCountsForBranches @BranchIDs = '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,167,168,169,170,172,173,174,175,176,177,178,179'
										  ,@Debug = 1
										  ,@Date = '2015-1-1'

exec Playbook.pGetDSDPromotionsChainGroupCountsForBranches @BranchIDs = ''
										  ,@Debug = 1
										  ,@Date = '2015-1-1'


exec Playbook.pGetDSDPromotionsChainGroupCountsForBranches @Debug = 1
										  ,@Date = '2015-1-1'

exec Playbook.pGetDSDPromotionsChainGroupCountsForBranches @Date = '2014-7-1', @Debug = 1

exec Playbook.pGetDSDPromotionsChainGroupCountsForBranches @Date = '2015-1-1', @Debug = 1

exec Playbook.pGetDSDPromotionsChainGroupCountsForBranches @Date = '2015-1-1'

exec Playbook.pGetDSDPromotionsChainGroupCountsForBranches @Debug = 1

---- San Antonio
exec Playbook.pGetDSDPromotionsChainGroupCountsForBranches @Debug = 1, @BranchIDs = 151, @Date = '2015-1-1'

---- Irving
exec Playbook.pGetDSDPromotionsChainGroupCountsForBranches @Debug = 1, @BranchIDs = 161, @Date = '2015-1-1'

exec Playbook.pGetDSDPromotionsChainGroupCountsForBranches @BranchIDs = 161, @Date = '2015-1-1'

Select *
From Playbook.PromotionAccount pa
Where PromotionID = 34605

Select *
From Playbook.PromotionGeoRelevancy
Where PromotionID = 34605

Select *
From Playbook.RetailPromotion
Where PromotionID = 34605

-- exec Playbook.pGetDSDPromotionsChainGroupCountsForBranches @Debug = 1, @BranchIDs = '161, 151', @Date = '2015-1-1'

---- Web BU
exec Playbook.pGetDSDPromotionsChainGroupCountsForBranches @Debug = 1, @Date = '2015-1-1', @BranchIDs = '118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,154,155,165,167,168,169'

exec Playbook.pGetDSDPromotionsChainGroupCountsForBranches @Date = '2015-1-1', @BranchIDs = '118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,154,155,165,167,168,169'

*/

--Select *
--From Playbook.PromotionAccount
--Where PromotionID = 36706

--Select *
--From Playbook.RetailPromotion
--Where PromotionID = 36706

--Declare @StartDAte Date
--Set @StartDAte = '2015-01-01'
--DEclare @EndDate Date
--Set @EndDate = '2015-02-26'

--Select *
--From
--Playbook.PromotionBranch pb with (nolock)
--Where pb.PromotionStartDate < @EndDate And pb.PromotionEndDate > @StartDate -- EndDate is inclusive, See promotion 34605 for details, 1-1 is not valid for that one
--And BranchID = 161
--And PromotionID = 36706
--Order By PromotionID
 
--	Select Distinct PromotionID,
--		Case When pb.PromotionStartDate <= @FourWeekEndDate Then 1 Else 0 End First4,
--		Case When pb.PromotionEndDate > @FourWeekEndDate Then 1 Else 0 End Last4
--	From
--	Playbook.PromotionBranch pb with (nolock)
--	Where pb.PromotionStartDate <= @EndDate And pb.PromotionEndDate > @StartDate -- EndDate is inclusive, See promotion 34605 for details, 1-1 is not valid for that one
--	And BranchID = 161

--Go

Create Proc Playbook.pGetDSDPromotionsChainGroupCountsForBranches
(
	@BranchIDs nvarchar(4000) = '',
	@Debug bit = 0, 
	@Date DateTime = null
)
AS
Begin
	/*  Rivision History
	2015-10-20 First Version; Installed on 108


	*/

	Set NoCount On;

	Declare @StartDate DateTime, @EndDate DateTime, @FourWeekEndDate DateTime

	If (@Debug = 1)
	Begin
		Declare @StartTime DateTime2(7)
		Set @StartTime = SYSDATETIME()

		Select '---- Starting ----' Debug, @BranchIDs BranchIDs, @Date StartDate
	End

	--~~~~~~~~~~~~~~~~~~~~~~ Stage 1. Parameters and User target ~~~~~~~~~~~~~~~~~~~~--
	--- If @BranchIDs parameter is set to be '', then it'll get converted to be null
	Print 'Processing parameters'
	If (@BranchIDs = '')
		Set @BranchIDs = null

	If (@BranchIDs is null)
	Begin
		Set @BranchIDs = ''
		Select @BranchIDs = @BranchIDs + Convert(Varchar, BranchID) + ','
		From SAP.Branch
		Set @BranchIDs = SUBSTRING(@BranchIDs, 0, Len(@BranchIDs) - 1)
	End

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
									,@BranchIDs BranchIDs, @StartDate StartDate, @FourWeekEndDate FourWeekEndDate, @EndDate EndDate
	End

	--~~~~~~~~~~~~~~~~~~~~~~ Stage 2. The query ~~~~~~~~~~~~~~~~~~~~--
	Declare @Promos Table 
	(
		PromotionID int,
		PromotionStartDate Date,
		PromotionEndDate Date,
		First4 bit,
		Last4 bit
		Primary Key(PromotionID, First4, Last4)
	)

	Insert Into @Promos
	Select Distinct pb.PromotionID, pb.PromotionStartDate, pb.PromotionEndDate, 
		Case When pb.PromotionStartDate <= @FourWeekEndDate Then 1 Else 0 End First4,
		Case When pb.PromotionEndDate > @FourWeekEndDate Then 1 Else 0 End Last4
	From
	PreCal.PromotionBranch pb with (nolock)
	Join dbo.Split(@BranchIDs, ',') brds On pb.BranchID = brds.Value
	Join Playbook.RetailPromotion rp on pb.PromotionID = rp.PromotionID
	Where rp.InformationCategory = 'Promotion'
	And pb.PromotionStartDate <= @EndDate And pb.PromotionEndDate > @StartDate -- @EndDate is inclusive, See promotion 34605 for details, 1-1 is not valid for that one

	If (@Debug = 1)
	Begin
		Select '---- PromotionIDs ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select Count(*) PromotionCount From @Promos
		Select * From @Promos Order By PromotionEndDate ASC
	End

	--~~~~~~~~~~~~~~~~~~~~~~ Stage 3. ChainGroups for the location ~~~~~~~~~~~~~~~~~~~~--
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
	Select Distinct pa.PromotionID, hier.NationalChainID, hier.RegionalChainID, hier.LocalChainID, 
		Case When pids.Last4 = 0 Then 'Weeks 1~4' When pids.First4 = 0 Then 'Weeks 5~8' Else 'Both' End WeekEndsIdentifier
	From PlayBook.PromotionAccount pa
	Join @Promos pids on pa.PromotionID = pids.PromotionID
	Join PreCal.ChainHier hier on pa.NationalChainID = hier.NationalChainID

	Insert @PromoAccountHier
	Select Distinct pa.PromotionID, -1, hier.RegionalChainID, hier.LocalChainID,
		Case When pids.Last4 = 0 Then 'Weeks 1~4' When pids.First4 = 0 Then 'Weeks 5~8' Else 'Both' End WeekEndsIdentifier	
	From PlayBook.PromotionAccount pa
	Join @Promos pids on pa.PromotionID = pids.PromotionID
	Join PreCal.ChainHier hier on pa.RegionalChainID = hier.RegionalChainID

	Insert @PromoAccountHier
	Select Distinct pa.PromotionID, -1, -1, pa.LocalChainID, 
		Case When pids.Last4 = 0 Then 'Weeks 1~4' When pids.First4 = 0 Then 'Weeks 5~8' Else 'Both' End WeekEndsIdentifier	
	From PlayBook.PromotionAccount pa
	Join @Promos pids on pa.PromotionID = pids.PromotionID
	Where isnull(pa.LocalChainID, 0) > 0

	If (@Debug = 1)
	Begin
		Select '---- @PromoAccountHier Expansion ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		--Select * From @PromoAccountHier Order By WeekEndsIdentifier, PromotionID, NationalChainID, RegionalChainID, LocalChainID
		Select Count(*) PromotionAccountHierCount From @PromoAccountHier
	End

	--~~~~~~~~~~~~~~~~~~~~~~~ Stage 3.5 Promotion ChainGroup Week Ends ~~~~~~
	--Declare @PCWe Table
	--(
	--	PromotionID int, ChainGroupID int, WeekEndsIdentifier varchar(20)
	--)
	
	--Insert Into @PCWe(ChainGroupID, PromotionID, WeekEndsIdentifier)
	--Select Distinct chainGroupMapping.ChainGroupID, PromotionID, WeekEndsIdentifier
	--From 
	--(
	--	Select Distinct pa.PromotionID, pa.WeekEndsIdentifier, mstr.ChainGroupID
	--	From @PromoAccountHier pa
	--	Join Playbook.ChainGroupLocalChain mstr on pa.LocalChainID = mstr.LocalChainID
	--	Union
	--	Select Distinct pa.PromotionID, pa.WeekEndsIdentifier, mstr.ChainGroupID
	--	From @PromoAccountHier pa
	--	Join Playbook.ChainGroupRegionalChain mstr on pa.RegionalChainID = mstr.RegionalChainID
	--	Union
	--	Select Distinct pa.PromotionID, pa.WeekEndsIdentifier, mstr.ChainGroupID
	--	From @PromoAccountHier pa
	--	Join Playbook.ChainGroupNationalChain mstr on pa.NationalChainID = mstr.NationalChainID
	--) chainGroupMapping 
	--Join PreCal.BranchChainGroup bcg on chainGroupMapping.ChainGroupID =  bcg.ChainGroupID
	--Join dbo.Split(@BranchIDs, ',') brds On bcg.BranchID = brds.Value

	--Insert Into @PCWe 
	--Select ChainGroupID, PromotionID, 'Weeks 1~4' From @PCWe Where WeekEndsIdentifier = 'Both'

	--Update @PCWe 
	--Set WeekEndsIdentifier = 'Weeks 5~8' Where WeekEndsIdentifier = 'Both'

	--If (@Debug = 1)
	--Begin
	--	Select '---- PromoAccount Reduction And Duplication ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	--	--Select * From @PromoAccountHier Order By WeekEndsIdentifier, PromotionID, NationalChainID, RegionalChainID, LocalChainID
	--	Select Count(*) PromotionWithWeekEndsAndChainGroupCounts From @PCWe
	--	Select WeekEndsIdentifier, PromotionID, p.ChainGroupID, ChainGroupName 
	--	From @PCWe p
	--	Join PlayBook.ChainGroup cg on p.ChainGroupID = cg.ChainGroupID
	--	Order By WeekEndsIdentifier, PromotionID, ChainGroupName
	--End

	----~~~~~~~~~~~~~~~~~~~~~~ Stage 4. ChainGroups and grouping ~~~~~~~~~~~~~~~~~~~~--
	--Declare @Output Table
	--(
	--	WeekEndsIdentifier varchar(20),
	--	ChainGroupID int,
	--	ChainGroupName varchar(100),
	--	WebImageURL varchar(200),
	--	IsAllOther bit,
	--	TrueRegional bit,
	--	CoveredByNational bit,
	--	PromotionCount int
	--)

	--Insert @Output(WeekEndsIdentifier, ChainGroupID, ChainGroupName, WebImageURL, IsAllOther, TrueRegional, CoveredByNational, PromotionCount)
	--Select WeekEndsIdentifier, c.ChainGroupID, c.ChainGroupName, c.WebImageURL, IsAllOther, TrueRegional, CoveredByNational, cnt.PromotionCount
	--From
	--(
	--	Select WeekEndsIdentifier, ChainGroupID, Count(*) PromotionCount
	--	From @PCWe
	--	Group By WeekEndsIdentifier, ChainGroupID
	--) cnt
	--Join PlayBook.ChainGroup c on cnt.ChainGroupID = c.ChainGroupID

	--Select * From @Output
	--Order By WeekEndsIdentifier, ChainGroupName

	--If (@Debug = 1)
	--Begin
	--	Select '---- Promotion ChainGroups Retrived ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds

	--	Select Distinct ChainGroupID, ChainGroupName, Case When IsAllOther = 1 Then 'Local' When TrueRegional = 1 Then 'Regional' When CoveredByNational = 1 Then 'National' End ChainType, WebImageURL
	--	From @Output
	--	Order By ChainType, ChainGroupName

	--	Select ChainType, Count(*) NumberOfChains
	--	From
	--	(Select Distinct ChainGroupID, ChainGroupName, Case When IsAllOther = 1 Then 'Local' When TrueRegional = 1 Then 'Regional' When CoveredByNational = 1 Then 'National' End ChainType From @Output) cg
	--	Group By ChainType
	--End

End

Go

