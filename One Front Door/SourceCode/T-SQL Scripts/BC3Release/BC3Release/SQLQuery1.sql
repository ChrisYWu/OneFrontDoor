use Portal_Data_int
Go

Select *
From BCMyDay.ManagementPriority
Where GetDate() >= StartDate And GetDate() <= EndDate

Select GetDate()

Select *
From BCMyDay.PriorityBottler
Where ManagementPriorityID = 438

Select *
From BCMyDay.ManagementPriority


exec BCMyDay.pGetBCPrioritiesByRegionID @RegionID = 9

SElect *
From Person.UserProfile
Where GSN = 'HALDC001'

SELECT distinct
 
[StoreConditionID]
      ,a.[AccountId]
      ,[ConditionDate]
      ,[GSN]
      ,[BCSystemID]
      ,[CreatedBy]
      ,[CreatedDate]
      ,a.[BottlerID]
      ,[IsActive]
      ,[Name]
  FROM [Portal_Data].[BCMyday].[StoreCondition] a
  --join [BC].[BottleraccountTradeMark] b on a.accountid = b.accountid
  --where gsn like '%hald%'
  where StoreConditionID = 7456




