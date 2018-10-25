USE Portal_Data
GO

Select *
From MSTR.RevChainImages
Where Chain like '%H-E-B%'

Select *
From PlayBook.ChainGroup



If Exists (Select * From sys.procedures Where object_id = object_id('Playbook.pGetChainTree'))
	Drop Proc Playbook.pGetChainTree
Go

Set QUOTED_IDENTIFIER ON
GO


/*
-- Deployed to 108 --
Declare @StartTime DateTime2(7)
Set @StartTime = SYSDATETIME()
exec Playbook.pGetChainTree @Debug =1, @RegionIDs = 8, @Date = '2015-1-1', @ChainGroups = 'N00055,L00324,L03072,L03076,L02452,N00042,R00161,R00278,R00169,R00126,R00127,R00123,N00066,N00050,R00148,R00144,N00012,R00021,R00017,R00020,N00021,N00121,N00036,R00092,R00106,R00103,N00085'
Select replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds

exec Playbook.pGetChainTree @RegionIDs = 8, @Date = '2015-1-1', @ChainGroups = 'N00055,L00324,L03072,L03076,L02452,N00042,R00161,R00278,R00169,R00126,R00127,R00123,N00066,N00050,R00148,R00144,N00012,R00021,R00017,R00020,N00021,N00121,N00036,R00092,R00106,R00103,N00085'


*/

Create Proc Playbook.pGetChainTree
AS
Begin
	/*  Rivision History
	2015-11-09 First Version; Not completed and not deployed


	*/

	Set NoCount On;

	If (@Debug = 1)
	Begin
		Declare @StartTime DateTime2(7)
		Set @StartTime = SYSDATETIME()

		Select '---- Starting ----' Debug
	End

	Select 'A00000' ChainID, 'All Chains' ChainName, '#' ParentChainID, 0 IsMSTRChainGroup
	Union
	Select 'N' + REPLACE(STR(nc.NationalChainID,5),' ','0') ChainID, NationalChainName nc.ChainName, 'A00000' ParentChainID,
		Case When r.ChainID is null Then 0 Else 1 End IsMSTRChainGroup
	From SAP.NationalChain nc
	Left Join MSTR.RevChainImages r on lc.LocalChainID = r.LocalChainID and r.ChainHierTypeDef = 'N'
	Union
	Select 'R' + REPLACE(STR(RegionalChainID,5),' ','0') ChainID, RegionalChainName ChainName, 'N' + REPLACE(STR(NationalChainID,5),' ','0') ParentChainID
	From SAP.RegionalChain
	Union
	Select 'L' + REPLACE(STR(lc.LocalChainID,5),' ','0') ChainID, lc.LocalChainName ChainName, 'R' + REPLACE(STR(lc.RegionalChainID,5),' ','0') ParentChainID, 
		Case When r.ChainID is null Then 0 Else 1 End IsMSTRChainGroup
	From SAP.LocalChain lc
	Left Join MSTR.RevChainImages r on lc.LocalChainID = r.LocalChainID and r.ChainHierTypeDef = 'L'

	Select Top 1000 *
	From MSTR.RevChainImages 

	If (@Debug = 1)
	Begin
		Select '---- Promotion ChainGroups and parent chaingroups retrived ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds
	End

End

Go



