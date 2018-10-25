USE Portal_Data
GO

Update 
CDE.Reference
Set REferenceValue = 'Asset added to (###NewSAPAccountNumber/NewSAPAccountName###). SAP shows it located at (###OldSAPAccountNumber/OldSAPAccountName###)'
Where ReferenceID = 521
Go

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:           BILAL KHAWAJA
-- Create date: 6/24/2013
-- Description: Gets the Action Label name by Reference Key
-- =============================================
ALTER FUNCTION [CDE].[udf_GetActionLabelName]
(
       -- Add the parameters for the function here
       @ReferenceKey nvarchar(50),
       @AssetValidationID int,
       @EquipmentNumber int
       
)
RETURNS nvarchar (500)
AS
BEGIN
       -- Declare the return variable here
       DECLARE @ResultVar nvarchar(200)

       -- Add the T-SQL statements to compute the return value here
       --IF(@ReferenceKey NOT IN ('502','514','520','521','522','523','524','525','526','527'))
       --BEGIN
       --SELECT @ResultVar = ReferenceValue FROM [CDE].[Reference] WHERE ReferenceKey = @ReferenceKey
       --END

       --Competitor product is at: ###FieldEntry###
       IF(@ReferenceKey ='502')
       BEGIN

       SELECT @ResultVar = REPLACE (ReferenceValue , '###FieldEntry###' , 
              (SELECT PercentofCompetitorProduct FROM [CDE].[AssetValidation] WHERE AssetValidationID = @AssetValidationID))
         FROM [CDE].[Reference] WHERE ReferenceKey = @ReferenceKey
       END

       --Service call needed for: ###FieldEntry###
       ELSE IF(@ReferenceKey = '514')
       BEGIN
       SELECT @ResultVar = REPLACE (ReferenceValue , '###FieldEntry###' , 
       (select [ReferenceValue] from [CDE].[Reference] where [ReferenceID] = 
       (SELECT ServiceOrderTypeID FROM [CDE].[AssetValidation] WHERE AssetValidationID = @AssetValidationID)))
         FROM [CDE].[Reference] WHERE ReferenceKey = @ReferenceKey
       END

       --Asset # changed from (###SAP###) to (###FieldEntry###)
       ELSE IF(@ReferenceKey = '520')
       BEGIN
       Declare @temp nvarchar(100)
       --DECLARE @assetNo nvarchar(50)
       --set @assetNo = (select assetnumber from [CDE].[AssetValidation] where assetvalidationid = @AssetValidationID)
       --if(@assetNo is null)
       --begin 
       --set @temp = (SELECT assetnumbermissingreasonid FROM [CDE].[AssetValidation] where AssetValidationID = @AssetValidationID) 
       --SELECT @ResultVar = ReferenceValue FROM [CDE].[Reference] WHERE ReferenceKey = @temp
       --end
       --else
       --begin
       set @temp = (SELECT (CASE WHEN e.InventoryNumber is null THEN 'blank' ELSE e.InventoryNumber END) + ' to ' + av.AssetNumber FROM [CDE].[AssetValidation] av left JOIN CDE.Equipment e (NOLOCK) ON av.EquipmentNUmber = e.EquipmentNumber WHERE AssetValidationID = @AssetValidationID) 
       SELECT @ResultVar = REPLACE (ReferenceValue , '(###SAP###) to (###FieldEntry###)' , @temp)  FROM [CDE].[Reference] WHERE ReferenceKey = @ReferenceKey
       --end
       END

       --Asset was Added to this customer.  SAP data shows it located at (###SAPAccountNumber/SAPAccountName###)
       ELSE IF(@ReferenceKey = '521')
       BEGIN
       Declare @temp2 nvarchar(100)
       set @temp2 = (SELECT cast(sapaccountnumber as varchar) +' / ' + cast(AccountName as varchar) FROM sap.account (NOLOCK) WHERE sapaccountnumber =
              (select customernumber from cde.equipment (NOLOCK) where equipmentnumber = @EquipmentNumber))
       IF (@temp2 is NULL OR @EquipmentNumber < 0)
       BEGIN
              set @temp2 = 'unknown location'
       END
       Declare @temp3 nvarchar(100)
       SEt @temp3 = (SELECT cast(sapaccountnumber as varchar) +' / ' + cast(AccountName as varchar) 
              FROM sap.Account (NOLOCK) WHERE sapaccountnumber =
              (select customernumber from cde.AssetValidation (NOLOCK) where AssetValidationID = @AssetValidationID))
       SELECT @ResultVar = REPLACE (ReferenceValue , '###OldSAPAccountNumber/OldSAPAccountName###' , @temp2)  FROM [CDE].[Reference] WHERE ReferenceKey = @ReferenceKey
       SELECT @ResultVar = REPLACE (@ResultVar , '###NewSAPAccountNumber/NewSAPAccountName###' , @temp3)
       END

       --Equipment changed from (###SAP###) to (###FieldEntry###)
       ELSE IF(@ReferenceKey = '522')
       BEGIN
       Declare @v1 nvarchar(50), @v2 nvarchar(50), @result varchar(100);
       set @v1 = (select [ReferenceValue] from [CDE].[Reference] r inner join cde.equipment e (NOLOCK) on e.EquipmentCategory = r.referenceid where e.equipmentnumber=@EquipmentNumber)
       set @v2 = (select [ReferenceValue] from [CDE].[Reference] r inner join cde.assetvalidation av on av.materialtypeid = r.referenceid where av.equipmentnumber=@EquipmentNumber AND AssetValidationID = @AssetValidationID) 
       set @result = @v1 + ' to ' +@v2;
       SELECT @ResultVar = REPLACE (ReferenceValue , '(###SAP###) to (###FieldEntry###)' , @result) 
         FROM [CDE].[Reference] WHERE ReferenceKey = @ReferenceKey
       END

       --Description changed from (###SAP###) to (###FieldEntry###)
       ELSE IF(@ReferenceKey = '523')
       BEGIN
       Declare @tempDesc nvarchar(100)
       set @tempDesc = (SELECT CDE.udf_GetActionReferenceValue(e.ObjectTypeId) + ' to ' + CDE.udf_GetActionReferenceValue(av.EquipmentTypeID) FROM [CDE].[AssetValidation] av INNER JOIN CDE.Equipment e (NOLOCK) ON av.EquipmentNUmber = e.EquipmentNumber WHERE AssetValidationID = @AssetValidationID) 
       IF ( @tempDesc is null )
       BEGIN
              set @tempDesc = 'unknown to ' + (SELECT CDE.udf_GetActionReferenceValue(av.EquipmentTypeID) FROM [CDE].[AssetValidation] av WHERE AssetValidationID = @AssetValidationID) 
       END
       SELECT @ResultVar = REPLACE (ReferenceValue , '(###SAP###) to (###FieldEntry###)' , @tempDesc)  FROM [CDE].[Reference] WHERE ReferenceKey = @ReferenceKey

       END
       
       --Location changed from (###SAP###) to (###FieldEntry###)
       ELSE IF(@ReferenceKey = '524')
       BEGIN
       Declare @temp5 nvarchar(100)
       set @temp5 = (SELECT (case when locationasset is null or locationasset ='' then 'n/a' else locationasset end) + ' to ' + 
       (case when locationdescription is null or locationdescription ='' then 'n/a' else locationdescription end)
       FROM [CDE].[AssetValidation] av INNER JOIN CDE.Equipment e (NOLOCK) ON av.EquipmentNUmber = e.EquipmentNumber WHERE AssetValidationID = @AssetValidationID) 
       SELECT @ResultVar = REPLACE (ReferenceValue , '(###SAP###) to (###FieldEntry###)' , @temp5)  FROM [CDE].[Reference] WHERE ReferenceKey = @ReferenceKey
       END

       --Model # changed from (###SAP###) to (###FieldEntry###)
       ELSE IF(@ReferenceKey = '525')
       BEGIN
       Declare @temp6 nvarchar(100)
       set @temp6 = (SELECT e.ModelNumber + ' to ' + av.ModelNumber FROM [CDE].[AssetValidation] av INNER JOIN CDE.Equipment e (NOLOCK) ON av.EquipmentNUmber = e.EquipmentNumber WHERE AssetValidationID = @AssetValidationID) 
       SELECT @ResultVar = REPLACE (ReferenceValue , '(###SAP###) to (###FieldEntry###)' , @temp6)  FROM [CDE].[Reference] WHERE ReferenceKey = @ReferenceKey
       END

       --Serial # changed from (###SAP###) to (###FieldEntry###)
       ELSE IF(@ReferenceKey = '526')
       BEGIN
       Declare @temp7 nvarchar(100)
       set @temp7= (SELECT TOP 1 (CASE WHEN e.SerialNumber is NULL THEN 'blank' ELSE e.SerialNumber END) + ' to ' + av.SerialNumber FROM [CDE].[AssetValidation] av INNER JOIN CDE.Equipment e (NOLOCK) ON av.EquipmentNUmber = e.EquipmentNumber WHERE AssetValidationID = @AssetValidationID ) 
       SELECT @ResultVar = REPLACE (ReferenceValue , '(###SAP###) to (###FieldEntry###)' , @temp7)  FROM [CDE].[Reference] WHERE ReferenceKey = @ReferenceKey
       END

       --Trademark changed from (###SAP###) to (###FieldEntry###)
       ELSE IF(@ReferenceKey = '527')
       BEGIN
       Declare @v11 nvarchar(50), @v22 nvarchar(50), @result2 varchar(100);
       set @v11 = (select [ReferenceValue] from [CDE].[Reference] r inner join cde.equipment e (NOLOCK) on e.trademarkid = r.referenceid where e.equipmentnumber=@EquipmentNumber)
       set @v22 = (select [ReferenceValue] from [CDE].[Reference] r inner join cde.assetvalidation av on av.equipmentgraphicsid = r.referenceid where av.equipmentnumber=@EquipmentNumber AND AssetValidationID = @AssetValidationID)  
       IF (@v11 is null)
       BEGIN
              set @v11 = 'blank'
       END
       IF (@v22 is null)
       BEGIN
              set @v22 = 'blank'
       END
       set @result2 = @v11 + ' to ' +@v22;
       SELECT @ResultVar = REPLACE (ReferenceValue , '(###SAP###) to (###FieldEntry###)' , @result2)  FROM [CDE].[Reference] WHERE ReferenceKey = @ReferenceKey
       END


       
       ELSE
              BEGIN
                     SELECT @ResultVar = ReferenceValue FROM [CDE].[Reference] WHERE ReferenceKey = @ReferenceKey
              END
       -- Return the result of the function
       RETURN @ResultVar
              
END
GO

ALTER View [CDE].[vAssetValidationAction]
As
       Select
       RefSubGroup, 
       lh.BUName,
       lh.RegionName,
       lh.BranchName,
       a.AccountName,
       sr.RouteName,
       sr.SAPRouteNumber,
       e.EquipmentNumber, 
       [CDE].[udf_GetActionLabelName](ActionTypeID, aas.AssetValidationID, e.EquipmentNumber) ActionType, 
       a.Address,
       a.City,
       a.State,
       a.PostalCode Zip,
       CreateDate, 
       --aas.ModifiedDate,
       ID, 
       aas.AssetValidationID, 
       r.ReferenceValue ActionStatus, 
       ActionTypeStatusID, 
       ActionTypeID        
       From [CDE].[AssetActionStatus] aas
       Left Join CDE.Reference r on aas.ActionTypeStatusID = r.ReferenceID
       Join CDE.AssetValidation e on aas.AssetValidationID = e.AssetValidationID
       Left Join SAP.Account a on e.CustomerNumber = a.SAPAccountNumber
       Join MView.LocationHier lh on a.BranchID = lh.BranchID
       Left Join SAP.RouteSchedule srd on srd.AccountID = a.AccountID
       Left Join SAP.SalesRoute sr on sr.RouteID = srd.RouteID
Go
