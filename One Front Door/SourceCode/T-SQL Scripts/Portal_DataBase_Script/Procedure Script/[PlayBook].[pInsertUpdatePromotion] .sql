--===================================================          
--Author-HCL          
--CreatedDate-03-March-2013          
--Description-The procedure is used to add/update Promotion to Platbook.RetailPromotion          
--Example Exec [PlayBook].[pInsertUpdatePromotion] 1096,'Promotion Test','Promotion Description','Promotion Name','4','A30','Region','BD46','6500',7,8,9,'05-10-2013','04-10-2013',4,0,1023,767,77,4,55,'User','user',0,'message',1          
          
--==================================================          
                              
CREATE  PROCEDURE [PlayBook].[pInsertUpdatePromotion]                                    
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