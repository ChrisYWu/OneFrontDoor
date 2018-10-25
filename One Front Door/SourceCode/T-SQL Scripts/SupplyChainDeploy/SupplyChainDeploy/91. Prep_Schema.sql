use Portal_Data
Go

If Not Exists (Select * From sys.schemas Where Name = 'Apacheta')
Begin
	Execute	sp_executesql N'Create Schema Apacheta'
End
Go

If Not Exists (Select * From sys.schemas Where Name = 'RSSC')
Begin
	Execute	sp_executesql N'Create Schema RSSC'
End
Go

If Not Exists (Select * From sys.schemas Where Name = 'SupplyChain')
Begin
	Execute	sp_executesql N'Create Schema SupplyChain'
End
Go

