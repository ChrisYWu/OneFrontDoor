use Portal_Data_SREINT
Go

If Exists (Select * From Sys.procedures Where Object_ID = Object_ID('ETL.pMergeCapstoneBottlerERH'))
Begin
	Drop Proc ETL.pMergeCapstoneBottlerERH
End
Go

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
Assuming Full Set of Bottler Hier Table is loaded.

exec ETL.pMergeCapstoneBottlerERH

SElect *
From Staging.BCvBottlerExternalHierachy
 
Select *
From Processing.BCBottlerEBNodes

*/ 

Create Proc [ETL].[pMergeCapstoneBottlerERH]
AS
	Set NoCount On;
	----------------------------------------
	--- EB1 ----
	----------------------------------------
	MERGE BC.BottlerEB1 AS pc
		USING (	Select e.ROW_MOD_DT, b.NODE_ID, b.NODE_DESC
				From Processing.BCBottlerEBNodes e 
				Join (Select Distinct NODE1_ID NODE_ID, 
						Replace(dbo.udf_TitleCase(NODE1_DESC), '_', ' ') NODE_DESC
						From Staging.BCvBottlerExternalHierachy) b on e.NODE_ID = b.NODE_ID
				) AS input
			ON pc.BCNodeID = input.NODE_ID
	WHEN MATCHED THEN
		UPDATE SET pc.EB1Name = input.NODE_DESC,
				   pc.LastModified = input.ROW_MOD_DT, 
				   pc.Active = 1
	WHEN NOT MATCHED By Target THEN
		INSERT(EB1Name, BCNodeID, Active, LastModified)
		VALUES(input.NODE_DESC, input.NODE_ID, 1, ROW_MOD_DT)
	WHEN NOT MATCHED By Source THEN
		Update Set pc.Active = 0;

	Update BC.BottlerEB1
	Set Active = 0
	Where BCNodeID = 'ZINACTV'

	----------------------------------------
	--- EB2 ----
	----------------------------------------
	MERGE BC.BottlerEB2 AS pc
		USING (	Select e.ROW_MOD_DT, b.NODE_ID, b.NODE_DESC, b1.EB1ID
				From Processing.BCBottlerEBNodes e 
				Join (Select Distinct NODE2_ID NODE_ID, NODE1_ID PRNT_ID,
						Replace(dbo.udf_TitleCase(NODE2_DESC), '_', ' ') NODE_DESC
						From Staging.BCvBottlerExternalHierachy) b on e.NODE_ID = b.NODE_ID
				Join BC.BottlerEB1 b1 on b1.BCNodeID = b.PRNT_ID) AS input
			ON pc.BCNodeID = input.NODE_ID
	WHEN MATCHED THEN
		UPDATE SET pc.EB2Name = input.NODE_DESC,
					pc.BCNodeID = input.NODE_ID,
					pc.LastModified = input.ROW_MOD_DT,
					pc.Active = 1,
					pc.EB1ID = input.EB1ID
	WHEN NOT MATCHED By Target THEN
		INSERT([EB2Name], [BCNodeID], Active, [LastModified], EB1ID)
		VALUES(input.NODE_DESC, input.NODE_ID, 1, input.ROW_MOD_DT, input.EB1ID)
	WHEN NOT MATCHED By Source THEN
		Update Set pc.Active = 0;

	Update eb2
	Set Active = 0
	From BC.BottlerEB1 eb1
	Join BC.BottlerEB2 eb2 on eb1.EB1ID = eb2.EB1ID
	Where eb1.BCNodeID = 'ZINACTV'

	----------------------------------------
	--- EB3 ----
	----------------------------------------
	MERGE BC.BottlerEB3 AS pc
		USING (	Select e.ROW_MOD_DT, b.NODE_ID, b.NODE_DESC, b2.EB2ID
				From Processing.BCBottlerEBNodes e 
				Join (Select Distinct NODE3_ID NODE_ID, NODE2_ID PRNT_ID,
						Replace(dbo.udf_TitleCase(NODE3_DESC), '_', ' ') NODE_DESC
						From Staging.BCvBottlerExternalHierachy) b on e.NODE_ID = b.NODE_ID
				Join BC.BottlerEB2 b2 on b2.BCNodeID = b.PRNT_ID) AS input
			ON pc.BCNodeID = input.NODE_ID
	WHEN MATCHED THEN
		UPDATE SET pc.EB3Name = input.NODE_DESC,
					pc.BCNodeID = input.NODE_ID,
					pc.LastModified = input.ROW_MOD_DT,
					pc.Active = 1,
					pc.EB2ID = input.EB2ID
	WHEN NOT MATCHED By Target THEN
		INSERT(EB3Name, BCNodeID, Active, LastModified, EB2ID)
		VALUES(input.NODE_DESC, input.NODE_ID, 1, input.ROW_MOD_DT, input.EB2ID)
	WHEN NOT MATCHED By Source THEN
		Update Set pc.Active = 0;

	Update eb3
	Set Active = 0
	From BC.BottlerEB1 eb1
	Join BC.BottlerEB2 eb2 on eb1.EB1ID = eb2.EB1ID
	Join BC.BottlerEB3 eb3 on eb2.EB2ID = eb3.EB2ID
	Where eb1.BCNodeID = 'ZINACTV'

	----------------------------------------
	--- EB4 ----
	----------------------------------------
	MERGE BC.BottlerEB4 AS pc
		USING (	Select e.ROW_MOD_DT, b.NODE_ID, b.NODE_DESC, b3.EB3ID
				From Processing.BCBottlerEBNodes e 
				Join (Select Distinct NODE4_ID NODE_ID, NODE3_ID PRNT_ID,
						Replace(dbo.udf_TitleCase(NODE4_DESC), '_', ' ') NODE_DESC
						From Staging.BCvBottlerExternalHierachy) b on e.NODE_ID = b.NODE_ID
				Join BC.BottlerEB3 b3 on b3.BCNodeID = b.PRNT_ID) AS input
			ON pc.BCNodeID = input.NODE_ID
	WHEN MATCHED THEN
		UPDATE SET pc.EB4Name = input.NODE_DESC,
					pc.BCNodeID = input.NODE_ID,
					pc.LastModified = input.ROW_MOD_DT,
					pc.Active = 1,
					pc.EB3ID = input.EB3ID
	WHEN NOT MATCHED By Target THEN
		INSERT(EB4Name, BCNodeID, Active, LastModified, EB3ID)
		VALUES(input.NODE_DESC, input.NODE_ID, 1, input.ROW_MOD_DT, input.EB3ID)
	WHEN NOT MATCHED By Source THEN
		Update Set pc.Active = 0;

	Update eb4
	Set Active = 0
	From BC.BottlerEB1 eb1
	Join BC.BottlerEB2 eb2 on eb1.EB1ID = eb2.EB1ID
	Join BC.BottlerEB3 eb3 on eb2.EB2ID = eb3.EB2ID
	Join BC.BottlerEB4 eb4 on eb3.EB3ID = eb4.EB3ID
	Where eb1.BCNodeID = 'ZINACTV'

	Declare @LogID int

	Select @LogID = Max(LogID)
	From ETL.BCDataLoadingLog
	Where SchemaName = 'Staging' 
	And TableName = 'BCvBottlerExternalHierachy'

	Update ETL.BCDataLoadingLog
	Set MergeDate = GetDate()
	Where  LogID = @LogID

GO

