--- In 108 ---
use Portal_Data
Go

If Exists (Select * From sys.indexes Where Name = 'NCI_PromotionAccount_NationalChainID')
	Drop Index NCI_PromotionAccount_NationalChainID On [Playbook].[PromotionAccount]

CREATE NONCLUSTERED INDEX NCI_PromotionAccount_NationalChainID
ON [Playbook].[PromotionAccount] ([PromotionID])
INCLUDE ([NationalChainID])

If Exists (Select * From sys.indexes Where Name = 'NCI_PromotionAccount_RegionalChainID')
	Drop Index NCI_PromotionAccount_RegionalChainID On [Playbook].[PromotionAccount]

CREATE NONCLUSTERED INDEX NCI_PromotionAccount_RegionalChainID
ON [Playbook].[PromotionAccount] ([PromotionID])
INCLUDE ([RegionalChainID])

If Exists (Select * From sys.indexes Where Name = 'NCI_PromotionAccount_LocalChainID')
	Drop Index NCI_PromotionAccount_LocalChainID On [Playbook].[PromotionAccount]

CREATE NONCLUSTERED INDEX NCI_PromotionAccount_LocalChainID
ON [Playbook].[PromotionAccount] ([PromotionID])
INCLUDE ([LocalChainID])
Go

--------------------------
--------------------------
--------------------------
If Exists (
	Select *
	From Sys.Tables t 
	Join Sys.schemas s on t.schema_id = s.schema_id
	Where t.Name = 'ChainGroup' and s.name = 'Playbook')
Begin
	Drop Table Playbook.ChainGroupLocalChain
	Drop Table Playbook.ChainGroupRegionalChain
	Drop Table Playbook.ChainGroupNationalChain
	Drop Table Playbook.ChainGroup
End
Go

--------------------------
CREATE TABLE Playbook.ChainGroup(
	ChainGroupID int NOT NULL Identity,
	MSTRChainGroupID varchar(20) NOT NULL,
	ChainGroupName varchar(100) NOT NULL,
	ImageName varchar(100) NOT NULL,
	WebImageURL varchar(512) not null,
	MobileImageURL varchar(512) not null,
	Active bit not null,
	CoveredByNational bit,
	TrueRegional bit,
	IsAllOther bit null,
	CreatedDate SmallDateTime Not Null,
	CreateBy varchar(50) Not Null,
	ModifiedDate SmallDatetime Not Null,
	ModifiedBy varchar(50) Not Null,
 CONSTRAINT [PK_ChainGroup] PRIMARY KEY CLUSTERED 
(
	ChainGroupID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

Go

CREATE UNIQUE NONCLUSTERED INDEX [UNCI-ChainGroup-MSTRChainGroupID] ON Playbook.ChainGroup
(
	[MSTRChainGroupID] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

----------------------------------
Merge Playbook.ChainGroup cg
Using (
	Select ChainID, Count(*) Cnt, Min(Chain) Chain, Min(ImageName) ImageName
	From (
		Select Distinct ChainID, Chain, ImageName
		From [MSTR].[RevChainImages]) temp
	Group by ChainID) input
	On input.ChainID = cg.MSTRChainGroupID
When Not Matched By Target Then
	Insert (MSTRChainGroupID, ChainGroupName, ImageName, WebImageURL, MobileImageURL, Active, CreatedDate, CreateBy, ModifiedDate, ModifiedBy)
	Values (input.ChainID, input.Chain, input.ImageName, 
	'https://dpsg.cloud.microstrategy.com/MicroStrategy/images/DPSG/Amplify%20MyScores/' + ImageName,
	'https://dpsg.cloud.microstrategy.com/MicroStrategy/images/DPSG/Amplify%20MyScores/Mobile/' + ImageName,
	1, GetDate(), 'System', GetDate(), 'System')
When Not Matched By Source Then
	Update
	Set Active = 0, ModifiedDate = GetDate(), ModifiedBy = 'System'
When Matched And (Active = 0 Or cg.ChainGroupName <> input.Chain Or cg.ImageName <> input.ImageName) Then
	Update
	Set Active = 1, ModifiedDate = GetDate(), ModifiedBy = 'System',
	ChainGroupName = input.Chain,
	ImageName = input.ImageName,
	WebImageURL = 'https://dpsg.cloud.microstrategy.com/MicroStrategy/images/DPSG/Amplify%20MyScores/' + input.ImageName,
	MobileImageURL = 'https://dpsg.cloud.microstrategy.com/MicroStrategy/images/DPSG/Amplify%20MyScores/Mobile/' + input.ImageName;
Go

----------------------------------

----------------------------------
If Exists (
	Select *
	From Sys.Tables t 
	Join Sys.schemas s on t.schema_id = s.schema_id
	Where t.Name = 'ChainGroupLocalChain' and s.name = 'Playbook')
Begin
	Drop Table Playbook.ChainGroupLocalChain
End
Go

--------------------------
--------------------------
--------------------------
CREATE TABLE Playbook.ChainGroupLocalChain(
	LocalChainID int Not NULL,
	ChainGroupID int Not NULL,
	Active bit not null,
	CreatedDate SmallDateTime Not Null,
	CreateBy varchar(50) Not Null,
	ModifiedDate SmallDatetime Not Null,
	ModifiedBy varchar(50) Not Null,
 CONSTRAINT [PK_ChainGroupLocalChain] PRIMARY KEY CLUSTERED 
(
	LocalChainID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

Go

ALTER TABLE [Playbook].[ChainGroupLocalChain]  WITH CHECK ADD CONSTRAINT [FK_ChainGroupLocalChain_LocalChain] FOREIGN KEY([LocalChainID])
REFERENCES [SAP].[LocalChain] ([LocalChainID])
GO

ALTER TABLE [Playbook].[ChainGroupLocalChain]  WITH CHECK ADD CONSTRAINT [FK_ChainGroupLocalChain_ChainGroup] FOREIGN KEY([ChainGroupID])
REFERENCES PlayBook.ChainGroup (ChainGroupID)
GO

--------------------------
Merge Playbook.ChainGroupLocalChain cgm
Using (
	Select Distinct LocalChainID, ChainGroupID
	From MSTR.RevChainImages ri 
	Join Playbook.ChainGroup cg on ri.ChainID = cg.MSTRChainGroupID
	Where ChainID Like ('L%')) input
	On input.LocalChainID = cgm.LocalChainID And input.ChainGroupID = cgm.ChainGroupID
When Not Matched By Target Then
	Insert (LocalChainID, ChainGroupID, Active, CreatedDate, CreateBy, ModifiedDate, ModifiedBy)
	Values (input.LocalChainID, input.ChainGroupID, 
	1, GetDate(), 'System', GetDate(), 'System')
When Not Matched By Source Then
	Update
	Set Active = 0, ModifiedDate = GetDate(), ModifiedBy = 'System';
Go

--------------------------
--------------------------
If Exists (
	Select *
	From Sys.Tables t 
	Join Sys.schemas s on t.schema_id = s.schema_id
	Where t.Name = 'ChainGroupRegionalChain' and s.name = 'Playbook')
Begin
	Drop Table Playbook.ChainGroupRegionalChain
End
Go

CREATE TABLE Playbook.ChainGroupRegionalChain(
	RegionalChainID int Not NULL,
	ChainGroupID int Not NULL,
	Active bit not null,
	CreatedDate SmallDateTime Not Null,
	CreateBy varchar(50) Not Null,
	ModifiedDate SmallDatetime Not Null,
	ModifiedBy varchar(50) Not Null,
 CONSTRAINT [PK_ChainGroupRegionalChain] PRIMARY KEY CLUSTERED 
(
	RegionalChainID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

Go

ALTER TABLE [Playbook].[ChainGroupRegionalChain]  WITH CHECK ADD CONSTRAINT [FK_ChainGroupRegionalChain_RegionalChain] FOREIGN KEY([RegionalChainID])
REFERENCES [SAP].[RegionalChain] ([RegionalChainID])
GO

ALTER TABLE [Playbook].[ChainGroupRegionalChain]  WITH CHECK ADD CONSTRAINT [FK_ChainGroupRegionalChain_ChainGroup] FOREIGN KEY([ChainGroupID])
REFERENCES PlayBook.ChainGroup (ChainGroupID)
GO

--------------------------
Merge Playbook.ChainGroupRegionalChain cgm
Using (
	Select Distinct RegionalChainID, ChainGroupID
	From MSTR.RevChainImages ri 
	Join Playbook.ChainGroup cg on ri.ChainID = cg.MSTRChainGroupID
	Where ChainID Like ('R%')) input
	On input.RegionalChainID = cgm.RegionalChainID And input.ChainGroupID = cgm.ChainGroupID
When Not Matched By Target Then
	Insert (RegionalChainID, ChainGroupID, Active, CreatedDate, CreateBy, ModifiedDate, ModifiedBy)
	Values (input.RegionalChainID, input.ChainGroupID, 
	1, GetDate(), 'System', GetDate(), 'System')
When Not Matched By Source Then
	Update
	Set Active = 0, ModifiedDate = GetDate(), ModifiedBy = 'System';
Go


--------------------------
--------------------------
If Exists (
	Select *
	From Sys.Tables t 
	Join Sys.schemas s on t.schema_id = s.schema_id
	Where t.Name = 'ChainGroupNationalChain' and s.name = 'Playbook')
Begin
	Drop Table Playbook.ChainGroupNationalChain
End
Go

CREATE TABLE Playbook.ChainGroupNationalChain(
	NationalChainID int Not NULL,
	ChainGroupID int Not NULL,
	Active bit not null,
	CreatedDate SmallDateTime Not Null,
	CreateBy varchar(50) Not Null,
	ModifiedDate SmallDatetime Not Null,
	ModifiedBy varchar(50) Not Null,
 CONSTRAINT [PK_ChainGroupNationalChain] PRIMARY KEY CLUSTERED 
(
	NationalChainID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

Go

ALTER TABLE [Playbook].[ChainGroupNationalChain]  WITH CHECK ADD CONSTRAINT [FK_ChainGroupNationalChain_NationalChain] FOREIGN KEY([NationalChainID])
REFERENCES [SAP].[NationalChain] ([NationalChainID])
GO

ALTER TABLE [Playbook].[ChainGroupNationalChain]  WITH CHECK ADD CONSTRAINT [FK_ChainGroupNationalChain_ChainGroup] FOREIGN KEY([ChainGroupID])
REFERENCES PlayBook.ChainGroup (ChainGroupID)
GO

--------------------------
Merge Playbook.ChainGroupNationalChain cgm
Using (
	Select Distinct NationalChainID, ChainGroupID
	From MSTR.RevChainImages ri 
	Join Playbook.ChainGroup cg on ri.ChainID = cg.MSTRChainGroupID
	Where ChainID Like ('N%')) input
	On input.NationalChainID = cgm.NationalChainID And input.ChainGroupID = cgm.ChainGroupID
When Not Matched By Target Then
	Insert (NationalChainID, ChainGroupID, Active, CreatedDate, CreateBy, ModifiedDate, ModifiedBy)
	Values (input.NationalChainID, input.ChainGroupID, 
	1, GetDate(), 'System', GetDate(), 'System')
When Not Matched By Source Then
	Update
	Set Active = 0, ModifiedDate = GetDate(), ModifiedBy = 'System';
Go

Update Playbook.ChainGroup
Set IsAllOther = 0, CoveredByNational = 0, TrueRegional = 0

Update cg
Set IsAllOther = Case When NationalChainID = 62 And RegionalChainID = 242 Then 1 Else 0 End,
	TrueRegional = Case When NationalChainID = 62 And RegionalChainID <> 242 Then 1 Else 0 End,
	CoveredByNational = Case When NationalChainID <> 62 Then 1 Else 0 End
From Playbook.ChainGroup cg
Join (Select Distinct LocalChainID, ChainID ChainGroupID From MSTR.RevChainImages Where ChainID like 'L%') l on cg.ChainGroupID = l.ChainGroupID
Join PreCal.ChainHier s on l.LocalChainID = s.LocalChainID
Go

Update cg
Set 
	TrueRegional = Case When NationalChainID = 62 Then 1 Else 0 End,
	CoveredByNational = Case When NationalChainID <> 62 Then 1 Else 0 End
From Playbook.ChainGroup cg
Join (Select Distinct RegionalChainID, ChainID ChainGroupID From MSTR.RevChainImages Where ChainID like 'R%') l on cg.ChainGroupID = l.ChainGroupID
Join SAP.RegionalChain s on l.RegionalChainID = s.RegionalChainID
Go

Update cg
Set CoveredByNational = 1
From Playbook.ChainGroup cg
Join (Select Distinct NationalChainID, ChainID ChainGroupID From MSTR.RevChainImages Where ChainID like 'N%') l on cg.ChainGroupID = l.ChainGroupID
Go

--- Expect to See nothing ----
Select 'Expect to See nothing'
Select ChainGroupID, Sum(Convert(int, TrueRegional) + Convert(int, IsAllOther) + Convert(int, CoveredByNational))
From Playbook.ChainGroup cg
Group By ChainGroupID
Having Sum(Convert(int, TrueRegional) + Convert(int, IsAllOther) + Convert(int, CoveredByNational)) > 1
Go

Select *
From Playbook.RetailPromotion
Where PromotionID not in
(
Select pr.PromotionID, ChainGroupID, PromotionWeekStart, PromotionWeekEnd, [Rank]
From Playbook.PromotionRank pr
Join Playbook.PromotionAccount pa on pr.PromotionID = pa.PromotionID
Join Playbook.ChainGroupNationalChain nc on pa.NationalChainID = nc.NationalChainID 
Union
Select pr.PromotionID, ChainGroupID, PromotionWeekStart, PromotionWeekEnd, [Rank]
From Playbook.PromotionRank pr
Join Playbook.PromotionAccount pa on pr.PromotionID = pa.PromotionID
Join Playbook.ChainGroupRegionalChain nc on pa.RegionalChainID = nc.RegionalChainID
Union
Select pr.PromotionID, ChainGroupID, PromotionWeekStart, PromotionWeekEnd, [Rank]
From Playbook.PromotionRank pr
Join Playbook.PromotionAccount pa on pr.PromotionID = pa.PromotionID
Join Playbook.ChainGroupLocalChain nc on pa.LocalChainID = nc.LocalChainID
Order By pr.PromotionID, ChainGroupID
)
Select Count(*)
From Playbook.PromotionRank