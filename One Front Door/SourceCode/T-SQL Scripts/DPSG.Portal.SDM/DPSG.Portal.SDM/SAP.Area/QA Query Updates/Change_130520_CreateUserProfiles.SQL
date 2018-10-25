-- Provided by Vijay on 5/20/2013 10:33am. 
-- For manually setup test user profiles
-- Executed on 5/20/2013 12:36am

--- Result: TESBM001 is a duplicated row.

--BM
insert into person.userprofile 
values( 'TESBM001',3,8,122,690,1634,'Test','BM1','','','60019153',1)
insert into person.spuserprofile 
values( 'TESBM001','{"AreaId":,"AreaName":"","BUId":3,"BUName":"Pacific","BranchId":122,"BranchName":"San Leandro"}','BM',NULL,NULL,23037,null,0,null)
insert into person.userprofile 
values( 'TESBM002',3,8,122,690,1634,'Test','BM2','','','60019153',1)
insert into person.spuserprofile 
values( 'TESBM002','{"AreaId":,"AreaName":"","BUId":3,"BUName":"Pacific","BranchId":122,"BranchName":"San Leandro"}','BM',NULL,NULL,23037,null,0,null)
insert into person.spuserprofile 
values( 'SINNX510','{"AreaId":,"AreaName":"","BUId":3,"BUName":"Pacific","BranchId":122,"BranchName":"San Leandro"}','BM',NULL,NULL,23037,null,0,null)
update person.UserProfile
set ManualSetup =1
where gsn='SINNX510'

--insert into person.userprofile 
--values( 'SETNX001',3,8,122,690,1634,'Test','BM2','','','60019153',1)
insert into person.spuserprofile 
values( 'SETNX001','{"AreaId":,"AreaName":"","BUId":3,"BUName":"Pacific","BranchId":122,"BranchName":"San Leandro"}','BM',NULL,NULL,23037,null,0,null)
update person.UserProfile
set ManualSetup =1
where gsn='SETNX001'


--insert into person.userprofile 
--values( 'FARTJ002',3,8,122,690,1634,'Test','BM2','','','60019153',1)
insert into person.spuserprofile 
values( 'FARTJ002','{"AreaId":,"AreaName":"","BUId":3,"BUName":"Pacific","BranchId":122,"BranchName":"San Leandro"}','BM',NULL,NULL,23037,null,0,null)
update person.UserProfile
set ManualSetup =1
where gsn='SETNX001'



--AD
insert into person.userprofile 
values( 'Tesad001',3,8,122,690,1634,'Test','AD1','','','60019153',1)
insert into person.spuserprofile 
values( 'Tesad001','{"AreaId":,"AreaName":"","BUId":3,"BUName":"Pacific","BranchId":122,"BranchName":"San Leandro"}','AD',NULL,NULL,23036,null,0,null)
insert into person.userprofile 
values( 'Tesad002',3,8,122,690,1634,'Test','AD2','','','60019153',1)
insert into person.spuserprofile 
values( 'Tesad002','{"AreaId":,"AreaName":"","BUId":3,"BUName":"Pacific","BranchId":122,"BranchName":"San Leandro"}','AD',NULL,NULL,23036,null,0,null)



--MDD
insert into person.userprofile 
values( 'mddts001',3,8,122,690,1634,'Test','MDD1','','','60019153',1)
insert into person.spuserprofile 
values( 'mddts001','{"AreaId":,"AreaName":"","BUId":3,"BUName":"Pacific","BranchId":122,"BranchName":"San Leandro"}','MDD',NULL,NULL,23031,null,0,null)
insert into person.userprofile 
values( 'mddts002',3,8,122,690,1634,'Test','MDD2','','','60019153',1)
insert into person.spuserprofile 
values( 'mddts002','{"AreaId":,"AreaName":"","BUId":3,"BUName":"Pacific","BranchId":122,"BranchName":"San Leandro"}','MDD',NULL,NULL,23031,null,0,null)


--RAE
insert into person.userprofile 
values( 'raets001',3,8,122,690,1634,'Test','RAE1','','','60019153',1)
insert into person.spuserprofile 
values( 'raets001','{"AreaId":,"AreaName":"","BUId":3,"BUName":"Pacific","BranchId":122,"BranchName":"San Leandro"}','RAE',NULL,NULL,23033,null,0,null)
insert into person.userprofile 
values( 'raets002',3,8,122,690,1634,'Test','RAE2','','','60019153',1)
insert into person.spuserprofile 
values( 'raets002','{"AreaId":,"AreaName":"","BUId":3,"BUName":"Pacific","BranchId":122,"BranchName":"San Leandro"}','RAE',NULL,NULL,23033,null,0,null)


--BUGM
insert into person.userprofile 
values( 'Bugtes001',3,8,122,690,1634,'Test','BUGM1','','','60019153',1)
insert into person.spuserprofile 
values( 'Bugtes001','{"AreaId":,"AreaName":"","BUId":3,"BUName":"Pacific","BranchId":122,"BranchName":"San Leandro"}','BUGM',NULL,NULL,23027,null,0,null)
insert into person.userprofile 
values( 'Bugtes002',3,8,122,690,1634,'Test','BUGM2','','','60019153',1)
insert into person.spuserprofile 
values( 'Bugtes002','{"AreaId":,"AreaName":"","BUId":3,"BUName":"Pacific","BranchId":122,"BranchName":"San Leandro"}','BUGM',NULL,NULL,23027,null,0,null)


--DM
insert into person.userprofile 
values( 'dmtes001',3,8,122,690,1634,'Test','DM1','','','60019153',1)
insert into person.spuserprofile 
values( 'dmtes001','{"AreaId":,"AreaName":"","BUId":3,"BUName":"Pacific","BranchId":122,"BranchName":"San Leandro"}','DM',NULL,NULL,23038,null,0,null)
insert into person.userprofile 
values( 'dmtes002',3,8,122,690,1634,'Test','DM2','','','60019153',1)
insert into person.spuserprofile 
values( 'dmtes002','{"AreaId":,"AreaName":"","BUId":3,"BUName":"Pacific","BranchId":122,"BranchName":"San Leandro"}','DM',NULL,NULL,23038,null,0,null)

--MDM
insert into person.userprofile 
values( 'mdmts001',3,8,122,690,1634,'Test','DM1','','','60019153',1)
insert into person.spuserprofile 
values( 'mdmts001','{"AreaId":,"AreaName":"","BUId":3,"BUName":"Pacific","BranchId":122,"BranchName":"San Leandro"}','DM',NULL,NULL,23038,null,0,null)
insert into person.userprofile 
values( 'mdmts002',3,8,122,690,1634,'Test','DM2','','','60019153',1)
insert into person.spuserprofile 
values( 'mdmts002','{"AreaId":,"AreaName":"","BUId":3,"BUName":"Pacific","BranchId":122,"BranchName":"San Leandro"}','DM',NULL,NULL,23038,null,0,null)



--select * from person.spuserprofile where gsn in( 'garkx001','TESBM001')
--Select * from person.Role

--select a.* from Person.spUserProfile a 
--inner join person.UserProfile b on a.gsn=b.GSN
--where b.ManualSetup =1

