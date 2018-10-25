USE [Portal_Data]
GO


Select *
from shared.ExceptionLog
where source like '%6'
order by LastModified desc

If Exists (Select * From sys.objects Where object_id = object_id('[Settings].[vExtendedApplicationRight]'))
Begin
	DROP View [Settings].[vExtendedApplicationRight]
End
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Test Bench
SELECT *
FROM Settings.vExtendedApplicationRight
*/

Create View [Settings].[vExtendedApplicationRight]
As
	Select ar.RightID
		  ,ar.ApplicationID
		  ,ar.RightName
		  ,ar.InvariantName
		  ,ar.Description
		  ,ar.BuiltInRight
		  ,ar.ParentRightID
		  ,ar.CreatedBy
		  ,ar.LastModifiedBy
		  ,ar.LastModified
		  ,arm.MetaDataID
		  ,arm.MetaDataTypeID
		  ,arm.MetaDataName
	From Settings.ApplicationRight ar
	Left Join 
			(Select RightID, Max(MetaDataID) MetaDataID, Max(MetaDataTypeID) MetaDataTypeID
				,Max(MetaDataName) MetaDataName
			From Settings.ApplicationRightMeta
			Group By RightID) arm on ar.RightID = arm.RightID
Go

