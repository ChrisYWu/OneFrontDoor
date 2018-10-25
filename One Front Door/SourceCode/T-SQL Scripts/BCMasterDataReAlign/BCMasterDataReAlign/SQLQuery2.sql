use Portal_Data
Go

Select c.SAPChannelID, a.StoreLastModified, a.CapstoneLastModified, a.*
From SAP.Account a
Join SAP.Channel c on a.ChannelID = c.ChannelID
Where SAPAccountNumber = 11903997


Select c.SAPChannelID, a.*
From SAP.Account a
Join SAP.Channel c on a.ChannelID = c.ChannelID
Where StoreLastModified > '2015-06-08'
