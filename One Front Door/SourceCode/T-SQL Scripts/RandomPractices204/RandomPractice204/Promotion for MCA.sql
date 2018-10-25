use Portal_Data
Go

	--~~~~~~~~~~~~ Stage 2. Promotion pre-fitlering and Geography expansion ~~~~~~~~--
	Select Distinct p.PromotionID, p.ModifiedDate, p.PromotionStartDate, p.PromotionEndDate
	Into #PromotionsInScope
	From Playbook.RetailPromotion p With (nolock),
	Playbook.PromotionGeoRelevancy pgr With (nolock)
	Where p.PromotionID = pgr.PromotionId
	And PromotionStatusID = 3
	And 
	(
		Coalesce(StateID, 0) > 0
	)

	Select '---- Promotion pre filter completed ----'
	Select * From #PromotionsInScope

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
		Coalesce(StateID, 0) > 0
	)

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


	----- BTTLR driver table -----
	Create Table #PGR
	(
		PromotionID int not null,
		BottlerID int
	)

	Create Clustered Index IDX_PGR_PromotionID_BottlerID ON #PGR(PromotionID, BottlerID)

	---------------
	Select Distinct pgr.PromotionID, v.BottlerID
	from #PromoGeoR pgr
	Join @Bottlers b on pgr.StateID = b.StateRegionID
	Join @Hier v on b.BottlerID = v.BottlerID

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

	Select Count(*) NumberOfPromotions_ReducedByTerrirotyMap From #Promotion

	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	--~~~~~~~~~~~~~~~~~~~ Stage 4. Output promotions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
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

	SELECT a.PromotionID 'PromotionID'
		,Coalesce(a.BrandID, 0) 'BrandID'
		,case when isnull(a.TrademarkID,0) = 0 then b.trademarkid else a.TrademarkID end 'TrademarkID'
	FROM playbook.promotionbrand a With (nolock)
	Join #Promotion pids on a.PromotionID = pids.PromotionID 
	left join sap.brand b With (nolock) on a.brandid = b.brandid
	Order By PromotionID, TrademarkID, BrandID

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

	SELECT pa.PromotionID 'PromotionID',
		PackageID 
	FROM playbook.promotionpackage pa With (nolock)
	Join #Promotion pids on pa.PromotionID = pids.PromotionID 
	Order By PromotionID, PackageID

	Select Distinct pgr.PromotionId, sr.RegionABRV StateAbrv
	From Playbook.PromotionGeoRelevancy pgr With (nolock)
	Join Shared.StateRegion sr on pgr.StateID = sr.StateRegionID
	Join #Promotion pids on pgr.PromotionID = pids.PromotionID 
	Order By PromotionID, StateAbrv

	Select pgh.PromotionID, pgh.BottlerID 
	From #ReducedPGR pgh

