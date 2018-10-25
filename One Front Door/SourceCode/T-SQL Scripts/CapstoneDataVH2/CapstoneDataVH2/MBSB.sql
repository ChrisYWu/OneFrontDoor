use Portal_Data
Go

SElect *
From Person.BCSalesAccountability
Where GSN = 'MONJX001'


Select *
From Person.UserProfile
Where LastName = 'Monge'

Select *
From BC.vBottlerSalesHier
Where REgionID = 84

Select TerritoryTypeID, Count(*)
From BC.Bottler b
Join BC.BottlerAccountTradeMark bat on b.BottlerID = bat.BottlerID
Where b.BCRegionID = 84
--And bat.TerritoryTypeID = 11
And bat.ProductTypeID = 1
Group By TerritoryTypeID 

Select *
From BC.BottlerAccountTradeMark
Where BottlerID = 7488
And TerritoryTypeID = 11
And ProductTypeID = 1

Select *
From BC.BottlerAccountTradeMark
where BranchID is not null


Where accountID = 976006














Select '*' + GSN + '*'
From Person.BCSalesAccountability
Order By GSN asc


Select *
From BC.Bottler
Where Latitude is null

Select *
From Bc.Region
Where RegionName = 'ISEA -  Seattle'


Select *
From Shared.ExceptionLog



Select *
From BC.vBCAccountability
Go

-- All Iso Bottlers
Create Proc BC.pGetSystems
As
Select Distinct v.SystemID, v.SystemName
From BC.vBottlerSalesHier v
--Join Person.BCSalesAccountability b on v.SystemID = b.SystemID
Where SystemName in ('BS - Paso System', 'RS - Caso System', 'IS - Iso System')
Go

exec BC.pGetSystems

--And RegionID = 84

Select u.GSN, u.FirstName, u.LastName, b.*
From Person.BCSalesAccountability b
Join Person.UserProfile u on b.GSN = u.GSN
Where b.RegionID = 84

-- Region 84 is picked
Select *
From BC.Bottler
Where BCRegionID = 84

Select *
From BC.BottlerAccountTradeMark bat

Where BottlerID in (7974, 7975, 9956)

Select Distinct BottlerID
From BC.BottlerAccountTradeMark
Where BottlerID in (7974, 7975, 9956)
And ProductTypeID = 1
And TerritoryTypeID = 12


Select *
From BC.Bottler b
Where BCRegionID = 84

Select *
From BC.TerritoryMap
Where BottlerID in (7486,
7487,
7490,
7972,
7973,
9954)

Select TerritoryTypeID, Count(*) Cnt
From BC.TerritoryMap
Group by TerritoryTypeID 
Go

SElect *
From BC.Bottler
Where BCRegionID = 87


exec BC.pGetAccountsByBottler @RegionID = 84, @TerritoryType = 0
Go

Alter Proc BC.pGetAccountsByBottler
(
	@RegionID int,
	@TerritoryType int 
)
AS

if (@TerritoryType > 0)
Begin
	Select a.SAPAccountNumber, a.AccountName, a.Address, a.City, a.State, a.PostalCode, Case When bat.TerritoryTypeID = 12 Then 'Servicing' Else 'Marketing' End TerritoryType, Count(*) TradeMarkCount
	From SAP.Account a
	Join BC.BottlerAccountTradeMark bat on a.AccountID = bat.AccountID
	Join BC.Bottler b on bat.BottlerID = b.BottlerID
	Where bat.ProductTypeID = 1
	And bat.TerritoryTypeID = @TerritoryType
	And b.BCRegionID = @RegionID
	Group By a.SAPAccountNumber, a.AccountName, a.Address, a.City, a.State, a.PostalCode, bat.TerritoryTypeID
	Order By a.AccountName, a.Address, a.City, a.State, a.PostalCode, bat.TerritoryTypeID
End
Else
Begin
	declare @RegionID int
	Set @RegionID = 82

	Select a.SAPAccountNumber, a.AccountName, a.Address, a.City, a.State, a.PostalCode, 'Marketing' TerritoryType, Count(*) TradeMarkCount
	From SAP.Account a
	Join BC.BottlerAccountTradeMark bat on a.AccountID = bat.AccountID
	Join BC.Bottler b on bat.BottlerID = b.BottlerID
	Where bat.ProductTypeID = 1
	And b.BCRegionID = @RegionID
	And bat.TerritoryTypeID = 11
	Group By a.SAPAccountNumber, a.AccountName, a.Address, a.City, a.State, a.PostalCode, bat.TerritoryTypeID
	Order By a.AccountName, a.Address, a.City, a.State, a.PostalCode, bat.TerritoryTypeID
End
Go



--Select Distinct c.SystemID, c.SystemName, 
--c.ZoneID, c.ZoneName, c.DivisionID, c.DivisionName, 
--br.BottlerID ReportingBttlrID, br.BottlerName ReportingBttlr, t.SAPTradeMarkID, t.TradeMarkID, t.TradeMarkName, 
--bs.BottlerID ServicingBttlrID, bs.BottlerName ServicingBttlr
--Into BC.tBottlerMapping
--From 
--(Select ServicingBottler.CountyID, ServicingBottler.PostalCode, ServicingBottler.TradeMarkID, RptgBottlerID, SvcgBottlerID
--From 
--       (Select CountyID, PostalCode, BottlerID SvcgBottlerID, TradeMarkID 
--       From BC.TerritoryMap
--       Where TerritoryTypeID = 12
--       And ProductTypeID = 1) ServicingBottler
--Join
--       (Select CountyID, PostalCode, BottlerID RptgBottlerID, TradeMarkID 
--       From BC.TerritoryMap
--       Where TerritoryTypeID = 11
--       And ProductTypeID = 1) ReportingBottler 
--on ServicingBottler.CountyID = ReportingBottler.CountyID 
--       And ServicingBottler.PostalCode = ReportingBottler.PostalCode
--       And ServicingBottler.TradeMarkID = ReportingBottler.TradeMarkID
--Where SvcgBottlerID <> RptgBottlerID) Diff
--Join BC.Bottler b on b.BottlerID = diff.RptgBottlerID
--Join BC.vBottlerSalesHier c on c.RegionID = b.BCRegionID
--Join SAP.TradeMark t on t.TradeMarkID = diff.TradeMarkID
--Join BC.Bottler bs on bs.BottlerID = diff.SvcgBottlerID
--Join BC.Bottler br on br.BottlerID = diff.RptgBottlerID

Select *
From Person.BCSalesAccountability

--- All the regions that can hit some reporting bottler data
Select Distinct r.RegionID, r.RegionName
From BC.Bottler b
Join BC.BottlerAccountTradeMark bat on b.BottlerID = bat.BottlerID
Join BC.Region r on r.RegionID = b.BCRegionID
Where bat.TerritoryTypeID = 11 -- Reporting Bottler
And bat.ProductTypeID = 1

---
Select top 100 BottlerID, bat.TradeMarkID, t.TradeMarkName + '(' + t.SAPTradeMarkID + ')' TradeMark, a.AccountID, a.AccountName, a.Latitude, a.Longitude
From BC.BottlerAccountTradeMark bat
Join SAP.Account a on bat.AccountID = a.AccountID
Join SAP.TradeMark t on bat.TradeMarkID = t.TradeMarkID
Where bat.TerritoryTypeID = 11 -- Reporting Bottler
And bat.ProductTypeID = 1

--------------- 
--************* 2 mints to do the calculation
Truncate Table BC.tReportingBottlerPopulation

Insert Into BC.tReportingBottlerPopulation
Select BottlerID, bat.TradeMarkID, Max(a.AccountID), a.Latitude, a.Longitude
From BC.BottlerAccountTradeMark bat
Join SAP.Account a on bat.AccountID = a.AccountID
Join SAP.TradeMark t on bat.TradeMarkID = t.TradeMarkID
Where bat.TerritoryTypeID = 11 -- Reporting Bottler
And bat.ProductTypeID = 1
And isnull(Latitude, 0) <> 0
Group By BottlerID, bat.TradeMarkID, a.Latitude, a.Longitude
Go
--*************

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


