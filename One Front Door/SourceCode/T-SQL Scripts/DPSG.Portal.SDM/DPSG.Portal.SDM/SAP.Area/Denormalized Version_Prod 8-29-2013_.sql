Use [Portal_Data]
Go

-------------------------------------------------
-- Create Area Table --
If Exists (select * from sys.objects where object_id = Object_ID('SAP.Area'))
Begin
	DROP TABLE [SAP].[Area];
End
Go

CREATE TABLE [SAP].[Area](
	[AreaID] [int] IDENTITY(1,1) NOT NULL,
	[SAPAreaID] [varchar](50) NOT NULL,
	[AreaName] [varchar](50) NOT NULL,
	[RegionID] [int] NOT NULL,
	[ChangeTrackNumber] [int] NULL,
	[LastModified] [smalldatetime] NULL,
	CONSTRAINT [PK_Area] PRIMARY KEY CLUSTERED 
(
	[AreaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [SAP].[Area]  WITH CHECK ADD CONSTRAINT [FK_Area_Region] FOREIGN KEY([RegionID])
REFERENCES [SAP].[Region] ([RegionID])
GO

ALTER TABLE [SAP].[Area] CHECK CONSTRAINT [FK_Area_Region]
GO

----- Populate data for the first time -------
----------------------------------------------
-- In 108 this is updated nightly by agent job
--Truncate Table Staging.SalesOffice
--Go 
--Insert Staging.SalesOffice
--Select *
--From BSCCSQ07.Portal_Data.Staging.SalesOffice

-------------------------------------------------------------------
------ Branch Table Modification ----------------------------------
Alter Table [SAP].[Branch] Add AreaID Int Null
Go

Alter Table [SAP].[Branch]  WITH CHECK ADD CONSTRAINT [FK_Branch_Area] FOREIGN KEY([AreaID])
REFERENCES [SAP].[Area] ([AreaID])
GO

ALTER TABLE [SAP].[Branch] CHECK CONSTRAINT [FK_Branch_Area]
GO

--- Procs --------------------
--- Procs --------------------
------------------------------
ALTER PROCEDURE [ETL].[pNormalizeLocations] 
AS
BEGIN
    -- exec [ETL].[pNormalizeLocations]
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--------------------------------------------
	---- BU ------------------------------------
	-- 1. Extract the source table
	Declare @bu Table
	(
		BUID varchar(50),
		BUName nvarchar(50)
	)
	Insert @bu
	Select Distinct BusinessUnit, BusinessUnit
	From Staging.SalesOffice
	Where BusinessUnit Not In ('Not assigned', '')

	-- 2. Mirror the target table inlcuding checksum
	Declare @sapbu Table
	(
		BUID varchar(50),
		SAPBUID varchar(50),
		BUName nvarchar(50),
		ChangeTrackNumber int
	)
	Insert Into @sapbu
	Select BUID, SAPBUID, BUName, ChangeTrackNumber
	From SAP.BusinessUnit

	-- 3. Merge the mirror with the lastest source
	MERGE @sapbu AS bu
		USING (SELECT BUID,BUName FROM @bu) AS input
			ON bu.SAPBUID = input.BUID
	WHEN MATCHED THEN 
		UPDATE SET bu.BUName = dbo.udf_TitleCase(input.BUName)
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPBUID,BUName)
	VALUES(input.BUID, dbo.udf_TitleCase(input.BUName));
	-- 3.1 Recalculate the Checksum
	Update @sapbu Set ChangeTrackNumber = CheckSum(SAPBUID, BUName)

	-- 4. Update and Insert
	-- 4.1 Insert when no skey is found
	MERGE SAP.BusinessUnit AS bu
		USING (SELECT BUID, SAPBUID, BUName, ChangeTrackNumber FROM @sapbu) AS input
			ON bu.BUID = input.BUID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPBUID, BUName, ChangeTrackNumber, LastModified)
		VALUES(input.SAPBUID, input.BUName, input.ChangeTrackNumber, GetDate());
	-- 4.2 Update when skey is found but the checksum is not right
	Update bu
	Set SAPBUID = sapbu.SAPBUID, BUName = sapbu.BUName, ChangeTrackNumber = sapbu.ChangeTrackNumber, LastModified = GetDate()
	From SAP.BusinessUnit bu 
		Join @sapBU sapbu on bu.BUID = sapbu.BUID And isnull(bu.ChangeTrackNumber, 0) != isnull(sapbu.ChangeTrackNumber, 0)

	--------------------------------------------

	--------------------------------------------
	---Region-------------------------------------
	-- 1. Extract the source table
	Declare @region Table
	(
		SAPBUID varchar(50),
		RegionID varchar(50),
		RegionName nvarchar(50)
	)
	Insert @region
	Select Distinct BusinessUnit, RegionID, Region
	From Staging.SalesOffice
	Where BusinessUnit not in ('Not assigned', '')

	-- 2. Mirror the target table inlcuding checksum
	Declare @sapregion Table
	(
		RegionID int,
		SAPRegionID varchar(50),
		RegionName nvarchar(50),
		BUID int,
		ChangeTrackNumber int
	)
	Insert Into @sapregion
	Select RegionID, SAPRegionID, RegionName, BUID, ChangeTrackNumber
	From SAP.Region

	-- 3. Merge the mirror with the lastest source
	MERGE @SAPRegion AS ba
		USING ( SELECT r.SAPBUID,RegionID,RegionName,bu.BUID 
				FROM @region r Join SAP.BusinessUnit bu on r.SAPBUID = bu.SAPBUID) AS input
			ON ba.SAPRegionID = input.RegionID
	WHEN MATCHED THEN
		UPDATE SET ba.RegionName = dbo.udf_TitleCase(input.RegionName), ba.BUID = input.BUID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPRegionID,RegionName,BUID)
	VALUES(input.RegionID, dbo.udf_TitleCase(input.RegionName), input.BUID);
	-- 3.1. Hardcode to fix the Captitalization
	Update @sapregion
	Set RegionName = 'Metro NY/NJ'
	Where RegionName = 'Metro Ny/Nj'
	Update @sapregion Set ChangeTrackNumber = CHECKSUM(SAPRegionID, RegionName, BUID)

	-- 4. Update and Insert
	-- 4.1 Insert when no skey is found
	MERGE SAP.Region AS ba
		USING ( SELECT RegionID, SAPRegionID, RegionName, BUID, ChangeTrackNumber from @sapRegion) AS input
			ON ba.RegionID = input.RegionID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPRegionID,RegionName,BUID, ChangeTrackNumber, LastModified)
	VALUES(input.SAPRegionID, input.RegionName, input.BUID, input.ChangeTrackNumber, GetDate());

	-- 4.2 Update when skey is found but the checksum is not right
	Update bu
	Set SAPRegionID = sapbu.SAPRegionID, RegionName = sapbu.RegionName, BUID = sapbu.BUID, ChangeTrackNumber = sapbu.ChangeTrackNumber, LastModified = GetDate()
	From SAP.Region bu 
		Join @sapRegion sapbu on bu.RegionID = sapbu.RegionID And isnull(bu.ChangeTrackNumber, 0) != isnull(sapbu.ChangeTrackNumber, 0)

    ----------------------------------------------
	--- Area -------------------------------------
	-- 1. Extract the source table
	Declare @area Table
	(
		SAPRegionID varchar(50),
		AreaID varchar(50),
		AreaName nvarchar(50)
	)
	Insert @area
	Select Distinct RegionID, AreaID, Area
	From Staging.SalesOffice
	Where Area not in ('')

	-- 2. Mirror the target table inlcuding checksum
	Declare @saparea Table
	(
		AreaID int,
		SAPAreaID varchar(50),
		AreaName nvarchar(50),
		RegionID int,
		ChangeTrackNumber int
	)
	Insert Into @saparea
	Select AreaID, SAPAreaID, AreaName, RegionID, ChangeTrackNumber
	From SAP.Area
	
	-- 3. Merge the mirror with the lastest source
	MERGE @SAPArea AS ba
		USING ( SELECT a.SAPRegionID, AreaID, AreaName, r.RegionID
				FROM @area a Join SAP.Region r on r.SAPRegionID = a.SAPRegionID) AS input
			ON ba.SAPAreaID = input.AreaID
	WHEN MATCHED THEN
		UPDATE SET ba.AreaName = dbo.udf_TitleCase(input.AreaName), ba.RegionID = input.RegionID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPAreaID,AreaName,RegionID)
	VALUES(input.AreaID, dbo.udf_TitleCase(input.AreaName), input.RegionID);

	Update @SAPArea Set AreaName = 'Metro NY/NJ I/O' Where AreaName = 'Metro Ny/Nj I/O'
	Update @SAPArea Set AreaName = 'Metro NY/NJ C/O' Where AreaName = 'Metro Ny/Nj C/O'
	Update @SAPArea Set ChangeTrackNumber = CHECKSUM(SAPAreaID, AreaName, RegionID)

	-- 4. Update and Insert
	-- 4.1 Insert when no skey is found
	MERGE SAP.Area AS ba
		USING ( SELECT AreaID, SAPAreaID, AreaName, RegionID, ChangeTrackNumber from @saparea) AS input
			ON ba.AreaID = input.AreaID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPAreaID,AreaName,RegionID, ChangeTrackNumber, LastModified)
	VALUES(input.SAPAreaID, input.AreaName, input.RegionID, input.ChangeTrackNumber, GetDate());

	-- 4.2 Update when skey is found but the checksum is not right
	Update bu
	Set SAPAreaID = sapbu.SAPAreaID, AreaName = sapbu.AreaName, RegionID = sapbu.RegionID, 
			ChangeTrackNumber = sapbu.ChangeTrackNumber, LastModified = GetDate()
	From SAP.Area bu
		Join @sapArea sapbu on bu.AreaID = sapbu.AreaID And isnull(bu.ChangeTrackNumber, 0) != isnull(sapbu.ChangeTrackNumber, 0)

	--------------------------------------------
	---BRANCH-----------------------------------
	-- 1. Extract the source table
	Declare @branch Table
	(
		SAPAreaID varchar(50),
		SalesOfficeID varchar(50),
		SalesOffice nvarchar(50)
	)
	Insert @branch
	Select Distinct AreaID, SalesOfficeID, SalesOffice
	From Staging.SalesOffice
	Where AreaID not in ('')

	Insert @branch values('100029', '1085', 'NEWBURGH')
	Insert @branch values('100023', '1176', 'TULSA')
		
	-- 2. Mirror the target table inlcuding checksum
	Declare @sapbr Table
	(
		BranchID int,
		SAPBranchID varchar(50),
		BranchName varchar(50),
		AreaID int,
		RegionID int,
		RMLocationID int,
		RMLocationCity varchar(50),
		ChangeTrackNumber int
	)
	Insert Into @sapbr
	Select BranchID, SAPBranchID,BranchName,AreaID, RegionID, RMLocationID, RMLocationCity, ChangeTrackNumber From SAP.Branch

	-- 3. Merge the mirror with the lastest source
	MERGE @sapbr AS ba
		USING ( SELECT b.SalesOfficeID, b.SalesOffice, area.AreaID, Area.RegionID, l.Location_ID, l.Location_City
				FROM @branch b 
				Join SAP.Area area on b.SapAreaID = area.SapAreaID
				Left Join Staging.RMLocation l on (b.SalesOfficeID = Left(l.Location_ID, 4))
				) AS input
			ON ba.SAPBranchID = input.SalesOfficeID
	WHEN MATCHED THEN
		UPDATE SET ba.BranchName = dbo.udf_TitleCase(input.SalesOffice),
					ba.AreaID = input.AreaID,
					ba.RegionID = input.RegionID,
					ba.RMLocationID = Location_ID,
					ba.RMLocationCity = Location_City
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPBranchID,BranchName,AreaID,RegionID,RMLocationID, RMLocationCity)
	VALUES(input.SalesOfficeID, dbo.udf_TitleCase(input.SalesOffice), input.AreaID, input.RegionID, Location_ID, Location_City);
	Update @sapbr Set ChangeTrackNumber = CHECKSUM(SAPBranchID, BranchName, AreaID, RegionID, RMLocationID, RMLocationCity)

	-- 4. Update and Insert
	-- 4.1 Insert when no skey is found
	MERGE SAP.Branch AS ba
		USING ( SELECT BranchID, SAPBranchID,BranchName,AreaID,RegionID,RMLocationID,RMLocationCity,ChangeTrackNumber from @sapbr) AS input
			ON ba.BranchID = input.BranchID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPBranchID, BranchName, AreaID, RegionID, RMLocationID, RMLocationCity, ChangeTrackNumber, LastModified)
	VALUES(input.SAPBranchID, input.BranchName, input.AreaID, input.RegionID, input.RMLocationID, input.RMLocationCity, input.ChangeTrackNumber, GetDate());

	-- 4.2 Update when skey is found but the checksum is not right	
	Update bu
	Set SAPBranchID = sapbu.SAPBranchID, BranchName = sapbu.BranchName, AreaID = sapbu.AreaID, RegionID = sapbu.RegionID, RMLocationID = sapbu.RMLocationID, 
		RMLocationCity = sapbu.RMLocationCity, ChangeTrackNumber = sapbu.ChangeTrackNumber, LastModified = GetDate()
	From SAP.Branch bu 
		Join @sapbr sapbu on bu.BranchID = sapbu.BranchID

	Update SAP.Branch Set AreaID = (Select Top 1 AreaID From SAP.Branch Where BranchName = 'San Leandro') Where BranchName = 'Walnut Creek'
	Update SAP.Branch Set RegionID = (Select Top 1 a.RegionID 
										From SAP.Branch b 
										Join SAP.Area a on b.AreaID = a.AreaID
										Where BranchName = 'San Leandro') Where BranchName = 'Walnut Creek'
	Update SAP.Branch Set ChangeTrackNumber = CHECKSUM(SAPBranchID, BranchName, AreaID, RMLocationID, RMLocationCity)

	--------------------------------------------
	---PROFIT CENTER----------------------------
	-- 1. Extract the source table
	--Select ProfitCenterID, ProfitCenter, SalesOfficeID, SalesOffice
	--From Staging.ProfitCenterToSalesOffice

	-- 2. Mirror the target table inlcuding checksum
	Declare @sppc Table
	(
		ProfitCenterID int,
		SAPProfitCenterID varchar(50),
		ProfitCenterName varchar(64),
		BranchID int,
		BWSalesOfficeID varchar(50),
		BWSalesOffice varchar(50), 
		ChangeTrackNumber int
	)
	Insert Into @sppc(ProfitCenterID, SAPProfitCenterID, ProfitCenterName, BranchID, ChangeTrackNumber)
	Select ProfitCenterID, SAPProfitCenterID, ProfitCenterName, BranchID, ChangeTrackNumber From SAP.ProfitCenter

	-- 3. Merge the mirror with the lastest source
	Declare @temppc Table
	(
		ProfitCenterID varchar(128), 
		ProfitCenter varchar(128), 
		SalesOfficeID varchar(128), 
		SalesOffice varchar(128), 
		BranchID int
	)
	Insert Into @temppc
	SELECT ProfitCenterID, ProfitCenter, SalesOfficeID, SalesOffice, br.BranchID
	FROM Staging.ProfitCenterToSalesOffice p Left Join SAP.Branch br on p.SalesOfficeID = br.SAPBranchID
	Where ISNUMERIC(ProfitCenterID) = 1 And ProfitCenterID != '101196.'

	MERGE @sppc AS ba
		USING (Select Convert(bigint, ProfitCenterID) ProfitCenterID, ProfitCenter, SalesOfficeID, SalesOffice, BranchID From @temppc) AS input
			ON ba.SAPProfitCenterID = input.ProfitCenterID
	WHEN MATCHED THEN
		UPDATE SET ba.ProfitCenterName = dbo.udf_TitleCase(input.ProfitCenter),
			ba.BranchID = input.BranchID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPProfitCenterID, ProfitCenterName, BranchID)
	VALUES(case when ISNUMEric(input.ProfitCenterID) = 1 Then Convert(bigint, input.ProfitCenterID) Else input.ProfitCenterID End, dbo.udf_TitleCase(input.ProfitCenter), input.BranchID);
	Update @sppc Set ChangeTrackNumber = CHECKSUM(SAPProfitCenterID, ProfitCenterName, BranchID);

	-- 4. Update and Insert
	-- 4.1 Insert when no skey is found
	MERGE SAP.ProfitCenter AS ba
		USING ( SELECT ProfitCenterID, SAPProfitCenterID, ProfitCenterName, BranchID,ChangeTrackNumber from @sppc) AS input
			ON ba.ProfitCenterID = input.ProfitCenterID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPProfitCenterID, ProfitCenterName, BranchID, ChangeTrackNumber, LastModified)
	VALUES(input.SAPProfitCenterID, input.ProfitCenterName, input.BranchID, input.ChangeTrackNumber, GetDate());

	-- 4.2 Update when skey is found but the checksum is not right
	Update bu
	Set SAPProfitCenterID = sapbu.SAPProfitCenterID, ProfitCenterName = sapbu.ProfitCenterName, BranchID = sapbu.BranchID, 
		ChangeTrackNumber = sapbu.ChangeTrackNumber, LastModified = GetDate()
	From SAP.ProfitCenter bu 
		Join @sppc sapbu on bu.ProfitCenterID = sapbu.ProfitCenterID And isnull(bu.ChangeTrackNumber, 0) != isnull(sapbu.ChangeTrackNumber, 0)


	--------------------------------------------
	---COST CENTER----------------------------
	--Select CostCenterID, CostCenter, ProfitCenterID
	--From Staging.CostCenterToProfitCenter
	
	-- 2. Mirror the target table inlcuding checksum
	Declare @sapcc Table
	(
		CostCenterID int,
		SAPCostCenterID varchar(64),
		CostCenterName varchar(64),
		ProfitCenterID int,
		ChangeTrackNumber int
	)
	Insert Into @sapcc(CostCenterID, SAPCostCenterID, CostCenterName, ProfitCenterID, ChangeTrackNumber)
	Select CostCenterID, SAPCostCenterID, CostCenterName, ProfitCenterID, ChangeTrackNumber From SAP.CostCenter

	-- 3. Merge the mirror with the lastest source
	MERGE @sapcc AS ba
		USING ( Select c.CostCenterID, c.CostCenter, pc.ProfitCenterID
				From Staging.CostCenterToProfitCenter c Left Join SAP.ProfitCenter pc on convert(bigint, c.ProfitCenterID) = pc.SAPProfitCenterID
			  ) AS input
			ON ba.SAPCostCenterID = case when isnumeric(input.CostCenterID) = 1 then convert(bigint, input.CostCenterID) else input.CostCenterID end
	WHEN MATCHED THEN
		UPDATE SET ba.CostCenterName = dbo.udf_TitleCase(input.CostCenter), ba.ProfitCenterID = input.ProfitCenterID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPCostCenterID, CostCenterName, ProfitCenterID)
	VALUES(case when isnumeric(input.CostCenterID) = 1 then convert(bigint, input.CostCenterID) else input.CostCenterID end, dbo.udf_TitleCase(input.CostCenter), input.ProfitCenterID);
	Update @sapcc Set ChangeTrackNumber = CHECKSUM(SAPCostCenterID, CostCenterName, ProfitCenterID);
	
	-- 4. Update and Insert
	-- 4.1 Insert when no skey is found
	MERGE SAP.CostCenter AS ba
		USING @sapcc AS input
		ON ba.CostCenterID = input.CostCenterID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPCostCenterID, CostCenterName, ProfitCenterID, ChangeTrackNumber, LastModified)
	VALUES(input.SAPCostCenterID, input.CostCenterName, input.ProfitCenterID, input.ChangeTrackNumber, GetDate());

	-- 4.2 Update when skey is found but the checksum is not right
	Update bu
	Set SAPCostCenterID = sapbu.SAPCostCenterID, CostCenterName = sapbu.CostCenterName, ProfitCenterID = sapbu.ProfitCenterID, 
		ChangeTrackNumber = sapbu.ChangeTrackNumber, LastModified = GetDate()
	From SAP.CostCenter bu 
		Join @sapcc sapbu on bu.CostCenterID = sapbu.CostCenterID And isnull(bu.ChangeTrackNumber, 0) != isnull(sapbu.ChangeTrackNumber, 0)
	
End
Go

Create View [MView].[GSNLocation]
As
	Select Distinct Upper(ul.GSN) GSN, lh.BranchID, lh.AreaID, lh.RegionID, lh.BUID
	From Person.UserLocation ul
	Join MView.LocationHier lh on ul.BUID = lh.BUID
	Union
	Select Distinct Upper(ul.GSN), lh.BranchID, lh.AreaID, lh.RegionID, lh.BUID
	From Person.UserLocation ul
	Join MView.LocationHier lh on ul.RegionID = lh.RegionID
	Union
	Select Distinct Upper(ul.GSN), lh.BranchID, lh.AreaID, lh.RegionID, lh.BUID
	From Person.UserLocation ul
	Join MView.LocationHier lh on ul.BranchID = lh.BranchID
GO


exec [ETL].[pNormalizeLocations] 
select *
from sap.Branch
Go

Select * From MView.GSNLocation
Go