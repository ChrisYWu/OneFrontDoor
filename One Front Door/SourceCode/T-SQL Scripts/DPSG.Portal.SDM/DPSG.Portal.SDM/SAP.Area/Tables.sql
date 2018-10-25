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

---------------------------------------------------
---------------------------------------------------
Alter Table Person.UserProfile Add RegionID Int
Go

Alter Table Person.UserProfile WITH CHECK ADD CONSTRAINT [FK_UserProfile_Region] FOREIGN KEY([RegionID])
REFERENCES [SAP].[Region] ([RegionID])
GO

ALTER TABLE Person.UserProfile CHECK CONSTRAINT [FK_UserProfile_Region]
GO

----- Populate data for the first time -------
----------------------------------------------
-- In 108 this is updated nightly by agent job
--Truncate Table Staging.SalesOffice
--Go 
--Insert Staging.SalesOffice
--Select *
--From BSCCSQ07.Portal_Data.Staging.SalesOffice

---Region-------------------------------------
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
		Join @sapArea sapbu on bu.AreaID = sapbu.AreaID
Go

-------------------------------------------------------------------
------ Branch Table Modification ----------------------------------
Alter TABLE [SAP].[Branch] DROP CONSTRAINT [FK_Branch_Region]
GO

Alter Table [SAP].[Branch] DROP Column RegionID
Go

Alter Table [SAP].[Branch] Add AreaID Int Null
Go

Alter Table [SAP].[Branch]  WITH CHECK ADD CONSTRAINT [FK_Branch_Area] FOREIGN KEY([AreaID])
REFERENCES [SAP].[Area] ([AreaID])
GO

ALTER TABLE [SAP].[Branch] CHECK CONSTRAINT [FK_Branch_Area]
GO

-------Populate date for the first time ---------------------------
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
		RMLocationID int,
		RMLocationCity varchar(50),
		ChangeTrackNumber int
	)
	Insert Into @sapbr
	Select BranchID, SAPBranchID,BranchName,AreaID,RMLocationID,RMLocationCity,ChangeTrackNumber From SAP.Branch

	-- 3. Merge the mirror with the lastest source
	MERGE @sapbr AS ba
		USING ( SELECT b.SalesOfficeID, b.SalesOffice, area.AreaID, l.Location_ID, l.Location_City
				FROM @branch b 
				Join SAP.Area area on b.SapAreaID = area.SapAreaID
				Left Join Staging.RMLocation l on (b.SalesOfficeID = Left(l.Location_ID, 4))
				) AS input
			ON ba.SAPBranchID = input.SalesOfficeID
	WHEN MATCHED THEN
		UPDATE SET ba.BranchName = dbo.udf_TitleCase(input.SalesOffice),
					ba.AreaID = input.AreaID,
					ba.RMLocationID = Location_ID,
					ba.RMLocationCity = Location_City
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPBranchID,BranchName,AreaID,RMLocationID, RMLocationCity)
	VALUES(input.SalesOfficeID, dbo.udf_TitleCase(input.SalesOffice), input.AreaID, Location_ID, Location_City);
	Update @sapbr Set ChangeTrackNumber = CHECKSUM(SAPBranchID, BranchName, AreaID, RMLocationID, RMLocationCity)
	--select CHECKSUM(SAPBranchID, BranchName, AreaID, RMLocationID, RMLocationCity), * from @sapbr

	-- 4. Update and Insert
	-- 4.1 Insert when no skey is found
	MERGE SAP.Branch AS ba
		USING ( SELECT BranchID, SAPBranchID,BranchName,AreaID,RMLocationID,RMLocationCity,ChangeTrackNumber from @sapbr) AS input
			ON ba.BranchID = input.BranchID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPBranchID, BranchName, AreaID, RMLocationID, RMLocationCity, ChangeTrackNumber, LastModified)
	VALUES(input.SAPBranchID, input.BranchName, input.AreaID, input.RMLocationID, input.RMLocationCity, input.ChangeTrackNumber, GetDate());

	-- 4.2 Update when skey is found but the checksum is not right
	Update SAP.Branch Set AreaID = (Select Top 1 AreaID From SAP.Branch Where BranchName = 'San Leandro') Where BranchName = 'Walnut Creek'
	Update bu
	Set SAPBranchID = sapbu.SAPBranchID, BranchName = sapbu.BranchName, AreaID = sapbu.AreaID, RMLocationID = sapbu.RMLocationID, 
		RMLocationCity = sapbu.RMLocationCity, ChangeTrackNumber = sapbu.ChangeTrackNumber, LastModified = GetDate()
	From SAP.Branch bu 
		Join @sapbr sapbu on bu.BranchID = sapbu.BranchID

	--Select * From SAP.Branch
