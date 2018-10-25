USE [Portal_Data]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ETL].[pLoadUserProfile]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ETL].[pLoadUserProfile]
GO

/*
exec [ETL].[pLoadUserProfile]
*/

CREATE PROCEDURE [ETL].[pLoadUserProfile]
AS
BEGIN
	--------------------------------------------
	---User Profile ----------------------------
	MERGE Person.UserProfile AS up
		USING ( Select hr.UserID, hr.FirstName, hr.LastName, hr.EmpID, cc.CostCenterID, pc.ProfitCenterID, b.BranchID, a.AreaID, bu.BUID
				From [HRStaging].[ADExtractData] hr
				Join SAP.CostCenter cc on cc.SAPCostCenterID = hr.CostCenter
				Join SAP.ProfitCenter pc on pc.ProfitCenterID = cc.ProfitCenterID
				Join SAP.Branch b on pc.BranchId = b.BranchID
				Join SAP.BusinessArea a on a.AreaID = b.AreaID
				Join SAP.BusinessUnit bu on bu.BUID = a.BUID) AS input
					ON up.GSN = input.UserID
	WHEN MATCHED THEN
		UPDATE SET up.BUID = input.BUID,
					up.AreaID = input.AreaID,
					up.PrimaryBranchID = input.BranchID,
					up.ProfitCenterID = input.ProfitCenterID,
					up.CostCenterID = input.CostCenterID,
					up.FirstName = input.FirstName,
					up.LastName = input.LastName,
					up.EmpID = input.EmpID				
	WHEN NOT MATCHED By Target THEN
		INSERT(GSN, BUID, AreaID, PrimaryBranchID, ProfitCenterID, CostCenterID, FirstName, LastName, EmpID)
	VALUES(input.UserID, input.BUID, input.AreaID, input.BranchID, input.CostCenterID, input.ProfitCenterID, input.FirstName, input.LastName, input.EmpID);

	--------------------------------------------
	---SP User Profile -------------------------
	MERGE Person.SPUserProfile AS sup
		USING ( Select hr.UserID, hr.FirstName, hr.LastName, hr.EmpID, cc.CostCenterID, pc.ProfitCenterID, 
						b.BranchID, a.AreaID, bu.BUID, hr.Title, b.BranchName, a.AreaName, BU.BUName,
						b.SAPBranchID, a.SAPAreaID, bu.SAPBUID
				From [HRStaging].[ADExtractData] hr
				Join SAP.CostCenter cc on cc.SAPCostCenterID = hr.CostCenter
				Join SAP.ProfitCenter pc on pc.ProfitCenterID = cc.ProfitCenterID
				Join SAP.Branch b on pc.BranchId = b.BranchID
				Join SAP.BusinessArea a on a.AreaID = b.AreaID
				Join SAP.BusinessUnit bu on bu.BUID = a.BUID) AS input
					ON sup.GSN = input.UserID
	WHEN MATCHED THEN
		UPDATE SET sup.GSN = input.UserID,
					sup.PrimaryBranch = input.BranchName + '|SAP:'  + input.SAPBranchID,
					sup.PrimaryRole = case when input.Title like '%branch manager%' then 'Branch Manager' end,
					sup.PrimaryArea = input.AreaName + '|SAP:' + input.SAPAreaID,
					sup.PrimaryBU = input.BUName + '|SAP:' + input.SAPBUID
	WHEN NOT MATCHED By Target THEN
		INSERT(GSN, PrimaryBranch, PrimaryRole, PrimaryArea, PrimaryBU)
	VALUES(	input.UserID, input.BranchName + '|SAP:'  + input.SAPBranchID,
			case when input.Title like '%branch manager%' then 'Branch Manager' end, 
			input.AreaName + '|SAP:' + input.SAPAreaID,
			input.BUName + '|SAP:' + input.SAPBUID);

End