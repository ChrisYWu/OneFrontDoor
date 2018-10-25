use Portal_Data
Go

-- 19~22 --

Truncate Table BC.TerritoryMap
Go

exec ETL.pMergeTMapAndInclusions

exec ETL.pMergeViewTables

Select *
From BC.TerritoryMap
