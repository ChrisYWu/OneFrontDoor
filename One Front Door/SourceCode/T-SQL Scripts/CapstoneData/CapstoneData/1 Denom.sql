Select s.SystemName SYSTEM_DESC, s.RegionName REGION_DESC, s.RegionID,
up1.LastName RSM_LAST_NM, up1.FirstName RSM_FIRST_NM, up1.GSN RSM_GSN, 
up2.LastName DSM_LAST_NM, up2.FirstName DSM_FIRST_NM, up2.GSN DSM_GSN,
up3.LastName ZVP_LAST_NM, up1.FirstName ZVP_FIRST_NM, up3.GSN ZVP_GSN,
up4.LastName SVP_LAST_NM, up4.FirstName SVP_FIRST_NM, up4.GSN SVP_GSN
From BC.vSalesHierarchy s
Left Join Person.BCSalesAccountability a1 on a1.RegionID = s.RegionID
Left Join Person.UserProfile up1 on a1.GSN = up1.GSN
Left Join Person.BCSalesAccountability a2 on a2.DivisionID = s.DivisionID
Left Join Person.UserProfile up2 on a2.GSN = up2.GSN
Left Join Person.BCSalesAccountability a3 on a3.ZoneID = s.ZoneID
Left Join Person.UserProfile up3 on a3.GSN = up3.GSN
Left Join Person.BCSalesAccountability a4 on a4.SystemID = s.SystemID
Left Join Person.UserProfile up4 on a4.GSN = up4.GSN
Where SystemName in ('RS - Caso System', 'IS - Iso System', 'BS - Paso System')
Order by  s.SystemName, s.RegionName
