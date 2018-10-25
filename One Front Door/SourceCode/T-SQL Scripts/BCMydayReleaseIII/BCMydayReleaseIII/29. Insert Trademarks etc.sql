use Portal_Data
Go

begin tran

--select * from bcmyday.systemtrademark

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

select * from bcmyday.systempackagebrand

select * from bcmyday.systembrand

select * from bcmyday.systemtrademark


commit tran