USE [Portal_DataSRE]
GO
ALTER TABLE [SalesPriority].[SalesPriorityTrademark] DROP CONSTRAINT [FK_SalesPriorityBrands_SalesPriority]
GO
ALTER TABLE [SalesPriority].[SalesPriorityRank] DROP CONSTRAINT [FK_SalesPriorityRank_SalesPriority]
GO
ALTER TABLE [SalesPriority].[SalesPriorityPackage] DROP CONSTRAINT [FK_SalesPriorityPackage_SalesPriority]
GO
ALTER TABLE [SalesPriority].[SalesPriorityDisplayLocation] DROP CONSTRAINT [FK_SalesPriorityDisplayLocation_SalesPriority]
GO
ALTER TABLE [SalesPriority].[SalesPriorityDisplayLocation] DROP CONSTRAINT [FK_SalesPriorityDisplayLocation_DisplayLocation]
GO
ALTER TABLE [SalesPriority].[SalesPriorityAttachment] DROP CONSTRAINT [FK_SalesPriorityAttachment_SalesPriority]
GO
ALTER TABLE [SalesPriority].[SalesPriority] DROP CONSTRAINT [FK_SalesPriority_SalesPriorityStatus]
GO
ALTER TABLE [SalesPriority].[SalesPriority] DROP CONSTRAINT [FK_SalesPriority_SalesPriorityFormat]
GO
ALTER TABLE [SalesPriority].[SalesPriority] DROP CONSTRAINT [FK_SalesPriority_SalesPriorityAlignment]
GO
ALTER TABLE [MSTR].[SurveyUser] DROP CONSTRAINT [FK_SurveyUser_Surveys]
GO
ALTER TABLE [MSTR].[SurveyResults] DROP CONSTRAINT [FK_SurveyResults_Surveys]
GO
ALTER TABLE [MSTR].[SurveyQuestion] DROP CONSTRAINT [FK_SurveyQuestion_Surveys]
GO
ALTER TABLE [MSTR].[RelMyDaySalesOfficePlanVersion] DROP CONSTRAINT [FK_RelMyDaySalesOfficePlanVersion_DimMydaySalesPlanVersions]
GO
ALTER TABLE [MSTR].[RelMyDaySalesOfficePlanVersion] DROP CONSTRAINT [FK_RelMyDaySalesOfficePlanVersion_Branch]
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
ALTER TABLE [MSTR].[DimBrandPackageMarginTiers] DROP CONSTRAINT [FK_DimBrandPackageMarginTiers_Package]
GO
ALTER TABLE [MSTR].[DimBrandPackageMarginTiers] DROP CONSTRAINT [FK_DimBrandPackageMarginTiers_Brand]
GO
ALTER TABLE [MSTR].[DimBranchPlan] DROP CONSTRAINT [FK_FactAnnualPlan_DimMonth]
GO
ALTER TABLE [MSTR].[DimBranchPlan] DROP CONSTRAINT [FK_FactAnnualPlan_Branch]
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
/****** Object:  Table [TempBUOrg].[UserLocationBranchesErrorLog]    Script Date: 3/13/2014 6:43:54 PM ******/
DROP TABLE [TempBUOrg].[UserLocationBranchesErrorLog]
GO
/****** Object:  Table [TempBUOrg].[TempUserLocationBranches]    Script Date: 3/13/2014 6:43:54 PM ******/
DROP TABLE [TempBUOrg].[TempUserLocationBranches]
GO
/****** Object:  Table [TempBUOrg].[TempPromotionGeoRelevancyBranch]    Script Date: 3/13/2014 6:43:54 PM ******/
DROP TABLE [TempBUOrg].[TempPromotionGeoRelevancyBranch]
GO
/****** Object:  Table [TempBUOrg].[TempLocationMapping]    Script Date: 3/13/2014 6:43:54 PM ******/
DROP TABLE [TempBUOrg].[TempLocationMapping]
GO
/****** Object:  Table [TempBUOrg].[SAP.Region]    Script Date: 3/13/2014 6:43:54 PM ******/
DROP TABLE [TempBUOrg].[SAP.Region]
GO
/****** Object:  Table [TempBUOrg].[SAP.ProfitCenter]    Script Date: 3/13/2014 6:43:55 PM ******/
DROP TABLE [TempBUOrg].[SAP.ProfitCenter]
GO
/****** Object:  Table [TempBUOrg].[SAP.CostCenter]    Script Date: 3/13/2014 6:43:55 PM ******/
DROP TABLE [TempBUOrg].[SAP.CostCenter]
GO
/****** Object:  Table [TempBUOrg].[SAP.BusinessUnit]    Script Date: 3/13/2014 6:43:55 PM ******/
DROP TABLE [TempBUOrg].[SAP.BusinessUnit]
GO
/****** Object:  Table [TempBUOrg].[SAP.Branch]    Script Date: 3/13/2014 6:43:55 PM ******/
DROP TABLE [TempBUOrg].[SAP.Branch]
GO
/****** Object:  Table [TempBUOrg].[SAP.Area]    Script Date: 3/13/2014 6:43:55 PM ******/
DROP TABLE [TempBUOrg].[SAP.Area]
GO
/****** Object:  Table [TempBUOrg].[SAP.Account]    Script Date: 3/13/2014 6:43:55 PM ******/
DROP TABLE [TempBUOrg].[SAP.Account]
GO
/****** Object:  Table [TempBUOrg].[Playbook.PromotionGeoRelevancy]    Script Date: 3/13/2014 6:43:56 PM ******/
DROP TABLE [TempBUOrg].[Playbook.PromotionGeoRelevancy]
GO
/****** Object:  Table [TempBUOrg].[Person.UserProfile]    Script Date: 3/13/2014 6:43:56 PM ******/
DROP TABLE [TempBUOrg].[Person.UserProfile]
GO
/****** Object:  Table [TempBUOrg].[Person.UserLocation]    Script Date: 3/13/2014 6:43:56 PM ******/
DROP TABLE [TempBUOrg].[Person.UserLocation]
GO
/****** Object:  Table [TempBUOrg].[Person.SPUserProfile]    Script Date: 3/13/2014 6:43:56 PM ******/
DROP TABLE [TempBUOrg].[Person.SPUserProfile]
GO
/****** Object:  Table [TempBUOrg].[MView.LocationHier]    Script Date: 3/13/2014 6:43:56 PM ******/
DROP TABLE [TempBUOrg].[MView.LocationHier]
GO
/****** Object:  Table [Staging].[CDEEquipment]    Script Date: 3/13/2014 6:43:56 PM ******/
DROP TABLE [Staging].[CDEEquipment]
GO
/****** Object:  Table [Staging].[CDEAccountDetails]    Script Date: 3/13/2014 6:43:57 PM ******/
DROP TABLE [Staging].[CDEAccountDetails]
GO
/****** Object:  Table [SalesPriority].[Status]    Script Date: 3/13/2014 6:43:57 PM ******/
DROP TABLE [SalesPriority].[Status]
GO
/****** Object:  Table [SalesPriority].[SalesPriorityTrademark]    Script Date: 3/13/2014 6:43:57 PM ******/
DROP TABLE [SalesPriority].[SalesPriorityTrademark]
GO
/****** Object:  Table [SalesPriority].[SalesPriorityRank]    Script Date: 3/13/2014 6:43:57 PM ******/
DROP TABLE [SalesPriority].[SalesPriorityRank]
GO
/****** Object:  Table [SalesPriority].[SalesPriorityPackage]    Script Date: 3/13/2014 6:43:57 PM ******/
DROP TABLE [SalesPriority].[SalesPriorityPackage]
GO
/****** Object:  Table [SalesPriority].[SalesPriorityFormat]    Script Date: 3/13/2014 6:43:58 PM ******/
DROP TABLE [SalesPriority].[SalesPriorityFormat]
GO
/****** Object:  Table [SalesPriority].[SalesPriorityDisplayLocation]    Script Date: 3/13/2014 6:43:58 PM ******/
DROP TABLE [SalesPriority].[SalesPriorityDisplayLocation]
GO
/****** Object:  Table [SalesPriority].[SalesPriorityAttachment]    Script Date: 3/13/2014 6:43:58 PM ******/
DROP TABLE [SalesPriority].[SalesPriorityAttachment]
GO
/****** Object:  Table [SalesPriority].[SalesPriorityAlignment]    Script Date: 3/13/2014 6:43:58 PM ******/
DROP TABLE [SalesPriority].[SalesPriorityAlignment]
GO
/****** Object:  Table [SalesPriority].[SalesPriority]    Script Date: 3/13/2014 6:43:58 PM ******/
DROP TABLE [SalesPriority].[SalesPriority]
GO
/****** Object:  Table [SalesPriority].[DisplayLocation]    Script Date: 3/13/2014 6:43:58 PM ******/
DROP TABLE [SalesPriority].[DisplayLocation]
GO
/****** Object:  Table [MSTR].[WDInputsSurveyResults]    Script Date: 3/13/2014 6:43:59 PM ******/
DROP TABLE [MSTR].[WDInputsSurveyResults]
GO
/****** Object:  Table [MSTR].[WDDetailSurveyResults_new_Backup_10182013]    Script Date: 3/13/2014 6:43:59 PM ******/
DROP TABLE [MSTR].[WDDetailSurveyResults_new_Backup_10182013]
GO
/****** Object:  Table [MSTR].[WDDetailSurveyResults_new_Backup_10172013]    Script Date: 3/13/2014 6:43:59 PM ******/
DROP TABLE [MSTR].[WDDetailSurveyResults_new_Backup_10172013]
GO
/****** Object:  Table [MSTR].[WDDetailSurveyResults_new]    Script Date: 3/13/2014 6:43:59 PM ******/
DROP TABLE [MSTR].[WDDetailSurveyResults_new]
GO
/****** Object:  Table [MSTR].[WDDetailSurveyResults]    Script Date: 3/13/2014 6:43:59 PM ******/
DROP TABLE [MSTR].[WDDetailSurveyResults]
GO
/****** Object:  Table [MSTR].[TransYTDMonthID]    Script Date: 3/13/2014 6:44:00 PM ******/
DROP TABLE [MSTR].[TransYTDMonthID]
GO
/****** Object:  Table [MSTR].[TransYTDDay]    Script Date: 3/13/2014 6:44:00 PM ******/
DROP TABLE [MSTR].[TransYTDDay]
GO
/****** Object:  Table [MSTR].[TransWTDDay]    Script Date: 3/13/2014 6:44:00 PM ******/
DROP TABLE [MSTR].[TransWTDDay]
GO
/****** Object:  Table [MSTR].[TransQTDDay]    Script Date: 3/13/2014 6:44:00 PM ******/
DROP TABLE [MSTR].[TransQTDDay]
GO
/****** Object:  Table [MSTR].[TransMTDDay]    Script Date: 3/13/2014 6:44:00 PM ******/
DROP TABLE [MSTR].[TransMTDDay]
GO
/****** Object:  Table [MSTR].[SurveyUser]    Script Date: 3/13/2014 6:44:00 PM ******/
DROP TABLE [MSTR].[SurveyUser]
GO
/****** Object:  Table [MSTR].[Surveys]    Script Date: 3/13/2014 6:44:01 PM ******/
DROP TABLE [MSTR].[Surveys]
GO
/****** Object:  Table [MSTR].[SurveyResultsStaging]    Script Date: 3/13/2014 6:44:01 PM ******/
DROP TABLE [MSTR].[SurveyResultsStaging]
GO
/****** Object:  Table [MSTR].[SurveyResults]    Script Date: 3/13/2014 6:44:01 PM ******/
DROP TABLE [MSTR].[SurveyResults]
GO
/****** Object:  Table [MSTR].[SurveyQuestion]    Script Date: 3/13/2014 6:44:01 PM ******/
DROP TABLE [MSTR].[SurveyQuestion]
GO
/****** Object:  Table [MSTR].[SurveyPhotos_new]    Script Date: 3/13/2014 6:44:01 PM ******/
DROP TABLE [MSTR].[SurveyPhotos_new]
GO
/****** Object:  Table [MSTR].[SurveyPhotos]    Script Date: 3/13/2014 6:44:02 PM ******/
DROP TABLE [MSTR].[SurveyPhotos]
GO
/****** Object:  Table [MSTR].[SurveyCustomers_staging2]    Script Date: 3/13/2014 6:44:02 PM ******/
DROP TABLE [MSTR].[SurveyCustomers_staging2]
GO
/****** Object:  Table [MSTR].[SurveyCustomers_Staging]    Script Date: 3/13/2014 6:44:02 PM ******/
DROP TABLE [MSTR].[SurveyCustomers_Staging]
GO
/****** Object:  Table [MSTR].[SurveyCustomers_Copy2]    Script Date: 3/13/2014 6:44:02 PM ******/
DROP TABLE [MSTR].[SurveyCustomers_Copy2]
GO
/****** Object:  Table [MSTR].[SurveyCustomers_Copy]    Script Date: 3/13/2014 6:44:02 PM ******/
DROP TABLE [MSTR].[SurveyCustomers_Copy]
GO
/****** Object:  Table [MSTR].[SurveyCustomers_Bak]    Script Date: 3/13/2014 6:44:02 PM ******/
DROP TABLE [MSTR].[SurveyCustomers_Bak]
GO
/****** Object:  Table [MSTR].[SurveyCustomers]    Script Date: 3/13/2014 6:44:03 PM ******/
DROP TABLE [MSTR].[SurveyCustomers]
GO
/****** Object:  Table [MSTR].[STG_Hispanic]    Script Date: 3/13/2014 6:44:03 PM ******/
DROP TABLE [MSTR].[STG_Hispanic]
GO
/****** Object:  Table [MSTR].[SourceGOALDeployment]    Script Date: 3/13/2014 6:44:03 PM ******/
DROP TABLE [MSTR].[SourceGOALDeployment]
GO
/****** Object:  Table [MSTR].[RelMyDaySalesOfficePlanVersion]    Script Date: 3/13/2014 6:44:03 PM ******/
DROP TABLE [MSTR].[RelMyDaySalesOfficePlanVersion]
GO
/****** Object:  Table [MSTR].[LogMyDayCustSumBWDailyValidation]    Script Date: 3/13/2014 6:44:03 PM ******/
DROP TABLE [MSTR].[LogMyDayCustSumBWDailyValidation]
GO
/****** Object:  Table [MSTR].[LogFactMyDayCustomer]    Script Date: 3/13/2014 6:44:03 PM ******/
DROP TABLE [MSTR].[LogFactMyDayCustomer]
GO
/****** Object:  Table [MSTR].[GetRouteDetail]    Script Date: 3/13/2014 6:44:04 PM ******/
DROP TABLE [MSTR].[GetRouteDetail]
GO
/****** Object:  Table [MSTR].[FactOFDDailyMetricsBak]    Script Date: 3/13/2014 6:44:04 PM ******/
DROP TABLE [MSTR].[FactOFDDailyMetricsBak]
GO
/****** Object:  Table [MSTR].[FactOFDDailyMetrics]    Script Date: 3/13/2014 6:44:04 PM ******/
DROP TABLE [MSTR].[FactOFDDailyMetrics]
GO
/****** Object:  Table [MSTR].[FactOFDCasesCuts]    Script Date: 3/13/2014 6:44:04 PM ******/
DROP TABLE [MSTR].[FactOFDCasesCuts]
GO
/****** Object:  Table [MSTR].[FactMyDayRoutePlan]    Script Date: 3/13/2014 6:44:04 PM ******/
DROP TABLE [MSTR].[FactMyDayRoutePlan]
GO
/****** Object:  Table [MSTR].[FactMyDayCustomerSummary_Old]    Script Date: 3/13/2014 6:44:05 PM ******/
DROP TABLE [MSTR].[FactMyDayCustomerSummary_Old]
GO
/****** Object:  Table [MSTR].[FactMyDayCustomerSummary]    Script Date: 3/13/2014 6:44:05 PM ******/
DROP TABLE [MSTR].[FactMyDayCustomerSummary]
GO
/****** Object:  Table [MSTR].[FactMyDayCustomer]    Script Date: 3/13/2014 6:44:05 PM ******/
DROP TABLE [MSTR].[FactMyDayCustomer]
GO
/****** Object:  Table [MSTR].[FactMyDayBranchPlanRanking]    Script Date: 3/13/2014 6:44:05 PM ******/
DROP TABLE [MSTR].[FactMyDayBranchPlanRanking]
GO
/****** Object:  Table [MSTR].[FactGOALDeployment]    Script Date: 3/13/2014 6:44:05 PM ******/
DROP TABLE [MSTR].[FactGOALDeployment]
GO
/****** Object:  Table [MSTR].[DimYear]    Script Date: 3/13/2014 6:44:05 PM ******/
DROP TABLE [MSTR].[DimYear]
GO
/****** Object:  Table [MSTR].[DimWeek]    Script Date: 3/13/2014 6:44:06 PM ******/
DROP TABLE [MSTR].[DimWeek]
GO
/****** Object:  Table [MSTR].[DimTENBrands]    Script Date: 3/13/2014 6:44:06 PM ******/
DROP TABLE [MSTR].[DimTENBrands]
GO
/****** Object:  Table [MSTR].[DimSuperChannelForComparison]    Script Date: 3/13/2014 6:44:06 PM ******/
DROP TABLE [MSTR].[DimSuperChannelForComparison]
GO
/****** Object:  Table [MSTR].[DimQuarter]    Script Date: 3/13/2014 6:44:06 PM ******/
DROP TABLE [MSTR].[DimQuarter]
GO
/****** Object:  Table [MSTR].[DimMydaySalesPlanVersions]    Script Date: 3/13/2014 6:44:06 PM ******/
DROP TABLE [MSTR].[DimMydaySalesPlanVersions]
GO
/****** Object:  Table [MSTR].[DimMonth]    Script Date: 3/13/2014 6:44:07 PM ******/
DROP TABLE [MSTR].[DimMonth]
GO
/****** Object:  Table [MSTR].[DimMetricName]    Script Date: 3/13/2014 6:44:07 PM ******/
DROP TABLE [MSTR].[DimMetricName]
GO
/****** Object:  Table [MSTR].[DimGOALMetric]    Script Date: 3/13/2014 6:44:07 PM ******/
DROP TABLE [MSTR].[DimGOALMetric]
GO
/****** Object:  Table [MSTR].[DimDay]    Script Date: 3/13/2014 6:44:07 PM ******/
DROP TABLE [MSTR].[DimDay]
GO
/****** Object:  Table [MSTR].[DimBrandPackageMarginTiers]    Script Date: 3/13/2014 6:44:07 PM ******/
DROP TABLE [MSTR].[DimBrandPackageMarginTiers]
GO
/****** Object:  Table [MSTR].[DimBranchPlan]    Script Date: 3/13/2014 6:44:07 PM ******/
DROP TABLE [MSTR].[DimBranchPlan]
GO
/****** Object:  Table [msrt].[SurveyCustomers_staging2]    Script Date: 3/13/2014 6:44:08 PM ******/
DROP TABLE [msrt].[SurveyCustomers_staging2]
GO
/****** Object:  Table [CDE].[UserProfileTemp]    Script Date: 3/13/2014 6:44:08 PM ******/
DROP TABLE [CDE].[UserProfileTemp]
GO
/****** Object:  Table [CDE].[Reference]    Script Date: 3/13/2014 6:44:08 PM ******/
DROP TABLE [CDE].[Reference]
GO
/****** Object:  Table [CDE].[NoBuySummary]    Script Date: 3/13/2014 6:44:08 PM ******/
DROP TABLE [CDE].[NoBuySummary]
GO
/****** Object:  Table [CDE].[NoBuyCategory]    Script Date: 3/13/2014 6:44:08 PM ******/
DROP TABLE [CDE].[NoBuyCategory]
GO
/****** Object:  Table [CDE].[EquipmentSnapshot]    Script Date: 3/13/2014 6:44:08 PM ******/
DROP TABLE [CDE].[EquipmentSnapshot]
GO
/****** Object:  Table [CDE].[EquipmentAgeCategory]    Script Date: 3/13/2014 6:44:09 PM ******/
DROP TABLE [CDE].[EquipmentAgeCategory]
GO
/****** Object:  Table [CDE].[Equipment]    Script Date: 3/13/2014 6:44:09 PM ******/
DROP TABLE [CDE].[Equipment]
GO
/****** Object:  Table [CDE].[AssetValidation]    Script Date: 3/13/2014 6:44:09 PM ******/
DROP TABLE [CDE].[AssetValidation]
GO
/****** Object:  Table [CDE].[AssetActionStatus]    Script Date: 3/13/2014 6:44:09 PM ******/
DROP TABLE [CDE].[AssetActionStatus]
GO
/****** Object:  Table [CDE].[Account]    Script Date: 3/13/2014 6:44:09 PM ******/
DROP TABLE [CDE].[Account]
GO
/****** Object:  Table [CDE].[AccessToken]    Script Date: 3/13/2014 6:44:10 PM ******/
DROP TABLE [CDE].[AccessToken]
GO

USE [Portal_DataSRE]
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
/****** Object:  Table [EDGE].[WebServiceLog]    Script Date: 3/13/2014 6:46:24 PM ******/
DROP TABLE [EDGE].[WebServiceLog]
GO
/****** Object:  Table [EDGE].[UserMapping]    Script Date: 3/13/2014 6:46:24 PM ******/
DROP TABLE [EDGE].[UserMapping]
GO
/****** Object:  Table [EDGE].[RPLItemPackage]    Script Date: 3/13/2014 6:46:24 PM ******/
DROP TABLE [EDGE].[RPLItemPackage]
GO
/****** Object:  Table [EDGE].[RPLItemNAE]    Script Date: 3/13/2014 6:46:25 PM ******/
DROP TABLE [EDGE].[RPLItemNAE]
GO
/****** Object:  Table [EDGE].[RPLItemChannel]    Script Date: 3/13/2014 6:46:25 PM ******/
DROP TABLE [EDGE].[RPLItemChannel]
GO
/****** Object:  Table [EDGE].[RPLItemBrand]    Script Date: 3/13/2014 6:46:25 PM ******/
DROP TABLE [EDGE].[RPLItemBrand]
GO
/****** Object:  Table [EDGE].[RPLItemAccount]    Script Date: 3/13/2014 6:46:25 PM ******/
DROP TABLE [EDGE].[RPLItemAccount]
GO
/****** Object:  Table [EDGE].[RPLItem]    Script Date: 3/13/2014 6:46:25 PM ******/
Truncate TABLE [EDGE].[RPLItem]
GO
/****** Object:  Table [EDGE].[RPLAttachment]    Script Date: 3/13/2014 6:46:25 PM ******/
DROP TABLE [EDGE].[RPLAttachment]
GO
/****** Object:  Table [EDGE].[RPLAttachementType]    Script Date: 3/13/2014 6:46:26 PM ******/
DROP TABLE [EDGE].[RPLAttachementType]
GO
/****** Object:  Table [EDGE].[PitPackageSizeMapping]    Script Date: 3/13/2014 6:46:26 PM ******/
DROP TABLE [EDGE].[PitPackageSizeMapping]
GO
/****** Object:  Table [EDGE].[ErrorHandler]    Script Date: 3/13/2014 6:46:26 PM ******/
DROP TABLE [EDGE].[ErrorHandler]
GO
/****** Object:  Table [EDGE].[ChannelMapping]    Script Date: 3/13/2014 6:46:26 PM ******/
DROP TABLE [EDGE].[ChannelMapping]
GO
/****** Object:  Table [EDGE].[BrandMapping]    Script Date: 3/13/2014 6:46:26 PM ******/
DROP TABLE [EDGE].[BrandMapping]
GO
/****** Object:  Table [EDGE].[AccountMapping]    Script Date: 3/13/2014 6:46:26 PM ******/
DROP TABLE [EDGE].[AccountMapping]
GO

Use Portal_DataSRE
Go

ALTER DATABASE Portal_DataSRE 
SET RECOVERY SIMPLE;
GO
DBCC SHRINKFILE(Portal_Data_log, 1);



DBCC SHRINKFILE(Portal_Data_log, 1)
GO 
