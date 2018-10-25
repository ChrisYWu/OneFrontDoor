Use Portal_Data
Go

Select Count(*)
From staging.BCStore

exec ETL.pNormalizeChains
exec ETL.pLoadFromRM
exec ETL.pMergeChainsAccounts
--exec ETL.pReloadBCSalesAccountability
--exec ETL.pMergeCapstoneProduct
--exec ETL.pMergeTMapAndInclusions
--exec ETL.pMergeViewTables

Go

Select GeoSource, Count(*) Cnt
From SAP.Account
Where InCapstone = 1
Group By GeoSource

Select GeoSource, GeoSource1, Latitude, Latitude1, Longitude, Longitude1, CRMActive
From SAP.Account
Where InCapstone = 1
--And (isnull(Latitude, 0) = 0 Or Isnull(Longitude, 0) = 0)
--And (Latitude1 <> 0 And Longitude1 <> 0)
--And CRMActive = 1

Drop Table SAP.AccountGeoDistance
Go

-- Meter
Drop Table SAP.AccountGeoDistance0604

Select CRMActive, AccountID, SAPAccountNumber, GeoSource, GeoSource1, Latitude, Longitude, Latitude1, Longitude1,
--geography::Point(Latitude, Longitude, 4326).STDistance(geography::Point(Latitude1, Longitude1, 4326)) -- in meter
	geography::Point(Latitude, Longitude, 4268).STDistance(geography::Point(Latitude1, Longitude1, 4268)) -- in US foot
       AS DistanceFromNewToOldInMeters
Into SAP.AccountGeoDistance0604
From SAP.Account
Where InCapstone = 1
--AND CRMActive = 1
And isnull(Latitude, 0) <> 0
And isnull(Longitude, 0) <> 0
And isnull(Latitude1, 0) <> 0
And isnull(Longitude1, 0) <> 0

Select Count(*)
From SAP.Account
Where InCapstone = 1
And (isnull(Latitude, 0) = 0 Or isnull(Longitude, 0) = 0)

Select Count(*)
From SAP.Account
Where InCapstone = 1
And CRMActive = 1
And (isnull(Latitude, 0) = 0 Or isnull(Longitude, 0) = 0)


Select count(*)
From SAP.Account
Where InCapstone = 1
AND CRMActive = 1

Select * from sys.spatial_reference_systems

Select CRMActive , Count(*) CNT
From SAP.Account
Where InCapstone = 1
Group By CRMActive 

Select Count(*)
From SAP.Account
Where InBW = 1 And InCapstone = 1

--Update SAP.Account
--SEt CRMActive = 
--	(Case When
--		--- Not in Capstone, so the column value is not relevant
--		IsNull(InCapstone, 0) = 0 Then Null 
--		--- In Capstone and CRM Active
--		When
--		InCapstone = 1 
--		And GetDate() Between CRMStoreOpenDate And CRMStoreCloseDate 
--		And CRMDeleted = 0 
--		And CRMLocal = 1 Then 1 
--		Else 0 -- In Capstone But Not CRM Active
--		End
--	)

--Select CRMStoreOpenDate, CRMStoreCloseDate, CRMDeleted, CRMLocal
--From SAP.Account
--Where InCapstone = 1

Select Max(DistanceFromNewToOldInMeters)
From SAP.AccountGeoDistance

Select '<30', Count(*)
From SAP.AccountGeoDistance0604
Where DistanceFromNewToOldInMeters <= 30
And CRMActive = 1
Union
Select '30~200', Count(*)
From SAP.AccountGeoDistance0604
Where DistanceFromNewToOldInMeters > 30 And DistanceFromNewToOldInMeters <= 200
And CRMActive = 1
Union
Select '200~1000', Count(*)
From SAP.AccountGeoDistance0604
Where DistanceFromNewToOldInMeters > 200 And DistanceFromNewToOldInMeters <= 1000
And CRMActive = 1
Union
Select '1000~10000', Count(*)
From SAP.AccountGeoDistance0604
Where DistanceFromNewToOldInMeters > 1000 And DistanceFromNewToOldInMeters <= 10000
And CRMActive = 1
Union
Select '>10000', Count(*)
From SAP.AccountGeoDistance0604
Where DistanceFromNewToOldInMeters > 10000
And CRMActive = 1
