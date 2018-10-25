use Portal_data
Go

--[SupplyChain].[pGetCalFilteredPromotionId] @Brand='Dr Pepper,7up',@package='1.75 L Plastic Btl LS 6',@Account='', @Bottler =''      
--[SupplyChain].[pGetCalFilteredPromotionId] @Brand='7up',@package='',@Account='', @Bottler =''  
Print 'Creating Procedure [SupplyChain].[pGetCalFilteredPromotionId]'
GO    
CREATE PROCEDURE [SupplyChain].[pGetCalFilteredPromotionId] @Brand VARCHAR(50) = NULL
	,@Package VARCHAR(50) = NULL
	,@Account VARCHAR(50) = NULL
	,@Channel VARCHAR(50) = NULL
	,@Bottler VARCHAR(50) = NULL
AS
DECLARE @flag INT

SET @flag = 0

SELECT 0 flag
	,- 1 Promotionid
INTO #FilterPromotionID

IF @Channel = 'My Channel'
	OR @Channel = 'All Channel'
	SET @Channel = ''

IF @Account = 'My Account'
	OR @Account = 'All Account'
	SET @Account = ''

IF (isnull(@Brand, '') <> '')
BEGIN
	INSERT INTO #FilterPromotionID
	SELECT 1
		,promotionid
	FROM playbook.promotionbrand
	WHERE brandid IN (
			SELECT brandid
			FROM sap.brand
			WHERE brandname IN (
					SELECT value
					FROM [CDE].[udfSplit](@Brand, ',')
					)
			)
	
	UNION
	
	SELECT 1
		,promotionid
	FROM playbook.promotionbrand
	WHERE trademarkid IN (
			SELECT trademarkid
			FROM sap.trademark
			WHERE TradeMarkName IN (
					SELECT value
					FROM [CDE].[udfSplit](@Brand, ',')
					)
			)

	SET @flag = 1
END

IF (isnull(@Package, '') <> '')
BEGIN
	INSERT INTO #FilterPromotionID
	SELECT 1
		,promotionid
	FROM playbook.promotionpackage
	WHERE packageid IN (
			SELECT packageid
			FROM sap.package
			WHERE packagename IN (
					SELECT value
					FROM [CDE].[udfSplit](@Package, ',')
					)
			)

	SET @flag = @flag + 1
END

IF (isnull(@Account, '') <> '')
BEGIN
	INSERT INTO #FilterPromotionID
	SELECT 1
		,promotionid
	FROM playbook.promotionaccount
	WHERE localchainid IN (
			SELECT localchainid
			FROM sap.localchain
			WHERE localchainname IN (
					SELECT value
					FROM [CDE].[udfSplit](@Account, ',')
					)
			)
	
	UNION
	
	SELECT 1
		,promotionid
	FROM playbook.promotionaccount
	WHERE regionalchainid IN (
			SELECT regionalchainid
			FROM sap.regionalchain
			WHERE regionalchainname IN (
					SELECT value
					FROM [CDE].[udfSplit](@Account, ',')
					)
			)
	
	UNION
	
	SELECT 1
		,promotionid
	FROM playbook.promotionaccount
	WHERE nationalchainid IN (
			SELECT nationalchainid
			FROM sap.nationalchain
			WHERE nationalchainname IN (
					SELECT value
					FROM [CDE].[udfSplit](@Account, ',')
					)
			)

	SET @flag = @flag + 1
END

IF (isnull(@Channel, '') <> '')
BEGIN
	INSERT INTO #FilterPromotionID
	SELECT 1
		,promotionid
	FROM playbook.promotionchannel
	WHERE channelid IN (
			SELECT channelid
			FROM sap.channel
			WHERE ChannelName IN (
					SELECT value
					FROM [CDE].[udfSplit](@Channel, ',')
					)
			)
	
	UNION
	
	SELECT 1
		,promotionid
	FROM playbook.promotionchannel
	WHERE superchannelid IN (
			SELECT SuperChannelID
			FROM sap.SuperChannel
			WHERE SuperChannelName IN (
					SELECT value
					FROM [CDE].[udfSplit](@Channel, ',')
					)
			)

	SET @flag = @flag + 1
END

IF (isnull(@Bottler, '') <> '')
BEGIN
	DECLARE @BottlerID INT

	SELECT @BottlerID = bottlerid
	FROM bc.bottler
	WHERE bottlername = @Bottler

	SELECT *
	INTO #BottlerChain
	FROM bc.tBottlerChainTradeMark
	WHERE bottlerid = @BottlerID

	INSERT INTO #FilterPromotionID
	SELECT DISTINCT 1
		,a.promotionid
	FROM Playbook.RetailPromotion a
	LEFT JOIN Playbook.PromotionAccountHier b ON a.promotionid = b.promotionid
	LEFT JOIN Playbook.promotiongeohier c ON c.promotionid = a.promotionid
	LEFT JOIN playbook.PromotionBrand d ON d.promotionid = a.promotionid
	LEFT JOIN sap.brand brnd ON brnd.BrandID = d.BrandID --JOIN #BottlerChain tc ON tc.bottlerid = c.bottlerid    
	--AND tc.trademarkid = case when isnull(d.trademarkid,0) = 0  then brnd.Trademarkid else d.trademarkid end    
	--AND tc.localchainid = b.localchainid    
	WHERE c.BottlerID = @BottlerID

	SET @flag = @flag + 1
END --select * from #FilterPromotionID    

DECLARE @retval VARCHAR(MAX)

SET @retval = (
		SELECT DISTINCT Convert(VARCHAR(20), Promotionid) + ','
		FROM #FilterPromotionID
		WHERE promotionid <> - 1
		GROUP BY promotionid
		HAVING sum(flag) = @flag
		FOR XML path('')
		)

SELECT @retval
GO
Print 'Creating Procedure SupplyChain.pGetMyPromotion'
GO     
CREATE PROCEDURE SupplyChain.pGetMyPromotion (        
  @LocationId VARCHAR(MAX)     
 ,@TradeMarkId VARCHAR(MAX)      
 ,@PackageId VARCHAR(MAX)      
 ,@TypeId VARCHAR(MAX)      
 ,@bool int = NULL     
 ,@StartDate DATETIME = NULL --= '12/1/2014 12:00:00 AM'--NULL --'11/1/2014 12:00:00 AM' --NULL --'10/1/2014 12:00:00 AM'          
 ,@EndDate DATETIME =NULL --'12/31/2014 12:00:00 AM'--NULL --'11/15/2014 12:00:00 AM' --NULL --'12/31/2014 12:00:00 AM'          
 ,@GSN VARCHAR(20)     
 ,@PersonaID int     
 )        
AS        
BEGIN        
 BEGIN TRY        
  DECLARE @LastweekStartDate DATE        
   ,@LastweekEndDate DATE        
   ,@NextweekStartDate DATE        
   ,@NextweekEndDate DATE        
   ,@ClosedLastweek INT        
   ,@Ongoing INT        
   ,@StartingNextWeek INT        
   ,@SubQuery VARCHAR(max) = ''        
   ,@Query VARCHAR(max) = ''        
   ,@IsMyAccountQuery VARCHAR(max) = '';        
        
  CREATE TABLE #Durationtemp (        
   LastweekStartDate DATETIME        
   ,LastweekEndDate DATETIME        
   ,NextweekStartDate DATETIME        
   ,NextweekEndDate DATETIME        
   ,CurrentWeekStart DATETIME        
   ,CurrentWeekEnd DATETIME        
   );        
        
  CREATE TABLE #Counttemp (RecordCount INT);        
        
  CREATE TABLE #PromotionIDtemp (PromotionID INT);        
        
  -----------Last Week Date and Next Week Date Set-------------------                          
  INSERT INTO #Durationtemp (        
   LastweekStartDate        
   ,LastweekEndDate        
   ,NextweekStartDate        
   ,NextweekEndDate        
   ,CurrentWeekStart        
   ,CurrentWeekEnd        
   )        
  SELECT Dateadd(dd, - (Datepart(dw, getdate())) - 5, getdate()) [LastweekStartDate]        
   ,Dateadd(dd, - (Datepart(dw, getdate())) + 1, getdate()) [LastweekEndDate]        
   ,Dateadd(dd, (9 - Datepart(dw, getdate())), getdate()) [NextweekStartDate]        
   ,Dateadd(dd, 15 - (Datepart(dw, getdate())), getdate()) [NextweekEndDate]        
   ,DATEADD(DAY, 1 - DATEPART(WEEKDAY, GETDATE()), CAST(GETDATE() AS DATE)) [CurrentWeekStart]        
   ,DATEADD(DAY, 7 - DATEPART(WEEKDAY, GETDATE()), CAST(GETDATE() AS DATE)) [CurrentWeekEnd];        
        
  -- For Is My Account    
               
  DECLARE @SPUserPRofileID INT                            
  SELECT @SPUserPRofileID = SPUserprofileid                            
  FROM Person.SPUserPRofile                            
  WHERE GSn = @GSN AND personaid = @PersonaID                           
  SELECT DISTINCT b.LocalChainID                            
   ,b.RegionalChainID                            
   ,b.NationalChainID                            
  INTO #UserAccount                            
  FROM Person.UserAccount a                            
  LEFT JOIN mview.ChainHier b ON (                            
    a.LocalChainID = b.LocalChainID                            
    OR a.RegionalChainID = b.RegionalChainID                            
    OR a.NationalChainID = b.NationalChainID                            
    )                            
  WHERE a.SPUserPRofileID = @SPUserPRofileID     
                
  ----------------------------------------------------------------------------                          
  ---------Query Prepare regarding LocationID,TradeMarkID,PackageID--------                 
  IF (ISNULL(@bool, 0) <> 0)        
  BEGIN        
   -- Promotion IDs --                
   DECLARE @LOCAL_startdate DATETIME;        
   DECLARE @LOCAL_enddate DATETIME;        
        
   SET @LOCAL_startdate = @StartDate;        
   SET @LOCAL_enddate = @EndDate;        
        
   INSERT INTO #PromotionIDtemp (PromotionID)        
   SELECT DISTINCT Rprmtn.PromotionID        
   FROM Playbook.Retailpromotion Rprmtn        
   JOIN Playbook.Promotionbrand Pbrand ON Rprmtn.PromotionID = Pbrand.PromotionID        
   JOIN Playbook.promotionPackage Ppackage ON Rprmtn.PromotionID = Ppackage.PromotionID        
   JOIN Playbook.PromotionGeoRelevancy PromGeo ON Rprmtn.PromotionID = PromGeo.PromotionID        
   JOIN mview.LocationHier mviewLoc ON PromGeo.RegionID = mviewLoc.RegionId        
    OR PromGeo.BranchId = mviewLoc.BranchId        
    OR PromGeo.BUID = mviewLoc.BUID        
    OR PromGeo.AreaId = mviewLoc.AreaId        
   WHERE mviewLoc.BranchId = @LocationId        
    AND Pbrand.TrademarkID IN (        
     SELECT value        
     FROM [CDE].[udfSplit](@TradeMarkId, ',')        
     )        
    AND Ppackage.PackageID IN (        
     SELECT value        
     FROM [CDE].[udfSplit](@PackageId, ',')        
     )    
    AND Rprmtn.PromotionStatusID = 4        
    AND (    
      --@LOCAL_startdate BETWEEN Rprmtn.PromotionStartDate AND Rprmtn.PromotionEndDate      
      --OR Rprmtn.PromotionRelevantStartdate BETWEEN @LOCAL_startdate AND @LOCAL_enddate      
      --OR Rprmtn.PromotionRelevantEnddate BETWEEN @LOCAL_startdate AND @LOCAL_enddate         
     Convert(Date,Rprmtn.PromotionStartDate) <= Convert(Date,@LOCAL_enddate)--@LOCAL_enddate /*Quater End Date   PromotionStartDate  */    
     AND Convert(Date,Rprmtn.PromotionEndDate) >= Convert(Date,@LOCAL_startdate )--@LOCAL_startdate /*Quater Start Date  PromotionEndDate */        
     )        
    --IsMyAccount            
    AND (Rprmtn.PromotionGroupID = 1             
    AND 1 = CASE             
      WHEN (SELECT TOP 1 1                   
          FROM PlayBook.PromotionAccountHier AS account                            
          WHERE account.PromotionID = Rprmtn.PromotionID                            
          and account.LocalChainID IN (SELECT uAccount.LocalChainID FROM #UserAccount uAccount)) =1 THEN 1                            
          ELSE 0            
      END             
   )    
                            
   SELECT PromotionID        
   FROM #PromotionIDtemp        
  END        
  ELSE        
   -- Promotion Count --            
  BEGIN        
   SET @IsMyAccountQuery = 'AND (Rprmtn.PromotionGroupID = 1 AND 1 = CASE WHEN (SELECT TOP 1 1 FROM PlayBook.PromotionAccountHier AS account WHERE account.PromotionID = Rprmtn.PromotionID and account.LocalChainID IN (SELECT uAccount.LocalChainID FROM #UserAccount uAccount)) =1 THEN 1 ELSE 0 END )'        
        
   IF (Isnull(@LocationId, '') != '0')        
   BEGIN        
    IF (Isnull(@TypeId, '') != '0')        
    BEGIN        
     IF (@TypeId = 1)        
     BEGIN        
      SET @SubQuery += ' and mviewLoc.RegionId IN (SELECT value FROM [CDE].[udfSplit](''' + @LocationId + ''','',''))';        
     END        
     ELSE IF (@TypeId = 2)        
     BEGIN        
      SET @SubQuery += ' and mviewLoc.BranchId IN (SELECT value FROM [CDE].[udfSplit](''' + @LocationId + ''','',''))';        
     END        
    END        
   END        
        
   IF (ISNULL(@TradeMarkId, '') != '0')        
   BEGIN        
    --SET @SubQuery += ' and Pbrand.TrademarkID=' + Convert(VARCHAR(100), @TradeMarkId) + ' ';                      
    SET @SubQuery += ' and Pbrand.TrademarkID IN (SELECT value FROM [CDE].[udfSplit](''' + @TradeMarkId + ''','',''))';        
   END        
        
   IF (ISNULL(@PackageId, '') != '0')        
   BEGIN        
    SET @SubQuery += ' and Ppackage.PackageID IN (SELECT value FROM [CDE].[udfSplit](''' + @PackageId + ''','',''))';        
   END        
        
   SET @Query = ' Select Count(distinct Rprmtn.PromotionID)  from Playbook.Retailpromotion Rprmtn join Playbook.Promotionbrand Pbrand  on Rprmtn.PromotionID=Pbrand.PromotionID  join Playbook.promotionPackage Ppackage on Rprmtn.PromotionID=Ppackage.PromotionID         
   join Playbook.PromotionGeoRelevancy PromGeo on Rprmtn.PromotionID= PromGeo.PromotionID JOIN mview.LocationHier mviewLoc ON PromGeo.RegionID=mviewLoc.RegionId OR PromGeo.BranchId=mviewLoc.BranchId OR PromGeo.BUID=mviewLoc.BUID OR PromGeo.AreaId=mviewLoc.AreaId          
   Where Convert(Date,Rprmtn.PromotionEndDate)>=Convert(Date,(Select Top 1 LastweekStartDate from #Durationtemp )) and Convert(Date,Rprmtn.PromotionEndDate)<=Convert(Date,(Select Top 1 LastweekEndDate from #Durationtemp )) and Rprmtn.PromotionStatusID =4'+ @SubQuery + '' + @IsMyAccountQuery + ' ';                      
        
   DELETE        
   FROM #Counttemp        
        
   PRINT @Query;        
        
   INSERT INTO #Counttemp (RecordCount)        
   EXEC (@Query);        
        
   SELECT @ClosedLastweek = RecordCount        
   FROM #Counttemp;        
        
   SET @Query = ' Select Count(distinct Rprmtn.PromotionID)  from Playbook.Retailpromotion Rprmtn join Playbook.Promotionbrand Pbrand on Rprmtn.PromotionID=Pbrand.PromotionID join Playbook.promotionPackage Ppackage on Rprmtn.PromotionID=Ppackage.PromotionID      
   join Playbook.PromotionGeoRelevancy PromGeo on Rprmtn.PromotionID= PromGeo.PromotionID JOIN mview.LocationHier mviewLoc ON PromGeo.RegionID=mviewLoc.RegionId OR PromGeo.BranchId=mviewLoc.BranchId OR PromGeo.BUID=mviewLoc.BUID OR PromGeo.AreaId=mviewLoc.AreaId      
  Where Convert(Date,Rprmtn.PromotionEndDate)>=Convert(Date,(Select Top 1 CurrentWeekStart from #Durationtemp )) and Convert(Date,Rprmtn.PromotionStartDate)<= Convert(Date,(Select Top 1 CurrentWeekEnd from #Durationtemp)) and Rprmtn.PromotionStatusID =4'+ @SubQuery + '' + @IsMyAccountQuery + ' ';            
        
   DELETE        
   FROM #Counttemp        
        
   PRINT @Query;        
        
   INSERT INTO #Counttemp (RecordCount)        
   EXEC (@Query);        
        
   SELECT @Ongoing = RecordCount        
   FROM #Counttemp;        
        
   SET @Query = ' Select Count(distinct Rprmtn.PromotionID)  from Playbook.Retailpromotion Rprmtn join Playbook.Promotionbrand Pbrand  on Rprmtn.PromotionID=Pbrand.PromotionID  join Playbook.promotionPackage Ppackage on Rprmtn.PromotionID=Ppackage.PromotionID join                     
    Playbook.PromotionGeoRelevancy PromGeo on Rprmtn.PromotionID= PromGeo.PromotionID JOIN mview.LocationHier mviewLoc ON PromGeo.RegionID=mviewLoc.RegionId OR PromGeo.BranchId=mviewLoc.BranchId OR PromGeo.BUID=mviewLoc.BUID OR PromGeo.AreaId=mviewLoc.AreaId     
    Where Convert(Date,Rprmtn.PromotionStartDate)>=Convert(Date,(Select Top 1 NextweekStartDate from #Durationtemp )) and Convert(Date,Rprmtn.PromotionStartDate)<=Convert(Date,(Select Top 1 NextweekEndDate from #Durationtemp )) and Rprmtn.PromotionStatusID= 4' + @SubQuery + '' + @IsMyAccountQuery + ' ';            
        
   DELETE        
   FROM #Counttemp;        
        
   PRINT @Query;        
        
   INSERT INTO #Counttemp (RecordCount)        
   EXEC (@Query);        
        
   SELECT @StartingNextWeek = RecordCount        
   FROM #Counttemp;        
        
   SELECT @ClosedLastweek [ClosedLastWeekValue]        
    ,@Ongoing [OngoingValue]        
    ,@StartingNextWeek [StartingNextWeekValue]        
  END        
 END TRY        
        
 BEGIN CATCH        
  SELECT Error_Message() [Error Message];        
 END CATCH        
END     
GO


Print 'Creating Procedure SupplyChain.GetProductLineWithTradeMark'     
GO
CREATE PROC SupplyChain.GetProductLineWithTradeMark @BranchIds VARCHAR(5000)
AS
BEGIN
	DECLARE @query AS NVARCHAR(max)

	SET NOCOUNT ON;
	SET @query = 'SELECT ProductLineID,ProductLineName,TradeMarkID,SAPTradeMarkID,TradeMarkName    

               FROM [MView].[BranchProductLine] where BranchID IN (' + @BranchIds + ') ORDER BY 1'

	EXECUTE sp_executesql @query
END
GO
Print 'Creating Procedure [Playbook].[GetAccountsForLocationSupplyChain]'     
GO
  
CREATE PROCEDURE [Playbook].[GetAccountsForLocationSupplyChain] @BranchIds VARCHAR(5000)  
AS  
BEGIN  
 DECLARE @query AS NVARCHAR(max)  
  
 SET NOCOUNT ON;  
  
 IF (@branchIds <> '0')  
 BEGIN  
  SET @query = 'SELECT a.[BranchID] AS BranchID, a.[BU] AS BU, a.[BUID] AS BUID, a.[BranchName] AS BranchName, a.[LocalChainID] AS LocalChainID, a.[LocalChainName] AS LocalChainName,                    
       a.[NationalChainID] AS NationalChainID, a.[NationalChainName] AS NationalChainName, a.[Region] AS Region, a.[RegionID] AS RegionID, a.[RegionalChainID] AS RegionalChainID, a.[RegionalChainName] AS RegionalChainName, a.[SAPLocalChainID] AS SAPLocalChainID, a.[SAPNationalChainID] AS SAPNationalChainID, a.[SAPRegionalChainID] AS SAPRegionalChainID FROM [MView].[LocationChain] a WHERE a.[RegionalChainName] <> ''All Other'' and a.branchid in (' + @branchIds + ')ORDER BY 1'  
  EXECUTE sp_executesql @query  
 END  
 ELSE  
 BEGIN  
  SELECT 0 AS BranchID  
   ,'' AS BU  
   ,0 AS BUID  
   ,'' AS BranchName  
   ,a.[LocalChainID] AS LocalChainID  
   ,a.[LocalChainName] AS LocalChainName  
   ,a.[NationalChainID] AS NationalChainID  
   ,a.[NationalChainName] AS NationalChainName  
   ,'' AS Region  
   ,0 AS RegionID  
   ,a.[RegionalChainID] AS RegionalChainID  
   ,a.[RegionalChainName] AS RegionalChainName  
   ,a.[SAPLocalChainID] AS SAPLocalChainID  
   ,a.[SAPNationalChainID] AS SAPNationalChainID  
   ,a.[SAPRegionalChainID] AS SAPRegionalChainID  
  FROM [MView].ChainHier a  
  WHERE a.[RegionalChainName] <> 'All Other'  
  ORDER BY 1  
 END  
END


Print 'Creating Procedure [SupplyChain].[GetManuFacturingMeasures]...'
GO
/****** Object:  StoredProcedure [SupplyChain].[GetManuFacturingMeasures]    Script Date: 11/13/2014 5:49:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
/*    
    
[SupplyChain].[GetManuFacturingMeasures] '2014-11-17','13, 15, 19, 20, 17, 16'  
    
  select * from 'Supplychain.plant'  
    
*/    
Create PROC [SupplyChain].[GetManuFacturingMeasures](@Date as SmallDateTime, @PlantID varchar(500))    
AS    
BEGIN    
     
Declare @SupplyChainManufacutringTME Table    
 (    
  AnchorDateID int not null,    
  PlantID int not null,    
  PlantName varchar(10) not null,    
  PlantDesc varchar(50) not null,    
  SAPPlantNumber varchar(50) null,    
  Latitude varchar(100),  
  Longitude Varchar(100),  
  IsMyPlant Bit null,    
  TMEMTD decimal(21,1)  null,    
  TMEMTDPY decimal(21,1) null,  
   TMETotal decimal(5,1) null,
  TMETotalPY decimal(5,1) null,
   TMEFavUnFav decimal(10,1) null,   
   TMERank int null,  
  AFCOMTD decimal(5,1) null,    
  AFCOMTDPY decimal(5,1) null,
  AFCOTotal decimal (18,1) null,
  AFCOTotalPY decimal (18,1) null, 
   AFCOFAVUnFAV decimal(10,1) null,  
   AFCOFAVUnFAVPercent decimal(5,1) null,  
    AFCORank int null,  
  RecordableMTD int,    
  RecordableMTDPY int,    
   RecordableTotal int null,  
  RecordableTotalPY int null,
  RecordableFavUnFav decimal(10,1) null, 
  RecordableRank int null,  
  InventoryCasesMTD int,    
  InventoryCasesMTDPY int,  
  InventoryCasesTotal decimal(18,1) null,  
  InventoryCasesTotalPY decimal(18,1) null, 
  InvCasesFavUnFav int null,
  InvCasesFavUnFavPercent decimal(10,4) null,
  InventoryCasesRank int null
 )  
 
 Declare @SelectedPlantIDs Table
		(
			PlantID int
		)
Insert into @SelectedPlantIDs
Select Value from dbo.Split(@PlantID,',')  

 Declare @AnchorDate Int  
 Declare @AnchorDatePrev int  
 Set @AnchorDate = [SupplyChain].[udfConvertToDateID](@Date)  
 Set @AnchorDatePrev = [SupplyChain].[udfConvertToDateID](DATEADD(YY,-1,@Date))  
 Insert into @SupplyChainManufacutringTME(AnchorDateID,PlantID,PlantName,PlantDesc,SAPPlantNumber,Latitude,Longitude, TMEMTD, TMEMTDPY, AFCOMTD, AFCOMTDPY,RecordableMTD, RecordableMTDPY,InventoryCasesMTD, InventoryCasesMTDPY, IsMyPlant)  
  Select @AnchorDate, p.PlantID, PlantName,PlantDesc,SAPPlantNumber,Latitude  ,Logitude  
    ,(Select TME * 100 from SupplyChain.tPlantKPI Where AnchorDateID=@AnchorDate And AggregationID = 3 And PlantID=p.PlantID)  
    ,(Select TME * 100 from SupplyChain.tPlantKPI Where AnchorDateID=@AnchorDatePrev And AggregationID = 3 And PlantID=p.PlantID)  
    ,(Select AvgFlavorCODuration from SupplyChain.tPlantKPI Where AnchorDateID=@AnchorDate And AggregationID = 3 And PlantID=p.PlantID)  
    ,(Select AvgFlavorCODuration from SupplyChain.tPlantKPI Where AnchorDateID=@AnchorDatePrev And AggregationID = 3 And PlantID=p.PlantID)  
    ,(Select [RecordableMDT] from [SupplyChain].[tManufacturingMeasures_ToBeDeleted] as tmD where tmd.plantID = p.PlantID)  
    ,(Select [RecordableMDTPY] from [SupplyChain].[tManufacturingMeasures_ToBeDeleted] as tmD where tmd.plantID = p.PlantID)  
    ,(Select SUM(Isnull(EndingInventory,0))  from SAP.BP7PlantInventory Where SAPPlantNumber = p.SAPPlantNumber And CalendarDate=@AnchorDate And EndingInventory > 0 Group by SAPPlantNumber)  
    ,(Select SUM(Isnull(EndingInventory,0)) from SAP.BP7PlantInventory Where SAPPlantNumber = p.SAPPlantNumber And CalendarDate=@AnchorDatePrev And EndingInventory > 0 Group by SAPPlantNumber)
	,Case When myPlant.PlantID is not null Then 1 Else null end  
    from SupplyChain.Plant p  Left Outer Join @SelectedPlantIDs as myPlant on p.PlantID = myPlant.PlantID
--  
Declare @TMETotal decimal(5,3)  
Declare @TMETotalPY decimal(5,3)
Declare @AFCOTotal decimal(18,1)  
Declare @AFCOTotalPY decimal(18,1)  
Select  @TMETotal = (Select Convert(decimal(5,3), Case When SUM(isnull(SumCapacityQty,0)) > 0 And SUM(isnull(SumDuration,0)) > 0 Then SUM(isnull(SumCODuration,0))/SUM(isnull(SumDuration,0)) + SUM(isnull(SumActualQty,0))/SUM(isnull(SumCapacityQty ,0))  
    When SUM(isnull(SumCapacityQty,0)) > 0 Then SUM(isnull(SumActualQty,0))/SUM(isnull(SumCapacityQty,0))   
    When SUM(isnull(SumDuration,0)) > 0 Then SUM(isnull(SumCODuration,0))/SUM(isnull(SumDuration,0))    
    Else Null   
    End)  
 from  @SelectedPlantIDs as  myPlant   
 join SupplyChain.tPlantKPI as p on p.PlantID = myPlant.PlantID And p.AggregationID = 3 And p.AnchorDateID = @AnchorDate)  

 ----Previous Year Plant TME Total
Select  @TMETotalPY = (Select Convert(decimal(5,3), Case When SUM(isnull(SumCapacityQty,0)) > 0 And SUM(isnull(SumDuration,0)) > 0 Then SUM(isnull(SumCODuration,0))/SUM(isnull(SumDuration,0)) + SUM(isnull(SumActualQty,0))/SUM(isnull(SumCapacityQty ,0))  
    When SUM(isnull(SumCapacityQty,0)) > 0 Then SUM(isnull(SumActualQty,0))/SUM(isnull(SumCapacityQty,0))   
    When SUM(isnull(SumDuration,0)) > 0 Then SUM(isnull(SumCODuration,0))/SUM(isnull(SumDuration,0))    
    Else Null   
    End)  
 from  @SelectedPlantIDs as  myPlant   
 join SupplyChain.tPlantKPI as p on p.PlantID = myPlant.PlantID And p.AggregationID = 3 And p.AnchorDateID = @AnchorDatePrev)  
 
 --Select @TMETotal  
Declare @TotalFlavor Decimal(18,1)  
Declare @Total Decimal(18,1)  

Declare @TotalFlavorPY Decimal(18,1)  
Declare @TotalPY Decimal(18,1)  
  
Select @TotalFlavor  = Sum(SumFlavorCODuration), @Total = Sum(SumActualQty)  
From SupplyChain.tPlantKPI pk  
Join @SelectedPlantIDs v on pk.PlantID = v.PlantID  
Where AnchorDateID = @AnchorDate And AggregationID = 3  

Select @TotalFlavorPY  = Sum(SumFlavorCODuration), @TotalPY = Sum(SumActualQty)  
From SupplyChain.tPlantKPI pk  
Join @SelectedPlantIDs v on pk.PlantID = v.PlantID  
Where AnchorDateID = @AnchorDatePrev And AggregationID = 3  
  
Select @AFCOTotal =( Select Case When Isnull(@Total, 0) = 0 Then Null Else Sum(AFCO) End AFCO  
From  
(  Select lk.AnchorDateID, lk.AggregationID,   
  Case When @TotalFlavor > 0 And lk.CountFlavorCO > 0 Then lk.SumFlavorCODuration/@TotalFlavor*lk.SumFlavorCODuration/lk.CountFlavorCO  
    Else 0 End AFCO  
  From SupplyChain.tLineKPI lk  
  Join SupplyChain.Line l on lk.LineID = l.LineID  
  Join @SelectedPlantIDs myPlant on l.PlantID = myPlant.PlantID  
  Where lk.AggregationID = 3 And lk.AnchorDateID = @AnchorDate  
) temp  
Group By  AnchorDateID, AggregationID)  
  
Select @AFCOTotalPY =( Select Case When Isnull(@TotalPY, 0) = 0 Then Null Else Sum(AFCO) End AFCO  
From  
(  Select lk.AnchorDateID, lk.AggregationID,   
  Case When @TotalFlavorPY > 0 And lk.CountFlavorCO > 0 Then lk.SumFlavorCODuration/@TotalFlavorPY*lk.SumFlavorCODuration/lk.CountFlavorCO  
    Else 0 End AFCO  
  From SupplyChain.tLineKPI lk  
  Join SupplyChain.Line l on lk.LineID = l.LineID  
  Join @SelectedPlantIDs myPlant on l.PlantID = myPlant.PlantID  
  Where lk.AggregationID = 3 And lk.AnchorDateID = @AnchorDatePrev  
) temp  
Group By  AnchorDateID, AggregationID)  
  
Update m  
Set TMETotal = @TMETotal * 100  
	,TMETotalPY = @TMETotalPY * 100
	,AFCOTotal = @AFCOTotal
	,AFCOTotalPY = @AFCOTotalPY  
	,InventoryCasesTotal = (Select SUM(Isnull(EndingInventory,0)/1000) from SAP.BP7PlantInventory Where SAPPlantNumber in (Select SAPPlantNumber from SupplyChain.Plant Where PlantID in (Select PlantID from @SelectedPlantIDs)) And CalendarDate=@AnchorDate)
	,InventoryCasesTotalPY = (Select SUM(Isnull(EndingInventory,0)/1000) from SAP.BP7PlantInventory Where SAPPlantNumber in (Select SAPPlantNumber from SupplyChain.Plant Where PlantID in (Select PlantID from @SelectedPlantIDs)) And CalendarDate=@AnchorDatePrev)  
	,RecordableTotal = (Select SUM(RecordableMDT) from [SupplyChain].[tManufacturingMeasures_ToBeDeleted] Where PlantID in (Select PlantID from @SelectedPlantIDs))  
	,RecordableTotalPY = (Select SUM(RecordableMDT) from [SupplyChain].[tManufacturingMeasures_ToBeDeleted] Where PlantID in (Select PlantID from @SelectedPlantIDs))  
	,TMEFavUnFav = (TMEMTD-TMEMTDPY)  
	,AFCOFAVUnFAVPercent = (CONVERT(DECIMAL(9,2),((AFCOMTD - AFCOMTDPY)/nullif(AFCOMTDPY,0)) * 100))  
	,AFCOFAVUnFAV = (CONVERT(DECIMAL(9,2),((AFCOMTD - AFCOMTDPY))))
	,RecordableFavUnFav=(RecordableMTD - RecordableMTDPY)  
	,InvCasesFavUnFav=(InventoryCasesMTD - InventoryCasesMTDPY)
,InvCasesFavUnFavPercent=(((InventoryCasesMTD - InventoryCasesMTDPY)*1.0/nullif(InventoryCasesMTDPY,0))* 100)
from @SupplyChainManufacutringTME as m  
  
 -- ,  
 --AFCORank = temp.AFCORank,  
 --RecordableRank = temp.RecordableRank,  
 --InventoryCasesRank = temp.InvCaseRank, 
--TME Rank
Update m  
set TMERank=temp.TMERank
from @SupplyChainManufacutringTME as m Inner Join   
(Select myPlant.PlantID, Rank() Over (ORDER BY  TMEFavUnFav Desc) as  TMERank
 --Rank() Over (ORDER BY InvCasesFavUnFav Asc) as InvCaseRank  
from @SupplyChainManufacutringTME as m inner join @SelectedPlantIDs myPlant on m.PlantID = myPlant.PlantID  
Where Longitude is not null And Latitude is not null And TMEFavUnFav is not null)temp on m.PlantID = temp.PlantID  

--AFCO Rank
Update m  
Set AFCORank = temp.AFCORank
from @SupplyChainManufacutringTME as m Inner Join   
(Select myPlant.PlantID, Rank() Over (ORDER BY  AFCOFAVUnFAV Asc) as  AFCORank
 --Rank() Over (ORDER BY InvCasesFavUnFav Asc) as InvCaseRank  
from @SupplyChainManufacutringTME as m inner join @SelectedPlantIDs myPlant on m.PlantID = myPlant.PlantID  
Where Longitude is not null And Latitude is not null And AFCOFAVUnFAV is not null)temp on m.PlantID = temp.PlantID
  
--Recordables Rank
Update m  
Set RecordableRank = temp.RecordableRank
from @SupplyChainManufacutringTME as m Inner Join   
(Select myPlant.PlantID, Rank() Over (ORDER BY RecordableFavUnFav Asc) as RecordableRank
 --Rank() Over (ORDER BY InvCasesFavUnFav Asc) as InvCaseRank  
from @SupplyChainManufacutringTME as m inner join @SelectedPlantIDs myPlant on m.PlantID = myPlant.PlantID  
Where Longitude is not null And Latitude is not null And RecordableFavUnFav is not null)temp on m.PlantID = temp.PlantID


--Inventory Rank
Update m  
Set InventoryCasesRank = temp.InventoryCasesRank
from @SupplyChainManufacutringTME as m Inner Join   
(Select myPlant.PlantID, Rank() Over (ORDER BY InvCasesFavUnFavPercent Asc) as  InventoryCasesRank
from @SupplyChainManufacutringTME as m inner join @SelectedPlantIDs myPlant on m.PlantID = myPlant.PlantID  
Where Longitude is not null And Latitude is not null And InvCasesFavUnFav is not null)temp on m.PlantID = temp.PlantID


---My Plants


Select *
--, 1 [HardValue_TMEPlan],1 [HardValue_TMEFU],1 [HardValue_2012],1 [HardValue_PacevsPY],
--  1 [HardValue_AFCOThreshold],1  [HardValue_AFCOFU],1  [HardValue_InvCasesYesterday],
--  1 [HardValue_InvCasesAvCM],1  [HardValue_InvCaseAvCY],1  [HardValue_InvCasePYsameMonth]
from @SupplyChainManufacutringTME Where Longitude is not null And Latitude is not null 
--And PlantID in (17,18,19,20,21)
     
END    
  
GO


Print 'Creating Procedure [SupplyChain].[pGetDsdInventoryBranchMeasuresForLanding] ...'
GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdInventoryBranchMeasuresForLanding]    Script Date: 11/19/2014 1:23:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/* Test Bench
exec [SupplyChain].[pGetDsdInventoryBranchMeasuresForLanding] 20141014,'118,8,11,12,13,14,15,18,19,21,25,29,33,35,36,37,42,44,47,48,50,52,53,54,58','69,192,138,29,232,221,75,158,195,3,12,35,129,49,190,184,64,101', '46,69,138,152,118,78,129,86,64,44,150,47,70,30,124,133,61,36','MinMax'
exec [SupplyChain].[pGetDsdInventoryBranchMeasuresForLanding] 20141106,'1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,167,168,169,170,172,173,174', '1,3,5,20,22,33,59,35,37,60,44,61,46,49,50,51,65,67,68,34,64,89,173,54,97,129,130,154,187,216,228','22,27,30,33,38,39,44,46,47,51,59,62,63,64,67,68,77,78,79,86,90,94,108,117,124,129,133,134,138,139,140,143,145,146,150,151,152,154','MinMax'

	24.SupplyChain.pGetDsdInventoryBranchMeasuresForLanding.sql

*/

CREATE Proc [SupplyChain].[pGetDsdInventoryBranchMeasuresForLanding]
(
	@DateID int,
	@BranchIDs varchar(4000),
	@TrademarkIDs varchar(4000),
	@PackageTypeIDs varchar(4000),
	@MeasureType varchar(10),
	@AggregationID int = 0
)
AS	
	Set NoCount On;
	
	Declare @SupplyChainDsdInventoryMeasuresByBranch Table  
			 (  
			   BranchID int not null
			  ,BranchName varchar(50) not null
			  ,Longitude varchar(20) null
			  ,Latitude varchar(20) null
			  ,CaseCut int  null
			  ,OOS Decimal(10,1) null
			  ,OOSDiff Decimal(10,1) null
			  ,DaysOfSupply Decimal(10,1) null
			  ,DaysOfSupplyDiff Decimal(10,1) null
			  ,DaysOfSupplyEndingInventory Decimal(10,1) null
			  ,MinMaxMiddle Decimal(10,1) null
			  ,MinMaxMiddleDiff Decimal(10,2) null
			  ,MinMaxLeftAbs int null
			  ,MinMaxMiddleAbs int null
			  ,MinMaxRightAbs int null
			  ,OOSRed Decimal(10,1) null
			  ,OOSGreen Decimal(10,1) null
			  ,DOSRed Decimal(10,1) null
			  ,DOSGreen Decimal(10,1) null
			  ,MinMaxRed Decimal(10,1) null
			  ,MinMaxGreen Decimal(10,1) null
			  ,KPILevel varchar(10) null
			 )

Declare @SelectedBranchIDs Table
		(
			BranchID int
		)

Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)

Declare @SelectedPackageTypeIDs Table
		(
			PackageTypeID int
		)

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')

Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')


Insert into @SelectedPackageTypeIDs
Select Value from dbo.Split(@PackageTypeIDs,',')

	Insert into @SupplyChainDsdInventoryMeasuresByBranch (BranchID,BranchName, Longitude, Latitude, OOSRed, OOSGreen, DOSRed, DOSGreen, MinMaxRed, MinMaxGreen) 
			Select b.BranchID, b.BranchName, b.Longitude, b.Latitude, bt.BranchOOSLeftThreshold, bt.BranchOOSRightThreshold, bt.BranchDOSLeftThreshold, bt.BranchDOSRightThreshold, bt.BranchMinMaxLeftThreshold, bt.BranchMinMaxRightThreshold
			from SAP.Branch as b 
			Inner Join SupplyChain.vBranchThreshold as bt on b.BranchID = bt.BranchID 
			Where bt.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)

	If(@MeasureType = 'OOS') 
		Begin
			Update mb
			Set mb.OOS = OOSTemp.OOS,
			mb.CaseCut = OOSTemp.CaseCut,
			mb.OOSDiff = (OOSTemp.OOS - mb.OOSGreen),  --- This will negative values for the Green Branches. So we can ignore if the difference is less than 0
			mb.KPILevel = Case 
							When OOSTemp.OOS > mb.OOSRed Then 'Red' 
							When (OOSTemp.OOS >= mb.OOSGreen And OOSTemp.OOS <= mb.OOSRed) Then 'Amber' 
							When OOSTemp.OOS < mb.OOSGreen Then 'Green' End
			from @SupplyChainDsdInventoryMeasuresByBranch as mb
			 Inner Join (Select BranchID
								,((SUM(oos.CaseCut) * 1.0)/NUllIF(sum(Isnull(oos.Quantity, 0)),0)) * 100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut 
						 from SupplyChain.tDsdDailyCaseCut as OOS
							Where  OOS.DateID = @DateID 
							And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
							And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		
							Group By OOS.BranchID) as OOSTemp on mb.BranchID= OOSTemp.BranchID
			 Select top 5 *, Rank() Over (ORDER BY mb.OOSDiff Desc) as MeasureRank  from @SupplyChainDsdInventoryMeasuresByBranch as mb where mb.CaseCut is not null And mb.OOSDiff > 0 order by OOSDiff Desc
		End
	Else If(@MeasureType = 'DOS') 
		Begin
			Update mb
				Set mb.DaysOfSupply = DOSTemp.DaysOfSupply,
					mb.DaysOfSupplyDiff = (DOSTemp.DaysOfSupply - mb.DOSGreen),  --- This will negative values for the Green Branches. So we can ignore if the difference is less than 0
					mb.DaysOfSupplyEndingInventory = DOSTemp.DaysOfSupplyEndingInventory,
					mb.KPILevel = Case 
								When DOSTemp.DaysOfSupply > mb.DOSRed Then 'Red' 
								When (DOSTemp.DaysOfSupply >= mb.DOSGreen And DOSTemp.DaysOfSupply <= mb.DOSRed) Then 'Amber' 
								When DOSTemp.DaysOfSupply < mb.DOSGreen Then 'Green' End
			from @SupplyChainDsdInventoryMeasuresByBranch as mb
			Inner Join (Select BranchID
							   , ((SUM(dos.EndingInventoryCapped)*1.0)/NullIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 31 as DaysOfSupply
							   , ((SUM(dos.EndingInventoryCapped)*1.0)/1000) as DaysOfSupplyEndingInventory
						 from SupplyChain.tDsdDailyBranchInventory as DOS 
						 Where DOS.DateID = @DateID 
								And dos.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
								And dos.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
								And dos.PackageTypeID in (Select PackageTypeID from @SelectedPackageTypeIDs)
								Group By BranchID) as DOSTemp on mb.BranchID=DOSTemp.BranchID
			Select  top 5 *, Rank() Over (ORDER BY mb.DaysOfSupplyDiff Desc) as MeasureRank  from @SupplyChainDsdInventoryMeasuresByBranch as mb where mb.DaysOfSupply > 0 And  mb.DaysOfSupplyDiff > 0 order by mb.DaysOfSupplyDiff Desc
		End
	Else If(@MeasureType = 'MinMax')
		Begin
			Update mb
			Set 
				mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle,
				mb.MinMaxMiddleDiff = (mb.MinMAxGreen - minmaxTemp.MinMaxMiddle),--- This will negative values for the Green Branches. So we can ignore if the difference is less than 0
				mb.MinMaxLeftAbs = minmaxtemp.MinMaxLeftAbs,
				mb.MinMaxMiddleAbs = minmaxtemp.MinMaxMiddleAbs,
				mb.MinMaxRightAbs = minmaxtemp.MinMaxRightAbs,
				mb.KPILevel = Case 
							When minmaxTemp.MinMaxMiddle < mb.MinMaxRed Then 'Red' 
							When (minmaxTemp.MinMaxMiddle >= mb.MinMaxRed And minmaxTemp.MinMaxMiddle <= mb.MinMaxGreen) Then 'Amber' 
							When minmaxTemp.MinMaxMiddle > mb.MinMaxGreen Then 'Green' End
				
			from @SupplyChainDsdInventoryMeasuresByBranch as mb
			Inner Join (Select BranchID
								,(SUm(IsCompliant) * 1.0 )/ SUM(IsBelowMin + IsCompliant + IsAboveMax)*100 as MinMaxMiddle
								,SUM(IsBelowMin) as MinMaxLeftAbs
								,SUM(IsCompliant) as MinMaxMiddleAbs
								,SUM(IsAboveMax) as MinMaxRightAbs
								from SupplyChain.tDsdDailyMinMax as minmax
								Where minmax.DateID = @DateID 
								And minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
								And minmax.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)			
								And minmax.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)	
								Group By BranchID) as minmaxTemp on mb.BranchId = minmaxTemp.BranchId
			Select  top 5 *, Rank() Over (ORDER BY MinMaxMiddleDiff) as MeasureRank  from @SupplyChainDsdInventoryMeasuresByBranch as mb where mb.MinMaxMiddle <> mb.MinMAxGreen And mb.MinMaxMiddleDiff > 0 order by mb.MinMaxMiddleDiff
		  End


GO

Print 'Creating Procedure [SupplyChain].[pGetDsdInventoryMeasuresByBranch] ...'
GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdInventoryMeasuresByBranch]    Script Date: 11/19/2014 1:23:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
/* Test Bench  
exec [SupplyChain].[pGetDsdInventoryMeasuresByBranch] 20141014,'8,11,12,13,14,15,18,19,21,25,29,33,35,36,37,42,44,47,48,50,52,53,54,58','69,192,138,29,232,221,75,158,195,3,12,35,129,49,190,184,64,101', '46,69,138,152,118,78,129,86,64,44,150,47,70,30,124,1', 'MinMax'
33,61,36'  
  
   
  
*/  
  
CREATE Proc [SupplyChain].[pGetDsdInventoryMeasuresByBranch]  
(  
 @DateID int,  
 @BranchIDs varchar(4000),  
 @TrademarkIDs varchar(4000),  
 @PackageTypeIDs varchar(4000),
 @MeasureType varchar(20)  ,
 @AggregationID int = 0  
)  
AS   
 Set NoCount On;  
   
 Declare @SupplyChainDsdInventoryMeasuresByBranch Table    
    (    
     BranchID int not null  
     ,BranchName varchar(50) not null  
     ,Longitude Decimal(10,6) null  
     ,Latitude Decimal(10,6) null  
     ,CaseCut int  null  
     ,OOS Decimal(10,1) null
	 ,OOSDiff Decimal(10,1) null 
     ,DaysOfSupply Decimal(10,1) null  
     ,DaysOfSupplyInventory Decimal(10,1) null  
     ,DaysOfSupplyDiff Decimal(10,1) null  
	 ,MinMaxLeft Decimal(10,1) null  
     ,MinMaxMiddle Decimal(10,1) null  
     ,MinMaxRight Decimal(10,1) null
	 ,MinMaxMiddleDiff Decimal(10,1) null    
      ,MinMaxLeftAbs int null  
     ,MinMaxMiddleAbs int null  
     ,MinMaxRightAbs int null  
     ,OOSRed Decimal(10,1) null  
     ,OOSGreen Decimal(10,1) null  
     ,DOSRed Decimal(10,1) null  
     ,DOSGreen Decimal(10,1) null  
     ,MinMaxRed Decimal(10,1) null  
     ,MinMAxGreen Decimal(10,1) null  
     --,OOSRank int null  
     --,DOSRank int null  
     --,MinMaxRank int null  
    )  
  
Declare @SelectedBranchIDs Table  
  (  
   BranchID int  
  )  
  
Declare @SelectedTradeMarkIDs Table  
  (  
   TradeMarkID int  
  )  
  
Declare @SelectedPackageTypeIDs Table  
  (  
   PackageTypeID int  
  )  
  
Insert into @SelectedBranchIDs  
Select Value from dbo.Split(@BranchIDs,',')  
  
Insert into @SelectedTradeMarkIDs  
Select Value from dbo.Split(@TrademarkIDs,',')  
  
  
Insert into @SelectedPackageTypeIDs  
Select Value from dbo.Split(@PackageTypeIDs,',')  
  
 Insert into @SupplyChainDsdInventoryMeasuresByBranch (BranchID,BranchName, Longitude, Latitude, OOSRed, OOSGreen, DOSRed, DOSGreen, MinMaxRed, MinMaxGreen)   
   Select b.BranchID, b.BranchName, b.Longitude, b.Latitude, bt.BranchOOSLeftThreshold, bt.BranchOOSRightThreshold, bt.BranchDOSLeftThreshold, bt.BranchDOSRightThreshold, bt.BranchMinMaxLeftThreshold, bt.BranchMinMaxRightThreshold  
   from SAP.Branch as b   
   Inner Join SupplyChain.vBranchThreshold as bt on b.BranchID = bt.BranchID   
   Where bt.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)  
  
 If(@MeasureType = 'OOS')
	Begin
		Update mb  
		  Set mb.OOS = OOSTemp.OOS,  
		  mb.CaseCut = OOSTemp.CaseCut,
		  	mb.OOSDiff = (OOSTemp.OOS - mb.OOSGreen)  --- This will negative values for the Green Branches. So we can ignore if the difference is less than 0  
		  from @SupplyChainDsdInventoryMeasuresByBranch as mb  
		   Inner Join (Select BranchID,((SUM(oos.CaseCut) * 1.0)/NUllIF(sum(Isnull(oos.Quantity, 0)),0))*100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from     
			  SupplyChain.tDsdDailyCaseCut as OOS  
			  Where  OOS.DateID = @DateID   
			  And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)  
			  And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)   
			  And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)    
			  Group By OOS.BranchID) as OOSTemp on mb.BranchID= OOSTemp.BranchID
		Select b.*, tRanking.MeasureRank as 'MeasureRank'
				from @SupplyChainDsdInventoryMeasuresByBranch as b Left Outer Join
					 (Select top 5 *, Rank() Over (ORDER BY mb.OOSDiff Desc) as MeasureRank  
							from @SupplyChainDsdInventoryMeasuresByBranch as mb 
							where mb.CaseCut is not null And mb.OOSDiff > 0 order by OOSDiff Desc) as tRanking on b.BranchID = tRanking.BranchID
	End  
 Else If (@MeasureType = 'DOS')
	Begin
		Update mb  
		  Set mb.DaysOfSupply = DOSTemp.DaysOfSupply,
		  mb.DaysOfSupplyDiff = (DOSTemp.DaysOfSupply - mb.DOSGreen),  --- This will negative values for the Green Branches. So we can ignore if the difference is less than 0  
		   mb.DaysOfSupplyInventory = DOSTemp.DaysOfSupplyInventory  
		  from @SupplyChainDsdInventoryMeasuresByBranch as mb  
		  Inner Join (Select BranchID  
							 , ((SUM(dos.EndingInventoryCapped)*1.0)/NullIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 31 as DaysOfSupply  
							 ,(SUM(dos.EndingInventoryCapped)*1.0)/1000 as DaysOfSupplyInventory  
						  from SupplyChain.tDsdDailyBranchInventory as DOS   
						  Where DOS.DateID = @DateID   
						   And dos.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)  
						   And dos.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)   
						   And dos.PackageTypeID in (Select PackageTypeID from @SelectedPackageTypeIDs)  
						   Group By BranchID) as DOSTemp on mb.BranchID=DOSTemp.BranchID
		Select b.*, tRanking.MeasureRank as 'MeasureRank'
				from @SupplyChainDsdInventoryMeasuresByBranch as b Left Outer Join
					 (Select  top 5 *, Rank() Over (ORDER BY mb.DaysOfSupplyDiff Desc) as MeasureRank  
								from @SupplyChainDsdInventoryMeasuresByBranch as mb where mb.DaysOfSupply > 0 And  mb.DaysOfSupplyDiff > 0 order by mb.DaysOfSupplyDiff Desc) as tRanking on b.BranchID = tRanking.BranchID
  
	End
 Else If (@MeasureType = 'MinMax')
	Begin
		  Update mb  
			  Set mb.MinMaxLeft = minmaxTemp.MinMaxLeft,  
			   mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle,  
			   mb.MinMaxMiddleDiff = (mb.MinMAxGreen - minmaxTemp.MinMaxMiddle),--- This will negative values for the Green Branches. So we can ignore if the difference is less than 0
			   mb.MinMaxRight = minmaxTemp.MinMaxRight,  
			   mb.MinMaxLeftAbs = minmaxTemp.MinMaxLeftAbs,  
			   mb.MinMaxMiddleAbs = minmaxTemp.MinMaxMiddleAbs,  
			   mb.MinMaxRightAbs = minmaxTemp.MinMaxRightAbs  
			  from @SupplyChainDsdInventoryMeasuresByBranch as mb  
			  Inner Join (Select BranchID  
				   , (SUm(IsBelowMin) * 1.0 )/ SUM(IsBelowMin + IsCompliant + IsAboveMax)*100 as MinMaxLeft  
				   ,(SUm(IsCompliant) * 1.0 )/ SUM(IsBelowMin + IsCompliant + IsAboveMax)*100 as MinMaxMiddle  
				   , (SUm(IsAboveMax) * 1.0 )/ SUM(IsBelowMin + IsCompliant + IsAboveMax)*100 as MinMaxRight  
				   ,(SUm(IsBelowMin) * 1.0 ) as MinMaxLeftAbs  
				   ,(SUm(IsCompliant) * 1.0 ) as MinMaxMiddleAbs  
				   ,(SUm(IsAboveMax) * 1.0 ) as MinMaxRightAbs  
				   from SupplyChain.tDsdDailyMinMax as minmax  
				   Where minmax.DateID = @DateID   
				   And minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)  
				   And minmax.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)     
				   And minmax.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)   
				   Group By BranchID) as minmaxTemp on mb.BranchId = minmaxTemp.BranchId 
			Select b.*, tRanking.MeasureRank as 'MeasureRank'
						from @SupplyChainDsdInventoryMeasuresByBranch as b Left Outer Join
					 ( Select  top 5 *, Rank() Over (ORDER BY MinMaxMiddleDiff) as MeasureRank  
							from @SupplyChainDsdInventoryMeasuresByBranch as mb where mb.MinMaxMiddle <> mb.MinMAxGreen And mb.MinMaxMiddleDiff > 0 order by mb.MinMaxMiddleDiff) as tRanking on b.BranchID = tRanking.BranchID 
	End 
  

GO

Print 'Creating Procedure [SupplyChain].[pGetDsdInventoryMeasuresByBranchAggregated] ...'
GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdInventoryMeasuresByBranchAggregated]    Script Date: 11/19/2014 1:23:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Test Bench
exec [SupplyChain].[pGetDsdInventoryMeasuresByBranchAggregated] 20141014,'8,11,12,13,14,15,18,19,21,25,29,33,35,36,37,42,44,47,48,50,52,53,54,58','69,192,138,29,232,221,75,158,195,3,12,35,129,49,190,184,64,101', '46,69,138,152,118,78,129,86,64,44,150,47,70,30,124,133,61,36'
exec [SupplyChain].[pGetDsdInventoryMeasuresByBranchAggregated] 20141118, '1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 146, 147, 148, 149, 150, 151, 152, 153, 163, 170, 172, 174'
																		, '1, 3, 7, 22, 29, 33, 35, 49, 65, 69, 75, 232, 101, 138, 145, 158, 170, 190, 194, 195, 196, 217, 221, 223, 231, 131, 160, 141, 12, 174, 68, 99, 184, 9, 67, 147, 162, 113, 44, 219, 154'
																		,'22, 27, 30, 32, 33, 38, 39, 44, 46, 47, 51, 59, 62, 63, 64, 67, 68, 73, 77, 78, 79, 85, 86, 88, 91, 94, 105, 108, 117, 124, 129, 133, 134, 138, 139, 140, 143, 145, 146, 150, 151, 152, 153, 154, 158, 159, 160, 162, 165'					

	
	
*/

CREATE PROC [SupplyChain].[pGetDsdInventoryMeasuresByBranchAggregated] (  
 @DateID INT =0  
 ,@BranchIDs VARCHAR(4000) =''  
 ,@TrademarkIDs VARCHAR(4000) = ''  
 ,@PackageTypeIDs varchar(4000)  
 ,@AggregationID INT = 0  
 )  
AS  
SET NOCOUNT ON;  

Declare @SupplyChainDsdInventoryMeasuresByBranchAggregated Table  
			 (  
				 IncomingOrderCases int  null
				 ,IncomingOrderCasesDayAfterTomorrow int  null
				,IncomingOrderUpdated Datetime2
				,CaseCut int null
				,OOS Decimal(10,1) null
				,DaysOfSupply Decimal(10,1) null
				,MinMaxLeft Decimal(10,1) null
				,MinMaxMiddle Decimal(10,1) null
				,MinMaxRight Decimal(10,1) null
				,OOSRed Decimal(10,1) null
				,OOSGreen Decimal(10,1) null
				,DOSRed Decimal(10,1) null
				,DOSGreen Decimal(10,1) null
				,MinMaxRed Decimal(10,1) null
				,MinMAxGreen Decimal(10,1) null
			 )

Declare @SelectedBranchIDs Table
		(
			BranchID int
		)

Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)

Declare @SelectedPackageTypeIDs Table
		(
			PackageTypeID int
		)
Declare @TomorrowDate int
Declare @DayAfterTomorrowDate int
Set @TomorrowDate = SupplyChain.udfConvertToDateID(DATEADD(d,2, Convert(DATE, LEFT(@DateID, 8))))
Set @DayAfterTomorrowDate = SupplyChain.udfConvertToDateID(DATEADD(d,3, Convert(DATE, LEFT(@DateID, 8)))) 

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')

Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')


Insert into @SelectedPackageTypeIDs
Select Value from dbo.Split(@PackageTypeIDs,',')

	----If we are showing only one branch, then need to return the threshold data for that one branch. If it's more than one branch and under one region we need to return the region threshold. If branches are falling under multiple region then need to return the OverAllThreshold
		If (Select Count(*) from @SelectedBranchIDs) = 1  
			Begin
				Insert into @SupplyChainDsdInventoryMeasuresByBranchAggregated (OOSRed, OOSGreen, DOSRed, DOSGreen, MinMaxRed, MinMaxGreen) 
					Select bt.BranchOOSLeftThreshold, bt.BranchOOSRightThreshold, bt.BranchDOSLeftThreshold, bt.BranchDOSRightThreshold, bt.BranchMinMaxLeftThreshold, bt.BranchMinMaxRightThreshold
					from SAP.Branch as b 
					Inner Join SupplyChain.vBranchThreshold as bt on b.BranchID = bt.BranchID 
					Where bt.BranchID in (Select BranchID from @SelectedBranchIDs)

			End
		Else If (Select Count(Distinct RegionID) from @SelectedBranchIDs sb inner Join Mview.LocationHier as lh on lh.BranchID = sb.BranchID) = 1 
			Begin
				Insert into @SupplyChainDsdInventoryMeasuresByBranchAggregated (OOSRed, OOSGreen, DOSRed, DOSGreen, MinMaxRed, MinMaxGreen) 
					Select Top 1 rt.RegionOOSLeftThreshold, rt.RegionOOSRightThreshold, rt.RegionDOSLeftThreshold, rt.RegionDOSRightThreshold, rt.RegionMinMaxLeftThreshold, rt.RegionMinMaxRightThreshold
					from MView.LocationHier as lh 
					Inner Join SupplyChain.vRegionThreshold as rt on lh.RegionID = rt.RegionID 
					Where Lh.BranchID in (Select BranchID from  @SelectedBranchIDs)

			End
		Else
			Begin 
				Insert into @SupplyChainDsdInventoryMeasuresByBranchAggregated (OOSRed, OOSGreen, DOSRed, DOSGreen, MinMaxRed, MinMaxGreen) 
					Select OAT.OverAllOOSLeftThreshold, OAT.OverAllOOSRightThreshold, OAT.OverAllDOSLeftThreshold, OAT.OverAllDOSRightThreshold, OAT.OverAllMinMaxLeftThreshold, OAT.OverAllMinMaxRightThreshold
						from SupplyChain.OverAllThreshold as OAT

			End
	
		Update mb
		Set mb.OOS = OOSTemp.OOS,
		mb.CaseCut = OOSTemp.CaseCut,
		mb.IncomingOrderUpdated = (Select Top 1 MergeDate From ETL.BCDataLoadingLog Where SchemaName = 'Apacheta'And TableName = 'OriginalOrder'),
		mb.IncomingOrderCases = Isnull((Select Sum(dor.Quantity) from SupplyChain.tDSDOpenOrder as DOR  inner Join  SAP.Branch as b on dor.BranchID = b.BranchID
										Where b.BranchID in (Select BranchID from @SelectedBranchIDs) 
											 And DateID = @TomorrowDate),0),
		mb.IncomingOrderCasesDayAfterTomorrow = isnull((Select Sum(dor.Quantity) from SupplyChain.tDSDOpenOrder as DOR  inner Join  SAP.Branch as b on dor.BranchID = b.BranchID
										Where b.BranchID in (Select BranchID from @SelectedBranchIDs) And DateID = @DayAfterTomorrowDate),0)


		from @SupplyChainDsdInventoryMeasuresByBranchAggregated as mb
		 Cross Join (Select ((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0)) * 100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
						SupplyChain.tDsdDailyCaseCut as OOS
						Where  OOS.DateID = @DateID 
						And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
						And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
						And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)	
						) as OOSTemp 

		Update mb
		Set mb.DaysOfSupply = DOSTemp.DaysOfSupply
		from @SupplyChainDsdInventoryMeasuresByBranchAggregated as mb
		Cross Join (Select ((SUM(dos.EndingInventoryCapped)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 31 as DaysOfSupply
					 from SupplyChain.tDsdDailyBranchInventory as DOS 
					 Where  DOS.DateID = @DateID 
						And DOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
						And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
						And DOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		 
						) as DOSTemp 

		Update mb
		Set mb.MinMaxLeft = minmaxTemp.MinMaxLeft,
			mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle,
			mb.MinMaxRight = minmaxTemp.MinMaxRight
		from @SupplyChainDsdInventoryMeasuresByBranchAggregated as mb
		Cross Join (Select  ((SUm(minMax.IsBelowMin) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxLeft
							,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
							, ((SUm(minMax.IsAboveMax) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxRight
							from SupplyChain.tDsdDailyMinMax as minmax
							 Where  minmax.DateID = @DateID And  minmax.BranchID in (Select BranchID from @SelectedBranchIDs)
						And minmax.TradeMarkID in (Select TradeMarkID from @SelectedTradeMarkIDs)	
						And minmax.PackageTypeID in (Select PackageTypeID from @SelectedPackageTypeIDs)
						) as minmaxTemp 
  Select * from @SupplyChainDsdInventoryMeasuresByBranchAggregated
--SELECT 2338 IncomingOrderCases  
-- ,getutcdate() IncomingOrderUpdated  
-- ,4 CaseCut  
-- ,2.5 OOS  
-- ,6.1 DaysOfSupply  
-- ,2.5 MinMaxleft  
-- ,89.1 MinMaxMiddle  
-- ,12.2 MinMaxRight  
-- ,-- Actuals  
-- 1.1 OOSRed  
-- ,1.2 OOSGreen  
-- ,2.3 DOSRed  
-- ,2.6 DOSGreen  
-- ,2.6 MinMaxRed  
-- ,2.9 MinMaxGreen --- Borders Threshholds  



GO
Print 'Creating Procedure [SupplyChain].[pGetDsdInventoryMeasuresByRegion] ...'
GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdInventoryMeasuresByRegion]    Script Date: 11/19/2014 1:23:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Test Bench
exec [SupplyChain].[pGetDsdInventoryMeasuresByRegion] 20141014,'3,4,5','69,192,138,29,232,221,75,9,158,195,3,12,35,129,49,190,184,67', '46,69,138,175,152,118,78,129,86,64,38,44,150,47,70,30,124', 'MinMax'
*/

CREATE Proc [SupplyChain].[pGetDsdInventoryMeasuresByRegion]

(

	@DateID int,
	@RegionIDs varchar(4000),
	@BranchIDs varchar(4000),
	@TrademarkIDs varchar(4000),
	@PackageTypeIDs varchar(4000),
	@MeasureType varchar(20),
	@AggregationID int = 0
)

AS	
	Set NoCount On;
	Declare @SupplyChainDsdInventoryMeasuresByRegion Table  
			 (  
			  RegionID int not null
			  ,RegionName varchar(50) not null
			  ,Longitude Decimal(10,6) null
			  ,Latitude Decimal(10,6) null
			  ,CaseCut int  null
			  ,OOS Decimal(10,1) null
			  ,OOSDiff Decimal(10,1) null
			  ,DaysOfSupply Decimal(10,1) null
			  ,DaysOfSupplyInventory Decimal(10,1) null
			  ,DaysOfSupplyDiff Decimal(10,1) null  
			  ,MinMaxLeft Decimal(10,1) null
			  ,MinMaxMiddle Decimal(10,1) null
			  ,MinMaxMiddleDiff Decimal(10,1) null    
			  ,MinMaxRight Decimal(10,1) null
			  ,MinMaxLeftAbs int null
			  ,MinMaxMiddleAbs int null
			  ,MinMaxRightAbs int null
			  ,OOSRed Decimal(10,1) null
			  ,OOSGreen Decimal(10,1) null
			  ,DOSRed Decimal(10,1) null
			  ,DOSGreen Decimal(10,1) null
			  ,MinMaxRed Decimal(10,1) null
			  ,MinMAxGreen Decimal(10,1) null
			  --,OOSRank int null
			  --,DOSRank int null
			  --,MinMaxRank int null
			 )
Declare @SelectedRegionIDs Table
		(
			RegionID int
		)
Declare @SelectedBranchIDs Table
(
	BranchID int
)
Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)
Declare @SelectedPackageTypeIDs Table
		(
			PackageTypeID int
		)
Insert into @SelectedRegionIDs
Select Value from dbo.Split(@RegionIDs,',')

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')

Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')

Insert into @SelectedPackageTypeIDs
Select Value from dbo.Split(@PackageTypeIDs,',')


	Insert into @SupplyChainDsdInventoryMeasuresByRegion (RegionID,RegionName, Longitude, Latitude, OOSRed, OOSGreen, DOSRed, DOSGreen, MinMaxRed, MinMaxGreen) 
			Select r.RegionID, r.RegionName, r.Longitude, r.Latitude, rt.RegionOOSLeftThreshold, rt.RegionOOSRightThreshold, rt.RegionDOSLeftThreshold, rt.RegionDOSRightThreshold, rt.RegionMinMaxLeftThreshold, rt.RegionMinMaxRightThreshold
			from SAP.Region as r 
			Inner Join SupplyChain.vRegionThreshold as rt on r.RegionID = rt.RegionID 
			Where rt.RegionID in (Select RegionID from @SelectedRegionIDs)

If(@MeasureType = 'OOS')
	Begin
		Update mb
		Set mb.OOS = OOSTemp.OOS,
		mb.CaseCut = OOSTemp.CaseCut,
		 	mb.OOSDiff = (OOSTemp.OOS - mb.OOSGreen)  --- This will negative values for the Green Branches. So we can ignore if the difference is less than 0  
		from @SupplyChainDsdInventoryMeasuresByRegion as mb
		 Inner Join (Select RegionID,((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0)) * 100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
						SupplyChain.tDsdDailyCaseCut as OOS
						Where  OOS.DateID = @DateID 
						And OOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
						And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
						And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
						And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		
						Group By RegionID) as OOSTemp on mb.RegionID= OOSTemp.RegionID
		Select r.*, tRanking.MeasureRank as 'MeasureRank'
				from @SupplyChainDsdInventoryMeasuresByRegion as r Left Outer Join
					 (Select top 5 *, Rank() Over (ORDER BY mb.OOSDiff Desc) as MeasureRank  
							from @SupplyChainDsdInventoryMeasuresByRegion as mb 
							where mb.CaseCut is not null And mb.OOSDiff > 0 order by OOSDiff Desc) as tRanking on r.RegionID = tRanking.RegionID

	End
Else If(@MeasureType = 'DOS')
	Begin
		Update mb
		Set mb.DaysOfSupply = DOSTemp.DaysOfSupply,
			mb.DaysOfSupplyDiff = (DOSTemp.DaysOfSupply - mb.DOSGreen),  --- This will negative values for the Green Branches. So we can ignore if the difference is less than 0  
			mb.DaysOfSupplyInventory = DOSTemp.DaysOfSupplyInventory
		from @SupplyChainDsdInventoryMeasuresByRegion as mb
		Inner Join (Select RegionID
							, ((SUM(dos.EndingInventoryCapped)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 31 as DaysOfSupply
							,(SUM(dos.EndingInventoryCapped)*1.0)/1000 as DaysOfSupplyInventory
					 from SupplyChain.tDsdDailyBranchInventory as DOS 
					 Where DOS.DateID = @DateID 
							And dos.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
							And dos.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
							And dos.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And dos.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)	
							Group By RegionID) as DOSTemp on mb.RegionID=DOSTemp.RegionID
			Select r.*, tRanking.MeasureRank as 'MeasureRank'
				from @SupplyChainDsdInventoryMeasuresByRegion as r Left Outer Join
					 (Select  top 5 *, Rank() Over (ORDER BY mb.DaysOfSupplyDiff Desc) as MeasureRank  
								from @SupplyChainDsdInventoryMeasuresByRegion as mb where mb.DaysOfSupply > 0 And  mb.DaysOfSupplyDiff > 0 order by mb.DaysOfSupplyDiff Desc) as tRanking on r.RegionID = tRanking.RegionID

	End
Else If(@MeasureType = 'MinMax')
	Begin
		Update mb
		Set mb.MinMaxLeft = minmaxTemp.MinMaxLeft,
			mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle,
			mb.MinMaxMiddleDiff = (mb.MinMAxGreen - minmaxTemp.MinMaxMiddle),--- This will negative values for the Green Branches. So we can ignore if the difference is less than 0
			mb.MinMaxRight = minmaxTemp.MinMaxRight,
			mb.MinMaxLeftAbs = minmaxTemp.MinMaxLeftAbs,
			mb.MinMaxMiddleAbs = minmaxTemp.MinMaxMiddleAbs,
			mb.MinMaxRightAbs = minmaxTemp.MinMaxRightAbs
		from @SupplyChainDsdInventoryMeasuresByRegion as mb
		Inner Join (Select RegionID
							,((SUm(minMax.IsBelowMin) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxLeft
							,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
							, ((SUm(minMax.IsAboveMax) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxRight
							,(SUm(IsBelowMin) * 1.0 ) as MinMaxLeftAbs
							,(SUm(IsCompliant) * 1.0 ) as MinMaxMiddleAbs
							,(SUm(IsAboveMax) * 1.0 ) as MinMaxRightAbs
							from SupplyChain.tDsdDailyMinMax as minmax
							Where minmax.DateID = @DateID 
							And minmax.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
							And minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
							And minmax.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)		
							And minmax.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)	
							Group By RegionID) as minmaxTemp on mb.RegionID = minmaxTemp.RegionID
		
			Select r.*, tRanking.MeasureRank as 'MeasureRank'
						from @SupplyChainDsdInventoryMeasuresByRegion as r Left Outer Join
					 ( Select  top 5 *, Rank() Over (ORDER BY MinMaxMiddleDiff) as MeasureRank  
							from @SupplyChainDsdInventoryMeasuresByRegion as mb where mb.MinMaxMiddle <> mb.MinMAxGreen And mb.MinMaxMiddleDiff > 0 order by mb.MinMaxMiddleDiff) as tRanking on r.RegionID = tRanking.RegionID

	End

GO
Print 'Creating Procedure [SupplyChain].[pGetDsdInventoryMeasuresByRegionAggregated] ...'
GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdInventoryMeasuresByRegionAggregated]    Script Date: 11/19/2014 1:23:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Test Bench
exec [SupplyChain].[pGetDsdInventoryMeasuresByRegionAggregated] 20141014,'3,4,5','69,192,138,29,232,221,75,9,158,195,3,12,35,129,49,190,184,67', '46,69,138,175,152,118,78,129,86,64,38,44,150,47,70,30,124'
exec [SupplyChain].[pGetDsdInventoryMeasuresByRegionAggregated] 20141117, '1, 2, 3, 5, 6, 11','1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 146, 147, 148, 149, 150, 151, 152, 153, 163, 170, 172, 174'
																		, '1, 3, 7, 22, 29, 33, 35, 49, 65, 69, 75, 232, 101, 138, 145, 158, 170, 190, 194, 195, 196, 217, 221, 223, 231, 131, 160, 141, 12, 174, 68, 99, 184, 9, 67, 147, 162, 113, 44, 219, 154'
																		,'22, 27, 30, 32, 33, 38, 39, 44, 46, 47, 51, 59, 62, 63, 64, 67, 68, 73, 77, 78, 79, 85, 86, 88, 91, 94, 105, 108, 117, 124, 129, 133, 134, 138, 139, 140, 143, 145, 146, 150, 151, 152, 153, 154, 158, 159, 160, 162, 165'					

	
	

*/

CREATE PROC [SupplyChain].[pGetDsdInventoryMeasuresByRegionAggregated] (  
 @DateID INT =0  
 ,@RegionIDs VARCHAR(4000) =''  
 ,@BranchIDs varchar(4000)=''
 ,@TrademarkIDs VARCHAR(4000) = ''  
 ,@PackageTypeIDs varchar(4000)  
 ,@AggregationID INT = 0  
 )  
AS  
SET NOCOUNT ON;  

Declare @SupplyChainDsdInventoryMeasuresByRegionAggregated Table  
			 (  
				 IncomingOrderCases int  null
				  ,IncomingOrderCasesDayAfterTomorrow int  null
				,IncomingOrderUpdated Datetime2
				,CaseCut int null
				,OOS Decimal(10,1) null
				,DaysOfSupply Decimal(10,1) null
				,MinMaxLeft Decimal(10,1) null
				,MinMaxMiddle Decimal(10,1) null
				,MinMaxRight Decimal(10,1) null
				,OOSRed Decimal(10,1) null
				,OOSGreen Decimal(10,1) null
				,DOSRed Decimal(10,1) null
				,DOSGreen Decimal(10,1) null
				,MinMaxRed Decimal(10,1) null
				,MinMAxGreen Decimal(10,1) null
			 )

Declare @SelectedRegionIDs Table
		(
			RegionID int
		)
Declare @SelectedBranchIDs Table
(
	BranchID int
)
Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)

Declare @SelectedPackageTypeIDs Table
		(
			PackageTypeID int
		)


Declare @TomorrowDate int
Declare @DayAfterTomorrowDate int
Set @TomorrowDate = SupplyChain.udfConvertToDateID(DATEADD(d,2, Convert(DATE, LEFT(@DateID, 8))))
Set @DayAfterTomorrowDate = SupplyChain.udfConvertToDateID(DATEADD(d,3, Convert(DATE, LEFT(@DateID, 8)))) 


Insert into @SelectedRegionIDs
Select Value from dbo.Split(@RegionIDs,',')

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')

Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')


Insert into @SelectedPackageTypeIDs
Select Value from dbo.Split(@PackageTypeIDs,',')

	----If we are showing only one branch, then need to return the threshold data for that one branch. If it's more than one branch and under one region we need to return the region threshold. If branches are falling under multiple region then need to return the OverAllThreshold
		If (Select Count(*) from @SelectedRegionIDs) = 1  
			Begin
				Insert into @SupplyChainDsdInventoryMeasuresByRegionAggregated (OOSRed, OOSGreen, DOSRed, DOSGreen, MinMaxRed, MinMaxGreen) 
					Select rt.RegionOOSLeftThreshold, rt.RegionOOSRightThreshold, rt.RegionDOSLeftThreshold, rt.RegionDOSRightThreshold, rt.RegionMinMaxLeftThreshold, rt.RegionMinMaxRightThreshold
					from SAP.Region as r 
					Inner Join SupplyChain.vRegionThreshold as rt on r.RegionID = rt.RegionID
					Where rt.RegionID in (Select RegionID from @SelectedRegionIDs)

			End
		Else
			Begin 
				Insert into @SupplyChainDsdInventoryMeasuresByRegionAggregated (OOSRed, OOSGreen, DOSRed, DOSGreen, MinMaxRed, MinMaxGreen) 
					Select OAT.OverAllOOSLeftThreshold, OAT.OverAllOOSRightThreshold, OAT.OverAllDOSLeftThreshold, OAT.OverAllDOSRightThreshold, OAT.OverAllMinMaxLeftThreshold, OAT.OverAllMinMaxRightThreshold
						from SupplyChain.OverAllThreshold as OAT

			End
	
		Update mb
		Set mb.OOS = OOSTemp.OOS,
		mb.CaseCut = OOSTemp.CaseCut,
		mb.IncomingOrderUpdated = (Select Top 1 MergeDate From ETL.BCDataLoadingLog Where SchemaName = 'Apacheta'And TableName = 'OriginalOrder'),
		mb.IncomingOrderCases = Isnull((Select Sum(DOR.Quantity) from SupplyChain.tDSDOpenOrder as DOR  inner Join  MView.LocationHier as lh on dor.BranchID = lh.BranchID
										Where lh.RegionID in (Select RegionID from @SelectedRegionIDs) And DateID = @TomorrowDate),0),
		mb.IncomingOrderCasesDayAfterTomorrow = Isnull((Select Sum(DOR.Quantity) from SupplyChain.tDSDOpenOrder as DOR  inner Join  MView.LocationHier as lh on dor.BranchID = lh.BranchID
										Where lh.RegionID in (Select RegionID from @SelectedRegionIDs) And DateID = @DayAfterTomorrowDate),0)
		from @SupplyChainDsdInventoryMeasuresByRegionAggregated as mb
		 Cross Join (Select ((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0))* 100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
						SupplyChain.tDsdDailyCaseCut as OOS
						Where  OOS.DateID = @DateID
						And OOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
						And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
						And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
						And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		
						) as OOSTemp 

		Update mb
		Set mb.DaysOfSupply = DOSTemp.DaysOfSupply
		from @SupplyChainDsdInventoryMeasuresByRegionAggregated as mb
		Cross Join (Select ((SUM(dos.EndingInventoryCapped)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 31 as DaysOfSupply
					 from SupplyChain.tDsdDailyBranchInventory as DOS 
					 Where  DOS.DateID = @DateID 
						And DOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
						And DOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
						And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
						And DOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		 
						) as DOSTemp 

		Update mb
		Set mb.MinMaxLeft = minmaxTemp.MinMaxLeft,
			mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle,
			mb.MinMaxRight = minmaxTemp.MinMaxRight
		from @SupplyChainDsdInventoryMeasuresByRegionAggregated as mb
		Cross Join (Select  ((SUm(minMax.IsBelowMin) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxLeft
							,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
							, ((SUm(minMax.IsAboveMax) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxRight
							from SupplyChain.tDsdDailyMinMax as minmax
							 Where  minmax.DateID = @DateID 
									And minmax.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
									And minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
									And minmax.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
									And minmax.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)	
					) as minmaxTemp 
  Select * from @SupplyChainDsdInventoryMeasuresByRegionAggregated
--SELECT 2338 IncomingOrderCases  
-- ,getutcdate() IncomingOrderUpdated  
-- ,4 CaseCut  
-- ,2.5 OOS  
-- ,6.1 DaysOfSupply  
-- ,2.5 MinMaxleft  
-- ,89.1 MinMaxMiddle  
-- ,12.2 MinMaxRight  
-- ,-- Actuals  
-- 1.1 OOSRed  
-- ,1.2 OOSGreen  
-- ,2.3 DOSRed  
-- ,2.6 DOSGreen  
-- ,2.6 MinMaxRed  
-- ,2.9 MinMaxGreen --- Borders Threshholds  



GO
Print 'Creating Procedure [SupplyChain].[pGetDsdInventoryRegionMeasuresForLanding] ...'
GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdInventoryRegionMeasuresForLanding]    Script Date: 11/19/2014 1:23:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Test Bench
exec [SupplyChain].[pGetDsdInventoryRegionMeasuresForLanding] 20141014,'3,4,5', '42,43,44,45,46,47,48,49,50,51,52', '69,192,138,29,232,221,75,9,158,195,3,12,35,129,49,190,184,67', '46,69,138,175,152,118,78,129,86,64,38,44,150,47,70,30,124', 'OOS'

exec [SupplyChain].[pGetDsdInventoryRegionMeasuresForLanding] 20141111,'1,2,3,4,5,6,7,8,9,11,14,12','1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,167,168,169,170,172,173,174',
'1,3,5,20,22,33,59,35,37,60,44,61,46,49,50,51,65,67,68,34,64,89,173,54,97,129,130,154,187,216,228',
'22,27,30,33,38,39,44,46,47,51,59,62,63,64,67,68,77,78,79,86,90,94,108,117,124,129,133,134,138,139,140,143,145,146,150,151,152,154','OOS'

*/
CREATE Proc [SupplyChain].[pGetDsdInventoryRegionMeasuresForLanding]
(
	@DateID int,
	@RegionIDs varchar(4000),
	@BranchIDs Varchar(4000),
	@TrademarkIDs varchar(4000),
	@PackageTypeIDs varchar(4000),
	@MeasureType varchar(10),
	@AggregationID int = 0
	
)
AS	
	Set NoCount On;

	Declare @SupplyChainDsdInventoryMeasuresByRegion Table  
			 (  
			  RegionID int not null
			  ,RegionName varchar(50) not null
			  ,Longitude varchar(50) null
			  ,Latitude varchar(50) null
			  ,CaseCut int  null
			  ,OOS Decimal(10,1) null
			  ,DaysOfSupply Decimal(10,1) null
			  ,MinMaxMiddle Decimal(10,1) null
			  ,IsSelectedRegion bit
			  ,OOSRed Decimal(10,1) null
			  ,OOSGreen Decimal(10,1) null
			  ,DOSRed Decimal(10,1) null
			  ,DOSGreen Decimal(10,1) null
			  ,MinMaxRed Decimal(10,1) null
			  ,MinMaxGreen Decimal(10,1) null
			  ,KPILevel varchar(10) null
			  ,BUSortOrder int	
			 )

Declare @SelectedRegionIDs Table
		(
			RegionID int
		)
Declare @SelectedBranchIDs Table
		(
			BranchID int
		)
Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)

Declare @SelectedPackageTypeIDs Table
		(
			PackageTypeID int
		)
Insert into @SelectedRegionIDs
Select Value from dbo.Split(@RegionIDs,',')

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')

Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')

Insert into @SelectedPackageTypeIDs
Select Value from dbo.Split(@PackageTypeIDs,',')

	Insert into @SupplyChainDsdInventoryMeasuresByRegion (RegionID,RegionName, Longitude, Latitude, IsSelectedRegion, OOSRed, OOSGreen, DOSRed, DOSGreen, MinMaxRed, MinMaxGreen,BUSortOrder) 
			Select r.RegionID, r.ShortName as RegionName, r.Longitude, r.Latitude
					,Case When sr.RegionID is not null then 1 Else 0 End
					, rt.RegionOOSLeftThreshold, rt.RegionOOSRightThreshold, rt.RegionDOSLeftThreshold, rt.RegionDOSRightThreshold, rt.RegionMinMaxLeftThreshold, rt.RegionMinMaxRightThreshold
					, bu.SortOrder
			from SAP.Region as r 
			Left Outer Join @SelectedRegionIDs as sr on r.RegionID = sr.RegionID
			Inner Join SupplyChain.vRegionThreshold as rt on rt.RegionID = r.RegionID 
			Inner Join SAP.BusinessUnit as bu on r.BUID = bu.BUID 
			

	If(@MeasureType = 'OOS')
		Begin 
			Update mb
			Set mb.OOS = OOSTemp.OOS,
			mb.CaseCut = OOSTemp.CaseCut,
			mb.KPILevel = Case 
							When OOSTemp.OOS > mb.OOSRed Then 'Red' 
							When (OOSTemp.OOS >= mb.OOSGreen And OOSTemp.OOS <= mb.OOSRed) Then 'Amber' 
							When OOSTemp.OOS < mb.OOSGreen Then 'Green' End
			from @SupplyChainDsdInventoryMeasuresByRegion as mb
			 Inner Join (Select RegionID,((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0))*100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
							SupplyChain.tDsdDailyCaseCut as OOS
							Where  OOS.DateID = @DateID 
							And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)
							And OOS.RegionID Not in (Select sr.RegionID from @SelectedRegionIDs as sr)		
							Group By RegionID) as OOSTemp on mb.RegionID= OOSTemp.RegionID
			Update mb
			Set mb.OOS = OOSTemp.OOS,
			mb.CaseCut = OOSTemp.CaseCut,
			mb.KPILevel = Case 
							When OOSTemp.OOS > mb.OOSRed Then 'Red' 
							When (OOSTemp.OOS >= mb.OOSGreen And OOSTemp.OOS <= mb.OOSRed) Then 'Amber' 
							When OOSTemp.OOS < mb.OOSGreen Then 'Green' End
			from @SupplyChainDsdInventoryMeasuresByRegion as mb
			 Inner Join (Select RegionID,((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0))*100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
							SupplyChain.tDsdDailyCaseCut as OOS
							Where  OOS.DateID = @DateID 
							And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)	
							And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)
							And OOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)		
							Group By RegionID) as OOSTemp on mb.RegionID= OOSTemp.RegionID
		End
    Else if(@MeasureType = 'DOS')
		Begin
			Update mb
			Set mb.DaysOfSupply = DOSTemp.DaysOfSupply,
			mb.KPILevel = Case 
								When DOSTemp.DaysOfSupply > mb.DOSRed Then 'Red' 
								When (DOSTemp.DaysOfSupply >= mb.DOSGreen And DOSTemp.DaysOfSupply <= mb.DOSRed) Then 'Amber' 
								When DOSTemp.DaysOfSupply < mb.DOSGreen Then 'Green' End
			from @SupplyChainDsdInventoryMeasuresByRegion as mb
			Inner Join (Select RegionID, ((SUM(dos.EndingInventoryCapped)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 31 as DaysOfSupply
						 from SupplyChain.tDsdDailyBranchInventory as DOS 
						Where  DOS.DateID = @DateID 
							And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And DOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)
							And DOS.RegionID Not in (Select sr.RegionID from @SelectedRegionIDs as sr)		
							Group By RegionID) as DOSTemp on mb.RegionID= DOSTemp.RegionID
			Update mb
			Set mb.DaysOfSupply = DOSTemp.DaysOfSupply,
			mb.KPILevel = Case 
								When DOSTemp.DaysOfSupply > mb.DOSRed Then 'Red' 
								When (DOSTemp.DaysOfSupply >= mb.DOSGreen And DOSTemp.DaysOfSupply <= mb.DOSRed) Then 'Amber' 
								When DOSTemp.DaysOfSupply < mb.DOSGreen Then 'Green' End
			from @SupplyChainDsdInventoryMeasuresByRegion as mb
			Inner Join (Select RegionID, ((SUM(dos.EndingInventoryCapped)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 31 as DaysOfSupply
						 from SupplyChain.tDsdDailyBranchInventory as DOS 
						Where  DOS.DateID = @DateID 
							And DOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)	
							And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And DOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)
							And DOS.RegionID  in (Select sr.RegionID from @SelectedRegionIDs as sr)		
							Group By RegionID) as DOSTemp on mb.RegionID= DOSTemp.RegionID
		End
	Else if(@MeasureType = 'MinMax')
		Begin
			Update mb
			Set mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle,
				mb.KPILevel = Case 
							When minmaxTemp.MinMaxMiddle < mb.MinMaxRed Then 'Red' 
							When (minmaxTemp.MinMaxMiddle >= mb.MinMaxRed And minmaxTemp.MinMaxMiddle <= mb.MinMaxGreen) Then 'Amber' 
							When minmaxTemp.MinMaxMiddle > mb.MinMaxGreen Then 'Green' End
			from @SupplyChainDsdInventoryMeasuresByRegion as mb
			Inner Join (Select RegionID								
								,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
							from SupplyChain.tDsdDailyMinMax as minmax
							Where  minmax.DateID = @DateID 
							And minmax.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And minmax.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)
							And minmax.RegionID Not in (Select sr.RegionID from @SelectedRegionIDs as sr)		
							Group By RegionID) as MinMaxTemp on mb.RegionID= MinMaxTemp.RegionID
			Update mb
			Set mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle,
				mb.KPILevel = Case 
							When minmaxTemp.MinMaxMiddle < mb.MinMaxRed Then 'Red' 
							When (minmaxTemp.MinMaxMiddle >= mb.MinMaxRed And minmaxTemp.MinMaxMiddle <= mb.MinMaxGreen) Then 'Amber' 
							When minmaxTemp.MinMaxMiddle > mb.MinMaxGreen Then 'Green' End
			from @SupplyChainDsdInventoryMeasuresByRegion as mb
			Inner Join (Select RegionID								
								,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
							from SupplyChain.tDsdDailyMinMax as minmax
							Where  minmax.DateID = @DateID
							And minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)	
							And minmax.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And minmax.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)
							And minmax.RegionID  in (Select sr.RegionID from @SelectedRegionIDs as sr)		
							Group By RegionID) as MinMaxTemp on mb.RegionID= MinMaxTemp.RegionID
		End

		Select * from @SupplyChainDsdInventoryMeasuresByRegion order by BUSortOrder, RegionName

GO
Print 'Creating Procedure [SupplyChain].[pGetDsdMostImpactedPackagesForLanding] ...'
GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdMostImpactedPackagesForLanding]    Script Date: 11/19/2014 1:23:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

exec [SupplyChain].[pGetDsdMostImpactedPackagesForLanding] 20141104,'3,4,5','69,192,138,29,232,221,75,158,195,3,12,35,129,49,190,184,64,101', '46,69,138,152,118,78,129,86,64,44,150,47,70,30,124,133,61,36','MinMax'
20141014,'24,25,26,27','69', '325'
select top 10 * from sap.Package
SupplyChain.pGetDsdMostImpactedPackagesForLanding
exec [SupplyChain].[pGetDsdMostImpactedPackagesForLanding] 20141110,'1,5,12','5,11,84,85,160,161','47,97,194','22,32,44,46,47,67,68,78,79,124,129,138,140,150,151,152','DOS'
*/
CREATE PROC [SupplyChain].[pGetDsdMostImpactedPackagesForLanding] (
	@DateID INT
	,@RegionIDs VARCHAR(4000)
	,@BranchIDs varchar(4000)
	,@TrademarkIDs VARCHAR(4000)
	,@packageIDs VARCHAR(4000)
	,@MeasureType varchar(10)
	,@AggregationID INT = 0
	)
AS
SET NOCOUNT ON;

Declare @SupplyChainDsdMostImpactedPackagesByRegion Table  
			 (  
				 PackageID int  null
				,SAPPackageID varchar(10) null
				,PackageName Varchar(50) null
				,PackageTypeID int null
				,TradeMarkID int null
				--,TradeMarkName varchar(50) null
				--	,TradeMarkURL varchar(512) null
				,RegionID int null
				--,RegionName varchar(50) null
				,CaseCut int null
				,OOS Decimal(10,1) null
				,DOS Decimal(10,1) null
				,DOSEndingInventory Decimal(10,1) null
				,MinMaxMiddle Decimal(10,1) null
				,MinMaxLeftAbs int null
			    ,MinMaxMiddleAbs int null
			    ,MinMaxRightAbs int null
				
			 )

Declare @SelectedRegionIDs Table
		(
			RegionID int
		)
Declare @SelectedBranchIDs Table
		(
			BranchID int
		)
Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)

Declare @SelectedPackageIDs Table
		(
			PackageID int
		)

Insert into @SelectedRegionIDs
Select Value from dbo.Split(@RegionIDs,',')

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')

Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')


Insert into @SelectedPackageIDs
Select Value from dbo.Split(@PackageIDs,',')

Insert into @SupplyChainDsdMostImpactedPackagesByRegion (PackageID, PackageName, SAPPackageID,PackageTypeID)
	Select PackageID, Substring(PackageName,1,14) as PackageName, '', PackageTypeID  from SAP.Package Where PackageID in (Select PackageID from @SelectedPackageIDs)

	If(@MeasureType = 'OOS')
		Begin
			Update mb
			Set mb.OOS = OOSTemp.OOS,
			mb.CaseCut = OOSTemp.CaseCut,
			mb.RegionID = OOSTemp.RegionID,
			mb.TradeMarkID = OOSTemp.TradeMarkID
				from @SupplyChainDsdMostImpactedPackagesByRegion as mb
				Inner Join (Select PackageID, TradeMarkID, RegionID, ((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0)) * 100  as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
							SupplyChain.tDsdDailyCaseCut as OOS
							Where  OOS.DateID = @DateID 
							And OOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
							And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
							And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And OOS.PackageID in (Select sp.PackageID from @SelectedPackageIDs as sp)		
							Group by OOS.PackageID, OOS.TradeMarkID, OOS.RegionID
						) as OOSTemp on mb.PackageID = OOSTemp.PackageID
			 Select top 5 *
						, (Select RegionName from SAP.Region as r Where r.RegionID = mb.RegionID) as RegionName
						, (Select TradeMarkName from SAP.TradeMark as t Where t.TradeMarkID = mb.TradeMarkID) as TradeMarkName
						, (Select ImageURL from Shared.[Image]  as I Where I.ImageID  in (Select t.ImageID from SAP.TradeMark as t where t.TradeMarkID = mb.TradeMarkID)) as TradeMarkURL
						,stuff((SELECT ','+ Cast(BranchID as varchar(10)) FROM Mview.LocationHier as lh WHERE lh.RegionID = mb.RegionID And lh.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb) FOR XML PATH('')),1,1,'') as 'BranchesInRegion'
			 from @SupplyChainDsdMostImpactedPackagesByRegion as mb 
			 Where mb.OOS is not null
			 order by mb.CaseCut desc
		End
	Else If(@MeasureType = 'DOS')
		Begin
			Update mb
				Set mb.DOS = DOSTemp.DaysOfSupply,
					mb.DOSEndingInventory = DOSTemp.DOSEndingInventory,
					mb.RegionID = DOSTemp.RegionID,
					mb.TradeMarkID = DOSTemp.TradeMarkID
				from @SupplyChainDsdMostImpactedPackagesByRegion as mb
				Inner Join (Select  PackageID, TradeMarkID, RegionID
									,((SUM(dos.EndingInventoryCapped)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 31 as DaysOfSupply
									,((SUM(dos.EndingInventoryCapped)*1.0)/1000) as DOSEndingInventory
							 from SupplyChain.tDsdDailyBranchInventory as DOS 
							 Where  DOS.DateID = @DateID 
									And DOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
									And DOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
									And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
									And DOS.PackageID in (Select sp.PackageID from @SelectedPackageIDs as sp)		 
									Group by DOS.PackageID, DOS.TradeMarkID, DOS.RegionID
							) as DOSTemp   on mb.PackageID = DOSTemp.PackageID
			 Select top 5 *
						, (Select RegionName from SAP.Region as r Where r.RegionID = mb.RegionID) as RegionName
						, (Select TradeMarkName from SAP.TradeMark as t Where t.TradeMarkID = mb.TradeMarkID) as TradeMarkName
						, (Select ImageURL from Shared.[Image]  as I Where I.ImageID  in (Select t.ImageID from SAP.TradeMark as t where t.TradeMarkID = mb.TradeMarkID)) as TradeMarkURL
						,stuff((SELECT ','+ Cast(BranchID as varchar(10)) FROM Mview.LocationHier as lh WHERE lh.RegionID = mb.RegionID And lh.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb) FOR XML PATH('')),1,1,'') as 'BranchesInRegion'
			 from @SupplyChainDsdMostImpactedPackagesByRegion as mb 
			 Where mb.DOS is not null
			 order by mb.DOS desc
		End
		
	Else If(@MeasureType = 'MinMax')
		Begin
			Update mb
			Set mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle,
				mb.MinMaxLeftAbs = minmaxtemp.MinMaxLeftAbs,
				mb.MinMaxMiddleAbs = minmaxtemp.MinMaxMiddleAbs,
				mb.MinMaxRightAbs = minmaxtemp.MinMaxRightAbs,
				mb.RegionID = minmaxTemp.RegionID,
				mb.TradeMarkID = minmaxTemp.TradeMarkID
			from @SupplyChainDsdMostImpactedPackagesByRegion as mb
			Inner Join (Select  PackageID, TradeMarkID, RegionID
								,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
								,SUM(IsBelowMin) as MinMaxLeftAbs
								,SUM(IsCompliant) as MinMaxMiddleAbs
								,SUM(IsAboveMax) as MinMaxRightAbs
								from SupplyChain.tDsdDailyMinMax as minmax
								 Where  minmax.DateID = @DateID 
										And minmax.RegionID in (Select RegionID from @SelectedRegionIDs)
										And minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
										And minmax.TradeMarkID in (Select TradeMarkID from @SelectedTradeMarkIDs)	
										And minmax.PackageID in (Select PackageID from @SelectedPackageIDs)	
										Group by minmax.PackageID, minmax.TradeMarkID, minmax.RegionID
						) as minmaxTemp   on mb.PackageID = minmaxTemp.PackageID
			 Select top 5 *
						, (Select RegionName from SAP.Region as r Where r.RegionID = mb.RegionID) as RegionName
						, (Select TradeMarkName from SAP.TradeMark as t Where t.TradeMarkID = mb.TradeMarkID) as TradeMarkName
						, (Select ImageURL from Shared.[Image]  as I Where I.ImageID  in (Select t.ImageID from SAP.TradeMark as t where t.TradeMarkID = mb.TradeMarkID)) as TradeMarkURL
						,stuff((SELECT ','+ Cast(BranchID as varchar(10)) FROM Mview.LocationHier as lh WHERE lh.RegionID = mb.RegionID And lh.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb) FOR XML PATH('')),1,1,'') as 'BranchesInRegion'
			 from @SupplyChainDsdMostImpactedPackagesByRegion as mb
			 Where mb.MinMaxMiddle is not null
			 order by mb.MinMaxMiddle Asc
		End


GO
Print 'Creating Procedure [SupplyChain].[pGetDsdMostImpactedPackageTypesByBranch] ...'
GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdMostImpactedPackageTypesByBranch]    Script Date: 11/19/2014 1:23:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
exec [SupplyChain].[pGetDsdMostImpactedPackageTypesByBranch] 20141014,'8,11,12,13,14,15,18,19,21,25,29,33,35,36,37,42,44,47,48,50,52,53,54,58','69,192,138,29,232,221,75,158,195,3,12,35,129,49,190,184,64,101', '46,69,138,152,118,78,129,86,64,44,150,47,70,30,124,133,61,36','MinMax'
select top 10 * from sap.Package

*/
CREATE PROC [SupplyChain].[pGetDsdMostImpactedPackageTypesByBranch] (
	@DateID INT
	,@BranchIDs VARCHAR(4000)
	,@TrademarkIDs VARCHAR(4000)
	,@packageTypeIDs VARCHAR(4000)
	,@MeasureType Varchar(20)
	,@AggregationID INT = 0
	)
AS
SET NOCOUNT ON;

Declare @SupplyChainDsdMostImpactedPackagesByBranch Table  
			 (  
				 PackageTypeID int  null
				,SAPPackageTypeID varchar(10) null
				,PackageTypeName Varchar(50) null
				,CaseCut int null
				,OOS Decimal(10,1) null
				,DOS Decimal(10,1) null
				,MinMaxMiddle Decimal(10,1) null
			 )

Declare @SelectedBranchIDs Table
		(
			BranchID int
		)

Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)

Declare @SelectedPackageTypeIDs Table
		(
			PackageTypeID int
		)

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')

Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')


Insert into @SelectedPackageTypeIDs
Select Value from dbo.Split(@PackageTypeIDs,',')

Insert into @SupplyChainDsdMostImpactedPackagesByBranch (PackageTypeID, PackageTypeName, SAPPackageTypeID)
	Select PackageTypeID, PackageTypeName, SAPPackageTypeID from SAP.PackageType Where PackageTypeID in (Select PackageTypeID from @SelectedPackageTypeIDs)

If(@MeasureType = 'OOS')
	Begin
		Update mb
		Set mb.OOS = OOSTemp.OOS,
		mb.CaseCut = OOSTemp.CaseCut
			from @SupplyChainDsdMostImpactedPackagesByBranch as mb
		 Inner Join (Select PackageTypeID, ((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0))*100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
						SupplyChain.tDsdDailyCaseCut as OOS
						Where  OOS.DateID = @DateID 
						And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
						And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
						And OOS.PackageTYpeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		
						Group by OOS.PackageTypeID) as OOSTemp on mb.PackageTypeID = OOSTemp.PackageTypeID
			Select * 
			from @SupplyChainDsdMostImpactedPackagesByBranch as mb
				Where mb.OOS is not null	
				Order by mb.OOS Desc
	End
Else If(@MeasureType = 'DOS')
	Begin
		Update mb
			Set mb.DOS = DOSTemp.DaysOfSupply
			from @SupplyChainDsdMostImpactedPackagesByBranch as mb
			Inner Join (Select PackageTypeID,((SUM(dos.EndingInventoryCapped)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 31 as DaysOfSupply
						 from SupplyChain.tDsdDailyBranchInventory as DOS 
						 Where  DOS.DateID = @DateID 
							And DOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
							And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And DOS.PackageTYpeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		 
							Group by DOS.PackageTypeID) as DOSTemp   on mb.PackageTypeID = DOSTemp.PackageTypeID
		Select * 
			from @SupplyChainDsdMostImpactedPackagesByBranch as mb
				Where mb.DOS is not null	
				Order by mb.DOS Desc
	End
Else If(@MeasureType = 'MinMax')
	Begin
		Update mb
			Set mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle
			from @SupplyChainDsdMostImpactedPackagesByBranch as mb
			Inner Join (Select PackageTypeID 
								,((SUm(minMax.IsBelowMin) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxLeft
								,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
								, ((SUm(minMax.IsAboveMax) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxRight
								from SupplyChain.tDsdDailyMinMax as minmax
								 Where  minmax.DateID = @DateID 
										And  minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
										And minmax.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
										And minmax.PackageTYpeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		
										Group by minmax.PackageTypeID
						) as minmaxTemp   on mb.PackageTypeID = minmaxTemp.PackageTypeID
		Select * 
			from @SupplyChainDsdMostImpactedPackagesByBranch as mb
				Where mb.MinMaxMiddle is not null	
				Order by mb.MinMaxMiddle

	End

GO
Print 'Creating Procedure [SupplyChain].[pGetDsdMostImpactedPackageTypesByRegion] ...'
GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdMostImpactedPackageTypesByRegion]    Script Date: 11/19/2014 1:23:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

exec [SupplyChain].[pGetDsdMostImpactedPackageTypesByRegion] 20141014,'3,4,5','69,192,138,29,232,221,75,9,158,195,3,12,35,129,49,190,184,67', '46,69,138,175,152,118,78,129,86,64,38,44,150,47,70,30,124','MinMax'
20141014,'24,25,26,27','69', '325'
select top 10 * from sap.Package

*/
CREATE PROC [SupplyChain].[pGetDsdMostImpactedPackageTypesByRegion] (
	@DateID INT
	,@RegionIDs VARCHAR(4000)
	,@BranchIDs VARCHAR(4000)
	,@TrademarkIDs VARCHAR(4000)
	,@packageTypeIDs VARCHAR(4000)
	,@MeasureType varchar(20)
	,@AggregationID INT = 0
	)
AS
SET NOCOUNT ON;

Declare @SupplyChainDsdMostImpactedPackagesByRegion Table  
			 (  
				 PackageTypeID int  null
				,SAPPackageTypeID varchar(10) null
				,PackageTypeName Varchar(50) null
				,CaseCut int null
				,OOS Decimal(10,1) null
				,DOS Decimal(10,1) null
				,MinMaxMiddle Decimal(10,1) null
			 )

Declare @SelectedRegionIDs Table
		(
			RegionID int
		)
Declare @SelectedBranchIDs Table
(
	BranchID int
)
Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)

Declare @SelectedPackageTypeIDs Table
		(
			PackageTypeID int
		)

Insert into @SelectedRegionIDs
Select Value from dbo.Split(@RegionIDs,',')

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')


Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')


Insert into @SelectedPackageTypeIDs
Select Value from dbo.Split(@PackageTypeIDs,',')

Insert into @SupplyChainDsdMostImpactedPackagesByRegion (PackageTypeID, PackageTypeName, SAPPackageTypeID)
	Select PackageTypeID, PackageTypeName, SAPPackageTypeID  from SAP.PackageType Where PackageTypeID in (Select PackageTypeID from @SelectedPackageTypeIDs)
If(@MeasureType = 'OOS')
	Begin
		Update mb
				Set mb.OOS = OOSTemp.OOS,
				mb.CaseCut = OOSTemp.CaseCut
					from @SupplyChainDsdMostImpactedPackagesByRegion as mb
				 Inner Join (Select PackageTypeID, ((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0))*100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
								SupplyChain.tDsdDailyCaseCut as OOS
								Where  OOS.DateID = @DateID 
								And OOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
								And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
								And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
								And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		
								Group by OOS.PackageTypeID
							) as OOSTemp on mb.PackageTypeID = OOSTemp.PackageTypeID
			Select * 
			from @SupplyChainDsdMostImpactedPackagesByRegion as mb
				Where mb.OOS is not null	
				Order by mb.OOS Desc
	End
Else If(@MeasureType = 'DOS')
	Begin
		Update mb
				Set mb.DOS = DOSTemp.DaysOfSupply
				from @SupplyChainDsdMostImpactedPackagesByRegion as mb
				Inner Join (Select PackageTypeID,((SUM(dos.EndingInventoryCapped)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 31 as DaysOfSupply
							 from SupplyChain.tDsdDailyBranchInventory as DOS 
							 Where  DOS.DateID = @DateID 
									And DOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
									And DOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
									And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
									And DOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		 
									Group by DOS.PackageTypeID
							) as DOSTemp   on mb.PackageTypeID = DOSTemp.PackageTypeID
		Select * 
			from @SupplyChainDsdMostImpactedPackagesByRegion as mb
				Where mb.DOS is not null	
				Order by mb.DOS Desc
	End
Else If(@MeasureType = 'MinMax')
	Begin
		Update mb
		Set mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle
		from @SupplyChainDsdMostImpactedPackagesByRegion as mb
		Inner Join (Select PackageTypeID
							,((SUm(minMax.IsBelowMin) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxLeft
							,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
							, ((SUm(minMax.IsAboveMax) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxRight
							from SupplyChain.tDsdDailyMinMax as minmax
							 Where  minmax.DateID = @DateID 
									And minmax.RegionID in (Select RegionID from @SelectedRegionIDs)
									And minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
									And minmax.TradeMarkID in (Select TradeMarkID from @SelectedTradeMarkIDs)	
									And minmax.PackageTypeID in (Select PackageTypeID from @SelectedPackageTypeIDs)	
									Group by minmax.PackageTypeID
					) as minmaxTemp   on mb.PackageTypeID = minmaxTemp.PackageTypeID
			Select * 
			from @SupplyChainDsdMostImpactedPackagesByRegion as mb
				Where mb.MinMaxMiddle is not null	
				Order by mb.MinMaxMiddle

	End

GO
Print 'Creating Procedure [SupplyChain].[pGetDsdMostImpactedTrademarksByBranch] ...'
GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdMostImpactedTrademarksByBranch]    Script Date: 11/19/2014 1:23:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

exec [SupplyChain].[pGetDsdMostImpactedTrademarksByBranch] 20141014,'8,11,12,13,14,15,18,19,21,25,29,33,35,36,37,42,44,47,48,50,52,53,54,58','69,192,138,29,232,221,75,158,195,3,12,35,129,49,190,184,64,101', '46,69,138,152,118,78,129,86,64,44,150,47,70,30,124,133,61,36','MinMax'
20141014,'24,25,26,27','69', '325'
select top 10 * from sap.Package

*/
CREATE PROC [SupplyChain].[pGetDsdMostImpactedTrademarksByBranch] (
	@DateID INT
	,@BranchIDs VARCHAR(4000)
	,@TrademarkIDs VARCHAR(4000)
	,@packageTypeIDs VARCHAR(4000)
	,@MeasureType Varchar(20)
	,@AggregationID INT = 0
	)
AS
SET NOCOUNT ON;

Declare @SupplyChainDsdMostImpactedTrademarksByBranch Table  
			 (  
				 TradeMarkID int  null
				,SAPTradeMarkID varchar(10) null
				,TradeMarkName Varchar(50) null
				,CaseCut int null
				,OOS Decimal(10,1) null
				,DOS Decimal(10,1) null
				,MinMaxMiddle Decimal(10,1) null
			 )

Declare @SelectedBranchIDs Table
		(
			BranchID int
		)

Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)

Declare @SelectedPackageTypeIDs Table
		(
			PackageTypeID int
		)

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')

Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')


Insert into @SelectedPackageTypeIDs
Select Value from dbo.Split(@PackageTypeIDs,',')

Insert into @SupplyChainDsdMostImpactedTrademarksByBranch (TradeMarkID, TradeMarkName, SAPTradeMarkID)
	Select TradeMarkID, TradeMarkName, SAPTradeMarkID  from SAP.TradeMark Where TradeMarkID in (Select TradeMarkID from @SelectedTradeMarkIDs)

If(@MeasureType = 'OOS')
	Begin
		Update mb
				Set mb.OOS = OOSTemp.OOS,
				mb.CaseCut = OOSTemp.CaseCut
					from @SupplyChainDsdMostImpactedTrademarksByBranch as mb
				 Inner Join (Select TradeMarkID, ((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0))*100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
								SupplyChain.tDsdDailyCaseCut as OOS
								Where  OOS.DateID = @DateID 
								And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
								And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
								And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		
								Group by OOS.TradeMarkID) as OOSTemp on mb.TradeMarkID = OOSTemp.TradeMarkID
		Select * 
			from @SupplyChainDsdMostImpactedTrademarksByBranch as mb
				Where mb.OOS is not null	
				Order by mb.OOS Desc
	End
Else If(@MeasureType = 'DOS')
	Begin
		Update mb
			Set mb.DOS = DOSTemp.DaysOfSupply
			from @SupplyChainDsdMostImpactedTrademarksByBranch as mb
			Inner Join (Select TradeMarkID,((SUM(dos.EndingInventoryCapped)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 31 as DaysOfSupply
					 from SupplyChain.tDsdDailyBranchInventory as DOS 
					 Where  DOS.DateID = @DateID 
						And  DOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
						And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
						And DOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		 
						Group by DOS.TradeMarkID) as DOSTemp   on mb.TradeMarkID = DOSTemp.TradeMarkID
			Select * 
			from @SupplyChainDsdMostImpactedTrademarksByBranch as mb
				Where mb.DOS is not null	
				Order by mb.DOS Desc
	End
Else If(@MeasureType = 'MinMax')
	Begin
		Update mb
		Set mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle
		from @SupplyChainDsdMostImpactedTrademarksByBranch as mb
		Inner Join (Select TradeMarkID
							,((SUm(minMax.IsBelowMin) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxLeft
							,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
							, ((SUm(minMax.IsAboveMax) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxRight
							from SupplyChain.tDsdDailyMinMax as minmax
							Where  minmax.DateID = @DateID 
							And  minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
							And minmax.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And minmax.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)	
							Group by minmax.TradeMarkID
				  ) as minmaxTemp   on mb.TradeMarkID = minmaxTemp.TradeMarkID
		Select * 
			from @SupplyChainDsdMostImpactedTrademarksByBranch as mb
				Where mb.MinMaxMiddle is not null	
				Order by mb.MinMaxMiddle
	End

GO
Print 'Creating Procedure [SupplyChain].[pGetDsdMostImpactedTrademarksByRegion] ...'
GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdMostImpactedTrademarksByRegion]    Script Date: 11/19/2014 1:23:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

exec [SupplyChain].[pGetDsdMostImpactedTrademarksByRegion] 20141014,'3,4,5','69,192,138,29,232,221,75,9,158,195,3,12,35,129,49,190,184,67', '46,69,138,175,152,118,78,129,86,64,38,44,150,47,70,30,124', 'MinMax'
20141014,'24,25,26,27','69', '325'
select top 10 * from sap.Package

*/
CREATE PROC [SupplyChain].[pGetDsdMostImpactedTrademarksByRegion] (
	@DateID INT
	,@RegionIDs VARCHAR(4000)
	,@BranchIDs VARCHAR(4000)
	,@TrademarkIDs VARCHAR(4000)
	,@packageTypeIDs VARCHAR(4000)
	,@MeasureType Varchar(20)
	,@AggregationID INT = 0
	)
AS
SET NOCOUNT ON;

Declare @SupplyChainDsdMostImpactedTrademarksByRegion Table  
			 (  
				 TrademarkID int  null
				,SAPTrademarkID varchar(10) null
				,TrademarkName Varchar(50) null
				,CaseCut int null
				,OOS Decimal(10,1) null
				,DOS Decimal(10,1) null
				,MinMaxMiddle Decimal(10,1) null
			 )

Declare @SelectedRegionIDs Table
		(
			RegionID int
		)

Declare @SelectedBranchIDs Table
		(
			BranchID int
		)
Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)

Declare @SelectedPackageTypeIDs Table
		(
			PackageTypeID int
		)

Insert into @SelectedRegionIDs
Select Value from dbo.Split(@RegionIDs,',')

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')

Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')


Insert into @SelectedPackageTypeIDs
Select Value from dbo.Split(@PackageTypeIDs,',')

Insert into @SupplyChainDsdMostImpactedTrademarksByRegion (TrademarkID, TrademarkName, SAPTrademarkID)
	Select TrademarkID, TrademarkName, SAPTradeMarkID  from SAP.Trademark Where TrademarkID in (Select TrademarkID from @SelectedTrademarkIDs)
If(@MeasureType = 'OOS')
	Begin
		Update mb
				Set mb.OOS = OOSTemp.OOS,
				mb.CaseCut = OOSTemp.CaseCut
					from @SupplyChainDsdMostImpactedTrademarksByRegion as mb
				 Inner Join (Select TrademarkID, ((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0))*100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
								SupplyChain.tDsdDailyCaseCut as OOS
								Where  OOS.DateID = @DateID 
								And OOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
								And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
								And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
								And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		
								Group by OOS.TrademarkID) as OOSTemp on mb.TrademarkID = OOSTemp.TrademarkID
		Select * 
			from @SupplyChainDsdMostImpactedTrademarksByRegion as mb
				Where mb.OOS is not null	
				Order by mb.CaseCut Desc
	 End
Else If(@MeasureType = 'DOS')
	Begin
		Update mb
				Set mb.DOS = DOSTemp.DaysOfSupply
				from @SupplyChainDsdMostImpactedTrademarksByRegion as mb
				Inner Join (Select TrademarkID,((SUM(dos.EndingInventoryCapped)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 31 as DaysOfSupply
 							 from SupplyChain.tDsdDailyBranchInventory as DOS 
							 Where  DOS.DateID = @DateID 
								And DOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
								And DOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
								And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
								And DOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		 
								Group by DOS.TrademarkID) as DOSTemp   on mb.TrademarkID = DOSTemp.TrademarkID
		Select * 
			from @SupplyChainDsdMostImpactedTrademarksByRegion as mb
				Where mb.DOS is not null	
				Order by mb.DOS Desc
	End
Else If(@MeasureType = 'MinMax')
	Begin
		Update mb
		Set mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle
		from @SupplyChainDsdMostImpactedTrademarksByRegion as mb
		Inner Join (Select TrademarkID
							,((SUm(minMax.IsBelowMin) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxLeft
							,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
							, ((SUm(minMax.IsAboveMax) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxRight
							from SupplyChain.tDsdDailyMinMax as minmax
							 Where  minmax.DateID = @DateID 
							 And minmax.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
							 And minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
							And minmax.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And minmax.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)	
							Group by minmax.TrademarkID
					) as minmaxTemp   on mb.TrademarkID = minmaxTemp.TrademarkID
		Select * 
			from @SupplyChainDsdMostImpactedTrademarksByRegion as mb
				Where mb.MinMaxMiddle is not null	
				Order by mb.MinMaxMiddle
	End

GO
Print 'Creating Procedure [SupplyChain].[pGetDsdOverAllScoresForLanding] ...'
GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdOverAllScoresForLanding]    Script Date: 11/19/2014 1:23:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
26.SupplyChain.pGetDsdOverAllScoresForLanding
exec [SupplyChain].[pGetDsdOverAllScoresForLanding] 20141103,'3,4,5', '42,43,44,45,46,47,48,49,50,51,52', '69,192,138,29,232,221,75,9,158,195,3,12,35,129,49,190,184,67', '46,69,138,175,152,118,78,129,86,64,38,44,150,47,70,30,124', 'MinMax'
20141014,'24,25,26,27','69', '325'
exec [SupplyChain].[pGetDsdInventoryBranchMeasuresForLanding] 20141106,'1,2,3,4,5,6,7,8,9,11,12,14','1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,167,168,169,170,172,173,174', '1,3,5,20,22,33,59,35,37,60,44,61,46,49,50,51,65,67,68,34,64,89,173,54,97,129,130,154,187,216,228','22,27,30,33,38,39,44,46,47,51,59,62,63,64,67,68,77,78,79,86,90,94,108,117,124,129,133,134,138,139,140,143,145,146,150,151,152,154','DOS'
select top 10 * from sap.Package
SupplyChain.pGetDsdOverAllScoresForLanding
exec [SupplyChain].[pGetDsdOverAllScoresForLanding] 20141110,'1,5,12','5,11,84,85,160,161','47,97,194','22,32,44,46,47,67,68,78,79,124,129,138,140,150,151,152','OOS'
*/
CREATE PROC [SupplyChain].[pGetDsdOverAllScoresForLanding] (
	@DateID INT
	,@RegionIDs VARCHAR(4000)
	,@BranchIDs varchar(4000)
	,@TrademarkIDs VARCHAR(4000)
	,@PackageIDs VARCHAR(4000)
	,@MeasureType varchar(10)
	,@AggregationID INT = 0
	)
AS
SET NOCOUNT ON;

Declare @SupplyChainDsdOverAllScoresForLanding Table  
			 (  
				 ProductLineID int null
				,ProductLineName varchar(50) null
				,CaseCut int null
				,OOS Decimal(10,1) null
				,DOS Decimal(10,1) null
				,DOSCases int null
				,MinMaxLeft Decimal(10,1) null
				,MinMaxMiddle Decimal(10,1) null
				,MinMaxRight Decimal(10,1) null
				,OOSRed Decimal(10,1) null
				,OOSGreen Decimal(10,1) null
				,DOSRed Decimal(10,1) null
				,DOSGreen Decimal(10,1) null
				,MinMaxRed Decimal(10,1) null
				,MinMaxGreen Decimal(10,1) null
			 )

Declare @SelectedRegionIDs Table
		(
			RegionID int
		)

Declare @SelectedBranchIDs Table
		(
			BranchID int
		)

Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)

Declare @SelectedPackageTypeIDs Table
		(
			PackageTypeID int
		)

Insert into @SelectedRegionIDs
Select Value from dbo.Split(@RegionIDs,',')

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')

Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')


Insert into @SelectedPackageTypeIDs
Select Value from dbo.Split(@PackageIDs,',')

--- These Records are for Product Lines
Insert into @SupplyChainDsdOverAllScoresForLanding (ProductLineID, ProductLineName, OOSRed, OOSGreen, DOSRed, DOSGreen, MinMaxRed, MinMaxGreen)
	Select pl.ProductLineID, pl.ProductLineName,OAT.OverAllOOSLeftThreshold, OAT.OverAllOOSRightThreshold, OAT.OverAllDOSLeftThreshold, OAT.OverAllDOSRightThreshold, OAT.OverAllMinMaxLeftThreshold, OAT.OverAllMinMaxRightThreshold  from SAP.ProductLine as pl cross join SupplyChain.OverAllThreshold as OAT
	Union
	Select -1,'OverAll',OAT.OverAllOOSLeftThreshold, OAT.OverAllOOSRightThreshold, OAT.OverAllDOSLeftThreshold, OAT.OverAllDOSRightThreshold, OAT.OverAllMinMaxLeftThreshold, OAT.OverAllMinMaxRightThreshold  from SupplyChain.OverAllThreshold as OAT
---- This one is for Over All Scores

	If(@MeasureType = 'OOS')
		Begin
			Update mb
			Set mb.OOS = OOSTemp.OOS,
			mb.CaseCut = OOSTemp.CaseCut
				from @SupplyChainDsdOverAllScoresForLanding as mb
				Inner Join (Select ProductLineID, ((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0)) * 100  as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
							SupplyChain.tDsdDailyCaseCut as OOS
							Where  OOS.DateID = @DateID 
							And OOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
							And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
							And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		
							Group by OOS.ProductLineID
						) as OOSTemp on mb.ProductLineID = OOSTemp.ProductLineID
			Update mb
			Set mb.OOS = OOSTemp.OOS,
			mb.CaseCut = OOSTemp.CaseCut,
			mb.ProductLineID = OOSTemp.OverAllID
				from @SupplyChainDsdOverAllScoresForLanding as mb
				Inner Join (Select -1 as OverAllID, ((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0)) * 100  as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
							SupplyChain.tDsdDailyCaseCut as OOS
							Where  OOS.DateID = @DateID 
							And OOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
							And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
							And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)
						) as OOSTemp on mb.ProductLineID = OOSTemp.OverAllID


			 Select * from @SupplyChainDsdOverAllScoresForLanding
		End
	Else If(@MeasureType = 'DOS')
		Begin
			Update mb
				Set mb.DOS = DOSTemp.DaysOfSupply
					,mb.DOSCases = DOSTemp.DOSCases
				from @SupplyChainDsdOverAllScoresForLanding as mb
				Inner Join (Select  ProductLineID,((SUM(dos.EndingInventoryCapped)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 31 as DaysOfSupply, SUM(dos.EndingInventoryCapped) as DOSCases
							 from SupplyChain.tDsdDailyBranchInventory as DOS 
							 Where  DOS.DateID = @DateID 
									And DOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
									And DOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
									And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
									And DOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		 
									Group by DOS.ProductLineID
							) as DOSTemp   on mb.ProductLineID = DOSTemp.ProductLineID
			Update mb
				Set mb.DOS = DOSTemp.DaysOfSupply
					,mb.DOSCases = DOSTemp.DOSCases
					,mb.ProductLineID = DOSTemp.OverAllID
				from @SupplyChainDsdOverAllScoresForLanding as mb
				Inner Join (Select  -1 as OverAllID,((SUM(dos.EndingInventoryCapped)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 31 as DaysOfSupply, SUM(dos.EndingInventoryCapped) as DOSCases
							 from SupplyChain.tDsdDailyBranchInventory as DOS 
							 Where  DOS.DateID = @DateID 
									And DOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
									And DOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
									And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
									And DOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		 
									Group by DOS.ProductLineID
							) as DOSTemp   on mb.ProductLineID = DOSTemp.OverAllID
			 Select * from @SupplyChainDsdOverAllScoresForLanding
		End
		
	Else If(@MeasureType = 'MinMax')
		Begin
			Update mb
			Set  mb.MinMaxLeft = minmaxTemp.MinMaxLeft
				,mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle
				,mb.MinMaxRight = minmaxTemp.MinMaxRight
			from @SupplyChainDsdOverAllScoresForLanding as mb
			Inner Join (Select   ProductLineID
								,((SUm(minMax.IsBelowMin) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxLeft
								,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
								,((SUm(minMax.IsAboveMax) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxRight
								from SupplyChain.tDsdDailyMinMax as minmax
								 Where  minmax.DateID = @DateID 
										And minmax.RegionID in (Select RegionID from @SelectedRegionIDs)
										And minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
										And minmax.TradeMarkID in (Select TradeMarkID from @SelectedTradeMarkIDs)	
										And minmax.PackageTypeID in (Select PackageTypeID from @SelectedPackageTypeIDs)	
										Group by minmax.ProductLineID
						) as minmaxTemp   on mb.ProductLineID = minmaxTemp.ProductLineID
			Update mb
			Set mb.MinMaxLeft = minmaxTemp.MinMaxLeft
				,mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle
				,mb.MinMaxRight = minmaxTemp.MinMaxRight
				,mb.ProductLineID = minmaxTemp.OverAllID
			from @SupplyChainDsdOverAllScoresForLanding as mb
			Inner Join (Select   -1 as OverAllID
								,((SUm(minMax.IsBelowMin) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxLeft
								,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
								,((SUm(minMax.IsAboveMax) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxRight
								from SupplyChain.tDsdDailyMinMax as minmax
								 Where  minmax.DateID = @DateID 
										And minmax.RegionID in (Select RegionID from @SelectedRegionIDs)
										And minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
										And minmax.TradeMarkID in (Select TradeMarkID from @SelectedTradeMarkIDs)	
										And minmax.PackageTypeID in (Select PackageTypeID from @SelectedPackageTypeIDs)	
										Group by minmax.ProductLineID
						) as minmaxTemp   on mb.ProductLineID = minmaxTemp.OverAllID
			 Select * from @SupplyChainDsdOverAllScoresForLanding
		End


GO
