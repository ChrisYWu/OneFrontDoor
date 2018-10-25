Use Portal_Data
Go

exec ETL.pMergeDSDCaseCut 20140828
Go

exec ETL.pDSDCasecutFilling 20140828
Go

exec ETL.pMergeDSDDailyBranchInventory 1
Go

exec ETL.pMergeDSDDailyMinMax 1
Go

Select Distinct DateID
From SupplyChain.tDSDDailyCaseCut
order by DateID desc

Select distinct Session_Date
From Apacheta.FleetLoader
order by Session_Date desc

