use Portal_Data
Go

--Delete From BCMyday.PromotionExecution 
--Where ExecutionID in (
--SELECT Distinct pe.ExecutionID
----SELECT Distinct SAPAccountNumber, AccountName, a.LocalChainID, a.LocalChainID1, rp.PromotionName, pe.*
--FROM [BCMyday].[StoreCondition] sc
--Join SAP.Account a on a.AccountID = sc.AccountID
--Join BCMyday.PromotionExecution pe on sc.StoreConditionID = pe.StoreConditionID
--Join Playbook.RetailPromotion rp on pe.PromotionID = rp.PromotionID
--Join Playbook.PromotionAccountHier pah on pah.PromotionID = rp.PromotionID
--Where Coalesce(a.LocalChainID1, 0) = 0
--And ConditionDate >= '2015-05-11' And ConditionDate < '2015-06-22'
--And AccountName = 'Dollar General 015395'
--And pah.NationalChainID <> 21)

--Order By ConditionDate

SELECT Distinct pe.ExecutionID, lc.LocalChainName, rc.RegionalChainName, nc.NationalChainName, 
lc1.LocalChainName PromotionLocalChainName, rc1.RegionalChainName PromotionRegionalChainName, nc1.NationalChainName PromotionNationalChainName, 
SAPAccountNumber, AccountName, a.LocalChainID, nc.NationalChainID, rp.PromotionName, pe.*
FROM [BCMyday].[StoreCondition] sc
Join SAP.Account a on a.AccountID = sc.AccountID
Join SAP.LocalChain lc on a.LocalChainId = lc.LocalChainID
Join SAP.RegionalChain rc on rc.RegionalChainID = lc.RegionalChainID
Join SAP.NationalChain nc on rc.NationalChainID = nc.NationalChainID
Join BCMyday.PromotionExecution pe on sc.StoreConditionID = pe.StoreConditionID
Join Playbook.RetailPromotion rp on pe.PromotionID = rp.PromotionID
Join Playbook.PromotionAccountHier pah on pah.PromotionID = rp.PromotionID
Join SAP.LocalChain lc1 on pah.LocalChainId = lc1.LocalChainID
Join SAP.RegionalChain rc1 on pah.RegionalChainID = rc1.RegionalChainID
Join SAP.NationalChain nc1 on pah.NationalChainID = nc1.NationalChainID
Where Coalesce(a.LocalChainID1, 0) = 0
Order By pe.ExecutionID, nc.NationalChainName, rc.RegionalChainName, lc.LocalChainName

--And ConditionDate >= '2015-05-11' And ConditionDate < '2015-06-22'
--And AccountName like '%Dollar%'
--And pah.NationalChainID <> 21

Select *
From Playbook.PromotionAccountHier
Where PromotionID = 42794

Select *
From SAP.nationalChain
Where NationalChainID = 60

Select ExecutionID, PromotionID, a.AccountID
From BCMyday.PromotionExecution pe
Join BCMyDay.StoreCondition sc on pe.StoreConditionID = sc.StoreConditionID
Join SAP.Account a on sc.AccountID = a.AccountID
Where Coalesce(a.LocalChainID1, 0) = 0




