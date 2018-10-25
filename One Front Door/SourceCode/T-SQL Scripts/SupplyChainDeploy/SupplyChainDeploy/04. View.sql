USE [Portal_Data]
GO
/****** Object:  View [MView].[vBP7PlantInventory]    Script Date: 12/12/2014 10:57:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create View [MView].[vBP7PlantInventory]
As
	Select SAPPlantNumber
		  ,SAPSalesOfficeNumber
		  ,SAPMaterialID
		  ,CalendarDate
		  ,TransferOut
		  ,CustomerShipment
		  ,EndingInventory
	From SAP.BP7PlantInventory
	Where SAPPlantNumber <> 1404
	Union
	Select 1403
		  ,SAPSalesOfficeNumber
		  ,SAPMaterialID
		  ,CalendarDate
		  ,TransferOut
		  ,CustomerShipment
		  ,EndingInventory
	From SAP.BP7PlantInventory
	Where SAPPlantNumber = 1404


GO
/****** Object:  View [SupplyChain].[vBranchThreshold]    Script Date: 12/12/2014 10:57:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create View [SupplyChain].[vBranchThreshold]
As
Select b.BranchID
	   ,coalesce(bt.BranchOOSLeftThreshold,rt.RegionOOSLeftThreshold, OAT.OverAllOOSLeftThreshold) as BranchOOSLeftThreshold
	   ,coalesce(bt.BranchOOSRightThreshold,rt.RegionOOSRightThreshold, OAT.OverAllOOSRightThreshold) as BranchOOSRightThreshold
	   ,coalesce(bt.BranchDOSLeftThreshold,rt.RegionDOSLeftThreshold, OAT.OverAllDOSLeftThreshold) as BranchDOSLeftThreshold
	   ,coalesce(bt.BranchDOSRightThreshold,rt.RegionDOSRightThreshold, OAT.OverAllDOSRightThreshold) as BranchDOSRightThreshold
	   ,coalesce(bt.BranchMinMaxLeftThreshold,rt.RegionMinMaxLeftThreshold, OAT.OverAllMinMaxLeftThreshold) as BranchMinMaxLeftThreshold
	   ,coalesce(bt.BranchMinMaxRightThreshold,rt.RegionMinMaxRightThreshold, OAT.OverAllMinMaxRightThreshold) as BranchMinMaxRightThreshold
		from MView.LocationHier as b 
		Left Outer Join SupplyChain.BranchThreshold as bt on b.BranchID = bt.BranchID
		Left Outer Join SupplyChain.RegionThreshold as rt on b.RegionID = rt.RegionID
		Cross Join SupplyChain.OverAllThreshold as OAT

GO
/****** Object:  View [SupplyChain].[vDate]    Script Date: 12/12/2014 10:57:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE View [SupplyChain].[vDate]
As
Select DateID, Date, Day, DaySuffix, DayOfWeek, DOWInMonth, DayOfYear, WeekOfYear, WeekOfMonth, Month, MonthName, Quarter, QuarterName, Year, StandardDate, HolidayText
From Shared.DimDate
Where DateID >= (Select Min(RunDateID) From SupplyChain.DayLineShift)
And DateID <= (Select Max(RunDateID) From SupplyChain.DayLineShift)


GO
/****** Object:  View [SupplyChain].[vDimLine]    Script Date: 12/12/2014 10:57:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create View [SupplyChain].[vDimLine]
As
Select l.LineID, l.LineName, ft.FillerTypeName, lt.LineTypeName, l.PlantID
From SupplyChain.Line l
Left Join SupplyChain.FillerType ft on l.FillerTypeID = ft.FillerTypeID
Left Join SupplyChain.LineType lt on l.LineTypeID = lt.LineTypeID



GO
/****** Object:  View [SupplyChain].[vDimPlant]    Script Date: 12/12/2014 10:57:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create View [SupplyChain].[vDimPlant]
As
Select p.PlantID, p.PlantName, p.PlantDesc, p.RegionID, pt.PlantTypeName
From SupplyChain.Plant p
Join SupplyChain.PlantType pt on p.PlantTypeID = pt.PlantTypeID



GO
/****** Object:  View [SupplyChain].[vDimReason]    Script Date: 12/12/2014 10:57:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create View [SupplyChain].[vDimReason]
As
Select drt.DownTimeReasonTypeName, dr.ReasonDesc, dr.ReasonID
From SupplyChain.DownTimeReason dr
Join SupplyChain.DownTimeReasonType drt on dr.DownTimeReasonTypeID = drt.DownTimeReasonTypeID



GO
/****** Object:  View [SupplyChain].[vFactDownTime]    Script Date: 12/12/2014 10:57:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Select DayLineShiftID, DayLineShiftSK, ShiftDuration, RunDurationSum
--From (
--Select dls.DayLineShiftID, dls.DayLineShiftSK, dls.ShiftDuration, Sum(r.RunDuration) RunDurationSum
--From SupplyChain.DayLineShift dls
--Join SupplyChain.Run r on dls.DayLineShiftSK = r.DayLineShiftSK
--Group by dls.DayLineShiftID, dls.DayLineShiftSK, dls.ShiftDuration) temp
--Where ShiftDuration <> RunDurationSum

--Select *
--From SupplyChain.DayLineShift dls
--Join SupplyChain.DownTime d on (dls.DayLineShiftID = d.DayLineShiftID)
--Where ShiftDuration = 0
--And d.Duration > 0

--SElect *
--From SupplyChain.run
--Where DayLineShiftSK = 251713


Create View [SupplyChain].[vFactDownTime]
As
Select dr.DownTimeID, dls.DayLineShiftID, dr.ClaimedReasonID ReasonID, Convert(Decimal(9,2), dr.Duration) DownTimeDuration, 
	dls.ShiftDownTime, dls.ShiftDuration, dls.RunDateID, dls.LineID, dls.ShiftID
From SupplyChain.DownTime dr
Join SupplyChain.DayLineShift dls on dr.DayLineShiftID = dls.DayLineShiftID
Where ShiftDuration > 0
--Join SupplyChain.Shift s on dls.ShiftID = s.ShiftID



GO
/****** Object:  View [SupplyChain].[vLocation]    Script Date: 12/12/2014 10:57:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create View [SupplyChain].[vLocation]
As
Select d.DivisionID, d.DivisionName, r.RegionID, r.RegionName, p.PlantID, p.PlantName, p.PlantDesc
From SupplyChain.Division d
Join SupplyChain.Region r on d.DivisionID = r.DivisionID
Join SupplyChain.Plant p on r.RegionID = p.RegionID



GO
/****** Object:  View [SupplyChain].[vMaterial]    Script Date: 12/12/2014 10:57:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create View [SupplyChain].[vMaterial]
As
Select m.MaterialID, m.MaterialName, f.FranchisorID, f.FranchisorName,
	bt.BevTypeID, bt.BevTypeName,
	b.BrandID, b.BrandName,
	tm.TradeMarkID, tm.TradeMarkName,
	fv.FlavorID, fv.FlavorName,
	pk.PackageID, pk.PackageName,
	pc.PackageConfID, pc.PackageConfName,
	pt.PackageTypeID, pt.PackageTypeName,
	cc.CalorieClassID, cc.CalorieClassName,
	ic.InternalCategoryID, ic.InternalCategoryName,
	ccl.CaffeineClaimID, ccl.CaffeineClaimName,
	ppg.PPGID, ppg.PPGName
From SAP.Material m
Left Join SAP.Franchisor f on m.FranchisorID = f.FranchisorID
Left Join SAP.BevType bt on m.BevTypeID = bt.BevTypeID
Left Join SAP.Brand b on m.BrandID = b.BrandID
Left Join SAP.TradeMark tm on b.TrademarkID = tm.TradeMarkID
Left Join SAP.Flavor fv on m.FlavorID = fv.FlavorID
Left Join SAP.Package pk on m.PackageID = pk.PackageID
Left Join SAP.PackageConf pc on pk.PackageConfID = pc.PackageConfID
Left Join SAP.PackageType pt on pt.PackageTypeID = pk.PackageID
Left Join SAP.CalorieClass cc on m.CalorieClassID = cc.CalorieClassID
Left Join SAP.InternalCategory ic on m.InternalCategoryID = ic.InternalCategoryID
Left Join SAP.CaffeineClaim ccl on m.CaffeineClaimID = ccl.CaffeineClaimID
Left Join SAP.PromoProductGroup ppg on m.PPGID = ppg.PPGID



GO
/****** Object:  View [SupplyChain].[vPtKPIs]    Script Date: 12/12/2014 10:57:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create View [SupplyChain].[vPtKPIs]
As
Select l.LineName, lt.LineTypeName, ft.FillerTypeName,
p.PlantName, p.PlantDesc, p.PlantID, p.PlantRTM, p.PlantManagerGSN, p.PlantSK,
ta.Name TimePeroid, ta.SortOrder, kpi.LineID, kpi.DateID,
SumActualQty, SumCapacityQty, SumPlanQty, SumDuration, SumCODuration, CountFlavorCO, SumFlavorCODuration
From SupplyChain.TimeAggregation ta
Join 
(
		Select 1 AggregationID, LineID, DateID, a.SumActualQty, a.SumCapacityQty, a.SumPlanQty, a.SumDuration, a.SumCODuration, a.CountFlavorCO, a.SumFlavorCODuration
			--, a.AdjustedSumCODuration
			--,TME, AvgFlavorCODuration, 
			--,Case When CountFlavorCO = 0 Then Null Else SumFlavorCODuration/CountFlavorCO End AvgFlavorCODuration1
			--,SumActualQty/SumCapacityQty + SumCODuration/SumDuration TME1
		From SupplyChain.tLineDailyKPI a
		--Order By DateID DESC
		Union All
		Select AggregationID, LineID, AnchorDateID, SumActualQty, SumCapacityQty, SumPlanQty, SumDuration, SumCODuration, CountFlavorCO, SumFlavorCODuration
		From SupplyChain.tLineKPI
) kpi on ta.AggregationID = kpi.AggregationID
Join SupplyChain.Line l on kpi.LineID = l.LineID
Left Join SupplyChain.LineType lt on l.LineTypeID = lt.LineTypeID 
Left Join SupplyChain.FillerType ft on l.FillerTypeID = ft.FillerTypeID
Join SupplyChain.Plant p on l.PlantID = p.PlantID


GO
/****** Object:  View [SupplyChain].[vRegionThreshold]    Script Date: 12/12/2014 10:57:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create View [SupplyChain].[vRegionThreshold]
As
Select r.RegionID
	   ,coalesce(rt.RegionOOSLeftThreshold, OAT.OverAllOOSLeftThreshold) as RegionOOSLeftThreshold
	   ,coalesce(rt.RegionOOSRightThreshold, OAT.OverAllOOSRightThreshold) as RegionOOSRightThreshold
	   ,coalesce(rt.RegionDOSLeftThreshold, OAT.OverAllDOSLeftThreshold) as RegionDOSLeftThreshold
	   ,coalesce(rt.RegionDOSRightThreshold, OAT.OverAllDOSRightThreshold) as RegionDOSRightThreshold
	   ,coalesce(rt.RegionMinMaxLeftThreshold, OAT.OverAllMinMaxLeftThreshold) as RegionMinMaxLeftThreshold
	   ,coalesce(rt.RegionMinMaxRightThreshold, OAT.OverAllMinMaxRightThreshold) as RegionMinMaxRightThreshold
		from SAP.Region as r 
		Inner Join SupplyChain.RegionThreshold as rt on r.RegionID = rt.RegionID
		Cross Join SupplyChain.OverAllThreshold as OAT

GO
/****** Object:  View [SupplyChain].[vRun]    Script Date: 12/12/2014 10:57:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create View [SupplyChain].[vRun]
As
Select r.RunID, r.RunDuration, r.ActualQty, r.PlanQty, r.CapacityQty, r.MaterialID, dls.RunDateID DateID, dls.LineID, dls.ShiftID
From SupplyChain.Run r
Join SupplyChain.DayLineShift dls on r.DayLineShiftID = dls.DayLineShiftID



GO
