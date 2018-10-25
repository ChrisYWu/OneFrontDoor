Use Portal_Data
Go

--Create Table DVIEW.TodayRouteAccount
--(
--	StopSequence int,
--	SAPAccountNumber int,
--	SAPRouteNumber int,
--	AccountName	varchar(128),
--	AddressLine1 varchar(128),
--	City	varchar(128),
--	State	varchar(50),
--	PostalCode	varchar(20),
--	NationalChain varchar(50),
--	SAPNationalChainID varchar(20),
--	RegionalChain varchar(50),
--	SAPRegionalChainID varchar(20),
--	LocalChain	varchar(50),
--	SAPLocalChainID varchar(20),
--	Channel	varchar(50),
--	SAPChannelID varchar(20)	
--)

--CREATE NONCLUSTERED INDEX [NCIDX_TodayRouteAccount_SAPRouteNumber]
--ON [DView].[TodayRouteAccount] (SAPRouteNumber)
--Go

--CREATE NONCLUSTERED INDEX [NCIDX_TodayRouteAccount_SAPRouteNumber]
--ON [DView].[TodayRouteAccount] ([SAPRouteNumber])

Truncate Table DVIEW.TodayRouteAccount
Go

Insert DVIEW.TodayRouteAccount
Select SequenceNumber AS StopSequence, 
	a.SAPAccountNumber, SAPRouteNumber, a.AccountName, a.Address, a.City, a.State, a.PostalCode, 
	nc.SPNationalChainName, ch.SAPNationalChainID, 
	ch.RegionalChainName, ch.SAPRegionalChainID, 
	ch.LocalChainName, ch.SAPLocalChainID, 
	c.SPChannelName, c.SAPChannelID, b.SAPBranchID, b.SPBranchName
From SAP.RouteScheduleDetail rsd
	JOin SAP.RouteSchedule rs on rsd.RouteScheduleID = rs.RouteScheduleID
	Join SAP.Account a on rs.AccountID = a.AccountID
	Join SAP.Branch b on a.BranchID = b.BranchID
	Join SAP.SalesRoute sr on sr.RouteID = rs.RouteID
	Join MView.ChainHier ch on a.LocalChainID = ch.LocalChainID
	Join SAP.NationalChain nc on nc.NationalChainID = ch.NationalChainID
	Join SAP.Channel c on a.ChannelID = c.ChannelID
Where DateDiff(Day, StartDate, GetDate()) % 28 = Day
	And sr.Active = 1
	And a.Active = 1
Go

Select Row_Number() Over (Order By StopSequence) StopOrder, *
From DVIEW.TodayRouteAccount
Where SAPRouteNumber = 101800139
Go

Select *
From SAP.NationalChain

