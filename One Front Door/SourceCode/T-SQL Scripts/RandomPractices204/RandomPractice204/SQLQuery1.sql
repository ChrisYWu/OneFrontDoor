use Portal_Data805
Go

------------------------------------------------
If Exists (Select *
	From sys.schemas
	Where name = 'Precal')
Begin
	Execute('Create Schema PreCal')
End

--##############################################

------------------------------------------------
If Exists (
	Select *
	From Sys.Tables t Join sys.schemas s on t.schema_id = s.schema_id
	Where t.Name = 'PromotionBranch' and s.name = 'Playbook')
Begin
	Drop Table Playbook.PromotionBranch
End
Go

If Exists (
	Select *
	From Sys.Tables t Join sys.schemas s on t.schema_id = s.schema_id
	Where t.Name = 'PromotionBranch' and s.name = 'PreCal')
Begin
	Drop Table PreCal.PromotionBranch
End
Go

CREATE TABLE Playbook.PromotionBranch (
	[BranchID] [int] NOT NULL,
	[PromotionID] [int] NOT NULL,
	PromotionStartDate Date,
	PromotionEndDate Date,
 CONSTRAINT [PK_PromotionBranch100] PRIMARY KEY CLUSTERED 
(
	[BranchID] ASC,
	[PromotionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

Go

CREATE NONCLUSTERED INDEX [NCI-PromotionBranch-Dates] ON [Playbook].[PromotionBranch]
(
	[PromotionStartDate] ASC,
	[PromotionEndDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

--##############################################

------------------------------------------------

