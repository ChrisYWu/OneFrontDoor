use Portal_DAta
Go

--Alter TABLE BCMyday.PriorityStoreConditionExecution
--Drop DF_PriorityStoreConditionExecution_ClientPriorityExecutionID
--Go

--Alter TABLE BCMyday.PriorityStoreConditionExecution
--Drop Column ClientPriorityExecutionID 
--Go

Alter TABLE BCMyday.PriorityStoreConditionExecution
Add ClientPriorityExecutionID int NOT NULL CONSTRAINT DF_PriorityStoreConditionExecution_ClientPriorityExecutionID  DEFAULT ((0))
Go

Alter TABLE BCMyday.PromotionExecution
Add ClientPromotionExecutionID int NOT NULL CONSTRAINT DF_PromotionExecution_ClientPromotionExecutionID  DEFAULT ((0))
Go
 

 Select top 100 *
 from Playbook.RetailPromotion 
 Order By PromotionID desc

 select *
 from sap.account
 where accountid = 181178
