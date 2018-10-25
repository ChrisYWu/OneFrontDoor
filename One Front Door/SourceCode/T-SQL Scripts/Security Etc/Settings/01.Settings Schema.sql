Use Portal_Data
Go

---------------------------------------
---------------------------------------
If Not Exists (Select * From sys.schemas Where Name = 'Settings')
Begin
	Create Schema Settings
End
Go

If Not Exists (Select * From sys.schemas Where Name = 'Shared')
Begin
	Create Schema Shared
End
Go

If Not Exists (Select * From sys.schemas Where Name = 'NationalAccount')
Begin
	Create Schema NationalAccount
End
Go

---------------------------------------
---------------------------------------
Alter Table Person.UserProfile
Add OrgUnitID int
Go

ALTER TABLE Person.UserProfile  WITH CHECK ADD  CONSTRAINT [FK_UserProfile_OrgUnitID] FOREIGN KEY([OrgUnitID])
REFERENCES [Shared].[OrganizationUnit] ([OrgUnitID])
GO

ALTER TABLE Person.UserProfile CHECK CONSTRAINT [FK_UserProfile_OrgUnitID]
GO

Update up
Set up.OrgUnitID = ou.OrgUnitID
From Person.UserProfile up
Join Staging.ADExtractData ad on up.GSN = ad.UserID
Join Shared.OrganizationUnit ou on ad.OrgUnit = ou.OrgUnitName
Go

---------------------------------------
---------------------------------------
USE [Portal_Data]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [NationalAccount].[System](
	[SystemID] [int] IDENTITY(1,1) NOT NULL,
	[SystemName] [varchar](25) NOT NULL,
	[TermsetName] [varchar](50) NOT NULL,
	[PromotionCopyRule] [int] NULL,
	[PromotionGeoRelevancy] [varchar](50) NULL,
	[DefaultPromotionStatus] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[SystemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO

SET IDENTITY_INSERT [NationalAccount].[System] ON 
GO
INSERT [NationalAccount].[System] ([SystemID], [SystemName], [TermsetName], [PromotionCopyRule], [PromotionGeoRelevancy], [DefaultPromotionStatus]) VALUES (2, N'CASO', N'CASO', 1, NULL, 4)
GO
INSERT [NationalAccount].[System] ([SystemID], [SystemName], [TermsetName], [PromotionCopyRule], [PromotionGeoRelevancy], [DefaultPromotionStatus]) VALUES (3, N'PASO', N'PASO', 1, NULL, 4)
GO
INSERT [NationalAccount].[System] ([SystemID], [SystemName], [TermsetName], [PromotionCopyRule], [PromotionGeoRelevancy], [DefaultPromotionStatus]) VALUES (4, N'ISO', N'ISO', 1, NULL, 4)
GO
INSERT [NationalAccount].[System] ([SystemID], [SystemName], [TermsetName], [PromotionCopyRule], [PromotionGeoRelevancy], [DefaultPromotionStatus]) VALUES (5, N'WD', N'WD', 1, NULL, 4)
GO
INSERT [NationalAccount].[System] ([SystemID], [SystemName], [TermsetName], [PromotionCopyRule], [PromotionGeoRelevancy], [DefaultPromotionStatus]) VALUES (6, N'DSD', N'DSD', 1, N'BU', 1)
GO
SET IDENTITY_INSERT [NationalAccount].[System] OFF
GO





