use Portal_Data
Go

--Persona Creation
SET IDENTITY_INSERT [Settings].[Persona] ON 
 
GO
INSERT [Settings].[Persona] ([PersonaID], [PersonaName], [IsIncludeForComboRole]) VALUES (6, N'SC', 1)
GO
SET IDENTITY_INSERT [Settings].[Persona] OFF
GO


---- Role Creation
Print 'Role Creation Started'
	Insert into Settings.PortalRole 
	Values ('SC Plant Manager', 'SC Plant Manager', 'SCPM', 'Supply Chain Plant Manager',0,1,'',1,1,null,'http://splashnet.dpsg.net/Pages/home.aspx','KAVSX001', 'KAVSX001',GETDATE(),'',6)

	Insert into Settings.PortalRole 
	Values ('Supply chain Inventory', 'Supply chain Inventory', 'SCI', 'Supply chain Inventory',0,1,'',1,1,null,'http://splashnet.dpsg.net/SCDashboards/Pages/DSDInventoryHome.aspx','KAVSX001', 'KAVSX001',GETDATE(),'',6)
Print 'Role Creation Ended'
--AppliCation Creation
Print 'Application Creation Started'
	--Begin Transaction ABCDEF
	Insert into Shared.Application 
	Values ('SC Manufacturing', 'SC Manufacturing', 'This application will control the access to Supply Chain Manufacturing application','',0,'KAVSX001','KAVSX001', GETDATE(),1 )

	Insert into Shared.Application 
	Values ('SC Inventory', 'SC Inventory', 'This application will control the access to Supply Chain Invemtory application','',0,'KAVSX001','KAVSX001', GETDATE(),1 )

	--Select * from Shared.Application Order By ApplicationID desc
	--Commit Transaction ABCDEF
Print 'Application Creation Ended'
--AppliCation Rights Creation
Print 'Application Rights Creation Started'
	--Begin Transaction ABCDEF
	Insert into Settings.ApplicationRight 
	Values ((Select top 1 ApplicationId from Shared.Application Where InvariantName = 'SC Manufacturing'), 'All Rights', 'All Rights','Created by System as a builtin right',1,null,'KAVSX001','KAVSX001', GETDATE(),1 )
	Insert into Settings.ApplicationRight 
	Values ((Select top 1 ApplicationId from Shared.Application Where InvariantName = 'SC Manufacturing'), 'Generic', NEWID(),'Created by System as a builtin right',1,(Select RightID from Settings.ApplicationRight Where ApplicationID in (Select top 1 ApplicationId from Shared.Application Where ApplicationName = 'SC Manufacturing') And RightName='All Rights'),'KAVSX001','KAVSX001', GETDATE(),1 )
	Insert into Settings.ApplicationRight 
	Values ((Select top 1 ApplicationId from Shared.Application Where InvariantName = 'SC Manufacturing'), 'View Operations', 'View Operations','Thsi right will let users to view the Supply chain Manufacturing Operations control',0,(Select RightID from Settings.ApplicationRight Where ApplicationID in (Select top 1 ApplicationId from Shared.Application Where InvariantName = 'SC Manufacturing') And RightName='All Rights'),'KAVSX001','KAVSX001', GETDATE(),1 )

	Insert into Settings.ApplicationRight 
	Values ((Select top 1 ApplicationId from Shared.Application Where InvariantName = 'SC Inventory'), 'All Rights', 'All Rights','Created by System as a builtin right',1,null,'KAVSX001','KAVSX001', GETDATE(),1 )
	Insert into Settings.ApplicationRight 
	Values ((Select top 1 ApplicationId from Shared.Application Where InvariantName = 'SC Inventory'), 'Generic', NEWID(),'Created by System as a builtin right',1,(Select RightID from Settings.ApplicationRight Where ApplicationID in (Select top 1 ApplicationId from Shared.Application Where ApplicationName = 'SC Inventory') And RightName='All Rights'),'KAVSX001','KAVSX001', GETDATE(),1 )
	Insert into Settings.ApplicationRight 
	Values ((Select top 1 ApplicationId from Shared.Application Where InvariantName = 'SC Inventory'), 'View Operations', 'View Operations','Thsi right will let users to view the Supply chain Inventory Operations and Data controls',0,(Select RightID from Settings.ApplicationRight Where ApplicationID in (Select top 1 ApplicationId from Shared.Application Where InvariantName = 'SC Inventory') And RightName='All Rights'),'KAVSX001','KAVSX001', GETDATE(),1 )

	--Select * from Settings.ApplicationRight 
	--Where RightID > 1226 
	--Order By RightID desc
	--Rollback Transaction ABCDEF
Print 'Application Rights Creation Ended'
---Behavior Creation
Print 'Behavior Creation Started'
	---Begin Transaction ABCDEF
	Insert into Settings.Behavior
	Values ('SC Manufacturing Reports','SC Manufacturing Reports','This behavior is a place holder for all the SSRS report url''s for Supply Chain Manufacturing', 10, 0, 'KAVSX001', 'KAVSX001',GETDATE(),1)

	Insert into Settings.Behavior
	Values ('SC Inventory Reports','SC Inventory Reports','This behavior is a place holder for all the SSRS report url''s for Supply Chain Inventory', 10, 0, 'KAVSX001', 'KAVSX001',GETDATE(),1)

	--Select * from Settings.Behavior order by BehaviorID desc
	--Rollback Transaction ABCDEF
Print 'Behavior Creation Ended'
--Behavior Details Creation
Print 'Behavior Member Creation Started'
	
	Insert into Settings.BehaviorMember
	Values ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'Preferences'),'Plants','Plants','Used to display the Planst that are used for Supply Chain',(Select Max(Precedence) + 1 from settings.BehaviorMember Where BehaviorID in ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'Preferences'))),'','KAVSX001','KAVSX001',getdate(),1)

	Insert into Settings.BehaviorMember
	Values ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'Preferences'),'Product Line','Product Line','Inventory product line tab.',(Select Max(Precedence) + 1 from settings.BehaviorMember Where BehaviorID in ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'Preferences'))),'','KAVSX001','KAVSX001',getdate(),1)

	Insert into Settings.BehaviorMember
	Values ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'My Preferences My Settings'),'Manufacturing','Manufacturing','My settings tab manufacutring settings',(Select Max(Precedence) + 1 from settings.BehaviorMember Where BehaviorID in ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'My Preferences My Settings'))),'','KAVSX001','KAVSX001',getdate(),1)
	
	Insert into Settings.BehaviorMember
	Values ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'My Preferences My Settings'),'Inventory Settings','Inventory Settings','My settings tab inventory settings',(Select Max(Precedence) + 1 from settings.BehaviorMember Where BehaviorID in ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'My Preferences My Settings'))),'','KAVSX001','KAVSX001',getdate(),1)
	

	Insert into Settings.BehaviorMember
	Values ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Manufacturing Reports'),'TME Single Branch','TME Single Branch','TME Report URL for Individual Branch',1,'http://splashnet.dpsg.net/scdashboards/_layouts/ReportServer/RSViewerPage.aspx?rv:RelativeReportUrl=/scdashboards/Reports/TMEForMultiPlants.rdl&rv:ParamMode=Hidden&rv:Toolbar=Full&rv:HeaderArea=None{0}&rp:D={1}&rv:toolbaritemsdisplaymode=154','KAVSX001','KAVSX001',getdate(),1)

	Insert into Settings.BehaviorMember
	Values ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Manufacturing Reports'),'TME Multiple Branch','TME Multiple Branch','TME Report URL for Multiple Branch',(Select Max(Precedence) + 1 from settings.BehaviorMember Where BehaviorID in ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Manufacturing Reports'))),'http://splashnet.dpsg.net/scdashboards/_layouts/ReportServer/RSViewerPage.aspx?rv:RelativeReportUrl=/scdashboards/Reports/TMEForMultiPlants.rdl&rv:ParamMode=Hidden&rv:Toolbar=Full&rv:HeaderArea=None{0}&rp:D={1}&rv:toolbaritemsdisplaymode=154','KAVSX001','KAVSX001',getdate(),1)

	Insert into Settings.BehaviorMember
	Values ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Manufacturing Reports'),'AFCO Single Branch','AFCO Single Branch','AFCO Report URL for Individual Branch',(Select Max(Precedence) + 1 from settings.BehaviorMember Where BehaviorID in ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Manufacturing Reports'))),'http://splashnet.dpsg.net/scdashboards/_layouts/ReportServer/RSViewerPage.aspx?rv:RelativeReportUrl=/scdashboards/Reports/AFCOMulti.rdl&rv:ParamMode=Hidden&rv:Toolbar=Full&rv:HeaderArea=None{0}&rp:D={1}&rv:toolbaritemsdisplaymode=154','KAVSX001','KAVSX001',getdate(),1)

	Insert into Settings.BehaviorMember
	Values ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Manufacturing Reports'),'AFCO Multiple Branch','AFCO Multiple Branch','AFCO Report URL for Multiple Branch',(Select Max(Precedence) + 1 from settings.BehaviorMember Where BehaviorID in ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Manufacturing Reports'))),'http://splashnet.dpsg.net/scdashboards/_layouts/ReportServer/RSViewerPage.aspx?rv:RelativeReportUrl=/scdashboards/Reports/AFCOMulti.rdl&rv:ParamMode=Hidden&rv:Toolbar=Full&rv:HeaderArea=None{0}&rp:D={1}&rv:toolbaritemsdisplaymode=154','KAVSX001','KAVSX001',getdate(),1)
	
	Insert into Settings.BehaviorMember
	Values ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Manufacturing Reports'),'Recordable Single Branch','Recordable Single Branch','Recordable Report URL for Individual Branch',(Select Max(Precedence) + 1 from settings.BehaviorMember Where BehaviorID in ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Manufacturing Reports'))),'http://splashnet.dpsg.net/scdashboards/_layouts/ReportServer/RSViewerPage.aspx?rv:RelativeReportUrl=/scdashboards/Reports/AFCOMulti.rdl&rv:ParamMode=Hidden&rv:Toolbar=Full&rv:HeaderArea=None{0}&rp:D={1}&rv:toolbaritemsdisplaymode=154','KAVSX001','KAVSX001',getdate(),1)

	Insert into Settings.BehaviorMember
	Values ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Manufacturing Reports'),'Recordable Multiple Branch','Recordable Multiple Branch','Recordable Report URL for Multiple Branch',(Select Max(Precedence) + 1 from settings.BehaviorMember Where BehaviorID in ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Manufacturing Reports'))),'http://splashnet.dpsg.net/scdashboards/_layouts/ReportServer/RSViewerPage.aspx?rv:RelativeReportUrl=/scdashboards/Reports/AFCOMulti.rdl&rv:ParamMode=Hidden&rv:Toolbar=Full&rv:HeaderArea=None{0}&rp:D={1}&rv:toolbaritemsdisplaymode=154','KAVSX001','KAVSX001',getdate(),1)
	
	Insert into Settings.BehaviorMember
	Values ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Manufacturing Reports'),'Inventory Cases Single Branch','Inventory Cases Single Branch','Inventory Cases Report URL for Individual Branch',(Select Max(Precedence) + 1 from settings.BehaviorMember Where BehaviorID in ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Manufacturing Reports'))),'http://splashnet.dpsg.net/scdashboards/_layouts/ReportServer/RSViewerPage.aspx?rv:RelativeReportUrl=/scdashboards/Reports/MfgPlantInventoryMulti.rdl&rv:ParamMode=Hidden&rv:Toolbar=Full&rv:HeaderArea=None{0}&rp:D={1}&rv:toolbaritemsdisplaymode=154','KAVSX001','KAVSX001',getdate(),1)

	Insert into Settings.BehaviorMember
	Values ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Manufacturing Reports'),'Inventory Cases Multiple Branch','Inventory Cases Multiple Branch','Inventory Cases Report URL for Multiple Branch',(Select Max(Precedence) + 1 from settings.BehaviorMember Where BehaviorID in ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Manufacturing Reports'))),'http://splashnet.dpsg.net/scdashboards/_layouts/ReportServer/RSViewerPage.aspx?rv:RelativeReportUrl=/scdashboards/Reports/MfgPlantInventoryMulti.rdl&rv:ParamMode=Hidden&rv:Toolbar=Full&rv:HeaderArea=None{0}&rp:D={1}&rv:toolbaritemsdisplaymode=154','KAVSX001','KAVSX001',getdate(),1)

	
	Insert into Settings.BehaviorMember
	Values ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Inventory Reports'),'OOS Multiple Branch','OOS Multiple Branch','OOS Report URL for Multiple Branch',1,'http://splashnet-qa.dpsg.net/scDashboards/_layouts/ReportServer/RSViewerPage.aspx?rv:RelativeReportUrl=/scDashboards/Reports/oosdetailsmulti.rdl&rv:ParamMode=Hidden&rv:Toolbar=Full&rv:HeaderArea=None{0}{1}{2}{3}&rv:toolbaritemsdisplaymode=154','KAVSX001','KAVSX001',getdate(),1)
	
	Insert into Settings.BehaviorMember
	Values ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Inventory Reports'),'DOS Multiple Branch','DOS Multiple Branch','DOS Report URL for Multiple Branch',(Select Max(Precedence) + 1 from settings.BehaviorMember Where BehaviorID in ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Inventory Reports'))),'http://splashnet-qa.dpsg.net/scDashboards/_layouts/ReportServer/RSViewerPage.aspx?rv:RelativeReportUrl=/scDashboards/Reports/dosdetailsmulti.rdl&rv:ParamMode=Hidden&rv:Toolbar=Full&rv:HeaderArea=None{0}{1}{2}{3}&rv:toolbaritemsdisplaymode=154','KAVSX001','KAVSX001',getdate(),1)

	Insert into Settings.BehaviorMember
	Values ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Inventory Reports'),'MinMax Multiple Branch','MinMax Multiple Branch','MinMax Report URL for Multiple Branch',(Select Max(Precedence) + 1 from settings.BehaviorMember Where BehaviorID in ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Inventory Reports'))),'http://splashnet-qa.dpsg.net/scDashboards/_layouts/ReportServer/RSViewerPage.aspx?rv:RelativeReportUrl=/scDashboards/Reports/minmaxdetailsmulti.rdl&rv:ParamMode=Hidden&rv:Toolbar=Full&rv:HeaderArea=None{0}{1}{2}{3}&rv:toolbaritemsdisplaymode=154','KAVSX001','KAVSX001',getdate(),1)


	Insert into Settings.BehaviorMember
	Values ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Inventory Reports'),'OOS Multiple Branch Trending','OOS Multiple Branch Trending','Used for Trend Chart For OOS',(Select Max(Precedence) + 1 from settings.BehaviorMember Where BehaviorID in ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Inventory Reports'))),'http://splashnet-qa.dpsg.net/scDashboards/_layouts/ReportServer/RSViewerPage.aspx?rv:RelativeReportUrl=/scDashboards/Reports/OOSSalesOfficesWeeklyTrend.rdl&rv:ParamMode=Hidden&rv:Toolbar=Full&rv:HeaderArea=None{0}{1}{2}{3}{4}&rv:toolbaritemsdisplaymode=154','KAVSX001','KAVSX001',getdate(),1)

	Insert into Settings.BehaviorMember
	Values ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Inventory Reports'),'DOS Multiple Branch Trending',	'DOS Multi Branch Trending',	'Used for Trend Chart For DOS',(Select Max(Precedence) + 1 from settings.BehaviorMember Where BehaviorID in ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Inventory Reports'))),'http://splashnet-qa.dpsg.net/scDashboards/_layouts/ReportServer/RSViewerPage.aspx?rv:RelativeReportUrl=/scDashboards/Reports/DOSSalesOfficesDailyTrend.rdl&rv:ParamMode=Hidden&rv:Toolbar=Full&rv:HeaderArea=None{0}{1}{2}{3}{4}&rv:toolbaritemsdisplaymode=154','KAVSX001','KAVSX001',getdate(),1)


	Insert into Settings.BehaviorMember
	Values ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Inventory Reports'),'MinMax Multiple Branch Trending','MinMax Multi Branch Trending','Used for Trend Chart For Min Max',(Select Max(Precedence) + 1 from settings.BehaviorMember Where BehaviorID in ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Inventory Reports'))),'http://splashnet-qa.dpsg.net/scDashboards/_layouts/ReportServer/RSViewerPage.aspx?rv:RelativeReportUrl=/scDashboards/Reports/MinMaxSalesOfficesDailyTrend.rdl&rv:ParamMode=Hidden&rv:Toolbar=Full&rv:HeaderArea=None{0}{1}{2}{3}{4}&rv:toolbaritemsdisplaymode=154','KAVSX001','KAVSX001',getdate(),1)

	Insert into Settings.BehaviorMember
	Values ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Inventory Reports'),'Potential OOS Report','Potential OOS Report','Used for Potential Orders',(Select Max(Precedence) + 1 from settings.BehaviorMember Where BehaviorID in ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Inventory Reports'))),'http://splashnet-qa.dpsg.net/scDashboards/_layouts/ReportServer/RSViewerPage.aspx?rv:RelativeReportUrl=/scDashboards/Reports/PotentialOOSDetailsMulti.rdl&rv:ParamMode=Hidden&rv:Toolbar=Full&rv:HeaderArea=None{0}{1}{2}{3}&rv:toolbaritemsdisplaymode=154','KAVSX001','KAVSX001',getdate(),1)

	Insert into Settings.BehaviorMember
	Values ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'Top Navigation Header'),'My Supply Chain','My Supply Chain','My Supply Chain',(Select Max(Precedence) + 1 from settings.BehaviorMember Where BehaviorID in ((Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'Top Navigation Header'))),'My Supply Chain','KAVSX001','KAVSX001',getdate(),1)

	--Select * from Settings.BehaviorMember Order by BehaviorMemberID desc
Print 'Behavior Member Creation Ended'
--Assign Application Right to Role
Print 'Application Right Assignation Started'
	Insert into Settings.RoleRight
	Values ((Select top 1 PortalRoleID from Settings.PortalRole Where InvariantName = 'SC Plant Manager'),(Select RightID from Settings.ApplicationRight Where ApplicationID in (Select top 1 ApplicationID from Shared.Application Where InvariantName = 'SC Manufacturing') And InvariantName='View Operations'),'KAVSX001',getdate())

	Insert into Settings.RoleRight
	Values ((Select top 1 PortalRoleID from Settings.PortalRole Where InvariantName = 'Supply chain Inventory'),(Select RightID from Settings.ApplicationRight Where ApplicationID in (Select top 1 ApplicationID from Shared.Application Where InvariantName = 'SC Inventory') And InvariantName='View Operations'),'KAVSX001',getdate()	)
Print 'Application Right Assignation Ended'
--Add to Role Right Trace Table
Print 'Application Right Trace Started'
	Insert into Settings.RoleRightTrace
	Values ((Select top 1 PortalRoleID from Settings.PortalRole Where InvariantName = 'SC Plant Manager'),(Select top 1 ApplicationID from Shared.Application Where InvariantName = 'SC Manufacturing'),'Insert','KAVSX001',getdate())

	Insert into Settings.RoleRightTrace
	Values ((Select top 1 PortalRoleID from Settings.PortalRole Where InvariantName = 'Supply chain Inventory'),(Select top 1 ApplicationID from Shared.Application Where InvariantName = 'SC Inventory'),'Insert','KAVSX001',getdate()	)
Print 'Application Right Trace Ended'
--Assign Behavior Member to Role
Print 'Behavior Assignation Started'

	Insert into Settings.RoleBehaviorMember
	Values((Select top 1 PortalRoleID from Settings.PortalRole Where InvariantName = 'SC Plant Manager'),(Select BehaviorMemberID from Settings.BehaviorMember Where BehaviorID in (Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'My Preferences') And MemberName = 'My Defaults'),'KAVSX001','KAVSX001',GETDATE()	)

	Insert into Settings.RoleBehaviorMember
	Values((Select top 1 PortalRoleID from Settings.PortalRole Where InvariantName = 'SC Plant Manager'),(Select BehaviorMemberID from Settings.BehaviorMember Where BehaviorID in (Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'My Preferences') And MemberName = 'My Settings'),'KAVSX001','KAVSX001',GETDATE()	)


	Insert into Settings.RoleBehaviorMember
	Values((Select top 1 PortalRoleID from Settings.PortalRole Where InvariantName = 'SC Plant Manager'),(Select BehaviorMemberID from Settings.BehaviorMember Where BehaviorID in (Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'Preferences') And MemberName = 'Plants'),'KAVSX001','KAVSX001',GETDATE()	)


	Insert into Settings.RoleBehaviorMember
	Values((Select top 1 PortalRoleID from Settings.PortalRole Where InvariantName = 'SC Plant Manager'),(Select BehaviorMemberID from Settings.BehaviorMember Where BehaviorID in (Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'My Preferences My Settings') And MemberName = 'Manufacturing'),'KAVSX001','KAVSX001',GETDATE()	)



	Insert into Settings.RoleBehaviorMember
	Values((Select top 1 PortalRoleID from Settings.PortalRole Where InvariantName = 'SC Plant Manager'),(Select BehaviorMemberID from Settings.BehaviorMember Where BehaviorID in (Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Manufacturing Reports') And MemberName = 'TME Single Branch'),'KAVSX001','KAVSX001',GETDATE()	)

	Insert into Settings.RoleBehaviorMember
	Values((Select top 1 PortalRoleID from Settings.PortalRole Where InvariantName = 'SC Plant Manager'),(Select BehaviorMemberID from Settings.BehaviorMember Where BehaviorID in (Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Manufacturing Reports') And MemberName = 'TME Multiple Branch'),'KAVSX001','KAVSX001',GETDATE()	)

	Insert into Settings.RoleBehaviorMember
	Values((Select top 1 PortalRoleID from Settings.PortalRole Where InvariantName = 'SC Plant Manager'),(Select BehaviorMemberID from Settings.BehaviorMember Where BehaviorID in (Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Manufacturing Reports') And MemberName = 'AFCO Single Branch'),'KAVSX001','KAVSX001',GETDATE()	)

	Insert into Settings.RoleBehaviorMember
	Values((Select top 1 PortalRoleID from Settings.PortalRole Where InvariantName = 'SC Plant Manager'),(Select BehaviorMemberID from Settings.BehaviorMember Where BehaviorID in (Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Manufacturing Reports') And MemberName = 'AFCO Multiple Branch'),'KAVSX001','KAVSX001',GETDATE()	)

	Insert into Settings.RoleBehaviorMember
	Values((Select top 1 PortalRoleID from Settings.PortalRole Where InvariantName = 'SC Plant Manager'),(Select BehaviorMemberID from Settings.BehaviorMember Where BehaviorID in (Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Manufacturing Reports') And MemberName = 'Inventory Cases Single Branch'),'KAVSX001','KAVSX001',GETDATE()	)

	Insert into Settings.RoleBehaviorMember
	Values((Select top 1 PortalRoleID from Settings.PortalRole Where InvariantName = 'SC Plant Manager'),(Select BehaviorMemberID from Settings.BehaviorMember Where BehaviorID in (Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Manufacturing Reports') And MemberName = 'Inventory Cases Multiple Branch'),'KAVSX001','KAVSX001',GETDATE()	)

	Insert into Settings.RoleBehaviorMember
	Values((Select top 1 PortalRoleID from Settings.PortalRole Where InvariantName = 'SC Plant Manager'),(Select BehaviorMemberID from Settings.BehaviorMember Where BehaviorID in (Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Manufacturing Reports') And MemberName = 'Recordable Single Branch'),'KAVSX001','KAVSX001',GETDATE()	)

	Insert into Settings.RoleBehaviorMember
	Values((Select top 1 PortalRoleID from Settings.PortalRole Where InvariantName = 'SC Plant Manager'),(Select BehaviorMemberID from Settings.BehaviorMember Where BehaviorID in (Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Manufacturing Reports') And MemberName = 'Recordable Multiple Branch'),'KAVSX001','KAVSX001',GETDATE()	)

	Insert into Settings.RoleBehaviorMember
	Values((Select top 1 PortalRoleID from Settings.PortalRole Where InvariantName = 'SC Plant Manager'),(Select BehaviorMemberID from Settings.BehaviorMember Where BehaviorID in (Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'Top Navigation Header') And MemberName = 'My Supply Chain'),'KAVSX001','KAVSX001',GETDATE()	)

	--- Supply Chain Inventory Role Behavior Assignation
	Insert into Settings.RoleBehaviorMember
	Values((Select top 1 PortalRoleID from Settings.PortalRole Where InvariantName = 'Supply chain Inventory'),(Select BehaviorMemberID from Settings.BehaviorMember Where BehaviorID in (Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'My Preferences') And MemberName = 'My Defaults'),'KAVSX001','KAVSX001',GETDATE()	)

	Insert into Settings.RoleBehaviorMember
	Values((Select top 1 PortalRoleID from Settings.PortalRole Where InvariantName = 'Supply chain Inventory'),(Select BehaviorMemberID from Settings.BehaviorMember Where BehaviorID in (Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'My Preferences') And MemberName = 'My Settings'),'KAVSX001','KAVSX001',GETDATE()	)

	
	
	Insert into Settings.RoleBehaviorMember
	Values((Select top 1 PortalRoleID from Settings.PortalRole Where InvariantName = 'Supply chain Inventory'),(Select BehaviorMemberID from Settings.BehaviorMember Where BehaviorID in (Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'Preferences') And MemberName = 'DSD Geography'),'KAVSX001','KAVSX001',GETDATE()	)


	Insert into Settings.RoleBehaviorMember
	Values((Select top 1 PortalRoleID from Settings.PortalRole Where InvariantName = 'Supply chain Inventory'),(Select BehaviorMemberID from Settings.BehaviorMember Where BehaviorID in (Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'Preferences') And MemberName = 'DSD Channel Dependent Account'),'KAVSX001','KAVSX001',GETDATE()	)

	Insert into Settings.RoleBehaviorMember
	Values((Select top 1 PortalRoleID from Settings.PortalRole Where InvariantName = 'Supply chain Inventory'),(Select BehaviorMemberID from Settings.BehaviorMember Where BehaviorID in (Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'Preferences') And MemberName = 'Product Line'),'KAVSX001','KAVSX001',GETDATE()	)


	
	Insert into Settings.RoleBehaviorMember
	Values((Select top 1 PortalRoleID from Settings.PortalRole Where InvariantName = 'Supply chain Inventory'),(Select BehaviorMemberID from Settings.BehaviorMember Where BehaviorID in (Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'My Preferences My Settings') And MemberName = 'Inventory Settings'),'KAVSX001','KAVSX001',GETDATE()	)


	Insert into Settings.RoleBehaviorMember
	Values((Select top 1 PortalRoleID from Settings.PortalRole Where InvariantName = 'Supply chain Inventory'),(Select BehaviorMemberID from Settings.BehaviorMember Where BehaviorID in (Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Inventory Reports') And MemberName = 'OOS Multiple Branch'),'KAVSX001','KAVSX001',GETDATE()	)

	Insert into Settings.RoleBehaviorMember
	Values((Select top 1 PortalRoleID from Settings.PortalRole Where InvariantName = 'Supply chain Inventory'),(Select BehaviorMemberID from Settings.BehaviorMember Where BehaviorID in (Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Inventory Reports') And MemberName = 'DOS Multiple Branch'),'KAVSX001','KAVSX001',GETDATE()	)

	Insert into Settings.RoleBehaviorMember
	Values((Select top 1 PortalRoleID from Settings.PortalRole Where InvariantName = 'Supply chain Inventory'),(Select BehaviorMemberID from Settings.BehaviorMember Where BehaviorID in (Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Inventory Reports') And MemberName = 'MinMax Multiple Branch'),'KAVSX001','KAVSX001',GETDATE()	)

	Insert into Settings.RoleBehaviorMember
	Values((Select top 1 PortalRoleID from Settings.PortalRole Where InvariantName = 'Supply chain Inventory'),(Select BehaviorMemberID from Settings.BehaviorMember Where BehaviorID in (Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Inventory Reports') And MemberName = 'Potential OOS Report'),'KAVSX001','KAVSX001',GETDATE()	)

	Insert into Settings.RoleBehaviorMember
	Values((Select top 1 PortalRoleID from Settings.PortalRole Where InvariantName = 'Supply chain Inventory'),(Select BehaviorMemberID from Settings.BehaviorMember Where BehaviorID in (Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'Top Navigation Header') And MemberName = 'My Supply Chain'),'KAVSX001','KAVSX001',GETDATE()	)

Print 'Behavior Assignation Ended'
--Add to Role Behavior Trace Table
Print 'Behavior Assignation Trace Started'
	Insert into Settings.RoleBehaviorTrace
	Values ((Select top 1 PortalRoleID from Settings.PortalRole Where InvariantName = 'SC Plant Manager'),(Select top 1 BehaviorID from Settings.Behavior Where BehavoirName = 'SC Manufacturing Reports'),'Insert','KAVSX001',getdate())
Print 'Behavior Assignation Trace Ended'

