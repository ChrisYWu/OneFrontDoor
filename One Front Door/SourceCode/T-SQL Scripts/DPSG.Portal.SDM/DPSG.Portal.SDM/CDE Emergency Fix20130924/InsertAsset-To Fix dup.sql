USE [Portal_Data]
GO

/****** Object:  StoredProcedure [CDE].[pInsertAssetValidation]    Script Date: 9/24/2013 9:59:42 AM ******/
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


-- verify that we do not have this record alreaady - compensate for mutlitple transmition on failure.
DECLARE @dupCount as INT

SELECT @dupCount = COUNT(*) from [CDE].[AssetValidation] WHERE [DateCreated] = @DateCreated AND [EquipmentNumber] = @EquipmentNumber

IF ( @dupCount > 0 )  
BEGIN
	SELECT top 1 @AssetValidationID = AssetValidationID from [CDE].[AssetValidation] WHERE [DateCreated] = @DateCreated AND [EquipmentNumber] = @EquipmentNumber
		ORDER BY AssetValidationID DESC
			
	RETURN @AssetValidationID
END


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
	  SR.[BUName] as [BusinessUnit]
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
		LEFT JOIN MVIEW.LocationHIER SR on SR.[BranchID] = SB.[BranchID] -- region name
		LEFT JOIN SAP.[ProfitCenter] SP on SP.[BranchID] = SB.[BranchID] -- profit center
		--LEFT JOIN [SAP].[BusinessUnit] SBU on SBU.[BUID] = SR.[BUID] -- business unit
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
           
		   UPDATE [CDE].[Equipment] SET [LastModified] = GETDATE() WHERE EquipmentID = @EquipmentID

		   SET @AssetValidationID = SCOPE_IDENTITY()

		   EXEC [CDE].[InsertAssetActionStatus] @AssetValidationID, @EquipmentNumber

		   RETURN @AssetValidationID

 END

 

GO

