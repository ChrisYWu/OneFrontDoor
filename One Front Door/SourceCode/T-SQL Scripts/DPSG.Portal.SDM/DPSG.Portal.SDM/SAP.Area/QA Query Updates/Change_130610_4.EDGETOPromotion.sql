-- executed on 20130610 1711

USE [Portal_Data]
GO
/****** Object:  StoredProcedure [ETL].[P_getDataFromEDGETOPromotionSchema]    Script Date: 6/10/2013 4:42:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  /*******************************************************************************************************************          
Description:  This procedure used to auto fill data from edge to Promtion.          
Schema:          
--------------------------------------------------------------------------------------------------------------------          
Created By      :  Dilip Singh        
Created Date    :  06-March-13        
Tracker/Release :          
--------------------------------------------------------------------------------------------------------------------          
------------------------------------------------------------------------------------------------------------          
*********************************************************************************************/        
ALTER PROCEDURE [ETL].[P_getDataFromEDGETOPromotionSchema]        
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
	[Price] [varchar](128) NULL,      
	[StartDate] [datetime] NULL,      
	[EndDate] [datetime] NULL,      
	[ItemId] int NULL,      
	[PromotionID] int null      
)      
        
-- Temp Table for the records of NORTH-EAST BU              
  DECLARE @newDatanortheast TABLE      
(      
	ID INT IDENTITY(1, 1) primary key ,      
	[Title] [varchar](180) NULL,      
	[Price] [varchar](128) NULL,      
	[StartDate] [datetime] NULL,      
	[EndDate] [datetime] NULL,      
	[ItemId] int NULL,      
	[PromotionID] int null      
)      

-- Temp Table for the records of PACIFIC BU
 DECLARE @newDatapacific TABLE      
(      
	ID INT IDENTITY(1, 1) primary key ,      
	[Title] [varchar](180) NULL,      
	[Price] [varchar](128) NULL,      
	[StartDate] [datetime] NULL,      
	[EndDate] [datetime] NULL,      
	[ItemId] int NULL,      
	[PromotionID] int null      
)      

-- Temp Table for the records of SOUTH-WEST BU      
 DECLARE @newDataSouthwest TABLE      
(      
ID INT IDENTITY(1, 1) primary key ,      
[Title] [varchar](180) NULL,      
[Price] [varchar](128) NULL,      
[StartDate] [datetime] NULL,      
[EndDate] [datetime] NULL,      
[ItemId] int NULL,      
[PromotionID] int null      
)         
      
      
/*--in PlayBook.RetailPromotion table some columns are not proper mapped so i am taking null values*/        
        
      
  declare @buid varchar(10)      
  --Declare @Promotionidbu int      
        
-- select buid into @buid from sap.businessunit where buname="central"      
 select @buid= (select buid from sap.businessunit where buname='central')      
 print @buid      
MERGE PlayBook.RetailPromotion AS TAR11        
USING (SELECT ItemID,Title,StartDate,EndDate,Price FROM EDGE.RPLItem Where RouteToMarkets like '%PB%'  )      
AS SRC11 (ItemID,Title,StartDate,EndDate,Price)         
ON SRC11.ItemID=TAR11.EDGEItemID        
WHEN MATCHED AND TAR11.ParentPromotionID IS NULL   THEN UPDATE        
 SET TAR11.PromotionName=SRC11.Title,TAR11.EDGEItemID=SRC11.ItemID,TAR11.PromotionStartDate=SRC11.StartDate,        
 TAR11.PromotionEndDate=SRC11.EndDate,TAR11.PromotionPrice=SRC11.Price     
WHEN NOT MATCHED BY TARGET THEN         
INSERT (PromotionName,PromotionDescription,PromotionTypeID,PromotionPrice,PromotionStartDate,PromotionEndDate,CreatedBy,CreatedDate,ModifiedDate,modifiedby,EDGEItemID,PromotionBUID,PromotionStatusID,PromotionCategoryid,GEOinfo)        
 VALUES (SRC11.Title,SRC11.Title,1,SRC11.Price,SRC11.StartDate,SRC11.EndDate,user,GETDATE(),GETDATE(),user,SRC11.ItemID,@buid,1,4,'BU-Central')      
 OUTPUT $action,inserted.PromotionName, inserted.PromotionPrice,inserted.PromotionStartDate,inserted.PromotionEndDate,inserted.EDGEItemID,inserted.PromotionID INTO @newData;      

      
      
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
      
if not exists (select * from playbook.promotiondisplaylocation where promotionid=@Promotionidbucentral and displaylocationid=21 and PromotionDisplayLocationOther IS NULL)      
insert into playbook.promotiondisplaylocation(promotionid,displaylocationid,PromotionDisplayLocationOther)  values (@PromotionIDbucentral,21,NULL)      
      
EXEC PlayBook.pInsertPromotionRanking @PromotionIDbucentral,@promotionstartdate,@promotionenddate      
set @id = @id - 1       
      
END      
      
      
--select promotionid, promotionstartdate,promotionenddate from playbook.retailpromotion p join  (select max(promotionid) as promotionidmax from playbook.retailpromotion group by Promotionid)max on p.promotionid=max.promotionidmax      
--select @PromotionID=(select promotionid, promotionstartdate,promotionenddate from playbook.retailpromotion p join  (select max(promotionid) as promotionidmax from playbook.retailpromotion group by Promotionid)max on p.promotionid=max.promotionidmax)    
  
      
      
--  declare @PromotionID int      
--  declare @StartDate date      
--  declare @EndDate date      
      
--select @PromotionID=(SELECT PROMOTIONID FROM playbook.retailpromotion WHERE PROMOTIONID = (select max(PROMOTIONID) from playbook.retailpromotion))      
--select @StartDate=(SELECT PROMOTIONSTARTDATE FROM playbook.retailpromotion WHERE PROMOTIONID = (select max(PROMOTIONID) from playbook.retailpromotion))      
--select @EndDate=(SELECT PROMOTIONENDDATE FROM playbook.retailpromotion WHERE PROMOTIONID = (select max(PROMOTIONID) from playbook.retailpromotion))      
--print @PromotionID      
      
----SELECT PROMOTIONID,PROMOTIONSTARTDATE,PROMOTIONENDDATE FROM playbook.retailpromotion WHERE PROMOTIONID = (select max(PROMOTIONID) from playbook.retailpromotion)      
--insert into playbook.promotiondisplaylocation(promotionid,displaylocationid,PromotionDisplayLocationOther)  values (@PromotionID,21,NULL)      
      
--EXEC PlayBook.pInsertPromotionRanking @PromotionID,@StartDate,@EndDate      
       
Select @itemCount=count(*) From @newData Where action='insert'      
print @itemCount      
 declare @buid1 varchar(10)      
 declare @buid2 varchar(10)      
 declare @buid3 varchar(10)      
      
       
      
      
If(@itemCount>0)      
Begin      
 ----Insert BU Northeast-------      
 select @buid1= (select buid from sap.businessunit where buname='northeast')      
 Insert into PlayBook.RetailPromotion (PromotionName,PromotionDescription,PromotionTypeID,PromotionPrice,PromotionStartDate,PromotionEndDate,CreatedBy,CreatedDate,ModifiedDate,modifiedby,EDGEItemID,PromotionBUID,PromotionStatusID,PromotionCategoryid,GEOinfo)        
 --OUTPUT $action, inserted.PromotionName, inserted.PromotionPrice,inserted.PromotionStartDate,inserted.PromotionEndDate,inserted.EDGEItemID,inserted.PromotionID INTO @newDatanortheast      
 OUTPUT inserted.PromotionName,inserted.PromotionPrice ,inserted.PromotionStartDate,inserted.PromotionEndDate,inserted.EDGEItemID,inserted.promotionid into @newDatanortheast      
 Select   Title,Title,1,price,StartDate,EndDate,user,GETDATE(),GETDATE(),user,itemid,@buid1,1,4 ,'BU-Northeast' from @newData Where action='insert'       
 --OUTPUT inserted.PromotionName, inserted.PromotionPrice,inserted.PromotionStartDate,inserted.PromotionEndDate,inserted.EDGEItemID,inserted.PromotionID INTO @newDatanortheast      
 --insert into @newDatanortheast(Title,Price,startdate,enddate,Itemid,Promotionid)       
 --select Title      
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
      
  if not exists (select * from playbook.promotiondisplaylocation where promotionid=@Promotionnortheast and displaylocationid=21 and PromotionDisplayLocationOther IS NULL)      
  insert into playbook.promotiondisplaylocation(promotionid,displaylocationid,PromotionDisplayLocationOther)  values (@Promotionnortheast,21,NULL)      
      
  EXEC PlayBook.pInsertPromotionRanking @Promotionnortheast,@promotionstartdatene,@promotionenddatene      
  set @id = @id - 1       
      
  END      
      
      
        
 --OUTPUT $action,inserted.PromotionName, inserted.PromotionPrice,inserted.PromotionStartDate,inserted.PromotionEndDate,inserted.EDGEItemID,inserted.PromotionID INTO @newDatanorthheast      
      
 --select @PromotionID=(SELECT PROMOTIONID FROM playbook.retailpromotion WHERE PROMOTIONID = (select max(PROMOTIONID) from playbook.retailpromotion))      
 --select @StartDate=(SELECT PROMOTIONSTARTDATE FROM playbook.retailpromotion WHERE PROMOTIONID = (select max(PROMOTIONID) from playbook.retailpromotion))      
 --select @EndDate=(SELECT PROMOTIONENDDATE FROM playbook.retailpromotion WHERE PROMOTIONID = (select max(PROMOTIONID) from playbook.retailpromotion))      
 --print @PromotionID      
      
 --insert into playbook.promotiondisplaylocation(promotionid,displaylocationid,PromotionDisplayLocationOther)  values (@PromotionID,21,NULL)      
 --EXEC PlayBook.pInsertPromotionRanking @PromotionID,@StartDate,@EndDate      
 ----Insert BU Pacific-------      
 select @buid2= (select buid from sap.businessunit where buname='pacific')      
 Insert into PlayBook.RetailPromotion (PromotionName,PromotionDescription,PromotionTypeID,PromotionPrice,PromotionStartDate,PromotionEndDate,CreatedBy,CreatedDate,ModifiedDate,modifiedby,EDGEItemID,PromotionBUID,PromotionStatusID,PromotionCategoryid,GEOinfo)        
 OUTPUT inserted.PromotionName, inserted.PromotionPrice,inserted.PromotionStartDate,inserted.PromotionEndDate,inserted.EDGEItemID,inserted.PromotionID INTO @newDatapacific      
 Select  Title,Title,1,price,StartDate,EndDate,user,GETDATE(),GETDATE(),user,itemid,@buid2,1,4,'BU-Pacific'  from @newData Where action='insert'       
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
      
  if not exists (select * from playbook.promotiondisplaylocation where promotionid=@Promotionidpacific and displaylocationid=21 and PromotionDisplayLocationOther IS NULL)      
  insert into playbook.promotiondisplaylocation(promotionid,displaylocationid,PromotionDisplayLocationOther)  values (@Promotionidpacific,21,NULL)      
      
  EXEC PlayBook.pInsertPromotionRanking @Promotionidpacific,@promotionpacificstartdate,@promotionpacificenddate      
  set @id = @id - 1       
      
  END      
      
      
      
 --select @PromotionID=(SELECT PROMOTIONID FROM playbook.retailpromotion WHERE PROMOTIONID = (select max(PROMOTIONID) from playbook.retailpromotion))      
 --select @StartDate=(SELECT PROMOTIONSTARTDATE FROM playbook.retailpromotion WHERE PROMOTIONID = (select max(PROMOTIONID) from playbook.retailpromotion))      
 --select @EndDate=(SELECT PROMOTIONENDDATE FROM playbook.retailpromotion WHERE PROMOTIONID = (select max(PROMOTIONID) from playbook.retailpromotion))      
 --print @PromotionID      
      
 --insert into playbook.promotiondisplaylocation(promotionid,displaylocationid,PromotionDisplayLocationOther)  values (@PromotionID,21,NULL)      
 --EXEC PlayBook.pInsertPromotionRanking @PromotionID,@StartDate,@EndDate      
      
 -------------Insert BU Southwest-------------@newDataSouthwest      
 select @buid3= (select buid from sap.businessunit where buname='southwest')      
 Insert into PlayBook.RetailPromotion (PromotionName,PromotionDescription,PromotionTypeID,PromotionPrice,PromotionStartDate,PromotionEndDate,CreatedBy,CreatedDate,ModifiedDate,modifiedby,EDGEItemID,PromotionBUID,PromotionStatusID,PromotionCategoryid,GEOinfo)        
 OUTPUT inserted.PromotionName, inserted.PromotionPrice,inserted.PromotionStartDate,inserted.PromotionEndDate,inserted.EDGEItemID,inserted.PromotionID INTO @newDataSouthwest      
 Select   Title,Title,1,price,StartDate,EndDate,user,GETDATE(),GETDATE(),user,itemid,@buid3,1,4,'BU-Southwest'  from @newData Where action='insert'        
      
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
      
  if not exists (select * from playbook.promotiondisplaylocation where promotionid=@PromotionidSouthWest and displaylocationid=21 and PromotionDisplayLocationOther IS NULL)      
  insert into playbook.promotiondisplaylocation(promotionid,displaylocationid,PromotionDisplayLocationOther)  values (@PromotionidSouthWest,21,NULL)      
      
  EXEC PlayBook.pInsertPromotionRanking @PromotionidSouthWest,@promotionSouthWeststartdate,@promotionSouthWestenddate      
  set @id = @id - 1       
      
  END      
      
      
 --select @PromotionID=(SELECT PROMOTIONID FROM playbook.retailpromotion WHERE PROMOTIONID = (select max(PROMOTIONID) from playbook.retailpromotion))      
 --select @StartDate=(SELECT PROMOTIONSTARTDATE FROM playbook.retailpromotion WHERE PROMOTIONID = (select max(PROMOTIONID) from playbook.retailpromotion))      
 --select @EndDate=(SELECT PROMOTIONENDDATE FROM playbook.retailpromotion WHERE PROMOTIONID = (select max(PROMOTIONID) from playbook.retailpromotion))      
 --   print @PromotionID      
 --insert into playbook.promotiondisplaylocation(promotionid,displaylocationid,PromotionDisplayLocationOther)  values (@PromotionID,21,NULL)      
 --EXEC PlayBook.pInsertPromotionRanking @PromotionID,@StartDate,@EndDate      
      
      
End      
      
      
      
      
       
/*---for PromotionBrand--NEW---*/         
 --declare @itemid int      
 --set @itemid=2189      
      
 -- if not exists (select distinct q.PromotionID,S.TRADEMARKID from EDGE.RPLItemBrand as p      
 --join PlayBook.RetailPromotion q on p.ItemID =q.EDGEItemID      
 --join SAP.Trademark s on s.SAPtrademarkid=p.SAPtrademarkid      
 -- where promotionid is not NULL )       
      
 --  Begin      
      
 --  insert into PlayBook.PromotionBrand(promotionid,trademarkid)      
 --  (select distinct q.PromotionID,S.TRADEMARKID from EDGE.RPLItemBrand as p      
 --join PlayBook.RetailPromotion q on p.ItemID=q.EDGEItemID      
 --join SAP.Trademark s on s.SAPtrademarkid=p.SAPtrademarkid      
 -- where promotionid is not NULL )      
      
 -- end      
      
       
  --declare @trademarkid varchar(10)      
  --declare @promotionid varchar(10)      
      
 -- select  @trademarkid=(select distinct S.TRADEMARKID from EDGE.RPLItemBrand as p      
 --join PlayBook.RetailPromotion q on p.ItemID =q.EDGEItemID      
 --join SAP.Trademark s on s.SAPtrademarkid=p.SAPtrademarkid      
 -- where promotionid is not NULL)      
      
 -- select @promotionid=(select distinct q.PromotionID from EDGE.RPLItemBrand as p      
 --join PlayBook.RetailPromotion q on p.ItemID =q.EDGEItemID      
 --join SAP.Trademark s on s.SAPtrademarkid=p.SAPtrademarkid      
 -- where promotionid is not NULL)      
      
      
      
  if  exists (select distinct q.PromotionID,S.TRADEMARKID from EDGE.RPLItemBrand as p      
 join PlayBook.RetailPromotion q on p.ItemID =q.EDGEItemID      
 join SAP.Trademark s on s.SAPtrademarkid=p.SAPtrademarkid      
  where promotionid is not NULL)      
      
  delete from playbook.promotionbrand where promotionid in (select distinct q.PromotionID from EDGE.RPLItemBrand as p      
 join PlayBook.RetailPromotion q on p.ItemID =q.EDGEItemID      
 join SAP.Trademark s on s.SAPtrademarkid=p.SAPtrademarkid      
  where promotionid is not NULL)      
  insert into PlayBook.PromotionBrand(promotionid,trademarkid)      
   (select distinct q.PromotionID,S.TRADEMARKID from EDGE.RPLItemBrand as p      
 join PlayBook.RetailPromotion q on p.ItemID=q.EDGEItemID      
 join SAP.Trademark s on s.SAPtrademarkid=p.SAPtrademarkid      
  where promotionid is not NULL )      
      
      
      
      
       
      
 -- update playbook.promotionbrand set trademarkid=s.saptrademaekid      
      
 -- else       
      
 -- insert into PlayBook.PromotionBrand(promotionid,trademarkid)      
 --  (select distinct q.PromotionID,S.TRADEMARKID from EDGE.RPLItemBrand as p      
 --join PlayBook.RetailPromotion q on p.ItemID=q.EDGEItemID      
 --join SAP.Trademark s on s.SAPtrademarkid=p.SAPtrademarkid      
 -- where promotionid is not NULL )      
      
      
--Account Section        
MERGE PlayBook.PromotionAccount as pa      
USING ( SELECT nc.NationalChainID,PromotionID,AccountName  -- Need not to have the Local/Regional Chain     
  FROM EDGE.RPLItemAccount  as ria      
  inner JOIN PlayBook.RetailPromotion  as rp on ria.ItemID = rp.edgeItemID    -- match the EDGE item id in RPLItemAccount/RetailPromotion Table    
  inner JOIN SAP.NationalChain as nc on ria.SAPNationalChainID = nc.SAPNationalChainID -- Get the NationalChainID from the SAPNationalChain Table    
   ) AS ea       
  ON pa.PromotionID = ea.PromotionID      
        
  ---when matched then update-->Only the National Chain Account (need not to update the regional or local as the EDGE promotions will always be National    
  WHEN MATCHED THEN UPDATE SET        
  pa.NationalChainID = ea.NationalChainID      
  WHEN NOT MATCHED BY TARGET THEN INSERT VALUES(ea.PromotionID,NULL,NULL,ea.NationalChainID);       
      
      
      
      
/*----for package -----*/      
      
 -- if not exists ( (SELECT distinct d.PromotionID,p.PackageTypeID,PackageConfID,PackageID FROM EDGE.RPLItemPackage as c        
 --join SAP.PackageType as p  on c.saptypeid=p.sappackagetypeid      
 --join  PlayBook.RetailPromotion  as d  on c.ItemID=d.EDGEItemID      
 --join sap.package as s on p.packagetypeid =s.packagetypeid ))      
      
 -- Begin      
 -- insert into PlayBook.PromotionPackage(promotionid,PackageTypeID,PackageConfID,PackageID)      
 --  (SELECT distinct d.PromotionID,p.PackageTypeID,PackageConfID,PackageID FROM EDGE.RPLItemPackage as c        
 --join SAP.PackageType as p  on c.saptypeid=p.sappackagetypeid      
 --join  PlayBook.RetailPromotion  as d  on c.ItemID=d.EDGEItemID      
 --join sap.package as s on p.packagetypeid =s.packagetypeid       
 --)      
 --end      
      
  if  exists ( (SELECT distinct d.PromotionID,p.PackageTypeID,PackageConfID,PackageID FROM EDGE.RPLItemPackage as c        
 join SAP.PackageType as p  on c.saptypeid=p.sappackagetypeid      
 join  PlayBook.RetailPromotion  as d  on c.ItemID=d.EDGEItemID      
 join sap.package as s on p.packagetypeid =s.packagetypeid ))      
      
  delete from playbook.promotionpackage where promotionid in (SELECT distinct d.PromotionID FROM EDGE.RPLItemPackage as c        
 join SAP.PackageType as p  on c.saptypeid=p.sappackagetypeid      
 join  PlayBook.RetailPromotion  as d  on c.ItemID=d.EDGEItemID      
 join sap.package as s on p.packagetypeid =s.packagetypeid)      
      
  insert into PlayBook.PromotionPackage(promotionid,PackageTypeID,PackageConfID,PackageID)      
   (SELECT distinct d.PromotionID,p.PackageTypeID,PackageConfID,PackageID FROM EDGE.RPLItemPackage as c        
 join SAP.PackageType as p  on c.saptypeid=p.sappackagetypeid      
 join  PlayBook.RetailPromotion  as d  on c.ItemID=d.EDGEItemID      
 join sap.package as s on p.packagetypeid =s.packagetypeid       
 )      
 end      
      
      
      
      
/*-----for attachment -----NEW--*/        
        
        
-- if not exists ( (SELECT distinct d.PromotionID,FileName  FROM EDGE.RPLAttachment as c        
--left  join PlayBook.RetailPromotion  as d   on c.ItemID=d.edgeItemID  where promotionid is not NULL  ))      
      
--  Begin      
      
--   insert into PlayBook.PromotionAttachment(promotionid,AttachmentName)      
--   (SELECT distinct d.PromotionID,FileName  FROM EDGE.RPLAttachment as c        
--left  join PlayBook.RetailPromotion  as d   on c.ItemID=d.edgeItemID  where promotionid is not NULL       
-- )      
      
--  end      
      
        
  if exists ( (SELECT distinct d.PromotionID,FileName  FROM EDGE.RPLAttachment as c        
left  join PlayBook.RetailPromotion  as d   on c.ItemID=d.edgeItemID  where promotionid is not NULL  ))      
      
delete from playbook.promotionattachment where promotionid in (SELECT distinct d.PromotionID  FROM EDGE.RPLAttachment as c        
left  join PlayBook.RetailPromotion  as d   on c.ItemID=d.edgeItemID  where promotionid is not NULL )      
      
insert into PlayBook.PromotionAttachment(promotionid,AttachmentName)      
   (SELECT distinct d.PromotionID,FileName  FROM EDGE.RPLAttachment as c        
left  join PlayBook.RetailPromotion  as d   on c.ItemID=d.edgeItemID  where promotionid is not NULL AND  c.AttachmentType = 'Document'    
 )      