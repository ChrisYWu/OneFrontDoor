use Portal_Data_INT
Go

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
