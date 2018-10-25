USE [Portal_Data]
GO

/****** Object:  StoredProcedure [dbo].[P_getDataFromEDGETOPromotionSchema]    Script Date: 3/21/2013 5:56:18 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[P_getDataFromEDGETOPromotionSchema]

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


/*--in PlayBook.RetailPromotion table some columns are not proper mapped so i am taking null values*/

MERGE PlayBook.RetailPromotion AS TAR11
USING (SELECT ItemID,Tittle,StartDate,EndDate,Price FROM EDGE.RPLItem)
AS SRC11 (ItemID,Tittle,StartDate,EndDate,Price) 
ON SRC11.ItemID=TAR11.ItemID
WHEN MATCHED THEN UPDATE
 SET TAR11.PromotionName=SRC11.Tittle,TAR11.ItemID=SRC11.ItemID,TAR11.PromotionStartDate=SRC11.StartDate,
 TAR11.PromotionEndDate=SRC11.EndDate,TAR11.PromotionPrice=SRC11.Price
WHEN NOT MATCHED BY TARGET THEN 
INSERT VALUES (SRC11.Tittle,NULL,NULL,SRC11.Price,NULL,NULL,NULL,NULL,SRC11.StartDate,SRC11.EndDate,null,
NULL,GETDATE(),NULL,NULL,SRC11.ItemID);



/*---for the account*/


MERGE PlayBook.PromotionAccount as a
USING (SELECT SAPLocalChainID,SAPRegionalChainID,SAPNationalChainID,PromotionID FROM EDGE.RPLItemAccount  as c
inner join PlayBook.RetailPromotion  as d   
on c.ItemID=d.ItemID 

 ) as b (SAPLocalChainID,SAPRegionalChainID,SAPNationalChainID,PromotionID)
on a.PromotionID=b.PromotionID
---when matched then update
when matched then update set  a.PromotionID=b.PromotionID,a.LocalChainID=b.SAPLocalChainID,a.RegionalChainID=b.SAPRegionalChainID,a.NationalChainID=b.SAPNationalChainID
when not matched by target then insert values(b.PromotionID,b.SAPLocalChainID,b.SAPRegionalChainID,b.SAPNationalChainID);



/*---for PromotionBrand-----*/

merge PlayBook.PromotionBrand as tar1
using (select distinct PromotionID,SAPBrandID,BrandName,p.ItemID from EDGE.RPLItemBrand as p
left join PlayBook.RetailPromotion q on p.ItemID=q.ItemID ) 
as src2 (PromotionID,SAPBrandID,BrandName,ItemID)
on tar1.ItemID=src2.ItemID
when matched then update set tar1.PromotionID=src2.PromotionID,tar1.Brand=src2.BrandName,tar1.ItemID=src2.ItemID,tar1.BrandID=src2.SAPBrandID
when not matched by target then insert values(src2.PromotionID,src2.SAPBrandID,src2.BrandName,src2.ItemID);


/*-----for packages -------*/



MERGE PlayBook.PromotionPackage as TAR3
USING (SELECT distinct c.ItemID,PackageName,PromotionID FROM EDGE.RPLItemPackage as c
left join  PlayBook.RetailPromotion  as d  on c.ItemID=d.ItemID
 )
  as SRC3 (ItemID,PackageName,PromotionID)
on TAR3.PromotionID=SRC3.PromotionID
---when matched then update
when matched then update set  TAR3.PromotionID=SRC3.PromotionID,TAR3.Package=SRC3.PackageName,TAR3.ItemID=SRC3.ItemID
when not matched by target then insert values(SRC3.ItemID,SRC3.PromotionID,null,SRC3.PackageName);


/*----for promotion attchedment*/



MERGE PlayBook.PromotionAttachment as a
USING (SELECT distinct AttachmentID, PromotionID,FileName  FROM EDGE.RPLAttachment as c
inner join PlayBook.RetailPromotion  as d   
on c.ItemID=d.ItemID 

 ) as b (AttachmentID,PromotionID,FileName)
on a.PromotionID=b.PromotionID
---when matched then update
when matched then update set a.AttachmentID=b.AttachmentID, a.PromotionID=b.PromotionID,a.PromotionAttachmentName=b.FileName
when not matched by target then insert values (b.AttachmentID,b.PromotionID,b.FileName);




  
END
GO


