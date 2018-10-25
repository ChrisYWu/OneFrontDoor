-- Provided by JS and executed at 2013-06-04 1312
-- Original file name is SQLScript_June4_2.sql

USE [Portal_Data]
GO


Begin Tran temp
go

ALTER PROCEDURE [PlayBook].[pGetPlayBookDetailsByDate]                                     
 @StartDate Date,                   -- Promotion Start date                
 @EndDate Date,      -- Promotion End Date                
 @IsCalendarView bit,               -- Flag for Calendar view and List View                
 @CurrentScope varchar(20),         -- Current user location scope                       
 @currentuser varchar(20),          -- Current user location scope                             
 @Buid int,       -- Current user BUID                             
 @areaid int,      -- Current user Area ID                             
 @Branchid int      -- Current user Branch ID                             
AS                                    
BEGIN                                    
                                     
                                   
            
-- Create Temporary table to store Location specific promotion on basis of current location scope of the logged in user            
            
CREATE TABLE #GeoPromotion(GeoPromotionID int)                              
            
--Retrive BU promotion and store in temp table            
if (@CurrentScope='BU')            
begin            
insert into #GeoPromotion select promotionid from playbook.retailpromotion where promotionbuid=@buid            
end            
--Retrive Region promotion and store in temp table            
--if (@CurrentScope='region')            
--begin            
            
--insert into #GeoPromotion select promotionid from playbook.retailpromotion where promotionbuid=@buid and promotionregionid=@areaid            
--end            
--Retrive Branch promotion and store in temp table            
if (@CurrentScope='branch')            
begin            
insert into #GeoPromotion select promotionid from playbook.retailpromotion where promotionbuid=@buid and promotionbranchid=@branchid            
end            
                              
if @IsCalendarView = 1                                  
BEGIN                                  
SELECT DISTINCT retail.PromotionID,                                    
  retail.PromotionStatusID,                     
  retail.IsLocalized,                  
  retail.EDGEItemID,                  
  retail.ParentPromotionID,                                     
  1 as PromotionRank,                              
  promoType.PromotionType,                                 
  retail.PromotionName,                                    
  retail.PromotionPrice,                                    
  retail.PromotionStartDate,                                    
  retail.PromotionEndDate,                                    
  stat.StatusName 'PromotionStatus',                                    
  category.ShortPromotionCategoryName AS 'PromotionCategory',                                    
  STUFF((SELECT DISTINCT '| ' + attachment.AttachmentName + ';' + attachment.AttachmentURL                                    
              FROM PlayBook.PromotionAttachment AS attachment                                    
              WHERE attachment.PromotionId = retail.PromotionID                                    
              FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'') as AttachmentsName,                                    
        STUFF((SELECT DISTINCT ' | ' + trademark.TradeMarkName                                    
              FROM SAP.TradeMark as trademark                                    
          --WHERE trademark.TradeMarkID IN ( select _brand.BrandID from PlayBook.PromotionBrand AS _brand where _brand.PromotionID = retail.PromotionID /*and _brand.BrandID in(select BrandidTemp from #PromotionBrandid)*/)                                  
      
     WHERE trademark.TradeMarkID IN ( select _brand.TrademarkID from PlayBook.PromotionBrand AS _brand where _brand.PromotionID = retail.PromotionID /*and _brand.BrandID in(select BrandidTemp from #PromotionBrandid)*/)                                    
          -- WHERE trademark.TradeMarkID IN ( select _brand.BrandID from PlayBook.PromotionBrand AS _brand where _brand.BrandID in(select BrandidTemp from #PromotionBrandid))                                    
     FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'') AS PromotionBrands,                                    
        STUFF((SELECT DISTINCT ' | ' + package.PackageName                                    
              FROM SAP.Package as package                                    
              WHERE package.PackageID IN ( select _package.PackageID from PlayBook.PromotionPackage AS _package where _package.PromotionID = retail.PromotionID)                                    
              FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'') AS PromotionPackages,                                    
        CASE WHEN retail.PromotionTypeID = 3 THEN _local.LocalChainName                       
    WHEN retail.PromotionTypeID = 2 THEN _regional.RegionalChainName                                    
    WHEN retail.PromotionTypeID = 1 THEN _national.NationalChainName                                    
    END AS AccountName,                                    
  CASE WHEN retail.PromotionTypeID = 3 THEN account.LocalChainID                                    
    WHEN retail.PromotionTypeID = 2 THEN account.RegionalChainID                                    
    WHEN retail.PromotionTypeID = 1 THEN account.NationalChainID                                    
    END AS AccountID,          
  CASE WHEN retail.PromotionTypeID = 3 THEN (SELECT  NationalChainName FROM SAP.NationalChain        
            WHERE NationalChainID = (SELECT NationalChainID FROM SAP.RegionalChain        
                    WHERE  RegionalChainID = (Select RegionalChainID from SAP.LocalChain        
                         Where LocalChainName = _local.LocalChainName )))                                  
    WHEN retail.PromotionTypeID = 2 THEN (SELECT  NationalChainName FROM SAP.NationalChain        
            WHERE NationalChainID = (SELECT NationalChainID FROM SAP.RegionalChain        
                 WHERE RegionalChainName = _regional.RegionalChainName))                                   
    WHEN retail.PromotionTypeID = 1 THEN _national.NationalChainName                                    
    END AS AccountImageName                                      
INTO #tempPromtionalDataCaledar               -- Temp Table that will contain all the non edge promotions                  
FROM PlayBook.RetailPromotion AS retail                                   
inner join #GeoPromotion as GP on retail.PromotionID = GP.GeoPromotionID                         -- New Added            
INNER JOIN PlayBook.Status AS stat ON retail.PromotionStatusID = stat.StatusID                                    
INNER JOIN PlayBook.PromotionCategory AS category ON retail.PromotionCategoryID = category.PromotionCategoryID                                    
INNER JOIN PlayBook.PromotionAccount AS account ON retail.PromotionID = account.PromotionID                                     
INNER JOIN  PlayBook.PromotionRank AS promoRank ON promoRank.PromotionID = retail.PromotionID                                     
INNER JOIN PlayBook.PromotionType promoType ON promoType.PromotionTypeID = retail.PromotionTypeID                                  
LEFT OUTER JOIN SAP.LocalChain AS _local ON _local.LocalChainID = account.LocalChainID                 
LEFT OUTER JOIN SAP.RegionalChain AS _regional ON _regional.RegionalChainID = account.RegionalChainID            
LEFT OUTER JOIN SAP.NationalChain AS _national ON _national.NationalChainID = account.NationalChainID                 
WHERE                 
(@StartDate BETWEEN retail.PromotionStartDate AND retail.PromotionEndDate                                   
OR retail.PromotionStartDate BETWEEN @StartDate AND @EndDate)            
    
                    
-- For promotions that are not from EDGE                  
SELECT *                   
INTO #PlayBookPromtoionsCalendar                  
FROM #tempPromtionalDataCaledar                  
Where EDGEItemID IS NULL  -- Should not be a EDGE Promotion                  
              
-- For promotions which are from EDGE and are Localized                  
SELECT *                   
INTO #EDGELocalizedPromotions                  
FROM #tempPromtionalDataCaledar                  
WHERE IsLocalized = 1      -- Should be a localized                  
AND EDGEItemID IS NOT NULL     -- Must have an EDGE Item ID                  
AND ParentPromotionID IS NOT NULL                  
                  
-- For promotions which are from EDGE and are not localized (Parent)                  
SELECT *                   
INTO #EDGEPromotions                  
FROM #tempPromtionalDataCaledar                  
WHERE (ISLocalized = 0 OR IsLocalized is NULL)          -- Should not be localized                  
AND EDGEItemID IS NOT NULL               -- Must have an EDGE Item ID                  
AND PromotionID NOT IN (SELECT ParentPromotionID FROM #EDGELocalizedPromotions)  -- Should not include which have been localized                  
                  
Insert Into #PlayBookPromtoionsCalendar Select * from #EDGELocalizedPromotions                  
Insert Into #PlayBookPromtoionsCalendar Select * from #EDGEPromotions                  
                  
Select * from #PlayBookPromtoionsCalendar                
END                                    
                                  
ELSE                                  
BEGIN                                  
SELECT DISTINCT retail.PromotionID,                                    
  retail.PromotionStatusID,                     
  retail.IsLocalized,                  
  retail.EDGEItemID,                  
  retail.ParentPromotionID,                          
  retail.CreatedBy,                                     
  promoRank.Rank 'PromotionRank',                             
  promoType.PromotionType,                                 
  retail.PromotionName,                                    
  retail.PromotionPrice,                                    
  retail.PromotionStartDate,                                    
  retail.PromotionEndDate,                                    
  stat.StatusName 'PromotionStatus',                                    
  category.ShortPromotionCategoryName AS 'PromotionCategory',                                    
  STUFF((SELECT DISTINCT '| ' + attachment.AttachmentName + ';' + attachment.AttachmentURL                                    
              FROM PlayBook.PromotionAttachment AS attachment                                    
              WHERE attachment.PromotionId = retail.PromotionID                                    
              FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'') as AttachmentsName,                                    
        STUFF((SELECT DISTINCT ' | ' + trademark.TradeMarkName                                    
      FROM SAP.TradeMark as trademark                                    
              --WHERE trademark.TradeMarkID IN (  select _brand.BrandID from PlayBook.PromotionBrand AS _brand where _brand.PromotionID = retail.PromotionID /*and _brand.BrandID in(select BrandidTemp from #PromotionBrandid)*/)                             
   
    WHERE trademark.TradeMarkID IN ( select _brand.TrademarkID from PlayBook.PromotionBrand AS _brand where _brand.PromotionID = retail.PromotionID)  
                  FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'') AS PromotionBrands,                                    
        STUFF((SELECT DISTINCT ' | ' + package.PackageName                                    
              FROM SAP.Package as package                                    
              WHERE package.PackageID IN ( select _package.PackageID from PlayBook.PromotionPackage AS _package where _package.PromotionID = retail.PromotionID)                                    
    FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'') AS PromotionPackages,                                    
  CASE WHEN retail.PromotionTypeID = 3 THEN _local.LocalChainName                                    
    WHEN retail.PromotionTypeID = 2 THEN _regional.RegionalChainName                                    
    WHEN retail.PromotionTypeID = 1 THEN _national.NationalChainName                                    
    END AS AccountName,                                    
  CASE WHEN retail.PromotionTypeID = 3 THEN account.LocalChainID                                    
    WHEN retail.PromotionTypeID = 2 THEN account.RegionalChainID                                    
    WHEN retail.PromotionTypeID = 1 THEN account.NationalChainID                                    
    END AS AccountID,          
  CASE WHEN retail.PromotionTypeID = 3 THEN (SELECT  NationalChainName FROM SAP.NationalChain        
            WHERE NationalChainID = (SELECT NationalChainID FROM SAP.RegionalChain        
                    WHERE  RegionalChainID = (Select RegionalChainID from SAP.LocalChain        
                         Where LocalChainName = _local.LocalChainName )))                                  
    WHEN retail.PromotionTypeID = 2 THEN (SELECT  NationalChainName FROM SAP.NationalChain        
            WHERE NationalChainID = (SELECT NationalChainID FROM SAP.RegionalChain        
                    WHERE RegionalChainName = _regional.RegionalChainName))                                   
    WHEN retail.PromotionTypeID = 1 THEN _national.NationalChainName                                    
    END AS AccountImageName                    
INTO #tempPromtionalDataList                          
FROM PlayBook.RetailPromotion AS retail            
inner join #GeoPromotion as GP on retail.PromotionID = GP.GeoPromotionID                         -- New Added                                  
INNER JOIN PlayBook.Status AS stat ON retail.PromotionStatusID = stat.StatusID                                    
INNER JOIN PlayBook.PromotionCategory AS category ON retail.PromotionCategoryID = category.PromotionCategoryID                                    
INNER JOIN PlayBook.PromotionAccount AS account ON retail.PromotionID = account.PromotionID                                     
INNER JOIN  PlayBook.PromotionRank AS promoRank ON promoRank.PromotionID = retail.PromotionID                                    
INNER JOIN PlayBook.PromotionType promoType ON promoType.PromotionTypeID = retail.PromotionTypeID                            
LEFT OUTER JOIN SAP.LocalChain AS _local ON _local.LocalChainID = account.LocalChainID                 
LEFT OUTER JOIN SAP.RegionalChain AS _regional ON _regional.RegionalChainID = account.RegionalChainID                
LEFT OUTER JOIN SAP.NationalChain AS _national ON _national.NationalChainID = account.NationalChainID                
WHERE                 
(@StartDate BETWEEN retail.PromotionStartDate AND retail.PromotionEndDate OR                   
retail.PromotionStartDate BETWEEN @StartDate AND @EndDate)                                 
AND promoRank.PromotionWeekStart = @StartDate              
     
-- For promotions that are not from EDGE                  
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



    
commit tran temp    
GO






