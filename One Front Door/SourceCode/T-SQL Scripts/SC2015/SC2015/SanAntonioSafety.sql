use Safety
Go

Select lost_time_id, *
From [dbo].[air_header]
Where location_id = 781
Order By accident_date desc


Select *
From dbo.lost_time