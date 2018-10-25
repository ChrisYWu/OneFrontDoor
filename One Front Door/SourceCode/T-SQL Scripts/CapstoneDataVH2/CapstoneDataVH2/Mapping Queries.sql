/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [LATITUDE]
      ,[LONGITUDE]
      ,[MatchType]
      ,[NumMatch]
      ,[SAPAccountNumber]
      ,[SDM_Latitude]
      ,[SDM_Longitude]
      ,[GeoSource]
      ,[Address]
      ,[City]
      ,[State]
      ,[PostalCode]
  FROM [Portal_Data_INT].[Staging].[MapLargeGeo]
  Where SAPAccountNUmber in (12173083, 12209371, 12181371, 12172336, 12245764)

SElect MatchType, Count(*) Cnt --238, 762
  FROM [Portal_Data_INT].[Staging].[MapLargeGeo]
Group By MatchType

Select Count(*) --- 335,662
  FROM [Portal_Data_INT].[Staging].[MapLargeGeo]


 SElect GeoSource, Count(*) Accounts --238, 762
  FROM [Portal_Data].SAP.Account
  Where InCapstone = 1
Group By GeoSource