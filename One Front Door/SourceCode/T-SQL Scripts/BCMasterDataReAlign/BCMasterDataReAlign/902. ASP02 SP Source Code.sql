USE [Portal_Data]
GO
/****** Object:  StoredProcedure [RSSC].[pGetAverageFlavorCO2]    Script Date: 6/8/2015 1:36:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* 
'Columbus'
exec RSSC.pGetAverageFlavorCO2 13, 20130201

'Carlstadt'
exec RSSC.pGetAverageFlavorCO2 3, 20140903

'Asper'
exec RSSC.pGetAverageFlavorCO2 8, 20140921

'Carlstadt'
exec RSSC.pGetAverageFlavorCO2 3, 20140921

'Willamson'
exec RSSC.pGetAverageFlavorCO2 7, 20130401

'Victorville'
exec RSSC.pGetAverageFlavorCO2 27, 20141007

'B something the new one'
exec RSSC.pGetAverageFlavorCO2 28, 20141205

*/

--ALTER Proc [RSSC].[pGetAverageFlavorCO2]
(
	@PlantIDs varchar(4000),
	@DateID int
)
AS
Set NoCount On;

--Set @DateID = SupplyChain.udfConvertToDateID(DATEADD(d, -1, SupplyChain.udfConvertToDate(@DateID)))

Declare @Output Table
(
	PlantID int,
	PlantName varchar(128),
	LineName varchar(128),
	LineID int,
	TimePeroidDisplay varchar(128),
	TimePeriodSortOrder int,
	YearName varchar(128),
	YearSortOrder int,
	SumFlavorCODuration Decimal(18, 8), 
	CountFlavorCO int,
	SumDuration Decimal(18, 8)
)

----------------- This year place holder -------------------------
Insert Into @Output(PlantID, PlantName, LineName, LineID, TimePeriodSortOrder, TimePeroidDisplay, YearSortOrder, YearName, 
		 CountFlavorCO, SumFlavorCODuration, SumDuration)
Select temp.PlantID, temp.PlantName, temp.LineName, temp.LineID,
ta.SortOrder TimePeriodSortOrder, 
Case When ta.Name = 'Today' Then 'Yesterday (' + Substring(DateName(Month, SupplyChain.udfConvertToDate(@DateID)), 1, 3) + ' ' + Convert(varchar, Day(SupplyChain.udfConvertToDate(@DateID))) + ')' 
--Case When ta.Name = 'Today' Then 'Yesterday (' + Substring(DateName(WeekDay, SupplyChain.udfConvertToDate(@DateID)), 1, 3) + ', ' + Substring(DateName(Month, SupplyChain.udfConvertToDate(@DateID)), 1, 3) + ' ' + Convert(varchar, Day(SupplyChain.udfConvertToDate(@DateID))) + ')' 
--Case When ta.Name = 'Today' Then 'Yesterday (' + Convert(varchar(5), SupplyChain.udfConvertToDate(@DateID), 110) + ')' 
When ta.Name = 'MTD' Then 'MTD (Last ' + convert(varchar(3), @DateID%100) + ' Days)'
When ta.Name = 'MTD' Then DATENAME(month, SupplyChain.udfConvertToDate(@DateID)) + '(Last ' + convert(varchar(3), @DateID%100) + ' Days)'
When ta.Name = 'YTD' Then 'YTD (Last ' + convert(varchar, datepart(dayofyear,SupplyChain.udfConvertToDate(@DateID))) + ' Days)'
When ta.Name = 'YTD' Then DATENAME(year, SupplyChain.udfConvertToDate(@DateID)) + '(Last ' + convert(varchar, datepart(dayofyear,SupplyChain.udfConvertToDate(@DateID))) + ' Days)'
Else ta.Name End TimePeroidDisplay,
1 YearSortOrder, 'This Year', 0,0,0
From SupplyChain.TimeAggregation ta
Cross Join 
(Select l.LineID, LineName, p.PlantID, PlantDesc PlantName
From SupplyChain.Line l
Join SupplyChain.LineType lt on l.LineTypeID = lt.LineTypeID
Join SupplyChain.Plant p on l.PlantID = p.PlantID) Temp
Where PlantID in 
(
	Select Value From dbo.Split(@PlantIDs, ',')
)
And ta.Active = 1

----------------- Last year place holder -------------------------
Insert Into @Output(PlantID, PlantName, LineName, LineID, TimePeriodSortOrder, TimePeroidDisplay, YearSortOrder, YearName, 
		 CountFlavorCO, SumFlavorCODuration, SumDuration)
Select temp.PlantID, temp.PlantName, temp.LineName, temp.LineID,
ta.SortOrder TimePeriodSortOrder, 
Case When ta.Name = 'Today' Then 'Yesterday(' + Convert(varchar(5), SupplyChain.udfConvertToDate(@DateID), 110) + ')' Else ta.Name End TimePeroidDisplay,
2 YearSortOrder, 'Last Year', 0,0,0
From SupplyChain.TimeAggregation ta
Cross Join 
(Select l.LineID, LineName, p.PlantID, PlantDesc PlantName
From SupplyChain.Line l
Join SupplyChain.LineType lt on l.LineTypeID = lt.LineTypeID
Join SupplyChain.Plant p on l.PlantID = p.PlantID) Temp
Where PlantID in
(
	Select Value From dbo.Split(@PlantIDs, ',')
)
And ta.Active = 1

Update op Set
	CountFlavorCO = fact.CountFlavorCO, 
	SumFlavorCODuration = fact.SumFlavorCODuration,
	SumDuration = fact.SumActualQty
From @Output op
Left Join 
(
	Select LIneID, LineName + ' - ' + LineTypeName As LineName, 
	Case When TimePeroid = 'Today' Then Convert(varchar, SupplyChain.udfConvertToDate(@DateID))  Else TimePeroid End TimePeroidDisplay,
	v.SortOrder TimePeriodSortOrder, 'This Year' YearName, 1 YearSortOrder, SumActualQty, SumCapacityQty, SumPlanQty, SumDuration, SumCODuration, CountFlavorCO, SumFlavorCODuration
	From SupplyChain.vPTKPIs v
	Where PlantID in
	(
		Select Value From dbo.Split(@PlantIDs, ',')
	)
	And DateID = @DateID
	Union All
	Select LIneID, LineName + ' - ' + LineTypeName As LineName, 
	Case When TimePeroid = 'Today' Then Convert(varchar, SupplyChain.udfConvertToDate(@DateID))  Else TimePeroid End TimePeroidDisplay,
	v.SortOrder TimePeriodSortOrder, 'Last Year' YearName, 2 YearSortOrder, SumActualQty, SumCapacityQty, SumPlanQty, SumDuration, SumCODuration, CountFlavorCO, SumFlavorCODuration
	From SupplyChain.vPTKPIs v
	Where PlantID in
	(
		Select Value From dbo.Split(@PlantIDs, ',')
	)
	And DateID = @DateID % 10000 + ((@DateID / 10000) - 1) * 10000
) fact 
On op.LineID = fact.LineID And op.YearSortOrder = fact.YearSortOrder And op.TimePeriodSortOrder = fact.TimePeriodSortOrder

------------------------------------
--- Remove the inactive line, that is defined as no year to date actual capacity ---
Delete 
From @Output
Where LineName in (
Select LineName
From @Output
Where YearSortOrder = 1 And TimePeriodSortOrder = 4
And Isnull(SumDuration, 0) = 0)

------ Remove the Year Grouping and instead create addtional columns -------------
------------------------------------
Declare @Out2 Table
(
	PlantID int,
	PlantName varchar(200),
	LineID int,
	LineName varchar(200),
	TimePeroidDisplay varchar(100),
	TimePeriodSortOrder int,
	CountFlavorCO int,
	SumFlavorCODuration decimal(10,1),
	LYCountFlavorCO int,
	LYSumFlavorCODuration decimal(10, 1),
	SumDuration decimal(10, 1),
	LYSumDuration decimal(10, 1),
	LineWeight Decimal(5,4),
	LYLineWeight Decimal(5,4),
	TYLineWeight Decimal(5,4),
	AVCO decimal(10,4),
	LYAVCO decimal(10,4),
	WeightedAVCO decimal(10,4),
	WeightedLYAVCO decimal(10,4)
)

Insert @Out2
Select TY.PlantID, TY.PlantName, TY.LineID, TY.LineName,
	TY.TimePeroidDisplay,
	TY.TimePeriodSortOrder,
	isnull(TY.CountFlavorCO, 0) CountFlavorCO, 
	isnull(TY.SumFlavorCODuration, 0) SumFlavorCODuration,
	isnull(LY.LYCountFlavorCO, 0) LYCountFlavorCO, 
	isnull(LY.LYSumFlavorCODuration, 0) LYSumFlavorCODuration, 
	Isnull(TY.SumDuration,0) SumDuration,
	Isnull(LY.LYSumDuration, 0) LYSumDuration
	, 0 LineWeight, 0, 0, 0, 0, 0, 0
From (
Select PlantID, PlantName, LineID, LineName,
	TimePeroidDisplay,
	TimePeriodSortOrder,
	YearName,
	YearSortOrder,
	CountFlavorCO, 
	SumFlavorCODuration,
	SumDuration
From @Output
Where YearSortOrder = 1) TY
Left Join
(
Select PlantID, PlantName, LineID, LineName,
	TimePeroidDisplay,
	TimePeriodSortOrder,
	YearName,
	YearSortOrder,
	CountFlavorCO LYCountFlavorCO, 
	SumFlavorCODuration LYSumFlavorCODuration,
	SumDuration LYSumDuration
From @Output
Where YearSortOrder = 2
) LY On TY.PlantName = LY.PlantName And TY.LineName = LY.LineName And TY.TimePeriodSortOrder = LY.TimePeriodSortOrder
Order By TY.PlantName, LineName, TimePeriodSortOrder

Declare @PlantSum Table
(
	PlantID int,
	TimePeriodSortOrder int,
	FCODuration decimal(10,1),
	LYFCODuration decimal(10,1)
)
Insert @PlantSum
Select PlantID, TimePeriodSortOrder, Sum(SumFlavorCODuration), Sum(LYSumFlavorCODuration)
From @Out2
Group By PlantID, TimePeriodSortOrder

Update o2
Set LineWeight = Case When LYFCODuration = 0 And FCODuration = 0 Then 0 
					  When LYFCODuration = 0 Then SumFlavorCODuration/FCODuration
					  Else LYSumFlavorCODuration/LYFCODuration
					  End,
	LYLineWeight = Case When LYFCODuration > 0 Then LYSumFlavorCODuration/LYFCODuration
					  Else 0
					  End,
	TYLineWeight = Case When FCODuration > 0 Then SumFlavorCODuration/FCODuration
					  Else 0
					  End,
	AVCO = Case When CountFlavorCO = 0 Then 0
				Else SumFlavorCODuration/CountFlavorCO End,
	LYAVCO = Case When LYCountFlavorCO = 0 Then 0
				Else LYSumFlavorCODuration/LYCountFlavorCO End
From @Out2 o2
Join @PlantSum s on o2.PlantID = s.PlantID And o2.TimePeriodSortOrder = s.TimePeriodSortOrder

Update @Out2
Set WeightedAVCO = Case When TYLineWeight = 0 Then 0
		Else AVCO*LineWeight/TYLineWeight End,
	WeightedLYAVCO = LYAVCO
From @Out2 o2

Select * From @Out2
Order By PlantName, LineName, TimePeriodSortOrder


