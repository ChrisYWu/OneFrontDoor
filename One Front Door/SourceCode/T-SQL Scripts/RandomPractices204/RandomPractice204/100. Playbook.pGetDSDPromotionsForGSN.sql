USE Portal_Data805
GO

exec [Playbook].[pGetPlayBookDetailsByDate1]
@StartDate = '2015-04-01' -- Promotion Start date
,@EndDate = '2015-07-01' -- Promotion End Date
,@currentuser = 'WUXYX001' -- Current user location scope
,@Branchid = '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,167,168,169,170,172,173,174,175,176,177,178,179' -- Current user Branch ID
--,@RegionID INT -- Current user Region ID
--	,@VIEW_DRAFT_NA BIT -- True/False : if the user has the rights to View National Account promotion in draft mode for Promotion Activities
--	,@ViewNatProm BIT -- True/False :  if the user has the rights to View National Promotion for Promotion Activities                                                                                           
--	,@RolledOutAccount VARCHAR(MAX) = '' -- Optional parameter with default null value for rolled out account, passed from front end using SRE
--	,@EditPromotionNA BIT
--	,@EditPromotionDSD BIT
--	,@CurrentPersonaID INT = 0

--Declare @Bids varchar(200)
--Set @Bids  = ''
--Select @Bids = @Bids + convert(varchar, branchID) + ','
--From SAP.Branch

--Select @Bids 

--Select convert(varchar, branchID) + ','
--From SAP.Branch for XML Path ('')

Select v.PromotionID PID, c.*
From Staging.PromoV v
Left Join Staging.PromtionsForComparison c on v.PromotionID = c.PromotionID
Where c.PromotionID is null
Order By v.PromotionID  desc

Select v.PromotionID PID, c.*
From Staging.PromoV v
right Join Staging.PromtionsForComparison c on v.PromotionID = c.PromotionID
Order By v.PromotionID  desc

Select PromotionRelevantStartDate, PromotionRelevantEndDate
From Playbook.RetailPromotion rp
Where PromotionID = 59331
And rp.PromotionRelevantStartDate <= '2015-07-01' And rp.PromotionRelevantEndDate >= '2015-04-01'

--Drop Table Staging.PromtionsForComparison 

exec Playbook.pGetDSDPromotionsForGSN @GSN = 'ROWJX002', @Debug = 1, @EnableLogging = 1, @StartDate = '2015-04-01', @EndDate = '2015-07-01'


If Exists (Select * From sys.procedures Where object_id = object_id('Playbook.pGetDSDPromotionsForGSN'))
	Drop Proc Playbook.pGetDSDPromotionsForGSN
Go

SET QUOTED_IDENTIFIER ON
GO

/*
--- 'Joe Rowland'
exec Playbook.pGetDSDPromotionsForGSN @GSN = 'ROWJX002', @Debug = 1, @EnableLogging = 1, @@
exec Playbook.pGetDSDPromotionsForGSN @GSN = 'ROWJX002', @EnableLogging = 1

exec Playbook.pGetDSDPromotionsForGSN @GSN = 'ROWJX002', @StartDate = '2015-04-01', @EndDate = '2015-07-01', @Debug = 1, @EnableLogging = 1
exec Playbook.pGetDSDPromotionsForGSN @GSN = 'ROWJX002', @StartDate = '2015-04-01', @EndDate = '2015-07-01', @EnableLogging = 1

Select Top 5 * From Playbook.PromotionRequestLog

exec Playbook.pGetDSDPromotionsForGSN @GSN = 'WUXYX001', @StartDate = '2015-04-01', @EndDate = '2015-07-01', @Debug = 1, @EnableLogging = 1

exec Playbook.pGetDSDPromotionsForGSN @GSN = 'WUXYX001', @StartDate = '2015-04-01', @EndDate = '2015-07-01', @EnableLogging = 1

Select Top 5 * From Playbook.PromotionRequestLog

*/

Create Proc Playbook.pGetDSDPromotionsForGSN
(
	@GSN Varchar(50), 
	@StartDate DateTime = null,
	@EndDate DateTime = null,
	@Debug bit = 0,
	@EnableLogging bit = 0
)
AS
Begin
	Set NoCount On;
	
	--~~~~~~~~~~~~~~~~~~~~~~ Stage 1. Parameters and User target ~~~~~~~~~~~~~~~~~~~~--
	--- If parameter is set to be '', then it'll get converted to be the default value of DateTime '1900-1-1'
	Print 'Processing parameters'
	If (@StartDate = '1900-1-1')
		Set @StartDate = null

	If (@EndDate = '1900-1-1')
		Set @EndDate = null

	If (@StartDate is null)
		Set @StartDate = Convert(Date, GetDate())

	If (@EndDate is null)
		Set @EndDate = DateAdd(month, 3, @StartDate)

	If (@StartDate >= @EndDate)
		Set @EndDate = DateAdd(day, 1, @StartDate)
	---------- Date done -----------

	If (@Debug is null)
		Set @Debug = 0
	
	If (@EnableLogging is null)
		Set @EnableLogging = 0

	If(@EnableLogging = 1)
	Begin
		Declare @LogID int
		Insert Into Playbook.PromotionRequestLog(GSN, PromotionStartDate, PromotionEndDate, StartDate) Values(@GSN, @StartDate, @EndDate, SYSDATETIME())
		Select @LogID = Scope_Identity()
	End

	--------------------
	Declare @Hier Table
	(
		BUID int,
		RegionID int,
		AreaID int,
		BranchID int,
		BranchName varchar(200),
		StateRegionID int
	)

	Insert into @Hier(BUID, RegionID, AreaID, BranchID, BranchName)
	Select lh.BUID, lh.RegionID, lh.AreaID, lh.BranchID, lh.BranchName
	From Person.UserLocation ulb, MView.LocationHier lh
	Where ulb.GSN = @GSN And ulb.BranchID = lh.BranchID
	Union
	Select Distinct lh.BUID, lh.RegionID, lh.AreaID, lh.BranchID, lh.BranchName
	From Person.UserLocation ulb, MView.LocationHier lh
	Where ulb.GSN = @GSN And ulb.AreaID = lh.AreaID
	Union
	Select Distinct lh.BUID, lh.RegionID, lh.AreaID, lh.BranchID, lh.BranchName
	From Person.UserLocation ulb, MView.LocationHier lh
	Where ulb.GSN = @GSN And ulb.RegionID = lh.RegionID
	Union
	Select Distinct lh.BUID, lh.RegionID, lh.AreaID, lh.BranchID, lh.BranchName
	From Person.UserLocation ulb, MView.LocationHier lh
	Where ulb.GSN = @GSN And ulb.BUID = lh.BUID

	Update h
	Set h.StateRegionID = sr.StateRegionID
	From @Hier h
	Join SAP.Branch b on h.BranchID = b.BranchID
	Join Shared.StateRegion sr on sr.RegionABRV = b.State

	If (@Debug = 1)
	Begin
		Declare @StartTime DateTime2(7)
		Set @StartTime = SysDateTime()
		Select '---- Input Parameters ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		
		Select @GSN GSN, Title, FirstName, LastName, @StartDate StartDateParameter, @EndDate EndDateParameter, @Debug DebugFlagParameter, @@SERVERNAME [Server], DB_NAME() [Database]
		From Person.UserProfile Where GSN = @GSN

		Select '---- User relevant branch hierachy ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select * From @Hier

	End
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	--~~~~~~~~~~~~ Stage 2. Promotion pre-fitlering and Geography expansion ~~~~~~~~--
	Select pgr.PromotionId PromotionID, pgr.BUID, pgr.RegionID, pgr.AreaID, pgr.BranchID, pgr.StateId StateID
	Into #PromoGeoR
	From Playbook.PromotionGeoRelevancy pgr With (nolock)
	Join Playbook.RetailPromotion rp with (nolock) on pgr.PromotionId = rp.PromotionId
	Where (
		Coalesce(BUID, 0) > 0
		Or Coalesce(RegionID, 0) > 0
		Or Coalesce(AreaID, 0) > 0
		Or Coalesce(BranchID, 0) > 0
		Or Coalesce(StateID, 0) > 0
	)
	And rp.PromotionRelevantStartDate <= @EndDate And rp.PromotionRelevantEndDate >= @StartDate

	If (@Debug = 1)
	Begin
		Select '---- Promotion geo relevancy raw data within Date Range ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select * From #PromoGeoR
	End

	----- BTTLR driver table -----
	Create Table #PGR
	(
		PromotionID int not null,
		BranchID int
	)

	Create Clustered Index IDX_PGR_PromotionID_BranchID ON #PGR(PromotionID, BranchID)

	---------------
	Insert Into #PGR(PromotionID, BranchID)
	Select Distinct pgr.PromotionID, v.BranchID
	from #PromoGeoR pgr
	Join @Hier v on pgr.BUID = v.BUID
	Where StateID is null
	Union
	Select Distinct pgr.PromotionID, v.BranchID
	from #PromoGeoR pgr
	Join @Hier v on pgr.RegionID = v.RegionID
	Where StateID is null And pgr.BUID is null
	Union
	Select Distinct pgr.PromotionID, v.BranchID
	from #PromoGeoR pgr
	Join @Hier v on pgr.AreaID = v.AreaID
	Where StateID is null And pgr.RegionID is null And pgr.BUID is null
	Union
	Select Distinct pgr.PromotionID, v.BranchID
	from #PromoGeoR pgr
	Join @Hier v on pgr.BranchID = v.BranchID
	Where StateID is null And pgr.BUID is null And pgr.RegionID is null And pgr.AreaID is null
	Union
	Select Distinct pgr.PromotionID, v.BranchID
	from #PromoGeoR pgr
	Join @Hier v on pgr.StateID = v.StateRegionID

	If (@Debug = 1)
	Begin
		Select '---- Expanded Promotion Geo Relevancy ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select Count(*) NumberOfExpandedRelations From #PGR		
	End

	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	Select Distinct pgr.PromotionID
	Into #PromotionID1
	From MView.BranchBrand bb, -- Promotion Brand Association
	(
		Select Distinct PromotionID, b.BrandID
		From Playbook.PromotionBrand pb With (nolock)
		Join SAP.Brand b on (pb.TrademarkID = b.TrademarkID)
		Union
		Select PromotionID, BrandID
		From Playbook.PromotionBrand With (nolock) Where Coalesce(TradeMarkID,0) = 0 
	) ptm, -- Promotion Brand
	#PGR pgr  --Promotion Geo
	Where pgr.BranchID = bb.BranchID
	And bb.BrandID = ptm.BrandID
	And pgr.PromotionID = ptm.PromotionID
	
	If (@Debug = 1)
	Begin
		Select '---- Promotion filtered by Brands ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select Count(*) NumberOfPromotions From #PromotionID1
	End

	Select Distinct pgr.PromotionID
	Into #PromotionID
	From 	
	#PGR pgr, -- Promotion Geo
	(
		Select PromotionID, LocalChainID
		From Playbook.PromotionAccount With (nolock) Where Coalesce(LocalChainID, 0) > 0
		Union
		Select PromotionID, lc.LocalChainID
		From Playbook.PromotionAccount pa With (nolock)
		Join SAP.LocalChain lc on(pa.RegionalChainID = lc.RegionalChainID) Where Coalesce(pa.RegionalChainID, 0) > 0
		Union
		Select PromotionID, lc.LocalChainID
		From Playbook.PromotionAccount pa With (nolock)
		Join SAP.RegionalChain rc on pa.NationalChainID = rc.NationalChainID
		Join SAP.LocalChain lc on rc.RegionalChainID = lc.RegionalChainID Where Coalesce(pa.NationalChainID, 0) > 0
	) pc, --- Promotion Chain
	Shared.tLocationChain tlc,
	#PromotionID1 p1
	Where pgr.BranchID = tlc.BranchID
	And tlc.LocalChainID = pc.LocalChainID
	And pc.PromotionID = pgr.PromotionID
	And p1.PromotionID = pgr.PromotionID

	If (@Debug = 1)
	Begin
		Select '---- Promotion further filtered further by Chains ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select Count(*) NumberOfPromotions From #PromotionID
	End

	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	--~~~~~~~~~~~~~~~~~~~ Stage 4. Output promotions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
	If (@Debug = 1)
	Begin
		Select '---- Generating Output 1: Promotions ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

	--Select PromotionID 
	--Into Staging.PromtionsForComparison
	--From #PromotionID

	SELECT distinct rp.PromotionID 'PromotionID'
		,PromotionName 'PromotionName'
		,PromotionDescription 'Comment'
		,rp.PromotionStartDate 'InStoreStartDate'
		,rp.PromotionEndDate 'InStoreEndDate'
		,DisplayStartDate 'DisplayStartDate'
		,DisplayEndDate 'DisplayEndDate'
		,PricingStartDate 'PricingStartDate'
		,PricingEndDate 'PricingEndDate'
		,ForecastVolume 'ForecastedVolume'
		,NationalDisplayTarget 'NationalDisplayTarget'
		,PromotionPrice 'RetailPrice'
		,BottlerCommitment 'InvoicePrice'
		,pc.promotioncategoryname 'Category'
		,case pdl.DisplayRequirement when 1 then 'Mandatory' when 2 then 'Local Sell-In' else 'No Display' end as 'DisplayRequirement'
		,DisplayLocationID 'DisplayLocationID'
		,DisplayTypeID 'DisplayTypeID'
		,PromotionType 'PromotionType'
		,pdl.PromotionDisplayLocationOther 'DisplayComments'
		,0 'DisplayRequired'
		,pr.Rank [Priority]
		,rp.promotionstatusid [PromotionStatusID]
		,rp.CreatedDate , rp.ModifiedDate
		--,Case When InformationCategory = 'Promotion' Then 1 Else 0 end InformationCategory
		,InformationCategory
	FROM playbook.retailpromotion rp With (nolock)
	Join #PromotionID pids on rp.PromotionID = pids.PromotionID 
	Join playbook.promotiontype pt With (nolock) ON rp.Promotiontypeid = pt.promotiontypeid
	Join playbook.promotioncategory pc With (nolock) ON rp.promotioncategoryid = pc.promotioncategoryid
	Join playbook.promotiondisplaylocation pdl With (nolock) ON rp.promotionid = pdl.promotionid
	left join Playbook.PromotionRank pr With (nolock) on pr.promotionid = rp.PromotionID
		and 
			case when rp.PromotionEndDate < playbook.fGetMonday(getdate()) then  playbook.fGetSunday(rp.PromotionEndDate) 
				when rp.PromotionStartDate > playbook.fGetSunday(getdate()) then  playbook.fGetMonday(rp.PromotionStartDate)
				else playbook.fGetMonday(getDate())
			end = 
			case when rp.PromotionEndDate < playbook.fGetMonday(getdate()) then  pr.PromotionWeekEnd
				when rp.PromotionStartDate > playbook.fGetSunday(getdate()) then  pr.PromotionWeekStart 
				else pr.PromotionWeekStart
			end 
	Order By PromotionID

	If (@Debug = 1)
	Begin
		Select '---- Generating Output 2: Promotion Brands ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

	SELECT a.PromotionID 'PromotionID'
		,Coalesce(a.BrandID, 0) 'BrandID', b.BrandName
		,case when isnull(a.TrademarkID,0) = 0 then b.trademarkid else a.TrademarkID end 'TrademarkID'
	FROM playbook.promotionbrand a With (nolock)
	Join #PromotionID pids on a.PromotionID = pids.PromotionID 
	left join sap.brand b With (nolock) on a.brandid = b.brandid
	Order By PromotionID, TrademarkID, BrandID

	If (@Debug = 1)
	Begin
		Select '---- Generating Output 3: Promotion Chains----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

	SELECT a.PromotionID 'PromotionID',		
		Coalesce(case 
			when isnull(a.RegionalChainID ,0) <> 0  then
			(select nationalchainid from sap.regionalchain where RegionalChainID = a.RegionalChainID )
			when isnull(a.LocalChainID ,0) <> 0  then
			(select c.nationalchainid from sap.localchain b
			left join sap.regionalchain c on b.regionalchainid = c.regionalchainid
			where localchainid = a.localchainid )
			else a.nationalchainid
		end, 0) 'NationalChainID'
		,
		Coalesce(case when isnull(a.LocalChainID ,0) <> 0  then
			(select regionalchainid from sap.localchain where localchainid = a.localchainid )
		else a.RegionalChainID
		end, 0) 'RegionalChainID'
		,Coalesce(LocalChainID,0) 'LocalChainID'
	FROM playbook.promotionaccount a With (nolock)
	Join #PromotionID pids on a.PromotionID = pids.PromotionID 
	Order By PromotionID, NationalChainID, RegionalChainID, LocalChainID

	If (@Debug = 1)
	Begin
		Select '---- Generating Output 4: Promotion Attachments ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

	SELECT pa.PromotionID 'PromotionID'
		,AttachmentURL 'FileURL'
		,AttachmentName 'FileName'
		,AttachmentSize 'Size'
		,at.AttachmentTypeName 'Type'
		,pa.PromotionAttachmentID 'AttachmentID',
		pa.AttachmentDateModified 'ModifiedDate'
	FROM playbook.promotionattachment pa With (nolock)
	Join Playbook.AttachmentType at ON pa.AttachmentTypeID = at.AttachmentTypeID
	Join #PromotionID pids on pa.PromotionID = pids.PromotionID 
	Order By PromotionID, AttachmentName

	If (@Debug = 1)
	Begin
		Select '---- Generating Output 5: Promotion Package ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

	SELECT pa.PromotionID 'PromotionID',
		PackageID 
	FROM playbook.promotionpackage pa With (nolock)
	Join #PromotionID pids on pa.PromotionID = pids.PromotionID 
	Order By PromotionID, PackageID

	--~~~~~~~~~~~~~~~~~~~~~~~~~ Stage 5. Complete logging ~~~~~~~~~~~~~~~~~~~~~~~~~~--
	---------------------------------------------------------
	If (@Debug = 1)
	Begin
		Select '---- All done. Updating logging if needed ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

	If(@EnableLogging = 1)
	Begin
		Declare @NumberOfPromotion int, @NumberOfRegion int, @NumberOfBottler int, @EndTime DateTime2(7), @CurrentPromotionCount int
		Declare @NumberOfAttachment int, @NumberOfBranch int
		
		Select @NumberOfPromotion = count(*) From #PromotionID
		Select @CurrentPromotionCount = Count(*) From Playbook.RetailPromotion With (nolock) Where PromotionID in (Select PromotionID From #PromotionID) And GetDate() Between PromotionStartDate And PromotionEndDate
		Select @NumberOfAttachment = count(*) From Playbook.PromotionAttachment pa With (nolock) Join #PromotionID  p on pa.PromotionID = p.PromotionID
		Select @NumberOfBranch = Count(*) From @Hier

		Update Playbook.PromotionRequestLog
		Set EndDate = SYSDATETIME()
		, NumberOfPromotion = @NumberOfPromotion
		, NumberOfCurrentPromotion = @CurrentPromotionCount
		, NumberOfBranch = @NumberOfBranch
		Where LogID = @LogID

		If (@Debug = 1)
		Begin
			Select *
			From Playbook.PromotionRequestLog
			Where LogID = @LogID
		End

	End

End

Go

