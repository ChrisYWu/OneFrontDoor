use Portal_Data
Go

----------------------------------
Alter Table [BCMyday].[StoreConditionDisplayDetail]
Add StoreConditionDisplayDetailID int identity(1,1) primary key
Go

----------------------------------
ALTER TABLE [BCMyday].[StoreConditionDisplayDetail]  WITH CHECK ADD CONSTRAINT [FK_StoreConditionDisplayDetail_StoreConditionDisplay] FOREIGN KEY([StoreConditionDisplayID])
REFERENCES [BCMyday].[StoreConditionDisplay] ([StoreConditionDisplayID])
ON DELETE CASCADE
GO

ALTER TABLE [BCMyday].[StoreConditionDisplayDetail] CHECK CONSTRAINT [FK_StoreConditionDisplayDetail_StoreConditionDisplay]
GO

----------------------------------
ALTER TABLE [BCMyday].[StoreConditionDisplay]  WITH CHECK ADD CONSTRAINT [FK_StoreConditionDisplay_StoreCondition] FOREIGN KEY([StoreConditionID])
REFERENCES [BCMyday].[StoreCondition] ([StoreConditionID])
ON DELETE CASCADE
GO

ALTER TABLE [BCMyday].[StoreConditionDisplay] CHECK CONSTRAINT [FK_StoreConditionDisplay_StoreCondition]
GO

Alter Table [BCMyday].[StoreConditionDisplay]
Alter Column StoreConditionID int not null
Go

----------------------------------
ALTER TABLE [BCMyday].[StoreTieInRate]  WITH CHECK ADD CONSTRAINT [FK_StoreTieInRate_StoreCondition] FOREIGN KEY([StoreConditionID])
REFERENCES [BCMyday].[StoreCondition] ([StoreConditionID])
ON DELETE CASCADE
GO

ALTER TABLE [BCMyday].[StoreTieInRate] CHECK CONSTRAINT [FK_StoreTieInRate_StoreCondition]
GO

----------------------------------

Alter Table BCMyDay.StoreConditionDisplay
Add ImageSharePointID varchar(50) not null default ''
Go