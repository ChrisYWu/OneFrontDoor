use Portal_DataVH2
Go

Select *
From Shared.ExceptionLog
Go

Select *
From BC.Bottler
Where Latitude = 0
And GeoCodingNeeded = 1
Go

--Update a
--Set GeoSource = null,
--Latitude = null,
--Longitude = null,
--GeoCodingNeeded = 1
--From Staging.MapLargeGeo ml
--Join SAP.Account a on ml.SAPAccountNumber = a.SAPAccountNumber
--Where MatchType <> 'ExactMatch'
--And a.GeoSource = 'ML'
--Go

