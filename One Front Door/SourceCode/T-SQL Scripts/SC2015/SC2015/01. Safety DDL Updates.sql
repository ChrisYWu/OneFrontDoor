Use Portal_Data
Go

Alter Table SupplyChain.Plant 
Add SafetyPlantName varchar(100)
Go

Alter Table SupplyChain.Plant 
Add SafetyLocationID int
Go

CREATE NONCLUSTERED INDEX [NCI_Plant_SafetyPlantID] ON [SupplyChain].[Plant]
(
	[SafetyLocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

-----------------------
CREATE TABLE [Staging].[PlantHour](
	[PlantID] [int] NULL,
	[Hours] [decimal](12, 2) NULL,
	[DateID] [int] NULL
) ON [PRIMARY]

GO


-----------------------
CREATE TABLE [SupplyChain].[PlantHour](
	[PlantID] [int] NOT NULL,
	[FirstOfMonthID] [int] NOT NULL,
	[NumberOfHours] [decimal](12, 2) NOT NULL,
	[ChangeTrackNumber] int NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[LastModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_PlantHour] PRIMARY KEY CLUSTERED 
(
	[PlantID] ASC,
	[FirstOfMonthID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [SupplyChain].[PlantHour]  WITH CHECK ADD  CONSTRAINT [FK_PlantHour_DimDate] FOREIGN KEY([FirstOfMonthID])
REFERENCES [Shared].[DimDate] ([DateID])
GO

ALTER TABLE [SupplyChain].[PlantHour] CHECK CONSTRAINT [FK_PlantHour_DimDate]
GO

ALTER TABLE [SupplyChain].[PlantHour]  WITH CHECK ADD  CONSTRAINT [FK_PlantHour_Plant] FOREIGN KEY([PlantID])
REFERENCES [SupplyChain].[Plant] ([PlantID])
GO

ALTER TABLE [SupplyChain].[PlantHour] CHECK CONSTRAINT [FK_PlantHour_Plant]
GO

--------------------------------
CREATE TABLE [SupplyChain].[AccidentStatus](
	[StatusID] [int] NOT NULL,
	[StatusName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_AccidentStatus] PRIMARY KEY CLUSTERED 
(
	[StatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

Insert [SupplyChain].[AccidentStatus] Values (-1, 'Not Found in SafetyDB')
Go

-------------------------------------
CREATE TABLE [SupplyChain].[LostTimeType](
	[LostTimeTypeID] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[ShortName] [varchar](50) NOT NULL,
	[EffectiveFrom] [date] NOT NULL,
	[EffectiveTo] [date] NOT NULL,
	[SortOrder] [int] NOT NULL,
 CONSTRAINT [PK_LostTimeType] PRIMARY KEY CLUSTERED 
(
	[LostTimeTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

------------------
CREATE TABLE [SupplyChain].[AccidentHeader](
	[AccidentHeaderID] [int] IDENTITY(1,1) NOT NULL,
	[SafetyAirHeaderID] [int] NOT NULL,
	[StatusID] [int] NOT NULL,
	[PlantID] [int] NOT NULL,
	[DateID] [int] NOT NULL,
	[LostTimeTypeID] [int] NOT NULL,
	[AccidentDate] [datetime2](6) NOT NULL,
	[ReportDate] [datetime2](6) NOT NULL,
	[LastModified] [datetime2](6) NOT NULL,
 CONSTRAINT [PK_AccidentHeader] PRIMARY KEY CLUSTERED 
(
	[AccidentHeaderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [SupplyChain].[AccidentHeader]  WITH CHECK ADD  CONSTRAINT [FK_AccidentHeader_AccidentStatus] FOREIGN KEY([StatusID])
REFERENCES [SupplyChain].[AccidentStatus] ([StatusID])
GO

ALTER TABLE [SupplyChain].[AccidentHeader] CHECK CONSTRAINT [FK_AccidentHeader_AccidentStatus]
GO

ALTER TABLE [SupplyChain].[AccidentHeader]  WITH CHECK ADD  CONSTRAINT [FK_AccidentHeader_DimDate] FOREIGN KEY([DateID])
REFERENCES [Shared].[DimDate] ([DateID])
GO

ALTER TABLE [SupplyChain].[AccidentHeader] CHECK CONSTRAINT [FK_AccidentHeader_DimDate]
GO

ALTER TABLE [SupplyChain].[AccidentHeader]  WITH CHECK ADD  CONSTRAINT [FK_AccidentHeader_LostTimeType] FOREIGN KEY([LostTimeTypeID])
REFERENCES [SupplyChain].[LostTimeType] ([LostTimeTypeID])
GO

ALTER TABLE [SupplyChain].[AccidentHeader] CHECK CONSTRAINT [FK_AccidentHeader_LostTimeType]
GO

ALTER TABLE [SupplyChain].[AccidentHeader]  WITH CHECK ADD  CONSTRAINT [FK_AccidentHeader_Plant] FOREIGN KEY([PlantID])
REFERENCES [SupplyChain].[Plant] ([PlantID])
GO

ALTER TABLE [SupplyChain].[AccidentHeader] CHECK CONSTRAINT [FK_AccidentHeader_Plant]
GO



------------------------------------
CREATE TABLE [Staging].[SafetyAirHeader](
	[air_header_id] [int] NULL,
	[location_id] [int] NULL,
	[status_id] [int] NULL,
	[accident_date] [datetime2](6) NULL,
	[reported_date] [datetime2](6) NULL,
	[lost_time_id] [int] NULL,
	[changed] [datetime2](6) NULL
) ON [PRIMARY]

GO

--------------------------
CREATE TABLE [SupplyChain].[tDailySafetyRecordable](
	[DateID] [int] NOT NULL,
	[PlantID] [int] NOT NULL,
	[AFRCount] [int] NULL,
	[LTIFRCount] [int] NULL,
	[DARTCount] [int] NULL,
 CONSTRAINT [PK_tDailySafetyRecordable] PRIMARY KEY CLUSTERED 
(
	[DateID] ASC,
	[PlantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [SupplyChain].[tDailySafetyRecordable]  WITH CHECK ADD  CONSTRAINT [FK_tDailySafetyRecordable_DimDate] FOREIGN KEY([DateID])
REFERENCES [Shared].[DimDate] ([DateID])
GO

ALTER TABLE [SupplyChain].[tDailySafetyRecordable] CHECK CONSTRAINT [FK_tDailySafetyRecordable_DimDate]
GO

ALTER TABLE [SupplyChain].[tDailySafetyRecordable]  WITH CHECK ADD  CONSTRAINT [FK_tDailySafetyRecordable_Plant] FOREIGN KEY([PlantID])
REFERENCES [SupplyChain].[Plant] ([PlantID])
GO

ALTER TABLE [SupplyChain].[tDailySafetyRecordable] CHECK CONSTRAINT [FK_tDailySafetyRecordable_Plant]
GO

ALTER TABLE [SupplyChain].[tDailySafetyRecordable]  WITH CHECK ADD  CONSTRAINT [CK_tDailySafetyRecordable] CHECK  (([AFRCount]>=[DARTCount]))
GO

ALTER TABLE [SupplyChain].[tDailySafetyRecordable] CHECK CONSTRAINT [CK_tDailySafetyRecordable]
GO

ALTER TABLE [SupplyChain].[tDailySafetyRecordable]  WITH CHECK ADD  CONSTRAINT [CK_tDailySafetyRecordable_1] CHECK  (([DARTCount]>=[LTIFRCount]))
GO

ALTER TABLE [SupplyChain].[tDailySafetyRecordable] CHECK CONSTRAINT [CK_tDailySafetyRecordable_1]
GO

---------------------------
CREATE TABLE [SupplyChain].[tSafetyRecordable](
	[AnchorDateID] [int] NOT NULL,
	[PlantID] [int] NOT NULL,
	[AggegationID] [tinyint] NOT NULL,
	[AFRCount] [int] NULL,
	[LTIFRCount] [int] NULL,
	[DARTCount] [int] NULL,
	[PlantHour] [decimal](18, 2) NULL,
	[LYAFRCount] [int] NULL,
	[LYLTIFRCount] [int] NULL,
	[LYDARTCount] [int] NULL,
	[LYPlantHour] [int] NULL,
 CONSTRAINT [PK_tSafetyRecordable] PRIMARY KEY CLUSTERED 
(
	[AnchorDateID] ASC,
	[PlantID] ASC,
	[AggegationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [SupplyChain].[tSafetyRecordable]  WITH CHECK ADD  CONSTRAINT [FK_tSafetyRecordable_DimDate1] FOREIGN KEY([AnchorDateID])
REFERENCES [Shared].[DimDate] ([DateID])
GO

ALTER TABLE [SupplyChain].[tSafetyRecordable] CHECK CONSTRAINT [FK_tSafetyRecordable_DimDate1]
GO

ALTER TABLE [SupplyChain].[tSafetyRecordable]  WITH CHECK ADD  CONSTRAINT [FK_tSafetyRecordable_Plant] FOREIGN KEY([PlantID])
REFERENCES [SupplyChain].[Plant] ([PlantID])
GO

ALTER TABLE [SupplyChain].[tSafetyRecordable] CHECK CONSTRAINT [FK_tSafetyRecordable_Plant]
GO

ALTER TABLE [SupplyChain].[tSafetyRecordable]  WITH CHECK ADD  CONSTRAINT [FK_tSafetyRecordable_TimeAggregation] FOREIGN KEY([AggegationID])
REFERENCES [SupplyChain].[TimeAggregation] ([AggregationID])
GO

ALTER TABLE [SupplyChain].[tSafetyRecordable] CHECK CONSTRAINT [FK_tSafetyRecordable_TimeAggregation]
GO

ALTER TABLE [SupplyChain].[tSafetyRecordable]  WITH CHECK ADD  CONSTRAINT [CK_tSafetyRecordable] CHECK  (([AFRCount]>=[DARTCount] AND [DARTCount]>=[LTIFRCount]))
GO

ALTER TABLE [SupplyChain].[tSafetyRecordable] CHECK CONSTRAINT [CK_tSafetyRecordable]
GO

---------------------------
/****** Object:  StoredProcedure [ETL].[pImportSafetyRecordable]    Script Date: 1/16/2015 3:50:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
------ Test -------
exec ETL.pImportSafetyRecordable
exec ETL.pImportSafetyRecordable 1

Select *
From SupplyChain.AccidentHeader

Select *
From ETL.BCDataLoadingLog l
Where SchemaName = 'Staging' And TableName = 'SafetyAirHeader'

*/

Create Proc [ETL].[pImportSafetyRecordable]
(
	@RefreshAll bit = 0
)
As
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

	--- Inverse Logic : Think before you update this
	If (@RefreshAll = 0)
	Begin
		Insert @PH
		Select PlantID, FirstOfMonthID, NumberOfHours, ChangeTrackNumber, LastModified
		From SupplyChain.PlantHour 
	End

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
	Declare @LastLoadTime DateTime2(6)
	Declare @LogID bigint 
	Declare @RecordCount int
	Declare @LastRecordDate DateTime

	Truncate Table Staging.SafetyAirHeader

	Select @LastLoadTime = IsNull(Max(IsNull(LatestLoadedRecordDate, '1970-1-1')), '1970-1-1')
	From ETL.BCDataLoadingLog l
	Where SchemaName = 'Staging' And TableName = 'SafetyAirHeader'
	And l.IsMerged = 1

	If (@RefreshAll = 1)
	Begin
		Set @LastLoadTime = Convert(Date, '1970-1-1')
		Truncate Table SupplyChain.AccidentHeader
	End

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
		Select air_header_id, p.PlantID, accident_date, SupplyChain.udfConvertToDateID(Convert(Date, accident_date)) AS DateID, 
			reported_date, lost_time_id, changed, status_id 
		From Staging.SafetyAirHeader sah
		Join SupplyChain.Plant p on sah.location_id = p.SafetyLocationID) input
		On input.air_header_id = header.SafetyAirHeaderID
	When Matched Then
		Update Set PlantID = input.PlantID, 
				   DateID = input.DateID,
				   LostTimeTypeID = input.lost_time_id,
				   AccidentDate = input.accident_date,
				   ReportDate = input.reported_date,
				   LastModified = input.changed,
				   StatusID = input.status_id
	When Not Matched By Target Then
		Insert (SafetyAirHeaderID, PlantID, DateID, LostTimeTypeID, AccidentDate, ReportDate, LastModified, StatusID)
		Values (input.air_header_id, input.PlantID, input.DateID, input.lost_time_id, input.accident_date, input.reported_date, input.changed, input.status_id);

	Update ETL.BCDataLoadingLog 
	Set MergeDate = GetDate()
	Where LogID = @LogID

GO

-----------------------------
/****** Object:  StoredProcedure [ETL].[pFillRecordables]    Script Date: 1/16/2015 3:51:15 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
------ Test -------
exec ETL.pFillRecordables

Select *
From SupplyChain.tSafetyRecordable
*/

Create Proc [ETL].[pFillRecordables]
(
	@NumberOfHistoryToPrecal int = 3
)
As
	Set NoCount On;

	Truncate Table SupplyChain.tDailySafetyRecordable

	--- AFR ---
	Insert Into SupplyChain.tDailySafetyRecordable(DateID, PlantID, AFRCount, LTIFRCount, DARTCount)
	Select DateID, PlantID, Count(SafetyAirHeaderID) Cnt, 0, 0
	From SupplyChain.AccidentHeader
	Where LostTimeTypeID <> 6
	And StatusID <> 4
	Group By DateID, PlantID

	--- DART ---
	Update r Set DARTCount = a.Cnt
	From SupplyChain.tDailySafetyRecordable r
	Join 	
	(Select DateID, PlantID, Count(SafetyAirHeaderID) Cnt
	From SupplyChain.AccidentHeader
	Where LostTimeTypeID in (7,11,12)
	And StatusID <> 4
	Group By DateID, PlantID) a On r.PlantID = a.PlantID And r.DateID = a.DateID

	--- LTIFR ---
	Update r Set LTIFRCount = a.Cnt
	From SupplyChain.tDailySafetyRecordable r
	Join 	
	(Select DateID, PlantID, Count(SafetyAirHeaderID) Cnt
	From SupplyChain.AccidentHeader
	Where LostTimeTypeID in (7,12)
	And StatusID <> 4
	Group By DateID, PlantID) a On r.PlantID = a.PlantID And r.DateID = a.DateID

	------------------------------------------------
	Truncate Table SupplyChain.tSafetyRecordable

	-- Month To Date ------
	Insert SupplyChain.tSafetyRecordable(AnchorDateID, PlantID, AggegationID, AFRCount, LTIFRCount, DARTCount, PlantHour)
	Select hr.DateID, hr.PlantID, 3, hr.AFRCount, hr.LTIFRCount, hr.DARTCount, ph.NumberOfHours
	From 
	(
		Select rt.DateID/100*100 + 1 PlantHourDateID, rt.DateID, 3 AggregationID, rt.PlantID, 
				sum(rs.AFRCount) AFRCount
				,sum(rs.LTIFRCount) LTIFRCount
				,sum(rs.DARTCount) DARTCount
		From (
				Select Distinct d.DateID, d.Date, PlantID
				From Shared.DimDate d
				Cross Join SupplyChain.Plant p
				Where d.Date <= GetDate()
				--And d.DateID > (Convert(int, Convert(Varchar, GetDate(), 112)) /10000 - @NumberOfHistoryToPrecal)*10000 -- enable this line to just keep latest n years or history
			 ) rt -- Report Date
		Join SupplyChain.tDailySafetyRecordable rs on rt.PlantID = rs.PlantID and rs.DateID <= rt.DateID And rs.DateID >= rt.DateID/100*100 + 1
		Group By rt.DateID, rt.PlantID
	) hr
	Left Join SupplyChain.PlantHour ph on hr.PlantHourDateID = ph.FirstOfMonthID And ph.PlantID = hr.PlantID

	-- Year To Date(4) ------
	Insert SupplyChain.tSafetyRecordable(AnchorDateID, PlantID, AggegationID, AFRCount, LTIFRCount, DARTCount, PlantHour)
	Select hr.DateID, hr.PlantID, 4, hr.AFRCount, hr.LTIFRCount, hr.DARTCount, ph.TotalHours
	From 
	(
		Select rt.DateID/100*100 + 1 PlantHourDateID, rt.DateID, 4 AggregationID, rt.PlantID, 
				sum(rs.AFRCount) AFRCount
				,sum(rs.LTIFRCount) LTIFRCount
				,sum(rs.DARTCount) DARTCount
		From (
				Select Distinct d.DateID, d.Date, PlantID
				From Shared.DimDate d
				Cross Join SupplyChain.Plant p
				Where d.Date <= GetDate()
				--And d.DateID > (Convert(int, Convert(Varchar, GetDate(), 112)) /10000 - @NumberOfHistoryToPrecal)*10000 -- enable this line to just keep latest n years or history
			 ) rt -- Report Date
		Join SupplyChain.tDailySafetyRecordable rs on rt.PlantID = rs.PlantID and rs.DateID <= rt.DateID And rs.DateID >= rt.DateID/10000*10000	
		Group By rt.DateID, rt.PlantID
	) hr
	Left Join 
	(
		Select phDates.PlantID, phDates.FirstOfMonthID, Sum(phAccu.NumberOfHours) TotalHours
		From SupplyChain.PlantHour phAccu
		Join SupplyChain.PlantHour phDates on phAccu.PlantID = phDates.PlantID 
		And phAccu.FirstOfMonthID / 10000 = phDates.FirstOfMonthID / 10000  -- Year Qualifier
		And phAccu.FirstOfMonthID / 100 <= phDates.FirstOfMonthID / 100      -- Month Qualifier
		Group By phDates.FirstOfMonthID, phDates.PlantID
	) ph on hr.PlantHourDateID = ph.FirstOfMonthID And ph.PlantID = hr.PlantID
	Order By DateID desc

	Update ty
	Set LYAFRCount = ly.AFRCount, 
		LYDARTCount = ly.DARTCount, 
		LYLTIFRCount = ly.LTIFRCount, 
		LYPlantHour = ly.PlantHour
	From SupplyChain.tSafetyRecordable ty
	Join
	(Select (AnchorDateID/10000+1)*10000 + AnchorDateID%10000 LYDateID, AFRCount, DARTCount, LTIFRCount, PlantHour, PlantID, AggegationID
	From SupplyChain.tSafetyRecordable) ly on ty.AnchorDateID = ly.LYDateID And ty.PlantID = ly.PlantID And ty.AggegationID = ly.AggegationID

GO

-----------------------------
/****** Object:  StoredProcedure [RSSC].[pGetRecordableDetails]    Script Date: 1/16/2015 3:52:00 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
------ Test -------
exec RSSC.pGetRecordableDetails 20141231, '1,2,3,5,7,8,10,11,12,13,15,16,17,18,19,20,21,22,24,26,27,28'
exec RSSC.pGetRecordableDetails 20150114, '1,2,3,5,7,8,10,11,12,13,15,16,17,18,19,20,21,22,24,26,27,28'
exec RSSC.pGetRecordableDetails 20150114, '17'
exec RSSC.pGetRecordableDetails 20141231, '8'

Declare @Pids varchar(4000)
Set @Pids = ''
Select @Pids = @Pids + Convert(varchar, PlantID) + ','
From SupplyChain.Plant
Where Active = 1
Order By PlantID

Select @Pids
*/

--Select *
--From SupplyChain.PlantHour
--Where PlantID = 7
--Order By FirstOfMonthID desc

Create Proc RSSC.pGetRecordableDetails
(
	@DateID int,
	@PlantIDs varchar(4000)
)
As
	Set NoCount On;

	Declare @PlantIDTable Table (PlantID int)
	Declare @LastDayOfLastMonthID int
	Declare @LastDayOfLastMonth2ID int
	Declare @ThisMonthName varchar(3)
	Declare @LastMonthName varchar(3)
	Declare @LastMonth2Name varchar(3)

	------- Setting Testing Parameters ---------
	--Declare @DateID int
	--Declare @PlantIDs varchar(4000)
	--Set @DateID = 20141231
	--Set @PlantIDs = '1,2,3,4,5,6,7,8'	
	Insert @PlantIDTable
	Select Value
	From dbo.Split(@PlantIDs, ',')

	--Insert @PlantIDTable
	--Select PlantID From SupplyChain.Plant
	-------------------------------------------

	Select @LastDayOfLastMonthID = SupplyChain.udfConvertToDateID(DateAdd(Day, -1, SupplyChain.udfConvertToDate(Convert(int, SUBSTRING(Convert(varchar, @DateID), 1, 4) + SUBSTRING(Convert(varchar, @DateID), 5, 2) + '01'))))
	Select @LastDayOfLastMonth2ID = SupplyChain.udfConvertToDateID(DateAdd(Day, -1, SupplyChain.udfConvertToDate(Convert(int, SUBSTRING(Convert(varchar, @DateID), 1, 4) + SUBSTRING(Convert(varchar, @LastDayOfLastMonthID), 5, 2) + '01'))))
	Select @ThisMonthName =  LEFT(DATENAME(MONTH,SupplyChain.udfConvertToDate(@DateID)),3) 
	Select @LastMonthName =  LEFT(DATENAME(MONTH,SupplyChain.udfConvertToDate(@LastDayOfLastMonthID)),3) 
	Select @LastMonth2Name =  LEFT(DATENAME(MONTH,SupplyChain.udfConvertToDate(@LastDayOfLastMonth2ID)),3) 
	
	--------------------------------------------
	Declare @Collection Table 
	(
		PlantID int,
		PlantName varchar(50),
		TimeFrameID int,
		TimeFrameName varchar(50),
		Recordable decimal (16,2),
		AFR decimal(16,2),
		RestrictedLTA decimal(16,2),
		DART decimal(16,2),
		LTA decimal(16,2),
		LTIFR decimal(16,2),
		PlantTotalHours decimal(16,2)
	)

	----- TY YTD -------
	Insert Into @Collection(PlantID, PlantName, TimeFrameID, TimeFrameName, Recordable, AFR, RestrictedLTA, DART, LTA, LTIFR, PlantTotalHours)
	Select t.PlantID, Null, 1, Convert(varchar, @DateID/10000) + ' YTD', 
		AFRCount Recordable, 
		AFRCount * 200000 / PlantHour AFR, 
		DARTCount RestrictedLTA,
		DARTCount* 200000 / PlantHour DART, 
		LTIFRCount LTA,
		LTIFRCount * 200000 / PlantHour LTIFRCount,
		PlantHour 
	From SupplyChain.tSafetyRecordable t
	Join @PlantIDTable p on t.PlantID = p.PlantID
	Where AnchorDateID = @DateID
	And AggegationID = 4

	----- LY    -------
	Insert Into @Collection(PlantID, PlantName, TimeFrameID, TimeFrameName, Recordable, AFR, RestrictedLTA, DART, LTA, LTIFR, PlantTotalHours)
	Select t.PlantID, Null, 2, Convert(varchar, @DateID/10000 - 1), 
		AFRCount Recordable, 
		AFRCount * 200000 / PlantHour AFR, 
		DARTCount RestrictedLTA,
		DARTCount* 200000 / PlantHour DART, 
		LTIFRCount LTA,
		LTIFRCount * 200000 / PlantHour LTIFRCount,
		PlantHour 
	From SupplyChain.tSafetyRecordable t
	Join @PlantIDTable p on t.PlantID = p.PlantID
	Where AnchorDateID = (@DateID/10000-1)*10000 + 1231
	And AggegationID = 4

	----- LY2    -------
	Insert Into @Collection(PlantID, PlantName, TimeFrameID, TimeFrameName, Recordable, AFR, RestrictedLTA, DART, LTA, LTIFR, PlantTotalHours)
	Select t.PlantID, Null, 3, Convert(varchar, @DateID/10000 - 2), 
		AFRCount Recordable, 
		AFRCount * 200000 / PlantHour AFR, 
		DARTCount RestrictedLTA,
		DARTCount* 200000 / PlantHour DART, 
		LTIFRCount LTA,
		LTIFRCount * 200000 / PlantHour LTIFRCount,
		PlantHour 
	From SupplyChain.tSafetyRecordable t
	Join @PlantIDTable p on t.PlantID = p.PlantID
	Where AnchorDateID = (@DateID/10000-2)*10000 + 1231
	And AggegationID = 4

	----- LM2    -------
	Insert Into @Collection(PlantID, PlantName, TimeFrameID, TimeFrameName, Recordable, AFR, RestrictedLTA, DART, LTA, LTIFR, PlantTotalHours)
	Select t.PlantID, Null, 4,  @LastMonth2Name, 
		AFRCount Recordable, 
		AFRCount * 200000 / PlantHour AFR, 
		DARTCount RestrictedLTA,
		DARTCount* 200000 / PlantHour DART, 
		LTIFRCount LTA,
		LTIFRCount * 200000 / PlantHour LTIFRCount,
		PlantHour 
	From SupplyChain.tSafetyRecordable t
	Join @PlantIDTable p on t.PlantID = p.PlantID
	Where AnchorDateID = @LastDayOfLastMonth2ID
	And AggegationID = 3

	----- LM     -------
	Insert Into @Collection(PlantID, PlantName, TimeFrameID, TimeFrameName, Recordable, AFR, RestrictedLTA, DART, LTA, LTIFR, PlantTotalHours)
	Select t.PlantID, Null, 5,  @LastMonthName, 
		AFRCount Recordable, 
		AFRCount * 200000 / PlantHour AFR, 
		DARTCount RestrictedLTA,
		DARTCount* 200000 / PlantHour DART, 
		LTIFRCount LTA,
		LTIFRCount * 200000 / PlantHour LTIFRCount,
		PlantHour 
	From SupplyChain.tSafetyRecordable t
	Join @PlantIDTable p on t.PlantID = p.PlantID
	Where AnchorDateID = @LastDayOfLastMonthID
	And AggegationID = 3

	----- TM     -------
	Insert Into @Collection(PlantID, PlantName, TimeFrameID, TimeFrameName, Recordable, AFR, RestrictedLTA, DART, LTA, LTIFR, PlantTotalHours)
	Select t.PlantID, Null, 6,  @ThisMonthName, 
		AFRCount Recordable, 
		AFRCount * 200000 / PlantHour AFR, 
		DARTCount RestrictedLTA,
		DARTCount* 200000 / PlantHour DART, 
		LTIFRCount LTA,
		LTIFRCount * 200000 / PlantHour LTIFRCount,
		PlantHour 
	From SupplyChain.tSafetyRecordable t
	Join @PlantIDTable p on t.PlantID = p.PlantID
	Where AnchorDateID = @DateID
	And AggegationID = 3

	--- Fill collection with zeros -----
	Declare @TimeFrame Table
	(
		TimeFrameSortOrder int,
		TimeFrameName varchar(20)
	)
	Insert @TimeFrame Values(1, Convert(varchar, @DateID/10000) + ' YTD')
	Insert @TimeFrame Values(2, Convert(varchar, @DateID/10000 - 1))
	Insert @TimeFrame Values(3, Convert(varchar, @DateID/10000 - 2))
	Insert @TimeFrame Values(4, @LastMonth2Name)
	Insert @TimeFrame Values(5, @LastMonthName)
	Insert @TimeFrame Values(6, @ThisMonthName)

	Merge @Collection c
	Using (Select p.PlantID, f.TimeFrameSortOrder, f.TimeFrameName
		From @PlantIDTable p
		Cross Join @TimeFrame f) input
	On c.PlantID = input.PlantID and c.TimeFrameID = input.TimeFrameSortOrder
	When Not Matched By Target Then
	Insert(PlantID, TimeFrameID, TimeFrameName, Recordable, AFR, RestrictedLTA, DART, LTA, LTIFR, PlantTotalHours)
	Values(input.PlantID, input.TimeFrameSortOrder, input.TimeFrameName, 0, 0, 0, 0, 0, 0, 0);

	---------------- @Collection Result Check ----------------
	--Select * From @Collection	
	----------------------------------------------------------

	--- Sort Order ---
	Declare @MeasureSort Table
	(
		SortOrder int,
		Name varchar(20)
	)
	Insert @MeasureSort Values(1, 'Recordable')
	Insert @MeasureSort Values(2, 'AFR')
	Insert @MeasureSort Values(3, 'RestrictedLTA')
	Insert @MeasureSort Values(4, 'DART')
	Insert @MeasureSort Values(5, 'LTA')
	Insert @MeasureSort Values(6, 'LTIFR')
	Insert @MeasureSort Values(7, 'PlantTotalHours')

	--- ForOutput(need to do blanks filling) ----
	Declare @Output Table
	(
		PlantID int,
		PlantName varchar(50),
		MeasureSortOrder int,
		MeasureName varchar(50),
		ThisYearYTD decimal(16,2),
		Pace decimal(16,2),
		LastYear decimal(16,2),
		LastYear2 decimal(16,2),
		LastMonth2 decimal(16,2),
		LastMonth decimal(16,2),
		ThisMonth decimal(16,2)
	)

	---------- Unpivotting columns to rows -------------------
	--- Need to tell the difference between null and 0 -------
	Insert @Output(PlantID, PlantName, MeasureSortOrder, MeasureName, ThisYearYTD, LastYear, LastYear2, LastMonth2, LastMonth, ThisMonth)  
	Select PlantID, PlantName, SortOrder, MeasureName, 
		[1] ThisYearYTD, 
		[2] LastYearTotal, 
		[3] LastYear2Total, 
		[4] LastMonth2Total, 
		[5] LastMonthTotal, 
		[6] ThisMonthMTD
	From
	(
		Select PlantID, PlantName, TimeFrameID, MeasureName, Value
		From
		(
			Select PlantID, PlantName, TimeFrameID, 
			IsNull(Recordable, 0) Recordable, AFR, 
			RestrictedLTA, DART, 
			LTA, LTIFR, 
			PlantTotalHours
			From @Collection
		) d
		Unpivot
		(
			Value for MeasureName in (Recordable, AFR, RestrictedLTA, DART, LTA, LTIFR, PlantTotalHours)
		) unpiv
	) e
	Pivot
	(
		Max(Value)
		For TimeFrameID in ([1], [2], [3], [4], [5], [6]) 
	) piv
	Join 
	@MeasureSort t on piv.MeasureName = t.Name

	--- Fillin Plant Name ----
	Update c Set PlantName = t.PlantDesc
	From @Output c 
	Join SupplyChain.Plant t on c.PlantID = t.PlantID

	---------------------------------
	Update @Output Set Pace = ThisYearYTD - LastYear --Negative means good, less than last year
	Select * From @Output Order By PlantName, MeasureSortOrder

Go


