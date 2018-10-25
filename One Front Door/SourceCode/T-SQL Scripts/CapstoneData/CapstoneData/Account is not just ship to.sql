Use Portal_Data
Go


Select Count(*)
From SAP.Account

SELECT [Address]
      +[City]
      +[State]
      +[PostalCode] ,Count(*)  
FROM [Portal_Data].[SAP].[Account]
Where AccountName like '%Walmart%'
Group By Address + City + State + [PostalCode]
Having Count(*) > 1

Select *
From [Portal_Data].[SAP].[Account]
Where [Address]
      +[City]
      +[State]
      +[PostalCode] = '10105 Lima RdFort WayneIN46818'

Select *
From [Portal_Data].[SAP].[Account]
Where [Address]
      +[City]
      +[State]
      +[PostalCode] = ''
And AccountName like '%Walmart%'

Use Portal_Data
Go

SElect SAPAccountNumber, Count(*)
From SAP.Account
Group By SAPAccountNumber
Having Count(*) > 1
Go

Select *
From SAP.NationalChain
Where NationalChainName like '%Walmart%'

Select *
From SAP.Account
Where SAPAccountNumber = '1001501'
Go

Select *
From SAP.NationalChain
Order by lastModified desc
Go

Select a.SAPAccountNumber, b.SAPChainID
From SAP.Account a
Right Join (
	Select SAPNationalChainID As SAPChainID
	From SAP.NationalChain
	Union 
	Select SAPRegionalChainID
	From SAP.RegionalChain
	Union 
	Select SAPLocalChainID
	From SAP.LocalChain
	) b on b.SAPChainID = a.SAPAccountNumber
Where SAPAccountNumber is null

Select *
From SAP.RegionalChain
Where SAPRegionalChainID = 1010944
Go

Select Distinct VicePresidentID
From [MSTR].[DimWDAmplifyCustHierarchy]
Go

'AccountID	SoldToID	ShipToID	CustomerGroupID	BrokerID	NationalAccountID	DirectorID	VicePresidentID	SrVicePresidentID	PlanningAccountID
990387		1105062		990387		828206			631815		931315				1169167		878502			631858				394'

--- Customer Group ---
Select *
From SAP.Account
Where AccountID = 828206

--- Broker ----
Select *
From SAP.Account
Where AccountID = 631815

--- NationalAccountID ----
Select *
From SAP.Account
Where AccountID = 931315

--- DirectorID ----
Select *
From SAP.Account
Where AccountID = 1169167

--- VicePresidentID ----
Select *
From SAP.Account
Where AccountID = 878502

--- SrVicePresidentID ---
Select *
From SAP.Account
Where AccountID = 631858

Select *
From SAP.Account
Where AccountID in ('990387','1105062','990387','828206','631815','931315', '1169167', '878502', '631858')
Go

Select Count(Distinct AccountID)
From [MSTR].[FactMyDayCustomer]
Where AccountID in ('990387','1105062','990387','828206','631815','931315', '1169167', '878502', '631858')

Select Count(Distinct AccountID)
From [MSTR].[FactMyDayCustomerSummary]
Where AccountID in ('990387','1105062','990387','828206','631815','931315', '1169167', '878502', '631858')


