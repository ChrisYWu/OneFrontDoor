USE [Portal_Data]
GO
/**Executed on DEV, QA and PROD**/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Alter Table Person.UserProfile
Add Title varchar(250)
Go

--------------------------------------------------------
------Load User Profile --------------------------------
ALTER PROCEDURE [ETL].[pLoadUserProfile] 
AS
BEGIN
	--------------------------------------------
	---User Profile ----------------------------
	MERGE Person.UserProfile AS up
		USING ( Select hr.UserID, hr.FirstName, hr.LastName, hr.EmpID, cc.CostCenterID, pc.ProfitCenterID, b.BranchID, a.AreaID, r.RegionID, bu.BUID, hr.JobCode, hr.ManagerGSN, hr.Title
				From [Staging].[ADExtractData] hr
				Left Join Person.userprofile up1 on hr.userid = up1.gsn
				Left Join SAP.CostCenter cc on cc.SAPCostCenterID = substring(hr.CostCenter, patindex('%[^0]%',hr.CostCenter), 10)  
				Left Join SAP.ProfitCenter pc on pc.ProfitCenterID = cc.ProfitCenterID
				Left Join SAP.Branch b on pc.BranchId = b.BranchID
				Left Join SAP.Area a on a.AreaID = b.AreaID
				Left Join SAP.Region r on a.RegionID = r.RegionID
				Left Join SAP.BusinessUnit bu on bu.BUID = r.BUID
				where IsNull(up1.ManualSetup, 0) = 0 
				And hr.ManagerGSN in (Select GSN From Person.userprofile) ) AS input
					ON up.GSN = input.UserID
	WHEN MATCHED THEN
		UPDATE SET up.BUID = input.BUID,
					up.AreaID = input.AreaID,
					up.RegionID = input.RegionID,
					up.PrimaryBranchID = input.BranchID,
					up.ProfitCenterID = input.ProfitCenterID,
					up.CostCenterID = input.CostCenterID,
					up.FirstName = input.FirstName,
					up.LastName = input.LastName,
					up.EmpID = input.EmpID,		
					up.JobCode = input.JobCode,
					up.ManagerGSN = input.ManagerGSN,
					up.Title = input.Title
	WHEN NOT MATCHED By Target THEN
		INSERT(GSN, BUID, AreaID, RegionID, PrimaryBranchID, ProfitCenterID, 
			CostCenterID, FirstName, LastName, EmpID, JobCode, ManualSetup, ManagerGSN, Title)
		VALUES(input.UserID, input.BUID, input.AreaID, input.RegionID, input.BranchID, input.ProfitCenterID, 
			input.CostCenterID, input.FirstName, input.LastName, input.EmpID, input.JobCode, 0, ManagerGSN, Title);
	
	--------------------------------------------
	---SP User Profile -------------------------
	MERGE Person.SPUserProfile AS sup
		USING ( Select hr.UserID, hr.FirstName, hr.LastName, hr.EmpID, cc.CostCenterID, pc.ProfitCenterID, 
						b.BranchID, area.AreaID, a.RegionID, bu.BUID, hr.Title, b.BranchName, a.RegionName, BU.BUName, area.AreaName, area.SAPAreaID,
						b.SAPBranchID, a.SAPRegionID, bu.SAPBUID,
						role.RoleID, role.RoleName
				From [Staging].[ADExtractData] hr
				Join SAP.CostCenter cc on cc.SAPCostCenterID = substring(hr.CostCenter, patindex('%[^0]%',hr.CostCenter), 10)  
				Join SAP.ProfitCenter pc on pc.ProfitCenterID = cc.ProfitCenterID
				Join SAP.Branch b on pc.BranchId = b.BranchID
				Join SAP.Area area on area.AreaID = b.AreaID
				Join SAP.Region a on area.RegionID = a.RegionID
				Join SAP.BusinessUnit bu on bu.BUID = a.BUID
				left outer join Person.userprofile up1 on hr.userid = up1.gsn
				Left Outer join Person.Job job on job.SAPHRJobNumber = hr.JobCode
				Left Outer join Person.Role role on role.RoleID = job.RoleID
				where IsNull(up1.ManualSetup, 0) = 0 And hr.UserID in (Select GSN From Person.userprofile) ) AS input
					ON sup.GSN = input.UserID
	WHEN MATCHED 
		and (sup.PrimaryBranch <> '{"AreaId":' + convert(varchar, input.AreaID) + ',"SAPAreaID":"' + convert(varchar, input.SAPAreaID) + ',"AreaName":"' + convert(varchar, input.AreaName) 
			+ '","RegionId":' + convert(varchar, input.RegionId) + ',"SAPRegionID":"' + convert(varchar, input.SAPRegionID) + ',"RegionName":"' + input.RegionName 
			+ '","BUId":' + convert(varchar, input.BUID) + ',"SAPBUID":"' + convert(varchar, input.SAPBUID) + ',"BUName":"' + input.BUName 
			+ '","BranchId":' + convert(varchar, input.BranchID) + ',"SAPBranchID":"' + convert(varchar, input.SAPBranchID) + ',"BranchName":"'+ input.BranchName +'"}'
		or sup.RoleID <> input.RoleID)
		THEN
		UPDATE SET sup.GSN = input.UserID,
					sup.PrimaryBranch = '{"AreaId":' + convert(varchar, input.AreaID) + ',"SAPAreaID":"' + convert(varchar, input.SAPAreaID) + ',"AreaName":"' + convert(varchar, input.AreaName) 
					+ '","RegionId":' + convert(varchar, input.RegionId) + ',"SAPRegionID":"' + convert(varchar, input.SAPRegionID) + ',"RegionName":"' + input.RegionName 
					+ '","BUId":' + convert(varchar, input.BUID) + ',"SAPBUID":"' + convert(varchar, input.SAPBUID) + ',"BUName":"' + input.BUName 
					+ '","BranchId":' + convert(varchar, input.BranchID) + ',"SAPBranchID":"' + convert(varchar, input.SAPBranchID) + ',"BranchName":"'+ input.BranchName +'"}',
					sup.PrimaryRole = input.RoleName,
					sup.RoleID = input.RoleID,
					sup.updatedinsp = 0
	WHEN NOT MATCHED By Target THEN
		INSERT(GSN, PrimaryBranch, PrimaryRole, RoleID)
	VALUES(	input.UserID, '{"AreaId":' + convert(varchar, input.AreaID) + ',"SAPAreaID":"' + convert(varchar, input.SAPAreaID) + ',"AreaName":"' + convert(varchar, input.AreaName) 
					+ '","RegionId":' + convert(varchar, input.RegionId) + ',"SAPRegionID":"' + convert(varchar, input.SAPRegionID) + ',"RegionName":"' + input.RegionName 
					+ '","BUId":' + convert(varchar, input.BUID) + ',"SAPBUID":"' + convert(varchar, input.SAPBUID) + ',"BUName":"' + input.BUName 
					+ '","BranchId":' + convert(varchar, input.BranchID) + ',"SAPBranchID":"' + convert(varchar, input.SAPBranchID) + ',"BranchName":"'+ input.BranchName +'"}',
			input.RoleName, 
			 input.RoleID);

	-----SP User Profile Role-------------------------
	MERGE Person.UserInRole AS uir
		USING ( Select hr.UserID, role.RoleID, role.RoleName
				From [Staging].[ADExtractData] hr
				join Person.userprofile up1 on hr.userid = up1.gsn
				join Person.Job job on job.SAPHRJobNumber = hr.JobCode
				join Person.Role role on role.RoleID = job.RoleID
				where IsNull(up1.ManualSetup, 0) = 0) AS input
					ON uir.GSN = input.UserID and uir.IsPrimary = 1
	WHEN MATCHED THEN
		UPDATE SET uir.RoleID= input.RoleID
	WHEN NOT MATCHED By Target THEN
		INSERT(GSN, RoleID, IsPrimary)
		VALUES(	input.UserID, input.RoleId,1)
	--WHEN NOT MATCHED By Source Then
		--Delete 
		;

	-----User in Branch Table-------------------------
	MERGE Person.UserInBranch AS uib
		USING ( Select hr.UserID, up1.PrimaryBranchID
				From [Staging].[ADExtractData] hr
				join Person.userprofile up1 on hr.userid = up1.gsn
				where IsNull(up1.ManualSetup, 0) = 0 and not up1.PrimaryBranchId is null ) AS input
				ON uib.GSN = input.UserID and uib.IsPrimary = 1
	WHEN MATCHED THEN
		UPDATE SET uib.BranchId = input.PrimaryBranchID
	WHEN NOT MATCHED By Target THEN
		INSERT(GSN, BranchID, IsPrimary)
		VALUES(	input.UserID, input.PrimaryBranchID, 1);

End
