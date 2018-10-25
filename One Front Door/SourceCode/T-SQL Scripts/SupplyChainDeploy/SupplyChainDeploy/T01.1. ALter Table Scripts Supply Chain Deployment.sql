Use Portal_Data
Go

Print N'Altering Person.SPUserProfile'
GO
ALTER TABLE [Person].[SPUserProfile]
    ADD [Plants]               VARCHAR (MAX) NULL,
        [DefaultManufacture]   VARCHAR (50)  NULL,
        [ProductLineName]      VARCHAR (MAX) NULL,
        [TradeMarkName]        VARCHAR (MAX) NULL,
        [DefaultInventoryPref] VARCHAR (50)  NULL;
GO

PRINT N'Altering [SAP].[Account]...';
GO
ALTER TABLE [SAP].[Account]
    ADD [EnforcedModifiedDate] SMALLDATETIME NULL;
GO


--This will alter the SAP.Branch
--Begin Transaction Abcdef
alter table sap.branch add Address1 varchar(100)
alter table sap.branch add Address2 varchar(100)
alter table sap.branch add City varchar(50)
alter table sap.branch add State varchar(50)
alter table sap.branch add Longitude decimal(10,6)
alter table sap.branch add Latitude decimal(10,6)

--rollback Transaction Abcdef

--SAP.Region will just add the longitude and Latitude
alter table sap.region add Longitude decimal(10,6)
alter table sap.region add Latitude decimal(10,6)
alter table sap.region add ShortName Varchar(10)



--SAP.BusinessUnit
alter table sap.businessunit add SortOrder int

---Alter the SRE Behavior Table for to update the MemberValue to 2000
alter table [Settings].[BehaviorMember] Alter Column [MemberValue] varchar(2000)

