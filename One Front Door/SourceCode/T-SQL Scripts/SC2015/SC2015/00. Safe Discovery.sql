Use Safety
Go

Select *
From dbo.[5S_Burst]

Select *
From dbo.accidentseverity

-- AddressId and Location ID
-- Has locationid
Select *
From dbo.addresses

-- Just the file for accident, header id is the business key
Select top 1 *
From dbo.air_attachment

-- air hearder id is the thing, this links to the cause of accident
Select *
From dbo.air_cause_of_accident

-- just comments tot he air header
Select *
From dbo.air_dcomments

------------
Select *
From dbo.air_email_details

-- header_id, location_Id, status_id, severity_id, accedent_date, reported_date, 
-- emp_no, emp_name, inv_gsn, inv_date, lost_time_id, lost_time_days/rest_duty_days
-- employee_time_yrs/mos and current postion, historical(details), geographical(more details)
-- Witness, circumstantial(damage made), loss of life, date of death, report_id, what is INV?(title)
-- home_location_id
Select *
From [dbo].[air_header]
where accident_date > '2013-1-1'

-- header to illness association
select * 
from [dbo].[air_illness_type]

-- header to injured body part association
select *
From [dbo].[air_injured_body_part]

-- header to injured class
select *
from [dbo].[air_injury_class]

-- header investigation
select *
from [dbo].[air_investigation]

-- some date log about header
select *
from [dbo].[air_ld_dates]

--
select *
from [dbo].[air_oienm]

-- property damage
select *
from [dbo].[air_pm_loss]

--- for each accident/header their might be some recommendation
select *
from [dbo].[air_recommendations]

-- rest date for accident?
select *
from [dbo].[air_rest_dates]

-- accident/investigation/review and followup ---
-- Repair pole and add 2 additional poles for support --
select *
from [dbo].[air_review_followup]

-- there is an root cause id
select *
from [dbo].[air_root_cause]

--- header to sp_ic_id
select *
from [dbo].[air_sp_ic]

--- header to sc_id
select *
from [dbo].[air_sub_conditions]

-- header to 3rd party
select *
from [dbo].[air_third_party]

-- 3rd party classification
select *
from [dbo].[air_third_party_details]

-- what kind of car is involved in the accident?
select *
from [dbo].[air_vehicle_report]

select *
from [dbo].[air_witness]

-- some location might have multiple names
select *
from [dbo].[alt_location]

--- empty table, good!
select * 
from [dbo].[avg_emps]

-- where is the injury?
select *
from [dbo].[body_parts]

-- p300 to location
select *
from [dbo].[c300]

-- traffic accident cause classification
select *
from [dbo].[cause_of_accident]

-- Accident classification
select *
from [dbo].[classification]

-- column refered in header table to identify how long the employee has been with the company
Select *
from [dbo].[cur_pos_yrs]

--
select *
from [dbo].[Date_Dim]

-- employee roster(potentially the gsn to emp_no association, job title is also there)
select *
from [dbo].[employees]

-- most likely referenced in air header table
select *
from [dbo].[employmenttype]

--- somebody wrote code to notify the status
select *
from [dbo].[Exception_Log]

--- fleet manager? for what?
select *
from [dbo].[fleet_manager]

--- bad data
select *
from [dbo].[GSN_Missmatch]

-- hazardous material classcification
select *
from [dbo].[hm_involved]

-----------------
Select l.Name, l.Area, l.*, h.*
From [dbo].[air_header] h
Join [dbo].[location] l on h.location_id = l.LocationID
where accident_date > '2015-1-1 00:00:00'
and accident_date < '2015-1-6 00:00:00'
--and Business_Unit = 'SupplyChain'
and status_id <> 3
and severity_id = 2
order By l.Name

select *
from [dbo].[location]

select *
from [dbo].[location]
where Business_Unit = 'SupplyChain'

-- Good/all PL location in SupplyChain'
select LocationID, Name
from [dbo].[location]
where Business_Unit = 'SupplyChain'
and name like '%-- PL'

Select 'Update SupplyChain.Plant Set SafetyLocationID = ' 

Select CharIndex(', ', Name, 1), Name, Substring(Name, 1, CharIndex(', ', Name, 1) - 1) SafetyPlantName
from [dbo].[location]
where Business_Unit = 'SupplyChain'
and name like '%-- PL'

--Albuquerque, NM -- SALES-
select *, 
from [dbo].[reportstatus]


