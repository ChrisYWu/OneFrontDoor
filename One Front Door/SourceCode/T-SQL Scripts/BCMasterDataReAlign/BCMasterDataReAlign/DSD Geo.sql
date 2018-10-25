Use Portal_Data
Go

--Select a.SAPAccountNumber, a.AccountName, lc.SAPLocalChainID CRMLocalChainID, lc.LocalChainName, 
----c1.SAPChannelID OldChannel,
--c.SAPChannelID CRMChannel, 
--a.ChannelID SDMChannelID, 
--c.ChannelName, bwa.Local_Chain BP7LocalChain, bwa.CHANNEL BP7Channel, bwa.*
--From SAP.Account a
--Join SAP.LocalChain lc on a.LocalChainID = lc.LocalChainID
--Join SAP.Channel c on c.ChannelID = a.ChannelID
----Left Join SAP.Channel c1 on c1.ChannelID = a.ChannelID1
--Join Staging.BWAccount bwa on a.SAPAccountNumber = Customer_Number
----Where SAPAccountNumber in (11189893)--, 11194178)
--Order By SAPAccountNumber

Select a.SAPAccountNumber, a.AccountName, lc.SAPLocalChainID CRMLocalChainID, lc.LocalChainName CRMLocalChainName, 
c.SAPChannelID CRMChannel, c.ChannelName CRMChannelName, 
c1.SAPChannelID SDMStuckSAPChannelID, 
lc1.SAPLocalChainID SDMStuckSAPLocalChainID,
ad.SAPAccountNumber BWSAPAccountNumber, Convert(int, ad.SAPLocalChainID) BP7LocalChainID, ad.SAPChannelID BP7ChannelID
From SAP.Account a
Left Join SDM_Prod.Portal_Data.SAP.Account prod on a.SAPAccountNumber = prod.SAPAccountNumber
Left Join SAP.LocalChain lc on a.LocalChainID = lc.LocalChainID
Left Join SAP.LocalChain lc1 on prod.LocalChainID = lc1.LocalChainID
Left Join SAP.Channel c on c.ChannelID = a.ChannelID
Left Join SAP.Channel c1 on c1.ChannelID = prod.ChannelID
--Left Join Staging.BWAccount bwa on a.SAPAccountNumber = Customer_Number
Join Staging.AccountDetails ad ON ISNUMERIC(ad.SAPAccountNumber) = 1 AND a.SAPAccountNumber = convert(BIGINT, ad.SAPAccountNumber)
--Where(Coalesce(a.LocalChainID, 0) <> Coalesce(prod.LocalChainID, 0) Or Coalesce(a.ChannelID,0) <> Coalesce(prod.ChannelID, 0))
Where Coalesce(a.LocalChainID, 0) <> Coalesce(prod.LocalChainID, 0)
Order By SAPAccountNumber

Select a.SAPAccountNumber, a.AccountName, lc.SAPLocalChainID CRMLocalChainID, lc.LocalChainName CRMLocalChainName, 
--c.SAPChannelID CRMChannel, c.ChannelName CRMChannelName, 
--c1.SAPChannelID SDMStuckSAPChannelID, 
lc1.SAPLocalChainID SDMSAPLocalChainID,
lc1.LocalChainName SDMLocalChainName
--ad.SAPAccountNumber BWSAPAccountNumber, Convert(int, ad.SAPLocalChainID) BP7LocalChainID, ad.SAPChannelID BP7ChannelID
From SAP.Account a
Left Join SDM_Prod.Portal_Data.SAP.Account prod on a.SAPAccountNumber = prod.SAPAccountNumber
Left Join SAP.LocalChain lc on a.LocalChainID = lc.LocalChainID
Left Join SAP.LocalChain lc1 on prod.LocalChainID = lc1.LocalChainID
Left Join SAP.Channel c on c.ChannelID = a.ChannelID
Left Join SAP.Channel c1 on c1.ChannelID = prod.ChannelID
--Left Join Staging.BWAccount bwa on a.SAPAccountNumber = Customer_Number
--Join Staging.AccountDetails ad ON ISNUMERIC(ad.SAPAccountNumber) = 1 AND a.SAPAccountNumber = convert(BIGINT, ad.SAPAccountNumber)
--Where(Coalesce(a.LocalChainID, 0) <> Coalesce(prod.LocalChainID, 0) Or Coalesce(a.ChannelID,0) <> Coalesce(prod.ChannelID, 0))
Where Coalesce(a.LocalChainID, 0) <> Coalesce(prod.LocalChainID, 0)
And lc1.SAPLocalChainID is not null
Order By SAPAccountNumber

Select a.SAPAccountNumber, a.AccountName, --lc.SAPLocalChainID CRMLocalChainID, lc.LocalChainName CRMLocalChainName, 
c.SAPChannelID CRMChannel, c.ChannelName CRMChannelName, 
c1.SAPChannelID SDMSAPChannelID,
c1.ChannelName SDMChannelName
--lc1.SAPLocalChainID SDMSAPLocalChainID,
--lc1.LocalChainName SDMLocalChainName
--ad.SAPAccountNumber BWSAPAccountNumber, Convert(int, ad.SAPLocalChainID) BP7LocalChainID, ad.SAPChannelID BP7ChannelID
From SAP.Account a
Left Join SDM_Prod.Portal_Data.SAP.Account prod on a.SAPAccountNumber = prod.SAPAccountNumber
--Left Join SAP.LocalChain lc on a.LocalChainID = lc.LocalChainID
--Left Join SAP.LocalChain lc1 on prod.LocalChainID = lc1.LocalChainID
Left Join SAP.Channel c on c.ChannelID = a.ChannelID
Left Join SAP.Channel c1 on c1.ChannelID = prod.ChannelID
--Left Join Staging.BWAccount bwa on a.SAPAccountNumber = Customer_Number
--Join Staging.AccountDetails ad ON ISNUMERIC(ad.SAPAccountNumber) = 1 AND a.SAPAccountNumber = convert(BIGINT, ad.SAPAccountNumber)
--Where(Coalesce(a.LocalChainID, 0) <> Coalesce(prod.LocalChainID, 0) Or Coalesce(a.ChannelID,0) <> Coalesce(prod.ChannelID, 0))
Where Coalesce(a.ChannelID, 0) <> Coalesce(prod.ChannelID, 0)
And c1.ChannelID is not null
Order By SAPAccountNumber


--Select a.SAPAccountNumber, a.AccountName--, lc.SAPLocalChainID CRMLocalChainID, lc.LocalChainName, c.SAPChannelID CRMChannel, c.ChannelName, bwa.Local_Chain BP7LocalChain, bwa.CHANNEL BP7Channel
--From SAP.Account a
----Left Join SAP.LocalChain lc on a.LocalChainID = lc.LocalChainID
----Left Join SAP.Channel c on c.ChannelID = a.ChannelID
----Join Staging.BWAccount bwa on a.SAPAccountNumber = Customer_Number
--Where Coalesce(a.ChannelID,0) <> Coalesce(ChannelID1, 0)
----And (Coalesce(a.LocalChainID, 0) <> Coalesce(LocalChainID1, 0) Or Coalesce(a.ChannelID,0) <> Coalesce(ChannelID1, 0))
--Order By SAPAccountNumber

--SElect *
--From Staging.AccountDetails


--Select a.SAPAccountNumber, a.AccountName, lc.SAPLocalChainID CRMLocalChainID, lc.LocalChainName, c.SAPChannelID CRMChannel, c.ChannelName, bwa.Local_Chain BP7LocalChain, bwa.CHANNEL BP7Channel
--From SAP.Account a
--Left Join SAP.LocalChain lc on a.LocalChainID = lc.LocalChainID
--Left Join SAP.Channel c on c.ChannelID = a.ChannelID
--Join Staging.BWAccount bwa on a.SAPAccountNumber = Customer_Number
--Where a.InBW = 1
--And (Coalesce(a.LocalChainID, 0) <> Coalesce(LocalChainID1, 0) Or Coalesce(a.ChannelID,0) <> Coalesce(ChannelID1, 0))

--Select Top 1 *
--From Staging.BWAccount

Select *
From BC.Bottler
Where BottlerName like '%Schilling%'


Select *
From BC.BottlerAccountTradeMark bat
Join SAP.LocalChain lc on bat.LocalChainID = lc.LocalChainID
Where BottlerID = 5872
And ProductTypeID = 1
And TerritoryTypeID = 11
And LocalChainName like 'Army Air Force Exchange Service Aaf%'

Select *
From SAP.NationalChain
Where NationalChainName like '%AAFES%'


Select lc.LocalChainName, *
From BC.BottlerAccountTradeMark bat
Join SAP.LocalChain lc on bat.LocalChainID = lc.LocalChainID
Where BottlerID = 5872
And ProductTypeID = 1
And TerritoryTypeID = 11

Select *
From BC.TerritoryMap
Where BottlerID = 5872
And ProductTypeID = 1
And TerritoryTypeID = 11
