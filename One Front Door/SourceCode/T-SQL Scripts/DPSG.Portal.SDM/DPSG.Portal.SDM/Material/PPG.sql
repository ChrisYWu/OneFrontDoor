USE [Portal_Data]
GO

CREATE TABLE [SAP].[PromoProductGroup](
	[PPGID] [int] IDENTITY(1,1) NOT NULL,
	[SAPPPGID] [varchar](10) NOT NULL,
	[PPGName] [varchar](100) NOT NULL,
	[ChangeTrackNumber] [int] NULL,
	[LastModified] [smalldatetime] NULL,
 CONSTRAINT [PK_PromoProductGroup] PRIMARY KEY CLUSTERED 
(
	[PPGID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/* Add new column to SAP.Material */
ALTER TABLE SAP.Material
ADD PPGID Int NULL,
CONSTRAINT FK_Material_PromoProductGroup FOREIGN KEY (PPGID) REFERENCES SAP.PromoProductGroup(PPGID);

Go

DROP TABLE [Staging].[MaterialBrandPKG]
GO

CREATE TABLE [Staging].[MaterialBrandPKG](
	[MaterialID] [nvarchar](50) NULL,
	[Material] [nvarchar](500) NULL,
	[FranchisorID] [nvarchar](50) NULL,
	[Franchisor] [nvarchar](100) NULL,
	[BevTypeID] [nvarchar](50) NULL,
	[BevType] [nvarchar](200) NULL,
	[TrademarkID] [nvarchar](50) NULL,
	[Trademark] [nvarchar](100) NULL,
	[BrandID] [nvarchar](50) NULL,
	[Brand] [nvarchar](500) NULL,
	[FlavorID] [nvarchar](50) NULL,
	[Flavor] [nvarchar](500) NULL,
	[PackTypeID] [nvarchar](50) NULL,
	[PackType] [nvarchar](500) NULL,
	[PackConfID] [nvarchar](50) NULL,
	[PackConf] [nvarchar](1000) NULL,
	[CalorieClassID] [nvarchar](50) NULL,
	[CaffeineClaim] [nvarchar](50) NULL,
	[InternalCategoryID] [nvarchar](50) NULL,
	[PPGID] [nvarchar](50) NULL,
	[PPGName] [nvarchar](100) NULL
) ON [PRIMARY]
GO


--------------------------------
ALTER PROCEDURE [ETL].[pNormalizeMaterial] 
AS
BEGIN
	/*
	ETL Scheduling Sequence
	1. ETL.pNormalizeMaterial
	2. ETL.pNomalizeLocations
	3. ETL.pNormalizeChains
	4. ETL.pLoadFromRM
	5. ETL.pLoadUserProfile
	6. ETL.pAssociateBranchMaterial
	7. ETL.pAssociateRMPerson
	7. ETL.pLoadMaterial
	8. ETL.pDViews

	*/
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
	---- Franchisor ----------------------------
	Declare @sapfran Table
	(
		FranchisorID int,
		SAPFranchisorID varchar(50),
		FranchisorName varchar(128),
		ChangeTrackNumber int
	)
	Insert Into @sapfran(FranchisorID, SAPFranchisorID, FranchisorName, ChangeTrackNumber)
	Select FranchisorID, SAPFranchisorID, FranchisorName, ChangeTrackNumber
	From SAP.Franchisor

	MERGE @sapfran AS pc
		USING (	Select distinct FranchisorID, Franchisor
				From Staging.MaterialBrandPKG) AS input
			ON pc.SAPFranchisorID = input.FranchisorID
	WHEN MATCHED THEN 
		UPDATE SET pc.FranchisorName = dbo.udf_TitleCase(input.Franchisor)
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPFranchisorID, FranchisorName)
	VALUES(input.FranchisorID, dbo.udf_TitleCase(input.Franchisor));

	Update @sapfran Set ChangeTrackNumber = CheckSum(SAPFranchisorID, FranchisorName)

	MERGE SAP.Franchisor AS pc
		USING (	Select FranchisorID, SAPFranchisorID, FranchisorName, ChangeTrackNumber From @sapfran) AS input
			ON pc.FranchisorID = input.FranchisorID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPFranchisorID, FranchisorName, ChangeTrackNumber, LastModified)
	VALUES(input.SAPFranchisorID, input.FranchisorName, input.ChangeTrackNumber, GetDate());

	Update sdm
	Set SAPFranchisorID = sap.SAPFranchisorID, FranchisorName = sap.FranchisorName, ChangeTrackNumber = sap.ChangeTrackNumber, LastModified = GetDate()
	From @sapfran sap
	Join SAP.Franchisor sdm on sap.FranchisorID = sdm.FranchisorID and sap.ChangeTrackNumber != isnull(sdm.ChangeTrackNumber, 0)

	--------------------------------------------

	--------------------------------------------
	---- PackageType ---------------------------
	Declare @sappack Table
	(
		[PackageTypeID] [int] ,
		[SAPPackageTypeID] [varchar](50) NOT NULL,
		[PackageTypeName] [varchar](128) NOT NULL,
		[ChangeTrackNumber] [int] NULL
	)
	Insert Into @sappack(PackageTypeID, SAPPackageTypeID, PackageTypeName, ChangeTrackNumber)
	Select PackageTypeID, SAPPackageTypeID, PackageTypeName, ChangeTrackNumber
	From SAP.PackageType

	MERGE @sappack AS pc
		USING (Select Distinct PackTypeID, PackType
			   From Staging.MaterialBrandPKG Where PackTypeID != '') AS input
			ON pc.SAPPackageTypeID = input.PackTypeID
	WHEN MATCHED THEN 
		UPDATE SET pc.PackageTypeName = dbo.udf_TitleCase(input.PackType)
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPPackageTypeID, PackageTypeName)
	VALUES(input.PackTypeID, dbo.udf_TitleCase(input.PackType));

	Update @sappack Set ChangeTrackNumber = Checksum(SAPPackageTypeID, PackageTypeName)

	MERGE SAP.PackageType AS pc
	USING (Select PackageTypeID, SAPPackageTypeID, PackageTypeName, ChangeTrackNumber
			   From @sappack) AS input
			ON pc.PackageTypeID = input.PackageTypeID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPPackageTypeID, PackageTypeName, ChangeTrackNumber, LastModified)
	VALUES(input.SAPPackageTypeID, input.PackageTypeName, input.ChangeTrackNumber, GetDate());

	Update sdm
	Set SAPPackageTypeID = sap.SAPPackageTypeID, PackageTypeName = sap.PackageTypeName, ChangeTrackNumber = sap.ChangeTrackNumber, LastModified = GetDate()
	From @sappack sap
	Join SAP.PackageType sdm on sap.PackageTypeID = sdm.PackageTypeID and sap.ChangeTrackNumber != isnull(sdm.ChangeTrackNumber, 0)
	--------------------------------------------

	--------------------------------------------
	---- PackageConf -----------------------------
	Declare @sapConf Table  
	(
		PackageConfID int,
		SAPPackageConfID varchar(50),
		PackageConfName varchar(128),
		ChangeTrackNumber int
	)

	Insert Into @sapConf(PackageConfID, SAPPackageConfID, PackageConfName, ChangeTrackNumber)
	Select PackageConfID, SAPPackageConfID, PackageConfName, ChangeTrackNumber
	From SAP.PackageConf

	MERGE @sapConf AS pc
		USING (Select Distinct PackConfID, PackConf
			   From Staging.MaterialBrandPKG Where PackConfID != '') AS input
			ON pc.SAPPackageConfID = input.PackConfID
	WHEN MATCHED THEN 
		UPDATE SET pc.PackageConfName = dbo.udf_TitleCase(input.PackConf)
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPPackageConfID, PackageConfName)
	VALUES(input.PackConfID, dbo.udf_TitleCase(input.PackConf));

	Update @sapConf Set ChangeTrackNumber = CHECKSUM(SAPPackageConfID, PackageConfName)

	MERGE SAP.PackageConf AS pc
	USING (Select PackageConfID, SAPPackageConfID, PackageConfName, ChangeTrackNumber
			   From @sapConf) AS input
			ON pc.PackageConfID = input.PackageConfID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPPackageConfID, PackageConfName, ChangeTrackNumber, LastModified)
	VALUES(input.SAPPackageConfID, input.PackageConfName, input.ChangeTrackNumber, GetDate());

	Update sdm
	Set SAPPackageConfID = sap.SAPPackageConfID, PackageConfName = sap.PackageConfName, ChangeTrackNumber = sap.ChangeTrackNumber, LastModified = GetDate()
	From @sapConf sap
	Join SAP.PackageConf sdm on sap.PackageConfID = sdm.PackageConfID and sap.ChangeTrackNumber != isnull(sdm.ChangeTrackNumber, 0)

	--------------------------------------------

	--------------------------------------------
	---- BevType ---------------------------
	Declare @sapbt Table
	(
		BevTypeID int,
		SAPBevTypeID varchar(50),
		BevTypeName varchar(128),
		ChangeTrackNumber int		
	)
	Insert @sapbt(BevTypeID, SAPBevTypeID, BevTypeName, ChangeTrackNumber)
	Select BevTypeID, SAPBevTypeID, BevTypeName, ChangeTrackNumber
	From SAP.BevType

	MERGE @sapbt AS pc
		USING (Select Distinct BevTypeID, BevType
			   From Staging.MaterialBrandPKG) AS input
			ON pc.SAPBevTypeID = input.BevTypeID
	WHEN MATCHED THEN 
		UPDATE SET pc.BevTypeName = dbo.udf_TitleCase(input.BevType)
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPBevTypeID, BevTypeName)
	VALUES(input.BevTypeID, dbo.udf_TitleCase(input.BevType));

	Update @sapbt
	Set BevTypeName = 'Applesauce - MS'
	Where BevTypeName = 'Applesauce - Ms';

	Update @sapbt
	Set BevTypeName = 'Applesauce - SS'
	Where BevTypeName = 'Applesauce - SS';
	
	Update @sapbt Set ChangeTrackNumber = CHECKSUM(SAPBevTypeID, BevTypeName)

	MERGE SAP.BevType AS pc
	USING (Select BevTypeID, SAPBevTypeID, BevTypeName, ChangeTrackNumber
			   From @sapbt) AS input
			ON pc.BevTypeID = input.BevTypeID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPBevTypeID, BevTypeName, ChangeTrackNumber, LastModified)
	VALUES(input.SAPBevTypeID, input.BevTypeName, input.ChangeTrackNumber, GetDate());

	Update sdm
	Set SAPBevTypeID = sap.SAPBevTypeID, BevTypeName = sap.BevTypeName, ChangeTrackNumber = sap.ChangeTrackNumber, LastModified = GetDate()
	From @sapbt sap
	Join SAP.BevType sdm on sap.BevTypeID = sdm.BevTypeID and sap.ChangeTrackNumber != isnull(sdm.ChangeTrackNumber, 0)
	--------------------------------------------
			 
	--------------------------------------------
	---- TradeMark ---------------------------
	declare @saptm Table
	(
		TradeMarkID int,
		SAPTradeMarkID varchar(50),
		TradeMarkName nvarchar(128),
		ChangeTrackNumber int
	)

	Insert @saptm(TradeMarkID, SAPTradeMarkID, TradeMarkName, ChangeTrackNumber)
	SElect TradeMarkID, SAPTradeMarkID, TradeMarkName, ChangeTrackNumber
	From SAP.TradeMark

	MERGE @saptm AS pc
		USING (Select Distinct TradeMarkID, TradeMark
			   From Staging.MaterialBrandPKG
			   Where Not(((TradeMarkID = 'C25' And BrandId = 'C44') Or (TradeMarkID = 'D06') Or (TradeMarkID = 'R07' And BrandId = 'N07')))) AS input
			ON pc.SAPTradeMarkID = input.TradeMarkID
	WHEN MATCHED THEN 
		UPDATE SET pc.TradeMarkName = dbo.udf_TitleCase(input.TradeMark)
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPTradeMarkID, TradeMarkName)
	VALUES(input.TradeMarkID, dbo.udf_TitleCase(input.TradeMark));

	Update @saptm
	Set TradeMarkName = '7UP'
	Where TradeMarkName = '7up';
	Update @saptm Set ChangeTrackNumber = CHECKSUM(SAPTradeMarkID, TradeMarkName)

	MERGE SAP.TradeMark AS pc
	USING (Select TradeMarkID, SAPTradeMarkID, TradeMarkName, ChangeTrackNumber From @saptm) AS input
			ON pc.TradeMarkID = input.TradeMarkID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPTradeMarkID, TradeMarkName, ChangeTrackNumber, LastModified)
	VALUES(input.SAPTradeMarkID, input.TradeMarkName, input.ChangeTrackNumber, GetDate());

	Update sdm
	Set SAPTradeMarkID = sap.SAPTradeMarkID, TradeMarkName = sap.TradeMarkName, ChangeTrackNumber = sap.ChangeTrackNumber, LastModified = GetDate()
	From @saptm sap
	Join SAP.TradeMark sdm on sap.TradeMarkID = sdm.TradeMarkID and sap.ChangeTrackNumber != isnull(sdm.ChangeTrackNumber, 0)

	------------------------------------------
	---- Brand -------------------------------
	Declare @sapbrd Table
	(
		BrandID int,
		SAPBrandID varchar(50),
		BrandName varchar(128),
		TradeMarkID int,
		ChangeTrackNumber int
	)
	Insert @sapbrd(BrandID, SAPBrandID, BrandName, TradeMarkID, ChangeTrackNumber)
	Select BrandID, SAPBrandID, BrandName, TradeMarkID, ChangeTrackNumber
	From SAP.Brand

	MERGE @sapbrd AS pc
		USING (Select t.TradeMarkID, mbp.BrandID, mbp.Brand
				From (Select Distinct TradeMarkID, BrandID, Brand
						From Staging.MaterialBrandPKG) mbp 
					Join SAP.Trademark t on mbp.TradeMarkID = t.SAPTradeMarkID
					Where Not ((t.SAPTrademarkID = 'C25' and mbp.BrandID = 'C44')
						or (t.SAPTrademarkID = 'C41' and mbp.BrandID = 'C80')
						or (t.SAPTrademarkID = 'R07' and mbp.BrandID = 'N07')
					)) input				
			ON pc.SAPBrandID = input.BrandID
	WHEN MATCHED THEN 
		UPDATE SET pc.BrandName = dbo.udf_TitleCase(input.Brand),
					pc.TradeMarkID = input.TradeMarkID
	WHEN NOT MATCHED By Target THEN
		INSERT(TradeMarkID, SAPBrandID, BrandName)
	VALUES(input.TradeMarkID, input.BrandID, dbo.udf_TitleCase(input.Brand));

	Update @sapbrd
	Set BrandName = '7UP'
	Where BrandName = '7up';

	Update @sapbrd SEt ChangeTrackNumber = CHECKSUM(SAPBrandID, BrandName, TradeMarkID)

	MERGE SAP.Brand AS pc
	USING (Select BrandID, SAPBrandID, BrandName, TradeMarkID, ChangeTrackNumber From @sapbrd) AS input
			ON pc.BrandID = input.BrandID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPBrandID, BrandName, TradeMarkID, ChangeTrackNumber, LastModified)
	VALUES(input.SAPBrandID, input.BrandName, input.TradeMarkID, input.ChangeTrackNumber, GetDate());

	Update sdm
	Set SAPBrandID = sap.SAPBrandID, BrandName = sap.BrandName, TradeMarkID = sap.TradeMarkID, ChangeTrackNumber = sap.ChangeTrackNumber, LastModified = GetDate()
	From @sapbrd sap
	Join SAP.Brand sdm on sap.BrandID = sdm.BrandID and sap.ChangeTrackNumber != isnull(sdm.ChangeTrackNumber, 0)

	--------------------------------------------

	------------------------------------------
	---- Flavor ------------------------------
	Declare @sapfv Table
	(
		FlavorID int,
		SAPFlavorID varchar(50),
		FlavorName varchar(50),
		ChangeTrackNumber int
	)
	Insert @sapfv(FlavorID, SAPFlavorID, FlavorName, ChangeTrackNumber)
	Select FlavorID, SAPFlavorID, FlavorName, ChangeTrackNumber
	From SAP.Flavor

	MERGE @sapfv AS pc
		USING (Select Distinct FlavorID, Flavor
			   From Staging.MaterialBrandPKG Where FlavorID != '') AS input
			ON pc.SAPFlavorID = input.FlavorID
	WHEN MATCHED THEN 
		UPDATE SET pc.FlavorName = dbo.udf_TitleCase(input.Flavor)
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPFlavorID, FlavorName)
	VALUES(input.FlavorID, dbo.udf_TitleCase(input.Flavor));
	
	Update @sapfv SEt ChangeTrackNumber = CHECKSUM(SAPFlavorID, FlavorName)

	MERGE SAP.Flavor AS pc
	USING @sapfv AS input
			ON pc.FlavorID = input.FlavorID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPFlavorID, FlavorName, ChangeTrackNumber, LastModified)
	VALUES(input.SAPFlavorID, input.FlavorName, input.ChangeTrackNumber, GetDate());

	Update sdm
	Set SAPFlavorID = sap.SAPFlavorID, FlavorName = sap.FlavorName, ChangeTrackNumber = sap.ChangeTrackNumber, LastModified = GetDate()
	From @sapfv sap
	Join SAP.Flavor sdm on sap.FlavorID = sdm.FlavorID and sap.ChangeTrackNumber != isnull(sdm.ChangeTrackNumber, 0)
	--------------------------------------------
	
	------------------------------------------
	---- Promo Product Group PPG  (Written Muralidhar Busa on 9/26/2013)------------------------------
	Declare @sapPPG Table
	(
		PPGID int,
		SAPPPGID varchar(50),
		PPGName varchar(100),
		ChangeTrackNumber int
	)
	Insert @sapPPG(PPGID, SAPPPGID, PPGName, ChangeTrackNumber)
	Select PPGID, SAPPPGID, PPGName, ChangeTrackNumber
	From SAP.PromoProductGroup

	MERGE @sapPPG AS pc
	USING (Select Distinct PPGID, PPGName
			From Staging.MaterialBrandPKG Where PPGID is not Null And PPGID != '') AS input
		ON pc.SAPPPGID = input.PPGID
	WHEN MATCHED THEN 
		UPDATE SET pc.PPGName = dbo.udf_TitleCase(input.PPGName)
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPPPGID, PPGName)
		VALUES(input.PPGID, dbo.udf_TitleCase(input.PPGName));
	
	Update @sapPPG Set ChangeTrackNumber = CHECKSUM(SAPPPGID, PPGName)

	MERGE SAP.PromoProductGroup AS pc
	USING @sapPPG AS input
		ON pc.PPGID = input.PPGID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPPPGID, PPGName, ChangeTrackNumber, LastModified)
		VALUES(input.SAPPPGID, input.PPGName, input.ChangeTrackNumber, GetDate());

	Update sdm Set SAPPPGID = sap.SAPPPGID, PPGName = sap.PPGName, ChangeTrackNumber = sap.ChangeTrackNumber,					LastModified = GetDate()
	From @sapPPG sap
		Join SAP.PromoProductGroup sdm on sap.PPGID = sdm.PPGID and sap.ChangeTrackNumber != isnull (sdm.ChangeTrackNumber, 0)
	
	--------------------------------------------


End
Go

ALTER PROCEDURE [ETL].[pLoadMaterial] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--------------------------------------------
	---- Material ------------------------------
	MERGE SAP.Material AS bu
		USING (Select Distinct MaterialID, Material, f.FranchisorID, bt.BevTypeID, t.TradeMarkID, 
					b.BrandID, fl.FlavorID, p.PackageID, ic.InternalCategoryID, cc.CalorieClassID, cd.CaffeineClaimID, PPG.PPGID
			   From Staging.MaterialBrandPKG mbp
					Left Join SAP.Franchisor f on mbp.FranchisorID = f.SAPFranchisorID
					Left Join SAP.BevType bt on mbp.BevTypeID = bt.SAPBevTypeID
					Left Join SAP.TradeMark t on mbp.TrademarkID = t.SAPTrademarkID
					Left Join SAP.Brand b on mbp.BrandID = b.SAPBrandID
					Left Join SAP.Flavor fl on mbp.FlavorID = fl.SAPFlavorID
					Left Join SAP.Package p on Rtrim(mbp.PackTypeID) + Rtrim(mbp.PackConfID) = p.RMPackageID
					Left Join SAP.InternalCategory ic on ic.SAPInternalCategoryID = mbp.InternalCategoryID
					Left Join SAP.CalorieClass cc on cc.SAPCalorieClassID = mbp.CalorieClassID
					Left Join SAP.CaffeineClaim cd on cd.SAPCaffeineClaimID = mbp.CaffeineClaim
					Left Join SAP.PromoProductGroup PPG on PPG.SAPPPGID = mbp.PPGID		--PPGID modification By Muralidhar Busa
					) AS input
			ON bu.SAPMaterialID = Case When Isnumeric(input.MaterialID) = 1 Then Convert(varchar(50), CONVERT(int, input.MaterialID)) Else input.MaterialID End
	WHEN MATCHED THEN 
		UPDATE SET bu.MaterialName = dbo.udf_TitleCase(input.Material),
					bu.FranchisorID = input.FranchisorID,
					bu.BevTypeID = input.BevTypeID,
					bu.BrandID = input.BrandID,
					bu.FlavorID = input.FlavorID,
					bu.PackageID = input.PackageID,
					bu.CalorieClassID = input.CalorieClassID,
					bu.InternalCategoryID = input.InternalCategoryID,
					bu.CaffeineClaimID = input.CaffeineClaimID,
					bu.PPGID = input.PPGID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPMaterialID, MaterialName, FranchisorID, BevTypeID, BrandID, FlavorID, PackageID, CalorieClassID, InternalCategoryID, CaffeineClaimID, PPGID)
	VALUES(Case When Isnumeric(input.MaterialID) = 1 Then Convert(varchar(50), CONVERT(int, input.MaterialID)) Else input.MaterialID End, dbo.udf_TitleCase(input.Material), input.FranchisorID, input.BevTypeID, input.BrandID, input.FlavorID, PackageID, input.CalorieClassID, input.InternalCategoryID, input.CaffeineClaimID, PPGID);
	
	Update SAP.Material Set ChangeTrackNumber = CHECKSUM(SAPMaterialID, MaterialName, FranchisorID, BevTypeID, BrandID, FlavorID, PackageID, CalorieClassID, InternalCategoryID, CaffeineClaimID, PPGID), LastModified = GetDate()
	Where isnull(ChangeTrackNumber,0) != CHECKSUM(SAPMaterialID, MaterialName, FranchisorID, BevTypeID, BrandID, FlavorID, PackageID, CalorieClassID, InternalCategoryID, CaffeineClaimID, PPGID)
	--------------------------------------------	
End
Go
















