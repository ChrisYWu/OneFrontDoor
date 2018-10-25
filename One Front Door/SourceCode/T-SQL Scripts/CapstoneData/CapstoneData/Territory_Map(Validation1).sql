Use Portal_DataSRE
Go

Declare @GSN Varchar(12)
--Set @GSN = 'BERDX002' ----- Dana Berghorn, SVP Sales Cola System, eventually responsible for 960 bottlers, 113 National Chains
--Set @GSN = 'SINSX003' ----- Stephen Singer, VP Sales CASO West, 362 bottlers, 108 National Chains
--Set @GSN = 'BRIJX004' ----- Scott McDowell, Divisional Sales Manager Heartland, 77 Bottlers, 83 National Chains
Set @GSN = 'BOEPX001' ----- Philip Boettcher, Regional Sales Manager AL, 13 Bottlers, 63 National Chains

--Select Distinct NationalChainName, RegionalChainName, LocalChainName
--From BC.GSNChain
--Where GSN = @GSN

sELECT Distinct RegionName, b.BottlerName
fROM BC.GSNRegion g
Join BC.Bottler b on g.RegionID = b.BCRegionID
Join [BC].[BottlerChainTradeMark] bm on b.BottlerID = bm.BottlerID
Where GSN = @GSN

