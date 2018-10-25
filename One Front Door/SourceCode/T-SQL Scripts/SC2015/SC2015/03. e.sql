Use Portal_Data818
Go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

If Exists (Select * From sys.procedures Where object_id = object_id('RSSC.pGetMTDRecordableCount'))
Begin
	Drop Proc RSSC.pGetMTDRecordableCount
End
Go

/*
------ Test -------
exec RSSC.pGetMTDRecordableCount

*/

Create Proc RSSC.pGetMTDRecordableCount
(
	@PlantID int
)
As
	Set NoCount On;

	--- AFR Count

	Merge SupplyChain.tDailySafetyRecordable t
	Using (
		Select DateID, PlantID, Count(*) Cnt
		From SupplyChain.AccidentHeader
		Where StatusID <> 4
		And LostTimeTypeID <> 6
		Group By DateID, PlantID) input
		On input.DateID = t.DateID and input.PlantID = t.PlantID
	When Matched Then
		Update Set AFRCount = input.Cnt
	When Not Matched By Target Then
		Insert(DateID, PlantID, AFRCount, LTIFRCount, DARTCount)
		Values(input.DateID, input.PlantID, input.Cnt, 0, 0);

	--- DART Count
	Select DateID, PlantID, Count(*) Cnt
	From SupplyChain.AccidentHeader
	Where StatusID <> 4
	And LostTimeTypeID in (7, 11, 12)
	Group By DateID, PlantID

	--- LTIFR Count
	Select DateID, PlantID, Count(*) Cnt
	From SupplyChain.AccidentHeader
	Where StatusID <> 4
	And LostTimeTypeID in (7, 12)
	Group By DateID, PlantID

Go
