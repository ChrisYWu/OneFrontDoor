use Portal_Data
Go

Select *
From MSTR.RevChainImages
Where NationalChainName like 'H-E-B'

Select *
From PreCal.ChainGroupTree
Where NodeType like '%;%'

Select *
From [MSTR].[RevChainImages]
Where ChainID in ('N00177', 'R00596')

Select *
From [MSTR].[RevChainImages]
Where Chain like 'Costco%'
