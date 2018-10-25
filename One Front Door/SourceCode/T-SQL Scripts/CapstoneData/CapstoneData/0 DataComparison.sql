use Portal_Data_SREINT
Go

select *
from ETL.BCDataLoadingLog


Select bct.*
From BC.tBottlerChainTradeMark bct
Join BC.Bottler b on b.BottlerID = bct.BottlerID
Where b.BottlerName in ('Columbia Of Wenatchee', 'Columbia Distr Kennewick')
And TerritoryTypeID = 12
----- The mapping and intersect idea need to be there -----


Select * From dbo.BCHierJoin
Where SYSTEM_DESC in ('PB - Packaged Beverages', 'IS - Iso System', 'BS - Paso System')

Select Distinct v.RegionID, 
v.RegionName REGION_DESC, 
'00' + Convert(varchar, b.BCBottlerID) BTTLR_ID, 
t.SAPTradeMarkID TRADEMARK_ID
From BC.Bottler b
Join BC.vSalesHierarchy v on b.BCRegionID = v.RegionID
Join BC.BottlerAccountTradeMark bat on b.BottlerID = bat.BottlerID And bat.TerritoryTypeID = 12
Join SAP.TradeMark t on t.TradeMarkID = bat.TradeMarkID
Where BCRegionID is not null
And SystemName in ('PB - Packaged Beverages', 'IS - Iso System', 'BS - Paso System')
And b.Active = 1

SElect *
From Person.BCSalesAccountability

Select RegionName REGION_DESC, LastName RSM_LAST_NM, FirstName RSM_FIRST_NM 
From BC.vSalesHierarchy v
Join Person.BCSalesAccountability b on v.RegionID = b.RegionID
Join Person.UserProfile up on b.GSN = up.GSN

Select RegionName REGION_DESC, LastName DSM_LAST_NM, FirstName DSM_FIRST_NM 
From BC.vSalesHierarchy v
Join Person.BCSalesAccountability b on v.DivisionID = b.DivisionID
Join Person.UserProfile up on b.GSN = up.GSN

Select Distinct s.SystemName SYSTEM_DESC, 
s.RegionName REGION_DESC, 
'00' + Convert(varchar, b.BCBottlerID) BTTLR_ID, 
t.SAPTradeMarkID TRADEMARK_ID,
up1.LastName RSM_LAST_NM, up1.FirstName RSM_FIRST_NM, 
up2.LastName DSM_LAST_NM, up2.FirstName DSM_FIRST_NM
,up3.LastName ZVP_LAST_NM, up1.FirstName ZVP_FIRST_NM, 
up4.LastName SVP_LAST_NM, up4.FirstName SVP_FIRST_NM
From BC.vSalesHierarchy s
Join BC.Bottler b on s.RegionID = b.BCRegionID
Join BC.BottlerAccountTradeMark bat on b.BottlerID = bat.BottlerID And bat.TerritoryTypeID = 12 -- Filtre for Servicing Bottler
Join SAP.TradeMark t on t.TradeMarkID = bat.TradeMarkID
Left Join Person.BCSalesAccountability a1 on a1.RegionID = s.RegionID
Left Join Person.UserProfile up1 on a1.GSN = up1.GSN
Left Join Person.BCSalesAccountability a2 on a2.DivisionID = s.DivisionID
Left Join Person.UserProfile up2 on a2.GSN = up2.GSN
Left Join Person.BCSalesAccountability a3 on a3.ZoneID = s.ZoneID
Left Join Person.UserProfile up3 on a3.GSN = up3.GSN
Left Join Person.BCSalesAccountability a4 on a4.SystemID = s.SystemID
Left Join Person.UserProfile up4 on a4.GSN = up4.GSN
And Active = 1
And SystemName in ('PB - Packaged Beverages', 'IS - Iso System', 'BS - Paso System')

-------------------------------
------- This is the query -----
----$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
Select act.SYSTEM_DESC, act.REGION_DESC, bat.BTTLR_ID, bat.TRADEMARK_ID, RSM_LAST_NM, RSM_FIRST_NM, DSM_LAST_NM, DSM_FIRST_NM, ZVP_LAST_NM, ZVP_FIRST_NM, SVP_LAST_NM, SVP_FIRST_NM
From 
	(Select Distinct v.RegionID, 
	v.RegionName REGION_DESC, 
	'00' + Convert(varchar, b.BCBottlerID) BTTLR_ID, 
	t.SAPTradeMarkID TRADEMARK_ID
	From BC.Bottler b
	Join BC.vSalesHierarchy v on b.BCRegionID = v.RegionID
	Join BC.BottlerAccountTradeMark bat on b.BottlerID = bat.BottlerID And bat.TerritoryTypeID = 12
	Join SAP.TradeMark t on t.TradeMarkID = bat.TradeMarkID
	Where BCRegionID is not null
	And SystemName in ('PB - Packaged Beverages', 'IS - Iso System', 'BS - Paso System')
	And b.Active = 1) bat
Join
	(Select s.SystemName SYSTEM_DESC, s.RegionName REGION_DESC, s.RegionID,
		up1.LastName RSM_LAST_NM, up1.FirstName RSM_FIRST_NM, 
		up2.LastName DSM_LAST_NM, up2.FirstName DSM_FIRST_NM
		,up3.LastName ZVP_LAST_NM, up1.FirstName ZVP_FIRST_NM, 
		up4.LastName SVP_LAST_NM, up4.FirstName SVP_FIRST_NM
		From BC.vSalesHierarchy s
		Left Join Person.BCSalesAccountability a1 on a1.RegionID = s.RegionID
		Left Join Person.UserProfile up1 on a1.GSN = up1.GSN
		Left Join Person.BCSalesAccountability a2 on a2.DivisionID = s.DivisionID
		Left Join Person.UserProfile up2 on a2.GSN = up2.GSN
		Left Join Person.BCSalesAccountability a3 on a3.ZoneID = s.ZoneID
		Left Join Person.UserProfile up3 on a3.GSN = up3.GSN
		Left Join Person.BCSalesAccountability a4 on a4.SystemID = s.SystemID
		Left Join Person.UserProfile up4 on a4.GSN = up4.GSN
		Where SystemName in ('PB - Packaged Beverages', 'IS - Iso System', 'BS - Paso System')
) act on bat.RegionID = act.RegionID
-------------------------------
-------------------------------
-------------------------------
-------------------------------
-------------------------------
-------------------------------
-------------------------------


Select Distinct s.SystemName SYSTEM_DESC, 
s.RegionName REGION_DESC, 
'00' + Convert(varchar, b.BCBottlerID) BTTLR_ID, 
t.SAPTradeMarkID TRADEMARK_ID,
up1.LastName RSM_LAST_NM, up1.FirstName RSM_FIRST_NM, 
up2.LastName DSM_LAST_NM, up2.FirstName DSM_FIRST_NM
,up3.LastName ZVP_LAST_NM, up1.FirstName ZVP_FIRST_NM, 
up4.LastName SVP_LAST_NM, up4.FirstName SVP_FIRST_NM
From BC.vSalesHierarchy s
Join BC.vCPIBottler b on s.RegionID = b.RegionID
Join BC.BottlerAccountTradeMark bat on b.BottlerID = bat.BottlerID And bat.TerritoryTypeID = 12 -- Filtre for Servicing Bottler
Join SAP.TradeMark t on t.TradeMarkID = bat.TradeMarkID
Left Join Person.BCSalesAccountability a1 on a1.RegionID = s.RegionID
Left Join Person.UserProfile up1 on a1.GSN = up1.GSN
Left Join Person.BCSalesAccountability a2 on a2.DivisionID = s.DivisionID
Left Join Person.UserProfile up2 on a2.GSN = up2.GSN
Left Join Person.BCSalesAccountability a3 on a3.ZoneID = s.ZoneID
Left Join Person.UserProfile up3 on a3.GSN = up3.GSN
Left Join Person.BCSalesAccountability a4 on a4.SystemID = s.SystemID
Left Join Person.UserProfile up4 on a4.GSN = up4.GSN

Select *
From dbo.BCHierJoin

SElect *
From Person.BCSalesAccountability 
Where DivisionID is not null

------------------------------------
------------------------------------
Select *
From 
(
	Select SystemName, RegionName, Count(*) CNT
	From 
		(Select Distinct v.SystemName, v.RegionName, b.BCBottlerID
		From BC.Bottler b
		Join BC.vSalesHierarchy v on b.BCRegionID = v.RegionID
		Join BC.BottlerAccountTradeMark bat on b.BottlerID = bat.BottlerID And bat.TerritoryTypeID = 12
		Where BCRegionID is not null
		And Active = 1) tmp
	Where SystemName in ('PB - Packaged Beverages', 'IS - Iso System', 'BS - Paso System')
	Group by SystemName, RegionName) SDM
Join
(
	Select SYSTEM_DESC, REGION_DESC, Count(*) CNT
	From 
		(Select Distinct SYSTEM_DESC, REGION_DESC, BTTLR_ID
		From dbo.BCHierJoin
		Where SYSTEM_DESC in ('PB - Packaged Beverages', 'IS - Iso System', 'BS - Paso System')
		) temp
	Group by SYSTEM_DESC, REGION_DESC
) BA on SDM.SystemName = ba.SYSTEM_DESC And SDM.RegionName = ba.REGION_DESC
Where ba.CNT <> sdm.CNT

Order By SystemName, RegionName
-----------------------------------------------------------
-----------------------------------------------------------
-----------------------------------------------------------
-----------------------------------------------------------
-----------------------------------------------------------

Select BTTLR_ID, REGION_DESC
From Staging.BCvBottlerSalesHierachy
Where HIER_TYPE = 'BC'
And BTTLR_ID in ('0012007418', '0012014445', '0012008055')

SElect *
From BC.Region
Where RegionName = 'BADM - ADMIRAL'

Select BCBottlerID BTTLR_ID, BottlerName
From BC.Bottler
Where BCRegionID = 36
And BCBottlerID in ('0012007418', '0012014445', '0012008055')

Select *
From Staging.BCBottler
Where BTTLR_ID in ('0012007418', '0012014445', '0012008055')

----------------------------------
-----------------------------------
Select Distinct SYSTEM_DESC, REGION_DESC, BTTLR_ID
From dbo.BCHierJoin
Order By SYSTEM_DESC, REGION_DESC, BTTLR_ID

Select *
From dbo.BCHierJoin

Select v.SystemName, v.RegionName, b.BCBottlerID
From BC.Bottler b
Join BC.vSalesHierarchy v on b.BCRegionID = v.RegionID
Where BCRegionID is not null
And Active = 1
Order By v.SystemName, v.RegionName, b.BCBottlerID

-----------------------------
-----------------------------
Select Distinct SYSTEM_DESC, REGION_DESC, BTTLR_ID
From dbo.BCHierJoin
Where REGION_DESC = 'BADM - Admiral'
Order By SYSTEM_DESC, REGION_DESC, BTTLR_ID


Select v.SystemName, v.RegionName, b.BCBottlerID
From BC.Bottler b
Join BC.vSalesHierarchy v on b.BCRegionID = v.RegionID
Where BCRegionID is not null
And Active = 1
And v.RegionName = 'BADM - Admiral'
Order By v.SystemName, v.RegionName, b.BCBottlerID

----------------------------------------------
Select SystemName, RegionName, Count(*)
From 
	(Select Distinct v.SystemName, v.RegionName, b.BCBottlerID
	From BC.Bottler b
	Join BC.vSalesHierarchy v on b.BCRegionID = v.RegionID
	Join BC.TerritoryMap bat on b.BottlerID = bat.BottlerID
	Where BCRegionID is not null
	And Active = 1) tmp
Group By SystemName, RegionName
Order By SystemName, RegionName



Select Distinct v.SystemName, v.RegionName, b.BCBottlerID
From BC.Bottler b
Join BC.vSalesHierarchy v on b.BCRegionID = v.RegionID
Join BC.BottlerAccountTradeMark bat on b.BottlerID = bat.BottlerID
Where BCRegionID is not null
And Active = 1
And v.RegionName = 'BADM - Admiral'
Order By v.SystemName, v.RegionName, b.BCBottlerID

Select v.SystemName, v.RegionName, b.BCBottlerID, temp.BTTLR_ID
From BC.Bottler b
Join BC.vSalesHierarchy v on b.BCRegionID = v.RegionID
	Left Join (Select Distinct SYSTEM_DESC, REGION_DESC, BTTLR_ID
	From dbo.BCHierJoin
	Where REGION_DESC = 'BADM - Admiral') temp on temp.REGION_DESC = v.RegionName and b.BCBottlerID = temp.BTTLR_ID
Where BCRegionID is not null
And Active = 1
And v.RegionName = 'BADM - Admiral'
Order By v.SystemName, v.RegionName, b.BCBottlerID

Select v.SystemName, v.RegionName, b.BCBottlerID, temp.BTTLR_ID
From BC.Bottler b
Join BC.vSalesHierarchy v on b.BCRegionID = v.RegionID
	Left Join (Select Distinct SYSTEM_DESC, REGION_DESC, BTTLR_ID
	From dbo.BCHierJoin
	Where REGION_DESC = 'BADM - Admiral') temp on temp.REGION_DESC = v.RegionName and b.BCBottlerID = temp.BTTLR_ID
Where BCRegionID is not null
And Active = 1
And v.RegionName = 'BADM - Admiral'
And temp.BTTLR_ID is null

SElect *
From BC.Bottler
Where BCBottlerID in ('12007418', '12014445', '12008055')


--------------------------------------------
--------------------------------------------
Select *
From dbo.BCHierJoin
Where SYSTEM_DESC in ('PB - Packaged Beverages', 'IS - Iso System', 'BS - Paso System')

Select Distinct TRADEMARK_ID
From dbo.BCHierJoin
Where SYSTEM_DESC in ('PB - Packaged Beverages', 'IS - Iso System', 'BS - Paso System')

Select Count(*) CNT
From 
	(Select Distinct SYSTEM_DESC, REGION_DESC, BTTLR_ID
	From dbo.BCHierJoin
	Where SYSTEM_DESC in ('PB - Packaged Beverages', 'IS - Iso System', 'BS - Paso System')
	) temp
Group by SYSTEM_DESC, REGION_DESC
Order By SYSTEM_DESC, REGION_DESC


Select Distinct SYSTEM_DESC, REGION_DESC, BTTLR_ID, TRADEMARK_ID
From dbo.BCHierJoin
Where SYSTEM_DESC in ('PB - Packaged Beverages', 'IS - Iso System', 'BS - Paso System')

Select *
From dbo.BCHierJoin
Where SYSTEM_DESC in ('PB - Packaged Beverages', 'IS - Iso System', 'BS - Paso System')

Select Distinct SystemName, RegionName, BCBottlerID, TradeMarkID
From BC.Bottler b
Join BC.vSalesHierarchy v on b.BCRegionID = v.RegionID
Join BC.BottlerAccountTradeMark bat on b.BottlerID = bat.BottlerID And bat.TerritoryTypeID = 12
Where BCRegionID is not null
And SystemName in ('PB - Packaged Beverages', 'IS - Iso System', 'BS - Paso System')
And Active = 1

Select SYSTEM_DESC, REGION_DESC, Count(*) CNT
From 
	(Select Distinct SYSTEM_DESC, REGION_DESC, BTTLR_ID
	From dbo.BCHierJoin
	Where SYSTEM_DESC in ('PB - Packaged Beverages', 'IS - Iso System', 'BS - Paso System')
	) temp
Group by SYSTEM_DESC, REGION_DESC
Order By SYSTEM_DESC, REGION_DESC

Select SYSTEM_DESC, REGION_DESC, Count(*) CNT
From 
	(Select Distinct SYSTEM_DESC, REGION_DESC, BTTLR_ID
	From dbo.BCHierJoin
	Where SYSTEM_DESC in ('PB - Packaged Beverages', 'IS - Iso System', 'BS - Paso System')
	) temp
Group by SYSTEM_DESC, REGION_DESC
Order By SYSTEM_DESC, REGION_DESC

Select SystemName, RegionName, Count(*) CNT
From 
	(Select Distinct v.SystemName, v.RegionName, b.BCBottlerID
	From BC.Bottler b
	Join BC.vSalesHierarchy v on b.BCRegionID = v.RegionID
	Join BC.BottlerAccountTradeMark bat on b.BottlerID = bat.BottlerID And bat.TerritoryTypeID = 12
	Where BCRegionID is not null
	And Active = 1) tmp
Where SystemName in ('PB - Packaged Beverages', 'IS - Iso System', 'BS - Paso System')
Group by SystemName, RegionName
Order By SystemName, RegionName

Select Distinct TradeMarkID
From BC.Bottler b
Join BC.vSalesHierarchy v on b.BCRegionID = v.RegionID
Join BC.BottlerAccountTradeMark bat on b.BottlerID = bat.BottlerID And bat.TerritoryTypeID = 12
Where BCRegionID is not null
And Active = 1
And SystemName in ('PB - Packaged Beverages', 'IS - Iso System', 'BS - Paso System')


Select Distinct v.SystemName, v.RegionName, b.BCBottlerID, TradeMarkID
From BC.Bottler b
Join BC.vSalesHierarchy v on b.BCRegionID = v.RegionID
Join BC.BottlerAccountTradeMark bat on b.BottlerID = bat.BottlerID And bat.TerritoryTypeID = 12
Where BCRegionID is not null
And Active = 1
And SystemName in ('PB - Packaged Beverages', 'IS - Iso System', 'BS - Paso System')

Select SystemName, RegionName, Count(*)
From 
	(Select Distinct v.SystemName, v.RegionName, b.BCBottlerID
	From BC.Bottler b
	Join BC.vSalesHierarchy v on b.BCRegionID = v.RegionID
	Join BC.BottlerAccountTradeMark bat on b.BottlerID = bat.BottlerID And bat.TerritoryTypeID = 12
	Where BCRegionID is not null
	And Active = 1) tmp
Where SystemName in ('PB - Packaged Beverages', 'IS - Iso System', 'BS - Paso System')
Group By SystemName, RegionName
Order By SystemName, RegionName

Select v.SystemName, v.RegionName, Count(*) CNT
From BC.Bottler b
Join BC.vSalesHierarchy v on b.BCRegionID = v.RegionID
Where BCRegionID is not null
Group by v.SystemName, v.RegionName
Order by v.SystemName, v.RegionName



