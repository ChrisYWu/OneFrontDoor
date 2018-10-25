use Portal_DAta
Go

Select top 10 LastModified, *
From Shared.ExceptionLog
Where AppliationID = 3000
Order By ExceptionLogID desc

Select Count(*)
From SAP.Account
Where GeoSource = 'G'

Select Latitude, Longitude, AccountName, GeoSource
From SAP.Account
--Where GeoSource = 'G'
Where Latitude = 0
And Longitude = 0

