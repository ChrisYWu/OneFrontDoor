use Portal_DataSRE
Go

Select *
From ETL.BCDataLoadingLog

Select *
From Person.UserProfile
Where LastName = 'McIntyre '

Select BCBottlerID, BottlerName, Convert(varchar(100), 'Reporting') As Note
into #temp
From BC.vBCAccountability
Where GSN = 'MCIMX001'

Select BCServicingBottlerID, ServicingBttlr, 'Servicing' As Note
into #temp2
From Bc.tBottlerMapping
Where RptgBottlerID
In(
Select BottlerID
From BC.vBCAccountability
Where GSN = 'MCIMX001'
)

Delete t2
From #temp t1
Join #temp2  t2 on t1.BCBottlerID = t2.BCServicingBottlerID 

Select *
From #temp
Union
Select *
From #temp2
Order By BottlerName




-----------------
Select BCBottlerID, BottlerName, 'Reporting' As Note
From BC.vBCAccountability
Where GSN = 'MCIMX001'
Union
Select BCServicingBottlerID, ServicingBttlr, 'Servicing' As Note
From Bc.tBottlerMapping
Where RptgBottlerID
In(
Select BottlerID
From BC.vBCAccountability
Where GSN = 'MCIMX001'
)
Order By BCBottlerID, BottlerName 


SElect *
From Bc.tBottlerMapping


Select *
From BC.v

Select *
From Person.BCSalesAccountability
Where GSN = 'MCIMX001'


Select *
From BC.vBCAccountability
Where GSN = 'MCIMX001'
Order by BottlerName


Select *
From ETL.BCDataLoadingLog


Select Distinct a.SAPAccountNumber, a.AccountName, a.Address, a.State, a.PostalCode
From BC.vBCAccountability ba
Join BC.BottlerAccountTradeMark bat on ba.BottlerID = bat.BottlerID
Join SAP.TradeMark t on bat.TradeMarkID = t.TradeMarkID
Join SAP.Account a on bat.AccountID = a.AccountID
Where GSN = 'METHX002'
And TerritoryTypeID = 12
And ProductTypeID = 1
Order By State, AccountName

Select Distinct SAPLocalChainID, LocalChainName, SAPRegionalChainID, RegionalChainName, SAPNationalChainID, NationalChainName 
From BC.vBCAccountability ba
Join BC.tBottlerChainTradeMark bct on ba.BottlerID = bct.BottlerID
Where GSN = 'METHX002'
And TerritoryTypeID = 12
And ProductTypeID = 1
Order By NationalChainName, RegionalChainName, LocalChainName


Select Distinct SAPRegionalChainID, RegionalChainName, SAPNationalChainID, NationalChainName 
From BC.vBCAccountability ba
Join BC.tBottlerChainTradeMark bct on ba.BottlerID = bct.BottlerID
Where GSN = 'MCIMX001'
And TerritoryTypeID = 12
And ProductTypeID = 1
Order By NationalChainName, RegionalChainName

Select Distinct SAPNationalChainID, NationalChainName 
From BC.vBCAccountability ba
Join BC.tBottlerChainTradeMark bct on ba.BottlerID = bct.BottlerID
Where GSN = 'MCIMX001'
And TerritoryTypeID = 12
And ProductTypeID = 1
Order By NationalChainName



Select distinct t.SAPTradeMarkID, t.TradeMarkName, a.SAPAccountNumber, a.AccountName, a.Address, a.State, a.PostalCode
From BC.vBCAccountability ba
Join BC.BottlerAccountTradeMark bat on ba.BottlerID = bat.BottlerID
Join SAP.TradeMark t on bat.TradeMarkID = t.TradeMarkID
Join SAP.Account a on bat.AccountID = a.AccountID
Where GSN = 'METHX002'
And TerritoryTypeID = 11
And ProductTypeID = 1
Order By SAPTradeMarkID, AccountName


Select *
From BC.vSalesHierarchy
Where RegionID = 608

Select *
From BC.Division
Where DivisionID = 222

Select *
From BC.Zone 
Where ZoneID = 104

Select *
From BC.System
Where SystemID = 46



Select *
From Person.BCSalesAccountability
Where RegionID = 600

Select *
From BC.Bottler
Where BottlerID in (29404
,29240
,29539
,26225)


Where BCBottlerID = 21912844

Select *
From BC.Region
Where BC

Select *
From BC.Bottler
Where BottlerName like 'ODOM%'

Select *
From 
(
	Select BottlerID, Count(*) Cnt
	From
	(
	SElect Distinct BottlerID, AccountID
	From Bc.BottlerAccountTradeMark
	Where TerritoryTypeID = 11 and ProductTypeID = 1
	) t
	Group By BottlerID
	Order By Count(*) desc
) 

Select Distinct AccountID
From Bc.BottlerAccountTradeMark
Where BottlerID = 19991
And TerritoryTypeID = 11

Select Distinct AccountID
From BC.BottlerAccountTradeMark bac
Where TerritoryTypeID = 12
And BottlerID in (
	Select BottlerID
	From BC.Bottler
	Where BCRegionID = 626)
And AccountID  in (
Select Distinct AccountID
From BC.BottlerAccountTradeMark bac
Where TerritoryTypeID = 10
And BottlerID in (
	Select BottlerID
	From BC.Bottler
	Where BCRegionID = 626)
	)

Select Distinct NationalChainName
From BC.tBottlerChainTradeMark
Where BottlerID in (
	Select BottlerID
	From BC.Bottler
	Where BCRegionID = 626)
And TerritoryTypeID = 12

And NationalChainName in
(
	Select Distinct NationalChainName
	From BC.tBottlerChainTradeMark
	Where BottlerID in (
		Select BottlerID
		From BC.Bottler
		Where BCRegionID = 626)
	And TerritoryTypeID = 10
)

-----------------------------------
-----------------------------------
Select lic.TradeMarkID, lic.AccountID, lic.BottlerID LicensingBttlrID, svc.BottlerID ServicingBttlrID
From 
(
Select BottlerID, TradeMarkID, AccountID
From BC.BottlerAccountTradeMark bac
Where TerritoryTypeID = 10) lic
Join 
(Select BottlerID, TradeMarkID, AccountID
From BC.BottlerAccountTradeMark
Where TerritoryTypeID = 12) svc on lic.AccountID = svc.AccountID and lic.TradeMarkID = svc.TradeMarkID
Go

-----------------------------------
-----------------------------------
Select comparison.TradeMarkID, comparison.AccountID, comparison.LicensingBttlrID, vl.RegionID, upsl.GSN, upsl.FirstName, upsl.LastName,
 comparison.ServicingBttlrID, vs.RegionID, upss.GSN, upss.FirstName, upss.LastName
From 
(
	Select lic.TradeMarkID, lic.AccountID, lic.BottlerID LicensingBttlrID, svc.BottlerID ServicingBttlrID
	From 
	(
	Select BottlerID, TradeMarkID, AccountID
	From BC.BottlerAccountTradeMark bac
	Where TerritoryTypeID = 10) lic
	Join 
	(Select BottlerID, TradeMarkID, AccountID
	From BC.BottlerAccountTradeMark
	Where TerritoryTypeID = 12) svc on lic.AccountID = svc.AccountID and lic.TradeMarkID = svc.TradeMarkID
) comparison
Left Join BC.vCPIBottler vl on comparison.LicensingBttlrID = vl.BottlerID 
Left Join Person.BCSalesAccountability al on vl.RegionID = al.RegionID
Left Join Person.UserProfile upsl on upsl.GSN = al.GSN
Left Join BC.vCPIBottler vs on comparison.ServicingBttlrID = vs.BottlerID 
Left Join Person.BCSalesAccountability asvc on asvc.RegionID = asvc.RegionID
Left Join Person.UserProfile upss on upss.GSN = asvc.GSN
Order By comparison.TradeMarkID, comparison.AccountID, comparison.LicensingBttlrID, comparison.ServicingBttlrID

-----------------------------------
-----------------------------------
Select Distinct a.GSN, up.FirstName, up.LastName, a.RegionID
From Person.BCSalesAccountability a
Join BC.vCPIBottler cpi on cpi.RegionID = a.RegionID
Join Person.UserProfile up on up.GSN = a.GSN

Select *
From BC.vCPIBottler

Select *
From BC.Bottler

Select *
From etl.BCDataLoadingLog

Select ProductTypeID, Count(*)
From BC.BottlerAccountTradeMark
Group by ProductTypeID

Select *
From BC.TerritoryType

Select TerritoryTypeID, Count(*)
From BC.TerritoryMap
Group By TerritoryTypeID 


--Select 
--t.SAPTradeMarkID TRADEMARK_ID, 
--bat.ProductTypeID PROD_TYPE, 
--bat.TerritoryTypeID TERR_VIEW, 
--b.BCBottlerID BTTLR_ID, 
--a.SAPAccountNumber STR_ID
--From BC.BottlerAccountTradeMark bat
--Join BC.Bottler b on bat.BottlerID = b.BottlerID
--Join SAP.TradeMark t on bat.TradeMarkID = t.TradeMarkID
--Join SAP.Account a on bat.AccountID = a.AccountID


----------------------------------
--Declare @StartTime DateTime
--Set @StartTime  = GetDate()

--Select *
--From BC.tBottlerChainTradeMark
--Where BottlerID = 14872 

--Select DateDiff(millisecond, @StartTime, GetDate()) QueryTime_In_Millisecond_From_SDM
--Go
----------------------------------
