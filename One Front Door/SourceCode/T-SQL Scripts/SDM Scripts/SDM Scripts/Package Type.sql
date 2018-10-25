Use Portal_Data
Go

Select *
From Staging.BWAccount
-- ONly information is Customer_number, 
Where Local_Chain is not null

Select Substring(PACKAGEID, 1, 3), SUBSTRING(PACKAGEID, 4, 2), Description
From RM..ACEUSER.PACKAGE;

	--------------------------------------------
	---- Package -------------------------------
	--Load Packages into Staging
	Truncate Table Staging.RMPackage

	Insert Into Staging.RMPackage
	Select PACKAGEID, DESCRIPTION, Substring(PACKAGEID, 1, 3) SAPPackageTypeID, SUBSTRING(PACKAGEID, 4, 2) SAPPackageConfigID
	From RM..ACEUSER.PACKAGE;
	
	MERGE SAP.Package AS a
	USING (Select p.PACKAGEID, pt.PackageTypeID, pc.PackageConfID, 
			Replace(Replace(dbo.udf_TitleCase(p.Description), 'Oz', 'OZ'), 'Ls', 'LS') PackageName
			,0 Active
			,Replace(Replace(dbo.udf_TitleCase(p.Description), 'Oz', 'OZ'), 'Ls', 'LS') SPPackageName 
		From Staging.RMPackage p
			Left Join SAP.PackageType pt on p.SAPPackageTypeID = pt.SAPPackageTypeID
			Left Join SAP.PackageConf pc on p.SAPPackageConfigID = pc.SAPPackageConfID
		  ) AS input
		ON a.RMPackageID = input.PACKAGEID
	WHEN MATCHED THEN 
		UPDATE SET PackageTypeID = input.PackageTypeID,
					PackageConfID = input.PackageConfID,
					PackageName = input.PackageName
	WHEN NOT MATCHED By Source THEN
		UPDATE SET Active = 0
	WHEN NOT MATCHED By Target THEN
		INSERT ([RMPackageID]
           ,[PackageTypeID]
           ,[PackageConfID]
           ,[PackageName]
           ,Active
           ,[SPPackageName])
		 VALUES
			   (PACKAGEID
			   ,PackageTypeID
			   ,PackageConfID
			   ,[PackageName]
			   ,Active
			   ,[SPPackageName]);
			   
	--------------------------------------------------
	
	Select



Select *
From SAP.PackageType
Where SAPPackageTypeID not in 
(Select SAPPackageTypeID From Staging.RMPackage)

Delete From SAP.PackageType Where SAPPackageTypeID = '#'

USE [Portal_Data]
GO

INSERT INTO [SAP].[Package]
           ([RMPackageID]
           ,[PackageTypeID]
           ,[PackageConfID]
           ,[PackageName]
           ,Active
           ,[SPPackageName])
Select p.PACKAGEID, pt.PackageTypeID, pc.PackageConfID, 
	Replace(Replace(dbo.udf_TitleCase(p.Description), 'Oz', 'OZ'), 'Ls', 'LS') 
	,0
	,Replace(Replace(dbo.udf_TitleCase(p.Description), 'Oz', 'OZ'), 'Ls', 'LS') 
From Staging.RMPackage p
	Left Join SAP.PackageType pt on p.SAPPackageTypeID = pt.SAPPackageTypeID
	Left Join SAP.PackageConf pc on p.SAPPackageConfigID = pc.SAPPackageConfID

GO


Select pt.PackageTypeID, pc.PackageConfID, p.Description 
From Staging.RMPackage p
	Join SAP.PackageType pt on p.SAPPackageTypeID = pt.SAPPackageTypeID
	Join SAP.PackageConf pc on p.SAPPackageConfigID = pc.SAPPackageConfID

