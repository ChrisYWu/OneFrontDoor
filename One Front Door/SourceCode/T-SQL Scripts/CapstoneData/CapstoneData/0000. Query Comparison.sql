use Portal_DataSRE
Go

----- SDM Raw data ----
Declare @StartTime DateTime
Set @StartTime  = GetDate()

Select 
bat.TradeMarkID, 
bat.AccountID, 
bat.ProductTypeID,
bat.TerritoryTypeID,
bat.BottlerID
From BC.BottlerAccountTradeMark bat
Where TerritoryTypeID = 12 
And ProductTypeID = 1
And BottlerID = 14872

Select DateDiff(millisecond, @StartTime, GetDate()) QueryTime_In_Millisecond_From_SDM
Go

---------- SDM(like for like) ------------
Declare @StartTime DateTime
Set @StartTime  = GetDate()

Select 
t.SAPTradeMarkID TRADEMARK_ID, 
bat.ProductTypeID PROD_TYPE, 
bat.TerritoryTypeID TERR_VIEW, 
b.BCBottlerID BTTLR_ID, 
a.SAPAccountNumber STR_ID
From BC.BottlerAccountTradeMark bat
Join BC.Bottler b on bat.BottlerID = b.BottlerID
Join SAP.TradeMark t on bat.TradeMarkID = t.TradeMarkID
Join SAP.Account a on bat.AccountID = a.AccountID
Where TerritoryTypeID = 12 
And ProductTypeID = 1
And b.BCBottlerID = 11310281
Order By SAPTradeMarkID, SAPAccountNumber, ProductTypeID, TerritoryTypeID, BCBottlerID

Select DateDiff(millisecond, @StartTime, GetDate()) QueryTime_In_Millisecond_From_SDM
Go

---- Capstone ----------------
Declare @StartTime DateTime
Set @StartTime  = GetDate()

Select * From OpenQuery(COP, 'SELECT 
D.TRADEMARK_ID, D.STR_ID, D.PROD_TYPE, 
D.TERR_VIEW, D.BTTLR_ID
FROM CAP_DM.DM_TERRITORY_STR D
WHERE SYSDATE BETWEEN D.VLD_FRM_DT AND D.VLD_TO_DT
AND TERR_VIEW = ''12''
AND PROD_TYPE = ''01''
AND BTTLR_ID = ''0011310281''' )

Select DateDiff(millisecond, @StartTime, GetDate()) QueryTime_In_Millisecond_From_COT
Go

