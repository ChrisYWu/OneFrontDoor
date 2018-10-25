use Portal_Data_INT
Go

INSERT [BCMyday].[Config] ([Key], [Value], [Description], [ModifiedDate], [SendToMyday]) 
VALUES (N'STORES_MAPVIEW_RADIUS_INMILES', N'5', N'Stores mapview radius in miles', CAST(N'2015-03-23 14:53:05.597' AS DateTime), 1)
GO

------------------
set identity_insert bcmyday.systemtrademark on

insert into bcmyday.systemtrademark(SystemTradeMarkID, ExternalTradeMarkName, TradeMarkID, ImageID, TradeMarkLevelSort, IsActive, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
values (17, 'Seagrams', null, null, 300, 1, 'System', getdate(), 'System', getdate())

set identity_insert bcmyday.systemtrademark off

set identity_insert bcmyday.systembrand on

insert into bcmyday.systembrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
values (50, 'Peach', 157, 'B', 50, 1, 'System', getdate(), 'System', getdate(),1,9,null)

insert into bcmyday.systembrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
values (51, 'Grapefruit', 155, 'B', 60, 1, 'System', getdate(), 'System', getdate(),1,9,null)

insert into bcmyday.systembrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
values (52, 'Pineapple', 158, 'B', 70, 1, 'System', getdate(), 'System', getdate(),1,9,null)

insert into bcmyday.systembrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
values (53, 'Cherry', 153, 'B', 80, 1, 'System', getdate(), 'System', getdate(),1,9,null)

insert into bcmyday.systembrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
values (54, 'Rasberry Ale', 433, 'B', 30, 1, 'System', getdate(), 'System', getdate(),1,10,null)

insert into bcmyday.systembrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
values (55, 'Seltzers', 435, 'B', 40, 1, 'System', getdate(), 'System', getdate(),1,10,null)

insert into bcmyday.systembrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
values (56, 'Orange', null, 'B', 20, 1, 'System', getdate(), 'System', getdate(),0,3,null)

insert into bcmyday.systembrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
values (57, 'Diet Orange', null, 'B', 30, 1, 'System', getdate(), 'System', getdate(),0,3,null)

insert into bcmyday.systembrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
values (58, 'Strawberry', null, 'B', 40, 1, 'System', getdate(), 'System', getdate(),0,3,null)

insert into bcmyday.systembrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
values (59, 'Grape', null, 'B', 50, 1, 'System', getdate(), 'System', getdate(),0,3,null)

insert into bcmyday.systembrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
values (60, 'Mango', null, 'B', 60, 1, 'System', getdate(), 'System', getdate(),0,3,null)

insert into bcmyday.systembrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
values (61, 'Grapefruit', null, 'B', 70, 1, 'System', getdate(), 'System', getdate(),0,3,null)

insert into bcmyday.systembrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
values (62, 'Pineapple', null, 'B', 80, 1, 'System', getdate(), 'System', getdate(),0,3,null)

insert into bcmyday.systembrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
values (63, 'Cherry', null, 'B', 90, 1, 'System', getdate(), 'System', getdate(),0,3,null)

insert into bcmyday.systembrand(SystemBrandID,ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
values (64, 'Regular', null, 'B', 100, 1, 'System', getdate(), 'System', getdate(),0,17,null)


set identity_insert bcmyday.systembrand off

insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive)
values(10,50,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive)
values(11,50,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive)
values(12,50,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive)
values(13,50,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive)
values(14,50,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive)
values(15,50,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive)
values(16,50,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive)
values(17,50,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive)
values(18,50,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive)
values(19,50,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive)
values(36,50,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive)
values(41,50,1)
insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive)
values(42,50,1)

insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive)
select SystemPackageID, 51, IsActive from  bcmyday.systempackagebrand
where systembrandid = 50

insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive)
select SystemPackageID, 52, IsActive from  bcmyday.systempackagebrand
where systembrandid = 50

insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive)
select SystemPackageID, 53, IsActive from  bcmyday.systempackagebrand
where systembrandid = 50

insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive)
select SystemPackageID, 54, IsActive from  bcmyday.systempackagebrand
where systembrandid = 50

insert into bcmyday.systempackagebrand(SystemPackageID, SystemBrandId, IsActive)
select SystemPackageID, 55, IsActive from  bcmyday.systempackagebrand
where systembrandid = 50
------------------------------
------------------------------

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
----------------------------
----------------------------
Update BCMyday.SystemBrand Set ExternalBrandName = 'Regular', ModifiedDate = '2015-03-16' Where SystemBrandID = 67
Update BCMyday.SystemPackage Set PackageName = '8oz Can', ModifiedDate = '2015-03-16' Where SystemPackageID = 46

Insert Into BCMyDay.SystemPackageBrand(SystemPackageID, SystemBrandId, IsActive) values(47,37,1)
Insert Into BCMyDay.SystemPackageBrand(SystemPackageID, SystemBrandId, IsActive) values(47,38,1)
Insert Into BCMyDay.SystemPackageBrand(SystemPackageID, SystemBrandId, IsActive) values(47,39,1)
Insert Into BCMyDay.SystemPackageBrand(SystemPackageID, SystemBrandId, IsActive) values(47,40,1)
Insert Into BCMyDay.SystemPackageBrand(SystemPackageID, SystemBrandId, IsActive) values(47,41,1)
Insert Into BCMyDay.SystemPackageBrand(SystemPackageID, SystemBrandId, IsActive) values(48,37,1)
Insert Into BCMyDay.SystemPackageBrand(SystemPackageID, SystemBrandId, IsActive) values(48,38,1)
Insert Into BCMyDay.SystemPackageBrand(SystemPackageID, SystemBrandId, IsActive) values(48,39,1)
Insert Into BCMyDay.SystemPackageBrand(SystemPackageID, SystemBrandId, IsActive) values(48,40,1)
Insert Into BCMyDay.SystemPackageBrand(SystemPackageID, SystemBrandId, IsActive) values(48,41,1)
Insert Into BCMyDay.SystemPackageBrand(SystemPackageID, SystemBrandId, IsActive) values(49,37,1)
Insert Into BCMyDay.SystemPackageBrand(SystemPackageID, SystemBrandId, IsActive) values(49,38,1)
Insert Into BCMyDay.SystemPackageBrand(SystemPackageID, SystemBrandId, IsActive) values(49,39,1)
Insert Into BCMyDay.SystemPackageBrand(SystemPackageID, SystemBrandId, IsActive) values(49,40,1)
Insert Into BCMyDay.SystemPackageBrand(SystemPackageID, SystemBrandId, IsActive) values(49,41,1)
Go


Update bcmyday.systembrand set IsDPSBrand = 'false' where systembrandid = 70 
Update bcmyday.systembrand set brandid=null where systembrandid = 70
Go
-----------------------------------------
-----------------------------------------
-----------------------------------------

set identity_insert shared.image on

insert into shared.image (imageid,imageurl,description)
values(201,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/crush-cherry.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(202,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/crush-grapefruit.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(203,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/crush-peach.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(204,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/crush-pineapple.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(205,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/fanta-cherry.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(206,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/fanta-diet-zero.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(207,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/fanta-grape.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(208,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/fanta-grapefrt.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(209,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/fanta-mango.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(210,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/fanta-orange.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(211,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/fanta-pineapple.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(212,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/fanta-strawberry.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(213,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/schweppes-orig-seltz-120.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(214,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/schweppes-raspberry.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(215,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/seagram-reg.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(216,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/seagrams.png','BCMyday Branch/Trademark')


set identity_insert shared.image off


update bcmyday.SystemTradeMark set imageid=215, ModifiedDate=getdate() where systemtrademarkid=17

update bcmyday.SystemBrand set imageid=203, ModifiedDate=getdate() where SystemBrandID=50
update bcmyday.SystemBrand set imageid=202, ModifiedDate=getdate() where SystemBrandID=51
update bcmyday.SystemBrand set imageid=204, ModifiedDate=getdate() where SystemBrandID=52
update bcmyday.SystemBrand set imageid=201, ModifiedDate=getdate() where SystemBrandID=53
update bcmyday.SystemBrand set imageid=214, ModifiedDate=getdate() where SystemBrandID=54
update bcmyday.SystemBrand set imageid=213, ModifiedDate=getdate() where SystemBrandID=55
update bcmyday.SystemBrand set imageid=210, ModifiedDate=getdate() where SystemBrandID=56
update bcmyday.SystemBrand set imageid=206, ModifiedDate=getdate() where SystemBrandID=57
update bcmyday.SystemBrand set imageid=212, ModifiedDate=getdate() where SystemBrandID=58
update bcmyday.SystemBrand set imageid=207, ModifiedDate=getdate() where SystemBrandID=59
update bcmyday.SystemBrand set imageid=209, ModifiedDate=getdate() where SystemBrandID=60
update bcmyday.SystemBrand set imageid=208, ModifiedDate=getdate() where SystemBrandID=61
update bcmyday.SystemBrand set imageid=211, ModifiedDate=getdate() where SystemBrandID=62
update bcmyday.SystemBrand set imageid=205, ModifiedDate=getdate() where SystemBrandID=63
update bcmyday.SystemBrand set imageid=216, ModifiedDate=getdate() where SystemBrandID=64

select a.systembrandid,b.imageurl from bcmyday.systembrand a
left join shared.image b on a.imageid = b.imageid
where a.SystemBrandID between 50 and 64 

select * from bcmyday.systemtrademark a
left join shared.image b on a.imageid = b.imageid
Go
---------------------------------------
---------------------------------------
---------------------------------------
set identity_insert shared.image on

--Select *
--From Shared.Image Order By ImageID Desc


insert into shared.image (imageid,imageurl,description)
values(217,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/arizona-W105xH56.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(218,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/barq-W50xH56.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(220,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/goldpeak-W81xH56.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(221,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/lipton-W83xH83.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(222,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/mrpibb-xtra-W105xH56.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(223,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/Mug-W70xH56.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(224,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/polar-W52xH56.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(225,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/pure-leaf-W138xH56.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(226,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/sun-drop-120x120.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(227,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/sun-drop-W65xH56.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(228,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/fresca-W138xH25.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(229,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/cott-W145xH56.png','BCMyday Branch/Trademark')

insert into shared.image (imageid,imageurl,description)
values(230,'http://splashnet.dpsg.net/sites/my-images/MasterImages/Trademark/private-label-W82xH56.png','BCMyday Branch/Trademark')

set identity_insert shared.image off

update bcmyday.SystemTradeMark set imageid=218, ModifiedDate=getdate() where systemtrademarkid=18
update bcmyday.SystemTradeMark set imageid=222, ModifiedDate=getdate() where systemtrademarkid=20
update bcmyday.SystemTradeMark set imageid=227, ModifiedDate=getdate() where systemtrademarkid=21
update bcmyday.SystemTradeMark set imageid=223, ModifiedDate=getdate() where systemtrademarkid=22
update bcmyday.SystemTradeMark set imageid=224, ModifiedDate=getdate() where systemtrademarkid=23
update bcmyday.SystemTradeMark set imageid=221, ModifiedDate=getdate() where systemtrademarkid=26
update bcmyday.SystemTradeMark set imageid=220, ModifiedDate=getdate() where systemtrademarkid=27
update bcmyday.SystemTradeMark set imageid=225, ModifiedDate=getdate() where systemtrademarkid=28
update bcmyday.SystemTradeMark set imageid=217, ModifiedDate=getdate() where systemtrademarkid=29
update bcmyday.SystemTradeMark set imageid=228, ModifiedDate=getdate() where systemtrademarkid=19
update bcmyday.SystemTradeMark set imageid=229, ModifiedDate=getdate() where systemtrademarkid=24
update bcmyday.SystemTradeMark set imageid=230, ModifiedDate=getdate() where systemtrademarkid=25
update bcmyday.SystemBrand set imageid=226, ModifiedDate=getdate() where SystemBrandID=72
Go

-----------------------------
------------------------------------
------------------------------------
-----------------------------
------------------------------------
------------------------------------
------------------------------------

Update bcmyday.systempackage set containertype='', modifieddate=getdate() where containertype is null
Go

/*
Update Playbook.RetailPromotion
Set ModifiedDate = DateAdd(month, 4, ModifiedDate), 
PromotionStartDate = DateAdd(month, 4, PromotionStartDate), 
PromotionEndDate = DateAdd(month, 4, PromotionEndDate) 
Go

*/



