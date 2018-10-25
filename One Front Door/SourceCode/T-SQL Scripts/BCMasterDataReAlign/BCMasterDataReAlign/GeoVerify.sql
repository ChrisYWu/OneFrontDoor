Use Portal_DAta
Go

--Select c.SAPLocalChainID, a.CapstoneLastModified, a.StoreLastModified, a.*
--From SAP.Account a
--Join SAP.LocalChain c on a.LocalChainID = c.LocalChainID 
--Where SAPAccountNumber = 11275399

--Select Latitude, Longitude, Latitude1, Longitude1, GeoSource, InCapstone, a.CapstoneLastModified, a.StoreLastModified,  a.*
--From SAP.Account a
----Where InCapstone = 1
--Where SAPAccountNumber in (12057658, 122249478, 12136797, 12256043, 12083396, 12047263, 12225358)

Select SAPAccountNumber, Latitude, Longitude, GeoSource, CapstoneLastModified, StoreLastModified
From SAP.Account
Where InCapstone = 1
Order By StoreLastModified Desc

Select StoreLastModified, Count(*)
From SAP.Account
Group By StoreLastModified
Order By StoreLastModified desc

