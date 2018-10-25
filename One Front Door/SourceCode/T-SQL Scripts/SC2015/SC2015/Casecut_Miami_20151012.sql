use Portal_Data
Go

--Select *
--From Apacheta

Select r.RegionID, r.RegionName, b.SAPBranchID, b.BranchName
From SAP.Region r
Join SAP.Area a on r.RegionID = a.RegionID
Join SAP.Branch b on b.AreaID = a.AreaID
Where RegionName = 'Southeast'

Select Sum(Quantity) Quantity, Sum(Total_Quantity) Total_Quantity, Sum(Quantity) - Sum(Total_Quantity) Cut  
From Apacheta.FleetLoader f
Join SAP.Branch b on b.SAPBranchID = Left(f.ROUTE_ID, 4)
Join SAP.Area a on b.AreaID = a.AreaID
Join SAP.Region r On r.RegionID = a.RegionID
Where SEssion_Date = '2015-01-12'
And b.SAPBranchID = '1005'

Select Sum(Quantity) Quantity, Sum(CaseCut) Cut

Select Sum(Quantity) - Sum(Total_Quantity), Sum(Quantity)
From Apacheta.FleetLoader f
Join SAP.Branch b on b.SAPBranchID = Left(f.ROUTE_ID, 4)
Join SAP.Area a on b.AreaID = a.AreaID
Join SAP.Region r On r.RegionID = a.RegionID
Where SEssion_Date = '2015-01-12'
And b.SAPBranchID = '1005'
And SKU in
(
	SElect SAPMaterialID
	From SAP.Material
	Where MaterialID in 
	(
		Select Distinct MaterialID
		From SupplyChain.tDSDDailyCaseCut
		Where DateID = 20150112
		And BranchID = 68
	)
)

Select Sum(Quantity) - Sum(Total_Quantity), Sum(Quantity)
From Apacheta.FleetLoader f
Join SAP.Branch b on b.SAPBranchID = Left(f.ROUTE_ID, 4)
Join SAP.Area a on b.AreaID = a.AreaID
Join SAP.Region r On r.RegionID = a.RegionID
Where SEssion_Date = '2015-01-12'
And b.SAPBranchID = '1005'
And SKU in
(
	SElect SAPMaterialID
	From SAP.Material
	Where MaterialID in 
	(
		Select Distinct MaterialID
		From SupplyChain.tDSDDailyCaseCut
		Where DateID = 20150112
		And BranchID = 68
	)
)

--Select Top 1 *
--From Apacheta.FleetLoader f

--Select *
--From SupplyChain.Plant

--- 1005, 1408
--Select *
--From SAP.Branch
--Where BranchName = 'Miami'

USE [Portal_Data]
GO
/****** Object:  StoredProcedure [ETL].[pMergeDSDCaseCut]    Script Date: 1/12/2015 10:23:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* 
exec ETL.pMergeDSDCaseCut 20140827

Select top 1000 * From SupplyChain.tDsdDailyCaseCut


Select Distinct BranchID
From SupplyChain.tDsdDailyCaseCut

Select Distinct(Left(ROUTE_ID, 4)) SAPSalesOffice
From Apacheta.FleetLoader
Where Left(ROUTE_ID, 4) Not In
(Select SAPBranchID From SAP.Branch)

Select *
From Apacheta.FleetLoader
Where Left(ROUTE_ID, 4) = 'PREB'

*/

ALTER Proc [ETL].[pMergeDSDCaseCut]
(
	@DateBackTo int = null
)
AS		
	Set NoCount On;

	Declare @MinDate Date;
	Declare @LogID int;

	Select Top 1 @MinDate = LatestLoadedRecordDate, @LogID = LogID
	From ETL.BCDataLoadingLog
	Where TableName = 'FleetLoader'
	And NumberOfRecordsLoaded > 0
	And IsMerged = 0

	--------------------------------------
	--If (@DateBackTo is not null)
	--Begin
	--	Set @MinDate = SupplyChain.udfConvertToDate(@DateBackTo)
	--	Set @LogID = null
	--End

	--------------------------------------
	--------------------------------------
	If (@MinDate is null) -- Alredy merged and won't merge again
		return
	--------------------------------------
	--------------------------------------
	Select Sum(rd.Quantity - rd.Total_Quantity)
	From 
		(Select SESSION_DATE, Left(ROUTE_ID, 4) SAPSalesOffice, SKU, Sum(QUANTITY) Quantity, Sum(Total_QUANTITY) Total_Quantity
		From Apacheta.FleetLoader
		Where SESSION_DATE = '2015-01-12'
		And QUANTITY > 0
		Group By SESSION_DATE, Left(ROUTE_ID, 4), SKU) rd
	Join Shared.DimDate d on rd.SESSION_DATE = d.Date
	Join SAP.Branch b on rd.SAPSalesOffice = b.SAPBranchID
	Left Join SAP.Area a on b.AreaID = a.AreaID
	Join SAP.Material m on rd.SKU = m.SAPMaterialID
	Left Join SAP.Brand bd on m.BrandID = bd.BrandID
	Left Join SAP.TradeMark t on bd.TrademarkID = t.TradeMarkID
	Left Join SAP.Package p on m.PackageID = p.PackageID
	Where BranchID = 68
	And Quantity > 0
	And Quantity > Total_Quantity

	-- Why not use the same insert query? I don't remember
	Update total
	Set CaseCut = cc.CaseCut,
	UpdateDate = SYSDATETIME()
	From SupplyChain.tDsdDailyCaseCut total
	Join 
		(
			Select Sum(rd.CaseCut)
			From 
				(
					Select SESSION_DATE, Left(ROUTE_ID, 4) SAPSalesOffice, SKU, 
						Sum(QUANTITY - TOTAL_QUANTITY) CaseCut, 
						Sum(QUANTITY) Quantity
					From Apacheta.FleetLoader
					Where 
					QUANTITY > 0
					And SESSION_DATE = '2015-01-12'
					And QUANTITY > TOTAL_QUANTITY 
					Group By SESSION_DATE, Left(ROUTE_ID, 4), SKU
				) rd
			Join SAP.Branch b on rd.SAPSalesOffice = b.SAPBranchID
			Join SAP.Material m on rd.SKU = m.SAPMaterialID
			Join Shared.DimDate d on rd.SESSION_DATE = d.Date
			And BranchId = 68
		) as cc on cc.BranchID = total.BranchID And cc.DateID = total.DateID And cc.MaterialID = total.MaterialID

Select SESSION_DATE, Left(ROUTE_ID, 4) SAPSalesOffice, SKU, 
	QUANTITY, TOTAL_QUANTITY
From Apacheta.FleetLoader
Where 
QUANTITY > 0
And SESSION_DATE = '2015-01-12'
And QUANTITY < TOTAL_QUANTITY 

Select *
From SAP.material
Where SAPMaterialID = '10000904'


	----------------------------------------
	----------------------------------------
	Update ETL.BCDataLoadingLog
	Set MergeDate = SYSDATETIME()
	Where  LogID = @LogID
	----------------------------------------
	----------------------------------------








