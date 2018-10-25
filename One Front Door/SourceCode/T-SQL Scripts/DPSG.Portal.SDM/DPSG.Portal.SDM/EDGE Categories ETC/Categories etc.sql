USE Portal_Data
GO

/****** Object:  Table [EDGE].[RPLItemCategory]    Script Date: 8/27/2013 4:37:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [EDGE].[RPLItemCategory](
	[ItemID] [int] NOT NULL,
	[Category] [varchar](50) NOT NULL,
 CONSTRAINT [PK_RPLItemCategory] PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC,
	[Category] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [EDGE].[RPLItemCategory]  WITH CHECK ADD  CONSTRAINT [FK_EDGE.RPLItemCategory_RPLItem] FOREIGN KEY([ItemID])
REFERENCES [EDGE].[RPLItem] ([ItemID])
GO

ALTER TABLE [EDGE].[RPLItemCategory] CHECK CONSTRAINT [FK_EDGE.RPLItemCategory_RPLItem]
GO

-----------------------------------------
Alter table EDGE.RPLItem add CancelledDate datetime
Go

Alter table EDGE.RPLItem add DeletedDate datetime
Go

Alter table EDGE.RPLItem add InformationCategory varchar(50) 
Go

-----------------------------------------
alter table edge.accountmapping add EnablePromotionActivity bit
Go
    
/********************************************************************************************    
Description:  This procedure used to auto fill data from edge schema to PlayBook schema    
    
---------------------------------------------------------------------------------------------    
Created By      :  Dilip Singh            
Created Date    :  06-March-13            
Tracker/Release :              
----------------------------------------------------------------------------------------------    
----------------------------------------------------------------------------------------------    
*********************************************************************************************/            
ALTER PROCEDURE [ETL].[P_getDataFromEDGETOPromotionSchema]      
@LastRunTime DateTime          
AS            
BEGIN            
    
set nocount on             
            
/*---we will used the merge statements which will check if data exist in target table the it             
will update else it will insert data.*/             
            
set rowcount 0          
          
DECLARE @itemCount int          
    
-- Temp Table for the records of CENTRAL BU    
DECLARE @newData TABLE          
(          
 action sysname,          
 ID INT IDENTITY(1, 1) primary key ,          
 [Title] [varchar](180) NULL,          
 [PromoDesc] [varchar](1000) NULL,            
 [Price] [varchar](128) NULL,          
 [StartDate] [datetime] NULL,          
 [EndDate] [datetime] NULL,          
 [ItemId] int NULL,          
 [PromotionID] int null,
 [InformationCategory] [varchar] (500)         
)          
            
-- Temp Table for the records of NORTH-EAST BU                  
  DECLARE @newDatanortheast TABLE          
(          
 ID INT IDENTITY(1, 1) primary key ,          
 [Title] [varchar](180) NULL,          
 [PromoDesc] [varchar](1000) NULL,            
 [Price] [varchar](128) NULL,          
 [StartDate] [datetime] NULL,          
 [EndDate] [datetime] NULL,          
 [ItemId] int NULL,          
 [PromotionID] int null ,
 [InformationCategory] [varchar] (500)           
)          
    
-- Temp Table for the records of PACIFIC BU    
 DECLARE @newDatapacific TABLE          
(          
 ID INT IDENTITY(1, 1) primary key ,          
 [Title] [varchar](180) NULL,          
 [PromoDesc] [varchar](1000) NULL,            
 [Price] [varchar](128) NULL,          
 [StartDate] [datetime] NULL,          
 [EndDate] [datetime] NULL,          
 [ItemId] int NULL,          
 [PromotionID] int null,
 [InformationCategory] [varchar] (500)           
)          
    
-- Temp Table for the records of SOUTH-WEST BU          
 DECLARE @newDataSouthwest TABLE          
(          
 ID INT IDENTITY(1, 1) primary key ,          
 [Title] [varchar](180) NULL,          
 [PromoDesc] [varchar](1000) NULL,            
 [Price] [varchar](128) NULL,          
 [StartDate] [datetime] NULL,          
 [EndDate] [datetime] NULL,          
 [ItemId] int NULL,          
 [PromotionID] int null,
 [InformationCategory] [varchar] (500)           
)          
    
-- Temp Table to keep all the valid item ids that needs to be updated    
CREATE TABLE #ValidItemID(VItemID int)       
    
-- Get all the Item IDs that needs to be updated    
INSERT INTO #ValidItemID    
  
SELECT DISTINCT A.ContentID FROM EDGE.RPLItem A  inner join edge.RPLitemAccount b on a.itemid=b.itemid     
WHERE ReceivedDate IN(select max(ReceivedDate) from EDGE.RPLItem group by contentid)    
AND (ReceivedDate >=  @LastRunTime) AND
 b.SAPNationalchainid in (select sapnationalchainid from EDGE.AccountMapping where EDGE.AccountMapping.enablepromotionactivity=1) 
          


		  

Update [Playbook].[RetailPromotion]
Set [PromotionStatusID]=3, 
PromotionDescription = Isnull(PromotionDescription,'') 
	+ ' Promotion has been cancelled from EDGE on ' + convert(varchar(10),getdate(),121)    
where EDGEItemID in (SELECT DISTINCT a.ContentID FROM EDGE.RPLItem  a
	WHERE 
	
	 (a.ReceivedDate >=  @LastRunTime) 
	AND (a.CancelledDate IS NOT NULL) 
	AND (A.DeletedDate IS NULL))



Update [Playbook].[RetailPromotion]
Set [PromotionStatusID]=3, 
PromotionDescription = Isnull(PromotionDescription,'') 
	+ ' Promotion has been deleted from EDGE on ' + convert(varchar(10),getdate(),121)  
where EDGEItemID in (SELECT DISTINCT a.ContentID FROM EDGE.RPLItem  a
	WHERE 
	 (a.ReceivedDate >=  @LastRunTime) 
	AND (DeletedDate  IS NOT NULL) )



/*--in PlayBook.RetailPromotion table some columns are not proper mapped so i am taking null values*/            
            
          
DECLARE @buid varchar(10)          
            
SELECT @buid= (SELECT buid FROM sap.businessunit WHERE buname='central')          
     
-- Insert BU CENTRAL --    
MERGE PlayBook.RetailPromotion AS TAR11            
 USING ( SELECT  distinct contentid,Title, programdetail,StartDate,EndDate,Price,InformationCategory     
   FROM EDGE.RPLItem  
   Where ((RouteToMarkets like '%PB%'    or RouteToMarkets like '%ALL%')  and (DeletedDate is  null and  CancelledDate is  null )
  
   AND ContentID IN (Select VItemID from #ValidItemID)     
   AND ModifiedDateUTC IN(select max(ModifiedDateUTC) from EDGE.RPLItem group by contentid))    )      
 AS SRC11 (Contentid,Title,programdetail,StartDate,EndDate,Price,InformationCategory)             
 ON SRC11.Contentid=TAR11.EDGEItemID            
WHEN MATCHED AND TAR11.ParentPromotionID IS NULL   THEN UPDATE            
  SET TAR11.PromotionName=SRC11.Title,    
  TAR11.EDGEItemID = SRC11.contentid,    
  TAR11.PromotionStartDate=SRC11.StartDate,            
  TAR11.PromotionEndDate=SRC11.EndDate,    
  TAR11.PromotionPrice=SRC11.Price         
WHEN NOT MATCHED BY TARGET THEN             
 INSERT (PromotionName,PromotionDescription,PromotionTypeID,PromotionPrice,PromotionStartDate,PromotionEndDate,CreatedBy,CreatedDate,ModifiedDate,modifiedby,EDGEItemID,PromotionBUID,PromotionStatusID,PromotionCategoryid,GEOinfo,InformationCategory)       
     
 VALUES (SRC11.Title,SRC11.programdetail,1,SRC11.Price,SRC11.StartDate,SRC11.EndDate,user,GETDATE(),GETDATE(),user,SRC11.contentID,@buid,1,4,'BU - Central',SRC11.InformationCategory)          
 OUTPUT $action,inserted.PromotionName,inserted.PromotionDescription, inserted.PromotionPrice,inserted.PromotionStartDate,inserted.PromotionEndDate,inserted.EDGEItemID,inserted.PromotionID,inserted.InformationCategory INTO @newData;          
    
          
          
Declare @id int          
Declare @Promotionidbucentral int          
Declare @promotionstartdate date          
Declare @promotionenddate date          
SELECT @id = count(ID) FROM @newData           
          
while (@id > 0)          
begin          
select @promotionstartdate=Startdate from @newData where ID=@id          
select @promotionenddate=Enddate from @newData where ID=@id          
select @PromotionIDbucentral=promotionid  from @newData  where ID= @id          
          
--if not exists (select * from playbook.promotiondisplaylocation where promotionid=@Promotionidbucentral and displaylocationid=21 and PromotionDisplayLocationOther IS NULL)          
  
if  exists (select * from playbook.promotiondisplaylocation where promotionid=@Promotionidbucentral and displaylocationid=21 and PromotionDisplayLocationOther IS NULL)          
  
delete from PlayBook.PromotionDisplayLocation where promotionid in (select PromotionID  from playbook.promotiondisplaylocation where promotionid=@Promotionidbucentral and displaylocationid=21 and PromotionDisplayLocationOther IS NULL)          
  
insert into playbook.promotiondisplaylocation(promotionid,displaylocationid,PromotionDisplayLocationOther)  values (@PromotionIDbucentral,24,NULL)          
          
EXEC PlayBook.pInsertPromotionRanking @PromotionIDbucentral,@promotionstartdate,@promotionenddate  

insert into [PlayBook].[PromotionGeoRelevancy](PromotionId ,BUID) values( @PromotionIDbucentral,  @buid)     
set @id = @id - 1           
          
END          
          
           
Select @itemCount=count(*) From @newData Where action='insert'     
 declare @buid1 varchar(10)          
 declare @buid2 varchar(10)          
 declare @buid3 varchar(10)          
          
If(@itemCount>0)          
Begin          
 ----Insert BU Northeast-------          
 select @buid1= (select buid from sap.businessunit where buname='northeast')          
 Insert into PlayBook.RetailPromotion (PromotionName,PromotionDescription,PromotionTypeID,PromotionPrice,PromotionStartDate,PromotionEndDate,CreatedBy,CreatedDate,ModifiedDate,modifiedby,EDGEItemID,PromotionBUID,PromotionStatusID,PromotionCategoryid,GEOinfo,InformationCategory)            
 OUTPUT inserted.PromotionName,inserted.PromotionDescription,inserted.PromotionPrice ,inserted.PromotionStartDate,inserted.PromotionEndDate,inserted.EDGEItemID,inserted.promotionid,inserted.InformationCategory into @newDatanortheast          
 Select   Title,PromoDesc,1,price,StartDate,EndDate,user,GETDATE(),GETDATE(),user,itemid,@buid1,1,4 ,'BU - Northeast',InformationCategory from @newData Where action='insert'           
 select * from @newDatanortheast          
           
  Declare @idnortheast int          
  Declare @Promotionnortheast int          
  Declare @promotionstartdatene date          
  Declare @promotionenddatene date          
  SELECT @id = count(ID) FROM @newDatanortheast           
          
  while (@id > 0)          
  begin          
  select @promotionstartdatene=Startdate from @newDatanortheast where ID=@id          
  select @promotionenddatene=Enddate from @newDatanortheast where ID=@id          
  select  @Promotionnortheast=promotionid  from @newDatanortheast  where ID= @id          
          
 -- if not exists (select * from playbook.promotiondisplaylocation where promotionid=@Promotionnortheast and displaylocationid=21 and PromotionDisplayLocationOther IS NULL)          
  --insert into playbook.promotiondisplaylocation(promotionid,displaylocationid,PromotionDisplayLocationOther)  values (@Promotionnortheast,24,NULL)          
  if  exists (select * from playbook.promotiondisplaylocation where promotionid=@Promotionnortheast and displaylocationid=21 and PromotionDisplayLocationOther IS NULL)          
delete from PlayBook.PromotionDisplayLocation where promotionid in (select promotionid from playbook.promotiondisplaylocation where promotionid=@Promotionnortheast and displaylocationid=21 and PromotionDisplayLocationOther IS NULL)          
insert into playbook.promotiondisplaylocation(promotionid,displaylocationid,PromotionDisplayLocationOther)  values (@Promotionnortheast,24,NULL)          
   
          
  EXEC PlayBook.pInsertPromotionRanking @Promotionnortheast,@promotionstartdatene,@promotionenddatene  
  
insert into [PlayBook].[PromotionGeoRelevancy](PromotionId ,BUID) values( @PromotionIDbucentral,  @buid1)           
  set @id = @id - 1           
          
  END          
            
 ----Insert BU Pacific-------          
 select @buid2= (select buid from sap.businessunit where buname='pacific')          
 Insert into PlayBook.RetailPromotion (PromotionName,PromotionDescription,PromotionTypeID,PromotionPrice,PromotionStartDate,PromotionEndDate,CreatedBy,CreatedDate,ModifiedDate,modifiedby,EDGEItemID,PromotionBUID,PromotionStatusID,PromotionCategoryid,GEOinfo,InformationCategory)            
 OUTPUT inserted.PromotionName,inserted.PromotionDescription, inserted.PromotionPrice,inserted.PromotionStartDate,inserted.PromotionEndDate,inserted.EDGEItemID,inserted.PromotionID,inserted.InformationCategory INTO @newDatapacific          
 Select  Title,PromoDesc,1,price,StartDate,EndDate,user,GETDATE(),GETDATE(),user,itemid,@buid2,1,4,'BU - Pacific',InformationCategory from @newData Where action='insert'           
 select * from @newDatapacific          
  Declare @idpacific int          
  Declare @Promotionidpacific int          
  Declare @promotionpacificstartdate date          
  Declare @promotionpacificenddate date          
  SELECT @id = count(ID) FROM @newDatapacific            
          
  while (@id > 0)          
  begin          
  select @promotionpacificstartdate=Startdate from @newDatapacific where ID=@id          
  select @promotionpacificenddate=Enddate from @newDatapacific where ID=@id          
  select  @Promotionidpacific=promotionid  from @newDatapacific  where ID= @id          
          
  --if not exists (select * from playbook.promotiondisplaylocation where promotionid=@Promotionidpacific and displaylocationid=21 and PromotionDisplayLocationOther IS NULL)          
  --insert into playbook.promotiondisplaylocation(promotionid,displaylocationid,PromotionDisplayLocationOther)  values (@Promotionidpacific,24,NULL)          
  if not exists (select * from playbook.promotiondisplaylocation where promotionid=@Promotionidpacific and displaylocationid=21 and PromotionDisplayLocationOther IS NULL)          
delete from PlayBook.PromotionDisplayLocation where promotionid in (select promotionid from playbook.promotiondisplaylocation where promotionid=@Promotionidpacific and displaylocationid=21 and PromotionDisplayLocationOther IS NULL)          
insert into playbook.promotiondisplaylocation(promotionid,displaylocationid,PromotionDisplayLocationOther)  values (@Promotionidpacific,24,NULL)          
  
  EXEC PlayBook.pInsertPromotionRanking @Promotionidpacific,@promotionpacificstartdate,@promotionpacificenddate          
  
insert into [PlayBook].[PromotionGeoRelevancy](PromotionId ,BUID) values( @PromotionIDbucentral,  @buid2) 
  set @id = @id - 1           
          
  END          
          
       
          
 -------------Insert BU Southwest-------------@newDataSouthwest          
 select @buid3= (select buid from sap.businessunit where buname='southwest')          
 Insert into PlayBook.RetailPromotion (PromotionName,PromotionDescription,PromotionTypeID,PromotionPrice,PromotionStartDate,PromotionEndDate,CreatedBy,CreatedDate,ModifiedDate,modifiedby,EDGEItemID,PromotionBUID,PromotionStatusID,PromotionCategoryid,GEOinfo,InformationCategory)            
 OUTPUT inserted.PromotionName,inserted.PromotionDescription, inserted.PromotionPrice,inserted.PromotionStartDate,inserted.PromotionEndDate,inserted.EDGEItemID,inserted.PromotionID,inserted.InformationCategory INTO @newDataSouthwest          
 Select   Title,PromoDesc,1,price,StartDate,EndDate,user,GETDATE(),GETDATE(),user,itemid,@buid3,1,4,'BU - Southwest',InformationCategory  from @newData Where action='insert'            
          
  Declare @idsouthwest int          
  Declare @PromotionidSouthWest int          
  Declare @promotionSouthWeststartdate date          
  Declare @promotionSouthWestenddate date          
  SELECT @id = count(ID) FROM @newDataSouthwest            
          
  while (@id > 0)          
  begin          
  select @promotionSouthWeststartdate=Startdate from @newDataSouthwest where ID=@id          
  select @promotionSouthWestenddate=Enddate from @newDataSouthwest where ID=@id          
  select @PromotionidSouthWest=promotionid  from @newDataSouthwest  where ID= @id          
          
 -- if exists (select * from playbook.promotiondisplaylocation where promotionid=@PromotionidSouthWest and displaylocationid=21 and PromotionDisplayLocationOther IS NULL)          
 -- insert into playbook.promotiondisplaylocation(promotionid,displaylocationid,PromotionDisplayLocationOther)  values (@PromotionidSouthWest,24,NULL)          
  if not exists (select * from playbook.promotiondisplaylocation where promotionid=@PromotionidSouthWest and displaylocationid=21 and PromotionDisplayLocationOther IS NULL)          
delete from PlayBook.PromotionDisplayLocation where promotionid in (select promotionid from playbook.promotiondisplaylocation where promotionid=@PromotionidSouthWest and displaylocationid=21 and PromotionDisplayLocationOther IS NULL)          
insert into playbook.promotiondisplaylocation(promotionid,displaylocationid,PromotionDisplayLocationOther)  values (@PromotionidSouthWest,24,NULL)          
  
          
  EXEC PlayBook.pInsertPromotionRanking @PromotionidSouthWest,@promotionSouthWeststartdate,@promotionSouthWestenddate          
  
insert into [PlayBook].[PromotionGeoRelevancy](PromotionId ,BUID) values( @PromotionIDbucentral,  @buid3) 
  set @id = @id - 1           
          
  END          
          
          
End          
    
-------------------- TradeMark Section Starts -------------------------    
      
  IF  EXISTS ( SELECT DISTINCT q.PromotionID,S.TRADEMARKID     
    FROM EDGE.RPLItemBrand AS p          
    JOIN PlayBook.RetailPromotion q ON p.contentid =q.EDGEItemID          
    JOIN SAP.Trademark s ON s.SAPtrademarkid=p.SAPtrademarkid            
    JOIN #ValidItemID vItem ON vItem.VItemID = p.contentid        
    WHERE promotionid IS NOT NULL)          
       
  DELETE FROM playbook.promotionbrand     
  WHERE promotionid in (SELECT DISTINCT q.PromotionID     
      FROM EDGE.RPLItemBrand AS p          
      JOIN PlayBook.RetailPromotion q ON p.contentid =q.EDGEItemID          
      JOIN SAP.Trademark s ON s.SAPtrademarkid=p.SAPtrademarkid          
      JOIN #ValidItemID vItem ON vItem.VItemID = p.contentid    
      WHERE promotionid IS NOT NULL)          
    
  INSERT INTO PlayBook.PromotionBrand(promotionid,trademarkid)          
  ( SELECT DISTINCT q.PromotionID,S.TRADEMARKID     
 FROM EDGE.RPLItemBrand AS p          
 JOIN PlayBook.RetailPromotion q ON p.contentid=q.EDGEItemID          
 JOIN SAP.Trademark s ON s.SAPtrademarkid=p.SAPtrademarkid             
 JOIN #ValidItemID vItem ON vItem.VItemID = p.contentid       
 WHERE promotionid IS NOT NULL )       
          
-------------------- Account Section Starts -------------------------    
    
MERGE PlayBook.PromotionAccount as pa          
USING ( SELECT distinct nc.NationalChainID,PromotionID,AccountName  -- Need not to have the Local/Regional Chain         
  FROM EDGE.RPLItemAccount  as ria          
  INNER JOIN PlayBook.RetailPromotion  as rp on ria.contentid = rp.edgeItemID    -- match the EDGE item id in RPLItemAccount/RetailPromotion Table        
  INNER JOIN SAP.NationalChain as nc on ria.SAPNationalChainID = nc.SAPNationalChainID -- Get the NationalChainID from the SAPNationalChain Table     
  INNER JOIN #ValidItemID vItem ON vItem.VItemID = ria.contentid        -- Get only those which are valid Item IDs    
   ) AS ea           
  ON pa.PromotionID = ea.PromotionID          
            
  ---when matched then update-->Only the National Chain Account (need not to update the regional or local as the EDGE promotions will always be National        
  WHEN MATCHED THEN UPDATE SET            
  pa.NationalChainID = ea.NationalChainID ,
  --pa.LocalChainID = ea.LocalChainID,
  --pa.RegionalChainID = ea.RegionalChainID,
  pa.IsRoot = 1
 -- WHEN NOT MATCHED BY TARGET THEN INSERT VALUES(ea.PromotionID,ea.LocalChainID,ea.RegionalChainID,ea.NationalChainID,1);           
  WHEN NOT MATCHED BY TARGET THEN INSERT VALUES(ea.PromotionID,NULL,NULL,ea.NationalChainID,1);           
    
    
          
----------------------- Package Section Starts ------------------------    
    
  IF  EXISTS   (SELECT DISTINCT d.PromotionID,p.PackageTypeID,PackageConfID,PackageID     
    FROM EDGE.RPLItemPackage as c            
    JOIN SAP.PackageType as p  on c.saptypeid=p.sappackagetypeid          
    JOIN PlayBook.RetailPromotion  as d  on c.contentid=d.EDGEItemID          
    JOIN sap.package as s on p.packagetypeid =s.packagetypeid     
    JOIN #ValidItemID vItem ON vItem.VItemID = c.contentid)          
          
 DELETE FROM playbook.promotionpackage     
 WHERE promotionid IN ( SELECT DISTINCT d.PromotionID     
      FROM EDGE.RPLItemPackage AS c            
      JOIN SAP.PackageType AS p  ON c.saptypeid=p.sappackagetypeid          
      JOIN  PlayBook.RetailPromotion  AS d  ON c.contentid=d.EDGEItemID          
      JOIN sap.package AS s ON p.packagetypeid =s.packagetypeid    
      JOIN #ValidItemID vItem ON vItem.VItemID = c.contentid)          
          
 INSERT INTO PlayBook.PromotionPackage(promotionid,PackageTypeID,PackageConfID,PackageID)          
   (SELECT DISTINCT d.PromotionID,p.PackageTypeID,PackageConfID,PackageID     
 FROM EDGE.RPLItemPackage AS c            
 JOIN SAP.PackageType AS p  ON c.saptypeid=p.sappackagetypeid          
 JOIN  PlayBook.RetailPromotion  AS d  ON c.contentid=d.EDGEItemID          
 JOIN sap.package AS s ON p.packagetypeid =s.packagetypeid           
 JOIN #ValidItemID vItem ON vItem.VItemID = c.contentid    
 )          
          
          
    
-------------------- Attachment Section Starts -------------------------            
            
  IF EXISTS ( ( SELECT DISTINCT d.PromotionID,FileName      
    FROM EDGE.RPLAttachment AS c            
    LEFT JOIN PlayBook.RetailPromotion  AS d  ON c.contentid=d.edgeItemID      
    INNER JOIN #ValidItemID vItem ON vItem.VItemID = c.contentid    
    WHERE promotionid IS NOT NULL  ))          
          
DELETE FROM playbook.promotionattachment     
WHERE promotionid IN ( SELECT DISTINCT d.PromotionID      
      FROM EDGE.RPLAttachment as c    
      LEFT JOIN PlayBook.RetailPromotion AS d ON c.contentid=d.edgeItemID      
      INNER JOIN #ValidItemID vItem ON vItem.VItemID = c.contentid    
      WHERE promotionid IS NOT NULL )          
          
INSERT INTO PlayBook.PromotionAttachment(promotionid,AttachmentName)          
 (SELECT DISTINCT d.PromotionID,FileName      
  FROM EDGE.RPLAttachment AS c            
  LEFT JOIN PlayBook.RetailPromotion AS d ON c.contentid=d.edgeItemID      
  INNER JOIN #ValidItemID vItem ON vItem.VItemID = c.contentid    
  WHERE promotionid IS NOT NULL     
  AND  (c.AttachmentType = 'Document'  or c.AttachmentType='Info')       
 )    
     
 END    
Go

USE [Portal_Data]
GO

INSERT INTO [EDGE].[RPLAttachementType]
           ([AttachmentType]
           ,[SPContentType]
           ,[AttachmentTypeID])
     VALUES
           ('OnePager', 'Sell Sheet', 1)
GO



