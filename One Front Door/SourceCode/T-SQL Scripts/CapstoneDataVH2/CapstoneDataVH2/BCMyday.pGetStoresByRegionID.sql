USE Portal_Data
GO


Alter Table SAP.Account
Add EnforcedModifiedDate SmallDateTime
Go

/****** Object:  StoredProcedure [BCMyday].[pGetStoresByRegionID]    Script Date: 8/14/2014 3:52:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- BCMyDay.[pGetStoresByBottlerID]  14872,'','SF,LF',12,1            
ALTER Procedure [BCMyday].[pGetStoresByRegionID]                        
(                        
	@RegionID int,               
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
	WHERE BTLR.BCRegionId = @RegionID AND BA.TerritoryTypeID in (11,12)
		AND BA.ProductTypeID = @ProductTypeID
		AND AC.Format in (SELECT value FROM CDE.udfSplit (@Format,','))  
		AND CH.SAPChannelID in (SELECT value FROM CDE.udfSplit (@SupportedChannels,','))  
		and (
			Ac.CapstoneLastModified >= Case when Isnull(@lastmodified, '')  = '' Then Ac.CapstoneLastModified Else @lastmodified end  
			Or
			Ac.EnforcedModifiedDate >= Case when Isnull(@lastmodified, '')  = '' Then Ac.EnforcedModifiedDate Else @lastmodified end  
		)
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

