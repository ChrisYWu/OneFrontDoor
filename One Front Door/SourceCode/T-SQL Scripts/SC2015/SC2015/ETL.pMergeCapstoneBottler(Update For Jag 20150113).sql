USE [Portal_Data]
GO
/****** Object:  StoredProcedure [ETL].[pMergeCapstoneBottler]    Script Date: 1/13/2015 8:48:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- exec ETL.pMergeCapstoneBottler --
ALTER Proc [ETL].[pMergeCapstoneBottler]
AS		
	Set NoCount On;

	-- first round is bottler --
	/*
		B.Bttlr_ID = '0012014111' FS Region has problem, so disable updating FS Region
		-- Chris 20150113 8:56 AM
	*/
	Merge BC.Bottler As BTTR
	Using ( 
			Select Distinct B.BTTLR_ID, Replace(Replace(Replace(dbo.udf_TitleCase(BTTLR_NM), 'Pb - ', 'PB - '), 'Ccr ', 'CCR '), 'Usf ', 'USF ') BTTLR_NM, c.ChannelID, 
				Case When b.DEL_FLG = 'Y' 
					Then 99 
					Else b.GLOBAL_STTS
				End GLOBAL_STTS, 
			r.RegionID BCRegionID, 
			--r2.RegionID FSRegionID, 
			eb4.EB4ID,
			b.ROW_MOD_DT,
			tempMDT1.ROW_MOD_DT EB_ROW_MOD_DT,
			tempMDT2.ROW_MOD_DT BC_ROW_MOD_DT
			--tempMDT3.ROW_MOD_DT FS_ROW_MOD_DT
		From Staging.BCBottler b
			Left Join SAP.Channel c on b.CHNL_CODE = c.SAPChannelID
			Left Join Staging.BCvBottlerExternalHierachy e on e.BTTLR_ID = b.BTTLR_ID
			Left Join Processing.BottlerLEGLatestUpdatedDate tempMDT1 on tempMDT1.Partner = b.BTTLR_ID And tempMDT1.HIER_TYPE = 'EB'
			Left Join BC.BottlerEB4 eb4 on eb4.BCNodeID = e.NODE4_ID
			Left Join Staging.BCvBottlerSalesHierachy sh on sh.BTTLR_ID = b.BTTLR_ID and sh.HIER_TYPE = 'BC'
			Left Join BC.Region r on r.BCNodeID = sh.REGION_ID
			Left Join Processing.BottlerLEGLatestUpdatedDate tempMDT2 on tempMDT2.Partner = b.BTTLR_ID And tempMDT2.HIER_TYPE = 'BC'
			--Left Join Staging.BCvBottlerSalesHierachy shfs on shfs.BTTLR_ID = b.BTTLR_ID and shfs.HIER_TYPE = 'FS'
			--Left Join BC.Region r2 on r2.BCNodeID = shfs.REGION_ID
			--Left Join Processing.BottlerLEGLatestUpdatedDate tempMDT3 on tempMDT3.Partner = b.BTTLR_ID And tempMDT3.HIER_TYPE = 'FS'
			Where b.DEL_FLG <> 'Y' And GLOBAL_STTS = 02
		) As input
	On BTTR.[BCBottlerID] = Convert(bigint, input.BTTLR_ID)
	When Matched Then
		Update Set BottlerName = input.BTTLR_NM,
				ChannelID = input.ChannelID,
				GlobalStatusID = input.GLOBAL_STTS,
				EB4ID = input.EB4ID,
				BCRegionID = input.BCRegionID,
				--FSRegionID = input.FSRegionID,
				LastModified = input.ROW_MOD_DT,
				EB4LastModified = input.EB_ROW_MOD_DT,
				[BCRegionLastModified] = input.BC_ROW_MOD_DT--,
				--[FSRegionLastModified] = input.FS_ROW_MOD_DT
	When Not Matched By Target Then
		Insert([BCBottlerID],[BottlerName],[ChannelID],[GlobalStatusID],[EB4ID],
		[BCRegionID],
		--[FSRegionID],
		[LastModified],
		EB4LastModified,[BCRegionLastModified],
		--[FSRegionLastModified], 
		GeoCodingNeeded)
		Values(input.BTTLR_ID,input.BTTLR_NM,input.ChannelID,input.GLOBAL_STTS,input.EB4ID,
		input.BCRegionID,
		--input.FSRegionID,
		input.ROW_MOD_DT,
		input.EB_ROW_MOD_DT,input.BC_ROW_MOD_DT,
		--input.FS_ROW_MOD_DT, 
		0);

	-- second round is bottler address--
	Merge BC.Bottler As BTTR
	Using ( 
			Select a.BP_ID,
			dbo.udf_TitleCase(Case When a.[ADDR_LINE_1] Like 'Xxx%' Then Null Else a.[ADDR_LINE_1] End) ADDR_LINE_1,
			dbo.udf_TitleCase(Case When a.[ADDR_CITY] Like 'Xxx%' Then Null Else a.[ADDR_CITY] End) ADDR_CITY,
			a.ADDR_REGION_ABRV,
			a.[ADDR_PSTL_CODE],
			a.EMAIL,
			a.PHN_NBR,
			a.ADDR_CNTRY_CODE,
			a.ROW_MOD_DT Address_ROW_MOD_DT,
			dbo.udf_TitleCase(a.ADDR_CNTY_NM) ADDR_CNTY_NM
		From Staging.BCBPAddress a 
		) As input
	On BTTR.BCBottlerID = input.BP_ID
	When Matched Then
		Update Set 
				Address = input.ADDR_LINE_1,
				City = input.ADDR_CITY,
				County = input.ADDR_CNTY_NM,
				State = input.ADDR_REGION_ABRV,
				PostalCode = input.ADDR_PSTL_CODE,
				Email = input.EMAIL,
				PhoneNumber = input.PHN_NBR,
				GeoCodingNeeded = 1,
				AddressLastModified = input.Address_ROW_MOD_DT;

	----------------------------------------
	----------------------------------------
	Declare @LogID int

	Select @LogID = Max(LogID)
	From ETL.BCDataLoadingLog
	Where SchemaName = 'Staging' 
	And TableName = 'BCvBottlerExternalHierachy'

	Update ETL.BCDataLoadingLog
	Set MergeDate = GetDate()
	Where  LogID = @LogID

	Select @LogID = Max(LogID)
	From ETL.BCDataLoadingLog
	Where SchemaName = 'Staging' 
	And TableName = 'BCvBottlerSalesHierachy'

	Update ETL.BCDataLoadingLog
	Set MergeDate = GetDate()
	Where LogID = @LogID

	Select @LogID = Max(LogID)
	From ETL.BCDataLoadingLog
	Where SchemaName = 'Staging' 
	And TableName = 'BCBottlerHierachy'

	Update ETL.BCDataLoadingLog
	Set MergeDate = GetDate()
	Where LogID = @LogID

	Select @LogID = Max(LogID)
	From ETL.BCDataLoadingLog
	Where SchemaName = 'Staging' 
	And TableName = 'BCBottler'

	Update ETL.BCDataLoadingLog
	Set MergeDate = GetDate()
	Where LogID = @LogID
	----------------------------------------
	----------------------------------------

