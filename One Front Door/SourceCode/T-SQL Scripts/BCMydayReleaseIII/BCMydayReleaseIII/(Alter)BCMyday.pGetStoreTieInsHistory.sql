USE [Portal_Data]
GO
/****** Object:  StoredProcedure [BCMyday].[pGetStoreTieInsHistory]    Script Date: 3/4/2015 2:00:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
/*
exec BCMyday.pGetStoreTieInsHistory @BottlerID = 6017, @LastModifiedDate='2015-02-01'
exec BCMyday.pGetStoreTieInsHistory @BottlerID = 12016, @LastModifiedDate='2015-03-01'

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
	FROM BCMyday.StoreCondition a              
	WHERE             
	a.BottlerID = 6017
	and ConditionDate >= '2015-01-01'

*/

Drop Proc [BCMyday].[pGetStoreTieInsHistory]
Go

--ALTER Procedure [BCMyday].[pGetStoreTieInsHistory]                      
--(                                
--	@BottlerID int 
--	,@LastModifiedDate datetime     = null
--)                      
--As                      
--Begin                      
   
--	DECLARE @StoreTieinHistory int;  
--	SELECT @StoreTieinHistory= value from BCMyday.Config  
--	where [Key]='History'                               
                            
--	SELECT distinct StoreConditionID,                      
--	a.AccountId,                      
--	a.ConditionDate,                      
--	a.GSN,                      
--	a.BCSystemID,                      
--	a.Longitude,                      
--	a.Latitude,                      
--	StoreNote,                      
--	CreatedBy,                      
--	CreatedDate,                      
--	ModifiedBy,                      
--	ModifiedDate,                      
--	a.BottlerID,            
--	IsActive,            
--	case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted                        
--	into #StoreCondition            
--	FROM BCMyday.StoreCondition a              
--	WHERE             
--	a.BottlerID = @BottlerID            
--	--and ConditionDate >= DATEADD(MONTH,-@StoreTieinHistory,GETDATE())  
--	and ConditionDate >= case when isnull(@LastModifiedDate,'') = '' then  DATEADD(MONTH,-@StoreTieinHistory,GETDATE())  else @LastModifiedDate end
--	--AND IsActive=1            
             
--	select * from #StoreCondition            
                      
--	SELECT StoreConditionDisplayID,                      
--	StoreConditionID,                      
--	DisplayLocationID,                      
--	PromotionID,                      
--	DisplayLocationNote,                                      
--	OtherNote,                      
--	DisplayImageURL,                      
--	GridX,                      
--	GridY,                      
--	CreatedBy,                      
--	CreatedDate,                      
--	ModifiedBy,                      
--	ModifiedDate,            
--	IsActive,            
--	case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted ,
--	DisplayTypeID,
--	ReasonID
--	into #StoreConditionDisplay            
--	FROM BCMyday.StoreConditionDisplay                      
--	WHERE StoreConditionID in          
--	(SELECT StoreConditionID from #StoreCondition )        
--	--AND IsActive=1             
                
--	select * from #StoreConditionDisplay            
                   
--	SELECT StoreConditionDisplayID,                      
--	SystemPackageID,                      
--	SystemBrandID,                      
--	ModifiedDate,            
--	IsActive,            
--	case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted                      
--	FROM BCMyDay.StoreConditionDisplayDetail                      
--	WHERE StoreConditionDisplayID in          
--	(SELECT StoreConditionDisplayID from #StoreConditionDisplay )         
--	--AND IsActive=1            
              
--	SELECT StoreConditionID,                      
--	TieInRate,                      
--	SystemBrandId,                      
--	ModifiedDate,            
--	IsActive,            
--	case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted                        
--	FROM BCMyday.StoreTieInRate                      
--	WHERE StoreConditionID in          
--	(SELECT StoreConditionID from #StoreCondition )            
--	--AND IsActive=1                    
                      
--	-------------------------------------------
--	Select pe.StoreConditionID, PromotionID, DisplayLocationID StoreConditionDisplayID, PromotionExecutionStatusID, ExecutionID PromotionExecutionID
--	From BCMyDay.PromotionExecution pe
--	Join #StoreCondition se on pe.StoreConditionID = se.StoreConditionID

--	Select pe.StoreConditionID, Note, ImageURL, ImageName, NoteID StoreConditionNoteID
--	From BCMyDay.StoreConditionNote pe
--	Join #StoreCondition se on pe.StoreConditionID = se.StoreConditionID

--	Select pe.StoreConditionID, ManagementPriorityID, PriorityExecutionStatusID, PriorityExecutionID
--	From BCMyDay.PriorityStoreConditionExecution pe
--	Join #StoreCondition se on pe.StoreConditionID = se.StoreConditionID                    
                      
--End