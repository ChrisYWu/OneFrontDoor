use Portal_Data
---- Point to Prod ----
Go

--Select *
--From Processing.BCvStoreERHSDM
--Order By L1_NODE_DESC, L2_NODE_DESC, L3_NODE_DESC, L4_NODE_DESC

Select NationalChainID, NationalChain, RegionalChainID, RegionalChain, LocalChainID, LocalChain
From Staging.Chain c
Where convert(varchar, convert(int, c.NationalChainID)) + convert(varchar, convert(int, c.RegionalChainID)) + convert(varchar, convert(int, c.LocalChainID))
Not IN (
Select convert(varchar, convert(int, c.NationalChainID)) + convert(varchar, convert(int, c.RegionalChainID)) + convert(varchar, convert(int, c.LocalChainID)) KE
From Processing.BCvStoreERHSDM bc
Join Staging.Chain c on convert(int, bc.L2_NODE_ID) = c.NationalChainID 
and convert(int, bc.L3_NODE_ID) = c.RegionalChainID 
and convert(int, bc.L4_NODE_ID) = c.LocalChainID
)

Select *
From Processing.BCvStoreERHSDM bc
Where convert(varchar, convert(int, bc.L2_NODE_ID)) + convert(varchar, convert(int, bc.L3_NODE_ID)) + convert(varchar, convert(int, bc.L4_NODE_ID))
Not IN (
	Select convert(varchar, convert(int, c.NationalChainID)) + convert(varchar, convert(int, c.RegionalChainID)) + convert(varchar, convert(int, c.LocalChainID)) KE
	From Processing.BCvStoreERHSDM bc
	Join Staging.Chain c on convert(int, bc.L2_NODE_ID) = c.NationalChainID 
	and convert(int, bc.L3_NODE_ID) = c.RegionalChainID 
	and convert(int, bc.L4_NODE_ID) = c.LocalChainID
)

Select *
From MView.ChainHier
Where LocalChainName like '%LOWE%'

