--------------------------------------------
---- National Chain ------------------------
use Portal_Data
Go
MERGE SAP.NationalChain AS bu
	USING (SELECT Distinct NationalChainID, NationalChain
			From BWStaging.Chain
			Where NationalChainID <> '#') AS input
		ON bu.SAPNationalChainID = input.NationalChainID
WHEN MATCHED THEN 
	UPDATE SET bu.NationalChainName = dbo.udf_TitleCase(input.NationalChain)
WHEN NOT MATCHED By Target THEN
	INSERT(SAPNationalChainID, NationalChainName)
VALUES(input.NationalChainID, dbo.udf_TitleCase(input.NationalChain));
GO

Select *
From SAP.NationalChain
Go

--------------------------------------------
---- Regional Chain ------------------------
use Portal_Data
Go

Declare @Rel Table
(
	NationalChainID int,
	RegionalChainID int
)
Insert @Rel
SELECT Distinct NationalChainID, RegionalChainID
From BWStaging.Chain 
Where NationalChainId <> '#' And RegionalChainId <> '#'

Declare @PotentialAllOtherExceptions table
(
	RegionalChainID varchar(20)
)

Insert @potentialAllOtherExceptions
Select RegionalChainID
From @Rel
Group By RegionalChainID
Having Count(*) > 1

Declare @Chain table
(
	NationalChainID int,
	NationalChainName varchar(128),
	RegionalChainID int,
	RegionalChainName varchar(128)
)

Insert @Chain
SELECT Distinct c.NationalChainID, NationalChain, RegionalChainID, RegionalChain
			From BWStaging.Chain c
			Join SAP.NationalChain nc on nc.SAPNationalChainID = c.NationalChainID
			Where RegionalChainID <> '#'

Delete @Chain
Where NationalChainName = 'ALL OTHER' 
And RegionalChainID in (Select RegionalChainID From @potentialAllOtherExceptions)
					
MERGE SAP.RegionalChain AS bu
	USING (SELECT nc.NationalChainID, nc.SAPNationalChainID, c.RegionalChainID, c.RegionalChainName
			From @Chain c
			Join SAP.NationalChain nc on nc.SAPNationalChainID = c.NationalChainID
			) AS input
		ON bu.SAPRegionalChainID = input.RegionalChainID
WHEN MATCHED THEN 
	UPDATE SET bu.RegionalChainName = dbo.udf_TitleCase(input.RegionalChainName),
			   bu.NationalChainID = input.NationalChainID
WHEN NOT MATCHED By Target THEN
	INSERT(SAPRegionalChainID, RegionalChainName, NationalChainID)
VALUES(RegionalChainID, dbo.udf_TitleCase(input.RegionalChainName), NationalChainID);
GO

Select *
From SAP.RegionalChain
Go

--------------------------------------------

--------------------------------------------
---Local Chain------------------------------
Declare @LocalChain Table
(
	LocalChainID int, 
	LocalChain varchar(128), 
	RegionalChainId int, 
	RegionalChain varchar(128)
)
Insert @LocalChain
Select Distinct LocalChainID, LocalChain, RegionalChainId, RegionalChain
From BWStaging.Chain 
Where LocalChainID <> '#'

Delete @LocalChain
Where LocalChainID in 
(
	Select LocalChainID 
	From @LocalChain
	Group By LocalChainID 
	Having Count(*) > 1
)
And RegionalChain = 'ALL OTHER'

MERGE SAP.LocalChain AS ba
	USING ( SELECT l.LocalChainID, l.LocalChain, rc.RegionalChainID
			FROM @LocalChain l
			Join SAP.RegionalChain rc on l.RegionalChainID = rc.SAPRegionalChainID) AS input
		ON ba.SAPLocalChainID = input.LocalChainID
WHEN MATCHED THEN
	UPDATE SET ba.LocalChainName = dbo.udf_TitleCase(input.LocalChain),
				ba.RegionalChainID = input.RegionalChainID
WHEN NOT MATCHED By Target THEN
	INSERT(SAPLocalChainID, LocalChainName, RegionalChainID)
VALUES(input.LocalChainID, dbo.udf_TitleCase(input.LocalChain), input.RegionalChainID);
GO

Use Portal_Data
Go

Update SAP.LocalChain 
Set LocalChainName = 'CVS/Pharmacy'
Where LocalChainName = 'Cvs/Pharmacy'

Update SAP.RegionalChain 
Set RegionalChainName = 'CVS/Pharmacy'
Where RegionalChainName = 'Cvs/Pharmacy'

Update SAP.NationalChain 
Set NationalChainName = 'CVS/Pharmacy'
Where NationalChainName = 'Cvs/Pharmacy'

Update SAP.NationalChain 
Set NationalChainName = 'Walmart US'
Where NationalChainName = 'Walmart Us'

Delete SAP.NationalChain
Where SAPnationalChainID is null
