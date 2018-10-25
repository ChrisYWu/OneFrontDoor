USE [Portal_Data]
GO

alter table CDE.Equipment ADD IsTempAssetActive bit null



/****** Object:  StoredProcedure [CDE].[pGetAssetByID]    Script Date: 9/16/2013 1:00:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [CDE].[pGetAssetByID]
(
	@EquipmentNumber int
)

AS

BEGIN


DECLARE @comment VarChar(150)
DECLARE @AddValidationCustomerNumber VarChar(50)

	SELECT TOP 1 @comment = av.comment, @AddValidationCustomerNumber = av.CustomerNumber FROM CDE.AssetValidation av (NOLOCK)
	WHERE av.EquipmentNumber = @EquipmentNumber
	AND av.[ValidationStatus] = 393
	ORDER by av.AssetValidationID DESC


IF ( @EquipmentNumber > 0 AND @AddValidationCustomerNumber is not null AND @AddValidationCustomerNumber <> '' )
BEGIN
	-- have added with existing equipment - will need to pull location customer data.
	SELECT top 1 
	   V.[EquipmentID]
      ,V.[AccountID]
      ,SAP.[SAPAccountNumber] -- V.[SAPAccountNumber]
      ,SAP.[AccountName] -- V.[AccountName]
      ,SAP.[Address] --V.[Address]
      ,SAP.[City] --V.[City]
      ,SAP.[State]  --V.[State]
      ,SAP.PostalCode --V.[PostalCode]
      ,V.[Contact]
      ,V.[PhoneNumber]
      ,SAP.[Longitude] -- V.[Longitude]
      ,SAP.[Latitude] -- V.[Latitude]
      ,V.[Active]
      ,V.[AccountLastModifiedDate]
      ,V.[LastInvoiceDate]
      ,V.[BusinessUnit]
      ,V.[Region]
      ,V.[Branch]
      ,V.[BranchName]
      ,V.[FunctionalLocation]
      ,V.[FLOCType]
      ,V.[Plant]
      ,V.[EquipmentNumber]
      ,V.[CreatedOn]
      ,V.[SerialNumber]
      ,V.[Manufacturer]
      ,V.[InventoryNumber]
      ,V.[AssetNumber]
      ,V.[LocationAsset]
      ,V.[TrademarkID]
      ,V.[TradeMarkDesc]
      ,V.[ModelNumber]
      ,V.[Material]
      ,V.[ObjectTypeID]
      ,V.[ObjectTypeDesc]
      ,V.[EquipmentCategory]
      ,V.[ChangedOn]
      ,V.[CostCenter]
      ,null as [ProfitCenter] --V.[ProfitCenter]
      ,V.[SalesOrganization]
      ,V.[Division]
      ,V.[DistributionChannel]
      ,SAP.[SAPAccountNumber] as CustomerNumber --V.[CustomerNumber]
      ,V.[UserStatus]
      ,V.[UserStatusDescription]
      ,V.[ValidFrom]
      ,V.[NetBookValueAmount]
      ,V.[LastModified]
      ,V.[MarketType]
      ,V.[Route]
      ,V.[RouteName]
      ,V.[ActionTaken]
      ,V.[AgingCategory]
      ,V.[EquipmentStatus]
      ,V.[NeedValidation]
      ,V.[LastValidationDate]
      ,V.[LastValidatedLocation]
      ,V.[DefaultAccountManagerGSN]
      ,V.[DistrictManagerGSN]
      ,V.[DistrictManagerFirstName]
      ,V.[DistrictManagerLastName]
      ,V.[AccountManagerGSN]
      ,V.[AccountManagerFirstName]
      ,V.[AccountManagerLastName]
      ,V.[ProfitCenterName]
	  ,('Asset added to ' + @AddValidationCustomerNumber + ' / ' + SAP.[AccountName] + '.  ') + 
		CASE WHEN @comment is null THEN ' ' ELSE @comment END as Comment
  FROM [CDE].[VColdDrinkEquipment] V (NOLOCK)
  LEFT OUTER JOIN SAP.Account sap (NOLOCK) on SAP.[SAPAccountNumber] = @AddValidationCustomerNumber
  WHERE V.[EquipmentNumber] = @EquipmentNumber
END
ELSE IF ( @EquipmentNumber < 0 )
BEGIN
	SELECT V.[EquipmentID]
      ,V.[AccountID]
      ,V.[SAPAccountNumber]
      ,V.[AccountName]
      ,V.[Address]
      ,V.[City]
      ,V.[State]
      ,V.[PostalCode]
      ,V.[Contact]
      ,V.[PhoneNumber]
      ,V.[Longitude]
      ,V.[Latitude]
      ,V.[Active]
      ,V.[AccountLastModifiedDate]
      ,V.[LastInvoiceDate]
      ,V.[BusinessUnit]
      ,V.[Region]
      ,V.[Branch]
      ,V.[BranchName]
      ,V.[FunctionalLocation]
      ,V.[FLOCType]
      ,V.[Plant]
      ,V.[EquipmentNumber]
      ,V.[CreatedOn]
      ,V.[SerialNumber]
      ,V.[Manufacturer]
      ,V.[InventoryNumber]
      ,V.[AssetNumber]
      ,V.[LocationAsset]
      ,V.[TrademarkID]
      ,V.[TradeMarkDesc]
      ,V.[ModelNumber]
      ,V.[Material]
      ,V.[ObjectTypeID]
      ,V.[ObjectTypeDesc]
      ,V.[EquipmentCategory]
      ,V.[ChangedOn]
      ,V.[CostCenter]
      ,V.[ProfitCenter]
      ,V.[SalesOrganization]
      ,V.[Division]
      ,V.[DistributionChannel]
      ,V.[CustomerNumber]
      ,V.[UserStatus]
      ,V.[UserStatusDescription]
      ,V.[ValidFrom]
      ,V.[NetBookValueAmount]
      ,V.[LastModified]
      ,V.[MarketType]
      ,V.[Route]
      ,V.[RouteName]
      ,V.[ActionTaken]
      ,V.[AgingCategory]
      ,V.[EquipmentStatus]
      ,V.[NeedValidation]
      ,V.[LastValidationDate]
      ,V.[LastValidatedLocation]
      ,V.[DefaultAccountManagerGSN]
      ,V.[DistrictManagerGSN]
      ,V.[DistrictManagerFirstName]
      ,V.[DistrictManagerLastName]
      ,V.[AccountManagerGSN]
      ,V.[AccountManagerFirstName]
      ,V.[AccountManagerLastName]
      ,V.[ProfitCenterName]
	  ,('Asset added to ' + @AddValidationCustomerNumber + ' / ' + [AccountName] + '.  ') + 
		CASE WHEN @comment is null THEN ' ' ELSE @comment END as Comment
  FROM [CDE].[VColdDrinkEquipment] V (NOLOCK)
  WHERE V.[EquipmentNumber] = @EquipmentNumber

END
ELSE
BEGIN
	SELECT V.[EquipmentID]
      ,V.[AccountID]
      ,V.[SAPAccountNumber]
      ,V.[AccountName]
      ,V.[Address]
      ,V.[City]
      ,V.[State]
      ,V.[PostalCode]
      ,V.[Contact]
      ,V.[PhoneNumber]
      ,V.[Longitude]
      ,V.[Latitude]
      ,V.[Active]
      ,V.[AccountLastModifiedDate]
      ,V.[LastInvoiceDate]
      ,V.[BusinessUnit]
      ,V.[Region]
      ,V.[Branch]
      ,V.[BranchName]
      ,V.[FunctionalLocation]
      ,V.[FLOCType]
      ,V.[Plant]
      ,V.[EquipmentNumber]
      ,V.[CreatedOn]
      ,V.[SerialNumber]
      ,V.[Manufacturer]
      ,V.[InventoryNumber]
      ,V.[AssetNumber]
      ,V.[LocationAsset]
      ,V.[TrademarkID]
      ,V.[TradeMarkDesc]
      ,V.[ModelNumber]
      ,V.[Material]
      ,V.[ObjectTypeID]
      ,V.[ObjectTypeDesc]
      ,V.[EquipmentCategory]
      ,V.[ChangedOn]
      ,V.[CostCenter]
      ,V.[ProfitCenter]
      ,V.[SalesOrganization]
      ,V.[Division]
      ,V.[DistributionChannel]
      ,V.[CustomerNumber]
      ,V.[UserStatus]
      ,V.[UserStatusDescription]
      ,V.[ValidFrom]
      ,V.[NetBookValueAmount]
      ,V.[LastModified]
      ,V.[MarketType]
      ,V.[Route]
      ,V.[RouteName]
      ,V.[ActionTaken]
      ,V.[AgingCategory]
      ,V.[EquipmentStatus]
      ,V.[NeedValidation]
      ,V.[LastValidationDate]
      ,V.[LastValidatedLocation]
      ,V.[DefaultAccountManagerGSN]
      ,V.[DistrictManagerGSN]
      ,V.[DistrictManagerFirstName]
      ,V.[DistrictManagerLastName]
      ,V.[AccountManagerGSN]
      ,V.[AccountManagerFirstName]
      ,V.[AccountManagerLastName]
      ,V.[ProfitCenterName]
	  ,(SELECT TOP 1 av.Comment					
				FROM CDE.AssetValidation av WHERE av.EquipmentNumber = V.EquipmentNumber 
				ORDER BY AssetValidationID DESC
			) AS Comment
  FROM [CDE].[VColdDrinkEquipment] V (NOLOCK)
  WHERE V.[EquipmentNumber] = @EquipmentNumber
END


	
	--SELECT V.*,
	--	(SELECT TOP 1 av.Comment					
	--			FROM CDE.AssetValidation av WHERE av.EquipmentNumber = V.EquipmentNumber 
	--			ORDER BY AssetValidationID DESC
	--		) AS Comment

	--FROM CDE.VColdDrinkEquipment V
	--WHERE V.EquipmentNumber = @EquipmentNumber
END

GO
/****** Object:  StoredProcedure [CDE].[pGetAssetItems]    Script Date: 9/16/2013 1:00:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [CDE].[pGetAssetItems]
(
	@FilterExpression varchar(4000) = null,
	@PageIndex Int=null,
	@PageSize Int=null,
	@SortExpression varchar(250) = null	
)

AS


BEGIN


SET NOCOUNT ON

DECLARE @sqlCode as nvarchar(max)
DECLARE @totalCount as int

	IF ( @PageIndex is NULL)
	BEGIN
		SET @PageIndex = 1
	END

	IF ( @PageSize is NULL )
	BEGIN
		SET @PageSize = 10
	END 

	If(@FilterExpression is null OR @FilterExpression = '')
	BEGIN
		SET @FilterExpression = ' (1 = 1) '
	End

	IF (@SortExpression is null OR @SortExpression = '')
	BEGIN
		SET @SortExpression = 'ORDER BY BranchName'
	END
	ELSE
	BEGIN
		SET @SortExpression = 'ORDER BY ' + @SortExpression
	END

	DECLARE @WHERELIST TABLE (RowNum int, EquipmentID int)

	SET @sqlCode = 'SELECT ROW_NUMBER() OVER (' + @SortExpression + ') as RowNum, EquipmentID from [CDE].[VColdDrinkEquipmentBowler] (NOLOCK) 
	where ' +  @FilterExpression

	INSERT INTO @WHERELIST (RowNum, EquipmentID)
	EXEC (@sqlCode)

	SELECT @totalCount = count(*) FROM @WHERELIST

	SELECT	W.RowNum, 
			W.EquipmentID, 
			@totalCount as TotalItems,
			V.BusinessUnit,
			V.Region,
			V.Branch, 
			V.BranchName,
			V.CustomerNumber,
			V.AccountName,
			V.Address,
			V.City,
			V.State,
			V.PostalCode,
			V.EquipmentNumber,
			V.SerialNumber,
			V.Material, 
			' $' +  V.NetBookValueAmount as NetBookValueAmount, 
			V.AgingCategory,
			V.MarketType,
			V.ObjectTypeDesc,
			V.Route,
			V.RouteName,
			V.BowlerCategory,
			(SELECT TOP 1 av.AssetValidationID					
				FROM CDE.AssetValidation av WHERE av.EquipmentID = V.EquipmentID 
				ORDER BY AssetValidationID DESC
			) AS AssetValidationID,
			V.UserStatusDescription,
			V.ProfitCenter,
			V.ProfitCenterName,
			V.InventoryNumber,
			V.ActionTaken,
			V.DistrictManagerName,
			V.AccountManagerName,
			CONVERT(VARCHAR(10),V.LastAssetValidationDate,101) as LastAssetValidationDate
	FROM @WHERELIST W
	JOIN [CDE].[VColdDrinkEquipmentBowler] V (NOLOCK) ON V.EquipmentID = W.EquipmentID
	WHERE W.RowNum BETWEEN ((@PageIndex - 1) * @PageSize) + 1 AND (@PageIndex * @PageSize)
	ORDER BY W.RowNum


----SET NOCOUNT ON

--DECLARE @sqlCode as nvarchar(max)

--DECLARE @equipmentCount as varchar(100)
--SET @equipmentCount = 'COUNT(*) OVER()'

--	If(@FilterExpression is null)
--		BEGIN
--			SET @FilterExpression = ' (1 = 1) '
--			SELECT @equipmentCount = COUNT(*)  FROM CDE.Equipment
--		End			

		
--		SET @sqlCode = 'SELECT  * FROM 
--		(
--			SELECT ROW_NUMBER() OVER (ORDER BY V.EquipmentNumber) as RowNum, 
--			V.BusinessUnit,V.Region,
--			V.Branch, V.BranchName,
--			V.CustomerNumber,V.AccountName,
--			V.Address,V.City,V.State,V.PostalCode,V.EquipmentNumber,
--			V.SerialNumber,V.Material, 
--			'' $'' +  V.NetBookValueAmount as NetBookValueAmount, 
--			V.AgingCategory,V.MarketType,
--			V.ObjectTypeDesc,
--			V.Route,
--			V.RouteName,
--			V.BowlerCategory,
--			' + @equipmentCount + ' as TotalItems,
--			--COUNT(*) OVER() as TotalItems,

--			(SELECT TOP 1 av.AssetValidationID					
--				FROM CDE.AssetValidation av WHERE av.EquipmentID = V.EquipmentID 
--				ORDER BY AssetValidationID DESC
--			) AS AssetValidationID,
--			V.UserStatusDescription,
--			V.ProfitCenter,
--			V.ProfitCenterName,
--			V.InventoryNumber,
--			V.ActionTaken,
--			V.DistrictManagerName,
--			V.AccountManagerName,
--			V.LastAssetValidationDate
			
--			FROM  CDE.VColdDrinkEquipmentBowler V (NOLOCK)
--				WHERE ' + @FilterExpression + 
--		') temp 	
--		 where RowNum BETWEEN (' +CONVERT(nvarchar(10), isnull(@PageIndex,0))+' - 1) * ' 
--									+CONVERT(nvarchar(10), isnull(@PageSize,0))+' + 1 and '
--									+CONVERT(nvarchar(10), isnull(@PageIndex,0))+'*'
--										+CONVERT(nvarchar(10), isnull(@PageSize,0)) + ''
		

----EXEC sp_executesql @sqlCode		

--PRINT  @sqlCode	

END
GO
/****** Object:  StoredProcedure [CDE].[pInsertAssetValidation]    Script Date: 9/16/2013 1:00:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [CDE].[pInsertAssetValidation]
		   @EquipmentID AS int,
		   @AccountID AS int,
		   @EquipmentNumber AS varchar(20),
		   @CustomerNumber as varchar(50),
		   @AssetNumber AS varchar(50),
           @AssetNumberValidated AS bit,
           @AssetNumberEntryReasonID AS int,
           @AssetNumberMissingReasonID AS int,
           @SerialNumber AS varchar(50),
           @SerialNumberValidated AS bit,
           @SerialNumberEntryReasonID AS int,
           @SerialNumberMissingReasonID AS int,
           @ModelNumber AS varchar(50),
           @ModelNumberEntryReasonID AS int,
           @ModelNumberMissingReasonID AS int,
           @MaterialTypeID AS int,
           @EquipmentTypeID AS int,
           @EquipmentGraphicsID AS int,
           @LocationDescription AS varchar(100),
           @EquipmentConditionID AS int,
           @isProductNeeded AS bit,
           @IsServiceOrderNeeded AS bit,
           @ServiceOrderTypeID AS int,
           @IsGraphicCurrent AS bit,
           @CustomerRequestPickup AS bit,
           @PercentofCompetitorProduct AS int,
           @Comment AS varchar(150),
           @ValidationStatus AS int,
           --@MissingReasonID AS int,
           --@MissingNote AS nvarchar(150),
           @IsInaccessible AS bit,
           --@InaccessibleNote AS varchar(150),
           @DateCreated AS datetime = null,
           @CreatedBy AS varchar(50)

AS

BEGIN

SET NOCOUNT ON

DECLARE @AssetValidationID AS INT

IF ( @EquipmentID = -1 )
BEGIN
	-- Need to create temp record in Equipment table - temp solution till we get workflow.
	  select @EquipmentNumber = (-1 * (max([AssetValidationID]) + 1)) from [CDE].[AssetValidation]
	  
	  INSERT INTO [CDE].[Equipment]
      ([BusinessUnit]
      ,[Region]
      ,[Branch]
      ,[FunctionalLocation]
      ,[FLOCType]
      ,[Plant]
      ,[EquipmentNumber]
	  ,[CostCenter]
      ,[ProfitCenter]
      ,[SalesOrganization]
      ,[Division]
      ,[DistributionChannel]
      ,[CustomerNumber]
      ,[CreatedOn]
      ,[SerialNumber]
      ,[Manufacturer]
      ,[InventoryNumber]
      ,[ModelNumber]
      ,[Material]
      ,[LocationAsset]
      ,[TradeMarkId]
      ,[TradeMarkDesc]
      ,[ObjectTypeId]
      ,[ObjectTypeDesc]
      ,[EquipmentCategory]
      ,[ChangedOn]
      ,[AssetMain]
      ,[ValidFrom]
      ,[UserStatus]
      ,[UserStatusDescription]
      ,[ClosedCustomerInt]
      ,[NetBookValueAmount]
      ,[Currency]
      ,[LastModified]
      ,[ActionTaken]
      ,[IsTempAssetActive]
	  )
	  SELECT DISTINCT TOP 1  
	  SBU.[BUName] as [BusinessUnit]
      ,SR.[RegionName] as [Region]
      ,SB.[SAPBranchID] as [Branch]
      ,null as [FunctionalLocation]
      ,null as [FLOCType]
      ,null as [Plant]
      ,@EquipmentNumber as [EquipmentNumber]
	  ,null as [CostCenter]
      ,null as [ProfitCenter]
      ,null as [SalesOrganization]
      ,null as [Division]
      ,null as [DistributionChannel]
      ,SA.[SAPAccountNumber] as [CustomerNumber]
      ,null as [CreatedOn]
      ,@SerialNumber as [SerialNumber]
      ,null as [Manufacturer]
      ,@AssetNumber as [InventoryNumber]
      ,@ModelNumber as [ModelNumber]
      ,null as [Material]
      ,@LocationDescription as [LocationAsset]
      ,@EquipmentGraphicsID as [TradeMarkId]
      ,(SELECT [ReferenceValue] FROM CDE.Reference WHERE ReferenceID = @EquipmentGraphicsID) as [TradeMarkDesc]
      ,@EquipmentTypeID as [ObjectTypeId]
      ,(SELECT [ReferenceValue] FROM CDE.Reference WHERE ReferenceID = @EquipmentTypeID) as  [ObjectTypeDesc]
      ,@MaterialTypeID as [EquipmentCategory]
      ,null as [ChangedOn]
      ,null as [AssetMain]
      ,null as [ValidFrom]
      ,null as [UserStatus]
      ,null as [UserStatusDescription]
      ,null as [ClosedCustomerInt]
      ,null as [NetBookValueAmount]
      ,null as [Currency]
      ,null as [LastModified]
      ,null as [ActionTaken]
      ,1 as [IsTempAssetActive]
	  FROM 
		SAP.Account SA -- account name
		LEFT JOIN SAP.Branch SB on SA.[BranchID] = SB.[BranchID] -- branch name
		LEFT JOIN SAP.Region SR on SR.[RegionID] = SB.[RegionID] -- region name
		LEFT JOIN SAP.[ProfitCenter] SP on SP.[BranchID] = SB.[BranchID] -- profit center
		LEFT JOIN [SAP].[BusinessUnit] SBU on SBU.[BUID] = SR.[BUID] -- business unit
		WHERE SA.[SAPAccountNumber] = @CustomerNumber
	
	SET @EquipmentID = SCOPE_IDENTITY()
END


INSERT INTO [Portal_Data].[CDE].[AssetValidation]
           ([EquipmentID]
		   ,[AccountID]
		   ,[EquipmentNumber]
		   ,[CustomerNumber]
           ,[AssetNumber]
           ,[AssetNumberValidated]
           ,[AssetNumberEntryReasonID]
           ,[AssetNumberMissingReasonID]
           ,[SerialNumber]
           ,[SerialNumberValidated]
           ,[SerialNumberEntryReasonID]
           ,[SerialNumberMissingReasonID]
           ,[ModelNumber]
           ,[ModelNumberEntryReasonID]
           ,[ModelNumberMissingReasonID]
           ,[MaterialTypeID]
           ,[EquipmentTypeID]
           ,[EquipmentGraphicsID]
           ,[LocationDescription]
           ,[EquipmentConditionID]
           ,[isProductNeeded]
           ,[IsServiceOrderNeeded]
           ,[ServiceOrderTypeID]
           ,[IsGraphicCurrent]
           ,[CustomerRequestPickup]
           ,[PercentofCompetitorProduct]
           ,[Comment]
           ,[ValidationStatus]
           --,[MissingReasonID]
           --,[MissingNote]
           ,[IsInaccessible]
           --,[InaccessibleNote]
           ,[DateCreated]
           ,[CreatedBy])
     VALUES
           (@EquipmentID,
		   @AccountID,
		   @EquipmentNumber,
		   @CustomerNumber,
           @AssetNumber,
           @AssetNumberValidated,
           @AssetNumberEntryReasonID, 
           @AssetNumberMissingReasonID, 
           @SerialNumber, 
           @SerialNumberValidated, 
           @SerialNumberEntryReasonID,
           @SerialNumberMissingReasonID, 
           @ModelNumber, 
           @ModelNumberEntryReasonID, 
           @ModelNumberMissingReasonID, 
           @MaterialTypeID,
           @EquipmentTypeID, 
           @EquipmentGraphicsID, 
           @LocationDescription, 
           @EquipmentConditionID, 
           @isProductNeeded, 
           @IsServiceOrderNeeded,
           @ServiceOrderTypeID, 
           @IsGraphicCurrent, 
           @CustomerRequestPickup,
           @PercentofCompetitorProduct, 
           @Comment, 
           @ValidationStatus, 
           --@MissingReasonID, 
           --@MissingNote, 
           @IsInaccessible, 
           --@InaccessibleNote, 
           @DateCreated, 
           @CreatedBy
           )
           

		   SET @AssetValidationID = SCOPE_IDENTITY()

		   EXEC [CDE].[InsertAssetActionStatus] @AssetValidationID, @EquipmentNumber

		   RETURN @AssetValidationID

 END

 

GO
/****** Object:  StoredProcedure [CDE].[UpdateAssetActionStatus]    Script Date: 9/16/2013 1:00:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [CDE].[UpdateAssetActionStatus]
@AssetValidationID int,
@ActionLabelId int,
@PicklistItemId int

AS

BEGIN

DECLARE @EquipmentNumber nvarchar(18)

SET NOCOUNT ON


		UPDATE [CDE].[AssetActionStatus]
			SET [ActionTypeStatusID] = @PicklistItemId
		WHERE AssetValidationID = @AssetValidationID 
			AND ActionTypeID = @ActionLabelId

		-- check to see if we need to turn off the temp record
		IF ( @ActionLabelId = 521 AND @PicklistItemId <> 620 )
		BEGIN
			
			SELECT @EquipmentNumber = [EquipmentNumber] FROM [CDE].[AssetActionStatus]
			WHERE AssetValidationID = @AssetValidationID 
			AND ActionTypeID = @ActionLabelId
			
			UPDATE CDE.Equipment SET [IsTempAssetActive] = 0 WHERE [EquipmentNumber] = @EquipmentNumber
		END

END
GO
/****** Object:  UserDefinedFunction [CDE].[udf_GetActionLabelName]    Script Date: 9/16/2013 1:00:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		BILAL KHAWAJA
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
	DECLARE @ResultVar nvarchar(100)

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
	SELECT @ResultVar = REPLACE (ReferenceValue , '###SAPAccountNumber/SAPAccountName###' , @temp2)  FROM [CDE].[Reference] WHERE ReferenceKey = @ReferenceKey
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
/****** Object:  View [CDE].[VColdDrinkEquipment]    Script Date: 9/16/2013 1:00:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [CDE].[VColdDrinkEquipment]
AS
SELECT DISTINCT  CDE.EquipmentID, SA.AccountID, SA.SAPAccountNumber, SA.AccountName, SA.Address, 
SA.City, SA.State, SA.PostalCode, SA.Contact, 
                  SA.PhoneNumber, SA.Longitude, SA.Latitude, SA.Active, SA.LastModified AS AccountLastModifiedDate, 
				  SA.[LastInvoiceDate],
				   CDE.BusinessUnit, CDE.Region, CDE.Branch, SB.[BranchName],
                  CDE.FunctionalLocation, CDE.FLOCType, CDE.Plant,
				  CDE.EquipmentNumber, CDE.CreatedOn, CDE.SerialNumber, CDE.Manufacturer,
                  CDE.InventoryNumber, CDE.InventoryNumber as AssetNumber, CDE.LocationAsset, CDE.TrademarkID, CDE.TradeMarkDesc, CDE.ModelNumber, 
				  CDE.Material, CDE.ObjectTypeID, RefObjDesc.ReferenceValue as ObjectTypeDesc,
				  --CDE.ObjectTypeDesc, 
                  CDE.EquipmentCategory, CDE.ChangedOn, CDE.CostCenter, CDE.ProfitCenter, 
				  CDE.SalesOrganization, CDE.Division, CDE.DistributionChannel, CDE.CustomerNumber, 
                  CDE.UserStatus, CDE.UserStatusDescription, CDE.ValidFrom, 
				  CDE.NetBookValueAmount, CDE.LastModified, 
				  (SELECT ReferenceValue FROM CDE.Reference WHERE SA.[MarketTypeID] = [ReferenceID] ) as MarketType, 
				  SAR.[SAPRouteNumber] as [Route], SAR.RouteName ,CDE.ActionTaken,
				 -- CASE 					
					--WHEN CDE.[ValidFrom] is null THEN
					--	CASE
					--	WHEN SA.[LastInvoiceDate] IS NULL THEN 12 
					--	WHEN SA.[LastInvoiceDate] < DATEADD(d, - 365, GetDate()) THEN 12
					--	WHEN SA.[LastInvoiceDate] < DATEADD(d, - 270, GetDate()) THEN 9 
					--	WHEN SA.[LastInvoiceDate] < DATEADD(d, - 180, GetDate()) THEN 6 
					--	WHEN SA.[LastInvoiceDate] < DATEADD(d, - 90, GetDate()) THEN 3
					--	WHEN SA.[LastInvoiceDate] < DATEADD(d, - 60, GetDate()) THEN 2
					--	WHEN SA.[LastInvoiceDate] < DATEADD(d, - 30, GetDate()) THEN 1
					--	WHEN SA.[LastInvoiceDate] <= DATEADD(d, - 1, GetDate()) THEN 0
					--	ELSE NULL
					--	END
					--WHEN SA.[LastInvoiceDate] is null THEN
					--	CASE
					--	WHEN CDE.[ValidFrom] IS NULL THEN 12 
					--	WHEN CDE.[ValidFrom] < DATEADD(d, - 365, GetDate()) THEN 12
					--	WHEN CDE.[ValidFrom] < DATEADD(d, - 270, GetDate()) THEN 9 
					--	WHEN CDE.[ValidFrom] < DATEADD(d, - 180, GetDate()) THEN 6 
					--	WHEN CDE.[ValidFrom] < DATEADD(d, - 90, GetDate()) THEN 3
					--	WHEN CDE.[ValidFrom] < DATEADD(d, - 60, GetDate()) THEN 2
					--	WHEN CDE.[ValidFrom] < DATEADD(d, - 30, GetDate()) THEN 1
					--	WHEN CDE.[ValidFrom] <= DATEADD(d, - 1, GetDate()) THEN 0
					--	ELSE NULL
					--	END
						
					--WHEN CDE.[ValidFrom] > SA.[LastInvoiceDate] THEN
					--	CASE
					--	WHEN CDE.[ValidFrom] < DATEADD(d, - 365, GetDate()) THEN 12
					--	WHEN CDE.[ValidFrom] < DATEADD(d, - 270, GetDate()) THEN 9 
					--	WHEN CDE.[ValidFrom] < DATEADD(d, - 180, GetDate()) THEN 6 
					--	WHEN CDE.[ValidFrom] < DATEADD(d, - 90, GetDate()) THEN 3
					--	WHEN CDE.[ValidFrom] < DATEADD(d, - 60, GetDate()) THEN 2
					--	WHEN CDE.[ValidFrom] < DATEADD(d, - 30, GetDate()) THEN 1
					--	WHEN CDE.[ValidFrom] <= DATEADD(d, - 1, GetDate()) THEN 0
					--	ELSE NULL
					--	END
					--ELSE
					--	CASE
					--	WHEN SA.[LastInvoiceDate] < DATEADD(d, - 365, GetDate()) THEN 12
					--	WHEN SA.[LastInvoiceDate] < DATEADD(d, - 270, GetDate()) THEN 9 
					--	WHEN SA.[LastInvoiceDate] < DATEADD(d, - 180, GetDate()) THEN 6 
					--	WHEN SA.[LastInvoiceDate] < DATEADD(d, - 90, GetDate()) THEN 3
					--	WHEN SA.[LastInvoiceDate] < DATEADD(d, - 60, GetDate()) THEN 2
					--	WHEN SA.[LastInvoiceDate] < DATEADD(d, - 30, GetDate()) THEN 1
					--	WHEN SA.[LastInvoiceDate] <= DATEADD(d, - 1, GetDate()) THEN 0
					--	ELSE NULL
					--	END
					--END
					EA.[AgingCategory],
				   EA.EquipmentStatus,

				  CASE 
					WHEN
				  ( select count(AV.[AssetValidationID]) FROM [CDE].[AssetValidation] AV
					WHERE CDE.[EquipmentID] = AV.[EquipmentID]
					AND AV.DateCreated > DATEADD(d, -365, GetDate())
				  ) > 0 THEN 0
				  ELSE 1
				  END AS NeedValidation,
				  
				  (SELECT TOP 1 AV3.[DateCreated] 
					FROM CDE.AssetValidation AV3 (NOLOCK) 
					WHERE AV3.EquipmentNumber = CDE.EquipmentNumber
					ORDER BY AV3.[DateCreated] DESC) as LastValidationDate,

				  (SELECT TOP 1 SA4.AccountName
					FROM CDE.AssetValidation AV (NOLOCK) 
					JOIN SAP.Account SA4 ON SA4.AccountID = AV.AccountID
					WHERE AV.EquipmentNumber = CDE.EquipmentNumber
					ORDER BY AV.[DateCreated] DESC) as LastValidatedLocation,

				  --(SELECT TOP 1 [AccountName] FROM [SAP].[Account] WHERE [AccountID] = AV.[AccountID])
				  --AS LastValidatedLocation, 
				  SAR.[DefaultAccountManagerGSN],
				  PR.[DistrictManagerGSN],PR.[DistrictManagerFirstName], PR.[DistrictManagerLastName],
				  PR.[AccountManagerGSN], PR.[AccountManagerFirstName], PR.[AccountManagerLastName],
				  
				  (select top 1 profitcentername from sap.profitcenter where sapprofitcenterid = cde.profitcenter) as ProfitCenterName

				  --'' AS [DistrictManagerGSN], '' AS [DistrictManagerFirstName], '' AS [DistrictManagerLastName],
				  --'' AS [AccountManagerGSN], '' AS [AccountManagerFirstName], '' AS [AccountManagerLastName]
				  

FROM    CDE.Equipment AS CDE (NOLOCK)
		LEFT OUTER JOIN  [CDE].[EquipmentAgeCategory] AS EA (NOLOCK) on EA.[EquipmentID] = CDE.[EquipmentID]
		LEFT OUTER JOIN SAP.Account AS SA (NOLOCK) ON SA.SAPAccountNumber = CDE.CustomerNumber
		LEFT OUTER JOIN CDE.Reference RefObjDesc (NOLOCK) ON CDE.[ObjectTypeID] = RefObjDesc.[ReferenceID]
		--LEFT OUTER JOIN CDE.Reference RefMT (NOLOCK) ON SA.[MarketTypeID] = RefMT.[ReferenceID]
		LEFT OUTER JOIN SAP.Branch AS SB (NOLOCK) ON SB.[SAPBranchID] = CDE.[Branch]
		--LEFT OUTER JOIN CDE.AssetValidation AV (NOLOCK) on AV.EquipmentNumber = CDE.EquipmentNumber 
		LEFT OUTER JOIN [SAP].[RouteSchedule] SR (NOLOCK) ON SR.[AccountID] = SA.AccountID 
		LEFT OUTER JOIN [SAP].[SalesRoute] SAR (NOLOCK) ON SAR.[RouteID] = SR.[RouteID] 
		LEFT OUTER JOIN [Person].[RouteDistrictManagers] PR (NOLOCK) ON PR.[AccountManagerGSN] = SAR.DefaultAccountManagerGSN AND SAR.DefaultAccountManagerGSN is not NULL

		WHERE CDE.[IsTempAssetActive] is NULL OR CDE.[IsTempAssetActive] = 1



GO
/****** Object:  View [CDE].[VColdDrinkEquipmentBowler]    Script Date: 9/16/2013 1:00:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--We need business unit, region, branch and bowler category, date field for month and year.
ALTER VIEW [CDE].[VColdDrinkEquipmentBowler]
AS

SELECT E.[EquipmentID], E.[EQUIPMENTNUMBER], E.[BusinessUnit], E.[Region], E.[Branch], SB.[BranchName],
		E.CustomerNumber,E.SerialNumber,E.Material,
		RefObjDesc.ReferenceValue as ObjectTypeDesc,
		--E.[ObjectTypeDesc],
		E.NetBookValueAmount, EA.AgingCategory,RefMT.ReferenceValue as MarketType,SAR.[SAPRouteNumber] as [Route],SAR.[RouteName],
		E.UserStatusDescription,
		E.ProfitCenter,
		E.InventoryNumber,
		E.ActionTaken,
		SA.[AccountName],SA.Address,SA.City,SA.State,SA.PostalCode, SA.LastInvoiceDate, SA.[LastInvoiceCaseQty], SA.[LastInvoiceNetSales],
		 (select top 1 profitcentername from sap.profitcenter where sapprofitcenterid = E.profitcenter) as ProfitCenterName,
		EA.BowlerCategory,
		SAR.[DefaultAccountManagerGSN],
		PR.[DistrictManagerGSN],PR.[DistrictManagerFirstName], PR.[DistrictManagerLastName], (PR.[DistrictManagerFirstName] + ' ' + PR.[DistrictManagerLastName]) as DistrictManagerName,
		PR.[AccountManagerGSN], PR.[AccountManagerFirstName], PR.[AccountManagerLastName], (PR.[AccountManagerFirstName] + ' ' + PR.[AccountManagerLastName]) as AccountManagerName,

		CASE WHEN EA.BowlerCategory is NULL THEN NULL
			 WHEN EA.BowlerCategory = 'Closed Account' THEN 'CLS'
			 WHEN EA.BowlerCategory = 'Missing' THEN 'MIS'
			 WHEN EA.BowlerCategory = '3 Months' THEN '3M'
			 WHEN EA.BowlerCategory = '6 Months' THEN '6M'
			 WHEN EA.BowlerCategory = '9 Months' THEN '9M'
			 WHEN EA.BowlerCategory = '12 Months' THEN '12M'
			 ELSE NULL
		END as BowlerCategoryID,
		--(SELECT CASE WHEN  COUNT(*) = 0 THEN NULL ELSE  convert(nvarchar(10),COUNT(*)) END
		--		FROM CDE.AssetActionStatus s 
		--		INNER JOIN CDE.AssetValidation av1 ON s.AssetValidationID = av1.AssetValidationID 
		--		WHERE av1.AssetValidationID = (SELECT TOP 1 av2.AssetValidationID					
		--									FROM CDE.AssetValidation av2 WHERE av2.EquipmentID = E.EquipmentID 
		--									ORDER BY av2.AssetValidationID DESC)
		--		AND
		--		( s.ActionTypeStatusID is NULL OR s.ActionTypeStatusID IN (SELECT ReferenceID FROM  CDE.Reference WHERE ReferenceType = 'ActionType' AND Description = 'Open'))
		--		       --554, 601, 621
		--	) AS OpenActionCount,
		(SELECT TOP 1 
				--CONVERT(VARCHAR(10),av.DateCreated,101)
				av.DateCreated					
				FROM CDE.AssetValidation av WHERE av.EquipmentID = E.EquipmentID 
				ORDER BY AssetValidationID DESC
			) AS LastAssetValidationDate,

		GetDate() as BowlerDate
FROM    CDE.Equipment AS E (NOLOCK)
		LEFT OUTER JOIN  [CDE].[EquipmentAgeCategory] AS EA (NOLOCK) on EA.[EquipmentID] = E.[EquipmentID]
		LEFT OUTER JOIN SAP.Account AS SA (NOLOCK) ON SA.SAPAccountNumber = E.CustomerNumber 
		LEFT OUTER JOIN SAP.Branch AS SB (NOLOCK) ON SB.[SAPBranchID] = E.[Branch]
		LEFT OUTER JOIN CDE.Reference RefMT (NOLOCK) ON SA.[MarketTypeID] = RefMT.[ReferenceID]
		LEFT OUTER JOIN CDE.Reference RefObjDesc (NOLOCK) ON E.[ObjectTypeId] = RefObjDesc.[ReferenceID]
		LEFT OUTER JOIN [SAP].[RouteSchedule] SR (NOLOCK) ON SR.[AccountID] = SA.AccountID 
		LEFT OUTER JOIN [SAP].[SalesRoute] SAR (NOLOCK) ON SAR.[RouteID] = SR.[RouteID] 
		LEFT OUTER JOIN [Person].[RouteDistrictManagers] PR (NOLOCK) ON PR.[AccountManagerGSN] = SAR.DefaultAccountManagerGSN AND SAR.DefaultAccountManagerGSN is not NULL
		--ORDER BY SB.[BranchName]

		WHERE E.[IsTempAssetActive] is NULL OR E.[IsTempAssetActive] = 1

GO
