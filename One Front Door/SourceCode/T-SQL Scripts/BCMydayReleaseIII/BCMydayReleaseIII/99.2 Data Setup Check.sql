use Portal_Data204
go

select a.systembrandid, a.ExternalBrandName, b.imageurl from bcmyday.systembrand a
left join shared.image b on a.imageid = b.imageid
order by a.SystemBrandID desc

select a.systemtrademarkid, a.externaltrademarkname, b.imageurl from bcmyday.systemtrademark a
left join shared.image b on a.imageid = b.imageid
order by SystemTradeMarkID desc

Select * From BCMyday.SystemPackage







SET IDENTITY_INSERT BCMyday.ManagementPriority ON
GO

--Delete BCMyday.ManagementPriority 
--Truncate Table BCMyday.ManagementPriority --Lazy way to rekey
--Delete BCMyday.ManagementPriority Where ManagementPriorityID = 200
--Select * From BCMyday.ManagementPriority

------------
INSERT INTO BCMyday.ManagementPriority(ManagementPriorityID, [Description],StartDate,EndDate,ForAllChains,ForAllBrands,ForAllPackages,ForAllBottlers,CreatedBy,Created,LastModifiedBy,LastModified,PublishingStatus,TypeID,Attachment,PriorityNote)
VALUES(3, 'CASO: Does DP have an inventory of 25% or more for all displays in the store?', '3/14/2015','12/31/2015'
           ,1
           ,1
           ,1
           ,0,'WUXYX001',SysDateTime(),'WUXYX001',SysDateTime()
           ,2
           ,1
           ,null
           ,null)

INSERT INTO [BCMyday].PriorityBottler([ManagementPriorityID], SystemID, ZoneID, DivisionID, RegionID, BottlerID, [CreatedBy],[Created],[LastModifiedBy],[LastModified])
VALUES(3,6,null,null, null, null,'WUXYX001', SysDateTime(), 'WUXYX001', SysDateTime())
------------
INSERT INTO BCMyday.ManagementPriority(ManagementPriorityID, [Description],StartDate,EndDate,ForAllChains,ForAllBrands,ForAllPackages,ForAllBottlers,CreatedBy,Created,LastModifiedBy,LastModified,PublishingStatus,TypeID,Attachment,PriorityNote)
VALUES(32, 'CASO: Are either DP .5L PET and/or DP  8-pack 12oz PET included on the display?', '3/14/2015','12/31/2015'
           ,1
           ,1
           ,1
           ,0,'WUXYX001',SysDateTime(),'WUXYX001',SysDateTime()
           ,2
           ,1
           ,null
           ,null)

INSERT INTO [BCMyday].PriorityBottler([ManagementPriorityID], SystemID, ZoneID, DivisionID, RegionID, BottlerID, [CreatedBy],[Created],[LastModifiedBy],[LastModified])
VALUES(32,6,null,null, null, null,'WUXYX001', SysDateTime(), 'WUXYX001', SysDateTime())
------------
INSERT INTO BCMyday.ManagementPriority(ManagementPriorityID, [Description],StartDate,EndDate,ForAllChains,ForAllBrands,ForAllPackages,ForAllBottlers,CreatedBy,Created,LastModifiedBy,LastModified,PublishingStatus,TypeID,Attachment,PriorityNote)
VALUES(31, 'CASO: Is DP 8oz glass available in the account?', '3/14/2015','12/31/2015'
           ,1
           ,1
           ,1
           ,0,'WUXYX001',SysDateTime(),'WUXYX001',SysDateTime()
           ,2
           ,1
           ,null
           ,null)

INSERT INTO [BCMyday].PriorityBottler([ManagementPriorityID], SystemID, ZoneID, DivisionID, RegionID, BottlerID, [CreatedBy],[Created],[LastModifiedBy],[LastModified])
VALUES(31,6,null,null, null, null,'WUXYX001', SysDateTime(), 'WUXYX001', SysDateTime())
------------
INSERT INTO BCMyday.ManagementPriority(ManagementPriorityID, [Description],StartDate,EndDate,ForAllChains,ForAllBrands,ForAllPackages,ForAllBottlers,CreatedBy,Created,LastModifiedBy,LastModified,PublishingStatus,TypeID,Attachment,PriorityNote)
VALUES(30, 'CASO: Is there DP 12oz glass in the store?', '3/14/2015','12/31/2015'
           ,1
           ,1
           ,1
           ,0,'WUXYX001',SysDateTime(),'WUXYX001',SysDateTime()
           ,2
           ,1
           ,null
           ,null)

INSERT INTO [BCMyday].PriorityBottler([ManagementPriorityID], SystemID, ZoneID, DivisionID, RegionID, BottlerID, [CreatedBy],[Created],[LastModifiedBy],[LastModified])
VALUES(30,6,null,null, null, null,'WUXYX001', SysDateTime(), 'WUXYX001', SysDateTime())
------------
INSERT INTO BCMyday.ManagementPriority(ManagementPriorityID, [Description],StartDate,EndDate,ForAllChains,ForAllBrands,ForAllPackages,ForAllBottlers,CreatedBy,Created,LastModifiedBy,LastModified,PublishingStatus,TypeID,Attachment,PriorityNote)
VALUES(20, 'PASO: Is Schweppes Sparkling 12 packs POG and on shelf in the store?', '3/14/2015','12/31/2015'
           ,1
           ,1
           ,1
           ,0,'WUXYX001',SysDateTime(),'WUXYX001',SysDateTime()
           ,2
           ,1
           ,null
           ,null)

INSERT INTO [BCMyday].PriorityBottler([ManagementPriorityID], SystemID, ZoneID, DivisionID, RegionID, BottlerID, [CreatedBy],[Created],[LastModifiedBy],[LastModified])
VALUES(20,5,null,null, null, null,'WUXYX001', SysDateTime(), 'WUXYX001', SysDateTime())
------------
INSERT INTO BCMyday.ManagementPriority(ManagementPriorityID, [Description],StartDate,EndDate,ForAllChains,ForAllBrands,ForAllPackages,ForAllBottlers,CreatedBy,Created,LastModifiedBy,LastModified,PublishingStatus,TypeID,Attachment,PriorityNote)
VALUES(19, 'PASO: Is Schweppes Ale 2 Liter POG on shelf in the CSD section?', '3/14/2015','12/31/2015'
           ,1
           ,1
           ,1
           ,0,'WUXYX001',SysDateTime(),'WUXYX001',SysDateTime()
           ,2
           ,1
           ,null
           ,null)

INSERT INTO [BCMyday].PriorityBottler([ManagementPriorityID], SystemID, ZoneID, DivisionID, RegionID, BottlerID, [CreatedBy],[Created],[LastModifiedBy],[LastModified])
VALUES(19,5,null,null, null, null,'WUXYX001', SysDateTime(), 'WUXYX001', SysDateTime())
------------
INSERT INTO BCMyday.ManagementPriority(ManagementPriorityID, [Description],StartDate,EndDate,ForAllChains,ForAllBrands,ForAllPackages,ForAllBottlers,CreatedBy,Created,LastModifiedBy,LastModified,PublishingStatus,TypeID,Attachment,PriorityNote)
VALUES(18, 'PASO: Is Schweppes Ale 12pk POG on shelf in the CSD section?', '3/14/2015','12/31/2015'
           ,1
           ,1
           ,1
           ,0,'WUXYX001',SysDateTime(),'WUXYX001',SysDateTime()
           ,2
           ,1
           ,null
           ,null)

INSERT INTO [BCMyday].PriorityBottler([ManagementPriorityID], SystemID, ZoneID, DivisionID, RegionID, BottlerID, [CreatedBy],[Created],[LastModifiedBy],[LastModified])
VALUES(18,5,null,null, null, null,'WUXYX001', SysDateTime(), 'WUXYX001', SysDateTime())
------------
INSERT INTO BCMyday.ManagementPriority(ManagementPriorityID, [Description],StartDate,EndDate,ForAllChains,ForAllBrands,ForAllPackages,ForAllBottlers,CreatedBy,Created,LastModifiedBy,LastModified,PublishingStatus,TypeID,Attachment,PriorityNote)
VALUES(17, 'PASO: Do the number of Crush Flavors POG on shelf equal to Fanta''s Flavor offering?', '3/14/2015','12/31/2015'
           ,1
           ,1
           ,1
           ,0,'WUXYX001',SysDateTime(),'WUXYX001',SysDateTime()
           ,2
           ,1
           ,null
           ,null)

INSERT INTO [BCMyday].PriorityBottler([ManagementPriorityID], SystemID, ZoneID, DivisionID, RegionID, BottlerID, [CreatedBy],[Created],[LastModifiedBy],[LastModified])
VALUES(17,5,null,null, null, null,'WUXYX001', SysDateTime(), 'WUXYX001', SysDateTime())
------------
INSERT INTO BCMyday.ManagementPriority(ManagementPriorityID, [Description],StartDate,EndDate,ForAllChains,ForAllBrands,ForAllPackages,ForAllBottlers,CreatedBy,Created,LastModifiedBy,LastModified,PublishingStatus,TypeID,Attachment,PriorityNote)
VALUES(16, 'PASO:  Is diet cherry 2 Liter POG on shelf?', '3/14/2015','12/31/2015'
           ,1
           ,1
           ,1
           ,0,'WUXYX001',SysDateTime(),'WUXYX001',SysDateTime()
           ,2
           ,1
           ,null
           ,null)

INSERT INTO [BCMyday].PriorityBottler([ManagementPriorityID], SystemID, ZoneID, DivisionID, RegionID, BottlerID, [CreatedBy],[Created],[LastModifiedBy],[LastModified])
VALUES(16,5,null,null, null, null,'WUXYX001', SysDateTime(), 'WUXYX001', SysDateTime())


GO

SET IDENTITY_INSERT BCMyday.ManagementPriority OFF
GO

--5	30004	BS - Paso System
--6	30005	RS - Caso System
--7	30006	IS - Iso System

SElect *
From BCMyday.PriorityBottler




