USE [Portal_Data]
GO
/****** Object:  StoredProcedure [ETL].[pMergeDSDDailyMinMax]    Script Date: 1/8/2015 10:24:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* 
exec ETL.pMergeDSDDailyMinMax
exec ETL.pMergeDSDDailyMinMax 1

select Distinct DateID from SupplyChain.tDsdDailyMinMax
Order by DateID desc

*/

ALTER Proc [ETL].[pMergeDSDDailyMinMax]
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

	Select @MaxProcessed = Max(DateID) From SupplyChain.tDsdDailyMinMax
	Select @MaxRaw = Max(CalendarDate) From Staging.BP7DailySalesOfficeMinMax

	--- The ForceDataReload flag even suppress @RefreshAll
	If (@ForceDataReload = 0 And (@MaxProcessed = @MaxRaw))
	Begin
		Select 'Early Return' As Result
		Return
	End
	Else
		
	Begin
		--------- ELSE BRANCH --------------

		Declare @CalendarDate int;
		Declare @UnderTolerance decimal(5,1)
		Set @UnderTolerance = 0.5
		Declare @OverTolerance decimal(5,1)
		Set @OverTolerance = 1.2
		--------------------------------------
		--------------------------------------

		If (@Refreshall = 0) 
		Begin
			Delete cc
			From SupplyChain.tDsdDailyMinMax cc
			Where cc.DateID in (
				Select Distinct CalendarDate
				From Staging.BP7DailySalesOfficeMinMax
			)
		End
		Else
		Begin
			Truncate Table SupplyChain.tDsdDailyMinMax
		End

		----------------------------------------------------
		Insert Into SupplyChain.tDsdDailyMinMax
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
			   ,EndingInventoryCapped
			   ,MaxStock
			   ,SafetyStock
			   ,AvailableStock
			   ,MinSafetyStock
			   ,IsBelowMin
			   ,IsCompliant
			   ,IsAboveMax
			   ,UpdateDate)
		SELECT minMax.CalendarDate, bu.BUID, r.RegionID, a.AreaID, BranchID, 
			t.ProductLineID, t.TradeMarkID, bd.BrandID, m.MaterialID, p.PackageID, p.PackageConfID, p.PackageTypeID
			, EndingInventory,
			Case When EndingInventory < 0 Then 0 Else EndingInventory End EndingInventoryCapped, 
			 MaxStock, SafetyStock, AvailableStock, MinSafetyStock
			,Case When MinSafetyStock <> 0 And AvailableStock < MinSafetyStock * @UnderTolerance Then 1 Else 0 End
			,Case When MinSafetyStock = 0 OR (AvailableStock >= MinSafetyStock * @UnderTolerance And AvailableStock <= MaxStock * @OverTolerance) OR (MaxStock = 0) Then 1 Else 0 End
			,Case When MaxStock <> 0 And AvailableStock > MaxStock * @OverTolerance Then 1 Else 0 End
			,SYSDATETIME()
		FROM SAP.BP7SalesOfficeMinMax minmax
		Join SAP.Branch b on minmax.SAPSalesOfficeNumber = b.SAPBranchID
		Left Join SAP.Area a on b.AreaID = a.AreaID
		Left Join SAP.Region r on a.RegionID = r.RegionID
		Left Join SAP.BusinessUnit bu on r.BUID = bu.BUID
		Join SAP.Material m on m.SAPMaterialNumber = minmax.SAPMaterialID
		Left Join SAP.Brand bd on m.BrandID = bd.BrandID
		Left Join SAP.TradeMark t on bd.TrademarkID = t.TradeMarkID
		Left Join SAP.Package p on m.PackageID = p.PackageID
		Where 
		(@Refreshall = 1)
		Or
		(CalendarDate in (
				Select Distinct CalendarDate
				From Staging.BP7DailySalesOfficeMinMax
			)
		)
		--------- END OF ELSE BRANCH --------------
	End
Go
