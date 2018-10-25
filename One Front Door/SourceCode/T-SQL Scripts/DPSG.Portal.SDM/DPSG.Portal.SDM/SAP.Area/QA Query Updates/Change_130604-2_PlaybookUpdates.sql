--Provided by J S and executed on 2013-06-04 0912

USE [Portal_Data]
GO

Alter table playbook.retailpromotion 
Add  GEOInfo varchar(500)
GO


Alter table SAP.Nationalchain
Add  SPNationalChainName varchar(30)
GO


USE [Portal_Data]
GO

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
insert into #GeoPromotion select promotionid from playbook.retailpromotion where promotionbuid=@buid and promotionregionid=@areaid and promotionbranchid=@branchid            
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
          --WHERE trademark.TradeMarkID IN ( select _brand.BrandID from PlayBook.PromotionBrand AS _brand where _brand.PromotionID = retail.PromotionID /*and _brand.BrandID in(select --                            
      
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
              --WHERE trademark.TradeMarkID IN (  select _brand.BrandID from PlayBook.PromotionBrand AS _brand where _brand.PromotionID = retail.PromotionID /*and _brand.BrandID in(select --                           
   
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
rollback tran temp  
GO




USE [Portal_Data]
GO

ALTER  PROCEDURE [PlayBook].[pInsertUpdatePromotion]                                  
(                             
--we will add column to save brand-package in json format                               
 @Mode VARCHAR(500),                             
 @PromotionID INT,                            
 @PromotionDescription VARCHAR(500),                          
 @PromotionName VARCHAR(500),                            
 @PromotionTypeID INT, 
 @GEOInfo varchar(500),                           
 @AccountId INT,                            
 @EdgeItemId INT,        
 @IsLocalized BIT,        
 @PromotionTradeMarkID VARCHAR(500),                            
 @PromotionBrandId VARCHAR(500),      
 @PromotionPackageID VARCHAR(500),       
 @PromotionPrice VARCHAR(500) ,                            
 @PromotionCategoryId INT,                            
 @PromotionDisplayLocationId int,                            
 @PromotionDisplayLocationOther VARCHAR(500),                            
 @PromotionStartDate DATETIME,                            
 @PromotionEndDate DATETIME,                            
 @PromotionStatus VARCHAR(500),               
 @IsDuplicate BIT,                            
 @ParentPromoId INT,                            
 @ForecastVolume VARCHAR(500),          
 @BranchId INT,          
 @BUID INT,        
 @RegionId INT,                            
 @CreatedBy VARCHAR(500),                            
 @ModifiedBy VARCHAR(500),                            
 @Status INT OUT,                            
 @Message VARCHAR(500) OUT,                  
 @NewPromoId int OUT        
)                                  
AS                                  
BEGIN                             
DECLARE @PromotionStatusId int                                 
--SET NOCOUNT ON                            
 BEGIN TRY                       
  --Fetch promotion status id by promotion status                            
                              
   SELECT @PromotionStatusId=StatusID                             
   FROM PlayBook.Status                             
   WHERE LOWER(StatusName)=LOWER(@PromotionStatus)                            
                              
                               
   Declare @Attachments table                            
 (                            
 Id int identity,                            
 PromoId int,                            
 Url varchar(500),                            
 Name varchar(500)                            
 )                            
                             
    Declare @tblTradeMark table                            
 (                            
     Id int identity(1,1),                            
     TradeMarkId VARCHAR(100)                            
 )         
    Declare @tblBrands table                            
 (                            
     Id int identity(1,1),                            
     BrandId VARCHAR(100)                            
 )                           
    Declare @tblPackage table                            
 (                            
     Id int identity(1,1),                            
     PackageId VARCHAR(100)                            
 )                            
                              
  IF(@Mode='Insert')                            
  BEGIN                            
-- Insert promotion                         
                          
INSERT INTO PlayBook.RetailPromotion                            
  (                            
  PromotionName,            
  PromotionDescription,                            
  PromotionTypeID,
  GEOInfo,                            
  PromotionPrice,                            
  PromotionCategoryID,                     
  PromotionStatusID,                            
  PromotionStartDate,                            
  PromotionEndDate,                            
  ForecastVolume,        
  PromotionBranchID,          
  PromotionBUID,          
  PromotionRegionID,                         
  EDGEItemID,        
  IsLocalized,        
  CreatedBy,          
  CreatedDate,          
  ModifiedBy,          
  ModifiedDate                               
   )                            
   VALUES                            
   (          
  @PromotionName,             
  @PromotionDescription ,                      
  @PromotionTypeID,
  @GEOInfo,                            
  @PromotionPrice,                            
  @PromotionCategoryId,                            
  @PromotionStatusId,                            
  @PromotionStartDate,                            
  @PromotionEndDate,                            
  @ForecastVolume,          
  @BranchId,          
  @BUID,          
  @RegionId,         
 @EdgeItemId,        
  @IsLocalized,              
  @CreatedBy,                            
  GETDATE(),          
  @ModifiedBy,          
  GETDATE()                           
   )                            
 SET @PromotionID=SCOPE_IDENTITY()                            
  SET @NewPromoId =@PromotionID;                     
 --To create duplicate promotion                             
 IF(@IsDuplicate=1)                            
  UPDATE PlayBook.RetailPromotion                            
  SET ParentPromotionID=@ParentPromoId                            
  WHERE PromotionID=@PromotionID                            
                             
 ----Save data for display location . for other option we have update PromotionDisplayLocationOther column in PlayBook.PromotionDisplayLocation                            
 IF(@PromotionDisplayLocationId=23)--23 id for other option in display location                            
 BEGIN                            
 INSERT INTO PlayBook.PromotionDisplayLocation(PromotionID,DisplayLocationID,PromotionDisplayLocationOther)                 
    VALUES(@PromotionID,@PromotionDisplayLocationId,@PromotionDisplayLocationOther)                            
 END                            
ELSE                            
 BEGIN                            
 INSERT INTO PlayBook.PromotionDisplayLocation(PromotionID,DisplayLocationID)                            
    VALUES(@PromotionID,@PromotionDisplayLocationId)                            
 END                            
                         
 ----Add account for Promotion                            
                             
 IF(@PromotionTypeID=2)--Regional chain                            
 INSERT INTO PlayBook.PromotionAccount(PromotionID,RegionalChainID) VALUES(@PromotionID,@AccountId)                            
                             
 IF(@PromotionTypeID=1)--National chain                     
 INSERT INTO PlayBook.PromotionAccount( PromotionID , NationalChainID ) VALUES( @PromotionID , @AccountId )                            
                             
 IF(@PromotionTypeID=3)--Local chain                            
  INSERT INTO PlayBook.PromotionAccount(PromotionID, LocalChainID) VALUES(@PromotionID,@AccountId)                            
 --   -- Insert trade mark for promotion                             
    INSERT INTO @tblTradeMark(TradeMarkId) SELECT * FROM dbo.split(@PromotionTradeMarkID,',')                            
    INSERT INTO PlayBook.PromotionBrand(PromotionID,TrademarkID) SELECT @PromotionID,CAST(TradeMarkId AS INT) FROM @tblTradeMark                            
       
 --Insert Brand instead of trademark for Core Ten Category      
    if(@PromotionBrandId !='')      
    BEGIN      
     INSERT INTO @tblBrands(BrandId) select * from dbo.split(@PromotionBrandId,',')      
     INSERT INTO PlayBook.PromotionBrand(PromotionID,BrandID) SELECT @PromotionID,CAST(BrandId AS INT) FROM @tblBrands                            
    END      
                            
     --Insert Package for promotion                            
 INSERT INTO @tblPackage(PackageId) SELECT * FROM dbo.split(@PromotionPackageID,',')                 
    INSERT INTO PlayBook.PromotionPackage(PromotionID,PackageID) SELECT @PromotionID,CAST(PackageId AS INT) FROM @tblPackage                            
                            
   SET @Status=1                            
  SET @Message='Promotion has been inserted successfully.'          
END                            
--Update Promotion                                 
                              
IF(@Mode='Update')                            
  BEGIN                            
  UPDATE PlayBook.RetailPromotion                            
  SET                             
  PromotionName=@PromotionName,             
  PromotionDescription=@PromotionDescription,                           
  PromotionTypeID=@PromotionTypeID,                            
  PromotionPrice=@PromotionPrice,                            
  PromotionCategoryID=@PromotionCategoryId,                            
  PromotionDisplayLocationID=@PromotionDisplayLocationID,                            
  PromotionStatusID= @PromotionStatusId,                            
  PromotionStartDate=@PromotionStartDate,                            
  PromotionEndDate=@PromotionEndDate,                            
  ForecastVolume=@ForecastVolume,             
  PromotionBranchID=@BranchId,          
  PromotionBUID=@BUID,          
  PromotionRegionID=@RegionId,          
  EDGEItemID=@EdgeItemId,
  GEOInfo=@GEOInfo,        
  IsLocalized=@IsLocalized,        
  ModifiedBy=@ModifiedBy,                            
  ModifiedDate=GETDATE()                            
 WHERE PromotionId=@PromotionID                            
                      
                             
 IF(@PromotionDisplayLocationId=23)                            
 BEGIN                             
    UPDATE PlayBook.PromotionDisplayLocation                            
    SET                            
    DisplayLocationID=@PromotionDisplayLocationId,                            
    PromotionDisplayLocationOther=@PromotionDisplayLocationOther                            
    WHERE PromotionID=@PromotionID;                            
                                
 END                            
                             
 ELSE                             
 BEGIN                            
                             
 UPDATE PlayBook.PromotionDisplayLocation                            
  SET DisplayLocationID=@PromotionDisplayLocationId,                            
   PromotionDisplayLocationOther=null                            
  WHERE PromotionID=@PromotionID;                            
 END                            
                            
                             
 IF(@PromotionTypeID=2)--Regional chain                            
 UPDATE PlayBook.PromotionAccount                            
  SET RegionalChainID=@AccountId,                            
  NationalChainID=null,                            
  LocalChainID=null                            
  WHERE PromotionID=@PromotionID                            
                             
 IF(@PromotionTypeID=1)--National chain                            
  UPDATE PlayBook.PromotionAccount                            
   SET NationalChainID=@AccountId,                            
       RegionalChainID=null,                            
       LocalChainID=null                            
   WHERE PromotionID=@PromotionID                            
                               
 IF(@PromotionTypeID=3)--Local chain                            
 UPDATE PlayBook.PromotionAccount                            
  SET LocalChainID=@AccountId,                          
  NationalChainID=null,                            
  RegionalChainID=null                            
  WHERE PromotionID=@PromotionID                            
                             
                   
      --Delete Brands and Insert new so that we can have updated brands for promotion.                            
 DELETE PlayBook.PromotionBrand                            
 WHERE PromotionID=@PromotionID                            
                               
 --Insert TradeMark for promotion                              
 INSERT INTO @tblTradeMark(TradeMarkId) SELECT * FROM dbo.split(@PromotionTradeMarkID,',')                            
 INSERT INTO PlayBook.PromotionBrand(PromotionID,TrademarkID) SELECT @PromotionID,CAST(TradeMarkId AS INT) FROM @tblTradeMark                            
         
   --Insert brandid instead of trademarkid for core ten category      
      
 if(@PromotionBrandId !='')      
   BEGIN      
    INSERT INTO @tblBrands(BrandId) select * from dbo.split(@PromotionBrandId,',')      
    INSERT INTO PlayBook.PromotionBrand(PromotionID,BrandID) SELECT @PromotionID,CAST(BrandId AS INT) FROM @tblBrands                            
   END      
      
     --Insert Package for promotion                            
    DELETE PlayBook.PromotionPackage                            
   WHERE PromotionID=@PromotionID                            
                               
                                
 INSERT INTO @tblPackage(PackageId) SELECT * FROM dbo.split(@PromotionPackageID,',')                            
                             
    INSERT INTO PlayBook.PromotionPackage(PromotionID,PackageID) SELECT @PromotionID,CAST(PackageId AS INT) FROM @tblPackage                            
    SET @NewPromoId =0;                                 
 SET @Status=1                            
 SET @Message='Promotion has been updated successfully.'                            
 END                            
                             
--COMMIT                              
END TRY                            
BEGIN CATCH                            
  SET @Message=ERROR_MESSAGE()                            
  SET @Status=0                            
 --ROLLBACK                            
END CATCH                              
END
GO



USE [Portal_Data]
GO

/****** Object:  StoredProcedure [PlayBook].[pGetLatestPromotions]    Script Date: 6/2/2013 11:02:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================                
-- Author  : Sumit Kanchan                
-- Create date : 06/May/2013                
-- Description : This procedure will get all the latest promotions                
-- =============================================                
ALTER PROCEDURE [PlayBook].[pGetLatestPromotions]                
 @LastLogin DateTime,                
 @CurrentScope varchar(20),           -- Current user location scope      
 @currentuser varchar(20)  ,          -- Current user          
 @Buid int,        -- Current user BUID                         
 @areaid int,      -- Current user Area ID                         
 @Branchid int      -- Current user Branch ID        
AS                
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
insert into #GeoPromotion select promotionid from playbook.retailpromotion where promotionbuid=@buid and promotionregionid=@areaid and promotionbranchid=@branchid        
end        
                  
SELECT DISTINCT retail.PromotionID,                                      
  retail.PromotionStatusID,                       
  retail.IsLocalized,                    
  retail.EDGEItemID,                    
  retail.ParentPromotionID,                            
  retail.CreatedBy,                                       
  1 AS 'PromotionRank',                               
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
( retail.CreatedDate > @LastLogin OR retail.ModifiedDate > @LastLogin)             
AND retail.PromotionBUID = @Buid        
        
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
GO


USE [Portal_Data]
GO

/****** Object:  StoredProcedure [PlayBook].[pExportPromotionToExcel]    Script Date: 6/2/2013 11:03:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
ALTER PROC [PlayBook].[pExportPromotionToExcel]        
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
insert into #GeoPromotion select promotionid from playbook.retailpromotion where promotionbuid=@buid and promotionregionid=@areaid and promotionbranchid=@branchid            
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
(  
retail.PromotionStartDate >= @StartDate AND retail.PromotionStartDate <= @EndDate)   
OR (@StartDate>=retail.PromotionStartDate  AND @EndDate>= retail.PromotionStartDate )        
        
        
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
GO


