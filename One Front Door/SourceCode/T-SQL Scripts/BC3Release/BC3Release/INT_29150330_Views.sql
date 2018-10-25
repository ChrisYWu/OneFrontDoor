use Portal_Data_INT
Go

Create View BCMyDay.vSystemCompetition
As
Select s.BCNodeID, s.SystemName, b.ExternalBrandName, t.ExternalTradeMarkName, m.TradeMarkID, m.TradeMarkName
From BCMyday.SystemCompetitionBrand c
Join BC.System s on c.SystemID = s.SystemID
Join BCMyday.SystemBrand b on c.SystemBrandID = b.SystemBrandID
Join BCMyday.SystemTradeMark t on b.SystemTradeMarkID = t.SystemTradeMarkID
Left Join SAP.TradeMark m on c.TradeMarkID = m.TradeMarkID
Go
