USE Portal_Data_INT
GO
/****** Object:  StoredProcedure [BCMyday].[pGetStoreTieInsHistoryByRegionID]    Script Date: 3/3/2015 11:02:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- BCMyday.pGetStoreTieInsHistoryByREgionID 239, '2015-1-1'
-- BCMyday.pGetStoreTieInsHistoryByREgionID 22, '2015-2-4'
-- exec BCMyday.pGetStoreTieInsHistoryByREgionID 239
-- exec BCMyday.pGetStoreTieInsHistoryByREgionID 240, '2015-1-1'

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

