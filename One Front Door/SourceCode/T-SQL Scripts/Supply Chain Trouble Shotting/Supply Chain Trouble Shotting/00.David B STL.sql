use Portal_Data
Go

Select *
From SupplyChain.Plant
Where PlantDesc = 'Concentrate (STL)'

Select *
From SupplyChain.Line
Where LineName = 'CON04'

-----------------------------------
Select *
From SupplyChain.DayLineShift dls
Join SupplyChain.Line l on dls.LineID = l.LineID
Where l.PlantID = 22
And RunDateID between 20150201 And 20150215
And LineName = 'CON04'

-----------

Select *
From AIRVDB02.Production.dbo.production_hdr 
Where run_date between '2015-02-01' and '2015-02-15'
and Line_id = 138
order by run_date

------------*******************************------------

Select dls.ShiftDuration, r.runDuration, r.*
From SupplyChain.DayLineShift dls
Join SupplyChain.Line l on dls.LineID = l.LineID
Join SupplyChain.Run r on r.DayLineShiftID = dls.DayLineShiftID
Where l.PlantID = 22
And RunDateID between 20150201 And 20150215
And LineName = 'CON04'

Select sum(r.RunDuration) RunDuration, sum(r.ActualQty) ActualQty, sum(r.CapacityQty) CapacityQty
From SupplyChain.DayLineShift dls
Join SupplyChain.Line l on dls.LineID = l.LineID
Join SupplyChain.Run r on r.DayLineShiftID = dls.DayLineShiftID
Where l.PlantID = 22
And RunDateID between 20150201 And 20150215
And LineName = 'CON04'

Select 3277.00/3379.00 + 100.0/3031

--Select top 10 *
--From SupplyChain.Run

Select shift_duration, run_duration, hdr.*, run.*
From AIRVDB02.Production.dbo.production_hdr hdr
Join AIRVDB02.Production.dbo.production_run run on hdr.hdr_id = run.hdr_id
Where run_date between '2015-02-01' and '2015-02-15'
and Line_id = 138


-----------------------****************************

Select *
From AIRVDB02.Production.dbo.downtime_reason

Select downtime_id, d.hdr_id,downtime_duration, downtime_reason_id, d.insert_date, d.update_date, 
		d.insert_by, d.update_by, item_number, downtime_reason_detail_id, labor_released 
From AIRVDB02.Production.dbo.downtime d with(nolock)
Join AIRVDB02.Production.dbo.production_hdr hdr with(nolock) on d.hdr_id = hdr.hdr_id
Where run_date between '2015-02-01' and '2015-02-15'
and Line_id = 138
Order By d.downtime_id

Select *
From AIRVDB02.Production.dbo.production_run 
where hdr_id = 384397

Select *
From AIRVDB02.Production.dbo.production_hdr
where hdr_id = 384397

Select *
from SupplyChain.Plant




--Select dls.ShiftDuration, r.runDuration, r.*
--From SupplyChain.DayLineShift dls
--Join SupplyChain.Line l on dls.LineID = l.LineID
--Join SupplyChain.Run r on r.DayLineShiftID = dls.DayLineShiftID
--Where l.PlantID = 22
--And RunDateID between 20150201 And 20150215
--And LineName = 'CON04'

Select reason.*, dt.*, dls.*
From SupplyChain.DownTime dt
Join SupplyChain.DayLineShift dls on dt.DayLineShiftID = dls.DayLineShiftID
Join SupplyChain.Line l on dls.LineID = l.LineID
Join SupplyChain.DownTimeReason reason on dt.ClaimedReasonID = reason.ReasonID
Where l.PlantID = 22
And RunDateID between 20150201 And 20150215
And LineName = 'CON04'
Order By DownTimeSK

Select *
From SupplyChain.DownTimeReason

Select *
From SupplyChain.DownTimeReasonType

Select DownTimeSK
From SupplyChain.DownTime
Group By DownTimeSK
Having Count(*) > 1

Select DayLineShiftSK, count(*)
From SupplyChain.DayLineShift
Group By DayLineShiftSK
Having count(*) > 1









Select distinct run_date
From AIRVDB02.Production.dbo.production_hdr 
Where run_date between '2015-02-01' and '2015-02-15'
order by run_date

select *
From AIRVDB02.Production.dbo.line
Where Line = 'CON04'

Select *
From SupplyChain.tLineKPI
Where AnchorDateID = 20150215 And AggregationID = 3 And LineID = 99

Select *
From SupplyChain.Line
Where LineName = 'CON04'

Select *
From SupplyChain.TimeAggregation

Select dls.RunDateID, dls.LineID, isnull(Sum(dt.Duration), 0) SumDuration, isnull(Count(dt.DownTimeID), 0) Cnt
From SupplyChain.DownTime dt
Join SupplyChain.DownTimeReason reason on dt.ClaimedReasonID = reason.ReasonID
Join SupplyChain.DayLineShift dls on dt.DayLineShiftID = dls.DayLineShiftID
Where DownTimeReasonTypeID = 3
And LineID = 99
And RunDateID between 20150201 And 20150215
Group By dls.RunDateID, dls.LineID

Select *
From SupplyChain.tLineDailyKPI
Where LineID = 99
And DateID between 20150201 And 20150215