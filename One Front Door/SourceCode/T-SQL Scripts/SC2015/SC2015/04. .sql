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
exec RSSC.pGetRecordableDetails 20141231


*/

Create Proc RSSC.pGetRecordableDetails
(
	@DateID int,
	@PlantIDs varchar(4000)
)
As
	Set NoCount On;

	Declare @DateID int
	Declare @PlantIDs varchar(4000)
	Declare @PlantIDTable Table
	(
		PlantID int
	)

	Set @DateID = 20141231
	Set @PlantIDs = '1,2,3,4,5,6,7,8'
	
	Insert @PlantIDTable
	Select Value
	From dbo.Split(@PlantIDs, ',')

	--------------------------------------------
	Declare @Output Table 
	(
		PlantID int,
		PlantName varchar(50),
		MeasureID int,
		MeasureName varchar(50),
		TY decimal(16,2),
		Pace decimal(16,2),
		LY decimal(16,2),
		LY2 decimal(16,2),
		LM3 decimal(16,2),
		LM2 decimal(16,2),
		LM1 decimal(16,2),
		NonEmpty bit
	)

	Declare @Measures Table
	(
		MeasureID int,
		MeasureName varchar(50)
	)

	Insert @Measures Values(1, 'Recordable')
	Insert @Measures Values(2, 'AFR')
	Insert @Measures Values(3, 'DART')
	Insert @Measures Values(4, 'LTIFR')

	Insert Into @Output(PlantID, PlantName, m.MeasureID, m.MeasureName, NonEmpty)
	Select PlantID, PlantDesc, m.MeasureID, m.MeasureName, 0
	From SupplyChain.Plant p
	Cross Join @Measures m
	Order By PlantDesc, MeasureID

	Select *
	From SupplyChain.tSafetyRecordable t
	Join @PlantIDTable p on t.PlantID = p.PlantID
	Where AnchorDateID = @DateID
	And 


	-------------------------------------
	Delete From @Output
	Where NonEmpty = 0

	Select * From @Output

Go

