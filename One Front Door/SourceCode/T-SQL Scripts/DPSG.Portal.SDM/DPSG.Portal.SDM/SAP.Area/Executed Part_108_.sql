

	Declare @area Table
	(
		SAPRegionID varchar(50),
		AreaID varchar(50),
		AreaName nvarchar(50)
	)
	Insert @area
	Select Distinct RegionID, AreaID, Area
	From Staging.SalesOffice
	Where Area not in ('')

	-- 2. Mirror the target table inlcuding checksum
	Declare @saparea Table
	(
		AreaID int,
		SAPAreaID varchar(50),
		AreaName nvarchar(50),
		RegionID int,
		ChangeTrackNumber int
	)
	Insert Into @saparea
	Select AreaID, SAPAreaID, AreaName, RegionID, ChangeTrackNumber
	From SAP.Area
	
	-- 3. Merge the mirror with the lastest source
	MERGE @SAPArea AS ba
		USING ( SELECT a.SAPRegionID, AreaID, AreaName, r.RegionID
				FROM @area a Join SAP.Region r on r.SAPRegionID = a.SAPRegionID) AS input
			ON ba.SAPAreaID = input.AreaID
	WHEN MATCHED THEN
		UPDATE SET ba.AreaName = dbo.udf_TitleCase(input.AreaName), ba.RegionID = input.RegionID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPAreaID,AreaName,RegionID)
	VALUES(input.AreaID, dbo.udf_TitleCase(input.AreaName), input.RegionID);

	Update @SAPArea Set AreaName = 'Metro NY/NJ I/O' Where AreaName = 'Metro Ny/Nj I/O'
	Update @SAPArea Set AreaName = 'Metro NY/NJ C/O' Where AreaName = 'Metro Ny/Nj C/O'
	Update @SAPArea Set ChangeTrackNumber = CHECKSUM(SAPAreaID, AreaName, RegionID)

	-- 4. Update and Insert
	-- 4.1 Insert when no skey is found
	MERGE SAP.Area AS ba
		USING ( SELECT AreaID, SAPAreaID, AreaName, RegionID, ChangeTrackNumber from @saparea) AS input
			ON ba.AreaID = input.AreaID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPAreaID,AreaName,RegionID, ChangeTrackNumber, LastModified)
	VALUES(input.SAPAreaID, input.AreaName, input.RegionID, input.ChangeTrackNumber, GetDate());

	-- 4.2 Update when skey is found but the checksum is not right
	Update bu
	Set SAPAreaID = sapbu.SAPAreaID, AreaName = sapbu.AreaName, RegionID = sapbu.RegionID, 
			ChangeTrackNumber = sapbu.ChangeTrackNumber, LastModified = GetDate()
	From SAP.Area bu
		Join @sapArea sapbu on bu.AreaID = sapbu.AreaID
Go