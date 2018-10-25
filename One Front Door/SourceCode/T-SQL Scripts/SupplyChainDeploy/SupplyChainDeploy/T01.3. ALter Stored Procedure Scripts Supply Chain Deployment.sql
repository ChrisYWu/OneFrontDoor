Use Portal_Data
Go

PRINT N'Altering PROCEDURE [Playbook].[pGetPromotionFilterAccount]...';
Go
ALTER PROCEDURE [Playbook].[pGetPromotionFilterAccount] @FilterType VARCHAR(50)  
AS  
BEGIN  
 SELECT ChainName  
  ,ChainId  
 INTO #ChainPromotion  
 FROM (  
  SELECT 'N-'+convert(varchar(20),a.nationalchainid) + '-' + convert(varchar(20),b.SAPNationalChainID) ChainID  
   ,b.NationalChainName ChainName, a.PromotionID  
  FROM playbook.promotionaccount a  
  INNER JOIN sap.NationalChain b ON a.nationalchainid = b.nationalchainid  
  WHERE a.promotionid IN (  
    SELECT promotionid  
    FROM #PromoIds  
    )  
    
  UNION  
    
  SELECT   
   case when isnull(c.nationalchainname,'') = 'All Other' then 'R-' else 'N-' end  
   +convert(varchar(20),a.RegionalChainid) + '-' + convert(varchar(20),b.SAPRegionalChainID)  
   ,b.RegionalChainName, a.PromotionID  
  FROM playbook.promotionaccount a  
  INNER JOIN sap.RegionalChain b ON a.RegionalChainid = b.RegionalChainid  
  left join sap.nationalchain c on b.nationalchainid = c.nationalchainid  
  WHERE a.promotionid IN (  
    SELECT promotionid  
    FROM #PromoIds  
    )  
    
  UNION  
    
  SELECT   
   case when isnull(d.nationalchainname,'') = 'All Other' and isnull(c.regionalchainname,'') = 'All Other'  
    then 'L-'  
    when isnull(d.nationalchainname,'') = 'All Other' and isnull(c.regionalchainname,'') <> 'All Other'  
    then 'R-'   
    else 'N-' end  
    +convert(varchar(20),a.LocalChainid)  + '-' + convert(varchar(20),b.SAPLocalChainID)  
   ,b.LocalChainName, a.PromotionID  
  FROM playbook.promotionaccount a  
  INNER JOIN sap.LocalChain b ON a.LocalChainid = b.LocalChainid  
  left join sap.regionalchain c on b.regionalchainid = c.regionalchainid  
  left join sap.nationalchain d on c.nationalchainid = d.nationalchainid  
  WHERE a.promotionid IN (  
    SELECT promotionid  
    FROM #PromoIds  
    )  
  ) a  
 WHERE a.promotionid IN (  
   SELECT promotionid  
   FROM #PromoIds  
   )  
  
 SELECT ' My Account' TEXT  
  ,'My Account' Value  
   
 UNION ALL  
   
 SELECT ' All Account' TEXT  
  ,'-1' Value  
 WHERE CharIndex('All Accounts', @FilterType) > 1  
   
 UNION ALL  
   
 SELECT DISTINCT ChainName  
  ,ChainId  
 FROM #ChainPromotion a  
 ORDER BY 1  
END

-- Alter SP --
GO
PRINT N'Altering PROCEDURE [Playbook].[pGetPromotionDetailsForCalendar]...'
GO
ALTER PROCEDURE [Playbook].[pGetPromotionDetailsForCalendar]     
  @StartDate DATE --= '10/1/2014 12:00:00 AM'-- Promotion Start date                                         
 ,@EndDate DATE --= '12/31/2014 12:00:00 AM' -- Promotion End Date                                           
 ,@currentuser VARCHAR(20) --='tesbm001' -- Current user                                          
 ,@Branchid INT --='139'-- Current Branch                                          
 ,@VIEW_DRAFT_NA BIT --='false'-- True/False : if the user has the rights to View National Account promotion in draft mode for Promotion Activities                                          
 ,@ViewNatProm BIT --='false'-- True/False :  if the user has the rights to View National Promotion for Promotion Activities                                          
 ,@RolledOutAccount VARCHAR(MAX) = '' --= '12,13,20,21,47,60,85,87,173'--'' -- Optional parameter with default null value for rolled out account, passed from front end using SRE                                          
 ,@BCRegionId VARCHAR(max) --=0                         
 ,@CurrentPersonaID INT --= 6        
 ,@TradeMarkId VARCHAR(MAX) =''  
 ,@PackageId VARCHAR(MAX) =''  
AS      
BEGIN      
 DECLARE @LOCAL_startdate DATETIME      
 DECLARE @LOCAL_enddate DATETIME      
 DECLARE @LOCAL_currentuser VARCHAR(20)      
 DECLARE @LOCAL_Branchid INT      
 DECLARE @Local_IsExport BIT      
 DECLARE @TypeId INT      
 DECLARE @bool INT      
      
 --set @Branchid = 120                                    
 SET @LOCAL_startdate = @StartDate      
 SET @LOCAL_enddate = @EndDate      
 SET @LOCAL_currentuser = @currentuser      
 SET @LOCAL_Branchid = @Branchid      
 SET @Local_IsExport = 0      
 SET @TypeId = 2      
 SET @bool = 1      
      
 SELECT 1 Promotionid      
 INTO #PromoIds      
      
 IF (@BCRegionId > 0)      
 BEGIN      
  INSERT INTO #PromoIds      
  EXEC [Playbook].[pGetBCPromotionsByRole] @LOCAL_startdate      
   ,@LOCAL_enddate      
   ,@currentuser      
   ,@BCRegionId      
   ,@VIEW_DRAFT_NA      
   ,@ViewNatProm      
   ,@Local_IsExport      
   ,NULL      
   ,@CurrentPersonaID      
 END      
 ELSE      
 BEGIN      
  IF (@TradeMarkId = '' AND @PackageId = '')      
  BEGIN      
   INSERT INTO #PromoIds      
   EXEC [Playbook].[pGetPromotionsByRole] @LOCAL_startdate      
    ,@LOCAL_enddate      
    ,@LOCAL_currentuser      
    ,@LOCAL_Branchid      
    ,@VIEW_DRAFT_NA      
    ,@ViewNatProm      
    ,@RolledOutAccount      
    ,@Local_IsExport      
    ,@CurrentPersonaID      
  END      
  ELSE      
  BEGIN      
   INSERT INTO #PromoIds      
   EXEC [SupplyChain].[pGetMyPromotion] @LOCAL_Branchid      
    ,@TradeMarkId      
    ,@PackageId      
    ,@TypeId      
    ,@bool      
    ,@LOCAL_startdate      
    ,@LOCAL_enddate    
    ,@LOCAL_currentuser      
    ,@CurrentPersonaID       
  END      
 END      
      
 -- Implement IsMyAccount                    
 DECLARE @SPUserPRofileID INT      
      
 SELECT @SPUserPRofileID = SPUserprofileid      
 FROM Person.SPUserPRofile      
 WHERE GSn = @currentuser      
      
 SELECT DISTINCT b.LocalChainID      
  ,b.RegionalChainID      
  ,b.NationalChainID      
 INTO #UserAccount      
 FROM Person.UserAccount a      
 LEFT JOIN Shared.tLocationChain b ON (      
   a.LocalChainID = b.LocalChainID      
   OR a.RegionalChainID = b.RegionalChainID      
   OR a.NationalChainID = b.NationalChainID      
   )      
 WHERE a.SPUserPRofileID = @SPUserPRofileID      
      
 SELECT - 1 Channelid      
 INTO #UserChannel      
      
 INSERT INTO #UserChannel      
 SELECT DISTINCT a.Channelid      
 FROM Person.UserChannel a      
 WHERE a.SPUserPRofileID = @SPUserPRofileID      
  AND a.Channelid IS NOT NULL      
       
 UNION      
       
 SELECT DISTINCT b.Channelid      
 FROM Person.UserChannel a      
 LEFT JOIN sap.channel b ON a.superchannelid = b.superchannelid      
 WHERE a.SPUserPRofileID = @SPUserPRofileID      
  AND a.superchannelid IS NOT NULL      
      
 SELECT DISTINCT retail.PromotionID      
  ,retail.PromotionName      
  ,retail.PromotionRelevantStartdate      
  ,retail.PromotionRelevantEnddate      
  ,retail.ProgramId      
  ,retail.IsNationalAccount 'IsNationalAccountPromotion'      
  ,PromotionType.PromotionType      
  ,retail.PromotionGroupID      
  ,retail.createdby AS CreatedBy      
  ,retail.UserGroupName AS UserGroupName -- Added new                    
  ,CASE -- For Is My Account                    
   WHEN retail.PromotionGroupID = 1      
    THEN (      
      CASE       
       WHEN (      
         SELECT TOP 1 1      
         FROM PlayBook.PromotionAccountHier AS account      
         WHERE account.PromotionID = retail.PromotionID      
          AND account.LocalChainID IN (      
           SELECT uAccount.LocalChainID      
           FROM #UserAccount uAccount      
           )      
         ) = 1      
        THEN 1      
       ELSE 0      
       END      
      )      
   WHEN retail.PromotionGroupID = 2      
    THEN 0      
   END AS 'IsMyAccount'      
  ,CASE       
   WHEN retail.PromotioNGroupID = 2      
    THEN (      
      CASE       
       WHEN (      
         SELECT TOP 1 1      
         FROM Playbook.PromotionChannel a      
         LEFT JOIN sap.channel b ON a.superchannelid = b.superchannelid      
         WHERE a.PromotionID = retail.PromotionID      
          AND CASE       
           WHEN isnull(a.SuperChannelid, 0) <> 0      
            THEN b.ChannelID      
           ELSE a.channelId      
           END IN (      
           SELECT channelid      
           FROM #UserChannel      
           )      
         ) = 1      
        THEN 1      
       ELSE 0      
       END      
      )      
   WHEN retail.PromotionGroupID = 1      
    THEN 0      
   END AS 'IsMyChannel'      
 INTO #TempPromotionData      
 FROM PlayBook.RetailPromotion AS retail      
 LEFT JOIN playbook.PromotionType PromotionType ON retail.PromotionTypeID = PromotionType.PromotionTypeID      
 INNER JOIN PlayBook.PromotionGroup promoGroup ON promoGroup.PromotionGroupID = retail.PromotionGroupID      
 WHERE retail.PromotionStatusID = 4      
  AND retail.PromotionID IN (      
   SELECT promotionid      
   FROM #PromoIds      
   )      
      
 --Get All Account                                                                                                                                    
 SELECT DISTINCT retail.PromotionID      
  ,_account.localchainID AS LocalchainID      
  ,_account.RegionalchainID AS RegionalchainID      
  ,_account.NationalchainID AS NationalchainID      
  ,CASE       
   WHEN _account.localchainID <> 0      
    THEN (      
      SELECT LocalChainName      
      FROM SAP.LocalChain AS _sapLocal      
      WHERE _account.LocalChainID = _sapLocal.LocalChainID      
      )      
   WHEN _account.RegionalchainID <> 0      
    THEN (      
      SELECT RegionalChainName      
      FROM SAP.RegionalChain AS _sapRegional      
      WHERE _account.RegionalChainID = _sapRegional.RegionalChainID      
      )      
   WHEN _account.NationalchainID <> 0      
    THEN (      
      SELECT NationalChainName      
      FROM SAP.NationalChain AS _sapNational      
      WHERE _account.NationalChainID = _sapNational.NationalChainID      
      )      
   END AS AccountName      
  ,'True' AS IsMyAccount      
 FROM #TempPromotionData AS retail      
 INNER JOIN Playbook.PromotionAccount _account ON retail.promotionId = _account.PromotionId      
 WHERE retail.PromotionGroupID = 1      
      
 --Get All Channel                                                          
 SELECT DISTINCT retail.PromotionID      
  ,_channel.SuperChannelID AS SuperChannelID      
  ,_channel.ChannelID AS ChannelID      
  ,CASE       
   WHEN _channel.SuperChannelID IS NOT NULL      
    THEN (      
      SELECT SuperChannelName      
      FROM SAP.SuperChannel AS _sapSuperChannel      
      WHERE _channel.SuperChannelID = _sapSuperChannel.SuperChannelID      
      )      
   WHEN _channel.ChannelID IS NOT NULL      
    THEN (      
 SELECT ChannelName      
      FROM SAP.Channel AS _sapChannel      
      WHERE _channel.ChannelID = _sapChannel.ChannelID      
      )      
   END AS ChannelName      
 FROM #TempPromotionData AS retail      
 INNER JOIN Playbook.PromotionChannel _channel ON retail.promotionId = _channel.PromotionId      
 WHERE retail.PromotionGroupID = 2      
      
 -- Get Promotion                                          
 SELECT *      
 FROM #TempPromotionData      
      
 --Get All Programs                                               
 SELECT DISTINCT retail.PromotionID      
  ,_program.ProgramID      
  ,_program.ProgramName      
 FROM #TempPromotionData AS retail      
 INNER JOIN NationalAccount.Program _program ON retail.ProgramID = _program.ProgramID      
END
GO
PRINT N'Altering PROCEDURE [Playbook].[pGetPromotionFilter]...';
Go
ALTER PROCEDURE [Playbook].[pGetPromotionFilter]   
  @StartDate DATE --='10/1/2014 12:00:00 AM'                
 ,@EndDate DATE --='12/31/2014 12:00:00 AM'                
 ,@currentuser VARCHAR(20) --='tesbm001'                  
 ,@Branchid VARCHAR(max) --=75                
 ,@BCRegionId VARCHAR(max) =0        
 ,@VIEW_DRAFT_NA BIT --='False'-- True/False : if the user has the rights to View National Account promotion in draft mode for Promotion Activities                      
 ,@ViewNatProm BIT --='False'-- True/False :  if the user has the rights to View National Promotion for Promotion Activities                      
 ,@RolledOutAccounts VARCHAR(MAX) = '' --Comma seperated rolledout account list for NA users, passed form frontend using SER.                      
 ,@IsExport BIT = 0      
 ,@FilterType VARCHAR(50) --='account'--'brand' package Bottler account               
 ,@PromotionStatus INT = NULL      
 ,@CurrentPersonaID INT --= 0
 ,@TradeMarkId VARCHAR(MAX) =''
 ,@PackageId VARCHAR(MAX) =''
      
AS      
BEGIN      
 SELECT 1 PromotionId      
 INTO #PromoIds      
      
 DECLARE @LOCAL_startdate DATETIME = @StartDate;      
 DECLARE @LOCAL_enddate DATETIME = @EndDate;      
 DECLARE @TypeId INT = 2;    
 DECLARE @bool INT = 1;
      
 IF (@BCRegionId > 0)      
 BEGIN      
  INSERT INTO #PromoIds      
  EXEC [Playbook].[pGetBCPromotionsByRole] @LOCAL_startdate      
   ,@LOCAL_enddate      
   ,@currentuser      
   ,@BCRegionId      
   ,@VIEW_DRAFT_NA      
   ,@ViewNatProm      
   ,@IsExport      
   ,NULL      
   ,@CurrentPersonaID      
 END      
 ELSE      
 BEGIN
 IF (@TradeMarkId = '' AND @PackageId = '')
 BEGIN      
  INSERT INTO #PromoIds      
  EXEC [Playbook].[pGetPromotionsByRole] @LOCAL_startdate      
   ,@LOCAL_enddate      
   ,@currentuser      
   ,@Branchid      
   ,@VIEW_DRAFT_NA      
   ,@ViewNatProm      
   ,@RolledOutAccounts      
   ,@IsExport      
   ,@CurrentPersonaID      
 END
 ELSE    
  BEGIN     /* Call for Supply chain Calendar */   
   INSERT INTO #PromoIds    
   EXEC [SupplyChain].[pGetMyPromotion] @Branchid    
    ,@TradeMarkId    
    ,@PackageId    
    ,@TypeId    
    ,@bool    
    ,@LOCAL_startdate    
    ,@LOCAL_enddate  
    ,@currentuser    
    ,@CurrentPersonaID     
  END
 END 
      
 IF ISNULL(@PromotionStatus,0) <> 0      
 BEGIN      
  DELETE #PromoIds      
  FROM #PromoIds a      
  JOIN playbook.retailpromotion b ON a.promotionid = b.promotionid      
  WHERE b.PromotionStatusID <> @PromotionStatus      
 END      
      
      
 --IF(@PageType='View')            
 --BEGIN                 
 IF (@FilterType = 'Bottler')      
 BEGIN      
  --Calling separate SP to get bottlers list                
  EXEC [Playbook].[pGetPromotionFilterBotler] @BCRegionID      
 END      
 ELSE IF (@FilterType = 'channel')      
 BEGIN      
  --Calling separate SP to get bottlers list                
  EXEC [Playbook].[pGetPromotionFilterChannel]      
 END      
 ELSE IF (left(@FilterType, 7) = 'account')      
 BEGIN      
  --Calling separate SP to get bottlers list                
  EXEC [Playbook].[pGetPromotionFilterAccount] @FilterType      
 END      
 ELSE IF (@FilterType = 'Brand')      
 BEGIN      
  SELECT ' All Brands' TEXT      
   ,'-1' Value      
        
  UNION ALL      
        
  SELECT ISNULL(b.TradeMarkName, c.BrandName) TEXT      
   ,(       
    STUFF((      
      SELECT DISTINCT ',' + CONVERT(VARCHAR, pb.Promotionid)      
      FROM playbook.PromotionBrand pb      
      JOIN Playbook.RetailPromotion pro ON pro.promotionid = pb.promotionid      
      WHERE ISNULL(BrandID, '') = ISNULL(a.BrandID, '')      
       AND ISNULL(TrademarkID, '') = ISNULL(a.TrademarkID, '')      
       AND pro.PromotionStatusID = CASE       
        WHEN @PromotionStatus IS NULL      
         THEN pro.PromotionStatusID      
        ELSE @PromotionStatus      
        END      
       AND pb.promotionid IN (      
        SELECT PromotionId      
        FROM #PromoIds      
        )      
      FOR XML PATH('')      
      ), 1, 1, '')      
    + ',' + convert(varchar(10), ISNULL(b.TradeMarkID, c.BrandID) * -1) ) Value      
  FROM [Playbook].PromotionBrand a      
  JOIN Playbook.RetailPromotion pro ON pro.promotionid = a.promotionid      
  LEFT JOIN SAP.Trademark b ON a.trademarkid = b.trademarkid      
  LEFT JOIN SAP.Brand c ON a.BrandId = c.BrandId      
  WHERE a.PromotionId IN (      
    SELECT PromotionId      
    FROM #PromoIds      
    )      
         
        
  GROUP BY a.TradeMarkid      
   ,a.BrandId      
   ,b.TrademarkName      
   ,c.brandname      
   ,c.BrandID      
   ,b.TradeMarkID      
  order by 1      
        
 END      
 ELSE IF (@FilterType = 'package')      
 BEGIN      
  SELECT ' All Packages' TEXT      
   ,'-1' Value      
        
  UNION ALL      
        
  SELECT PackageName TEXT      
   ,(  convert(Varchar(50),a.PackageID*-1)+ ','+       
    STUFF((      
      SELECT DISTINCT ',' + CONVERT(VARCHAR, pp.promotionid)      
      FROM playbook.PromotionPackage pp      
      JOIN Playbook.RetailPromotion pro ON pro.promotionid = pp.promotionid      
      WHERE ISNULL(PackageID, '') = ISNULL(a.PackageID, '')      
       AND pro.PromotionStatusID = CASE       
        WHEN @PromotionStatus IS NULL      
         THEN pro.PromotionStatusID      
        ELSE @PromotionStatus      
        END      
       AND pro.promotionid IN (      
        SELECT PromotionId      
        FROM #PromoIds      
        )      
      FOR XML PATH('')      
      ), 1, 1, '')      
    ) Value      
  FROM [Playbook].PromotionPackage a      
  JOIN Playbook.RetailPromotion pro ON pro.promotionid = a.promotionid      
  INNER JOIN SAP.Package _spck ON a.PackageID = _spck.PackageID      
  WHERE a.PromotionId IN (      
    SELECT PromotionId      
    FROM #PromoIds      
    )      
   AND pro.PromotionStatusID = CASE       
    WHEN @PromotionStatus IS NULL      
     THEN pro.PromotionStatusID      
    ELSE @PromotionStatus      
    END      
  GROUP BY a.PackageID      
   ,_spck.PackageName      
  order by 1      
 END      
END      
 --END            
 --ELSE IF(@PageType='Calender')            
 --BEGIN            
 --END 
 
 --go 
 --[Playbook].[pGetPromotionFilter]   
 -- @StartDate  ='10/1/2014 12:00:00 AM'                
 --,@EndDate  ='12/31/2014 12:00:00 AM'                
 --,@currentuser ='tesbm001'                  
 --,@Branchid =140                
 --,@BCRegionId =0        
 --,@VIEW_DRAFT_NA ='False'-- True/False : if the user has the rights to View National Account promotion in draft mode for Promotion Activities                      
 --,@ViewNatProm  ='False'-- True/False :  if the user has the rights to View National Promotion for Promotion Activities                      
 --,@RolledOutAccounts = '' --Comma seperated rolledout account list for NA users, passed form frontend using SER.                      
 --,@IsExport  = 0      
 --,@FilterType ='account|My Accounts'--'brand' package Bottler account               
 --,@PromotionStatus = 4      
 --,@CurrentPersonaID  = 6
 --,@TradeMarkId ='1,3,7,22,29,33,35,49,54'
 --,@PackageId ='22,30,44,46,47,62,63,67,68,77,78,79,94,108,124,129,133,134,138,139,140,143,146,150,151,152,154'

GO
PRINT N'Update complete.'
GO
