--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--
---- Note this starts from 108

use Portal_Data
Go

If Exists (Select * From sys.procedures Where object_id = object_id('Precal.pPupulateChainGroupTree'))
	Drop Proc Precal.pPupulateChainGroupTree
Go

Create Proc PreCal.pPupulateChainGroupTree(@Debug bit = 1)
As
Begin

	Declare @AllNodes Table
	(
		ChainGroupID varchar(20),
		ChainGroupName varchar(100),
		ParentChainGroupID varchar(20),
		NodeType varchar(100),
		SequenceOrder int
	);

	Declare @Dup Table
	(
		ChainGroupID varchar(20),
		ChainGroupName varchar(100),
		ParentChainGroupID varchar(20),
		NodeType varchar(100),
		SequenceOrder int
	);

	With TrueN As
	(
		Select Distinct ChainID, 
						Chain, 
						'0--Null-Nil-Null--' ParentChainID, 
						'National Chain(Scuh as Walmart, CVS and Aramark)' NodeType,
						1 SequenceOrder
		--'Examples scuh as Walmart, CVS, Dollar General and Aramark. Usually shield all chindren, with exception such as Spartan Nash.' Descr
		From MSTR.RevChainImages
		Where ChainHierType = 'N'
	),

	RealR As
	(
		Select Distinct ChainID, 
						Chain,
						Case When NationalChainName = 'All Other' Then '0--Null-Nil-Null--' 
							Else 'N' + REPLACE(STR(NationalChainID,5),' ','0') End ParentChainID, 
						Case When NationalChainName = 'All Other' Then 'Regional Chain with [All Other] Parent' 
							Else 'Regional chain with a national cover' End NodeType,
						Case When NationalChainName = 'All Other' Then 2 
							Else 1 End SequenceOrder
		From MSTR.RevChainImages
		Where ChainHierType = 'R'
	),

	RParent As
	(
		Select Distinct r.ParentChainID ChainID, NationalChainName Chain, 
				'0--Null-Nil-Null--' ParentChainID, 
				'Regional Chain Parent' NodeType, 1 SequenceOrder
		From MSTR.RevChainImages rci
		Join RealR r on Substring(r.ParentChainID, 2, 5) = rci.NationalChainID
		Where ParentChainID <> '0--Null-Nil-Null--'
	),

	HardL As
	(
		Select Distinct ChainID, 
						Chain, 
						Case When RegionalChainName = 'All Other' Then '0--Null-Nil-Null--' 
							 When NationalChainName = 'All Other' Then 'R' + REPLACE(STR(RegionalChainID,5),' ','0')
							 Else 'N' + REPLACE(STR(NationalChainID,5),' ','0') End ParentChainID, 
						Case When RegionalChainName = 'All Other' Then 'Local Chain with [All Other]/[All Other] Parents' 
							 When NationalChainName = 'All Other' Then 'Local Chain with Regional Chain Parents' 
							 Else 'Local Chain attached to national name(skipping the regional level)'
							 End NodeType,
						Case When RegionalChainName = 'All Other' Then 3 
							 When NationalChainName = 'All Other' Then 2 
							 Else 1
							 End SequenceOrder  
		From MSTR.RevChainImages
		Where ChainHierType = 'L'
	),

	LParent As
	(
		Select Distinct l.ParentChainID ChainID, 
						NationalChainName Chain, 
						'0--Null-Nil-Null--' ParentChainID, 
						'Local chain''s national chain grand parent' NodeType,
						1 SequenceOrder  
		From MSTR.RevChainImages rci
		Join HardL l on Substring(l.ParentChainID, 2, 5) = rci.NationalChainID
		Where Substring(l.ParentChainID, 1, 1) = 'N'
		And ParentChainID <> '0--Null-Nil-Null--'
		Union
		Select Distinct l.ParentChainID ChainID, 
						RegionalChainName Chain, 
						'0--Null-Nil-Null--' ParentChainID, 
						'Local chain''s regional chain parent' NodeType,
						2 SequenceOrder  
		From MSTR.RevChainImages rci
		Join HardL l on Substring(l.ParentChainID, 2, 5) = rci.RegionalChainID
		Where Substring(l.ParentChainID, 1, 1) = 'R'
		And ParentChainID <> '0--Null-Nil-Null--'
	)

	Insert Into @AllNodes(ChainGroupID, ChainGroupName, ParentChainGroupID, NodeType, SequenceOrder)
	Select ChainID, Chain, ParentChainID, NodeType, SequenceOrder
	From TrueN
	Union 
	Select ChainID, Chain, ParentChainID, NodeType, SequenceOrder
	From RealR
	Union 
	Select ChainID, Chain, ParentChainID, NodeType, SequenceOrder
	From RParent
	Union
	Select ChainID, Chain, ParentChainID, NodeType, SequenceOrder
	From HardL
	Union
	Select ChainID, Chain, ParentChainID, NodeType, SequenceOrder
	From LParent

	-- Get rid of old Albertsons nodes
	Delete From @AllNodes Where ChainGroupID = 'N00172' Or ParentChainGroupID = 'N00172' 

	-- Get rid of old Safeway nodes
	Delete From @AllNodes Where ChainGroupName = 'Safeway Us'

	--- Merge the duplicated national nodes cause they play more than one role ---
	Insert Into @Dup(ChainGroupID, ChainGroupName, ParentChainGroupID, NodeType, SequenceOrder)
	Select ChainGroupID, ChainGroupName, ParentChainGroupID, Min(NodeType) + '; ' + Max(NodeType) NodeType, SequenceOrder
	From @AllNodes
	Group By ChainGroupID, ChainGroupName, ParentChainGroupID, SequenceOrder
	Having Count(*) > 1

	Delete From @AllNodes
	Where ChainGroupID in (Select ChainGroupID From @Dup)

	Insert Into @AllNodes
	Select ChainGroupID, ChainGroupName, ParentChainGroupID, NodeType, SequenceOrder
	From @Dup

	---------------
	Truncate Table PreCal.ChainGroupTree

	Insert Into PreCal.ChainGroupTree(ChainGroupID, ChainGroupName, ParentChainGroupID, NodeType, SequenceOrder, IsMSTRChainGroup)
	Select a.ChainGroupID, a.ChainGroupName, Case When a.ParentChainGroupID = '0--Null-Nil-Null--' Then Null Else a.ParentChainGroupID End, 
		a.NodeType, a.SequenceOrder, Case When cg.ChainGroupID is Null Then 0 Else 1 End
	From @AllNodes a
	Left Join PlayBook.ChainGroup cg on a.ChainGroupID = cg.ChainGroupID

	If (@Debug = 1)
	Begin
		--- Expecting Nothing ----
		Select 'Expecting Nothing '
		Select *
		From @AllNodes
		Where ChainGroupID in 
		(
			Select ChainGroupID
			From @AllNodes
			Group By ChainGroupID
			Having Count(*) > 1
		)
		Order By ChainGroupID
	End
End
Go

Select *
From PlayBook.ChainGroup

exec Precal.pPupulateChainGroupTree

Select *
From PreCal.ChainGroupTree
Order By SequenceOrder, ChainGroupName

Select *
From PreCal.ChainGroupTree Where ParentChainGroupID = 'N00184'



