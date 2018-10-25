USE [Portal_Data]
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_GetDayOfWeekStartsMonday]    Script Date: 3/21/2013 5:37:12 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[ufn_GetDayOfWeekStartsMonday] ( @pInputDate    DATETIME )
RETURNS INT
BEGIN
	Declare @WeekDay int
	Select @WeekDay = DATEPART(WeekDay, GETDATE())
	Set @WeekDay = Case When @WeekDay = 1 Then 7 Else @WeekDay - 1 End
	Return @WeekDay 
END

GO


