Use Portal_DataSRE
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

Select *
From BC.BCRegionChain
Where RegionName = 'BBOS - Boston'

