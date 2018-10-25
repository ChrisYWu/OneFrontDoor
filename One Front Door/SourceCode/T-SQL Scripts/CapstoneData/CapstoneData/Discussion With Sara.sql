use Portal_Data
Go

Select *
From [MSTR].[DimWDAmplifyCustHierarchy]
Go

--- Typical ShipTo/SoldTo in DSD world
Select Top 1000 *
From SAP.Account
Where Active is not null
Go

-------- VicePresidentID --------
Select *
From SAP.Account
Where AccountID in
(	Select Distinct VicePresidentID
	From [MSTR].[DimWDAmplifyCustHierarchy]
)
Go

