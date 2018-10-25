USE [Portal_Data]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_TitleCase]    Script Date: 02/11/2013 17:43:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_TitleCase]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[udf_TitleCase]
GO

USE [Portal_Data]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_TitleCase]    Script Date: 02/11/2013 17:43:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[udf_TitleCase] (@InputString VARCHAR(4000) )
RETURNS VARCHAR(4000)
AS
 BEGIN
 DECLARE @Index INT
 DECLARE @Char CHAR(1)
DECLARE @OutputString VARCHAR(255)
SET @OutputString = LOWER(@InputString)
SET @Index = 2
SET @OutputString =
STUFF(@OutputString, 1, 1,UPPER(SUBSTRING(@InputString,1,1)))
WHILE @Index <= LEN(@InputString)
BEGIN
 SET @Char = SUBSTRING(@InputString, @Index, 1)
IF @Char IN (' ', ';', ':', '!', '?', ',', '.', '_', '-', '/', '&','''','(')
IF @Index + 1 <= LEN(@InputString)
BEGIN
 IF @Char != ''''
OR
UPPER(SUBSTRING(@InputString, @Index + 1, 1)) != 'S'
SET @OutputString =
STUFF(@OutputString, @Index + 1, 1,UPPER(SUBSTRING(@InputString, @Index + 1, 1)))
END
 SET @Index = @Index + 1
END
 RETURN ISNULL(@OutputString,'')
END 
GO

---------------------------------------
---------------------------------------
USE [Portal_Data]
GO
Drop FUNCTION [dbo].[ufn_GetDayOfWeekStartsMonday] 
Go
CREATE FUNCTION [dbo].[ufn_GetDayOfWeekStartsMonday] ( @pInputDate    DATETIME )
RETURNS INT
BEGIN
	Declare @WeekDay int
	Select @WeekDay = DATEPART(WeekDay, GETDATE())
	Set @WeekDay = Case When @WeekDay = 1 Then 7 Else @WeekDay - 1 End
	Return @WeekDay 
END
GO

USE [Portal_Data]
GO
Drop FUNCTION [dbo].[ufn_GetWeekNumber] 
Go
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
Go
---------------------------------------
---------------------------------------
USE [Portal_Data]
GO
CREATE FUNCTION [dbo].[ufn_GetFirstDayOfMonth] ( @pInputDate    DATETIME )
RETURNS DATETIME
BEGIN

    RETURN CAST(CAST(YEAR(@pInputDate) AS VARCHAR(4)) + '/' + 
                CAST(MONTH(@pInputDate) AS VARCHAR(2)) + '/01' AS DATETIME)

END
GO
