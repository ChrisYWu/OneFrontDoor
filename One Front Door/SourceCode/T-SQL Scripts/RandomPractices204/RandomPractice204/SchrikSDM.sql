USE [Portal_Data805]
GO
ALTER TABLE [SupplyChain].[tSafetyRecordable] DROP CONSTRAINT [FK_tSafetyRecordable_TimeAggregation]
GO
ALTER TABLE [SupplyChain].[tSafetyRecordable] DROP CONSTRAINT [FK_tSafetyRecordable_Plant]
GO
ALTER TABLE [SupplyChain].[tSafetyRecordable] DROP CONSTRAINT [FK_tSafetyRecordable_DimDate1]
GO
ALTER TABLE [SupplyChain].[tPlantKPI] DROP CONSTRAINT [FK_tPlantKPIDetail_Plant]
GO
ALTER TABLE [SupplyChain].[tPlantKPI] DROP CONSTRAINT [FK_tPlantKPI_TimeAggregation]
GO
ALTER TABLE [SupplyChain].[tPlantInventory] DROP CONSTRAINT [FK_tPlantInventory_Plant]
GO
ALTER TABLE [SupplyChain].[tPlantInventory] DROP CONSTRAINT [FK_tPlantInventory_Material]
GO
ALTER TABLE [SupplyChain].[tPlantInventory] DROP CONSTRAINT [FK_tPlantInventory_DimDate]
GO
ALTER TABLE [SupplyChain].[tPlantDailyKPI] DROP CONSTRAINT [FK_tPlantDailyReport_Plant]
GO
ALTER TABLE [SupplyChain].[tPlantDailyKPI] DROP CONSTRAINT [FK_tPlantDailyReport_DimDate]
GO
ALTER TABLE [SupplyChain].[tLineKPI] DROP CONSTRAINT [FK_tLineKPIDetail_Line]
GO
ALTER TABLE [SupplyChain].[tLineKPI] DROP CONSTRAINT [FK_tLineKPI_TimeAggregation]
GO
ALTER TABLE [SupplyChain].[tLineDailyKPI] DROP CONSTRAINT [FK_tLineDailyReport_Line]
GO
ALTER TABLE [SupplyChain].[tLineDailyKPI] DROP CONSTRAINT [FK_tLineDailyReport_DimDate]
GO
ALTER TABLE [SupplyChain].[tDsdDailyMinMax] DROP CONSTRAINT [FK_DsdDailyMinMax_Material]
GO
ALTER TABLE [SupplyChain].[tDsdDailyMinMax] DROP CONSTRAINT [FK_DsdDailyMinMax_DimDate]
GO
ALTER TABLE [SupplyChain].[tDsdDailyMinMax] DROP CONSTRAINT [FK_DsdDailyMinMax_Branch]
GO
ALTER TABLE [SupplyChain].[tDsdDailyCaseCut] DROP CONSTRAINT [FK_DsdDailyCaseCut_Material]
GO
ALTER TABLE [SupplyChain].[tDsdDailyCaseCut] DROP CONSTRAINT [FK_DsdDailyCaseCut_DimDate]
GO
ALTER TABLE [SupplyChain].[tDsdDailyCaseCut] DROP CONSTRAINT [FK_DsdDailyCaseCut_Branch]
GO
ALTER TABLE [SupplyChain].[tDsdDailyBranchInventory] DROP CONSTRAINT [FK_DsdDailyBranchInventory_Material]
GO
ALTER TABLE [SupplyChain].[tDsdDailyBranchInventory] DROP CONSTRAINT [FK_DsdDailyBranchInventory_DimDate]
GO
ALTER TABLE [SupplyChain].[tDsdDailyBranchInventory] DROP CONSTRAINT [FK_DsdDailyBranchInventory_Branch]
GO
ALTER TABLE [SupplyChain].[tDsdCaseCut] DROP CONSTRAINT [FK_tDsdCaseCut_Material]
GO
ALTER TABLE [SupplyChain].[tDsdCaseCut] DROP CONSTRAINT [FK_tDsdCaseCut_DimDate]
GO
ALTER TABLE [SupplyChain].[tDsdCaseCut] DROP CONSTRAINT [FK_tDsdCaseCut_Branch]
GO
ALTER TABLE [SupplyChain].[tDsdCaseCut] DROP CONSTRAINT [FK_tDsdCaseCut_AggregationID]
GO
ALTER TABLE [SupplyChain].[tDailySafetyRecordable] DROP CONSTRAINT [FK_tDailySafetyRecordable_Plant]
GO
ALTER TABLE [SupplyChain].[tDailySafetyRecordable] DROP CONSTRAINT [FK_tDailySafetyRecordable_DimDate]
GO
ALTER TABLE [MSTR].[RelMyDaySalesOfficePlanVersion] DROP CONSTRAINT [FK_RelMyDaySalesOfficePlanVersion_DimMydaySalesPlanVersions]
GO
ALTER TABLE [MSTR].[RelMyDaySalesOfficePlanVersion] DROP CONSTRAINT [FK_RelMyDaySalesOfficePlanVersion_Branch]
GO
ALTER TABLE [MSTR].[FactWDAmplifyOandFOrder] DROP CONSTRAINT [FK_FactWDAmplifyOandFOrder_Material]
GO
ALTER TABLE [MSTR].[FactWDAmplifyOandFOrder] DROP CONSTRAINT [FK_FactWDAmplifyOandFOrder_Account_SoldToID]
GO
ALTER TABLE [MSTR].[FactWDAmplifyOandFOrder] DROP CONSTRAINT [FK_FactWDAmplifyOandFOrder_Account_ShipToID]
GO
ALTER TABLE [MSTR].[FactWDAmplifyInvoiceData] DROP CONSTRAINT [FK_FactWDAmplifyInvoiceData_Material]
GO
ALTER TABLE [MSTR].[FactWDAmplifyInvoiceData] DROP CONSTRAINT [FK_FactWDAmplifyInvoiceData_Account_SoldToID]
GO
ALTER TABLE [MSTR].[FactWDAmplifyInvoiceData] DROP CONSTRAINT [FK_FactWDAmplifyInvoiceData_Account_ShipToID]
GO
ALTER TABLE [MSTR].[FactWDAmplifyAOPandForeCast] DROP CONSTRAINT [FK_FactWDAmplifyAOPandForeCast_Material]
GO
ALTER TABLE [MSTR].[FactWDAmplifyAOPandForeCast] DROP CONSTRAINT [FK_FactWDAmplifyAOPandForeCast_Account_SoldToID]
GO
ALTER TABLE [MSTR].[FactWDAmplifyAOPandForeCast] DROP CONSTRAINT [FK_FactWDAmplifyAOPandForeCast_Account_ShipToID]
GO
ALTER TABLE [MSTR].[FactNielsenPerformanceTracker] DROP CONSTRAINT [FK_FactNielsonPerformanceTracker_DimNielsonMarket]
GO
ALTER TABLE [MSTR].[FactNielsenPerformanceTracker] DROP CONSTRAINT [FK_FactNielsenPerformanceTracker_DimNielsenWeek]
GO
ALTER TABLE [MSTR].[FactNielsenPerformanceTracker] DROP CONSTRAINT [FK_FactNielsenPerformanceTracker_DimNielsenType]
GO
ALTER TABLE [MSTR].[FactNielsenPerformanceTracker] DROP CONSTRAINT [FK_FactNielsenPerformanceTracker_DimNielsenProduct]
GO
ALTER TABLE [MSTR].[FactMyScoresPlanRanking] DROP CONSTRAINT [FK_FactMyScoresPlanRanking_DimMydaySalesPlanVersions]
GO
ALTER TABLE [MSTR].[FactMyScoresPlanRanking] DROP CONSTRAINT [FK_FactMyScoresPlanRanking_DimMonth]
GO
ALTER TABLE [MSTR].[FactMyDayRoutePlan] DROP CONSTRAINT [FK_FactMyDaySalesOfficePlan_SalesRoute]
GO
ALTER TABLE [MSTR].[FactMyDayRoutePlan] DROP CONSTRAINT [FK_FactMyDaySalesOfficePlan_DimMydaySalesPlanVersions]
GO
ALTER TABLE [MSTR].[FactMyDayRoutePlan] DROP CONSTRAINT [FK_FactMyDaySalesOfficePlan_DimMonth]
GO
ALTER TABLE [MSTR].[FactMyDayBranchPlanRanking] DROP CONSTRAINT [FK_FactMyDayBranchPlanRanking_SalesRoute]
GO
ALTER TABLE [MSTR].[FactMyDayBranchPlanRanking] DROP CONSTRAINT [FK_FactMyDayBranchPlanRanking_DimMydaySalesPlanVersions]
GO
ALTER TABLE [MSTR].[FactMyDayBranchPlanRanking] DROP CONSTRAINT [FK_FactMyDayBranchPlanRanking_DimMonth]
GO
ALTER TABLE [MSTR].[DimTENBrands] DROP CONSTRAINT [FK_DimTENBrands_Brand]
GO
ALTER TABLE [MSTR].[DimNielsenProduct] DROP CONSTRAINT [FK_DimNielsenProduct_DimNielsenProductOwner]
GO
ALTER TABLE [MSTR].[DimNielsenProduct] DROP CONSTRAINT [FK_DimNielsenProduct_DimNielsenProductCategory]
GO
ALTER TABLE [MSTR].[DimNielsenMarketOwners] DROP CONSTRAINT [FK_DimNielsenMarketOwners_UserProfile]
GO
ALTER TABLE [MSTR].[DimNielsenMarketOwners] DROP CONSTRAINT [FK_DimNielsenMarketOwners_DimNielsenMarket]
GO
ALTER TABLE [MSTR].[DimBrandPackageMarginTiers] DROP CONSTRAINT [FK_DimBrandPackageMarginTiers_Package]
GO
ALTER TABLE [MSTR].[DimBrandPackageMarginTiers] DROP CONSTRAINT [FK_DimBrandPackageMarginTiers_Brand]
GO
ALTER TABLE [MSTR].[DimBranchPlan] DROP CONSTRAINT [FK_FactAnnualPlan_DimMonth]
GO
ALTER TABLE [MSTR].[DimBranchPlan] DROP CONSTRAINT [FK_FactAnnualPlan_Branch]
GO
ALTER TABLE [EDGE].[RPLItemPackage] DROP CONSTRAINT [FK_RPLItemPackage_RPLItem]
GO
ALTER TABLE [EDGE].[RPLItemNAE] DROP CONSTRAINT [FK_RPLItemNAE_RPLItem]
GO
ALTER TABLE [EDGE].[RPLItemChannel] DROP CONSTRAINT [FK_RPLItemChannel_RPLItem]
GO
ALTER TABLE [EDGE].[RPLItemBrand] DROP CONSTRAINT [FK_RPLItemBrand_RPLItem]
GO
ALTER TABLE [EDGE].[RPLItemAccount] DROP CONSTRAINT [FK_RPLItemAccount_RPLItem]
GO
ALTER TABLE [EDGE].[RPLAttachment] DROP CONSTRAINT [FK_RPLAttachment_RPLItem]
GO
ALTER TABLE [CDE].[ROICommissionsImport] DROP CONSTRAINT [FK_SAPAccount_ROICommissionsImport]
GO
ALTER TABLE [CDE].[ObjectType] DROP CONSTRAINT [FK_ObjectType_Reference]
GO
ALTER TABLE [CDE].[Notification] DROP CONSTRAINT [FK_Notification_Reference]
GO
ALTER TABLE [CDE].[ExtractZeso] DROP CONSTRAINT [FK_ExtractZeso_Reference]
GO
ALTER TABLE [CDE].[ExtractZemoPickup] DROP CONSTRAINT [FK_ExtractZemoPickup_Reference]
GO
ALTER TABLE [CDE].[ExtractZemoDelivery] DROP CONSTRAINT [FK_ExtractZemoDelivery_Reference]
GO
ALTER TABLE [CDE].[ExtractChangeEquipment] DROP CONSTRAINT [FK_ExtractChangeEquipment_Reference]
GO
ALTER TABLE [CDE].[EquipmentSnapshot] DROP CONSTRAINT [FK_EquipmentSnapshot_Equipment]
GO
ALTER TABLE [CDE].[EquipmentAgeCategory] DROP CONSTRAINT [FK_EquipmentAgeCategory_Equipment]
GO
ALTER TABLE [CDE].[AssetValidation] DROP CONSTRAINT [FK_AssetValidation_Reference_ValidationStatus]
GO
ALTER TABLE [CDE].[AssetValidation] DROP CONSTRAINT [FK_AssetValidation_Reference_ServiceOrderType]
GO
ALTER TABLE [CDE].[AssetValidation] DROP CONSTRAINT [FK_AssetValidation_Reference_SerialNumberMissingReason]
GO
ALTER TABLE [CDE].[AssetValidation] DROP CONSTRAINT [FK_AssetValidation_Reference_SerialNumberEntryReason]
GO
ALTER TABLE [CDE].[AssetValidation] DROP CONSTRAINT [FK_AssetValidation_Reference_ModelNumberMissingReason]
GO
ALTER TABLE [CDE].[AssetValidation] DROP CONSTRAINT [FK_AssetValidation_Reference_ModelNumberEntryReason]
GO
ALTER TABLE [CDE].[AssetValidation] DROP CONSTRAINT [FK_AssetValidation_Reference_MaterialType]
GO
ALTER TABLE [CDE].[AssetValidation] DROP CONSTRAINT [FK_AssetValidation_Reference_EquipmentType]
GO
ALTER TABLE [CDE].[AssetValidation] DROP CONSTRAINT [FK_AssetValidation_Reference_EquipmentGraphics]
GO
ALTER TABLE [CDE].[AssetValidation] DROP CONSTRAINT [FK_AssetValidation_Reference_EquipmentCondition]
GO
ALTER TABLE [CDE].[AssetValidation] DROP CONSTRAINT [FK_AssetValidation_Reference_AssetNumberMissingReason]
GO
ALTER TABLE [CDE].[AssetValidation] DROP CONSTRAINT [FK_AssetValidation_Reference_AssetNumberEnttryReason]
GO
ALTER TABLE [CDE].[AssetValidation] DROP CONSTRAINT [FK_AssetValidation_Equipment]
GO
ALTER TABLE [CDE].[AssetActionStatus] DROP CONSTRAINT [FK_AssetActionStatus_Reference_ActionTypeStatus]
GO
ALTER TABLE [CDE].[AssetActionStatus] DROP CONSTRAINT [FK_AssetActionStatus_Reference_ActionType]
GO
ALTER TABLE [CDE].[AssetActionStatus] DROP CONSTRAINT [FK_AssetActionStatus_AssetValidation]
GO
ALTER TABLE [CDE].[Account] DROP CONSTRAINT [FK_SAPAccount_CDEAccount]
GO
/****** Object:  Table [SupplyChain].[tSafetyRecordable]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [SupplyChain].[tSafetyRecordable]
GO
/****** Object:  Table [SupplyChain].[tRegionBranchTradeMark]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [SupplyChain].[tRegionBranchTradeMark]
GO
/****** Object:  Table [SupplyChain].[tPlantKPI]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [SupplyChain].[tPlantKPI]
GO
/****** Object:  Table [SupplyChain].[tPlantInventory]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [SupplyChain].[tPlantInventory]
GO
/****** Object:  Table [SupplyChain].[tPlantDailyKPI]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [SupplyChain].[tPlantDailyKPI]
GO
/****** Object:  Table [SupplyChain].[tManufacturingMeasures_ToBeDeleted]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [SupplyChain].[tManufacturingMeasures_ToBeDeleted]
GO
/****** Object:  Table [SupplyChain].[tLineKPI]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [SupplyChain].[tLineKPI]
GO
/****** Object:  Table [SupplyChain].[tLineDailyKPI]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [SupplyChain].[tLineDailyKPI]
GO
/****** Object:  Table [SupplyChain].[tDsdPotentialCaseCut]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [SupplyChain].[tDsdPotentialCaseCut]
GO
/****** Object:  Table [SupplyChain].[tDsdOpenOrder]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [SupplyChain].[tDsdOpenOrder]
GO
/****** Object:  Table [SupplyChain].[tDsdDailyMinMax]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [SupplyChain].[tDsdDailyMinMax]
GO
/****** Object:  Table [SupplyChain].[tDsdDailyCaseCut]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [SupplyChain].[tDsdDailyCaseCut]
GO
/****** Object:  Table [SupplyChain].[tDsdDailyBranchInventory]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [SupplyChain].[tDsdDailyBranchInventory]
GO
/****** Object:  Table [SupplyChain].[tDsdCaseCut]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [SupplyChain].[tDsdCaseCut]
GO
/****** Object:  Table [SupplyChain].[tDailySafetyRecordable]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [SupplyChain].[tDailySafetyRecordable]
GO
/****** Object:  Table [SAP].[BP7SalesOfficeMinMax]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [SAP].[BP7SalesOfficeMinMax]
GO
/****** Object:  Table [SAP].[BP7SalesOfficeInventory]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [SAP].[BP7SalesOfficeInventory]
GO
/****** Object:  Table [SAP].[BP7PlantInventory]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [SAP].[BP7PlantInventory]
GO
/****** Object:  Table [MSTR].[WDSurveyPhotos]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[WDSurveyPhotos]
GO
/****** Object:  Table [MSTR].[WDDetailSurveyResults_new]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[WDDetailSurveyResults_new]
GO
/****** Object:  Table [MSTR].[WDDetailSurveyResults]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[WDDetailSurveyResults]
GO
/****** Object:  Table [MSTR].[WD_User_Role]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[WD_User_Role]
GO
/****** Object:  Table [MSTR].[TransYTDMonthID]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[TransYTDMonthID]
GO
/****** Object:  Table [MSTR].[TransYTDDay]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[TransYTDDay]
GO
/****** Object:  Table [MSTR].[TransWTDDay]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[TransWTDDay]
GO
/****** Object:  Table [MSTR].[TransQTDDay]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[TransQTDDay]
GO
/****** Object:  Table [MSTR].[TransMTDDay]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[TransMTDDay]
GO
/****** Object:  Table [MSTR].[SurveyPhotos_new]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[SurveyPhotos_new]
GO
/****** Object:  Table [MSTR].[SurveyCustomers_Staging]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[SurveyCustomers_Staging]
GO
/****** Object:  Table [MSTR].[SurveyCustomers]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[SurveyCustomers]
GO
/****** Object:  Table [MSTR].[STG_Hispanic]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[STG_Hispanic]
GO
/****** Object:  Table [MSTR].[RevChainImages]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[RevChainImages]
GO
/****** Object:  Table [MSTR].[RetailExecutionTransactionLog]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[RetailExecutionTransactionLog]
GO
/****** Object:  Table [MSTR].[RetailExecution]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[RetailExecution]
GO
/****** Object:  Table [MSTR].[RelMyDaySalesOfficePlanVersion]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[RelMyDaySalesOfficePlanVersion]
GO
/****** Object:  Table [MSTR].[ProcedureExecutionLog]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[ProcedureExecutionLog]
GO
/****** Object:  Table [MSTR].[Months_Temp]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[Months_Temp]
GO
/****** Object:  Table [MSTR].[LogMyDayCustSumBWDailyValidation]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[LogMyDayCustSumBWDailyValidation]
GO
/****** Object:  Table [MSTR].[LogFactMyDayCustomer]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[LogFactMyDayCustomer]
GO
/****** Object:  Table [MSTR].[GetRouteDetail]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[GetRouteDetail]
GO
/****** Object:  Table [MSTR].[FactWDSurveyResults]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[FactWDSurveyResults]
GO
/****** Object:  Table [MSTR].[FactWDAmplifyOandFOrder]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[FactWDAmplifyOandFOrder]
GO
/****** Object:  Table [MSTR].[FactWDAmplifyInvoiceData]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[FactWDAmplifyInvoiceData]
GO
/****** Object:  Table [MSTR].[FactWDAmplifyAOPandForeCast]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[FactWDAmplifyAOPandForeCast]
GO
/****** Object:  Table [MSTR].[FactPromoAccountChannel]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[FactPromoAccountChannel]
GO
/****** Object:  Table [MSTR].[FactPromoAccountChain]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[FactPromoAccountChain]
GO
/****** Object:  Table [MSTR].[FactPromoAccount]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[FactPromoAccount]
GO
/****** Object:  Table [MSTR].[FactOFDDailyMetricsBak]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[FactOFDDailyMetricsBak]
GO
/****** Object:  Table [MSTR].[FactOFDDailyMetrics]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[FactOFDDailyMetrics]
GO
/****** Object:  Table [MSTR].[FactOFDCasesCuts]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[FactOFDCasesCuts]
GO
/****** Object:  Table [MSTR].[FactNielsenPerformanceTracker]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[FactNielsenPerformanceTracker]
GO
/****** Object:  Table [MSTR].[FactMyScoresPlanRanking]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[FactMyScoresPlanRanking]
GO
/****** Object:  Table [MSTR].[FactMyDayRoutePlan]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[FactMyDayRoutePlan]
GO
/****** Object:  Table [MSTR].[FactMyDayCustomerSummary_Old]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[FactMyDayCustomerSummary_Old]
GO
/****** Object:  Table [MSTR].[FactMyDayCustomerSummary]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[FactMyDayCustomerSummary]
GO
/****** Object:  Table [MSTR].[FactMyDayCustomer]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[FactMyDayCustomer]
GO
/****** Object:  Table [MSTR].[FactMyDayBranchPlanRanking]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[FactMyDayBranchPlanRanking]
GO
/****** Object:  Table [MSTR].[FactEMUsage]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[FactEMUsage]
GO
/****** Object:  Table [MSTR].[FactDSDRouteAccount]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[FactDSDRouteAccount]
GO
/****** Object:  Table [MSTR].[FactDSDRoute]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[FactDSDRoute]
GO
/****** Object:  Table [MSTR].[FactDSDInventory]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[FactDSDInventory]
GO
/****** Object:  Table [MSTR].[FactBCSurveySalesHier]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[FactBCSurveySalesHier]
GO
/****** Object:  Table [MSTR].[FactBCSurveyResults]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[FactBCSurveyResults]
GO
/****** Object:  Table [MSTR].[FactBCSurveyPromoExecution]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[FactBCSurveyPromoExecution]
GO
/****** Object:  Table [MSTR].[FactBCSurveyMgmtQuestion]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[FactBCSurveyMgmtQuestion]
GO
/****** Object:  Table [MSTR].[DimYear]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[DimYear]
GO
/****** Object:  Table [MSTR].[DimWeek]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[DimWeek]
GO
/****** Object:  Table [MSTR].[DimWDSurveyUnlisted]    Script Date: 7/22/2015 11:31:49 AM ******/
DROP TABLE [MSTR].[DimWDSurveyUnlisted]
GO
/****** Object:  Table [MSTR].[DimWDSurveyStoreInfo]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimWDSurveyStoreInfo]
GO
/****** Object:  Table [MSTR].[DimWDSurveyCustomers]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimWDSurveyCustomers]
GO
/****** Object:  Table [MSTR].[DimWDSurveyBrand]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimWDSurveyBrand]
GO
/****** Object:  Table [MSTR].[DimWDActionItems]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimWDActionItems]
GO
/****** Object:  Table [MSTR].[DimUserProfile]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimUserProfile]
GO
/****** Object:  Table [MSTR].[DimUserInBranchHier]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimUserInBranchHier]
GO
/****** Object:  Table [MSTR].[DimTENBrands]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimTENBrands]
GO
/****** Object:  Table [MSTR].[DimSuperChannelForComparison]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimSuperChannelForComparison]
GO
/****** Object:  Table [MSTR].[DimSalesRoute]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimSalesRoute]
GO
/****** Object:  Table [MSTR].[DimRoute]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimRoute]
GO
/****** Object:  Table [MSTR].[DimQuarter]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimQuarter]
GO
/****** Object:  Table [MSTR].[DimNielsenWeek]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimNielsenWeek]
GO
/****** Object:  Table [MSTR].[DimNielsenType]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimNielsenType]
GO
/****** Object:  Table [MSTR].[DimNielsenProductOwner]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimNielsenProductOwner]
GO
/****** Object:  Table [MSTR].[DimNielsenProductCategory]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimNielsenProductCategory]
GO
/****** Object:  Table [MSTR].[DimNielsenProduct]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimNielsenProduct]
GO
/****** Object:  Table [MSTR].[DimNielsenMarketOwners]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimNielsenMarketOwners]
GO
/****** Object:  Table [MSTR].[DimNielsenMarket]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimNielsenMarket]
GO
/****** Object:  Table [MSTR].[DimMydaySalesPlanVersions]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimMydaySalesPlanVersions]
GO
/****** Object:  Table [MSTR].[DimMonth]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimMonth]
GO
/****** Object:  Table [MSTR].[DimMetricName]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimMetricName]
GO
/****** Object:  Table [MSTR].[DimGOALMetric]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimGOALMetric]
GO
/****** Object:  Table [MSTR].[DimEMUsage]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimEMUsage]
GO
/****** Object:  Table [MSTR].[DimEMJobCodeProductGroup]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimEMJobCodeProductGroup]
GO
/****** Object:  Table [MSTR].[DimDPSHoliday]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimDPSHoliday]
GO
/****** Object:  Table [MSTR].[DimDay]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimDay]
GO
/****** Object:  Table [MSTR].[DimChainHier]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimChainHier]
GO
/****** Object:  Table [MSTR].[DimBrandPackageMarginTiers]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimBrandPackageMarginTiers]
GO
/****** Object:  Table [MSTR].[DimBranchPlan]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimBranchPlan]
GO
/****** Object:  Table [MSTR].[DimBCSurveyImage]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimBCSurveyImage]
GO
/****** Object:  Table [MSTR].[DimBCSurveyDisplayLocationType]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimBCSurveyDisplayLocationType]
GO
/****** Object:  Table [MSTR].[DimBCSurveyBrand]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimBCSurveyBrand]
GO
/****** Object:  Table [MSTR].[DimBCMydayPackage]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimBCMydayPackage]
GO
/****** Object:  Table [MSTR].[DimBCMydayDisplayType]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimBCMydayDisplayType]
GO
/****** Object:  Table [MSTR].[DimBCMydayDisplayLocation]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimBCMydayDisplayLocation]
GO
/****** Object:  Table [MSTR].[DimBCBottlerSalesHier]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimBCBottlerSalesHier]
GO
/****** Object:  Table [MSTR].[DimBCBottlerEBHier]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimBCBottlerEBHier]
GO
/****** Object:  Table [MSTR].[DimAccountChainHier]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimAccountChainHier]
GO
/****** Object:  Table [MSTR].[DimAccount]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[DimAccount]
GO
/****** Object:  Table [MSTR].[BCMonthCloseDMTable]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [MSTR].[BCMonthCloseDMTable]
GO
/****** Object:  Table [EDGE].[WebServiceLog]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [EDGE].[WebServiceLog]
GO
/****** Object:  Table [EDGE].[UserMapping]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [EDGE].[UserMapping]
GO
/****** Object:  Table [EDGE].[RPLItemPackage]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [EDGE].[RPLItemPackage]
GO
/****** Object:  Table [EDGE].[RPLItemNAE]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [EDGE].[RPLItemNAE]
GO
/****** Object:  Table [EDGE].[RPLItemChannel]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [EDGE].[RPLItemChannel]
GO
/****** Object:  Table [EDGE].[RPLItemBrand]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [EDGE].[RPLItemBrand]
GO
/****** Object:  Table [EDGE].[RPLItemAccount]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [EDGE].[RPLItemAccount]
GO
ALTER TABLE [Playbook].[RetailPromotion] DROP CONSTRAINT [FK__RetailPro__ItemI__04EFA97D]
GO
/****** Object:  Table [EDGE].[RPLItem]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [EDGE].[RPLItem]
GO
/****** Object:  Table [EDGE].[RPLAttachment]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [EDGE].[RPLAttachment]
GO
/****** Object:  Table [EDGE].[RPLAttachementType]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [EDGE].[RPLAttachementType]
GO
/****** Object:  Table [EDGE].[PitPackageSizeMapping]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [EDGE].[PitPackageSizeMapping]
GO
/****** Object:  Table [EDGE].[ErrorHandler]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [EDGE].[ErrorHandler]
GO
/****** Object:  Table [EDGE].[ChannelMapping]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [EDGE].[ChannelMapping]
GO
/****** Object:  Table [EDGE].[BrandMapping]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [EDGE].[BrandMapping]
GO
/****** Object:  Table [EDGE].[AccountMapping]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [EDGE].[AccountMapping]
GO
/****** Object:  Table [CDE].[UserProfileTemp]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [CDE].[UserProfileTemp]
GO
/****** Object:  Table [CDE].[ROICommissionsImport]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [CDE].[ROICommissionsImport]
GO
/****** Object:  Table [CDE].[Reference]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [CDE].[Reference]
GO
/****** Object:  Table [CDE].[ObjectType]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [CDE].[ObjectType]
GO
/****** Object:  Table [CDE].[Notification]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [CDE].[Notification]
GO
/****** Object:  Table [CDE].[NoBuySummary]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [CDE].[NoBuySummary]
GO
/****** Object:  Table [CDE].[NoBuyCategory]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [CDE].[NoBuyCategory]
GO
/****** Object:  Table [CDE].[MTDNoBuySummary]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [CDE].[MTDNoBuySummary]
GO
/****** Object:  Table [CDE].[ExtractZeso]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [CDE].[ExtractZeso]
GO
/****** Object:  Table [CDE].[ExtractZemoPickup]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [CDE].[ExtractZemoPickup]
GO
/****** Object:  Table [CDE].[ExtractZemoDelivery]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [CDE].[ExtractZemoDelivery]
GO
/****** Object:  Table [CDE].[ExtractVemo]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [CDE].[ExtractVemo]
GO
/****** Object:  Table [CDE].[ExtractChangeEquipment]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [CDE].[ExtractChangeEquipment]
GO
/****** Object:  Table [CDE].[EquipmentSnapshot]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [CDE].[EquipmentSnapshot]
GO
/****** Object:  Table [CDE].[EquipmentAgeCategory]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [CDE].[EquipmentAgeCategory]
GO
/****** Object:  Table [CDE].[Equipment]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [CDE].[Equipment]
GO
/****** Object:  Table [CDE].[AssetValidation]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [CDE].[AssetValidation]
GO
/****** Object:  Table [CDE].[AssetActionStatus]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [CDE].[AssetActionStatus]
GO
/****** Object:  Table [CDE].[Account]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [CDE].[Account]
GO
/****** Object:  Table [CDE].[AccessToken]    Script Date: 7/22/2015 11:31:50 AM ******/
DROP TABLE [CDE].[AccessToken]
GO

/****** Object:  Table [TempBUOrg].[TempUserLocationBranches]    Script Date: 7/22/2015 3:10:17 PM ******/
DROP TABLE [TempBUOrg].[TempUserLocationBranches]
GO
/****** Object:  Table [TempBUOrg].[TempPromotionGeoRelevancyBranch]    Script Date: 7/22/2015 3:10:17 PM ******/
DROP TABLE [TempBUOrg].[TempPromotionGeoRelevancyBranch]
GO
/****** Object:  Table [TempBUOrg].[TempLocationMapping]    Script Date: 7/22/2015 3:10:17 PM ******/
DROP TABLE [TempBUOrg].[TempLocationMapping]
GO
/****** Object:  Table [TempBUOrg].[SAP.ProfitCenter]    Script Date: 7/22/2015 3:10:17 PM ******/
DROP TABLE [TempBUOrg].[SAP.ProfitCenter]
GO
/****** Object:  Table [TempBUOrg].[SAP.CostCenter]    Script Date: 7/22/2015 3:10:17 PM ******/
DROP TABLE [TempBUOrg].[SAP.CostCenter]
GO
/****** Object:  Table [TempBUOrg].[SAP.BusinessUnit]    Script Date: 7/22/2015 3:10:17 PM ******/
DROP TABLE [TempBUOrg].[SAP.BusinessUnit]
GO
/****** Object:  Table [TempBUOrg].[SAP.Branch]    Script Date: 7/22/2015 3:10:17 PM ******/
DROP TABLE [TempBUOrg].[SAP.Branch]
GO
/****** Object:  Table [TempBUOrg].[SAP.Area]    Script Date: 7/22/2015 3:10:17 PM ******/
DROP TABLE [TempBUOrg].[SAP.Area]
GO
/****** Object:  Table [TempBUOrg].[SAP.Account]    Script Date: 7/22/2015 3:10:17 PM ******/
DROP TABLE [TempBUOrg].[SAP.Account]
GO
/****** Object:  Table [TempBUOrg].[Playbook.PromotionGeoRelevancy]    Script Date: 7/22/2015 3:10:17 PM ******/
DROP TABLE [TempBUOrg].[Playbook.PromotionGeoRelevancy]
GO
/****** Object:  Table [TempBUOrg].[Person.UserProfile]    Script Date: 7/22/2015 3:10:17 PM ******/
DROP TABLE [TempBUOrg].[Person.UserProfile]
GO
/****** Object:  Table [TempBUOrg].[Person.UserLocation]    Script Date: 7/22/2015 3:10:17 PM ******/
DROP TABLE [TempBUOrg].[Person.UserLocation]
GO
/****** Object:  Table [TempBUOrg].[Person.SPUserProfile]    Script Date: 7/22/2015 3:10:17 PM ******/
DROP TABLE [TempBUOrg].[Person.SPUserProfile]
GO
/****** Object:  Table [Apacheta].[OriginalOrder]    Script Date: 7/22/2015 3:17:04 PM ******/
DROP TABLE [Apacheta].[OriginalOrder]
GO
/****** Object:  Table [Apacheta].[FleetLoader]    Script Date: 7/22/2015 3:17:04 PM ******/
DROP TABLE [Apacheta].[FleetLoader]
GO
/****** Object:  Table [msrt].[SurveyCustomers_staging2]    Script Date: 8/10/2015 10:02:46 AM ******/
DROP TABLE [msrt].[SurveyCustomers_staging2]
GO
/****** Object:  Table [HRReport].[TransYTDDayHR]    Script Date: 8/10/2015 10:02:46 AM ******/
DROP TABLE [HRReport].[TransYTDDayHR]
GO
/****** Object:  Table [HRReport].[TransTQLQHR]    Script Date: 8/10/2015 10:02:46 AM ******/
DROP TABLE [HRReport].[TransTQLQHR]
GO
/****** Object:  Table [HRReport].[DimQuarterHR]    Script Date: 8/10/2015 10:02:46 AM ******/
DROP TABLE [HRReport].[DimQuarterHR]
GO
/****** Object:  Table [HRReport].[DimMonthHR]    Script Date: 8/10/2015 10:02:46 AM ******/
DROP TABLE [HRReport].[DimMonthHR]
GO
/****** Object:  Table [HRReport].[DimDayHR]    Script Date: 8/10/2015 10:02:46 AM ******/
DROP TABLE [HRReport].[DimDayHR]
GO
/****** Object:  Table [Staging].[RevUPROFILE]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[RevUPROFILE]
GO
/****** Object:  Table [Staging].[RevTOTALPOP]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[RevTOTALPOP]
GO
/****** Object:  Table [Staging].[RevSalesRouteAccount]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[RevSalesRouteAccount]
GO
/****** Object:  Table [Staging].[RevPROMOTOTALPOPULATION]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[RevPROMOTOTALPOPULATION]
GO
/****** Object:  Table [Staging].[RevPromotionChain]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[RevPromotionChain]
GO
/****** Object:  Table [Staging].[RevPROMOTION_ACCOUNT_CHAIN]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[RevPROMOTION_ACCOUNT_CHAIN]
GO
/****** Object:  Table [Staging].[RevPROMORESULTS]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[RevPROMORESULTS]
GO
/****** Object:  Table [Staging].[RevPROMOCHAINIMAGEPREP]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[RevPROMOCHAINIMAGEPREP]
GO
/****** Object:  Table [Staging].[RevPROMOACCOUNTHIER]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[RevPROMOACCOUNTHIER]
GO
/****** Object:  Table [Staging].[RevNEXTROUTE]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[RevNEXTROUTE]
GO
/****** Object:  Table [Staging].[RevGeoRelevancy3Weeks]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[RevGeoRelevancy3Weeks]
GO
/****** Object:  Table [Staging].[RevGeoRelevancy]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[RevGeoRelevancy]
GO
/****** Object:  Table [Staging].[RevCUSTFACT]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[RevCUSTFACT]
GO
/****** Object:  Table [Staging].[NielsenTop70ProductCodes]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[NielsenTop70ProductCodes]
GO
/****** Object:  Table [Staging].[NielsenShare]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[NielsenShare]
GO
/****** Object:  Table [Staging].[NielsenProduct]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[NielsenProduct]
GO
/****** Object:  Table [Staging].[NielsenMaxDisplay_Keyed]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[NielsenMaxDisplay_Keyed]
GO
/****** Object:  Table [Staging].[NielsenMaxDisplay]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[NielsenMaxDisplay]
GO
/****** Object:  Table [Staging].[NielsenMarketOwners]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[NielsenMarketOwners]
GO
/****** Object:  Table [Staging].[NielsenMarket]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[NielsenMarket]
GO
/****** Object:  Table [Staging].[NielsenISOMarketOwners]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[NielsenISOMarketOwners]
GO
/****** Object:  Table [Staging].[NielsenDisplayTieIn_Keyed]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[NielsenDisplayTieIn_Keyed]
GO
/****** Object:  Table [Staging].[NielsenDisplayTieIn]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[NielsenDisplayTieIn]
GO
/****** Object:  Table [Staging].[NielsenCategorySales]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[NielsenCategorySales]
GO
/****** Object:  Table [Staging].[NielsenBCTieInRate]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[NielsenBCTieInRate]
GO
/****** Object:  Table [Staging].[NielsenBCShare]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[NielsenBCShare]
GO
/****** Object:  Table [Staging].[NielsenBCProduct]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[NielsenBCProduct]
GO
/****** Object:  Table [Staging].[NielsenBCMarket]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[NielsenBCMarket]
GO
/****** Object:  Table [Staging].[NielsenBCDisplays]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[NielsenBCDisplays]
GO
/****** Object:  Table [Staging].[NielsenACV_Keyed]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[NielsenACV_Keyed]
GO
/****** Object:  Table [Staging].[NielsenACV]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[NielsenACV]
GO
/****** Object:  Table [Staging].[MSTR_FactBCSurveyResults]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[MSTR_FactBCSurveyResults]
GO
/****** Object:  Table [Staging].[FactWDAmplifyOandFOrderLoad]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[FactWDAmplifyOandFOrderLoad]
GO
/****** Object:  Table [Staging].[FactWDAmplifyInvoiceDataLoad]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[FactWDAmplifyInvoiceDataLoad]
GO
/****** Object:  Table [Staging].[FactWDAmplifyAOPandForeCastLoad]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[FactWDAmplifyAOPandForeCastLoad]
GO
/****** Object:  Table [Staging].[FactOFDDeliveryMetricsLoad]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[FactOFDDeliveryMetricsLoad]
GO
/****** Object:  Table [Staging].[FactOFDDailyMetricsLoad]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[FactOFDDailyMetricsLoad]
GO
/****** Object:  Table [Staging].[FactOFDCasesCutsLoad]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[FactOFDCasesCutsLoad]
GO
/****** Object:  Table [Staging].[FactNPTLoad]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[FactNPTLoad]
GO
/****** Object:  Table [Staging].[FactMyDayCustomerLoad]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[FactMyDayCustomerLoad]
GO
/****** Object:  Table [Staging].[FactMyDayCustomerHistLoad]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[FactMyDayCustomerHistLoad]
GO
/****** Object:  Table [Staging].[EMUsageDataMart]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[EMUsageDataMart]
GO
/****** Object:  Table [Staging].[DSD_PVA]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[DSD_PVA]
GO
/****** Object:  Table [Staging].[DSD_ONSS]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[DSD_ONSS]
GO
/****** Object:  Table [Staging].[DSD_IR]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[DSD_IR]
GO
/****** Object:  Table [Staging].[DSD_HBR]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[DSD_HBR]
GO
/****** Object:  Table [Staging].[DSD_HBA]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[DSD_HBA]
GO
/****** Object:  Table [Staging].[DSD_GA]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[DSD_GA]
GO
/****** Object:  Table [Staging].[DSD_BP8D]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[DSD_BP8D]
GO
/****** Object:  Table [Staging].[DSD_BP6D]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[DSD_BP6D]
GO
/****** Object:  Table [Staging].[DSD_BP2]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[DSD_BP2]
GO
/****** Object:  Table [Staging].[DSD_BP1D]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Staging].[DSD_BP1D]
GO
/****** Object:  Table [Playbook].[retailpromotion_BackupRemovedParentPromotion]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Playbook].[retailpromotion_BackupRemovedParentPromotion]
GO
/****** Object:  Table [Playbook].[CopiesBackup_RootAccount_PromotionAccount]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Playbook].[CopiesBackup_RootAccount_PromotionAccount]
GO
/****** Object:  Table [Playbook].[CopiesBackup_RetailPromotion]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Playbook].[CopiesBackup_RetailPromotion]
GO
/****** Object:  Table [Playbook].[CopiesBackup_PromotionRank]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Playbook].[CopiesBackup_PromotionRank]
GO
/****** Object:  Table [Playbook].[CopiesBackup_PromotionPackage]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Playbook].[CopiesBackup_PromotionPackage]
GO
/****** Object:  Table [Playbook].[CopiesBackup_PromotionGeoRelevancy]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Playbook].[CopiesBackup_PromotionGeoRelevancy]
GO
/****** Object:  Table [Playbook].[CopiesBackup_PromotionDisplayLocation]    Script Date: 8/10/2015 2:53:31 PM ******/
DROP TABLE [Playbook].[CopiesBackup_PromotionDisplayLocation]
GO
/****** Object:  Table [Playbook].[CopiesBackup_PromotionBrand]    Script Date: 8/10/2015 2:53:32 PM ******/
DROP TABLE [Playbook].[CopiesBackup_PromotionBrand]
GO
/****** Object:  Table [Playbook].[CopiesBackup_PromotionAttachment]    Script Date: 8/10/2015 2:53:32 PM ******/
DROP TABLE [Playbook].[CopiesBackup_PromotionAttachment]
GO
/****** Object:  Table [Playbook].[CopiesBackup_PromotionAccount]    Script Date: 8/10/2015 2:53:32 PM ******/
DROP TABLE [Playbook].[CopiesBackup_PromotionAccount]
GO

-----------------------------------
DBCC SHRINKDATABASE (Portal_Data805, 1);
GO
-----------------------------------

-------------------------
DECLARE @TableName varchar(255) 
DECLARE TableCursor CURSOR FOR 
 
SELECT table_schema + '.' + table_name FROM information_schema.tables WHERE table_type = 'base table' 
order by table_name

 
OPEN TableCursor 
	FETCH NEXT FROM TableCursor INTO @TableName  
	WHILE @@FETCH_STATUS = 0  
		BEGIN  
		DBCC DBREINDEX(@TableName,' ',90)  
	FETCH NEXT FROM TableCursor INTO @TableName 
END 
 
CLOSE TableCursor 
 
DEALLOCATE TableCursor
Go

--exec sp_updatestats
--Go

SELECT OBJECT_NAME(OBJECT_ID), index_id,index_type_desc,index_level,
avg_fragmentation_in_percent,avg_page_space_used_in_percent,page_count
FROM sys.dm_db_index_physical_stats
(DB_ID(N'Portal_Data805'), NULL, NULL, NULL , 'SAMPLED')
ORDER BY page_count DESC
Go

/****** Object:  User [OnePortal]    Script Date: 8/10/2015 4:40:50 PM ******/
CREATE USER [OnePortal] FOR LOGIN [OnePortal] WITH DEFAULT_SCHEMA=[dbo]
GO

--EXEC sp_change_users_login 'Update_One', 'OnePortal', 'OnePortal'
--Go

--DBCC SHRINKDATABASE (Portal_Data805, 1);
--GO
