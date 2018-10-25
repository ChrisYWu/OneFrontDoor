use Portal_Data
Go

If exists (Select *
	From Sys.procedures p
	Join Sys.schemas s on p.schema_id = s.schema_id
	Where p.name = 'pGetManagementPriorityIDsForBottler' and s.name = 'BCMyDay')
	Drop Proc BCMyDay.pGetManagementPriorityIDsForBottler
Go

-------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/* ----------- Testing bench -------
exec BCMyDay.pGetManagementPriorityIDsForBottler @BottlerID = 604

*/

Create Proc BCMyDay.pGetManagementPriorityIDsForBottler
(
	@BottlerID int
)
As
	--Select ManagementPriorityID PriorityID
	--From BCMyday.ManagementPriority 

	Select Distinct ManagementPriorityID PriorityID
	From
	(
		Select ManagementPriorityID, b.BottlerID
		From BCMyday.ManagementPriority m
		Cross Join BC.Bottler b
		Where GetDate() Between StartDate And EndDate
		And b.BCRegionID is not null
		And TypeID = 1
		And ForAllBottlers = 1
		--------------
		Union
		Select distinct reg.ManagementPriorityID, reg.BottlerID
		From BCMyday.ManagementPriority mp
		Join
			(
			Select ManagementPriorityID, BottlerID
			From BCMyday.PriorityBottler
			Where BottlerID > 0
			Union
			Select ManagementPriorityID, b.BottlerID
			From BCMyday.PriorityBottler pb
			Join BC.Bottler b on pb.RegionID = b.BCRegionID
			Where pb.BottlerID is null and pb.RegionID > 0
			Union
			Select ManagementPriorityID, b.BottlerID
			From BCMyday.PriorityBottler pb
			Join BC.Region r on pb.DivisionID = r.DivisionID  
			Join BC.Bottler b on b.BCRegionID = r.RegionID
			Where pb.DivisionID > 0 and pb.RegionID is null
			Union
			Select ManagementPriorityID, b.BottlerID
			From BCMyday.PriorityBottler pb
			Join BC.Division d on pb.ZoneID = d.ZoneID
			Join BC.Region r on d.DivisionID = r.DivisionID
			Join BC.Bottler b on b.BCRegionID = r.RegionID
			Where pb.ZoneID > 0 and pb.DivisionID is null
			Union
			Select ManagementPriorityID, b.BottlerID
			From BCMyday.PriorityBottler pb
			Join BC.Zone z on pb.SystemID = z.SystemID
			Join BC.Division d on z.ZoneID = d.ZoneID
			Join BC.Region r on d.DivisionID = r.DivisionID
			Join BC.Bottler b on b.BCRegionID = r.RegionID
			Where pb.SystemID > 0 and pb.ZoneID is null
		) reg on reg.ManagementPriorityID = mp.ManagementPriorityID
		Where GetDate() Between StartDate And EndDate
		And ForAllBottlers = 0
		And TypeID = 1
	) allRecords
	Where BottlerID = @BottlerID

Go

