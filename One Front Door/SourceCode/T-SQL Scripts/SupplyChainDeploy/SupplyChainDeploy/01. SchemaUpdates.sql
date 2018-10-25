Use Portal_Data
Go

Alter Table SAP.Material
Add SAPMaterialNumber 
As Case When ISNUMERIC(SAPMaterialID) = 1 Then replace(str(SAPMaterialID,18),' ','0') Else SAPMaterialID End 
Go

If Not Exists (Select * From sys.columns Where object_id = OBJECT_ID('SAP.Branch'))
Begin
	Alter Table SAP.Branch
	Add SAPPlantID As Right(RMLocationID, 4)
End
Go

---------------------------------------
---------------------------------------
Alter Table SAP.Material
Add ActiveInRM bit Default 0 Not Null
Go

Alter Table SAP.Material
Add RMStatusSetDate datetime2(7) Default SysDateTime() Not Null
Go

---- Reset ------
Update SAP.Material
Set ActiveInRM = 0, RMStatusSetDate = SYSDATETIME()
Where MaterialID not in 
(
	Select Distinct MaterialID
	From SAP.BranchMaterial
)

---- Set ------
Update SAP.Material
Set ActiveInRM = 1, RMStatusSetDate = SYSDATETIME()
Where MaterialID In 
(
	Select Distinct MaterialID
	From SAP.BranchMaterial
)
Go

-------------------------------
-------------------------------
Alter Table SAP.Brand
Add ActiveInRM bit Default 0 Not Null
Go

Alter Table SAP.Brand
Add RMStatusSetDate datetime2(7) Default SysDateTime() Not Null
Go

--- Reset ---
Update b
Set ActiveInRM = 0, RMStatusSetDate = SYSDATETIME()
From SAP.Material m
Join SAP.Brand b on m.BrandID = b.BrandID
Where m.ActiveInRM = 0

--- Set ---
Update b
Set ActiveInRM = 1, RMStatusSetDate = SYSDATETIME()
From SAP.Material m
Join SAP.Brand b on m.BrandID = b.BrandID
Where m.ActiveInRM = 1
Go

Alter Table SAP.TradeMark
Add ActiveInRM bit Default 0 Not Null
Go

Alter Table SAP.TradeMark
Add RMStatusSetDate datetime2(7) Default SysDateTime() Not Null
Go

--- Reset ---
Update t
Set ActiveInRM = 0, RMStatusSetDate = SYSDATETIME()
From SAP.Brand b 
Join SAP.TradeMark t on b.TrademarkID = t.TrademarkID
Where b.ActiveInRM = 0

--- Set ---
Update t
Set ActiveInRM = 1, RMStatusSetDate = SYSDATETIME()
From SAP.Brand b 
Join SAP.TradeMark t on b.TrademarkID = t.TrademarkID
Where b.ActiveInRM = 1
Go
---------------------------------------
--------Verification ------------------

