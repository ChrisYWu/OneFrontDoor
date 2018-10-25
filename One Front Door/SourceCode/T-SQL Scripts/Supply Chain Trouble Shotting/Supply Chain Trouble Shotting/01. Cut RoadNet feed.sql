use Portal_Data
Go

Select Left(1, SAPAccountNumber) AccountFirstLetter, SAPAccountNumber, AccountName, Latitude, Longitude, a.Active ActiveInRouteManager, ro.RouteName, rt.RouteTypeName, isnull(GeoSource, 'RN') GeoSource
From SAP.Account a
Left Join SAP.RouteSchedule r on a.AccountID = r.AccountID
Left Join SAP.Route ro on r.RouteID = ro.RouteID
Left Join SAP.RouteType rt on rt.RouteTypeID = ro.RouteTypeID
Where isnull(InCapstone, 0) = 0
And isnull(Latitude, 0) <> 0

Select *
From SAP.Route
