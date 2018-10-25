Use Portal_Data204
Go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

If Exists (Select * From sys.procedures Where object_id = object_id('ETL.pFillRecordables'))
Begin
	Drop Proc ETL.pFillRecordables
End
Go

/*
------ Test -------
exec ETL.pFillRecordables

Select *
From SupplyChain.tSafetyRecordable


*/

Create Proc ETL.pFillRecordables
(
	@NumberOfHistoryToPrecal int = 3
)
As
	Set NoCount On;

	Truncate Table SupplyChain.tDailySafetyRecordable

	--- AFR ---
	Insert Into SupplyChain.tDailySafetyRecordable(DateID, PlantID, AFRCount, LTIFRCount, DARTCount)
	Select DateID, PlantID, Count(SafetyAirHeaderID) Cnt, 0, 0
	From SupplyChain.AccidentHeader
	Where LostTimeTypeID <> 6
	And StatusID <> 4
	Group By DateID, PlantID

	--- DART ---
	Update r Set DARTCount = a.Cnt
	From SupplyChain.tDailySafetyRecordable r
	Join 	
	(Select DateID, PlantID, Count(SafetyAirHeaderID) Cnt
	From SupplyChain.AccidentHeader
	Where LostTimeTypeID in (7,11,12)
	And StatusID <> 4
	Group By DateID, PlantID) a On r.PlantID = a.PlantID And r.DateID = a.DateID

	--- LTIFR ---
	Update r Set LTIFRCount = a.Cnt
	From SupplyChain.tDailySafetyRecordable r
	Join 	
	(Select DateID, PlantID, Count(SafetyAirHeaderID) Cnt
	From SupplyChain.AccidentHeader
	Where LostTimeTypeID in (7,12)
	And StatusID <> 4
	Group By DateID, PlantID) a On r.PlantID = a.PlantID And r.DateID = a.DateID

	------------------------------------------------
	Truncate Table SupplyChain.tSafetyRecordable

	-- Month To Date ------
	Insert SupplyChain.tSafetyRecordable(AnchorDateID, PlantID, AggegationID, AFRCount, LTIFRCount, DARTCount, PlantHour)
	Select hr.DateID, hr.PlantID, 3, hr.AFRCount, hr.LTIFRCount, hr.DARTCount, ph.NumberOfHours
	From 
	(
		Select rt.DateID/100*100 + 1 PlantHourDateID, rt.DateID, 3 AggregationID, rt.PlantID, 
				sum(rs.AFRCount) AFRCount
				,sum(rs.LTIFRCount) LTIFRCount
				,sum(rs.DARTCount) DARTCount
		From (
				Select Distinct d.DateID, d.Date, PlantID
				From Shared.DimDate d
				Cross Join SupplyChain.Plant p
				Where d.Date <= GetDate()
				--And d.DateID > (Convert(int, Convert(Varchar, GetDate(), 112)) /10000 - @NumberOfHistoryToPrecal)*10000 -- enable this line to just keep latest n years or history
			 ) rt -- Report Date
		Join SupplyChain.tDailySafetyRecordable rs on rt.PlantID = rs.PlantID and rs.DateID <= rt.DateID And rs.DateID >= rt.DateID/100*100 + 1
		Group By rt.DateID, rt.PlantID
	) hr
	Left Join SupplyChain.PlantHour ph on hr.PlantHourDateID = ph.FirstOfMonthID And ph.PlantID = hr.PlantID

	-- Year To Date(4) ------
	Insert SupplyChain.tSafetyRecordable(AnchorDateID, PlantID, AggegationID, AFRCount, LTIFRCount, DARTCount, PlantHour)
	Select hr.DateID, hr.PlantID, 4, hr.AFRCount, hr.LTIFRCount, hr.DARTCount, ph.TotalHours
	From 
	(
		Select rt.DateID/100*100 + 1 PlantHourDateID, rt.DateID, 4 AggregationID, rt.PlantID, 
				sum(rs.AFRCount) AFRCount
				,sum(rs.LTIFRCount) LTIFRCount
				,sum(rs.DARTCount) DARTCount
		From (
				Select Distinct d.DateID, d.Date, PlantID
				From Shared.DimDate d
				Cross Join SupplyChain.Plant p
				Where d.Date <= GetDate()
				--And d.DateID > (Convert(int, Convert(Varchar, GetDate(), 112)) /10000 - @NumberOfHistoryToPrecal)*10000 -- enable this line to just keep latest n years or history
			 ) rt -- Report Date
		Join SupplyChain.tDailySafetyRecordable rs on rt.PlantID = rs.PlantID and rs.DateID <= rt.DateID And rs.DateID >= rt.DateID/10000*10000	
		Group By rt.DateID, rt.PlantID
	) hr
	Left Join 
	(
		Select phDates.PlantID, phDates.FirstOfMonthID, Sum(phAccu.NumberOfHours) TotalHours
		From SupplyChain.PlantHour phAccu
		Join SupplyChain.PlantHour phDates on phAccu.PlantID = phDates.PlantID 
		And phAccu.FirstOfMonthID / 10000 = phDates.FirstOfMonthID / 10000  -- Year Qualifier
		And phAccu.FirstOfMonthID / 100 <= phDates.FirstOfMonthID / 100      -- Month Qualifier
		Group By phDates.FirstOfMonthID, phDates.PlantID
	) ph on hr.PlantHourDateID = ph.FirstOfMonthID And ph.PlantID = hr.PlantID
	Order By DateID desc

	Update ty
	Set LYAFRCount = ly.AFRCount, 
		LYDARTCount = ly.DARTCount, 
		LYLTIFRCount = ly.LTIFRCount, 
		LYPlantHour = ly.PlantHour
	From SupplyChain.tSafetyRecordable ty
	Join
	(Select (AnchorDateID/10000+1)*10000 + AnchorDateID%10000 LYDateID, AFRCount, DARTCount, LTIFRCount, PlantHour, PlantID, AggegationID
	From SupplyChain.tSafetyRecordable) ly on ty.AnchorDateID = ly.LYDateID And ty.PlantID = ly.PlantID And ty.AggegationID = ly.AggegationID

Go
