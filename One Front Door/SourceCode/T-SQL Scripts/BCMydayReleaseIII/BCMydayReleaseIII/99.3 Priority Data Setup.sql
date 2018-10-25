use Portal_Data
Go

--Select top 5000 *
--From Playbook.RetailPromotion
--order By ModifiedDate desc

--update Playbook.RetailPromotion
--Set ModifiedDate = DateAdd(month, 3, ModifiedDate), PromotionStartDate = DateAdd(month, 3, PromotionStartDate), PromotionEndDate = DateAdd(month, 3, PromotionEndDate) 

-- Import the data first with the SSIS data import tool then do the query below.
-- Or, get the data through linked server

--Select Distinct InformationCategory
--From Playbook.RetailPromotion


--Select *
--From dbo.PRIORITY_MASTER

--Select Distinct PRIORITY_ID
--From dbo.PRIORITY_BRANDS

--Select Distinct PRIORITY_ID
--From dbo.PRIORITY_CUST_HIER

--Select *
--From dbo.PRIORITY_MASTER

-----------------------------------------------
-----------------------------------------------
Delete BCMyday.ManagementPriority 
--Truncate Table BCMyday.ManagementPriority --Lazy way to rekey
Go

SET IDENTITY_INSERT BCMyday.ManagementPriority ON
GO

INSERT INTO BCMyday.ManagementPriority(ManagementPriorityID, [Description],StartDate,EndDate,ForAllChains,ForAllBrands,ForAllPackages,ForAllBottlers,CreatedBy,Created,LastModifiedBy,LastModified,PublishingStatus,TypeID,Attachment,PriorityNote)
Select PRIORITY_ID, PRIORITY_DESC, START_DATE, END_DATE
           ,1
           ,1
           ,1
           ,1,'WUXYX001',SysDateTime(),'WUXYX001',SysDateTime()
           ,2
           ,1
           ,null
           ,null
From dbo.PRIORITY_MASTER

SET IDENTITY_INSERT BCMyday.ManagementPriority OFF
GO

-----------------------------------------------
Delete [BCMyday].PriorityBottler
Go

Update BCMyday.ManagementPriority
Set ForAllBottlers = 0
Where Description like 'PASO%'
Or Description like 'CASO%'
Or Description like 'ISO%'
Go

INSERT INTO [BCMyday].PriorityBottler([ManagementPriorityID], SystemID, ZoneID, DivisionID, RegionID, BottlerID, [CreatedBy],[Created],[LastModifiedBy],[LastModified])
Select ManagementPriorityID, 5,null,null, null, null,'WUXYX001', SYSDATETIME(), 'WUXYX001', SYSDATETIME()
From BCMyday.ManagementPriority
Where Description like 'PASO%'
Go

INSERT INTO [BCMyday].PriorityBottler([ManagementPriorityID], SystemID, ZoneID, DivisionID, RegionID, BottlerID, [CreatedBy],[Created],[LastModifiedBy],[LastModified])
Select ManagementPriorityID, 6,null,null, null, null,'WUXYX001', SYSDATETIME(), 'WUXYX001', SYSDATETIME()
From BCMyday.ManagementPriority
Where Description like 'CASO%'
Go

INSERT INTO [BCMyday].PriorityBottler([ManagementPriorityID], SystemID, ZoneID, DivisionID, RegionID, BottlerID, [CreatedBy],[Created],[LastModifiedBy],[LastModified])
Select ManagementPriorityID, 7,null,null, null, null,'WUXYX001', SYSDATETIME(), 'WUXYX001', SYSDATETIME()
From BCMyday.ManagementPriority
Where Description like 'ISO%'
Go

---------------------------------------------
---------------------------------------------
Update BCMyday.ManagementPriority
Set ForAllChains = -1
Where ManagementPriorityID in 
(
	Select PRIORITY_ID
	From dbo.PRIORITY_CUST_HIER
	Where NATIONAL_CHAIN_ID > 0
)
Go

Delete [BCMyday].PriorityChain
Go

INSERT INTO [BCMyday].[PriorityChain]([ManagementPriorityID],[NationalChainID],[RegionalChainID],[LocalChainID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
Select PRIORITY_ID, NATIONAL_CHAIN_ID, null, null, 'WUXYX001', SYSDATETIME(), 'WUXYX001', SYSDATETIME()
From dbo.PRIORITY_CUST_HIER
Where NATIONAL_CHAIN_ID > 0
Go
---------------------------------------------

Update BCMyday.ManagementPriority
Set ForAllBrands = -1
Where ManagementPriorityID in 
(
	Select PRIORITY_ID
	From dbo.PRIORITY_BRANDS
	Where TRADEMARK_ID > 0
)
Go

Delete [BCMyday].PriorityBrand
Go

INSERT INTO [BCMyday].[PriorityBrand]([ManagementPriorityID],[TradeMarkID],[BrandID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
Select PRIORITY_ID, TRADEMARK_ID, BRAND_ID, 'WUXYX001', SYSDATETIME(), 'WUXYX001', SYSDATETIME()
From dbo.PRIORITY_BRANDS
Where TRADEMARK_ID > 0
Go

-----------------------
--Insert Into [BCMyday].[PriorityBottlerForUI]
--           ([ManagementPriorityID]
--           ,[BottlerID]
--           ,[RegionID]
--           ,[DivisionID]
--           ,[ZoneID]
--           ,[SystemID]
--           ,[StateRegionID]
--           ,[CreatedBy]
--           ,[Created]
--           ,[LastModifiedBy]
--           ,[LastModified])
--Select 	[ManagementPriorityID],
--	[BottlerID] ,
--	[RegionID] ,
--	[DivisionID] ,
--	[ZoneID] ,
--	[SystemID] ,
--	NULL,
--	[CreatedBy] ,
--	[Created] ,
--	[LastModifiedBy] ,
--	[LastModified] 
--From [BCMyday].[PriorityBottler]
--Go