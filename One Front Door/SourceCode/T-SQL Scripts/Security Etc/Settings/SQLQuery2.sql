Use Portal_Data
Go

Select top 1 *
From Shared.ExceptionLog
Order By LastModified desc
Go

Select *
From Staging.ADExtractData
Where isnull(OrgUnit, '') = '' 

Select DATALENGTH(Detail)
From Shared.ExceptionLog
Order By LastModified desc
Go

SELECT [RoleRightID]
	,ar.RightName
	,a.ApplicationID
	,a.ApplicationName
    ,[PortalRoleID]
    ,rr.[RightID]
    ,rr.[CreatedBy]
    ,rr.[LastModified]
FROM [Settings].[RoleRight] rr
Join Settings.ApplicationRight ar On rr.RightID = ar.RightID
Join Shared.Application a on ar.ApplicationID = a.ApplicationID
Where PortalRoleID = 10
And a.ApplicationID = 3046

Select *
From Settings.UserInRole
