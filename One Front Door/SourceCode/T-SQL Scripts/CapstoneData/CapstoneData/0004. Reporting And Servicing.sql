use Portal_DataSRE
Go

Select Top 1 BottlerID, TradeMarkID, AccountID
From BC.BottlerAccountTradeMark
Where TerritoryTypeID = 11
And ProductTypeID = 1

Select Top 100 BottlerID, TradeMarkID, AccountID
From BC.BottlerAccountTradeMark
Where TerritoryTypeID = 12
And ProductTypeID = 1


CREATE NONCLUSTERED INDEX NCI_TerritoryMap_ProductTypeID_TerritoryTypeID
ON [BC].[TerritoryMap] ([ProductTypeID],[TerritoryTypeID])
INCLUDE ([TradeMarkID],[CountyID],[PostalCode],[BottlerID])

Select sr.RegionName State, c.CountyName County, diff.PostalCode, t.SAPTradeMarkID, br.BottlerName ReportingBttlr, bs.BottlerName ServicingBttlr
From 
(Select ServicingBottler.CountyID, ServicingBottler.PostalCode, ServicingBottler.TradeMarkID, RptgBottlerID, SvcgBottlerID
From 
	(Select CountyID, PostalCode, BottlerID SvcgBottlerID, TradeMarkID 
	From BC.TerritoryMap
	Where TerritoryTypeID = 12
	And ProductTypeID = 1) ServicingBottler
Join
	(Select CountyID, PostalCode, BottlerID RptgBottlerID, TradeMarkID 
	From BC.TerritoryMap
	Where TerritoryTypeID = 11
	And ProductTypeID = 1) ReportingBottler 
on ServicingBottler.CountyID = ReportingBottler.CountyID 
	And ServicingBottler.PostalCode = ReportingBottler.PostalCode
	And ServicingBottler.TradeMarkID = ReportingBottler.TradeMarkID
Where SvcgBottlerID <> RptgBottlerID) Diff
Join Shared.County c on c.CountyID = diff.CountyID
Join Shared.StateRegion sr on sr.StateRegionID = c.StateRegionID
Join SAP.TradeMark t on t.TradeMarkID = diff.TradeMarkID
Join BC.Bottler bs on bs.BottlerID = diff.SvcgBottlerID
Join BC.Bottler br on br.BottlerID = diff.RptgBottlerID
Join BC.Region r on br.BCRegionID = r.RegionID
Join BC.vSalesHierarchy h on r.RegionID = h.RegionID
Where h.SystemName in ('IS - Iso System', 'RS - Caso System', 'BS - Paso System')

Select Count(*)
From Bc.AccountInclusion
Go

DECLARE @datetime2 datetime2(4)
Go

Declare @StartTime datetime2 
Set @StartTime  = SYSDATETIME()

Select Distinct RptgBottlerID, SvcgBottlerID
From BC.tBottlerMapping
Where RptgBottlerID = 15136

Select DateDiff(MICROSECOND, @StartTime, SYSDATETIME()) QueryTime_In_Millisecond_From_SDM
Go

--------------
Select Distinct diff.TradeMarkID, RptgBottlerID, br.BCBottlerID BCReportingBottlerID, br.BottlerName ReportingBttlr, SvcgBottlerID, bs.BCBottlerID BCServicingBottlerID, bs.BottlerName ServicingBttlr
--Into BC.tBottlerMapping
From 
(		
		Select ServicingBottler.TradeMarkID, ServicingBottler.CountyID, ServicingBottler.PostalCode, ServicingBottler.TradeMarkID, RptgBottlerID, SvcgBottlerID
		From 
		(Select CountyID, PostalCode, BottlerID SvcgBottlerID, TradeMarkID 
		From BC.TerritoryMap
		Where TerritoryTypeID = 12
		And ProductTypeID = 1) ServicingBottler
		Join
		(Select CountyID, PostalCode, BottlerID RptgBottlerID, TradeMarkID 
		From BC.TerritoryMap
		Where TerritoryTypeID = 11
		And ProductTypeID = 1) ReportingBottler 
		on ServicingBottler.CountyID = ReportingBottler.CountyID 
			And ServicingBottler.PostalCode = ReportingBottler.PostalCode
			And ServicingBottler.TradeMarkID = ReportingBottler.TradeMarkID
		Where SvcgBottlerID <> RptgBottlerID) Diff
Join Shared.County c on c.CountyID = diff.CountyID
Join Shared.StateRegion sr on sr.StateRegionID = c.StateRegionID
Join SAP.TradeMark t on t.TradeMarkID = diff.TradeMarkID
Join BC.Bottler bs on bs.BottlerID = diff.SvcgBottlerID
Join BC.Bottler br on br.BottlerID = diff.RptgBottlerID
Order By br.BottlerName, bs.BottlerName
--------------

		Insert Into BC.tBottlerMapping
		Select ServicingBottler.TradeMarkID, ServicingBottler.CountyID, ServicingBottler.PostalCode, RptgBottlerID, SvcgBottlerID
		From 
		(Select CountyID, PostalCode, BottlerID SvcgBottlerID, TradeMarkID 
		From BC.TerritoryMap
		Where TerritoryTypeID = 12
		And ProductTypeID = 1) ServicingBottler
		Join
		(Select CountyID, PostalCode, BottlerID RptgBottlerID, TradeMarkID 
		From BC.TerritoryMap
		Where TerritoryTypeID = 11
		And ProductTypeID = 1) ReportingBottler 
		on ServicingBottler.CountyID = ReportingBottler.CountyID 
			And ServicingBottler.PostalCode = ReportingBottler.PostalCode
			And ServicingBottler.TradeMarkID = ReportingBottler.TradeMarkID
		Where SvcgBottlerID <> RptgBottlerID

Select *
From BC.tBottlerMapping


Select *
From BC.System


Select Count(*)
From BC.TerritoryMap
Where TerritoryTypeID = 12

Select Count(*)
From BC.TerritoryMap tm
Join BC.Bottler b on tm.BottlerID = b.BottlerID
Join BC.Region r on b.BCRegionID = r.RegionID
Join BC.vSalesHierarchy h on r.RegionID = h.RegionID
Where TerritoryTypeID = 11
And h.SystemName in ('IS - Iso System', 'RS - Caso System', 'BS - Paso System')
