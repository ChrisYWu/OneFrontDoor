USE [Portal_Data]
GO

/****** Object:  View [MView].[AccountRouteSchedule]    Script Date: 3/21/2013 5:15:11 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create view [MView].[AccountRouteSchedule] as
SELECT   rsd.SequenceNumber AS StopSequence, rsd.Day AS RouteDay, b.BranchID, a.SAPAccountNumber, sr.SAPRouteNumber, a.AccountName, a.Address, a.City, a.State, a.PostalCode, 
                      nc.SPNationalChainName, ch.SAPNationalChainID,ch.NationalChainID, ch.RegionalChainName, ch.SAPRegionalChainID,ch.RegionalChainID, ch.LocalChainName, ch.SAPLocalChainID,ch.LocalChainID, c.SPChannelName, 
                      c.SAPChannelID, b.SAPBranchID, b.SPBranchName
FROM         SAP.RouteScheduleDetail AS rsd INNER JOIN
                      SAP.RouteSchedule AS rs ON rsd.RouteScheduleID = rs.RouteScheduleID and rsd.Day = DATEDIFF(Day, rs.StartDate, GETDATE()) % 28  INNER JOIN
                      SAP.Account AS a ON rs.AccountID = a.AccountID INNER JOIN
                      SAP.Branch AS b ON a.BranchID = b.BranchID INNER JOIN
                      SAP.SalesRoute AS sr ON sr.RouteID = rs.RouteID INNER JOIN
                      MView.ChainHier AS ch ON a.LocalChainID = ch.LocalChainID INNER JOIN
                      SAP.NationalChain AS nc ON nc.NationalChainID = ch.NationalChainID INNER JOIN
                      SAP.Channel AS c ON a.ChannelID = c.ChannelID
WHERE     (sr.Active = 1) AND (a.Active = 1) ----and sr.SAPRouteNumber='110801055'


GO


