use Portal_DataGoalVh2
Go

Select *
From Nielsen.Market
Go

Select t.TaskID, t.GoalAccountID, a.GoalAccountID, a.Actual, a.LastYearActual, 
	m.AccountMasterID, m.AccountSize, m.GoalModuleID,
	nm.MarketID, nm.MarketName, nm.Level
From Goal.GoalAccountTask t
Join Goal.GoalAccount a on t.GoalAccountID = a.GoalAccountID
Join Goal.AccountMaster m on a.AccountMasterID = m.AccountMasterID
Join Nielsen.Market nm on m.MarketID = nm.MarketID
Go

Select *
From Goal.AccountMaster
Go

Select *
From Goal.GoalAccountTask

Insert Into Goal.GoalAccountTask(TaskID, GoalAccountID, CreatedDate, CreatedBy, ModifiedDate, ModifiedBy)
Values(6, 12, '2014-7-12', 'CWU', '2014-7-12', 'CWU')

Insert Into Goal.GoalAccountTask(TaskID, GoalAccountID, CreatedDate, CreatedBy, ModifiedDate, ModifiedBy)
Values(7, 16, '2014-7-12', 'CWU', '2014-7-12', 'CWU')


select *
from Goal.GoalAccount


select *
From Goal.GoalMaster


 