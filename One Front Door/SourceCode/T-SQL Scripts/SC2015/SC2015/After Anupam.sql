use Safety
Go

-- -- Looks like 2, 3 shoudl be what we need ---
Select *
From dbo.accidentseverity

Select *
From dbo.air_header

select *
from [dbo].[location]
where Business_Unit = 'SupplyChain'
and name like '%-- PL'

-- So AFR, LRIFR and DART only applicable to US locations/plants
Select Distinct LocationID, name, location_ID
From [dbo].[hours_by_month] h
right Join [dbo].[location] l on h.location_ID = l.LocationID
where Business_Unit = 'SupplyChain'
and name like '%-- PL'
order by name

Select l.Name, count(air_header_id) Cnt, 
	sum(lost_time_days) TodayLostTimeInDays, 
	sum(rest_duty_days) TotalRestDutyDays,
	sum(hr.hours)/count(air_header_id) PlantMonthHours,
	count(air_header_id) * count(air_header_id) * 200000/sum(hr.hours) AFR
From (select DATEADD(month, DATEDIFF(month, 0, accident_date), 0) AS StartOfMonth, * from dbo.air_header) h
Join [dbo].[location] l on h.location_ID = l.LocationID
Join [dbo].[hours_by_month] hr on hr.location_ID = l.LocationID and hr.hours_date = h.StartOfMonth
where l.Business_Unit = 'SupplyChain'
and l.name like '%-- PL'
and h.lost_time_id <> 6
And h.accident_date between '2014-03-01' And '2014-04-01'
and h.status_id <> 4 -- 4 is for deleted records
group by l.Name
Order By l.Name


------- 2012 ------------
Select l.Name, count(air_header_id) Cnt, 
	sum(lost_time_days) TodayLostTimeInDays, 
	sum(rest_duty_days) TotalRestDutyDays, sum(hr.hours) CompondHours,
	sum(hr.hours)/count(air_header_id) PlantMonthHours,
	count(air_header_id) * count(air_header_id) * 200000/sum(hr.hours) AFR
From (select DATEADD(month, DATEDIFF(month, 0, accident_date), 0) AS StartOfMonth, * from dbo.air_header) h
Join [dbo].[location] l on h.location_ID = l.LocationID
Join [dbo].[hours_by_month] hr on hr.location_ID = l.LocationID and hr.hours_date = h.StartOfMonth
where l.Business_Unit = 'SupplyChain'
and l.name like '%-- PL'
and h.lost_time_id <> 6
And h.accident_date between '2013-01-01' And '2014-01-01'
and h.status_id <> 4 -- 4 is for deleted records
group by l.Name
Order By l.Name

select top 100 *
from dbo.air_header

select top 100 datepart(year, accident_date), datepart(month, accident_date), 
	DATEADD(month, DATEDIFF(month, 0, accident_date), 0) AS StartOfMonth, *
from dbo.air_header h
where h.accident_date between '2014-03-01' And '2014-04-01'

select *
from dbo.accidentseverity

select l.name, h.*
From [dbo].[hours_by_month] h
Join [dbo].[location] l on h.location_ID = l.LocationID
where l.Business_Unit = 'SupplyChain'
and l.name like '%-- PL'
and hours_date = '2014-03-01'

---------------------------------
---------------------------------
---------------------------------
--- Take Northlake for example
Select * 
From [dbo].[location] l
where 
--l.Business_Unit = 'SupplyChain'
 l.name like '%-- PL'
--or l.name like '%-- RDC'
 order by name

-- name like '%Northlake%'
--and name like '%Carlstadt%'
--and name like '%Louisville%'


-- Location id = 750 -- 668 for Carlstadt
select *
from [dbo].[hours_by_month] h
--where location_ID = 668
where location_ID = 735
--where location_ID = 750
and hours_date = '2014-03-1'

--- 35272.00 hours for 2014-03, 9519 for Carlstadt
select *
from dbo.air_header
where location_id = 750
and accident_date between '2014-03-01' And '2014-04-01'
and lost_time_id <> 6

SELECT TOP 1000 [lost_time_id]
      ,[lost_time_desc]
      ,[lost_time_type]
      ,[eff_from]
      ,[eff_to]
      ,[sortby]
  FROM [SAFETY].[dbo].[lost_time]

/*
1	1 day	1 
2	2 days	2 
3	3+ days	3+
5	0-Days Recordable OSHA	O 
6	0-Days Non Recordable	NO
7	Lost Days	0 
11	Restricted/Light Duty Days	R 
12	Days Away	A 

*/

DARt = 7,11,12
LTIFR = 7,12

-- 4 accidents

select 200000 * 4 / 35272

Select * 
From [dbo].[location] l
--where 
--l.Business_Unit = 'SupplyChain'
--and l.name like '%-- PL'
where name like '%Northlake%'


---------------
Select location_id, hours_date, count(*)
From [dbo].[hours_by_month]
Where location_id in (select l.LocationID
	From [dbo].[location] l
	where l.name like '%-- PL')
Group By location_id, hours_date
having count(*) > 1

Select *
From dbo.hours_by_month
Where location_id = 811
and hours_date = '2013-12-01'

select *
from dbo.location
where locationId = 811


