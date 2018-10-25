Use Portal_Data818
Go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

If Exists (Select * From sys.procedures Where object_id = object_id('RSSC.pGetRecordableDetails'))
Begin
	Drop Proc RSSC.pGetRecordableDetails
End
Go

/*
------ Test -------
exec RSSC.pGetRecordableDetails 20141231, '1,2,3,5,7,8,10,11,12,13,15,16,17,18,19,20,21,22,24,26,27,28'
exec RSSC.pGetRecordableDetails 20150114, '1,2,3,5,7,8,10,11,12,13,15,16,17,18,19,20,21,22,24,26,27,28'
exec RSSC.pGetRecordableDetails 20140331, '1,2,3,5,7,8,10,11,12,13,15,16,17,18,19,20,21,22,24,26,27,28'
exec RSSC.pGetRecordableDetails 20150114, '17'
exec RSSC.pGetRecordableDetails 20141231, '8'
exec RSSC.pGetRecordableDetails 20150114, '8'

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


