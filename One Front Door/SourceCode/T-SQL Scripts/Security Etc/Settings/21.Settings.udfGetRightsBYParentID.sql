USE [Portal_Data]
GO

/****** Object:  UserDefinedFunction [Settings].[udfGetRightsBYParentID]    Script Date: 1/3/2014 3:23:35 PM ******/

If Exists (Select * From sys.objects Where object_id = object_id('[Settings].[udfGetRightsBYParentID]'))
Begin
	DROP FUNCTION [Settings].[udfGetRightsBYParentID]
End
GO

/****** Object:  UserDefinedFunction [Settings].[udfGetRightsBYParentID]    Script Date: 1/3/2014 3:23:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE Function [Settings].[udfGetRightsBYParentID]
(
	@PortalRoleID int,
	@RightID int
)
Returns Table
AS
Return 
	WITH UserRights(ApplicationID, RightName, InvariantName, RightID, RightLevel, PortalRoleID, IsParent)
	AS (
			SELECT 
				e.ApplicationID,
				CONVERT(varchar(255), e.RightName),
				e.InvariantName,
				e.RightID,
				1,
				@PortalRoleID,
				0
			FROM settings.ApplicationRight AS e
				WHERE e.ParentRightID = @RightID
			UNION ALL
			SELECT 
				e.ApplicationID,
				CONVERT(varchar(255), e.RightName),
				e.InvariantName,
				e.RightID,
				RightLevel + 1,
				@PortalRoleID,
				0
			FROM settings.ApplicationRight AS e
			JOIN UserRights AS d ON e.ParentRightID = d.RightID
			)
			Select PortalRoleID,RightID, IsParent from UserRights;



GO


