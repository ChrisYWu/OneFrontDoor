USE [Portal_Data]
GO

/****** Object:  StoredProcedure [BCMyday].[pGetPromotionsByRegionID]    Script Date: 7/27/2015 1:17:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



---------------------------------------------------------
---------------------------------------------------------
--26318

--exec BCMyDay.pGetPromotionsByRegionID 240,'2015-01-01'
--exec BCMyDay.pGetPromotionsByRegionID 9,'2015-01-01'
ALTER PROCEDURE [BCMyday].[pGetPromotionsByRegionID] @BCRegionID INT
	,@lastmodified DATETIME = NULL
AS
BEGIN
	select -1 PromotionID into #Promotions
	select -1 PromotionID into #ValidPromotions

	--Only approved promotion
	select 4 value into #PromotionStatus

	if isnull(@lastmodified,'') <> ''
		insert into #PromotionStatus values(3)	--Cancel promotion also required for delta


	IF (isnull(@lastmodified, '') = '')
	BEGIN
		--If there is no delta, send promotion as per dates in comfig
		DECLARE @ConfigPStartDate DATETIME
			,@ConfigPEndDate DATETIME

		SELECT @ConfigPStartDate = dateadd(day,(select convert(int,value * -1) from bcmyday.config where [key] = 'PROMOTION_DOWNLOAD_DURATION_PAST'), getdate())
		SELECT @ConfigPEndDate = dateadd(day,(select convert(int,value)  from bcmyday.config where [key] = 'PROMOTION_DOWNLOAD_DURATION_FUTURE'), getdate())
	END
	ELSE
	BEGIN
		--getting all promotion, will filter by modified date
		SET @ConfigPStartDate = '2000-01-01'
		SET @ConfigPEndDate = '9999-01-01'	
	END

	insert into #Promotions
	exec playbook.pgetbcpromotionsbyrole @StartDate= @ConfigPStartDate, @EndDate = @ConfigPEndDate, @currentuser = '', 
		@Regionid = @BCRegionID, @VIEW_DRAFT_NA = 1, @ViewNatProm =1 , @IsExport = 0, @BottlerID = '', @CurrentPersonaID = -1
	
	insert into #ValidPromotions
	select distinct a.promotionId
	from playbook.retailpromotion a
	left join playbook.promotiongeohier b on a.promotionid = b.promotionid
	where a.ModifiedDate >= case when isnull(@lastmodified,'') = '' then a.ModifiedDate else @lastmodified end	--For delta only modifed promotion else all
	and a.promotionstatusid in (select value from #PromotionStatus)	
	and a.promotionid in (select promotionid from #Promotions)

	if isnull(@lastmodified,'') <> ''
	begin
		--For delta , need to send all active promtoion (irrespective of delta)
		insert into #ValidPromotions
		select distinct a.promotionId
		from playbook.retailpromotion a
		left join playbook.promotiongeohier b on a.promotionid = b.promotionid
		where a.PromotionStatusID in (select value from #PromotionStatus)
		and (
			a.PromotionStartDate between Playbook.fGetSunday(getDate()) and Playbook.fGetMonday(getDate())  
			or
			a.PromotionEndDate between Playbook.fGetSunday(getDate()) and Playbook.fGetMonday(getDate())
			or
			Playbook.fGetSunday(getDate()) BETWEEN a.PromotionStartDate AND a.PromotionEndDate
			)
		and a.promotionid in (select promotionid from #Promotions)
	end


	
	SELECT distinct rp.PromotionID 'PromotionID'
		,PromotionName 'PromotionName'
		,PromotionDescription 'Comment'
		,PromotionStartDate 'InStoreStartDate'
		,PromotionEndDate 'InStoreEndDate'
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
	FROM playbook.retailpromotion rp
	INNER JOIN playbook.promotiontype pt ON rp.Promotiontypeid = pt.promotiontypeid
	INNER JOIN playbook.promotioncategory pc ON rp.promotioncategoryid = pc.promotioncategoryid
	INNER JOIN playbook.promotiondisplaylocation pdl ON rp.promotionid = pdl.promotionid
	left join [Playbook].[PromotionRank] pr on pr.promotionid = rp.PromotionID
		and 
		case when rp.PromotionEndDate < playbook.fGetMonday(getdate()) then  playbook.fGetSunday(rp.PromotionEndDate) 
			when rp.PromotionStartDate > playbook.fGetSunday(getdate()) then  playbook.fGetMonday(rp.PromotionStartDate)
			else playbook.fGetMonday(getDate())
		end = 
		case when rp.PromotionEndDate < playbook.fGetMonday(getdate()) then  pr.PromotionWeekEnd
			when rp.PromotionStartDate > playbook.fGetSunday(getdate()) then  pr.PromotionWeekStart 
			else pr.PromotionWeekStart
		end 

	WHERE rp.PromotionID IN (
			SELECT PromotionID
			FROM #ValidPromotions
			)

	SELECT PromotionID 'PromotionID'
		,a.BrandID 'BrandID'
		,case when isnull(a.TrademarkID,0) = 0 then b.trademarkid else a.TrademarkID end 'TrademarkID'
	FROM playbook.promotionbrand a
	left join sap.brand b on a.brandid = b.brandid
	WHERE promotionid IN (
			SELECT PromotionID
			FROM #ValidPromotions
			)

	SELECT PromotionID 'PromotionID',
		
		case 
			when isnull(a.RegionalChainID ,0) <> 0  then
			(select nationalchainid from sap.regionalchain where RegionalChainID = a.RegionalChainID )
			when isnull(a.LocalChainID ,0) <> 0  then
			(select c.nationalchainid from sap.localchain b
			left join sap.regionalchain c on b.regionalchainid = c.regionalchainid
			where localchainid = a.localchainid )
			else a.nationalchainid
		end 'NationalChainID'
		,
		case when isnull(a.LocalChainID ,0) <> 0  then
			(select regionalchainid from sap.localchain where localchainid = a.localchainid )
		else a.RegionalChainID
		end 'RegionalChainID'
		,LocalChainID 'LocalChainID'
	FROM playbook.promotionaccount a
	WHERE promotionid IN (
			SELECT PromotionID
			FROM #ValidPromotions
			)

	SELECT PromotionID 'PromotionID'
		,AttachmentURL 'FileURL'
		,AttachmentName 'FileName'
		,AttachmentSize 'Size'
		,at.AttachmentTypeName 'Type'
		,pa.PromotionAttachmentID 'AttachmentID',
		pa.AttachmentDateModified 'ModifiedDate'
	FROM playbook.promotionattachment pa
	INNER JOIN Playbook.AttachmentType at ON pa.AttachmentTypeID = at.AttachmentTypeID
	WHERE promotionid IN (
			SELECT PromotionID
			FROM #ValidPromotions
			)


	SELECT PromotionID 'PromotionID',
		PackageID 
	FROM playbook.promotionpackage pa
	WHERE promotionid IN (
			SELECT PromotionID
			FROM #ValidPromotions
			)

	Select Distinct pgr.PromotionId, sr.RegionABRV StateAbrv
	From Playbook.PromotionGeoRelevancy pgr
	Join Shared.StateRegion sr on pgr.StateID = sr.StateRegionID
	WHERE promotionid IN (
			SELECT PromotionID
			FROM #ValidPromotions
			)

END

GO

