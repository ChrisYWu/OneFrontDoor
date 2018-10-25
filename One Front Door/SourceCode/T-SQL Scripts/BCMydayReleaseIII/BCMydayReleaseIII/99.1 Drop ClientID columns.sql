use Portal_Data
Go

ALTER TABLE [BCMyday].[PriorityStoreConditionExecution] DROP CONSTRAINT [DF_PriorityStoreConditionExecution_ClientPriorityExecutionID]
GO

Alter Table [BCMyday].[PriorityStoreConditionExecution]
Drop column [ClientPriorityExecutionID] 
Go

-------------------
ALTER TABLE [BCMyday].[PromotionExecution] DROP CONSTRAINT [DF_PromotionExecution_ClientPromotionExecutionID]
GO

Alter Table [BCMyday].[PromotionExecution]
Drop column [ClientPromotionExecutionID]
Go

Select *
From BCMyday.StoreCondition
Order By ModifiedDate desc

Select *
From BCMyday.PriorityStoreConditionExecution
Where StoreConditionID = 9186

