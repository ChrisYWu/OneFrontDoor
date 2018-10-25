USE Portal_Data805
GO

If Exists (Select * From sys.procedures Where object_id = object_id('Playbook.pGetDSDPromotionsAccountCountsForBranches'))
	Drop Proc Playbook.pGetDSDPromotionsAccountCountsForBranches
Go

Set QUOTED_IDENTIFIER ON
GO

/*
-- Deployed to 108 --

exec Playbook.pGetDSDPromotionsAccountCountsForBranches @BranchIDs = '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,167,168,169,170,172,173,174,175,176,177,178,179'
										  ,@Debug = 1
										  ,@Date = '2015-1-1'

exec Playbook.pGetDSDPromotionsAccountCountsForBranches @BranchIDs = ''
										  ,@Debug = 1
										  ,@Date = '2015-1-1'


exec Playbook.pGetDSDPromotionsAccountCountsForBranches @Debug = 1
										  ,@Date = '2015-1-1'

exec Playbook.pGetDSDPromotionsAccountCountsForBranches @Date = '2015-1-1'

exec Playbook.pGetDSDPromotionsAccountCountsForBranches @Date = '2015-1-1', @Debug = 1


----- Irving --------
exec Playbook.pGetDSDPromotionsAccountCountsForBranches @Debug = 1, @BranchIDs = 161, @Date = '2015-1-1'


exec Playbook.pGetDSDPromotionsAccountCountsForBranches @Debug = 1, @BranchIDs = 151, @Date = '2015-1-1'

----- Web BU ------
exec Playbook.pGetDSDPromotionsAccountCountsForBranches @Debug = 1, @Date = '2015-1-1', @BranchIDs = '118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,154,155,165,167,168,169'

*/

Go
Create Proc Playbook.pGetDSDPromotionsAccountCountsForBranches
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

		Select '---- Starting ----' Debug, @BranchIDs BranchIDs, @Date InputDate
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
		WeekEndsIdentifier varchar(20)
	)

	If (@BranchIDs is null)
	Begin
		Insert Into @Promos
		Select Distinct PromotionID, 
		Case When pb.PromotionStartDate < @FourWeekEndDate And pb.PromotionEndDate >= @StartDate Then 'Week 1~4' 
			 When pb.PromotionStartDate <= @EndDate And pb.PromotionEndDate >= @FourWeekEndDate Then 'Week 5~8'
		End WeekEndsIdentifier	  
		From
		Precal.PromotionBranch pb with (nolock)
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
		Precal.PromotionBranch pb with (nolock)
		Join dbo.Split(@BranchIDs, ',') brds On pb.BranchID = brds.Value
		Where pb.PromotionStartDate <= @EndDate And pb.PromotionEndDate >= @StartDate
	End

	If (@Debug = 1)
	Begin
		Select '---- PromotionIDs ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select Count(Distinct PromotionID) NumberOfPromotions From @Promos
		--Select * From @Promos
	End

	--~~~~~~~~~~~~~~~~~~~~~~ Stage 3. Chains and grouping ~~~~~~~~~~~~~~~~~~~~--
	Select WeekEndsIdentifier, ChainType, ChainID, ChainName, Count(*) NumberOfPromotions
	From
	(
	Select pids.PromotionID, pids.WeekEndsIdentifier, 'L' ChainType, ch.LocalChainID ChainID, ch.LocalChainName ChainName
	From PlayBook.PromotionAccount pa
	Join SAP.LocalChain ch on pa.LocalChainID = ch.LocalChainID
	Join @Promos pids on pa.PromotionID = pids.PromotionID
	Union
	Select pids.PromotionID, pids.WeekEndsIdentifier, 'R' ChainType, rc.RegionalChainID ChainID, rc.RegionalChainName ChainName
	From PlayBook.PromotionAccount pa
	Join SAP.RegionalChain rc on pa.RegionalChainID = rc.RegionalChainID
	Join @Promos pids on pa.PromotionID = pids.PromotionID
	Union
	Select pids.PromotionID, pids.WeekEndsIdentifier, 'N' ChainType, nc.NationalChainID ChainID, nc.NationalChainName ChainName
	From PlayBook.PromotionAccount pa
	Join SAP.NationalChain nc on pa.NationalChainID = nc.NationalChainID
	Join @Promos pids on pa.PromotionID = pids.PromotionID) temp
	Group By WeekEndsIdentifier, ChainName, ChainType, ChainID

	If (@Debug = 1)
	Begin
		Select '---- Promotion Chains Retrived ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds

		Select Distinct ChainType + Convert(varchar, ChainID) ChainGroup, ChainName
		From
		(
		Select pids.PromotionID, pids.WeekEndsIdentifier, 'N' ChainType, nc.NationalChainID ChainID, nc.NationalChainName ChainName
		From PlayBook.PromotionAccount pa
		Join SAP.NationalChain nc on pa.NationalChainID = nc.NationalChainID
		Join @Promos pids on pa.PromotionID = pids.PromotionID
		Union
		Select pids.PromotionID, pids.WeekEndsIdentifier, 'R' ChainType, rc.RegionalChainID ChainID, rc.RegionalChainName ChainName
		From PlayBook.PromotionAccount pa
		Join SAP.RegionalChain rc on pa.RegionalChainID = rc.RegionalChainID
		Join @Promos pids on pa.PromotionID = pids.PromotionID
		Union
		Select pids.PromotionID, pids.WeekEndsIdentifier, 'L' ChainType, ch.LocalChainID ChainID, ch.LocalChainName ChainName
		From PlayBook.PromotionAccount pa
		Join SAP.LocalChain ch on pa.LocalChainID = ch.LocalChainID
		Join @Promos pids on pa.PromotionID = pids.PromotionID
		) temp
		Group By WeekEndsIdentifier, ChainName, ChainType, ChainID
		Order By ChainName

	End

End

Go

--Select pa.*, rp.*
--From Playbook.PromotionAccount pa
--Join Playbook.RetailPromotion rp on pa.PromotionID = rp.PromotionID
--Where LocalChainID = 38
--Order By rp.PromotionID desc

/*
Select *
From Processing.tBranchForSeeking
Where BUID = 7

Declare @BranchID varchar(4000)
Set @BranchID = ''

Select @BranchID = @BranchID + Convert(varchar, BranchID) + ','
From Processing.tBranchForSeeking
Where BUID = 7

Select @BranchID
*/

--Select *
--From SAP.Branch
--Where BranchName like 'San A%'

--Select *
--From MSTR.RevChainImages
--Where NationalChainID = 185


