use Portal_Data
Go

Create Table BCMyDay.TieInFairShareStatus
(
	TieInFairShareStatusID int Primary Key,
	Description Varchar(50),
	Active bit
)

Insert BCMyDay.TieInFairShareStatus
Values(0, 'Not Answered', 1)

Insert BCMyDay.TieInFairShareStatus
Values(1, 'Fair', 1)

Insert BCMyDay.TieInFairShareStatus
Values(2, 'Not Fair', 1)
Go

Alter Table [BCMyday].[StoreConditionDisplay]
Add TieInFairShareStatusID Int Null 
Go

Update [BCMyday].[StoreConditionDisplay]
Set TieInFairShareStatusID = 0
Go

Alter Table [BCMyday].[StoreConditionDisplay]
Alter Column TieInFairShareStatusID Int Not Null
Go

ALTER TABLE [BCMyday].[StoreConditionDisplay]  WITH CHECK ADD  CONSTRAINT [FK_StoreConditionDisplay_TieInFairShareStatus] FOREIGN KEY(TieInFairShareStatusID)
REFERENCES BCMyDay.TieInFairShareStatus (TieInFairShareStatusID)
ON DELETE CASCADE
GO

ALTER TABLE [BCMyday].[StoreConditionDisplay] CHECK CONSTRAINT [FK_StoreConditionDisplay_TieInFairShareStatus]
GO



