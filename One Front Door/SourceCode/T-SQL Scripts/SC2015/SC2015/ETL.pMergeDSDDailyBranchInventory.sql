USE [Portal_Data]
GO
/****** Object:  StoredProcedure [ETL].[pMergeDSDDailyBranchInventory]    Script Date: 1/16/2015 1:35:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Select *
--From SupplyChain

--Select Distinct b.SAPMaterialID

--Select Distinct t.TradeMarkID, t.TradeMarkName
--From SAP.BP7SalesOfficeInventory b
--Join SAP.Material m on b.SAPMaterialID = m.SAPMaterialNumber
--Join SAP.Brand bd on m.BrandID = bd.BrandID
--Join SAP.TradeMark t on bd.TrademarkID = t.TradeMarkID
--Where CalendarDate = 20141125
--And SAPSalesOfficeNumber = 1108
--Order by TradeMarkName

--Select *
--From SAP.Material

--Select *
--From SAP.TradeMark

--Select SAPPlantID, BranchName, SAPBranchID, BranchID
--From SAP.Branch
--Order By SAPPlantID




-------------------------------
--Select *
--From SAP.Branch
--Where BranchName = 'Austin'


/* 
exec ETL.pMergeDSDDailyBranchInventory

exec ETL.pMergeDSDDailyBranchInventory 1

--what is 1188? BC BU, ignored intentaionally
Select *
From SupplyChain.tDsdDailyBranchInventory
Where DateID = 20141014


select DateID, MaterialID, BranchID, Past31DaysXferOutPlusShipment 
from SupplyChain.tDsdDailyBranchInventory
Where DateID = 20141013

Select DateID, Sum(Case When CustomerShipment < 0 Then CustomerShipment*-1 Else 0 End ) + Sum(Case When TransferOut < 0 Then TransferOut*-1 Else 0 End)
Select *

Select Sum(Case When CustomerShipment < 0 Then CustomerShipment*-1 Else 0 End ) + Sum(Case When TransferOut < 0 Then TransferOut*-1 Else 0 End)
From SupplyChain.tDsdDailyBranchInventory
Where DateID > 20140912 and DateID <= 20141013
And BranchID = 1
And MaterialID = 37

Select Distinct DateID, UpdateDate
From SupplyChain.tDsdDailyBranchInventory
Order By DateID Desc

exec ETL.pMergeDSDDailyBranchInventory 1

*/

ALTER Proc [ETL].[pMergeDSDDailyBranchInventory]
(
	@Refreshall bit = 0
)
AS		
	Set NoCount On;
	
	Declare @ForceDataReload bit
	Declare @MaxProcessed int
	Declare @MaxRaw int

	Select @ForceDataReload = Convert(bit, ConfigValue)
	From Settings.Configuration
	Where ConfigKey = 'ForceSCDataReload'

	Select @MaxProcessed = Max(DateID) From SupplyChain.tDsdDailyBranchInventory
	Select @MaxRaw = Max(CalendarDate) From Staging.BP7DailySalesOfficeInventory

	--- The ForceDataReload flag even suppress @RefreshAll
	If (@ForceDataReload = 0 And (@MaxProcessed = @MaxRaw))
	Begin
		Select 'Early Return' As Result
		Return
	End
	Else
		
	Begin
		--------- ELSE BRANCH --------------

		Declare @DateIDEffective int;

		Select @DateIDEffective = Min(CalendarDate)
		From Staging.BP7DailySalesOfficeInventory
		--------------------------------------
		--------------------------------------

		If (@Refreshall = 0) 
		Begin
			Delete cc
			From SupplyChain.tDsdDailyBranchInventory cc
			Where cc.DateID >= @DateIDEffective
		End
		Else
		Begin
	
			Truncate Table SupplyChain.tDsdDailyBranchInventory
		End

		--------------------------------------------------
		Insert Into SupplyChain.tDsdDailyBranchInventory
			   (DateID
			   ,BUID
			   ,RegionID
			   ,AreaID
			   ,BranchID
			   ,ProductLineID
			   ,TradeMarkID
			   ,BrandID
			   ,MaterialID
			   ,PackageID
			   ,PackageConfID
			   ,PackageTypeID
			   ,EndingInventory
			   ,TransferOut
			   ,CustomerShipment
			   ,EndingInventoryCapped
			   ,TransferOutCapped
			   ,CustomerShipmentCapped
			   ,UpdateDate)
		SELECT minMax.CalendarDate, bu.BUID, r.RegionID, a.AreaID, BranchID, 
			t.ProductLineID, t.TradeMarkID, bd.BrandID, m.MaterialID, p.PackageID, p.PackageConfID, p.PackageTypeID
			, EndingInventory, TransferOut, CustomerShipment
			, Case When EndingInventory < 0 Then 0 Else EndingInventory End
			, Case When TransferOut > 0 Then 0 Else TransferOut End
			, Case When CustomerShipment > 0 Then 0 Else CustomerShipment End
			,SYSDATETIME()
		FROM SAP.BP7SalesOfficeInventory minmax
		Join SAP.Branch b on minmax.SAPSalesOfficeNumber = b.SAPBranchID
		Left Join SAP.Area a on b.AreaID = a.AreaID
		Left Join SAP.Region r on a.RegionID = r.RegionID
		Left Join SAP.BusinessUnit bu on r.BUID = bu.BUID
		Join SAP.Material m on m.SAPMaterialNumber = minmax.SAPMaterialID
		Left Join SAP.Brand bd on m.BrandID = bd.BrandID
		Left Join SAP.TradeMark t on bd.TrademarkID = t.TradeMarkID
		Left Join SAP.Package p on m.PackageID = p.PackageID
		Where @Refreshall = 1 Or CalendarDate >= @DateIDEffective

		Update inv
		Set Past31DaysXferOutPlusShipment = agg.Past30DaysXferOutPlusShipment, UpdateDate = SYSDATETIME(),
			Past31DaysShipment = agg.Past30DaysShipment,
			DOS = Case When agg.Past30DaysXferOutPlusShipment = 0 Then 0 -- 999999 for infinity					
					   Else EndingInventory / agg.Past30DaysXferOutPlusShipment * 30
					   End,
			DOSShipment = Case When agg.Past30DaysShipment = 0 Then 0 -- 999999 for infinity					
					   Else EndingInventory / agg.Past30DaysShipment * 30
					   End
		From SupplyChain.tDsdDailyBranchInventory inv
		Join 
		(
			Select r.DateID, NonDapped.BranchID, NonDapped.MaterialID, Sum(-1.0*TransferOut + -1.0*CustomerShipment) Past30DaysXferOutPlusShipment, Sum(-1.0*CustomerShipment) Past30DaysShipment
			From Shared.DimDate R
			Join SupplyChain.tDsdDailyBranchInventory NonDapped on NonDapped.DateID > R.Last31DaysBeginingDateID And NonDapped.DateID <= R.DateID
			Where  @Refreshall = 1 Or R.DateID >= @DateIDEffective
			Group By r.DateID, NonDapped.BranchID, NonDapped.MaterialID ) agg on inv.BranchID = agg.BranchID And inv.MaterialID = agg.MaterialID And inv.DateID = agg.DateID
		--------- END OF ELSE BRANCH --------------
	End

	--Select Sum(Case When CustomerShipment < 0 Then CustomerShipment*-1 Else 0 End ) + Sum(Case When TransferOut < 0 Then TransferOut*-1 Else 0 End)
	--From SupplyChain.tDsdDailyBranchInventory
	--Where DateID > 20140912 and DateID <= 20141013
	--And BranchID = 1
	--And MaterialID = 37

	--Select *
	--From SupplyChain.tDsdDailyBranchInventory
	--Where DateID > 20140912 and DateID <= 20141013
	--And BranchID = 1
	--And MaterialID = 37

	--Select DateID, Last31DaysBeginingDateID
	--From Shared.DimDate
	--Where DateID = 20141013

	--Select DateID, MaterialID, BranchID, TransferOut, CustomerShipment, EndingInventory
	--From
	--(
	--	Select DateID, MaterialID, BranchID, 
	--		Case When TransferOut < 0 Then TransferOut*-1 Else 0 End TransferOut, 
	--		Case When CustomerShipment < 0 Then CustomerShipment*-1 Else 0 End CustomerShipment,
	--		EndingInventory
	--	From SupplyChain.tDsdDailyBranchInventory
	--) Capped

	--Select *
	--From SupplyChain.tDsdDailyBranchInventory
	--Where TransferOut > 0
