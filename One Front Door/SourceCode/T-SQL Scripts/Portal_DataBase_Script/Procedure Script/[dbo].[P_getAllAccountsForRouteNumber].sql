USE [Portal_Data]
GO

/****** Object:  StoredProcedure [dbo].[P_getAllAccountsForRouteNumber]    Script Date: 3/21/2013 5:50:42 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE Procedure [dbo].[P_getAllAccountsForRouteNumber]
(
 @SAPRouteNumber varchar(45) 
)
as

/*******************************************************************************************************************  
Description:  This procedure used to return data on the basis of SAPRouteNumber.  
Schema:  
--------------------------------------------------------------------------------------------------------------------  
Created By      :  Dilip Singh
Created Date    :  18-March-13
Tracker/Release :  
--------------------------------------------------------------------------------------------------------------------  
------------------------------------------------------------------------------------------------------------  
*********************************************************************************************/

begin
set nocount on
/*-execute the  esiationg function with parameter @SAPRouteNumber*/




select a.*,b.PromotionID into #working1 from [MView].[AccountRouteSchedule] a , PlayBook.PromotionAccount b

where a.NationalChainID =b.NationalChainID 

or a.RegionalChainID =b.RegionalChainID

or a.LocalChainID =b.LocalChainID


 
SELECT * FROM PlayBook.RetailPromotion a, #working1 b,PlayBook.PromotionType C

where a.PromotionID=b.PromotionID and
      a.PromotionTypeID=C.PromotionTypeID
	  AND  b.SAPRouteNumber=ltrim(rtrim(@SAPRouteNumber))



end 


GO


