use Portal_Data805
Go

CREATE NONCLUSTERED INDEX NCI_UserLocation_GSN
ON [Person].[UserLocation] ([GSN])
Go

CREATE NONCLUSTERED INDEX NCI_Promotion_RelevantDate
ON [Playbook].[RetailPromotion] ([PromotionRelevantStartDate],[PromotionRelevantEndDate])
INCLUDE ([PromotionID])
GO



