use Portal_Data805
Go

If Exists(select * From sys.tables where object_id = object_id('BC.tBottlerState'))
Begin
	Drop Table BC.tBottlerState
End
Go

CREATE TABLE [BC].[tBottlerState](
	[BottlerID] [int] NOT NULL,
	[ServingStateID] [int] NOT NULL,
	LastModified DateTime2(7) not null
 CONSTRAINT [PK_tBottlerState] PRIMARY KEY CLUSTERED 
(
	[ServingStateID] ASC,
	[BottlerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

Merge BC.tBottlerState As t
Using (
	Select Distinct b.BottlerID, sr.StateRegionID ServingStateID
	From BC.BottlerAccountTradeMark bat
	Join BC.Bottler b on bat.BottlerID = b.BottlerID
	Join SAP.Account a on bat.AccountID = a.AccountID
	Join Shared.StateRegion sr on a.State = sr.RegionABRV
	Where a.CRMActive = 1
	And b.BCRegionID is not null
	And bat.TerritoryTypeID in (10, 11)
	And bat.ProductTypeID = 1
	) input
	on (t.BottlerID = input.BottlerID And t.ServingStateID = input.ServingStateID)
When Not Matched By Source
Then Delete
When Not Matched By Target
Then Insert Values(input.BottlerID, input.ServingStateID, SysDateTime());

Select *
From BC.tBottlerState 



