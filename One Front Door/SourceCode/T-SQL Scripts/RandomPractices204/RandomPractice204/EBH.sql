use Portal_Data
Go

Declare @EBH Table 
(
	NodeID varchar(20),
	NodeName nvarchar(200),
	HasChildren bit,
	ParentID varchar(20),
	Level int
)

Insert Into @EBH(NodeID, NodeName, Level, HasChildren)
Select 'EB1ID' + convert(varchar, eb1.EB1ID) NodeID, eb1.EB1Name + '[' + Convert(varchar, Count(*)) + ']' NodeName, 1, Case When Count(*) > 0 Then 1 Else 0 End
From BC.BottlerEB1 eb1
Join BC.BottlerEB2 eb2 on eb1.EB1ID = eb2.EB1ID
Group By eb1.EB1ID, eb1.EB1Name

Insert Into @EBH(NodeID, NodeName, Level, ParentID, HasChildren)
Select 'EB2ID' + convert(varchar, eb2.EB2ID) NodeID, eb2.EB2Name + '[' + Convert(varchar, Count(*)) + ']' NodeName, 2, 'EB1ID' + convert(varchar, EB1ID), Case When Count(*) > 0 Then 1 Else 0 End
From BC.BottlerEB2 eb2
Join BC.BottlerEB3 eb3 on eb2.EB2ID = eb3.EB2ID
Group By eb2.EB2ID, eb2.EB2Name, 'EB1ID' + convert(varchar, EB1ID)

Insert Into @EBH(NodeID, NodeName, Level, ParentID, HasChildren)
Select 'EB3ID' + convert(varchar, eb3.EB3ID) NodeID, eb3.EB3Name + '[' + Convert(varchar, Count(*)) + ']' NodeName, 3, 'EB2ID' + convert(varchar, EB2ID), Case When Count(*) > 0 Then 1 Else 0 End
From BC.BottlerEB3 eb3
Join BC.BottlerEB4 eb4 on eb3.EB3ID = eb4.EB3ID
Group By eb3.EB3ID, eb3.EB3Name, 'EB2ID' + convert(varchar, EB2ID)

Insert Into @EBH(NodeID, NodeName, Level, ParentID, HasChildren)
Select 'EB4ID' + convert(varchar, eb4.EB4ID) NodeID, eb4.EB4Name + '[' + Convert(varchar, Count(*)) + ']' NodeName, 4, 'EB3ID' + convert(varchar, EB3ID), Case When Count(*) > 0 Then 1 Else 0 End
From BC.BottlerEB4 eb4
Join BC.Bottler b on eb4.EB4ID = b.EB4ID
Group By eb4.EB4ID, eb4.EB4Name, 'EB3ID' + convert(varchar, EB3ID)

Insert Into @EBH(NodeID, NodeName, Level, ParentID, HasChildren)
Select 'BTTLRID' + convert(varchar, b.BottlerID) NodeID, b.BottlerName NodeName, 5, 'EB4ID' + convert(varchar, b.EB4ID), 0
From BC.Bottler b
Join BC.BottlerEB4 eb4 on eb4.EB4ID = b.EB4ID

Select *
Into dbo.EBH
From @EBH

