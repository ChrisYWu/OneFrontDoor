use Portal_Data
Go

--- There is a staggering 239 accounts in SP7
Select *
From SAP.Account
Where Address Like '%2000 Shoppers%'
And InCapstone = 1


