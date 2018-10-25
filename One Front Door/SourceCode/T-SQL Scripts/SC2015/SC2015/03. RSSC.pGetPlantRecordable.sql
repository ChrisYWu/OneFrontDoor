Use Portal_Data818
Go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

If Exists (Select * From sys.procedures Where object_id = object_id('RSSC.pGetPlantRecordable'))
Begin
	Drop Proc RSSC.pGetPlantRecordable
End
Go

/*
------ Test -------
exec RSSC.pGetPlantRecordable 20141231

Select *
From SupplyChain.tSafetyRecordable


*/

Create Proc RSSC.pGetPlantRecordable
(
	@AnchorDateID int
)
As
	Set NoCount On;

	Select p.PlantID, isnull(t.AFRCount, 0) Recordables, isnull(t.LYAFRCount, 0) LYRecordables
	From SupplyChain.Plant p
	Left Join SupplyChain.tSafetyRecordable t on p.PlantID = t.PlantID And AnchorDateID = @AnchorDateID And AggegationID = 3
	Where Active = 1

Go

