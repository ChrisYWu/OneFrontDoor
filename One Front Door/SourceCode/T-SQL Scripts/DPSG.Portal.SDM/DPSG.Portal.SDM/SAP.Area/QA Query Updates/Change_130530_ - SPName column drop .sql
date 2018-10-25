---- executed on 2013530 1518 
---- modifed on 21030605 1501

Use Portal_Data
Go

Alter Table SAP.Trademark
Drop Column SPTrademarkName
Go

Alter Table SAP.Brand
Drop Column SPBrandName
Go

Alter Table SAP.NationalChain
Drop Column SPNationalChainName
Go

Alter Table SAP.RegionalChain
Drop Column SPRegionalChainName
Go

Alter Table SAP.LocalChain
Drop Column SPLocalChainName
Go

Alter Table SAP.SuperChannel
Drop Column SPSuperChannelName
Go

Alter Table SAP.Channel
Drop Column SPChannelName
Go
