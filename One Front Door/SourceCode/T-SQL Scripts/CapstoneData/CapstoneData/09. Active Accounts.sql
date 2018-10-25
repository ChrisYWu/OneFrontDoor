use Portal_DataSRE
Go

--Select Active, CRMActive, city
Update SAP.Account
Set City = null
From SAP.Account
Where city like '%XXX%'
Go

Update SAP.Account
Set Active = null
Where InCapstone = 1
Go

MERGE SAP.Account AS a
USING (Select convert(bigint, CUSTOMER_NUMBER) CUSTOMER_NUMBER, a.ACTIVE 
		From (Select CUSTOMER_NUMBER, Max(ACTIVE) ACTIVE
				From Staging.RMAccount 
				Group By CUSTOMER_NUMBER) a
		) AS input
	ON a.SAPAccountNumber = input.CUSTOMER_NUMBER
WHEN MATCHED THEN 
	UPDATE SET ACTIVE = input.ACTIVE;
Go

Update ETL.BCDataLoadingLog
Set MergeDate = null
Where TableName in ('BCStore', 'BCBPAddress')
Go

exec ETL.pLoadFromCapstone
Go

Select *
From ETL.BCDataLoadingLog
Go

Select *
From ETL.BCDataLoadingLog

Select *
From ETL.BCAccountTerritoryMapRecreationLog

Select Count(*)
From Staging.BCTMap

Select Count(*)
From BC.TerritoryMap
Where Active = 1

--Truncate Table BC.TerritoryMap

Select Count(*)
From BC.AccountInclusion
Where Active = 1

Select Count(*)
From Staging.BCStoreInclusion
Go
