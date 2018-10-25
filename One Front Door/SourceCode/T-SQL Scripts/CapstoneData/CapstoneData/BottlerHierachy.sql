Use Portal_DataSRE
Go

--- Sanity Check ---
Select HIER_TYPE, Min(HIER_LVL_NBR) HIER_LVL_NBR
From Staging.BCBottlerHierachy
Group By HIER_TYPE

---------------------------------
Select NODE_ID, NODE_DESC, NODE_GUID, ROW_MOD_DT, DATALENGTH(NODE_GUID)
From Staging.BCBottlerHierachy
Where HIER_TYPE in('BC', 'FS')
And HIER_LVL_NBR = 0

Select Starter.NODE_ID ParentID, BC1.NODE_ID, BC1.NODE_DESC, BC1.NODE_GUID, BC1.ROW_MOD_DT
From Staging.BCBottlerHierachy BC1
Join (Select NODE_ID, NODE_DESC, NODE_GUID, ROW_MOD_DT
	From Staging.BCBottlerHierachy
	Where HIER_TYPE in('BC', 'FS')
	And HIER_LVL_NBR = 0 ) Starter On BC1.PRNT_GUID = Starter.NODE_GUID

--- Starter for EB --
Select Replace(dbo.udf_TitleCase(NODE_DESC), '_', ' ') NODE_DESC, NODE_GUID BCNodeGuid, NODE_ID BCNodeID, ROW_MOD_DT
From Staging.BCBottlerHierachy
Where HIER_TYPE in('EB')
And HIER_LVL_NBR = 1

----------------------------------------
--- Need Distinct ----
----------------------------------------
MERGE BC.BottlerEB1 AS pc
	USING (	Select Distinct Replace(dbo.udf_TitleCase(NODE_DESC), '_', ' ') NODE_DESC, 
			NODE_GUID, NODE_ID, ROW_MOD_DT
			From Staging.BCBottlerHierachy
			Where HIER_TYPE in('EB')
			And HIER_LVL_NBR = 1) AS input
		ON pc.BCNodeGuid = input.NODE_GUID
WHEN MATCHED THEN
	UPDATE SET pc.EB1Name = input.NODE_DESC,
				pc.BCNodeID = input.NODE_ID,
				pc.LastModified = input.ROW_MOD_DT,
				pc.Active = 1
WHEN NOT MATCHED By Target THEN
	INSERT([EB1Name], [BCNodeGuid], [BCNodeID], Active, [LastModified])
	VALUES(input.NODE_DESC, input.NODE_GUID, input.NODE_ID, 1, input.ROW_MOD_DT)
WHEN NOT MATCHED By Source THEN
	Update Set pc.Active = 0;
Go

----------------------------------------
----------------------------------------
Select * From BC.BottlerEB2

Select BCNodeGuid, Count(*)
From BC.BottlerEB2 eb2
Group By BCNodeGuid
Having Count(*) > 1

Select NODE_GUID, Count(*) Cnt
From Staging.BCBottlerHierachy
Group By NODE_GUID
Having Count(*) > 1

Select *
From Staging.BCBottlerHierachy
Where NODE_GUID = '1CC1DE754AA91EE3A3A0D275C871DCB0'


--Select BTTLR_GUID, Count(*) Cnt
--From Staging.BCBottlerSalesHierachy
--Group By BTTLR_GUID
--Having Count(*) > 2

Join (	Select Replace(dbo.udf_TitleCase(NODE_DESC), '_', ' ') NODE_DESC, 
			NODE_GUID, 
			NODE_ID, ROW_MOD_DT, EB1ID
			From Staging.BCBottlerHierachy b2
			Join BC.BottlerEB1 b1 on b1.BCNodeGuid = b2.PRNT_GUID)  eb22 on eb2.BCNodeGuid = eb22.NODE_GUID


MERGE BC.BottlerEB2 AS pc
	USING (	Select Distinct Replace(dbo.udf_TitleCase(NODE_DESC), '_', ' ') NODE_DESC, 
			NODE_GUID, 
			NODE_ID, ROW_MOD_DT, EB1ID
			From Staging.BCBottlerHierachy b2
			Join BC.BottlerEB1 b1 on b1.BCNodeGuid = b2.PRNT_GUID) AS input
		ON pc.BCNodeGuid = input.NODE_GUID
WHEN MATCHED THEN
	UPDATE SET pc.EB2Name = input.NODE_DESC,
				pc.BCNodeID = input.NODE_ID,
				pc.LastModified = input.ROW_MOD_DT,
				pc.Active = 1,
				pc.EB1ID = input.EB1ID
WHEN NOT MATCHED By Target THEN
	INSERT([EB2Name], [BCNodeGuid], [BCNodeID], Active, [LastModified], EB1ID)
	VALUES(input.NODE_DESC, input.NODE_GUID, input.NODE_ID, 1, input.ROW_MOD_DT, input.EB1ID)
WHEN NOT MATCHED By Source THEN
	Update Set pc.Active = 0;
Go



Select Replace(dbo.udf_TitleCase(NODE_DESC), '_', ' ') NODE_DESC, Convert(uniqueidentifier, NODE_GUID) NODE_GUID, NODE_ID, ROW_MOD_DT
			From Staging.BCBottlerHierachy
			Where HIER_TYPE in('EB')
			And HIER_LVL_NBR = 1
