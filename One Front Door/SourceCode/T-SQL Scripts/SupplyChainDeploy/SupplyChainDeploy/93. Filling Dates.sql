USE Portal_Data
GO

--Select *
--From Shared.DimDate

Insert Into Shared.DimDate([DateID]
      ,[Date]
      ,[Day]
      ,[DaySuffix]
      ,[DayOfWeek]
      ,[DOWInMonth]
      ,[DayOfYear]
      ,[WeekOfYear]
      ,[WeekOfMonth]
      ,[Month]
      ,[MonthName]
      ,[Quarter]
      ,[QuarterName]
      ,[Year]
      ,[StandardDate]
      ,[HolidayText]
      ,[WeekBeginingDateID]
      ,[MonthBeginingDateID]
      ,[YearBeginingDateID]
      ,[Last7DaysBeginingDateID]
      ,[Last31DaysBeginingDateID])
SELECT [DateID]
      ,[Date]
      ,[Day]
      ,[DaySuffix]
      ,[DayOfWeek]
      ,[DOWInMonth]
      ,[DayOfYear]
      ,[WeekOfYear]
      ,[WeekOfMonth]
      ,[Month]
      ,[MonthName]
      ,[Quarter]
      ,[QuarterName]
      ,[Year]
      ,[StandardDate]
      ,[HolidayText]
      ,[WeekBeginingDateID]
      ,[MonthBeginingDateID]
      ,[YearBeginingDateID]
      ,[Last7DaysBeginingDateID]
      ,[Last31DaysBeginingDateID]
From BSCCAP121.Portal_Data.Shared.DimDate
Go