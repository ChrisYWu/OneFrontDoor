use Portal_Data
Go

Update Shared.Application
Set Active = 0

Update Shared.Application
Set Active = 1
Where BuiltInApplication = 1

Update Settings.PortalRole
Set Active = 0

Update Settings.PortalRole
Set Active = 1
Where IsBuiltInRole = 1

----------------------------
/*
Update Shared.Application
Set Active = 1

Update Settings.PortalRole
Set Active = 1
*/