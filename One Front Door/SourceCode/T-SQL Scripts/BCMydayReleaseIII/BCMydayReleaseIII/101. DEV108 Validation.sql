use Portal_Data
Go

--Select s.name + '.' + t.name TableName, c.name ColumnName, ty.name DataType, ty.max_length Length
--From sys.tables t
--Join sys.schemas s on t.schema_id = s.schema_id
--Join sys.columns c on c.object_id = t.object_id
--Join sys.types ty on c.system_type_id = ty.system_type_id
--where s.name = 'BCMyDay'
--and t.name not in ('Config', 'DisplayTypeMaster', 'LOS', 'LOSDisplayLocation', 'StoreCondition', 'StoreConditionDisplay', 'StoreConditionDisplayDetail', 'StoreTieInRate', 
--'SystemPackage', 'SystemPackageBrand', 'SystemTradeMark', 'TieInReason', 'WebServiceLog')
--Order By t.name, c.name

-- BCMyDay.pGetPromotionsByRegionID 240,'2015-01-01'
-- BCMyDay.pGetPromotionsByRegionID 9,'2015-01-01'
-- exec BCMyday.pGetStoreTieInsHistory @BottlerID = 490, @LastModifiedDate='2015-02-01'
-- exec BCMyday.pGetStoreTieInsHistoryByREgionID 9, '2015-2-4'
exec BCMyDay.pGetBCPrioritiesByRegionID @RegionID = 36

Select *
From BC.Bottler
Where BottlerId = 490

Select *
From BCMyday.StoreTieInRate
order by StoreConditionID desc

select *
From BCMyday.StoreCondition
order by StoreConditionID desc

select *
from playbook.retailpromotion
order by promotionid desc



