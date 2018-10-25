use Portal_DataSRE
Go

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

--- Spot check one passed 
--- SAP Account: 11311446
--- Conclusion:
--- We'll need to complement trademarks 
Select T.SAPTradeMarkID, A.SAPAccountNumber, MAP.ProductTypeID, map.TerritoryTypeID, b.BCBottlerID
From BC.TerritoryMap map
Join SAP.Account a on map.PostalCode = a.PostalCode and map.CountyID = a.CountyID
Join SAP.LocalChain l on a.LocalChainID = l.LocalChainID
Join SAP.RegionalChain r on r.RegionalChainID = l.RegionalChainID
Join SAP.NationalChain n on r.NationalChainID = n.NationalChainID
Join BC.Bottler b on map.BottlerID = b.BottlerID
Join SAP.TradeMark t on map.TradeMarkID = t.TradeMarkID
Where map.TerritoryTypeID = 12
And map.ProductTypeID = 1
And a.InCapstone = 1
And a.Active = 1
And SAPAccountNumber = 11311446
Order By SAPTradeMarkID, BCBottlerID

-- 'C34', 'O07', 'U00', 'W10'

-- I don't have those trademarks --
Select *
From SAP.TradeMark
Where SAPTradeMarkID IN ('C34', 'O07', 'U00', 'W10')
Go

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Declare @SAPAccount int

Declare vendor_cursor Cursor 
For
Select Distinct STR_ID
From Staging.BCStoreInclusion
Where TRADEMARK_ID not in ('C34', 'O07', 'U00', 'W10')
-- Out of 898 Account only 18 account has true exceptions --
-- And STR_ID < 11200000

Open vendor_cursor
Fetch Next From vendor_cursor Into @SAPAccount
While @@FETCH_STATUS = 0
Begin
	--Select @SAPAccount
	If Exists (
		Select *
		From Staging.BCStoreInclusion
		Where STR_ID = @SAPAccount
		And TERR_VW_ID = 12
		And TRADEMARK_ID not in ('C34', 'O07', 'U00', 'W10')
		And TRADEMARK_ID not in 
			(Select T.SAPTradeMarkID
			From BC.TerritoryMap map
			Join SAP.Account a on map.PostalCode = a.PostalCode and map.CountyID = a.CountyID
			Join SAP.LocalChain l on a.LocalChainID = l.LocalChainID
			Join SAP.RegionalChain r on r.RegionalChainID = l.RegionalChainID
			Join SAP.NationalChain n on r.NationalChainID = n.NationalChainID
			Join BC.Bottler b on map.BottlerID = b.BottlerID
			Join SAP.TradeMark t on map.TradeMarkID = t.TradeMarkID
			Where map.TerritoryTypeID = 12
			And map.ProductTypeID = 1
			And a.InCapstone = 1
			And a.Active = 1
			And SAPAccountNumber = @SAPAccount
		)
	)
	Begin
		Select *
		From Staging.BCStoreInclusion
		Where STR_ID = @SAPAccount
		And TERR_VW_ID = 12
		And TRADEMARK_ID not in 
			(Select T.SAPTradeMarkID
			From BC.TerritoryMap map
			Join SAP.Account a on map.PostalCode = a.PostalCode and map.CountyID = a.CountyID
			Join SAP.LocalChain l on a.LocalChainID = l.LocalChainID
			Join SAP.RegionalChain r on r.RegionalChainID = l.RegionalChainID
			Join SAP.NationalChain n on r.NationalChainID = n.NationalChainID
			Join BC.Bottler b on map.BottlerID = b.BottlerID
			Join SAP.TradeMark t on map.TradeMarkID = t.TradeMarkID
			Where map.TerritoryTypeID = 12
			And map.ProductTypeID = 1
			And a.InCapstone = 1
			And a.Active = 1
			And SAPAccountNumber = @SAPAccount
		)
	End
	Fetch Next From vendor_cursor Into @SAPAccount
END 
CLOSE vendor_cursor;
DEALLOCATE vendor_cursor;
Go

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 3 minutes to load(16M rows), need to do the full load every night --
-- Need to Drop and Recreating tables - much faster
If Exists (Select * From Sys.tables where object_id = object_id('Staging.BottlerAccountTradeMark'))
	Drop table Staging.BottlerAccountTradeMark
Go

-- 5:23 minutes
Truncate Table BC.BottlerAccountTradeMark
Go
--- 15 minutes to load with indexes--
Insert Into BC.BottlerAccountTradeMark
Select *
From 
(
	Select Distinct map.TerritoryTypeID, map.ProductTypeID, 0 IsStoreInclusion, map.BottlerID, map.TradeMarkID, a.AccountID, a.LocalChainID, a.ChannelID, a.BranchID
	From BC.TerritoryMap map
	Join SAP.Account a on map.PostalCode = a.PostalCode and map.CountyID = a.CountyID
	Where a.InCapstone = 1
	And a.Active = 1
	Union
	Select Distinct inc.TerritoryTypeID, inc.ProductTypeID, 1 IsStoreInclusion, inc.BottlerID, inc.TradeMarkID, a.AccountID, a.LocalChainID, a.ChannelID, a.BranchID
	From BC.AccountInclusion inc
	Join SAP.Account a on inc.AccountID = a.AccountID
	Where a.InCapstone = 1
	And a.Active = 1) tm
Go

-- 2s to delete the confliting rows -- 
-- Need to throtlle the flow from the source, so I don't have to filter it here - 

Delete map
From (Select * From BC.BottlerAccountTradeMark map Where IsStoreInclusion = 0) map
Join (Select * From BC.BottlerAccountTradeMark map Where IsStoreInclusion = 1) inc 
	on map.AccountID = inc.AccountID 
	And map.TradeMarkID = inc.TradeMarkID 
	And map.ProductTypeID = inc.ProductTypeID
	And map.TerritoryTypeID = inc.TerritoryTypeID
Go

-- 6 minutes to rekey --
ALTER TABLE BC.BottlerAccountTradeMark
ADD CONSTRAINT [PK_BottlerAccountTradeMark_BottlerID_AccountID_TradeMarkID_TerritoryTypeID_ProductID]
PRIMARY KEY CLUSTERED
(
[BottlerID] ASC,
[TerritoryTypeID] ASC,
[ProductTypeID] ASC,
[AccountID] ASC,
[TradeMarkID] ASC,
[IsStoreInclusion]
)

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Repopulating BottlerTradeMark(mostly for myday) relationship
Delete From BC.BottlerTradeMark
Go

Insert Into BC.BottlerTradeMark
Select Distinct BottlerID, TradeMarkID, TerritoryTypeID, ProductTypeID
From BC.BottlerAccountTradeMark
Go

------------------ Useful queries ------------------------
Select Distinct b.BottlerID, BCBottlerID, BottlerName
From BC.BottlerTradeMark bt
Join BC.Bottler b on bt.BottlerID = b.BottlerID
Where b.BCRegionID is not null -- Filter from accoutability scopes
And ProductTypeID = 1 -- Filter from Products

Select Distinct b.BottlerID, bt.TradeMarkID, t.SAPTradeMarkID, t.TradeMarkName
From BC.BottlerTradeMark bt
Join BC.Bottler b on bt.BottlerID = b.BottlerID
Join SAP.TradeMark t on bt.TradeMarkID = t.TradeMarkID
Where b.BCRegionID is not null -- Filter from accoutability scopes
And ProductTypeID = 1 -- Filter from Products


Go

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- takes 3:22 to finish full load
Drop Table Staging.BottlerAccountTradeMarkBranch

Select *
Into Staging.BottlerAccountTradeMarkBranch
From 
(
	Select Distinct map.TerritoryTypeID, map.ProductTypeID, 0 IsStoreInclusion, map.BottlerID, map.TradeMarkID, a.AccountID, a.BranchID
	From BC.TerritoryMap map
	Join SAP.Account a on map.PostalCode = a.PostalCode and map.CountyID = a.CountyID
	Where a.InCapstone = 1
	And a.Active = 1
	Union
	Select Distinct inc.TerritoryTypeID, inc.ProductTypeID, 1 IsStoreInclusion, inc.BottlerID, inc.TradeMarkID, a.AccountID, a.BranchID
	From BC.AccountInclusion inc
	Join SAP.Account a on inc.AccountID = a.AccountID
	Where a.InCapstone = 1
	And a.Active = 1) tm
Go

Delete map
From (Select * From Staging.BottlerAccountTradeMark map Where IsStoreInclusion = 0) map
Join (Select * From Staging.BottlerAccountTradeMark map Where IsStoreInclusion = 1) inc 
	on map.AccountID = inc.AccountID 
	And map.TradeMarkID = inc.TradeMarkID 
	And map.ProductTypeID = inc.ProductTypeID
	And map.TerritoryTypeID = inc.TerritoryTypeID
Go

---- How long does it take to load this? 40 minutes, some index has to be introduced to make it load faster ----
Select Distinct BUID, BUName, br.RegionID PBRegionID, br.RegionName PBRegionName, SAPAreaID, AreaID, AreaName, SAPBranchID, br.BranchID, BranchName, 
r.RegionID BCRegionID, r.BCNodeID BCRegionNodeID, r.RegionName BCRegionName, 
d.DivisionID BCDivisionID, d.BCNodeID BCDivisionNodeID, d.DivisionName BCDivisionName, 
z.ZoneID BCZoneID, z.BCNodeID BCZoneNodeID, z.ZoneName BCZoneName,
s.SystemID BCSystemID, s.BCNodeID BCSystemNodeID, s.SystemName BCSystemName
Into BC.PBBCMapping
From Staging.BottlerAccountTradeMarkBranch big
Join BC.Bottler b on big.BottlerID = b.BottlerID
Join BC.Region r on b.BCRegionID = r.RegionID
Join BC.Division d on r.DivisionID = d.DivisionID
Join BC.Zone z on d.ZoneID = z.ZoneID
Join BC.System s on s.SystemID = z.SystemID
Join MView.LocationHier br on br.BranchID = big.BranchID
Go

Select *
From BC.PBBCMapping
Go

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- 2 minutes for full loading ---
Truncate Table BC.BottlerChainTradeMark
Go

Insert Into BC.BottlerChainTradeMark
Select Distinct a.TerritoryTypeID, a.ProductTypeID, b.BottlerID, b.BCBottlerID, b.BottlerName, 
	t.TradeMarkID, t.SAPTradeMarkID, t.TradeMarkName, 
	l.LocalChainID, l.SAPLocalChainID, l.LocalChainName, 
	r.RegionalChainID, r.SAPRegionalChainID, r.RegionalChainName, 
	n.NationalChainID, n.SAPNationalChainID, n.NationalChainName 
From BC.BottlerAccountTradeMark a
Join SAP.LocalChain l on a.LocalChainID = l.LocalChainID
Join SAP.RegionalChain r on r.RegionalChainID = l.RegionalChainID
Join SAP.NationalChain n on r.NationalChainID = n.NationalChainID
Join BC.Bottler b on a.BottlerID = b.BottlerID
Join SAP.TradeMark t on a.TradeMarkID = t.TradeMarkID
Go

Select Distinct NationalChainName
From BC.GSNChain
--Where GSN = 'BERDX002' ----- Dana Berghorn, SVP Sales Cola System, eventually responsible for 960 bottlers, 113 National Chains
--Where GSN = 'SINSX003' ----- Stephen Singer, VP Sales CASO West, 362 bottlers, 108 National Chains
--Where GSN = 'BRIJX004' ----- Scott McDowell, Divisional Sales Manager Heartland, 77 Bottlers, 83 National Chains
Where GSN = 'BOEPX001' ----- Philip Boettcher, Regional Sales Manager AL, 13 Bottlers, 63 National Chains
Go

Select *
From BC.GSNRegion
--Where GSN = 'BERDX002' ----- Dana Berghorn, SVP Sales Cola System, eventually responsible for 960 bottlers, 113 National Chains
--Where GSN = 'SINSX003' ----- Stephen Singer, VP Sales CASO West, 362 bottlers, 108 National Chains
--Where GSN = 'BRIJX004' ----- Scott McDowell, Divisional Sales Manager Heartland, 77 Bottlers, 83 National Chains
Where GSN = 'BOEPX001' ----- Philip Boettcher, Regional Sales Manager AL, 13 Bottlers, 63 National Chains
Go

Create View BC.BCRegionChain
As
Select r.RegionID, r.RegionName, bct.LocalChainID, bct.LocalChainName, bct.RegionalChainID, bct.RegionalChainName, bct.NationalChainID, bct.NationalChainName
From BC.BottlerChainTradeMark bct
Join BC.Bottler b on bct.BottlerID = b.BottlerID
Join BC.Region r on b.BCRegionID = r.RegionID
Go

Select Distinct NationalChainName, RegionalChainName, LocalChainName
From BC.GSNChain
--Where bca.GSN = 'BERDX002' ----- Dana Berghorn, SVP Sales Cola System, eventually responsible for 960 bottlers, 113 National Chains
--Where bca.GSN = 'SINSX003' ----- Stephen Singer, VP Sales CASO West, 362 bottlers, 108 National Chains
----Where bca.GSN = 'BEASX004' ----- Sean Beacom, Dir Sales CASO, 35 Bottlers, but no national chains(Territory Map incomplete?) When you dig into the data, you will find that region 600002 RCDO - ONTARIO is probably not active, or assigned wrong 
--Where bca.GSN = 'BRIJX004' ----- Scott McDowell, Divisional Sales Manager Heartland, 77 Bottlers, 83 National Chains
Where GSN = 'BOEPX001' ----- Philip Boettcher, Regional Sales Manager AL, 13 Bottlers, 63 National Chains
Order By NationalChainName
Go

Alter View BC.GSNChain
As
Select Distinct bca.GSN, bca.FirstName, bca.LastName, bca.Title, bct.NationalChainID, bct.NationalChainName, bct.RegionalChainID, bct.RegionalChainName, bct.LocalChainID, bct.LocalChainName
From BC.BottlerChainTradeMark bct
Join BC.BCAccountability bca on bct.BottlerID = bca.BottlerID
Go

--Select *
--From BC.BottlerChainTradeMark 
--Where BottlerID
--In 
--(
--	Select BottlerID
--	From BC.BCAccountability 
--	Where GSN = 'MCDSX005'
--)

--Select *
--From Staging.BCTMap
--Where Convert(int, BTTLR_ID)
--In (
--	Select BCBottlerID
--	From BC.BCAccountability 
--	Where GSN = 'BEASX004')

--Select *
--From BC.GSNRegion
--Where RegionID = 544

--Select *
--From BC.Region
--Where RegionID = 544

--Select *
--From Staging.BCBottlerHierachy
--Where NODE_ID = '600002'




--Select *
--From BC.BCAccountability
--Where LastName = 'Boettcher'



--- This Cola SVP, eventually responsible for 960 bottlers
--Select *
--From BC.BCAccountability
--Where GSN = 'BERDX002'

---- VP Sales CASO West, 362 bottlers
--Select *
--From BC.BCAccountability
--Where GSN = 'SINSX003'

-----Dir Sales CASO, 35 Bottlers
--Select *
--From BC.BCAccountability
--Where GSN = 'BEASX004'

-----Regional Sales Manager AL, 13 Bottlers
--Select *
--From BC.BCAccountability
--Where GSN = 'BOEPX001'

--Select *
--From BC.BCAccountability
--Where BottlerID in 
--(
--	Select BottlerID
--	From BC.BCAccountability
--	Where GSN = 'BEASX004'
--)

--Select *
--From Person.BCSalesAccountability
--Where RegionID is not null

----------------~~~~~~~~~~~~~~~~~~~~~~~~~
----------------~~~~~~~~~~~~~~~~~~~~~~~~~
----------------~~~~~~~~~~~~~~~~~~~~~~~~~
----------------~~~~~~~~~~~~~~~~~~~~~~~~~
----------------~~~~~~~~~~~~~~~~~~~~~~~~~
----------------~~~~~~~~~~~~~~~~~~~~~~~~~
----------------~~~~~~~~~~~~~~~~~~~~~~~~~
Select *
From BC.GSNRegion
Where RegionID in 
(
Select RegionID
From BC.GSNRegion
Where GSN = 'SINSX003'
)
And GSN not in ('SINSX003', 'BERDX002')
----------------~~~~~~~~~~~~~~~~~~~~~~~~~
----------------~~~~~~~~~~~~~~~~~~~~~~~~~
----------------~~~~~~~~~~~~~~~~~~~~~~~~~
----------------~~~~~~~~~~~~~~~~~~~~~~~~~
----------------~~~~~~~~~~~~~~~~~~~~~~~~~
----------------~~~~~~~~~~~~~~~~~~~~~~~~~
----------------~~~~~~~~~~~~~~~~~~~~~~~~~

--Select *
--From BC.GSNRegion
--Where GSN = 'BOEPX001'


--Drop Table BC.BottlerChainTradeMark
--Go

----- 2 minutes for the full load --
--Select *
--Into BC.BottlerChainTradeMark
--From 
--(
--	Select Distinct map.TerritoryTypeID, map.ProductTypeID, 0 IsStoreInclusion, b.BottlerID, b.BCBottlerID, b.BottlerName, 
--		t.TradeMarkID, t.SAPTradeMarkID, t.TradeMarkName, 
--		l.LocalChainID, l.SAPLocalChainID, l.LocalChainName, 
--		r.RegionalChainID, r.SAPRegionalChainID, r.RegionalChainName, 
--		n.NationalChainID, n.SAPNationalChainID, n.NationalChainName 
--	From BC.TerritoryMap map
--	Join SAP.Account a on map.PostalCode = a.PostalCode and map.CountyID = a.CountyID
--	Join SAP.LocalChain l on a.LocalChainID = l.LocalChainID
--	Join SAP.RegionalChain r on r.RegionalChainID = l.RegionalChainID
--	Join SAP.NationalChain n on r.NationalChainID = n.NationalChainID
--	Join BC.Bottler b on map.BottlerID = b.BottlerID
--	Join SAP.TradeMark t on map.TradeMarkID = t.TradeMarkID
--	Where map.TerritoryTypeID = 12
--	And map.ProductTypeID = 1
--	And a.InCapstone = 1
--	And a.Active = 1
--	Union
--	Select Distinct inc.TerritoryTypeID, inc.ProductTypeID, 1 IsStoreInclusion, b.BottlerID, b.BCBottlerID, b.BottlerName, 
--		t.TradeMarkID, t.SAPTradeMarkID, t.TradeMarkName, 
--		l.LocalChainID, l.SAPLocalChainID, l.LocalChainName, 
--		r.RegionalChainID, r.SAPRegionalChainID, r.RegionalChainName, 
--		n.NationalChainID, n.SAPNationalChainID, n.NationalChainName 
--	From BC.AccountInclusion inc
--	Join SAP.Account a on inc.AccountID = a.AccountID
--	Join SAP.LocalChain l on a.LocalChainID = l.LocalChainID
--	Join SAP.RegionalChain r on r.RegionalChainID = l.RegionalChainID
--	Join SAP.NationalChain n on r.NationalChainID = n.NationalChainID
--	Join BC.Bottler b on inc.BottlerID = b.BottlerID
--	Join SAP.TradeMark t on inc.TradeMarkID = t.TradeMarkID
--	Where inc.TerritoryTypeID = 12
--	And inc.ProductTypeID = 1
--	And a.InCapstone = 1
--	And a.Active = 1) tm
--Go

--Select *
--From BC.BottlerChainTradeMark

--Select BCBottlerID, TradeMarkID, LocalChainID, Count(*) Cnt
--From BC.BottlerChainTradeMark
--Group By BCBottlerID, TradeMarkID, LocalChainID
--Having Count(*) > 1



