use Portal_Data_INT
Go

/*
---- Deployment log ----

*/
------------------------------------------------
--- SP------------------------------------------
--##############################################
------------------------------------------------
If Exists (Select * From sys.procedures Where object_id = object_id('Precal.pRefreshLookups'))
Begin
	Drop Proc Precal.pRefreshLookups
	Print 'Precal.pRefreshLookups dropped'
End
Go

---#################

If Exists (Select * From sys.procedures Where object_id = object_id('PreCal.pReMapDSDPromotions'))
Begin
	Drop Proc PreCal.pReMapDSDPromotions
	Print 'Precal.pReMapDSDPromotions dropped'
End
Go

---##################
If Exists (Select * From sys.procedures Where object_id = object_id('PreCal.pReMapBCPromotions'))
Begin
	Drop Proc PreCal.pReMapBCPromotions
	Print 'Precal.pReMapBCPromotions dropped'
End
Go

---##################
If Exists (Select * From sys.procedures Where object_id = object_id('Precal.pPupulateChainGroupTree'))
Begin
	Drop Proc Precal.pPupulateChainGroupTree
	Print 'Precal.pPupulateChainGroupTree dropped'
End
Go

---##################
If Exists (Select * From sys.procedures Where object_id = object_id('Playbook.pSaveBCPromotion'))
Begin
	Drop Proc Playbook.pSaveBCPromotion
	Print 'Playbook.pSaveBCPromotion dropped'
End
Go

---##################
If Exists (Select * From sys.procedures Where object_id = object_id('Playbook.pSaveDSDPromotion'))
Begin
	Drop Proc Playbook.pSaveDSDPromotion
	Print 'Playbook.pSaveDSDPromotion dropped'
End
Go

---##################
ALTER PROCEDURE [Playbook].[pInsertUpdatePromotion] (
	--we will add column to save brand-package in json format                                                                                                                     
	@Mode VARCHAR(500)
	,@PromotionID INT
	,@PromotionDescription VARCHAR(500)
	,@PromotionName VARCHAR(500)
	,@PromotionTypeID INT
	,@GEOInfo XML
	,@AccountInfo XML
	,@ChannelInfo XML
	,@StateXML XML
	,@AccountId INT
	,@EdgeItemId INT
	,@IsLocalized BIT
	,@PromotionTradeMarkID VARCHAR(500)
	,@PromotionBrandId VARCHAR(500)
	,@PromotionPackageID VARCHAR(500)
	,@PromotionPrice VARCHAR(500)
	,@PromotionCategoryId INT
	,@PromotionDisplayLocationId INT
	,@PromotionDisplayLocationOther VARCHAR(500)
	,@PromotionDisplayRequirement VARCHAR(20)
	,@PromotionStartDate DATETIME
	,@PromotionEndDate DATETIME
	,@PromotionStatus VARCHAR(500)
	,@SystemID VARCHAR(500)
	--,@IsDuplicate BIT              
	,@ParentPromoId INT
	,@IsNewVersion BIT
	,@ForecastVolume VARCHAR(500)
	,@NationalDisplayTarget VARCHAR(500)
	,@BottlerCommitment VARCHAR(500)
	,@BranchId INT
	,@BUID INT
	,@RegionId INT
	,@CreatedBy VARCHAR(500)
	,@ModifiedBy VARCHAR(500)
	,@AccountImageName VARCHAR(50)
	,@PromotionGroupID INT
	,@ProgramId INT
	,@BestBets NVARCHAR(48)
	,@EdgeComments NVARCHAR(250)
	,@IsNationalPromotion BIT -- True/False if the user has the permission to create NA Promotions                                      
	,@PromotionDisplayStartDate DATETIME
	,@PromotionDisplayEndDate DATETIME
	,@PromotionPricingStartDate DATETIME
	,@PromotionPricingEndDate DATETIME
	,@VariableRPC VARCHAR(50)
	,@Redemption INT
	,@FixedCost VARCHAR(50)
	,@AccrualComments VARCHAR(500)
	,@Unit VARCHAR(50)
	,@Accounting VARCHAR(50)
	,@IsSMA BIT
	,@IsCostPerStore BIT
	,@TPMNumberCASO VARCHAR(20)
	,@TPMNumberPASO VARCHAR(20)
	,@TPMNumberISO VARCHAR(20)
	,@TPMNumberPB VARCHAR(100)
	,@RoleName VARCHAR(50) -- Add new Pram as Role Name for get persona             
	,@PromotionDisplayTypeId INT
	,@PersonaID INT
	,@COSTPerStore VARCHAR(50)
	,@Status INT OUT
	,@Message VARCHAR(500) OUT
	,@NewPromoId INT OUT
	,@InformationCategory NVARCHAR(100)
	)
AS
BEGIN
	DECLARE @PromotionStatusId INT

	if(convert(varchar(30),@PromotionDisplayStartDate,101)='01/01/1900')
		set @PromotionDisplayStartDate = null
	if(convert(varchar(30),@PromotionDisplayEndDate,101)='01/01/1900')
		set @PromotionDisplayEndDate = null
	if(convert(varchar(30),@PromotionPricingStartDate,101)='01/01/1900')
		set @PromotionPricingStartDate = null
	if(convert(varchar(30),@PromotionPricingEndDate,101)='01/01/1900')
		set @PromotionPricingEndDate = null

	--Fetch promotion status id by promotion status                                                               
	SELECT @PromotionStatusId = StatusID
	FROM PlayBook.STATUS
	WHERE LOWER(StatusName) = LOWER(@PromotionStatus)

	DECLARE @Attachments TABLE (
		Id INT identity
		,PromoId INT
		,Url VARCHAR(500)
		,NAME VARCHAR(500)
		)
	DECLARE @tblTradeMark TABLE (
		Id INT identity(1, 1)
		,TradeMarkId VARCHAR(100)
		)
	DECLARE @tblBrands TABLE (
		Id INT identity(1, 1)
		,BrandId VARCHAR(100)
		)
	DECLARE @tblPackage TABLE (
		Id INT identity(1, 1)
		,PackageId VARCHAR(100)
		)
	-- Fatching User Group Name from  table                            
	DECLARE @UserGroupName VARCHAR(50)

	SELECT @UserGroupName = UserGroupName
	FROM Playbook.UserGroup
	WHERE RoleName = @RoleName

	--print @UserGroupName                    
	IF (@Mode = 'Insert')
	BEGIN
		-- Insert promotion
		--select MAX(promotionid) from PlayBook.RetailPromotion
		--SELECT * from PlayBook.RetailPromotion where promotionid = 24571
		INSERT INTO PlayBook.RetailPromotion (
			PromotionName
			,PromotionDescription
			,PromotionTypeID
			,PromotionPrice
			,PromotionCategoryID
			,PromotionStatusID
			,PromotionStartDate
			,PromotionEndDate
			,ForecastVolume
			,NationalDisplayTarget
			,BottlerCommitment
			,PromotionBranchID
			,PromotionBUID
			,PromotionRegionID
			,EDGEItemID
			,IsLocalized
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,AccountImageName
			,InformationCategory
			,PromotionGroupID
			,ProgramId
			,NationalChainID
			,IsNationalAccount
			,StatusModifiedDate
			,BestBets
			,EdgeComments
			,PromotionRelevantStartDate
			,PromotionRelevantEndDate
			,DisplayStartDate -- new date fields                                    
			,DisplayEndDate -- new date fields                                    
			,PricingStartDate -- new date fields                                    
			,PricingEndDate -- new date fields                 
			,IsSMA
			,IsCostPerStore
			,TPMCASO
			,TPMPASO
			,TPMISO
			,TPMPB
			,PersonaID
			,UserGroupName
			,DisplayTypeID
			,CostPerStore
			,RPC
			,Redemption
			,FixedCost
			,AccrualComments
			,Unit
			,Accounting
			)
		VALUES (
			@PromotionName
			,@PromotionDescription
			,@PromotionTypeID
			,@PromotionPrice
			,@PromotionCategoryId
			,@PromotionStatusId
			,@PromotionStartDate
			,@PromotionEndDate
			,@ForecastVolume
			,@NationalDisplayTarget
			,@BottlerCommitment
			,@BranchId
			,@BUID
			,@RegionId
			,@EdgeItemId
			,@IsLocalized
			,@CreatedBy
			,GETUTCDATE()
			,@ModifiedBy
			,GETUTCDATE()
			,@AccountImageName
			,@InformationCategory
			,@PromotionGroupID
			,@ProgramId
			,@AccountId
			,@IsNationalPromotion
			,GETUTCDATE()
			,@BestBets
			,@EdgeComments
			,CASE 
				WHEN DATENAME(DW, @PromotionStartDate) = 'Sunday'
					THEN DATEADD(wk, DATEDIFF(wk, 0, @PromotionStartDate), - 7)
				ELSE DATEADD(wk, DATEDIFF(wk, 7, @PromotionStartDate), 7)
				END
			,CASE 
				WHEN DATENAME(DW, @PromotionEndDate) = 'Sunday'
					THEN @PromotionEndDate
				ELSE DATEADD(wk, DATEDIFF(wk, 6, @PromotionEndDate), 6 + 7)
				END
			,@PromotionDisplayStartDate
			,@PromotionDisplayEndDate
			,@PromotionPricingStartDate
			,@PromotionPricingEndDate
			,@IsSMA
			,@IsCostPerStore
			,@TPMNumberCASO
			,@TPMNumberPASO
			,@TPMNumberISO
			,@TPMNumberPB
			,@PersonaID
			,@UserGroupName
			,@PromotionDisplayTypeId
			,@COSTPerStore
			,@VariableRPC
			,@Redemption
			,@FixedCost
			,@AccrualComments
			,@Unit
			,@Accounting
			)

		SET @PromotionID = SCOPE_IDENTITY()
		SET @NewPromoId = @PromotionID;

		----To create duplicate promotion                                                                           
		IF (@IsNewVersion = 1)
			UPDATE PlayBook.RetailPromotion
			SET ParentPromotionID = @ParentPromoId
				,islocalized = 1
			WHERE PromotionID = @PromotionID

		----Save data for display location . for other option we have update PromotionDisplayLocationOther column in PlayBook.PromotionDisplayLocation                                                                                                              
		--IF (@PromotionDisplayLocationId = 23) --23 id for other option in display location                                                                                                                  
		--BEGIN                                      
		INSERT INTO PlayBook.PromotionDisplayLocation (
			PromotionID
			,DisplayLocationID
			,PromotionDisplayLocationOther
			,DisplayRequirement
			)
		VALUES (
			@PromotionID
			,@PromotionDisplayLocationId
			,@PromotionDisplayLocationOther
			,@PromotionDisplayRequirement
			)

		--END                                 
		--ELSE                                      
		--BEGIN                                      
		-- INSERT INTO PlayBook.PromotionDisplayLocation (                                      
		--  PromotionID                                      
		--  ,DisplayLocationID                                      
		--  )                                      
		-- VALUES (                                      
		--  @PromotionID                                      
		--  ,@PromotionDisplayLocationId                                      
		--  )                                      
		--END                 
		----Add account for Promotion                                                                
		--IF(@PromotionTypeID=2)--Regional chain                                                                                          
		--INSERT INTO PlayBook.PromotionAccount(PromotionID,RegionalChainID) VALUES(@PromotionID,@AccountId)                                                                
		--IF(@PromotionTypeID=1)--National chain                                                                                                           
		--INSERT INTO PlayBook.PromotionAccount( PromotionID , NationalChainID ) VALUES( @PromotionID , @AccountId )                                                                                  
		--IF(@PromotionTypeID=3)--Local chain                                                                
		-- INSERT INTO PlayBook.PromotionAccount(PromotionID, LocalChainID) VALUES(@PromotionID,@AccountId)                                                                              
		INSERT INTO PlayBook.PromotionAccount (
			PromotionID
			,LocalChainID
			,RegionalChainID
			,NationalChainID
			)
		SELECT DISTINCT @PromotionID AS PromotionID
			,item.value('LocalChainID[1]', 'varchar(100)') AS LocalChainID
			,item.value('RegionalChainID[1]', 'varchar(100)') AS RegionalChainID
			,item.value('NationalChainID[1]', 'varchar(100)') AS NationalChainID
		--,item.value('IsRoot[1]', 'varchar(100)') AS IsRoot          
		FROM @AccountInfo.nodes('Account/Item') AS items(item)

		--   -- Insert trade mark for promotion                                                                                     
		INSERT INTO @tblTradeMark (TradeMarkId)
		SELECT *
		FROM CDE.udfSplit(@PromotionTradeMarkID, ',')
		WHERE Value != ''
			AND Value IS NOT NULL

		INSERT INTO PlayBook.PromotionBrand (
			PromotionID
			,TrademarkID
			)
		SELECT @PromotionID
			,CAST(TradeMarkId AS INT)
		FROM @tblTradeMark

		----   -- Insert System for promotion                                                          
		--INSERT INTO @tblPromotionSystem (SystemId)                            
		--SELECT *                            
		--FROM CDE.udfSplit(@SystemID, ',')                            
		--INSERT INTO PlayBook.PromotionSystem (                            
		-- PromotionID                            
		-- ,SystemID                            
		-- )                            
		--SELECT @PromotionID                            
		-- ,CAST(SystemId AS INT)                            
		--FROM @tblPromotionSystem                            
		--Insert Brand instead of trademark for Core Ten Category                                                                                            
		IF (@PromotionBrandId != '')
		BEGIN
			INSERT INTO @tblBrands (BrandId)
			SELECT *
			FROM CDE.udfSplit(@PromotionBrandId, ',')
			WHERE Value != ''
				AND Value IS NOT NULL

			INSERT INTO PlayBook.PromotionBrand (
				PromotionID
				,BrandID
				)
			SELECT @PromotionID
				,CAST(BrandId AS INT)
			FROM @tblBrands
		END

		--Insert Package for promotion                                                                                                                  
		INSERT INTO @tblPackage (PackageId)
		SELECT *
		FROM CDE.udfSplit(@PromotionPackageID, ',')
		WHERE Value != ''
			AND Value IS NOT NULL

		INSERT INTO PlayBook.PromotionPackage (
			PromotionID
			,PackageID
			)
		SELECT @PromotionID
			,CAST(PackageId AS INT)
		FROM @tblPackage

		-- Insert GEO relevancy                                                                   
		EXEC Playbook.[PInsertUpdatePromotionGEORelevancy] @PromotionID
			,@GEOInfo
			,@SystemID

		--INSERT INTO PlayBook.PromotionGeoRelevancy (                              
		-- PromotionID                              
		-- ,BUID                              
		-- ,RegionId   
		-- ,BranchId                              
		-- ,AreaId                              
		-- )                              
		--SELECT @PromotionID AS PromotionID                              
		-- ,item.value('BUID[1]', 'varchar(500)') AS BUID                              
		-- ,item.value('RegionId[1]', 'varchar(500)') AS RegionID                              
		-- ,item.value('BranchId[1]', 'varchar(500)') AS BranchId                              
		-- ,item.value('AreaId[1]', 'varchar(500)') AS AreaId                              
		--FROM @GEOInfo.nodes('GEO/Item') AS items(item)                      
		---Channel---                                                                  
		INSERT INTO PlayBook.PromotionChannel
		SELECT (
				CASE 
					WHEN item.value('SuperChannelID[1]', 'varchar(100)') = ''
						THEN NULL
					ELSE CAST(item.value('SuperChannelID[1]', 'varchar(100)') AS INT)
					END
				) AS SuperChannelID
			,(
				CASE 
					WHEN item.value('ChannelID[1]', 'varchar(100)') = ''
						THEN NULL
					ELSE CAST(item.value('ChannelID[1]', 'varchar(100)') AS INT)
					END
				) AS ChannelID
			,@PromotionID AS PromotionID
		FROM @ChannelInfo.nodes('Channel/Item') AS items(item)

		SET @Status = 1
		SET @Message = 'Promotion has been inserted successfully.'
	END

	--Update Promotion                         
	IF (@Mode = 'Update')
	BEGIN
		UPDATE PlayBook.RetailPromotion
		SET PromotionName = @PromotionName
			,PromotionDescription = @PromotionDescription
			,PromotionTypeID = @PromotionTypeID
			,PromotionPrice = @PromotionPrice
			,PromotionCategoryID = @PromotionCategoryId
			,PromotionDisplayLocationID = @PromotionDisplayLocationID
			,PromotionStatusID = @PromotionStatusId
			,PromotionStartDate = @PromotionStartDate
			,PromotionEndDate = @PromotionEndDate
			,ForecastVolume = @ForecastVolume
			,NationalDisplayTarget = @NationalDisplayTarget
			,BottlerCommitment = @BottlerCommitment
			,PromotionBranchID = @BranchId
			,PromotionBUID = @BUID
			,PromotionRegionID = @RegionId
			,EDGEItemID = @EdgeItemId
			,ModifiedBy = @ModifiedBy
			,ModifiedDate = GETUTCDATE()
			,AccountImageName = @AccountImageName
			,PromotionGroupID = @PromotionGroupID
			,ProgramId = @ProgramID
			,NationalChainID = @AccountId
			,BestBets = @BestBets
			,InformationCategory = @InformationCategory
			,EdgeComments = @EdgeComments
			,StatusModifiedDate = CASE 
				WHEN PromotionStatusID = @PromotionStatusId
					THEN StatusModifiedDate
				ELSE GETUTCDATE()
				END
			,PromotionRelevantStartDate = CASE 
				WHEN DATENAME(DW, @PromotionStartDate) = 'Sunday'
					THEN DATEADD(wk, DATEDIFF(wk, 0, @PromotionStartDate), - 7)
				ELSE DATEADD(wk, DATEDIFF(wk, 7, @PromotionStartDate), 7)
				END
			,PromotionRelevantEndDate = CASE 
				WHEN DATENAME(DW, @PromotionEndDate) = 'Sunday'
					THEN @PromotionEndDate
				ELSE DATEADD(wk, DATEDIFF(wk, 6, @PromotionEndDate), 6 + 7)
				END
			,DisplayStartDate = @PromotionDisplayStartDate
			,DisplayEndDate = @PromotionDisplayEndDate
			,PricingStartDate = @PromotionPricingStartDate
			,PricingEndDate = @PromotionPricingEndDate
			,IsSMA = @IsSMA
			,IsCostPerStore = @IsCostPerStore
			,TPMCASO = @TPMNumberCASO
			,TPMPASO = @TPMNumberPASO
			,TPMISO = @TPMNumberISO
			,TPMPB = @TPMNumberPB
			,DisplayTypeID = @PromotionDisplayTypeId
			,CostPerStore = @COSTPerStore
			,RPC = @VariableRPC
			,Redemption = @Redemption
			,FixedCost = @FixedCost
			,AccrualComments = @AccrualComments
			,Unit = @Unit
			,Accounting = @Accounting
		WHERE PromotionId = @PromotionID

		--IF (@PromotionDisplayLocationId = 23)                                      
		--BEGIN                                      
		UPDATE PlayBook.PromotionDisplayLocation
		SET DisplayLocationID = @PromotionDisplayLocationId
			,PromotionDisplayLocationOther = @PromotionDisplayLocationOther
			,DisplayRequirement = @PromotionDisplayRequirement
		WHERE PromotionID = @PromotionID;

		--Deleting priority if change in account
		IF EXISTS (
				SELECT isnull(localchainid, 0) + isnull(regionalchainid, 0) + isnull(nationalchainid, 0)
				FROM PlayBook.PromotionAccount
				WHERE PromotionID = @PromotionID
					AND isnull(localchainid, 0) + isnull(regionalchainid, 0) + isnull(nationalchainid, 0) NOT IN (
						SELECT isnull(item.value('LocalChainID[1]', 'varchar(100)'), 0) + isnull(item.value('RegionalChainID[1]', 'varchar(100)'), 0) + isnull(item.value('NationalChainID[1]', 'varchar(100)'), 0)
						FROM @AccountInfo.nodes('Account/Item') AS items(item)
						)
				)
		BEGIN
			UPDATE playbook.promotionrank
			SET Rank = NULL
			WHERE PromotionID = @PromotionID
		END

		--Promotion account      
		DELETE PlayBook.PromotionAccount
		WHERE PromotionID = @PromotionID

		INSERT INTO PlayBook.PromotionAccount (
			PromotionID
			,LocalChainID
			,RegionalChainID
			,NationalChainID
			)
		SELECT DISTINCT @PromotionID AS PromotionID
			,item.value('LocalChainID[1]', 'varchar(100)') AS LocalChainID
			,item.value('RegionalChainID[1]', 'varchar(100)') AS RegionalChainID
			,item.value('NationalChainID[1]', 'varchar(100)') AS NationalChainID
		--,item.value('IsRoot[1]', 'varchar(100)') AS IsRoot          
		FROM @AccountInfo.nodes('Account/Item') AS items(item)

		--Delete Brands and Insert new so that we can have updated brands for promotion.                                                                                                                  
		DELETE PlayBook.PromotionBrand
		WHERE PromotionID = @PromotionID

		--Insert TradeMark for promotion                                                                                                                    
		INSERT INTO @tblTradeMark (TradeMarkId)
		SELECT *
		FROM CDE.udfSplit(@PromotionTradeMarkID, ',')

		INSERT INTO PlayBook.PromotionBrand (
			PromotionID
			,TrademarkID
			)
		SELECT @PromotionID
			,CAST(TradeMarkId AS INT)
		FROM @tblTradeMark

		SET @Message = 'Promotion brand has been updated successfully.'

		----  -- Insert System for promotion                                                          
		--DELETE PlayBook.PromotionSystem                            
		--WHERE PromotionID = @PromotionID                            
		--INSERT INTO @tblPromotionSystem (SystemId)       
		--SELECT *                            
		--FROM CDE.udfSplit(@SystemID, ',')                            
		--INSERT INTO PlayBook.PromotionSystem (                            
		-- PromotionID                            
		-- ,SystemID                            
		-- )                            
		--SELECT @PromotionID                            
		-- ,CAST(SystemId AS INT)                            
		--FROM @tblPromotionSystem                            
		--Insert brandid instead of trademarkid for core ten category                                                                                            
		IF (@PromotionBrandId != '')
		BEGIN
			INSERT INTO @tblBrands (BrandId)
			SELECT *
			FROM CDE.udfSplit(@PromotionBrandId, ',')

			INSERT INTO PlayBook.PromotionBrand (
				PromotionID
				,BrandID
				)
			SELECT @PromotionID
				,CAST(BrandId AS INT)
			FROM @tblBrands
		END

		--Insert Package for promotion                                                                           
		DELETE PlayBook.PromotionPackage
		WHERE PromotionID = @PromotionID

		INSERT INTO @tblPackage (PackageId)
		SELECT *
		FROM CDE.udfSplit(@PromotionPackageID, ',')

		INSERT INTO PlayBook.PromotionPackage (
			PromotionID
			,PackageID
			)
		SELECT @PromotionID
			,CAST(PackageId AS INT)
		FROM @tblPackage

		SET @NewPromoId = 0;

		PRINT 'Pro=' + convert(VARCHAR, @PromotionID)

		--Update GEO Relevancy             
		--delete existing promotion with same id                                  
		EXEC Playbook.[PInsertUpdatePromotionGEORelevancy] @PromotionID
			,@GEOInfo
			,@SystemID

		--INSERT INTO PlayBook.PromotionGeoRelevancy (                              
		-- PromotionID                              
		-- ,BUID                              
		-- ,RegionId                              
		-- ,BranchId                              
		-- ,AreaId                              
		-- )                              
		--SELECT @PromotionID AS PromotionID                              
		-- ,item.value('BUID[1]', 'varchar(500)') AS BUID                              
		-- ,item.value('RegionId[1]', 'varchar(500)') AS RegionID                              
		-- ,item.value('BranchId[1]', 'varchar(500)') AS BranchId                              
		-- ,item.value('AreaId[1]', 'varchar(500)') AS AreaId                              
		--FROM @GEOInfo.nodes('GEO/Item') AS items(item)                              
		----Promotion Channel                                                     
		DELETE PlayBook.PromotionChannel
		WHERE PromotionId = @PromotionID

		INSERT INTO PlayBook.PromotionChannel
		SELECT (
				CASE 
					WHEN item.value('SuperChannelID[1]', 'varchar(100)') = ''
						THEN NULL
					ELSE CAST(item.value('SuperChannelID[1]', 'varchar(100)') AS INT)
					END
				) AS SuperChannelID
			,(
				CASE 
					WHEN item.value('ChannelID[1]', 'varchar(100)') = ''
						THEN NULL
					ELSE CAST(item.value('ChannelID[1]', 'varchar(100)') AS INT)
					END
				) AS ChannelID
			,@PromotionID AS PromotionID
		FROM @ChannelInfo.nodes('Channel/Item') AS items(item)

		SET @Status = 1
		SET @Message = 'Promotion has been updated successfully.'
	END

	IF @IsNationalPromotion = 1 --Approve                                                
	BEGIN
		--if @PromotionStatusId = 4                                                 
		-- --copying promotions                                                
		-- exec Playbook.pCreatePromotionCopies @PromotionID                   
		IF @PromotionStatusId = 3 --Cancelled                        
		BEGIN
			--Cancelling all promotions                                                
			UPDATE PlayBook.RetailPromotion
			SET PromotionStatusID = @PromotionStatusId
				,StatusModifiedDate = GETUTCDATE()
			WHERE EDGEItemID = @PromotionID
		END
	END

	IF (@IsNationalPromotion = 1)
	BEGIN
		UPDATE PlayBook.RetailPromotion
		SET PromotionName = @PromotionName
			,PromotionDescription = @PromotionDescription
			,PromotionStatusID = @PromotionStatusId
		WHERE ParentPromotionId = @PromotionID
	END

	--Updating Account Hier                
	EXEC Playbook.pInsertUpdatePromotionAccountHier @PromotionID

	DECLARE @NationalChainID INT

	SET @NationalChainID = 0
	SET @NationalChainID = (
			SELECT TOP 1 NationalChainID
			FROM playbook.PromotionAccount
			WHERE promotionid = @PromotionID
				AND isnull(NationalChainID, 0) <> 0
			)

	IF (isnull(@NationalChainID, 0) = 0)
		SET @NationalChainID = (
				SELECT TOP 1 b.NationalChainID
				FROM playbook.PromotionAccount a
				LEFT JOIN Sap.regionalchain b ON a.regionalchainid = b.regionalchainid
				WHERE a.promotionid = @PromotionID
					AND isnull(a.regionalchainid, 0) <> 0
				)

	IF (isnull(@NationalChainID, 0) = 0)
		SET @NationalChainID = (
				SELECT TOP 1 c.NationalChainID
				FROM playbook.PromotionAccount a
				LEFT JOIN Sap.localchain b ON a.localchainid = b.localchainid
				LEFT JOIN Sap.regionalchain c ON c.regionalchainid = b.regionalchainid
				WHERE a.promotionid = @PromotionID
					AND isnull(a.localchainid, 0) <> 0
				)

	-- Update Account Info, GEO and Brands                
	UPDATE PlayBook.RetailPromotion
	SET NationalChainID = @NationalChainID
		,PromotionBrands = STUFF((
				SELECT TradeMarkName
				FROM (
					SELECT DISTINCT ' | ' + trademark.TradeMarkName AS TradeMarkName
					FROM SAP.TradeMark AS trademark
					WHERE trademark.TradeMarkID IN (
							SELECT _brand.TrademarkID
							FROM PlayBook.PromotionBrand AS _brand
							WHERE _brand.PromotionID = @PromotionID
							)
					
					UNION
					
					SELECT DISTINCT ' | ' + brands.brandName AS TradeMarkName
					FROM SAP.Brand AS brands
					WHERE brands.BrandId IN (
							SELECT _brand.BrandID
							FROM PlayBook.PromotionBrand AS _brand
							WHERE _brand.PromotionID = @PromotionID
							)
					) AS table1
				FOR XML PATH('')
					,TYPE
				).value('.', 'NVARCHAR(MAX)'), 1, 2, '')
		,promotionPackages = STUFF((
				SELECT DISTINCT ' | ' + _package.PackageName
				FROM SAP.Package AS _package
				WHERE _package.PackageID IN (
						SELECT _pPackage.PackageID
						FROM PlayBook.PromotionPackage AS _pPackage
						WHERE _pPackage.PromotionID = @PromotionID
						)
				FOR XML PATH('')
					,TYPE
				).value('.', 'NVARCHAR(MAX)'), 1, 2, '')
		,AccountInfo = STUFF((
				SELECT DISTINCT ' | ' + CASE 
						WHEN _account.localchainID <> 0
							THEN (
									SELECT LocalChainName
									FROM SAP.LocalChain AS _sapLocal
									WHERE _account.LocalChainID = _sapLocal.LocalChainID
									)
						WHEN _account.RegionalchainID <> 0
							THEN (
									SELECT RegionalChainName
									FROM SAP.RegionalChain AS _sapRegional
									WHERE _account.RegionalChainID = _sapRegional.RegionalChainID
									)
						WHEN _account.NationalchainID <> 0
							THEN (
									SELECT NationalChainName
									FROM SAP.NationalChain AS _sapNational
									WHERE _account.NationalChainID = _sapNational.NationalChainID
									)
						END AS _account
				FROM PlayBook.PromotionAccount AS _account
				WHERE _account.PromotionID = @PromotionID
					--AND _account.IsRoot = 0                
					AND PromotionGroupID = 1
				FOR XML PATH('')
					,TYPE
				).value('.', 'NVARCHAR(MAX)'), 1, 2, '')
		,GEORelavency = STUFF((
				SELECT DISTINCT ' | ' + CASE 
						WHEN IsNull(_geoRel.BUID, 0) <> 0
							THEN (
									'BU - ' + (
										SELECT BUName
										FROM SAP.BusinessUnit _sapBU
										WHERE _geoRel.BUID = _sapBU.BUID
										)
									)
						WHEN IsNull(_geoRel.RegionID, 0) <> 0
							THEN (
									'Region - ' + (
										SELECT RegionName
										FROM SAP.Region _sapRegion
										WHERE _geoRel.RegionID = _sapRegion.RegionID
										)
									)
						WHEN IsNull(_geoRel.BranchId, 0) <> 0
							THEN (
									'Branch - ' + (
										SELECT BranchName
										FROM SAP.Branch _sapBranch
										WHERE _geoRel.BranchID = _sapBranch.BranchID
										)
									)
						WHEN IsNull(_geoRel.AreaId, 0) <> 0
							THEN (
									'Area - ' + (
										SELECT AreaName
										FROM SAP.Area _sapArea
										WHERE _geoRel.AreaID = _sapArea.AreaID
										)
									)
								-- -- FOR SYSTEM, ZONE, Division, BCRegionID,StateID                  
						WHEN IsNull(_geoRel.SystemID, 0) <> 0
							THEN (
									'System - ' + (
										SELECT SystemName
										FROM NationalAccount.System
										WHERE bcsystemID = _geoRel.SystemID
										)
									)
						WHEN isnull(_geoRel.ZoneID, 0) <> 0
							THEN (
									'Zone - ' + (
										SELECT zonename
										FROM bc.zone
										WHERE zoneid = _geoRel.ZoneID
										)
									)
						WHEN isnull(_geoRel.DivisionID, 0) <> 0
							THEN (
									'Division - ' + (
										SELECT divisionname
										FROM bc.division
										WHERE divisionid = _geoRel.DivisionID
										)
									)
						WHEN isnull(_geoRel.BCRegionID, 0) <> 0
							THEN (
									'BC Region - ' + (
										SELECT regionname
										FROM bc.region
										WHERE regionid = _geoRel.BCRegionID
										)
									)
						WHEN isnull(_geoRel.BottlerID, 0) <> 0
							THEN (
									'Bottler - ' + (
										SELECT bottlername
										FROM bc.bottler
										WHERE bottlerid = _geoRel.BottlerID
										)
									)
						WHEN isnull(_geoRel.StateID, 0) <> 0
							THEN (
									'State - ' + (
										SELECT RegionName
										FROM shared.stateregion
										WHERE StateRegionID = _geoRel.StateID
										)
									)
						END AS _geoRel
				FROM PlayBook.PromotionGeoRelevancy AS _geoRel
				WHERE _geoRel.PromotionID = @PromotionID
				FOR XML PATH('')
					,TYPE
				).value('.', 'NVARCHAR(MAX)'), 1, 2, '')
		,PromotionChannel = STUFF((
				SELECT DISTINCT ' | ' + CASE 
						WHEN _channel.SuperChannelID IS NOT NULL
							THEN (
									SELECT SuperChannelName
									FROM SAP.SuperChannel AS _sapSuperChannel
									WHERE _channel.SuperChannelID = _sapSuperChannel.SuperChannelID
									)
						WHEN _channel.ChannelID IS NOT NULL
							THEN (
									SELECT ChannelName
									FROM SAP.Channel AS _sapChannel
									WHERE _channel.ChannelID = _sapChannel.ChannelID
									)
						END AS _channel
				FROM PlayBook.PromotionChannel AS _channel
				WHERE _channel.PromotionID = @PromotionID
				FOR XML PATH('')
					,TYPE
				).value('.', 'NVARCHAR(MAX)'), 1, 2, '')
	WHERE PromotionId = @PromotionID

	--Update all System if all system are selected        
	DECLARE @sysCount INT = 0
		,@buCount INT = 0

	SELECT @sysCount = count(1)
	FROM playbook.PromotionGeoRelevancy
	WHERE PromotionID = @PromotionID
		AND SystemID IS NOT NULL

	SELECT @buCount = count(1)
	FROM playbook.PromotionGeoRelevancy
	WHERE PromotionID = @PromotionID
		AND BUID IS NOT NULL

	IF (
			@sysCount = 3
			AND @buCount = 3
			)
	BEGIN
		UPDATE playbook.RetailPromotion
		SET GEORelavency = 'All Systems'
		WHERE PromotionID = @PromotionID

		--As all systems and BU are selected, addin flag for WD as well      
		INSERT INTO playbook.promotionGeoRelevancy (
			PromotioniD
			,WD
			)
		VALUES (
			@PromotionID
			,1
			)
			--Update Systems    
	END
END

Go
Print 'Playbook.pInsertUpdatePromotion reverted back'
Go

Print '--- All SP dropped/reverted---'
Go

------------------------------------------------

--##############################################
------------------------------------------------
If Exists (
	Select *
	From Sys.Tables t Join sys.schemas s on t.schema_id = s.schema_id
	Where t.Name = 'PromotionBranch' and s.name = 'Playbook')
Begin
	Drop Table Playbook.PromotionBranch
End
Go

If Exists (
	Select *
	From Sys.Tables t Join sys.schemas s on t.schema_id = s.schema_id
	Where t.Name = 'PromotionBranch' and s.name = 'PreCal')
Begin
	Drop Table PreCal.PromotionBranch
	Print 'PreCal.PromotionBranch Dropped'
End
Go

--##############################################
------------------------------------------------
If Exists (
	Select *
	From Sys.Tables
	Where object_id = object_id('PreCal.PromotionBranchChainGroup'))
Begin
	Drop Table PreCal.PromotionBranchChainGroup
	Print 'PreCal.PromotionBranchChainGroup Dropped'
End
Go

--##############################################
------------------------------------------------
If Exists (
	Select *
	From Sys.Tables t Join sys.schemas s on t.schema_id = s.schema_id
	Where t.Name = 'BranchChannel' and s.name = 'PreCal')
Begin
	Drop Table PreCal.BranchChannel
	Print 'PreCal.BranchChannel Dropped'
End
Go

--##############################################
------------------------------------------------
If Exists (
	Select *
	From Sys.Tables t Join sys.schemas s on t.schema_id = s.schema_id
	Where t.Name = 'PromotionLocalChain' and s.name = 'PreCal')
Begin
	Drop Table PreCal.PromotionLocalChain
	Print 'PreCal.PromotionLocalChain Dropped'
End
Go

--##############################################
------------------------------------------------
If Exists (Select * From sys.tables Where Object_id = Object_ID('Processing.tBottlerForSeeking'))
Begin
	Drop Table Processing.tBottlerForSeeking
End
Go

If Exists (Select * From sys.tables Where Object_id = Object_ID('Precal.BottlerHier'))
Begin
	Drop Table Precal.BottlerHier
	Print 'PreCal.BottlerHier Dropped'
End
Go

--##############################################
------------------------------------------------
If Exists (Select * From sys.tables Where Object_id = Object_ID('Processing.tBottlerStateMapping'))
Begin
	Drop Table Processing.tBottlerStateMapping
End
Go

If Exists (Select * From sys.tables Where Object_id = Object_ID('PreCal.BottlerState'))
Begin
	Drop Table PreCal.BottlerState
	Print 'PreCal.BottlerState Dropped'
End
Go

--##############################################
------------------------------------------------
If Exists (Select * From sys.tables Where Object_id = Object_ID('Processing.tBranchStateMapping'))
Begin
	Drop Table Processing.tBranchStateMapping
End
Go

If Exists (Select * From sys.tables Where Object_id = Object_ID('PreCal.BranchState'))
Begin
	Drop Table PreCal.BranchState
	Print 'PreCal.BranchState Dropped'
End
Go

--##############################################
------------------------------------------------
If Exists (Select * From sys.tables Where Object_id = Object_ID('Processing.tBranchForSeeking'))
Begin
	Drop Table Processing.tBranchForSeeking
End
Go

If Exists (Select * From sys.tables Where Object_id = Object_ID('PreCal.DSDBranch'))
Begin
	Drop Table PreCal.DSDBranch
	Print 'PreCal.DSDBranch Dropped'
End
Go

--##############################################
------------------------------------------------
If Exists (Select * From sys.tables Where Object_id = Object_ID('Processing.tBranchBrand'))
Begin
	Drop Table Processing.tBranchBrand
End
Go

If Exists (Select * From sys.tables Where Object_id = Object_ID('PreCal.BranchBrand'))
Begin
	Drop Table PreCal.BranchBrand
	Print 'PreCal.BranchBrand Dropped'
End
Go

--##############################################
------------------------------------------------
If Exists (Select * From sys.tables Where Object_id = Object_ID('Processing.tChainSeeking'))
Begin
	Drop Table Processing.tChainSeeking
End
Go

If Exists (Select * From sys.tables Where Object_id = Object_ID('PreCal.ChainHier'))
Begin
	Drop Table PreCal.ChainHier
	Print 'PreCal.ChainHier Dropped'
End
Go

--##############################################
------------------------------------------------
If Exists (
	Select *
	From Sys.Tables
	Where Object_ID = object_id('PlayBook.ChainGroupLocalChain'))
Begin
	Drop Table PlayBook.ChainGroupLocalChain
End
Go

If Exists (
	Select *
	From Sys.Tables
	Where Object_ID = object_id('PlayBook.ChainGroupRegionalChain'))
Begin
	Drop Table PlayBook.ChainGroupRegionalChain
End
Go

If Exists (
	Select *
	From Sys.Tables
	Where Object_ID = object_id('PlayBook.ChainGroupNationalChain'))
Begin
	Drop Table PlayBook.ChainGroupNationalChain
End
Go


If Exists (
	Select *
	From Sys.Tables t 
	Join Sys.schemas s on t.schema_id = s.schema_id
	Where t.Name = 'ChainGroup' and s.name = 'Playbook')
Begin
	Drop Table Playbook.ChainGroup
	Print 'Playbook.ChainGroup Dropped'
End
Go

--##############################################
------------------------------------------------
If Exists (Select * From sys.tables Where Object_id = Object_ID('Processing.tBranchChainGroup'))
Begin
	Drop Table Processing.tBranchChainGroup
End
Go

If Exists (Select * From sys.tables Where Object_id = Object_ID('PreCal.BranchChainGroup'))
Begin
	Drop Table PreCal.BranchChainGroup
	Print 'PreCal.BranchChainGroup Dropped'
End
Go

--##############################################
------------------------------------------------
If Exists (Select * From sys.tables Where Object_id = Object_ID('PreCal.PromotionChainGroup'))
Begin
	Drop Table PreCal.PromotionChainGroup
	Print 'PreCal.PromotionChainGroup Dropped'
End
Go


--##############################################
------------------------------------------------
If Exists (
	Select *
	From Sys.Objects
	Where Object_id = Object_id('Playbook.PromotionRegion'))
Begin
	Drop Table Playbook.PromotionRegion
	Print 'Playbook.PromotionRegion Dropped'
End
Go

If Exists (
	Select *
	From Sys.Objects
	Where Object_id = Object_id('PreCal.PromotionRegion'))
Begin
	Drop Table PreCal.PromotionRegion
	Print 'PreCal.PromotionRegion Dropped'
End
Go

If Exists (
	Select *
	From Sys.Objects
	Where Object_id = Object_id('PreCal.PromotionRegionChainGroup'))
Begin
	Drop Table PreCal.PromotionRegionChainGroup
	Print 'PreCal.PromotionRegionChainGroup Dropped'
End
Go

--##############################################
------------------------------------------------
If Exists (
	Select *
	From Sys.Tables
	Where Object_ID = object_id('Playbook.PromotionBottler'))
Begin
	Drop Table Playbook.PromotionBottler
	Print 'Playbook.PromotionBottler Dropped'
End
Go

If Exists (
	Select *
	From Sys.Tables
	Where Object_ID = object_id('PreCal.PromotionBottler'))
Begin
	Drop Table PreCal.PromotionBottler
	Print 'PreCal.PromotionBottler Dropped'
End
Go


If Exists (
	Select *
	From Sys.Tables
	Where Object_ID = object_id('PreCal.PromotionBottlerChainGroup'))
Begin
	Drop Table PreCal.PromotionBottlerChainGroup
	Print 'PreCal.PromotionBottlerChainGroup Dropped'
End
Go

--##############################################
------------------------------------------------
If Exists (
	Select *
	From Sys.Tables
	Where Object_ID = object_id('BC.tRegionTradeMarkLocalChainForSeeking'))
Begin
	Drop Table BC.tRegionTradeMarkLocalChainForSeeking
	Print 'BC.tRegionTradeMarkLocalChainForSeeking Dropped'
End
Go

If Exists (
	Select *
	From Sys.Tables
	Where Object_ID = object_id('PreCal.RegionTMLocalChain'))
Begin
	Drop Table PreCal.RegionTMLocalChain
	Print 'PreCal.RegionTMLocalChain Dropped'
End
Go

--##############################################
------------------------------------------------
If Exists (
	Select *
	From Sys.Tables
	Where Object_ID = object_id('PreCal.ChainGroupTree'))
Begin
	Drop Table PreCal.ChainGroupTree
	Print 'PreCal.ChainGroupTree Dropped'
End
Go

--##############################################
------------------------------------------------

Print '--- All New Tables In PreCal Dropped ---'
Go

If Exists (Select * From sys.objects Where object_ID = OBJECT_ID('PreCal.vSchemaDocument'))
Begin
	Drop View [PreCal].[vSchemaDocument]
	Print 'View PreCal.vSchemaDocument Dropped'
End
Go

If Exists (Select *
	From sys.schemas
	Where name = 'PreCal')
Begin
	Execute('Drop Schema PreCal')
	Print 'Schema PreCal Dropped'
End
Go

------------------------------------------------
------------------------------------------------
If Exists (
	Select *
	From Sys.Tables
	Where Object_ID = object_id('PlayBook.PromotionRankBackup'))
Begin
	Begin Transaction
		Drop Table PlayBook.PromotionRank;

		CREATE TABLE [Playbook].[PromotionRank](
			[PromotionRankID] [int] IDENTITY(1,1) NOT NULL,
			[PromotionID] [int] NULL,
			[PromotionWeekStart] [date] NULL,
			[PromotionWeekEnd] [date] NULL,
			[Rank] [int] NULL,
		CONSTRAINT [PK_PromotionRank] PRIMARY KEY CLUSTERED 
		(
			[PromotionRankID] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 20) ON [PRIMARY]
		) ON [PRIMARY];


		ALTER TABLE [Playbook].[PromotionRank]  WITH CHECK ADD  CONSTRAINT [FK_PromoRank_PromotionId] FOREIGN KEY([PromotionID])
		REFERENCES [Playbook].[RetailPromotion] ([PromotionID]);

		ALTER TABLE [Playbook].[PromotionRank] CHECK CONSTRAINT [FK_PromoRank_PromotionId];

		Insert Into PlayBook.PromotionRank([PromotionID], [PromotionWeekStart], [PromotionWeekEnd], [Rank])
		Select [PromotionID], [PromotionWeekStart], [PromotionWeekEnd], [Rank] From PlayBook.PromotionRankBackup;

		Drop Table PlayBook.PromotionRankBackup;
		Print '--- PlayBook.PromotionRank revert back ---'
	Commit Transaction
End
Go

--##############################################
------------------------------------------------
If Exists (Select * From sys.procedures Where object_id = object_id('Playbook.pGetLocationTree'))
	Drop Proc Playbook.pGetLocationTree
Go

--##############################################
------------------------------------------------
If Exists (Select * From sys.procedures Where object_id = object_id('Playbook.pGetPromotionsForLocCgStartDate'))
	Drop Proc Playbook.pGetPromotionsForLocCgStartDate
Go

--##############################################
------------------------------------------------
If Exists (Select * From sys.procedures Where object_id = object_id('Playbook.pGetChainGroupsBranches'))
	Drop Proc Playbook.pGetChainGroupsBranches
Go

--##############################################
------------------------------------------------
If Exists (Select * From sys.procedures Where object_id = object_id('Playbook.pGetBCLocationTree'))
	Drop Proc Playbook.pGetBCLocationTree
Go

--##############################################
------------------------------------------------
If Exists (Select * From sys.procedures Where object_id = object_id('Playbook.pGetChainGroupsFromBCPromos'))
	Drop Proc Playbook.pGetChainGroupsFromBCPromos
Go

--##############################################
------------------------------------------------
If Exists (Select * From sys.procedures Where object_id = object_id('Playbook.pGetBCPromotionsForLocCgStartDate'))
	Drop Proc Playbook.pGetBCPromotionsForLocCgStartDate
Go

Print ''
Print 'Server Name:' + @@ServerName
Print 'Database Name:' + DB_Name()
Print '*** All Global Context related changes rolled back ***'
Go
--- Drop the Job ---
--- Drop the Job ---
--- Drop the Job ---
--- Drop the Job ---
USE [msdb]
GO

/****** Object:  Job [DPSG.SDM.JobRemapPromotions]    Script Date: 12/2/2015 10:02:47 AM ******/
IF  EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = N'DPSG.SDM.JobRemapPromotions')
Begin
	EXEC msdb.dbo.sp_delete_job @job_name=N'DPSG.SDM.JobRemapPromotions', @delete_unused_schedule=1
	Print ''
	Print 'Server Name:' + @@ServerName
	Print 'Database Name:' + DB_Name()
	Print '--- SQL AgentJob DPSG.SDM.JobRemapPromotions dropped ---'

End
GO


