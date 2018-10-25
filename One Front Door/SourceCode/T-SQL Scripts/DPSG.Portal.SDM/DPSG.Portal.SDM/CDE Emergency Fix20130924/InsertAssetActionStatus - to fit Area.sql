USE [Portal_Data]
GO

/****** Object:  StoredProcedure [CDE].[InsertAssetActionStatus]    Script Date: 9/24/2013 10:25:00 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [CDE].[InsertAssetActionStatus]
	@AssetValidationID int,
	@EquipmentNumber nvarchar(18)
AS
BEGIN

SET NOCOUNT ON

DECLARE @IsInaccessible bit
--DECLARE @MissingReasonID int
DECLARE @PercentofCompetitorProduct int
DECLARE @IsProductNeeded bit
DECLARE @AssetNumberMissingReasonID int
DECLARE @ModelNumberMissingReasonID int
DECLARE @SerialNumberMissingReasonID int
DECLARE @CustomerRequestPickup bit
DECLARE @ServiceOrderNeeded int
DECLARE @IsGraphicCurrent bit
DECLARE @AssetNumberValidated bit
DECLARE @ValidationStatus int
DECLARE @MaterialTypeID int
DECLARE @EquipmentTypeID int
DECLARE @LocationDescription varchar(100)
DECLARE @ModelNumberValidated bit
DECLARE @SerialNumberValidated bit
DECLARE @EquipmentGraphicsID int



--********************************************************************
-- CHECK IF VALIDATIONSTATUS FLAG IS 391 OR 393
-- 391 = LABEL 500 = Asset Reported Inaccessible
-- 392 = LABEL 501  = Asset reported Missing
--********************************************************************
SELECT  @ValidationStatus  = av.ValidationStatus   
	from [CDE].[AssetValidation] av (NOLOCK) WHERE AssetValidationID = @AssetValidationID


IF(@ValidationStatus IN (391,392))
BEGIN
	
IF((@ValidationStatus IS NOT NULL OR @ValidationStatus <> '') AND @ValidationStatus = 391)
	BEGIN
		INSERT INTO [CDE].[AssetActionStatus](AssetValidationID,EquipmentNumber, ActionTypeID, CreateDate, RefSubGroup)
		VALUES(@AssetValidationID,@EquipmentNumber, 500, GetDate(), CDE.udf_GetActionReferenceSubGroup(500))
	END

ELSE IF((@ValidationStatus  IS NOT NULL OR @ValidationStatus <> '') AND @ValidationStatus = 392)
	BEGIN
		INSERT INTO [CDE].[AssetActionStatus](AssetValidationID,EquipmentNumber, ActionTypeID, CreateDate, RefSubGroup)
		VALUES(@AssetValidationID,@EquipmentNumber, 501, GetDate(), CDE.udf_GetActionReferenceSubGroup(501))
	END
END
---------------------------------------------------------------
ELSE

BEGIN

-- IF VALIDATIONSTATUS IS NOT 391 OR 392, THEN PROCESS THE REST OF THE VALIDATION 
--393 = 521 = Asset was Added to this Customer
IF((@ValidationStatus IS NOT NULL OR @ValidationStatus <> '') AND @ValidationStatus = 393)
	BEGIN
		INSERT INTO [CDE].[AssetActionStatus](AssetValidationID,EquipmentNumber, ActionTypeID, CreateDate, RefSubGroup)
		VALUES(@AssetValidationID,@EquipmentNumber, 521, GetDate(), CDE.udf_GetActionReferenceSubGroup(521))
	END

------------------------------------------------------------------------------------------

--500: IF IsInaccessible is not null and = true
SELECT @IsInaccessible = av.IsInaccessible  
	from [CDE].[AssetValidation] av (NOLOCK)  WHERE AssetValidationID = @AssetValidationID
	
IF(@IsInaccessible IS NOT NULL AND @IsInaccessible =1)
	BEGIN
		INSERT INTO [CDE].[AssetActionStatus](AssetValidationID,EquipmentNumber, ActionTypeID, CreateDate, RefSubGroup)
		VALUES(@AssetValidationID,@EquipmentNumber, 500, GetDate(), CDE.udf_GetActionReferenceSubGroup(500))
	END
---------------------------------------------------------------
	
--501: IF MissingreasonID is not null and empty then insert
--SELECT @MissingReasonID = av.MissingreasonID  
--	from [CDE].[AssetValidation] av WHERE AssetValidationID = @AssetValidationID
	
--IF ((@MissingReasonID IS NOT NULL OR @MissingReasonID <> '') AND @MissingReasonID > 0)
--	BEGIN
--		INSERT INTO [CDE].[AssetActionStatus](AssetValidationID,EquipmentNumber, ActionTypeID, CreateDate, RefSubGroup)
--		VALUES(@AssetValidationID,@EquipmentNumber, 501, GetDate(), CDE.udf_GetActionReferenceSubGroup(501))
--	END
---------------------------------------------------------------

--502: IF PercentofCompetitorProduct is not null && > 0, then display with value, replace ###
SELECT @PercentofCompetitorProduct = av.PercentofCompetitorProduct  
	from [CDE].[AssetValidation] av (NOLOCK) WHERE AssetValidationID = @AssetValidationID
	
IF(@PercentofCompetitorProduct IS NOT NULL AND @PercentofCompetitorProduct > 0)
	BEGIN
		INSERT INTO [CDE].[AssetActionStatus](AssetValidationID,EquipmentNumber, ActionTypeID, CreateDate, RefSubGroup)
		VALUES(@AssetValidationID,@EquipmentNumber, 502, GetDate(), CDE.udf_GetActionReferenceSubGroup(502))
	END
---------------------------------------------------------------

--503: IsProductNeeded = true? then insert
SELECT @IsProductNeeded = av.IsProductNeeded  
	from [CDE].[AssetValidation] av (NOLOCK) WHERE AssetValidationID = @AssetValidationID
	
IF(@IsProductNeeded IS NOT NULL AND @IsProductNeeded = 1)
	BEGIN
		INSERT INTO [CDE].[AssetActionStatus](AssetValidationID,EquipmentNumber, ActionTypeID, CreateDate, RefSubGroup)
		VALUES(@AssetValidationID,@EquipmentNumber, 503, GetDate(), CDE.udf_GetActionReferenceSubGroup(503))
	END
---------------------------------------------------------------

---**************************************************************************
-- TYPE: ASSET NUMBER
-----------------------------------------------------------------------------

	--ASSETNUMBERMISSINGREASONID = NULL MEANS ASSETNUMBER IS PRESENT
	--COMPARE THE ASSET NUMBER WITH CDE.EQUIPMENT
	--CHECK FOR ASSETNUMBERENTRYREASONID
	--CHECK FOR ASSETNUMBERMISSINGREASONID

--***************************************************************************
SELECT @AssetNumberMissingReasonID = av.AssetNumberMissingReasonID  
	from [CDE].[AssetValidation] av (NOLOCK) WHERE AssetValidationID = @AssetValidationID

	IF(@AssetNumberMissingReasonID IS NULL OR @AssetNumberMissingReasonID = 0 )
	--ASSET NUMBER IS PRESENT
	BEGIN
		declare @assetno nvarchar(20)
		declare @assetnoEquip nvarchar(20)
		
		--get asset number from assetvalidation table
		set @assetno = (select assetnumber from [CDE].[AssetValidation] (NOLOCK) where AssetValidationID = @AssetValidationID)
		--get asset number from cde.equipment table (inventorynumber)
		set @assetnoEquip = (select top 1 InventoryNumber from cde.equipment (NOLOCK)  where equipmentnumber = @EquipmentNumber)

		--compare if NOT Equal
		IF(@assetno <> @assetnoEquip)
		BEGIN
			-- 520: Asset # changed from (###SAP###) to (###FieldEntry###)
			INSERT INTO [CDE].[AssetActionStatus](AssetValidationID,EquipmentNumber, ActionTypeID, CreateDate, RefSubGroup)
			VALUES(@AssetValidationID,@EquipmentNumber, 520, GetDate(), CDE.udf_GetActionReferenceSubGroup(520))
		END	

		/*CHECK FOR ENTRY REASON ID
		declare @entryreasonid int
		set @entryreasonid = (select assetnumberentryreasonid from [CDE].[AssetValidation] where AssetValidationID = @AssetValidationID)
		IF(@entryreasonid IS NOT NULL OR @entryreasonid <> '')
		BEGIN
			--INSERT ENTRY REASON ID
			INSERT INTO [CDE].[AssetActionStatus](AssetValidationID,EquipmentNumber, ActionTypeID, CreateDate, RefSubGroup)
			VALUES(@AssetValidationID,@EquipmentNumber, @entryreasonid, GetDate(), CDE.udf_GetActionReferenceSubGroup(@entryreasonid))
		END*/
	END
	--- ASSET NUMBER MISSING
	ELSE IF(@AssetNumberMissingReasonID IS NOT NULL OR @AssetNumberMissingReasonID <> '')
	BEGIN
			--INSERT MISSING REASON ID
			-- 510: Asset Tag - Asset # damaged or missing
			INSERT INTO [CDE].[AssetActionStatus](AssetValidationID,EquipmentNumber, ActionTypeID, CreateDate, RefSubGroup)
			VALUES(@AssetValidationID,@EquipmentNumber, 510, GetDate(), CDE.udf_GetActionReferenceSubGroup(510))
	END

---********************************************************************************************************************************************************************************


---**************************************************************************
-- TYPE: SERIAL NUMBER
-----------------------------------------------------------------------------

	--SERIALNUMBERMISSINGREASONID = NULL MEANS SERIAL NUMBER IS PRESENT
	--COMPARE THE SERIAL NUMBER WITH CDE.EQUIPMENT
	--CHECK FOR SERIALNUMBERENTRYREASONID
	--CHECK FOR SERIALNUMBERMISSINGREASONID

--***************************************************************************
SELECT @SerialNumberMissingReasonID = av.SerialNumberMissingReasonID  
	from [CDE].[AssetValidation] av (NOLOCK) WHERE AssetValidationID = @AssetValidationID

	IF(@SerialNumberMissingReasonID IS NULL OR @SerialNumberMissingReasonID = 0 )
	--SERIAL NUMBER IS PRESENT
	BEGIN
		declare @serialno nvarchar(20)
		declare @serialnoEquip nvarchar(20)
		
		--get serial number from assetvalidation table
		set @serialno = (select serialnumber from [CDE].[AssetValidation] (NOLOCK)  where AssetValidationID = @AssetValidationID)
		--get serial number from cde.equipment table
		set @serialnoEquip = (select top 1 serialnumber from cde.equipment (NOLOCK) where equipmentnumber = @EquipmentNumber)

		--compare if NOT Equal
		IF(@serialno <> @serialnoEquip)
		BEGIN
			-- 526: Serial # changed from (###SAP###) to (###FieldEntry###)
			INSERT INTO [CDE].[AssetActionStatus](AssetValidationID,EquipmentNumber, ActionTypeID, CreateDate, RefSubGroup)
			VALUES(@AssetValidationID,@EquipmentNumber, 526, GetDate(), CDE.udf_GetActionReferenceSubGroup(526))
		END	

		/*CHECK FOR ENTRY REASON ID
		declare @entryreasonidserialnumber int
		set @entryreasonidserialnumber = (select serialnumberentryreasonid from [CDE].[AssetValidation] where AssetValidationID = @AssetValidationID)
		IF(@entryreasonidserialnumber IS NOT NULL OR @entryreasonidserialnumber <> '')
		BEGIN
			--INSERT ENTRY REASON ID
			INSERT INTO [CDE].[AssetActionStatus](AssetValidationID,EquipmentNumber, ActionTypeID, CreateDate, RefSubGroup)
			VALUES(@AssetValidationID,@EquipmentNumber, @entryreasonidserialnumber, GetDate(), CDE.udf_GetActionReferenceSubGroup(@entryreasonidserialnumber))
		END*/
	END
	--- SERIAL NUMBER MISSING
	ELSE IF(@SerialNumberMissingReasonID IS NOT NULL OR @SerialNumberMissingReasonID <> '')
	BEGIN
			--INSERT MISSING REASON ID
			-- 512: Asset Tag - Serial # damaged or missing
			INSERT INTO [CDE].[AssetActionStatus](AssetValidationID,EquipmentNumber, ActionTypeID, CreateDate, RefSubGroup)
			VALUES(@AssetValidationID,@EquipmentNumber, 512, GetDate(), CDE.udf_GetActionReferenceSubGroup(512))
	END

---********************************************************************************************************************************************************************************


---**************************************************************************
-- TYPE: MODEL NUMBER
-----------------------------------------------------------------------------

	--SERIALNUMBERMISSINGREASONID = NULL MEANS SERIAL NUMBER IS PRESENT
	--COMPARE THE SERIAL NUMBER WITH CDE.EQUIPMENT
	--CHECK FOR SERIALNUMBERENTRYREASONID
	--CHECK FOR SERIALNUMBERMISSINGREASONID

--***************************************************************************
SELECT @ModelNumberMissingReasonID = av.ModelNumberMissingReasonID  
	from [CDE].[AssetValidation] av (NOLOCK) WHERE AssetValidationID = @AssetValidationID

	IF(@ModelNumberMissingReasonID IS NULL OR @ModelNumberMissingReasonID = 0 )
	--MODEL NUMBER IS PRESENT
	BEGIN
		declare @modelno nvarchar(20)
		declare @modelnoEquip nvarchar(20)
		
		--get model number from assetvalidation table
		set @modelno = (select modelnumber from [CDE].[AssetValidation] (NOLOCK) where AssetValidationID = @AssetValidationID)
		--get model number from cde.equipment table
		set @modelnoEquip = (select top 1 modelnumber from cde.equipment (NOLOCK) where equipmentnumber = @EquipmentNumber)

		--compare if NOT Equal
		IF(@modelno <> @modelnoEquip)
		BEGIN
			-- 525: Model # changed from (###SAP###) to (###FieldEntry###)
			INSERT INTO [CDE].[AssetActionStatus](AssetValidationID,EquipmentNumber, ActionTypeID, CreateDate, RefSubGroup)
			VALUES(@AssetValidationID,@EquipmentNumber, 525, GetDate(), CDE.udf_GetActionReferenceSubGroup(525))
		END	

		/*CHECK FOR ENTRY REASON ID
		declare @entryreasonidmodelnumber int
		set @entryreasonidmodelnumber = (select modelnumberentryreasonid from [CDE].[AssetValidation] where AssetValidationID = @AssetValidationID)
		IF(@entryreasonidmodelnumber IS NOT NULL OR @entryreasonidmodelnumber <> '')
		BEGIN
			--INSERT ENTRY REASON ID
			INSERT INTO [CDE].[AssetActionStatus](AssetValidationID,EquipmentNumber, ActionTypeID, CreateDate, RefSubGroup)
			VALUES(@AssetValidationID,@EquipmentNumber, @entryreasonidmodelnumber, GetDate(), CDE.udf_GetActionReferenceSubGroup(@entryreasonidmodelnumber))
		END*/
	END
	--- MODEL NUMBER MISSING
	ELSE IF(@ModelNumberMissingReasonID IS NOT NULL OR @ModelNumberMissingReasonID <> '')
	BEGIN
			--INSERT MISSING REASON ID
			-- 511: Asset Tag - Model # damaged or missing
			INSERT INTO [CDE].[AssetActionStatus](AssetValidationID,EquipmentNumber, ActionTypeID, CreateDate, RefSubGroup)
			VALUES(@AssetValidationID,@EquipmentNumber, 511, GetDate(), CDE.udf_GetActionReferenceSubGroup(511))
	END

---********************************************************************************************************************************************************************************




--513: @CustomerRequestPickup is not null/empty, then insert
SELECT  @CustomerRequestPickup = av.CustomerRequestPickup  
	from [CDE].[AssetValidation] av (NOLOCK) WHERE AssetValidationID = @AssetValidationID
	
IF(@CustomerRequestPickup IS NOT NULL AND @CustomerRequestPickup =1)
	BEGIN
		INSERT INTO [CDE].[AssetActionStatus](AssetValidationID,EquipmentNumber, ActionTypeID, CreateDate, RefSubGroup)
		VALUES(@AssetValidationID,@EquipmentNumber, 513, GetDate(), CDE.udf_GetActionReferenceSubGroup(513))
	END
---------------------------------------------------------------

--514: @ServiceOrderTypeID is not null/empty, then insert
SELECT  @ServiceOrderNeeded = av.ServiceOrderTypeID
	from [CDE].[AssetValidation] av (NOLOCK) WHERE AssetValidationID = @AssetValidationID
	
IF(@ServiceOrderNeeded IS NOT NULL AND @ServiceOrderNeeded > 0 AND @ServiceOrderNeeded <> 370)
	BEGIN
		INSERT INTO [CDE].[AssetActionStatus](AssetValidationID,EquipmentNumber, ActionTypeID, CreateDate, RefSubGroup)
		VALUES(@AssetValidationID,@EquipmentNumber, 514, GetDate(), CDE.udf_GetActionReferenceSubGroup(514))
	END
---------------------------------------------------------------

--515: @IsGraphicCurrent = false
SELECT  @IsGraphicCurrent = av.IsGraphicCurrent  
	from [CDE].[AssetValidation] av (NOLOCK) WHERE AssetValidationID = @AssetValidationID
	
IF(@IsGraphicCurrent IS NOT NULL AND @IsGraphicCurrent = 0)
	BEGIN
		INSERT INTO [CDE].[AssetActionStatus](AssetValidationID,EquipmentNumber, ActionTypeID, CreateDate, RefSubGroup)
		VALUES(@AssetValidationID,@EquipmentNumber, 515, GetDate(), CDE.udf_GetActionReferenceSubGroup(515))
	END
---------------------------------------------------------------


--522: materialtypeid is not null && <> cde.equipment.material then...
SELECT  @MaterialTypeID  = av.MaterialTypeID   
	from [CDE].[AssetValidation] av (NOLOCK) WHERE AssetValidationID = @AssetValidationID
	
IF(@MaterialTypeID IS NOT NULL AND @MaterialTypeID <> (SELECT EquipmentCategory from CDE.Equipment (NOLOCK) WHERE EquipmentNumber = @EquipmentNumber))
	BEGIN
		INSERT INTO [CDE].[AssetActionStatus](AssetValidationID,EquipmentNumber, ActionTypeID, CreateDate, RefSubGroup)
		VALUES(@AssetValidationID,@EquipmentNumber, 522, GetDate(), CDE.udf_GetActionReferenceSubGroup(522))
	END
---------------------------------------------------------------

--523: EquipmentTypeID is not null && <> cde.equipment.objectTypeId? then...
SELECT  @EquipmentTypeID  = av.EquipmentTypeID   
	from [CDE].[AssetValidation] av (NOLOCK) WHERE AssetValidationID = @AssetValidationID
	
IF(@EquipmentTypeID IS NOT NULL AND @EquipmentTypeID <> (SELECT CASE WHEN ObjectTypeId is null THEN 0 ELSE ObjectTypeId END from CDE.Equipment (NOLOCK) WHERE EquipmentNumber = @EquipmentNumber))
	BEGIN
		INSERT INTO [CDE].[AssetActionStatus](AssetValidationID,EquipmentNumber, ActionTypeID, CreateDate, RefSubGroup)
		VALUES(@AssetValidationID,@EquipmentNumber, 523, GetDate(), CDE.udf_GetActionReferenceSubGroup(523))
	END
---------------------------------------------------------------

--524: LocationDescription is not null && <> cde.equoipment.locationasset? then..
SELECT  @LocationDescription  = av.LocationDescription   
	from [CDE].[AssetValidation] av (NOLOCK) WHERE AssetValidationID = @AssetValidationID
	
IF(@LocationDescription IS NOT NULL AND @LocationDescription <> (SELECT LocationAsset from CDE.Equipment (NOLOCK) WHERE EquipmentNumber = @EquipmentNumber))
	BEGIN
		INSERT INTO [CDE].[AssetActionStatus](AssetValidationID,EquipmentNumber, ActionTypeID, CreateDate, RefSubGroup)
		VALUES(@AssetValidationID,@EquipmentNumber, 524, GetDate(), CDE.udf_GetActionReferenceSubGroup(524))
	END
---------------------------------------------------------------


--527: EquipmentGraphicsID is not null && <> cde.equipment.trademarkid
SELECT  @EquipmentGraphicsID   = av.EquipmentGraphicsID    
	from [CDE].[AssetValidation] av (NOLOCK) WHERE AssetValidationID = @AssetValidationID
	
IF(@EquipmentGraphicsID IS NOT NULL AND @EquipmentGraphicsID <> (SELECT CASE WHEN TrademarkId IS null THEN -1 ELSE TrademarkId END from CDE.Equipment (NOLOCK) WHERE EquipmentNumber = @EquipmentNumber))
	BEGIN
		INSERT INTO [CDE].[AssetActionStatus](AssetValidationID,EquipmentNumber, ActionTypeID, CreateDate, RefSubGroup)
		VALUES(@AssetValidationID,@EquipmentNumber, 527, GetDate(), CDE.udf_GetActionReferenceSubGroup(527))
	END
---------------------------------------------------------------

 END

 END

GO

