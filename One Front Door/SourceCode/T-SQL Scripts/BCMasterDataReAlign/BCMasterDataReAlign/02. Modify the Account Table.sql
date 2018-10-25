use Portal_Data
Go

--2. Modify SAP.Account ---------------------------------
--*********************************************************
Alter Table SAP.Account
Add CRMStoreOpenDate Date

Alter Table SAP.Account
Add CRMStoreCloseDate Date

Alter Table SAP.Account
Add CRMLocal Bit

Alter Table SAP.Account
Add CRMDeleted Bit
Go

---- Columns for archiving data ---
Alter Table SAP.Account
Add LocalChainID1 int
Go

Alter Table SAP.Account
Add ChannelID1 int
Go

Alter Table SAP.Account
Add Longitude1 Decimal(10,6)
Go

Alter Table SAP.Account
Add Latitude1 Decimal(10,6)
Go

Alter Table SAP.Account
Add GeoSource1 Varchar (5)
Go

Alter Table SAP.Account
Add GeoCodingNeeded1 bit
Go

Alter Table SAP.Account
Add CapstoneChecksum int
Go

Alter Table SAP.Account
Add InBW bit default 0
Go

Alter Table SAP.Account
Add StoreLastModified DateTime(7)
Go
-------------------------

Update SAP.Account
Set StoreLastModified = LastModified
Go

-------------------------
-------------------------
Update SAP.Account
Set LocalChainID1 = LocalChainID,
	ChannelID1 = ChannelID,
	Latitude1 = Latitude,
	Longitude1 = Longitude,
	GeoSource1 = GeoSource,
	GeoCodingNeeded1 = GeoCodingNeeded
Go

CREATE UNIQUE NONCLUSTERED INDEX [UNCI-Account-SAPAccountNumber] ON [SAP].[Account]
(
	[SAPAccountNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO



-- This idea won't work, the CRMActive is in some index for performance considerations before
--Alter Table SAP.Account
--Drop Column CRMActive
--Go

--Alter Table SAP.Account
--Add CRMActive As  
--(Case When
--	--- Not in Capstone, so the column value is not relevant
--	IsNull(InCapstone, 0) = 0 Then Null 
--	--- In Capstone and CRM Active
--	When
--	InCapstone = 1 
--	And GetDate() Between CRMStoreOpenDate And CRMStoreCloseDate 
--	And CRMDeleted = 0 
--	And CRMLocal = 1 Then 1 
--	Else 0 -- In Capstone But Not CRM Active
--	End
--)
--Go
