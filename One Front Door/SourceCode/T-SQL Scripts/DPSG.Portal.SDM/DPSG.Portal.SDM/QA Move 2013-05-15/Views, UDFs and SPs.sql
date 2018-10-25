USE [Portal_Data]
GO
/****** Object:  View [MView].[BranchRoute]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP VIEW [MView].[BranchRoute]
GO
/****** Object:  View [MView].[BevBrandPack]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP VIEW [MView].[BevBrandPack]
GO
/****** Object:  View [MSTR].[ViewOFDDailyMetrics]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP VIEW [MSTR].[ViewOFDDailyMetrics]
GO
/****** Object:  View [MSTR].[ViewGeoAccount]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP VIEW [MSTR].[ViewGeoAccount]
GO
/****** Object:  View [MSTR].[UserInBranchExtended]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP VIEW [MSTR].[UserInBranchExtended]
GO
/****** Object:  View [PlayBook].[PromotionBrandView]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP VIEW [PlayBook].[PromotionBrandView]
GO
/****** Object:  View [PlayBook].[PromotionAttachmentView]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP VIEW [PlayBook].[PromotionAttachmentView]
GO
/****** Object:  View [MView].[BranchBrandCategory]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP VIEW [MView].[BranchBrandCategory]
GO
/****** Object:  View [MSTR].[VMyDayComparsionAccounts]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP VIEW [MSTR].[VMyDayComparsionAccounts]
GO
/****** Object:  View [MSTR].[VChannelsForComparison]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP VIEW [MSTR].[VChannelsForComparison]
GO
/****** Object:  View [SAP].[BranchPackages]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP VIEW [SAP].[BranchPackages]
GO
/****** Object:  View [SAP].[BrachLocalChain]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP VIEW [SAP].[BrachLocalChain]
GO
/****** Object:  View [MView].[AccountRouteSchedule]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP VIEW [MView].[AccountRouteSchedule]
GO
/****** Object:  UserDefinedFunction [MView].[udfGetAllAccoutsForRouteNumber]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP FUNCTION [MView].[udfGetAllAccoutsForRouteNumber]
GO
/****** Object:  View [MView].[ChannelHier]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP VIEW [MView].[ChannelHier]
GO
/****** Object:  View [SAP].[BUPackages]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP VIEW [SAP].[BUPackages]
GO
/****** Object:  View [SAP].[AreaPackages]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP VIEW [SAP].[AreaPackages]
GO
/****** Object:  View [SAP].[TrademarkPackage]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP VIEW [SAP].[TrademarkPackage]
GO
/****** Object:  View [MView].[BranchBrand]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP VIEW [MView].[BranchBrand]
GO
/****** Object:  View [MView].[AccountActiveRouteSchedule]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP VIEW [MView].[AccountActiveRouteSchedule]
GO
/****** Object:  View [MView].[LocationChannel]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP VIEW [MView].[LocationChannel]
GO
/****** Object:  View [MView].[LocationChain]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP VIEW [MView].[LocationChain]
GO
/****** Object:  View [MView].[ChainHier]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP VIEW [MView].[ChainHier]
GO
/****** Object:  View [MView].[BranchPackage]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP VIEW [MView].[BranchPackage]
GO
/****** Object:  View [MView].[BrandHier]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP VIEW [MView].[BrandHier]
GO
/****** Object:  View [MView].[PersonalRoleLocation]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP VIEW [MView].[PersonalRoleLocation]
GO
/****** Object:  View [MView].[LocationHier]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP VIEW [MView].[LocationHier]
GO
/****** Object:  UserDefinedFunction [dbo].[udf_TitleCase]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP FUNCTION [dbo].[udf_TitleCase]
GO
/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP FUNCTION [dbo].[Split]
GO
/****** Object:  StoredProcedure [PlayBook].[pUpdatePromotionRankByID]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP PROCEDURE [PlayBook].[pUpdatePromotionRankByID]
GO
/****** Object:  StoredProcedure [PlayBook].[pInsertUpdatePromotion_Test]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP PROCEDURE [PlayBook].[pInsertUpdatePromotion_Test]
GO
/****** Object:  StoredProcedure [PlayBook].[pInsertUpdatePromotion]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP PROCEDURE [PlayBook].[pInsertUpdatePromotion]
GO
/****** Object:  StoredProcedure [PlayBook].[pGetRoutePromotions]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP PROCEDURE [PlayBook].[pGetRoutePromotions]
GO
/****** Object:  StoredProcedure [PlayBook].[pGetPlayBookDetailsByDate_LocationPersonalization]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP PROCEDURE [PlayBook].[pGetPlayBookDetailsByDate_LocationPersonalization]
GO
/****** Object:  StoredProcedure [PlayBook].[pGetPlayBookDetailsByDate_LocalVersion]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP PROCEDURE [PlayBook].[pGetPlayBookDetailsByDate_LocalVersion]
GO
/****** Object:  StoredProcedure [PlayBook].[pGetPlayBookDetailsByDate]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP PROCEDURE [PlayBook].[pGetPlayBookDetailsByDate]
GO
/****** Object:  StoredProcedure [PlayBook].[pGetLatestPromotions]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP PROCEDURE [PlayBook].[pGetLatestPromotions]
GO
/****** Object:  StoredProcedure [PlayBook].[pExportPromotionToExcel]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP PROCEDURE [PlayBook].[pExportPromotionToExcel]
GO
/****** Object:  StoredProcedure [PlayBook].[P_getTimerJOBdetails]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP PROCEDURE [PlayBook].[P_getTimerJOBdetails]
GO
/****** Object:  StoredProcedure [PlayBook].[ExportPromotionToExcel]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP PROCEDURE [PlayBook].[ExportPromotionToExcel]
GO
/****** Object:  StoredProcedure [MSTR].[pUpdateHistoryFMDCustomer]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP PROCEDURE [MSTR].[pUpdateHistoryFMDCustomer]
GO
/****** Object:  StoredProcedure [MSTR].[pSpreadBranchPlan]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP PROCEDURE [MSTR].[pSpreadBranchPlan]
GO
/****** Object:  StoredProcedure [ETL].[pStageRN]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP PROCEDURE [ETL].[pStageRN]
GO
/****** Object:  StoredProcedure [ETL].[pStageRM]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP PROCEDURE [ETL].[pStageRM]
GO
/****** Object:  StoredProcedure [ETL].[pNormalizeMaterial]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP PROCEDURE [ETL].[pNormalizeMaterial]
GO
/****** Object:  StoredProcedure [ETL].[pNormalizeLocations]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP PROCEDURE [ETL].[pNormalizeLocations]
GO
/****** Object:  StoredProcedure [ETL].[pNormalizeChains]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP PROCEDURE [ETL].[pNormalizeChains]
GO
/****** Object:  StoredProcedure [ETL].[pLoadUserProfile]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP PROCEDURE [ETL].[pLoadUserProfile]
GO
/****** Object:  StoredProcedure [ETL].[pLoadMaterial]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP PROCEDURE [ETL].[pLoadMaterial]
GO
/****** Object:  StoredProcedure [ETL].[pLoadFromRM]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP PROCEDURE [ETL].[pLoadFromRM]
GO
/****** Object:  StoredProcedure [ETL].[pAssociateBranchMaterial]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP PROCEDURE [ETL].[pAssociateBranchMaterial]
GO
/****** Object:  StoredProcedure [ETL].[P_getDataFromEDGETOPromotionSchema]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP PROCEDURE [ETL].[P_getDataFromEDGETOPromotionSchema]
GO
/****** Object:  StoredProcedure [EDGE].[pPopulateLog]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP PROCEDURE [EDGE].[pPopulateLog]
GO
/****** Object:  StoredProcedure [EDGE].[pGetTimerJOBdetails]    Script Date: 5/17/2013 3:21:46 PM ******/
DROP PROCEDURE [EDGE].[pGetTimerJOBdetails]
GO
/****** Object:  StoredProcedure [EDGE].[pGetTimerJOBdetails]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




create Procedure
[EDGE].[pGetTimerJOBdetails]
(
 @timerjob datetime
)


as
begin
/*******************************************************************************************************************  
Description:  This procedure used to display data for TIMER JOB RELATED.  
Schema:  
--------------------------------------------------------------------------------------------------------------------  
Created By      :  Dilip Singh
Created Date    :  15-March-13
Tracker/Release :  
--------------------------------------------------------------------------------------------------------------------  
------------------------------------------------------------------------------------------------------------  
*********************************************************************************************/

create table #displaydata(ProgramNumber int null,StartDate datetime null,ItemID varchar(100) null,EndDate datetime null,
AccountName varchar(150) null,ChannelName varchar(100) null,AttachmentID varchar(120) null,FileName varchar(128) null,
PhysicalFile varbinary(max) null,BrandName varchar(2000) null)

insert into #displaydata(ProgramNumber,StartDate,ItemID,EndDate,AccountName,ChannelName,AttachmentID,FileName,PhysicalFile)

select a.ProgramNumber,a.StartDate,a.ItemID,a.EndDate,b.AccountName,c.ChannelName,d.AttachmentID,
d.FileName,d.PhysicalFile from EDGE.RPLItem a inner join [EDGE].[RPLItemAccount] b
on a.ItemID=b.ItemID
inner join [EDGE].[RPLItemChannel] c
ON  a.ItemID=c.ItemID
inner join [EDGE].[RPLAttachment] d
on a.ItemID=d.ItemID
where a.ModifiedDateUTC >=@timerjob


create table #working1 (ItemID VARCHAR(50) NOT NULL,BrandName varchar(2000) null)
insert into #working1(ItemID,BrandName)
SELECT p1.ItemID,

       stuff( (SELECT ','+BrandName 

               FROM [EDGE].RPLItemBrand p2

               WHERE p2.ItemID = p1.ItemID
              

               ORDER BY BrandName

               FOR XML PATH(''), TYPE).value('.', 'varchar(max)')

            ,1,1,'')

       AS BrandName

      FROM EDGE.RPLItem p1   where   p1.ModifiedDateUTC >=@timerjob   ---@ROUTEDATE

      GROUP BY ItemID ;

update  a
set  a.BrandName=b.BrandName
from #displaydata a inner join #working1 b
on a.ItemID=b.ItemID


select ProgramNumber,StartDate,ItemID,EndDate,AccountName,ChannelName,AttachmentID,FileName,PhysicalFile,BrandName
from #displaydata



end 


GO
/****** Object:  StoredProcedure [EDGE].[pPopulateLog]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Sumit Kanchan
-- Create date: 18/March/2013
-- Description:	This will insert the error in the error table
-- =============================================
create PROCEDURE [EDGE].[pPopulateLog]
@ErrorMessgae varchar(255),
@ErrorDate datetime,
@ContentID varchar(210),
@ErrorCode varchar(85)

AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Insert into EDGE.ErrorHandler(ErrorCode,ErrorMessgae,ErrorDate,ContentID)
	Values(@ErrorCode,@ErrorMessgae,@ErrorDate,@ContentID)

END

GO
/****** Object:  StoredProcedure [ETL].[P_getDataFromEDGETOPromotionSchema]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   
CREATE PROCEDURE [ETL].[P_getDataFromEDGETOPromotionSchema]  
  
AS  
BEGIN  
/*******************************************************************************************************************    
Description:  This procedure used to auto fill data from edge to Promtion.    
Schema:    
--------------------------------------------------------------------------------------------------------------------    
Created By      :  Dilip Singh  
Created Date    :  06-March-13  
Tracker/Release :    
--------------------------------------------------------------------------------------------------------------------    
------------------------------------------------------------------------------------------------------------    
*********************************************************************************************/  
set nocount on   
  
/*---we will used the merge statements which will check if data exist in target table the it   
will update else it will insert data.*/   
  
  
/*--in PlayBook.RetailPromotion table some columns are not proper mapped so i am taking null values*/  
  set rowcount 12


MERGE PlayBook.RetailPromotion AS TAR11  
USING (SELECT ItemID,Tittle,StartDate,EndDate,Price FROM EDGE.RPLItem)
AS SRC11 (ItemID,Tittle,StartDate,EndDate,Price)   
ON SRC11.ItemID=TAR11.EDGEItemID  
WHEN MATCHED THEN UPDATE  
 SET TAR11.PromotionName=SRC11.Tittle,TAR11.EDGEItemID=SRC11.ItemID,TAR11.PromotionStartDate=SRC11.StartDate,  
 TAR11.PromotionEndDate=SRC11.EndDate,TAR11.PromotionPrice=SRC11.Price  
WHEN NOT MATCHED BY TARGET THEN   
--INSERT VALUES (SRC11.ITEMID,SRC11.Tittle,34,SRC11.Price,NULL,NULL,NULL,NULL,SRC11.StartDate,SRC11.EndDate,null,  
INSERT VALUES (SRC11.Tittle,SRC11.Tittle,34,SRC11.Price,NULL,NULL,NULL,NULL,SRC11.StartDate,SRC11.EndDate,null,  
NULL,GETDATE(),NULL,NULL,SRC11.ItemID,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);

  

  
  
/*---for the account*/  
  
 
  
/*---for PromotionBrand-----*/  
  
--merge PlayBook.PromotionBrand as tar1  
--using (select distinct itemID,SAPBrandID,BrandName,SAPTradeMarkID from EDGE.RPLItemBrand as p  
--left join PlayBook.RetailPromotion q on p.ItemID=q.EDGEItemID )   
--as src2 (PromotionID,SAPBrandID,BrandName,ItemID)  
--on tar1.promotionid=src2.promotionid  
--when matched then update set tar1.PromotionID=src2.PromotionID,tar1.BrandID=src2.trademarkid,tar1.ItemID=src2.ItemID,tar1.BrandID=src2.SAPBrandID  
--when not matched by target then insert values(src2.PromotionID,src2.SAPBrandID,src2.BrandName,src2.ItemID);  
  
  
/*-----for packages -------*/  
  
  
  
--MERGE PlayBook.PromotionPackage as TAR3  
--USING (SELECT distinct c.ItemID,PackageName,PromotionID FROM EDGE.RPLItemPackage as c  
--left join  PlayBook.RetailPromotion  as d  on c.ItemID=d.EDGEItemID  
-- )  
--  as SRC3 (ItemID,PackageName,PromotionID)  
--on TAR3.PromotionID=SRC3.PromotionID  
-----when matched then update  
--when matched then update set  TAR3.PromotionID=SRC3.PromotionID,TAR3.Package=SRC3.PackageName,TAR3.ItemID=SRC3.ItemID  
--when not matched by target then insert values(SRC3.ItemID,SRC3.PromotionID,null,SRC3.PackageName);  
  
  
/*----for promotion attchedment*/  
  
  
  
--MERGE PlayBook.PromotionAttachment as a  
--USING (SELECT distinct AttachmentID, PromotionID,FileName  FROM EDGE.RPLAttachment as c  
--inner join PlayBook.RetailPromotion  as d     
--on c.ItemID=d.edgeItemID   
  
-- ) as b (AttachmentID,PromotionID,FileName)  
--on a.PromotionID=b.PromotionID  
-----when matched then update  
--when matched then update set a.AttachmentID=b.AttachmentID, a.PromotionID=b.PromotionID,a.PromotionAttachmentName=b.FileName  
--when not matched by target then insert values (b.AttachmentID,b.PromotionID,b.FileName);  
  
  
  
  
    
END
GO
/****** Object:  StoredProcedure [ETL].[pAssociateBranchMaterial]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [ETL].[pAssociateBranchMaterial] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	-------------------------------------------
	-------------------------------------------
	MERGE SAP.BranchMaterial AS bu
		USING (Select BranchID, MaterialID
					From Staging.RMItemMaster ai
					Join SAP.Material bt on ai.ITEM_NUMBER = bt.SAPMaterialID
					Join SAP.Branch b on Left(LOCATION_ID, 4) = b.SAPBranchID ) input
				ON bu.MaterialID = input.MaterialID
				And bu.BranchID = input.BranchID
	WHEN NOT MATCHED By Target THEN
		INSERT(MaterialID, BranchID)
		VALUES(input.MaterialID, input.BranchID)
	WHEN NOT MATCHED By Source THEN
		Delete;
End


GO
/****** Object:  StoredProcedure [ETL].[pLoadFromRM]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [ETL].[pLoadFromRM] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--------------------------------------------------------
	---Package----------------------------------------------
	Declare @sappk Table
	(
		PackageID int,
		RMPackageID varchar(10),
		PackageTypeID int,
		PackageConfID int,
		PackageName varchar(50),
		Source varchar(50),
		Active varchar(50),
		ChangeTrackNumber int
	)
	Insert @sappk
	Select PackageID, RMPackageID, PackageTypeID, PackageConfID, PackageName, Source, Active, ChangeTrackNumber 
	From SAP.Package

	MERGE @sappk AS a
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
					PackageName = input.PackageName,
					Source = 'RouteManager'
	WHEN NOT MATCHED By Source THEN
		UPDATE SET Active = 0
	WHEN NOT MATCHED By Target THEN
		INSERT ([RMPackageID]
           ,[PackageTypeID]
           ,[PackageConfID]
           ,[PackageName]
           ,Source
		   ,Active)
		 VALUES
			   (PACKAGEID
			   ,PackageTypeID
			   ,PackageConfID
			   ,[PackageName]
			   ,'RouteManager'
			   ,Active);

	MERGE @sappk AS bu
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
           ,Source)
		 VALUES
			   (PACKAGEID
			   ,PackageTypeID
			   ,PackageConfID
			   ,Case When [PackageName] = 'Not Assigned Not Assigned' Then 'Not Assigned' Else PackageName End
			   ,1
			   ,'SAPBW');

	Update @sappk Set ChangeTrackNumber = CHECKSUM(RMPackageID, PackageTypeID, PackageConfID, PackageName, Source, Active)

	MERGE SAP.Package AS pc
	USING @sappk AS input
			ON pc.PackageID = input.PackageID
	WHEN NOT MATCHED By Target THEN
		INSERT(RMPackageID, PackageTypeID, PackageConfID, PackageName, Source, Active, ChangeTrackNumber, LastModified)
	VALUES(input.RMPackageID, input.PackageTypeID, input.PackageConfID, input.PackageName, input.Source, input.Active, input.ChangeTrackNumber, GetDate());

	Update sdm
	Set RMPackageID = sap.RMPackageID, PackageTypeID = sap.PackageTypeID, PackageConfID = sap.PackageConfID, PackageName = sap.PackageName, 
		Source = sap.Source, Active = sap.Active, FriendlyName = sap.PackageName, ChangeTrackNumber = sap.ChangeTrackNumber, LastModified = GetDate()
	From @sappk sap
	Join SAP.Package sdm on sap.PackageID = sdm.PackageID and sap.ChangeTrackNumber != isnull(sdm.ChangeTrackNumber, 0)

	--------------------------------------------
	---- Account -------------------------------
	-- Merge From BW records
	MERGE SAP.Account AS a
		USING ( select CUSTOMER_NUMBER, max(CUSTOMER_NAME) CUSTOMER_NAME, max(CUSTOMER_STREET) CUSTOMER_STREET, max(CITY) CITY, max(STATE) STATE, max(POSTAL_CODE) POSTAL_CODE,
				max(CONTACT_PERSON) CONTACT_PERSON, max(PHONE_NUMBER) PHONE_NUMBER, max(BranchID) BranchID, max(ChannelID) ChannelID, max(LocalChainID) LocalChainID
				from (Select convert(bigint, CUSTOMER_NUMBER) CUSTOMER_NUMBER, CUSTOMER_NAME, CUSTOMER_STREET, CITY, STATE, POSTAL_CODE,
							CONTACT_PERSON, PHONE_NUMBER, b.BranchID, c.ChannelID, lc.LocalChainID
						From Staging.BWAccount a
							Left Join Staging.AccountDetails ad on ISNUMERIC(ad.SAPAccountNumber) = 1 And convert(bigint, a.CUSTOMER_NUMBER) = convert(bigint, ad.SAPAccountNumber)
							Left Join SAP.Branch b on b.SAPBranchID = ad.SAPBranchID
							Left Join SAP.CHANNEL c on ad.SAPChannelID = c.SAPChannelID
							Left Join SAP.LocalChain lc on Right(ad.SAPLocalChainID, 7) = lc.SAPLocalChainID
						) tmp
				group by CUSTOMER_NUMBER
			  ) AS input
	--USING (Select convert(bigint, CUSTOMER_NUMBER) CUSTOMER_NUMBER, CUSTOMER_NAME, CUSTOMER_STREET, CITY, STATE, POSTAL_CODE,
	--			CONTACT_PERSON, PHONE_NUMBER, b.BranchID, c.ChannelID, lc.LocalChainID
	--		From Staging.BWAccount a
	--			Left Join Staging.AccountDetails ad on ISNUMERIC(ad.SAPAccountNumber) = 1 And convert(bigint, a.CUSTOMER_NUMBER) = convert(bigint, ad.SAPAccountNumber)
	--			Left Join SAP.Branch b on b.SAPBranchID = ad.SAPBranchID
	--			Left Join SAP.CHANNEL c on ad.SAPChannelID = c.SAPChannelID
	--			Left Join SAP.LocalChain lc on Right(ad.SAPLocalChainID, 7) = lc.SAPLocalChainID
	--	  ) AS input
		ON a.SAPAccountNumber = input.CUSTOMER_NUMBER
	WHEN MATCHED THEN 
		UPDATE SET [AccountName] = dbo.udf_TitleCase(input.CUSTOMER_NAME)
		  ,[ChannelID] = input.ChannelID
		  ,[BranchID] = input.BranchID
		  ,[LocalChainID] = input.LocalChainID
		  ,[Address] = dbo.udf_TitleCase(input.CUSTOMER_STREET)
		  ,[City] = dbo.udf_TitleCase(input.CITY)
		  ,[State] = input.STATE
		  ,[PostalCode] = input.POSTAL_CODE
		  ,[Contact] = dbo.udf_TitleCase(input.CONTACT_PERSON)
		  ,[PhoneNumber] = input.PHONE_NUMBER
	WHEN NOT MATCHED By Target THEN
		INSERT (SAPAccountNumber
			   ,[AccountName]
			   ,[BranchID]
			   ,[Address]
			   ,[City]
			   ,[State]
			   ,[PostalCode]
			   ,[Contact]
			   ,[PhoneNumber], ChannelID, LocalChainID)
		 VALUES
			   (CUSTOMER_NUMBER
			   ,dbo.udf_TitleCase(input.CUSTOMER_NAME)
			   ,BranchID
			   ,dbo.udf_TitleCase(CUSTOMER_STREET)
			   ,dbo.udf_TitleCase(CITY)
			   ,STATE
			   ,input.POSTAL_CODE
			   ,dbo.udf_TitleCase(CONTACT_PERSON)
			   ,PHONE_NUMBER, ChannelID, LocalChainID);

	-- Merge From RM records for Active Flag Only
	MERGE SAP.Account AS a
	USING (Select convert(bigint, CUSTOMER_NUMBER) CUSTOMER_NUMBER, a.ACTIVE 
			From (Select CUSTOMER_NUMBER, Max(ACTIVE) ACTIVE
					From Staging.RMAccount 
					Group By CUSTOMER_NUMBER) a
		  ) AS input
		ON a.SAPAccountNumber = input.CUSTOMER_NUMBER
	WHEN MATCHED THEN 
		UPDATE SET ACTIVE = input.ACTIVE;

	--MERGE SAP.Account AS a
	--USING (Select convert(bigint, CUSTOMER_NUMBER) CUSTOMER_NUMBER, CUSTOMER_NAME, CUSTOMER_STREET, CITY, STATE, POSTAL_CODE, a.ACTIVE, 
	--			CONTACT_PERSON, PHONE_NUMBER, b.BranchID, c.ChannelID, lc.LocalChainID
	--		From (Select CUSTOMER_NUMBER, Max(LOCATION_ID) LOCATION_ID, Max(CONTACT_PERSON) CONTACT_PERSON, Max(LOCAL_CHAIN) LOCAL_CHAIN, Max(CHANNEL) CHANNEL,
	--					Max(CUSTOMER_NAME) CUSTOMER_NAME, Max(CUSTOMER_STREET) CUSTOMER_STREET, Max(CITY) CITY, Max(STATE) STATE, Max(POSTAL_CODE) POSTAL_CODE,
	--					Max(PHONE_NUMBER) PHONE_NUMBER, Max(ACTIVE) ACTIVE
	--				From Staging.RMAccount 
	--				Group By CUSTOMER_NUMBER) a
	--				Left Join SAP.Branch b on Left(LOCATION_ID, 4) = b.SAPBranchID
	--				Left Join SAP.CHANNEL c on a.CHANNEL = c.SAPChannelID
	--				Left Join SAP.LocalChain lc on a.LOCAL_CHAIN = lc.SAPLocalChainID
	--	  ) AS input
	--	ON a.SAPAccountNumber = input.CUSTOMER_NUMBER
	--WHEN MATCHED THEN 
	--	UPDATE SET ACTIVE = input.ACTIVE
	--	  ,[AccountName] = dbo.udf_TitleCase(input.CUSTOMER_NAME)
	--	  ,[ChannelID] = input.ChannelID
	--	  ,[BranchID] = input.BranchID
	--	  ,[LocalChainID] = input.LocalChainID
	--	  ,[Address] = dbo.udf_TitleCase(input.CUSTOMER_STREET)
	--	  ,[City] = dbo.udf_TitleCase(input.CITY)
	--	  ,[State] = input.STATE
	--	  ,[PostalCode] = input.POSTAL_CODE
	--	  ,[Contact] = dbo.udf_TitleCase(input.CONTACT_PERSON)
	--	  ,[PhoneNumber] = input.PHONE_NUMBER
	--WHEN NOT MATCHED By Target THEN
	--	INSERT (SAPAccountNumber
	--		   ,[AccountName]
	--		   ,[BranchID]
	--		   ,[Address]
	--		   ,[City]
	--		   ,[State]
	--		   ,[PostalCode]
	--		   ,[Contact]
	--		   ,[PhoneNumber]
	--		   ,ACTIVE
	--		   ,ChannelID
	--		   ,LocalChainID
	--		   )
	--	 VALUES
	--		   (CUSTOMER_NUMBER
	--		   ,dbo.udf_TitleCase(input.CUSTOMER_NAME)
	--		   ,BranchID
	--		   ,dbo.udf_TitleCase(CUSTOMER_STREET)
	--		   ,dbo.udf_TitleCase(CITY)
	--		   ,STATE
	--		   ,input.POSTAL_CODE
	--		   ,dbo.udf_TitleCase(CONTACT_PERSON)
	--		   ,PHONE_NUMBER
	--		   ,ACTIVE
	--		   ,ChannelID
	--		   ,LocalChainID);

	Update acc
	Set acc.Longitude = rnl.LONGITUDE, acc.Latitude = rnl.LATITUDE
	From (	Select AccountNumber, Min(LONGITUDE) LONGITUDE, Min(LATITUDE) LATITUDE
				From Staging.RNLocation
				Where ISNUMERIC(AccountNumber) = 1
				Group By AccountNumber) rnl
    Join SAP.Account acc on rnl.AccountNumber = acc.SAPAccountNumber

	Update SAP.Account Set ChangeTrackNumber = CHECKSUM(SAPAccountNumber, AccountName, ChannelID, BranchID, LocalChainID, 
		Address, City, State, PostalCode, Contact, PhoneNumber, Longitude, Latitude, Active), LastModified = GetDate()
	Where isnull(ChangeTrackNumber,0) != CHECKSUM(SAPAccountNumber, AccountName, ChannelID, BranchID, LocalChainID, 
		Address, City, State, PostalCode, Contact, PhoneNumber, Longitude, Latitude, Active)
			   
	--------------------------------------------------
	---- SalesRoute ----------------------------------
	MERGE SAP.SalesRoute AS r
		USING (	Select ROUTE_NUMBER, ROUTE_DESCRIPTION, ACTIVE_ROUTE, ROUTE_TYPE, LOCATION_ID, DEFAULT_EMPLOYEE, e.PersonID, b.BranchID
				From Staging.RMROUTEMASTER r
				Left Join Person.Employee e on r.DEFAULT_EMPLOYEE = e.RMEmployeeID
				Left Join SAP.Branch b on Left(LOCATION_ID, 4) = b.SAPBranchID
				Where r.Active = '1'
				And r.Route_Type = '0'
				And Active_Route = '1'
			  ) AS input
			ON r.SAPRouteNumber = input.ROUTE_NUMBER
	WHEN MATCHED THEN
		UPDATE SET SAPRouteNumber = input.ROUTE_NUMBER
		  ,[RouteName] = dbo.udf_TitleCase(input.ROUTE_DESCRIPTION)
		  ,[DefaultEmployeeID] = input.PersonID
		  ,BranchID = input.BranchID
	WHEN NOT MATCHED By Source THEN
		UPDATE SET Active = 0
	WHEN NOT MATCHED By Target THEN
		INSERT (SAPRouteNumber
			   ,[RouteName]
			   ,[DefaultEmployeeID]
			   ,BranchID
			   ,[Active])
		 VALUES
			   (input.ROUTE_NUMBER
			   ,dbo.udf_TitleCase(input.ROUTE_DESCRIPTION)
			   ,input.PersonID
			   ,input.BranchID
			   ,1);
			   
	-----------------------------------------------------
	---- RouteSchedule ----------------------------------
	MERGE SAP.RouteSchedule AS bu
		USING (Select sr.RouteID, a.AccountID, START_Date, t.Route_Number, t.Customer_Number
				From [Staging].[RMRouteSchedule] t
					-- Inner joins to take only the active routes and active customers
					Join SAP.SalesRoute sr on t.ROUTE_NUMBER = sr.SAPRouteNumber
					Join SAP.Account a on t.CUSTOMER_NUMBER = a.SAPAccountNumber) AS input
			ON bu.RouteID = input.RouteID
			And bu.AccountID = input.AccountID
	WHEN MATCHED THEN 
		UPDATE SET bu.StartDate = input.Start_Date
	WHEN NOT MATCHED By Target THEN
		INSERT(RouteID, AccountID, StartDate)
	VALUES(input.RouteID, input.AccountID, input.Start_Date)
	WHEN NOT MATCHED By Source THEN
		Delete;

	-----------------------------------------------------------
	---- RouteScheduleDetail ----------------------------------
	Truncate Table SAP.routeScheduleDetail

	Declare @dayCounter int
	Declare @indexStarter int

	Set @indexStarter = 0
	Set @dayCounter = 0
	While @dayCounter < 28
		Begin
			Set @indexStarter = 3*@dayCounter + 1
			Insert Into SAP.RouteScheduleDetail(RouteScheduleID, Day, SequenceNumber)
			Select saprs.RouteScheduleID, @dayCounter, Convert(int, substring(SEQUENCE_NUMBER, @indexStarter, 3)) AS SEQUENCE_NUMBER
			From [Staging].[RMRouteSchedule] t
				Join SAP.SalesRoute sr on t.ROUTE_NUMBER = sr.SAPRouteNumber
				Join SAP.Account a on t.CUSTOMER_NUMBER = a.SAPAccountNumber
				Join SAP.RouteSchedule saprs on saprs.AccountID = a.AccountID and saprs.RouteID = sr.RouteID
			Where Convert(int, substring(SEQUENCE_NUMBER, @indexStarter, 3)) > 0;
			
			Set @dayCounter = @dayCounter + 1;
		End	

End


GO
/****** Object:  StoredProcedure [ETL].[pLoadMaterial]    Script Date: 5/17/2013 3:21:46 PM ******/
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
	---- Material ------------------------------
	MERGE SAP.Material AS bu
		USING (Select Distinct MaterialID, Material, f.FranchisorID, bt.BevTypeID, t.TradeMarkID, 
					b.BrandID, fl.FlavorID, p.PackageID, ic.InternalCategoryID, cc.CalorieClassID, cd.CaffeineClaimID
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
					bu.CaffeineClaimID = input.CaffeineClaimID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPMaterialID, MaterialName, FranchisorID, BevTypeID, BrandID, FlavorID, PackageID, CalorieClassID, InternalCategoryID, CaffeineClaimID)
	VALUES(Case When Isnumeric(input.MaterialID) = 1 Then Convert(varchar(50), CONVERT(int, input.MaterialID)) Else input.MaterialID End, dbo.udf_TitleCase(input.Material), input.FranchisorID, input.BevTypeID, input.BrandID, input.FlavorID, PackageID, input.CalorieClassID, input.InternalCategoryID, input.CaffeineClaimID);
	
	Update SAP.Material Set ChangeTrackNumber = CHECKSUM(SAPMaterialID, MaterialName, FranchisorID, BevTypeID, BrandID, FlavorID, PackageID, CalorieClassID, InternalCategoryID, CaffeineClaimID), LastModified = GetDate()
	Where isnull(ChangeTrackNumber,0) != CHECKSUM(SAPMaterialID, MaterialName, FranchisorID, BevTypeID, BrandID, FlavorID, PackageID, CalorieClassID, InternalCategoryID, CaffeineClaimID)

	--------------------------------------------

End




GO
/****** Object:  StoredProcedure [ETL].[pLoadUserProfile]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ETL].[pLoadUserProfile] 
AS
BEGIN

	
	--------------------------------------------
	---User Profile ----------------------------
	MERGE Person.UserProfile AS up
		USING ( Select hr.UserID, hr.FirstName, hr.LastName, hr.EmpID, cc.CostCenterID, pc.ProfitCenterID, b.BranchID, a.RegionID, bu.BUID, hr.JobCode
				From [Staging].[ADExtractData] hr
				left outer join Person.userprofile up1 on hr.userid = up1.gsn
				Join SAP.CostCenter cc on cc.SAPCostCenterID = substring(hr.CostCenter, patindex('%[^0]%',hr.CostCenter), 10)  
				Join SAP.ProfitCenter pc on pc.ProfitCenterID = cc.ProfitCenterID
				Join SAP.Branch b on pc.BranchId = b.BranchID
				Join SAP.Region a on a.RegionID = b.RegionID
				Join SAP.BusinessUnit bu on bu.BUID = a.BUID
				where IsNull(up1.ManualSetup, 0) = 0 ) AS input
					ON up.GSN = input.UserID
	WHEN MATCHED THEN
		UPDATE SET up.BUID = input.BUID,
					up.AreaID = input.RegionID,
					up.PrimaryBranchID = input.BranchID,
					up.ProfitCenterID = input.ProfitCenterID,
					up.CostCenterID = input.CostCenterID,
					up.FirstName = input.FirstName,
					up.LastName = input.LastName,
					up.EmpID = input.EmpID,		
					up.JobCode = input.JobCode
	WHEN NOT MATCHED By Target THEN
		INSERT(GSN, BUID, AreaID, PrimaryBranchID, ProfitCenterID, CostCenterID, FirstName, LastName, EmpID, JobCode, ManualSetup)
		VALUES(input.UserID, input.BUID, input.RegionID, input.BranchID, input.ProfitCenterID, input.CostCenterID, input.FirstName, input.LastName, input.EmpID, input.JobCode, 0);
	
	--------------------------------------------
	---SP User Profile -------------------------
	MERGE Person.SPUserProfile AS sup
		USING ( Select hr.UserID, hr.FirstName, hr.LastName, hr.EmpID, cc.CostCenterID, pc.ProfitCenterID, 
						b.BranchID, a.RegionID, bu.BUID, hr.Title, b.BranchName, a.RegionName, BU.BUName,
						b.SAPBranchID, a.SAPRegionID, bu.SAPBUID,
						role.RoleID, role.RoleName
				From [Staging].[ADExtractData] hr
				Join SAP.CostCenter cc on cc.SAPCostCenterID = substring(hr.CostCenter, patindex('%[^0]%',hr.CostCenter), 10)  
				Join SAP.ProfitCenter pc on pc.ProfitCenterID = cc.ProfitCenterID
				Join SAP.Branch b on pc.BranchId = b.BranchID
				Join SAP.Region a on a.RegionID = b.RegionID
				Join SAP.BusinessUnit bu on bu.BUID = a.BUID
				left outer join Person.userprofile up1 on hr.userid = up1.gsn
				Left Outer join Person.Job job on job.SAPHRJobNumber = hr.JobCode
				Left Outer join Person.Role role on role.RoleID = job.RoleID
				where IsNull(up1.ManualSetup, 0) = 0 ) AS input
					ON sup.GSN = input.UserID
	WHEN MATCHED 
		and (sup.PrimaryBranch <> '{"AreaId":,"AreaName":"","BUId":' + convert(varchar, input.BUID) + ',"BUName":"' + input.BUName + '","BranchId":' + convert(varchar, input.BranchID) + ',"BranchName":"'+ input.BranchName +'"}'
		or sup.RoleID <> input.RoleID)
		THEN
		UPDATE SET sup.GSN = input.UserID,
					--{"AreaId":9,"AreaName":"Northwest","BUId":11,"BUName":"Pacific","BranchId":116,"BranchName":"Fremont"}
					sup.PrimaryBranch = '{"AreaId":,"AreaName":"","BUId":' + convert(varchar, input.BUID) + ',"BUName":"' + input.BUName + '","BranchId":' + convert(varchar, input.BranchID) + ',"BranchName":"'+ input.BranchName +'"}',
					--sup.PrimaryBranch = input.BranchName + '|SAP:'  + input.SAPBranchID + '|ID:' + '0',
					sup.PrimaryRole = input.RoleName,
					--sup.PrimaryArea = input.RegionName + '|SAP:' + input.SAPRegionID + '|ID:' + '0',
					--sup.PrimaryBU = input.BUName + '|SAP:' + input.SAPBUID + '|ID:' + '0',
					sup.RoleID = input.RoleID,
					sup.updatedinsp = 0
	WHEN NOT MATCHED By Target THEN
		INSERT(GSN, PrimaryBranch, PrimaryRole, RoleID)
	VALUES(	input.UserID, '{"AreaId":,"AreaName":"","BUId":' + convert(varchar, input.BUID)+ ',"BUName":"' + input.BUName + '","BranchId":' + convert(varchar, input.BranchID) + ',"BranchName":"'+ input.BranchName +'"}',
			input.RoleName, 
			 input.RoleID);


	-----SP User Profile Role-------------------------
	MERGE Person.UserInRole AS uir
		USING ( Select hr.UserID, role.RoleID, role.RoleName
				From [Staging].[ADExtractData] hr
				join Person.userprofile up1 on hr.userid = up1.gsn
				join Person.Job job on job.SAPHRJobNumber = hr.JobCode
				join Person.Role role on role.RoleID = job.RoleID
				where IsNull(up1.ManualSetup, 0) = 0) AS input
					ON uir.GSN = input.UserID and uir.IsPrimary = 1
	WHEN MATCHED THEN
		UPDATE SET uir.RoleID= input.RoleID
	WHEN NOT MATCHED By Target THEN
		INSERT(GSN, RoleID, IsPrimary)
		VALUES(	input.UserID, input.RoleId,1)
	--WHEN NOT MATCHED By Source Then
		--Delete 
		;
	


	-----User in Branch Table-------------------------
	MERGE Person.UserInBranch AS uib
		USING ( Select hr.UserID, up1.PrimaryBranchID
				From [Staging].[ADExtractData] hr
				join Person.userprofile up1 on hr.userid = up1.gsn
				where IsNull(up1.ManualSetup, 0) = 0 and not up1.PrimaryBranchId is null ) AS input
				ON uib.GSN = input.UserID and uib.IsPrimary = 1
	WHEN MATCHED THEN
		UPDATE SET uib.BranchId = input.PrimaryBranchID
	WHEN NOT MATCHED By Target THEN
		INSERT(GSN, BranchID, IsPrimary)
		VALUES(	input.UserID, input.PrimaryBranchID, 1);

End
GO
/****** Object:  StoredProcedure [ETL].[pNormalizeChains]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [ETL].[pNormalizeChains] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--------------------------------------------
    --- Channel Loading is disabled per discussion with Rajeev. 
	---- Super Channel -------------------------
	--MERGE SAP.SuperChannel AS bu
	--	USING (SELECT Distinct SuperChannelID, SuperChannel 
	--			From Staging.Channel
	--			Where SuperChannelID <> '#') AS input
	--		ON bu.SAPSuperChannelID = input.SuperChannelID
	--WHEN MATCHED THEN 
	--	UPDATE SET bu.SuperChannelName = dbo.udf_TitleCase(input.SuperChannel)
	--WHEN NOT MATCHED By Target THEN
	--	INSERT(SAPSuperChannelID, SuperChannelName)
	--VALUES(input.SuperChannelID, dbo.udf_TitleCase(input.SuperChannel));
	--GO

	--Select *
	--From SAP.SuperChannel 
	--Go

	--------------------------------------------

	-----------------------------------------------
	---Channel-------------------------------------
	--MERGE SAP.Channel AS ba
	--	USING ( SELECT Distinct ChannelID, Channel
	--			FROM Staging.Channel r
	--			Where Rtrim(Ltrim(ChannelID)) <> '#') AS input
	--		ON ba.SAPChannelID = input.ChannelID
	--WHEN MATCHED THEN
	--	UPDATE SET ba.ChannelName = dbo.udf_TitleCase(input.Channel)
	--WHEN NOT MATCHED By Target THEN
	--	INSERT(SAPChannelID, ChannelName)
	--VALUES(input.ChannelID, dbo.udf_TitleCase(input.Channel));
	--GO

	--Select *
	--From SAP.Channel
	--Go

	--Merge SAP.SuperChannelChannel scc
	--Using (Select s.SuperChannelID, c.ChannelID
	--		From Staging.Channel bw
	--		Join SAP.SuperChannel s on BW.SuperChannelID = s.SAPSuperChannelID
	--		Join SAP.Channel c on BW.ChannelID = c.SAPChannelID) as input
	--	On scc.SuperChannelID = input.SuperChannelID
	--	And scc.ChannelID = input.ChannelID
	--When Not Matched By Target Then
	--	Insert(SuperChannelID, ChannelID)
	--	Values(input.SuperChannelID, input.ChannelID)
	--When Not Matched By Source Then
	--	Delete;
	--Go

	--------------------------------------------
	---- National Chain ------------------------
	Declare @sapch Table
	(
		[NationalChainID] int,
		[SAPNationalChainID] int, 
		[NationalChainName] varchar(50),
		[ChangeTrackNumber] int
	)

	Insert Into @sapch(NationalChainID, SAPNationalChainID, NationalChainName, ChangeTrackNumber)
	Select NationalChainID, SAPNationalChainID, NationalChainName, ChangeTrackNumber From SAP.NationalChain

	MERGE @sapch AS bu
	USING (SELECT Distinct NationalChainID, NationalChain
				From Staging.Chain
				Where NationalChainID Not in ('#', '')) AS input
			ON bu.SAPNationalChainID = input.NationalChainID
	WHEN MATCHED THEN 
		UPDATE SET bu.NationalChainName = dbo.udf_TitleCase(input.NationalChain)
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPNationalChainID, NationalChainName)
	VALUES(input.NationalChainID, dbo.udf_TitleCase(input.NationalChain));

	Update @sapch Set NationalChainName = 'CVS/Pharmacy' Where NationalChainName = 'Cvs/Pharmacy'
	Update @sapch Set NationalChainName = 'Walmart US' Where NationalChainName = 'Walmart Us'
	Update @sapch Set ChangeTrackNumber = Checksum(SAPNationalChainID, NationalChainName);
	
	MERGE SAP.NationalChain AS pc
	USING (Select NationalChainID, SAPNationalChainID, NationalChainName, ChangeTrackNumber
			   From @sapch) AS input
			ON pc.NationalChainID = input.NationalChainID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPNationalChainID, NationalChainName, ChangeTrackNumber, LastModified)
	VALUES(input.SAPNationalChainID, input.NationalChainName, input.ChangeTrackNumber, GetDate());

	Update sdm
	Set SAPNationalChainID = sap.SAPNationalChainID, NationalChainName = sap.NationalChainName, ChangeTrackNumber = sap.ChangeTrackNumber, LastModified = GetDate()
	From @sapch sap
	Join SAP.NationalChain sdm on sap.NationalChainID = sdm.NationalChainID and sap.ChangeTrackNumber != isnull(sdm.ChangeTrackNumber, 0)

	--------------------------------------------
	---- Regional Chain ------------------------
	Declare @saprc Table
	(
		[RegionalChainID] int,
		[SAPRegionalChainID] int, 
		[RegionalChainName] varchar(50),
		[NationalChainID] int,
		[ChangeTrackNumber] int
	)
	Insert @saprc
	Select [RegionalChainID], [SAPRegionalChainID], [RegionalChainName], [NationalChainID], ChangeTrackNumber
	From SAP.RegionalChain 

	MERGE @saprc AS bu
		USING ( Select nc.NationalChainID, RegionalChainID, c.RegionalChain 
				From (SELECT Distinct NationalChainID, NationalChain, RegionalChainID, RegionalChain
						From Staging.Chain Where Rtrim(RegionalChain) != '' And NationalChain != '') c
				Left Join SAP.NationalChain nc on nc.SAPNationalChainID = c.NationalChainID) AS input
			ON bu.SAPRegionalChainID = input.RegionalChainID
	WHEN MATCHED THEN 
		UPDATE SET bu.RegionalChainName = dbo.udf_TitleCase(input.RegionalChain),
				   bu.NationalChainID = input.NationalChainID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPRegionalChainID, RegionalChainName, NationalChainID)
	VALUES(RegionalChainID, dbo.udf_TitleCase(input.RegionalChain), NationalChainID);

	Update @saprc Set RegionalChainName = 'CVS/Pharmacy' Where RegionalChainName = 'Cvs/Pharmacy'
	Update @saprc Set ChangeTrackNumber = CHECKSUM(SAPRegionalChainID, RegionalChainName, NationalChainID)
	
	MERGE SAP.RegionalChain AS pc
	USING @saprc AS input ON pc.RegionalChainID = input.RegionalChainID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPRegionalChainID, RegionalChainName, NationalChainID, ChangeTrackNumber, LastModified)
	VALUES(input.SAPRegionalChainID, input.RegionalChainName, input.NationalChainID, input.ChangeTrackNumber, GetDate());

	Update sdm
	Set SAPRegionalChainID = sap.SAPRegionalChainID, RegionalChainName = sap.RegionalChainName, 
		NationalChainID = sap.NationalChainID, ChangeTrackNumber = sap.ChangeTrackNumber, LastModified = GetDate()
	From @saprc sap
	Join SAP.RegionalChain sdm on sap.RegionalChainID = sdm.RegionalChainID and sap.ChangeTrackNumber != isnull(sdm.ChangeTrackNumber, 0)
	--------------------------------------------

	--------------------------------------------
	---Local Chain------------------------------
	Declare @saplc Table
	(
		LocalChainID int, 
		SAPLocalChainID int,
		LocalChainName varchar(128), 
		RegionalChainID int, 
		ChangeTrackNumber int
	)
	Insert @saplc(LocalChainID, SAPLocalChainID, LocalChainName, RegionalChainID, ChangeTrackNumber)
	Select LocalChainID, SAPLocalChainID, LocalChainName, RegionalChainID, ChangeTrackNumber From SAP.LocalChain

	MERGE @saplc AS ba
		USING ( Select LocalChain, rc.RegionalChainID, l.LocalChainID From
				( Select Distinct LocalChainID, LocalChain, RegionalChainId, RegionalChain
					From Staging.Chain 
					Where LocalChainID Not In ('#', '', 'test hier2', 'Test Hierr 02') And 
						(Not (Convert(int, LocalChainID) = '1000105' And Convert(int, RegionalChainID) = '1000265'))) l
				Left Join SAP.RegionalChain rc on l.RegionalChainID = rc.SAPRegionalChainID) AS input
			ON ba.SAPLocalChainID = input.LocalChainID
	WHEN MATCHED THEN
		UPDATE SET ba.LocalChainName = dbo.udf_TitleCase(input.LocalChain),
					ba.RegionalChainID = input.RegionalChainID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPLocalChainID, LocalChainName, RegionalChainID)
	VALUES(input.LocalChainID, dbo.udf_TitleCase(input.LocalChain), input.RegionalChainID);

	Update @saplc Set LocalChainName = 'CVS/Pharmacy' Where LocalChainName = 'Cvs/Pharmacy'
	Update @saplc Set ChangeTrackNumber = CHECKSUM(SAPLocalChainID, LocalChainName, RegionalChainID)

	MERGE SAP.LocalChain AS pc
	USING @saplc AS input ON pc.LocalChainID = input.LocalChainID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPLocalChainID, LocalChainName, RegionalChainID, ChangeTrackNumber, LastModified)
	VALUES(input.SAPLocalChainID, input.LocalChainName, input.RegionalChainID, input.ChangeTrackNumber, GetDate());

	Update sdm
	Set SAPLocalChainID = sap.SAPLocalChainID, LocalChainName = sap.LocalChainName, 
		RegionalChainID = sap.RegionalChainID, ChangeTrackNumber = sap.ChangeTrackNumber, LastModified = GetDate()
	From @saplc sap
	Join SAP.LocalChain sdm on sap.LocalChainID = sdm.LocalChainID and sap.ChangeTrackNumber != isnull(sdm.ChangeTrackNumber, 0)

End



GO
/****** Object:  StoredProcedure [ETL].[pNormalizeLocations]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [ETL].[pNormalizeLocations] 
AS
BEGIN
    -- exec [ETL].[pNormalizeLocations]
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--------------------------------------------
	---- BU ------------------------------------
	-- 1. Extract the source table
	Declare @bu Table
	(
		BUID varchar(50),
		BUName nvarchar(50)
	)
	Insert @bu
	Select Distinct BusinessUnit, BusinessUnit
	From Staging.SalesOffice
	Where BusinessUnit Not In ('Not assigned', '')

	-- 2. Mirror the target table inlcuding checksum
	Declare @sapbu Table
	(
		BUID varchar(50),
		SAPBUID varchar(50),
		BUName nvarchar(50),
		ChangeTrackNumber int
	)
	Insert Into @sapbu
	Select BUID, SAPBUID, BUName, ChangeTrackNumber
	From SAP.BusinessUnit

	-- 3. Merge the mirror with the lastest source
	MERGE @sapbu AS bu
		USING (SELECT BUID,BUName FROM @bu) AS input
			ON bu.SAPBUID = input.BUID
	WHEN MATCHED THEN 
		UPDATE SET bu.BUName = dbo.udf_TitleCase(input.BUName)
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPBUID,BUName)
	VALUES(input.BUID, dbo.udf_TitleCase(input.BUName));
	-- 3.1 Recalculate the Checksum
	Update @sapbu Set ChangeTrackNumber = CheckSum(SAPBUID, BUName)

	-- 4. Update and Insert
	-- 4.1 Insert when no skey is found
	MERGE SAP.BusinessUnit AS bu
		USING (SELECT BUID, SAPBUID, BUName, ChangeTrackNumber FROM @sapbu) AS input
			ON bu.BUID = input.BUID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPBUID, BUName, ChangeTrackNumber, LastModified)
		VALUES(input.SAPBUID, input.BUName, input.ChangeTrackNumber, GetDate());
	-- 4.2 Update when skey is found but the checksum is not right
	Update bu
	Set SAPBUID = sapbu.SAPBUID, BUName = sapbu.BUName, ChangeTrackNumber = sapbu.ChangeTrackNumber, LastModified = GetDate()
	From SAP.BusinessUnit bu 
		Join @sapBU sapbu on bu.BUID = sapbu.BUID And isnull(bu.ChangeTrackNumber, 0) != isnull(sapbu.ChangeTrackNumber, 0)

	--------------------------------------------

	--------------------------------------------
	---Region-------------------------------------
	-- 1. Extract the source table
	Declare @region Table
	(
		SAPBUID varchar(50),
		RegionID varchar(50),
		RegionName nvarchar(50)
	)
	Insert @region
	Select Distinct BusinessUnit, RegionID, Region
	From Staging.SalesOffice
	Where BusinessUnit not in ('Not assigned', '')

	-- 2. Mirror the target table inlcuding checksum
	Declare @sapregion Table
	(
		RegionID int,
		SAPRegionID varchar(50),
		RegionName nvarchar(50),
		BUID int,
		ChangeTrackNumber int
	)
	Insert Into @sapregion
	Select RegionID, SAPRegionID, RegionName, BUID, ChangeTrackNumber
	From SAP.Region

	-- 3. Merge the mirror with the lastest source
	MERGE @SAPRegion AS ba
		USING ( SELECT r.SAPBUID,RegionID,RegionName,bu.BUID 
				FROM @region r Join SAP.BusinessUnit bu on r.SAPBUID = bu.SAPBUID) AS input
			ON ba.SAPRegionID = input.RegionID
	WHEN MATCHED THEN
		UPDATE SET ba.RegionName = dbo.udf_TitleCase(input.RegionName)
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPRegionID,RegionName,BUID)
	VALUES(input.RegionID, dbo.udf_TitleCase(input.RegionName), input.BUID);
	-- 3.1. Hardcode to fix the Captitalization
	Update @sapregion
	Set RegionName = 'Metro NY/NJ'
	Where RegionName = 'Metro Ny/Nj'
	Update @sapregion Set ChangeTrackNumber = CHECKSUM(SAPRegionID, RegionName, BUID)

	-- 4. Update and Insert
	-- 4.1 Insert when no skey is found
	MERGE SAP.Region AS ba
		USING ( SELECT RegionID, SAPRegionID, RegionName, BUID, ChangeTrackNumber from @sapRegion) AS input
			ON ba.RegionID = input.RegionID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPRegionID,RegionName,BUID, ChangeTrackNumber, LastModified)
	VALUES(input.SAPRegionID, input.RegionName, input.BUID, input.ChangeTrackNumber, GetDate());

	-- 4.2 Update when skey is found but the checksum is not right
	Update bu
	Set SAPRegionID = sapbu.SAPRegionID, RegionName = sapbu.RegionName, BUID = sapbu.BUID, ChangeTrackNumber = sapbu.ChangeTrackNumber, LastModified = GetDate()
	From SAP.Region bu 
		Join @sapRegion sapbu on bu.RegionID = sapbu.RegionID And isnull(bu.ChangeTrackNumber, 0) != isnull(sapbu.ChangeTrackNumber, 0)

	--------------------------------------------
	---BRANCH-----------------------------------
	-- 1. Extract the source table
	Declare @branch Table
	(
		SAPRegionID varchar(50),
		SalesOfficeID varchar(50),
		SalesOffice nvarchar(50)
	)
	Insert @branch
	Select Distinct RegionID, SalesOfficeID, SalesOffice
	From Staging.SalesOffice
	Where BusinessUnit not in ('Not assigned', '')

	Insert @branch values('METRO NY/NJ', '1085', 'NEWBURGH')

	-- 2. Mirror the target table inlcuding checksum
	Declare @sapbr Table
	(
		BranchID int,
		SAPBranchID varchar(50),
		BranchName varchar(50),
		RegionID int,
		RMLocationID int,
		RMLocationCity varchar(50),
		ZipCode varchar(30),
		ChangeTrackNumber int
	)
	Insert Into @sapbr
	Select BranchID, SAPBranchID,BranchName,RegionID,RMLocationID,RMLocationCity, ZipCode,ChangeTrackNumber From SAP.Branch

	-- 3. Merge the mirror with the lastest source
	MERGE @sapbr AS ba
		USING ( SELECT b.SalesOfficeID, b.SalesOffice, area.RegionID, l.Location_ID, l.Location_City, l.LOCATION_ZIP
				FROM @branch b 
				Join SAP.Region area on b.SapRegionID = area.SapRegionID
				Left Join Staging.RMLocation l on (b.SalesOfficeID = Left(l.Location_ID, 4))
				) AS input
			ON ba.SAPBranchID = input.SalesOfficeID
	WHEN MATCHED THEN
		UPDATE SET ba.BranchName = dbo.udf_TitleCase(input.SalesOffice),
		            ba.REgionID = input.RegionID,
					ba.RMLocationID = Location_ID,
					ba.RMLocationCity = Location_City,
					ba.ZipCode = LOCATION_ZIP
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPBranchID,BranchName,RegionID,RMLocationID, RMLocationCity, ZipCode)
	VALUES(input.SalesOfficeID, dbo.udf_TitleCase(input.SalesOffice), input.RegionID, Location_ID, Location_City, Location_Zip);
	Update @sapbr Set ChangeTrackNumber = CHECKSUM(SAPBranchID, BranchName, RegionID, RMLocationID, RMLocationCity, ZipCode)

	-- 4. Update and Insert
	-- 4.1 Insert when no skey is found
	MERGE SAP.Branch AS ba
		USING ( SELECT BranchID, SAPBranchID,BranchName,RegionID,RMLocationID,RMLocationCity,ZipCode,ChangeTrackNumber from @sapbr) AS input
			ON ba.BranchID = input.BranchID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPBranchID, BranchName, RegionID, RMLocationID, RMLocationCity, ZipCode, ChangeTrackNumber, LastModified)
		VALUES(input.SAPBranchID, input.BranchName, input.RegionID, input.RMLocationID, input.RMLocationCity, input.ZipCode, input.ChangeTrackNumber, GetDate());

	-- 4.2 Update when skey is found but the checksum is not right
	Update bu
	Set SAPBranchID = sapbu.SAPBranchID, BranchName = sapbu.BranchName, RegionID = sapbu.RegionID, RMLocationID = sapbu.RMLocationID, 
		RMLocationCity = sapbu.RMLocationCity, ChangeTrackNumber = sapbu.ChangeTrackNumber, ZipCode = sapbu.ZipCode, LastModified = GetDate()
	From SAP.Branch bu 
		Join @sapbr sapbu on bu.BranchID = sapbu.BranchID And isnull(bu.ChangeTrackNumber, 0) != isnull(sapbu.ChangeTrackNumber, 0)

	--------------------------------------------
	---PROFIT CENTER----------------------------
	-- 1. Extract the source table
	--Select ProfitCenterID, ProfitCenter, SalesOfficeID, SalesOffice
	--From Staging.ProfitCenterToSalesOffice

	-- 2. Mirror the target table inlcuding checksum
	Declare @sppc Table
	(
		ProfitCenterID int,
		SAPProfitCenterID varchar(50),
		ProfitCenterName varchar(64),
		BranchID int,
		BWSalesOfficeID varchar(50),
		BWSalesOffice varchar(50), 
		ChangeTrackNumber int
	)
	Insert Into @sppc(ProfitCenterID, SAPProfitCenterID, ProfitCenterName, BranchID, ChangeTrackNumber)
	Select ProfitCenterID, SAPProfitCenterID, ProfitCenterName, BranchID, ChangeTrackNumber From SAP.ProfitCenter

	-- 3. Merge the mirror with the lastest source
	Declare @temppc Table
	(
		ProfitCenterID varchar(128), 
		ProfitCenter varchar(128), 
		SalesOfficeID varchar(128), 
		SalesOffice varchar(128), 
		BranchID int
	)
	Insert Into @temppc
	SELECT ProfitCenterID, ProfitCenter, SalesOfficeID, SalesOffice, br.BranchID
	FROM Staging.ProfitCenterToSalesOffice p Left Join SAP.Branch br on p.SalesOfficeID = br.SAPBranchID
	Where ISNUMERIC(ProfitCenterID) = 1 And ProfitCenterID != '101196.'

	MERGE @sppc AS ba
		USING (Select Convert(int, ProfitCenterID) ProfitCenterID, ProfitCenter, SalesOfficeID, SalesOffice, BranchID From @temppc) AS input
			ON ba.SAPProfitCenterID = input.ProfitCenterID
	WHEN MATCHED THEN
		UPDATE SET ba.ProfitCenterName = dbo.udf_TitleCase(input.ProfitCenter),
			ba.BranchID = input.BranchID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPProfitCenterID, ProfitCenterName, BranchID)
	VALUES(case when ISNUMEric(input.ProfitCenterID) = 1 Then Convert(int, input.ProfitCenterID) Else input.ProfitCenterID End, dbo.udf_TitleCase(input.ProfitCenter), input.BranchID);
	Update @sppc Set ChangeTrackNumber = CHECKSUM(SAPProfitCenterID, ProfitCenterName, BranchID);

	-- 4. Update and Insert
	-- 4.1 Insert when no skey is found
	MERGE SAP.ProfitCenter AS ba
		USING ( SELECT ProfitCenterID, SAPProfitCenterID, ProfitCenterName, BranchID,ChangeTrackNumber from @sppc) AS input
			ON ba.ProfitCenterID = input.ProfitCenterID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPProfitCenterID, ProfitCenterName, BranchID, ChangeTrackNumber, LastModified)
	VALUES(input.SAPProfitCenterID, input.ProfitCenterName, input.BranchID, input.ChangeTrackNumber, GetDate());

	-- 4.2 Update when skey is found but the checksum is not right
	Update bu
	Set SAPProfitCenterID = sapbu.SAPProfitCenterID, ProfitCenterName = sapbu.ProfitCenterName, BranchID = sapbu.BranchID, 
		ChangeTrackNumber = sapbu.ChangeTrackNumber, LastModified = GetDate()
	From SAP.ProfitCenter bu 
		Join @sppc sapbu on bu.ProfitCenterID = sapbu.ProfitCenterID And isnull(bu.ChangeTrackNumber, 0) != isnull(sapbu.ChangeTrackNumber, 0)


	--------------------------------------------
	---COST CENTER----------------------------
	--Select CostCenterID, CostCenter, ProfitCenterID
	--From Staging.CostCenterToProfitCenter
	
	-- 2. Mirror the target table inlcuding checksum
	Declare @sapcc Table
	(
		CostCenterID int,
		SAPCostCenterID varchar(64),
		CostCenterName varchar(64),
		ProfitCenterID int,
		ChangeTrackNumber int
	)
	Insert Into @sapcc(CostCenterID, SAPCostCenterID, CostCenterName, ProfitCenterID, ChangeTrackNumber)
	Select CostCenterID, SAPCostCenterID, CostCenterName, ProfitCenterID, ChangeTrackNumber From SAP.CostCenter

	-- 3. Merge the mirror with the lastest source
	MERGE @sapcc AS ba
		USING ( Select c.CostCenterID, c.CostCenter, pc.ProfitCenterID
				From Staging.CostCenterToProfitCenter c Left Join SAP.ProfitCenter pc on convert(int, c.ProfitCenterID) = pc.SAPProfitCenterID
			  ) AS input
			ON ba.SAPCostCenterID = case when isnumeric(input.CostCenterID) = 1 then convert(int, input.CostCenterID) else input.CostCenterID end
	WHEN MATCHED THEN
		UPDATE SET ba.CostCenterName = dbo.udf_TitleCase(input.CostCenter)
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPCostCenterID, CostCenterName, ProfitCenterID)
	VALUES(case when isnumeric(input.CostCenterID) = 1 then convert(int, input.CostCenterID) else input.CostCenterID end, dbo.udf_TitleCase(input.CostCenter), input.ProfitCenterID);
	Update @sapcc Set ChangeTrackNumber = CHECKSUM(SAPCostCenterID, CostCenterName, ProfitCenterID);
	
	-- 4. Update and Insert
	-- 4.1 Insert when no skey is found
	MERGE SAP.CostCenter AS ba
		USING @sapcc AS input
		ON ba.CostCenterID = input.CostCenterID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPCostCenterID, CostCenterName, ProfitCenterID, ChangeTrackNumber, LastModified)
	VALUES(input.SAPCostCenterID, input.CostCenterName, input.ProfitCenterID, input.ChangeTrackNumber, GetDate());

	-- 4.2 Update when skey is found but the checksum is not right
	Update bu
	Set SAPCostCenterID = sapbu.SAPCostCenterID, CostCenterName = sapbu.CostCenterName, ProfitCenterID = sapbu.ProfitCenterID, 
		ChangeTrackNumber = sapbu.ChangeTrackNumber, LastModified = GetDate()
	From SAP.CostCenter bu 
		Join @sapcc sapbu on bu.CostCenterID = sapbu.CostCenterID And isnull(bu.ChangeTrackNumber, 0) != isnull(sapbu.ChangeTrackNumber, 0)
	
	-------------------------------------------------
	------------- Update SPName for locations -------
	----Update SAP.BusinessUnit
	----Set SPBUName = BUName

	----Update SAP.Region
	----Set SPRegionName = RegionName
	----Where SAPRegionID <> 'CENTRAL'

	----Update SAP.Region
	----Set SPRegionName = 'So. Cal / Nevada'
	----Where SAPRegionID = 'SOCAL - NEVADA'

	----Update SAP.Region
	----Set SPRegionName = null
	----Where SAPRegionID = 'SOUTH TEXAS NEW MEXICO'

	---------------------------------------------
	----Update SAP.Branch
	----Set SPBranchName = BranchName

	----Update SAP.Branch
	----Set SPBranchName = null
	----Where BranchName in ('Northlake Fran Dist', 'Racine Fran Dist', '"jackson', '"hzlwd Dst-Clmbia', '"jeffcty Dst-Clmba' )

	---------------- Plains -----------------------
	-----------------------------------------------
	----Update SAP.Branch
	----Set SPBranchName = 'St Joseph'
	----Where BranchName = 'St. Joseph'

	----Update SAP.Branch
	----Set SPBranchName = 'West Fargo'
	----Where BranchName = 'Fargo'

	----Update SAP.Branch
	----Set SPBranchName = 'South St.Paul'
	----Where BranchName = 'Twin Cities'

	----Update SAP.Branch
	----Set SPBranchName = null
	----Where BranchName in ('Des Moines Fran Dist', 'Lenexa Fran Dist',
	----'Omaha Fran Dist', 'Ottumwa Mfg', 'Twin Cities Fran Dst')

	---------------- Southeast --------------------
	-----------------------------------------------
	----Update SAP.Branch
	----Set SPBranchName = 'Mobile'
	----Where BranchName = 'Mobile Fran Dist'

	----Update SAP.Branch
	----Set SPBranchName = 'Ft Myers'
	----Where BranchName = 'Fort Myers'

	----Update SAP.Branch
	----Set SPBranchName = null
	----Where BranchName in ('Birmingham Fran Dist', 'Jackson Fran Dist', 'Jacksonville Mfg')

	---------------- Pacific - Northwest ----------
	----Update SAP.Branch
	----Set SPBranchName = 'McKinleyville'
	----Where BranchName = 'Eureka'

	----Update SAP.Branch
	----Set SPBranchName = null
	----Where BranchName in ('Sacramento Mfg', 'Vallejo')

	---------------- Pacific - So. Cal/Nevada ----------
	----Update SAP.Branch
	----Set SPBranchName = null
	----Where BranchName in ('Buena Park', 'Camarillo', 'Victorville')

	----Update SAP.Branch
	----Set SPBranchName = 'Los Angeles'
	----Where BranchName = 'LA/Vernon' -- There is a split in SP for this

	----Update SAP.Branch
	----Set SPBranchName = 'LA/Vernon'
	----Where BranchName = 'Vernon' -- There is a split in SP for this

	----Update SAP.Branch
	----Set SPBranchName = 'North Las Vegas'
	----Where BranchName = 'Las Vegas'

End
GO
/****** Object:  StoredProcedure [ETL].[pNormalizeMaterial]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ETL].[pNormalizeMaterial] 
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

End





GO
/****** Object:  StoredProcedure [ETL].[pStageRM]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [ETL].[pStageRM]
AS
	/*
	1. Location
	2. Accounts
	3. Route Master
	4. Route Schedule
	5. Item Master
	6. Package

	*/

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	-- 1. Locations
	Truncate Table Staging.RMLocation

	Insert Into Staging.RMLocation(LOCATION_ID, LOCATION_NAME, LOCATION_ADDR1, LOCATION_ADDR2, LOCATION_CITY, LOCATION_STATE, LOCATION_ZIP, LOCATION_PHONE, LOCATION_FAX, COMPANY_NAME, SUPPLIER_LOCATION_NUMBER)
	SElect LOCATION_ID, LOCATION_NAME, LOCATION_ADDR1, LOCATION_ADDR2, LOCATION_CITY, LOCATION_STATE, LOCATION_ZIP, LOCATION_PHONE, LOCATION_FAX, COMPANY_NAME, SUPPLIER_LOCATION_NUMBER
	From RM..ACEUSER.LOCATION;

	-- 2. Load Accounts into Staging
	Truncate Table Staging.RMAccount;

	INSERT INTO Staging.RMAccount(CUSTOMER_NUMBER, LOCATION_ID, CUSTOMER_NAME, CUSTOMER_STREET, CITY, STATE
			, POSTAL_CODE, CONTACT_PERSON, PHONE_NUMBER, LOCAL_CHAIN, CHANNEL, ACTIVE)
	Select CUSTOMER_NUMBER, LOCATION_ID, CUSTOMER_NAME, CUSTOMER_STREET, CITY, STATE
			,POSTAL_CODE, CONTACT_PERSON, PHONE_NUMBER, LOCAL_CHAIN, CHANNEL, ACTIVE
	From RM..ACEUSER.CUSTOMERS

	-- 3. Route Master
	Truncate Table Staging.RMRouteMaster;

	Insert Into Staging.RMRouteMaster(ROUTE_NUMBER, ROUTE_DESCRIPTION, ACTIVE_ROUTE, ROUTE_TYPE, LOCATION_ID, DEFAULT_EMPLOYEE, ACTIVE)
	Select ROUTE_NUMBER, ROUTE_DESCRIPTION, ACTIVE_ROUTE, ROUTE_TYPE, LOCATION_ID, DEFAULT_EMPLOYEE, ACTIVE	
	From RM..ACEUSER.ROUTE_MASTER
	
	--------------------------------------------
	-- 6. Package -------------------------------
	--Load Packages into Staging
	Truncate Table Staging.RMPackage

	Insert Into Staging.RMPackage
	Select PACKAGEID, DESCRIPTION, Substring(PACKAGEID, 1, 3) SAPPackageTypeID, SUBSTRING(PACKAGEID, 4, 2) SAPPackageConfigID
	From RM..ACEUSER.PACKAGE;

	-----------------------------------------------------
	-- 4. RouteSchedule ----------------------------------
	Truncate Table Staging.RMRouteSchedule;

	Insert Into Staging.RMRouteSchedule(ROUTE_NUMBER,CUSTOMER_NUMBER,LOCATION_ID,FREQUENCY,START_DATE,DEFAULT_DELIV_ROUTE,SEQUENCE_NUMBER,SEASONAL,SEASONAL_START_DATE,SEASONAL_END_DATE)
	Select		ROUTE_NUMBER,CUSTOMER_NUMBER,LOCATION_ID,FREQUENCY,START_DATE,DEFAULT_DELIV_ROUTE,SEQUENCE_NUMBER,SEASONAL,SEASONAL_START_DATE,SEASONAL_END_DATE
	From RM..ACEUSER.ROUTE_SCHEDULE;

	-----------------------------------------------------
	-- 5. ItemMaster ----------------------------------
	Truncate Table Staging.RMItemMaster

	Insert Into Staging.RMItemMaster
	Select Distinct Location_ID, ITEM_NUMBER
	From RM..ACEUSER.ITEM_MASTER
	Where Active = 1



GO
/****** Object:  StoredProcedure [ETL].[pStageRN]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Proc [ETL].[pStageRN]
AS
	/*
	1. Location

	*/

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	-- Locations
	Truncate Table Staging.RNLocation

	Insert INTO Staging.RNLocation
	Select * From  OPENQUERY(RN, 'Select ID AS AccountNumber, LONGITUDE/1000000.0 LONGITUDE, LATITUDE/1000000.0 LATITUDE From TSDBA.TS_LOCATION' )

	--Select top 10 * 
	--From RN..[TSDBA].[TS_EQUIPMENT]

	--Select Distinct Status
	--From RN..[TSDBA].[TS_EQUIPMENT]

GO
/****** Object:  StoredProcedure [MSTR].[pSpreadBranchPlan]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [MSTR].[pSpreadBranchPlan] (@monthId int) 
AS
BEGIN
set nocount on
/*******************************************************************************************************************  

Description:  This procedure will be run every month to spread the Sales Plan from the DimBranchplan down to the Sales Route level
Schema:  MSTR
--------------------------------------------------------------------------------------------------------------------  
Created By      :  Rajeev Unnikrishnan
Created Date    :  09-April-13
Tracker/Release :  
--------------------------------------------------------------------------------------------------------------------  
------------------------------------------------------------------------------------------------------------  
*********************************************************************************************/

	-- get all the plan versions used by different sales offices
	declare @versions int
	declare @versionid int
	declare @ctr int

	set @versions=0
	set @versionid=0
	set @ctr=0


	-- get the different plans and the plan versions
	create table #BranchPlans (monthid int, versionid int, branchid int, planvolume numeric(18,4))

	insert into #BranchPlans(monthid, versionid, branchid, planVolume)
	select bp.monthid, spv.versionid, bp.branchid, bp.planVolume 
	from MSTR.DimBranchplan bp inner join MSTR.RelMyDaySalesOfficePlanVersion spv on bp.branchid=spv.branchid
	where bp.monthid=@monthid

	-- get all different versions of branch plans - we will need to loop through this
	create table #versions (versionId int)
	insert into #versions
	select distinct versionid from #BranchPlans
	select @ctr=count(*) from #versions


	-- get the actual percent spreads for the routes in the sales offices
	create table #BranchPlanSpreads (branchid int, routeid int, sales numeric(18,4), percentMix numeric(18,10))

	while(@ctr<>0)
	begin
		select top 1 @versionid=versionId from #versions
		insert into #BranchPlanSpreads (branchId, routeid, sales)
		select s.branchid, rs.routeid,sum(f.MTDConvertedCases) sales
		from MSTR.FactMyDayCustomer f 
			inner join sap.routeSchedule rs on f.accountId=rs.accountId
			inner join sap.SalesRoute s on rs.RouteID=s.RouteID 
			inner join mstr.RelMyDaySalesOfficePlanVersion sopv on sopv.branchid=s.branchid and sopv.versionid=@versionid
		where MonthID in(select monthid from [MSTR].[udfMonthsForPlanSpread](@versionid))
		group by rs.routeid,s.branchid

		delete from #versions where versionid=@versionId
		select @ctr=count(*) from #versions
	end

	-- update the percentMix 
	update f
	set percentMix=f.sales/NullIf(f1.cs,0)
	from #BranchPlanSpreads f inner join (select branchid, sum(sales) cs from #BranchPlanSpreads group by branchid) f1 on f.branchid=f1.branchid

	

	delete from MSTR.FACTMyDayRoutePlan where monthid=@monthid

	insert into MSTR.FACTMyDayRoutePlan(RouteID, MonthID, VersionID, PlanCases, RecordDate)
	select routeid, @monthid, versionid, sp.percentMix*p.planVolume, getdate()
	from #BranchPlanSpreads sp inner join #BranchPlans p on p.branchid=sp.branchid
	

	drop table #BranchPlans
	drop table #BranchPlanSpreads
	drop table #versions
END

GO
/****** Object:  StoredProcedure [MSTR].[pUpdateHistoryFMDCustomer]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Muralidhar Busa>
-- Create date: <04/29/2013>
-- Description:	<This procedure Updates History FatcMyDayCutomer table for vertical colums YTDCases, YTDRevenue, LYCM cases and Revenue, Avg3Month and prorated>
-- =============================================
Create PROCEDURE [MSTR].[pUpdateHistoryFMDCustomer]
	-- Add the parameters for the stored procedure here
	@MonID as Varchar (8)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
Set @MonID = ltrim(rtrim((@MonID)))

If len(ltrim(rtrim((@MonID)))) =0
	Begin
		RAISERROR ('Empty Spaces are not allowed',11,6)
		Goto Exitpoint
	End 

If Len(@MonID) !=6 
	Begin
		RAISERROR ('Please provide valid date in YYYYMM format',11,6)
		Goto Exitpoint
	End 

If IsNumeric(@MonID)=0 or Left(@MonID,1) = '-' or @MonID='000000'
	Begin
		RAISERROR ('Must be positive Integer only',11,6)
		Goto Exitpoint
	End 

Declare @MonthID as Varchar(8)= @MonID
--Declare @MonthID as Varchar(8)= Cast(Year(Getdate())  as Varchar) +  IIf(Len(Month(Getdate()))=1, '0'+ Cast(Month(Getdate()) as Varchar), Cast(MOnth(getdate())as Varchar))
Declare @MailBody as Varchar (1000)
Declare @M1 as Varchar(8)
Declare @M2 as Varchar(8)
Declare @M3 as Varchar(8)
Declare @MStart as Varchar(8)
Declare @LYMonthID as Varchar(10)

If right(@MonthID-1,2) = 0
	Begin
		Set @M1=Cast(Left(@MonthID,4)-1 as Varchar) + '12'
		Set @M2=Cast(Left(@MonthID,4)-1 as Varchar) + '11'
		Set @M3=Cast (Left(@MonthID,4)-1 as Varchar) + '10'
	ENd
Else If right(@MonthID-1,2) = 1
	Begin
		Set @M1=Cast(Left(@MonthID,4) as Varchar) + '01'
		Set @M2=Cast(Left(@MonthID,4)-1 as Varchar) + '12'
		Set @M3=Cast (Left(@MonthID,4)-1 as Varchar) + '11'
	ENd
Else If right(@MonthID-1,2) = 2
	Begin
		Set @M1=Cast(Left(@MonthID,4) as Varchar) + '02'
		Set @M2=Cast(Left(@MonthID,4) as Varchar) + '01'
		Set @M3=Cast (Left(@MonthID,4)-1 as Varchar) + '12'
	ENd
Else
	Begin 
		Set @M1=@MonthID-1
		Set @M2=@MonthID-2
		Set @M3=@MonthID-3
	ENd

Set @LYMonthID = Cast(Left(@Monthid,4)-1 as Varchar) + Cast(Right(@MonthID,2) as Varchar)
Set @MStart = Cast(Left(@Monthid,4) as Varchar) + '01'



/* Updating the MSTR.FactMyDayCustomer for 2 columns YTDConvertedcases, YTDRevenue */
Update f set f.YTDConvertedCases= coalesce(f1.cs,0), f.YTDRevenue= coalesce(f1.Rev,0)
--Select f.accountid, f.brandid,f.packageid,f.BevTypeID,f.internalCategoryId, MTDConvertedCases MTDCS, cs, cast(sum(MTDRevenue) as numeric(18,4)) Rev
from mstr.FactMyDayCustomer f 
	Inner join 
        (select accountid,brandid,packageid,BevTypeID,internalCategoryId,
		cast(sum(mtdconvertedcases) as numeric(18,4)) cs , cast(sum(MTDRevenue) as numeric(18,4)) Rev  
        from mstr.FactMyDayCustomer  
        where MonthID >= @MStart and MonthID <= @MonthID
        group by accountid,brandid,packageid,BevTypeID,internalCategoryId
        )f1
        on f.accountid=f1.accountid 
        and f.brandid=f1.brandid 
        and f.packageid=f1.packageid
        and f.bevtypeid=f1.BevTypeID
        and f.internalCategoryId=f1.internalCategoryId
where f.monthid = @MonthID

Update mstr.FactMyDayCustomer Set YTDConvertedCases=0 where YTDConvertedCases is Null
Update mstr.FactMyDayCustomer Set YTDRevenue=0 where YTDRevenue is Null



/* Updating the MSTR.FactMyDayCustomerSummary for 2 columns LYCMConvertedcases, LYCMRevenue */
Update f set f.LYCMConvertedCases = coalesce(f1.lycs,0), f.LYCMRevenue = coalesce(f1.lyRev,0)
--Select f.accountid, f.brandid,f.packageid,f.BevTypeID,f.internalCategoryId, MTDConvertedCases MTDCS, lycs, cast(sum(mtdRevenue) as numeric(18,4)) lyRev 
from mstr.FactMyDayCustomer f 
    Inner join 
        (select accountid,brandid,packageid,BevTypeID,internalCategoryId,
		cast(sum(mtdconvertedcases) as numeric(18,4)) lycs, cast(sum(mtdRevenue) as numeric(18,4)) lyRev  
        from mstr.FactMyDayCustomer  
        where monthid = @LYMonthID
        group by accountid,brandid,packageid,BevTypeID,internalCategoryId
        ) f1
        on f.accountid=f1.accountid 
        and f.brandid=f1.brandid 
        and f.packageid=f1.packageid
        and f.bevtypeid=f1.BevTypeID
        and f.internalCategoryId=f1.internalCategoryId
where f.monthid=@MonthID
Update mstr.FactMyDayCustomer Set LYCMConvertedCases=0 where LYCMConvertedCases is Null
Update mstr.FactMyDayCustomer Set LYCMRevenue=0 where LYCMRevenue is Null


/* Updating the MSTR.FactMyDayCustomerSummary for columns Avg3Month */
Update f set f.Avg3Month= coalesce(f1.Avg3M/3,0)
--Select coalesce(f1.Avg3M/3,0), f1.Avg3M, *
from mstr.FactMyDayCustomer f 
	Inner join 
		(select accountid,brandid,packageid,BevTypeID,internalCategoryId,cast(sum(MTDConvertedCases) as numeric(18,4)) Avg3M 
		from mstr.FactMyDayCustomer  
		where monthid >= @M3 and monthid <= @M1
		group by accountid,brandid,packageid,BevTypeID,internalCategoryId
		) f1
		on f.accountid=f1.accountid 
		and f.brandid=f1.brandid 
		and f.packageid=f1.packageid
		and f.bevtypeid=f1.BevTypeID
		and f.internalCategoryId=f1.internalCategoryId
where f.monthid=@MonthID
Update mstr.FactMyDayCustomer Set Avg3Month=0 where Avg3Month is Null



/* Updating the MSTR.FactMyDayCustomerSummary for column Avg3MonthProrated */
Declare @MID Varchar(10)
Declare @ProratedDays Float
Declare @TotalDays Float
Set @MID = @MonthID
Set @MID = Left(@MID,4) + '-' + Right(@MID,2) + '-' + '01'
Set @TotalDays = Day(EOMONTH(@MID))
Set @ProratedDays = Day(getdate())-1


If @ProratedDays >= 1

	Begin
		Print 'Greater Eaqual 1'
		Update f set f.Avg3MonthProrated = (((coalesce(f1.Avg3M/3,0))/@TotalDays)*@ProratedDays)
		--Select 1,f1.Avg3M, coalesce(f1.Avg3M/3,0) Avg3Month, (((coalesce(f1.Avg3M/3,0))/@TotalDays)*@ProratedDays) Avg3MonthPRoRtd,  *
		from mstr.FactMyDayCustomer f 
			   Inner join 
					  (select accountid,brandid,packageid,BevTypeID,internalCategoryId,cast(sum(MTDConvertedCases) as numeric(18,4)) Avg3M 
					  from mstr.FactMyDayCustomer 
					  where monthid >= @M3 and monthid <= @M1
					  group by accountid,brandid,packageid,BevTypeID,internalCategoryId
					  ) f1
					  on f.accountid=f1.accountid 
					  and f.brandid=f1.brandid 
					  and f.packageid=f1.packageid
					  and f.bevtypeid=f1.BevTypeID
					  and f.internalCategoryId=f1.internalCategoryId
		where f.monthid=@MonthID
	End
Else
	Begin
		Print 'Less than 1'
		Update f set f.Avg3MonthProrated = coalesce(f1.Avg3M/3,0)
		--Select 2,f1.Avg3M, coalesce(f1.Avg3M/3,0) Avg3Month, coalesce(f1.Avg3M/3,0) Avg3MonthPRoRtd,  *
		from mstr.FactMyDayCustomer f 
			   Inner join 
					  (select accountid,brandid,packageid,BevTypeID,internalCategoryId,cast(sum(MTDConvertedCases) as numeric(18,4)) Avg3M 
					  from mstr.FactMyDayCustomer 
					  where monthid >= @M3 and monthid <= @M1
					  group by accountid,brandid,packageid,BevTypeID,internalCategoryId
					  ) f1
					  on f.accountid=f1.accountid 
					  and f.brandid=f1.brandid 
					  and f.packageid=f1.packageid
					  and f.bevtypeid=f1.BevTypeID
					  and f.internalCategoryId=f1.internalCategoryId
		where f.monthid=@MonthID
	End

--Update mstr.FactMyDayCustomerSummary Set Avg3MonthProrated=0 where Avg3MonthProrated is Null


/* Sending email with Statistics */

--Set @MailBody='The MyDayCustomer records are loaded into STAGING Table....' + char(10) + Char(13) + 
--				'Total Staging Records:' + Cast(@LoadedRecordsStg as Varchar) + Char(13) +
--				'Sum Of Tatal Cases   : ' + Cast(@SumCasesStg as Varchar) + Char(13) +
--				'Sum Of Tatal Revenue : ' + Cast(@SumRevenueStg as Varchar) + Char(10) + Char(13) +

--				'The MyDayCustomer records are loaded into FACT Table....' + char(10) + Char(13) + 
--				'Total Fact Records   : ' + Cast(@LoadedRecordsFact as Varchar) + Char(13) +
--				'Sum Of Tatal Cases   : ' + Cast(@SumCasesFact as Varchar) + Char(13) +
--				'Sum Of Tatal Revenue : ' + Cast(@SumRevenueFact as Varchar) + Char(13)


--EXEC msdb.dbo.sp_send_dbmail
--    @recipients = 'Muralidhar.Busa@dpsg.com;', 
--    @body = @MailBody,
--    @subject = 'FactMyDayCustomer Loading' ; 



Set @MailBody=	'The MyDayCustomer records are loaded into FACT Table....' + char(10) + Char(13) + 
				'M1					  : ' + Cast(@M1 as Varchar) + Char(13) +
				'M2					  : ' + Cast(@M2 as Varchar) + Char(13) +
				'M3					  : ' + Cast(@M3 as Varchar) + Char(13) +
				'MStart				  : ' + Cast(@Mstart as Varchar) + Char(13) +
				'Month ID			  : ' + Cast(@MonthID as Varchar) + Char(13) +
				'LYMonth ID			  : ' + Cast(@LYMonthID as Varchar) + Char(13)


Print @MailBody




Exitpoint: 
	Print ' Did not execute'
	Return

END

GO
/****** Object:  StoredProcedure [PlayBook].[ExportPromotionToExcel]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [PlayBook].[ExportPromotionToExcel]
 @StartDate Date = '2013-05-13',
 @EndDate Date = '2013-05-19'  ,
 @CurrentScope varchar(20) = 'Region',
 @currentuser varchar(20)  = 'KUMVX014',          
 @Buid int = 9,
 @areaid int = 4,
 @Branchid int = 46      
as        
BEGIN              
               
 SET NOCOUNT ON;              
            
-- Personalization for Trademark            
            
CREATE TABLE #PromotionBrandid(BrandidTemp int)            
            
CREATE TABLE #PromotionBrand(Promoid int)            
            
CREATE TABLE #PromotionNationalid(NationalidTemp int)            
            
CREATE TABLE #PromotionRegionalid(RegionalidTemp int)            
            
CREATE TABLE #PromotionLocalid(LocalidTemp int)            
        
create table #promotionNatlAccount(NationalidTemp1 int)        
        
create table #promotionRegAccount (RegionalidTemp1 int)        
        
create table #promotionLocalAccount (LocalidTemp1 int)        
        
            
if (@CurrentScope='BU')            
BEGIN            
insert into #PromotionBrandid            
select distinct TradeMarkID from [Portal_Data].[Person].[UserBranchTradeMark] where userinBranchid in (SELECT  distinct primaryBranchid            
  FROM [Portal_Data].[Person].[UserProfile] where buid=@Buid)            
            
insert into #promotionbrand            
select distinct a.promotionid from Portal_Data.playbook.promotionbrand as a join #PromotionBrandid as b on a.brandid=b.brandidTemp            
            
end            
            
if (@CurrentScope='Area' OR @CurrentScope='Region')            
BEGIN            
insert into #PromotionBrandid            
select distinct TradeMarkID from [Portal_Data].[Person].[UserBranchTradeMark] where userinBranchid in (SELECT  distinct primarybranchid            
  FROM [Portal_Data].[Person].[UserProfile] where areaid=@areaid)            
            
insert into #promotionbrand            
select distinct a.promotionid from Portal_Data.playbook.promotionbrand as a join #PromotionBrandid as b on a.brandid=b.brandidTemp            
end            
            
if (@CurrentScope='Branch')            
BEGIN            
insert into #PromotionBrandid            
select distinct TradeMarkID from [Portal_Data].[Person].[UserBranchTradeMark] where userinBranchid in (SELECT distinct branchid            
  FROM [Portal_Data].[Person].[UserInBranch] where GSN=@currentuser)            
            
insert into #promotionbrand            
select distinct a.promotionid from Portal_Data.playbook.promotionbrand as a join #PromotionBrandid as b on a.brandid=b.brandidTemp            
            
end            
            
        
            
if (@CurrentScope='BU')            
BEGIN            
insert into #PromotionNationalid            
select distinct nationalchainid  from mview.locationchain where buid=@Buid            
insert into #PromotionRegionalid            
select distinct regionalchainid  from mview.locationchain where buid=@Buid            
insert into #PromotionLocalid            
select distinct localchainid  from mview.locationchain where buid=@Buid            
end            
            
if (@CurrentScope='Area' OR @CurrentScope='Region')            
BEGIN            
insert into #PromotionNationalid            
select distinct nationalchainid  from mview.locationchain where regionid=@areaid            
insert into #PromotionRegionalid            
select distinct regionalchainid  from mview.locationchain where regionid=@areaid            
insert into #PromotionLocalid            
select distinct localchainid  from mview.locationchain where regionid=@areaid            
end            
            
if (@CurrentScope='Branch')            
BEGIN            
insert into #PromotionNationalid            
select distinct nationalchainid  from mview.locationchain where branchid in (SELECT distinct branchid            
  FROM [Portal_Data].[Person].[UserInBranch] where GSN=@currentuser)            
            
insert into #PromotionRegionalid            
select distinct regionalchainid  from mview.locationchain where branchid in (SELECT distinct branchid            
  FROM [Portal_Data].[Person].[UserInBranch] where GSN=@currentuser)            
            
insert into #PromotionLocalid            
select distinct localchainid  from mview.locationchain where branchid in (SELECT distinct branchid            
  FROM [Portal_Data].[Person].[UserInBranch] where GSN=@currentuser)            
            
end            
        
insert into #promotionNatlAccount            
select distinct a.promotionid from Portal_Data.playbook.promotionaccount as a join #PromotionNationalid as b on a.nationalchainid=b.NationalidTemp        
        
insert into #promotionRegAccount            
select distinct a.promotionid from Portal_Data.playbook.promotionaccount as a join #PromotionRegionalid as b on a.regionalchainid=b.RegionalidTemp        
        
insert into #promotionLocalAccount            
select distinct a.promotionid from Portal_Data.playbook.promotionaccount as a join #PromotionLocalid as b on a.localchainid=b.LocalidTemp        
         
BEGIN            
SELECT retail.PromotionID,              
  retail.PromotionStatusID, 
  retail.IsLocalized,
  retail.EDGEItemID,
  retail.ParentPromotionID,   
  retail.CreatedBy,
  promoRank.Rank 'PromotionRank',       
  promoType.PromotionType,
  promoType.PromotionTypeId,            
  retail.PromotionName, 
  displaylocation.DisplaylocationName,             
  retail.PromotionPrice,              
  promoRank.PromotionWeekStart as PromotionStartDate,              
  promoRank.PromotionWeekEnd as PromotionEndDate,              
  stat.StatusName,              
  category.ShortPromotionCategoryName AS 'PromotionCategory',              
  STUFF((SELECT DISTINCT '| ' + attachment.AttachmentName + ';' + attachment.AttachmentURL              
              FROM PlayBook.PromotionAttachment AS attachment              
              WHERE attachment.PromotionId = retail.PromotionID              
              FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'') as AttachmentsName,              
        STUFF((SELECT DISTINCT ' | ' + trademark.TradeMarkName              
              FROM SAP.TradeMark as trademark              
              WHERE trademark.TradeMarkID IN (  select _brand.BrandID from PlayBook.PromotionBrand AS _brand where _brand.PromotionID = retail.PromotionID /*and _brand.BrandID in(select BrandidTemp from #PromotionBrandid)*/)              
              FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'') AS PromotionBrands,              
        STUFF((SELECT DISTINCT ' | ' + package.PackageName              
              FROM SAP.Package as package              
              WHERE package.PackageID IN ( select _package.PromotionPackageID from PlayBook.PromotionPackage AS _package where _package.PromotionID = retail.PromotionID)              
              FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'') AS PromotionPackages,              
        CASE WHEN retail.PromotionTypeID = 3 THEN _local.LocalChainName              
    WHEN retail.PromotionTypeID = 1 THEN _regional.RegionalChainName              
    WHEN retail.PromotionTypeID = 2 THEN _national.NationalChainName              
    END AS AccountName,              
  CASE WHEN retail.PromotionTypeID = 3 THEN account.LocalChainID              
    WHEN retail.PromotionTypeID = 1 THEN account.RegionalChainID              
    WHEN retail.PromotionTypeID = 2 THEN account.NationalChainID              
    END AS AccountID   
--INTO #tempPromtionalData         
FROM PlayBook.RetailPromotion AS retail            
INNER JOIN PlayBook.Status AS stat ON retail.PromotionStatusID = stat.StatusID              
INNER JOIN PlayBook.PromotionCategory AS category ON retail.PromotionCategoryID = category.PromotionCategoryID              
INNER JOIN Playbook.PromotionDisplayLocation AS promoDisplayLocation on retail.PromotionId=promoDisplayLocation.PromotionId
INNER JOIN Playbook.DisplayLocation AS displaylocation on promoDisplayLocation.DisplaylocationId=displaylocation.DisplaylocationId
INNER JOIN PlayBook.PromotionAccount AS account ON retail.PromotionID = account.PromotionID               
INNER JOIN  PlayBook.PromotionRank AS promoRank ON promoRank.PromotionID = retail.PromotionID              
INNER JOIN PlayBook.PromotionType promoType ON promoType.PromotionTypeID = retail.PromotionTypeID      
LEFT OUTER JOIN SAP.LocalChain AS _local ON _local.LocalChainID = account.LocalChainID  
LEFT OUTER JOIN SAP.RegionalChain AS _regional ON _regional.RegionalChainID = account.RegionalChainID 
LEFT OUTER JOIN SAP.NationalChain AS _national ON _national.NationalChainID = account.NationalChainID 
WHERE retail.PromotionStartDate BETWEEN @StartDate AND @EndDate


END
DROP TABLE #PromotionBrandid 
DROP TABLE #PromotionBrand 
DROP TABLE #PromotionNationalid
DROP TABLE #PromotionRegionalid
DROP TABLE #PromotionLocalid 
DROP table #promotionNatlAccount 
DROP table #promotionRegAccount 
DROP table #promotionLocalAccount
END

GO
/****** Object:  StoredProcedure [PlayBook].[P_getTimerJOBdetails]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
  
  
CREATE Procedure  
[PlayBook].[P_getTimerJOBdetails]  
(  
 @timerjob datetime  
)  
  
  
as  
begin  
/*******************************************************************************************************************    
Description:  This procedure used to display data for TIMER JOB RELATED.    
Schema:    
--------------------------------------------------------------------------------------------------------------------    
Created By      :  Dilip Singh  
Created Date    :  15-March-13  
Tracker/Release :    
--------------------------------------------------------------------------------------------------------------------    
------------------------------------------------------------------------------------------------------------    
*********************************************************************************************/  
  
create table #displaydata(ProgramNumber int null,StartDate datetime null,ItemID varchar(100) null,EndDate datetime null,  
AccountName varchar(150) null,ChannelName varchar(100) null,AttachmentID varchar(120) null,FileName varchar(128) null,  
PhysicalFile varbinary(max) null,BrandName varchar(2000) null)  
  
insert into #displaydata(ProgramNumber,StartDate,ItemID,EndDate,AccountName,ChannelName,AttachmentID,FileName,PhysicalFile)  
  
select a.ProgramNumber,a.StartDate,a.ItemID,a.EndDate,b.AccountName,c.ChannelName,d.AttachmentID,  
d.FileName,d.PhysicalFile from EDGE.RPLItem a inner join [EDGE].[RPLItemAccount] b  
on a.ItemID=b.ItemID  
inner join [EDGE].[RPLItemChannel] c  
ON  a.ItemID=c.ItemID  
inner join [EDGE].[RPLAttachment] d  
on a.ItemID=d.ItemID  
where a.ModifiedDateUTC >=@timerjob  
  
  
create table #working1 (ItemID VARCHAR(50) NOT NULL,BrandName varchar(2000) null)  
insert into #working1(ItemID,BrandName)  
SELECT p1.ItemID,  
  
       stuff( (SELECT ','+BrandName   
  
               FROM [EDGE].RPLItemBrand p2  
  
               WHERE p2.ItemID = p1.ItemID  
                
  
               ORDER BY BrandName  
  
               FOR XML PATH(''), TYPE).value('.', 'varchar(max)')  
  
            ,1,1,'')  
  
       AS BrandName  
  
      FROM EDGE.RPLItem p1   where   p1.ModifiedDateUTC >=@timerjob   ---@ROUTEDATE  
  
      GROUP BY ItemID ;  
  
update  a  
set  a.BrandName=b.BrandName  
from #displaydata a inner join #working1 b  
on a.ItemID=b.ItemID  
  
  
select ProgramNumber,StartDate,ItemID,EndDate,AccountName,ChannelName,AttachmentID,FileName,PhysicalFile,BrandName  
from #displaydata  
  
  
  
end   
  
GO
/****** Object:  StoredProcedure [PlayBook].[pExportPromotionToExcel]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROC [PlayBook].[pExportPromotionToExcel]
 @StartDate Date = '2013-05-13',
 @EndDate Date = '2013-05-19'  ,
 @CurrentScope varchar(20) = 'Region',
 @currentuser varchar(20)  = 'KUMVX014',          
 @Buid int = 9,
 @areaid int = 4,
 @Branchid int = 46      
as        
BEGIN              
               
 SET NOCOUNT ON;              
            
-- Personalization for Trademark            
            
CREATE TABLE #PromotionBrandid(BrandidTemp int)            
            
CREATE TABLE #PromotionBrand(Promoid int)            
            
CREATE TABLE #PromotionNationalid(NationalidTemp int)            
            
CREATE TABLE #PromotionRegionalid(RegionalidTemp int)            
            
CREATE TABLE #PromotionLocalid(LocalidTemp int)            
        
create table #promotionNatlAccount(NationalidTemp1 int)        
        
create table #promotionRegAccount (RegionalidTemp1 int)        
        
create table #promotionLocalAccount (LocalidTemp1 int)        
        
            
if (@CurrentScope='BU')            
BEGIN            
insert into #PromotionBrandid            
select distinct TradeMarkID from [Portal_Data].[Person].[UserBranchTradeMark] where userinBranchid in (SELECT  distinct primaryBranchid            
  FROM [Portal_Data].[Person].[UserProfile] where buid=@Buid)            
            
insert into #promotionbrand            
select distinct a.promotionid from Portal_Data.playbook.promotionbrand as a join #PromotionBrandid as b on a.brandid=b.brandidTemp            
            
end            
            
if (@CurrentScope='Area' OR @CurrentScope='Region')            
BEGIN            
insert into #PromotionBrandid            
select distinct TradeMarkID from [Portal_Data].[Person].[UserBranchTradeMark] where userinBranchid in (SELECT  distinct primarybranchid            
  FROM [Portal_Data].[Person].[UserProfile] where areaid=@areaid)            
            
insert into #promotionbrand            
select distinct a.promotionid from Portal_Data.playbook.promotionbrand as a join #PromotionBrandid as b on a.brandid=b.brandidTemp            
end            
            
if (@CurrentScope='Branch')            
BEGIN            
insert into #PromotionBrandid            
select distinct TradeMarkID from [Portal_Data].[Person].[UserBranchTradeMark] where userinBranchid in (SELECT distinct branchid            
  FROM [Portal_Data].[Person].[UserInBranch] where GSN=@currentuser)            
            
insert into #promotionbrand            
select distinct a.promotionid from Portal_Data.playbook.promotionbrand as a join #PromotionBrandid as b on a.brandid=b.brandidTemp            
            
end            
            
        
            
if (@CurrentScope='BU')            
BEGIN            
insert into #PromotionNationalid            
select distinct nationalchainid  from mview.locationchain where buid=@Buid            
insert into #PromotionRegionalid            
select distinct regionalchainid  from mview.locationchain where buid=@Buid            
insert into #PromotionLocalid            
select distinct localchainid  from mview.locationchain where buid=@Buid            
end            
            
if (@CurrentScope='Area' OR @CurrentScope='Region')            
BEGIN            
insert into #PromotionNationalid            
select distinct nationalchainid  from mview.locationchain where regionid=@areaid            
insert into #PromotionRegionalid            
select distinct regionalchainid  from mview.locationchain where regionid=@areaid            
insert into #PromotionLocalid            
select distinct localchainid  from mview.locationchain where regionid=@areaid            
end            
            
if (@CurrentScope='Branch')            
BEGIN            
insert into #PromotionNationalid            
select distinct nationalchainid  from mview.locationchain where branchid in (SELECT distinct branchid            
  FROM [Portal_Data].[Person].[UserInBranch] where GSN=@currentuser)            
            
insert into #PromotionRegionalid            
select distinct regionalchainid  from mview.locationchain where branchid in (SELECT distinct branchid            
  FROM [Portal_Data].[Person].[UserInBranch] where GSN=@currentuser)            
            
insert into #PromotionLocalid            
select distinct localchainid  from mview.locationchain where branchid in (SELECT distinct branchid            
  FROM [Portal_Data].[Person].[UserInBranch] where GSN=@currentuser)            
            
end            
        
insert into #promotionNatlAccount            
select distinct a.promotionid from Portal_Data.playbook.promotionaccount as a join #PromotionNationalid as b on a.nationalchainid=b.NationalidTemp        
        
insert into #promotionRegAccount            
select distinct a.promotionid from Portal_Data.playbook.promotionaccount as a join #PromotionRegionalid as b on a.regionalchainid=b.RegionalidTemp        
        
insert into #promotionLocalAccount            
select distinct a.promotionid from Portal_Data.playbook.promotionaccount as a join #PromotionLocalid as b on a.localchainid=b.LocalidTemp        
         
BEGIN            
SELECT retail.PromotionID,              
  retail.PromotionStatusID, 
  retail.IsLocalized,
  retail.EDGEItemID,
  retail.ParentPromotionID,   
  retail.CreatedBy,
  promoRank.Rank 'PromotionRank',       
  promoType.PromotionType,
  promoType.PromotionTypeId,            
  retail.PromotionName, 
  displaylocation.DisplaylocationName,             
  retail.PromotionPrice,              
  promoRank.PromotionWeekStart as PromotionStartDate,              
  promoRank.PromotionWeekEnd as PromotionEndDate,              
  stat.StatusName,              
  category.ShortPromotionCategoryName AS 'PromotionCategory',              
  STUFF((SELECT DISTINCT '| ' + attachment.AttachmentName + ';' + attachment.AttachmentURL              
              FROM PlayBook.PromotionAttachment AS attachment              
              WHERE attachment.PromotionId = retail.PromotionID              
              FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'') as AttachmentsName,              
        STUFF((SELECT DISTINCT ' | ' + trademark.TradeMarkName              
              FROM SAP.TradeMark as trademark              
              WHERE trademark.TradeMarkID IN (  select _brand.BrandID from PlayBook.PromotionBrand AS _brand where _brand.PromotionID = retail.PromotionID /*and _brand.BrandID in(select BrandidTemp from #PromotionBrandid)*/)              
              FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'') AS PromotionBrands,              
        STUFF((SELECT DISTINCT ' | ' + package.PackageName              
              FROM SAP.Package as package              
              WHERE package.PackageID IN ( select _package.PromotionPackageID from PlayBook.PromotionPackage AS _package where _package.PromotionID = retail.PromotionID)              
              FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'') AS PromotionPackages,              
        CASE WHEN retail.PromotionTypeID = 3 THEN _local.LocalChainName              
    WHEN retail.PromotionTypeID = 1 THEN _regional.RegionalChainName              
    WHEN retail.PromotionTypeID = 2 THEN _national.NationalChainName              
    END AS AccountName,              
  CASE WHEN retail.PromotionTypeID = 3 THEN account.LocalChainID              
    WHEN retail.PromotionTypeID = 1 THEN account.RegionalChainID              
    WHEN retail.PromotionTypeID = 2 THEN account.NationalChainID              
    END AS AccountID   
--INTO #tempPromtionalData         
FROM PlayBook.RetailPromotion AS retail            
INNER JOIN PlayBook.Status AS stat ON retail.PromotionStatusID = stat.StatusID              
INNER JOIN PlayBook.PromotionCategory AS category ON retail.PromotionCategoryID = category.PromotionCategoryID              
INNER JOIN Playbook.PromotionDisplayLocation AS promoDisplayLocation on retail.PromotionId=promoDisplayLocation.PromotionId
INNER JOIN Playbook.DisplayLocation AS displaylocation on promoDisplayLocation.DisplaylocationId=displaylocation.DisplaylocationId
INNER JOIN PlayBook.PromotionAccount AS account ON retail.PromotionID = account.PromotionID               
INNER JOIN  PlayBook.PromotionRank AS promoRank ON promoRank.PromotionID = retail.PromotionID              
INNER JOIN PlayBook.PromotionType promoType ON promoType.PromotionTypeID = retail.PromotionTypeID      
LEFT OUTER JOIN SAP.LocalChain AS _local ON _local.LocalChainID = account.LocalChainID  
LEFT OUTER JOIN SAP.RegionalChain AS _regional ON _regional.RegionalChainID = account.RegionalChainID 
LEFT OUTER JOIN SAP.NationalChain AS _national ON _national.NationalChainID = account.NationalChainID 
WHERE retail.PromotionStartDate BETWEEN @StartDate AND @EndDate


END
DROP TABLE #PromotionBrandid 
DROP TABLE #PromotionBrand 
DROP TABLE #PromotionNationalid
DROP TABLE #PromotionRegionalid
DROP TABLE #PromotionLocalid 
DROP table #promotionNatlAccount 
DROP table #promotionRegAccount 
DROP table #promotionLocalAccount
END

GO
/****** Object:  StoredProcedure [PlayBook].[pGetLatestPromotions]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================        
-- Author  : Sumit Kanchan        
-- Create date : 06/May/2013        
-- Description : This procedure will get all the lates promotions        
-- =============================================        
CREATE PROCEDURE [PlayBook].[pGetLatestPromotions]        
 @LastLogin DateTime,        
 @CurrentScope varchar(20),        
 @currentuser varchar(20)  ,            
 @Buid int,        
 @areaid int,        
 @Branchid int        
AS        
BEGIN                
                 
 SET NOCOUNT ON; 
          
SELECT DISTINCT retail.PromotionID,                
  retail.PromotionStatusID,          
  retail.PromotionName,                
  retail.PromotionPrice,                
  retail.PromotionStartDate,                
  retail.PromotionEndDate,            
  retail.CreatedDate,        
  retail.ModifiedDate,            
  stat.StatusName as 'PromotionStatus',                 
        STUFF((SELECT DISTINCT ' | ' + trademark.TradeMarkName                
              FROM SAP.TradeMark as trademark                
              WHERE trademark.TradeMarkID IN (  select _brand.BrandID from PlayBook.PromotionBrand AS _brand where _brand.PromotionID = retail.PromotionID /*and _brand.BrandID in(select BrandidTemp from #PromotionBrandid)*/)                
              FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'') AS PromotionBrands,                
        STUFF((SELECT DISTINCT ' | ' + package.PackageName                
              FROM SAP.Package as package                
              WHERE package.PackageID IN ( select _package.PromotionPackageID from PlayBook.PromotionPackage AS _package where _package.PromotionID = retail.PromotionID)                
              FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'') AS PromotionPackages,                
        CASE WHEN retail.PromotionTypeID = 3 THEN _local.LocalChainName                
   WHEN retail.PromotionTypeID = 1 THEN _regional.RegionalChainName                
   WHEN retail.PromotionTypeID = 2 THEN _national.NationalChainName                
   END AS AccountName,                
  CASE WHEN retail.PromotionTypeID = 3 THEN account.LocalChainID                
   WHEN retail.PromotionTypeID = 1 THEN account.RegionalChainID                
   WHEN retail.PromotionTypeID = 2 THEN account.NationalChainID                
   END AS AccountID                
FROM PlayBook.RetailPromotion AS retail              
INNER JOIN PlayBook.Status AS stat ON retail.PromotionStatusID = stat.StatusID          
INNER JOIN PlayBook.PromotionAccount AS account ON retail.PromotionID = account.PromotionID                 
INNER JOIN PlayBook.PromotionType promoType ON promoType.PromotionTypeID = retail.PromotionTypeID        
LEFT OUTER JOIN SAP.LocalChain AS _local ON _local.LocalChainID = account.LocalChainID  -- and _local.LocalChainID in (select LocalidTemp from #PromotionLocalid)              
LEFT OUTER JOIN SAP.RegionalChain AS _regional ON _regional.RegionalChainID = account.RegionalChainID -- and _regional.RegionalChainID in (select RegionalidTemp from #PromotionRegionalid)              
LEFT OUTER JOIN SAP.NationalChain AS _national ON _national.NationalChainID = account.NationalChainID --and _national.NationalChainID in (select NationalidTemp from #PromotionNationalid)              
WHERE          
( retail.CreatedDate > @LastLogin OR retail.ModifiedDate > @LastLogin)     
AND retail.PromotionBUID = @Buid 

-- For promotions that are not from EDGE      
SELECT *       
INTO #PlayBookPromtoionsList      
FROM #tempPromtionalDataList      
Where EDGEItemID IS NULL  -- Should not be a EDGE Promotion      
      
      
-- For promotions which are from EDGE and are Localized      
SELECT *       
INTO #EDGELocalizedPromotionsList      
FROM #tempPromtionalDataList      
WHERE IsLocalized = 1      -- Should be a localized      
AND EDGEItemID IS NOT NULL     -- Must have an EDGE Item ID      
AND ParentPromotionID IS NOT NULL      
      
-- For promotions which are from EDGE and are not localized (Parent)      
SELECT *       
INTO #EDGEPromotionsList      
FROM #tempPromtionalDataList      
WHERE (IsLocalized = 0 OR IsLocalized IS NULL)           -- Should not be localized      
AND EDGEItemID IS NOT NULL                -- Must have an EDGE Item ID      
AND PromotionID NOT IN (SELECT ParentPromotionID FROM #EDGELocalizedPromotionsList)  -- Should not include which have been localized      
      
      
Insert Into #PlayBookPromtoionsList Select * from #EDGELocalizedPromotionsList  --insert in a table to return a single table  
Insert Into #PlayBookPromtoionsList Select * from #EDGEPromotionsList    --insert in a table to return a single table  
      
Select * from #PlayBookPromtoionsList    
    
END 
GO
/****** Object:  StoredProcedure [PlayBook].[pGetPlayBookDetailsByDate]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                      
-- =============================================                      
-- Author:  HCL Team                      
-- Create date: 11/April/2013                      
-- Description: This procedure will get all the promotions for the date Range. This procedure joins all promotion tables and fetch the promotion data.                      
--Example : exec [PlayBook].[pGetPlayBookDetailsByDate]  '2013-04-22', '2013-05-28', 'true' ,'BU','KANSX031',11,9,116  
-- =============================================                      
CREATE PROCEDURE [PlayBook].[pGetPlayBookDetailsByDate]                         
 @StartDate Date,                   -- Promotion Start date    
 @EndDate Date,      -- Promotion End Date    
 @IsCalendarView bit,               -- Flag for Calendar view and List View    
 @CurrentScope varchar(20),         -- Current user location scope           
 @currentuser varchar(20),          -- Current user location scope                 
 @Buid int,       -- Current user BUID                 
 @areaid int,      -- Current user Area ID                 
 @Branchid int      -- Current user Branch ID                 
AS                        
BEGIN                        
                         
SET NOCOUNT ON;                        
                  
if @IsCalendarView = 1                      
BEGIN                      
SELECT DISTINCT retail.PromotionID,                        
  retail.PromotionStatusID,         
  retail.IsLocalized,      
  retail.EDGEItemID,      
  retail.ParentPromotionID,                         
  1 as PromotionRank,                  
  promoType.PromotionType,                     
  retail.PromotionName,                        
  retail.PromotionPrice,                        
  retail.PromotionStartDate,                        
  retail.PromotionEndDate,                        
  stat.StatusName,                        
  category.ShortPromotionCategoryName AS 'PromotionCategory',                        
  STUFF((SELECT DISTINCT '| ' + attachment.AttachmentName + ';' + attachment.AttachmentURL                        
              FROM PlayBook.PromotionAttachment AS attachment                        
              WHERE attachment.PromotionId = retail.PromotionID                        
              FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'') as AttachmentsName,                        
        STUFF((SELECT DISTINCT ' | ' + trademark.TradeMarkName                        
              FROM SAP.TradeMark as trademark                        
              WHERE trademark.TradeMarkID IN ( select _brand.BrandID from PlayBook.PromotionBrand AS _brand where _brand.PromotionID = retail.PromotionID /*and _brand.BrandID in(select BrandidTemp from #PromotionBrandid)*/)                        
             -- WHERE trademark.TradeMarkID IN ( select _brand.BrandID from PlayBook.PromotionBrand AS _brand where _brand.BrandID in(select BrandidTemp from #PromotionBrandid))                        
     FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'') AS PromotionBrands,                        
        STUFF((SELECT DISTINCT ' | ' + package.PackageName                        
              FROM SAP.Package as package                        
              WHERE package.PackageID IN ( select _package.PromotionPackageID from PlayBook.PromotionPackage AS _package where _package.PromotionID = retail.PromotionID)                        
              FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'') AS PromotionPackages,                        
        CASE WHEN retail.PromotionTypeID = 3 THEN _local.LocalChainName           
    WHEN retail.PromotionTypeID = 1 THEN _regional.RegionalChainName                        
    WHEN retail.PromotionTypeID = 2 THEN _national.NationalChainName                        
    END AS AccountName,                        
  CASE WHEN retail.PromotionTypeID = 3 THEN account.LocalChainID                        
    WHEN retail.PromotionTypeID = 1 THEN account.RegionalChainID                        
    WHEN retail.PromotionTypeID = 2 THEN account.NationalChainID                        
    END AS AccountID                         
INTO #tempPromtionalDataCaledar                     
FROM PlayBook.RetailPromotion AS retail                       
--inner join #promotionbrand as Brandtemp on retail.PromotionID = Brandtemp.PromoID                         
INNER JOIN PlayBook.Status AS stat ON retail.PromotionStatusID = stat.StatusID                        
INNER JOIN PlayBook.PromotionCategory AS category ON retail.PromotionCategoryID = category.PromotionCategoryID                        
INNER JOIN PlayBook.PromotionAccount AS account ON retail.PromotionID = account.PromotionID                         
INNER JOIN  PlayBook.PromotionRank AS promoRank ON promoRank.PromotionID = retail.PromotionID                         
INNER JOIN PlayBook.PromotionType promoType ON promoType.PromotionTypeID = retail.PromotionTypeID                      
LEFT OUTER JOIN SAP.LocalChain AS _local ON _local.LocalChainID = account.LocalChainID     
LEFT OUTER JOIN SAP.RegionalChain AS _regional ON _regional.RegionalChainID = account.RegionalChainID     
LEFT OUTER JOIN SAP.NationalChain AS _national ON _national.NationalChainID = account.NationalChainID     
WHERE     
(@StartDate BETWEEN retail.PromotionStartDate AND retail.PromotionEndDate                       
OR retail.PromotionStartDate BETWEEN @StartDate AND @EndDate)   
AND retail.PromotionBUID = @Buid  
        
-- For promotions that are not from EDGE      
SELECT *       
INTO #PlayBookPromtoionsCalendar      
FROM #tempPromtionalDataCaledar      
Where EDGEItemID IS NULL  -- Should not be a EDGE Promotion      
  
-- For promotions which are from EDGE and are Localized      
SELECT *       
INTO #EDGELocalizedPromotions      
FROM #tempPromtionalDataCaledar      
WHERE IsLocalized = 1      -- Should be a localized      
AND EDGEItemID IS NOT NULL     -- Must have an EDGE Item ID      
AND ParentPromotionID IS NOT NULL      
      
-- For promotions which are from EDGE and are not localized (Parent)      
SELECT *       
INTO #EDGEPromotions      
FROM #tempPromtionalDataCaledar      
WHERE (ISLocalized = 0 OR IsLocalized = NULL)          -- Should not be localized      
AND EDGEItemID IS NOT NULL               -- Must have an EDGE Item ID      
AND PromotionID NOT IN (SELECT ParentPromotionID FROM #EDGELocalizedPromotions)  -- Should not include which have been localized      
      
Insert Into #PlayBookPromtoionsCalendar Select * from #EDGELocalizedPromotions      
Insert Into #PlayBookPromtoionsCalendar Select * from #EDGEPromotions      
      
Select * from #PlayBookPromtoionsCalendar    
END                        
                      
ELSE                      
BEGIN                      
SELECT DISTINCT retail.PromotionID,                        
  retail.PromotionStatusID,         
  retail.IsLocalized,      
  retail.EDGEItemID,      
  retail.ParentPromotionID,              
  retail.CreatedBy,                         
  promoRank.Rank 'PromotionRank',                 
  promoType.PromotionType,                     
  retail.PromotionName,                        
  retail.PromotionPrice,                        
  retail.PromotionStartDate,                        
  retail.PromotionEndDate,                        
  stat.StatusName,                        
  category.ShortPromotionCategoryName AS 'PromotionCategory',                        
  STUFF((SELECT DISTINCT '| ' + attachment.AttachmentName + ';' + attachment.AttachmentURL                        
              FROM PlayBook.PromotionAttachment AS attachment                        
              WHERE attachment.PromotionId = retail.PromotionID                        
              FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'') as AttachmentsName,                        
        STUFF((SELECT DISTINCT ' | ' + trademark.TradeMarkName                        
      FROM SAP.TradeMark as trademark                        
              WHERE trademark.TradeMarkID IN (  select _brand.BrandID from PlayBook.PromotionBrand AS _brand where _brand.PromotionID = retail.PromotionID /*and _brand.BrandID in(select BrandidTemp from #PromotionBrandid)*/)                        
              FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'') AS PromotionBrands,                        
        STUFF((SELECT DISTINCT ' | ' + package.PackageName                        
              FROM SAP.Package as package                        
              WHERE package.PackageID IN ( select _package.PromotionPackageID from PlayBook.PromotionPackage AS _package where _package.PromotionID = retail.PromotionID)                        
    FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'') AS PromotionPackages,                        
        CASE WHEN retail.PromotionTypeID = 3 THEN _local.LocalChainName                        
    WHEN retail.PromotionTypeID = 1 THEN _regional.RegionalChainName                        
    WHEN retail.PromotionTypeID = 2 THEN _national.NationalChainName                        
    END AS AccountName,                        
  CASE WHEN retail.PromotionTypeID = 3 THEN account.LocalChainID                        
    WHEN retail.PromotionTypeID = 1 THEN account.RegionalChainID                        
    WHEN retail.PromotionTypeID = 2 THEN account.NationalChainID                        
    END AS AccountID           
INTO #tempPromtionalDataList                  
FROM PlayBook.RetailPromotion AS retail                      
INNER JOIN PlayBook.Status AS stat ON retail.PromotionStatusID = stat.StatusID                        
INNER JOIN PlayBook.PromotionCategory AS category ON retail.PromotionCategoryID = category.PromotionCategoryID                        
INNER JOIN PlayBook.PromotionAccount AS account ON retail.PromotionID = account.PromotionID                         
INNER JOIN  PlayBook.PromotionRank AS promoRank ON promoRank.PromotionID = retail.PromotionID                        
INNER JOIN PlayBook.PromotionType promoType ON promoType.PromotionTypeID = retail.PromotionTypeID                
LEFT OUTER JOIN SAP.LocalChain AS _local ON _local.LocalChainID = account.LocalChainID     
LEFT OUTER JOIN SAP.RegionalChain AS _regional ON _regional.RegionalChainID = account.RegionalChainID    
LEFT OUTER JOIN SAP.NationalChain AS _national ON _national.NationalChainID = account.NationalChainID    
WHERE     
(@StartDate BETWEEN retail.PromotionStartDate AND retail.PromotionEndDate OR       
retail.PromotionStartDate BETWEEN @StartDate AND @EndDate)                     
AND promoRank.PromotionWeekStart = @StartDate  
AND retail.PromotionBUID = @Buid
  
     
-- For promotions that are not from EDGE      
SELECT *       
INTO #PlayBookPromtoionsList      
FROM #tempPromtionalDataList      
Where EDGEItemID IS NULL  -- Should not be a EDGE Promotion      
      
      
-- For promotions which are from EDGE and are Localized      
SELECT *       
INTO #EDGELocalizedPromotionsList      
FROM #tempPromtionalDataList      
WHERE IsLocalized = 1      -- Should be a localized      
AND EDGEItemID IS NOT NULL     -- Must have an EDGE Item ID      
AND ParentPromotionID IS NOT NULL      
      
-- For promotions which are from EDGE and are not localized (Parent)      
SELECT *       
INTO #EDGEPromotionsList      
FROM #tempPromtionalDataList      
WHERE (IsLocalized = 0 OR IsLocalized IS NULL)           -- Should not be localized      
AND EDGEItemID IS NOT NULL                -- Must have an EDGE Item ID      
AND PromotionID NOT IN (SELECT ParentPromotionID FROM #EDGELocalizedPromotionsList)  -- Should not include which have been localized      
      
      
Insert Into #PlayBookPromtoionsList Select * from #EDGELocalizedPromotionsList  --insert in a table to return a single table  
Insert Into #PlayBookPromtoionsList Select * from #EDGEPromotionsList    --insert in a table to return a single table  
      
Select * from #PlayBookPromtoionsList    
END                      
END 
GO
/****** Object:  StoredProcedure [PlayBook].[pGetPlayBookDetailsByDate_LocalVersion]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                  
-- =============================================                    
-- Author:  Sumit Kanchan                    
-- Create date: 11/April/2013                    
-- Description: This procedure will get all the promotions for the date provided                     
--                   
-- exec [PlayBook].[pGetPlayBookDetailsByDate]  '2013-04-22', '2013-05-28', 'true' ,'Region','KUMVX014',9,10,46                 
-- exec [PlayBook].[pGetPlayBookDetailsByDate]  '2013-04-15', '2013-04-21'                    
--                     
--                    
-- =============================================                    
CREATE PROCEDURE [PlayBook].[pGetPlayBookDetailsByDate_LocalVersion]                     
 @StartDate Date,                    
 @EndDate Date,                  
 @IsCalendarView bit,                  
 @CurrentScope varchar(20),                  
 @currentuser varchar(20),                  
 @Buid int,                  
 @areaid int,                  
 @Branchid int                  
AS                    
BEGIN                    
                     
 SET NOCOUNT ON;                    
                  
-- Personalization for Trademark                  
                  
CREATE TABLE #PromotionBrandid(BrandidTemp int)                  
                  
CREATE TABLE #PromotionBrand(Promoid int)                  
                  
CREATE TABLE #PromotionNationalid(NationalidTemp int)                  
                  
CREATE TABLE #PromotionRegionalid(RegionalidTemp int)                  
                  
CREATE TABLE #PromotionLocalid(LocalidTemp int)                  
              
create table #promotionNatlAccount(NationalidTemp1 int)              
              
create table #promotionRegAccount (RegionalidTemp1 int)              
              
create table #promotionLocalAccount (LocalidTemp1 int)              
              
                  
if (@CurrentScope='BU')                  
BEGIN                  
insert into #PromotionBrandid                  
select distinct trademarkid from mview.branchbrand where buid=@Buid                  
insert into #promotionbrand                  
select distinct a.promotionid from Portal_Data.playbook.promotionbrand as a join #PromotionBrandid as b on a.trademarkid=b.brandidTemp                  
                  
end                  
                  
if (@CurrentScope='Area' OR @CurrentScope='Region')                  
BEGIN                  
insert into #PromotionBrandid                  
select distinct trademarkid from mview.branchbrand where regionid=@areaid        
                  
insert into #promotionbrand                  
select distinct a.promotionid from Portal_Data.playbook.promotionbrand as a join #PromotionBrandid as b on a.trademarkid=b.brandidTemp                  
end                  
                  
if (@CurrentScope='Branch')                  
BEGIN                  
insert into #PromotionBrandid                  
select distinct trademarkid from [Portal_Data].[Person].[UserBranchTradeMark] where userinBranchid in (SELECT distinct branchid                  
  FROM [Portal_Data].[Person].[UserInBranch] where GSN=@currentuser)                  
                  
insert into #promotionbrand                  
select distinct a.promotionid from Portal_Data.playbook.promotionbrand as a join #PromotionBrandid as b on a.brandid=b.brandidTemp                  
                  
end                  
                  
              
                  
if (@CurrentScope='BU')                  
BEGIN                  
insert into #PromotionNationalid                  
select distinct nationalchainid  from mview.locationchain where buid=@Buid                  
insert into #PromotionRegionalid                  
select distinct regionalchainid  from mview.locationchain where buid=@Buid                  
insert into #PromotionLocalid                  
select distinct localchainid  from mview.locationchain where buid=@Buid                  
end                  
                  
if (@CurrentScope='Area' OR @CurrentScope='Region')                  
BEGIN                  
insert into #PromotionNationalid                  
select distinct nationalchainid  from mview.locationchain where regionid=@areaid                  
insert into #PromotionRegionalid                  
select distinct regionalchainid  from mview.locationchain where regionid=@areaid                  
insert into #PromotionLocalid                  
select distinct localchainid  from mview.locationchain where regionid=@areaid                  
end                  
                  
if (@CurrentScope='Branch')                  
BEGIN                  
insert into #PromotionNationalid                  
select distinct nationalchainid  from mview.locationchain where branchid in (SELECT distinct branchid                  
  FROM [Portal_Data].[Person].[UserInBranch] where GSN=@currentuser)                  
                  
insert into #PromotionRegionalid                  
select distinct regionalchainid  from mview.locationchain where branchid in (SELECT distinct branchid                  
  FROM [Portal_Data].[Person].[UserInBranch] where GSN=@currentuser)                  
                  
insert into #PromotionLocalid                  
select distinct localchainid  from mview.locationchain where branchid in (SELECT distinct branchid                  
  FROM [Portal_Data].[Person].[UserInBranch] where GSN=@currentuser)                  
                  
end                  
              
insert into #promotionNatlAccount                  
select distinct a.promotionid from Portal_Data.playbook.promotionaccount as a join #PromotionNationalid as b on a.nationalchainid=b.NationalidTemp              
              
insert into #promotionRegAccount                  
select distinct a.promotionid from Portal_Data.playbook.promotionaccount as a join #PromotionRegionalid as b on a.regionalchainid=b.RegionalidTemp              
              
insert into #promotionLocalAccount                  
select distinct a.promotionid from Portal_Data.playbook.promotionaccount as a join #PromotionLocalid as b on a.localchainid=b.LocalidTemp              
              
              
if @IsCalendarView = 1                  
BEGIN                  
SELECT DISTINCT retail.PromotionID,                    
  retail.PromotionStatusID,    
  retail.IsLocalized,  
  retail.EDGEItemID,  
  retail.ParentPromotionID,         
  retail.CreatedBy,                      
  1 as PromotionRank,              
  promoType.PromotionType,                 
  retail.PromotionName,                    
  retail.PromotionPrice,                    
  retail.PromotionStartDate,                    
  retail.PromotionEndDate,                    
  stat.StatusName,                    
  category.ShortPromotionCategoryName AS 'PromotionCategory',                    
  STUFF((SELECT DISTINCT '| ' + attachment.AttachmentName + ';' + attachment.AttachmentURL                    
              FROM PlayBook.PromotionAttachment AS attachment                    
              WHERE attachment.PromotionId = retail.PromotionID                    
              FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'') as AttachmentsName,                    
        STUFF((SELECT DISTINCT ' | ' + trademark.TradeMarkName                    
              FROM SAP.TradeMark as trademark                    
              WHERE trademark.TradeMarkID IN ( select _brand.BrandID from PlayBook.PromotionBrand AS _brand where _brand.PromotionID = retail.PromotionID /*and _brand.BrandID in(select BrandidTemp from #PromotionBrandid)*/)                    
             -- WHERE trademark.TradeMarkID IN ( select _brand.BrandID from PlayBook.PromotionBrand AS _brand where _brand.BrandID in(select BrandidTemp from #PromotionBrandid))                    
     FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'') AS PromotionBrands,                    
        STUFF((SELECT DISTINCT ' | ' + package.PackageName                    
              FROM SAP.Package as package                    
              WHERE package.PackageID IN ( select _package.PromotionPackageID from PlayBook.PromotionPackage AS _package where _package.PromotionID = retail.PromotionID)                    
              FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'') AS PromotionPackages,                    
        CASE WHEN retail.PromotionTypeID = 3 THEN _local.LocalChainName       
    WHEN retail.PromotionTypeID = 1 THEN _regional.RegionalChainName                    
    WHEN retail.PromotionTypeID = 2 THEN _national.NationalChainName                    
    END AS AccountName,                    
  CASE WHEN retail.PromotionTypeID = 3 THEN account.LocalChainID                    
    WHEN retail.PromotionTypeID = 1 THEN account.RegionalChainID                    
    WHEN retail.PromotionTypeID = 2 THEN account.NationalChainID                    
    END AS AccountID                  
INTO #tempPromtionalDataCaledar  
FROM PlayBook.RetailPromotion AS retail                   
--inner join #promotionbrand as Brandtemp on retail.PromotionID = Brandtemp.PromoID                     
INNER JOIN PlayBook.Status AS stat ON retail.PromotionStatusID = stat.StatusID                    
INNER JOIN PlayBook.PromotionCategory AS category ON retail.PromotionCategoryID = category.PromotionCategoryID                    
INNER JOIN PlayBook.PromotionAccount AS account ON retail.PromotionID = account.PromotionID                     
INNER JOIN  PlayBook.PromotionRank AS promoRank ON promoRank.PromotionID = retail.PromotionID                     
INNER JOIN PlayBook.PromotionType promoType ON promoType.PromotionTypeID = retail.PromotionTypeID                  
LEFT OUTER JOIN SAP.LocalChain AS _local ON _local.LocalChainID = account.LocalChainID   --and _local.LocalChainID in (select LocalidTemp from #PromotionLocalid)                  
LEFT OUTER JOIN SAP.RegionalChain AS _regional ON _regional.RegionalChainID = account.RegionalChainID  --and _regional.RegionalChainID in (select RegionalidTemp from #PromotionRegionalid)                  
LEFT OUTER JOIN SAP.NationalChain AS _national ON _national.NationalChainID = account.NationalChainID --and _national.NationalChainID in (select NationalidTemp from #PromotionNationalid)                  
WHERE ( retail.PromotionID in( select NationalidTemp1 from #promotionNatlAccount) or               
retail.PromotionID in( select RegionalidTemp1 from #promotionRegAccount) or retail.PromotionID in( select localidTemp1 from #promotionLocalAccount)) and retail.PromotionID in(select promoid from #promotionbrand)  and           
(@StartDate BETWEEN retail.PromotionStartDate AND retail.PromotionEndDate                   
OR retail.PromotionStartDate BETWEEN @StartDate AND @EndDate)         
  
-- For promotions that are not from EDGE  
SELECT *   
INTO #PlayBookPromtoionsCalendar  
FROM #tempPromtionalDataCaledar  
Where EDGEItemID IS NULL  -- Should not be a EDGE Promotion  
  
  
-- For promotions which are from EDGE and are Localized  
SELECT *   
INTO #EDGELocalizedPromotions  
FROM #tempPromtionalDataCaledar  
WHERE IsLocalized = 1      -- Should be a localized  
AND EDGEItemID IS NOT NULL     -- Must have an EDGE Item ID  
AND ParentPromotionID IS NOT NULL  
  
-- For promotions which are from EDGE and are not localized (Parent)  
SELECT *   
INTO #EDGEPromotions  
FROM #tempPromtionalDataCaledar  
WHERE (ISLocalized = 0 OR IsLocalized = NULL)          -- Should not be localized  
AND EDGEItemID IS NOT NULL               -- Must have an EDGE Item ID  
AND PromotionID NOT IN (SELECT ParentPromotionID FROM #EDGELocalizedPromotions)  -- Should not include which have been localized  
  
Insert Into #PlayBookPromtoionsCalendar Select * from #EDGELocalizedPromotions  
Insert Into #PlayBookPromtoionsCalendar Select * from #EDGEPromotions  
  
Select * from #PlayBookPromtoionsCalendar           
END                    
                  
ELSE                  
BEGIN                  
SELECT DISTINCT retail.PromotionID,                    
  retail.PromotionStatusID,    
  retail.IsLocalized,  
  retail.EDGEItemID,  
  retail.ParentPromotionID,         
  retail.CreatedBy,                     
  promoRank.Rank 'PromotionRank',             
  promoType.PromotionType,                 
  retail.PromotionName,                    
  retail.PromotionPrice,                    
  retail.PromotionStartDate,                    
  retail.PromotionEndDate,                    
  stat.StatusName,                    
  category.ShortPromotionCategoryName AS 'PromotionCategory',                    
  STUFF((SELECT DISTINCT '| ' + attachment.AttachmentName + ';' + attachment.AttachmentURL                    
              FROM PlayBook.PromotionAttachment AS attachment                    
              WHERE attachment.PromotionId = retail.PromotionID                    
              FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'') as AttachmentsName,                    
        STUFF((SELECT DISTINCT ' | ' + trademark.TradeMarkName                    
              FROM SAP.TradeMark as trademark                    
              WHERE trademark.TradeMarkID IN (  select _brand.BrandID from PlayBook.PromotionBrand AS _brand where _brand.PromotionID = retail.PromotionID /*and _brand.BrandID in(select BrandidTemp from #PromotionBrandid)*/)                    
              FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'') AS PromotionBrands,                    
        STUFF((SELECT DISTINCT ' | ' + package.PackageName                    
              FROM SAP.Package as package                    
              WHERE package.PackageID IN ( select _package.PromotionPackageID from PlayBook.PromotionPackage AS _package where _package.PromotionID = retail.PromotionID)                    
    FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'') AS PromotionPackages,                    
        CASE WHEN retail.PromotionTypeID = 3 THEN _local.LocalChainName                    
    WHEN retail.PromotionTypeID = 1 THEN _regional.RegionalChainName                    
    WHEN retail.PromotionTypeID = 2 THEN _national.NationalChainName                    
    END AS AccountName,                    
  CASE WHEN retail.PromotionTypeID = 3 THEN account.LocalChainID                    
    WHEN retail.PromotionTypeID = 1 THEN account.RegionalChainID                    
    WHEN retail.PromotionTypeID = 2 THEN account.NationalChainID                    
    END AS AccountID     
INTO #tempPromtionalDataList               
FROM PlayBook.RetailPromotion AS retail                  
--inner join #promotionbrand as Brandtemp on retail.PromotionID = Brandtemp.PromoID                      
INNER JOIN PlayBook.Status AS stat ON retail.PromotionStatusID = stat.StatusID                    
INNER JOIN PlayBook.PromotionCategory AS category ON retail.PromotionCategoryID = category.PromotionCategoryID                    
INNER JOIN PlayBook.PromotionAccount AS account ON retail.PromotionID = account.PromotionID                     
INNER JOIN  PlayBook.PromotionRank AS promoRank ON promoRank.PromotionID = retail.PromotionID                    
INNER JOIN PlayBook.PromotionType promoType ON promoType.PromotionTypeID = retail.PromotionTypeID            
LEFT OUTER JOIN SAP.LocalChain AS _local ON _local.LocalChainID = account.LocalChainID  -- and _local.LocalChainID in (select LocalidTemp from #PromotionLocalid)                  
LEFT OUTER JOIN SAP.RegionalChain AS _regional ON _regional.RegionalChainID = account.RegionalChainID -- and _regional.RegionalChainID in (select RegionalidTemp from #PromotionRegionalid)                  
LEFT OUTER JOIN SAP.NationalChain AS _national ON _national.NationalChainID = account.NationalChainID --and _national.NationalChainID in (select NationalidTemp from #PromotionNationalid)                  
WHERE ( retail.PromotionID in( select NationalidTemp1 from #promotionNatlAccount) or               
retail.PromotionID in( select RegionalidTemp1 from #promotionRegAccount) or retail.PromotionID in( select localidTemp1 from #promotionLocalAccount)) and           
retail.PromotionID in(select promoid from #promotionbrand) and (@StartDate BETWEEN retail.PromotionStartDate AND retail.PromotionEndDate OR   
retail.PromotionStartDate BETWEEN @StartDate AND @EndDate    )              
AND promoRank.PromotionWeekStart = @StartDate      
  
-- For promotions that are not from EDGE  
SELECT *   
INTO #PlayBookPromtoionsList  
FROM #tempPromtionalDataList  
Where EDGEItemID IS NULL  -- Should not be a EDGE Promotion  
  
  
-- For promotions which are from EDGE and are Localized  
SELECT *   
INTO #EDGELocalizedPromotionsList  
FROM #tempPromtionalDataList  
WHERE IsLocalized = 1      -- Should be a localized  
AND EDGEItemID IS NOT NULL     -- Must have an EDGE Item ID  
AND ParentPromotionID IS NOT NULL  
  
-- For promotions which are from EDGE and are not localized (Parent)  
SELECT *   
INTO #EDGEPromotionsList  
FROM #tempPromtionalDataList  
WHERE (IsLocalized = 0 OR IsLocalized IS NULL)           -- Should not be localized  
AND EDGEItemID IS NOT NULL                -- Must have an EDGE Item ID  
AND PromotionID NOT IN (SELECT ParentPromotionID FROM #EDGELocalizedPromotionsList)  -- Should not include which have been localized  
  
  
Insert Into #PlayBookPromtoionsList Select * from #EDGELocalizedPromotionsList  
Insert Into #PlayBookPromtoionsList Select * from #EDGEPromotionsList  
  
Select * from #PlayBookPromtoionsList  
  
END       
END 
GO
/****** Object:  StoredProcedure [PlayBook].[pGetPlayBookDetailsByDate_LocationPersonalization]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
        
-- =============================================          
-- Author:  Sumit Kanchan          
-- Create date: 11/April/2013          
-- Description: This procedure will get all the promotions for the date provided           
--         
-- exec [PlayBook].[pGetPlayBookDetailsByDate]  '2013-04-22', '2013-05-28', 'true' ,'Region','KUMVX014',9,10,46       
-- exec [PlayBook].[pGetPlayBookDetailsByDate]  '2013-04-15', '2013-04-21'          
--           
--          
-- =============================================          
CREATE PROCEDURE [PlayBook].[pGetPlayBookDetailsByDate_LocationPersonalization]           
 @StartDate Date,          
 @EndDate Date,        
 @IsCalendarView bit,        
 @CurrentScope varchar(20),        
 @currentuser varchar(20),        
 @Buid int,        
 @areaid int,        
 @Branchid int        
AS          
BEGIN          
           
 SET NOCOUNT ON;          
        
-- Personalization for Trademark        
        
CREATE TABLE #PromotionBrandid(BrandidTemp int)        
        
CREATE TABLE #PromotionBrand(Promoid int)        
        
CREATE TABLE #PromotionNationalid(NationalidTemp int)        
        
CREATE TABLE #PromotionRegionalid(RegionalidTemp int)        
        
CREATE TABLE #PromotionLocalid(LocalidTemp int)        
    
create table #promotionNatlAccount(NationalidTemp1 int)    
    
create table #promotionRegAccount (RegionalidTemp1 int)    
    
create table #promotionLocalAccount (LocalidTemp1 int)    

create table #promotionGeo (PromotiongeoTemp1 int)  
    
        
if (@CurrentScope='BU')        
BEGIN        
insert into #PromotionBrandid        
select distinct brandid from [Portal_Data].[Person].[UserBranchBrand] where userinBranchid in (SELECT  distinct primaryBranchid        
  FROM [Portal_Data].[Person].[UserProfile] where buid=@Buid)        
        
insert into #promotionbrand        
select distinct a.promotionid from Portal_Data.playbook.promotionbrand as a join #PromotionBrandid as b on a.brandid=b.brandidTemp        
        
end        
        
if (@CurrentScope='Area' OR @CurrentScope='Region')        
BEGIN        
insert into #PromotionBrandid        
select distinct brandid from [Portal_Data].[Person].[UserBranchBrand] where userinBranchid in (SELECT  distinct primarybranchid        
  FROM [Portal_Data].[Person].[UserProfile] where areaid=@areaid)        
        
insert into #promotionbrand        
select distinct a.promotionid from Portal_Data.playbook.promotionbrand as a join #PromotionBrandid as b on a.brandid=b.brandidTemp        
end        
        
if (@CurrentScope='Branch')        
BEGIN        
insert into #PromotionBrandid        
select distinct brandid from [Portal_Data].[Person].[UserBranchBrand] where userinBranchid in (SELECT distinct branchid        
  FROM [Portal_Data].[Person].[UserInBranch] where GSN=@currentuser)        
        
insert into #promotionbrand        
select distinct a.promotionid from Portal_Data.playbook.promotionbrand as a join #PromotionBrandid as b on a.brandid=b.brandidTemp        
        
end        
        
    
        
if (@CurrentScope='BU')        
BEGIN        
insert into #PromotionNationalid        
select distinct nationalchainid  from mview.locationchain where buid=@Buid        
insert into #PromotionRegionalid        
select distinct regionalchainid  from mview.locationchain where buid=@Buid        
insert into #PromotionLocalid        
select distinct localchainid  from mview.locationchain where buid=@Buid        
end        
        
if (@CurrentScope='Area' OR @CurrentScope='Region')        
BEGIN        
insert into #PromotionNationalid        
select distinct nationalchainid  from mview.locationchain where regionid=@areaid        
insert into #PromotionRegionalid        
select distinct regionalchainid  from mview.locationchain where regionid=@areaid        
insert into #PromotionLocalid        
select distinct localchainid  from mview.locationchain where regionid=@areaid        
end        
        
if (@CurrentScope='Branch')        
BEGIN        
insert into #PromotionNationalid        
select distinct nationalchainid  from mview.locationchain where branchid in (SELECT distinct branchid        
  FROM [Portal_Data].[Person].[UserInBranch] where GSN=@currentuser)        
        
insert into #PromotionRegionalid        
select distinct regionalchainid  from mview.locationchain where branchid in (SELECT distinct branchid        
  FROM [Portal_Data].[Person].[UserInBranch] where GSN=@currentuser)        
        
insert into #PromotionLocalid        
select distinct localchainid  from mview.locationchain where branchid in (SELECT distinct branchid        
  FROM [Portal_Data].[Person].[UserInBranch] where GSN=@currentuser)        
        
end     

--- Geographical Information Start

if (@CurrentScope='BU')      
begin

insert into #promotiongeo
select distinct promotionid from [PlayBook].[PromotionGeographic] where buid=@Buid
end

if (@CurrentScope='Area' OR @CurrentScope='Region')      
begin

insert into #promotiongeo
select distinct promotionid from [PlayBook].[PromotionGeographic] where buid=@areaid

end

if (@CurrentScope='Branch')      
begin

insert into #promotiongeo
select distinct promotionid from [PlayBook].[PromotionGeographic] where branchid in (SELECT distinct branchid        
  FROM [Portal_Data].[Person].[UserInBranch] where GSN=@currentuser)

end
   
   
insert into #promotionNatlAccount      
select distinct a.promotionid from Portal_Data.playbook.promotionaccount as a join #PromotionNationalid as b on a.nationalchainid=b.NationalidTemp
join #promotiongeo as c on a.promotionid=c.promotiongeoTemp1

insert into #promotionRegAccount      
select distinct a.promotionid from Portal_Data.playbook.promotionaccount as a join #PromotionRegionalid as b on a.regionalchainid=b.RegionalidTemp  
join #promotiongeo as c on a.promotionid=c.promotiongeoTemp1  
insert into #promotionLocalAccount      
select distinct a.promotionid from Portal_Data.playbook.promotionaccount as a join #PromotionLocalid as b on a.localchainid=b.LocalidTemp  
join #promotiongeo as c on a.promotionid=c.promotiongeoTemp1
    
    
if @IsCalendarView = 1        
BEGIN        
SELECT DISTINCT retail.PromotionID,          
  retail.PromotionStatusID,           
  1 as PromotionRank,    
  promoType.PromotionType,       
  retail.PromotionName,          
  retail.PromotionPrice,          
  retail.PromotionStartDate,          
  retail.PromotionEndDate,          
  stat.PromotionStatus,          
  category.ShortPromotionCategory AS 'PromotionCategory',          
  STUFF((SELECT DISTINCT '| ' + attachment.AttachmentName + ';' + attachment.AttachmentURL          
              FROM PlayBook.PromotionAttachment AS attachment          
              WHERE attachment.PromotionId = retail.PromotionID          
              FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'') as AttachmentsName,          
        STUFF((SELECT DISTINCT ' | ' + trademark.TradeMarkName          
              FROM SAP.TradeMark as trademark          
              WHERE trademark.TradeMarkID IN ( select _brand.BrandID from PlayBook.PromotionBrand AS _brand where _brand.PromotionID = retail.PromotionID /*and _brand.BrandID in(select BrandidTemp from #PromotionBrandid)*/)          
             -- WHERE trademark.TradeMarkID IN ( select _brand.BrandID from PlayBook.PromotionBrand AS _brand where _brand.BrandID in(select BrandidTemp from #PromotionBrandid))          
     FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'') AS PromotionBrands,          
        STUFF((SELECT DISTINCT ' | ' + package.PackageName          
              FROM SAP.Package as package          
              WHERE package.PackageID IN ( select _package.PromotionPackageID from PlayBook.PromotionPackage AS _package where _package.PromotionID = retail.PromotionID)          
              FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'') AS PromotionPackages,          
        CASE WHEN retail.PromotionTypeID = 3 THEN _local.LocalChainName          
    WHEN retail.PromotionTypeID = 1 THEN _regional.RegionalChainName          
    WHEN retail.PromotionTypeID = 2 THEN _national.NationalChainName          
    END AS AccountName,          
  CASE WHEN retail.PromotionTypeID = 3 THEN account.LocalChainID          
    WHEN retail.PromotionTypeID = 1 THEN account.RegionalChainID          
    WHEN retail.PromotionTypeID = 2 THEN account.NationalChainID          
    END AS AccountID          
FROM PlayBook.RetailPromotion AS retail         
--inner join #promotionbrand as Brandtemp on retail.PromotionID = Brandtemp.PromoID           
INNER JOIN PlayBook.PromotionStatus AS stat ON retail.PromotionStatusID = stat.PromotionStatusID          
INNER JOIN PlayBook.PromotionCategory AS category ON retail.PromotionCategoryID = category.PromotionCategoryID          
INNER JOIN PlayBook.PromotionAccount AS account ON retail.PromotionID = account.PromotionID           
INNER JOIN  PlayBook.PromotionRank AS promoRank ON promoRank.PromotionID = retail.PromotionID           
INNER JOIN PlayBook.PromotionType promoType ON promoType.PromotionTypeID = retail.PromotionTypeID        
LEFT OUTER JOIN SAP.LocalChain AS _local ON _local.LocalChainID = account.LocalChainID   --and _local.LocalChainID in (select LocalidTemp from #PromotionLocalid)        
LEFT OUTER JOIN SAP.RegionalChain AS _regional ON _regional.RegionalChainID = account.RegionalChainID  --and _regional.RegionalChainID in (select RegionalidTemp from #PromotionRegionalid)        
LEFT OUTER JOIN SAP.NationalChain AS _national ON _national.NationalChainID = account.NationalChainID --and _national.NationalChainID in (select NationalidTemp from #PromotionNationalid)        
WHERE ( retail.PromotionID in( select NationalidTemp1 from #promotionNatlAccount) or     
retail.PromotionID in( select RegionalidTemp1 from #promotionRegAccount) or retail.PromotionID in( select a.localidTemp1 from #promotionLocalAccount as a inner join #promotiongeo as b on a.localidTemp1=b.promotiongeotemp1)) and retail.PromotionID in(select promoid from #promotionbrand)  and 
(@StartDate BETWEEN retail.PromotionStartDate AND retail.PromotionEndDate         
OR retail.PromotionStartDate BETWEEN @StartDate AND @EndDate)        
END          
        
ELSE        
BEGIN        
SELECT DISTINCT retail.PromotionID,          
  retail.PromotionStatusID,
  retail.CreatedBy,           
  promoRank.PromotionRank,   
  promoType.PromotionType,       
  retail.PromotionName,          
  retail.PromotionPrice,          
  retail.PromotionStartDate,          
  retail.PromotionEndDate,          
  stat.PromotionStatus,          
  category.ShortPromotionCategory AS 'PromotionCategory',          
  STUFF((SELECT DISTINCT '| ' + attachment.AttachmentName + ';' + attachment.AttachmentURL          
              FROM PlayBook.PromotionAttachment AS attachment          
              WHERE attachment.PromotionId = retail.PromotionID          
              FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'') as AttachmentsName,          
        STUFF((SELECT DISTINCT ' | ' + trademark.TradeMarkName          
              FROM SAP.TradeMark as trademark          
              WHERE trademark.TradeMarkID IN (  select _brand.BrandID from PlayBook.PromotionBrand AS _brand where _brand.PromotionID = retail.PromotionID /*and _brand.BrandID in(select BrandidTemp from #PromotionBrandid)*/)          
              FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'') AS PromotionBrands,          
        STUFF((SELECT DISTINCT ' | ' + package.PackageName          
              FROM SAP.Package as package          
              WHERE package.PackageID IN ( select _package.PromotionPackageID from PlayBook.PromotionPackage AS _package where _package.PromotionID = retail.PromotionID)          
              FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'') AS PromotionPackages,          
        CASE WHEN retail.PromotionTypeID = 3 THEN _local.LocalChainName          
    WHEN retail.PromotionTypeID = 1 THEN _regional.RegionalChainName          
    WHEN retail.PromotionTypeID = 2 THEN _national.NationalChainName          
    END AS AccountName,          
  CASE WHEN retail.PromotionTypeID = 3 THEN account.LocalChainID          
    WHEN retail.PromotionTypeID = 1 THEN account.RegionalChainID          
    WHEN retail.PromotionTypeID = 2 THEN account.NationalChainID          
    END AS AccountID          
FROM PlayBook.RetailPromotion AS retail        
--inner join #promotionbrand as Brandtemp on retail.PromotionID = Brandtemp.PromoID            
INNER JOIN PlayBook.PromotionStatus AS stat ON retail.PromotionStatusID = stat.PromotionStatusID          
INNER JOIN PlayBook.PromotionCategory AS category ON retail.PromotionCategoryID = category.PromotionCategoryID          
INNER JOIN PlayBook.PromotionAccount AS account ON retail.PromotionID = account.PromotionID           
INNER JOIN  PlayBook.PromotionRank AS promoRank ON promoRank.PromotionID = retail.PromotionID          
INNER JOIN PlayBook.PromotionType promoType ON promoType.PromotionTypeID = retail.PromotionTypeID  
LEFT OUTER JOIN SAP.LocalChain AS _local ON _local.LocalChainID = account.LocalChainID  -- and _local.LocalChainID in (select LocalidTemp from #PromotionLocalid)        
LEFT OUTER JOIN SAP.RegionalChain AS _regional ON _regional.RegionalChainID = account.RegionalChainID -- and _regional.RegionalChainID in (select RegionalidTemp from #PromotionRegionalid)        
LEFT OUTER JOIN SAP.NationalChain AS _national ON _national.NationalChainID = account.NationalChainID --and _national.NationalChainID in (select NationalidTemp from #PromotionNationalid)        
WHERE ( retail.PromotionID in( select NationalidTemp1 from #promotionNatlAccount) or     
retail.PromotionID in( select RegionalidTemp1 from #promotionRegAccount) or retail.PromotionID in( select a.localidTemp1 from #promotionLocalAccount as a inner join #promotiongeo as b on a.localidTemp1=b.promotiongeotemp1)) and 
retail.PromotionID in(select promoid from #promotionbrand) and (@StartDate BETWEEN retail.PromotionStartDate AND retail.PromotionEndDate         
OR retail.PromotionStartDate BETWEEN @StartDate AND @EndDate)        
AND promoRank.PromotionWeekStart = @StartDate        
END        
END 
GO
/****** Object:  StoredProcedure [PlayBook].[pGetRoutePromotions]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Proc [PlayBook].[pGetRoutePromotions]
(
	@routeNumber varchar(20),
	@promotionStartDate SmallDateTime
)
As

/*
Declare @startDAte smallDateTime
Set @startDate = DateAdd(Day, 1, GetDate())
exec Playbook.pGetRoutePromotions @routeNumber = 100288831 , @promotionStartDate = '05-10-2013'

*/

Set NoCount On;

Declare @AccountPromotions TABLE (
	[PromotionID] [int] NULL,
	[PromotionType] [varchar](185) NOT NULL,
	[PromotionCategory] [varchar](150) NOT NULL,
	[PromotionStartDate] [date] NULL,
	[PromotionEndDate] [date] NULL,
	[PromotionName] [varchar](180) NULL,
	[PromotionPrice] [varchar](150) NULL,
	[PromotionDisplayLocation] [varchar](200) NULL,
	[ProgramName] [varchar](150) NULL,
	[PromotionRank] [int] NULL,
	[SAPAccountNumber] [bigint] NOT NULL,
	[NationalChainName] [varchar](30) NULL,
	[SAPNationalChainID] [int] NULL,
	[RegionalChainName] [varchar](50) NOT NULL,
	[SAPRegionalChainID] [int] NULL,
	[LocalChainName] [varchar](50) NOT NULL,
	[SAPLocalChainID] [int] NULL,
	[SPChannelName] [varchar](50) NULL,
	[SAPChannelID] [varchar](50) NOT NULL,
	[SAPBranchID] [varchar](50) NOT NULL,
	[BranchName] [varchar](50) NULL,
	[AccountID] [int] not NULL
) 
Declare @AccountPromMapping TABLE (
	[SAPAccountNumber] [bigint] NOT NULL,
	[PromotionID] [int] NULL,
	[NationalChainName] [varchar](30) NULL,
	[SAPNationalChainID] [int] NULL,
	[RegionalChainName] [varchar](50) NOT NULL,
	[SAPRegionalChainID] [int] NULL,
	[LocalChainName] [varchar](50) NOT NULL,
	[SAPLocalChainID] [int] NULL,
	[SPChannelName] [varchar](50) NULL,
	[SAPChannelID] [varchar](50) NOT NULL,
	[AccountID] [int] NOT NULL
)
Declare @Promotion Table(
	[PromotionID] [int] NULL,
	[PromotionType] [varchar](185) NOT NULL,
	[PromotionCategory] [varchar](150) NOT NULL,
	[PromotionStartDate] [date] NULL,
	[PromotionEndDate] [date] NULL,
	[PromotionName] [varchar](180) NULL,
	[PromotionPrice] [varchar](150) NULL,
	[PromotionDisplayLocation] [varchar](200) NULL,
	[ProgramName] [varchar](150) NULL,
	[PromotionRank] [int] NULL,
	[NationalChainName] [varchar](30) NULL,
	[SAPNationalChainID] [int] NULL,
	[RegionalChainName] [varchar](50) NOT NULL,
	[SAPRegionalChainID] [int] NULL,
	[LocalChainName] [varchar](50) NOT NULL,
	[SAPLocalChainID] [int] NULL,
	[SPChannelName] [varchar](50) NULL,
	[SAPChannelID] [varchar](50) NOT NULL
)
Declare @PromotionAttachment table(
	[AttachmentType] [varchar](150) NULL,
	[AttachmentURL] [varchar](2500) NULL,
	[AttachmentName] [varchar](200) NULL,
	[AttachmentSize] [int] NULL,
	[AttachmentDocumentID] [nvarchar](50) NULL,
	[PromotionID] [int] NULL,
	[AttachmentDateModified] [datetime] NULL
)
Declare @PromotionPackage table (
	[PromotionID] [int] NULL,
	[PackageID] [int] NOT NULL,
	[SAPPackageID] [varchar](10) NULL,
	[PackageName] [varchar](50) NOT NULL
)
Declare @PromotionBrand TABLE(
	[PromotionID] [int] NULL,
	[SAPBrandID] [varchar](50) NOT NULL,
	[BrandName] [varchar](128) NOT NULL,
	[BrandID] [int] NOT NULL
)

Insert Into @AccountPromotions
Select P.PromotionID, pt.PromotionType, pc.PromotionCategoryName, p.PromotionStartDate, p.PromotionEndDate, p.PromotionName, p.PromotionPrice, 
	dl.DisplayLocationName,'ProgramName'  as ProgramName,
	--cp.ProgramName,
	pr.[Rank], s.SAPAccountNumber, 
	   s.NationalChainName, s.SAPNationalChainID, s.RegionalChainName
      ,s.SAPRegionalChainID
      ,s.LocalChainName
      ,s.SAPLocalChainID
      ,s.SPChannelName
      ,s.SAPChannelID, s.SAPBranchID
      ,s.BranchName,s.Accountid
From [MView].[AccountRouteSchedule] s
left join Playbook.PromotionAccount pa on (s.NationalChainID = pa.NationalChainID Or s.RegionalChainID = pa.RegionalChainID Or s.LocalChainID = pa.LocalChainID )
left Join Playbook.RetailPromotion p on  p.PromotionID = pa.PromotionID
Join Playbook.PromotionType pt on p.PromotionTypeID = pt.PromotionTypeID
Join Playbook.PromotionCategory pc on p.PromotionCategoryID = pc.PromotionCategoryID
Left Join Playbook.DisplayLocation dl on p.PromotionDisplayLocationID = dl.DisplayLocationID
--Left Join PlayBook.CorporatePriority cp on cp.CorporatePriorityID = p.CorporatePriorityID
Left Join [PlayBook].[PromotionRank] pr on pr.PromotionID = p.PromotionID and GetDate() between PromotionWeekStart and PromotionWeekEnd
Where SAPRouteNumber = @routeNumber --113301220
And PromotionEndDate > GetDate() -- will get all the promotions while they are either on the fly or being planned for the future
And PromotionStartDate < @promotionStartDate -- DateAdd(Day, 1, GetDate()) -- will get a real date for this
And PromotionStatusID = 4 -- only approved promotion goes
Order By StopSequence

--- The account/customer to promotion mapping
Insert Into @AccountPromMapping
Select SAPAccountNumber, PromotionID, 
NationalChainName,  SAPNationalChainID,  RegionalChainName
      ,SAPRegionalChainID
      ,LocalChainName
      ,SAPLocalChainID, SPChannelName
      ,SAPChannelID,
	  AccountID
From @AccountPromotions

---- Promotion master
Insert Into @Promotion
Select Distinct PromotionID, PromotionType, PromotionCategory, PromotionStartDate, PromotionEndDate, PromotionName, PromotionPrice, 
	PromotionDisplayLocation, ProgramName, PromotionRank,NationalChainName,SAPNationalChainID,RegionalChainName,SAPRegionalChainID,LocalChainName,SAPLocalChainID,SPChannelName,
	SAPChannelID

From @AccountPromotions

-- Attachments
Insert @PromotionAttachment
Select AttachmentTypeName, pa.AttachmentURL+'/'+pa.AttachmentName as AttachmentURL,AttachmentName, AttachmentSize, AttachmentDocumentID,pa.promotionid,pa.AttachmentDateModified
From Playbook.PromotionAttachment pa
Join Playbook.AttachmentType at on pa.AttachmentTypeID = at.AttachmentTypeID
Join @Promotion p on p.PromotionID = pa.PromotionID

--- Promotion Pakcage
Insert @PromotionPackage
Select pr.PromotionID, p.PackageID, p.RMPackageID SAPPackageID, p.PackageName
From Playbook.PromotionPackage pp
Join SAP.Package p on pp.PackageTypeID = p.PackageID
Join @Promotion pr on pr.PromotionID = pp.PromotionID

--- Promotion Brand
Insert @PromotionBrand
Select pr.PromotionID, b.SAPBrandID, BrandName,pb.BrandID
From Playbook.PromotionBrand pb
Join SAP.Brand b on pb.BrandID = b.BrandID
Join @Promotion pr on pr.PromotionID = pb.PromotionID
Insert @PromotionBrand
Select pr.PromotionID, b.SAPTrademarkID, TrademarkName,pb.BrandID
From Playbook.PromotionBrand pb
Join SAP.TradeMark b on pb.TradeMarkID = b.TradeMarkID
Join @Promotion pr on pr.PromotionID = pb.PromotionID

--------Output --------------
-----------------------------
Select  PromotionID,SAPAccountNumber,AccountID
-- NationalChainName, 
-- SAPNationalChainID, 
-- RegionalChainName
      --,SAPRegionalChainID
      --,LocalChainName
      --,SAPLocalChainID, SPChannelName
      --,SAPChannelID
From @AccountPromMapping
Select PromotionID, PromotionType, PromotionCategory, PromotionStartDate, PromotionEndDate, PromotionName, PromotionPrice, 
	PromotionDisplayLocation, ProgramName, PromotionRank,NationalChainName,SAPNationalChainID,RegionalChainName,SAPRegionalChainID
	,LocalChainName,SAPLocalChainID,SPChannelName,SAPChannelID

From @Promotion
Select PromotionID,AttachmentType, AttachmentURL, AttachmentName, AttachmentSize, AttachmentDocumentID,AttachmentDateModified From @PromotionAttachment
Select PromotionID, PackageID, SAPPackageID, PackageName From @PromotionPackage
Select PromotionID, SAPBrandID, BrandName,BrandID From @PromotionBrand
Select MydayStatusCode,MydayStatusMessage From PlayBook.MydayStatus
GO
/****** Object:  StoredProcedure [PlayBook].[pInsertUpdatePromotion]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--===================================================
--Author-HCL
--CreatedDate-03-March-2013
--Description-The procedure is used to add/update Promotion to Platbook.RetailPromotion
--Example Exec [PlayBook].[pInsertUpdatePromotion] 1096,'Promotion Test','Promotion Description','Promotion Name','4','A30','Region','BD46','6500',7,8,9,'05-10-2013','04-10-2013',4,0,1023,767,77,4,55,'User','user',0,'message',1

--==================================================
                    
CREATE  PROCEDURE [PlayBook].[pInsertUpdatePromotion]                          
(                     
--we will add column to save brand-package in json format                       
 @Mode VARCHAR(500),                     
 @PromotionID INT,                    
 @PromotionDescription VARCHAR(500),                  
 @PromotionName VARCHAR(500),                    
 @PromotionTypeID INT,                    
 @AccountId INT,                    
 --@EdgeItemId INT,
 --@IsLocalized BIT,
 @PromotionTradeMarkID VARCHAR(500),                    
 @PromotionPackageID VARCHAR(500),                    
 @PromotionPrice VARCHAR(500) ,                    
 @PromotionCategoryId INT,                    
 @PromotionDisplayLocationId int,                    
 @PromotionDisplayLocationOther VARCHAR(500),                    
 @PromotionStartDate DATETIME,                    
 @PromotionEndDate DATETIME,                    
 @PromotionStatus VARCHAR(500),       
 @IsDuplicate BIT,                    
 @ParentPromoId INT,                    
 @ForecastVolume VARCHAR(500),  
 @BranchId INT,  
 @BUID INT,
 @RegionId INT,                    
 @CreatedBy VARCHAR(500),                    
 @ModifiedBy VARCHAR(500),                    
 @Status INT OUT,                    
 @Message VARCHAR(500) OUT,          
 @NewPromoId int OUT
                     
                     
)                          
AS                          
BEGIN                     
DECLARE @PromotionStatusId int                         
--SET NOCOUNT ON                    
 BEGIN TRY               
  --Fetch promotion status id by promotion status                    
                      
   SELECT @PromotionStatusId=StatusID                     
   FROM PlayBook.Status                     
   WHERE LOWER(StatusName)=LOWER(@PromotionStatus)                    
                      
                       
   Declare @Attachments table                    
 (                    
 Id int identity,                    
 PromoId int,                    
 Url varchar(500),                    
 Name varchar(500)                    
 )                    
                     
    Declare @tblBrand table                    
 (                    
     Id int identity(1,1),                    
     TradeMarkId VARCHAR(100)                    
 )                    
    Declare @tblPackage table                    
 (                    
     Id int identity(1,1),                    
     PackageId VARCHAR(100)                    
 )                    
                      
  IF(@Mode='Insert')                    
  BEGIN                    
-- Insert promotion                 
                  
INSERT INTO PlayBook.RetailPromotion                    
  (                    
  PromotionName,    
  PromotionDescription,                    
  PromotionTypeID,                    
   PromotionPrice,                    
   PromotionCategoryID,                    
  PromotionStatusID,                    
  PromotionStartDate,                    
  PromotionEndDate,                    
  ForecastVolume,
  PromotionBranchID,  
  PromotionBUID,  
  PromotionRegionID,                 
 -- EDGEItemID,
  --IsLocalized,
  CreatedBy,  
  CreatedDate,  
  ModifiedBy,  
  ModifiedDate                       
   )                    
   VALUES                    
   (  
  @PromotionName,     
  @PromotionDescription ,                  
  @PromotionTypeID,                    
  @PromotionPrice,                    
  @PromotionCategoryId,                    
  @PromotionStatusId,                    
  @PromotionStartDate,                    
  @PromotionEndDate,                    
  @ForecastVolume,  
  @BranchId,  
  @BUID,  
  @RegionId, 
 -- @EdgeItemId,
  --@IsLocalized,      
  @CreatedBy,                    
  GETDATE(),  
  @ModifiedBy,  
  GETDATE()                   
   )                    
 SET @PromotionID=SCOPE_IDENTITY()                    
  SET @NewPromoId =@PromotionID;             
 --To create duplicate promotion                     
 IF(@IsDuplicate=1)                    
  UPDATE PlayBook.RetailPromotion                    
  SET ParentPromotionID=@ParentPromoId                    
  WHERE PromotionID=@PromotionID                    
                     
 ----Save data for display location . for other option we have update PromotionDisplayLocationOther column in PlayBook.PromotionDisplayLocation                    
 IF(@PromotionDisplayLocationId=23)--23 id for other option in display location                    
 BEGIN                    
 INSERT INTO PlayBook.PromotionDisplayLocation(PromotionID,DisplayLocationID,PromotionDisplayLocationOther)         
    VALUES(@PromotionID,@PromotionDisplayLocationId,@PromotionDisplayLocationOther)                    
 END                    
ELSE                    
 BEGIN                    
 INSERT INTO PlayBook.PromotionDisplayLocation(PromotionID,DisplayLocationID)                    
    VALUES(@PromotionID,@PromotionDisplayLocationId)                    
 END                    
                 
 ----Add account for Promotion                    
                     
 IF(@PromotionTypeID=1)--Regional chain                    
 INSERT INTO PlayBook.PromotionAccount(PromotionID,RegionalChainID) VALUES(@PromotionID,@AccountId)                    
                     
 IF(@PromotionTypeID=2)--National chain             
 INSERT INTO PlayBook.PromotionAccount( PromotionID , NationalChainID ) VALUES( @PromotionID , @AccountId )                    
                     
 IF(@PromotionTypeID=3)--Local chain                    
  INSERT INTO PlayBook.PromotionAccount(PromotionID, LocalChainID) VALUES(@PromotionID,@AccountId)                    
 --   -- Insert barnd for promotion                     
    INSERT INTO @tblBrand(TradeMarkId) SELECT * FROM dbo.split(@PromotionTradeMarkID,',')                    
    INSERT INTO PlayBook.PromotionBrand(PromotionID,TrademarkID) SELECT @PromotionID,CAST(TradeMarkId AS INT) FROM @tblBrand                    
                    
     --Insert Package for promotion                    
 INSERT INTO @tblPackage(PackageId) SELECT * FROM dbo.split(@PromotionPackageID,',')                    
    INSERT INTO PlayBook.PromotionPackage(PromotionID,PackageID) SELECT @PromotionID,CAST(PackageId AS INT) FROM @tblPackage                    
                    
   SET @Status=1                    
  SET @Message='Promotion has been inserted successfully.'                    
END                    
--Update Promotion                         
                      
IF(@Mode='Update')                    
  BEGIN                    
  UPDATE PlayBook.RetailPromotion                    
  SET                     
  PromotionName=@PromotionName,     
  PromotionDescription=@PromotionDescription,                   
  PromotionTypeID=@PromotionTypeID,                    
  PromotionPrice=@PromotionPrice,                    
  PromotionCategoryID=@PromotionCategoryId,                    
  PromotionDisplayLocationID=@PromotionDisplayLocationID,                    
  PromotionStatusID= @PromotionStatusId,                    
  PromotionStartDate=@PromotionStartDate,                    
  PromotionEndDate=@PromotionEndDate,                    
  ForecastVolume=@ForecastVolume,                    
  PromotionBranchID=@BranchId,  
  PromotionBUID=@BUID,  
  PromotionRegionID=@RegionId,  
  --EDGEItemID=@EdgeItemId,
  --IsLocalized=@IsLocalized,
  ModifiedBy=@ModifiedBy,                    
  ModifiedDate=GETDATE()                    
 WHERE PromotionId=@PromotionID                    
              
                     
 IF(@PromotionDisplayLocationId=23)                    
 BEGIN                     
    UPDATE PlayBook.PromotionDisplayLocation                    
    SET                    
    DisplayLocationID=@PromotionDisplayLocationId,                    
    PromotionDisplayLocationOther=@PromotionDisplayLocationOther                    
    WHERE PromotionID=@PromotionID;                    
                        
 END                    
                     
 ELSE                     
 BEGIN                    
                     
 UPDATE PlayBook.PromotionDisplayLocation                    
  SET DisplayLocationID=@PromotionDisplayLocationId,                    
   PromotionDisplayLocationOther=null                    
  WHERE PromotionID=@PromotionID;                    
 END                    
                    
                     
 IF(@PromotionTypeID=1)--Regional chain                    
 UPDATE PlayBook.PromotionAccount                    
  SET RegionalChainID=@AccountId,                    
  NationalChainID=null,                    
  LocalChainID=null                    
  WHERE PromotionID=@PromotionID                    
                     
 IF(@PromotionTypeID=2)--National chain                    
  UPDATE PlayBook.PromotionAccount                    
   SET NationalChainID=@AccountId,                    
       RegionalChainID=null,                    
       LocalChainID=null                    
   WHERE PromotionID=@PromotionID                    
                       
 IF(@PromotionTypeID=3)--Local chain                    
 UPDATE PlayBook.PromotionAccount                    
  SET LocalChainID=@AccountId,                  
  NationalChainID=null,                    
  RegionalChainID=null                    
  WHERE PromotionID=@PromotionID                    
                     
           
      --Delete Brands and Insert new so that we can have updated brands for promotion.                    
 DELETE PlayBook.PromotionBrand                    
 WHERE PromotionID=@PromotionID                    
                       
                       
 INSERT INTO @tblBrand(TradeMarkId) SELECT * FROM dbo.split(@PromotionTradeMarkID,',')                    
                     
    INSERT INTO PlayBook.PromotionBrand(PromotionID,TrademarkID) SELECT @PromotionID,CAST(TradeMarkId AS INT) FROM @tblBrand                    
                         
     --Insert Package for promotion                    
                        
    DELETE PlayBook.PromotionPackage                    
   WHERE PromotionID=@PromotionID                    
                       
                        
 INSERT INTO @tblPackage(PackageId) SELECT * FROM dbo.split(@PromotionPackageID,',')                    
                     
    INSERT INTO PlayBook.PromotionPackage(PromotionID,PackageID) SELECT @PromotionID,CAST(PackageId AS INT) FROM @tblPackage                    
    SET @NewPromoId =0;                         
 SET @Status=1                    
 SET @Message='Promotion has been updated successfully.'                    
 END                    
                     
--COMMIT                      
END TRY                    
BEGIN CATCH                    
  SET @Message=ERROR_MESSAGE()                    
  SET @Status=0                    
 --ROLLBACK                    
END CATCH                      
END
GO
/****** Object:  StoredProcedure [PlayBook].[pInsertUpdatePromotion_Test]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                    
Create  PROCEDURE [PlayBook].[pInsertUpdatePromotion_Test]                          
(                     
--we will add column to save brand-package in json format                       
 @Mode VARCHAR(500),                     
 @PromotionID INT,                    
 @PromotionDescription VARCHAR(500),                  
 @PromotionName VARCHAR(500),                    
 @PromotionTypeID INT,                    
 @AccountId INT,                    
 @EdgeItemId INT,
 @IsLocalized BIT,
 @PromotionTradeMarkID VARCHAR(500),                    
 @PromotionPackageID VARCHAR(500),                    
 @PromotionPrice VARCHAR(500) ,                    
 @PromotionCategoryId INT,                    
 @PromotionDisplayLocationId int,                    
 @PromotionDisplayLocationOther VARCHAR(500),                    
 @PromotionStartDate DATETIME,                    
 @PromotionEndDate DATETIME,                    
 @PromotionStatus VARCHAR(500),       
 @IsDuplicate BIT,                    
 @ParentPromoId INT,                    
 @ForecastVolume VARCHAR(500),  
 @BranchId INT,  
 @BUID INT,
 @RegionId INT,                    
 @CreatedBy VARCHAR(500),                    
 @ModifiedBy VARCHAR(500),                    
 @Status INT OUT,                    
 @Message VARCHAR(500) OUT,          
 @NewPromoId int OUT
                     
                     
)                          
AS                          
BEGIN                     
DECLARE @PromotionStatusId int                         
--SET NOCOUNT ON                    
 BEGIN TRY               
  --Fetch promotion status id by promotion status                    
                      
   SELECT @PromotionStatusId=StatusID                     
   FROM PlayBook.Status                     
   WHERE LOWER(StatusName)=LOWER(@PromotionStatus)                    
                      
                       
   Declare @Attachments table                    
 (                    
 Id int identity,                    
 PromoId int,                    
 Url varchar(500),                    
 Name varchar(500)                    
 )                    
                     
    Declare @tblBrand table                    
 (                    
     Id int identity(1,1),                    
     TradeMarkId VARCHAR(100)                    
 )                    
    Declare @tblPackage table                    
 (                    
     Id int identity(1,1),                    
     PackageId VARCHAR(100)                    
 )                    
                      
  IF(@Mode='Insert')                    
  BEGIN                    
-- Insert promotion                 
                  
INSERT INTO PlayBook.RetailPromotion                    
  (                    
  PromotionName,    
  PromotionDescription,                    
  PromotionTypeID,                    
   PromotionPrice,                    
   PromotionCategoryID,                    
  PromotionStatusID,                    
  PromotionStartDate,                    
  PromotionEndDate,                    
  ForecastVolume,
  PromotionBranchID,  
  PromotionBUID,  
  PromotionRegionID,                 
 EDGEItemID,
 IsLocalized,
  CreatedBy,  
  CreatedDate,  
  ModifiedBy,  
  ModifiedDate                       
   )                    
   VALUES                    
   (  
  @PromotionName,     
  @PromotionDescription ,                  
  @PromotionTypeID,                    
  @PromotionPrice,                    
  @PromotionCategoryId,                    
  @PromotionStatusId,                    
  @PromotionStartDate,                    
  @PromotionEndDate,                    
  @ForecastVolume,  
  @BranchId,  
  @BUID,  
  @RegionId, 
 @EdgeItemId,
 @IsLocalized,      
  @CreatedBy,                    
  GETDATE(),  
  @ModifiedBy,  
  GETDATE()                   
   )                    
 SET @PromotionID=SCOPE_IDENTITY()                    
  SET @NewPromoId =@PromotionID;             
 --To create duplicate promotion                     
 IF(@IsDuplicate=1)                    
  UPDATE PlayBook.RetailPromotion                    
  SET ParentPromotionID=@ParentPromoId                    
  WHERE PromotionID=@PromotionID                    
                     
 ----Save data for display location . for other option we have update PromotionDisplayLocationOther column in PlayBook.PromotionDisplayLocation                    
 IF(@PromotionDisplayLocationId=23)--23 id for other option in display location                    
 BEGIN                    
 INSERT INTO PlayBook.PromotionDisplayLocation(PromotionID,DisplayLocationID,PromotionDisplayLocationOther)         
    VALUES(@PromotionID,@PromotionDisplayLocationId,@PromotionDisplayLocationOther)                    
 END                    
ELSE                    
 BEGIN                    
 INSERT INTO PlayBook.PromotionDisplayLocation(PromotionID,DisplayLocationID)                    
    VALUES(@PromotionID,@PromotionDisplayLocationId)                    
 END                    
                 
 ----Add account for Promotion                    
                     
 IF(@PromotionTypeID=1)--Regional chain                    
 INSERT INTO PlayBook.PromotionAccount(PromotionID,RegionalChainID) VALUES(@PromotionID,@AccountId)                    
                     
 IF(@PromotionTypeID=2)--National chain             
 INSERT INTO PlayBook.PromotionAccount( PromotionID , NationalChainID ) VALUES( @PromotionID , @AccountId )                    
                     
 IF(@PromotionTypeID=3)--Local chain                    
  INSERT INTO PlayBook.PromotionAccount(PromotionID, LocalChainID) VALUES(@PromotionID,@AccountId)                    
 --   -- Insert barnd for promotion                     
    INSERT INTO @tblBrand(TradeMarkId) SELECT * FROM dbo.split(@PromotionTradeMarkID,',')                    
    INSERT INTO PlayBook.PromotionBrand(PromotionID,TrademarkID) SELECT @PromotionID,CAST(TradeMarkId AS INT) FROM @tblBrand                    
                    
     --Insert Package for promotion                    
 INSERT INTO @tblPackage(PackageId) SELECT * FROM dbo.split(@PromotionPackageID,',')                    
    INSERT INTO PlayBook.PromotionPackage(PromotionID,PackageID) SELECT @PromotionID,CAST(PackageId AS INT) FROM @tblPackage                    
                    
   SET @Status=1                    
  SET @Message='Promotion has been inserted successfully.'                    
END                    
--Update Promotion                         
                      
IF(@Mode='Update')                    
  BEGIN                    
  UPDATE PlayBook.RetailPromotion                    
  SET                     
  PromotionName=@PromotionName,     
  PromotionDescription=@PromotionDescription,                   
  PromotionTypeID=@PromotionTypeID,                    
  PromotionPrice=@PromotionPrice,                    
  PromotionCategoryID=@PromotionCategoryId,                    
  PromotionDisplayLocationID=@PromotionDisplayLocationID,                    
  PromotionStatusID= @PromotionStatusId,                    
  PromotionStartDate=@PromotionStartDate,                    
  PromotionEndDate=@PromotionEndDate,                    
  ForecastVolume=@ForecastVolume,                    
  PromotionBranchID=@BranchId,  
  PromotionBUID=@BUID,  
  PromotionRegionID=@RegionId,  
 EDGEItemID=@EdgeItemId,
 IsLocalized=@IsLocalized,
  ModifiedBy=@ModifiedBy,                    
  ModifiedDate=GETDATE()                    
 WHERE PromotionId=@PromotionID                    
              
                     
 IF(@PromotionDisplayLocationId=23)                    
 BEGIN                     
    UPDATE PlayBook.PromotionDisplayLocation                    
    SET                    
    DisplayLocationID=@PromotionDisplayLocationId,                    
    PromotionDisplayLocationOther=@PromotionDisplayLocationOther                    
    WHERE PromotionID=@PromotionID;                    
                        
 END                    
                     
 ELSE                     
 BEGIN                    
                     
 UPDATE PlayBook.PromotionDisplayLocation                    
  SET DisplayLocationID=@PromotionDisplayLocationId,                    
   PromotionDisplayLocationOther=null                    
  WHERE PromotionID=@PromotionID;                    
 END                    
                    
                     
 IF(@PromotionTypeID=1)--Regional chain                    
 UPDATE PlayBook.PromotionAccount                    
  SET RegionalChainID=@AccountId,                    
  NationalChainID=null,                    
  LocalChainID=null                    
  WHERE PromotionID=@PromotionID                    
                     
 IF(@PromotionTypeID=2)--National chain                    
  UPDATE PlayBook.PromotionAccount                    
   SET NationalChainID=@AccountId,                    
       RegionalChainID=null,                    
       LocalChainID=null                    
   WHERE PromotionID=@PromotionID                    
                       
 IF(@PromotionTypeID=3)--Local chain                    
 UPDATE PlayBook.PromotionAccount                    
  SET LocalChainID=@AccountId,                  
  NationalChainID=null,                    
  RegionalChainID=null                    
  WHERE PromotionID=@PromotionID                    
                     
           
      --Delete Brands and Insert new so that we can have updated brands for promotion.                    
 DELETE PlayBook.PromotionBrand                    
 WHERE PromotionID=@PromotionID                    
                       
                       
 INSERT INTO @tblBrand(TradeMarkId) SELECT * FROM dbo.split(@PromotionTradeMarkID,',')                    
                     
    INSERT INTO PlayBook.PromotionBrand(PromotionID,TrademarkID) SELECT @PromotionID,CAST(TradeMarkId AS INT) FROM @tblBrand                    
                         
     --Insert Package for promotion                    
                        
    DELETE PlayBook.PromotionPackage                    
   WHERE PromotionID=@PromotionID                    
                       
                        
 INSERT INTO @tblPackage(PackageId) SELECT * FROM dbo.split(@PromotionPackageID,',')                    
                     
    INSERT INTO PlayBook.PromotionPackage(PromotionID,PackageID) SELECT @PromotionID,CAST(PackageId AS INT) FROM @tblPackage                    
    SET @NewPromoId =0;                         
 SET @Status=1                    
 SET @Message='Promotion has been updated successfully.'                    
 END                    
                     
--COMMIT                      
END TRY                    
BEGIN CATCH                    
  SET @Message=ERROR_MESSAGE()                    
  SET @Status=0                    
 --ROLLBACK                    
END CATCH                      
END
GO
/****** Object:  StoredProcedure [PlayBook].[pUpdatePromotionRankByID]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Sumit Kanchan  
-- Create date: 26/April/2013  
-- Description: This procedure will update the promotion ranks  
--  
-- Test Values  
-- exec [PlayBook].[pUpdatePromotionRankByID] '9,9','1201,1195','2013-04-22'  
--  
-- =============================================  
CREATE PROCEDURE [PlayBook].[pUpdatePromotionRankByID]   
@Ranks varchar(MAX),  
@PromotionIDs varchar(MAX),  
@StartDate Date  
AS  
BEGIN  
 DECLARE @delimiter char(1) = ','  
 DECLARE @chRankIndex int  
 DECLARE @chPIDIndex int  
 DECLARE @_rank varchar(100)  
 DECLARE @_pid varchar(100)  
 DECLARE @pStartDate Date  
 DECLARE @pEndDate Date  
 DECLARE @ErrorPid varchar(MAX) = ''  
 Declare @RowsEffected varchar(10) = 0  
 SET NOCOUNT ON;  
  
  
WHILE CHARINDEX(@delimiter, @Ranks, 0) <> 0  
        BEGIN  
            -- Get the index of the first delimiter.  
            SET @chRankIndex = CHARINDEX(@delimiter, @Ranks, 0)  
            SET @chPIDIndex = CHARINDEX(@delimiter, @PromotionIDs, 0)  
  
            -- Get all of the characters prior to the delimiter and insert the string into the table.  
            SELECT @_rank = SUBSTRING(@Ranks, 1, @chRankIndex - 1)  
            SELECT @_pid = SUBSTRING(@PromotionIDs, 1, @chPIDIndex - 1)  
  
            IF LEN(@_rank) > 0  
                BEGIN  
                    --Get the start Date end Date and check if the Start/End Date is same then update rank in retail table also  
                    SELECT @pStartDate = PromotionStartDate,@pEndDate = PromotionEndDate   
                    FROM PlayBook.RetailPromotion   
                    WHERE PromotionID = @_pid  
                      
                    IF @StartDate = @pStartDate AND @pEndDate = DATEADD(day,6,@StartDate)  
      BEGIN  
       BEGIN TRY  
        --Update the Rank in promotion retail table also  
        Update PlayBook.RetailPromotion   
        SET CreatedPromotionRank = @_rank  
        WHERE PromotionID = @_pid  
       END TRY  
       BEGIN CATCH  
        SET @ErrorPid = @ErrorPid +';' + @_pid  
       END CATCH  
      END  
                    BEGIN TRY  
      --Update the rank in Promotion Rank table  
      Update PlayBook.PromotionRank 
      SET Rank = @_rank  
      Where PromotionID = @_pid AND PromotionWeekStart = @StartDate  
      SET @RowsEffected = @RowsEffected + @@ROWCOUNT  
                    END TRY  
                    BEGIN CATCH  
      SET @ErrorPid = @ErrorPid +';' + @_pid  
                    END CATCH  
                END  
  
            -- Get the remainder of the string.  
            SELECT @Ranks = SUBSTRING(@Ranks, @chRankIndex + 1, LEN(@Ranks))  
            SELECT @PromotionIDs = SUBSTRING(@PromotionIDs, @chPIDIndex + 1, LEN(@PromotionIDs))  
        END  
  
         
        --Update the Last record  
        IF LEN(@Ranks) > 0  
        BEGIN  
            --Get the start Date end Date and check if the Start/End Date is same then update rank in retail table also  
            SELECT @pStartDate = PromotionStartDate,@pEndDate = PromotionEndDate   
            FROM PlayBook.RetailPromotion   
            WHERE PromotionID = @_pid  
              
            IF @StartDate = @pStartDate AND @pEndDate = DATEADD(day,6,@StartDate)  
    BEGIN  
     BEGIN TRY  
      --Update the Rank in promotion retail table also  
      Update PlayBook.RetailPromotion   
      SET CreatedPromotionRank = @Ranks  
      WHERE PromotionID = @PromotionIDs  
     END TRY  
     BEGIN CATCH  
       SET @ErrorPid = @ErrorPid +';' + @PromotionIDs  
                    END CATCH  
    END  
              
            BEGIN TRY  
    --Update the rank in Promotion Rank table  
    Update PlayBook.PromotionRank  
    SET Rank =@Ranks  
    Where PromotionID = @PromotionIDs AND PromotionWeekStart = @StartDate  
    SET @RowsEffected = @RowsEffected + @@ROWCOUNT  
   END TRY  
            BEGIN CATCH  
    SET @ErrorPid = @ErrorPid +';' + @PromotionIDs  
            END CATCH  
        END  
   
  
SELECT @RowsEffected + '#' +@ErrorPid AS ErrorInfo  
END  
GO
/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Split]
(
	@input AS Varchar(4000),
	@splitChar AS Char(1) = null
)  
RETURNS  
      @Result TABLE(Value varchar(200))  
AS  
BEGIN  
      DECLARE @str VARCHAR(20)  
      DECLARE @ind Int  
      
	  IF(@splitChar is null) 
	  BEGIN
		SET @splitChar = ';'
	  END

	  IF(@input is not null)  
      BEGIN  
            SET @ind = CharIndex(@splitChar,@input)  
            WHILE @ind > 0  
            BEGIN  
                  SET @str = SUBSTRING(@input,1,@ind-1)  
                  SET @input = SUBSTRING(@input,@ind+1,LEN(@input)-@ind)  
                  INSERT INTO @Result values (@str)  
                  SET @ind = CharIndex(@splitChar,@input)  
            END  
            SET @str = @input  
            INSERT INTO @Result values (@str)  
      END  
      RETURN  
END 

GO
/****** Object:  UserDefinedFunction [dbo].[udf_TitleCase]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[udf_TitleCase] (@InputString VARCHAR(4000) )
RETURNS VARCHAR(4000)
AS
 BEGIN
 DECLARE @Index INT
 DECLARE @Char CHAR(1)
DECLARE @OutputString VARCHAR(255)
SET @OutputString = LOWER(@InputString)
SET @Index = 2
SET @OutputString =
STUFF(@OutputString, 1, 1,UPPER(SUBSTRING(@InputString,1,1)))
WHILE @Index <= LEN(@InputString)
BEGIN
 SET @Char = SUBSTRING(@InputString, @Index, 1)
IF @Char IN (' ', ';', ':', '!', '?', ',', '.', '_', '-', '/', '&','''','(')
IF @Index + 1 <= LEN(@InputString)
BEGIN
 IF @Char != ''''
OR
UPPER(SUBSTRING(@InputString, @Index + 1, 1)) != 'S'
SET @OutputString =
STUFF(@OutputString, @Index + 1, 1,UPPER(SUBSTRING(@InputString, @Index + 1, 1)))
END
 SET @Index = @Index + 1
END
 RETURN ISNULL(@OutputString,'')
END 
GO
/****** Object:  View [MView].[LocationHier]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE View [MView].[LocationHier]
As
Select BUName, SPBUName, RegionName, SPRegionName, SAPBranchID, BranchName, SPBranchName, bu.BUID, a.RegionID, b.BranchID
From SAP.BusinessUnit bu
	Join SAP.Region a on bu.BUID = a.BUID
	Join SAP.Branch b on a.RegionID = b.RegionID


GO
/****** Object:  View [MView].[PersonalRoleLocation]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [MView].[PersonalRoleLocation]
AS
SELECT        up.GSN, up.FirstName, up.LastName, r.RoleName, lh.BUName, lh.SPBUName AS AreaName, lh.RegionName AS SAPBranchID, lh.SPRegionName AS BranchName, 
                         lh.SAPBranchID AS SPBranchName, lh.BranchName AS BUID, lh.SPBranchName AS AreaID, lh.BUID AS BranchID, lh.RegionID, lh.BranchID AS Expr1
FROM            Person.UserInRole AS ur INNER JOIN
                         Person.UserProfile AS up ON ur.GSN = up.GSN INNER JOIN
                         Person.Role AS r ON ur.RoleID = r.RoleID INNER JOIN
                         SAP.CostCenter AS c ON up.CostCenterID = c.CostCenterID INNER JOIN
                         SAP.ProfitCenter AS p ON p.ProfitCenterID = c.ProfitCenterID INNER JOIN
                         SAP.Branch AS b ON b.BranchID = p.BranchID INNER JOIN
                         MView.LocationHier AS lh ON b.BranchID = lh.BranchID

GO
/****** Object:  View [MView].[BrandHier]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create View [MView].[BrandHier]
AS
Select SAPTradeMarkID, TradeMarkName, SAPBrandID, BrandName, t.TradeMarkID, BrandID
From SAP.TradeMark t
Join SAP.Brand b on t.TrademarkID = b.TrademarkID
Where SAPTradeMarkID <> '#' And SAPTradeMarkID <> 'ZZZ' 

GO
/****** Object:  View [MView].[BranchPackage]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [MView].[BranchPackage]
AS
SELECT DISTINCT 
                         bu.BUID, bu.SAPBUID, bu.BUName, a.RegionID, a.SAPRegionID, a.RegionName, br.BranchID, br.SAPBranchID, br.BranchName, bt.InternalCategoryID, 
                         bt.InternalCategoryName, b.SAPTradeMarkID, b.TradeMarkID, b.TradeMarkName, b.BrandID, b.SAPBrandID, b.BrandName, pc.PackageID, pc.PackageName
FROM            SAP.Material AS m INNER JOIN
                         MView.BrandHier AS b ON m.BrandID = b.BrandID INNER JOIN
                         SAP.BranchMaterial AS bm ON bm.MaterialID = m.MaterialID INNER JOIN
                         SAP.Package AS pc ON pc.PackageID = m.PackageID INNER JOIN
                         SAP.InternalCategory AS bt ON bt.InternalCategoryID = m.InternalCategoryID INNER JOIN
                         SAP.Branch AS br ON bm.BranchID = br.BranchID INNER JOIN
                         SAP.Region AS a ON a.RegionID = br.RegionID INNER JOIN
                         SAP.BusinessUnit AS bu ON bu.BUID = a.BUID
WHERE        (b.SAPTradeMarkID <> 'ZZZ')

GO
/****** Object:  View [MView].[ChainHier]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [MView].[ChainHier]
As
Select SAPNationalChainID, NationalChainName, SAPRegionalChainID, RegionalChainName, SAPLocalChainID, LocalChainName, lc.LocalChainID, rc.RegionalChainID, nc.NationalChainID
From SAP.LocalChain lc
	Join SAP.RegionalChain rc on lc.RegionalChainID = rc.RegionalChainID
	Join SAP.NationalChain nc on rc.NationalChainID = nc.NationalChainID

GO
/****** Object:  View [MView].[LocationChain]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [MView].[LocationChain]
AS
SELECT DISTINCT 
                         ch.SAPNationalChainID, ch.NationalChainName, ch.SAPRegionalChainID, ch.RegionalChainName, ch.SAPLocalChainID, ch.LocalChainName, ch.LocalChainID, 
                         ch.RegionalChainID, ch.NationalChainID, lh.BUName AS BU, lh.BUID AS BUID, lh.RegionName AS Region, lh.RegionID, lh.BranchName AS BranchName, 
                         lh.BranchID AS BranchID
FROM            SAP.Account AS a INNER JOIN
                         SAP.Branch AS br ON br.BranchID = a.BranchID INNER JOIN
                         MView.ChainHier AS ch ON a.LocalChainID = ch.LocalChainID INNER JOIN
                         MView.LocationHier AS lh ON br.BranchID = lh.BranchID
WHERE        (a.Active = 1)

GO
/****** Object:  View [MView].[LocationChannel]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create View [MView].[LocationChannel]
AS
Select Distinct ch.*, lh.*
From SAP.Account a
Join SAP.Branch br on br.BranchID = a.BranchID
Join SAP.Channel ch on a.ChannelID = ch.ChannelID
Join MView.LocationHier lh on br.BranchID = lh.BranchID
Where a.Active = 1

GO
/****** Object:  View [MView].[AccountActiveRouteSchedule]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create View [MView].[AccountActiveRouteSchedule]
As
	Select SequenceNumber AS StopSequence, Day, b.BranchID, 
		a.SAPAccountNumber, SAPRouteNumber, a.AccountName, a.Address, a.City, a.State, a.PostalCode, 
		nc.SPNationalChainName, ch.SAPNationalChainID, 
		ch.RegionalChainName, ch.SAPRegionalChainID, 
		ch.LocalChainName, ch.SAPLocalChainID, 
		c.SPChannelName, c.SAPChannelID, b.SAPBranchID, b.SPBranchName
	From SAP.RouteScheduleDetail rsd
		JOin SAP.RouteSchedule rs on rsd.RouteScheduleID = rs.RouteScheduleID
		Join SAP.Account a on rs.AccountID = a.AccountID
		Join SAP.Branch b on a.BranchID = b.BranchID
		Join SAP.SalesRoute sr on sr.RouteID = rs.RouteID
		Join MView.ChainHier ch on a.LocalChainID = ch.LocalChainID
		Join SAP.NationalChain nc on nc.NationalChainID = ch.NationalChainID
		Join SAP.Channel c on a.ChannelID = c.ChannelID
	Where sr.Active = 1
		And a.Active = 1


GO
/****** Object:  View [MView].[BranchBrand]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [MView].[BranchBrand]
AS
SELECT DISTINCT 
                         bu.BUID, bu.SAPBUID, bu.BUName, a.RegionID, a.SAPRegionID, a.RegionName, br.BranchID, br.SAPBranchID, br.BranchName, b.SAPTradeMarkID, b.TradeMarkID, 
                         b.TradeMarkName, b.BrandID, b.SAPBrandID, b.BrandName
FROM            SAP.Material AS m INNER JOIN
                         MView.BrandHier AS b ON m.BrandID = b.BrandID INNER JOIN
                         SAP.BranchMaterial AS bm ON bm.MaterialID = m.MaterialID INNER JOIN
                         SAP.Branch AS br ON bm.BranchID = br.BranchID INNER JOIN
                         SAP.Region AS a ON a.RegionID = br.RegionID INNER JOIN
                         SAP.BusinessUnit AS bu ON bu.BUID = a.BUID
WHERE        (b.SAPTradeMarkID <> 'ZZZ')

GO
/****** Object:  View [SAP].[TrademarkPackage]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [SAP].[TrademarkPackage]
AS
SELECT DISTINCT TrademarkID, Trademark, PackTypeID, PackType, PackConfID, PackConf
FROM         Staging.MaterialBrandPKG
WHERE     (Trademark IS NOT NULL)

GO
/****** Object:  View [SAP].[AreaPackages]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [SAP].[AreaPackages]
AS
SELECT        BT.SAPTradeMarkID, BT.TradeMarkName, TP.PackTypeID, TP.PackType, TP.PackConfID, TP.PackConf
FROM            SAP.TrademarkPackage AS TP INNER JOIN
                         MView.BranchBrand AS BT ON TP.TrademarkID = BT.SAPTradeMarkID

GO
/****** Object:  View [SAP].[BUPackages]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [SAP].[BUPackages]
AS
SELECT        BT.BUName, BT.SAPTradeMarkID, BT.TradeMarkName, TP.PackTypeID, TP.PackType, TP.PackConfID, TP.PackConf
FROM            SAP.TrademarkPackage AS TP INNER JOIN
                         MView.BranchBrand AS BT ON TP.TrademarkID = BT.SAPTradeMarkID

GO
/****** Object:  View [MView].[ChannelHier]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [MView].[ChannelHier]
As
	Select sc.SuperChannelID, SAPSuperChannelID, SuperChannelName, ChannelID, SAPChannelID, ChannelName
	From SAP.Channel c
		Join SAP.SuperChannel sc on c.SuperChannelID = sc.SuperChannelID

GO
/****** Object:  UserDefinedFunction [MView].[udfGetAllAccoutsForRouteNumber]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Function [MView].[udfGetAllAccoutsForRouteNumber]
(
	@SAPRouteNumber int
)
Returns Table
AS
Return
	Select Distinct a.AccountID, a.SAPAccountNumber, a.AccountName, lh.*, chh.*, c.*, a.Longitude, a.Latitude
	From SAP.RouteScheduleDetail rsd
		JOin SAP.RouteSchedule rs on rsd.RouteScheduleID = rs.RouteScheduleID
		Join SAP.Account a on rs.AccountID = a.AccountID
		Join SAP.SalesRoute sr on sr.RouteID = rs.RouteID
		Join Mview.LocationHier lh on a.BranchID = lh.BranchID
		Join MView.ChannelHier chh on a.ChannelID = chh.ChannelID
		Join MView.ChainHier c on a.LocalChainID = c.LocalChainID
	Where SAPRouteNumber = @SAPRouteNumber -- 113201405
	And sr.Active = 1
	And a.Active = 1


GO
/****** Object:  View [MView].[AccountRouteSchedule]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE view [MView].[AccountRouteSchedule] as  
SELECT   rsd.SequenceNumber AS StopSequence, rsd.Day AS RouteDay, b.BranchID, a.SAPAccountNumber, sr.SAPRouteNumber,a.AccountID ,a.AccountName, a.Address, a.City, a.State, a.PostalCode,   
                      nc.SPNationalChainName, ch.SAPNationalChainID,ch.NationalChainID, ch.NationalChainName, ch.RegionalChainName, ch.SAPRegionalChainID, ch.RegionalChainID, ch.LocalChainName, ch.SAPLocalChainID,ch.LocalChainID, c.SPChannelName,   
                      c.SAPChannelID, b.SAPBranchID, b.SPBranchName, b.BranchName  
FROM         SAP.RouteScheduleDetail AS rsd INNER JOIN  
                      SAP.RouteSchedule AS rs ON rsd.RouteScheduleID = rs.RouteScheduleID and rsd.Day =/*datepart (dd,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0))*/ DATEDIFF(Day, rs.StartDate, GETDATE()) % 28  INNER JOIN  
                      SAP.Account AS a ON rs.AccountID = a.AccountID INNER JOIN  
                      SAP.Branch AS b ON a.BranchID = b.BranchID INNER JOIN  
                      SAP.SalesRoute AS sr ON sr.RouteID = rs.RouteID INNER JOIN  
                      MView.ChainHier AS ch ON a.LocalChainID = ch.LocalChainID INNER JOIN  
                      SAP.NationalChain AS nc ON nc.NationalChainID = ch.NationalChainID INNER JOIN  
                      SAP.Channel AS c ON a.ChannelID = c.ChannelID  
WHERE     (sr.Active = 1) AND (a.Active = 1) ----and sr.SAPRouteNumber='108000031'




GO
/****** Object:  View [SAP].[BrachLocalChain]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [SAP].[BrachLocalChain]
AS
SELECT        lh.SAPBranchID, lh.BranchName, lh.SPBranchName, lh.BUID, lh.BUName, ch.SAPNationalChainID, ch.NationalChainName, ch.SAPRegionalChainID, 
                         ch.RegionalChainName, ch.SAPLocalChainID, ch.LocalChainName, c.SAPChannelID, c.ChannelName, a.BranchID, a.AccountID, ch.LocalChainID, ch.RegionalChainID, 
                         ch.NationalChainID, c.ChannelID
FROM            SAP.Account AS a INNER JOIN
                         MView.LocationHier AS lh ON a.BranchID = lh.BranchID INNER JOIN
                         MView.ChainHier AS ch ON a.LocalChainID = ch.LocalChainID INNER JOIN
                         SAP.Channel AS c ON a.ChannelID = c.ChannelID
WHERE        (a.Active = 1)

GO
/****** Object:  View [SAP].[BranchPackages]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [SAP].[BranchPackages]
AS
SELECT        BT.SAPBranchID, BT.BranchName, BT.SAPTradeMarkID, BT.TradeMarkName, TP.PackTypeID, TP.PackType, TP.PackConfID, TP.PackConf
FROM            SAP.TrademarkPackage AS TP INNER JOIN
                         MView.BranchBrand AS BT ON TP.TrademarkID = BT.SAPTradeMarkID

GO
/****** Object:  View [MSTR].[VChannelsForComparison]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [MSTR].[VChannelsForComparison] as
select c.ChannelId 
	from portal_data.sap.channel c
	inner join	portal_data.sap.Superchannel sc on c.superChannelId=sc.superChannelId
	inner join PORTAL_DATA.MSTR.DimSuperChannelForComparison cc on sc.SAPSuperChannelID=cc.sapSuperChannelId

GO
/****** Object:  View [MSTR].[VMyDayComparsionAccounts]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [MSTR].[VMyDayComparsionAccounts] as
select a.accountId ,B.BRANCHiD, b.branchName, lc.localChainId,lc.localChainName 
from portal_data.sap.account a 
	inner join portal_data.sap.branch b on a.branchid=b.branchid
	inner join portal_data.sap.localchain lc on a.localChainid=lc.localChainid
	inner join portal_data.mstr.VChannelsForComparison cc on a.channelId=cc.channelId
where A.ACTIVE=1 
-- provide these values
--and a.BranchID=159 and a.LocalChainID=583
group by B.BRANCHiD,b.branchName, lc.localChainName,lc.localChainId,a.accountId
GO
/****** Object:  View [MView].[BranchBrandCategory]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [MView].[BranchBrandCategory]  
AS  
SELECT        MView.BranchPackage.BUID, MView.BranchPackage.SAPBUID, MView.BranchPackage.BUName, MView.BranchPackage.RegionID,   
                         MView.BranchPackage.SAPRegionID, MView.BranchPackage.RegionName, MView.BranchPackage.BranchID, MView.BranchPackage.SAPBranchID,   
                         MView.BranchPackage.BranchName, MView.BranchPackage.InternalCategoryID, MView.BranchPackage.InternalCategoryName,   
                         MView.BranchPackage.SAPTradeMarkID, MView.BranchPackage.TradeMarkID, MView.BranchPackage.TradeMarkName, MView.BranchPackage.BrandID,   
                         MView.BranchPackage.SAPBrandID, MView.BranchPackage.BrandName, MView.BranchPackage.PackageID, MView.BranchPackage.PackageName  
FROM            PlayBook.Category INNER JOIN  
                         MView.BranchPackage ON 
                         PlayBook.Category.CategoryID = MView.BranchPackage.InternalCategoryID  
GO
/****** Object:  View [PlayBook].[PromotionAttachmentView]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [PlayBook].[PromotionAttachmentView]
as
select t.promotionid
    ,STUFF((
        select ',' + [AttachmentName] ,'#',AttachmentTypeID
        from PLAYBOOK.PromotionAttachment as t1
        where t1.PromotionID = t.promotionID
        for xml path(''), type
    ).value('.', 'varchar(max)'), 1, 1, '') [PromotionFiles]
from playbook.PromotionAttachment as t --where t.PromotionID=2
group by t.promotionid



GO
/****** Object:  View [PlayBook].[PromotionBrandView]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE view [PlayBook].[PromotionBrandView]
as
select t.promotionid
    ,STUFF((
        select ',', BrandID
        from PLAYBOOK.promotionbrand as t1
        where t1.PromotionID = t.promotionID
        for xml path(''), type
    ).value('.', 'varchar(max)'), 1, 1, '')BRANDID 
from playbook.promotionbrand as t --where t.PromotionID=2
group by t.promotionid
GO
/****** Object:  View [MSTR].[UserInBranchExtended]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE View [MSTR].[UserInBranchExtended]
As
Select up.GSN, up.FirstName, up.LastName, b.BranchID, b.SAPBranchID, b.BranchName, Convert(int, ub.IsPrimary) IsPrimary
From Person.UserInBranch ub
Join SAP.Branch b on ub.BranchID = b.BranchID
Join Person.UserProfile up on ub.GSN = up.GSN


GO
/****** Object:  View [MSTR].[ViewGeoAccount]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [MSTR].[ViewGeoAccount] as
(
SELECT top 20 [AccountID]
      ,[SAPAccountNumber]
      ,[AccountName]
      ,[ChannelID]
      ,[BranchID]
      ,[LocalChainID]
      ,[Address]
      ,[City]
      ,[State]
      ,[PostalCode]
      ,[Contact]
      ,[PhoneNumber]
      ,[Longitude]
      ,[Latitude]
      ,[Active]
  FROM [SAP].[Account])

GO
/****** Object:  View [MSTR].[ViewOFDDailyMetrics]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE VIEW [MSTR].[ViewOFDDailyMetrics] 
AS SELECT 
pvt.BranchID,
'A' as GSN,
MetricDate,
RecordDate,
coalesce ([M101],0) as 'SalesQty',
coalesce ([M102],0) as 'PreSales',
coalesce ([M103],0) as 'SalesQtyCNV',
coalesce ([M104],0) as 'LoadOut',
coalesce ([M105],0) as 'CaseCuts',
coalesce ([M106],0) as 'BuyBack',
coalesce ([M201],0) as 'ShrinkageQty',
coalesce ([M202],0) as 'BreakageQty',
coalesce ([M203],0) as 'DOS',
coalesce ([M301],0) as 'DamagesQty',
coalesce ([M302],0) as 'Damages',
coalesce ([M401],0) as 'Haulback',
coalesce ([M204],0) as 'Shrinkage',
coalesce ([M205],0) as 'Breakage',
coalesce ([M701],0) as 'ActualStops',
coalesce ([M702],0) as 'PlannedStops',
coalesce ([M703],0) as 'ActualMiles',
coalesce ([M704],0) as 'PlannedMiles',
coalesce ([M705],0) as 'ActualTimeinMins',
coalesce ([M706],0) as 'PlannedTimeinMins',
1 as 'Inventory',
2 as 'OnTimeInvoices',
3 as 'TotalInvoices'
FROM   (SELECT BranchID,MetricDate,RecordDate,MetricID,[Metric] 
        FROM   [Portal_Data].[mstr].[FactOFDDailyMetrics]
        ) src PIVOT (Max([METRIC])FOR METRICID
        IN ([M101],[M102],[M103],[M104],[M105],[M106],[M201],[M202],[M203],[M301],[M302],[M401],[M204],[M205],[M701],[M702],[M703],[M704],[M705],[M706])) pvt
        





GO
/****** Object:  View [MView].[BevBrandPack]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [MView].[BevBrandPack]
AS
SELECT        b.BevTypeID, b.BevTypeName, c.BrandID, c.BrandName, e.TradeMarkID, e.TradeMarkName, d.PackageID, d.PackageName
FROM            SAP.Material AS a INNER JOIN
                         SAP.BevType AS b ON a.BevTypeID = b.BevTypeID INNER JOIN
                         SAP.Brand AS c ON a.BrandID = c.BrandID INNER JOIN
                         SAP.TradeMark AS e ON c.TrademarkID = e.TradeMarkID INNER JOIN
                         SAP.Package AS d ON a.PackageID = d.PackageID

GO
/****** Object:  View [MView].[BranchRoute]    Script Date: 5/17/2013 3:21:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create View [MView].[BranchRoute]
As
Select b.*, sr.RouteID, sr.SAPRouteNumber, sr.RouteName
From SAP.Branch b 
	Join SAP.SalesRoute sr on b.BranchID = sr.BranchID

GO
