USE [Portal_Data]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_DayOfWeek]    Script Date: 3/21/2013 5:35:07 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[udf_DayOfWeek](@dtDate DATETIME)
RETURNS VARCHAR(10)
AS
 BEGIN
 DECLARE @rtDayofWeek VARCHAR(10)
SELECT @rtDayofWeek = CASE DATEPART(weekday,@dtDate)
WHEN 1 THEN 'Sunday'
WHEN 2 THEN 'Monday'
WHEN 3 THEN 'Tuesday'
WHEN 4 THEN 'Wednesday'
WHEN 5 THEN 'Thursday'
WHEN 6 THEN 'Friday'
WHEN 7 THEN 'Saturday'
END
 RETURN (@rtDayofWeek)
END

GO


