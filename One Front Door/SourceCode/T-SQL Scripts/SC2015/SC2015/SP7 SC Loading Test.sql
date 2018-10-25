use Portal_Data204
Go

Select Distinct CalendarDate
From SAP.BP7PlantInventory
Order By CalendarDate desc

Select Distinct CalendarDate
From Staging.BP7DailyPlantInventory
Order By CalendarDate desc

Select Distinct CalendarDate
From Staging.BP7DailySalesOfficeInventory
Order By CalendarDate desc

Select Distinct CalendarDate
From Staging.BP7DailySalesOfficeMinMax
Order By CalendarDate desc

exec ETL.pMergeDSDDailyBranchInventory
exec ETL.pMergeDSDDailyMinMax
exec ETL.pMergePlantInventory

---------------------------------
SElect Distinct DateID
From SupplyChain.tDsdDailyBranchInventory
Order By DateID desc

SElect Distinct DateID
From SupplyChain.tDsdDailyMinMax
Order By DateID desc
