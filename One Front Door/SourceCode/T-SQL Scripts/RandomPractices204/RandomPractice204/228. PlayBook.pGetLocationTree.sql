USE Portal_Data
GO

If Exists (Select * From sys.procedures Where object_id = object_id('Playbook.pGetLocationTree'))
	Drop Proc Playbook.pGetLocationTree
Go

Set QUOTED_IDENTIFIER ON
GO


/*
-- Deployed to 108 --
Declare @StartTime DateTime2(7)
Set @StartTime = SYSDATETIME()
exec Playbook.pGetLocationTree
Select replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
*/

Create Proc Playbook.pGetLocationTree
AS
Begin
	Set NoCount On;

	Select '0All' NodeID, 'All BUs' NodeName, '#' ParentID
	Union
	Select '1B' + Convert(varchar, BUID) NodeID, BUName NodeName, '0All' ParentID
	From SAP.BusinessUnit
	Union
	Select '2R' + Convert(Varchar, RegionID) NodeID, RegionName NodeName, '1B' + Convert(varchar, BUID) ParentID
	From SAP.Region
	Union
	Select '3A' + Convert(Varchar, AreaID) NodeID, AreaName NodeName, '2R' + Convert(varchar, RegionID) ParentID
	From SAP.Area
	Where AreaID in (Select Distinct AreaID From PreCal.PromotionBranchChainGroup g Join SAP.Branch b on b.BranchID = g.BranchID)
	Union
	Select '4B' + Convert(Varchar, BranchID) NodeID, BranchName NodeName, '3A' + Convert(varchar, AreaID) ParentID
	From SAP.Branch
	Where BranchID in (Select Distinct BranchID From PreCal.PromotionBranchChainGroup)
	Order By NodeName
End
Go

--Select *
--From SAP.BusinessUnit


--Select *
--From PreCal.ChainGroupTree
--Where ParentChainGroupID = 'N00185'

--SElect *
--From PreCal.ChainGroupTree
--Where ChainGroupName = 'H-E-B'


