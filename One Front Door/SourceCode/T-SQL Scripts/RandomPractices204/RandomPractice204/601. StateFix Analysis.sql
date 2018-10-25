use Portal_Data805
Go

Select Distinct b.BCBottlerID BottlerID, b.BottlerName, b.State LocationState, sr.RegionABRV ServingState, sr.RegionName ServingStateName, sr.CountryCode
From BC.BottlerAccountTradeMark bat
Join BC.Bottler b on bat.BottlerID = b.BottlerID
Join SAP.Account a on bat.AccountID = a.AccountID
Join Shared.StateRegion sr on a.State = sr.RegionABRV
Where a.CRMActive = 1
And b.BCRegionID is not null
And bat.TerritoryTypeID in (10, 11)
And bat.ProductTypeID = 1
Order By b.BottlerName, sr.RegionName

Select rp.PromotionName, rp.PromotionStartDate, rp.PromotionEndDate, pgr.StateID, sr.RegionABRV StateABRV
From Playbook.RetailPromotion rp
Join Playbook.PromotionGeoRelevancy pgr on rp.PromotionID = pgr.PromotionId
Join Shared.StateRegion sr on pgr.StateId = sr.StateRegionID
And pgr.StateId is not null
Order By rp.PromotionName, rp.PromotionStartDate

Select Distinct rp.PromotionID, rp.PromotionName, rp.PromotionStartDate, rp.PromotionEndDate, Case When GetDate() Between rp.PromotionStartDate And rp.PromotionEndDate Then 1 Else 0 End IsCurrentPromotion
From Playbook.RetailPromotion rp
Join Playbook.PromotionGeoRelevancy pgr on rp.PromotionID = pgr.PromotionId
Join Shared.StateRegion sr on pgr.StateId = sr.StateRegionID
And pgr.StateId is not null
Order By rp.PromotionName, rp.PromotionStartDate