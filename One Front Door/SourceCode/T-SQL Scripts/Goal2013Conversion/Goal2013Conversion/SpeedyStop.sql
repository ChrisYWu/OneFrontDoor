use Portal_DataVH2
Go

Select GeoSource, AccountName, SAPAccountNumber, AccountID, Latitude, Longitude, Address, City, State, PostalCode
From SAP.Account
Where AccountName in ('Speedy Stop 000118', 'Walmart Sc 005189', 'Fry''s Food 000610')

Select *
From Staging.RNLocation
Where AccountNumber = '12238241'

Select * From  OPENQUERY(RN, 'Select ID AS AccountNumber, LONGITUDE/1000000.0 LONGITUDE, LATITUDE/1000000.0 LATITUDE From TSDBA.TS_LOCATION' )

Select * From  OPENQUERY(RN, 'Select * From TSDBA.TS_LOCATION Where ID = ''12238241''' )

Select * From  OPENQUERY(RN, 'Select REGION_ID, ID, ADDR_LINE1, REGION1, REGION3, POSTAL_CODE, LONGITUDE, LATITUDE From TSDBA.TS_LOCATION Where ID = ''12238241''' )

