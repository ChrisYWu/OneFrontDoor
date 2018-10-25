use Portal_Data_SREINT
Go

Select *
From ETL.BCDataLoadingLog

Select *
from Staging.BCBottler



--delete ETL.BCDataLoadingLog
--delete ETL.BCAccountTerritoryMapRecreationLog 

exec ETL.pLoadFromCapstone
exec ETL.pMergeCapstoneBottlerERH
exec ETL.pMergeCapstoneBottlerHier
exec ETL.pMergeStateCounty
exec ETL.pMergeCapstoneBottler
exec ETL.pMergeChainsAccounts
exec ETL.pReloadBCSalesAccountability
exec ETL.pMergeCapstoneProduct
exec ETL.pMergeTMapAndInclusions
exec ETL.pMergeViewTables

Select *
from ETL.BCDataLoadingLog order by logid desc

Select *
from Portal_DataSRE.ETL.BCDataLoadingLog order by logid desc

Select *
From ETL.BCAccountTerritoryMapRecreationLog

Select *
From Staging.BCStoreInclusion
