use Portal_Data
Go

begin tran

--select * from bcmyday.systemtrademark

set identity_insert bcmyday.systemtrademark on

insert into bcmyday.systemtrademark(SystemTradeMarkID, ExternalTradeMarkName, TradeMarkID, ImageID, TradeMarkLevelSort, IsActive, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
values (18, 'Barq''s', null, null, 310, 1, 'System', getdate(), 'System', getdate())

insert into bcmyday.systemtrademark(SystemTradeMarkID, ExternalTradeMarkName, TradeMarkID, ImageID, TradeMarkLevelSort, IsActive, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
values (19, 'Fresca', null, null, 320, 1, 'System', getdate(), 'System', getdate())

insert into bcmyday.systemtrademark(SystemTradeMarkID, ExternalTradeMarkName, TradeMarkID, ImageID, TradeMarkLevelSort, IsActive, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
values (20, 'Mr Pibb', null, null, 330, 1, 'System', getdate(), 'System', getdate())

insert into bcmyday.systemtrademark(SystemTradeMarkID, ExternalTradeMarkName, TradeMarkID, ImageID, TradeMarkLevelSort, IsActive, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
values (21, 'Sundrop', 194, null, 340, 1, 'System', getdate(), 'System', getdate())

insert into bcmyday.systemtrademark(SystemTradeMarkID, ExternalTradeMarkName, TradeMarkID, ImageID, TradeMarkLevelSort, IsActive, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
values (22, 'Mug', null, null, 350, 1, 'System', getdate(), 'System', getdate())

insert into bcmyday.systemtrademark(SystemTradeMarkID, ExternalTradeMarkName, TradeMarkID, ImageID, TradeMarkLevelSort, IsActive, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
values (23, 'Polar', null, null, 360, 1, 'System', getdate(), 'System', getdate())

insert into bcmyday.systemtrademark(SystemTradeMarkID, ExternalTradeMarkName, TradeMarkID, ImageID, TradeMarkLevelSort, IsActive, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
values (24, 'Cott', null, null, 370, 1, 'System', getdate(), 'System', getdate())

insert into bcmyday.systemtrademark(SystemTradeMarkID, ExternalTradeMarkName, TradeMarkID, ImageID, TradeMarkLevelSort, IsActive, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
values (25, 'Private Label', null, null, 380, 1, 'System', getdate(), 'System', getdate())

insert into bcmyday.systemtrademark(SystemTradeMarkID, ExternalTradeMarkName, TradeMarkID, ImageID, TradeMarkLevelSort, IsActive, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
values (26, 'Lipton', null, null, 390, 1, 'System', getdate(), 'System', getdate())

insert into bcmyday.systemtrademark(SystemTradeMarkID, ExternalTradeMarkName, TradeMarkID, ImageID, TradeMarkLevelSort, IsActive, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
values (27, 'Gold Peak', null, null, 400, 1, 'System', getdate(), 'System', getdate())

insert into bcmyday.systemtrademark(SystemTradeMarkID, ExternalTradeMarkName, TradeMarkID, ImageID, TradeMarkLevelSort, IsActive, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
values (28, 'Pure Leaf', null, null, 410, 1, 'System', getdate(), 'System', getdate())

insert into bcmyday.systemtrademark(SystemTradeMarkID, ExternalTradeMarkName, TradeMarkID, ImageID, TradeMarkLevelSort, IsActive, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
values (29, 'Arizona', null, null, 420, 1, 'System', getdate(), 'System', getdate())

set identity_insert bcmyday.systemtrademark off

set identity_insert bcmyday.systembrand on

insert into bcmyday.systembrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
values (65, 'Coke Led Display', null, 'B', 10, 1, 'System', getdate(), 'System', getdate(),0,1,null)

insert into bcmyday.systembrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
values (66, 'Pepsi Led Display', null, 'B', 10, 1, 'System', getdate(), 'System', getdate(),0,4,null)

insert into bcmyday.systembrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
values (67, 'Root Beer', null, 'B', 10, 1, 'System', getdate(), 'System', getdate(),0,18,null)

insert into bcmyday.systembrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
values (68, 'Ginger Ale', null, 'B', 10, 1, 'System', getdate(), 'System', getdate(),0,17,null)

insert into bcmyday.systembrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
values (69, 'Seltzer', null, 'B', 20, 1, 'System', getdate(), 'System', getdate(),0,17,null)

insert into bcmyday.systembrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
values (70, 'Regular', 435, 'B', 10, 1, 'System', getdate(), 'System', getdate(),0,19,null)

insert into bcmyday.systembrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
values (71, 'Regular', null, 'B', 10, 1, 'System', getdate(), 'System', getdate(),0,20,null)

insert into bcmyday.systembrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
values (72, 'Regular', null, 'B', 10, 1, 'System', getdate(), 'System', getdate(),1,10,null)

insert into bcmyday.systembrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
values (73, 'Regular', null, 'B', 10, 1, 'System', getdate(), 'System', getdate(),0,22,null)

insert into bcmyday.systembrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
values (74, 'Regular', null, 'B', 10, 1, 'System', getdate(), 'System', getdate(),0,23,null)

insert into bcmyday.systembrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
values (75, 'Regular', null, 'B', 10, 1, 'System', getdate(), 'System', getdate(),0,24,null)

insert into bcmyday.systembrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
values (76, 'Regular', null, 'B', 10, 1, 'System', getdate(), 'System', getdate(),0,25,null)

insert into bcmyday.systembrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
values (77, 'Antiox', null, 'B', 10, 1, 'System', getdate(), 'System', getdate(),0,26,null)

insert into bcmyday.systembrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
values (78, 'Brisk', null, 'B', 20, 1, 'System', getdate(), 'System', getdate(),0,26,null)

insert into bcmyday.systembrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
values (79, 'Regular', null, 'B', 10, 1, 'System', getdate(), 'System', getdate(),0,27,null)

insert into bcmyday.systembrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
values (80, 'Regular', null, 'B', 10, 1, 'System', getdate(), 'System', getdate(),0,28,null)

insert into bcmyday.systembrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
values (81, 'Regular', null, 'B', 10, 1, 'System', getdate(), 'System', getdate(),0,29,null)

set identity_insert bcmyday.systembrand off

insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(45,1,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(45,2,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(45,3,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(45,4,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(45,5,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(45,6,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(45,7,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(45,8,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(45,9,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(45,10,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(45,11,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(45,12,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(45,13,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(45,14,1)

insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(46,12,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(46,13,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(46,27,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(46,28,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(46,30,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(46,31,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(46,33,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(46,34,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(46,35,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(46,36,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(46,46,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(46,7,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(46,8,1)

--insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(63,37,1)
--insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(63,38,1)
--insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(63,39,1)
--insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(63,40,1)
--insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(63,41,1)

--insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(64,37,1)
--insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(64,38,1)
--insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(64,39,1)
--insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(64,40,1)
--insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(64,41,1)

--insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(65,37,1)
--insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(65,38,1)
--insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(65,39,1)
--insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(65,40,1)
--insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive) values(65,41,1)

select * from bcmyday.SystemTradeMark
select * from bcmyday.SystemBrand
select * from bcmyday.systempackagebrand

----------------------
SElect *
From bcmyday.SystemPackage


SET IDENTITY_INSERT bcmyday.SystemPackage ON 
Go

insert into bcmyday.SystemPackage(SystemPackageID, ContainerType, PackageConfigID, BCSystemID, PackageLevelSort, IsActive, PackageName)
values(45, '', null, 6, 93, 1, '8oz Glass')

insert into bcmyday.SystemPackage(SystemPackageID, ContainerType, PackageConfigID, BCSystemID, PackageLevelSort, IsActive, PackageName)
values(46, '', null, 7, 62, 1, '8oz CN')

insert into bcmyday.SystemPackage(SystemPackageID, ContainerType, PackageConfigID, BCSystemID, PackageLevelSort, IsActive, PackageName)
values(47, '', null, 7, 63, 1, '32oz')

insert into bcmyday.SystemPackage(SystemPackageID, ContainerType, PackageConfigID, BCSystemID, PackageLevelSort, IsActive, PackageName)
values(48, '', null, 7, 64, 1, '64oz')

insert into bcmyday.SystemPackage(SystemPackageID, ContainerType, PackageConfigID, BCSystemID, PackageLevelSort, IsActive, PackageName)
values(49, '', null, 7, 65, 1, '18.5oz')
go

--update bcmyday.systempackage set containertype='', modifieddate=getdate() where containertype is null

SET IDENTITY_INSERT [BCMyday].[SystemPackage] Off
Go

select * from bcmyday.SystemPackage Order By SystemPackageID desc
----------------------------

commit tran