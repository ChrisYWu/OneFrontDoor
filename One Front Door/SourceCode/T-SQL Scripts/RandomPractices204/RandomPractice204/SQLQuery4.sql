use Portal_Data_INT
Go

exec Playbook.pGetChainGroupsFromBCPromos @SystemIDs = '5,6,7', @Date = '2015-1-1'

Select *
From BC.System


--Select Distinct TableName
--From PreCal.vSchemaDocument
--Order By TableName

--Select *
--From PreCal.vSchemaDocument
--Where TableName = 'PreCal.ChainGroupTree'

--SequenceOrder	int
--IsMSTRChainGroup	bit
--ChainGroupID	varchar(20)
--ChainGroupName	varchar(100)
--ParentChainGroupID	varchar(20)
--NodeType	varchar(100)

--Select *
--From PreCal.RegionTMLocalChain
