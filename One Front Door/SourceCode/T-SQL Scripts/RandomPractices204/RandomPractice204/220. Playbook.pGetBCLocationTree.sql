USE Portal_Data
GO

If Exists (Select * From sys.procedures Where object_id = object_id('Playbook.pGetBCLocationTree'))
	Drop Proc Playbook.pGetBCLocationTree
Go

Set QUOTED_IDENTIFIER ON
GO


/*
-- Deployed to 108 --
Declare @StartTime DateTime2(7)
Set @StartTime = SYSDATETIME()
exec Playbook.pGetBCLocationTree
Select replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
*/

Create Proc Playbook.pGetBCLocationTree
AS
Begin
	Set NoCount On;

	Select '0All' NodeID, 'All Systems' NodeName, '#' ParentID
	Union
	Select '1S' + Convert(varchar, SystemID) NodeID, SystemName NodeName, '0All' ParentID
	From BC.System Where SystemID in (5,6,7)
	Union
	Select '2Z' + Convert(Varchar, ZoneID) NodeID, ZoneName NodeName, '1S' + Convert(varchar, s.SystemID) ParentID
	From BC.Zone z Join BC.System s on z.SystemID = s.SystemID Where s.SystemID in (5,6,7)
	Union
	Select Distinct '3D' + Convert(Varchar, d.DivisionID) NodeID, d.DivisionName NodeName, '2Z' + Convert(varchar, d.ZoneID) ParentID
	From PreCal.BottlerHier h Join BC.Division d on h.DivisionID = d.DivisionID
	Union
	Select Distinct '4R' + Convert(Varchar, r.RegionID) NodeID, r.RegionName NodeName, '3D' + Convert(varchar, r.DivisionID) ParentID
	From PreCal.BottlerHier h Join BC.Region r on h.RegionID = r.RegionID
	Union
	Select Distinct '5B' + Convert(Varchar, b.BottlerID) NodeID, b.BottlerName NodeName, '4R' + Convert(varchar, h.RegionID) ParentID
	From PreCal.BottlerHier h Join BC.Bottler b on h.BottlerID = b.BottlerID
	Order By NodeName
End
Go

--Select *
--From PreCal.BottlerHier

--Select BottlerID, Count(*) Cnt
--From BC.tBottlerChainTradeMark
--Where TerritoryTypeID in (10, 11)
--And ProductTypeID = 1
--Group by BottlerID

--Select Top 1 *
--From BC.tBottlerChainTradeMark


--Select *
--From SAP.BusinessUnit


--Select *
--From PreCal.ChainGroupTree
--Where ParentChainGroupID = 'N00185'

--SElect *
--From PreCal.ChainGroupTree
--Where ChainGroupName = 'H-E-B'


