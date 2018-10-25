use Portal_Data
Go

Select Count(*)
From SAP.Account
Where GeoSource = 'G'
Go

Select SAPAccountNumber, AccountName, Address, City, State, PostalCode, Latitude, Longitude
From SAP.Account
Where GeoSource = 'G'
And InCapstone = 1
And Latitude = 0
Go

Select Count(*)
From SAP.Account
Where GeoCodingNeeded = 1


