USE [Portal_Data]
GO

If Exists (Select * From sys.objects Where object_id = object_id('[Settings].[vExtendedRoleRight]'))
Begin
	DROP View [Settings].[vExtendedRoleRight]
End
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Test Bench
SELECT *
FROM Settings.vExtendedRoleRight
Where ApplicationID = 1

Select ar.*
From Settings.vExtendedApplicationRight ar
--Join Settings.RoleRight rr on ar.RightID = rr.RightID
Where ApplicationID = 1

Select *
From Settings.RoleRight

Select *
From Settings.ApplicationRightValue

SEle
[Settings].[ApplicationRightMeta]
*/

Create View [Settings].[vExtendedRoleRight]
As
	Select Convert(bit, Case When rr.RightID is null then 0 else 1 end) As Selected
		  ,ar.RightID, ar.RightName, ar.ApplicationID
		  ,rr.CreatedBy, rr.LastModified
		  ,arm.MetaDataID
		  ,arm.MetaDataTypeID
		  ,arm.MetaDataName, isnull(rr.PortalRoleID, 0) PortalRoleID
	From Settings.ApplicationRight ar
	Left Join Settings.RoleRight rr on ar.RightID = rr.RightID
	Left Join 
			(Select RightID, Max(MetaDataID) MetaDataID, Max(MetaDataTypeID) MetaDataTypeID
				,Max(MetaDataName) MetaDataName
			From Settings.ApplicationRightMeta
			Group By RightID) arm on rr.RightID = arm.RightID
Go

