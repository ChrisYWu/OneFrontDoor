use Portal_Data
Go

ALTER TABLE [BCMyday].[PromotionExecution] DROP CONSTRAINT [FK_PromotionExecution_DisplayLocation]
GO

Alter Table BCMyDay.PromotionExecution
Drop Column DisplayLocationID 
Go

Alter Table BCMyDay.PromotionExecution
Add StoreConditionDisplayID int null
Go

--ALTER TABLE [BCMyday].[PromotionExecution]  WITH CHECK ADD  CONSTRAINT [FK_PromotionExecution_StoreConditionDisplay] 
--FOREIGN KEY(StoreConditionDisplayID)
--REFERENCES [BCMyday].[StoreConditionDisplay] (StoreConditionDisplayID)
--On Delete Set Null
--GO

--ALTER TABLE [BCMyday].[PromotionExecution] CHECK CONSTRAINT [FK_PromotionExecution_StoreConditionDisplay]
--GO

