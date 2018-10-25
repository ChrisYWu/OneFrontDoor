use Portal_DataVH2
Go

Drop Table BC.tReportingBottlerPopulation
Go

--------------- 
--************* 2 mints to do the calculation
Truncate Table BC.tReportingBottlerPopulation

Insert Into BC.tReportingBottlerPopulation
Select TerritoryTypeID, BottlerID, bat.TradeMarkID, Max(bat.AccountID) AccountID--, a.Latitude, a.Longitude
From BC.BottlerAccountTradeMark bat
Where bat.TerritoryTypeID = 11 -- Reporting Bottler
And bat.ProductTypeID = 1
And isnull(Latitude, 0) <> 0
Group By TerritoryTypeID, BottlerID, bat.TradeMarkID--, a.Latitude, a.Longitude
Having Count(*) > 1
Go

Drop Table BC.tBottlerAccountLocation
Go

-- MapLarge Geo is a concern ---
Select TerritoryTypeID, BottlerID, TradeMarkID, Max(a.AccountID) AccountID, a.Latitude, a.Longitude, Count(*) AccountCount
Into BC.tBottlerAccountLocation
From BC.BottlerAccountTradeMark bat
Join SAP.Account a on bat.AccountID = a.AccountID
Where ProductTypeID = 1
And isnull(Latitude, 0) <> 0
--And TradeMarkID in (Select TradeMarkID From SAP.TradeMark Where TradeMarkName in ('7UP', 'A&W', 'Dr Pepper', 'Canada Dry', 'Crush', 'Clamato', 'Yoo-Hoo', 'Sun Drop', 'Snapple'))
Group by TerritoryTypeID, BottlerID, TradeMarkID, a.Latitude, a.Longitude
Go

Select *
From BC.tBottlerAccountLocation
Where AccountCount > 1


Select *
From SAP.Account
Where Latitude = 41.106215	And Longitude = -85.115959

Select SAPAccountNumber
From Staging.MapLargeGeo
Where MatchType = 'ExactMatch'
And NumMatch <> 'Exact'


Update a
Set GeoSource = null,
Latitude = null,
Longitude = null,
GeoCodingNeeded = 1
From Staging.MapLargeGeo ml
Join SAP.Account a on ml.SAPAccountNumber = a.SAPAccountNumber
Where (MatchType <> 'ExactMatch' Or NumMatch <> 'Exact')
And a.GeoSource = 'ML'
Go

--Approx
--Where SAPAccountNumber in (12236344
--,12168794
--,12084481
--,12146583
--,12080972
--,12086987
--,12250687
--,12211783)
Go

Alter View BC.vBottlerTerritoryMapHeader
As
Select Distinct t.TerritoryTypeID, t.BottlerID, t.TradeMarkID
From Bc.tBottlerAccountLocation t
left Join BC.tBottlerTerritoryMap m on t.BottlerID = m.BottlerID
									And t.TerritoryTypeID = m.TerritoryTypeID 
									And t.TradeMarkID = m.TradeMarkID
Where m.BottlerID is null
Go

Select t.TerritoryTypeID, t.BottlerID, t.TradeMarkID, count(*)
From Bc.tBottlerTerritoryMap t
Group By t.TerritoryTypeID, t.BottlerID, t.TradeMarkID

Select *
From BC.tBottlerAccountLocation
Where BottlerID = 6336
And TradeMarkID = 254

Select *
From SAP.TradeMark
Where TradeMarkID = 129

Select BottlerName, 'new google.maps.LatLng(' + convert(varchar(12), b.Latitude) + ',' + convert(varchar(12), b.Longitude) +')' bsJs , 
'			new google.maps.LatLng(' + convert(varchar(12), bat.Latitude) + ',' + convert(varchar(12), bat.Longitude) +'),' jsCode
From BC.tBottlerTerritoryMap bat
Join BC.Bottler b on bat.BottlerID = b.BottlerID
Where TerritoryTypeID = 12
--And BottlerID = 476
And TradeMarkID = 69

Select *
From BC.tBottlerTerritoryMap

Select *
From BC.Bottler
Where BottlerID = 476

Select *
From SAP.TradeMark
Where TradeMarkID = 69



--truncate table BC.tBottlerTerritoryMap




--*************

Select Count(*)
From SAP.Account
Where isnull(Latitude, 0) <> 0
And InCapstone = 1

Select GeoSource, Count(*) Cnt
From SAP.Account
Where InCapstone = 1
Group By GeoSource 

--Select *
--From BSCCAP121.Portal_Data.SAP.Account
--Where GeoSource = 'G'

Select *
From BSCCAP121.Portal_Data.Shared.ExceptionLog
Where AppliationID = 3000

Select *
From BC.tReportingBottlerPopulation


--------------- 
--************* 2 mints to do the calculation
If Exists (Select * From sys.views Where OBJECT_ID = OBJECT_ID('BC.vReportingBottlerTradeMark'))
Begin
	Drop View BC.vReportingBottlerTradeMark
End
Go

Create View BC.vReportingBottlerTradeMark
As
Select Distinct BottlerID, TradeMarkID
From BC.tReportingBottlerPopulation
Go


Select *
From BC.vReportingBottlerTradeMark
--*************

SElect *
From BC.tReportingMap

Select *
From BC.tReportingBottlerPopulation
Where BottlerID = 11
And TradeMarkID = 192

Truncate Table BC.tReportingMap

SElect b.BottlerName, t.TradeMarkName, m.*
From BC.tReportingMap m
Join BC.Bottler b on m.bottlerID = b.BottlerID
Join SAP.TradeMark t on m.TradeMarkID = t.TradeMarkID

Select a.AccountID, a.SAPAccountNumber, a.AccountName, a.Address, a.City, a.State, m.PLatitude, m.PLongitude, a.GeoSource
From BC.tReportingMap m
Join SAP.Account a on m.PAccountID = a.AccountID
Where TradeMarkID = 192

Select *
From SAP.Account
Where AccountID = 926801


