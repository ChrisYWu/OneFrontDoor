use Portal_Data
Go

Select Distinct Session_Date
From Apacheta.FleetLoader
Order By Session_Date Desc

--The duplicate key value is (20150226, 3, 150, 7214)

exec ETL.pDSDCasecutFilling