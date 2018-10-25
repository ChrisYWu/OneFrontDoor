use Portal_Data
Go

If exists (Select *
	From Sys.procedures p
	Join Sys.schemas s on p.schema_id = s.schema_id
	Where p.name = 'pGetRSMsByManagementPriorityID' and s.name = 'BCMyDay')
	Drop Proc BCMyDay.pGetRSMsByManagementPriorityID
Go

-------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* ----------- Testing bench -------
exec BCMyDay.pGetRSMsByManagementPriorityID @ManagementPriorityID = 5

exec BCMyDay.pGetRSMsByManagementPriorityID @ManagementPriorityID = 10

exec BCMyDay.pGetRSMsByManagementPriorityID @ManagementPriorityID = 30

exec BCMyDay.pGetRSMsByManagementPriorityID @ManagementPriorityID = 407

exec BCMyDay.pGetRSMsByManagementPriorityID @ManagementPriorityID = 401

Select *
From BCMyDay.ManagementPriority

*/

Create Proc BCMyDay.pGetRSMsByManagementPriorityID
(
	@ManagementPriorityID int
)
As

	Declare @MP Table
	(
		RegionID int
	)

	Insert Into @MP
	Select distinct reg.RegionID
	From BCMyday.ManagementPriority mp
	Join
		(
		Select ManagementPriorityID, RegionID
		From BCMyday.PriorityBottler
		Where RegionID > 0 and BottlerID is null
		Union
		Select ManagementPriorityID, r.RegionID
		From BCMyday.PriorityBottler pb
		Join BC.Region r on pb.DivisionID = r.DivisionID  
		Where pb.DivisionID > 0 and pb.RegionID is null
		Union
		Select ManagementPriorityID, r.RegionID
		From BCMyday.PriorityBottler pb
		Join BC.Division d on pb.ZoneID = d.ZoneID
		Join BC.Region r on d.DivisionID = r.DivisionID
		Where pb.ZoneID > 0 and pb.DivisionID is null
		Union
		Select ManagementPriorityID, r.RegionID
		From BCMyday.PriorityBottler pb
		Join BC.Zone z on pb.SystemID = z.SystemID
		Join BC.Division d on z.ZoneID = d.ZoneID
		Join BC.Region r on d.DivisionID = r.DivisionID
		Where pb.SystemID > 0 and pb.ZoneID is null
		Union
		Select ManagementPriorityID, RegionID
		From BCMyday.ManagementPriority m
		Cross Join BC.Region r
		Where m.TypeID = 1
		And r.Active = 1
		And m.ForAllBottlers = 1
		And GetDate() Between StartDate And EndDate
	) reg on reg.ManagementPriorityID = mp.ManagementPriorityID
	Join 
	(
		Select Distinct ManagementPriorityID, TradeMarkID
		From BCMyday.PriorityBrand
		Union
		Select Distinct ManagementPriorityID, TradeMarkID
		From BCMyday.ManagementPriority m
		Cross Join SAP.TradeMark t
		Where m.TypeID = 1
		And m.ForAllBrands = 1
		And GetDate() Between StartDate And EndDate
	) tr on tr.ManagementPriorityID = mp.ManagementPriorityID
	Join
	(
		Select ManagementPriorityID, LocalChainID
		From BCMyday.PriorityChain
		Union 
		Select ManagementPriorityID, l.LocalChainID
		From BCMyday.PriorityChain p
		Join SAP.LocalChain l on p.RegionalChainID = l.RegionalChainID
		Where p.RegionalChainID > 0 And p.LocalChainID is null
		Union 
		Select ManagementPriorityID, l.LocalChainID
		From BCMyday.PriorityChain p
		Join SAP.RegionalChain r on p.NationalChainID = r.NationalChainID
		Join SAP.LocalChain l on r.RegionalChainID = l.RegionalChainID
		Where p.NationalChainID > 0 And p.RegionalChainID is null
		Union
		Select ManagementPriorityID, l.LocalChainID
		From BCMyday.ManagementPriority m
		Cross Join SAP.LocalChain l
		Where m.TypeID = 1
		And m.ForAllBrands = 1
		And GetDate() Between StartDate And EndDate
	) lc on lc.ManagementPriorityID = mp.ManagementPriorityID
	Join Bc.tRegionChainTradeMark trct on trct.RegionID = reg.RegionID 
			And trct.TradeMarkID = tr.TradeMarkID 
			And trct.LocalChainID = lc.LocalChainID
	Where GetDate() Between StartDate And EndDate
	And mp.ManagementPriorityID = @ManagementPriorityID
	And mp.TypeID = 1
	And trct.TerritoryTypeID = 11
	And trct.ProductTypeID = 1

	--------------------------------------
	Select up.GSN, up.LastName, up.FirstName
	From Person.BCSalesAccountability a
	Join Person.UserProfile up on a.GSN = up.GSN
	Join @MP mp on mp.RegionID = a.RegionID
Go

