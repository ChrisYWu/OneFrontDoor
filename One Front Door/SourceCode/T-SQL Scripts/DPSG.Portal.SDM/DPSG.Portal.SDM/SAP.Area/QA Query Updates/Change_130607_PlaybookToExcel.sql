-- provided by Rahul and executed by Vijay around 20130607 1200pm 

use Portal_Data
Go

ALTER PROCedure [PlayBook].[pExportPromotionToExcel]            
 @StartDate Date,            
 @EndDate Date,            
 @CurrentScope varchar(20),            
 @currentuser varchar(20),                      
 @Buid int,            
 @areaid int,            
 @Branchid int                 
as                    
BEGIN                          
                           
 SET NOCOUNT ON;                          
                     
-- Create Temporary table to store Location specific promotion on basis of current location scope of the logged in user                
                
CREATE TABLE #GeoPromotion(GeoPromotionID int)                                  
                
--Retrive BU promotion and store in temp table                
if (@CurrentScope='BU')                
begin                
insert into #GeoPromotion select promotionid from playbook.retailpromotion where promotionbuid=@buid                
end                
--Retrive Region promotion and store in temp table                
if (@CurrentScope='region')                
begin                
                
insert into #GeoPromotion select promotionid from playbook.retailpromotion where promotionbuid=@buid and promotionregionid=@areaid                
end                
--Retrive Branch promotion and store in temp table                
if (@CurrentScope='branch')                
begin                
insert into #GeoPromotion select promotionid from playbook.retailpromotion where promotionbuid=@buid and (promotionbranchid=@branchid OR promotionbranchid is NULL)  
end                
                                  
                                    
BEGIN                        
SELECT retail.PromotionID,                          
  retail.PromotionStatusID,             
  retail.IsLocalized,            
  retail.EDGEItemID,            
  retail.ParentPromotionID,               
  retail.CreatedBy,            
  promoRank.Rank 'PromotionRank',                   
  promoType.PromotionType,            
  promoType.PromotionTypeId,                        
  retail.PromotionName,             
  displaylocation.DisplaylocationName,                         
  retail.PromotionPrice,                          
  promoRank.PromotionWeekStart as PromotionStartDate,                          
  promoRank.PromotionWeekEnd as PromotionEndDate,                          
  stat.StatusName,                          
  category.ShortPromotionCategoryName AS 'PromotionCategory',      
  CASE WHEN retail.PromotionTypeID = 3 THEN _local.LocalChainName                          
    WHEN retail.PromotionTypeID = 2 THEN _regional.RegionalChainName                          
    WHEN retail.PromotionTypeID = 1 THEN _national.NationalChainName                          
    END AS AccountName,                          
  CASE WHEN retail.PromotionTypeID = 3 THEN account.LocalChainID                          
    WHEN retail.PromotionTypeID = 2 THEN account.RegionalChainID                          
    WHEN retail.PromotionTypeID = 1 THEN account.NationalChainID                          
    END AS AccountID               
INTO #tempPromtionalDataList           
FROM PlayBook.RetailPromotion AS retail                        
inner join #GeoPromotion as GP on retail.PromotionID = GP.GeoPromotionID                         -- New Added                                      
INNER JOIN PlayBook.Status AS stat ON retail.PromotionStatusID = stat.StatusID                          
INNER JOIN PlayBook.PromotionCategory AS category ON retail.PromotionCategoryID = category.PromotionCategoryID                          
INNER JOIN Playbook.PromotionDisplayLocation AS promoDisplayLocation on retail.PromotionId=promoDisplayLocation.PromotionId            
INNER JOIN Playbook.DisplayLocation AS displaylocation on promoDisplayLocation.DisplaylocationId=displaylocation.DisplaylocationId            
INNER JOIN PlayBook.PromotionAccount AS account ON retail.PromotionID = account.PromotionID                           
INNER JOIN  PlayBook.PromotionRank AS promoRank ON promoRank.PromotionID = retail.PromotionID                          
INNER JOIN PlayBook.PromotionType promoType ON promoType.PromotionTypeID = retail.PromotionTypeID                  
LEFT OUTER JOIN SAP.LocalChain AS _local ON _local.LocalChainID = account.LocalChainID              
LEFT OUTER JOIN SAP.RegionalChain AS _regional ON _regional.RegionalChainID = account.RegionalChainID             
LEFT OUTER JOIN SAP.NationalChain AS _national ON _national.NationalChainID = account.NationalChainID             
WHERE stat.statusName='Approved'  and      
((      
retail.PromotionStartDate >= @StartDate AND retail.PromotionStartDate <= @EndDate)       
OR (@StartDate>=retail.PromotionStartDate  AND @EndDate>= retail.PromotionStartDate ))            
            
            
SELECT *                       
INTO #PlayBookPromtoionsList                      
FROM #tempPromtionalDataList                      
Where EDGEItemID IS NULL  -- Should not be a EDGE Promotion                      
                      
              
-- For promotions which are from EDGE and are Localized                      
SELECT *                       
INTO #EDGELocalizedPromotionsList                      
FROM #tempPromtionalDataList                      
WHERE IsLocalized = 1      -- Should be a localized                      
AND EDGEItemID IS NOT NULL     -- Must have an EDGE Item ID                      
AND ParentPromotionID IS NOT NULL                      
                      
-- For promotions which are from EDGE and are not localized (Parent)                      
SELECT *                       
INTO #EDGEPromotionsList                   
FROM #tempPromtionalDataList                      
WHERE (IsLocalized = 0 OR IsLocalized IS NULL)           -- Should not be localized                      
AND EDGEItemID IS NOT NULL                -- Must have an EDGE Item ID                      
AND PromotionID NOT IN (SELECT ParentPromotionID FROM #EDGELocalizedPromotionsList)  -- Should not include which have been localized                      
                      
                      
Insert Into #PlayBookPromtoionsList Select * from #EDGELocalizedPromotionsList  --insert in a table to return a single table                  
Insert Into #PlayBookPromtoionsList Select * from #EDGEPromotionsList    --insert in a table to return a single table                  
                      
Select * from #PlayBookPromtoionsList     
END            
          
END 