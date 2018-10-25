use Portal_Data_SREINT
Go

If Exists (Select * From Sys.procedures Where Object_ID = Object_ID('ETL.pMergeCapstoneBottlerHier'))
Begin
	Drop Proc ETL.pMergeCapstoneBottlerHier
End
Go

/*
exec ETL.pMergeCapstoneBottlerHier
*/ 

Create Proc [ETL].[pMergeCapstoneBottlerHier]
AS

	Set NoCount On;
	----------------------------------------
	--- BC.TotalCompany ----
	----------------------------------------
	MERGE BC.TotalCompany AS pc
		USING (	Select e.ROW_MOD_DT, b.NODE_ID, b.NODE_DESC, b.HIER_TYPE
				From Processing.BCBottlerEBNodes e 
				Join (  Select Distinct TCOMP_ID NODE_ID, dbo.udf_TitleCase(TCOMP_DESC) NODE_DESC, HIER_TYPE
						From Staging.BCvBottlerSalesHierachy) b on e.NODE_ID = b.NODE_ID
			  ) AS input
			ON pc.BCNodeID = input.NODE_ID
	WHEN MATCHED THEN
		UPDATE SET pc.TotalCompanyName = input.NODE_DESC,
				   pc.LastModified = input.ROW_MOD_DT, 
				   pc.HierType = input.HIER_TYPE,
				   pc.Active = 1
	WHEN NOT MATCHED By Target THEN
		INSERT(TotalCompanyName, BCNodeID, Active, LastModified, HierType)
		VALUES(input.NODE_DESC, input.NODE_ID, 1, ROW_MOD_DT, HIER_TYPE)
	WHEN NOT MATCHED By Source THEN
		Update Set pc.Active = 0;

	----------------------------------------
	--- BC.Country ----
	----------------------------------------
	MERGE BC.Country AS pc
		USING (	Select e.ROW_MOD_DT, b.NODE_ID, b.NODE_DESC, b2.TotalCompanyID
				From Processing.BCBottlerEBNodes e 
				Join (  Select Distinct TCOMP_ID PRNT_ID, CCNTRY_ID NODE_ID, dbo.udf_TitleCase([CCNTRY_DESC]) NODE_DESC
						From Staging.BCvBottlerSalesHierachy) b on e.NODE_ID = b.NODE_ID
				Join BC.TotalCompany b2 on b2.BCNodeID = b.PRNT_ID
				) AS input
			ON pc.BCNodeID = input.NODE_ID
	WHEN MATCHED THEN
		UPDATE SET pc.CountryName = Upper(Substring(input.NODE_DESC, 1, 5)) + Substring(input.NODE_DESC, 6, 99),
				   pc.LastModified = input.ROW_MOD_DT, 
				   pc.TotalCompanyID = input.TotalCompanyID,
				   pc.Active = 1
	WHEN NOT MATCHED By Target THEN
		INSERT(CountryName, BCNodeID, Active, LastModified, TotalCompanyID)
		VALUES(Upper(Substring(input.NODE_DESC, 1, 5)) + Substring(input.NODE_DESC, 6, 99), input.NODE_ID, 1, ROW_MOD_DT, TotalCompanyID)
	WHEN NOT MATCHED By Source THEN
		Update Set pc.Active = 0;
	
	----------------------------------------
	--- BC.System ----
	----------------------------------------
	MERGE BC.System AS pc
		USING (	Select e.ROW_MOD_DT, b.NODE_ID, b.NODE_DESC, b2.CountryID
				From Processing.BCBottlerEBNodes e 
				Join (  Select Distinct CCNTRY_ID PRNT_ID, [SYSTEM_ID] NODE_ID, dbo.udf_TitleCase([SYSTEM_DESC]) NODE_DESC
						From Staging.BCvBottlerSalesHierachy) b on e.NODE_ID = b.NODE_ID
				Join BC.Country b2 on b2.BCNodeID = b.PRNT_ID
				) AS input
			ON pc.BCNodeID = input.NODE_ID
	WHEN MATCHED THEN
		UPDATE SET pc.SystemName = 
		Replace(Upper(Substring(input.NODE_DESC, 1, 4)) + Substring(input.NODE_DESC, 5, 99), 'Oth - ', 'OTH - '),
		pc.LastModified = input.ROW_MOD_DT, 
		pc.CountryID = input.CountryID,
		pc.Active = 1
	WHEN NOT MATCHED By Target THEN
		INSERT(SystemName, BCNodeID, Active, LastModified, CountryID)
		VALUES(Replace(Upper(Substring(input.NODE_DESC, 1, 4)) + Substring(input.NODE_DESC, 5, 99), 'Oth - ', 'OTH - '), input.NODE_ID, 1, ROW_MOD_DT, CountryID)
	WHEN NOT MATCHED By Source THEN
		Update Set pc.Active = 0;

	----------------------------------------
	--- BC.Zone ----
	----------------------------------------
	MERGE BC.Zone AS pc
		USING (	Select e.ROW_MOD_DT, b.NODE_ID, b.NODE_DESC, b2.SystemID
				From Processing.BCBottlerEBNodes e 
				Join (  Select Distinct SYSTEM_ID PRNT_ID, [ZONE_ID] NODE_ID, dbo.udf_TitleCase([ZONE_DESC]) NODE_DESC
						From Staging.BCvBottlerSalesHierachy) b on e.NODE_ID = b.NODE_ID
				Join BC.System b2 on b2.BCNodeID = b.PRNT_ID
				) AS input
			ON pc.BCNodeID = input.NODE_ID
	WHEN MATCHED THEN
		UPDATE SET pc.ZONEName = 
			Upper(Substring(input.NODE_DESC, 1, 4)) + Substring(input.NODE_DESC, 5, 99),
		pc.LastModified = input.ROW_MOD_DT, 
		pc.SystemID = input.SystemID,
		pc.Active = 1
	WHEN NOT MATCHED By Target THEN
		INSERT(ZONEName, BCNodeID, Active, LastModified, SystemID)
		VALUES(Upper(Substring(input.NODE_DESC, 1, 4)) + Substring(input.NODE_DESC, 5, 99), input.NODE_ID, 1, ROW_MOD_DT, SystemID)
	WHEN NOT MATCHED By Source THEN
		Update Set pc.Active = 0;

	----------------------------------------
	--- BC.Division ----
	----------------------------------------
	MERGE BC.Division AS pc
		USING (	Select e.ROW_MOD_DT, b.NODE_ID, b.NODE_DESC, b2.ZoneID
				From Processing.BCBottlerEBNodes e 
				Join (  Select Distinct ZONE_ID PRNT_ID, DIVISION_ID NODE_ID, dbo.udf_TitleCase(DIVISION_DESC) NODE_DESC
						From Staging.BCvBottlerSalesHierachy) b on e.NODE_ID = b.NODE_ID
				Join BC.Zone b2 on b2.BCNodeID = b.PRNT_ID
				) AS input
			ON pc.BCNodeID = input.NODE_ID
	WHEN MATCHED THEN
		UPDATE SET pc.DivisionName = 
			Replace(Upper(Substring(input.NODE_DESC, 1, 4)) + Substring(input.NODE_DESC, 5, 99), 'Ny/Nj', 'NY/NJ'),
		pc.LastModified = input.ROW_MOD_DT, 
		pc.ZoneID = input.ZoneID,
		pc.Active = 1
	WHEN NOT MATCHED By Target THEN
		INSERT(DivisionName, BCNodeID, Active, LastModified, ZoneID)
		VALUES(Replace(Upper(Substring(input.NODE_DESC, 1, 4)) + Substring(input.NODE_DESC, 5, 99), 'Ny/Nj', 'NY/NJ'), input.NODE_ID, 1, ROW_MOD_DT, ZoneID)
	WHEN NOT MATCHED By Source THEN
		Update Set pc.Active = 0;
 
	----------------------------------------
	--- BC.Region ----
	----------------------------------------
	MERGE BC.Region AS pc
		USING (	Select e.ROW_MOD_DT, b.NODE_ID, b.NODE_DESC, b2.DivisionID, HIER_TYPE
				From Processing.BCBottlerEBNodes e 
				Join (  Select Distinct DIVISION_ID PRNT_ID, REGION_ID NODE_ID, dbo.udf_TitleCase(REGION_DESC) NODE_DESC, HIER_TYPE
						From Staging.BCvBottlerSalesHierachy) b on e.NODE_ID = b.NODE_ID
				Join BC.Division b2 on b2.BCNodeID = b.PRNT_ID
				) AS input
			ON pc.BCNodeID = input.NODE_ID
	WHEN MATCHED THEN
		UPDATE SET pc.RegionName = 
			Upper(Substring(input.NODE_DESC, 1, 5)) + Substring(input.NODE_DESC, 6, 99),
		pc.LastModified = input.ROW_MOD_DT, 
		pc.DivisionID = input.DivisionID,
		pc.HierType = input.HIER_TYPE,
		pc.Active = 1
	WHEN NOT MATCHED By Target THEN
		INSERT(RegionName, BCNodeID, Active, LastModified, DivisionID, HierType)
		VALUES(Upper(Substring(input.NODE_DESC, 1, 5)) + Substring(input.NODE_DESC, 6, 99), input.NODE_ID, 1, ROW_MOD_DT, DivisionID, HIER_TYPE)
	WHEN NOT MATCHED By Source THEN
		Update Set pc.Active = 0;

	Declare @LogID int

	Select @LogID = Max(LogID)
	From ETL.BCDataLoadingLog
	Where SchemaName = 'Staging' 
	And TableName = 'BCvBottlerSalesHierachy'

	Update ETL.BCDataLoadingLog
	Set MergeDate = GetDate()
	Where LogID = @LogID

GO

Select *
From ETL.BCDataLoadingLog

