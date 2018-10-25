begin tran

insert into bcmyday.config([Key],Value,Description,ModifiedDate,SendToMyday)
select [Key],Value,Description,ModifiedDate,SendToMyday 
from openquery(bsccap108,'select * from bcmyday.config')


insert into bcmyday.displaytypemaster(Description,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select Description,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
from openquery(bsccap108,'select * from bcmyday.displaytypemaster')

DBCC CHECKIDENT ('bcmyday.SystemBrand', RESEED, 0)
DBCC CHECKIDENT ('bcmyday.systempackage', RESEED, 0)
DBCC CHECKIDENT ('bcmyday.systemtrademark', RESEED, 0)
DBCC CHECKIDENT ('bcmyday.displaytypemaster', RESEED, 0)
DBCC CHECKIDENT ('bcmyday.TieInReason', RESEED, 0)
DBCC CHECKIDENT ('bcmyday.LOS', RESEED, 3)


insert into bcmyday.LOS(ChannelID,LOSImageID,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,LocalChainID,AccountID,IsActive)
select ChannelID,LOSImageID,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,LocalChainID,AccountID,IsActive
from openquery(bsccap108,'select * from bcmyday.LOS')


insert into bcmyday.LOSDisplayLocation(LOSID,DisplayLocationID,DisplaySequence,GridX,GridY,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select LOSID,DisplayLocationID,DisplaySequence,GridX,GridY,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
from openquery(bsccap108,'select * from bcmyday.LOSDisplayLocation')

insert into bcmyday.SystemTradeMark(ExternalTradeMarkName,TradeMarkID,ImageID,TradeMarkLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select ExternalTradeMarkName,TradeMarkID,ImageID,TradeMarkLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
from openquery(bsccap108,'select * from bcmyday.SystemTradeMark')


insert into bcmyday.systembrand(ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId)
select ExternalBrandName,BrandID,TieInType,BrandLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDPSBrand,SystemTradeMarkID,ImageId
from openquery(bsccap108,'select * from bcmyday.systembrand')


insert into bcmyday.SystemPackage(ContainerType,PackageConfigID,BCSystemID,PackageLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,PackageName)
select ContainerType,PackageConfigID,BCSystemID,PackageLevelSort,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,PackageName
from openquery(bsccap108,'select * from bcmyday.SystemPackage')

insert into bcmyday.SystemPackageBrand(SystemPackageID,SystemBrandId,IsActive)
select SystemPackageID,SystemBrandId,IsActive
from openquery(bsccap108,'select * from bcmyday.SystemPackageBrand')


insert into bcmyday.TieInReason(Description,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select Description,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
from openquery(bsccap108,'select * from bcmyday.TieInReason')


insert into shared.image(ImageURL,Description)
select ImageURL,Description
from openquery(bsccap108,'select * from shared.image')


select * from bcmyday.systembrand
select * from bcmyday.systemtrademark

select * from shared.image

rollback tran