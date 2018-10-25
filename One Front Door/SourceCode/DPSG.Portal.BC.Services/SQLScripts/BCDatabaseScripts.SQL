Begin tran
go

--Creating Schema
Create Schema [BCMyday]
go

USE [Portal_Data]
GO
/****** Object:  StoredProcedure [BCMyday].[pGetBottlers]    Script Date: 6/26/2014 10:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [BCMyday].[pGetBottlers]
(
@lastmodified Date = null   
)
As
Begin
	If ISNULL(@lastmodified, '') = ''
	BEGIN
		SELECT TOP 10 BottlerID, BottlerName, ChannelID, GlobalStatusID, BCRegionID, Address, City,
		County, State, PostalCode, Country, Email, PhoneNumber, Longitude, 	Latitude, LastModified,	Active  
		FROM BC.Bottler
--		WHERE Active = 1  
	END
	Else
	BEGIN
		SELECT BottlerID, BottlerName, ChannelID, GlobalStatusID, BCRegionID, Address, City,
		County, State, PostalCode, Country, Email, PhoneNumber, Longitude, 	Latitude, LastModified,	Active  
		FROM BC.Bottler
		WHERE --Active=1 
		LastModified >= @lastmodified
	END
End 



GO
/****** Object:  StoredProcedure [BCMyday].[pGetBrandDetails]    Script Date: 6/26/2014 10:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- BCMday.pGetBrandDetails  
CREATE Procedure [BCMyday].[pGetBrandDetails]  
As  
Begin  
  
SELECT TOP 50 TRADEMARK.TradeMarkID,  
       TradeMarkName,  
       BrandID,  
       BrandName  
  
FROM sap.trademark  TRADEMARK  
INNER JOIN sap.brand BRAND  
On  TRADEMARK.TradeMarkID= BRAND.TradeMarkID  
  
End


GO
/****** Object:  StoredProcedure [BCMyday].[pGetCustomerHierarchy]    Script Date: 6/26/2014 10:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


      
--  BCMyday.[pGetCustomerHierarchy] '2013-05-18 12:21:00'                    
CREATE Procedure [BCMyday].[pGetCustomerHierarchy]        
(                    
   @lastmodified Date = null                   
)                     
As                      
Begin                      
                     
 If ISNULL(@lastmodified, '') = ''                         
Begin                    
                    
SELECT  SAPNationalChainID,
        NationalChainID,
        NationalChainName
       -- IsActive,
       -- IsDeleted 
        FROM SAP.NationalChain 
		--WHERE IsActive=1
                             
SELECT  SAPRegionalChainID,
        NationalChainID,
        RegionalChainID,
        RegionalChainName
       -- IsActive,
       -- IsDeleted
        FROM SAP.RegionalChain  
		--WHERE IsActive=1                      
        
SELECT  SAPLocalChainID,
        RegionalChainID,
        LocalChainID,
        LocalChainName
      --  IsActive,
      --  IsDeleted 
FROM SAP.LocalChain  
--WHERE IsActive=1
                    
SELECT  ChannelID,
        SuperChannelID,
        SAPChannelID,
        ChannelName
     --   IsActive,
     --   IsDeleted 
        FROM  SAP.Channel
		-- WHERE IsActive=1
              
SELECT SuperChannelID,
       SAPSuperChannelID,
       SuperChannelName
     --  IsActive,
     --  IsDeleted
       FROM SAP.SuperChannel  
	   --WHERE IsActive=1    
End                    
                    
Else                    
Begin                    
                    
SELECT   SAPNationalChainID,
         NationalChainID,
         NationalChainName  
        -- IsActive,
       --  IsDeleted    
FROM SAP.NationalChain                    
WHERE    LastModified >= @lastmodified -- AND IsActive=1                          
                     
SELECT  SAPRegionalChainID,
        NationalChainID,
        RegionalChainID,    
        RegionalChainName
      --  IsActive,
      --  IsDeleted    
FROM    SAP.RegionalChain 
WHERE LastModified >= @lastmodified 
--AND IsActive=1                                              
                     
SELECT  SAPLocalChainID,
        RegionalChainID,
        LocalChainID,
        LocalChainName 
      --  IsActive,
      --  IsDeleted    
        FROM SAP.LocalChain                     
WHERE LastModified >= @lastmodified 
 --ND IsActive=1                                              
      
SELECT  ChannelID,
        SuperChannelID,
        SAPChannelID,
        ChannelName
       -- IsActive,
       -- IsDeleted    
FROM  SAP.Channel
--WHERE IsActive=1                                
    
SELECT SuperChannelID,
       SAPSuperChannelID,
       SuperChannelName
     --  IsActive,
     --  IsDeleted    
FROM SAP.SuperChannel      
--WHERE IsActive=1                                
                    
                    
End                    
                    
                      
End 



GO
/****** Object:  StoredProcedure [BCMyday].[pGetLOSMaster]    Script Date: 6/26/2014 10:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                 
-- BCMyday.pGetLOSMaster ''                      
CREATE Procedure [BCMyday].[pGetLOSMaster]                      
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
    
    
                        
End   

GO
/****** Object:  StoredProcedure [BCMyday].[pGetProductHierarchy]    Script Date: 6/26/2014 10:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


          
--BCMyday.pGetProductHierarchy  '2014-01-01'              
CREATE Procedure [BCMyday].[pGetProductHierarchy]                  
(                
 @lastmodified Date = null                    
)                
As                  
Begin                  
                  
 If ISNULL(@lastmodified, '') = ''                        
              
Begin                
SELECT BrandID,
       BrandName,
       LastModified
      -- IsActive,
      -- IsDeleted 
FROM  SAP.Brand 
--WHERE  IsActive=1                
                  
SELECT PackageID,
       PackageName,
	   RMPackageID,
       LastModified,
       Active
       --IsDeleted 
FROM  SAP.Package  
WHERE  Active=1                
                  
SELECT TradeMarkID,
       TradeMarkName,
       LastModified
      -- IsActive,
      -- IsDeleted 
FROM  SAP.TradeMark 
--WHERE  IsActive=1                 
                
End                
                
Else                
Begin                
                
SELECT  BrandID,
        BrandName,
        LastModified
      --  IsActive,
       -- IsDeleted 
FROM  SAP.Brand                  
WHERE LastModified >= @lastmodified    
--AND  IsActive=1             
                  
SELECT  PackageID,
        PackageName,
        LastModified,
        Active
       -- IsDeleted 
FROM  SAP.Package                  
WHERE LastModified >= @lastmodified                 
--AND Active=1                
                
SELECT  TradeMarkID,
        TradeMarkName,
        LastModified
     --   IsActive,
      --  IsDeleted 
FROM  SAP.TradeMark                  
WHERE LastModified > @lastmodified   
--AND  IsActive=1              
                
End                
                
                  
End




GO
/****** Object:  StoredProcedure [BCMyday].[pGetSalesAccountabilityMaster]    Script Date: 6/26/2014 10:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


          
-- BCMyDay.pGetSalesAccountabilityMaster          
CREATE procedure [BCMyday].[pGetSalesAccountabilityMaster]          
(          
  @lastmodified Date = null                  
)          
As          
Begin          
          
 If ISNULL(@lastmodified, '') = ''                          
 Begin          
           
 SELECT 
 BCSalesAccountabilityID,          
 GSN,          
 TotalCompanyID,          
 CountryID,          
 SystemID,          
 ZoneID,          
 DivisionID,          
 RegionID,          
 IsPrimary
 --IsActive,      
 --IsDeleted         
 FROM person.BCSalesAccountability          
 --WHERE IsActive=1
           
 End          
           
 ELSE 
          
 Begin          
           
 SELECT           
 BCSalesAccountabilityID,          
 GSN,          
 TotalCompanyID,           
 CountryID,          
 SystemID,          
 ZoneID,          
 DivisionID,          
 RegionID,          
 IsPrimary
 --IsActive,      
 --IsDeleted  
        
 FROM person.BCSalesAccountability                     
 WHERE LastModified > @lastmodified          
 --AND IsActive=1        
                      
 End            
 
End



GO
/****** Object:  StoredProcedure [BCMyday].[pGetSalesHierarchy]    Script Date: 6/26/2014 10:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--  BCMyDay.pGetSalesHierarchy  '2013-01-01'           
CREATE procedure [BCMyday].[pGetSalesHierarchy]              
(              
	@lastmodified Date = null                      
)              
As              
Begin              

Declare @Systems varchar(30)  
select @Systems = value from BCMyday.Config where [Key]='Systems'  
              
 If ISNULL(@lastmodified, '') = ''                              
 Begin              
               
 SELECT  TotalCompanyID,
         BCNodeID,
         TotalCompanyName,
         LastModified   
        -- Active  
 FROM BC.TotalCompany  
-- WHERE Active=1             
               
 SELECT CountryID,              
        BCNodeID,              
        CountryName,              
        TotalCompanyID,          
        LastModified     
       -- Active              
        FROM BC.Country 
		--WHERE Active=1              
                      
	SELECT SystemID,              
       BCNodeID,              
       SystemName,              
       CountryID,          
       LastModified,
		Active  
    FROM BC.System  
	where charindex(BCNodeID, @Systems, 1) > 0
	and Active=1   
	--and systemid not in ()          
                     
SELECT  ZoneID,              
       BCNodeID,              
       ZoneName,              
       SystemID,          
       LastModified,
       Active  
       FROM BC.Zone  
	   WHERE Active=1             
              
SELECT  DivisionID,              
       BCNodeID,              
       DivisionName,              
       ZoneID,          
       LastModified ,
        Active                     
       FROM BC.Division 
	   WHERE Active=1              
       
SELECT RegionID,              
       BCNodeID,              
       RegionName,              
       DivisionID,          
       LastModified      ,
      Active  
       FROM BC.Region  
	   WHERE Active=1             
             
--SELECT TotalCompanyName,              
--       TotalCompanyID,              
--       HierType,              
--       CountryName,              
--       CountryID,              
--       SystemName,              
--       SystemID,              
--       ZoneName,              
--       ZoneID,              
--       DivisionName,              
--       DivisionID,              
--       RegionName,              
--       RegionID,              
--       RegionBCNodeID,        
--       1 IsActive,        
--       0 IsDeleted              
--       FROM  BC.vBottlerSalesHier  where               
--       HierType='BC'              
                
                          
 End              
               
 ELSE              
 Begin              
               
SELECT   TotalCompanyID,
         BCNodeID,
         TotalCompanyName,
         LastModified,
         Active             
FROM BC.TotalCompany              
WHERE LastModified >= @lastmodified --AND Active=1                              
                
SELECT  CountryID,              
        BCNodeID,              
        CountryName,              
        TotalCompanyID,          
        LastModified  
     --  Active  
        FROM BC.Country      
        WHERE LastModified >= @lastmodified --AND Active=1                           
                      
SELECT SystemID,              
       BCNodeID,              
       SystemName,              
       CountryID,        
       LastModified    ,
       Active  
       FROM BC.System
       WHERE LastModified >= @lastmodified-- AND Active=1                            
	   and charindex(convert(varchar,BCNodeID) +',',@Systems,1)>0
	   

                     
SELECT ZoneID,              
       BCNodeID,              
       ZoneName,              
       SystemID,        
       LastModified     , 
       Active  
       FROM BC.Zone
       WHERE LastModified > @lastmodified --AND Active=1                             
              
SELECT  DivisionID,              
       BCNodeID,              
       DivisionName,              
       ZoneID,        
       LastModified,
       Active  
       FROM BC.Division 
       WHERE LastModified >= @lastmodified -- AND Active=1                             
           
SELECT RegionID,              
       BCNodeID,              
       RegionName,              
       DivisionID,        
       LastModified ,   
       Active  
       FROM BC.Region   
       WHERE LastModified >= @lastmodified  --AND Active=1                           
              
--SELECT  TotalCompanyName,              
--    TotalCompanyID,              
--       HierType,              
--       CountryName,              
--       CountryID,              
--       SystemName,              
--       SystemID,              
--       ZoneName,              
--       ZoneID,              
--       DivisionName,              
--       DivisionID,              
--       RegionName,              
--       RegionID,              
--       RegionBCNodeID,        
--       1 IsActive,        
--       0 IsDeleted             
--       FROM  BC.vBottlerSalesHier  where               
--       HierType='BC'                
                
               
               
 End              
               
               
End



GO
/****** Object:  StoredProcedure [BCMyday].[pGetSalesMasterData]    Script Date: 6/26/2014 10:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

      
--BCMyday.pGetSalesMasterData '05-20-2014'                      
CREATE PROCEDURE [BCMyday].[pGetSalesMasterData]
(                      
	@lastmodified Date = null                          
)                      
As                      
Begin          
   
	Declare @TType varchar(30)  
	Declare @PType varchar(30)  
	Declare @Systems varchar(30)  
  
	select @TType = value from BCMyday.Config where [Key] = 'TType'  
	select @PType = value from BCMyday.Config where [Key] = 'PType'  
	select @Systems = value from BCMyday.Config where [Key] = 'Systems'  
  
	SELECT Bot.BottlerID, Bot.BottlerName, Bot.ChannelID, Bot.GlobalStatusID, Bot.BCRegionID, Bot.Address, Bot.City,                                    
	Bot.County, Bot.State, Bot.PostalCode, Bot.Country, Bot.Email, Bot.PhoneNumber, Bot.Longitude, Bot.Latitude, Bot.LastModified,  
	Bot.Active
	into #Bottler  
	FROM BC.Bottler Bot  
	Inner join [BC].[tBottlerTerritoryType] BotType on Bot.BottlerId = BotType.BottlerId  
	left join [BC].[vBottlerSalesHier] SalesHier on SalesHier.RegionID = Bot.BCRegionID
	left join [bc].[system] syst on syst.systemid = SalesHier.systemid
	where BotType.TerritoryTypeID = @TType and BotType.producttypeid = @PType  
	and bot.LastModified >= case when isnull(@lastmodified,'') = '' Then bot.LastModified  Else @lastmodified End  
	and Bot.Active = case when isnull(@lastmodified,'') = '' Then 1 Else Bot.Active End  
	and charindex(Convert(varchar,syst.BCNodeID) + ',', @Systems) > 0
	--and bot.bottlerid not in (12024,14078,12821,12912,14361,22466,16021)

	select * from #Bottler  
      
	select TerritoryTypeID,
	ProductTypeID,
	BottlerID,
	BCBottlerID,
	BottlerName,
	TradeMarkID,
	SAPTradeMarkID,
	TradeMarkName from [BC].[tBottlerTrademark]                 
	where bottlerid in (select bottlerid from #Bottler)  
	and TerritoryTypeID = @TType and producttypeid = @PType  
     
    exec [BCMyday].[pGetSalesHierarchy]  @lastmodified  
    exec  [BCMyday].[pGetSalesAccountabilityMaster]  @lastmodified               
 End 


GO
/****** Object:  StoredProcedure [BCMyday].[pGetStoresByBottlerID]    Script Date: 6/26/2014 10:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- BCMyDay.[pGetStoresByBottlerID]  14872,'','SF,LF',12,1            
CREATE Procedure [BCMyday].[pGetStoresByBottlerID]                        
(                        
	@BottlerID int,               
	@lastmodified datetime=null             
)                        
As                        
Begin                                 
  
	DECLARE @TerritoryTypeID int;
	DECLARE @ProductTypeID int;
	DECLARE @Format varchar(500);
	DECLARE @SupportedChannels varchar(1000);
  
	SELECT @TerritoryTypeID = Value FROM BCMyday.Config WHERE [Key]='TType' 
	SELECT @ProductTypeID = Value FROM BCMyday.Config WHERE [Key]='PType'  
	SELECT @Format = Value FROM BCMyday.Config WHERE [Key]='Format'  
	SELECT @SupportedChannels = Value FROM BCMyday.Config WHERE [Key]='CHANNELS_FOR_STORES'  
    
  
	select distinct AC.AccountID,AC.SAPAccountNumber SAPAccountID,                    
	BTLR.BottlerID BottlerID,                    
	AC.AccountName,                    
	AC.Address,AC.City,AC.State,AC.PostalCode,AC.PhoneNumber,                    
	AC.Latitude,AC.Longitude,                    
	AC.ChannelID,                    
	NationalChainID,                    
	RGN.RegionalChainID,                    
	AC.LocalChainID,BTLR.BCRegionID,AC.CRMActive IsActive,AC.LastModified                                   
	from Bc.BottlerAccountTradeMark BA  
	Left Join BC.Bottler BTLR ON BTLR.BottlerId = BA.BottlerId  
	Left Join SAP.Account AC on AC.AccountID = BA.AccountId  
	LEFT JOIN SAP.LOCALCHAIN LOCLCHN ON  AC.LOCALCHAINID=LOCLCHN.LOCALCHAINID  
	LEFT JOIN SAP.REGIONALCHAIN RGN ON LOCLCHN.RegionalChainID=RGN.RegionalChainID  
	LEFT JOIN SAP.Channel CH on CH.ChannelID = BA.ChannelID
	WHERE BA.BottlerID = @BottlerID AND BA.TerritoryTypeID = @TerritoryTypeID
		AND BA.ProductTypeID = @ProductTypeID
		AND AC.Format in (SELECT value FROM CDE.udfSplit (@Format,','))  
		AND CH.SAPChannelID in (SELECT value FROM CDE.udfSplit (@SupportedChannels,','))  
		and Ac.LastModified >= Case when Isnull(@lastmodified, '')  = '' Then Ac.LastModified Else @lastmodified end  
		And AC.CRMActive = Case when  Isnull(@lastmodified, '') = '' Then 1  Else AC.CRMActive end  
  
  
--If ISNULL(@lastmodified, '') = ''                                     
--Begin          
                    
--SELECT AC.AccountID,AC.SAPAccountNumber SAPAccountID,                    
--@BottlerID BottlerID,                    
--AC.AccountName,                    
--AC.Address,AC.City,AC.State,AC.PostalCode,AC.PhoneNumber,                    
--AC.Latitude,AC.Longitude,                    
--AC.ChannelID,                    
--NationalChainID,                    
--RGN.RegionalChainID,                    
--AC.LocalChainID,BTLR.BCRegionID,AC.Active IsActive,AC.LastModified                                   
--FROM SAP.ACCOUNT AC                      
--LEFT JOIN SAP.LOCALCHAIN LOCLCHN ON                      
--AC.LOCALCHAINID=LOCLCHN.LOCALCHAINID                      
--LEFT JOIN SAP.REGIONALCHAIN RGN                       
--ON LOCLCHN.RegionalChainID=RGN.RegionalChainID      
--INNER JOIN BC.Bottler BTLR ON  BTLR.BottlerID= @BottlerID                  
--WHERE accountID                      
--In (SELECT distinct                      
--AccountID FROM   BC.BottlerAccountTradeMark                        
--WHERE BottlerID=@BottlerID AND TerritoryTypeID=@TerritoryTypeID    
--AND ProductTypeID=@ProductTypeID)                   
--AND AC.Format in (SELECT value FROM CDE.udfSplit (@Format,','))                
    
              
--End              
              
--Else            
--Begin      
     
--SELECT  AC.AccountID,AC.SAPAccountNumber SAPAccountID,                    
--@BottlerID BottlerID,                    
--AC.AccountName,                    
--AC.Address,AC.City,AC.State,AC.PostalCode,AC.PhoneNumber,                    
--AC.Latitude,AC.Longitude,                    
--AC.ChannelID,                    
--NationalChainID,                    
--RGN.RegionalChainID,                    
--AC.LocalChainID,BTLR.BCRegionID,AC.Active IsActive,AC.LastModified                                   
--FROM SAP.ACCOUNT AC                      
--LEFT JOIN SAP.LOCALCHAIN LOCLCHN ON                      
--AC.LOCALCHAINID=LOCLCHN.LOCALCHAINID                      
--LEFT JOIN SAP.REGIONALCHAIN RGN                       
--ON LOCLCHN.RegionalChainID=RGN.RegionalChainID      
--INNER JOIN BC.Bottler BTLR ON  BTLR.BottlerID= @BottlerID                  
--WHERE accountID                      
--In (SELECT distinct                      
--AccountID FROM   BC.BottlerAccountTradeMark                
--WHERE BottlerID=@BottlerID AND TerritoryTypeID=@TerritoryTypeID    
--AND ProductTypeID=@ProductTypeID)                   
--AND AC.Format in (SELECT value FROM CDE.udfSplit (@Format,','))                  
--AND AC.LastModified > @lastmodified              
              
--End              
                      
                        
End 


GO
/****** Object:  StoredProcedure [BCMyday].[pGetStoreTieInsHistory]    Script Date: 6/26/2014 10:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
        
--BCMyday.pGetStoreTieInsHistory 12,14872                    
CREATE Procedure [BCMyday].[pGetStoreTieInsHistory]                      
(                                
 @BottlerID int            
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
  WHERE             
  a.BottlerID = @BottlerID            
  and ConditionDate >= DATEADD(MONTH,-@StoreTieinHistory,GETDATE())        
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
 case when isnull(IsActive,0) = 1 then 0 else 1 end IsDeleted                    
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
                      
                      
                      
End 

GO
/****** Object:  StoredProcedure [BCMyday].[pGetUserSession]    Script Date: 6/26/2014 10:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [BCMyday].[pGetUserSession]  
(  
 @SessionID varchar(50)  
 ,@GSN varchar(50)  
)  
As  
Begin  
  
 SELECT TOP 1 SESSIONID FROM BCMYday.UserSession  
 WHERE SESSIONID = @SessionID  
 --and GSN = @GSN  
 and ExpiryDate > GETDATE()  
  
End  
  
  


GO

/****** Object:  StoredProcedure [BCMyday].[pInsertUploadStoreData]    Script Date: 6/27/2014 3:14:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [BCMyday].[pInsertUploadStoreData]                
	 @AccountId int,              
	 @ConditionDate datetime,              
	 @GSN varchar(50),              
	 @BCSystemID int,              
	 @Longitude float,        
	 @Latitude float     ,        
	 @StoreNote varchar(200),              
	 @CreatedBy varchar(50),              
	 @CreatedDate datetime,              
	 @ModifiedBy varchar(50),              
	 @ModifiedDate datetime,              
	 @BottlerID int,              
	 @IsActive bit,  
	 @Name varchar(100),           
	 @StoreConditionDisplay XML,        
	 @StoreConditionDisplayDetail XML,              
	 @StoreTieInRate  XML              
AS                
BEGIN              
        
 DECLARE @StoreConditionID int                
 DECLARE @RowCnt int                
            
 --BEGIN TRANSACTION T1            
              
-- BEGIN TRY            
            
 -- Logic written for StoreCondition              
 SELECT @StoreConditionID = StoreConditionID                 
 FROM [BCMyday].[StoreCondition]                
 WHERE AccountId = @AccountId              
 AND GSN = @GSN              
 AND CONVERT(VARCHAR(10), ConditionDate, 120) = CONVERT(VARCHAR(10), @ConditionDate, 120)                    
 and BottlerID = @BottlerID
            
 IF isnull(@StoreConditionID,0) > 0                         
 BEGIN                   
	-- Update Storecondition table              
	UPDATE [BCMyday].[StoreCondition]                    
	SET                 
	Latitude = @Latitude,                
	Longitude = @Longitude,                
	StoreNote = @StoreNote,                
	ModifiedBy = @ModifiedBy,                
	ModifiedDate = @ModifiedDate,                
	BCSystemID = @BCSystemID,                
	BottlerID = @BottlerID,
	Name = @Name
	WHERE StoreConditionID=@StoreConditionID              
 END                
 ELSE                
 BEGIN                
	  -- INSERT STATEMENT DATA FROM #StoreCondition                
	  INSERT INTO BCMyDay.StoreCondition (AccountId, ConditionDate, GSN, BCSystemID, Longitude, Latitude,                 
	  StoreNote, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, BottlerID, IsActive, Name)                
	  Values              
	  (@AccountId, @ConditionDate, @GSN, @BCSystemID, @Longitude, @Latitude,                 
	  @StoreNote, @CreatedBy, @CreatedDate, @ModifiedBy, @ModifiedDate, @BottlerID, @IsActive, @Name)              
              
	  SELECT @StoreConditionID = SCOPE_IDENTITY()                   
            
              
 End              
                
	----Logic for StoreCondtionDisplay              
	SELECT                        
	item.value('DisplayLocationID[1]', 'int') AS DisplayLocationID                       
	,item.value('PromotionID[1]', 'int') AS PromotionID                
	,item.value('DisplayLocationNote[1]', 'varchar(200)') AS DisplayLocationNote              
	,item.value('DisplayTypeID[1]', 'int') AS DisplayTypeID                
	,item.value('OtherNote[1]', 'varchar(200)') AS OtherNote                  
	,item.value('DisplayImageURL[1]', 'varchar(200)') AS DisplayImageURL                
	,item.value('GridX[1]', 'int') AS GridX                
	,item.value('GridY[1]', 'int') AS GridY                  
	,item.value('CreatedBy[1]', 'varchar(50)') AS CreatedBy              
	,item.value('CreatedDate[1]', 'datetime') AS CreatedDate              
	,item.value('ModifiedBy[1]', 'varchar(50)') AS ModifiedBy              
	,item.value('ModifiedDate[1]', 'datetime') AS ModifiedDate                  
	,item.value('IsActive[1]', 'bit') AS IsActive              
	,item.value('ClientDisplayID[1]', 'int') AS ClientDisplayID              
	,item.value('ReasonID[1]', 'int') AS ReasonID                 
	INTO #StoreConditionDisplay              
	FROM @StoreConditionDisplay.nodes('StoreConditionDisplays/StoreConditionDisplay') AS items(item)               
              
              
	 --Deleting from store condition display details            
	 DELETE FROM [BCMyday].[StoreConditionDisplayDetail]            
	 WHERE StoreConditionDisplayID IN (select StoreConditionDisplayID From [BCMyday].[StoreConditionDisplay]            
	 where StoreConditionID = @StoreConditionID)            
               
                  
	  --Delete matching data              
	 DELETE FROM [BCMyday].[StoreConditionDisplay]              
	 WHERE StoreConditionID = @StoreConditionID            
            
               
                 
	 Insert into [BCMyday].[StoreConditionDisplay]             
	 (StoreConditionID,DisplayLocationID,PromotionID,DisplayLocationNote,              
	 DisplayTypeID,OtherNote,DisplayImageURL,GridX,GridY,              
	 CreatedBy,CreatedDate,ModifiedBy,ModifiedDate              
	 ,IsActive,ClientDisplayID,ReasonID)              
	 SELECT               
	 @StoreConditionID,DisplayLocationID,null,DisplayLocationNote              
	 ,CASE WHEN DisplayTypeID > 0 THEN DisplayTypeID ELSE NULL END,OtherNote,DisplayImageURL,GridX,GridY,              
	 CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,              
	 IsActive,ClientDisplayID,ReasonID             
	 FROM #StoreConditionDisplay              
              
	SELECT   item.value('SystemPackageID[1]', 'int') AS SystemPackageID                  
	,item.value('SystemBrandID[1]', 'int') AS SystemBrandID                       
	,item.value('PromotionID[1]', 'int') AS PromotionID                 
	,item.value('CreatedBy[1]', 'varchar(50)') AS CreatedBy              
	,item.value('CreatedDate[1]', 'datetime') AS CreatedDate              
	,item.value('ModifiedBy[1]', 'varchar(50)') AS ModifiedBy              
	,item.value('ModifiedDate[1]', 'datetime') AS ModifiedDate                  
	,item.value('IsActive[1]', 'bit') AS IsActive              
	,item.value('ClientDisplayID[1]', 'int') AS ClientDisplayID              
	INTO #StoreConditionDisplayDetail              
	FROM @StoreConditionDisplayDetail.nodes('StoreConditionDisplayDetails/StoreConditionDisplayDetail') AS items(item)               
                
              
	-- inserting into detail table from temp table which holds xml data and newly created condtion displayID              
	INSERT INTO [BCMyday].[StoreConditionDisplayDetail]               
	(StoreConditionDisplayID,SystemPackageID,SystemBrandID,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsActive)              
	SELECT M.StoreConditionDisplayID, D.SystemPackageID, D.SystemBrandID, D.CreatedBy, D.CreatedDate, D.ModifiedBy, D.ModifiedDate, D.IsActive              
	FROM #StoreConditionDisplayDetail D              
	INNER JOIN BCmyday.storeconditiondisplay  M on D.ClientDisplayID = M.ClientDisplayID             
	and M.StoreConditionId = @StoreConditionID              
             
              
	SELECT   item.value('SystemBrandID[1]', 'int') AS SystemBrandID                  
	,item.value('TieInRate[1]', 'int') AS TieInRate                         
	,item.value('IsActive[1]', 'bit') AS IsActive               
	,item.value('TotalDisplays[1]', 'int') AS TotalDisplays                 
	,item.value('CreatedBy[1]', 'varchar(50)') AS CreatedBy              
	,item.value('CreatedDate[1]', 'datetime') AS CreatedDate              
	,item.value('ModifiedBy[1]', 'varchar(50)') AS ModifiedBy              
	,item.value('ModifiedDate[1]', 'datetime') AS ModifiedDate                    
	INTO #StoreTieInRate              
	FROM @StoreTieInRate.nodes('StoreTieInRates/StoreTieInRate') AS items(item)               
               
               
	DELETE FROM [BCMyday].[StoreTieInRate]               
	where StoreConditionID = @StoreConditionID              
              
                
	Insert into [BCMyday].[StoreTieInRate]  (              
	StoreConditionID,SystemBrandID,TieInRate,IsActive,CreatedBy,              
	CreatedDate,ModifiedBy,ModifiedDate,TotalDisplays              
	)                
	SELECT @StoreConditionID,SystemBrandID,TieInRate,IsActive,CreatedBy,              
	CreatedDate,ModifiedBy,ModifiedDate,TotalDisplays              
	FROM #StoreTieInRate              
            
                
	SELECT StoreConditionDisplayID,StoreConditionID,        
	ClientDisplayID FROM             
	[BCMyday].[StoreConditionDisplay]            
	WHERE StoreConditionID = @StoreConditionID            
             
             
 --COMMIT TRANSACTION T1            
 --return 0        
--END TRY            
            
--BEGIN CATCH            
            
 --if @@TranCOunt > 0        
 --ROLLBACK TRANSACTION T1            
             
              
--END CATCH            
               
END        

GO

/****** Object:  StoredProcedure [BCMyday].[pInsertUserSession]    Script Date: 6/26/2014 10:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [BCMyday].[pInsertUserSession]  
(  
@GSN varchar(50),  
@SessionID varchar(50),  
@ExpiryDate datetime  
)  
As  
Begin  
  

IF EXISTS(SELECT GSN FROM BCMYday.UserSession WHERE GSN=@GSN)  
 BEGIN
 UPDATE BCMYday.UserSession
 SET SessionID=@SessionID,ExpiryDate=@ExpiryDate
 WHERE GSN=@GSN
 END
 
 ELSE 
 BEGIN 
INSERT INTO BCMYday.UserSession  
(GSN,SessionID,ExpiryDate)  
VALUES  
(@GSN,@SessionID,@ExpiryDate)  
 END
  
End  
  
  
  


GO
/****** Object:  StoredProcedure [BCMyday].[pSaveServiceLog]    Script Date: 6/26/2014 10:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  
-- BCMyDay.pSaveServiceLog 'd','d','2014-01-01','d','d','Pass','d',1,'d'    
CREATE Procedure [BCMyday].[pSaveServiceLog]    
(    
@ServiceName varchar(150),    
@OperationName varchar(50),    
@ModifiedDate datetime,    
@GSN varchar(50)= null,  
@Type varchar(50)= null,  
@Exception varchar(max)= null,
@GUID uniqueidentifier 
)    
As    
Begin    
    
INSERT INTO BCMyDay.WebServiceLog    
(ServiceName,    
 OperationName,    
 ModifiedDate,    
 GSN,  
 Type,  
 Exception,
 GUID 
)    
    
Values    
(    
@ServiceName,    
@OperationName,    
@ModifiedDate,    
@GSN,   
@Type,  
@Exception,
@GUID 
)    
End  


GO
/****** Object:  Table [BCMyday].[Config]    Script Date: 6/26/2014 10:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BCMyday].[Config](
	[ConfigID] [int] IDENTITY(1,1) NOT NULL,
	[Key] [varchar](50) NULL,
	[Value] [varchar](50) NULL,
	[Description] [varchar](50) NULL,
	[ModifiedDate] [datetime] NULL,
	[SendToMyday] [bit] NULL,
 CONSTRAINT [PK_Config] PRIMARY KEY CLUSTERED 
(
	[ConfigID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BCMyday].[DisplayTypeMaster]    Script Date: 6/26/2014 10:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BCMyday].[DisplayTypeMaster](
	[DisplayTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [varchar](50) NULL,
	[ModifiedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[DisplayTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BCMyday].[LOS]    Script Date: 6/26/2014 10:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BCMyday].[LOS](
	[LOSID] [int] IDENTITY(1,1) NOT NULL,
	[ChannelID] [int] NOT NULL,
	[LOSImageID] [int] NOT NULL,
	[CreatedBy] [nchar](10) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [varchar](50) NULL,
	[ModifiedDate] [datetime] NULL,
	[LocalChainID] [int] NULL,
	[AccountID] [int] NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_LOS] PRIMARY KEY CLUSTERED 
(
	[LOSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BCMyday].[LOSDisplayLocation]    Script Date: 6/26/2014 10:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BCMyday].[LOSDisplayLocation](
	[LOSID] [int] NOT NULL,
	[DisplayLocationID] [int] NOT NULL,
	[DisplaySequence] [int] NULL,
	[GridX] [int] NULL,
	[GridY] [int] NULL,
	[IsActive] [int] NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [varchar](50) NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_LOSDisplayLocation] PRIMARY KEY CLUSTERED 
(
	[LOSID] ASC,
	[DisplayLocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BCMyday].[StoreCondition]    Script Date: 6/26/2014 10:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BCMyday].[StoreCondition](
	[StoreConditionID] [int] IDENTITY(1,1) NOT NULL,
	[AccountId] [int] NULL,
	[ConditionDate] [datetime] NULL,
	[GSN] [varchar](50) NULL,
	[BCSystemID] [int] NULL,
	[Longitude] [float] NULL,
	[Latitude] [float] NULL,
	[StoreNote] [varchar](200) NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [varchar](50) NULL,
	[ModifiedDate] [datetime] NULL,
	[BottlerID] [int] NULL,
	[IsActive] [bit] NULL,
	[Name] [varchar](100) NULL,
 CONSTRAINT [PK_StoreCondition1] PRIMARY KEY CLUSTERED 
(
	[StoreConditionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BCMyday].[StoreConditionDisplay]    Script Date: 6/26/2014 10:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [BCMyday].[StoreConditionDisplay](
	[StoreConditionDisplayID] [int] IDENTITY(1,1) NOT NULL,
	[StoreConditionID] [int] NULL,
	[DisplayLocationID] [int] NULL,
	[PromotionID] [int] NULL,
	[DisplayLocationNote] [varchar](200) NULL,
	[DisplayTypeID] [int] NULL,
	[OtherNote] [varchar](200) NULL,
	[DisplayImageURL] [varchar](200) NULL,
	[GridX] [int] NULL,
	[GridY] [int] NULL
) ON [PRIMARY]
SET ANSI_PADDING ON
ALTER TABLE [BCMyday].[StoreConditionDisplay] ADD [CreatedBy] [varchar](50) NULL
ALTER TABLE [BCMyday].[StoreConditionDisplay] ADD [CreatedDate] [datetime] NULL
SET ANSI_PADDING OFF
ALTER TABLE [BCMyday].[StoreConditionDisplay] ADD [ModifiedBy] [varchar](50) NULL
ALTER TABLE [BCMyday].[StoreConditionDisplay] ADD [ModifiedDate] [datetime] NULL
ALTER TABLE [BCMyday].[StoreConditionDisplay] ADD [IsActive] [bit] NULL
ALTER TABLE [BCMyday].[StoreConditionDisplay] ADD [ClientDisplayID] [int] NULL
ALTER TABLE [BCMyday].[StoreConditionDisplay] ADD [ReasonID] [int] NULL
 CONSTRAINT [PK_StoreConditionDisplay] PRIMARY KEY CLUSTERED 
(
	[StoreConditionDisplayID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BCMyday].[StoreConditionDisplayDetail]    Script Date: 6/26/2014 10:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BCMyday].[StoreConditionDisplayDetail](
	[StoreConditionDisplayID] [int] NOT NULL,
	[SystemPackageID] [int] NULL,
	[SystemBrandID] [int] NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [varchar](50) NULL,
	[ModifiedDate] [datetime] NULL,
	[IsActive] [bit] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BCMyday].[StoreTieInRate]    Script Date: 6/26/2014 10:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BCMyday].[StoreTieInRate](
	[StoreConditionID] [int] NOT NULL,
	[SystemBrandId] [int] NOT NULL,
	[TieInRate] [int] NOT NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [varchar](40) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [varchar](50) NULL,
	[ModifiedDate] [datetime] NULL,
	[TotalDisplays] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[StoreConditionID] ASC,
	[SystemBrandId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BCMyday].[SystemBrand]    Script Date: 6/26/2014 10:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BCMyday].[SystemBrand](
	[SystemBrandID] [int] IDENTITY(1,1) NOT NULL,
	[ExternalBrandName] [varchar](50) NULL,
	[BrandID] [int] NULL,
	[TieInType] [char](1) NULL,
	[BrandLevelSort] [int] NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [varchar](50) NULL,
	[ModifiedDate] [datetime] NULL,
	[IsDPSBrand] [bit] NULL,
	[SystemTradeMarkID] [int] NULL,
	[ImageId] [int] NULL,
 CONSTRAINT [PK_SystemBrand] PRIMARY KEY CLUSTERED 
(
	[SystemBrandID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BCMyday].[SystemPackage]    Script Date: 6/26/2014 10:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [BCMyday].[SystemPackage](
	[SystemPackageID] [int] IDENTITY(1,1) NOT NULL,
	[ContainerType] [varchar](10) NULL,
	[PackageConfigID] [int] NULL,
	[BCSystemID] [int] NULL,
	[PackageLevelSort] [int] NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [varchar](50) NULL,
	[ModifiedDate] [datetime] NULL
) ON [PRIMARY]
SET ANSI_PADDING ON
ALTER TABLE [BCMyday].[SystemPackage] ADD [PackageName] [varchar](50) NULL
 CONSTRAINT [PK_SystemPackage] PRIMARY KEY CLUSTERED 
(
	[SystemPackageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BCMyday].[SystemPackageBrand]    Script Date: 6/26/2014 10:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BCMyday].[SystemPackageBrand](
	[SystemPackageBrandID] [int] IDENTITY(1,1) NOT NULL,
	[SystemPackageID] [int] NULL,
	[SystemBrandId] [int] NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_SystemPackageBrand] PRIMARY KEY CLUSTERED 
(
	[SystemPackageBrandID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [BCMyday].[SystemTradeMark]    Script Date: 6/26/2014 10:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BCMyday].[SystemTradeMark](
	[SystemTradeMarkID] [int] IDENTITY(1,1) NOT NULL,
	[ExternalTradeMarkName] [varchar](50) NULL,
	[TradeMarkID] [int] NULL,
	[ImageID] [int] NULL,
	[TradeMarkLevelSort] [int] NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [varchar](50) NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_SystemTradeMark] PRIMARY KEY CLUSTERED 
(
	[SystemTradeMarkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BCMyday].[TieInReason]    Script Date: 6/26/2014 10:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BCMyday].[TieInReason](
	[TieReasonId] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](50) NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [varchar](50) NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_TieInReason] PRIMARY KEY CLUSTERED 
(
	[TieReasonId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BCMyday].[UserSession]    Script Date: 6/26/2014 10:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BCMyday].[UserSession](
	[GSN] [varchar](50) NOT NULL,
	[SessionID] [varchar](50) NULL,
	[ExpiryDate] [datetime] NULL,
 CONSTRAINT [PK_UserSession] PRIMARY KEY CLUSTERED 
(
	[GSN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BCMyday].[WebServiceLog]    Script Date: 6/26/2014 10:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [BCMyday].[WebServiceLog](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[ServiceName] [varchar](150) NULL,
	[OperationName] [varchar](50) NULL,
	[ModifiedDate] [datetime] NULL,
	[GSN] [varchar](50) NULL,
	[Type] [varchar](50) NULL,
	[Exception] [varchar](max) NULL,
	[GUID] [uniqueidentifier] NULL,
PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [BCMyday].[StoreConditionDisplay] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [BCMyday].[StoreConditionDisplayDetail] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [BCMyday].[SystemPackageBrand] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [BCMyday].[LOSDisplayLocation]  WITH CHECK ADD  CONSTRAINT [FK_LOSDisplayLocation_LOS] FOREIGN KEY([LOSID])
REFERENCES [BCMyday].[LOS] ([LOSID])
GO
ALTER TABLE [BCMyday].[LOSDisplayLocation] CHECK CONSTRAINT [FK_LOSDisplayLocation_LOS]
GO
ALTER TABLE [BCMyday].[StoreConditionDisplay]  WITH CHECK ADD  CONSTRAINT [FK_StoreConditionDisplay_RetailPromotion] FOREIGN KEY([PromotionID])
REFERENCES [Playbook].[RetailPromotion] ([PromotionID])
GO
ALTER TABLE [BCMyday].[StoreConditionDisplay] CHECK CONSTRAINT [FK_StoreConditionDisplay_RetailPromotion]
GO


rollback tran
