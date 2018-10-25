USE [Portal_Data204]
GO
/****** Object:  StoredProcedure [BCMyday].[pGetLOSMaster]    Script Date: 2/27/2015 4:01:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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

