USE [Portal_Data]
GO

/****** Object:  StoredProcedure [dbo].[P_GetBransforBranch]    Script Date: 3/21/2013 5:53:07 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[P_GetBransforBranch] 
( 
  @BranchID INT 
 )
AS
BEGIN
/*******************************************************************************************************************  
Description:  This procedure used to display data for Brand on basis of BranchID.  
Schema:  
--------------------------------------------------------------------------------------------------------------------  
Created By      :  Dilip Singh
Created Date    :  07-March-13
Tracker/Release :  
--------------------------------------------------------------------------------------------------------------------  
------------------------------------------------------------------------------------------------------------  
*********************************************************************************************/
declare @ErrorMessage varchar(85),@ErrorID INT  
set nocount on 

/*--@RouteTOMarket can not be null or <>'' */
if @BranchID is null or @BranchID=''
begin
select @ErrorMessage='BranchID can not be blank'
select @ErrorMessage
return
end 
else 
 begin

select distinct brand.BrandID,
            brand.BrandName,
            brand.SAPBrandID,
            brand.TrademarkID 
from SAP.Brand brand
      inner join SAP.Material material
      ON
      brand.BrandID= material.BrandID
      inner join SAP.BranchMaterial bm
      ON 
      material.MaterialID=bm.MaterialID
      inner join SAP.Branch b
      ON
      b.BranchID=bm.BranchID
where b.BranchID=@BranchID
 
 
 end
 
end  







GO


