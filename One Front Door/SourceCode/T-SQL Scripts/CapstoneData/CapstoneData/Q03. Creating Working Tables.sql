USE Portal_Data_INT
GO

If Not Exists (Select * From sys.schemas Where name = 'Processing')
Begin
	exec sp_executesql N'Create Schema Processing'
End
Go

--------- BCBottlerEBNodes --------------
------------------------------------------
If Exists (Select * From sys.tables where object_id = object_id('Processing.BCBottlerEBNodes'))
Begin
	Drop Table Processing.BCBottlerEBNodes
End
Go

CREATE TABLE Processing.[BCBottlerEBNodes](
	[NODE_ID] [nvarchar](20) NULL,
	[ROW_MOD_DT] [datetime2](7) NULL
) ON [PRIMARY]
GO


-----------------------------------------
If Exists (Select * From sys.tables where object_id = object_id('Processing.BottlerLEGLatestUpdatedDate'))
Begin
	Drop Table Processing.BottlerLEGLatestUpdatedDate
End
Go

CREATE TABLE Processing.BottlerLEGLatestUpdatedDate(
	[PARTNER] [nvarchar](10) NULL,
	[HIER_TYPE] [nvarchar](2) NULL,
	[LEG_COUNT] [int] NULL,
	[ROW_MOD_DT] [datetime2](7) NULL
) ON [PRIMARY]

GO

----------------------------------------
If Exists (Select * From Sys.views where object_id =  object_Id('Processing.BCvStoreERHSDM'))
Begin
	Drop View Processing.BCvStoreERHSDM
End
Go

-----------------------------------------
Create View Processing.BCvStoreERHSDM
As
Select l1.NODE_ID L1_NODE_ID, l1.NODE_DESC L1_NODE_DESC, 
	l2.NODE_ID L2_NODE_ID, l2.NODE_DESC L2_NODE_DESC, 
	l3.NODE_ID L3_NODE_ID, l3.NODE_DESC L3_NODE_DESC, 
	l4.NODE_ID L4_NODE_ID, l4.NODE_DESC L4_NODE_DESC
From Staging.BCStoreHier l1
Join Staging.BCStoreHier l2 On l2.PRNT_GUID = l1.NODE_GUID
Join Staging.BCStoreHier l3 On l3.PRNT_GUID = l2.NODE_GUID
Join Staging.BCStoreHier l4 On l4.PRNT_GUID = l3.NODE_GUID
Where l1.HIER_TYPE = 'ER'
And l2.HIER_TYPE = 'ER'
And l3.HIER_TYPE = 'ER'
And l4.HIER_TYPE = 'ER'
And GetDate() Between l1.NODE_VLD_FRM_DT And l1.NODE_VLD_TO_DT 
And GetDate() Between l2.NODE_VLD_FRM_DT And l2.NODE_VLD_TO_DT 
And GetDate() Between l3.NODE_VLD_FRM_DT And l3.NODE_VLD_TO_DT 
And GetDate() Between l4.NODE_VLD_FRM_DT And l4.NODE_VLD_TO_DT 
And l1.DEL_FLG <> 'Y'
And l2.DEL_FLG <> 'Y'
And l3.DEL_FLG <> 'Y'
And l4.DEL_FLG <> 'Y'
Go

-----------------------------------------
If Exists (Select * From Sys.tables where object_id =  object_Id('Processing.BCChainLastModified'))
Begin
	Drop Table Processing.BCChainLastModified
End
Go

CREATE TABLE [Processing].BCChainLastModified(
	[NODE_ID] [nvarchar](32) NOT NULL,
	[ROW_MOD_DT] [datetime2](7) NULL
) ON [PRIMARY]

GO


