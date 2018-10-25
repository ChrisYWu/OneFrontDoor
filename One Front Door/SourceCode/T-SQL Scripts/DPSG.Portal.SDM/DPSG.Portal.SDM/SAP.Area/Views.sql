Use Portal_Data
Go

ALTER VIEW [MView].[LocationChain]
AS
SELECT DISTINCT 
        ch.SAPNationalChainID, ch.NationalChainName, ch.SAPRegionalChainID, ch.RegionalChainName, ch.SAPLocalChainID, ch.LocalChainName, ch.LocalChainID, 
        ch.RegionalChainID, ch.NationalChainID, lh.BUName AS BU, lh.BUID AS BUID, lh.RegionName AS Region, lh.RegionID, lh.BranchName AS BranchName, 
        lh.BranchID AS BranchID, lh.AreaID, lh.SAPAreaID, lh.AreaName
FROM            SAP.Account AS a INNER JOIN
                SAP.Branch AS br ON br.BranchID = a.BranchID INNER JOIN
                MView.ChainHier AS ch ON a.LocalChainID = ch.LocalChainID INNER JOIN
                MView.LocationHier AS lh ON br.BranchID = lh.BranchID
WHERE        (a.Active = 1)
GO

CREATE NONCLUSTERED INDEX [NC_AccountID_BranchIDChannalIDActive] ON [SAP].[Account]
(
	[BranchID] ASC,
	[AccountID] ASC,
	[ChannelID] ASC,
	[Active] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
Go

ALTER View [MView].[LocationChannel]
AS
Select Distinct ch.*, lh.*
From SAP.Account a
Join SAP.Branch br on br.BranchID = a.BranchID
Join SAP.Channel ch on a.ChannelID = ch.ChannelID
Join MView.LocationHier lh on br.BranchID = lh.BranchID
Where a.Active = 1
Go

ALTER View [MView].[LocationHier]
As
Select BUName, SPBUName, RegionName, SPRegionName, SAPAreaID, AreaName, SAPBranchID, BranchName, SPBranchName, bu.BUID, a.RegionID, b.BranchID, area.AreaID
From SAP.BusinessUnit bu
	Join SAP.Region a on bu.BUID = a.BUID
	Join SAP.Area area on area.RegionID = a.RegionID
	Join SAP.Branch b on area.AreaID = b.AreaID
GO
