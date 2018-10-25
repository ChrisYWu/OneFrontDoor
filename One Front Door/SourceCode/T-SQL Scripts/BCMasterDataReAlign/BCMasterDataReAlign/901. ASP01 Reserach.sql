/****** Script for SelectTopNRows command from SSMS  ******/
Use [Portal_Data]
Go

SELECT [DownTimeID]
      ,[DownTimeSK]
      ,dls.[DayLineShiftID]
	  ,dls.*
      ,[ItemNumber]
      ,[Duration]
      ,[ReasonDetailID]
      ,[ClaimedReasonID]
      ,[LaborReleased]
  FROM [SupplyChain].[DownTime] dt
  Join SupplyChain.DayLineShift dls on dt.DayLineShiftID = dls.DayLineShiftID
  Where LIneID = 117
  And RunDateID Between 20150501 And 20150531
  And ClaimedReasonID = 7


  --Select *
  --From SupplyChain.Line 
  --Where LineName like 'ASP01'
Select *
From SupplyChain.DownTimeReason

Select *
From SupplyChain.tLineDailyKPI
Where LineID = 117
And DateID Between 20150501 And 20150531

Select *
From SupplyChain.Line
Order By LineName 

Select downtime_id, d.hdr_id,downtime_duration, downtime_reason_id, d.insert_date, d.update_date, 
	d.insert_by, d.update_by, item_number, downtime_reason_detail_id, labor_released, h.* 
From AIRVDB02.Production.dbo.downtime d with(nolock)
	join AIRVDB02.Production.dbo.production_hdr h with(nolock) on d.hdr_id = h.hdr_id
Where Line_ID = 91
And run_date between '2015-05-01' and '2015-06-01'
and downtime_reason_id = 6


select top 100 hdr_id, run_date, shift_duration, line_id, shift_id, insert_date, update_date, insert_by, update_by
from AIRVDB02.Production.dbo.production_hdr hdr with(nolock)
Where Line_ID = 91
And run_date between '2015-05-01' and '2015-06-01'



