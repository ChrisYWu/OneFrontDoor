use Portal_Data204
Go

-- The UI one
SELECT [ID]
      ,[PromotionId]
      ,[BUID]
      ,[RegionId]
      ,[BranchId]
      ,[AreaId]
      ,[SystemID]
      ,[ZoneID]
      ,[DivisionID]
      ,[BCRegionID]
      ,[BottlerID]
      ,[StateId]
      ,[WD]
  FROM [Playbook].[PromotionGeoRelevancy] t1
Where StateID is not null 
And Exists (Select * From [Playbook].[PromotionGeoRelevancy] t2 Where t2.PromotionId = t1.PromotionId and (t2.SystemID is not null or t2.DivisionID is not null))
Order By PromotionId desc


Select * From Playbook.PromotionGeoRelevancy Where PromotionId = 35839

-- Fitler One
Select * From Playbook.PromotionGeoHier
Where PromotionID = 35839
And BottlerID is not null

Select * From Shared.StateBottler

Select definition, o.object_id, o.name
From  sys.sql_modules m
join sys.objects o on m.object_id = o.object_id
where definition like '% StateBottler%'

Select *
From Playbook.RetailPromotion

Select Distinct pgr.PromotionId, sr.RegionABRV, pgr.*
From Playbook.PromotionGeoRelevancy pgr
Join Shared.StateRegion sr on pgr.StateID = sr.StateRegionID

Select *
From BCMyday.PriorityBottler

--Insert Into BCMyday.PriorityBottlerForUI(ManagementPriorityID, StateRegionID, CreatedBy, Created, LastModifiedBy, LastModified) 
--Values(10, 52, 'WUXYX001', SYSDATETIME(), 'WUXYX001', SYSDATETIME())
--Insert Into BCMyday.PriorityBottlerForUI(ManagementPriorityID, StateRegionID, CreatedBy, Created, LastModifiedBy, LastModified) 
--Values(10, 53, 'WUXYX001', SYSDATETIME(), 'WUXYX001', SYSDATETIME())
--Insert Into BCMyday.PriorityBottlerForUI(ManagementPriorityID, StateRegionID, CreatedBy, Created, LastModifiedBy, LastModified) 
--Values(1, 53, 'WUXYX001', SYSDATETIME(), 'WUXYX001', SYSDATETIME())
--Insert Into BCMyday.PriorityBottlerForUI(ManagementPriorityID, StateRegionID, CreatedBy, Created, LastModifiedBy, LastModified) 
--Values(12, 31, 'WUXYX001', SYSDATETIME(), 'WUXYX001', SYSDATETIME())
--Insert Into BCMyday.PriorityBottlerForUI(ManagementPriorityID, StateRegionID, CreatedBy, Created, LastModifiedBy, LastModified) 
--Values(33, 34, 'WUXYX001', SYSDATETIME(), 'WUXYX001', SYSDATETIME())
--Insert Into BCMyday.PriorityBottlerForUI(ManagementPriorityID, StateRegionID, CreatedBy, Created, LastModifiedBy, LastModified) 
--Values(15, 31, 'WUXYX001', SYSDATETIME(), 'WUXYX001', SYSDATETIME())
--Insert Into BCMyday.PriorityBottlerForUI(ManagementPriorityID, StateRegionID, CreatedBy, Created, LastModifiedBy, LastModified) 
--Values(32, 52, 'WUXYX001', SYSDATETIME(), 'WUXYX001', SYSDATETIME())
--Go

Use Portal_Data
Go

Drop Table BCMyday.PriorityBottlerForUI
Go










