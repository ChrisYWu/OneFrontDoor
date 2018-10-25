Use Portal_DataSRE
Go

Select Address, State, PostalCode, Latitude, Longitude, GeoSource, InCapstone, GeoCodingNeeded
From SAp.Account
Where Latitude = 0 and Longitude = 0
Go

Update SAP.Account
Set GeoCodingNeeded = 1
Where Latitude = 0 and Longitude = 0 And GeoSource = 'RN'
Go

Update SAP.Account
Set GeoCodingNeeded = 1
Where InCapstone = 1 And GeoSource <> 'RN'
Go




Use Portal_DataSRE
Go

Select InCapstone, SAPAccountNumber, Address, City, State, IsNull(PostalCode, TMPostalCode) PostalCode, Longitude, Latitude
From SAP.Account
Where GeoCodingNeeded = 1
Go

Select Count(*)
From Portal_data.SAP.Account
Where Active = 1


Update SAP.Account
Set GeoCodingNeeded = 0
Where GeoCodingNeeded is null
Go

Update SAP.Account
Set GeoCodingNeeded = 1
From SAP.Account
Where GeoSource = 'RN'
And InCapstone = 1
And SAPAccountNumber < 11200000
Go

Select *
From SAP.Account
Where GeoSource = 'RN'
And InCapstone = 1
And SAPAccountNumber < 11200000
Go

Select SAPAccountNumber, Latitude, Longitude
From SAP.Account
Where GeoSource = 'Cap'




------------------------
/*
1. Scope 
	a. Capstone Stores(including Bttlrs)
		i. If Goe is available from RoadNet, do we override it?
		(There are bad ones we can filter out(1,234 address that has 0,0), we can take are of those ones.

	b. Everything in Account Table(1.3 Mil records or so)

2. Approach
	a. Batch - Marlarge
	b. Differential - Google Geo Serivce and automated process that ties to DB differential updates.

3. Time
*/

Select *
From SAP.Account
