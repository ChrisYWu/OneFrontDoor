use Portal_DataSRE
Go

-- Done 2014-04-03

/* A usefule query to take out the artificial notes in EB hierachy
Select *
From BC.BottlerEB3
Where IsNumeric(Right(EB3Name, 2)) = 1 And Right(EB3Name, 2) = -3
And Active = 1
*/

Drop Table Staging.BCBottlerHierachy
Go

-- Staging.BCBottlerHierachy Takes 9 second for full load, differential is negligible
-- Artificial 4-level hairachy ---
Declare @LastLoadTime DateTime
Set @LastLoadTime = '2013-11-18 17:00:28'
DECLARE @OPENQUERY nvarchar(4000)
Set @OPENQUERY = BC.fnSetOpenQuery('SELECT 
   D.NODE_GUID, D.SEQ_NBR, D.NODE_ID, 
   D.NODE_DESC, D.NODE_VLD_FRM_DT, D.NODE_VLD_TO_DT, 
   D.HIER_LVL_NBR, D.PRNT_GUID, D.HIER_TYPE, 
   D.PARTNER_GUID, D.PARTNER, D.BP_VLD_FRM_DT, 
   D.BP_VLD_TO_DT, D.CHG_NBR, D.MD5_KEY, 
   D.BATCH_ID, D.DEL_FLG, D.ROW_TSK_ID, 
   D.ROW_CRT_DT, D.ROW_CRT_BY, D.ROW_MOD_DT, 
   D.ROW_MOD_BY
FROM CAP_DM.DM_BTTLR_HIER D', 'COP', @LastLoadTime, 'D')
Set @OPENQUERY = Replace(@OpenQuery, 'Select *', 'Select * Into Staging.BCBottlerHierachy')
Set @OPENQUERY = Replace(@OpenQuery, 'MI:SS'''')'')', 'MI:SS'''') AND SYSDATE Between D.NODE_VLD_FRM_DT And D.NODE_VLD_TO_DT '')')
--Set @OPENQUERY = Replace(@OpenQuery, 'MI:SS'''')'')', 'MI:SS'''') AND SYSDATE Between D.NODE_VLD_FRM_DT And D.NODE_VLD_TO_DT 
--And D.DEL_FLG = ''''N'''''')')
Exec (@OPENQUERY)
Go

Drop Table Staging.BCBottlerHierachyE
Go

-- Staging.BCBottlerHierachyE
DECLARE @OPENQUERY nvarchar(4000)
Set @OPENQUERY = 'Select * Into Staging.BCBottlerHierachyE From OpenQuery(COP, ''SELECT 
V.BTTLR_GUID, V.BTTLR_ID, V.HIER_TYPE, 
   V.NODE4_GUID, V.NODE4_ID, V.NODE4_DESC, 
   V.NODE3_GUID, V.NODE3_ID, V.NODE3_DESC, 
   V.NODE2_GUID, V.NODE2_ID, V.NODE2_DESC, 
   V.NODE1_GUID, V.NODE1_ID, V.NODE1_DESC
FROM CAP_DM.VW_DM_BTTLR_EBH_HIER V'')'
--Select @OPENQUERY

Exec (@OPENQUERY)
Go

---  Maybe need to use the sale table, just trundate and reload every time ---
If Exists (Select * From Sys.Tables Where Object_id = object_id('Staging.WorkingBottlerEBNodes'))
Begin
	Drop Table Staging.WorkingBottlerEBNodes
End

Select NODE_ID, Max(ROW_MOD_DT) ROW_MOD_DT
Into Staging.WorkingBottlerEBNodes
From Staging.BCBottlerHierachy h
Where DEL_FLG <> 'Y'
Group By NODE_ID	
Go

Delete BC.BottlerEB4 
Delete BC.BottlerEB3 
Delete BC.BottlerEB2
Delete BC.BottlerEB1 
Go
----------------------------------------
--- EB1 ----
----------------------------------------
MERGE BC.BottlerEB1 AS pc
	USING (	Select e.ROW_MOD_DT, b.NODE_ID, b.NODE_DESC
			From Staging.WorkingBottlerEBNodes e 
			Join (Select Distinct NODE1_ID NODE_ID, 
					Replace(dbo.udf_TitleCase(NODE1_DESC), '_', ' ') NODE_DESC
					From Staging.BCBottlerHierachyE) b on e.NODE_ID = b.NODE_ID
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
Go

Update BC.BottlerEB1
Set Active = 0
Where BCNodeID = 'ZINACTV'
Go

----------------------------------------
--- EB2 ----
----------------------------------------
MERGE BC.BottlerEB2 AS pc
	USING (	Select e.ROW_MOD_DT, b.NODE_ID, b.NODE_DESC, b1.EB1ID
			From Staging.WorkingBottlerEBNodes e 
			Join (Select Distinct NODE2_ID NODE_ID, NODE1_ID PRNT_ID,
					Replace(dbo.udf_TitleCase(NODE2_DESC), '_', ' ') NODE_DESC
					From Staging.BCBottlerHierachyE) b on e.NODE_ID = b.NODE_ID
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
Go

Update eb2
Set Active = 0
From BC.BottlerEB1 eb1
Join BC.BottlerEB2 eb2 on eb1.EB1ID = eb2.EB1ID
Where eb1.BCNodeID = 'ZINACTV'
Go

----------------------------------------
--- EB3 ----
----------------------------------------
MERGE BC.BottlerEB3 AS pc
	USING (	Select e.ROW_MOD_DT, b.NODE_ID, b.NODE_DESC, b2.EB2ID
			From Staging.WorkingBottlerEBNodes e 
			Join (Select Distinct NODE3_ID NODE_ID, NODE2_ID PRNT_ID,
					Replace(dbo.udf_TitleCase(NODE3_DESC), '_', ' ') NODE_DESC
					From Staging.BCBottlerHierachyE) b on e.NODE_ID = b.NODE_ID
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
Go

Update eb3
Set Active = 0
From BC.BottlerEB1 eb1
Join BC.BottlerEB2 eb2 on eb1.EB1ID = eb2.EB1ID
Join BC.BottlerEB3 eb3 on eb2.EB2ID = eb3.EB2ID
Where eb1.BCNodeID = 'ZINACTV'
Go

----------------------------------------
--- EB4 ----
----------------------------------------
MERGE BC.BottlerEB4 AS pc
	USING (	Select e.ROW_MOD_DT, b.NODE_ID, b.NODE_DESC, b3.EB3ID
			From Staging.WorkingBottlerEBNodes e 
			Join (Select Distinct NODE4_ID NODE_ID, NODE3_ID PRNT_ID,
					Replace(dbo.udf_TitleCase(NODE4_DESC), '_', ' ') NODE_DESC
					From Staging.BCBottlerHierachyE) b on e.NODE_ID = b.NODE_ID
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
Go

Update eb4
Set Active = 0
From BC.BottlerEB1 eb1
Join BC.BottlerEB2 eb2 on eb1.EB1ID = eb2.EB1ID
Join BC.BottlerEB3 eb3 on eb2.EB2ID = eb3.EB2ID
Join BC.BottlerEB4 eb4 on eb3.EB3ID = eb4.EB3ID
Where eb1.BCNodeID = 'ZINACTV'
Go

---------------------------------
If Exists (Select * From Sys.views Where object_id = object_id('BC.BottlerExternalHier'))
Begin
	Drop View BC.BottlerExternalHier
End
Go

Create View BC.BottlerExternalHier
As
	Select 
	--eb1.BCNodeID BCNode1ID,
	  eb1.EB1Name, eb1.EB1ID,
	--eb2.BCNodeID BCNode2ID,
	  eb2.EB2Name, eb2.EB2ID,
	--eb3.BCNodeID BCNode3ID,
	  eb3.EB3Name, eb3.EB3ID,
	--eb4.BCNodeID BCNode4ID
	  eb4.EB4Name, eb4.EB4ID
	From BC.BottlerEB1 eb1
	Join BC.BottlerEB2 eb2 on eb1.EB1ID = eb2.EB1ID
	Join BC.BottlerEB3 eb3 on eb2.EB2ID = eb3.EB2ID
	Join BC.BottlerEB4 eb4 on eb3.EB3ID = eb4.EB3ID
	Where eb1.Active = 1 and eb1.Active = 1 and eb3.Active = 1 and eb4.Active = 1
Go

Select EB1Name, EB2Name, EB3Name, EB4Name
From BC.BottlerExternalHier
Order By EB1Name, EB2Name, EB3Name, EB4Name
Go

/* For comparison and checking
Select Distinct NODE1_GUID, NODE1_ID, NODE1_DESC, 
		NODE2_GUID, NODE2_ID, NODE2_DESC, 
		NODE3_GUID, NODE3_ID, NODE3_DESC, 
		NODE4_GUID, NODE4_ID, NODE4_DESC
From Staging.BCBottlerHierachyE
Where NODE1_ID != 'ZINACTV'
*/
