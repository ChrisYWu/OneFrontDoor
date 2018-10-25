use Portal_DataSRE
Go

If Exists (Select * From Sys.procedures Where Object_ID = Object_ID('ETL.pMergeCapstoneProduct'))
Begin
	Drop Proc ETL.pMergeCapstoneProduct
End
Go

SET QUOTED_IDENTIFIER ON
GO

/*
Truncate Table BC.TerritoryMap 

exec ETL.pMergeCapstoneProduct 

*/

Create Proc [ETL].[pMergeCapstoneProduct]
AS		
	Set NoCount On;
	Declare @LogID int;

	--------------------------------------------
	---- TradeMark -----------------------------
	declare @saptm Table
	(
		TradeMarkID int,
		SAPTradeMarkID varchar(50),
		TradeMarkName nvarchar(128),
		IsCapstone bit,
		ChangeTrackNumber int
	)

	-- Trademarks are loaded from SDM here --
	Insert @saptm(TradeMarkID, SAPTradeMarkID, TradeMarkName, ChangeTrackNumber, IsCapstone)
	SElect TradeMarkID, SAPTradeMarkID, TradeMarkName, ChangeTrackNumber, IsCapstone
	From SAP.TradeMark

	--- All the Capstone trademarks
	Declare @CapstoneTrademarks Table
	(
		SAPTradeMarkID varchar(50),
		TradeMarkName nvarchar(128)
	)

	Insert Into @CapstoneTrademarks
	Select Distinct TRADEMARK_ID TradeMarkID, TRADEMARK_DESC TradeMark
	From Staging.BCProduct
	Where DEL_FLG <> 'Y'

	--- Adding new Capstone trademarks 
	MERGE @saptm AS pc
		USING (Select SAPTradeMarkID, TradeMarkName From @CapstoneTrademarks) input
		ON pc.SAPTradeMarkID = input.SAPTradeMarkID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPTradeMarkID, TradeMarkName, IsCapstone)
	VALUES(input.SAPTradeMarkID, dbo.udf_TitleCase(input.TradeMarkName), 1);

	--- Updating the trademark name exclusive to Capstone
	--- If a trademark is ever seen in BW feed, Capstone data can never update the trademark name any more
	Update SDM
	Set TradeMarkName = c.TradeMarkName
	From @CapstoneTrademarks c
	Join @saptm SDM on c.SAPTradeMarkID = SDM.SAPTradeMarkID
	And SDM.IsCapstone = 1

	Update @saptm Set ChangeTrackNumber = CHECKSUM(SAPTradeMarkID, TradeMarkName) -- checksum is defined to be the businesskey and business name

	-- Use the table veriable to update SDM Trademark table based on CheckSum --
	MERGE SAP.TradeMark AS pc
	USING (Select TradeMarkID, SAPTradeMarkID, TradeMarkName, ChangeTrackNumber, IsCapstone From @saptm) AS input
			ON pc.TradeMarkID = input.TradeMarkID
	WHEN NOT MATCHED By Target THEN
		INSERT(SAPTradeMarkID, TradeMarkName, ChangeTrackNumber, LastModified, IsCapstone)
	VALUES(input.SAPTradeMarkID, input.TradeMarkName, input.ChangeTrackNumber, GetDate(), input.IsCapstone);

	Update sdm
	Set SAPTradeMarkID = sap.SAPTradeMarkID, TradeMarkName = sap.TradeMarkName, ChangeTrackNumber = sap.ChangeTrackNumber, LastModified = GetDate()
	From @saptm sap
	Join SAP.TradeMark sdm on sap.TradeMarkID = sdm.TradeMarkID and sap.ChangeTrackNumber != isnull(sdm.ChangeTrackNumber, 0);

	--@@@-- Set the merged flag 
	Select @LogID = Max(LogID)
	From BC.DataLoadingLog
	Where SchemaName = 'Staging' 
	And TableName = 'BCProduct1'

	Update BC.DataLoadingLog
	Set MergeDate = GetDate()
	Where  LogID = @LogID

	Select @LogID = Max(LogID)
	From BC.DataLoadingLog
	Where SchemaName = 'Staging' 
	And TableName = 'BCProduct2'

	Update BC.DataLoadingLog
	Set MergeDate = GetDate()
	Where  LogID = @LogID
Go