use Portal_Data_INT
Go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------
---------------------------------------------------------
/* Testing 
exec BCMyday.pGetLOSMaster @lastmodified = '2015-01-01'
exec BCMyday.pGetLOSMaster @lastmodified='2015-02-01 00:00:00'
exec BCMyday.pGetLOSMaster @lastmodified='2016-02-01 00:00:00'

*/

-- BCMyday.pGetLOSMaster ''                      
ALTER Procedure [BCMyday].[pGetLOSMaster]                      
(                      
  @lastmodified Date = null                    
)                      
As                      
Begin                      
                      
 If ISNULL(@lastmodified, '') = ''                        
	Begin                       
		SELECT  LOSID,      
				ChannelID,      
				LOSImageID,      
				ModifiedDate,      
				ImageURL,  
				IsActive ,      
				case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted,
				localchainid
			  --  IsDeleted          
		FROM BCMyday.LOS  LOS  
		INNER JOIN Shared.Image IMG  
		ON LOS.LOSImageID=IMG.ImageID  
		WHERE IsActive=1    
   
		SELECT LOSID,      
			   DisplayLocationID,      
			   DisplaySequence,          
			   GridX,      
			   GridY,      
			   ModifiedDate,      
			case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted           ,
				IsActive 
		FROM BCMyday.LOSDisplayLocation                      
		WHERE IsActive=1                     
                      
		SELECT TieReasonId,      
			   Description,                  
			   ModifiedDate,      
			   IsActive ,      
		  case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted             
		FROM BCMyday.TieInReason  
		WHERE IsActive=1                  
                      
		SELECT DisplayTypeId,      
			   Description,      
			   ModifiedDate,      
			  IsActive ,      
		  case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted           
			   FROM              
		BCMyday.DISPLAYTYPEMASTER  
		WHERE IsActive=1                     
                      
  
		SELECT a.SystemBrandID,      
		  case when isnull(a.ExternalBrandName,'') <> '' then a.ExternalBrandName else b.BrandName end ExternalBrandName,      
			   a.BrandID,      
			   a.TieInType,      
			   a.BrandLevelSort,          
			   a.ModifiedDate,  
			   IMG.ImageURL,      
			  a.IsActive ,  
			  a.SystemTradeMarkID    ,
		  case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted                         
		FROM BCMyday.SystemBrand a    
		left JOIN Shared.Image IMG  
		ON A.ImageID=IMG.ImageID  
		left join sap.brand b on a.brandid=b.brandid    
		WHERE IsActive=1          
                      
		SELECT SystemPackageID,      
		 ContainerType + '|' + Isnull(Conf.SAPPackageConfID,'') ContainerType,      
		 PackageConfigID,      
		 BCSystemID,          
		 PackageLevelSort,      
		 ModifiedDate,      
		 IsActive ,      
		 case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted,    
		 Isnull(Conf.SAPPackageConfID,'') SAPPackageConfID,    
		 PackageName    
		FROM   BCMyday.SystemPackage     
		Left Join SAP.PackageConf Conf on Conf.PackageConfID = BCMyday.SystemPackage.PackageConfigID    
		WHERE IsActive=1                      
                      
		SELECT SystemPackageID SystemPackageID,      
			   SystemBrandId SystemBrandID,      
			  IsActive ,      
		  case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted           
		FROM BCMyday.SystemPackageBrand  
		 WHERE IsActive=1          
        
		SELECT ConfigID,      
			   [Key],      
			   Value,      
			   Description,      
			   ModifiedDate         
		FROM BCMyday.Config                  
		where SendToMyday = 1                  
	End                      
                      
ELSE                      
	Begin                      
                      
		SELECT  LOSID,      
				ChannelID,      
				LOSImageID,      
				ModifiedDate,      
				ImageURL,  
				IsActive ,      
				localchainid,
				case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted           
			  into  #LOS        
		FROM BCMyday.LOS  LOS  
		INNER JOIN Shared.Image IMG  
		ON LOS.LOSImageID=IMG.ImageID  
		WHERE ModifiedDate>=@lastmodified
    
		select * from #LOS    
                     
		SELECT LOSID,      
			   DisplayLocationID,      
			   DisplaySequence,      
			   GridX,      
			   GridY,      
			   ModifiedDate,      
		  IsActive ,      
		  case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted           
		FROM BCMyday.LOSDisplayLocation                      
		WHERE   losid in (select losid from #LOS)    
                      
		SELECT TieReasonId,      
			   Description,      
			   ModifiedDate,      
			  IsActive ,      
		  case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted           
		FROM BCMyday.TieInReason                      
		WHERE ModifiedDate >= @lastmodified         
		--AND IsActive=1                                           
                      
		SELECT DisplayTypeId,      
			   Description,      
			   ModifiedDate,      
			 IsActive ,      
		  case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted           
		FROM BCMyday.DISPLAYTYPEMASTER                       
		WHERE ModifiedDate >= @lastmodified       
		--AND IsActive=1                                            
                      
		SELECT a.SystemBrandID,      
		  case when isnull(a.ExternalBrandName,'') <> '' then a.ExternalBrandName else b.BrandName end ExternalBrandName,      
			   a.BrandID,      
			   a.TieInType,      
			   a.BrandLevelSort,          
			   a.ModifiedDate,  
			   IMG.ImageURL,      
			  a.IsActive ,  
			  SystemTradeMarkID    ,
		  case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted                         
		FROM BCMyday.SystemBrand a    
		LEFT JOIN Shared.Image IMG  
		ON A.ImageID=IMG.ImageID  
		left join sap.brand b on a.brandid=b.brandid    
		WHERE      
		-- IsActive=1 AND          
		ModifiedDate >= @lastmodified       
                     
                       
		SELECT SystemPackageID,      
			ContainerType + '|' + Isnull(Conf.SAPPackageConfID,'') ContainerType,      
			PackageConfigID,      
			BCSystemID,      
			PackageLevelSort,                      
			ModifiedDate,      
			IsActive ,      
		 case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted ,    
		 Isnull(Conf.SAPPackageConfID,'') SAPPackageConfID,    
		 PackageName    
		FROM BCMyday.SystemPackage     
		Left Join SAP.PackageConf Conf on Conf.PackageConfID = BCMyday.SystemPackage.PackageConfigID    
		WHERE 
		--IsActive=1                      
		--AND 
		ModifiedDate >= @lastmodified                      
                      
		SELECT SystemPackageID SystemPackageID,      
			   SystemBrandId SystemBrandID,          
			   IsActive ,      
		  case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted           
		FROM BCMyday.SystemPackageBrand        
		--WHERE IsActive=1                                          
                    
		SELECT ConfigID,      
			   [Key],      
			   Value,      
			   Description,      
			   ModifiedDate         
		FROM BCMyday.Config        
		WHERE ModifiedDate > @lastmodified         
		and SendToMyday=1                                                         
	End     
  
  
  
select DisplayLocationID,DisplayLocationName from playbook.displaylocation                   
    
SELECT SystemTradeMarkID, Case when ST.TradeMarkID is null then ST.ExternalTradeMarkName Else T.TrademarkName End ExternalTradeMarkName,    
 ST.TradeMarkID,  
 TradeMarkLevelSort,    
 IsActive,  
 CreatedBy,  
 CreatedDate,  
 ModifiedBy,  
 ModifiedDate,  
 ImageURL          
FROM BCMyday.SystemTradeMark ST   
LEFT JOIN Shared.Image IMG  
ON ST.ImageID=IMG.ImageID  
Left join sap.trademark T on ST.trademarkid = t.trademarkid    
WHERE 
IsActive = case when isnull(@lastmodified,'')='' Then 1 else IsActive End
and modifieddate >= case when isnull(@lastmodified,'')='' Then modifieddate else @lastmodified End

------ System Competition Brand, added for BC Release III ---------    
Select SystemID As NodeID , Isnull(SystemBrandID, 0) SystemBrandID, coalesce(SystemTradeMarkID, 0) As SystemDPSTrademarkID, Active
From BCMyDay.SystemCompetitionBrand
Where @lastmodified is null Or LastModified >= @lastmodified

------ BC Promotion Execution Status -------------
Select PromotionExectuionStatusID StatusID, Description StatusDesc, Active
From BCMyday.PromotionExecutionStatus
                     
End
Go

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
Go

---------------------------------------------------------
---------------------------------------------------------
-- BCMyday.pGetStoreTieInsHistoryByREgionID 239, '2015-1-1'
-- BCMyday.pGetStoreTieInsHistoryByREgionID 22, '2015-2-4'

--Select b.BCRegionID, *
--From BCMyDay.StoreCondition s
--Join BC.Bottler b on s.BottlerID = b.BottlerID
--Order By ModifiedDate desc

--Select *
--From BCMyDay.StoreConditionDisplay



--Select *
--From BCMyday.StoreConditionDisplay
--Where StoreConditionID = 9186
ALTER Procedure BCMyday.pGetStoreTieInsHistoryByRegionID
(                                
	@RegionID int
	,@LastModifiedDate datetime = null
)                      
As                      
Begin                      
   
	DECLARE @StoreTieinHistory int;  
	SELECT @StoreTieinHistory= value from BCMyday.Config  
	where [Key]='History'

	SELECT distinct StoreConditionID,                      
	a.AccountId,                      
	a.ConditionDate,                      
	a.GSN,                      
	a.BCSystemID,                      
	a.Longitude,                      
	a.Latitude,                      
	StoreNote,                      
	CreatedBy,                      
	CreatedDate,                      
	ModifiedBy,                      
	ModifiedDate,                      
	a.BottlerID,            
	IsActive,            
	case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted                        
	into #StoreCondition            
	FROM BCMyday.StoreCondition a
	Left Join BC.Bottler b on a.BottlerID = b.BottlerID
	WHERE             
	b.BCRegionID = @RegionID            
	--and ConditionDate >= DATEADD(MONTH,-@StoreTieinHistory,GETDATE())  
	and ConditionDate >= case when isnull(@LastModifiedDate,'') = '' then  DATEADD(MONTH,-@StoreTieinHistory,GETDATE())  else @LastModifiedDate end
	--AND IsActive=1            
             
	select * from #StoreCondition            
                      
	SELECT StoreConditionDisplayID,                      
	StoreConditionID,                      
	DisplayLocationID,                      
	PromotionID,                      
	DisplayLocationNote,                                      
	OtherNote,                      
	DisplayImageURL,                      
	GridX,                      
	GridY,                      
	CreatedBy,                      
	CreatedDate,                      
	ModifiedBy,                      
	ModifiedDate,            
	IsActive,            
	case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted,
	DisplayTypeID,
	ReasonID,
	TieInFairShareStatusID IsFairShare
	into #StoreConditionDisplay            
	FROM BCMyday.StoreConditionDisplay                      
	WHERE StoreConditionID in          
	(SELECT StoreConditionID from #StoreCondition )        
	--AND IsActive=1             
                
	select * from #StoreConditionDisplay            
                   
	SELECT StoreConditionDisplayID,                      
	SystemPackageID,                      
	SystemBrandID,                      
	ModifiedDate,            
	IsActive,            
	case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted                      
	FROM BCMyDay.StoreConditionDisplayDetail                      
	WHERE StoreConditionDisplayID in          
	(SELECT StoreConditionDisplayID from #StoreConditionDisplay )         
	--AND IsActive=1            
              
	SELECT StoreConditionID,                      
	TieInRate,                      
	SystemBrandId,                      
	ModifiedDate,            
	IsActive,            
	case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted                        
	FROM BCMyday.StoreTieInRate                      
	WHERE StoreConditionID in          
	(SELECT StoreConditionID from #StoreCondition )            
	--AND IsActive=1
	  
	-------------------------------------------
	Select pe.StoreConditionID, PromotionID, StoreConditionDisplayID, PromotionExecutionStatusID, ExecutionID PromotionExecutionID
	From BCMyDay.PromotionExecution pe
	Join #StoreCondition se on pe.StoreConditionID = se.StoreConditionID

	Select pe.StoreConditionID, Note, ImageURL, ImageName, NoteID StoreConditionNoteID
	From BCMyDay.StoreConditionNote pe
	Join #StoreCondition se on pe.StoreConditionID = se.StoreConditionID

	Select pe.StoreConditionID, ManagementPriorityID, PriorityExecutionStatusID, PriorityExecutionID
	From BCMyDay.PriorityStoreConditionExecution pe
	Join #StoreCondition se on pe.StoreConditionID = se.StoreConditionID   
                                  
End 

Go

----------------------------------------------------------
----------------------------------------------------------
Drop Proc [BCMyday].[pGetStoreTieInsHistory]
Go

----------------------------------------------------------
----------------------------------------------------------
If exists (Select *
	From Sys.procedures p
	Join Sys.schemas s on p.schema_id = s.schema_id
	Where p.name = 'pGetBCPrioritiesByRegionID' and s.name = 'BCMyDay')
	Drop Proc BCMyDay.pGetBCPrioritiesByRegionID
Go

/* ----------- Testing bench -------
exec BCMyDay.pGetBCPrioritiesByRegionID @RegionID = 36

exec BCMyDay.pGetBCPrioritiesByRegionID @RegionID = 44

*/
Create Proc BCMyDay.pGetBCPrioritiesByRegionID
(
	@RegionID int,
	@LastModifiedTime datetime2(7) = '1970-01-01'
)
As

	Declare @MP Table
	(
		ManagementPriorityID int, 
		Description varchar(200), 
		StartDate Date, 
		EndDate Date, 
		Created DateTime2(7), 
		LastModified DateTime2(7), 
		Active bit, 
		ForAllBottlers bit, 
		ForAllBrands bit, 
		ForAllChains bit, 
		ForAllPackages bit
	)

	IF (isnull(@LastModifiedTime, '') = '')
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

	Insert Into @MP
	Select distinct mp.ManagementPriorityID, Description, StartDate, EndDate, Created, mp.LastModified, Active, ForAllBottlers, ForAllBrands, ForAllChains, ForAllPackages
	From BCMyday.ManagementPriority mp
	Join
		(
		Select ManagementPriorityID, RegionID
		From BCMyday.PriorityBottler
		Where RegionID > 0 and BottlerID is null
		Union
		Select ManagementPriorityID, r.RegionID
		From BCMyday.PriorityBottler pb
		Join BC.Region r on pb.DivisionID = r.DivisionID  
		Where pb.DivisionID > 0 and pb.RegionID is null
		Union
		Select ManagementPriorityID, r.RegionID
		From BCMyday.PriorityBottler pb
		Join BC.Division d on pb.ZoneID = d.ZoneID
		Join BC.Region r on d.DivisionID = r.DivisionID
		Where pb.ZoneID > 0 and pb.DivisionID is null
		Union
		Select ManagementPriorityID, r.RegionID
		From BCMyday.PriorityBottler pb
		Join BC.Zone z on pb.SystemID = z.SystemID
		Join BC.Division d on z.ZoneID = d.ZoneID
		Join BC.Region r on d.DivisionID = r.DivisionID
		Where pb.SystemID > 0 and pb.ZoneID is null
		Union
		Select ManagementPriorityID, RegionID
		From BCMyday.ManagementPriority m
		Cross Join BC.Region r
		Where m.TypeID = 1
		And r.Active = 1
		And m.ForAllBottlers = 1
		--And GetDate() Between StartDate And DateAdd(Day, 1, EndDate)
		And GetDate() Between @ConfigPStartDate And @ConfigPEndDate
		And m.LastModified >= @LastModifiedTime
		--Union
		--Select Distinct ManagementPriorityID, b.BCRegionID RegionID
		--From BCMyday.PriorityBottler pb
		--Join BC.Bottler b on pb.BottlerID = b.BottlerID
	) reg on reg.ManagementPriorityID = mp.ManagementPriorityID
	Join 
	(
		Select Distinct ManagementPriorityID, TradeMarkID
		From BCMyday.PriorityBrand
		Union
		Select Distinct ManagementPriorityID, TradeMarkID
		From BCMyday.ManagementPriority m
		Cross Join SAP.TradeMark t
		Where m.TypeID = 1
		And m.ForAllBrands = 1
		And GetDate() Between @ConfigPStartDate And @ConfigPEndDate
		And m.LastModified >= @LastModifiedTime
	) tr on tr.ManagementPriorityID = mp.ManagementPriorityID
	Join
	(
		Select ManagementPriorityID, LocalChainID
		From BCMyday.PriorityChain
		Union 
		Select ManagementPriorityID, l.LocalChainID
		From BCMyday.PriorityChain p
		Join SAP.LocalChain l on p.RegionalChainID = l.RegionalChainID
		Where p.RegionalChainID > 0 And p.LocalChainID is null
		Union 
		Select ManagementPriorityID, l.LocalChainID
		From BCMyday.PriorityChain p
		Join SAP.RegionalChain r on p.NationalChainID = r.NationalChainID
		Join SAP.LocalChain l on r.RegionalChainID = l.RegionalChainID
		Where p.NationalChainID > 0 And p.RegionalChainID is null
		Union
		Select ManagementPriorityID, l.LocalChainID
		From BCMyday.ManagementPriority m
		Cross Join SAP.LocalChain l
		Where m.TypeID = 1
		And m.ForAllChains = 1
		And GetDate() Between @ConfigPStartDate And @ConfigPEndDate
		And m.LastModified >= @LastModifiedTime
	) lc on lc.ManagementPriorityID = mp.ManagementPriorityID
	Join Bc.tRegionChainTradeMark trct on trct.RegionID = reg.RegionID 
			And trct.TradeMarkID = tr.TradeMarkID 
			And trct.LocalChainID = lc.LocalChainID
	Where GetDate() Between @ConfigPStartDate And @ConfigPEndDate
	And mp.LastModified >= @LastModifiedTime
	And reg.RegionID = @RegionID
	And mp.TypeID = 1
	And trct.TerritoryTypeID <> 10
	And trct.ProductTypeID = 1
	And mp.PublishingStatus in (2,3)

	Select * From @MP Order By ManagementPriorityID

	--------------------------------------
	Declare @PriorityChain Table
	(
		ManagementPriorityID int,
		NationalChainID int,
		RegionalChainID int,
		LocalChainID int,
		LastModified DateTime2(7)
	)

	Insert Into @PriorityChain
	Select pc.ManagementPriorityID, NationalChainID, RegionalChainID, LocalChainID,  pc.LastModified
	From BCMyDay.PriorityChain pc
	Join @MP mp on pc.ManagementPriorityID = mp.ManagementPriorityID
	Union
	Select mp.ManagementPriorityID, -1, null, null, mp.LastModified
	From @MP mp
	Where mp.ForAllChains = 1
	Order By pc.ManagementPriorityID, NationalChainID, RegionalChainID, LocalChainID

	Update c
	Set c.RegionalChainID = rc.RegionalChainID
	From @PriorityChain c
	Join SAP.LocalChain rc on c.LocalChainID = rc.LocalChainID

	Update c
	Set c.NationalChainID = rc.NationalChainID
	From @PriorityChain c
	Join SAP.RegionalChain rc on c.RegionalChainID = rc.RegionalChainID

	Select * From @PriorityChain
	-----------------------------------------------

	Select pc.ManagementPriorityID, TradeMarkID, BrandID, pc.LastModified
	From BCMyDay.PriorityBrand pc
	Join @MP mp on pc.ManagementPriorityID = mp.ManagementPriorityID
	Union
	Select mp.ManagementPriorityID, -1, null, mp.LastModified
	From @MP mp 
	Where mp.ForAllBrands = 1
	Order By pc.ManagementPriorityID, TradeMarkID, BrandID, pc.LastModified

Go

-----------------------------------------------------------
-----------------------------------------------------------
If exists (Select *
	From Sys.procedures p
	Join Sys.schemas s on p.schema_id = s.schema_id
	Where p.name = 'pGetBCPrioritiesByRegionID' and s.name = 'BCMyDay')
	Drop Proc BCMyDay.pGetRSMsByManagementPriorityID
Go

-------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* ----------- Testing bench -------
exec BCMyDay.pGetRSMsByManagementPriorityID @ManagementPriorityID = 5

exec BCMyDay.pGetRSMsByManagementPriorityID @ManagementPriorityID = 10

exec BCMyDay.pGetRSMsByManagementPriorityID @ManagementPriorityID = 30

exec BCMyDay.pGetRSMsByManagementPriorityID @ManagementPriorityID = 407

exec BCMyDay.pGetRSMsByManagementPriorityID @ManagementPriorityID = 401

Select *
From BCMyDay.ManagementPriority

*/

Create Proc BCMyDay.pGetBCPrioritiesByRegionID
(
	@RegionID int,
	@LastModifiedTime datetime2(7) = '1970-01-01'
)
As

	Declare @MP Table
	(
		ManagementPriorityID int, 
		Description varchar(200), 
		StartDate Date, 
		EndDate Date, 
		Created DateTime2(7), 
		LastModified DateTime2(7), 
		Active bit, 
		ForAllBottlers bit, 
		ForAllBrands bit, 
		ForAllChains bit, 
		ForAllPackages bit
	)

	IF (isnull(@LastModifiedTime, '') = '')
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

	Insert Into @MP
	Select distinct mp.ManagementPriorityID, Description, StartDate, EndDate, Created, mp.LastModified, Active, ForAllBottlers, ForAllBrands, ForAllChains, ForAllPackages
	From BCMyday.ManagementPriority mp
	Join
		(
		Select ManagementPriorityID, RegionID
		From BCMyday.PriorityBottler
		Where RegionID > 0 and BottlerID is null
		Union
		Select ManagementPriorityID, r.RegionID
		From BCMyday.PriorityBottler pb
		Join BC.Region r on pb.DivisionID = r.DivisionID  
		Where pb.DivisionID > 0 and pb.RegionID is null
		Union
		Select ManagementPriorityID, r.RegionID
		From BCMyday.PriorityBottler pb
		Join BC.Division d on pb.ZoneID = d.ZoneID
		Join BC.Region r on d.DivisionID = r.DivisionID
		Where pb.ZoneID > 0 and pb.DivisionID is null
		Union
		Select ManagementPriorityID, r.RegionID
		From BCMyday.PriorityBottler pb
		Join BC.Zone z on pb.SystemID = z.SystemID
		Join BC.Division d on z.ZoneID = d.ZoneID
		Join BC.Region r on d.DivisionID = r.DivisionID
		Where pb.SystemID > 0 and pb.ZoneID is null
		Union
		Select ManagementPriorityID, RegionID
		From BCMyday.ManagementPriority m
		Cross Join BC.Region r
		Where m.TypeID = 1
		And r.Active = 1
		And m.ForAllBottlers = 1
		--And GetDate() Between StartDate And DateAdd(Day, 1, EndDate)
		And GetDate() Between @ConfigPStartDate And @ConfigPEndDate
		And m.LastModified >= @LastModifiedTime
		--Union
		--Select Distinct ManagementPriorityID, b.BCRegionID RegionID
		--From BCMyday.PriorityBottler pb
		--Join BC.Bottler b on pb.BottlerID = b.BottlerID
	) reg on reg.ManagementPriorityID = mp.ManagementPriorityID
	Join 
	(
		Select Distinct ManagementPriorityID, TradeMarkID
		From BCMyday.PriorityBrand
		Union
		Select Distinct ManagementPriorityID, TradeMarkID
		From BCMyday.ManagementPriority m
		Cross Join SAP.TradeMark t
		Where m.TypeID = 1
		And m.ForAllBrands = 1
		And GetDate() Between @ConfigPStartDate And @ConfigPEndDate
		And m.LastModified >= @LastModifiedTime
	) tr on tr.ManagementPriorityID = mp.ManagementPriorityID
	Join
	(
		Select ManagementPriorityID, LocalChainID
		From BCMyday.PriorityChain
		Union 
		Select ManagementPriorityID, l.LocalChainID
		From BCMyday.PriorityChain p
		Join SAP.LocalChain l on p.RegionalChainID = l.RegionalChainID
		Where p.RegionalChainID > 0 And p.LocalChainID is null
		Union 
		Select ManagementPriorityID, l.LocalChainID
		From BCMyday.PriorityChain p
		Join SAP.RegionalChain r on p.NationalChainID = r.NationalChainID
		Join SAP.LocalChain l on r.RegionalChainID = l.RegionalChainID
		Where p.NationalChainID > 0 And p.RegionalChainID is null
		Union
		Select ManagementPriorityID, l.LocalChainID
		From BCMyday.ManagementPriority m
		Cross Join SAP.LocalChain l
		Where m.TypeID = 1
		And m.ForAllChains = 1
		And GetDate() Between @ConfigPStartDate And @ConfigPEndDate
		And m.LastModified >= @LastModifiedTime
	) lc on lc.ManagementPriorityID = mp.ManagementPriorityID
	Join Bc.tRegionChainTradeMark trct on trct.RegionID = reg.RegionID 
			And trct.TradeMarkID = tr.TradeMarkID 
			And trct.LocalChainID = lc.LocalChainID
	Where GetDate() Between @ConfigPStartDate And @ConfigPEndDate
	And mp.LastModified >= @LastModifiedTime
	And reg.RegionID = @RegionID
	And mp.TypeID = 1
	And trct.TerritoryTypeID <> 10
	And trct.ProductTypeID = 1
	And mp.PublishingStatus in (2,3)

	Select * From @MP Order By ManagementPriorityID

	--------------------------------------
	Declare @PriorityChain Table
	(
		ManagementPriorityID int,
		NationalChainID int,
		RegionalChainID int,
		LocalChainID int,
		LastModified DateTime2(7)
	)

	Insert Into @PriorityChain
	Select pc.ManagementPriorityID, NationalChainID, RegionalChainID, LocalChainID,  pc.LastModified
	From BCMyDay.PriorityChain pc
	Join @MP mp on pc.ManagementPriorityID = mp.ManagementPriorityID
	Union
	Select mp.ManagementPriorityID, -1, null, null, mp.LastModified
	From @MP mp
	Where mp.ForAllChains = 1
	Order By pc.ManagementPriorityID, NationalChainID, RegionalChainID, LocalChainID

	Update c
	Set c.RegionalChainID = rc.RegionalChainID
	From @PriorityChain c
	Join SAP.LocalChain rc on c.LocalChainID = rc.LocalChainID

	Update c
	Set c.NationalChainID = rc.NationalChainID
	From @PriorityChain c
	Join SAP.RegionalChain rc on c.RegionalChainID = rc.RegionalChainID

	Select * From @PriorityChain
	-----------------------------------------------

	Select pc.ManagementPriorityID, TradeMarkID, BrandID, pc.LastModified
	From BCMyDay.PriorityBrand pc
	Join @MP mp on pc.ManagementPriorityID = mp.ManagementPriorityID
	Union
	Select mp.ManagementPriorityID, -1, null, mp.LastModified
	From @MP mp 
	Where mp.ForAllBrands = 1
	Order By pc.ManagementPriorityID, TradeMarkID, BrandID, pc.LastModified

Go

------------------------------------
------------------------------------
------------------------------------
ALTER Proc [ETL].[pMergeViewTables]
AS	
	Set NoCount On;

	----------------------------------------
	Merge BC.tBottlerTerritoryType As t
	Using 
		(Select Distinct a.BottlerID, a.TerritoryTypeID, tt.TerritoryTypeName, a.ProductTypeID
		From BC.BottlerAccountTradeMark a
		Join BC.TerritoryType tt on a.TerritoryTypeID = tt.TerritoryTypeID) input
		On t.BottlerID = input.BottlerID And t.TerritoryTypeID = input.TerritoryTypeID And t.ProductTypeID = input.ProductTypeID
	When Not Matched By Target Then
		Insert(BottlerID, TerritoryTypeID, TerritoryTypeName, ProductTypeID, LastModified)
		Values(input.BottlerID, input.TerritoryTypeID, input.TerritoryTypeName, input.ProductTypeID, GetDate())
	When Not matched By Source Then
		Delete;

	----------------------------------------
	Merge [BC].[tBottlerTrademark] As t
	Using 
		(	Select Distinct a.TerritoryTypeID, a.ProductTypeID, b.BottlerID, b.BCBottlerID, b.BottlerName, 
				t.TradeMarkID, t.SAPTradeMarkID, t.TradeMarkName 
			From BC.BottlerAccountTradeMark a
			Join BC.Bottler b on a.BottlerID = b.BottlerID
			Join SAP.TradeMark t on a.TradeMarkID = t.TradeMarkID) input
		On t.TerritoryTypeID = input.TerritoryTypeID And t.ProductTypeID = input.ProductTypeID And t.BottlerID = input.BottlerID And t.TradeMarkID = input.TradeMarkID
	When Not Matched By Target Then
		Insert(TerritoryTypeID, ProductTypeID, BottlerID, BCBottlerID, BottlerName, 
			   TradeMarkID, SAPTradeMarkID, TradeMarkName, LastModified)
		Values(input.TerritoryTypeID, input.ProductTypeID, input.BottlerID, input.BCBottlerID, input.BottlerName, 
			   input.TradeMarkID, input.SAPTradeMarkID, input.TradeMarkName, GetDate())
	When Not matched By Source Then
		Delete;

	---------------------------------------
	Merge BC.tBottlerChainTradeMark t
	Using
		(
			Select Distinct a.TerritoryTypeID, a.ProductTypeID, b.BottlerID, b.BCBottlerID, b.BottlerName, 
			t.TradeMarkID, t.SAPTradeMarkID, t.TradeMarkName, 
			l.LocalChainID, l.SAPLocalChainID, l.LocalChainName, 
			r.RegionalChainID, r.SAPRegionalChainID, r.RegionalChainName, 
			n.NationalChainID, n.SAPNationalChainID, n.NationalChainName 
			From BC.BottlerAccountTradeMark a
			Join SAP.LocalChain l on a.LocalChainID = l.LocalChainID
			Join SAP.RegionalChain r on r.RegionalChainID = l.RegionalChainID
			Join SAP.NationalChain n on r.NationalChainID = n.NationalChainID
			Join BC.Bottler b on a.BottlerID = b.BottlerID
			Join SAP.TradeMark t on a.TradeMarkID = t.TradeMarkID
		) input
		On t.TerritoryTypeID = input.TerritoryTypeID
			And t.ProductTypeID = input.ProductTypeID
			And t.BottlerID = input.BottlerID
			And t.TradeMarkID = input.TradeMarkID
			And t.LocalChainID = input.LocalChainID
	When Not Matched By Target Then
		Insert(TerritoryTypeID, ProductTypeID, BottlerID, BCBottlerID, BottlerName, 
			TradeMarkID, SAPTradeMarkID, TradeMarkName, 
			LocalChainID, SAPLocalChainID, LocalChainName, 
			RegionalChainID, SAPRegionalChainID, RegionalChainName, 
			NationalChainID, SAPNationalChainID, NationalChainName, LastModified)
		Values(input.TerritoryTypeID, input.ProductTypeID, input.BottlerID, input.BCBottlerID, input.BottlerName, 
			input.TradeMarkID, input.SAPTradeMarkID, input.TradeMarkName, 
			input.LocalChainID, input.SAPLocalChainID, input.LocalChainName, 
			input.RegionalChainID, input.SAPRegionalChainID, input.RegionalChainName, 
			input.NationalChainID, input.SAPNationalChainID, input.NationalChainName, GetDate())
	When Not matched By Source Then
		Delete;

	---------------------------------------------
	Truncate Table BC.tBottlerMapping;

	Insert Into BC.tBottlerMapping
	Select ServicingBottler.TradeMarkID, ServicingBottler.CountyID, ServicingBottler.PostalCode, RptgBottlerID, SvcgBottlerID
	From 
	(Select CountyID, PostalCode, BottlerID SvcgBottlerID, TradeMarkID 
	From BC.TerritoryMap
	Where TerritoryTypeID = 12
	And ProductTypeID = 1) ServicingBottler
	Join
	(Select CountyID, PostalCode, BottlerID RptgBottlerID, TradeMarkID 
	From BC.TerritoryMap
	Where TerritoryTypeID = 11
	And ProductTypeID = 1) ReportingBottler 
	on ServicingBottler.CountyID = ReportingBottler.CountyID 
		And ServicingBottler.PostalCode = ReportingBottler.PostalCode
		And ServicingBottler.TradeMarkID = ReportingBottler.TradeMarkID
	Where SvcgBottlerID <> RptgBottlerID

	---------------------------------------
	Merge BC.tRegionChainTradeMark t
	Using
		(
			Select Distinct a.TerritoryTypeID, a.ProductTypeID, b.BCRegionID RegionID, 
			t.TradeMarkID,
			l.LocalChainID,
			r.RegionalChainID,
			r.NationalChainID
			From BC.BottlerAccountTradeMark a
			Join SAP.LocalChain l on a.LocalChainID = l.LocalChainID
			Join SAP.RegionalChain r on r.RegionalChainID = l.RegionalChainID
			Join BC.Bottler b on a.BottlerID = b.BottlerID
			Join SAP.TradeMark t on a.TradeMarkID = t.TradeMarkID
			Where b.BCRegionID is not null
		) input
		On t.TerritoryTypeID = input.TerritoryTypeID
			And t.ProductTypeID = input.ProductTypeID
			And t.RegionID = input.RegionID
			And t.TradeMarkID = input.TradeMarkID
			And t.LocalChainID = input.LocalChainID
	When Not Matched By Target Then
		Insert(TerritoryTypeID, ProductTypeID, RegionID, 
			TradeMarkID, 
			LocalChainID, RegionalChainID, NationalChainID, LastModified)
		Values(input.TerritoryTypeID, input.ProductTypeID, input.RegionID, 
			input.TradeMarkID, 
			input.LocalChainID, 
			input.RegionalChainID,
			input.NationalChainID, SysDateTime())
	When Not matched By Source Then
		Delete;

Go

-------------------
exec [ETL].[pMergeViewTables]
-------------------

Select top 1 *
From BC.tRegionChainTradeMark
