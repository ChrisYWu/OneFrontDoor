use Portal_Data
Go

Select 'Update SAP.TradeMark Set ProductLineID = ' + Convert(varchar, ProductLineID) + ' Where SAPTradeMarkID = ''' + SAPTradeMarkID + ''''
From SAP.TradeMark