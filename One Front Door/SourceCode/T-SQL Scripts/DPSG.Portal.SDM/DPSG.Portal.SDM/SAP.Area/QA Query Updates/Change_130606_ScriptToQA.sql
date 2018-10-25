USE [Portal_Data]
GO
/****** Object:  StoredProcedure [EDGE].[pGetTimerJOBdetails]    Script Date: 6/6/2013 3:37:20 PM ******/
Begin Tran

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER Procedure
[EDGE].[pGetTimerJOBdetails]
(
 @timerjob datetime
)


as
begin
/*******************************************************************************************************************  
Description:  This procedure used to display data for TIMER JOB RELATED.  
Schema:  
--------------------------------------------------------------------------------------------------------------------  
Created By      :  Dilip Singh
Created Date    :  15-March-13
Tracker/Release :  
--------------------------------------------------------------------------------------------------------------------  
------------------------------------------------------------------------------------------------------------  
*********************************************************************************************/

--Execute procedure to Sync data from RPLItem to RetailPromotion,PromotionBrand,PromotionPackage and PromotionAttachment
  EXEC [ETL].[P_getDataFromEDGETOPromotionSchema]  

create table #displaydata(PromotionID int,ProgramNumber int null,StartDate datetime null,ItemID varchar(100) null,EndDate datetime null,
AccountName varchar(150) null,ChannelName varchar(100) null,AttachmentID varchar(120) null,FileName varchar(128) null,
PhysicalFile varbinary(max) null,BrandName varchar(2000) null)

insert into #displaydata(PromotionID,ProgramNumber,StartDate,ItemID,EndDate,AccountName,ChannelName,AttachmentID,FileName,PhysicalFile)

select  e.PromotionID,a.ProgramNumber,a.StartDate,a.ItemID,a.EndDate,b.AccountName,c.ChannelName,d.AttachmentID,
d.FileName,d.PhysicalFile from EDGE.RPLItem a inner join [EDGE].[RPLItemAccount] b
on a.ItemID=b.ItemID
inner join [EDGE].[RPLItemChannel] c
ON  a.ItemID=c.ItemID
inner join [EDGE].[RPLAttachment] d
on a.ItemID=d.ItemID
inner join [PlayBook].[RetailPromotion] e
on a.ItemID=e.EdgeItemID
where a.ModifiedDateUTC >=@timerjob


create table #working1 (ItemID VARCHAR(50) NOT NULL,BrandName varchar(2000) null)
insert into #working1(ItemID,BrandName)
SELECT p1.ItemID,

       stuff( (SELECT ','+BrandName 

               FROM [EDGE].RPLItemBrand p2

               WHERE p2.ItemID = p1.ItemID
              

               ORDER BY BrandName

               FOR XML PATH(''), TYPE).value('.', 'varchar(max)')

            ,1,1,'')

       AS BrandName

      FROM EDGE.RPLItem p1   where   p1.ModifiedDateUTC >=@timerjob   ---@ROUTEDATE

      GROUP BY ItemID ;

update  a
set  a.BrandName=b.BrandName
from #displaydata a inner join #working1 b
on a.ItemID=b.ItemID


select Promotionid, ProgramNumber,StartDate,ItemID,EndDate,AccountName,ChannelName,AttachmentID,FileName,PhysicalFile,BrandName
from #displaydata



end 



/****** Object:  StoredProcedure [ETL].[P_getDataFromEDGETOPromotionSchema]    Script Date: 6/6/2013 3:35:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
--exec [ETL].[P_getDataFromEDGETOPromotionSchema]  2191    
         
    
    
ALTER PROCEDURE [ETL].[P_getDataFromEDGETOPromotionSchema]      
--(      
-- @itemid int      
--)      
      
 -- exec [ETL].[P_getDataFromEDGETOPromotionSchema]      
    
AS      
BEGIN      
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
set nocount on       
      
/*---we will used the merge statements which will check if data exist in target table the it       
will update else it will insert data.*/       
      
set rowcount 0    
    
DECLARE @itemCount int    
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
USING (SELECT ItemID,Title,StartDate,EndDate,Price FROM EDGE.RPLItem Where Title like '%PB%'  )    
AS SRC11 (ItemID,Title,StartDate,EndDate,Price)       
ON SRC11.ItemID=TAR11.EDGEItemID      
WHEN MATCHED THEN UPDATE      
 SET TAR11.PromotionName=SRC11.Title,TAR11.EDGEItemID=SRC11.ItemID,TAR11.PromotionStartDate=SRC11.StartDate,      
 TAR11.PromotionEndDate=SRC11.EndDate,TAR11.PromotionPrice=SRC11.Price      
WHEN NOT MATCHED BY TARGET THEN       
--INSERT VALUES (SRC11.ITEMID,SRC11.Title,34,SRC11.Price,NULL,NULL,NULL,NULL,SRC11.StartDate,SRC11.EndDate,null,      
INSERT (PromotionName,PromotionDescription,PromotionTypeID,PromotionPrice,PromotionStartDate,PromotionEndDate,CreatedBy,CreatedDate,ModifiedDate,modifiedby,EDGEItemID,PromotionBUID,PromotionStatusID,PromotionCategoryid,GEOinfo)      
 VALUES (SRC11.Title,SRC11.Title,1,SRC11.Price,SRC11.StartDate,SRC11.EndDate,user,GETDATE(),GETDATE(),user,SRC11.ItemID,@buid,1,4,'BU-Central')    
 OUTPUT $action,inserted.PromotionName, inserted.PromotionPrice,inserted.PromotionStartDate,inserted.PromotionEndDate,inserted.EDGEItemID,inserted.PromotionID INTO @newData;    
 --select @Promotionidbu=promotionid from @newData    
 --insert into playbook.promotiondisplaylocation(promotionid,displaylocationid,PromotionDisplayLocationOther)  values (@Promotionidbu,21,NULL)    
--EXEC PlayBook.pInsertPromotionRanking inserted.PromotionID,@StartDate,@EndDate    
--select * from @newData    
    
    
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
  INNER JOIN PlayBook.RetailPromotion  as rp on ria.ItemID = rp.edgeItemID    -- match the EDGE item id in RPLItemAccount/RetailPromotion Table  
  INNER JOIN SAP.NationalChain as nc on ria.SAPNationalChainID = nc.SAPNationalChainID -- Get the NationalChainID from the SAPNationalChain Table  
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
    
GO



USE [Portal_Data]
GO

/****** Object:  StoredProcedure [PlayBook].[pUpdatePromotionAttachment]    Script Date: 6/6/2013 3:40:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--*******************************************************************************************************************    
--Description:  This procedure used to update the attachnment details to the table for all EDGE Promotion  
--Schema:    
----------------------------------------------------------------------------------------------------------------------    
--Created By      :  Dilip Singh  
--Created Date    :  15-March-13  
--Tracker/Release :    
----------------------------------------------------------------------------------------------------------------------    
--------------------------------------------------------------------------------------------------------------    
--*********************************************************************************************/  
begin tran
go
              
Create  PROCEDURE [PlayBook].[pUpdatePromotionAttachment]                          
(                     
                     
 @FileName VARCHAR(500),                     
 @PromotionID int,                    
 @DocumentID VARCHAR(500),                  
 @FileSize int,
 @AttachmentURL VARCHAR(500),                    
 @AttachmentDateModified    Datetime            
)                          
AS                          
BEGIN  
Update   PlayBook.PromotionAttachment set    
	AttachmentURL=@AttachmentURL,
	AttachmentSize=@FileSize,
	AttachmentDocumentID=@DocumentID,
	AttachmentDateModified=@AttachmentDateModified
Where PromotionID=@PromotionID and AttachmentName=@FileName
        
END


GO


















  




