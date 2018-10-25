
/*
Bottler Sales Hierachy
*/

-- Staging.BCBottlerHierachy Takes 9 second for full load, differential is negligible
-- Artificial 4-level hairachy ---
DECLARE @OPENQUERY nvarchar(4000)
Set @OPENQUERY = 'Select * Into Staging.BCBottlerSalesHierachy From OpenQuery(COP, ''Select V.BTTLR_GUID, V.BTTLR_ID, V.HIER_TYPE, 
   V.REGION_DESC, V.REGION_GUID, V.REGION_ID, 
   V.DIVISION_DESC, V.DIVISION_GUID, V.DIVISION_ID, 
   V.ZONE_DESC, V.ZONE_GUID, V.ZONE_ID, 
   V.SYSTEM_DESC, V.SYSTEM_GUID, V.SYSTEM_ID, 
   V.CCNTRY_DESC, V.CCNTRY_GUID, V.CCNTRY_ID, 
   V.TCOMP_DESC, V.TCOMP_GUID, V.TCOMP_ID
FROM CAP_DM.VW_DM_BTTLR_SA_HIER V'')'
--Select @OPENQUERY

Exec (@OPENQUERY)
Go

Drop Table Staging.BCBottlerHierachyE
Go

-- Staging.BCBottlerHierachyE
DECLARE @OPENQUERY nvarchar(4000)
Set @OPENQUERY = 'Select * Into Staging.BCBottlerHierachyE From OpenQuery(COP, ''SELECT 
V.BTTLR_GUID, V.BTTLR_ID, V.HIER_TYPE, 
   V.NODE4_GUID, V.NODE4_ID, V.NODE4_DESC, 
   V.NODE3_GUID, V.NODE3_ID, V.NODE3_DESC, 
   V.NODE2_GUID, V.NODE2_ID, V.NODE2_DESC, 
   V.NODE1_GUID, V.NODE1_ID, V.NODE1_DESC
FROM CAP_DM.VW_DM_BTTLR_EBH_HIER V'')'
--Select @OPENQUERY

Exec (@OPENQUERY)
Go

------------------


Select *
From Staging.BCBottlerSalesHierachy 

-- Total company, level 1
-- Hier_Type is redundant information, they are used consistently with the hierachy's top tier nodes
Select Distinct TCOMP_ID, TCOMP_DESC, HIER_TYPE
From Staging.BCBottlerSalesHierachy 

Select NODE_ID, NODE_DESC, HIER_TYPE 
From Staging.BCBottlerHierachy
Where HIER_LVL_NBR = 0

--- Conclusion: Hierachy maintains
Select Distinct TCOMP_ID, TCOMP_DESC, CCNTRY_ID, CCNTRY_DESC
From Staging.BCBottlerSalesHierachy

Select NODE_ID, NODE_DESC, HIER_TYPE
From Staging.BCBottlerHierachy
Where HIER_LVL_NBR in (0, 1)
And HIER_TYPE <> 'EB'

Select *
From Staging.BCBottlerSalesHierachy 

--- Conclusion: Hierachy maintains
--- For all the intents and purposes, which one are ISO, CASO or PASO
/*
30004	BS - PASO SYSTEM
30005	RS - CASO SYSTEM
30006	IS - ISO SYSTEM
*/
Select Distinct TCOMP_DESC, CCNTRY_ID, CCNTRY_DESC, SYSTEM_ID, SYSTEM_DESC
From Staging.BCBottlerSalesHierachy

--- Conclusion: Hierachy maintains, 
--- Do we need the 'BR - RESEARCH OR FRANCHISE ROLE RESERVED', or 'IR - RESEARCH OR FRANCHISE ROLE RESERVED'?
Select Distinct SYSTEM_ID, SYSTEM_DESC, ZONE_ID, ZONE_DESC
From Staging.BCBottlerSalesHierachy
Where SYSTEM_ID in ('30004', '30005', '30006')

--- Conclusion: Hierachy maintains
--- 22 Divisions in the 3 systems
Select Distinct SYSTEM_ID, SYSTEM_DESC, DIVISION_ID, DIVISION_DESC
From Staging.BCBottlerSalesHierachy
Where SYSTEM_ID in ('30004', '30005', '30006')

--- Conclusion: Hierachy maintains
--- 86 Regions in the 3 systems
Select Distinct SYSTEM_DESC, DIVISION_ID, DIVISION_DESC, REGION_ID, REGION_DESC
From Staging.BCBottlerSalesHierachy
Where SYSTEM_ID in ('30004', '30005', '30006')

--- Conclusion: Hierachy maintains
--- 86 Regions in the 3 systems
Select Distinct SYSTEM_DESC, DIVISION_ID, DIVISION_DESC, REGION_ID, REGION_DESC
From Staging.BCBottlerSalesHierachy
Where SYSTEM_ID in ('30004', '30005', '30006')

---- There seems to be bottlers that doesn't belong to any hirachy?, 
-- yeah - majority of them don't belong to a hirachy
Select b.*
From Staging.BCBottlerHierachy h
Right Join Staging.BCBottler b on h.PARTNER = b.BTTLR_ID
Where h.NODE_ID is null
And b.DEL_FLG <> 'Y'
Order By ROW_MOD_DT desc


