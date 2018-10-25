use Portal_Data_INT
Go

Select *
From BC.Bottler

Update b
Set b.GeoCodingNeeded = rb.GeoCodingNeeded,
b.Latitude = rb.Latitude,
b.Longitude = rb.Longitude
From BC.Bottler b
Join BSCCAP108.Portal_Data.BC.Bottler rb on b.BCBottlerID = rb.BCBottlerID
Where rb.GeoCodingNeeded = 0

Select b.Latitude, b.Longitude, b.GeoSource, rb.GeoSource, rb.Latitude, rb.Longitude, rb.GeoCodingNeeded
From SAP.Account b
Join BSCCAP108.Portal_Data.SAP.Account rb on b.SAPAccountNumber = rb.SAPAccountNumber
Where rb.GeoSource = 'G'
And isnull(b.Latitude, 0.0) = 0


Update b
Set b.GeoCodingNeeded = rb.GeoCodingNeeded,
b.Latitude = rb.Latitude,
b.Longitude = rb.Longitude,
b.GeoSource = rb.GeoSource
From SAP.Account b
Join BSCCAP108.Portal_Data.SAP.Account rb on b.SAPAccountNumber = rb.SAPAccountNumber
Where rb.GeoSource = 'G'
And isnull(b.Latitude, 0.0) = 0
