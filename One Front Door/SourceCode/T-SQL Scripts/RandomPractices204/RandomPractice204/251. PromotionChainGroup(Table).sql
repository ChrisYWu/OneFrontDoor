Use Portal_Data805
Go

With PromoAccountHier As
(
	Select pa.PromotionID, hier.NationalChainID, hier.RegionalChainID, hier.LocalChainID
	From PlayBook.PromotionAccount pa
	Join Processing.tChainSeeking hier on pa.NationalChainID = hier.NationalChainID
	Union
	Select Distinct pa.PromotionID, -1, hier.RegionalChainID, hier.LocalChainID
	From PlayBook.PromotionAccount pa
	Join Processing.tChainSeeking hier on pa.RegionalChainID = hier.RegionalChainID
	Union
	Select Distinct pa.PromotionID, -1, -1, pa.LocalChainID
	From PlayBook.PromotionAccount pa
	Where isnull(pa.LocalChainID, 0) > 0
)

Select Distinct PromotionID, ChainGroupID, MSTRChainGroupID, ChainGroupName
From PromoAccountHier pah,
MSTR.RevChainImages rci,
Playbook.ChainGroup cg
Where (pah.NationalChainID = rci.NationalChainID
Or pah.RegionalChainID = rci.RegionalChainID
Or pah.LocalChainID = rci.LocalChainID)
And cg.MSTRChainGroupID = rci.ChainID
Order By PromotionID, ChainGroupName


