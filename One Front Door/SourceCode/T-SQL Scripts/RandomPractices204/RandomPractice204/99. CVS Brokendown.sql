
--- This data is in QA 121 ---
use Portal_Data
Go

Select *
From Staging.TempCVSHierarchySQ7 c,
Staging.TempCVSChainBrokendown a
Where c.SAPLocalChainID = a.CAPLocalChainID


---- this query is better to be in prod, QA can represent the result as well -----
Select *
From Playbook.PromotionAccount
Where NationalChainID = 1 Or RegionalChainID = 1 Or LocalChainID = 21

SElect *
From Playbook.PromotionAccountHier
Where NationalChainID = 1 Or RegionalChainID = 1 Or LocalChainID = 21
