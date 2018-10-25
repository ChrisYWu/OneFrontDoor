Use Portal_Data818
Go


	Set NoCount On;
	-----------------------------------------
	-- Update Plant SafetyID based on the Safety Location Naming Convention
	-----------------------------------------
	Update p
	Set SafetyPlantName = sl.SafetyPlantName, SafetyLocationID = sl.LocationID
	From SupplyChain.Plant p
	Join
	(
		Select LocationID, Name SafetyPlantName, 
			Case When Name = 'St. Louis, MO -- PL' then 'Concentrate (STL)'	
			Else Substring(Name, 1, CharIndex(', ', Name, 1) - 1) 
			End ConformedPlantName,
			Substring(Name, 1, CharIndex(', ', Name, 1) - 1) PlantName
		From [ASCCSQ11\TORPDB02].[Safety].[dbo].[location]
		Where name like '%-- PL'
	) Sl on p.PlantDesc = sl.ConformedPlantName

	----------------------------------------
	-- diffential update for plant hours
	----------------------------------------
	Declare @PH TABLE (
		[PlantID] [int],
		[FirstOfMonthID] [int] ,
		[NumberOfHours] [decimal](12, 2),
		[ChangeTrackNumber] int,
		[LastModified] [datetime2](7)
	)

	Insert @PH
	Select PlantID, FirstOfMonthID, NumberOfHours, ChangeTrackNumber, LastModified
	From SupplyChain.PlantHour 

	Truncate Table Staging.PlantHour;

	---- One Plant has two locations : need to ask
	/*
	811 ------- Vernon, CA -- PL
	Hours in two location
		LOS ANGELES
		CALIFORNIA - FIELD
	*/
	Insert Staging.PlantHour(PlantID, Hours, DateID)
	Select p.PlantID, Sum(hm.hours) [Hours], SupplyChain.udfConvertToDateID(hm.hours_date) DateID
	From [ASCCSQ11\TORPDB02].[Safety].[dbo].[hours_by_month] hm
	Join SupplyChain.Plant p on hm.location_id = p.SafetyLocationID
	Group By p.PlantID, hm.hours_date

	Merge @PH As ph
	Using Staging.PlantHour input
		On input.PlantID = ph.PlantID And input.DateID = ph.FirstOfMonthID
	When Matched Then
		Update Set [NumberOfHours] = input.hours;

	Update @PH Set ChangeTrackNumber = CHECKSUM(PlantID, FirstOfMonthID, NumberOfHours);

	Update sdm
	Set LastModified = SYSDATETIME(), ChangeTrackNumber = ph.ChangeTrackNumber, NumberOfHours = ph.NumberOfHours
	From SupplyChain.PlantHour sdm
	Join @PH ph on sdm.PlantID = ph.PlantID And sdm.FirstOfMonthID = ph.FirstOfMonthID And sdm.ChangeTrackNumber != isnull(ph.ChangeTrackNumber, -1)

	Merge SupplyChain.PlantHour As ph
	Using Staging.PlantHour input
		On input.PlantID = ph.PlantID And input.DateID = ph.FirstOfMonthID
	When Not Matched By Target Then
		Insert ([PlantID], [FirstOfMonthID], [NumberOfHours], CreatedDate, [LastModified])
		Values(input.PlantID, input.DateID, input.hours, SYSDATETIME(), SYSDATETIME());

	Update SupplyChain.PlantHour Set ChangeTrackNumber = CHECKSUM(PlantID, FirstOfMonthID, NumberOfHours) Where ChangeTrackNumber is null

	-----------------------------------
	-- LostTimeType master list -------
	-----------------------------------
	Merge SupplyChain.LostTimeType ph
	Using [ASCCSQ11\TORPDB02].[Safety].[dbo].[lost_time] input
		On input.lost_time_id = ph.LostTimeTypeID
	When Matched Then
		Update Set Name = input.[lost_time_desc],
		ShortName = input.[lost_time_type],
		EffectiveFrom = input.[eff_from],
		EffectiveTo = input.[eff_to],
		SortOrder = input.[sortby]
	When Not Matched By Target Then
		Insert ([LostTimeTypeID]
			   ,[Name]
			   ,[ShortName]
			   ,[EffectiveFrom]
			   ,[EffectiveTo]
			   ,[SortOrder])
		Values (input.[lost_time_id]
		  ,input.[lost_time_desc]
		  ,input.[lost_time_type]
		  ,input.[eff_from]
		  ,input.[eff_to]
		  ,input.[sortby]);

	-----------------------------------
	-- HeaderStatus master list -------
	-----------------------------------
	Merge SupplyChain.AccidentStatus ph
	Using [ASCCSQ11\TORPDB02].[Safety].[dbo].[reportstatus] input
		On input.StatusID = ph.StatusID
	When Matched Then
		Update Set StatusName = input.[Status]
	When Not Matched By Target Then
		Insert (StatusID, StatusName)
		Values (input.StatusId, input.[Status]);

	-------------------------------------------------
	-- Differntial Update to Staging.SafetyAirHeader
	-------------------------------------------------
	Select * From ETL.BCDataLoadingLog l
	Where SchemaName = 'Staging' And TableName = 'SafetyAirHeader'

	Declare @LastLoadTime DateTime2(6)
	Declare @LogID bigint 
	Declare @RecordCount int
	Declare @LastRecordDate DateTime

	Truncate Table Staging.SafetyAirHeader

	Select @LastLoadTime = IsNull(Max(IsNull(LatestLoadedRecordDate, '1970-1-1')), '1970-1-1')
	From ETL.BCDataLoadingLog l
	Where SchemaName = 'Staging' And TableName = 'SafetyAirHeader'
	And l.IsMerged = 1

	Insert ETL.BCDataLoadingLog([SchemaName], [TableName], [StartDate])
	Values ('Staging', 'SafetyAirHeader', GetDate())

	Select @LogID = SCOPE_IDENTITY()

	Insert Into Staging.SafetyAirHeader
	SELECT [air_header_id]
		  ,[location_id]
		  ,[status_id]
		  ,[accident_date]
		  ,[reported_date]
		  ,[lost_time_id]
		  ,[changed]
	FROM [ASCCSQ11\TORPDB02].[Safety].[dbo].[air_header]
	Where [changed] >= Convert(DateTime, @LastLoadTime)

	Select @RecordCount = Count(*) From Staging.SafetyAirHeader
	Select @LastRecordDate = Max(changed) From Staging.SafetyAirHeader

	Update ETL.BCDataLoadingLog 
	Set EndDate = GetDate(), NumberOfRecordsLoaded = @RecordCount, LatestLoadedRecordDate = @LastRecordDate
	Where LogID = @LogID

	--------------------------------------------
	--- Merge/Update AccidentHeader ------------
	--------------------------------------------
	Merge SupplyChain.AccidentHeader header
	Using (
		Select air_header_id, p.PlantID, accident_date, SupplyChain.udfConvertToDateID(DATEADD(month, DATEDIFF(month, 0, accident_date), 0)) AS StartOfMonth, 
			reported_date, lost_time_id, changed, status_id 
		From Staging.SafetyAirHeader sah
		Join SupplyChain.Plant p on sah.location_id = p.SafetyLocationID) input
		On input.air_header_id = header.SafetyAirHeaderID
	When Matched Then
		Update Set PlantID = input.PlantID, 
				   FirstOfMonthID = input.StartOfMonth,
				   LostTimeTypeID = input.lost_time_id,
				   AccidentDate = input.accident_date,
				   ReportDate = input.reported_date,
				   LastModified = input.changed,
				   StatusID = input.status_id
	When Not Matched By Target Then
		Insert (SafetyAirHeaderID, PlantID, FirstOfMonthID, LostTimeTypeID, AccidentDate, ReportDate, LastModified, StatusID)
		Values (input.air_header_id, input.PlantID, input.StartOfMonth, input.lost_time_id, input.accident_date, input.reported_date, input.changed, input.status_id);

	Update ETL.BCDataLoadingLog 
	Set MergeDate = GetDate()
	Where LogID = @LogID
	---------------------------------------------

