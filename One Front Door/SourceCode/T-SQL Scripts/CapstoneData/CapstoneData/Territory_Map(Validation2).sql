Use Portal_DataSRE
Go

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Declare @GSN Varchar(12)
--Set @GSN = 'BERDX002' ----- Dana Berghorn, SVP Sales Cola System, 49 Regions
--Set @GSN = 'SINSX003' ----- Stephen Singer, VP Sales CASO West, 362 bottlers, 19 Region
Set @GSN = 'BRIJX004' ----- Scott McDowell, Divisional Sales Manager Heartland, 6 Regions
Set @GSN = 'BOEPX001' ----- Philip Boettcher, Regional Sales Manager AL, 1 Region

Select RegionName
From BC.GSNRegion
Where GSN = @GSN
Go
