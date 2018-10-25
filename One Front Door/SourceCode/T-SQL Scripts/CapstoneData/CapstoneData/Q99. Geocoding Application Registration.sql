USE Portal_Data_INT
GO

----------------------------------
SET IDENTITY_INSERT Shared.Application ON 
GO
If Exists (Select * From Shared.Application Where ApplicationName = 'Google GeoCoder Console Application')
Begin
	Delete From Shared.Application Where ApplicationName = 'Google GeoCoder Console Application'
End
Go

INSERT Shared.Application (ApplicationID, ApplicationName, InvariantName, Description, SiteURL, BuiltInApplication, CreatedBy, LastModifiedBy, LastModified, Active) 
VALUES (3000, N'Google GeoCoder Console Application', N'Google GeoCoder Console Application', N'Google GeoCoder Console Application fetches new addresses or updated addresses for both Bottlers and Capstone Stores and call out to Google Geo Service via HTTP web request and get the lat/long(Geocoding) back, then save it back to database(SDM). There is no right associated with this application. The entry here is just for registration and exception logging. ', N'', 1, N'System', N'System', CAST(0xA2ED039A AS SmallDateTime), 1)
GO
SET IDENTITY_INSERT Shared.Application OFF
GO
----------------------------------

SET IDENTITY_INSERT Shared.ExceptionSeverity ON 
GO
If Exists (Select * From Shared.ExceptionSeverity Where SeverityName = 'Infomation')
Begin
	Delete From Shared.ExceptionSeverity Where SeverityName = 'Infomation'
End
Go
INSERT Shared.ExceptionSeverity (SeverityID, SeverityName, Description) VALUES (3, N'Infomation', N'General Inforamtion')
GO
SET IDENTITY_INSERT Shared.ExceptionSeverity OFF
GO

