USE Portal_Data805
GO

If Exists (Select * From sys.procedures Where object_id = object_id('BCMyday.pGetBCPromotionsForGSN9'))
	Drop Proc BCMyday.pGetBCPromotionsForGSN9
Go

SET QUOTED_IDENTIFIER ON
GO

--Select *
--From BC.


--[BCMyday].[pGetPromotionIDsByBottler]

--Select *
--From BC.tBottlerChainTradeMark
--Where LocalChainID in (
--7,
--3332,
--3397)






/*
exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'BUTJX004', @EnableLogging = 1

exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'BUTJX004', @Debug = 1, @EnableLogging = 1

exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'WATBX001', @Debug = 1

exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'WATBX001', @EnableLogging = 1

exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'ALBDX003', @EnableLogging = 1

exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'BUTJX004', @EnableLogging = 1

exec BCMyday.pGetBCPromotionsForGSN9 @GSN = 'WATBX001', @Debug = 1, @EnableLogging = 1

*/

Create Proc BCMyday.pGetBCPromotionsForGSN9
(
	@GSN Varchar(50), 
	@LastModified DateTime = null,
	@Debug bit = 0,
	@EnableLogging bit = 0
)
AS
Begin
	Set NoCount On;
	
	--~~~~~~~~~~~~~~~~~~~~~~ Stage 1. Parameters and User target ~~~~~~~~~~~~~~~~~~~~--
	--- If parameter is set to be '', then it'll get converted to be the default value of DateTime '1900-1-1'
	Print 'Processing parameters'
	If (@LastModified = '1900-1-1')
		Set @LastModified = null

	If (@Debug is null)
		Set @Debug = 0
	
	If (@EnableLogging is null)
		Set @EnableLogging = 0

	If(@EnableLogging = 1)
	Begin
		Declare @LogID int
		Insert Into BCMyDay.PromotionRequestLog(GSN, MDate, StartDate) Values(@GSN, @LastModified, SYSDATETIME())
		Select @LogID = Scope_Identity()
	End

	--------------------
	Declare @Hier Table
	(
		SystemID int,
		ZoneID int,
		DivisionID int,
		RegionID int,
		BCRegionID int, 
		BottlerID int,
		BottlerName varchar(400)
	)

	Insert into @Hier
	Select v.SystemID, v.ZoneID, v.DivisionID, v.RegionID, v.RegionNodeID, b.BottlerID, b.BottlerName
	From BC.vSalesHierarchy v
	Join BC.Bottler b on b.BCRegionID = v.RegionID
	Join BC.tGSNRegion t on v.RegionID = t.RegionID
	Where t.GSN = @GSN

	If (@Debug = 1)
	Begin
		Declare @StartTime DateTime2(7)
		Set @StartTime = SysDateTime()
		Select '---- Input Parameters ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		
		Select @GSN GSN, Title, FirstName, LastName, @LastModified LastModifiedParameter, @Debug DebugFlagParameter, @@SERVERNAME [Server], DB_NAME() [Database]
		From Person.UserProfile Where GSN = @GSN

		Select g.GSN, r.RegionID, r.RegionName From BC.tGSNRegion g Join BC.Region r on g.RegionID = r.RegionID Where GSN = @GSN

		Select '---- User relevant bottlers with hierachy ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select SystemID, ZoneID, DivisionID, RegionID, BCRegionID, BottlerID, BottlerName From @Hier

	End

	Declare @ApplicablePromoStatus Table
	(
		StatusID int
	)

	Insert Into @ApplicablePromoStatus Values(4)	--- The published status is always included.

	--- Differential Updates requires cancelled Promotions as well 
	If (@LastModified is not null)
		Insert Into @ApplicablePromoStatus Values(3)
	
	If (@Debug = 1)
	Begin
		Select '---- ApplicablePromoStatus ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select * From @ApplicablePromoStatus
	End

	---- Interested date range, driven by Configurations ----
	Declare @ConfigPStartDate DateTime, @ConfigPEndDate DateTime
	Select @ConfigPStartDate = dateadd(day,(Select convert(Int,value * -1) from bcmyday.config where [key] = 'PROMOTION_DOWNLOAD_DURATION_PAST'), getdate())
	Select @ConfigPEndDate = dateadd(day,(Select convert(Int,value)  from bcmyday.config where [key] = 'PROMOTION_DOWNLOAD_DURATION_FUTURE'), getdate())

	If (@Debug = 1)
	Begin
		Select '---- Start and End Date ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select @ConfigPStartDate ConfigPStartDate, @ConfigPEndDate ConfigPEndDate
	End
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	--~~~~~~~~~~~~ Stage 2. Promotion pre-fitlering and Geography expansion ~~~~~~~~--
	Select Distinct p.PromotionID, p.ModifiedDate, p.PromotionStartDate, p.PromotionEndDate
	Into #PromotionsInScope
	From Playbook.RetailPromotion p With (nolock),
	Playbook.PromotionGeoRelevancy pgr With (nolock),
	@ApplicablePromoStatus st
	Where p.PromotionID = pgr.PromotionId
	And 
	 (
		Coalesce(SystemID, 0) > 0
		Or Coalesce(ZoneID, 0) > 0
		Or Coalesce(DivisionID, 0) > 0
		Or Coalesce(BCRegionID, 0) > 0
		Or Coalesce(BottlerID, 0) > 0
		Or Coalesce(StateID, 0) > 0
	)
	And (p.PromotionRelevantStartDate <= @ConfigPEndDate And p.PromotionRelevantEndDate >= @ConfigPStartDate)
	And st.StatusID = p.PromotionStatusID
	And (
		(@LastModified is null) Or
		 (
			 (
					--In Active Scope 
					PromotionStartDate between Playbook.fGetSunday(getDate()) and Playbook.fGetMonday(getDate())  
					or
					PromotionEndDate between Playbook.fGetSunday(getDate()) and Playbook.fGetMonday(getDate())
					or
					Playbook.fGetSunday(getDate()) BETWEEN PromotionStartDate AND PromotionEndDate
			  ) Or
			ModifiedDate >= Coalesce(@LastModified, '1900-01-01')	-- In Date-Delta
		)
	)

	If (@Debug = 1)
	Begin
		Select '---- Promotion pre filter completed ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select * From #PromotionsInScope
	End

	--- Extended Bttler table, that has state id ---
	Declare @Bottlers Table
	(
		AllSystems int,
		SystemID int, 
		ZoneID int, 
		DivisionID int, 
		RegionID int, 
		BottlerID int, 
		StateRegionID int
	)

	Insert Into @Bottlers
	Select 1, v.SystemID, v.ZoneID, v.DivisionID, v.RegionID, b.BottlerID, sr.StateRegionID
	From BC.vSalesHierarchy v
	Join BC.Bottler b on b.BCRegionID = v.RegionID
	Join Shared.StateRegion sr on b.State = sr.RegionABRV
	Where SystemID in (5, 6,7)

	--- Expand GeoRelevancy Tree
	Select pgr.PromotionId PromotionID, pgr.SystemID, pgr.ZoneID, pgr.DivisionID, pgr.BCRegionID RegionID, pgr.BottlerID, pgr.StateId StateID
	Into #PromoGeoR
	From Playbook.PromotionGeoRelevancy pgr With (nolock)
	Join #PromotionsInScope p on pgr.PromotionId = p.PromotionID
	Where (
		Coalesce(SystemID, 0) > 0
		Or Coalesce(ZoneID, 0) > 0
		Or Coalesce(DivisionID, 0) > 0
		Or Coalesce(BCRegionID, 0) > 0
		Or Coalesce(BottlerID, 0) > 0
		Or Coalesce(StateID, 0) > 0
	)

	If (@Debug = 1)
	Begin
		Select '---- Promotion geo relevancy ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select * From #PromoGeoR
	End

	----- BTTLR driver table -----
	Create Table #PGR
	(
		PromotionID int not null,
		BottlerID int
	)

	Create Clustered Index IDX_PGR_PromotionID_BottlerID ON #PGR(PromotionID, BottlerID)

	---------------
	Insert Into #PGR(PromotionID, BottlerID)
	Select Distinct pgr.PromotionID, v.BottlerID
	from #PromoGeoR pgr
	Join @Hier v on pgr.SystemID = v.SystemID
	Where StateID is null
	Union
	Select Distinct pgr.PromotionID, v.BottlerID
	from #PromoGeoR pgr
	Join @Hier v on pgr.ZoneID = v.ZoneID
	Where StateID is null And pgr.SystemID is null
	Union
	Select Distinct pgr.PromotionID, v.BottlerID
	from #PromoGeoR pgr
	Join @Hier v on pgr.DivisionID = v.DivisionID
	Where StateID is null And pgr.ZoneID is null And pgr.SystemID is null
	Union
	Select Distinct pgr.PromotionID, v.BottlerID
	from #PromoGeoR pgr
	Join @Hier v on pgr.RegionID = v.RegionID
	Where StateID is null And pgr.ZoneID is null And pgr.SystemID is null And pgr.DivisionID is null
	Union
	Select Distinct pgr.PromotionID, v.BottlerID
	from #PromoGeoR pgr
	Join @Hier v on pgr.BottlerID = v.BottlerID
	Where StateID is null And pgr.ZoneID is null And pgr.SystemID is null And pgr.DivisionID is null and pgr.RegionID is null
	Union
	Select Distinct pgr.PromotionID, v.BottlerID
	from #PromoGeoR pgr
	Join @Bottlers b on pgr.StateID = b.StateRegionID
	Join @Hier v on b.BottlerID = v.BottlerID

	If (@Debug = 1)
	Begin
		Select '---- Expanded Promotion Geo Relevancy ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select Count(*) NumberOfExpandedRelations From #PGR		
		Select * From #PGR 
	End

	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	--~~~~~~~~~~~~ Stage 3. Bottler Chain Trademark territoties correlation ~~~~~~~~--
	Select Distinct pgh.PromotionID, pgh.BottlerID
	Into #ReducedPGR
	From 
	#PGR pgh,
	(
		Select PromotionID, b.TrademarkID
		From Playbook.PromotionBrand pb With (nolock)
		Join SAP.Brand b on (pb.BrandID = b.BrandID)
		Union
		Select PromotionID, TrademarkID
		From Playbook.PromotionBrand With (nolock)) ptm,
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
	) pc,
	BC.tBottlerChainTradeMark tmap With (nolock)
	Where ptm.PromotionID = pgh.PromotionID
	And pc.PromotionID = pgh.PromotionID
	And tmap.TerritoryTypeID <> 10
	And tmap.ProductTypeID = 1
	And tmap.TradeMarkID = ptm.TradeMarkID
	And tmap.LocalChainID = pc.LocalChainID
	And tmap.BottlerID = pgh.BottlerID

	Select Distinct PromotionID
	Into #Promotion 
	From #ReducedPGR

	If (@Debug = 1)
	Begin
		Select '---- Promotion table content after applying territory ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
		Select Count(*) NumberOfPromotions_ReducedByTerrirotyMap From #Promotion

	End

	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	--~~~~~~~~~~~~~~~~~~~ Stage 4. Output promotions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
	If (@Debug = 1)
	Begin
		Select '---- Generating Output 1: Promotions ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

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
	Join #Promotion pids on rp.PromotionID = pids.PromotionID 
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
		,Coalesce(a.BrandID, 0) 'BrandID'
		,case when isnull(a.TrademarkID,0) = 0 then b.trademarkid else a.TrademarkID end 'TrademarkID'
	FROM playbook.promotionbrand a With (nolock)
	Join #Promotion pids on a.PromotionID = pids.PromotionID 
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
	Join #Promotion pids on a.PromotionID = pids.PromotionID 
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
	Join #Promotion pids on pa.PromotionID = pids.PromotionID 
	Order By PromotionID, AttachmentName

	If (@Debug = 1)
	Begin
		Select '---- Generating Output 5: Promotion States ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

	SELECT pa.PromotionID 'PromotionID',
		PackageID 
	FROM playbook.promotionpackage pa With (nolock)
	Join #Promotion pids on pa.PromotionID = pids.PromotionID 
	Order By PromotionID, PackageID

	If (@Debug = 1)
	Begin
		Select '---- Generating Output 6: Promotion States ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

	Select Distinct pgr.PromotionId, sr.RegionABRV StateAbrv
	From Playbook.PromotionGeoRelevancy pgr With (nolock)
	Join Shared.StateRegion sr on pgr.StateID = sr.StateRegionID
	Join #Promotion pids on pgr.PromotionID = pids.PromotionID 
	Order By PromotionID, StateAbrv

	If (@Debug = 1)
	Begin
		Select '---- Generating Output 7: Promotion Geo ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

	Select pgh.PromotionID, pgh.BottlerID 
	From #ReducedPGR pgh

	--~~~~~~~~~~~~~~~~~~~~~~~~~ Stage 5. Complete logging ~~~~~~~~~~~~~~~~~~~~~~~~~~--
	---------------------------------------------------------
	If (@Debug = 1)
	Begin
		Select '---- All done. Updating logging if needed ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

	If(@EnableLogging = 1)
	Begin
		Declare @NumberOfPromotion int, @NumberOfRegion int, @NumberOfBottler int, @EndDate DateTime2(7), @CurrentPromotionCount int
		Declare @NumberOfAttachment int, @NumberOfPromoBottler int, @TotalAttachmentSize bigint
		
		Set @EndDate  = SYSDATETIME()
		Select @NumberOfPromotion = count(*) From #Promotion
		Select @NumberOfRegion = count(*) From BC.tGSNRegion g Join BC.Region r on g.RegionID = r.RegionID Where GSN = @GSN
		Select @NumberOfBottler = count(*) From BC.tGSNRegion t Join BC.Bottler b on t.RegionID = b.BCRegionID Where GSN = @GSN
		Select @CurrentPromotionCount = Count(*) From Playbook.RetailPromotion With (nolock) Where PromotionID in (Select PromotionID From #Promotion) And GetDate() Between PromotionStartDate And PromotionEndDate
		Select @NumberOfAttachment = count(*) From Playbook.PromotionAttachment pa With (nolock) Join #Promotion  p on pa.PromotionID = p.PromotionID
		Select @TotalAttachmentSize = Sum(Coalesce(AttachmentSize, 0)) From Playbook.PromotionAttachment pa With (nolock) Join #Promotion  p on pa.PromotionID = p.PromotionID
		Select @NumberOfPromoBottler = count(*) From #ReducedPGR

		Update BCMyDay.PromotionRequestLog
		Set EndDate = SYSDATETIME()
		, NumberOfPromotion = @NumberOfPromotion
		, NumberOfRegion = @NumberOfRegion
		, NumberOfBottler = @NumberOfBottler
		, NumberOfCurrentPromotion = @CurrentPromotionCount
		, NumberOfAttachments = @NumberOfAttachment
		, NumberOfPromoBottler = @NumberOfPromoBottler
		, TotalAttachmentSize = @TotalAttachmentSize
		Where LogID = @LogID

		If (@Debug = 1)
		Begin
			Select LogID,
				LogDate,
				Duration, 
				GSN, 
				MDate, 
				StartDate, 
				EndDate, 
				NumberOfPromotion,
				NumberOfCurrentPromotion,
				NumberOfRegion,
				NumberOfBottler, NumberOfAttachments, TotalAttachmentSize, NumberOfPromoBottler
			From BCMyDay.PromotionRequestLog
			Where LogID = @LogID
		End

	End

End

Go

