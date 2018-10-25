use Portal_Data204
Go

If exists (Select *
	From Sys.procedures p
	Join Sys.schemas s on p.schema_id = s.schema_id
	Where p.name = 'pGetBCPrioritiesByRegionID' and s.name = 'BCMyDay')
	Drop Proc BCMyDay.pGetBCPrioritiesByRegionID
Go

-------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* ----------- Testing bench -------
exec BCMyDay.pGetBCPrioritiesByRegionID @RegionID = 36

exec BCMyDay.pGetBCPrioritiesByRegionID @RegionID = 44

*/

Create Proc BCMyDay.pGetBCPrioritiesByRegionID
(
	@RegionID int,
	@LastModifiedTime datetime2(7) = '1970-01-01'
)
As

	Declare @MP Table
	(
		ManagementPriorityID int, 
		Description varchar(200), 
		StartDate Date, 
		EndDate Date, 
		Created DateTime2(7), 
		LastModified DateTime2(7), 
		Active bit, 
		ForAllBottlers bit, 
		ForAllBrands bit, 
		ForAllChains bit, 
		ForAllPackages bit
	)

	Insert Into @MP
	Select distinct mp.ManagementPriorityID, Description, StartDate, EndDate, Created, mp.LastModified, Active, ForAllBottlers, ForAllBrands, ForAllChains, ForAllPackages
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
		And GetDate() Between StartDate And DateAdd(Day, 1, EndDate)
		And m.LastModified >= @LastModifiedTime
		--Union
		--Select Distinct ManagementPriorityID, b.BCRegionID RegionID
		--From BCMyday.PriorityBottler pb
		--Join BC.Bottler b on pb.BottlerID = b.BottlerID
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
		And GetDate() Between StartDate And DateAdd(Day, 1, EndDate)
		And m.LastModified >= @LastModifiedTime
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
		And m.ForAllChains = 1
		And GetDate() Between StartDate And DateAdd(Day, 1, EndDate)
		And m.LastModified >= @LastModifiedTime
	) lc on lc.ManagementPriorityID = mp.ManagementPriorityID
	Join Bc.tRegionChainTradeMark trct on trct.RegionID = reg.RegionID 
			And trct.TradeMarkID = tr.TradeMarkID 
			And trct.LocalChainID = lc.LocalChainID
	Where GetDate() Between StartDate And DateAdd(Day, 1, EndDate)
	And mp.LastModified >= @LastModifiedTime
	And reg.RegionID = @RegionID
	And mp.TypeID = 1
	And trct.TerritoryTypeID <> 10
	And trct.ProductTypeID = 1
	And mp.PublishingStatus in (2,3)

	--------------------------------------
	Select * From @MP Order By ManagementPriorityID

	Select pc.ManagementPriorityID, NationalChainID, RegionalChainID, LocalChainID, pc.LastModified
	From BCMyDay.PriorityChain pc
	Join @MP mp on pc.ManagementPriorityID = mp.ManagementPriorityID
	Union
	Select mp.ManagementPriorityID, -1, null, null, mp.LastModified
	From @MP mp
	Where mp.ForAllChains = 1
	Order By pc.ManagementPriorityID, NationalChainID, RegionalChainID, LocalChainID

	Select pc.ManagementPriorityID, TradeMarkID, BrandID, pc.LastModified
	From BCMyDay.PriorityBrand pc
	Join @MP mp on pc.ManagementPriorityID = mp.ManagementPriorityID
	Union
	Select mp.ManagementPriorityID, -1, null, mp.LastModified
	From @MP mp 
	Where mp.ForAllBrands = 1
	Order By pc.ManagementPriorityID, TradeMarkID, BrandID, pc.LastModified

Go


