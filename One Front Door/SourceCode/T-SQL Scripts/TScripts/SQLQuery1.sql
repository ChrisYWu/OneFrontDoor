use Portal_Data
Go

--Select *
--From Mview.ChainHier
--Where NationalChainName like 'CVS%'



--Select *
--From SupplyChain.Plant
--Where sAPPlantType = 'RDC'


--Select PlantID, DAteID
--From [SupplyChain].[tPlantInventory]
--Where PlantID in (29, 30)
--Group By DateID, PlantID
--Order By PlantID, DAteID desc


--Select SAPPlantNumber, CalendarDate , Count(*)
--From SAP.BP7PlantInventory
--Where SAPPlantNumber in (1148,
--1418,
--1219,
--1211)
--Group By SAPPlantNumber, CalendarDate 
--Order By SAPPlantNumber, CalendarDate desc



