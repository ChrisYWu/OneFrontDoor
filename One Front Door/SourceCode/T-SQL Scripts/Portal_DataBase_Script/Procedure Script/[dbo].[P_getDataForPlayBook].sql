USE [Portal_Data]
GO

/****** Object:  StoredProcedure [dbo].[P_getDataForPlayBook]    Script Date: 3/21/2013 5:54:56 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[P_getDataForPlayBook]
(
 @weekdisplay datetime=null,
 @PromotionTypeID INT=NULL,
 @SortBY VARCHAR(85)=null
)
as

/*******************************************************************************************************************  
Description:  This procedure used to return data for the PlayBook Home pages.  
Schema:  
--------------------------------------------------------------------------------------------------------------------  
Created By      :  Dilip Singh
Created Date    :  20-March-13
Tracker/Release :  
--------------------------------------------------------------------------------------------------------------------  
------------------------------------------------------------------------------------------------------------  
*********************************************************************************************/

--Note1---By default we will display data for the current week means at that time Parameter @weekdisplay will null
--Note2---if @SortBY parameter is null then always we will shorting on Priority column
--Note3--@PromotionTypeID this parameter we are using for seraching the Promotion if this is null then display all


BEGIN
set nocount on

select * from PlayBook.RetailPromotion a, PlayBook.PromotionType b,PlayBook.PromotionStatus c,
PlayBook.PromotionCategory d

--where a.PromotionTypeID=b.PromotionTypeID
--      and a.PromotionStatusID=c.PromotionStatusID
--      and  a.PromotionCategoryID=d.PromotionCategoryID
--      and a.PromotionStartDate between @weekdisplay and @weekdisplay + 7
      


      
END 
GO


