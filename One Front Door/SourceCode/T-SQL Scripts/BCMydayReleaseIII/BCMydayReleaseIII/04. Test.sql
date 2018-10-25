use Portal_Data204
Go

exec BCMyday.pGetLOSMaster @lastmodified = '2014-09-30'
exec BCMyday.pGetLOSMaster @lastmodified='2015-02-01 00:00:00'

SElect *
From BCMyday.SystemCompetitionBrand

Select * From BCMyday.SystemTradeMark


Select *
From BCMyday.PromotionExecutionStatus

Select SYSDATETIME()


