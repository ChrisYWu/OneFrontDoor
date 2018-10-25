USE [Portal_Data]
GO

/*
ETL Scheduling Sequence
1. ETL.pNormalizeMaterial
2. ETL.pNomalizeLocations
3. ETL.pNormalizeChains
4. ETL.pLoadFromRM
5. ETL.pLoadUserProfile
6. ETL.pAssociateBranchMaterial
7. ETL.pAssociateRMPerson
8. ETL.pDViews

*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ETL].[pNormalizeMaterial]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ETL].[pNormalizeMaterial]
GO

USE [Portal_Data]
GO

/****** Object:  StoredProcedure [ETL].[pNormalizeMaterial]    Script Date: 03/21/2013 09:44:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ETL].[pNormalizeMaterial] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--1. Franchisor
	--2. BevType
	--3. Trademark
	--4. Brand
	--5 .Flavor
	--6. Package Type
	--7. PackConfig

	--The only relationship I is between trademark and brand
	--------------------------------------------
	---- Franchisor -----------------------------
	MERGE SAP.Franchisor AS pc
		USING (	Select distinct FranchisorID, Franchisor
				From BWStaging.MaterialBrandPKG) AS input
			ON pc.SAPFranchisorID = input.FranchisorID
	WHEN MATCHED THEN 
		UPDATE SET pc.FranchisorName = input.Franchisor
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPFranchisorID, FranchisorName)
	VALUES(input.FranchisorID, input.Franchisor);
	--------------------------------------------

	--------------------------------------------
	-- Need to find out how to load the RM data --
	---- PackageType ---------------------------
	MERGE SAP.PackageType AS pc
		USING (Select Distinct PackTypeID, PackType
			   From BWStaging.MaterialBrandPKG) AS input
			ON pc.SAPPackageTypeID = input.PackTypeID
	WHEN MATCHED THEN 
		UPDATE SET pc.PackageTypeName = input.PackType
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPPackageTypeID, PackageTypeName)
	VALUES(input.PackTypeID, input.PackType);
	--------------------------------------------

	--------------------------------------------
	---- PackageConf -----------------------------
	MERGE SAP.PackageConf AS pc
		USING (Select Distinct PackConfID, PackConf
			   From BWStaging.MaterialBrandPKG) AS input
			ON pc.SAPPackageConfID = input.PackConfID
	WHEN MATCHED THEN 
		UPDATE SET pc.PackageConfName = input.PackConf
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPPackageConfID, PackageConfName)
	VALUES(input.PackConfID, input.PackConf);
	--------------------------------------------

	--------------------------------------------
	---- BevType ---------------------------
	MERGE SAP.BevType AS pc
		USING (Select Distinct BevTypeID, BevType
			   From BWStaging.MaterialBrandPKG) AS input
			ON pc.SAPBevTypeID = input.BevTypeID
	WHEN MATCHED THEN 
		UPDATE SET pc.BevTypeName = dbo.udf_TitleCase(input.BevType)
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPBevTypeID, BevTypeName)
	VALUES(input.BevTypeID, dbo.udf_TitleCase(input.BevType));

	Update SAP.BevType
	Set BevTypeName = 'Applesauce - MS'
	Where BevTypeName = 'Applesauce - Ms'

	Update SAP.BevType
	Set BevTypeName = 'Applesauce - SS'
	Where BevTypeName = 'Applesauce - SS'

	Select * 
	From SAP.BevType
	--------------------------------------------
			 
	--------------------------------------------
	---- TradeMark ---------------------------
	MERGE SAP.TradeMark AS pc
		USING (Select Distinct TradeMarkID, TradeMark
			   From BWStaging.MaterialBrandPKG
			   Where TradeMarkID not in ('C25', 'D06', 'R07')) AS input
			ON pc.SAPTradeMarkID = input.TradeMarkID
	WHEN MATCHED THEN 
		UPDATE SET pc.TradeMarkName = dbo.udf_TitleCase(input.TradeMark)
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPTradeMarkID, TradeMarkName)
	VALUES(input.TradeMarkID, dbo.udf_TitleCase(input.TradeMark));

	Update SAP.TradeMark
	Set TradeMarkName = '7UP'
	Where TradeMarkName = '7up'

	------------------------------------------
	---- Brand -------------------------------
	MERGE SAP.Brand AS pc
		USING (Select t.TradeMarkID, mbp.BrandID, mbp.Brand
				From
				(Select Distinct TradeMarkID, BrandID, Brand
					From BWStaging.MaterialBrandPKG) mbp 
					Join SAP.Trademark t on mbp.TradeMarkID = t.SAPTradeMarkID) input				
			ON pc.SAPBrandID = input.BrandID
	WHEN MATCHED THEN 
		UPDATE SET pc.BrandName = dbo.udf_TitleCase(input.Brand),
					pc.TradeMarkID = input.TradeMarkID
	WHEN NOT MATCHED By Target THEN
		INSERT(TradeMarkID, SAPBrandID, BrandName)
	VALUES(input.TradeMarkID, input.BrandID, dbo.udf_TitleCase(input.Brand));

	Update SAP.Brand
	Set BrandName = '7UP'
	Where BrandName = '7up'
	--------------------------------------------

	------------------------------------------
	---- Flovar ------------------------------
	MERGE SAP.Flavor AS pc
		USING (Select Distinct FlavorID, Flavor
			   From BWStaging.MaterialBrandPKG) AS input
			ON pc.SAPFlavorID = input.FlavorID
	WHEN MATCHED THEN 
		UPDATE SET pc.FlavorName = dbo.udf_TitleCase(input.Flavor)
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPFlavorID, FlavorName)
	VALUES(input.FlavorID, dbo.udf_TitleCase(input.Flavor));
	--------------------------------------------

End



