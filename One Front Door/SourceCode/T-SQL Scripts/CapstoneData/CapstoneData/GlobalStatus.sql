use Portal_DataSRE
Go

If Exists (Select * From Sys.Objects Where name = 'GlobalStatus' And Type = 'U')
	DROP TABLE BC.GlobalStatus
GO

CREATE TABLE BC.GlobalStatus(
	GlobalStatusID varchar(20) Primary Key NOT NULL,
	BCGlobalStatusID varchar(20) NOT NULL,
	StatusName varchar(50) NOT NULL
) ON [PRIMARY]
GO
Set NoCount On;

INSERT [BC].[GlobalStatus] ([GlobalStatusID], [BCGlobalStatusID], [StatusName]) VALUES ('01', '01', N'Draft')
GO
INSERT [BC].[GlobalStatus] ([GlobalStatusID], [BCGlobalStatusID], [StatusName]) VALUES ('02', '02', N'Active')
GO
INSERT [BC].[GlobalStatus] ([GlobalStatusID], [BCGlobalStatusID], [StatusName]) VALUES ('03', '03', N'Inactive')
GO
