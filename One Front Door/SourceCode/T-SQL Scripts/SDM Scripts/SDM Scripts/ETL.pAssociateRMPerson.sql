USE [Portal_Data]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ETL].[pAssociateRMPerson]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ETL].[pAssociateRMPerson]
GO

CREATE PROCEDURE [ETL].[pAssociateRMPerson] 
AS
BEGIN
	--------------------------------------------
	---- Role ----------------------------------
	MERGE Person.Role AS r
		USING (Select Distinct JobRole
				From RM..ACEUSER.EMPLOYEES
			  ) AS input
			ON r.RoleName = input.JobRole
	WHEN MATCHED THEN 
		UPDATE SET r.RoleName = dbo.udf_TitleCase(input.JobRole)
	WHEN NOT MATCHED By Target THEN
		INSERT(RoleName)
	VALUES(dbo.udf_TitleCase(input.JobRole));

	MERGE Person.Employee AS e
		USING (Select EMPLOYEEID, JOBROLE, e.FIRSTNAME, e.LASTNAME, LOCATION_ID, ACTIVE, e.GSN, r.RoleID, b.BranchID
				From RM..ACEUSER.EMPLOYEES e
				Join Person.Role r on e.JobRole = r.RoleName
				Join SAP.Branch b on Left(e.LOCATION_ID, 4) = b.SAPBranchID
			  ) AS input
			ON e.RMEmployeeID = input.EMPLOYEEID
	WHEN MATCHED THEN 
		UPDATE SET e.GSN = input.GSN,
					e.FirstName = input.FirstName,
					e.LastName = input.LastName,
					e.BranchID = input.BranchID,
					e.Active = input.Active,
					e.RMEmployeeID = input.EMPLOYEEID,
					e.RoleID = input.RoleID,
					e.RMLocationID = input.Location_ID		
	WHEN NOT MATCHED By Target THEN
		INSERT(GSN, FirstName, LastName, BranchID, Active, RMEmployeeID, RoleID, RMLocationID)
	VALUES(input.GSN, input.FirstName, input.LastName, input.BranchID, input.Active, input.EmployeeID, input.RoleID, Location_ID);

	Update s
	Set s.GSN = u.GSN
	From Person.Employee s
	Join Person.UserProfile u on (s.FirstName = u.FirstName and s.LastName = u.LastName)
	Where s.GSN is null

End

