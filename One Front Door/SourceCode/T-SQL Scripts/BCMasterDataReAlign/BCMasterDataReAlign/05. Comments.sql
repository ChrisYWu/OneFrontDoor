/*

0. Compare existing SPs(2 of them) with Prod and QA to make sure the latest version is used as code base and note
	the upcoming updates in the pipeline(visible in QA).
	--Need a new column StoreLastModified that will be touched by the two SPs
1. Execute script 1~4 and 8, 9 and 7. the three exec sp.
2. Disable Windows Task "SDM Address Geo Service" in BMCCAP42
3. Manually run the following query or "06. Update on Full load.sql"
	exec ETL.pMergeChainsAccounts
	exec ETL.pReloadBCSalesAccountability
	exec ETL.pMergeCapstoneProduct
	exec ETL.pMergeTMapAndInclusions
	exec ETL.pMergeViewTables


4. Observe it for 2 days and on second day verify
	a. All Account that have InCapstone = 1 have GeoSource = 'Cap'
	b. Some differences in LocalChainID and ChanelID with their archive columns
	c. Some differences in Lat/Long with their archive columns(also format should be different)
	d. Windows Task "SDM Address Geo Service" is disabled
	e. No job failure
