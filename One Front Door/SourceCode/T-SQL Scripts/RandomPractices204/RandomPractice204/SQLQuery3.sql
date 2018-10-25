use Portal_Data
Go

Select *
From Playbook.RetailPromotion
Where PromotionID = 29064

exec Playbook.pSaveDSDPromotion @PromotionID = 29064, @Debug = 1

Select *
From Playbook.PromotionGeoRelevancy
Where PromotionID = 29064


Select *
From Playbook.PromotionAccount
Where PromotionID = 29064

Select BUID, RegionID, AreaID, BranchID, StateID, 
	Case When (Coalesce(BUID, RegionID, AreaID, BranchID, 0) > 0) Then 1 Else 0 End HierDefined, 
	Case When (Coalesce(StateID, 0) > 0) Then 1 Else 0 End StateDefined,
	1 TYP 
From Playbook.PromotionGeoRelevancy pgr
Join Playbook.RetailPromotion rp on pgr.PromotionID = rp.PromotionID
Where 
--(
--	Coalesce(BUID, RegionID, AreaID, BranchID, StateID, 0) > 0
--) And 
pgr.PromotionID = 29064

