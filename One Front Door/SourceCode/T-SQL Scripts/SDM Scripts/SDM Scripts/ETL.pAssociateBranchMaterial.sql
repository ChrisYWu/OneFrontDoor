USE [Portal_Data]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ETL].[pAssociateBranchMaterial]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ETL].[pAssociateBranchMaterial]
GO

USE [Portal_Data]
GO

/****** Object:  StoredProcedure [ETL].[AssociateBranchMaterial]    Script Date: 03/21/2013 09:44:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ETL].[pAssociateBranchMaterial] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-------------------------------------------
	-------------------------------------------
	Truncate Table BWStaging.ActiveItem

	Insert Into BWStaging.ActiveItem
	Select Distinct Location_ID, ITEM_NUMBER, HANDHELD_DESCRIPTION, PRINTOUT_DESCRIPTION
	From RM..ACEUSER.ITEM_MASTER
	Where Active = 1

	-------------------------------------------
	-------------------------------------------
	MERGE SAP.BranchMaterial AS bu
		USING (Select BranchID, MaterialID, HANDHELD_DESCRIPTION, PRINTOUT_DESCRIPTION
					From BWStaging.ActiveItem ai
					Join SAP.Material bt on ai.ITEM_NUMBER = bt.SAPMaterialID
					Join SAP.Branch b on Left(LOCATION_ID, 4) = b.SAPBranchID ) input
				ON bu.MaterialID = input.MaterialID
				And bu.BranchID = input.BranchID
	WHEN MATCHED THEN
		Update Set HandheldDesc = input.HANDHELD_DESCRIPTION,
				PrintoutDesc = PRINTOUT_DESCRIPTION
	WHEN NOT MATCHED By Target THEN
		INSERT(MaterialID, BranchID, HandheldDesc, PrintoutDesc)
		VALUES(input.MaterialID, input.BranchID, input.HANDHELD_DESCRIPTION, input.PRINTOUT_DESCRIPTION)
	WHEN NOT MATCHED By Source THEN
		Delete;
End

