use Portal_Data
Go

Select @@SERVERNAME
Go

Select *
From Playbook.RetailPromotion
where promotionid in (56479, 58696)

select * 
from [Playbook].[PromotionGeoHier]
where promotionid in (56479, 58696)
and AreaID is not null

select * from [Playbook].[PromotionGeoRelevancy]
where promotionid in (56479, 58696)

Select PromotionID, Count(*)
From [Playbook].[RetailExecutionDisplay]
where promotionid in (56479, 58696)
Group By PromotionID

