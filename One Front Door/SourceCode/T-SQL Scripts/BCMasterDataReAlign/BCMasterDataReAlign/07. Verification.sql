use Portal_Data
Go

Select a.SAPAccountNumber, l.SAPLocalChainID CurrentSAPLocalChain, l1.SAPLocalChainID OldSAPLocalChain, 
c.SAPChannelID CurrentSAPChannel, c1.SAPChannelID OldSAPChannel, 
Case When isnull(a.LocalChainID, 0) <> IsNUll(a.LocalChainID1, 0) Then 'Different Chain' Else 'Same Chain' End DifferentChainIndicator,
Case When isnull(a.ChannelID, 0) <> IsNUll(a.ChannelID1, 0) Then 'Different Channel' Else 'Same Channel' End DifferentChannelIndicator,
a.StoreLastModified, a.CapstoneLastModified, Latitude, Longitude
From SAP.Account a
Left Join SAP.Localchain l on a.LocalChainID = l.LocalchainID
Left Join SAP.Localchain l1 on a.LocalChainID1 = l1.LocalchainID
Left Join SAP.Channel c on a.ChannelID = c.ChannelID
Left Join SAP.Channel c1 on a.ChannelID1 = c1.ChannelID
Where IsNull(a.InCapstone, 0) = 1
--And 
--(isnull(a.LocalChainID, 0) <> IsNUll(a.LocalChainID1, 0) Or 
--isnull(a.ChannelID, 0) <> IsNUll(a.ChannelID1, 0))
And CRMActive = 1


Select l.SAPLocalChainID CurrentSAPLocalChain, l1.SAPLocalChainID OldSAPLocalChain, 
c.SAPChannelID CurrentSAPChannel, c1.SAPChannelID OldSAPChannel, 
Case When isnull(a.LocalChainID, 0) <> IsNUll(a.LocalChainID1, 0) Then 'Different Chain' Else 'Same Chain' End DifferentChainIndicator,
Case When isnull(a.ChannelID, 0) <> IsNUll(a.ChannelID1, 0) Then 'Different Channel' Else 'Same Channel' End DifferentChannelIndicator
,*
From SAP.Account a
Left Join SAP.Localchain l on a.LocalChainID = l.LocalchainID
Left Join SAP.Localchain l1 on a.LocalChainID1 = l1.LocalchainID
Left Join SAP.Channel c on a.ChannelID = c.ChannelID
Left Join SAP.Channel c1 on a.ChannelID1 = c1.ChannelID
Where IsNull(a.InCapstone, 0) = 1
And 
(isnull(a.LocalChainID, 0) <> IsNUll(a.LocalChainID1, 0) Or 
isnull(a.ChannelID, 0) <> IsNUll(a.ChannelID1, 0))
And CRMActive = 1

Select *
From SAP.Account 
Where IsNull(InCapstone, 0) = 1
And isnull(LocalChainID, 0) = 0
And CRMActive = 1


Select *
From SAP.Account Where SAPAccountNumber = 12285400


--Drop Table SAP.Account0529

Select *
Into SAP.Account0604
From SAP.Account a

exec ETL.pNormalizeChains
exec ETL.pLoadFromRM
exec ETL.pMergeChainsAccounts
Go

Select StoreLastModified, Count(*) Cnt
From SAP.Account a
Group By StoreLastModified
Order By StoreLastModified DESC
Go

Select *
From SAP.Account
Where StoreLastModified = '2015-06-04 09:44:25.4370000'

Select LastModified, StoreLastModified, Count(*) Cnt
From SAP.Account a
Group By LastModified, StoreLastModified
Order By StoreLastModified DESC, LastModified DESC
Go

---- Need a new column StoreLastModified that will be touched by the two SPs

Select count(*)
From Staging.BCStore

Select AccountID, SAPAccountNumber, AccountName, InCapstone, CRMActive, LocalChainID, LocalChainID1, ChannelID, ChannelID1, LastModified
From SAP.Account
Where Coalesce(InCapstone,0) = 1
And (COALESCE(LocalChainID, 0) <> Coalesce(LocalChainID1, 0) or Coalesce(ChannelID,0) <> Coalesce(ChannelID1,0))

-- Account update for the varchar fields can only be one source

Select Count(*)
From SAP.Account
Where InCapstone = 1
And CRMActive <> CRMActive1

--And isnull(InBW, 0) = 0
And (isnull(LocalChainID, 0) <> IsNull(LocalChainID1, 0)
Or (isnull(ChannelID, 0) <> IsNull(ChannelID1, 0)))
And CRMActive = 1

--Delete 

--Select Distinct LastModified
--From SAP.Account
--Where AccountID in (
--Select Max(AccountID)
--From SAP.Account
--Group by SAPAccountNumber
--Having count(*) > 1)

--Select Count(*)
--From SAP.Account
--Order By AccountID Desc

--Where SAPAccountNumber = 200477616

