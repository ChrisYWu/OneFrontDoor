Use Portal_DataSRE
Go

If Exists (Select * From Sys.procedures Where Object_ID = Object_ID('ETL.pReloadBCSalesAccountability'))
Begin
	Drop Proc ETL.pReloadBCSalesAccountability
End
Go

-- exec ETL.pReloadBCSalesAccountability --

Create Proc [ETL].[pReloadBCSalesAccountability]
AS		
	Set NoCount On;

	Delete [Person].[BCSalesAccountability] Where IsSystemLoad = 1;
	
	INSERT INTO [Person].[BCSalesAccountability]
			   ([IsPrimary]
			   ,[GSN]
			   ,[TotalCompanyID]
			   ,[CountryID]
			   ,[SystemID]
			   ,[ZoneID]
			   ,[DivisionID]
			   ,[RegionID]
			   ,[IsSystemLoad]
			   ,[LastModified])
	Select Case When EMP_FUNC = 'Z000010' Then 1 Else 0 End As IsPrimary, 
		EMP_GSN GSN, 
		tc.TotalCompanyID, 
		null CountryID, 
		null SystemID, 
		null ZoneID, 
		null DivisionID, 
		null RegionID, 
		1 IsSystemLoad,
		e.ROW_MOD_DT
	From Staging.BCHierachyEmployee e
	Join BC.TotalCompany tc on e.NODE_ID = tc.BCNodeID
	Join Person.UserProfile u on u.GSN = e.EMP_GSN
	Where DEL_FLG <> 'Y'
	And GetDate() Between VLD_FRM_DT And VLD_TO_DT
	Union
	Select Case When EMP_FUNC = 'Z000010' Then 1 Else 0 End As IsPrimary, 
		EMP_GSN, 
		null TotalCompanyID, 
		tc.CountryID, 
		null SystemID, 
		null ZoneID, 
		null DivisionID, 
		null RegionID, 
		1 IsSystemLoad,
		e.ROW_MOD_DT
	From Staging.BCHierachyEmployee e
	Join BC.Country tc on e.NODE_ID = tc.BCNodeID
	Join Person.UserProfile u on u.GSN = e.EMP_GSN
	Where DEL_FLG <> 'Y'
	And GetDate() Between VLD_FRM_DT And VLD_TO_DT
	Union
	Select Case When EMP_FUNC = 'Z000010' Then 1 Else 0 End As IsPrimary, 
		EMP_GSN, 
		null TotalCompanyID, 
		null CountryID, 
		tc.SystemID, 
		null ZoneID, 
		null DivisionID, 
		null RegionID, 
		1 IsSystemLoad,
		e.ROW_MOD_DT
	From Staging.BCHierachyEmployee e
	Join BC.System tc on e.NODE_ID = tc.BCNodeID
	Join Person.UserProfile u on u.GSN = e.EMP_GSN
	Where DEL_FLG <> 'Y'
	And GetDate() Between VLD_FRM_DT And VLD_TO_DT
	Union
	Select Case When EMP_FUNC = 'Z000010' Then 1 Else 0 End As IsPrimary, 
		EMP_GSN, 
		null TotalCompanyID, 
		null CountryID, 
		null SystemID, 
		tc.ZoneID, 
		null DivisionID, 
		null RegionID, 
		1 IsSystemLoad,
		e.ROW_MOD_DT
	From Staging.BCHierachyEmployee  e
	Join BC.Zone tc on e.NODE_ID = tc.BCNodeID
	Join Person.UserProfile u on u.GSN = e.EMP_GSN
	Where DEL_FLG <> 'Y'
	And GetDate() Between VLD_FRM_DT And VLD_TO_DT
	Union
	Select Case When EMP_FUNC = 'Z000010' Then 1 Else 0 End As IsPrimary, 
		EMP_GSN, 
		null TotalCompanyID, 
		null CountryID, 
		null SystemID, 
		null ZoneID, 
		tc.DivisionID, 
		null RegionID, 
		1 IsSystemLoad,
		e.ROW_MOD_DT
	From Staging.BCHierachyEmployee  e
	Join BC.Division tc on e.NODE_ID = tc.BCNodeID
	Join Person.UserProfile u on u.GSN = e.EMP_GSN
	Where DEL_FLG <> 'Y'
	And GetDate() Between VLD_FRM_DT And VLD_TO_DT
	Union
	Select Case When EMP_FUNC = 'Z000010' Then 1 Else 0 End As IsPrimary, 
		EMP_GSN, 
		null TotalCompanyID, 
		null CountryID, 
		null SystemID, 
		null ZoneID, 
		null DivisionID, 
		tc.RegionID, 
		1 IsSystemLoad,
		e.ROW_MOD_DT
	From Staging.BCHierachyEmployee  e
	Join BC.Region tc on e.NODE_ID = tc.BCNodeID
	Join Person.UserProfile u on u.GSN = e.EMP_GSN
	Where DEL_FLG <> 'Y'
	And GetDate() Between VLD_FRM_DT And VLD_TO_DT
	----------------------------------------
	----------------------------------------
	Declare @LogID int

	Select @LogID = Max(LogID)
	From ETL.BCDataLoadingLog
	Where SchemaName = 'Staging' 
	And TableName = 'BCHierachyEmployee'

	Update ETL.BCDataLoadingLog
	Set MergeDate = GetDate()
	Where  LogID = @LogID

Go

