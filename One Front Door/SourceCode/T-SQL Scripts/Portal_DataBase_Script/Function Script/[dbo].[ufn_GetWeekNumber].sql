USE [Portal_Data]
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_GetWeekNumber]    Script Date: 3/21/2013 5:47:28 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[ufn_GetWeekNumber] ( @pInputDate    DATETIME )
RETURNS INT
Begin
	Declare @Ancor int
	Select @Ancor = DATEPART(DAY, @pInputDate) / 7 + 1 -- Compensate for the half week in the current week

	Declare @Day1WeekDay int
	Select @Day1WeekDay = DATEPART(WEEKDAY, [dbo].[ufn_GetFirstDayOfMonth](@pInputDate))
	Set @Day1WeekDay = Case When @Day1WeekDay = 1 Then 7 Else @Day1WeekDay - 1 End
	If (-8 + @Day1WeekDay + (DATEPART(DAY, @pInputDate) % 7) > 0)
	Begin
		Select @Ancor = @Ancor + 1
	End
	REturn @Ancor
End

GO


