USE [Portal_Data]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ETL].[pLoadMaterial]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ETL].[pLoadMaterial]
GO

USE [Portal_Data]
GO

/****** Object:  StoredProcedure [ETL].[pLoadMaterial]    Script Date: 03/21/2013 09:44:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ETL].[pLoadMaterial] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	--------------------------------------------
	---- Package ------------------------------
	MERGE SAP.Package AS bu
		USING (Select Distinct Rtrim(mbp.PackTypeID) + Rtrim(mbp.PackConfID) PACKAGEID, 
								Replace(Replace(Replace(dbo.udf_TitleCase(Rtrim(mbp.PackType) + ' ' + Rtrim(mbp.PackConf)), 'Oz', 'OZ'), 'Ls', 'LS'), 'pk', 'PK') PACKAGEName
								,pc.PackageConfID, pt.PackageTypeID								
			   From Staging.MaterialBrandPKG mbp
			   		Join SAP.PackageConf pc on mbp.PackConfID = pc.SAPPackageConfID
					Join SAP.PackageType pt on mbp.PackTypeID = pt.SAPPackageTypeID) AS input
			ON bu.RMPackageID = input.PACKAGEID
	WHEN MATCHED THEN 
		UPDATE SET bu.Active = 1
	WHEN NOT MATCHED By Source THEN
		UPDATE SET bu.Active = 0
	WHEN NOT MATCHED By Target THEN
				INSERT ([RMPackageID]
           ,[PackageTypeID]
           ,[PackageConfID]
           ,[PackageName]
           ,Active
           ,[SPPackageName]
           ,Source)
		 VALUES
			   (PACKAGEID
			   ,PackageTypeID
			   ,PackageConfID
			   ,Case When [PackageName] = 'Not Assigned Not Assigned' Then 'Not Assigned' Else PackageName End
			   ,1
			   ,Case When [PackageName] = 'Not Assigned Not Assigned' Then 'Not Assigned' Else PackageName End
			   ,'SAPBW');
	--------------------------------------------
	
	--	MERGE SAP.Package AS bu
	--	USING (Select Distinct Rtrim(pt.SAPPackageTypeID) + Rtrim(pc.SAPPackageConfID) PACKAGEID, 
	--							Replace(Replace(Replace(dbo.udf_TitleCase(Rtrim(pt.PackageTypeName) + ' ' + Rtrim(pc.PackageConfName)), 'Oz', 'OZ'), 'Ls', 'LS'), 'pk', 'PK') PACKAGEName
	--							,pc.PackageConfID, pt.PackageTypeID
	--		   From SAP.Material mbp
	--		   		Join SAP.PackageConf pc on mbp.PackageConfID = pc.PackageConfID
	--				Join SAP.PackageType pt on mbp.PackageTypeID = pt.PackageTypeID) AS input
	--		ON bu.RMPackageID = input.PACKAGEID
	--WHEN MATCHED THEN 
	--	UPDATE SET bu.Active = 1
	--WHEN NOT MATCHED By Source THEN
	--	UPDATE SET bu.Active = 0
	--WHEN NOT MATCHED By Target THEN
	--			INSERT ([RMPackageID]
 --          ,[PackageTypeID]
 --          ,[PackageConfID]
 --          ,[PackageName]
 --          ,Active
 --          ,[SPPackageName]
 --          ,Source)
	--	 VALUES
	--		   (PACKAGEID
	--		   ,PackageTypeID
	--		   ,PackageConfID
	--		   ,[PackageName]
	--		   ,1
	--		   ,[PackageName]
	--		   ,'SAPBW');
	--------------------------------------------
	--Update m
	--Set PackageID = p.PackageID
	--From SAP.Material m
	--Join SAP.PackageType pt on m.PackageTypeID = pt.PackageTypeID
	--Join SAP.PackageConf pc on m.PackageConfID = pc.PackageConfID
	--Join SAP.Package p on pt.SAPPackageTypeID + pc.SAPPackageConfID = p.RMPackageID

	--------------------------------------------
	---- Material ------------------------------
	
	MERGE SAP.Material AS bu
		USING (Select Distinct MaterialID, Material, f.FranchisorID, bt.BevTypeID, t.TradeMarkID, 
					b.BrandID, fl.FlavorID, p.PackageID
			   From Staging.MaterialBrandPKG mbp
					Join SAP.Franchisor f on mbp.FranchisorID = f.SAPFranchisorID
					Join SAP.BevType bt on mbp.BevTypeID = bt.SAPBevTypeID
					Join SAP.TradeMark t on mbp.TrademarkID = t.SAPTrademarkID
					Join SAP.Brand b on mbp.BrandID = b.SAPBrandID
					Join SAP.Flavor fl on mbp.FlavorID = fl.SAPFlavorID
					Left Join SAP.Package p on Rtrim(mbp.PackTypeID) + Rtrim(mbp.PackConfID) = p.RMPackageID
					) AS input
			ON bu.SAPMaterialID = input.MaterialID
	WHEN MATCHED THEN 
		UPDATE SET bu.MaterialName = dbo.udf_TitleCase(input.Material),
					bu.FranchisorID = input.FranchisorID,
					bu.BevTypeID = input.BevTypeID,
					bu.BrandID = input.BrandID,
					bu.FlavorID = input.FlavorID,
					bu.PackageConfID = input.PackageConfID,
					bu.PackageTypeID = input.PackageTypeID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPMaterialID, MaterialName, FranchisorID, BevTypeID, BrandID, FlavorID, PackageConfID, PackageTypeID)
	VALUES(input.MaterialID, dbo.udf_TitleCase(input.Material), input.FranchisorID, input.BevTypeID, input.BrandID, input.FlavorID, input.PackageConfID, input.PackageTypeID);
	--------------------------------------------

End



