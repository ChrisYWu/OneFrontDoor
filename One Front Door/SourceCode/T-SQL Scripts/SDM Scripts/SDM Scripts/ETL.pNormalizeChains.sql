USE [Portal_Data]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ETL].[pNormalizeChains]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ETL].[pNormalizeChains]
GO

USE [Portal_Data]
GO

/****** Object:  StoredProcedure [ETL].[NormalizeChains]    Script Date: 03/21/2013 09:44:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ETL].[pNormalizeChains] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--------------------------------------------
    --- Channel Loading is disabled per discussion with Rajeev. 
	---- Super Channel -------------------------
	--MERGE SAP.SuperChannel AS bu
	--	USING (SELECT Distinct SuperChannelID, SuperChannel 
	--			From BWStaging.Channel
	--			Where SuperChannelID <> '#') AS input
	--		ON bu.SAPSuperChannelID = input.SuperChannelID
	--WHEN MATCHED THEN 
	--	UPDATE SET bu.SuperChannelName = dbo.udf_TitleCase(input.SuperChannel)
	--WHEN NOT MATCHED By Target THEN
	--	INSERT(SAPSuperChannelID, SuperChannelName)
	--VALUES(input.SuperChannelID, dbo.udf_TitleCase(input.SuperChannel));
	--GO

	--Select *
	--From SAP.SuperChannel 
	--Go

	--------------------------------------------

	-----------------------------------------------
	---Channel-------------------------------------
	--MERGE SAP.Channel AS ba
	--	USING ( SELECT Distinct ChannelID, Channel
	--			FROM BWStaging.Channel r
	--			Where Rtrim(Ltrim(ChannelID)) <> '#') AS input
	--		ON ba.SAPChannelID = input.ChannelID
	--WHEN MATCHED THEN
	--	UPDATE SET ba.ChannelName = dbo.udf_TitleCase(input.Channel)
	--WHEN NOT MATCHED By Target THEN
	--	INSERT(SAPChannelID, ChannelName)
	--VALUES(input.ChannelID, dbo.udf_TitleCase(input.Channel));
	--GO

	--Select *
	--From SAP.Channel
	--Go

	--Merge SAP.SuperChannelChannel scc
	--Using (Select s.SuperChannelID, c.ChannelID
	--		From BWStaging.Channel bw
	--		Join SAP.SuperChannel s on BW.SuperChannelID = s.SAPSuperChannelID
	--		Join SAP.Channel c on BW.ChannelID = c.SAPChannelID) as input
	--	On scc.SuperChannelID = input.SuperChannelID
	--	And scc.ChannelID = input.ChannelID
	--When Not Matched By Target Then
	--	Insert(SuperChannelID, ChannelID)
	--	Values(input.SuperChannelID, input.ChannelID)
	--When Not Matched By Source Then
	--	Delete;
	--Go

	--------------------------------------------
	---- National Chain ------------------------
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

	--------------------------------------------
	---- Regional Chain ------------------------
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
End

