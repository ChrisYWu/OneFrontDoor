USE [Portal_Data]
GO

If Exists (Select * From sys.objects Where object_id = object_id('[Settings].[pGetExtendedRightByApplicationAndRole]'))
Begin
	DROP Proc [Settings].[pGetExtendedRightByApplicationAndRole]
End
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Test Bench
2031	Test Role 1
2037	Test Role 3

exec Settings.pGetExtendedRightByApplicationAndRole @applicationID = 1043, @PortalRoleID = 2031

exec Settings.pGetExtendedRightByApplicationAndRole @applicationID = 1043, @PortalRoleID = 2037

select * 
from settings.roleright r 
join settings.applicationright ar on r.rightid = ar.rightid
where portalroleid =  2037
and applicationid = 1043

select *
from shared.application


exec Settings.pGetExtendedRightByApplicationAndRole @applicationID = 1, @PortalRoleID = 2031

select ar.rightid, rightname 
from settings.roleright rr
join settings.applicationright ar on rr.rightid = ar.rightid 
where portalroleid = 11

select * from shared.application

select * from settings.applicationright where applicationid = 1043

select * from settings.Portalrole

select * from settings.roleright where rolerightid = 37

select * from settings.applicationright where rightid = 2158

select * from settings.rolerighttrace where portalroleid = 11 order by lastmodified desc

select top 10 * from shared.exceptionlog order by exceptionlogid desc

*/

Create Proc [Settings].[pGetExtendedRightByApplicationAndRole]
(
	@ApplicationID int,
	@PortalRoleID int
)
As
	Select ar.RightID, ParentRightID, 
		rr.RoleRightID, 
		RightName, 
		InvariantName, 
		MetaDataID, ar.MetaDataTypeID, MetaDataName, mdt.DataType, mdt.ValueAs, mdt.ControlContrainer, mdt.MultiValue, mdt.AssociatedControl,
		Convert(bit, (Case When rr.PortalRoleID = @PortalRoleID then 1 else 0 end)) Selected,
		Convert(bit, (Case When MetaDataID is null then 0 else 1 end)) ShouldConfigure,
		Convert(bit, (Case When Temp.ValueID is null then 0 else 1 end)) Configured
	From Settings.vExtendedApplicationRight ar
	Left Join Settings.MetaDataType mdt On mdt.MetaDataTypeID = ar.MetaDataTypeID
	Left Join Settings.RoleRight rr on ar.RightID = rr.RightID and rr.PortalRoleID = @PortalRoleID
	Left Join (Select RoleRightID, Max(ValueID) ValueID From Settings.RoleRightValue Group By RoleRightID) Temp on rr.RoleRightID = Temp.RoleRightID 
	Where ApplicationID = @ApplicationID
Go
