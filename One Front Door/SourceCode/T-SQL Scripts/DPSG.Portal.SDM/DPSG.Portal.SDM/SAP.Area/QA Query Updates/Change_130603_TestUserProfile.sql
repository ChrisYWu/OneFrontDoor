-- Provided by Vijay on 6/3/2013 15:20am. 
-- For manually setup test user profiles
-- Executed on 6/3/2013 15:20am


use Portal_data
Go

begin tran


--deleting existing profile for test accounts
delete Person.UserBranchTradeMark where UserInBranchID in 
(select UserInBranchID from person.userinbranch where gsn  in('Tesbm001','Tesbm002','Tesad001','Tesad002','dmtes001',
'dmtes002','Bugtes001','Bugtes002','mddts001','mddts002','mdmts001','mdmts002','raets001','raets002'))
delete person.UserInBranch where gsn in('Tesbm001','Tesbm002','Tesad001','Tesad002','dmtes001',
'dmtes002','Bugtes001','Bugtes002','mddts001','mddts002','mdmts001','mdmts002','raets001','raets002')
delete person.UserInRole where gsn in('Tesbm001','Tesbm002','Tesad001','Tesad002','dmtes001',
'dmtes002','Bugtes001','Bugtes002','mddts001','mddts002','mdmts001','mdmts002','raets001','raets002')
delete person.SPUserProfile where gsn in('Tesbm001','Tesbm002','Tesad001','Tesad002','dmtes001',
'dmtes002','Bugtes001','Bugtes002','mddts001','mddts002','mdmts001','mdmts002','raets001','raets002')
delete person.UserProfile where gsn in('Tesbm001','Tesbm002','Tesad001','Tesad002','dmtes001',
'dmtes002','Bugtes001','Bugtes002','mddts001','mddts002','mdmts001','mdmts002','raets001','raets002')

declare @BUID numeric
declare @AreaID numeric 
declare @BranchId  numeric, @ProfitCenterID numeric, @costCenter numeric

select @BranchId = a.BranchID,  @AreaID = b.RegionID, @BUID = b.BUID
from sap.Branch a 
left join sap.Region b on a.RegionID = b.RegionID
where a.BranchName = 'San Leandro'



--BM
insert into person.userprofile 
values( 'TESBM001',@BUID,@AreaID,@BranchId,@ProfitCenterID,@costCenter,'Test','BM1','','','60019182',1, Null)
insert into person.userprofile 
values( 'TESBM002',@BUID,@AreaID,@BranchId,@ProfitCenterID,@costCenter,'Test','BM2','','','60019182',1, Null)

--AD
insert into person.userprofile 
values( 'Tesad001',@BUID,@AreaID,@BranchId,@ProfitCenterID,@costCenter,'Test','AD1','','','60019153',1, Null)
insert into person.userprofile 
values( 'Tesad002',@BUID,@AreaID,@BranchId,@ProfitCenterID,@costCenter,'Test','AD2','','','60019153',1, Null)

--MDD
insert into person.userprofile 
values( 'mddts001',@BUID,@AreaID,@BranchId,@ProfitCenterID,@costCenter,'Test','MDD1','','','60000567',1, Null)
insert into person.userprofile 
values( 'mddts002',@BUID,@AreaID,@BranchId,@ProfitCenterID,@costCenter,'Test','MDD2','','','60000567',1, Null)

--RAE
insert into person.userprofile 
values( 'raets001',@BUID,@AreaID,@BranchId,@ProfitCenterID,@costCenter,'Test','RAE1','','','60019669',1, Null)
insert into person.userprofile 
values( 'raets002',@BUID,@AreaID,@BranchId,@ProfitCenterID,@costCenter,'Test','RAE2','','','60019669',1, Null)

--BUGM
insert into person.userprofile 
values( 'Bugtes001',@BUID,@AreaID,@BranchId,@ProfitCenterID,@costCenter,'Test','BUGM1','','','60019652',1, Null)
insert into person.userprofile 
values( 'Bugtes002',@BUID,@AreaID,@BranchId,@ProfitCenterID,@costCenter,'Test','BUGM2','','','60019652',1, Null)

--DM
insert into person.userprofile 
values( 'dmtes001',@BUID,@AreaID,@BranchId,@ProfitCenterID,@costCenter,'Test','DM1','','','60019154',1, Null)
insert into person.userprofile 
values( 'dmtes002',@BUID,@AreaID,@BranchId,@ProfitCenterID,@costCenter,'Test','DM2','','','60019154',1, Null)

go


--SPUserProfile
INSERT into person.SPUserProfile(GSN, PrimaryBranch, PrimaryRole, RoleID)
select gsn,
'{"AreaId":'+ Convert(varchar, rg.RegionID, 15) +',"AreaName":"'+ rg.RegionName +'","BUId":' + convert(varchar, up.BUID)+ ',"BUName":"' +   bu.BUName + '","BranchId":' + convert(varchar, up.PrimaryBranchID) + ',"BranchName":"'+ br.BranchName +'","RegionId":'+ Convert(varchar, rg.RegionID, 15) +',"RegionName":"'+ rg.RegionName +'"}',
role.RoleName,role.RoleID
from person.UserProfile up
inner join sap.Branch br on up.PrimaryBranchID = br.BranchID
inner join sap.Region rg on rg.RegionID = br.RegionID
inner join sap.BusinessUnit bu on rg.BUID = bu.BUID
inner join person.job on job.SAPHRJobNumber = up.JobCode
inner join person.role on role.RoleID = job.RoleID
where gsn in('Tesbm001','Tesbm002','Tesad001','Tesad002','dmtes001',
'dmtes002','Bugtes001','Bugtes002','mddts001','mddts002','mdmts001','mdmts002','raets001','raets002')

--USer In Role
INSERT into person.UserInRole(GSN, RoleID, IsPrimary)
Select up1.GSN, role.RoleID, 1
From Person.userprofile up1 
join Person.Job job on job.SAPHRJobNumber = up1.JobCode
join Person.Role role on role.RoleID = job.RoleID
where gsn in('Tesbm001','Tesbm002','Tesad001','Tesad002','dmtes001',
'dmtes002','Bugtes001','Bugtes002','mddts001','mddts002','mdmts001','mdmts002','raets001','raets002')

--USer in Branch
INSERT into person.UserInBranch(GSN, BranchID, IsPrimary)
Select up1.GSN, up1.PrimaryBranchID,1
From Person.userprofile up1 
where gsn in('Tesbm001','Tesbm002','Tesad001','Tesad002','dmtes001',
'dmtes002','Bugtes001','Bugtes002','mddts001','mddts002','mdmts001','mdmts002','raets001','raets002')




commit tran