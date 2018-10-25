USE [Portal_Data]
GO
/****** Object:  StoredProcedure [ETL].[pAppendBP7PlantInventory]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [ETL].[pAppendBP7PlantInventory]
AS		
	Set NoCount On;

	-------------------------------------
	Delete From SAP.BP7PlantInventory
	Where CalendarDate in (
	Select Distinct CalendarDate
	From Staging.BP7DailyPlantInventory)

	Insert Into SAP.BP7PlantInventory([SAPPlantNumber]
           ,[SAPSalesOfficeNumber]
           ,[SAPMaterialID]
           ,[CalendarDate]
           ,[TransferOut]
           ,[CustomerShipment]
           ,[EndingInventory])
	Select *
	From Staging.BP7DailyPlantInventory

	--Update SAP.BP7PlantInventory
	--Set SAPPlantNumber = 1403, OriginalPlantNumber = SAPPlantNumber
	--Where SAPPlantNumber = 1404
	--And CalendarDate in (
	--Select Distinct CalendarDate
	--From Staging.BP7DailyPlantInventory)


GO
/****** Object:  StoredProcedure [ETL].[pAppendBP7SalesOfficeInventory]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
exec ETL.pAppendBP7SalesOfficeInventory

*/

Create Proc [ETL].[pAppendBP7SalesOfficeInventory]
AS
Set NoCount On;
	-------------------------------------
	Delete From SAP.BP7SalesOfficeInventory
	Where CalendarDate in (
	Select Distinct CalendarDate
	From Staging.BP7DailySalesOfficeInventory)

	Insert Into SAP.BP7SalesOfficeInventory
	Select *
	From Staging.BP7DailySalesOfficeInventory


GO
/****** Object:  StoredProcedure [ETL].[pAppendBP7SalesOfficeMinMax]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
exec ETL.pAppendBP7SalesOfficeMinMax

*/

Create Proc [ETL].[pAppendBP7SalesOfficeMinMax]
AS
Set NoCount On;
	-------------------------------------
	Delete From SAP.BP7SalesOfficeMinMax
	Where CalendarDate in (
	Select Distinct CalendarDate
	From Staging.BP7DailySalesOfficeMinMax)

	Insert Into SAP.BP7SalesOfficeMinMax
           (SAPPlantNumber, SAPSalesOfficeNumber
           ,SAPMaterialID
           ,CalendarDate
           ,EndingInventory
           ,MaxStock
           ,SafetyStock
           ,AvailableStock
           ,MinSafetyStock)
	Select SAPPlantNumber, SAPSalesOfficeNumber
           ,SAPMaterialID
           ,CalendarDate
           ,EndingInventory
           ,MaxStock
           ,SafetyStock
           ,AvailableStock
           ,MinSafetyStock
	From Staging.BP7DailySalesOfficeMinMax


GO
/****** Object:  StoredProcedure [ETL].[pDSDCasecutFilling]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [ETL].[pDSDCasecutFilling]
(
	@ParamAffectedMinDateID int = 0
)
As
Begin
	Set NoCount On;

	--Declare @ParamAffectedMinDateID int
	--Set @ParamAffectedMinDateID = 20140828

	Declare @AffectedMinDate Date
	Declare @AffectedMinDateID int

	If (@ParamAffectedMinDateID > 0) 
	Begin
		Set @AffectedMinDateID = @ParamAffectedMinDateID 
	End
	Else
	Begin
		Select Top 1 @AffectedMinDate = LatestLoadedRecordDate
		From ETL.BCDataLoadingLog
		Where TableName = 'FleetLoader'
		And NumberOfRecordsLoaded > 0

		Select @AffectedMinDateID = SupplyChain.udfConvertToDateID(@AffectedMinDate)
	End

	Delete From SupplyChain.tDsdCaseCut 
	Where AnchorDateID Between @AffectedMinDateID And SupplyChain.udfConvertToDateID(GetDate())

	----- Month To Date --------------
	Insert Into SupplyChain.tDsdCaseCut
           (AnchorDateID
		   ,RegionID, BranchID, ProductLineID
		   ,TradeMarkID
		   ,BrandID
           ,MaterialID
		   ,PackageID
		   ,PackageConfID
		   ,PackageTypeID
           ,AggregationID
           ,Quantity
           ,CaseCut)
	Select Anchor.DateID, RegionID, BranchID, ProductLineID
		   ,TradeMarkID
		   ,BrandID
           ,MaterialID
		   ,PackageID
		   ,PackageConfID
		   ,PackageTypeID, 3, Sum(Quantity), Sum(CaseCut)
	From SupplyChain.tDsdDailyCaseCut cut
	Join (
		Select DateID
		From Shared.DimDate 
		Where DateID Between @AffectedMinDateID And SupplyChain.udfConvertToDateID(GetDate())
	) Anchor on cut.DateID <= Anchor.DateID And cut.DateID >= Anchor.DateID/100*100 + 1
	Group By Anchor.DateID, RegionID, BranchID, ProductLineID
		   ,TradeMarkID
		   ,BrandID
           ,MaterialID
		   ,PackageID
		   ,PackageConfID
		   ,PackageTypeID

	----- Year To Date --------------
	Insert Into SupplyChain.tDsdCaseCut
           (AnchorDateID
		   ,RegionID, BranchID, ProductLineID
		   ,TradeMarkID
		   ,BrandID
           ,MaterialID
		   ,PackageID
		   ,PackageConfID
		   ,PackageTypeID
           ,AggregationID
           ,Quantity
           ,CaseCut)
	Select Anchor.DateID, RegionID, BranchID, ProductLineID
		   ,TradeMarkID
		   ,BrandID
           ,MaterialID
		   ,PackageID
		   ,PackageConfID
		   ,PackageTypeID, 4, Sum(Quantity), Sum(CaseCut)
	From SupplyChain.tDsdDailyCaseCut cut
	Join (
		Select DateID
		From Shared.DimDate 
		Where DateID Between @AffectedMinDateID And SupplyChain.udfConvertToDateID(GetDate())
	) Anchor on cut.DateID <= Anchor.DateID And cut.DateID >= Anchor.DateID/10000*10000 + 1
	Group By Anchor.DateID, RegionID, BranchID, ProductLineID
		   ,TradeMarkID
		   ,BrandID
           ,MaterialID
		   ,PackageID
		   ,PackageConfID
		   ,PackageTypeID

	----- Last 7 Days --------------
	--Select DateID, Convert(Int, CONVERT(varchar, DATEADD(d, -6, Date),112)) [7daysago]
	--From Shared.DimDate 
	--Where DateID Between @AffectedMinDateID And SupplyChain.udfConvertToDateID(GetDate())

	--Insert Into SupplyChain.tDsdCaseCut
 --          (AnchorDateID
	--	   ,RegionID, BranchID, ProductLineID
	--	   ,TradeMarkID
	--	   ,BrandID
 --          ,MaterialID
	--	   ,PackageID
	--	   ,PackageConfID
	--	   ,PackageTypeID
 --          ,AggregationID
 --          ,Quantity
 --          ,CaseCut)
	--Select Anchor.DateID, RegionID, BranchID, ProductLineID
	--	   ,TradeMarkID
	--	   ,BrandID
 --          ,MaterialID
	--	   ,PackageID
	--	   ,PackageConfID
	--	   ,PackageTypeID, 5, Sum(Quantity), Sum(CaseCut)
	--From SupplyChain.tDsdDailyCaseCut cut
	--Join (
	--	Select DateID, Date
	--	From Shared.DimDate 
	--	Where DateID Between @AffectedMinDateID And SupplyChain.udfConvertToDateID(GetDate())
	--) Anchor on cut.DateID <= Anchor.DateID And cut.DateID >= Convert(Int, CONVERT(varchar, DATEADD(d, -6, Anchor.Date),112))
	--Group By Anchor.DateID, RegionID, BranchID, ProductLineID
	--	   ,TradeMarkID
	--	   ,BrandID
 --          ,MaterialID
	--	   ,PackageID
	--	   ,PackageConfID
	--	   ,PackageTypeID

	--- Verify -----------------
	--Select * From SupplyChain.tDsdCaseCut
	---------------------------
End


GO
/****** Object:  StoredProcedure [ETL].[pImportProductionDownTime]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [ETL].[pImportProductionDownTime]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @RefreshLogID int
	Insert Into SupplyChain.RefreshLog
	Values(GetDate(), null, null, null, null, null)

	Select @RefreshLogID = Scope_Identity()

	--------------------------------------------------
	---- Division ------------------------------------
	MERGE SupplyChain.Division AS d
		USING (select Distinct division
			   from AIRVDB02.Production.dbo.line) AS input
			ON d.DivisionName = input.division
	WHEN NOT MATCHED  THEN
		INSERT(DivisionName, LastModified)
		VALUES(input.division, getdate());

	---- Region ------------------------------------
	MERGE SupplyChain.Region AS d
		USING (Select distinct d.DivisionID, region
				From AIRVDB02.Production.dbo.line l
				Join SupplyChain.Division d on l.division = d.DivisionName) AS input
			ON d.RegionName = input.region
	WHEN NOT MATCHED  THEN
		INSERT(DivisionID, RegionName, LastModified)
		VALUES(input.DivisionID, input.region, getdate());

	---- Division ------------------------------------
	MERGE SupplyChain.PlantType AS pt
		USING (select Distinct plant_type
			   from AIRVDB02.Production.dbo.plant) AS input
			ON pt.PlantTypeName = input.plant_type
	WHEN NOT MATCHED  THEN
		INSERT(PlantTypeName, LastModified)
		VALUES(input.plant_type, getdate());

	---- Region ------------------------------------
	MERGE SupplyChain.Region AS d
		USING (Select distinct d.DivisionID, region
				From AIRVDB02.Production.dbo.line l
				Join SupplyChain.Division d on l.division = d.DivisionName) AS input
			ON d.RegionName = input.region
	WHEN NOT MATCHED  THEN
		INSERT(DivisionID, RegionName, LastModified)
		VALUES(input.DivisionID, input.region, getdate());

	---- Plant --------------------------------------
	MERGE SupplyChain.Plant AS p
		USING (Select distinct r.RegionID, p.plant_id, plant, plant_desc, pt.PlantTypeID, CheckSum(p.plant_id, plant, plant_desc, r.RegionID, pt.PlantTypeID) ChangeTrackNumber 
				From AIRVDB02.Production.dbo.plant p
				Join AIRVDB02.Production.dbo.line l on p.plant_id = l.plant_id
				Join SupplyChain.Region r on l.region = r.RegionName
				Join SupplyChain.Division d on r.DivisionID = d.DivisionID
				Left Join SupplyChain.PlantType pt on pt.PlantTypeName = p.plant_type
				Where d.DivisionName = l.division
			) AS input
			ON p.PlantSK = input.plant_id
	WHEN NOT MATCHED  THEN
		INSERT(PlantSK, PlantName, PlantDesc, RegionID, PlantTypeID, ChangeTrackNumber, LastModified)
		VALUES(input.plant_id, input.plant, input.plant_desc, input.regionID, input.PlantTypeID, input.ChangeTrackNumber, getdate());

	With Input As
	(
		Select distinct r.RegionID, p.plant_id, plant, plant_desc, pt.PlantTypeID, CheckSum(p.plant_id, plant, plant_desc, r.RegionID, pt.PlantTypeID) ChangeTrackNumber 
		From AIRVDB02.Production.dbo.plant p
		Join AIRVDB02.Production.dbo.line l on p.plant_id = l.plant_id
		Join SupplyChain.Region r on l.region = r.RegionName
		Join SupplyChain.Division d on r.DivisionID = d.DivisionID
		Left Join SupplyChain.PlantType pt on pt.PlantTypeName = p.plant_type
		Where d.DivisionName = l.division	
	)
	Update p
		Set p.PlantName = input.plant,
		  p.PlantDesc = input.plant_desc,
		  p.RegionID = input.RegionID,
		  p.PlantTypeID = input.PlantTypeID,
		  p.ChangeTrackNumber = input.ChangeTrackNumber,
		  p.LastModified = getdate()
	From SupplyChain.Plant p
	Join Input on p.PlantSK = input.plant_id 
	Where isnull(p.ChangeTrackNumber, 0) <> input.ChangeTrackNumber

	---- Filler Type ------------------------------------
	MERGE SupplyChain.FillerType AS d
		USING (select Distinct filler_type
			   from AIRVDB02.Production.dbo.line where filler_type is not null) AS input
			ON d.FillerTypeName = input.filler_type
	WHEN NOT MATCHED  THEN
		INSERT(FillerTypeName, LastModified)
		VALUES(input.filler_type, getdate());

	---- Line Type ------------------------------------
	MERGE SupplyChain.LineType AS d
		USING (select Distinct line_type
			   from AIRVDB02.Production.dbo.line where line_type is not null) AS input
			ON d.LineTypeName = input.line_type
	WHEN NOT MATCHED  THEN
		INSERT(LineTypeName, LastModified)
		VALUES(input.line_type, getdate());

	---- Line --------------------------------------
    MERGE SupplyChain.Line AS p
		USING (		Select l.line_id, l.line, p.PlantID, ft.FillerTypeID, lt.LineTypeID, CheckSum(l.line, p.PlantID, ft.FillerTypeID, lt.LineTypeID) ChangeTrackNumber 
					From AIRVDB02.Production.dbo.line l
					Join SupplyChain.Plant p on l.plant_id = p.PlantSK
					Left Join SupplyChain.FillerType ft on l.filler_type = ft.FillerTypeName
					Left Join SupplyChain.LineType lt on l.line_type = lt.LineTypeName
			) AS input
			ON p.LineSK = input.line_id
	WHEN NOT MATCHED  THEN
		INSERT(LineSK, LineName, PlantID, LineTypeID, FillerTypeID, ChangeTrackNumber, LastModified)
		VALUES(input.line_id, input.line, input.PlantID, input.LineTypeID, input.FillerTypeID, input.ChangeTrackNumber, getdate());

	With Input As
	(
		Select l.line_id, l.line, p.PlantID, ft.FillerTypeID, lt.LineTypeID, CheckSum(l.line, p.PlantID, ft.FillerTypeID, lt.LineTypeID) ChangeTrackNumber 
		From AIRVDB02.Production.dbo.line l
		Join SupplyChain.Plant p on l.plant_id = p.PlantSK
		Left Join SupplyChain.FillerType ft on l.filler_type = ft.FillerTypeName
		Left Join SupplyChain.LineType lt on l.line_type = lt.LineTypeName
	)
	Update l
		Set l.LineName = input.line,
		  l.PlantID = input.PlantID,
		  l.FillerTypeID = input.FillerTypeID,
		  l.LineTypeID = input.LineTypeID,
		  l.ChangeTrackNumber = input.ChangeTrackNumber,
		  l.LastModified = getdate()
	From SupplyChain.Line l
	Join Input on l.LineSK = input.line_id 
	Where isnull(l.ChangeTrackNumber, 0) <> input.ChangeTrackNumber

	---- Shift ------------------------------------
	MERGE SupplyChain.Shift AS d
		USING (select shift_id, shift
			   from AIRVDB02.Production.dbo.shift) AS input
			ON d.ShiftSK = input.Shift_id
	WHEN NOT MATCHED  THEN
		INSERT(ShiftID, ShiftSK, ShiftName, LastModified)
		VALUES(input.shift_id, input.shift_id, input.shift, getdate())
	When Matched Then
		Update
		Set ShiftName = input.shift, LastModified = getdate();

	---- DayLineShift ------------------------------------
	Declare @HDRLastModified DateTime
	Set @HDRLastModified = Convert(DateTime, '1800-1-1')
	Select Top 1 @HDRLastModified = IsNull(HDRLastModified, Convert(DateTime, '1800-1-1'))
	From SupplyChain.RefreshLog	
	Where HDRLastModified is not null
	Order By RefreshLogID Desc

	Declare @production_hdr TABLE (
		hdr_id int NOT NULL,
		run_date datetime NOT NULL,
		shift_duration int NOT NULL,
		line_id int NOT NULL,
		shift_id int NOT NULL,
		insert_date datetime NOT NULL,
		update_date datetime NULL,
		insert_by varchar(50) NOT NULL,
		update_by varchar(50) NULL)

	insert into @production_hdr(hdr_id, run_date, shift_duration, line_id, shift_id, insert_date, update_date, insert_by, update_by)
	select hdr_id, run_date, shift_duration, line_id, shift_id, insert_date, update_date, insert_by, update_by
	from AIRVDB02.Production.dbo.production_hdr hdr with(nolock)
	Where isnull(update_date, insert_date) > @HDRLastModified
	Or hdr.hdr_id Not in (Select DayLineShiftSK From SupplyChain.DayLineShift)

	--select * from @production_hdr

	Merge SupplyChain.DayLineShift As dls
		Using ( 
			Select hdr_id, d.DateID, shift_duration, l.LineID, s.ShiftID, isnull(update_date, insert_date) LastModified, 
				isnull(update_by, insert_by) LastModifiedBy 
			From @production_hdr hdr 
			Join SupplyChain.Line l on hdr.line_id = l.LineSK
			Join Shared.DimDate d on hdr.run_date = d.Date
			Join SupplyChain.Shift s on hdr.shift_id = s.ShiftSK) input
		On dls.DayLineShiftSK = input.hdr_id
	When Matched Then
		Update Set ShiftDuration = input.shift_duration,
		           RunDateID = input.DateID,
				   LineID = input.LineID,
				   ShiftID = input.ShiftID,
				   LastModified = input.LastModified,
				   LastModifiedBy = input.LastModifiedBy
	When Not Matched By Target Then
		Insert(DayLineShiftSK, ShiftDuration, RunDateID, LineID, ShiftID, LastModified, LastModifiedBy)
		Values(input.hdr_id, input.shift_duration, input.DateID, input.LineID, input.ShiftID, input.LastModified, input.LastModifiedBy);

	Delete SupplyChain.DayLineShift Where DayLineShiftSK not in (Select hdr_id From AIRVDB02.Production.dbo.production_hdr);

	--Select * From SupplyChain.DayLineShift Where DayLineShiftSK not in (Select hdr_id From AIRVDB02.Production.dbo.production_hdr)
	--Select * from AIRVDB02.Production.dbo.production_hdr where hdr_id Not in (Select DayLineShiftSK From SupplyChain.DayLineShift)

	Select @HDRLastModified = Max(LastModified)
	From SupplyChain.DayLineShift

	Update SupplyChain.RefreshLog
	Set HDRLastModified = @HDRLastModified
	Where RefreshLogID = @RefreshLogID;

	--CW: Not doing Product Alignment as of 9/8/2014 since don't understand why PT products are not alligned with SP7
	---- Product ------------------------------------
	--1. Suppliment SAP TradeMark
	--MERGE SAP.TradeMark AS d
	--	USING (select Distinct dbo.udf_TitleCase(super_brand) super_brand
	--			from AIRVDB02.Production.dbo.product p) AS input
	--		ON d.TradeMarkName = input.super_brand
	--WHEN NOT MATCHED  THEN
	--	INSERT(SAPTrademarkID, TrademarkName, FromSupplyChain, LastModified)
	--	VALUES('N/A', super_brand, 1, getdate());

	----2. Suppliment SAP Brand
	--MERGE SAP.Brand AS d
	--	USING (select Distinct t.TradeMarkID, dbo.udf_TitleCase(super_brand) super_brand, dbo.udf_TitleCase(brand) brand
	--				from AIRVDB02.Production.dbo.product p 
	--				Join SAP.Trademark t on dbo.udf_TitleCase(p.super_brand) = t.TradeMarkName
	--			) AS input
	--		ON d.BrandName = input.brand
	--WHEN NOT MATCHED  THEN
	--	INSERT(SAPBrandID, BrandName, TradeMarkID, FromSupplyChain, LastModified)
	--	VALUES('N/A', brand, input.TradeMarkID, 1, getdate());

	----3. Suppliment SAP Franchisor
	--MERGE SAP.Franchisor AS d
	--	USING (select Distinct dbo.udf_TitleCase(franchisor) franchisor
	--		   from AIRVDB02.Production.dbo.product p 
	--			) AS input
	--		ON d.FranchisorName = dbo.udf_TitleCase(input.franchisor)
	--WHEN NOT MATCHED  THEN
	--	INSERT(FranchisorName, SAPFranchisorID, FromSupplyChain, LastModified)
	--	VALUES(input.franchisor, 'N/A', 1, getdate());

	----4. Suppliment SAP BevType
	--MERGE SAP.BevType AS d
	--	USING (select Distinct dbo.udf_TitleCase(bev_type) bev_type
	--		   from AIRVDB02.Production.dbo.product p 
	--			) AS input
	--		ON d.BevTypeName = dbo.udf_TitleCase(input.bev_type)
	--WHEN NOT MATCHED  THEN
	--	INSERT(BevTypeName, SAPBevTypeID, FromSupplyChain, LastModified)
	--	VALUES(input.bev_type, 'N/A', 1, getdate());

	--5. Finally the Product
	MERGE SAP.Material AS m
	Using (
		select b.BevTypeID, t.TradeMarkID, Max(br.BrandID) BrandID, f.FranchisorID, p.product_code, p.product_desc, p.product_id
		from AIRVDB02.Production.dbo.product p
		Join SAP.BevType b on p.bev_type = b.BevTypeName
		Join SAP.Franchisor f on p.franchisor = f.FranchisorName		
		Join SAP.Brand br on br.BrandName = p.brand
		Join SAP.TradeMark t on br.TrademarkID = t.TradeMarkID
		Group By b.BevTypeID, t.TradeMarkID, f.FranchisorID, p.product_code, p.product_desc, p.product_id) input
		on m.SAPMaterialID = convert(varchar, input.product_code)
	--WHEN NOT MATCHED  THEN
	--	Insert(SAPMaterialID,MaterialName,FranchisorID,BevTypeID,BrandID,LastModified,FromSupplyChain, SupplyChainProductSK)
	--	Values(convert(varchar,input.product_code), dbo.udf_TitleCase(input.product_desc), input.FranchisorID, input.BevTypeID, input.BrandID, GetDate(), 1, input.product_id)
	When Matched Then
		Update Set SupplyChainProductSK = input.product_id;
		--Update Set SupplyChainProductSK = input.product_id, LastModified = GetDate();

	--MERGE SAP.Material AS m
	--Using (
	--	select b.BevTypeID, t.TradeMarkID, br.BrandID, f.FranchisorID, p.product_code, p.product_desc, p.product_id
	--	from AIRVDB02.Production.dbo.product p
	--	Join SAP.BevType b on p.bev_type = b.BevTypeName
	--	Join SAP.Franchisor f on p.franchisor = f.FranchisorName
	--	Join SAP.TradeMark t on p.super_brand = t.TradeMarkName
	--	Join SAP.Brand br on br.BrandName = p.brand and br.TrademarkID = t.TradeMarkID) input
	--	on m.SAPMaterialID = convert(varchar, input.product_code) 
	--		and m.FromSupplyChain = 1 
	--		--and isnull(CheckSum(m.BevTypeID, m.BrandID, m.FranchisorID, m.MaterialName), 0) <> CheckSum(input.BevTypeID, input.BrandID, input.FranchisorID, dbo.udf_TitleCase(input.product_desc))
	--WHEN MATCHED THEN
	--	Update Set MaterialName = dbo.udf_TitleCase(input.product_desc),
	--		FranchisorID = input.FranchisorID,
	--		BevTypeID = input.BevTypeID,
	--		BrandID = input.BrandID,
	--		SupplyChainProductSK = input.product_id,
	--		LastModified = GetDate();

	----This part take case of the set where the brand and trademark indication is in contradiction to each other
	--MERGE SAP.Material AS m
	--Using (
	--	select b.BevTypeID, t.TradeMarkID, br.BrandID, f.FranchisorID, p.product_code, p.product_desc, p.product_id
	--	From AIRVDB02.Production.dbo.product p
	--		Join SAP.BevType b on p.bev_type = b.BevTypeName
	--		Join SAP.Franchisor f on p.franchisor = f.FranchisorName
	--		Join SAP.TradeMark t on p.super_brand = t.TradeMarkName
	--		Join SAP.Brand br on br.BrandName = p.brand
	--		Where p.product_id 
	--		in (
	--			select p.product_id
	--			From AIRVDB02.Production.dbo.product p
	--			Join SAP.TradeMark t on p.super_brand = t.TradeMarkName
	--			left Join SAP.Brand br on br.BrandName = p.brand and t.TradeMarkID = br.TrademarkID
	--			Where br.BrandID is null)) input
	--	on m.SAPMaterialID = convert(varchar, input.product_code)
	--WHEN NOT MATCHED  THEN
	--	Insert(SAPMaterialID,MaterialName,FranchisorID,BevTypeID,BrandID,LastModified,FromSupplyChain, SupplyChainProductSK)
	--	Values(convert(varchar,input.product_code), dbo.udf_TitleCase(input.product_desc), 
	--		input.FranchisorID, input.BevTypeID, input.BrandID, GetDate(), 1, input.product_id)
	--When Matched Then
	--	Update Set SupplyChainProductSK = input.product_id, LastModified = GetDate();

	--MERGE SAP.Material AS m
	--Using (
	--	select b.BevTypeID, t.TradeMarkID, br.BrandID, f.FranchisorID, p.product_code, p.product_desc, p.product_id
	--	From AIRVDB02.Production.dbo.product p
	--		Join SAP.BevType b on p.bev_type = b.BevTypeName
	--		Join SAP.Franchisor f on p.franchisor = f.FranchisorName
	--		Join SAP.TradeMark t on p.super_brand = t.TradeMarkName
	--		Join SAP.Brand br on br.BrandName = p.brand
	--		Where p.product_id 
	--		in (
	--			select p.product_id
	--			From AIRVDB02.Production.dbo.product p
	--			Join SAP.TradeMark t on p.super_brand = t.TradeMarkName
	--			left Join SAP.Brand br on br.BrandName = p.brand and t.TradeMarkID = br.TrademarkID
	--			Where br.BrandID is null)) input
	--		on m.SAPMaterialID = convert(varchar, input.product_code) 
	--		and m.FromSupplyChain = 1 
	--WHEN MATCHED THEN
	--	Update Set MaterialName = dbo.udf_TitleCase(input.product_desc),
	--		FranchisorID = input.FranchisorID,
	--		BevTypeID = input.BevTypeID,
	--		BrandID = input.BrandID,
	--		SupplyChainProductSK = input.product_id,
	--		LastModified = GetDate();

	--Update SAP.Material Set ChangeTrackNumber = CHECKSUM(SAPMaterialID, MaterialName, FranchisorID, BevTypeID, BrandID, FlavorID, PackageID, CalorieClassID, InternalCategoryID, CaffeineClaimID, PPGID, SupplyChainProductSK), LastModified = GetDate()
	--Where isnull(ChangeTrackNumber,0) != CHECKSUM(SAPMaterialID, MaterialName, FranchisorID, BevTypeID, BrandID, FlavorID, PackageID, CalorieClassID, InternalCategoryID, CaffeineClaimID, PPGID, SupplyChainProductSK)

	/* Sanity check
	-- SC used SAP Product_Code as business Key
	Select product_code, count(*)
	from AIRVDB02.Production.dbo.product p
	group by product_code
	having count(*) > 1

	-- We have addional material that SC didn't capture
	Select *
	From SAP.Material
	Where SAPMaterialID not in (
		select distinct convert(varchar, product_code)
		from AIRVDB02.Production.dbo.product p
	)

	-- We captured every product SC has
	Select *
	from AIRVDB02.Production.dbo.product p
	Where convert(varchar, product_code) not in (
		select SAPMaterialID from SAP.Material
	)
	*/

	---- Run ------------------------------------
	---- Run ------------------------------------
	Declare @RunLastModified DateTime
	Set @RunLastModified = Convert(DateTime, '1800-1-1')
	Select Top 1 @RunLastModified = IsNull(RunLastModified, Convert(DateTime, '1800-1-1'))
	From SupplyChain.RefreshLog
	Where RunLastModified is not null
	Order By RefreshLogID Desc

	Declare @production_run TABLE (
		run_id int NOT NULL,
		run_duration int NOT NULL,
		actual_qty int NOT NULL,
		capacity_qty decimal(9, 2) NOT NULL,
		plan_qty decimal(9, 2) NOT NULL,
		insert_date datetime NOT NULL,
		product_id int NOT NULL,
		update_date datetime NULL,
		hdr_id int NOT NULL,
		insert_by varchar(50) NOT NULL,
		update_by varchar(50) NULL,
		item_number int NOT NULL)

	Insert @production_run(run_id, run_duration, actual_qty, capacity_qty, plan_qty, insert_date, product_id,update_date, hdr_id, insert_by, update_by, item_number)
	Select run_id, run_duration, actual_qty, capacity_qty, plan_qty, insert_date, product_id,update_date, hdr_id, insert_by, update_by, item_number
	From AIRVDB02.Production.dbo.production_run r with(nolock)
	Where isnull(update_date, insert_date) > @RunLastModified
	Or r.run_id Not in (Select RunSK From SupplyChain.Run)

	Merge SupplyChain.Run As r
		Using ( 
				Select r.run_id, r.run_duration, r.capacity_qty, r.plan_qty, r.hdr_id, dls.DayLineShiftID,
				convert(decimal(9,2), r.actual_qty) actual_qty, r.item_number,
				isnull(update_date, insert_date) LastModified, m.MaterialID,
				isnull(update_by, insert_by) LastModifiedBy
				From @production_run r
				Join SupplyChain.DayLineShift dls on r.hdr_id = dls.DayLineShiftSK
				Left Join SAP.Material m on r.product_id = m.SupplyChainProductSK) input
		On r.DayLineShiftSK = input.hdr_id and r.ItemNumber = input.item_number
	When Matched Then
		Update Set DayLineShiftID = input.DayLineShiftID,
				   RunSK = input.run_id,
				   MaterialID = input.MaterialID,
				   RunDuration = input.run_duration,
				   ActualQty = input.actual_qty,
				   CapacityQty = input.capacity_qty,
				   PlanQty = input.plan_qty,
				   LastModified = input.LastModified,
				   LastModifiedBy = input.LastModifiedBy
	When Not Matched Then
		Insert(RunSK, DayLineShiftID, DayLineShiftSK, ItemNumber, MaterialID, RunDuration, 
			ActualQty, CapacityQty, PlanQty, LastModified, LastModifiedBy)
		Values(input.run_id, input.DayLineShiftID, input.hdr_id, input.item_number, input.MaterialID, input.run_duration, 
			input.actual_qty, input.Capacity_Qty, input.Plan_Qty, input.LastModified, input.LastModifiedBy);
	--When Not Matched By Source Then
	--	Delete;

	Delete From SupplyChain.Run Where RunSK not in (Select run_id From AIRVDB02.Production.dbo.production_run);

	Select @RunLastModified = Max(LastModified)
	From SupplyChain.Run

	Update SupplyChain.RefreshLog
	Set RunLastModified = @RunLastModified
	Where RefreshLogID = @RefreshLogID;

	/* Sanity check
	--Select * From SupplyChain.Run Where RunSK not in (Select run_id From AIRVDB02.Production.dbo.production_run)
	--Select * from AIRVDB02.Production.dbo.production_run where run_id Not in (Select RunSK From SupplyChain.Run)

	select count(*)
	from (
		select distinct hdr_id, item_number
		From AIRVDB02.Production.dbo.production_run) tmp

	Select Count(*), max(LastModified) maxdate From SupplyChain.Run

	select count(run_id), max(isnull(update_date, insert_date)) maxdate
	From AIRVDB02.Production.dbo.production_run

	Select count(*)
	From AIRVDB02.Production.dbo.production_run
	*/

	------------------------------------------------------------
	---- DownTimeReasonType ------------------------------------
	MERGE SupplyChain.DownTimeReasonType AS d
		USING (Select distinct downtime_reason_type
			From AIRVDB02.Production.dbo.downtime_reason) AS input
			ON d.DownTimeReasonTypeName = input.downtime_reason_type
	WHEN NOT MATCHED  THEN
		INSERT(DownTimeReasonTypeName, LastModified)
		VALUES(dbo.udf_TitleCase(input.downtime_reason_type), getdate())
	When Matched Then
		Update
		Set DownTimeReasonTypeName = dbo.udf_TitleCase(input.downtime_reason_type);

	--------------------------------------------------------
	---- DownTimeReason ------------------------------------
	MERGE SupplyChain.DownTimeReason AS d
		USING (	Select downtime_reason_type, downtime_reason_id, downtime_reason_code, downtime_reason_desc, 
						Case When active_code = 'Yes' Then 1 Else 0 End active, rc.DownTimeReasonTypeID
				From AIRVDB02.Production.dbo.downtime_reason r
				Join SupplyChain.DownTimeReasonType rc on r.downtime_reason_type = rc.DownTimeReasonTypeName
				) AS input
			ON d.ReasonSK = input.downtime_reason_id
	WHEN NOT MATCHED  THEN
		INSERT(ReasonSK, ReasonCode, ReasonDesc, DownTimeReasonTypeID, Active, LastModified)
		VALUES(input.downtime_reason_id, input.downtime_reason_code, dbo.udf_TitleCase(input.downtime_reason_desc), input.DownTimeReasonTypeID, input.active, getdate())
	When Matched Then
		Update
		Set ReasonCode = input.downtime_reason_code,
		ReasonDesc = dbo.udf_TitleCase(input.downtime_reason_desc),
		Active = input.active,
		DownTimeReasonTypeID = input.DownTimeReasonTypeID,
		LastModified = getdate();

	--------------------------------------------------------
	---- DownTimeReasonDetail ------------------------------
	MERGE SupplyChain.DownTimeReasonDetail AS d
		USING (	Select downtime_reason_id, downtime_detail_code, downtime_reason_detail_id, dbo.udf_TitleCase(downtime_detail) downtime_detail, 
						Case When active_code = 'Yes' Then 1 Else 0 End active, rc.ReasonID
					From AIRVDB02.Production.dbo.downtime_reason_details r
					Join SupplyChain.DownTimeReason rc on r.downtime_reason_id = rc.ReasonSK
				) AS input
			ON d.ReasonDetailSK = input.downtime_reason_detail_id
	WHEN NOT MATCHED  THEN
		INSERT(ReasonDetailSK, ReasonID, ReasonDetailCode, ReasonDetailDesc, Active, LastModified)
		VALUES(input.downtime_reason_detail_id, input.ReasonID, input.downtime_detail_code, dbo.udf_TitleCase(input.downtime_detail), 
			input.active, getdate())
	When Matched Then
		Update
		Set ReasonDetailCode = input.downtime_detail_code,
		ReasonDetailDesc = dbo.udf_TitleCase(input.downtime_detail),
		Active = input.active,
		ReasonID = input.ReasonID,
		LastModified = getdate();

	---- DownTime ------------------------------------
	---- DownTime ------------------------------------
	Declare @DowntimeLastModified DateTime
	Set @DowntimeLastModified = Convert(DateTime, '1800-1-1')
	Select Top 1 @DowntimeLastModified = IsNull(DowntimeLastModified, Convert(DateTime, '1800-1-1'))
	From SupplyChain.RefreshLog
	Where DowntimeLastModified is not null
	Order By RefreshLogID Desc

	declare @downtime table (
		downtime_id int NOT NULL,
		hdr_id int NOT NULL,
		downtime_duration int NOT NULL,
		downtime_reason_id int NOT NULL,
		insert_date datetime NOT NULL,
		update_date datetime NULL,
		insert_by varchar(50) NOT NULL,
		update_by varchar(50) NULL,
		item_number int NOT NULL,
		downtime_reason_detail_id int NULL,
		labor_released varchar(3) NULL)

	Insert into @downtime(downtime_id, hdr_id,downtime_duration, downtime_reason_id, insert_date, update_date, 
		insert_by, update_by, item_number, downtime_reason_detail_id, labor_released)
	Select downtime_id, hdr_id,downtime_duration, downtime_reason_id, insert_date, update_date, 
		insert_by, update_by, item_number, downtime_reason_detail_id, labor_released From AIRVDB02.Production.dbo.downtime d with(nolock)
	Where isnull(update_date, insert_date) > @DowntimeLastModified
	Or d.downtime_id Not in (Select DownTimeSK From SupplyChain.DownTime)

	Merge SupplyChain.DownTime As r
		Using (	Select r.DayLineShiftID, drd.ReasonDetailID, dr.ReasonID ClaimedReasonID, isnull(update_date, insert_date) LastModified, d.downtime_id, d.downtime_duration,
				isnull(update_by, insert_by) LastModifiedBy, Case When labor_released = 'Yes' Then 1 Else 0 End labor_released, d.item_number
				From @downtime d
				Join SupplyChain.DayLineShift r on r.DayLineShiftSK = d.hdr_id
				Left Join SupplyChain.DownTimeReasonDetail drd on d.downtime_reason_detail_id = drd.ReasonDetailSK
				Left Join SupplyChain.DownTimeReason dr on d.downtime_reason_id = dr.ReasonSK) As input
		On r.DayLineShiftID = input.DayLineShiftID and r.ItemNumber = input.item_number
	When Matched Then
		Update Set DayLineShiftID = input.DayLineShiftID,
				   ItemNumber = input.item_number,
				   DownTimeSK = input.downtime_id,
		           Duration = input.downtime_duration,
				   ReasonDetailID = input.ReasonDetailID,
				   ClaimedReasonID = input.ClaimedReasonID,
				   LaborReleased = input.labor_released,
				   LastModified = input.LastModified,
				   LastModifiedBy = input.LastModifiedBy
	When Not Matched By Target Then
		Insert(DownTimeSK, DayLineShiftID, Duration, ReasonDetailID, ClaimedReasonID, LastModified, LastModifiedBy, LaborReleased, ItemNumber)
		Values(input.downtime_id, input.DayLineShiftID, input.downtime_duration, input.ReasonDetailID, input.ClaimedReasonID, 
			input.LastModified, input.LastModifiedBy, input.labor_released, input.item_number);
	--When Not Matched By Source Then
	--	Delete;

	Delete SupplyChain.DownTime Where DownTimeSK not in (Select downtime_id From AIRVDB02.Production.dbo.downtime);

	Update dls
	Set ShiftDownTime = isnull(temp.ShiftDownTime, 0)
	From SupplyChain.DayLineShift dls
	Left Join 
	(
	Select DayLineShiftID, Sum(Duration) ShiftDownTime
	From SupplyChain.DownTime
	Group By DayLineShiftID) Temp on dls.DayLineShiftID = Temp.DayLineShiftID;

	Select @DowntimeLastModified = Max(LastModified)
	From SupplyChain.DownTime

	Update SupplyChain.RefreshLog
	Set DowntimeLastModified = @DowntimeLastModified
	Where RefreshLogID = @RefreshLogID;

	--Select * From SupplyChain.DownTime Where DownTimeSK not in (Select downtime_id From AIRVDB02.Production.dbo.downtime)
	--Select * from AIRVDB02.Production.dbo.downtime where downtime_id Not in (Select DownTimeSK From SupplyChain.DownTime)

	---- The End ------------------------------------
	Update SupplyChain.RefreshLog
	Set EndTime = GetDate()
	Where RefreshLogID = @RefreshLogID

	------ check -------------------------------------
	Declare @Cnt varchar(10)
	Declare @AccuString varchar(128)

	Select @AccuString = Count(*) From SupplyChain.DayLineShift Where DayLineShiftSK not in (Select hdr_id From AIRVDB02.Production.dbo.production_hdr with(nolock))
	Set @AccuString += '|'

	Select @Cnt = Count(*) from AIRVDB02.Production.dbo.production_hdr with(nolock) where hdr_id Not in (Select DayLineShiftSK From SupplyChain.DayLineShift)
	Set @AccuString += @Cnt + '|'

	Select @Cnt = Count(*) From SupplyChain.Run Where RunSK not in (Select run_id From AIRVDB02.Production.dbo.production_run with(nolock))
	Set @AccuString += @Cnt + '|'

	Select @Cnt = Count(*) from AIRVDB02.Production.dbo.production_run with(nolock) where run_id Not in (Select RunSK From SupplyChain.Run)
	Set @AccuString += @Cnt + '|'

	Select @Cnt = Count(*) From SupplyChain.DownTime Where DownTimeSK not in (Select downtime_id From AIRVDB02.Production.dbo.downtime with(nolock))
	Set @AccuString += @Cnt + '|'

	Select @Cnt = Count(*) from AIRVDB02.Production.dbo.downtime with(nolock) where downtime_id Not in (Select DownTimeSK From SupplyChain.DownTime)
	Set @AccuString += @Cnt

	Update SupplyChain.RefreshLog
	Set SanityCheck = @AccuString
	Where RefreshLogID = @RefreshLogID
	
End





GO
/****** Object:  StoredProcedure [ETL].[pLoadAndProcessRMOpanOrder]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* 
exec ETL.pLoadAndProcessRMOpanOrder 

*/

Create Proc [ETL].[pLoadAndProcessRMOpanOrder]
AS		
	Set NoCount On;
	Declare @LastLoadTime DateTime
	Declare @LogID bigint 
	Declare @RecordCount int
	Declare @LastRecordDate DateTime

	------------------------------------------------------
	------------------------------------------------------
	Truncate Table Apacheta.OriginalOrder;

	Insert ETL.BCDataLoadingLog([SchemaName], [TableName], [StartDate])
	Values ('Apacheta', 'OriginalOrder', SYSDATETIME())

	Select @LogID = SCOPE_IDENTITY()
	------------------------------------------------------
	Insert Into Apacheta.OriginalOrder
			   (DeliveryDate
			   ,SAPBranchID
			   ,RouteNumber
			   ,SAPMaterialID
			   ,OrderNumber
			   ,CaseQuantity)
	Select DELIVERYDATE, SAPBRANCHID, ROUTE_NUMBER, ITEM_NUMBER, ORDER_NUMBER, CASEQTY
	From OPENQUERY(RM, 'SELECT 
	O.DELIVERYDATE, SUBSTR(O.ROUTE_NUMBER, 1, 4) SAPBRANCHID, O.ROUTE_NUMBER, 
	D.ITEM_NUMBER, O.ORDER_NUMBER, D.CASEQTY
	FROM ACEUSER.ORIGINAL_ORDER_MASTER O, 
	ACEUSER.ORIGINAL_ORDER_DETAIL D
	WHERE O.ORDER_NUMBER = D.ORDER_NUMBER
	AND O.DELIVERYDATE > SYSDATE
	AND D.TYPE = ''O'''  )

	Select @RecordCount = Count(*) From Apacheta.OriginalOrder
	Select @LastRecordDate = SYSDATETIME()

	Update ETL.BCDataLoadingLog 
	Set EndDate = GetDate(), NumberOfRecordsLoaded = @RecordCount, LatestLoadedRecordDate = @LastRecordDate
	Where LogID = @LogID

	--------------------------------------------
	Truncate Table SupplyChain.tDsdOpenOrder;

	Insert Into SupplyChain.tDsdOpenOrder
	Select SupplyChain.udfConvertToDateID(DeliveryDate) DateID, a.RegionID, b.BranchID, 
	t.ProductLineID, bd.TradeMarkID, bd.BrandID,
	m.MaterialID, m.PackageID, p.PackageConfID, p.PackageTypeID, Sum(CaseQuantity) Quantity
	From Apacheta.OriginalOrder oo
	Join SAP.Branch b on oo.SAPBranchID = b.SAPBranchID
	Join SAP.Material m on oo.SAPMaterialID = m.SAPMaterialID
	Left Join SAP.Area a on b.AreaID = a.AreaID
	Left Join SAP.Brand bd on m.BrandID = bd.BrandID
	Left Join SAP.TradeMark t on bd.TrademarkID = t.TradeMarkID
	Left Join SAP.Package p on m.PackageID = p.PackageID
	Group By SupplyChain.udfConvertToDateID(DeliveryDate), a.RegionID, b.BranchID, 
	t.ProductLineID, bd.TradeMarkID, bd.BrandID,
	m.MaterialID, m.PackageID, p.PackageConfID, p.PackageTypeID

	Update ETL.BCDataLoadingLog
	Set MergeDate = SYSDATETIME()
	Where LogID = @LogID

	------- Potential Casecut -----------------
	Declare @Yesterday int
	Declare @Today int
	Declare @Tomorrow int
	Declare @DayAfterTomorrow int
	Set @Today = SupplyChain.udfConvertToDateID(GetDate());
	Set @Yesterday = SupplyChain.udfConvertToDateID(DateAdd(d, -1, GetDate()));
	Set @Tomorrow = SupplyChain.udfConvertToDateID(DateAdd(d, 1, GetDate()));
	Set @DayAfterTomorrow = SupplyChain.udfConvertToDateID(DateAdd(d, 2, GetDate()));

	Truncate Table SupplyChain.tDsdPotentialCaseCut;

	Insert Into Supplychain.tDsdPotentialCaseCut
	Select invt.RegionID, invt.TradeMarkID, invt.PackageID, invt.PackageTypeID, invt.BranchID, invt.MaterialID, 1, invt.EndingInventory, isnull(shipping.Shipment, 0) Shipment, oo.OpenOrder, 
	Case When 
		invt.EndingInventory - isnull(shipping.Shipment, 0) - isnull(oo.OpenOrder, 0) >= 0 Then 0 -- No casecut
	Else
		-1 * (invt.EndingInventory - isnull(shipping.Shipment, 0) - isnull(oo.OpenOrder, 0)) 
	End PotentialCaseCut, 0
	From 
	(
	Select RegionID, TrademarkID, PackageID, PackageTypeID, BranchID, MaterialID, Sum(EndingInventoryCapped) EndingInventory
	From SupplyChain.tDsdDailyBranchInventory invt
	Where invt.DateID = @Yesterday
	Group By RegionID, MaterialID, TrademarkID, BranchID, PackageID, PackageTypeID
	) invt
	Left Join
	(Select MaterialID, BranchID, Sum(Quantity) - Sum(CaseCut) Shipment
	From SupplyChain.tDsdDailyCaseCut
	Where DateID = @Today
	Group By MaterialID, BranchID
	) shipping on invt.MaterialID = shipping.MaterialID and invt.BranchID = shipping.BranchID
	Left Join
	(Select MaterialID, BranchID, Sum(Quantity) OpenOrder
	From SupplyChain.tDsdOpenOrder
	Where
	(DateID = @Tomorrow) 
	--Or (@HowFarInTheFuture = 2 And (DateID = @Tomorrow Or DateID = @DayAfterTomorrow))
	Group By MaterialID, BranchID
	) oo on invt.MaterialID = oo.MaterialID and invt.BranchID = oo.BranchID
	Where isnull(oo.OpenOrder, 0) > 0

	--
	Insert Into Supplychain.tDsdPotentialCaseCut
	Select invt.RegionID, invt.TradeMarkID, invt.PackageID, invt.PackageTypeID, invt.BranchID, invt.MaterialID, 2, invt.EndingInventory, isnull(shipping.Shipment, 0) Shipment, oo.OpenOrder, 
	Case When 
		invt.EndingInventory - isnull(shipping.Shipment, 0) - isnull(oo.OpenOrder, 0) >= 0 Then 0 -- No casecut
	Else
		-1 * (invt.EndingInventory - isnull(shipping.Shipment, 0) - isnull(oo.OpenOrder, 0)) 
	End PotentialCaseCut, 0
	From 
	(
	Select RegionID, TrademarkID, PackageID, PackageTypeID, BranchID, MaterialID, Sum(EndingInventoryCapped) EndingInventory
	From SupplyChain.tDsdDailyBranchInventory invt
	Where invt.DateID = @Yesterday
	Group By RegionID, MaterialID, TrademarkID, BranchID, PackageID, PackageTypeID
	) invt
	Left Join
	(Select MaterialID, BranchID, Sum(Quantity) - Sum(CaseCut) Shipment
	From SupplyChain.tDsdDailyCaseCut
	Where DateID = @Today
	Group By MaterialID, BranchID
	) shipping on invt.MaterialID = shipping.MaterialID and invt.BranchID = shipping.BranchID
	Left Join
	(Select MaterialID, BranchID, Sum(Quantity) OpenOrder
	From SupplyChain.tDsdOpenOrder
	Where
		(DateID = @Tomorrow Or DateID = @DayAfterTomorrow)
		Group By MaterialID, BranchID
	) oo on invt.MaterialID = oo.MaterialID and invt.BranchID = oo.BranchID
	Where isnull(oo.OpenOrder, 0) > 0

	Update Supplychain.tDsdPotentialCaseCut
	Set PotentialCaseCut = Case When PotentialCaseCut > OpenOrder Then OpenOrder Else PotentialCaseCut End,
	PotentialOOS = PotentialCaseCut*1.0 / OpenOrder


GO
/****** Object:  StoredProcedure [ETL].[pLoadFromRM2]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [ETL].[pLoadFromRM2]
AS		
	Set NoCount On;
	Declare @LastLoadTime DateTime
	Declare @LogID bigint 
	Declare @RecordCount int
	Declare @LastRecordDate DateTime

	------------------------------------------------------
	------------------------------------------------------
	Select @LastLoadTime = MINSESSION_DATE
	From OPENQUERY(RM, 'SELECT 
	MIN(SESSION_DATE) MINSESSION_DATE
	FROM ACEUSER.FLEETLOADER_VIEW' )

	Insert ETL.BCDataLoadingLog([SchemaName], [TableName], [StartDate])
	Values ('Apacheta', 'FleetLoader', SYSDATETIME())

	Select @LogID = SCOPE_IDENTITY()

	Delete From Apacheta.FleetLoader Where SESSION_DATE >= @LastLoadTime

	----------------------------------------
	INSERT INTO Apacheta.FleetLoader
			   (SESSION_DATE
			   ,ROUTE_ID
			   ,LOCATION_ID
			   ,ORDER_NUMBER
			   ,BAY_NUMBER
			   ,SKU
			   ,QUANTITY
			   ,TOTAL_QUANTITY
			   ,LAST_UPDATE)
	Select *
	From OPENQUERY(RM, 'SELECT 
	SESSION_DATE, 
	ROUTE_ID, 
	LOCATION_ID, 
	ORDER_NUMBER, 
	BAY_NUMBER, 
	SKU, 
	QUANTITY, 
	TOTAL_QUANTITY, 
	Coalesce(UPDATE_TIME, INSERT_TIME) LAST_UPDATE
	FROM ACEUSER.FLEETLOADER_VIEW' )
	----------------------------------------

	Select @RecordCount = Count(*) From Apacheta.FleetLoader Where SESSION_DATE >= @LastLoadTime
	Select @LastRecordDate = @LastLoadTime

	Update ETL.BCDataLoadingLog 
	Set EndDate = GetDate(), NumberOfRecordsLoaded = @RecordCount, LatestLoadedRecordDate = @LastRecordDate
	Where LogID = @LogID
	------------------------------------------------------
	------------------------------------------------------


GO
/****** Object:  StoredProcedure [ETL].[pMergeDSDCaseCut]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* 
exec ETL.pMergeDSDCaseCut 20140827

Select top 1000 * From SupplyChain.tDsdDailyCaseCut


Select Distinct BranchID
From SupplyChain.tDsdDailyCaseCut

Select Distinct(Left(ROUTE_ID, 4)) SAPSalesOffice
From Apacheta.FleetLoader
Where Left(ROUTE_ID, 4) Not In
(Select SAPBranchID From SAP.Branch)

Select *
From Apacheta.FleetLoader
Where Left(ROUTE_ID, 4) = 'PREB'

*/

CREATE Proc [ETL].[pMergeDSDCaseCut]
(
	@DateBackTo int = null
)
AS		
	Set NoCount On;

	Declare @MinDate Date;
	Declare @LogID int;

	Select Top 1 @MinDate = LatestLoadedRecordDate, @LogID = LogID
	From ETL.BCDataLoadingLog
	Where TableName = 'FleetLoader'
	And NumberOfRecordsLoaded > 0
	And IsMerged = 0

	--------------------------------------
	If (@DateBackTo is not null)
	Begin
		Set @MinDate = SupplyChain.udfConvertToDate(@DateBackTo)
		Set @LogID = null
	End

	--------------------------------------
	--------------------------------------
	If (@MinDate is null) -- Alredy merged and won't merge again
		return
	--------------------------------------
	--------------------------------------

	Delete cc
	From SupplyChain.tDsdDailyCaseCut cc
	Where cc.DateID >= SupplyChain.udfConvertToDateID(@MinDate)

	Insert Into SupplyChain.tDsdDailyCaseCut
           (DateID
		   ,RegionID
           ,BranchID
		   ,ProductLineID
		   ,TradeMarkID
		   ,BrandID
           ,MaterialID
		   ,PackageID
		   ,PackageConfID
		   ,PackageTypeID
           ,Quantity
           ,CaseCut
		   ,UpdateDate)
	Select d.DateID, a.RegionID, b.BranchID, 
	t.ProductLineID, bd.TradeMarkID, bd.BrandID,
	m.MaterialID, m.PackageID, p.PackageConfID, p.PackageTypeID,
	rd.Quantity, 0, SYSDATETIME()
	From 
		(Select SESSION_DATE, Left(ROUTE_ID, 4) SAPSalesOffice, SKU, Sum(QUANTITY) Quantity
		From Apacheta.FleetLoader
		Where SESSION_DATE >= @MinDate
		And QUANTITY > 0
		Group By SESSION_DATE, Left(ROUTE_ID, 4), SKU) rd
	Join Shared.DimDate d on rd.SESSION_DATE = d.Date
	Join SAP.Branch b on rd.SAPSalesOffice = b.SAPBranchID
	Left Join SAP.Area a on b.AreaID = a.AreaID
	Join SAP.Material m on rd.SKU = m.SAPMaterialID
	Left Join SAP.Brand bd on m.BrandID = bd.BrandID
	Left Join SAP.TradeMark t on bd.TrademarkID = t.TradeMarkID
	Left Join SAP.Package p on m.PackageID = p.PackageID

	-- Why not use the same insert query? I don't remember
	Update total
	Set CaseCut = cc.CaseCut,
	UpdateDate = SYSDATETIME()
	From SupplyChain.tDsdDailyCaseCut total
	Join 
		(
			Select d.DateID, b.BranchID, m.MaterialID, rd.CaseCut
			From 
				(
					Select SESSION_DATE, Left(ROUTE_ID, 4) SAPSalesOffice, SKU, 
						Sum(QUANTITY - TOTAL_QUANTITY) CaseCut, 
						Sum(QUANTITY) Quantity
					From Apacheta.FleetLoader
					Where 
					QUANTITY > 0
					And SESSION_DATE >= @MinDate
					And QUANTITY > TOTAL_QUANTITY 
					Group By SESSION_DATE, Left(ROUTE_ID, 4), SKU
				) rd
			Join SAP.Branch b on rd.SAPSalesOffice = b.SAPBranchID
			Join SAP.Material m on rd.SKU = m.SAPMaterialID
			Join Shared.DimDate d on rd.SESSION_DATE = d.Date
		) as cc on cc.BranchID = total.BranchID And cc.DateID = total.DateID And cc.MaterialID = total.MaterialID

	----------------------------------------
	----------------------------------------
	Update ETL.BCDataLoadingLog
	Set MergeDate = SYSDATETIME()
	Where  LogID = @LogID
	----------------------------------------
	----------------------------------------




GO
/****** Object:  StoredProcedure [ETL].[pMergeDSDDailyBranchInventory]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Select *
--From SupplyChain

--Select Distinct b.SAPMaterialID

--Select Distinct t.TradeMarkID, t.TradeMarkName
--From SAP.BP7SalesOfficeInventory b
--Join SAP.Material m on b.SAPMaterialID = m.SAPMaterialNumber
--Join SAP.Brand bd on m.BrandID = bd.BrandID
--Join SAP.TradeMark t on bd.TrademarkID = t.TradeMarkID
--Where CalendarDate = 20141125
--And SAPSalesOfficeNumber = 1108
--Order by TradeMarkName

--Select *
--From SAP.Material

--Select *
--From SAP.TradeMark

--Select SAPPlantID, BranchName, SAPBranchID, BranchID
--From SAP.Branch
--Order By SAPPlantID




-------------------------------
--Select *
--From SAP.Branch
--Where BranchName = 'Austin'


/* 
exec ETL.pMergeDSDDailyBranchInventory

exec ETL.pMergeDSDDailyBranchInventory 1

--what is 1188? BC BU, ignored intentaionally
Select *
From SupplyChain.tDsdDailyBranchInventory
Where DateID = 20141014


select DateID, MaterialID, BranchID, Past31DaysXferOutPlusShipment 
from SupplyChain.tDsdDailyBranchInventory
Where DateID = 20141013

Select DateID, Sum(Case When CustomerShipment < 0 Then CustomerShipment*-1 Else 0 End ) + Sum(Case When TransferOut < 0 Then TransferOut*-1 Else 0 End)
Select *

Select Sum(Case When CustomerShipment < 0 Then CustomerShipment*-1 Else 0 End ) + Sum(Case When TransferOut < 0 Then TransferOut*-1 Else 0 End)
From SupplyChain.tDsdDailyBranchInventory
Where DateID > 20140912 and DateID <= 20141013
And BranchID = 1
And MaterialID = 37

Select Distinct DateID, UpdateDate
From SupplyChain.tDsdDailyBranchInventory
Order By DateID Desc

exec ETL.pMergeDSDDailyBranchInventory 1

*/

CREATE Proc [ETL].[pMergeDSDDailyBranchInventory]
(
	@Refreshall bit = 0
)
AS		
	Set NoCount On;

	Declare @DateIDEffective int;

	Select @DateIDEffective = Min(CalendarDate)
	From Staging.BP7DailySalesOfficeInventory
	--------------------------------------
	--------------------------------------

	If (@Refreshall = 0) 
	Begin
		Delete cc
		From SupplyChain.tDsdDailyBranchInventory cc
		Where cc.DateID >= @DateIDEffective
	End
	Else
	Begin
	
		Truncate Table SupplyChain.tDsdDailyBranchInventory
	End

	--------------------------------------------------
	Insert Into SupplyChain.tDsdDailyBranchInventory
           (DateID
		   ,BUID
		   ,RegionID
		   ,AreaID
           ,BranchID
		   ,ProductLineID
		   ,TradeMarkID
		   ,BrandID
           ,MaterialID
		   ,PackageID
		   ,PackageConfID
		   ,PackageTypeID
           ,EndingInventory
           ,TransferOut
           ,CustomerShipment
           ,EndingInventoryCapped
           ,TransferOutCapped
           ,CustomerShipmentCapped
		   ,UpdateDate)
	SELECT minMax.CalendarDate, bu.BUID, r.RegionID, a.AreaID, BranchID, 
		t.ProductLineID, t.TradeMarkID, bd.BrandID, m.MaterialID, p.PackageID, p.PackageConfID, p.PackageTypeID
		, EndingInventory, TransferOut, CustomerShipment
		, Case When EndingInventory < 0 Then 0 Else EndingInventory End
		, Case When TransferOut > 0 Then 0 Else TransferOut End
		, Case When CustomerShipment > 0 Then 0 Else CustomerShipment End
		,SYSDATETIME()
	FROM SAP.BP7SalesOfficeInventory minmax
	Join SAP.Branch b on minmax.SAPSalesOfficeNumber = b.SAPBranchID
	Left Join SAP.Area a on b.AreaID = a.AreaID
	Left Join SAP.Region r on a.RegionID = r.RegionID
	Left Join SAP.BusinessUnit bu on r.BUID = bu.BUID
	Join SAP.Material m on m.SAPMaterialNumber = minmax.SAPMaterialID
	Left Join SAP.Brand bd on m.BrandID = bd.BrandID
	Left Join SAP.TradeMark t on bd.TrademarkID = t.TradeMarkID
	Left Join SAP.Package p on m.PackageID = p.PackageID
	Where @Refreshall = 1 Or CalendarDate >= @DateIDEffective

	Update inv
	Set Past31DaysXferOutPlusShipment = agg.Past30DaysXferOutPlusShipment, UpdateDate = SYSDATETIME(),
		Past31DaysShipment = agg.Past30DaysShipment,
		DOS = Case When agg.Past30DaysXferOutPlusShipment = 0 Then 0 -- 999999 for infinity					
				   Else EndingInventory / agg.Past30DaysXferOutPlusShipment * 30
				   End,
		DOSShipment = Case When agg.Past30DaysShipment = 0 Then 0 -- 999999 for infinity					
				   Else EndingInventory / agg.Past30DaysShipment * 30
				   End
	From SupplyChain.tDsdDailyBranchInventory inv
	Join 
	(
		Select r.DateID, NonDapped.BranchID, NonDapped.MaterialID, Sum(-1.0*TransferOut + -1.0*CustomerShipment) Past30DaysXferOutPlusShipment, Sum(-1.0*CustomerShipment) Past30DaysShipment
		From Shared.DimDate R
		Join SupplyChain.tDsdDailyBranchInventory NonDapped on NonDapped.DateID > R.Last31DaysBeginingDateID And NonDapped.DateID <= R.DateID
		Where  @Refreshall = 1 Or R.DateID >= @DateIDEffective
		Group By r.DateID, NonDapped.BranchID, NonDapped.MaterialID ) agg on inv.BranchID = agg.BranchID And inv.MaterialID = agg.MaterialID And inv.DateID = agg.DateID

	--Select Sum(Case When CustomerShipment < 0 Then CustomerShipment*-1 Else 0 End ) + Sum(Case When TransferOut < 0 Then TransferOut*-1 Else 0 End)
	--From SupplyChain.tDsdDailyBranchInventory
	--Where DateID > 20140912 and DateID <= 20141013
	--And BranchID = 1
	--And MaterialID = 37

	--Select *
	--From SupplyChain.tDsdDailyBranchInventory
	--Where DateID > 20140912 and DateID <= 20141013
	--And BranchID = 1
	--And MaterialID = 37

	--Select DateID, Last31DaysBeginingDateID
	--From Shared.DimDate
	--Where DateID = 20141013

	--Select DateID, MaterialID, BranchID, TransferOut, CustomerShipment, EndingInventory
	--From
	--(
	--	Select DateID, MaterialID, BranchID, 
	--		Case When TransferOut < 0 Then TransferOut*-1 Else 0 End TransferOut, 
	--		Case When CustomerShipment < 0 Then CustomerShipment*-1 Else 0 End CustomerShipment,
	--		EndingInventory
	--	From SupplyChain.tDsdDailyBranchInventory
	--) Capped

	--Select *
	--From SupplyChain.tDsdDailyBranchInventory
	--Where TransferOut > 0


GO
/****** Object:  StoredProcedure [ETL].[pMergeDSDDailyMinMax]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* 
exec ETL.pMergeDSDDailyMinMax
exec ETL.pMergeDSDDailyMinMax 1

select Distinct DateID from SupplyChain.tDsdDailyMinMax
Order by DateID desc

*/

CREATE Proc [ETL].[pMergeDSDDailyMinMax]
(
	@Refreshall bit = 0
)
AS		
	Set NoCount On;

	Declare @CalendarDate int;
	Declare @UnderTolerance decimal(5,1)
	Set @UnderTolerance = 0.5
	Declare @OverTolerance decimal(5,1)
	Set @OverTolerance = 1.2
	--------------------------------------
	--------------------------------------

	If (@Refreshall = 0) 
	Begin
		Delete cc
		From SupplyChain.tDsdDailyMinMax cc
		Where cc.DateID in (
			Select Distinct CalendarDate
			From Staging.BP7DailySalesOfficeMinMax
		)
	End
	Else
	Begin
		Truncate Table SupplyChain.tDsdDailyMinMax
	End

	----------------------------------------------------
	Insert Into SupplyChain.tDsdDailyMinMax
           (DateID
		   ,BUID
		   ,RegionID
		   ,AreaID
           ,BranchID
		   ,ProductLineID
		   ,TradeMarkID
		   ,BrandID
           ,MaterialID
		   ,PackageID
		   ,PackageConfID
		   ,PackageTypeID
           ,EndingInventory
		   ,EndingInventoryCapped
           ,MaxStock
           ,SafetyStock
		   ,AvailableStock
		   ,MinSafetyStock
		   ,IsBelowMin
		   ,IsCompliant
		   ,IsAboveMax
		   ,UpdateDate)
	SELECT minMax.CalendarDate, bu.BUID, r.RegionID, a.AreaID, BranchID, 
		t.ProductLineID, t.TradeMarkID, bd.BrandID, m.MaterialID, p.PackageID, p.PackageConfID, p.PackageTypeID
		, EndingInventory,
		Case When EndingInventory < 0 Then 0 Else EndingInventory End EndingInventoryCapped, 
		 MaxStock, SafetyStock, AvailableStock, MinSafetyStock
		,Case When MinSafetyStock <> 0 And AvailableStock < MinSafetyStock * @UnderTolerance Then 1 Else 0 End
		,Case When MinSafetyStock = 0 OR (AvailableStock >= MinSafetyStock * @UnderTolerance And AvailableStock <= MaxStock * @OverTolerance) OR (MaxStock = 0) Then 1 Else 0 End
		,Case When MaxStock <> 0 And AvailableStock > MaxStock * @OverTolerance Then 1 Else 0 End
		,SYSDATETIME()
	FROM SAP.BP7SalesOfficeMinMax minmax
	Join SAP.Branch b on minmax.SAPSalesOfficeNumber = b.SAPBranchID
	Left Join SAP.Area a on b.AreaID = a.AreaID
	Left Join SAP.Region r on a.RegionID = r.RegionID
	Left Join SAP.BusinessUnit bu on r.BUID = bu.BUID
	Join SAP.Material m on m.SAPMaterialNumber = minmax.SAPMaterialID
	Left Join SAP.Brand bd on m.BrandID = bd.BrandID
	Left Join SAP.TradeMark t on bd.TrademarkID = t.TradeMarkID
	Left Join SAP.Package p on m.PackageID = p.PackageID
	Where 
	(@Refreshall = 1)
	Or
	(CalendarDate in (
			Select Distinct CalendarDate
			From Staging.BP7DailySalesOfficeMinMax
		)
	)


GO
/****** Object:  StoredProcedure [ETL].[pProductionLinefilling]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [ETL].[pProductionLinefilling]
(
	@NumberOfHistoryToPrecal int = 3
)
As
Set NoCount On;
Begin

	Truncate Table SupplyChain.tLineDailyKPI

	Insert Into SupplyChain.tLineDailyKPI
           (DateID
           ,LineID
           ,SumActualQty
           ,SumCapacityQty
           ,SumPlanQty
           ,CountRun,
		   [SumDuration], [CountFlavorCO], [SumFlavorCODuration], CountPkgCO, SumPkgCODuration, [CountCO], [SumCODuration]
		   )
	Select dls.RunDateID, 
	dls.LineID, 
	isnull(sum(r.ActualQty), 0) ActualQty, 
	isnull(sum(r.CapacityQty), 0) CapacityQty, 
	isnull(sum(r.PlanQty), 0) PlanQty, 
	isnull(Count(RunID), 0) CountRun,
	0,0,0,0,0,0,0
	From SupplyChain.DayLineShift dls
	Join SupplyChain.Run r on dls.DayLineShiftID = r.DayLineShiftID
	Join Shared.DimDate dd on dd.DateID = dls.RunDateID
	Group by dls.LineID, dls.RunDateID
	Having dls.RunDateID > (DatePart(YYYY, SYSDATETIME()) - 2) * 10000

	----------------------------
	--- Verify -----------------
	--Select DateID, LineID, SumActualQty, SumCapacityQty, SumPlanQty, CountRun
	--From SupplyChain.tLineDailyKPI
	--Where SumCapacityQty = 0

	----------------------------

	Update tl
	Set tl.SumDuration = s.SumDuration
	From SupplyChain.tLineDailyKPI tl
	Join (
		Select RunDateID DateID, LineID, isnull(Sum(dls.ShiftDuration), 0) SumDuration
		From SupplyChain.DayLineShift dls 
		Group By dls.RunDateID, dls.LineID
	) s On s.DateID = tl.DateID And s.LineID = tl.LineID

	----------------------------
	--- Verify -----------------
	--Select DateID, LineID, SumActualQty, SumCapacityQty, SumPlanQty, CountRun, SumDuration
	--From SupplyChain.tLineDailyKPI
	--Where SumCapacityQty = 0
	--Or SumDuration = 0

	--Select * From SupplyChain.tLineDailyKPI
	----------------------------

	--- Filling Flavor Change Orver Time Aggregation ----
	Update tl
	Set tl.CountFlavorCO = flv.Cnt, tl.SumFlavorCODuration = flv.SumDuration,
	tl.AvgFlavorCODuration = (case when flv.Cnt = (0) then NULL else flv.SumDuration/(flv.Cnt*1.0) end)
	From SupplyChain.tLineDailyKPI tl
	Join (
	Select dls.RunDateID, dls.LineID, isnull(Sum(dt.Duration), 0) SumDuration, isnull(Count(dt.DownTimeID), 0) Cnt
	From SupplyChain.DownTime dt
	Join SupplyChain.DayLineShift dls on dt.DayLineShiftID = dls.DayLineShiftID
	Where ClaimedReasonID = 7
	Group By dls.RunDateID, dls.LineID) flv
	On tl.DateID = flv.RunDateID And flv.LineID = tl.LineID
	---------------------------

	--- Filling Package Change Orver Time Aggregation ----
	Update tl
	Set tl.CountPkgCO = pck.Cnt, tl.SumPkgCODuration = pck.SumDuration,
	tl.AvgPkgCODuration = (case when pck.Cnt = (0) then NULL else pck.SumDuration/(pck.Cnt*1.0) end)
	From SupplyChain.tLineDailyKPI tl
	Join (
	Select dls.RunDateID, dls.LineID, isnull(Sum(dt.Duration), 0) SumDuration, isnull(Count(dt.DownTimeID), 0) Cnt
	From SupplyChain.DownTime dt
	Join SupplyChain.DayLineShift dls on dt.DayLineShiftID = dls.DayLineShiftID
	Where ClaimedReasonID = 8
	Group By dls.RunDateID, dls.LineID) pck
	On tl.DateID = pck.RunDateID And pck.LineID = tl.LineID

	----------------------------
	Update tl
	Set tl.CountCO = flv.Cnt, tl.SumCODuration = flv.SumDuration,
	tl.TME =(tl.SumActualQty/tl.SumCapacityQty + flv.SumDuration/tl.SumDuration)
	From SupplyChain.tLineDailyKPI tl
	Join (
	Select dls.RunDateID, dls.LineID, isnull(Sum(dt.Duration), 0) SumDuration, isnull(Count(dt.DownTimeID), 0) Cnt
	From SupplyChain.DownTime dt
	Join SupplyChain.DownTimeReason reason on dt.ClaimedReasonID = reason.ReasonID
	Join SupplyChain.DayLineShift dls on dt.DayLineShiftID = dls.DayLineShiftID
	Where DownTimeReasonTypeID = 3
	Group By dls.RunDateID, dls.LineID) flv
	On tl.DateID = flv.RunDateID And flv.LineID = tl.LineID

	Update SupplyChain.tLineDailyKPI
	Set AdjustedSumCODuration = Case When TME <= 1.0 Then SumCODuration
			Else (1.0 - SumActualQty/tl.SumCapacityQty) * SumDuration End
	From SupplyChain.tLineDailyKPI tl

	----------------------------
	--- Verify -----------------
	--Select * From SupplyChain.tLineDailyKPI
	--Where TME > 1.0  -- Should we cap this?
	---------------------------

	------------------------------------------------
	-- Populate KPI details(Customized Aggegation)--
	Truncate Table SupplyChain.tLineKPI

	---- Month To Date Aggregation ----
	Insert Into SupplyChain.tLineKPI
			   (AnchorDateID
			   ,AggregationID
			   ,LineID
			   ,SumFlavorCODuration
			   ,CountFlavorCO
			   ,SumActualQty
			   ,SumCapacityQty
			   ,SumPlanQty
			   ,SumDuration
			   ,SumCODuration)
	Select rt.DateID, 3 AggregationID, rt.LineID, 
			sum(rs.SumFlavorCODuration) SumFlavorCODuration
			,sum(rs.CountFlavorCO) CountFlavorCO
			,sum(rs.SumActualQty) SumActualQty
			,sum(rs.SumCapacityQty) SumCapacityQty
			,Sum(rs.SumPlanQty) SumPlanQty 
			,sum(rs.SumDuration) SumDuration
			,sum(rs.SumCODuration) SumCODuration
	From (
			Select Distinct d.DateID, d.Date, LineID
			From Shared.DimDate d
			Cross Join SupplyChain.Line l 
			Where d.Date <= GetDate()
			And d.DateID > (Convert(int, Convert(Varchar, GetDate(), 112)) /10000 - @NumberOfHistoryToPrecal)*10000 -- just keep latest 3 years or history
		 ) rt -- Report Date
	Join SupplyChain.tLineDailyKPI rs on rt.LineID = rs.LineID and rs.DateID <= rt.DateID And rs.DateID >= rt.DateID/100*100 + 1
	Group By rt.DateID, rt.LineID

	---- Year To Date Aggregation ----
	Insert Into SupplyChain.tLineKPI
			   (AnchorDateID
			   ,AggregationID
			   ,LineID
			   ,SumFlavorCODuration
			   ,CountFlavorCO
			   ,SumActualQty
			   ,SumCapacityQty
			   ,SumPlanQty
			   ,SumDuration
			   ,SumCODuration)
	Select rt.DateID, 4 AggregationID, rt.LineID, 
			sum(rs.SumFlavorCODuration) SumFlavorCODuration
			,sum(rs.CountFlavorCO) CountFlavorCO
			,sum(rs.SumActualQty) SumActualQty
			,sum(rs.SumCapacityQty) SumCapacityQty
			,Sum(rs.SumPlanQty) SumPlanQty 
			,sum(rs.SumDuration) SumDuration
			,sum(rs.SumCODuration) SumCODuration
	From (
			Select Distinct d.DateID, d.Date, LineID
			From Shared.DimDate d
			Cross Join SupplyChain.Line l 
			Where d.Date <= GetDate()
			And d.DateID > (Convert(int, Convert(Varchar, GetDate(), 112)) /10000 - @NumberOfHistoryToPrecal)*10000
		 ) rt -- Report Date
	Join SupplyChain.tLineDailyKPI rs on rt.LineID = rs.LineID and rs.DateID <= rt.DateID And rs.DateID >= rt.DateID/10000*10000 + 1
	Group By rt.DateID, rt.LineID

	---- Week To Date Aggregation ----
	Insert Into SupplyChain.tLineKPI
           (AnchorDateID
           ,AggregationID
           ,LineID
           ,SumFlavorCODuration
           ,CountFlavorCO
           ,SumActualQty
           ,SumCapacityQty
		   ,SumPlanQty
           ,SumDuration
           ,SumCODuration)
	Select rt.DateID, 2 AggregationID, rt.LineID, 
			sum(rs.SumFlavorCODuration) SumFlavorCODuration
			,sum(rs.CountFlavorCO) CountFlavorCO
			,sum(rs.SumActualQty) SumActualQty
			,sum(rs.SumCapacityQty) SumCapacityQty
			,sum(rs.SumPlanQty) SumPlanQty
			,sum(rs.SumDuration) SumDuration
			,sum(rs.SumCODuration) SumCODuration
	From (
			Select Distinct d.DateID, d.Date, LineID
			From Shared.DimDate d
			Cross Join SupplyChain.Line l 
			Where d.Date <= GetDate()
			And d.DateID > (Convert(int, Convert(Varchar, GetDate(), 112)) /10000 - @NumberOfHistoryToPrecal)*10000
		 ) rt -- Report Date
	Join SupplyChain.tLineDailyKPI rs on rt.LineID = rs.LineID
	Where rs.DateID <= rt.DateID And rs.DateID > 
	Convert(Int, CONVERT(varchar, DATEADD(d, -1 * datepart(dw, rt.Date) + 1, rt.Date),112))	-- Week starts Monday
	--Convert(Int, CONVERT(varchar, DATEADD(d, -1 * datepart(dw, d.Date) + 1, d.Date),112)) -- Week starts Tuesday
	--Convert(Int, CONVERT(varchar, DATEADD(d, -1 * datepart(dw, d.Date) + 1, d.Date),112)) -- Week starts Wednesday
	--Convert(Int, CONVERT(varchar, DATEADD(d, -1 * datepart(dw, d.Date) + 1, d.Date),112)) -- Week starts Thursday
	--Convert(Int, CONVERT(varchar, DATEADD(d, -1 * datepart(dw, d.Date) + 1, d.Date),112)) -- Week starts Friday
	Group By rt.DateID, rt.LineID

	---- Last 7 Days Aggregation ----
	Insert Into SupplyChain.tLineKPI
           (AnchorDateID
           ,AggregationID
           ,LineID
           ,SumFlavorCODuration
           ,CountFlavorCO
           ,SumActualQty
           ,SumCapacityQty
		   ,SumPlanQty
           ,SumDuration
           ,SumCODuration)
	Select rt.DateID, 5 AggregationID, rt.LineID, 
			sum(rs.SumFlavorCODuration) SumFlavorCODuration
			,sum(rs.CountFlavorCO) CountFlavorCO
			,sum(rs.SumActualQty) SumActualQty
			,sum(rs.SumCapacityQty) SumCapacityQty
			,sum(rs.SumPlanQty) SumPlanQty
			,sum(rs.SumDuration) SumDuration
			,sum(rs.SumCODuration) SumCODuration
	From (
			Select Distinct d.DateID, d.Date, LineID
			From Shared.DimDate d
			Cross Join SupplyChain.Line l 
			Where d.Date <= GetDate()
			And d.DateID > (Convert(int, Convert(Varchar, GetDate(), 112)) /10000 - @NumberOfHistoryToPrecal)*10000
		 ) rt -- Report Date
	Join SupplyChain.tLineDailyKPI rs on rt.LineID = rs.LineID
	Where rs.DateID <= rt.DateID And rs.DateID > 
	Convert(Int, CONVERT(varchar, DATEADD(d, -7, rt.Date),112))
	Group By rt.DateID, rt.LineID

	---- Last 30 Days Aggregation ----
	Insert Into SupplyChain.tLineKPI
           (AnchorDateID
           ,AggregationID
           ,LineID
           ,SumFlavorCODuration
           ,CountFlavorCO
           ,SumActualQty
           ,SumCapacityQty
		   ,SumPlanQty
           ,SumDuration
           ,SumCODuration)
	Select rt.DateID, 6 AggregationID, rt.LineID, 
			sum(rs.SumFlavorCODuration) SumFlavorCODuration
			,sum(rs.CountFlavorCO) CountFlavorCO
			,sum(rs.SumActualQty) SumActualQty
			,sum(rs.SumCapacityQty) SumCapacityQty
			,sum(rs.SumPlanQty) SumPlanQty
			,sum(rs.SumDuration) SumDuration
			,sum(rs.SumCODuration) SumCODuration
	From (
			Select Distinct d.DateID, d.Date, LineID
			From Shared.DimDate d
			Cross Join SupplyChain.Line l 
			Where d.Date <= GetDate()
			And d.DateID > (Convert(int, Convert(Varchar, GetDate(), 112)) /10000 - @NumberOfHistoryToPrecal)*10000
		 ) rt -- Report Date
	Join SupplyChain.tLineDailyKPI rs on rt.LineID = rs.LineID
	Where rs.DateID <= rt.DateID And rs.DateID > 
	Convert(Int, CONVERT(varchar, DATEADD(d, -30, rt.Date),112))
	Group By rt.DateID, rt.LineID


	--Select DateID, DayOfWeek, 
	--Convert(Int, CONVERT(varchar, DATEADD(d, -1 * datepart(dw, rt.Date) + 1, rt.Date),112)),
	--Convert(Int, CONVERT(varchar, DATEADD(d, -7, rt.Date),112))
	--From Shared.DimDate rt

	----------------------------
	--- Verify -----------------
	--Select * From SupplyChain.TimeAggregation
	--Select * From SupplyChain.tLineKPI
	---------------------------
End



GO
/****** Object:  StoredProcedure [ETL].[pProductionPlantFilling]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

Declare @TotalFlavor Decimal(18,1)
Declare @Total Decimal(18,1)
Declare @PlantIDs varchar(4000)
Set @PlantIDs = '1,2,3,4'

Select @TotalFlavor  = Sum(SumFlavorCODuration), @Total = Sum(SumActualQty)
From SupplyChain.tPlantKPI pk
Join dbo.Split(@PlantIDs, ',') v on pk.PlantID = v.Value
Where AnchorDateID = 20141010 And AggregationID = 3

Select AnchorDateID, AggregationID, Case When Isnull(@Total, 0) = 0 Then Null Else Sum(AFCO) End AFCO
From
(		Select lk.AnchorDateID, lk.AggregationID, 
		Case When @TotalFlavor > 0 And lk.CountFlavorCO > 0 Then lk.SumFlavorCODuration/@TotalFlavor*lk.SumFlavorCODuration/lk.CountFlavorCO
			 Else 0 End AFCO
		From SupplyChain.tLineKPI lk
		Join SupplyChain.Line l on lk.LineID = l.LineID
		Join dbo.Split(@PlantIDs, ',') v on l.PlantID = v.Value
		Where lk.AggregationID = 3 And lk.AnchorDateID = 20141010
) temp
Group By  AnchorDateID, AggregationID
*/
CREATE Proc [ETL].[pProductionPlantFilling]
As
Set NoCount On;
Begin

	Truncate Table SupplyChain.tPlantDailyKPI

	Insert Into SupplyChain.tPlantDailyKPI
           (DateID
			,PlantID
			,TME
			,SumCODuration
			,SumDuration
			,SumActualQty
			,SumCapacityQty
			,AvgFlavorCODuration
			,SumFlavorCODuration
		   )
	Select d.DateID
			,l.PlantID
			,0 -- TME
			,Sum(SumCODuration) SumCODuration
			,Sum(SumDuration) SumDuration
			,Sum(SumActualQty) SumActualQty
			,Sum(SumCapacityQty) SumCapacityQty
			,0 --AvgFlavorCODuration
			,Sum(SumFlavorCODuration) SumFlavorCODuration
	From SupplyChain.tLineDailyKPI d
	Join SupplyChain.Line l on d.LineID = l.LineID
	Group By d.DateID, l.PlantID
	----------------------------
	--- Verify -----------------
	--Select *
	--From SupplyChain.tPlantDailyKPI

	---- Plant TME ------------------------
	Update SupplyChain.tPlantDailyKPI
	Set TME = Convert(decimal(5,3), Case When SumCapacityQty > 0 And SumDuration > 0 Then SumCODuration/SumDuration + SumActualQty/SumCapacityQty 
				When SumCapacityQty > 0 Then SumActualQty/SumCapacityQty 
				When SumDuration > 0 Then SumCODuration/SumDuration  
				Else Null 
			 End)

	Update p
	Set AvgFlavorCODuration = Convert(Decimal(6,1), PlantWeightedAvgCODuration)
	From SupplyChain.tPlantDailyKPI p
	Join
	(
		Select DateID, PlantID, Sum(WeightedAvgCODuration) PlantWeightedAvgCODuration
		From
		(
			Select p.PlantID, d.DateID, d.LineID, Case When d.CountFlavorCO > 0 And p.SumFlavorCODuration > 0 Then d.SumFlavorCODuration/d.CountFlavorCO*d.SumFlavorCODuration/p.SumFlavorCODuration
								Else 0 End WeightedAvgCODuration
			From SupplyChain.tLineDailyKPI d
			Join SupplyChain.Line l on d.LineID = l.LineID
			Join SupplyChain.tPlantDailyKPI p on d.DateID = p.DateID And p.PlantID = l.PlantID
		) temp
		Group By DateID, PlantID
	) temp1 on p.PlantID = temp1.PlantID and p.DateID = temp1.DateID

-- Populate KPI details(Customized Aggegation)--
	Truncate Table SupplyChain.tPlantKPI
	----Month TO Date Aggregation
	Insert Into SupplyChain.tPlantKPI
           ( AnchorDateID
			,AggregationID
			,PlantID
			,TME
			,SumCODuration
			,SumDuration
			,SumActualQty
			,SumCapacityQty
			,AvgFlavorCODuration
			,SumFlavorCODuration
		   )
	Select 
			rt.DateID
			, 3 AggregationID
			, rt.PlantID
			, 0 -- TME
			,sum(rs.SumCODuration) SumCODuration
			,sum(rs.SumDuration) SumDuration
			,sum(rs.SumActualQty) SumActualQty
			,Sum(rs.SumCapacityQty) SumCapacityQty
			,0 -- AvgFlavorCODuration
			,sum(rs.SumFlavorCODuration) SumFlavorCODuration					
	From (
			Select Distinct d.DateID, d.Date, PlantID
			From Shared.DimDate d
			Cross Join SupplyChain.Plant p 
			Where d.Date <= GetDate()
			And d.DateID > (Convert(int, Convert(Varchar, GetDate(), 112)) /10000 - 3)*10000 -- just keep latest 3 years or history
		 ) rt -- Report Date
	Join SupplyChain.tPlantDailyKPI rs on rt.PlantID = rs.PlantID and rs.DateID <= rt.DateID And rs.DateID >= rt.DateID/100*100 + 1
	Group By rt.DateID, rt.PlantID

	---- Year To Date Aggregation ----
	Insert Into SupplyChain.tPlantKPI
           ( AnchorDateID
			,AggregationID
			,PlantID
			,TME
			,SumCODuration
			,SumDuration
			,SumActualQty
			,SumCapacityQty
			,AvgFlavorCODuration
			,SumFlavorCODuration
		   )
	Select 
			rt.DateID
			, 4 AggregationID
			, rt.PlantID
			, 0 -- TME
			,sum(rs.SumCODuration) SumCODuration
			,sum(rs.SumDuration) SumDuration
			,sum(rs.SumActualQty) SumActualQty
			,Sum(rs.SumCapacityQty) SumCapacityQty
			,0 -- AvgFlavorCODuration
			,sum(rs.SumFlavorCODuration) SumFlavorCODuration					
	From (
			Select Distinct d.DateID, d.Date, PlantID
			From Shared.DimDate d
			Cross Join SupplyChain.Plant p 
			Where d.Date <= GetDate()
			And d.DateID > (Convert(int, Convert(Varchar, GetDate(), 112)) /10000 - 3)*10000 -- just keep latest 3 years or history
		 ) rt -- Report Date
	Join SupplyChain.tPlantDailyKPI rs on rt.PlantID = rs.PlantID and rs.DateID <= rt.DateID And rs.DateID >= rt.DateID/10000*10000 + 1
	Group By rt.DateID, rt.PlantID


	---- Week To Date Aggregation ----
	Insert Into SupplyChain.tPlantKPI
           ( AnchorDateID
			,AggregationID
			,PlantID
			,TME
			,SumCODuration
			,SumDuration
			,SumActualQty
			,SumCapacityQty
			,AvgFlavorCODuration
			,SumFlavorCODuration
		   )
	Select 
			rt.DateID
			, 2 AggregationID
			, rt.PlantID
			, 0 -- TME
			,sum(rs.SumCODuration) SumCODuration
			,sum(rs.SumDuration) SumDuration
			,sum(rs.SumActualQty) SumActualQty
			,Sum(rs.SumCapacityQty) SumCapacityQty
			,0 -- AvgFlavorCODuration
			,sum(rs.SumFlavorCODuration) SumFlavorCODuration					
	From (
			Select Distinct d.DateID, d.Date, PlantID
			From Shared.DimDate d
			Cross Join SupplyChain.Plant p 
			Where d.Date <= GetDate()
			And d.DateID > (Convert(int, Convert(Varchar, GetDate(), 112)) /10000 - 3)*10000 -- just keep latest 3 years or history
		 ) rt -- Report Date
	Join SupplyChain.tPlantDailyKPI rs on rt.PlantID = rs.PlantID
	Where rs.DateID <= rt.DateID And rs.DateID > 
	Convert(Int, CONVERT(varchar, DATEADD(d, -1 * datepart(dw, rt.Date) + 1, rt.Date),112))
	Group By rt.DateID, rt.PlantID


	---- Last 7 Days Aggregation ----
	Insert Into SupplyChain.tPlantKPI
           ( AnchorDateID
			,AggregationID
			,PlantID
			,TME
			,SumCODuration
			,SumDuration
			,SumActualQty
			,SumCapacityQty
			,AvgFlavorCODuration
			,SumFlavorCODuration
		   )
	Select 
			rt.DateID
			, 5 AggregationID
			, rt.PlantID
			, 0 -- TME
			,sum(rs.SumCODuration) SumCODuration
			,sum(rs.SumDuration) SumDuration
			,sum(rs.SumActualQty) SumActualQty
			,Sum(rs.SumCapacityQty) SumCapacityQty
			,0 -- AvgFlavorCODuration
			,sum(rs.SumFlavorCODuration) SumFlavorCODuration					
	From (
			Select Distinct d.DateID, d.Date, PlantID
			From Shared.DimDate d
			Cross Join SupplyChain.Plant p 
			Where d.Date <= GetDate()
			And d.DateID > (Convert(int, Convert(Varchar, GetDate(), 112)) /10000 - 3)*10000 -- just keep latest 3 years or history
		 ) rt -- Report Date
	Join SupplyChain.tPlantDailyKPI rs on rt.PlantID = rs.PlantID
	Where rs.DateID <= rt.DateID And rs.DateID > 
	Convert(Int, CONVERT(varchar, DATEADD(d, -7, rt.Date),112))
	Group By rt.DateID, rt.PlantID

---- Last 30 Days Aggregation ----
	Insert Into SupplyChain.tPlantKPI
           ( AnchorDateID
			,AggregationID
			,PlantID
			,TME
			,SumCODuration
			,SumDuration
			,SumActualQty
			,SumCapacityQty
			,AvgFlavorCODuration
			,SumFlavorCODuration
		   )
	Select 
			rt.DateID
			, 6 AggregationID
			, rt.PlantID
			, 0 -- TME
			,sum(rs.SumCODuration) SumCODuration
			,sum(rs.SumDuration) SumDuration
			,sum(rs.SumActualQty) SumActualQty
			,Sum(rs.SumCapacityQty) SumCapacityQty
			,0 -- AvgFlavorCODuration
			,sum(rs.SumFlavorCODuration) SumFlavorCODuration					
	From (
			Select Distinct d.DateID, d.Date, PlantID
			From Shared.DimDate d
			Cross Join SupplyChain.Plant p 
			Where d.Date <= GetDate()
			And d.DateID > (Convert(int, Convert(Varchar, GetDate(), 112)) /10000 - 3)*10000 -- just keep latest 3 years or history
		 ) rt -- Report Date
	Join SupplyChain.tPlantDailyKPI rs on rt.PlantID = rs.PlantID
	Where rs.DateID <= rt.DateID And rs.DateID > 
	Convert(Int, CONVERT(varchar, DATEADD(d, -30, rt.Date),112))
	Group By rt.DateID, rt.PlantID
	---- Plant TME ------------------------
	Update SupplyChain.tPlantKPI
	Set TME = Convert(decimal(5,3), Case When SumCapacityQty > 0 And SumDuration > 0 Then (SumCODuration/SumDuration) + (SumActualQty/SumCapacityQty) 
				When SumCapacityQty > 0 Then SumActualQty/SumCapacityQty 
				When SumDuration > 0 Then SumCODuration/SumDuration  
				Else Null 
			 End)

	Update pk 
	Set AvgFlavorCODuration = AFCO
	From SupplyChain.tPlantKPI pk
	Join
	(Select AnchorDateID, PlantID, AggregationID, Case When Isnull(SumActualQty, 0) = 0 Then Null Else Sum(RealAFCO) End AFCO
		From (
		Select pk.AnchorDateID, pk.PlantID, pk.AggregationID, l.LineID, pk.SumActualQty,
		Case When pk.SumFlavorCODuration > 0 And lk.CountFlavorCO > 0 Then lk.SumFlavorCODuration/pk.SumFlavorCODuration*lk.SumFlavorCODuration/lk.CountFlavorCO
			 Else 0 End RealAFCO
		From SupplyChain.tLineKPI lk
		Join SupplyChain.Line l on lk.LineID = l.LineID
		Join SupplyChain.tPlantKPI pk on l.PlantID = pk.PlantID and lk.AggregationID = pk.AggregationID 
										and lk.AnchorDateID = pk.AnchorDateID) temp
	Group By AnchorDateID, PlantID, AggregationID, SumActualQty) temp2
	On pk.AnchorDateID = temp2.AnchorDateID And pk.PlantID = temp2.PlantID And pk.AggregationID = temp2.AggregationID 
	
End


GO
/****** Object:  StoredProcedure [RSSC].[pGetActivePlants]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [RSSC].[pGetActivePlants]
AS		
	Set NoCount On;
	--Select PlantID, PlantDesc + '(' + convert(varchar, PlantID) + ')' PlantName 
	Select PlantID, PlantDesc PlantName 
	From SupplyChain.Plant
	Where Active = 1
	Order By PlantName



GO
/****** Object:  StoredProcedure [RSSC].[pGetAverageFlavorCO2]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* 
'Columbus'
exec RSSC.pGetAverageFlavorCO2 13, 20130201

'Carlstadt'
exec RSSC.pGetAverageFlavorCO2 3, 20140903

'Asper'
exec RSSC.pGetAverageFlavorCO2 8, 20140921

'Carlstadt'
exec RSSC.pGetAverageFlavorCO2 3, 20140921

'Willamson'
exec RSSC.pGetAverageFlavorCO2 7, 20130401

'Victorville'
exec RSSC.pGetAverageFlavorCO2 27, 20141007

'B something the new one'
exec RSSC.pGetAverageFlavorCO2 28, 20141205

*/

Create Proc [RSSC].[pGetAverageFlavorCO2]
(
	@PlantIDs varchar(4000),
	@DateID int
)
AS
Set NoCount On;

--Set @DateID = SupplyChain.udfConvertToDateID(DATEADD(d, -1, SupplyChain.udfConvertToDate(@DateID)))

Declare @Output Table
(
	PlantID int,
	PlantName varchar(128),
	LineName varchar(128),
	LineID int,
	TimePeroidDisplay varchar(128),
	TimePeriodSortOrder int,
	YearName varchar(128),
	YearSortOrder int,
	SumFlavorCODuration Decimal(18, 8), 
	CountFlavorCO int,
	SumDuration Decimal(18, 8)
)

----------------- This year place holder -------------------------
Insert Into @Output(PlantID, PlantName, LineName, LineID, TimePeriodSortOrder, TimePeroidDisplay, YearSortOrder, YearName, 
		 CountFlavorCO, SumFlavorCODuration, SumDuration)
Select temp.PlantID, temp.PlantName, temp.LineName, temp.LineID,
ta.SortOrder TimePeriodSortOrder, 
Case When ta.Name = 'Today' Then 'Yesterday (' + Substring(DateName(Month, SupplyChain.udfConvertToDate(@DateID)), 1, 3) + ' ' + Convert(varchar, Day(SupplyChain.udfConvertToDate(@DateID))) + ')' 
--Case When ta.Name = 'Today' Then 'Yesterday (' + Substring(DateName(WeekDay, SupplyChain.udfConvertToDate(@DateID)), 1, 3) + ', ' + Substring(DateName(Month, SupplyChain.udfConvertToDate(@DateID)), 1, 3) + ' ' + Convert(varchar, Day(SupplyChain.udfConvertToDate(@DateID))) + ')' 
--Case When ta.Name = 'Today' Then 'Yesterday (' + Convert(varchar(5), SupplyChain.udfConvertToDate(@DateID), 110) + ')' 
When ta.Name = 'MTD' Then 'MTD (Last ' + convert(varchar(3), @DateID%100) + ' Days)'
When ta.Name = 'MTD' Then DATENAME(month, SupplyChain.udfConvertToDate(@DateID)) + '(Last ' + convert(varchar(3), @DateID%100) + ' Days)'
When ta.Name = 'YTD' Then 'YTD (Last ' + convert(varchar, datepart(dayofyear,SupplyChain.udfConvertToDate(@DateID))) + ' Days)'
When ta.Name = 'YTD' Then DATENAME(year, SupplyChain.udfConvertToDate(@DateID)) + '(Last ' + convert(varchar, datepart(dayofyear,SupplyChain.udfConvertToDate(@DateID))) + ' Days)'
Else ta.Name End TimePeroidDisplay,
1 YearSortOrder, 'This Year', 0,0,0
From SupplyChain.TimeAggregation ta
Cross Join 
(Select l.LineID, LineName, p.PlantID, PlantDesc PlantName
From SupplyChain.Line l
Join SupplyChain.LineType lt on l.LineTypeID = lt.LineTypeID
Join SupplyChain.Plant p on l.PlantID = p.PlantID) Temp
Where PlantID in 
(
	Select Value From dbo.Split(@PlantIDs, ',')
)
And ta.Active = 1

----------------- Last year place holder -------------------------
Insert Into @Output(PlantID, PlantName, LineName, LineID, TimePeriodSortOrder, TimePeroidDisplay, YearSortOrder, YearName, 
		 CountFlavorCO, SumFlavorCODuration, SumDuration)
Select temp.PlantID, temp.PlantName, temp.LineName, temp.LineID,
ta.SortOrder TimePeriodSortOrder, 
Case When ta.Name = 'Today' Then 'Yesterday(' + Convert(varchar(5), SupplyChain.udfConvertToDate(@DateID), 110) + ')' Else ta.Name End TimePeroidDisplay,
2 YearSortOrder, 'Last Year', 0,0,0
From SupplyChain.TimeAggregation ta
Cross Join 
(Select l.LineID, LineName, p.PlantID, PlantDesc PlantName
From SupplyChain.Line l
Join SupplyChain.LineType lt on l.LineTypeID = lt.LineTypeID
Join SupplyChain.Plant p on l.PlantID = p.PlantID) Temp
Where PlantID in
(
	Select Value From dbo.Split(@PlantIDs, ',')
)
And ta.Active = 1

Update op Set
	CountFlavorCO = fact.CountFlavorCO, 
	SumFlavorCODuration = fact.SumFlavorCODuration,
	SumDuration = fact.SumActualQty
From @Output op
Left Join 
(
	Select LIneID, LineName + ' - ' + LineTypeName As LineName, 
	Case When TimePeroid = 'Today' Then Convert(varchar, SupplyChain.udfConvertToDate(@DateID))  Else TimePeroid End TimePeroidDisplay,
	v.SortOrder TimePeriodSortOrder, 'This Year' YearName, 1 YearSortOrder, SumActualQty, SumCapacityQty, SumPlanQty, SumDuration, SumCODuration, CountFlavorCO, SumFlavorCODuration
	From SupplyChain.vPTKPIs v
	Where PlantID in
	(
		Select Value From dbo.Split(@PlantIDs, ',')
	)
	And DateID = @DateID
	Union All
	Select LIneID, LineName + ' - ' + LineTypeName As LineName, 
	Case When TimePeroid = 'Today' Then Convert(varchar, SupplyChain.udfConvertToDate(@DateID))  Else TimePeroid End TimePeroidDisplay,
	v.SortOrder TimePeriodSortOrder, 'Last Year' YearName, 2 YearSortOrder, SumActualQty, SumCapacityQty, SumPlanQty, SumDuration, SumCODuration, CountFlavorCO, SumFlavorCODuration
	From SupplyChain.vPTKPIs v
	Where PlantID in
	(
		Select Value From dbo.Split(@PlantIDs, ',')
	)
	And DateID = @DateID % 10000 + ((@DateID / 10000) - 1) * 10000
) fact 
On op.LineID = fact.LineID And op.YearSortOrder = fact.YearSortOrder And op.TimePeriodSortOrder = fact.TimePeriodSortOrder

------------------------------------
--- Remove the inactive line, that is defined as no year to date actual capacity ---
Delete 
From @Output
Where LineName in (
Select LineName
From @Output
Where YearSortOrder = 1 And TimePeriodSortOrder = 4
And Isnull(SumDuration, 0) = 0)

------ Remove the Year Grouping and instead create addtional columns -------------
------------------------------------
Declare @Out2 Table
(
	PlantID int,
	PlantName varchar(200),
	LineID int,
	LineName varchar(200),
	TimePeroidDisplay varchar(100),
	TimePeriodSortOrder int,
	CountFlavorCO int,
	SumFlavorCODuration decimal(10,1),
	LYCountFlavorCO int,
	LYSumFlavorCODuration decimal(10, 1),
	SumDuration decimal(10, 1),
	LYSumDuration decimal(10, 1),
	LineWeight Decimal(5,4),
	LYLineWeight Decimal(5,4),
	TYLineWeight Decimal(5,4),
	AVCO decimal(10,4),
	LYAVCO decimal(10,4),
	WeightedAVCO decimal(10,4),
	WeightedLYAVCO decimal(10,4)
)

Insert @Out2
Select TY.PlantID, TY.PlantName, TY.LineID, TY.LineName,
	TY.TimePeroidDisplay,
	TY.TimePeriodSortOrder,
	isnull(TY.CountFlavorCO, 0) CountFlavorCO, 
	isnull(TY.SumFlavorCODuration, 0) SumFlavorCODuration,
	isnull(LY.LYCountFlavorCO, 0) LYCountFlavorCO, 
	isnull(LY.LYSumFlavorCODuration, 0) LYSumFlavorCODuration, 
	Isnull(TY.SumDuration,0) SumDuration,
	Isnull(LY.LYSumDuration, 0) LYSumDuration
	, 0 LineWeight, 0, 0, 0, 0, 0, 0
From (
Select PlantID, PlantName, LineID, LineName,
	TimePeroidDisplay,
	TimePeriodSortOrder,
	YearName,
	YearSortOrder,
	CountFlavorCO, 
	SumFlavorCODuration,
	SumDuration
From @Output
Where YearSortOrder = 1) TY
Left Join
(
Select PlantID, PlantName, LineID, LineName,
	TimePeroidDisplay,
	TimePeriodSortOrder,
	YearName,
	YearSortOrder,
	CountFlavorCO LYCountFlavorCO, 
	SumFlavorCODuration LYSumFlavorCODuration,
	SumDuration LYSumDuration
From @Output
Where YearSortOrder = 2
) LY On TY.PlantName = LY.PlantName And TY.LineName = LY.LineName And TY.TimePeriodSortOrder = LY.TimePeriodSortOrder
Order By TY.PlantName, LineName, TimePeriodSortOrder

Declare @PlantSum Table
(
	PlantID int,
	TimePeriodSortOrder int,
	FCODuration decimal(10,1),
	LYFCODuration decimal(10,1)
)
Insert @PlantSum
Select PlantID, TimePeriodSortOrder, Sum(SumFlavorCODuration), Sum(LYSumFlavorCODuration)
From @Out2
Group By PlantID, TimePeriodSortOrder

Update o2
Set LineWeight = Case When LYFCODuration = 0 And FCODuration = 0 Then 0 
					  When LYFCODuration = 0 Then SumFlavorCODuration/FCODuration
					  Else LYSumFlavorCODuration/LYFCODuration
					  End,
	LYLineWeight = Case When LYFCODuration > 0 Then LYSumFlavorCODuration/LYFCODuration
					  Else 0
					  End,
	TYLineWeight = Case When FCODuration > 0 Then SumFlavorCODuration/FCODuration
					  Else 0
					  End,
	AVCO = Case When CountFlavorCO = 0 Then 0
				Else SumFlavorCODuration/CountFlavorCO End,
	LYAVCO = Case When LYCountFlavorCO = 0 Then 0
				Else LYSumFlavorCODuration/LYCountFlavorCO End
From @Out2 o2
Join @PlantSum s on o2.PlantID = s.PlantID And o2.TimePeriodSortOrder = s.TimePeriodSortOrder

Update @Out2
Set WeightedAVCO = Case When TYLineWeight = 0 Then 0
		Else AVCO*LineWeight/TYLineWeight End,
	WeightedLYAVCO = LYAVCO
From @Out2 o2

Select * From @Out2
Order By PlantName, LineName, TimePeriodSortOrder


GO
/****** Object:  StoredProcedure [RSSC].[pGetBottomCaseCut]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [RSSC].[pGetBottomCaseCut]
(
	@DateID int
)
AS	
	Set NoCount On;

	--- Set the date to be yesterday ---
	Set @DateID = SupplyChain.udfConvertToDateID(DATEADD(d, -1, SupplyChain.udfConvertToDate(@DateID)))
		
	Select r.SAPRegionID, r.RegionName, cut.SumCasesCut, cut.SumQuantity, cut.OOS
	From SAP.Region r 
	Join
		(Select RegionID, Sum(Quantity) SumQuantity, Sum(CaseCut) SumCasesCut, Sum(CaseCut)*1.0/Sum(Quantity) OOS
		From SupplyChain.tDsdDailyCaseCut
		Where DateID = @DateID 
		Group By RegionID) cut on r.RegionID = cut.RegionID
	Order By RegionName


GO
/****** Object:  StoredProcedure [RSSC].[pGetBranches]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [RSSC].[pGetBranches]
AS		
	Set NoCount On;
	--Select PlantID, PlantDesc + '(' + convert(varchar, PlantID) + ')' PlantName 

	Select BranchID, SAPBranchID + ' - ' + BranchName As Branch
	From SAP.Branch
	Order By BranchName


GO
/****** Object:  StoredProcedure [RSSC].[pGetDailyCasecutForAllRegions]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [RSSC].[pGetDailyCasecutForAllRegions]
(
	@DateID int
)
AS	
	Set NoCount On;

	--- Set the date to be yesterday ---
	--Set @DateID = SupplyChain.udfConvertToDateID(DATEADD(d, -1, SupplyChain.udfConvertToDate(@DateID)))
		
	Select r.SAPRegionID, r.RegionName, cut.SumCasesCut, cut.SumQuantity, cut.SumActualQuantity, cut.OOS
	From SAP.Region r 
	Join
		(Select RegionID, Sum(Quantity) SumQuantity, Sum(CaseCut) SumCasesCut,
			Sum(Quantity) - Sum(CaseCut) SumActualQuantity, 
			Sum(CaseCut)*1.0/Sum(Quantity) OOS
		From SupplyChain.tDsdDailyCaseCut
		Where DateID = @DateID 
		Group By RegionID) cut on r.RegionID = cut.RegionID
	Order By RegionName


GO
/****** Object:  StoredProcedure [RSSC].[pGetDailyCasecutForRegion]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [RSSC].[pGetDailyCasecutForRegion]
(
	@DateID int
)
AS	
	Set NoCount On;

	--- Set the date to be yesterday ---
	Set @DateID = SupplyChain.udfConvertToDateID(DATEADD(d, -1, SupplyChain.udfConvertToDate(@DateID)))
		
	Select r.SAPRegionID, r.RegionName, cut.SumCasesCut, cut.SumQuantity, cut.OOS
	From SAP.Region r 
	Join
		(Select RegionID, Sum(Quantity) SumQuantity, Sum(CaseCut) SumCasesCut, Sum(CaseCut)*1.0/Sum(Quantity) OOS
		From SupplyChain.tDsdDailyCaseCut
		Where DateID = @DateID 
		Group By RegionID) cut on r.RegionID = cut.RegionID
	Order By RegionName


GO
/****** Object:  StoredProcedure [RSSC].[pGetDailyCasecutMostImpactedPackages]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [RSSC].[pGetDailyCasecutMostImpactedPackages]
(
	@DateID int,
	@ProductLineID int,
	@BottomCut tinyint = 10
)
AS	
	Set NoCount On;

	--- Set the date to be yesterday ---
	--Set @DateID = SupplyChain.udfConvertToDateID(DATEADD(d, -1, SupplyChain.udfConvertToDate(@DateID)))
		
	Select r.SAPPackageTypeID, r.PackageTypeName Package, cut.SumCasesCut, cut.SumQuantity, cut.SumActualQuantity, cut.OOS, cut.RowNumber
	From SAP.PackageType r 
	Join
		(Select PackageTypeID, Sum(Quantity) SumQuantity, Sum(CaseCut) SumCasesCut,
			Sum(Quantity) - Sum(CaseCut) SumActualQuantity, 
			Sum(CaseCut)*1.0/Sum(Quantity) OOS, ROW_NUMBER() Over (Order By Sum(CaseCut)*1.0/Sum(Quantity) desc) RowNumber
		From SupplyChain.tDsdDailyCaseCut
		Where DateID = @DateID 
		And ProductLineID = @ProductLineID
		Group By PackageTypeID) cut on r.PackageTypeID = cut.PackageTypeID
	Where RowNumber <= @BottomCut
	And OOS > 0
	Order By cut.RowNumber


GO
/****** Object:  StoredProcedure [RSSC].[pGetDailyCasecutMostImpactedTMs]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* 
exec RSSC.pGetDailyCasecutMostImpactedTMs 20141007, 2
exec RSSC.pGetDailyCasecutMostImpactedTMs 20141007, 3
exec RSSC.pGetDailyCasecutMostImpactedTMs 20141007, 4


*/
Create Proc [RSSC].[pGetDailyCasecutMostImpactedTMs]
(
	@DateID int,
	@ProductLineID int,
	@BottomCut tinyint = 10
)
AS	
	Set NoCount On;

	--- Set the date to be yesterday ---
	--Set @DateID = SupplyChain.udfConvertToDateID(DATEADD(d, -1, SupplyChain.udfConvertToDate(@DateID)))
		
	Select r.SAPTradeMarkID, r.TradeMarkName TradeMark, cut.SumCasesCut, cut.SumQuantity, cut.SumActualQuantity, cut.OOS, cut.RowNumber
	From SAP.TradeMark r 
	Join
		(Select TradeMarkID, Sum(Quantity) SumQuantity, Sum(CaseCut) SumCasesCut,
			Sum(Quantity) - Sum(CaseCut) SumActualQuantity, 
			Sum(CaseCut)*1.0/Sum(Quantity) OOS, ROW_NUMBER() Over (Order By Sum(CaseCut)*1.0/Sum(Quantity) desc) RowNumber
		From SupplyChain.tDsdDailyCaseCut
		Where DateID = @DateID 
		And ProductLineID = @ProductLineID
		Group By TradeMarkID) cut on r.TradeMarkID = cut.TradeMarkID
	Where RowNumber <= @BottomCut
	And OOS > 0
	Order By cut.RowNumber


GO
/****** Object:  StoredProcedure [RSSC].[pGetDailyCasecutRegionTrends]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* 
exec RSSC.pGetDailyCasecutRegionTrends 1

Select *
From SAP.Region


*/
Create Proc [RSSC].[pGetDailyCasecutRegionTrends]
(
	@RegionID int
	--,@ProductLineID int
)
AS	
	Set NoCount On;

	--- Set the date to be yesterday ---
	--Set @DateID = SupplyChain.udfConvertToDateID(DATEADD(d, -1, SupplyChain.udfConvertToDate(@DateID)))
		
	Select SupplyChain.udfConvertToDate(cut.DateID) Date, r.SAPRegionID, r.RegionName Region, cut.SumCasesCut, cut.SumQuantity, cut.SumActualQuantity, cut.OOS
	From SAP.Region r 
	Join
		(Select DateID, RegionID, Sum(Quantity) SumQuantity, Sum(CaseCut) SumCasesCut,
			Sum(Quantity) - Sum(CaseCut) SumActualQuantity, 
			Sum(CaseCut)*1.0/Sum(Quantity) OOS
		From SupplyChain.tDsdDailyCaseCut
		Where DateID Between SupplyChain.udfConvertToDateID(DateAdd(day, -30, GetDate())) And SupplyChain.udfConvertToDateID(DateAdd(day, -1, GetDate()))
		--And ProductLineID = @ProductLineID
		And RegionID = @RegionID
		Group By DateID, RegionID) cut on r.RegionID = cut.RegionID
	Order By DateID, RegionName


GO
/****** Object:  StoredProcedure [RSSC].[pGetDefaultPlantInventoryDate]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [RSSC].[pGetDefaultPlantInventoryDate]
AS		
	Set NoCount On;

	Select Top 1 CalendarDate
	From SAP.BP7PlantInventory
	Order By CalendarDate Desc


GO
/****** Object:  StoredProcedure [RSSC].[pGetDSDAvailableDOSDate]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [RSSC].[pGetDSDAvailableDOSDate]
AS		
	Set NoCount On;

	Select DateID, Convert(varchar, Date, 110) + '(' + convert(varchar(3), datename(dw, Date)) + ')' Date
	From Shared.DimDate
	Where DateID in
	(
		Select Distinct DateID
		From SupplyChain.tDsdDailyCaseCut
	)
	And DateID > 20141009
	Order By DateID Desc


GO
/****** Object:  StoredProcedure [RSSC].[pGetDsdDOSDetails]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [RSSC].[pGetDsdDOSDetails]
(
	@DateID int,
	@BranchIDs varchar(4000),
	@TrademarkIDs varchar(4000),
	@PackageTypeIDs varchar(4000)
)
AS		
	Set NoCount On;

	Select r.RegionName Region, b.BranchName Branch, m.SAPMaterialID SKU, m.MaterialName [SKU Description], 
		t.TradeMarkName Trademark, p.PackageName Package, isnull(EndingInventory, 0) EndingInventory, 
		Past31DaysXferOutPlusShipment/30.0 AvgSales, Past31DaysShipment/30.0 AvgShipments
	From SupplyChain.tDsdDailyBranchInventory invt
	Join SAP.Branch b on invt.BranchID = b.BranchID
	Join SAP.Region r on invt.RegionID = r.RegionID
	Join SAP.Material m on m.MaterialID = invt.MaterialID
	Join SAP.TradeMark t on invt.TrademarkID = t.TradeMarkID
	Join SAP.Package p on invt.PackageID = p.PackageID
	Where DateID = @DateID
	And invt.BranchID in (Select Value From dbo.Split(@BranchIDs, ','))
	And invt.TradeMarkID in (Select Value From dbo.Split(@TrademarkIDs, ','))
	And (
			(@PackageTypeIDs = '-1') Or 
			(invt.PackageTypeID in (Select Value From dbo.Split(@PackageTypeIDs, ',')))
		)
--	And (isnull(EndingInventoryCapped, 0) + Past31DaysXferOutPlusShipment) > 0


GO
/****** Object:  StoredProcedure [RSSC].[pGetDsdOOSDate]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [RSSC].[pGetDsdOOSDate]
AS		
	Set NoCount On;

	Select DateID, Convert(varchar, Date, 110) + '(' + convert(varchar(3), datename(dw, Date)) + ')' Date
	From Shared.DimDate
	Where DateID in 
	(
		Select Distinct DateID
		From SupplyChain.tDsdDailyCaseCut
	)
	Order By DateID Desc


GO
/****** Object:  StoredProcedure [RSSC].[pGetDSDPlant]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [RSSC].[pGetDSDPlant]
AS		
	Set NoCount On;
	Select PlantID, PlantDesc PlantName, SAPPlantNumber
	From SupplyChain.Plant
	Where Active = 1
	And SAPSource = 'SP7'
	Order By PlantName



GO
/****** Object:  StoredProcedure [RSSC].[pGetDSDPlantInventoryDate]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [RSSC].[pGetDSDPlantInventoryDate]
AS		
	Set NoCount On;

	Select DateID, Convert(varchar, Date, 110) + '(' + convert(varchar(3), datename(dw, Date)) + ')' Date
	From Shared.DimDate
	Where DateID in 
	(
		Select Distinct CalendarDate
		From SAP.BP7PlantInventory
	)
	Order By DateID Desc


GO
/****** Object:  StoredProcedure [RSSC].[pGetLast7DaysRunningAvgOOS]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* 
exec RSSC.pGetLast7DaysRunningAvgOOS

Select *
From SAP.Region


*/
Create Proc [RSSC].[pGetLast7DaysRunningAvgOOS]
AS	
	Set NoCount On;

	--- Set the date to be yesterday ---
	--Set @DateID = SupplyChain.udfConvertToDateID(DATEADD(d, -1, SupplyChain.udfConvertToDate(@DateID)))
		
	Select SupplyChain.udfConvertToDate(cut.DateID) Date, r.BUID, r.BUName BusinessUnit, cut.SumCasesCut, cut.SumQuantity, cut.SumActualQuantity, cut.OOS
	From SAP.BusinessUnit r 
	Join
		(Select AnchorDateID DateID, BU.BUID, BU.BUName, Sum(Quantity) SumQuantity, Sum(CaseCut) SumCasesCut,
			Sum(Quantity) - Sum(CaseCut) SumActualQuantity, 
			Sum(CaseCut)*1.0/Sum(Quantity) OOS
		From SupplyChain.tDsdCaseCut c
		Join SAP.Region r on c.RegionID = r.RegionID
		Join SAP.BusinessUnit bu on r.BUID = bu.BUID
		Where AnchorDateID Between SupplyChain.udfConvertToDateID(DateAdd(day, -30, GetDate())) And SupplyChain.udfConvertToDateID(DateAdd(day, -1, GetDate()))
		--And ProductLineID = @ProductLineID
		And AggregationID = 5
		Group By AnchorDateID, BU.BUID, BU.BUName) cut on r.BUID = cut.BUID
	Order By DateID, BusinessUnit


GO
/****** Object:  StoredProcedure [RSSC].[pGetLast7DaysRunningAvgOOSByBU]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* 
exec RSSC.pGetLast7DaysRunningAvgOOSByBU 'Central'

Select *
From SAP.BusinessUnit

*/

Create Proc [RSSC].[pGetLast7DaysRunningAvgOOSByBU]
(
	@BUName varchar(50)
)
AS	
	Set NoCount On;

	--- Set the date to be yesterday ---
	--Set @DateID = SupplyChain.udfConvertToDateID(DATEADD(d, -1, SupplyChain.udfConvertToDate(@DateID)))
		
	Select SupplyChain.udfConvertToDate(cut.DateID) Date, r.RegionName Region, cut.SumCasesCut, cut.SumQuantity, cut.SumActualQuantity, cut.OOS
	From SAP.Region r 
	Join
		(Select AnchorDateID DateID, c.RegionID, Sum(Quantity) SumQuantity, Sum(CaseCut) SumCasesCut,
			Sum(Quantity) - Sum(CaseCut) SumActualQuantity, 
			Sum(CaseCut)*1.0/Sum(Quantity) OOS
		From SupplyChain.tDsdCaseCut c
		Join SAP.Region r on c.RegionID = r.RegionID
		Join SAP.BusinessUnit bu on r.BUID = bu.BUID
		Where AnchorDateID Between SupplyChain.udfConvertToDateID(DateAdd(day, -30, GetDate())) And SupplyChain.udfConvertToDateID(DateAdd(day, -1, GetDate()))
		And @BUName = bu.BUName
		And AggregationID = 5
		Group By AnchorDateID, c.RegionID) cut on r.RegionID = cut.RegionID
	Order By DateID, RegionName


GO
/****** Object:  StoredProcedure [RSSC].[pGetPackageTypes]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [RSSC].[pGetPackageTypes]
AS		
	Set NoCount On;
	--Select PlantID, PlantDesc + '(' + convert(varchar, PlantID) + ')' PlantName 

	Select Distinct pt.PackageTypeID, SAPPackageTypeID + ' - ' + PackageTypeName PackageType
	From SAP.PackageType pt
	Join SAP.Package p on pt.PackageTypeID = p.PackageTypeID
	Where p.Active = 1
	Order By SAPPackageTypeID + ' - ' + PackageTypeName


GO
/****** Object:  StoredProcedure [RSSC].[pGetPlantInventory]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [RSSC].[pGetPlantInventory]
(
	@PlantID nvarchar(4000),
	@DateID int
)
AS		
	Set NoCount On;

	Declare @AllPlant Table
	(
		PlantID int,
		PlantDesc varchar(200),
		SAPPlantNumber int,
		SAPSource varchar(100)
	)

	Insert Into @AllPlant
	Select PlantID, PlantDesc, SAPPlantNumber, SAPSource
	From SupplyChain.Plant

	Insert Into @AllPlant
	Select PlantID, PlantDesc, 1404, SAPSource
	From SupplyChain.Plant
	Where SAPPlantNumber = 1403

	Select PlantID, PlantDesc Plant, TradeMarkName TradeMark, FlavorName Flavor, PackageTypeName Package, PackageConfName PackConfig, m.SAPMaterialID ItemNo, MaterialName Item, Inv.EndingInventory [Case], 0 [LYCase]
	Into #Temp
	From SAP.BP7PlantInventory inv
	Join SAP.Material m on inv.SAPMaterialID = m.SAPMaterialNumber
	Join SAP.Flavor f on m.FlavorID = f.FlavorID
	Join SAP.Brand b on m.BrandID = b.BrandID
	Join SAP.TradeMark t on b.TradeMarkID = t.TradeMarkID
	Join SAP.Package p on m.PackageID = p.PackageID
	Join SAP.PackageType pt on p.PackageTypeID = pt.PackageTypeID
	Join SAP.PackageConf pc on p.PackageConfID = pc.PackageConfID
	Join @AllPlant plt on inv.SAPPlantNumber = plt.SAPPlantNumber And plt.SAPSource = 'SP7'
	Where CalendarDate = @DateID
	And PlantID in (Select Value from dbo.Split(@PlantID, ','))
	And EndingInventory > 0
	Order By Plant, TradeMark, Flavor, Package, PackConfig, Item

	Declare @LYDate int
	Set @LYDate = SupplyChain.udfConvertToDateID(DATEADD(Year, -1,SupplyChain.udfConvertToDate(@DateID)))

	Update t
	Set LYCase = isnull(prev.[Case], 0)
	From #Temp t 
	Left Join
	(
		Select PlantID, PlantDesc Plant, TradeMarkName TradeMark, FlavorName Flavor, PackageTypeName Package, PackageConfName PackConfig, m.SAPMaterialID ItemNo, MaterialName Item, Inv.EndingInventory [Case], 0 [LYCase]
		From SAP.BP7PlantInventory inv
		Join SAP.Material m on inv.SAPMaterialID = m.SAPMaterialNumber
		Join SAP.Flavor f on m.FlavorID = f.FlavorID
		Join SAP.Brand b on m.BrandID = b.BrandID
		Join SAP.TradeMark t on b.TradeMarkID = t.TradeMarkID
		Join SAP.Package p on m.PackageID = p.PackageID
		Join SAP.PackageType pt on p.PackageTypeID = pt.PackageTypeID
		Join SAP.PackageConf pc on p.PackageConfID = pc.PackageConfID
		Join @AllPlant plt on inv.SAPPlantNumber = plt.SAPPlantNumber And plt.SAPSource = 'SP7'
		Where CalendarDate = @LYDate
	And PlantID in (Select Value from dbo.Split(@PlantID, ','))) prev On t.PlantID = prev.PlantID And t.ItemNo = prev.ItemNo

	Select * From #Temp 
	Order By Plant, TradeMark, Flavor, Package, PackConfig, Item


GO
/****** Object:  StoredProcedure [RSSC].[pGetPlantTME]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* 
'Columbus'
exec RSSC.pGetPlantTME 13, 20140909

'Carlstadt'
exec RSSC.pGetPlantTME 3, 20140903

'Asper'
exec RSSC.pGetPlantTME 8, 20140921

'Carlstadt'
exec RSSC.pGetPlantTME 3, 20140921

Select *
From SupplyChain.Line
Where LineName = 'Car03'

Select *
From SupplyChain.DayLineShift
Where LineID = 116
And RunDateID > 20140900

Select r.*
From SupplyChain.Run r
Join SupplyChain.DayLineShift dls on r.DayLineShiftID = dls.DayLineShiftID
Where LineID = 116
And RunDateID > 20140900
*/

Create Proc [RSSC].[pGetPlantTME]
(
	@PlantIDs varchar(4000),
	@DateID int
)
AS

--Set @DateID = SupplyChain.udfConvertToDateID(DATEADD(d, -1, SupplyChain.udfConvertToDate(@DateID)))

Declare @Output Table
(
	PlantName varchar(128),
	LineName varchar(128),
	LineID int,
	TimePeroidDisplay varchar(128),
	TimePeriodSortOrder int,
	YearName varchar(128),
	YearSortOrder int,
	SumActualQty Decimal(18, 8), 
	SumCapacityQty Decimal(18, 8), 
	SumPlannedQty Decimal(18, 8), 
	DiffQty As SumActualQty - SumPlannedQty, 
	SumDuration Decimal(18, 8), 
	SumCODuration Decimal(18, 8), 
	CountFlavorCO Decimal(18, 8), 
	SumFlavorCODuration Decimal(18, 8)
)

----------------- This year place holder -------------------------
Insert Into @Output(PlantName, LineName, LineID, TimePeriodSortOrder, TimePeroidDisplay, YearSortOrder, YearName, 
		SumActualQty, SumCapacityQty, SumPlannedQty, SumDuration, 
		SumCODuration, CountFlavorCO, SumFlavorCODuration)
Select temp.PlantName, temp.LineName, temp.LineID,
ta.SortOrder TimePeriodSortOrder, 
--Case When ta.Name = 'Today' Then 'Yesterday(' + Convert(varchar(5), SupplyChain.udfConvertToDate(@DateID), 110) + ')' 
Case When ta.Name = 'Today' Then 'Yesterday (' + Substring(DateName(Month, SupplyChain.udfConvertToDate(@DateID)), 1, 3) + ' ' + Convert(varchar, Day(SupplyChain.udfConvertToDate(@DateID))) + ')' 
When ta.Name = 'MTD' Then 'MTD (Last ' + convert(varchar(3), @DateID%100) + ' Days)'
When ta.Name = 'MTD' Then DATENAME(month, SupplyChain.udfConvertToDate(@DateID)) + '(Last ' + convert(varchar(3), @DateID%100) + ' Days)'
When ta.Name = 'YTD' Then 'YTD (Last ' + convert(varchar, datepart(dayofyear,SupplyChain.udfConvertToDate(@DateID))) + ' Days)'
When ta.Name = 'YTD' Then DATENAME(year, SupplyChain.udfConvertToDate(@DateID)) + '(Last ' + convert(varchar, datepart(dayofyear,SupplyChain.udfConvertToDate(@DateID))) + ' Days)'
Else ta.Name End TimePeroidDisplay,
1 YearSortOrder, 'This Year', 0,0,0,0,0,0,0
From SupplyChain.TimeAggregation ta
Cross Join 
(Select l.LineID, LineName, p.PlantID, PlantDesc PlantName
--(Select l.LineID, LineName + ' - ' + LineTypeName As LineName, LineID, p.PlantID, PlantDesc PlantName
From SupplyChain.Line l
left Join SupplyChain.LineType lt on l.LineTypeID = lt.LineTypeID
left Join SupplyChain.Plant p on l.PlantID = p.PlantID) Temp
Where PlantID in 
(
	Select Value From dbo.Split(@PlantIDs, ',')
)
And ta.Active = 1

----------------- Last year place holder -------------------------
Insert Into @Output(PlantName, LineName, LineID, TimePeriodSortOrder, TimePeroidDisplay, YearSortOrder, YearName, 
		SumActualQty, SumCapacityQty, SumPlannedQty, SumDuration, 
		SumCODuration, CountFlavorCO, SumFlavorCODuration)
Select temp.PlantName, temp.LineName, temp.LineID,
ta.SortOrder TimePeriodSortOrder, 
Case When ta.Name = 'Today' Then 'Yesterday(' + Convert(varchar(5), SupplyChain.udfConvertToDate(@DateID), 110) + ')' 
When ta.Name = 'MTD' Then 'MTD (Last ' + convert(varchar(3), @DateID%100) + ' Days)'
When ta.Name = 'MTD' Then DATENAME(month, SupplyChain.udfConvertToDate(@DateID)) + '(Last ' + convert(varchar(3), @DateID%100) + ' Days)'
When ta.Name = 'YTD' Then 'YTD (Last ' + convert(varchar, datepart(dayofyear,SupplyChain.udfConvertToDate(@DateID))) + ' Days)'
When ta.Name = 'YTD' Then DATENAME(year, SupplyChain.udfConvertToDate(@DateID)) + '(Last ' + convert(varchar, datepart(dayofyear,SupplyChain.udfConvertToDate(@DateID))) + ' Days)'
Else ta.Name End TimePeroidDisplay,
2 YearSortOrder, 'Last Year', 0,0,0,0,0,0,0
From SupplyChain.TimeAggregation ta
Cross Join 
(Select l.LineID, LineName, p.PlantID, PlantDesc PlantName
From SupplyChain.Line l
Join SupplyChain.LineType lt on l.LineTypeID = lt.LineTypeID
Join SupplyChain.Plant p on l.PlantID = p.PlantID) Temp
Where PlantID in
(
	Select Value From dbo.Split(@PlantIDs, ',')
)
And ta.Active = 1

Update op Set
	SumActualQty = fact.SumActualQty, 
	SumCapacityQty = fact.SumCapacityQty, 
	SumPlannedQty = fact.SumPlanQty,
	SumDuration = fact.SumDuration, 
	SumCODuration = fact.SumCODuration, 
	CountFlavorCO = fact.CountFlavorCO, 
	SumFlavorCODuration = fact.SumFlavorCODuration
From @Output op
Left Join 
(
	Select LIneID, LineName + ' - ' + LineTypeName As LineName, 
	TimePeroid  TimePeroidDisplay,
	v.SortOrder TimePeriodSortOrder, 'This Year' YearName, 1 YearSortOrder, SumActualQty, SumCapacityQty, SumPlanQty, SumDuration, SumCODuration, CountFlavorCO, SumFlavorCODuration
	From SupplyChain.vPTKPIs v
	Where PlantID in 
	(
		Select Value From dbo.Split(@PlantIDs, ',')
	)
	And DateID = @DateID
	Union All
	Select LIneID, LineName + ' - ' + LineTypeName As LineName, 
	Case When TimePeroid = 'Today' Then Convert(varchar, SupplyChain.udfConvertToDate(@DateID % 10000 + ((@DateID / 10000) - 1) * 10000))  Else TimePeroid End,
	v.SortOrder TimePeriodSortOrder, 'Last Year' YearName, 2 YearSortOrder, SumActualQty, SumCapacityQty, SumPlanQty, SumDuration, SumCODuration, CountFlavorCO, SumFlavorCODuration
	From SupplyChain.vPTKPIs v
	Where PlantID in 
	(
		Select Value From dbo.Split(@PlantIDs, ',')
	)
	And DateID = @DateID % 10000 + ((@DateID / 10000) - 1) * 10000
) fact 
On op.LineID = fact.LineID And op.YearSortOrder = fact.YearSortOrder And op.TimePeriodSortOrder = fact.TimePeriodSortOrder

------------------------------------
--- Remove the inactive line, that is defined as no year to date actual capacity
Delete 
From @Output
Where LineName in (
Select LineName
From @Output
Where YearSortOrder = 1 And TimePeriodSortOrder = 4
And isnull(SumActualQty,0) = 0
And isnull(SumCapacityQty, 0) = 0
And isnull(SumDuration, 0) = 0)

------------------------------------
Select 
	ty.PlantName, ty.LineName,
	ty.TimePeroidDisplay,
	ty.TimePeriodSortOrder,
	ty.YearName,
	ty.YearSortOrder,
	ty.SumActualQty, 
	ty.SumCapacityQty, 
	ty.DiffQty,
	ty.SumPlannedQty,
	ty.SumDuration, 
	ty.SumCODuration, 
	ty.CountFlavorCO, 
	ty.SumFlavorCODuration,
	ly.SumActualQty LYSumActualQty , 
	ly.SumCapacityQty LYSumCapacityQty, 
	ly.DiffQty LYDiffQty,
	ly.SumPlannedQty LYSumPlannedQty,
	ly.SumDuration LYSumDuration, 
	ly.SumCODuration LYSumCODuration, 
	ly.CountFlavorCO LYCountFlavorCO, 
	ly.SumFlavorCODuration LYSumFlavorCODuration
From
(Select PlantName, LineName,
	TimePeroidDisplay,
	TimePeriodSortOrder,
	YearName,
	YearSortOrder,
	isnull(SumActualQty, 0) SumActualQty, 
	isnull(SumCapacityQty, 0) SumCapacityQty, 
	isnull(DiffQty, 0) DiffQty,
	isnull(SumPlannedQty, 0) SumPlannedQty,
	isnull(SumDuration, 0) SumDuration, 
	isnull(SumCODuration, 0) SumCODuration, 
	isnull(CountFlavorCO, 0) CountFlavorCO, 
	isnull(SumFlavorCODuration, 0) SumFlavorCODuration
From @Output
Where YearSortOrder = 1) ty Join
(
Select PlantName, LineName,
	TimePeroidDisplay,
	TimePeriodSortOrder,
	YearName,
	YearSortOrder,
	isnull(SumActualQty, 0) SumActualQty, 
	isnull(SumCapacityQty, 0) SumCapacityQty, 
	isnull(DiffQty, 0) DiffQty,
	isnull(SumPlannedQty, 0) SumPlannedQty,
	isnull(SumDuration, 0) SumDuration, 
	isnull(SumCODuration, 0) SumCODuration, 
	isnull(CountFlavorCO, 0) CountFlavorCO, 
	isnull(SumFlavorCODuration, 0) SumFlavorCODuration
From @Output
Where YearSortOrder = 2
) ly on ty.PlantName = ly.PlantName And ty.LineName = ly.LineName and ty.TimePeriodSortOrder = ly.TimePeriodSortOrder
Order By YearSortOrder, LineName, TimePeriodSortOrder



GO
/****** Object:  StoredProcedure [RSSC].[pGetPlantTMETrend]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* 
'Columbus'
exec RSSC.pGetPlantTMETrend 13

exec RSSC.pGetPlantTMETrend 3

*/

Create Proc [RSSC].[pGetPlantTMETrend]
(
	@PlantID int
)
AS

Declare @TimeStart int
Declare @TimeEnd int
Declare @LastYearTimeStart int
Declare @LastYearTimeEnd int

Select @TimeStart = SupplyChain.udfConvertToDateID(DateAdd(d, -181, GetDate()))
Select @TimeEnd = SupplyChain.udfConvertToDateID(GetDate())
Select @LastYearTimeStart = @TimeStart - 10000 
Select @LastYearTimeEnd = @TimeEnd - 10000

Select 'This Year' Year, PlantDesc Plant, SupplyChain.udfConvertToDate(DateID) Date,
Convert(Decimal(6,3), Sum(SumActualQty)/Sum(SumCapacityQty) + Sum(SumCODuration)/Sum(SumDuration)) TME
--,Convert(Decimal(6,3), SumPlanQty/SumCapacityQty + SumCODuration/SumDuration) 'Planned'
From SupplyChain.vPTKPIs
Where PlantID = @PlantID
And TimePeroid = 'Last 30 Days'
And DateID Between @TimeStart And @TimeEnd
Group By PlantDesc, DateID
Union All
Select 'Last Year', PlantDesc Plant, SupplyChain.udfConvertToDate(DateID + 10000) Date,
Convert(Decimal(6,3), Sum(SumActualQty)/Sum(SumCapacityQty) + Sum(SumCODuration)/Sum(SumDuration)) TME
--,Convert(Decimal(6,3), SumPlanQty/SumCapacityQty + SumCODuration/SumDuration) 'Planned'
From SupplyChain.vPTKPIs
Where PlantID = @PlantID
And TimePeroid = 'Last 30 Days'
And DateID Between @LastYearTimeStart And @LastYearTimeEnd
Group By PlantDesc, DateID

----Select Plant, Line, Date, Count(*)
----From
----(
--Select PlantDesc Plant, LineName Line, SupplyChain.udfConvertToDate(DateID) Date,
--Convert(Decimal(6,3), SumActualQty/SumCapacityQty + SumCODuration/SumDuration) TME
----,Convert(Decimal(6,3), SumPlanQty/SumCapacityQty + SumCODuration/SumDuration) 'Planned'
--From SupplyChain.vPTKPIs
--Where PlantID = @PlantID
--And TimePeroid = 'Last 30 Days'
--And DateID > SupplyChain.udfConvertToDateID(DateAdd(d, -181, GetDate()))
----) s
----Group By Plant, Line, Date



GO
/****** Object:  StoredProcedure [RSSC].[pGetProductLines]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [RSSC].[pGetProductLines]
AS		
	Set NoCount On;
	--Select PlantID, PlantDesc + '(' + convert(varchar, PlantID) + ')' PlantName 
	Select ProductLineID, ProductLineName
	From SAP.ProductLine
	Order By SortOrder



GO
/****** Object:  StoredProcedure [RSSC].[pGetRegions]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [RSSC].[pGetRegions]
AS		
	Set NoCount On;
	--Select PlantID, PlantDesc + '(' + convert(varchar, PlantID) + ')' PlantName 
	Select RegionID, RegionName
	From SAP.Region
	Order By RegionName



GO
/****** Object:  StoredProcedure [RSSC].[pGetSalesOfficesDOSTrend]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [RSSC].[pGetSalesOfficesDOSTrend]
(
	@DateID int,
	@BranchIDs varchar(4000),
	@TrademarkIDs varchar(4000),
	@PackageTypeIDs varchar(4000),
	@HowManyDaysToGoBack int
)
AS		
	Set NoCount On;
	If (@HowManyDaysToGoBack > 30) 
		Set @HowManyDaysToGoBack = 30

	Declare @RequestedDate Date
	Set @RequestedDate = SupplyChain.udfConvertToDate(@DateID);

	Select d.[Date], Sum(EndingInventoryCapped) EndingInventory, Sum(Past31DaysXferOutPlusShipment) Past31Days,
		Convert(decimal(5,1), Case When Sum(Past31DaysXferOutPlusShipment) = 0 Then 20.0
		Else Sum(EndingInventoryCapped)*31.0/Sum(Past31DaysXferOutPlusShipment)
		End )DOS
	From SupplyChain.tDsdDailyBranchInventory invt
	Join SAP.Branch b on invt.BranchID = b.BranchID
	Join SAP.Region r on invt.RegionID = r.RegionID
	Join SAP.Material m on m.MaterialID = invt.MaterialID
	Join SAP.TradeMark t on invt.TrademarkID = t.TradeMarkID
	Join SAP.Package p on invt.PackageID = p.PackageID
	Join Shared.DimDate d on invt.DateID = d.DateID
	Where invt.BranchID in (Select Value From dbo.Split(@BranchIDs, ','))
	And invt.TradeMarkID in (Select Value From dbo.Split(@TrademarkIDs, ','))
	And ((@PackageTypeIDs = '-1') Or (invt.PackageTypeID in (Select Value From dbo.Split(@PackageTypeIDs, ','))))
	And d.Date Between DateAdd(d, -1*@HowManyDaysToGoBack +1, @RequestedDate) And @RequestedDate
	Group By d.Date
	Having Sum(EndingInventoryCapped) + Sum(Past31DaysXferOutPlusShipment) > 0
	Order By d.Date




GO
/****** Object:  StoredProcedure [RSSC].[pGetSalesOfficesMinMaxDetails]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [RSSC].[pGetSalesOfficesMinMaxDetails]
(
	@DateID int,
	@BranchIDs varchar(4000),
	@TrademarkIDs varchar(4000),
	@PackageTypeIDs varchar(4000)
)
AS		
	Set NoCount On;

	Select r.RegionName Region, b.BranchName Branch, m.SAPMaterialID SKU, 
		m.MaterialName [SKU Description], t.TradeMarkName Trademark, p.PackageName Package, 
		AvailableStock Inventory, MinSafetyStock [Min], MaxStock [Max]
	From SupplyChain.tDsdDailyMinMax minmax
	Join SAP.Branch b on minmax.BranchID = b.BranchID
	Join SAP.Region r on minmax.RegionID = r.RegionID
	Join SAP.Material m on m.MaterialID = minmax.MaterialID
	Join SAP.TradeMark t on minmax.TrademarkID = t.TradeMarkID
	Join SAP.Package p on minmax.PackageID = p.PackageID
	Where DateID = @DateID
	And minmax.BranchID in (Select Value From dbo.Split(@BranchIDs, ','))
	And minmax.TradeMarkID in (Select Value From dbo.Split(@TrademarkIDs, ','))
	And ((@PackageTypeIDs = '-1') Or minmax.PackageTypeID in (Select Value From dbo.Split(@PackageTypeIDs, ',')))

GO
/****** Object:  StoredProcedure [RSSC].[pGetSalesOfficesMinMaxTrend]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [RSSC].[pGetSalesOfficesMinMaxTrend]
(
	@DateID int,
	@BranchIDs varchar(4000),
	@TrademarkIDs varchar(4000),
	@PackageTypeIDs varchar(4000),
	@HowManyDaysToGoBack int
)
AS		
	Set NoCount On;
	If (@HowManyDaysToGoBack > 30) 
		Set @HowManyDaysToGoBack = 30

	Declare @RequestedDate Date
	Set @RequestedDate = SupplyChain.udfConvertToDate(@DateID);

	Select d.[Date], Convert(decimal(5,3), Sum(IsBelowMin)*1.0/(Sum(IsBelowMin) + Sum(IsCompliant) + Sum(IsAboveMax))) [% Below Safety Stock],
					Convert(decimal(5,3), Sum(IsCompliant)*1.0/(Sum(IsBelowMin) + Sum(IsCompliant) + Sum(IsAboveMax))) [% Compliant],
					Convert(decimal(5,3), Sum(IsAboveMax)*1.0/(Sum(IsBelowMin) + Sum(IsCompliant) + Sum(IsAboveMax))) [% Above Max Stock]
	--Select d.[Date], Sum(IsBelowMin) LeftNumber,
	--				Sum(IsCompliant) MiddleNumber,
	--				Sum(IsAboveMax) RightNumber
	From SupplyChain.tDsdDailyMinMax minmax
	Join SAP.Branch b on minmax.BranchID = b.BranchID
	Join SAP.Region r on minmax.RegionID = r.RegionID
	Join SAP.Material m on m.MaterialID = minmax.MaterialID
	Join SAP.TradeMark t on minmax.TrademarkID = t.TradeMarkID
	Join SAP.Package p on minmax.PackageID = p.PackageID
	Join Shared.DimDate d on minmax.DateID = d.DateID
	Where minmax.BranchID in (Select Value From dbo.Split(@BranchIDs, ','))
	And minmax.TradeMarkID in (Select Value From dbo.Split(@TrademarkIDs, ','))
	And ((@PackageTypeIDs = '-1') Or (minmax.PackageTypeID in (Select Value From dbo.Split(@PackageTypeIDs, ','))))
	And d.Date Between DateAdd(d, -1*@HowManyDaysToGoBack +1, @RequestedDate) And @RequestedDate
	Group By d.Date
	Order By d.Date



GO
/****** Object:  StoredProcedure [RSSC].[pGetSalesOfficesOOSDetails]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [RSSC].[pGetSalesOfficesOOSDetails]
(
	@DateID int,
	@BranchIDs varchar(4000),
	@TrademarkIDs varchar(4000),
	@PackageTypeIDs varchar(4000)
)
AS		
	Set NoCount On;
	--Select PlantID, PlantDesc + '(' + convert(varchar, PlantID) + ')' PlantName 

	Select r.RegionName Region, b.BranchName Branch, m.SAPMaterialID SKU, m.MaterialName [SKU Description], t.TradeMarkName Trademark, p.PackageName Package, Quantity [O. Demand], CaseCut [Case Cuts], OOS
	From SupplyChain.tDsdDailyCaseCut cut
	Join SAP.Branch b on cut.BranchID = b.BranchID
	Join SAP.Region r on cut.RegionID = r.RegionID
	Join SAP.Material m on m.MaterialID = cut.MaterialID
	Join SAP.TradeMark t on cut.TrademarkID = t.TradeMarkID
	Join SAP.Package p on cut.PackageID = p.PackageID
	Where DateID = @DateID
	And cut.BranchID in (Select Value From dbo.Split(@BranchIDs, ','))
	And cut.TradeMarkID in (Select Value From dbo.Split(@TrademarkIDs, ','))
	And (@PackageTypeIDs = '-1' Or cut.PackageTypeID in (Select Value From dbo.Split(@PackageTypeIDs, ',')))


GO
/****** Object:  StoredProcedure [RSSC].[pGetSalesOfficesOOSWeeklyTrend]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [RSSC].[pGetSalesOfficesOOSWeeklyTrend]
(
	@DateID int,
	@BranchIDs varchar(4000),
	@TrademarkIDs varchar(4000),
	@PackageTypeIDs varchar(4000),
	@HowManyDaysToGoBack int
)
AS		
	Set NoCount On;

	Declare @RequestedDate Date
	Set @RequestedDate = SupplyChain.udfConvertToDate(@DateID);

	Select d.[Week], Sum(CaseCut*100.0)/Sum(Quantity*1.0) OOS--, Sum(CaseCut)*1.0/Sum(Quantity) OOS
	From SupplyChain.tDsdCaseCut cut
	Join SAP.Branch b on cut.BranchID = b.BranchID
	Join SAP.Region r on cut.RegionID = r.RegionID
	Join SAP.Material m on m.MaterialID = cut.MaterialID
	Join SAP.TradeMark t on cut.TrademarkID = t.TradeMarkID
	Join SAP.Package p on cut.PackageID = p.PackageID
	Join (
			Select DateID, Case When [Year] = Datepart(year, @RequestedDate) 
				Then Convert(varchar, WeekOfYear) Else 'LY ' + Convert(varchar, WeekOfYear) End [Week]
			From Shared.DimDate d
			Where Date Between DateAdd(Day, -1*@HowManyDaysToGoBack, @RequestedDate) And @RequestedDate
			And DatePart(WEEKDAY, Date) = 7) d on cut.AnchorDateID = d.DateID
	Where AggregationID = 5
	And cut.BranchID in (Select Value From dbo.Split(@BranchIDs, ','))
	And cut.TradeMarkID in (Select Value From dbo.Split(@TrademarkIDs, ','))
	And cut.PackageTypeID in (Select Value From dbo.Split(@PackageTypeIDs, ','))
	Group By d.[Week]
	Order By d.[Week]


GO
/****** Object:  StoredProcedure [RSSC].[pGetSalesOfficesPotentialOOSDetails]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [RSSC].[pGetSalesOfficesPotentialOOSDetails]
(	
	@HowFarInTheFuture int,
	@BranchIDs varchar(4000),
	@TrademarkIDs varchar(4000),
	@PackageTypeIDs varchar(4000)
)
AS		
	Set NoCount On;
	
	If (@HowFarInTheFuture < 0 or @HowFarInTheFuture > 2)
		Set @HowFarInTheFuture = 1

	Select r.RegionName Region, b.BranchName Branch, m.SAPMaterialID SKU, m.MaterialName [SKU Description], 
		t.TradeMarkName Trademark, p.PackageName Package, OpenOrder [O. Demand], PotentialCaseCut [Case Cuts], PotentialOOS OOS
	From SupplyChain.tDsdPotentialCaseCut cut
	Join SAP.Branch b on cut.BranchID = b.BranchID
	Join SAP.Region r on cut.RegionID = r.RegionID
	Join SAP.Material m on m.MaterialID = cut.MaterialID
	Join SAP.TradeMark t on cut.TrademarkID = t.TradeMarkID
	Join SAP.Package p on cut.PackageID = p.PackageID
	Where cut.BranchID in (Select Value From dbo.Split(@BranchIDs, ','))
	And cut.TradeMarkID in (Select Value From dbo.Split(@TrademarkIDs, ','))
	And ((@PackageTypeIDs = '-1') or cut.PackageTypeID in (Select Value From dbo.Split(@PackageTypeIDs, ',')))
	And cut.HowFarInFuture = @HowFarInTheFuture 



GO
/****** Object:  StoredProcedure [RSSC].[pGetTrademarks]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [RSSC].[pGetTrademarks]
AS		
	Set NoCount On;
	--Select PlantID, PlantDesc + '(' + convert(varchar, PlantID) + ')' PlantName 

	Select TradeMarkID, SAPTradeMarkID + ' - ' + TradeMarkName As Trademark
	From SAP.TradeMark
	--Where ActiveInRM = 1
	Order By TradeMarkName


GO
/****** Object:  StoredProcedure [RSSC].[pRegions]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [RSSC].[pRegions]
AS		
	Set NoCount On;
	--Select PlantID, PlantDesc + '(' + convert(varchar, PlantID) + ')' PlantName 
	Select RegionID, RegionName
	From SAP.Region
	Order By RegionName



GO
/****** Object:  StoredProcedure [RSSC].[pReportDateRange]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [RSSC].[pReportDateRange]
AS		
	Set NoCount On;
	
	Select DateID, Convert(varchar, Date, 110) + '(' + convert(varchar(3), datename(dw, Date)) + ')' Date
	From Shared.DimDate
	Where Date <= Convert(Date, GetDate())
	And Date > DateAdd(d, -271, Convert(Date, GetDate()))
	Order By DateID Desc


GO
/****** Object:  StoredProcedure [SupplyChain].[GetManuFacturingMeasures]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


  
/*    
Select * from SupplyChain.Plant Where SAPPlantNumber in ('1118','1304','1331','1213','1212')
[SupplyChain].[GetManuFacturingMeasures] '2014-12-08','3,8,13,16,19'
[SupplyChain].[GetManuFacturingMeasures] '2014-12-08','19,16,13,15,26,21,1,2,20,3,24,5,7,8,17,18,27'  
    
  select * from 'Supplychain.plant'  
    
*/    
CREATE PROC [SupplyChain].[GetManuFacturingMeasures](@Date as SmallDateTime, @PlantID varchar(500))    
AS    
BEGIN    
     
Declare @SupplyChainManufacutringTME Table    
 (    
  AnchorDateID int not null,    
  PlantID int not null,    
  PlantName varchar(10) not null,    
  PlantDesc varchar(50) not null,    
  SAPPlantNumber varchar(50) null,    
  Latitude varchar(100),  
  Longitude Varchar(100),  
  IsMyPlant Bit null,    
  TMEMTD decimal(21,1)  null,    
  TMEMTDPY decimal(21,1) null,  
   TMETotal decimal(5,1) null,
  TMETotalPY decimal(5,1) null,
   TMEFavUnFav decimal(10,1) null,   
   TMERank int null,  
  AFCOMTD decimal(5,1) null,    
  AFCOMTDPY decimal(5,1) null,
  AFCOTotal decimal (18,1) null,
  AFCOTotalPY decimal (18,1) null, 
   AFCOFAVUnFAV decimal(10,1) null,  
   AFCOFAVUnFAVPercent decimal(5,1) null,  
    AFCORank int null,  
  RecordableMTD int,    
  RecordableMTDPY int,    
   RecordableTotal int null,  
  RecordableTotalPY int null,
  RecordableFavUnFav decimal(10,1) null, 
  RecordableRank int null,  
  InventoryCasesMTD int,    
  InventoryCasesMTDPY int,  
  InventoryCasesTotal decimal(18,1) null,  
  InventoryCasesTotalPY decimal(18,1) null, 
  InvCasesFavUnFav int null,
  InvCasesFavUnFavPercent decimal(10,1) null,
  InventoryCasesRank int null
 )  
 
 Declare @SelectedPlantIDs Table
		(
			PlantID int
		)
Insert into @SelectedPlantIDs
Select Value from dbo.Split(@PlantID,',')  

 Declare @AnchorDate Int  
 Declare @AnchorDatePrev int  
 Set @AnchorDate = [SupplyChain].[udfConvertToDateID](@Date)  
 Set @AnchorDatePrev = [SupplyChain].[udfConvertToDateID](DATEADD(YY,-1,@Date))  
 Insert into @SupplyChainManufacutringTME(AnchorDateID,PlantID,PlantName,PlantDesc,SAPPlantNumber,Latitude,Longitude, TMEMTD, TMEMTDPY, RecordableMTD, RecordableMTDPY,InventoryCasesMTD, InventoryCasesMTDPY, IsMyPlant)  
  Select @AnchorDate, p.PlantID, PlantName,PlantDesc,SAPPlantNumber,Latitude  ,Logitude  
    ,(Select TME * 100 from SupplyChain.tPlantKPI Where AnchorDateID=@AnchorDate And AggregationID = 3 And PlantID=p.PlantID)  
    ,(Select TME * 100 from SupplyChain.tPlantKPI Where AnchorDateID=@AnchorDatePrev And AggregationID = 3 And PlantID=p.PlantID)  
   -- ,(Select AvgFlavorCODuration from SupplyChain.tPlantKPI Where AnchorDateID=@AnchorDate And AggregationID = 3 And PlantID=p.PlantID)  
    --,(Select AvgFlavorCODuration from SupplyChain.tPlantKPI Where AnchorDateID=@AnchorDatePrev And AggregationID = 3 And PlantID=p.PlantID)  
    ,(Select [RecordableMDT] from [SupplyChain].[tManufacturingMeasures_ToBeDeleted] as tmD where tmd.plantID = p.PlantID)  
    ,(Select [RecordableMDTPY] from [SupplyChain].[tManufacturingMeasures_ToBeDeleted] as tmD where tmd.plantID = p.PlantID)  
    ,(Select SUM(Isnull(EndingInventory,0))  from SAP.BP7PlantInventory Where SAPPlantNumber = p.SAPPlantNumber And CalendarDate=@AnchorDate And  EndingInventory > 0 Group by SAPPlantNumber)  
    ,(Select SUM(Isnull(EndingInventory,0)) from SAP.BP7PlantInventory Where SAPPlantNumber = p.SAPPlantNumber And CalendarDate=@AnchorDatePrev And  EndingInventory > 0 Group by SAPPlantNumber)
	,Case When myPlant.PlantID is not null Then 1 Else null end  
    from SupplyChain.Plant p  Left Outer Join @SelectedPlantIDs as myPlant on p.PlantID = myPlant.PlantID
--  
Declare @TMETotal decimal(5,3)  
Declare @TMETotalPY decimal(5,3)
Declare @AFCOTotal decimal(18,1)  
Declare @AFCOTotalPY decimal(18,1)  
Select  @TMETotal = (Select Convert(decimal(5,3), Case When SUM(isnull(SumCapacityQty,0)) > 0 And SUM(isnull(SumDuration,0)) > 0 Then SUM(isnull(SumCODuration,0))/SUM(isnull(SumDuration,0)) + SUM(isnull(SumActualQty,0))/SUM(isnull(SumCapacityQty ,0))  
    When SUM(isnull(SumCapacityQty,0)) > 0 Then SUM(isnull(SumActualQty,0))/SUM(isnull(SumCapacityQty,0))   
    When SUM(isnull(SumDuration,0)) > 0 Then SUM(isnull(SumCODuration,0))/SUM(isnull(SumDuration,0))    
    Else Null   
    End)  
 from  @SelectedPlantIDs as  myPlant   
 join SupplyChain.tPlantKPI as p on p.PlantID = myPlant.PlantID And p.AggregationID = 3 And p.AnchorDateID = @AnchorDate)  

 ----Previous Year Plant TME Total
Select  @TMETotalPY = (Select Convert(decimal(5,3), Case When SUM(isnull(SumCapacityQty,0)) > 0 And SUM(isnull(SumDuration,0)) > 0 Then SUM(isnull(SumCODuration,0))/SUM(isnull(SumDuration,0)) + SUM(isnull(SumActualQty,0))/SUM(isnull(SumCapacityQty ,0))  
    When SUM(isnull(SumCapacityQty,0)) > 0 Then SUM(isnull(SumActualQty,0))/SUM(isnull(SumCapacityQty,0))   
    When SUM(isnull(SumDuration,0)) > 0 Then SUM(isnull(SumCODuration,0))/SUM(isnull(SumDuration,0))    
    Else Null   
    End)  
 from  @SelectedPlantIDs as  myPlant   
 join SupplyChain.tPlantKPI as p on p.PlantID = myPlant.PlantID And p.AggregationID = 3 And p.AnchorDateID = @AnchorDatePrev)  
 
 --Select @TMETotal  
Declare @TotalFlavor Decimal(18,1)  
Declare @Total Decimal(18,1)

Declare @TotalFlavorPY Decimal(18,1)  
Declare @TotalPY Decimal(18,1)
Declare @TotalCOPY Decimal(9,1)
Declare @TotalCO Decimal(9,1)

Declare @LYBaseLine Table 
(
	LineID int,
	PlantDesc varchar(200),
	LineName varchar(200),
	LYWeightAverage decimal(10,7),
	LYBaseLinePercentage decimal(10,7)
)  
  
Select @TotalFlavorPY = Sum(SumFlavorCODuration), @TotalPY = Sum(SumActualQty) , @TotalCOPY = Sum(SumFlavorCODuration)
From SupplyChain.tPlantKPI pk  
Join @SelectedPlantIDs v on pk.PlantID = v.PlantID  
Where AnchorDateID = @AnchorDatePrev And AggregationID = 3  

Insert @LYBaseLine 
Select lk.LineID, p.PlantDesc, l.LineName,
	Case When @TotalFlavorPY > 0 And lk.CountFlavorCO > 0 Then 
	 lk.SumFlavorCODuration*lk.SumFlavorCODuration/lk.CountFlavorCO/@TotalFlavorPY
    Else 0 End AFCO,
	lk.SumFlavorCODuration/@TotalCOPY
From SupplyChain.tLineKPI lk  
Join SupplyChain.Line l on lk.LineID = l.LineID
Join SupplyChain.Plant p on p.PlantID = l.PlantID  
Join @SelectedPlantIDs myPlant on l.PlantID = myPlant.PlantID  
Where lk.AggregationID = 3 And lk.AnchorDateID = @AnchorDatePrev

--Select * From @LYBaseLine Order By PlantDesc, LineName

Select @AFCOTotalPY = Sum(LYWeightAverage)
From @LYBaseLine

If @AFCOTotalPY = 0 
Begin
	Select @TotalFlavor = Sum(SumFlavorCODuration), @TotalCO = Sum(SumFlavorCODuration)
	From SupplyChain.tPlantKPI pk  
	Join @SelectedPlantIDs v on pk.PlantID = v.PlantID  
	Where AnchorDateID = @AnchorDate And AggregationID = 3  

	Delete From @LYBaseLine

	Insert @LYBaseLine 
	Select lk.LineID, p.PlantDesc, l.LineName, 0 AFCO,
		lk.SumFlavorCODuration/@TotalCO
	From SupplyChain.tLineKPI lk  
	Join SupplyChain.Line l on lk.LineID = l.LineID
	Join SupplyChain.Plant p on p.PlantID = l.PlantID  
	Join @SelectedPlantIDs myPlant on l.PlantID = myPlant.PlantID  
	Where lk.AggregationID = 3 And lk.AnchorDateID = @AnchorDate
End

--Select py.PlantDesc, py.LineID, py.LineName, py.LYBaseLinePercentage, Case When CountFlavorCO = 0 Then 0 Else SumFlavorCODuration*py.LYBaseLinePercentage/CountFlavorCO End AVThisYear
--From SupplyChain.tLineKPI lk  
--Join SupplyChain.Line l on lk.LineID = l.LineID  
--Join @SelectedPlantIDs myPlant on l.PlantID = myPlant.PlantID
--Join @LYBaseLine py on py.LineID = lk.LineID
--Where lk.AggregationID = 3 And lk.AnchorDateID = @AnchorDate  
 
Select @AFCOTotal =  ( 
Select Sum(AFCO)
From  
	(   
		Select lk.LineID,   
			Case When CountFlavorCO = 0 Then 0 Else SumFlavorCODuration*py.LYBaseLinePercentage/CountFlavorCO End AFCO  
		From SupplyChain.tLineKPI lk  
		Join SupplyChain.Line l on lk.LineID = l.LineID  
		Join @SelectedPlantIDs myPlant on l.PlantID = myPlant.PlantID
		Join @LYBaseLine py on py.LineID = lk.LineID
		Where lk.AggregationID = 3 And lk.AnchorDateID = @AnchorDate  
	) temp
)

------------------------------------------AFCO Wieghted Average Start-----------------------------------------------------

Declare @Output Table
(
	PlantID int,
	PlantName varchar(128),
	LineName varchar(128),
	LineID int,
	TimePeroidDisplay varchar(128),
	TimePeriodSortOrder int,
	YearName varchar(128),
	YearSortOrder int,
	SumFlavorCODuration Decimal(18, 8), 
	CountFlavorCO int,
	SumDuration Decimal(18, 8)
)

----------------- This year place holder -------------------------
Insert Into @Output(PlantID, PlantName, LineName, LineID, TimePeriodSortOrder, TimePeroidDisplay, YearSortOrder, YearName, 
		 CountFlavorCO, SumFlavorCODuration, SumDuration)
Select temp.PlantID, temp.PlantName, temp.LineName, temp.LineID,
ta.SortOrder TimePeriodSortOrder, 
Case When ta.Name = 'Today' Then 'Yesterday (' + Substring(DateName(Month, SupplyChain.udfConvertToDate(@AnchorDate)), 1, 3) + ' ' + Convert(varchar, Day(SupplyChain.udfConvertToDate(@AnchorDate))) + ')' 
--Case When ta.Name = 'Today' Then 'Yesterday (' + Substring(DateName(WeekDay, SupplyChain.udfConvertToDate(@AnchorDate)), 1, 3) + ', ' + Substring(DateName(Month, SupplyChain.udfConvertToDate(@AnchorDate)), 1, 3) + ' ' + Convert(varchar, Day(SupplyChain.udfConvertToDate(@AnchorDate))) + ')' 
--Case When ta.Name = 'Today' Then 'Yesterday (' + Convert(varchar(5), SupplyChain.udfConvertToDate(@AnchorDate), 110) + ')' 
When ta.Name = 'MTD' Then 'MTD (Last ' + convert(varchar(3), @AnchorDate%100) + ' Days)'
When ta.Name = 'MTD' Then DATENAME(month, SupplyChain.udfConvertToDate(@AnchorDate)) + '(Last ' + convert(varchar(3), @AnchorDate%100) + ' Days)'
When ta.Name = 'YTD' Then 'YTD (Last ' + convert(varchar, datepart(dayofyear,SupplyChain.udfConvertToDate(@AnchorDate))) + ' Days)'
When ta.Name = 'YTD' Then DATENAME(year, SupplyChain.udfConvertToDate(@AnchorDate)) + '(Last ' + convert(varchar, datepart(dayofyear,SupplyChain.udfConvertToDate(@AnchorDate))) + ' Days)'
Else ta.Name End TimePeroidDisplay,
1 YearSortOrder, 'This Year', 0,0,0
From SupplyChain.TimeAggregation ta
Cross Join 
(Select l.LineID, LineName, p.PlantID, PlantDesc PlantName
From SupplyChain.Line l
Join SupplyChain.LineType lt on l.LineTypeID = lt.LineTypeID
Join SupplyChain.Plant p on l.PlantID = p.PlantID) Temp
Where PlantID in 
(
	Select PlantID From SupplyChain.Plant Where Logitude is not null And Latitude is not null 
)
And ta.Active = 1 And ta.AggregationID = 3

----------------- Last year place holder -------------------------
Insert Into @Output(PlantID, PlantName, LineName, LineID, TimePeriodSortOrder, TimePeroidDisplay, YearSortOrder, YearName, 
		 CountFlavorCO, SumFlavorCODuration, SumDuration)
Select temp.PlantID, temp.PlantName, temp.LineName, temp.LineID,
ta.SortOrder TimePeriodSortOrder, 
Case When ta.Name = 'Today' Then 'Yesterday(' + Convert(varchar(5), SupplyChain.udfConvertToDate(@AnchorDate), 110) + ')' Else ta.Name End TimePeroidDisplay,
2 YearSortOrder, 'Last Year', 0,0,0
From SupplyChain.TimeAggregation ta
Cross Join 
(Select l.LineID, LineName, p.PlantID, PlantDesc PlantName
From SupplyChain.Line l
Join SupplyChain.LineType lt on l.LineTypeID = lt.LineTypeID
Join SupplyChain.Plant p on l.PlantID = p.PlantID) Temp
Where PlantID in
(
	Select PlantID From SupplyChain.Plant Where Logitude is not null And Latitude is not null 
)
And ta.Active = 1

Update op Set
	CountFlavorCO = fact.CountFlavorCO, 
	SumFlavorCODuration = fact.SumFlavorCODuration,
	SumDuration = fact.SumActualQty
From @Output op
Left Join 
(
	Select LIneID, LineName + ' - ' + LineTypeName As LineName, 
	Case When TimePeroid = 'Today' Then Convert(varchar, SupplyChain.udfConvertToDate(@AnchorDate))  Else TimePeroid End TimePeroidDisplay,
	v.SortOrder TimePeriodSortOrder, 'This Year' YearName, 1 YearSortOrder, SumActualQty, SumCapacityQty, SumPlanQty, SumDuration, SumCODuration, CountFlavorCO, SumFlavorCODuration
	From SupplyChain.vPTKPIs v
	Where PlantID in
	(
		Select PlantID From SupplyChain.Plant Where Logitude is not null And Latitude is not null 
	)
	And DateID = @AnchorDate
	Union All
	Select LIneID, LineName + ' - ' + LineTypeName As LineName, 
	Case When TimePeroid = 'Today' Then Convert(varchar, SupplyChain.udfConvertToDate(@AnchorDate))  Else TimePeroid End TimePeroidDisplay,
	v.SortOrder TimePeriodSortOrder, 'Last Year' YearName, 2 YearSortOrder, SumActualQty, SumCapacityQty, SumPlanQty, SumDuration, SumCODuration, CountFlavorCO, SumFlavorCODuration
	From SupplyChain.vPTKPIs v
	Where PlantID in
	(
		Select PlantID From SupplyChain.Plant Where Logitude is not null And Latitude is not null 
	)
	And DateID = @AnchorDate % 10000 + ((@AnchorDate / 10000) - 1) * 10000
) fact 
On op.LineID = fact.LineID And op.YearSortOrder = fact.YearSortOrder And op.TimePeriodSortOrder = fact.TimePeriodSortOrder

------------------------------------
--- Remove the inactive line, that is defined as no year to date actual capacity ---
Delete 
From @Output
Where LineName in (
Select LineName
From @Output
Where YearSortOrder = 1 And TimePeriodSortOrder = 4
And Isnull(SumDuration, 0) = 0)

------ Remove the Year Grouping and instead create addtional columns -------------
------------------------------------
Declare @Out2 Table
(
	PlantID int,
	PlantName varchar(200),
	LineID int,
	LineName varchar(200),
	TimePeroidDisplay varchar(100),
	TimePeriodSortOrder int,
	CountFlavorCO int,
	SumFlavorCODuration decimal(10,1),
	LYCountFlavorCO int,
	LYSumFlavorCODuration decimal(10, 1),
	SumDuration decimal(10, 1),
	LYSumDuration decimal(10, 1),
	LineWeight Decimal(5,4),
	LYLineWeight Decimal(5,4),
	TYLineWeight Decimal(5,4),
	AVCO decimal(10,4),
	LYAVCO decimal(10,4),
	WeightedAVCO decimal(10,4),
	WeightedLYAVCO decimal(10,4)
)

Insert @Out2
Select TY.PlantID, TY.PlantName, TY.LineID, TY.LineName,
	TY.TimePeroidDisplay,
	TY.TimePeriodSortOrder,
	isnull(TY.CountFlavorCO, 0) CountFlavorCO, 
	isnull(TY.SumFlavorCODuration, 0) SumFlavorCODuration,
	isnull(LY.LYCountFlavorCO, 0) LYCountFlavorCO, 
	isnull(LY.LYSumFlavorCODuration, 0) LYSumFlavorCODuration, 
	Isnull(TY.SumDuration,0) SumDuration,
	Isnull(LY.LYSumDuration, 0) LYSumDuration
	, 0 LineWeight, 0, 0, 0, 0, 0, 0
From (
Select PlantID, PlantName, LineID, LineName,
	TimePeroidDisplay,
	TimePeriodSortOrder,
	YearName,
	YearSortOrder,
	CountFlavorCO, 
	SumFlavorCODuration,
	SumDuration
From @Output
Where YearSortOrder = 1) TY
Left Join
(
Select PlantID, PlantName, LineID, LineName,
	TimePeroidDisplay,
	TimePeriodSortOrder,
	YearName,
	YearSortOrder,
	CountFlavorCO LYCountFlavorCO, 
	SumFlavorCODuration LYSumFlavorCODuration,
	SumDuration LYSumDuration
From @Output
Where YearSortOrder = 2
) LY On TY.PlantName = LY.PlantName And TY.LineName = LY.LineName And TY.TimePeriodSortOrder = LY.TimePeriodSortOrder
Order By TY.PlantName, LineName, TimePeriodSortOrder

Declare @PlantSum Table
(
	PlantID int,
	TimePeriodSortOrder int,
	FCODuration decimal(10,1),
	LYFCODuration decimal(10,1)
)
Insert @PlantSum
Select PlantID, TimePeriodSortOrder, Sum(SumFlavorCODuration), Sum(LYSumFlavorCODuration)
From @Out2
Group By PlantID, TimePeriodSortOrder

Update o2
Set LineWeight = Case When LYFCODuration = 0 And FCODuration = 0 Then 0 
					  When LYFCODuration = 0 Then SumFlavorCODuration/FCODuration
					  Else LYSumFlavorCODuration/LYFCODuration
					  End,
	LYLineWeight = Case When LYFCODuration > 0 Then LYSumFlavorCODuration/LYFCODuration
					  Else 0
					  End,
	TYLineWeight = Case When FCODuration > 0 Then SumFlavorCODuration/FCODuration
					  Else 0
					  End,
	AVCO = Case When CountFlavorCO = 0 Then 0
				Else SumFlavorCODuration/CountFlavorCO End,
	LYAVCO = Case When LYCountFlavorCO = 0 Then 0
				Else LYSumFlavorCODuration/LYCountFlavorCO End
From @Out2 o2
Join @PlantSum s on o2.PlantID = s.PlantID And o2.TimePeriodSortOrder = s.TimePeriodSortOrder

Update @Out2
Set WeightedAVCO = Case When TYLineWeight = 0 Then 0
		Else AVCO*LineWeight/TYLineWeight End,
	WeightedLYAVCO = LYAVCO
From @Out2 o2

----Now Update the Plant Level Data
Update t1
Set AFCOMTD = t2.AFCO, AFCOMTDPY = t2.AFCOPY
from @SupplyChainManufacutringTME as t1 Join (Select PlantID, SUM(AVCO*LineWeight) as AFCO, SUM(LYAVCO*LineWeight) as AFCOPY From @Out2 as t
Group By PlantID) as t2 on t1.PlantID = t2.PlantID 

------------------------------------------AFCO Wieghted Average Complete-----------------------------------------------------
   
  
Update m  
Set TMETotal = @TMETotal * 100  
	,TMETotalPY = @TMETotalPY * 100
	,AFCOTotal = @AFCOTotal
	,AFCOTotalPY = @AFCOTotalPY  
	,InventoryCasesTotal = (Select SUM(Isnull(EndingInventory,0)/1000) from SAP.BP7PlantInventory Where SAPPlantNumber in (Select SAPPlantNumber from SupplyChain.Plant Where PlantID in (Select PlantID from @SelectedPlantIDs)) And CalendarDate=@AnchorDate)
	,InventoryCasesTotalPY = (Select SUM(Isnull(EndingInventory,0)/1000) from SAP.BP7PlantInventory Where SAPPlantNumber in (Select SAPPlantNumber from SupplyChain.Plant Where PlantID in (Select PlantID from @SelectedPlantIDs)) And CalendarDate=@AnchorDatePrev)  
	,RecordableTotal = (Select SUM(RecordableMDT) from [SupplyChain].[tManufacturingMeasures_ToBeDeleted] Where PlantID in (Select PlantID from @SelectedPlantIDs))  
	,RecordableTotalPY = (Select SUM(RecordableMDT) from [SupplyChain].[tManufacturingMeasures_ToBeDeleted] Where PlantID in (Select PlantID from @SelectedPlantIDs))  
	,TMEFavUnFav = (TMEMTD-TMEMTDPY)  
	,AFCOFAVUnFAVPercent = (CONVERT(DECIMAL(9,2),((AFCOMTD - AFCOMTDPY)/nullif(AFCOMTDPY,0)) * 100))  
	,AFCOFAVUnFAV = (CONVERT(DECIMAL(9,2),((AFCOMTD - AFCOMTDPY))))
	,RecordableFavUnFav=(RecordableMTD - RecordableMTDPY)  
	,InvCasesFavUnFav=(InventoryCasesMTD - InventoryCasesMTDPY)
,InvCasesFavUnFavPercent=(((InventoryCasesMTD - InventoryCasesMTDPY)*1.0/nullif(InventoryCasesMTDPY,0))* 100)
from @SupplyChainManufacutringTME as m  
  
 -- ,  
 --AFCORank = temp.AFCORank,  
 --RecordableRank = temp.RecordableRank,  
 --InventoryCasesRank = temp.InvCaseRank, 
--TME Rank
Update m  
set TMERank=temp.TMERank
from @SupplyChainManufacutringTME as m Inner Join   
(Select myPlant.PlantID, Rank() Over (ORDER BY  TMEFavUnFav Desc) as  TMERank
 --Rank() Over (ORDER BY InvCasesFavUnFav Asc) as InvCaseRank  
from @SupplyChainManufacutringTME as m inner join @SelectedPlantIDs myPlant on m.PlantID = myPlant.PlantID  
Where Longitude is not null And Latitude is not null And TMEFavUnFav is not null)temp on m.PlantID = temp.PlantID  

--AFCO Rank
Update m  
Set AFCORank = temp.AFCORank
from @SupplyChainManufacutringTME as m Inner Join   
(Select myPlant.PlantID, Rank() Over (ORDER BY  AFCOFAVUnFAVPercent Asc) as  AFCORank
 --Rank() Over (ORDER BY InvCasesFavUnFav Asc) as InvCaseRank  
from @SupplyChainManufacutringTME as m inner join @SelectedPlantIDs myPlant on m.PlantID = myPlant.PlantID  
Where Longitude is not null And Latitude is not null And AFCOFAVUnFAVPercent is not null)temp on m.PlantID = temp.PlantID
  
--Recordables Rank
Update m  
Set RecordableRank = temp.RecordableRank
from @SupplyChainManufacutringTME as m Inner Join   
(Select myPlant.PlantID, Rank() Over (ORDER BY RecordableFavUnFav Asc) as RecordableRank
 --Rank() Over (ORDER BY InvCasesFavUnFav Asc) as InvCaseRank  
from @SupplyChainManufacutringTME as m inner join @SelectedPlantIDs myPlant on m.PlantID = myPlant.PlantID  
Where Longitude is not null And Latitude is not null And RecordableFavUnFav is not null)temp on m.PlantID = temp.PlantID


--Inventory Rank
Update m  
Set InventoryCasesRank = temp.InventoryCasesRank
from @SupplyChainManufacutringTME as m Inner Join   
(Select myPlant.PlantID, Rank() Over (ORDER BY InvCasesFavUnFavPercent Asc) as  InventoryCasesRank
from @SupplyChainManufacutringTME as m inner join @SelectedPlantIDs myPlant on m.PlantID = myPlant.PlantID  
Where Longitude is not null And Latitude is not null And InvCasesFavUnFav is not null)temp on m.PlantID = temp.PlantID

---My Plants
Select *
--, 1 [HardValue_TMEPlan],1 [HardValue_TMEFU],1 [HardValue_2012],1 [HardValue_PacevsPY],
--  1 [HardValue_AFCOThreshold],1  [HardValue_AFCOFU],1  [HardValue_InvCasesYesterday],
--  1 [HardValue_InvCasesAvCM],1  [HardValue_InvCaseAvCY],1  [HardValue_InvCasePYsameMonth]
From @SupplyChainManufacutringTME Where Longitude is not null And Latitude is not null 
--And PlantID in (17,18,19,20,21)
     
END    
  

GO
/****** Object:  StoredProcedure [SupplyChain].[GetProductLineWithTradeMark]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [SupplyChain].[GetProductLineWithTradeMark]    
      
AS        
BEGIN     
                                                            
SET NOCOUNT ON;                  
   --SET @query = ' where BranchID IN ('+@BranchIds+') ORDER BY 1'    
     --SELECT Distinct ProductLineID,ProductLineName,TradeMarkID,SAPTradeMarkID,TradeMarkName    
     --          FROM [MView].[BranchProductLine] Order by ProductLineID              
	 Select pl.ProductLineID, pl.ProductLineName,t.TradeMarkID, t.SAPTradeMarkID,t.TradeMarkName from SAP.TradeMark as t inner join SAP.ProductLine as pl on t.ProductLineID = pl.ProductLineID Order by ProductLineID, TradeMarkName
   --EXECUTE sp_executesql @query                 
END 



GO
/****** Object:  StoredProcedure [SupplyChain].[pGetCalFilteredPromotionId]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [SupplyChain].[pGetCalFilteredPromotionId] @Brand VARCHAR(50) = NULL
	,@Package VARCHAR(50) = NULL
	,@Account VARCHAR(50) = NULL
	,@Channel VARCHAR(50) = NULL
	,@Bottler VARCHAR(50) = NULL
AS
DECLARE @flag INT

SET @flag = 0

SELECT 0 flag
	,- 1 Promotionid
INTO #FilterPromotionID

IF @Channel = 'My Channel'
	OR @Channel = 'All Channel'
	SET @Channel = ''

IF @Account = 'My Account'
	OR @Account = 'All Account'
	SET @Account = ''

IF (isnull(@Brand, '') <> '')
BEGIN
	INSERT INTO #FilterPromotionID
	SELECT 1
		,promotionid
	FROM playbook.promotionbrand
	WHERE brandid IN (
			SELECT brandid
			FROM sap.brand
			WHERE brandname IN (
					SELECT value
					FROM [CDE].[udfSplit](@Brand, ',')
					)
			)
	
	UNION
	
	SELECT 1
		,promotionid
	FROM playbook.promotionbrand
	WHERE trademarkid IN (
			SELECT trademarkid
			FROM sap.trademark
			WHERE TradeMarkName IN (
					SELECT value
					FROM [CDE].[udfSplit](@Brand, ',')
					)
			)

	SET @flag = 1
END

IF (isnull(@Package, '') <> '')
BEGIN
	INSERT INTO #FilterPromotionID
	SELECT 1
		,promotionid
	FROM playbook.promotionpackage
	WHERE packageid IN (
			SELECT packageid
			FROM sap.package
			WHERE packagename IN (
					SELECT value
					FROM [CDE].[udfSplit](@Package, ',')
					)
			)

	SET @flag = @flag + 1
END

IF (isnull(@Account, '') <> '')
BEGIN
	INSERT INTO #FilterPromotionID
	SELECT 1
		,promotionid
	FROM playbook.promotionaccount
	WHERE localchainid IN (
			SELECT localchainid
			FROM sap.localchain
			WHERE localchainname IN (
					SELECT value
					FROM [CDE].[udfSplit](@Account, ',')
					)
			)
	
	UNION
	
	SELECT 1
		,promotionid
	FROM playbook.promotionaccount
	WHERE regionalchainid IN (
			SELECT regionalchainid
			FROM sap.regionalchain
			WHERE regionalchainname IN (
					SELECT value
					FROM [CDE].[udfSplit](@Account, ',')
					)
			)
	
	UNION
	
	SELECT 1
		,promotionid
	FROM playbook.promotionaccount
	WHERE nationalchainid IN (
			SELECT nationalchainid
			FROM sap.nationalchain
			WHERE nationalchainname IN (
					SELECT value
					FROM [CDE].[udfSplit](@Account, ',')
					)
			)

	SET @flag = @flag + 1
END

IF (isnull(@Channel, '') <> '')
BEGIN
	INSERT INTO #FilterPromotionID
	SELECT 1
		,promotionid
	FROM playbook.promotionchannel
	WHERE channelid IN (
			SELECT channelid
			FROM sap.channel
			WHERE ChannelName IN (
					SELECT value
					FROM [CDE].[udfSplit](@Channel, ',')
					)
			)
	
	UNION
	
	SELECT 1
		,promotionid
	FROM playbook.promotionchannel
	WHERE superchannelid IN (
			SELECT SuperChannelID
			FROM sap.SuperChannel
			WHERE SuperChannelName IN (
					SELECT value
					FROM [CDE].[udfSplit](@Channel, ',')
					)
			)

	SET @flag = @flag + 1
END

IF (isnull(@Bottler, '') <> '')
BEGIN
	DECLARE @BottlerID INT

	SELECT @BottlerID = bottlerid
	FROM bc.bottler
	WHERE bottlername = @Bottler

	SELECT *
	INTO #BottlerChain
	FROM bc.tBottlerChainTradeMark
	WHERE bottlerid = @BottlerID

	INSERT INTO #FilterPromotionID
	SELECT DISTINCT 1
		,a.promotionid
	FROM Playbook.RetailPromotion a
	LEFT JOIN Playbook.PromotionAccountHier b ON a.promotionid = b.promotionid
	LEFT JOIN Playbook.promotiongeohier c ON c.promotionid = a.promotionid
	LEFT JOIN playbook.PromotionBrand d ON d.promotionid = a.promotionid
	LEFT JOIN sap.brand brnd ON brnd.BrandID = d.BrandID --JOIN #BottlerChain tc ON tc.bottlerid = c.bottlerid    
	--AND tc.trademarkid = case when isnull(d.trademarkid,0) = 0  then brnd.Trademarkid else d.trademarkid end    
	--AND tc.localchainid = b.localchainid    
	WHERE c.BottlerID = @BottlerID

	SET @flag = @flag + 1
END --select * from #FilterPromotionID    

DECLARE @retval VARCHAR(MAX)

SET @retval = (
		SELECT DISTINCT Convert(VARCHAR(20), Promotionid) + ','
		FROM #FilterPromotionID
		WHERE promotionid <> - 1
		GROUP BY promotionid
		HAVING sum(flag) = @flag
		FOR XML path('')
		)

SELECT @retval

GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdInventoryBranchMeasuresForLanding]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/* Test Bench
exec [SupplyChain].[pGetDsdInventoryBranchMeasuresForLanding] 20141014,'118,8,11,12,13,14,15,18,19,21,25,29,33,35,36,37,42,44,47,48,50,52,53,54,58','69,192,138,29,232,221,75,158,195,3,12,35,129,49,190,184,64,101', '46,69,138,152,118,78,129,86,64,44,150,47,70,30,124,133,61,36','MinMax'
exec [SupplyChain].[pGetDsdInventoryBranchMeasuresForLanding] 20141106,'1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,167,168,169,170,172,173,174', '1,3,5,20,22,33,59,35,37,60,44,61,46,49,50,51,65,67,68,34,64,89,173,54,97,129,130,154,187,216,228','22,27,30,33,38,39,44,46,47,51,59,62,63,64,67,68,77,78,79,86,90,94,108,117,124,129,133,134,138,139,140,143,145,146,150,151,152,154','DOS'

	24.SupplyChain.pGetDsdInventoryBranchMeasuresForLanding.sql

*/

CREATE Proc [SupplyChain].[pGetDsdInventoryBranchMeasuresForLanding]
(
	@DateID int,
	@BranchIDs varchar(4000),
	@TrademarkIDs varchar(4000),
	@PackageTypeIDs varchar(4000),
	@MeasureType varchar(10),
	@AggregationID int = 0
)
AS	
	Set NoCount On;
	
	Declare @SupplyChainDsdInventoryMeasuresByBranch Table  
			 (  
			   BranchID int not null
			  ,BranchName varchar(50) not null
			  ,Longitude varchar(20) null
			  ,Latitude varchar(20) null
			  ,CaseCut int  null
			  ,OOS Decimal(10,1) null
			  ,OOSDiff Decimal(10,1) null
			  ,DaysOfSupply Decimal(10,1) null
			  ,DaysOfSupplyDiff Decimal(10,1) null
			  ,DaysOfSupplyEndingInventory Decimal(10,1) null
			  ,MinMaxMiddle Decimal(10,1) null
			  ,MinMaxMiddleDiff Decimal(10,2) null
			  ,MinMaxLeftAbs int null
			  ,MinMaxMiddleAbs int null
			  ,MinMaxRightAbs int null
			  ,OOSRed Decimal(10,1) null
			  ,OOSGreen Decimal(10,1) null
			  ,DOSRed Decimal(10,1) null
			  ,DOSGreen Decimal(10,1) null
			  ,MinMaxRed Decimal(10,1) null
			  ,MinMaxGreen Decimal(10,1) null
			  ,KPILevel varchar(10) null
			 )

Declare @SelectedBranchIDs Table
		(
			BranchID int
		)

Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)

Declare @SelectedPackageTypeIDs Table
		(
			PackageTypeID int
		)

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')

Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')


Insert into @SelectedPackageTypeIDs
Select Value from dbo.Split(@PackageTypeIDs,',')

	Insert into @SupplyChainDsdInventoryMeasuresByBranch (BranchID,BranchName, Longitude, Latitude, OOSRed, OOSGreen, DOSRed, DOSGreen, MinMaxRed, MinMaxGreen) 
			Select b.BranchID, b.BranchName, b.Longitude, b.Latitude, bt.BranchOOSLeftThreshold, bt.BranchOOSRightThreshold, bt.BranchDOSLeftThreshold, bt.BranchDOSRightThreshold, bt.BranchMinMaxLeftThreshold, bt.BranchMinMaxRightThreshold
			from SAP.Branch as b 
			Inner Join SupplyChain.vBranchThreshold as bt on b.BranchID = bt.BranchID 
			Where bt.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)

	If(@MeasureType = 'OOS') 
		Begin
			Update mb
			Set mb.OOS = OOSTemp.OOS,
			mb.CaseCut = OOSTemp.CaseCut,
			mb.OOSDiff = (OOSTemp.OOS - mb.OOSGreen),  --- This will negative values for the Green Branches. So we can ignore if the difference is less than 0
			mb.KPILevel = Case 
							When OOSTemp.OOS > mb.OOSRed Then 'Red' 
							When (OOSTemp.OOS >= mb.OOSGreen And OOSTemp.OOS <= mb.OOSRed) Then 'Amber' 
							When OOSTemp.OOS < mb.OOSGreen Then 'Green' End
			from @SupplyChainDsdInventoryMeasuresByBranch as mb
			 Inner Join (Select BranchID
								,((SUM(oos.CaseCut) * 1.0)/NUllIF(sum(Isnull(oos.Quantity, 0)),0)) * 100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut 
						 from SupplyChain.tDsdDailyCaseCut as OOS
							Where  OOS.DateID = @DateID 
							And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
							And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		
							Group By OOS.BranchID) as OOSTemp on mb.BranchID= OOSTemp.BranchID
			 Select top 5 *, Rank() Over (ORDER BY mb.OOSDiff Desc) as MeasureRank  from @SupplyChainDsdInventoryMeasuresByBranch as mb where mb.CaseCut is not null And mb.OOSDiff > 0 order by OOSDiff Desc
		End
	Else If(@MeasureType = 'DOS') 
		Begin
			Update mb
				Set mb.DaysOfSupply = DOSTemp.DaysOfSupply,
					mb.DaysOfSupplyDiff = (DOSTemp.DaysOfSupply - mb.DOSGreen),  --- This will negative values for the Green Branches. So we can ignore if the difference is less than 0
					mb.DaysOfSupplyEndingInventory = DOSTemp.DaysOfSupplyEndingInventory,
					mb.KPILevel = Case 
								When DOSTemp.DaysOfSupply > mb.DOSRed Then 'Red' 
								When (DOSTemp.DaysOfSupply >= mb.DOSGreen And DOSTemp.DaysOfSupply <= mb.DOSRed) Then 'Amber' 
								When DOSTemp.DaysOfSupply < mb.DOSGreen Then 'Green' End
			from @SupplyChainDsdInventoryMeasuresByBranch as mb
			Inner Join (Select BranchID
							   ,  ((SUM(dos.EndingInventory)*1.0)/NullIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 30  as DaysOfSupply
							   , ((SUM(dos.EndingInventory)*1.0)/1000) as DaysOfSupplyEndingInventory
						 from SupplyChain.tDsdDailyBranchInventory as DOS 
						 Where DOS.DateID = @DateID 
								And dos.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
								And dos.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
								And dos.PackageTypeID in (Select PackageTypeID from @SelectedPackageTypeIDs)
								Group By BranchID) as DOSTemp on mb.BranchID=DOSTemp.BranchID
			Select  top 5 *, Rank() Over (ORDER BY mb.DaysOfSupplyDiff Desc) as MeasureRank  from @SupplyChainDsdInventoryMeasuresByBranch as mb where mb.DaysOfSupply > 0 And  mb.DaysOfSupplyDiff > 0 order by mb.DaysOfSupplyDiff Desc
		End
	Else If(@MeasureType = 'MinMax')
		Begin
			Update mb
			Set 
				mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle,
				mb.MinMaxMiddleDiff = (mb.MinMAxGreen - minmaxTemp.MinMaxMiddle),--- This will negative values for the Green Branches. So we can ignore if the difference is less than 0
				mb.MinMaxLeftAbs = minmaxtemp.MinMaxLeftAbs,
				mb.MinMaxMiddleAbs = minmaxtemp.MinMaxMiddleAbs,
				mb.MinMaxRightAbs = minmaxtemp.MinMaxRightAbs,
				mb.KPILevel = Case 
							When minmaxTemp.MinMaxMiddle < mb.MinMaxRed Then 'Red' 
							When (minmaxTemp.MinMaxMiddle >= mb.MinMaxRed And minmaxTemp.MinMaxMiddle <= mb.MinMaxGreen) Then 'Amber' 
							When minmaxTemp.MinMaxMiddle > mb.MinMaxGreen Then 'Green' End
				
			from @SupplyChainDsdInventoryMeasuresByBranch as mb
			Inner Join (Select BranchID
								,(SUm(IsCompliant) * 1.0 )/ SUM(IsBelowMin + IsCompliant + IsAboveMax)*100 as MinMaxMiddle
								,SUM(IsBelowMin) as MinMaxLeftAbs
								,SUM(IsCompliant) as MinMaxMiddleAbs
								,SUM(IsAboveMax) as MinMaxRightAbs
								from SupplyChain.tDsdDailyMinMax as minmax
								Where minmax.DateID = @DateID 
								And minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
								And minmax.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)			
								And minmax.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)	
								Group By BranchID) as minmaxTemp on mb.BranchId = minmaxTemp.BranchId
			Select  top 5 *, Rank() Over (ORDER BY MinMaxMiddleDiff) as MeasureRank  from @SupplyChainDsdInventoryMeasuresByBranch as mb where mb.MinMaxMiddle <> mb.MinMAxGreen And mb.MinMaxMiddleDiff > 0 order by mb.MinMaxMiddleDiff
		  End




GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdInventoryMeasuresByBranch]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
/* Test Bench  
exec [SupplyChain].[pGetDsdInventoryMeasuresByBranch] 20141014,'8,11,12,13,14,15,18,19,21,25,29,33,35,36,37,42,44,47,48,50,52,53,54,58','69,192,138,29,232,221,75,158,195,3,12,35,129,49,190,184,64,101', '46,69,138,152,118,78,129,86,64,44,150,47,70,30,124,1', 'MinMax'
33,61,36'  
  
   
  
*/  
  
CREATE Proc [SupplyChain].[pGetDsdInventoryMeasuresByBranch]  
(  
 @DateID int,  
 @BranchIDs varchar(4000),  
 @TrademarkIDs varchar(4000),  
 @PackageTypeIDs varchar(4000),
 @MeasureType varchar(20)  ,
 @AggregationID int = 0  
)  
AS   
 Set NoCount On;  
   
 Declare @SupplyChainDsdInventoryMeasuresByBranch Table    
    (    
     BranchID int not null  
     ,BranchName varchar(50) not null  
     ,Longitude Decimal(10,6) null  
     ,Latitude Decimal(10,6) null  
     ,CaseCut int  null  
     ,OOS Decimal(10,1) null
	 ,OOSDiff Decimal(10,1) null 
     ,DaysOfSupply Decimal(10,1) null  
     ,DaysOfSupplyInventory Decimal(10,1) null  
     ,DaysOfSupplyDiff Decimal(10,1) null  
	 ,MinMaxLeft Decimal(10,1) null  
     ,MinMaxMiddle Decimal(10,1) null  
     ,MinMaxRight Decimal(10,1) null
	 ,MinMaxMiddleDiff Decimal(10,1) null    
      ,MinMaxLeftAbs int null  
     ,MinMaxMiddleAbs int null  
     ,MinMaxRightAbs int null  
     ,OOSRed Decimal(10,1) null  
     ,OOSGreen Decimal(10,1) null  
     ,DOSRed Decimal(10,1) null  
     ,DOSGreen Decimal(10,1) null  
     ,MinMaxRed Decimal(10,1) null  
     ,MinMAxGreen Decimal(10,1) null  
     --,OOSRank int null  
     --,DOSRank int null  
     --,MinMaxRank int null  
    )  
  
Declare @SelectedBranchIDs Table  
  (  
   BranchID int  
  )  
  
Declare @SelectedTradeMarkIDs Table  
  (  
   TradeMarkID int  
  )  
  
Declare @SelectedPackageTypeIDs Table  
  (  
   PackageTypeID int  
  )  
  
Insert into @SelectedBranchIDs  
Select Value from dbo.Split(@BranchIDs,',')  
  
Insert into @SelectedTradeMarkIDs  
Select Value from dbo.Split(@TrademarkIDs,',')  
  
  
Insert into @SelectedPackageTypeIDs  
Select Value from dbo.Split(@PackageTypeIDs,',')  
  
 Insert into @SupplyChainDsdInventoryMeasuresByBranch (BranchID,BranchName, Longitude, Latitude, OOSRed, OOSGreen, DOSRed, DOSGreen, MinMaxRed, MinMaxGreen)   
   Select b.BranchID, b.BranchName, b.Longitude, b.Latitude, bt.BranchOOSLeftThreshold, bt.BranchOOSRightThreshold, bt.BranchDOSLeftThreshold, bt.BranchDOSRightThreshold, bt.BranchMinMaxLeftThreshold, bt.BranchMinMaxRightThreshold  
   from SAP.Branch as b   
   Inner Join SupplyChain.vBranchThreshold as bt on b.BranchID = bt.BranchID   
   Where bt.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)  
  
 If(@MeasureType = 'OOS')
	Begin
		Update mb  
		  Set mb.OOS = OOSTemp.OOS,  
		  mb.CaseCut = OOSTemp.CaseCut,
		  	mb.OOSDiff = (OOSTemp.OOS - mb.OOSGreen)  --- This will negative values for the Green Branches. So we can ignore if the difference is less than 0  
		  from @SupplyChainDsdInventoryMeasuresByBranch as mb  
		   Inner Join (Select BranchID,((SUM(oos.CaseCut) * 1.0)/NUllIF(sum(Isnull(oos.Quantity, 0)),0))*100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from     
			  SupplyChain.tDsdDailyCaseCut as OOS  
			  Where  OOS.DateID = @DateID   
			  And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)  
			  And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)   
			  And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)    
			  Group By OOS.BranchID) as OOSTemp on mb.BranchID= OOSTemp.BranchID
		Select b.*, tRanking.MeasureRank as 'MeasureRank'
				from @SupplyChainDsdInventoryMeasuresByBranch as b Left Outer Join
					 (Select top 5 *, Rank() Over (ORDER BY mb.OOSDiff Desc) as MeasureRank  
							from @SupplyChainDsdInventoryMeasuresByBranch as mb 
							where mb.CaseCut is not null And mb.OOSDiff > 0 order by OOSDiff Desc) as tRanking on b.BranchID = tRanking.BranchID
	End  
 Else If (@MeasureType = 'DOS')
	Begin
		Update mb  
		  Set mb.DaysOfSupply = DOSTemp.DaysOfSupply,
		  mb.DaysOfSupplyDiff = (DOSTemp.DaysOfSupply - mb.DOSGreen),  --- This will negative values for the Green Branches. So we can ignore if the difference is less than 0  
		   mb.DaysOfSupplyInventory = DOSTemp.DaysOfSupplyInventory  
		  from @SupplyChainDsdInventoryMeasuresByBranch as mb  
		  Inner Join (Select BranchID  
							 , Case When sum(dos.Past31DaysXferOutPlusShipment) = 0  Then 0 else ((SUM(dos.EndingInventory)*1.0)/NullIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 30 End as DaysOfSupply  
							 ,(SUM(dos.EndingInventory)*1.0)/1000 as DaysOfSupplyInventory  
						  from SupplyChain.tDsdDailyBranchInventory as DOS   
						  Where DOS.DateID = @DateID   
						   And dos.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)  
						   And dos.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)   
						   And dos.PackageTypeID in (Select PackageTypeID from @SelectedPackageTypeIDs)  
						   Group By BranchID) as DOSTemp on mb.BranchID=DOSTemp.BranchID
		Select b.*, tRanking.MeasureRank as 'MeasureRank'
				from @SupplyChainDsdInventoryMeasuresByBranch as b Left Outer Join
					 (Select  top 5 *, Rank() Over (ORDER BY mb.DaysOfSupplyDiff Desc) as MeasureRank  
								from @SupplyChainDsdInventoryMeasuresByBranch as mb where mb.DaysOfSupply > 0 And  mb.DaysOfSupplyDiff > 0 order by mb.DaysOfSupplyDiff Desc) as tRanking on b.BranchID = tRanking.BranchID
  
	End
 Else If (@MeasureType = 'MinMax')
	Begin
		  Update mb  
			  Set mb.MinMaxLeft = minmaxTemp.MinMaxLeft,  
			   mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle,  
			   mb.MinMaxMiddleDiff = (mb.MinMAxGreen - minmaxTemp.MinMaxMiddle),--- This will negative values for the Green Branches. So we can ignore if the difference is less than 0
			   mb.MinMaxRight = minmaxTemp.MinMaxRight,  
			   mb.MinMaxLeftAbs = minmaxTemp.MinMaxLeftAbs,  
			   mb.MinMaxMiddleAbs = minmaxTemp.MinMaxMiddleAbs,  
			   mb.MinMaxRightAbs = minmaxTemp.MinMaxRightAbs  
			  from @SupplyChainDsdInventoryMeasuresByBranch as mb  
			  Inner Join (Select BranchID  
				   , (SUm(IsBelowMin) * 1.0 )/ SUM(IsBelowMin + IsCompliant + IsAboveMax)*100 as MinMaxLeft  
				   ,(SUm(IsCompliant) * 1.0 )/ SUM(IsBelowMin + IsCompliant + IsAboveMax)*100 as MinMaxMiddle  
				   , (SUm(IsAboveMax) * 1.0 )/ SUM(IsBelowMin + IsCompliant + IsAboveMax)*100 as MinMaxRight  
				   ,(SUm(IsBelowMin) * 1.0 ) as MinMaxLeftAbs  
				   ,(SUm(IsCompliant) * 1.0 ) as MinMaxMiddleAbs  
				   ,(SUm(IsAboveMax) * 1.0 ) as MinMaxRightAbs  
				   from SupplyChain.tDsdDailyMinMax as minmax  
				   Where minmax.DateID = @DateID   
				   And minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)  
				   And minmax.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)     
				   And minmax.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)   
				   Group By BranchID) as minmaxTemp on mb.BranchId = minmaxTemp.BranchId 
			Select b.*, tRanking.MeasureRank as 'MeasureRank'
						from @SupplyChainDsdInventoryMeasuresByBranch as b Left Outer Join
					 ( Select  top 5 *, Rank() Over (ORDER BY MinMaxMiddleDiff) as MeasureRank  
							from @SupplyChainDsdInventoryMeasuresByBranch as mb where mb.MinMaxMiddle <> mb.MinMAxGreen And mb.MinMaxMiddleDiff > 0 order by mb.MinMaxMiddleDiff) as tRanking on b.BranchID = tRanking.BranchID 
	End 
  


GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdInventoryMeasuresByBranchAggregated]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Test Bench
exec [SupplyChain].[pGetDsdInventoryMeasuresByBranchAggregated] 20141014,'8,11,12,13,14,15,18,19,21,25,29,33,35,36,37,42,44,47,48,50,52,53,54,58','69,192,138,29,232,221,75,158,195,3,12,35,129,49,190,184,64,101', '46,69,138,152,118,78,129,86,64,44,150,47,70,30,124,133,61,36'
exec [SupplyChain].[pGetDsdInventoryMeasuresByBranchAggregated] 20141118, '1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 146, 147, 148, 149, 150, 151, 152, 153, 163, 170, 172, 174'
																		, '1, 3, 7, 22, 29, 33, 35, 49, 65, 69, 75, 232, 101, 138, 145, 158, 170, 190, 194, 195, 196, 217, 221, 223, 231, 131, 160, 141, 12, 174, 68, 99, 184, 9, 67, 147, 162, 113, 44, 219, 154'
																		,'22, 27, 30, 32, 33, 38, 39, 44, 46, 47, 51, 59, 62, 63, 64, 67, 68, 73, 77, 78, 79, 85, 86, 88, 91, 94, 105, 108, 117, 124, 129, 133, 134, 138, 139, 140, 143, 145, 146, 150, 151, 152, 153, 154, 158, 159, 160, 162, 165'					

	
	
*/

CREATE PROC [SupplyChain].[pGetDsdInventoryMeasuresByBranchAggregated] (  
 @DateID INT =0  
 ,@BranchIDs VARCHAR(4000) =''  
 ,@TrademarkIDs VARCHAR(4000) = ''  
 ,@PackageTypeIDs varchar(4000)  
 ,@AggregationID INT = 0  
 )  
AS  
SET NOCOUNT ON;  

Declare @SupplyChainDsdInventoryMeasuresByBranchAggregated Table  
			 (  
				 IncomingOrderCases int  null
				 ,IncomingOrderCasesDayAfterTomorrow int  null
				,IncomingOrderUpdated Datetime2
				,CaseCut int null
				,OOS Decimal(10,1) null
				,DaysOfSupply Decimal(10,1) null
				,MinMaxLeft Decimal(10,1) null
				,MinMaxMiddle Decimal(10,1) null
				,MinMaxRight Decimal(10,1) null
				,OOSRed Decimal(10,1) null
				,OOSGreen Decimal(10,1) null
				,DOSRed Decimal(10,1) null
				,DOSGreen Decimal(10,1) null
				,MinMaxRed Decimal(10,1) null
				,MinMAxGreen Decimal(10,1) null
			 )

Declare @SelectedBranchIDs Table
		(
			BranchID int
		)

Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)

Declare @SelectedPackageTypeIDs Table
		(
			PackageTypeID int
		)
Declare @TomorrowDate int
Declare @DayAfterTomorrowDate int
Set @TomorrowDate = SupplyChain.udfConvertToDateID(getdate())
Set @DayAfterTomorrowDate = SupplyChain.udfConvertToDateID(DATEADD(d,1, GETDATE())) 

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')

Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')


Insert into @SelectedPackageTypeIDs
Select Value from dbo.Split(@PackageTypeIDs,',')

	----If we are showing only one branch, then need to return the threshold data for that one branch. If it's more than one branch and under one region we need to return the region threshold. If branches are falling under multiple region then need to return the OverAllThreshold
		If (Select Count(*) from @SelectedBranchIDs) = 1  
			Begin
				Insert into @SupplyChainDsdInventoryMeasuresByBranchAggregated (OOSRed, OOSGreen, DOSRed, DOSGreen, MinMaxRed, MinMaxGreen) 
					Select bt.BranchOOSLeftThreshold, bt.BranchOOSRightThreshold, bt.BranchDOSLeftThreshold, bt.BranchDOSRightThreshold, bt.BranchMinMaxLeftThreshold, bt.BranchMinMaxRightThreshold
					from SAP.Branch as b 
					Inner Join SupplyChain.vBranchThreshold as bt on b.BranchID = bt.BranchID 
					Where bt.BranchID in (Select BranchID from @SelectedBranchIDs)

			End
		Else If (Select Count(Distinct RegionID) from @SelectedBranchIDs sb inner Join Mview.LocationHier as lh on lh.BranchID = sb.BranchID) = 1 
			Begin
				Insert into @SupplyChainDsdInventoryMeasuresByBranchAggregated (OOSRed, OOSGreen, DOSRed, DOSGreen, MinMaxRed, MinMaxGreen) 
					Select Top 1 rt.RegionOOSLeftThreshold, rt.RegionOOSRightThreshold, rt.RegionDOSLeftThreshold, rt.RegionDOSRightThreshold, rt.RegionMinMaxLeftThreshold, rt.RegionMinMaxRightThreshold
					from MView.LocationHier as lh 
					Inner Join SupplyChain.vRegionThreshold as rt on lh.RegionID = rt.RegionID 
					Where Lh.BranchID in (Select BranchID from  @SelectedBranchIDs)

			End
		Else
			Begin 
				Insert into @SupplyChainDsdInventoryMeasuresByBranchAggregated (OOSRed, OOSGreen, DOSRed, DOSGreen, MinMaxRed, MinMaxGreen) 
					Select OAT.OverAllOOSLeftThreshold, OAT.OverAllOOSRightThreshold, OAT.OverAllDOSLeftThreshold, OAT.OverAllDOSRightThreshold, OAT.OverAllMinMaxLeftThreshold, OAT.OverAllMinMaxRightThreshold
						from SupplyChain.OverAllThreshold as OAT

			End
	
		Update mb
		Set mb.OOS = OOSTemp.OOS,
		mb.CaseCut = OOSTemp.CaseCut,
		mb.IncomingOrderUpdated = (Select Top 1 MergeDate From ETL.BCDataLoadingLog Where SchemaName = 'Apacheta'And TableName = 'OriginalOrder'),
		mb.IncomingOrderCases = Isnull((Select Sum(dcc.Quantity) from SupplyChain.tDsdDailyCaseCut as dcc  inner Join  SAP.Branch as b on dcc.BranchID = b.BranchID
										Where b.BranchID in (Select BranchID from @SelectedBranchIDs)
											  And dcc.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
											  And dcc.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)	
											 And DateID = @TomorrowDate),0),
		mb.IncomingOrderCasesDayAfterTomorrow = isnull((Select Sum(dor.Quantity) from SupplyChain.tDSDOpenOrder as DOR  inner Join  SAP.Branch as b on dor.BranchID = b.BranchID
										Where b.BranchID in (Select BranchID from @SelectedBranchIDs) 
											  And DOR.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
											  And DOR.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)
											  And DateID = @DayAfterTomorrowDate),0)
		from @SupplyChainDsdInventoryMeasuresByBranchAggregated as mb
		 Cross Join (Select ((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0)) * 100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
						SupplyChain.tDsdDailyCaseCut as OOS
						Where  OOS.DateID = @DateID 
						And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
						And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
						And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)	
						) as OOSTemp 

		Update mb
		Set mb.DaysOfSupply = DOSTemp.DaysOfSupply
		from @SupplyChainDsdInventoryMeasuresByBranchAggregated as mb
		Cross Join (Select Case When sum(dos.Past31DaysXferOutPlusShipment) = 0 Then 0 Else ((SUM(dos.EndingInventory)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 30 End as DaysOfSupply
					 from SupplyChain.tDsdDailyBranchInventory as DOS 
					 Where  DOS.DateID = @DateID 
						And DOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
						And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
						And DOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		 
						) as DOSTemp 

		Update mb
		Set mb.MinMaxLeft = minmaxTemp.MinMaxLeft,
			mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle,
			mb.MinMaxRight = minmaxTemp.MinMaxRight
		from @SupplyChainDsdInventoryMeasuresByBranchAggregated as mb
		Cross Join (Select  ((SUm(minMax.IsBelowMin) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxLeft
							,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
							, ((SUm(minMax.IsAboveMax) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxRight
							from SupplyChain.tDsdDailyMinMax as minmax
							 Where  minmax.DateID = @DateID And  minmax.BranchID in (Select BranchID from @SelectedBranchIDs)
						And minmax.TradeMarkID in (Select TradeMarkID from @SelectedTradeMarkIDs)	
						And minmax.PackageTypeID in (Select PackageTypeID from @SelectedPackageTypeIDs)
						) as minmaxTemp 
  Select * from @SupplyChainDsdInventoryMeasuresByBranchAggregated
--SELECT 2338 IncomingOrderCases  
-- ,getutcdate() IncomingOrderUpdated  
-- ,4 CaseCut  
-- ,2.5 OOS  
-- ,6.1 DaysOfSupply  
-- ,2.5 MinMaxleft  
-- ,89.1 MinMaxMiddle  
-- ,12.2 MinMaxRight  
-- ,-- Actuals  
-- 1.1 OOSRed  
-- ,1.2 OOSGreen  
-- ,2.3 DOSRed  
-- ,2.6 DOSGreen  
-- ,2.6 MinMaxRed  
-- ,2.9 MinMaxGreen --- Borders Threshholds  




GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdInventoryMeasuresByRegion]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Test Bench
exec [SupplyChain].[pGetDsdInventoryMeasuresByRegion] 20141014,'3,4,5','69,192,138,29,232,221,75,9,158,195,3,12,35,129,49,190,184,67', '46,69,138,175,152,118,78,129,86,64,38,44,150,47,70,30,124', 'MinMax'
*/

CREATE Proc [SupplyChain].[pGetDsdInventoryMeasuresByRegion]

(

	@DateID int,
	@RegionIDs varchar(4000),
	@BranchIDs varchar(4000),
	@TrademarkIDs varchar(4000),
	@PackageTypeIDs varchar(4000),
	@MeasureType varchar(20),
	@AggregationID int = 0
)

AS	
	Set NoCount On;
	Declare @SupplyChainDsdInventoryMeasuresByRegion Table  
			 (  
			  RegionID int not null
			  ,RegionName varchar(50) not null
			  ,Longitude Decimal(10,6) null
			  ,Latitude Decimal(10,6) null
			  ,CaseCut int  null
			  ,OOS Decimal(10,1) null
			  ,OOSDiff Decimal(10,1) null
			  ,DaysOfSupply Decimal(10,1) null
			  ,DaysOfSupplyInventory Decimal(10,1) null
			  ,DaysOfSupplyDiff Decimal(10,1) null  
			  ,MinMaxLeft Decimal(10,1) null
			  ,MinMaxMiddle Decimal(10,1) null
			  ,MinMaxMiddleDiff Decimal(10,1) null    
			  ,MinMaxRight Decimal(10,1) null
			  ,MinMaxLeftAbs int null
			  ,MinMaxMiddleAbs int null
			  ,MinMaxRightAbs int null
			  ,OOSRed Decimal(10,1) null
			  ,OOSGreen Decimal(10,1) null
			  ,DOSRed Decimal(10,1) null
			  ,DOSGreen Decimal(10,1) null
			  ,MinMaxRed Decimal(10,1) null
			  ,MinMAxGreen Decimal(10,1) null
			  --,OOSRank int null
			  --,DOSRank int null
			  --,MinMaxRank int null
			 )
Declare @SelectedRegionIDs Table
		(
			RegionID int
		)
Declare @SelectedBranchIDs Table
(
	BranchID int
)
Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)
Declare @SelectedPackageTypeIDs Table
		(
			PackageTypeID int
		)
Insert into @SelectedRegionIDs
Select Value from dbo.Split(@RegionIDs,',')

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')

Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')

Insert into @SelectedPackageTypeIDs
Select Value from dbo.Split(@PackageTypeIDs,',')


	Insert into @SupplyChainDsdInventoryMeasuresByRegion (RegionID,RegionName, Longitude, Latitude, OOSRed, OOSGreen, DOSRed, DOSGreen, MinMaxRed, MinMaxGreen) 
			Select r.RegionID, r.RegionName, r.Longitude, r.Latitude, rt.RegionOOSLeftThreshold, rt.RegionOOSRightThreshold, rt.RegionDOSLeftThreshold, rt.RegionDOSRightThreshold, rt.RegionMinMaxLeftThreshold, rt.RegionMinMaxRightThreshold
			from SAP.Region as r 
			Inner Join SupplyChain.vRegionThreshold as rt on r.RegionID = rt.RegionID 
			Where rt.RegionID in (Select RegionID from @SelectedRegionIDs)

If(@MeasureType = 'OOS')
	Begin
		Update mb
		Set mb.OOS = OOSTemp.OOS,
		mb.CaseCut = OOSTemp.CaseCut,
		 	mb.OOSDiff = (OOSTemp.OOS - mb.OOSGreen)  --- This will negative values for the Green Branches. So we can ignore if the difference is less than 0  
		from @SupplyChainDsdInventoryMeasuresByRegion as mb
		 Inner Join (Select RegionID,((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0)) * 100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
						SupplyChain.tDsdDailyCaseCut as OOS
						Where  OOS.DateID = @DateID 
						And OOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
						And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
						And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
						And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		
						Group By RegionID) as OOSTemp on mb.RegionID= OOSTemp.RegionID
		Select r.*, tRanking.MeasureRank as 'MeasureRank'
				from @SupplyChainDsdInventoryMeasuresByRegion as r Left Outer Join
					 (Select top 5 *, Rank() Over (ORDER BY mb.OOSDiff Desc) as MeasureRank  
							from @SupplyChainDsdInventoryMeasuresByRegion as mb 
							where mb.CaseCut is not null And mb.OOSDiff > 0 order by OOSDiff Desc) as tRanking on r.RegionID = tRanking.RegionID

	End
Else If(@MeasureType = 'DOS')
	Begin
		Update mb
		Set mb.DaysOfSupply = DOSTemp.DaysOfSupply,
			mb.DaysOfSupplyDiff = (DOSTemp.DaysOfSupply - mb.DOSGreen),  --- This will negative values for the Green Branches. So we can ignore if the difference is less than 0  
			mb.DaysOfSupplyInventory = DOSTemp.DaysOfSupplyInventory
		from @SupplyChainDsdInventoryMeasuresByRegion as mb
		Inner Join (Select RegionID
							, Case When sum(dos.Past31DaysXferOutPlusShipment) = 0 Then 0 Else ((SUM(dos.EndingInventory)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 30 End as DaysOfSupply
							,(SUM(dos.EndingInventory)*1.0)/1000 as DaysOfSupplyInventory
					 from SupplyChain.tDsdDailyBranchInventory as DOS 
					 Where DOS.DateID = @DateID 
							And dos.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
							And dos.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
							And dos.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And dos.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)	
							Group By RegionID) as DOSTemp on mb.RegionID=DOSTemp.RegionID
			Select r.*, tRanking.MeasureRank as 'MeasureRank'
				from @SupplyChainDsdInventoryMeasuresByRegion as r Left Outer Join
					 (Select  top 5 *, Rank() Over (ORDER BY mb.DaysOfSupplyDiff Desc) as MeasureRank  
								from @SupplyChainDsdInventoryMeasuresByRegion as mb where mb.DaysOfSupply > 0 And  mb.DaysOfSupplyDiff > 0 order by mb.DaysOfSupplyDiff Desc) as tRanking on r.RegionID = tRanking.RegionID

	End
Else If(@MeasureType = 'MinMax')
	Begin
		Update mb
		Set mb.MinMaxLeft = minmaxTemp.MinMaxLeft,
			mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle,
			mb.MinMaxMiddleDiff = (mb.MinMAxGreen - minmaxTemp.MinMaxMiddle),--- This will negative values for the Green Branches. So we can ignore if the difference is less than 0
			mb.MinMaxRight = minmaxTemp.MinMaxRight,
			mb.MinMaxLeftAbs = minmaxTemp.MinMaxLeftAbs,
			mb.MinMaxMiddleAbs = minmaxTemp.MinMaxMiddleAbs,
			mb.MinMaxRightAbs = minmaxTemp.MinMaxRightAbs
		from @SupplyChainDsdInventoryMeasuresByRegion as mb
		Inner Join (Select RegionID
							,((SUm(minMax.IsBelowMin) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxLeft
							,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
							, ((SUm(minMax.IsAboveMax) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxRight
							,(SUm(IsBelowMin) * 1.0 ) as MinMaxLeftAbs
							,(SUm(IsCompliant) * 1.0 ) as MinMaxMiddleAbs
							,(SUm(IsAboveMax) * 1.0 ) as MinMaxRightAbs
							from SupplyChain.tDsdDailyMinMax as minmax
							Where minmax.DateID = @DateID 
							And minmax.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
							And minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
							And minmax.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)		
							And minmax.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)	
							Group By RegionID) as minmaxTemp on mb.RegionID = minmaxTemp.RegionID
		
			Select r.*, tRanking.MeasureRank as 'MeasureRank'
						from @SupplyChainDsdInventoryMeasuresByRegion as r Left Outer Join
					 ( Select  top 5 *, Rank() Over (ORDER BY MinMaxMiddleDiff) as MeasureRank  
							from @SupplyChainDsdInventoryMeasuresByRegion as mb where mb.MinMaxMiddle <> mb.MinMAxGreen And mb.MinMaxMiddleDiff > 0 order by mb.MinMaxMiddleDiff) as tRanking on r.RegionID = tRanking.RegionID

	End


GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdInventoryMeasuresByRegionAggregated]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Test Bench
exec [SupplyChain].[pGetDsdInventoryMeasuresByRegionAggregated] 20141014,'3,4,5','69,192,138,29,232,221,75,9,158,195,3,12,35,129,49,190,184,67', '46,69,138,175,152,118,78,129,86,64,38,44,150,47,70,30,124'
exec [SupplyChain].[pGetDsdInventoryMeasuresByRegionAggregated] 20141117, '1, 2, 3, 5, 6, 11','1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 146, 147, 148, 149, 150, 151, 152, 153, 163, 170, 172, 174'
																		, '1, 3, 7, 22, 29, 33, 35, 49, 65, 69, 75, 232, 101, 138, 145, 158, 170, 190, 194, 195, 196, 217, 221, 223, 231, 131, 160, 141, 12, 174, 68, 99, 184, 9, 67, 147, 162, 113, 44, 219, 154'
																		,'22, 27, 30, 32, 33, 38, 39, 44, 46, 47, 51, 59, 62, 63, 64, 67, 68, 73, 77, 78, 79, 85, 86, 88, 91, 94, 105, 108, 117, 124, 129, 133, 134, 138, 139, 140, 143, 145, 146, 150, 151, 152, 153, 154, 158, 159, 160, 162, 165'					

	
	

*/

CREATE PROC [SupplyChain].[pGetDsdInventoryMeasuresByRegionAggregated] (  
 @DateID INT =0  
 ,@RegionIDs VARCHAR(4000) =''  
 ,@BranchIDs varchar(4000)=''
 ,@TrademarkIDs VARCHAR(4000) = ''  
 ,@PackageTypeIDs varchar(4000)  
 ,@AggregationID INT = 0  
 )  
AS  
SET NOCOUNT ON;  

Declare @SupplyChainDsdInventoryMeasuresByRegionAggregated Table  
			 (  
				 IncomingOrderCases int  null
				  ,IncomingOrderCasesDayAfterTomorrow int  null
				,IncomingOrderUpdated Datetime2
				,CaseCut int null
				,OOS Decimal(10,1) null
				,DaysOfSupply Decimal(10,1) null
				,MinMaxLeft Decimal(10,1) null
				,MinMaxMiddle Decimal(10,1) null
				,MinMaxRight Decimal(10,1) null
				,OOSRed Decimal(10,1) null
				,OOSGreen Decimal(10,1) null
				,DOSRed Decimal(10,1) null
				,DOSGreen Decimal(10,1) null
				,MinMaxRed Decimal(10,1) null
				,MinMAxGreen Decimal(10,1) null
			 )

Declare @SelectedRegionIDs Table
		(
			RegionID int
		)
Declare @SelectedBranchIDs Table
(
	BranchID int
)
Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)

Declare @SelectedPackageTypeIDs Table
		(
			PackageTypeID int
		)


Declare @TomorrowDate int
Declare @DayAfterTomorrowDate int
Set @TomorrowDate = SupplyChain.udfConvertToDateID(GETDATE())
Set @DayAfterTomorrowDate = SupplyChain.udfConvertToDateID(DATEADD(d,1, GETDATE())) 


Insert into @SelectedRegionIDs
Select Value from dbo.Split(@RegionIDs,',')

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')

Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')


Insert into @SelectedPackageTypeIDs
Select Value from dbo.Split(@PackageTypeIDs,',')

	----If we are showing only one branch, then need to return the threshold data for that one branch. If it's more than one branch and under one region we need to return the region threshold. If branches are falling under multiple region then need to return the OverAllThreshold
		If (Select Count(*) from @SelectedRegionIDs) = 1  
			Begin
				Insert into @SupplyChainDsdInventoryMeasuresByRegionAggregated (OOSRed, OOSGreen, DOSRed, DOSGreen, MinMaxRed, MinMaxGreen) 
					Select rt.RegionOOSLeftThreshold, rt.RegionOOSRightThreshold, rt.RegionDOSLeftThreshold, rt.RegionDOSRightThreshold, rt.RegionMinMaxLeftThreshold, rt.RegionMinMaxRightThreshold
					from SAP.Region as r 
					Inner Join SupplyChain.vRegionThreshold as rt on r.RegionID = rt.RegionID
					Where rt.RegionID in (Select RegionID from @SelectedRegionIDs)

			End
		Else
			Begin 
				Insert into @SupplyChainDsdInventoryMeasuresByRegionAggregated (OOSRed, OOSGreen, DOSRed, DOSGreen, MinMaxRed, MinMaxGreen) 
					Select OAT.OverAllOOSLeftThreshold, OAT.OverAllOOSRightThreshold, OAT.OverAllDOSLeftThreshold, OAT.OverAllDOSRightThreshold, OAT.OverAllMinMaxLeftThreshold, OAT.OverAllMinMaxRightThreshold
						from SupplyChain.OverAllThreshold as OAT

			End
	
		Update mb
		Set mb.OOS = OOSTemp.OOS,
		mb.CaseCut = OOSTemp.CaseCut,
		mb.IncomingOrderUpdated = (Select Top 1 MergeDate From ETL.BCDataLoadingLog Where SchemaName = 'Apacheta'And TableName = 'OriginalOrder'),
		mb.IncomingOrderCases = Isnull((Select Sum(dcc.Quantity) from SupplyChain.tDsdDailyCaseCut as dcc  inner Join  MView.LocationHier as lh on dcc.BranchID = lh.BranchID
										Where lh.RegionID in (Select RegionID from @SelectedRegionIDs) 
											  And lh.BranchID in (Select BranchID from @SelectedBranchIDs)
											  And dcc.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
											  And dcc.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		
											  And DateID = @TomorrowDate),0),
		mb.IncomingOrderCasesDayAfterTomorrow = Isnull((Select Sum(DOR.Quantity) from SupplyChain.tDSDOpenOrder as DOR  inner Join  MView.LocationHier as lh on dor.BranchID = lh.BranchID
										Where lh.RegionID in (Select RegionID from @SelectedRegionIDs) 
											   And lh.BranchID in (Select BranchID from @SelectedBranchIDs)
											  And DOR.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
											  And DOR.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)	
											  And DateID = @DayAfterTomorrowDate),0)
		from @SupplyChainDsdInventoryMeasuresByRegionAggregated as mb
		 Cross Join (Select ((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0))* 100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
						SupplyChain.tDsdDailyCaseCut as OOS
						Where  OOS.DateID = @DateID
						And OOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
						And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
						And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
						And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		
						) as OOSTemp 

		Update mb
		Set mb.DaysOfSupply = DOSTemp.DaysOfSupply
		from @SupplyChainDsdInventoryMeasuresByRegionAggregated as mb
		Cross Join (Select Case When sum(dos.Past31DaysXferOutPlusShipment) = 0 Then 0 Else ((SUM(dos.EndingInventory)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 30 End as DaysOfSupply
					 from SupplyChain.tDsdDailyBranchInventory as DOS 
					 Where  DOS.DateID = @DateID 
						And DOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
						And DOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
						And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
						And DOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		 
						) as DOSTemp 

		Update mb
		Set mb.MinMaxLeft = minmaxTemp.MinMaxLeft,
			mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle,
			mb.MinMaxRight = minmaxTemp.MinMaxRight
		from @SupplyChainDsdInventoryMeasuresByRegionAggregated as mb
		Cross Join (Select  ((SUm(minMax.IsBelowMin) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxLeft
							,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
							, ((SUm(minMax.IsAboveMax) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxRight
							from SupplyChain.tDsdDailyMinMax as minmax
							 Where  minmax.DateID = @DateID 
									And minmax.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
									And minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
									And minmax.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
									And minmax.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)	
					) as minmaxTemp 
  Select * from @SupplyChainDsdInventoryMeasuresByRegionAggregated
--SELECT 2338 IncomingOrderCases  
-- ,getutcdate() IncomingOrderUpdated  
-- ,4 CaseCut  
-- ,2.5 OOS  
-- ,6.1 DaysOfSupply  
-- ,2.5 MinMaxleft  
-- ,89.1 MinMaxMiddle  
-- ,12.2 MinMaxRight  
-- ,-- Actuals  
-- 1.1 OOSRed  
-- ,1.2 OOSGreen  
-- ,2.3 DOSRed  
-- ,2.6 DOSGreen  
-- ,2.6 MinMaxRed  
-- ,2.9 MinMaxGreen --- Borders Threshholds  




GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdInventoryRegionMeasuresForLanding]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Test Bench
exec [SupplyChain].[pGetDsdInventoryRegionMeasuresForLanding] 20141014,'3,4,5', '42,43,44,45,46,47,48,49,50,51,52', '69,192,138,29,232,221,75,9,158,195,3,12,35,129,49,190,184,67', '46,69,138,175,152,118,78,129,86,64,38,44,150,47,70,30,124', 'OOS'

exec [SupplyChain].[pGetDsdInventoryRegionMeasuresForLanding] 20141111,'1,2,3,4,5,6,7,8,9,11,14,12','1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,167,168,169,170,172,173,174',
'1,3,5,20,22,33,59,35,37,60,44,61,46,49,50,51,65,67,68,34,64,89,173,54,97,129,130,154,187,216,228',
'22,27,30,33,38,39,44,46,47,51,59,62,63,64,67,68,77,78,79,86,90,94,108,117,124,129,133,134,138,139,140,143,145,146,150,151,152,154','OOS'

*/
CREATE Proc [SupplyChain].[pGetDsdInventoryRegionMeasuresForLanding]
(
	@DateID int,
	@RegionIDs varchar(4000),
	@BranchIDs Varchar(4000),
	@TrademarkIDs varchar(4000),
	@PackageTypeIDs varchar(4000),
	@MeasureType varchar(10),
	@AggregationID int = 0
	
)
AS	
	Set NoCount On;

	Declare @SupplyChainDsdInventoryMeasuresByRegion Table  
			 (  
			  RegionID int not null
			  ,RegionName varchar(50) not null
			  ,Longitude varchar(50) null
			  ,Latitude varchar(50) null
			  ,CaseCut int  null
			  ,OOS Decimal(10,1) null
			  ,DaysOfSupply Decimal(10,1) null
			  ,MinMaxMiddle Decimal(10,1) null
			  ,IsSelectedRegion bit
			  ,OOSRed Decimal(10,1) null
			  ,OOSGreen Decimal(10,1) null
			  ,DOSRed Decimal(10,1) null
			  ,DOSGreen Decimal(10,1) null
			  ,MinMaxRed Decimal(10,1) null
			  ,MinMaxGreen Decimal(10,1) null
			  ,KPILevel varchar(10) null
			  ,BUSortOrder int	
			 )

Declare @SelectedRegionIDs Table
		(
			RegionID int
		)
Declare @SelectedBranchIDs Table
		(
			BranchID int
		)
Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)

Declare @SelectedPackageTypeIDs Table
		(
			PackageTypeID int
		)
Insert into @SelectedRegionIDs
Select Value from dbo.Split(@RegionIDs,',')

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')

Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')

Insert into @SelectedPackageTypeIDs
Select Value from dbo.Split(@PackageTypeIDs,',')

	Insert into @SupplyChainDsdInventoryMeasuresByRegion (RegionID,RegionName, Longitude, Latitude, IsSelectedRegion, OOSRed, OOSGreen, DOSRed, DOSGreen, MinMaxRed, MinMaxGreen,BUSortOrder) 
			Select r.RegionID, r.ShortName as RegionName, r.Longitude, r.Latitude
					,Case When sr.RegionID is not null then 1 Else 0 End
					, rt.RegionOOSLeftThreshold, rt.RegionOOSRightThreshold, rt.RegionDOSLeftThreshold, rt.RegionDOSRightThreshold, rt.RegionMinMaxLeftThreshold, rt.RegionMinMaxRightThreshold
					, bu.SortOrder
			from SAP.Region as r 
			Left Outer Join @SelectedRegionIDs as sr on r.RegionID = sr.RegionID
			Inner Join SupplyChain.vRegionThreshold as rt on rt.RegionID = r.RegionID 
			Inner Join SAP.BusinessUnit as bu on r.BUID = bu.BUID 
			

	If(@MeasureType = 'OOS')
		Begin 
			Update mb
			Set mb.OOS = OOSTemp.OOS,
			mb.CaseCut = OOSTemp.CaseCut,
			mb.KPILevel = Case 
							When OOSTemp.OOS > mb.OOSRed Then 'Red' 
							When (OOSTemp.OOS >= mb.OOSGreen And OOSTemp.OOS <= mb.OOSRed) Then 'Amber' 
							When OOSTemp.OOS < mb.OOSGreen Then 'Green' End
			from @SupplyChainDsdInventoryMeasuresByRegion as mb
			 Inner Join (Select RegionID,((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0))*100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
							SupplyChain.tDsdDailyCaseCut as OOS
							Where  OOS.DateID = @DateID 
							And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)
							And OOS.RegionID Not in (Select sr.RegionID from @SelectedRegionIDs as sr)		
							Group By RegionID) as OOSTemp on mb.RegionID= OOSTemp.RegionID
			Update mb
			Set mb.OOS = OOSTemp.OOS,
			mb.CaseCut = OOSTemp.CaseCut,
			mb.KPILevel = Case 
							When OOSTemp.OOS > mb.OOSRed Then 'Red' 
							When (OOSTemp.OOS >= mb.OOSGreen And OOSTemp.OOS <= mb.OOSRed) Then 'Amber' 
							When OOSTemp.OOS < mb.OOSGreen Then 'Green' End
			from @SupplyChainDsdInventoryMeasuresByRegion as mb
			 Inner Join (Select RegionID,((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0))*100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
							SupplyChain.tDsdDailyCaseCut as OOS
							Where  OOS.DateID = @DateID 
							And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)	
							And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)
							And OOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)		
							Group By RegionID) as OOSTemp on mb.RegionID= OOSTemp.RegionID
		End
    Else if(@MeasureType = 'DOS')
		Begin
			Update mb
			Set mb.DaysOfSupply = DOSTemp.DaysOfSupply,
			mb.KPILevel = Case 
								When DOSTemp.DaysOfSupply > mb.DOSRed Then 'Red' 
								When (DOSTemp.DaysOfSupply >= mb.DOSGreen And DOSTemp.DaysOfSupply <= mb.DOSRed) Then 'Amber' 
								When DOSTemp.DaysOfSupply < mb.DOSGreen Then 'Green' End
			from @SupplyChainDsdInventoryMeasuresByRegion as mb
			Inner Join (Select RegionID, Case When sum(dos.Past31DaysXferOutPlusShipment) = 0 Then 0 Else ((SUM(dos.EndingInventory)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 30 End as DaysOfSupply
						 from SupplyChain.tDsdDailyBranchInventory as DOS 
						Where  DOS.DateID = @DateID 
							And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And DOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)
							And DOS.RegionID Not in (Select sr.RegionID from @SelectedRegionIDs as sr)		
							Group By RegionID) as DOSTemp on mb.RegionID= DOSTemp.RegionID
			Update mb
			Set mb.DaysOfSupply = DOSTemp.DaysOfSupply,
			mb.KPILevel = Case 
								When DOSTemp.DaysOfSupply > mb.DOSRed Then 'Red' 
								When (DOSTemp.DaysOfSupply >= mb.DOSGreen And DOSTemp.DaysOfSupply <= mb.DOSRed) Then 'Amber' 
								When DOSTemp.DaysOfSupply < mb.DOSGreen Then 'Green' End
			from @SupplyChainDsdInventoryMeasuresByRegion as mb
			Inner Join (Select RegionID, Case When sum(dos.Past31DaysXferOutPlusShipment) = 0 Then 0 Else ((SUM(dos.EndingInventory)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 30 End as DaysOfSupply
						 from SupplyChain.tDsdDailyBranchInventory as DOS 
						Where  DOS.DateID = @DateID 
							And DOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)	
							And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And DOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)
							And DOS.RegionID  in (Select sr.RegionID from @SelectedRegionIDs as sr)		
							Group By RegionID) as DOSTemp on mb.RegionID= DOSTemp.RegionID
		End
	Else if(@MeasureType = 'MinMax')
		Begin
			Update mb
			Set mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle,
				mb.KPILevel = Case 
							When minmaxTemp.MinMaxMiddle < mb.MinMaxRed Then 'Red' 
							When (minmaxTemp.MinMaxMiddle >= mb.MinMaxRed And minmaxTemp.MinMaxMiddle <= mb.MinMaxGreen) Then 'Amber' 
							When minmaxTemp.MinMaxMiddle > mb.MinMaxGreen Then 'Green' End
			from @SupplyChainDsdInventoryMeasuresByRegion as mb
			Inner Join (Select RegionID								
								,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
							from SupplyChain.tDsdDailyMinMax as minmax
							Where  minmax.DateID = @DateID 
							And minmax.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And minmax.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)
							And minmax.RegionID Not in (Select sr.RegionID from @SelectedRegionIDs as sr)		
							Group By RegionID) as MinMaxTemp on mb.RegionID= MinMaxTemp.RegionID
			Update mb
			Set mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle,
				mb.KPILevel = Case 
							When minmaxTemp.MinMaxMiddle < mb.MinMaxRed Then 'Red' 
							When (minmaxTemp.MinMaxMiddle >= mb.MinMaxRed And minmaxTemp.MinMaxMiddle <= mb.MinMaxGreen) Then 'Amber' 
							When minmaxTemp.MinMaxMiddle > mb.MinMaxGreen Then 'Green' End
			from @SupplyChainDsdInventoryMeasuresByRegion as mb
			Inner Join (Select RegionID								
								,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
							from SupplyChain.tDsdDailyMinMax as minmax
							Where  minmax.DateID = @DateID
							And minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)	
							And minmax.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And minmax.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)
							And minmax.RegionID  in (Select sr.RegionID from @SelectedRegionIDs as sr)		
							Group By RegionID) as MinMaxTemp on mb.RegionID= MinMaxTemp.RegionID
		End

		Select * from @SupplyChainDsdInventoryMeasuresByRegion order by BUSortOrder, RegionName



GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdMostImpactedPackagesForLanding]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

exec [SupplyChain].[pGetDsdMostImpactedPackagesForLanding] 20141104,'3,4,5','69,192,138,29,232,221,75,158,195,3,12,35,129,49,190,184,64,101', '46,69,138,152,118,78,129,86,64,44,150,47,70,30,124,133,61,36','MinMax'
20141014,'24,25,26,27','69', '325'
select top 10 * from sap.Package
SupplyChain.pGetDsdMostImpactedPackagesForLanding
exec [SupplyChain].[pGetDsdMostImpactedPackagesForLanding] 20141110,'1,5,12','5,11,84,85,160,161','47,97,194','22,32,44,46,47,67,68,78,79,124,129,138,140,150,151,152','DOS'
*/
CREATE PROC [SupplyChain].[pGetDsdMostImpactedPackagesForLanding] (
	@DateID INT
	,@RegionIDs VARCHAR(4000)
	,@BranchIDs varchar(4000)
	,@TrademarkIDs VARCHAR(4000)
	,@packageIDs VARCHAR(4000)
	,@MeasureType varchar(10)
	,@AggregationID INT = 0
	)
AS
SET NOCOUNT ON;

Declare @SupplyChainDsdMostImpactedPackagesByRegion Table  
			 (  
				 PackageID int  null
				,SAPPackageID varchar(10) null
				--,PackageName Varchar(50) null
				--,PackageTypeID int null
				,TradeMarkID int null
				--,TradeMarkName varchar(50) null
				--	,TradeMarkURL varchar(512) null
				,RegionID int null
				--,RegionName varchar(50) null
				,CaseCut int null
				,OOS Decimal(10,1) null
				,DOS Decimal(10,1) null
				,DOSEndingInventory Decimal(10,1) null
				,MinMaxMiddle Decimal(10,1) null
				,MinMaxLeftAbs int null
			    ,MinMaxMiddleAbs int null
			    ,MinMaxRightAbs int null
				
			 )

Declare @SelectedRegionIDs Table
		(
			RegionID int
		)
Declare @SelectedBranchIDs Table
		(
			BranchID int
		)
Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)

Declare @SelectedPackageIDs Table
		(
			PackageID int
		)

Insert into @SelectedRegionIDs
Select Value from dbo.Split(@RegionIDs,',')

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')

Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')


Insert into @SelectedPackageIDs
Select Value from dbo.Split(@PackageIDs,',')

--Insert into @SupplyChainDsdMostImpactedPackagesByRegion (PackageID, PackageName, SAPPackageID,PackageTypeID)
--	Select PackageID, Substring(PackageName,1,14) as PackageName, '', PackageTypeID  from SAP.Package Where PackageID in (Select PackageID from @SelectedPackageIDs)

	If(@MeasureType = 'OOS')
		Begin
		Insert into @SupplyChainDsdMostImpactedPackagesByRegion (PackageID, TradeMarkID, RegionID, OOS, CaseCut)
			Select PackageID, TradeMarkID, RegionID, ((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0)) * 100  as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
							SupplyChain.tDsdDailyCaseCut as OOS
							Where  OOS.DateID = @DateID 
							And OOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
							And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
							And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And OOS.PackageID in (Select sp.PackageID from @SelectedPackageIDs as sp)		
							Group by OOS.PackageID, OOS.TradeMarkID, OOS.RegionID
			 Select top 5 *
			 			, (Select RegionName from SAP.Region as r Where r.RegionID = mb.RegionID) as RegionName
						, (Select TradeMarkName from SAP.TradeMark as t Where t.TradeMarkID = mb.TradeMarkID) as TradeMarkName
						, (Select ImageURL from Shared.[Image]  as I Where I.ImageID  in (Select t.ImageID from SAP.TradeMark as t where t.TradeMarkID = mb.TradeMarkID)) as TradeMarkURL
						, (Select PackageName from SAP.Package as p Where p.PackageID = mb.PackageID) as PackageName
						, (Select PackageTypeID from SAP.Package as p Where p.PackageID = mb.PackageID) as PackageTypeID
						,stuff((SELECT ','+ Cast(BranchID as varchar(10)) FROM Mview.LocationHier as lh WHERE lh.RegionID = mb.RegionID And lh.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb) FOR XML PATH('')),1,1,'') as 'BranchesInRegion'
			 from @SupplyChainDsdMostImpactedPackagesByRegion as mb 
			 Where mb.OOS is not null
			 order by mb.CaseCut desc
		End
	Else If(@MeasureType = 'DOS')
		Begin
		Insert into @SupplyChainDsdMostImpactedPackagesByRegion (PackageID, TradeMarkID, RegionID, DOS, DOSEndingInventory)
			Select  PackageID, TradeMarkID, RegionID
									,Case When sum(dos.Past31DaysXferOutPlusShipment) = 0 Then 0 Else ((SUM(dos.EndingInventory)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 30 End as DaysOfSupply
									,((SUM(dos.EndingInventory)*1.0)/1000) as DOSEndingInventory
							 from SupplyChain.tDsdDailyBranchInventory as DOS 
							 Where  DOS.DateID = @DateID 
									And DOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
									And DOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
									And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
									And DOS.PackageID in (Select sp.PackageID from @SelectedPackageIDs as sp)		 
									Group by DOS.PackageID, DOS.TradeMarkID, DOS.RegionID
							
			 Select top 5 *
						, (Select RegionName from SAP.Region as r Where r.RegionID = mb.RegionID) as RegionName
						, (Select TradeMarkName from SAP.TradeMark as t Where t.TradeMarkID = mb.TradeMarkID) as TradeMarkName
						, (Select ImageURL from Shared.[Image]  as I Where I.ImageID  in (Select t.ImageID from SAP.TradeMark as t where t.TradeMarkID = mb.TradeMarkID)) as TradeMarkURL
						, (Select PackageName from SAP.Package as p Where p.PackageID = mb.PackageID) as PackageName
						, (Select PackageTypeID from SAP.Package as p Where p.PackageID = mb.PackageID) as PackageTypeID
						,stuff((SELECT ','+ Cast(BranchID as varchar(10)) FROM Mview.LocationHier as lh WHERE lh.RegionID = mb.RegionID And lh.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb) FOR XML PATH('')),1,1,'') as 'BranchesInRegion'
			 from @SupplyChainDsdMostImpactedPackagesByRegion as mb 
			 Where mb.DOS is not null
			 order by mb.DOS desc
		End
		
	Else If(@MeasureType = 'MinMax')
		Begin
			Insert into @SupplyChainDsdMostImpactedPackagesByRegion (PackageID, TradeMarkID, RegionID, MinMaxMiddle, MinMaxLeftAbs, MinMaxMiddleAbs, MinMaxRightAbs)
				Select  PackageID, TradeMarkID, RegionID
								,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
								,SUM(IsBelowMin) as MinMaxLeftAbs
								,SUM(IsCompliant) as MinMaxMiddleAbs
								,SUM(IsAboveMax) as MinMaxRightAbs
								from SupplyChain.tDsdDailyMinMax as minmax
								 Where  minmax.DateID = @DateID 
										And minmax.RegionID in (Select RegionID from @SelectedRegionIDs)
										And minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
										And minmax.TradeMarkID in (Select TradeMarkID from @SelectedTradeMarkIDs)	
										And minmax.PackageID in (Select PackageID from @SelectedPackageIDs)	
										Group by minmax.PackageID, minmax.TradeMarkID, minmax.RegionID
						
			 Select top 5 *
						, (Select RegionName from SAP.Region as r Where r.RegionID = mb.RegionID) as RegionName
						, (Select TradeMarkName from SAP.TradeMark as t Where t.TradeMarkID = mb.TradeMarkID) as TradeMarkName
						, (Select ImageURL from Shared.[Image]  as I Where I.ImageID  in (Select t.ImageID from SAP.TradeMark as t where t.TradeMarkID = mb.TradeMarkID)) as TradeMarkURL
						, (Select PackageName from SAP.Package as p Where p.PackageID = mb.PackageID) as PackageName
						, (Select PackageTypeID from SAP.Package as p Where p.PackageID = mb.PackageID) as PackageTypeID
						,stuff((SELECT ','+ Cast(BranchID as varchar(10)) FROM Mview.LocationHier as lh WHERE lh.RegionID = mb.RegionID And lh.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb) FOR XML PATH('')),1,1,'') as 'BranchesInRegion'
			 from @SupplyChainDsdMostImpactedPackagesByRegion as mb
			 Where mb.MinMaxMiddle is not null
			 order by mb.MinMaxMiddle asc
		End



GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdMostImpactedPackageTypesByBranch]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
exec [SupplyChain].[pGetDsdMostImpactedPackageTypesByBranch] 20141014,'8,11,12,13,14,15,18,19,21,25,29,33,35,36,37,42,44,47,48,50,52,53,54,58','69,192,138,29,232,221,75,158,195,3,12,35,129,49,190,184,64,101', '46,69,138,152,118,78,129,86,64,44,150,47,70,30,124,133,61,36','MinMax'
select top 10 * from sap.Package

*/
CREATE PROC [SupplyChain].[pGetDsdMostImpactedPackageTypesByBranch] (
	@DateID INT
	,@BranchIDs VARCHAR(4000)
	,@TrademarkIDs VARCHAR(4000)
	,@packageTypeIDs VARCHAR(4000)
	,@MeasureType Varchar(20)
	,@AggregationID INT = 0
	)
AS
SET NOCOUNT ON;

Declare @SupplyChainDsdMostImpactedPackagesByBranch Table  
			 (  
				 PackageTypeID int  null
				,SAPPackageTypeID varchar(10) null
				,PackageTypeName Varchar(50) null
				,CaseCut int null
				,OOS Decimal(10,1) null
				,DOS Decimal(10,1) null
				,MinMaxMiddle Decimal(10,1) null
			 )

Declare @SelectedBranchIDs Table
		(
			BranchID int
		)

Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)

Declare @SelectedPackageTypeIDs Table
		(
			PackageTypeID int
		)

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')

Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')


Insert into @SelectedPackageTypeIDs
Select Value from dbo.Split(@PackageTypeIDs,',')

Insert into @SupplyChainDsdMostImpactedPackagesByBranch (PackageTypeID, PackageTypeName, SAPPackageTypeID)
	Select PackageTypeID, PackageTypeName, SAPPackageTypeID from SAP.PackageType Where PackageTypeID in (Select PackageTypeID from @SelectedPackageTypeIDs)

If(@MeasureType = 'OOS')
	Begin
		Update mb
		Set mb.OOS = OOSTemp.OOS,
		mb.CaseCut = OOSTemp.CaseCut
			from @SupplyChainDsdMostImpactedPackagesByBranch as mb
		 Inner Join (Select PackageTypeID, ((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0))*100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
						SupplyChain.tDsdDailyCaseCut as OOS
						Where  OOS.DateID = @DateID 
						And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
						And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
						And OOS.PackageTYpeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		
						Group by OOS.PackageTypeID) as OOSTemp on mb.PackageTypeID = OOSTemp.PackageTypeID
			Select * 
			from @SupplyChainDsdMostImpactedPackagesByBranch as mb
				Where mb.OOS is not null	
				Order by mb.OOS Desc
	End
Else If(@MeasureType = 'DOS')
	Begin
		Update mb
			Set mb.DOS = DOSTemp.DaysOfSupply
			from @SupplyChainDsdMostImpactedPackagesByBranch as mb
			Inner Join (Select PackageTypeID,Case When sum(dos.Past31DaysXferOutPlusShipment) = 0 Then 0 Else ((SUM(dos.EndingInventory)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 30 End as DaysOfSupply
						 from SupplyChain.tDsdDailyBranchInventory as DOS 
						 Where  DOS.DateID = @DateID 
							And DOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
							And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And DOS.PackageTYpeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		 
							Group by DOS.PackageTypeID) as DOSTemp   on mb.PackageTypeID = DOSTemp.PackageTypeID
		Select * 
			from @SupplyChainDsdMostImpactedPackagesByBranch as mb
				Where mb.DOS is not null	
				Order by mb.DOS Desc
	End
Else If(@MeasureType = 'MinMax')
	Begin
		Update mb
			Set mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle
			from @SupplyChainDsdMostImpactedPackagesByBranch as mb
			Inner Join (Select PackageTypeID 
								,((SUm(minMax.IsBelowMin) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxLeft
								,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
								, ((SUm(minMax.IsAboveMax) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxRight
								from SupplyChain.tDsdDailyMinMax as minmax
								 Where  minmax.DateID = @DateID 
										And  minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
										And minmax.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
										And minmax.PackageTYpeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		
										Group by minmax.PackageTypeID
						) as minmaxTemp   on mb.PackageTypeID = minmaxTemp.PackageTypeID
		Select * 
			from @SupplyChainDsdMostImpactedPackagesByBranch as mb
				Where mb.MinMaxMiddle is not null	
				Order by mb.MinMaxMiddle

	End


GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdMostImpactedPackageTypesByRegion]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

exec [SupplyChain].[pGetDsdMostImpactedPackageTypesByRegion] 20141014,'3,4,5','69,192,138,29,232,221,75,9,158,195,3,12,35,129,49,190,184,67', '46,69,138,175,152,118,78,129,86,64,38,44,150,47,70,30,124','MinMax'
20141014,'24,25,26,27','69', '325'
select top 10 * from sap.Package

*/
CREATE PROC [SupplyChain].[pGetDsdMostImpactedPackageTypesByRegion] (
	@DateID INT
	,@RegionIDs VARCHAR(4000)
	,@BranchIDs VARCHAR(4000)
	,@TrademarkIDs VARCHAR(4000)
	,@packageTypeIDs VARCHAR(4000)
	,@MeasureType varchar(20)
	,@AggregationID INT = 0
	)
AS
SET NOCOUNT ON;

Declare @SupplyChainDsdMostImpactedPackagesByRegion Table  
			 (  
				 PackageTypeID int  null
				,SAPPackageTypeID varchar(10) null
				,PackageTypeName Varchar(50) null
				,CaseCut int null
				,OOS Decimal(10,1) null
				,DOS Decimal(10,1) null
				,MinMaxMiddle Decimal(10,1) null
			 )

Declare @SelectedRegionIDs Table
		(
			RegionID int
		)
Declare @SelectedBranchIDs Table
(
	BranchID int
)
Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)

Declare @SelectedPackageTypeIDs Table
		(
			PackageTypeID int
		)

Insert into @SelectedRegionIDs
Select Value from dbo.Split(@RegionIDs,',')

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')


Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')


Insert into @SelectedPackageTypeIDs
Select Value from dbo.Split(@PackageTypeIDs,',')

Insert into @SupplyChainDsdMostImpactedPackagesByRegion (PackageTypeID, PackageTypeName, SAPPackageTypeID)
	Select PackageTypeID, PackageTypeName, SAPPackageTypeID  from SAP.PackageType Where PackageTypeID in (Select PackageTypeID from @SelectedPackageTypeIDs)
If(@MeasureType = 'OOS')
	Begin
		Update mb
				Set mb.OOS = OOSTemp.OOS,
				mb.CaseCut = OOSTemp.CaseCut
					from @SupplyChainDsdMostImpactedPackagesByRegion as mb
				 Inner Join (Select PackageTypeID, ((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0))*100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
								SupplyChain.tDsdDailyCaseCut as OOS
								Where  OOS.DateID = @DateID 
								And OOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
								And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
								And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
								And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		
								Group by OOS.PackageTypeID
							) as OOSTemp on mb.PackageTypeID = OOSTemp.PackageTypeID
			Select * 
			from @SupplyChainDsdMostImpactedPackagesByRegion as mb
				Where mb.OOS is not null	
				Order by mb.OOS Desc
	End
Else If(@MeasureType = 'DOS')
	Begin
		Update mb
				Set mb.DOS = DOSTemp.DaysOfSupply
				from @SupplyChainDsdMostImpactedPackagesByRegion as mb
				Inner Join (Select PackageTypeID,Case When sum(dos.Past31DaysXferOutPlusShipment) = 0 Then 0 Else ((SUM(dos.EndingInventory)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 30 End as DaysOfSupply
							 from SupplyChain.tDsdDailyBranchInventory as DOS 
							 Where  DOS.DateID = @DateID 
									And DOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
									And DOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
									And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
									And DOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		 
									Group by DOS.PackageTypeID
							) as DOSTemp   on mb.PackageTypeID = DOSTemp.PackageTypeID
		Select * 
			from @SupplyChainDsdMostImpactedPackagesByRegion as mb
				Where mb.DOS is not null	
				Order by mb.DOS Desc
	End
Else If(@MeasureType = 'MinMax')
	Begin
		Update mb
		Set mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle
		from @SupplyChainDsdMostImpactedPackagesByRegion as mb
		Inner Join (Select PackageTypeID
							,((SUm(minMax.IsBelowMin) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxLeft
							,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
							, ((SUm(minMax.IsAboveMax) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxRight
							from SupplyChain.tDsdDailyMinMax as minmax
							 Where  minmax.DateID = @DateID 
									And minmax.RegionID in (Select RegionID from @SelectedRegionIDs)
									And minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
									And minmax.TradeMarkID in (Select TradeMarkID from @SelectedTradeMarkIDs)	
									And minmax.PackageTypeID in (Select PackageTypeID from @SelectedPackageTypeIDs)	
									Group by minmax.PackageTypeID
					) as minmaxTemp   on mb.PackageTypeID = minmaxTemp.PackageTypeID
			Select * 
			from @SupplyChainDsdMostImpactedPackagesByRegion as mb
				Where mb.MinMaxMiddle is not null	
				Order by mb.MinMaxMiddle

	End


GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdMostImpactedTrademarksByBranch]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

exec [SupplyChain].[pGetDsdMostImpactedTrademarksByBranch] 20141014,'8,11,12,13,14,15,18,19,21,25,29,33,35,36,37,42,44,47,48,50,52,53,54,58','69,192,138,29,232,221,75,158,195,3,12,35,129,49,190,184,64,101', '46,69,138,152,118,78,129,86,64,44,150,47,70,30,124,133,61,36','MinMax'
20141014,'24,25,26,27','69', '325'
select top 10 * from sap.Package

*/
CREATE PROC [SupplyChain].[pGetDsdMostImpactedTrademarksByBranch] (
	@DateID INT
	,@BranchIDs VARCHAR(4000)
	,@TrademarkIDs VARCHAR(4000)
	,@packageTypeIDs VARCHAR(4000)
	,@MeasureType Varchar(20)
	,@AggregationID INT = 0
	)
AS
SET NOCOUNT ON;

Declare @SupplyChainDsdMostImpactedTrademarksByBranch Table  
			 (  
				 TradeMarkID int  null
				,SAPTradeMarkID varchar(10) null
				,TradeMarkName Varchar(50) null
				,CaseCut int null
				,OOS Decimal(10,1) null
				,DOS Decimal(10,1) null
				,MinMaxMiddle Decimal(10,1) null
			 )

Declare @SelectedBranchIDs Table
		(
			BranchID int
		)

Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)

Declare @SelectedPackageTypeIDs Table
		(
			PackageTypeID int
		)

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')

Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')


Insert into @SelectedPackageTypeIDs
Select Value from dbo.Split(@PackageTypeIDs,',')

Insert into @SupplyChainDsdMostImpactedTrademarksByBranch (TradeMarkID, TradeMarkName, SAPTradeMarkID)
	Select TradeMarkID, TradeMarkName, SAPTradeMarkID  from SAP.TradeMark Where TradeMarkID in (Select TradeMarkID from @SelectedTradeMarkIDs)

If(@MeasureType = 'OOS')
	Begin
		Update mb
				Set mb.OOS = OOSTemp.OOS,
				mb.CaseCut = OOSTemp.CaseCut
					from @SupplyChainDsdMostImpactedTrademarksByBranch as mb
				 Inner Join (Select TradeMarkID, ((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0))*100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
								SupplyChain.tDsdDailyCaseCut as OOS
								Where  OOS.DateID = @DateID 
								And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
								And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
								And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		
								Group by OOS.TradeMarkID) as OOSTemp on mb.TradeMarkID = OOSTemp.TradeMarkID
		Select * 
			from @SupplyChainDsdMostImpactedTrademarksByBranch as mb
				Where mb.OOS is not null	
				Order by mb.OOS Desc
	End
Else If(@MeasureType = 'DOS')
	Begin
		Update mb
			Set mb.DOS = DOSTemp.DaysOfSupply
			from @SupplyChainDsdMostImpactedTrademarksByBranch as mb
			Inner Join (Select TradeMarkID,Case When sum(dos.Past31DaysXferOutPlusShipment) = 0 Then 0 Else ((SUM(dos.EndingInventory)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 30 End as DaysOfSupply
					 from SupplyChain.tDsdDailyBranchInventory as DOS 
					 Where  DOS.DateID = @DateID 
						And  DOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
						And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
						And DOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		 
						Group by DOS.TradeMarkID) as DOSTemp   on mb.TradeMarkID = DOSTemp.TradeMarkID
			Select * 
			from @SupplyChainDsdMostImpactedTrademarksByBranch as mb
				Where mb.DOS is not null	
				Order by mb.DOS Desc
	End
Else If(@MeasureType = 'MinMax')
	Begin
		Update mb
		Set mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle
		from @SupplyChainDsdMostImpactedTrademarksByBranch as mb
		Inner Join (Select TradeMarkID
							,((SUm(minMax.IsBelowMin) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxLeft
							,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
							, ((SUm(minMax.IsAboveMax) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxRight
							from SupplyChain.tDsdDailyMinMax as minmax
							Where  minmax.DateID = @DateID 
							And  minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
							And minmax.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And minmax.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)	
							Group by minmax.TradeMarkID
				  ) as minmaxTemp   on mb.TradeMarkID = minmaxTemp.TradeMarkID
		Select * 
			from @SupplyChainDsdMostImpactedTrademarksByBranch as mb
				Where mb.MinMaxMiddle is not null	
				Order by mb.MinMaxMiddle
	End


GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdMostImpactedTrademarksByRegion]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

exec [SupplyChain].[pGetDsdMostImpactedTrademarksByRegion] 20141014,'3,4,5','69,192,138,29,232,221,75,9,158,195,3,12,35,129,49,190,184,67', '46,69,138,175,152,118,78,129,86,64,38,44,150,47,70,30,124', 'MinMax'
20141014,'24,25,26,27','69', '325'
select top 10 * from sap.Package

*/
CREATE PROC [SupplyChain].[pGetDsdMostImpactedTrademarksByRegion] (
	@DateID INT
	,@RegionIDs VARCHAR(4000)
	,@BranchIDs VARCHAR(4000)
	,@TrademarkIDs VARCHAR(4000)
	,@packageTypeIDs VARCHAR(4000)
	,@MeasureType Varchar(20)
	,@AggregationID INT = 0
	)
AS
SET NOCOUNT ON;

Declare @SupplyChainDsdMostImpactedTrademarksByRegion Table  
			 (  
				 TrademarkID int  null
				,SAPTrademarkID varchar(10) null
				,TrademarkName Varchar(50) null
				,CaseCut int null
				,OOS Decimal(10,1) null
				,DOS Decimal(10,1) null
				,MinMaxMiddle Decimal(10,1) null
			 )

Declare @SelectedRegionIDs Table
		(
			RegionID int
		)

Declare @SelectedBranchIDs Table
		(
			BranchID int
		)
Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)

Declare @SelectedPackageTypeIDs Table
		(
			PackageTypeID int
		)

Insert into @SelectedRegionIDs
Select Value from dbo.Split(@RegionIDs,',')

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')

Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')


Insert into @SelectedPackageTypeIDs
Select Value from dbo.Split(@PackageTypeIDs,',')

Insert into @SupplyChainDsdMostImpactedTrademarksByRegion (TrademarkID, TrademarkName, SAPTrademarkID)
	Select TrademarkID, TrademarkName, SAPTradeMarkID  from SAP.Trademark Where TrademarkID in (Select TrademarkID from @SelectedTrademarkIDs)
If(@MeasureType = 'OOS')
	Begin
		Update mb
				Set mb.OOS = OOSTemp.OOS,
				mb.CaseCut = OOSTemp.CaseCut
					from @SupplyChainDsdMostImpactedTrademarksByRegion as mb
				 Inner Join (Select TrademarkID, ((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0))*100 as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
								SupplyChain.tDsdDailyCaseCut as OOS
								Where  OOS.DateID = @DateID 
								And OOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
								And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
								And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
								And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		
								Group by OOS.TrademarkID) as OOSTemp on mb.TrademarkID = OOSTemp.TrademarkID
		Select * 
			from @SupplyChainDsdMostImpactedTrademarksByRegion as mb
				Where mb.OOS is not null	
				Order by mb.CaseCut Desc
	 End
Else If(@MeasureType = 'DOS')
	Begin
		Update mb
				Set mb.DOS = DOSTemp.DaysOfSupply
				from @SupplyChainDsdMostImpactedTrademarksByRegion as mb
				Inner Join (Select TrademarkID,Case When sum(dos.Past31DaysXferOutPlusShipment) = 0 Then 0 Else ((SUM(dos.EndingInventory)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 30 End as DaysOfSupply
 							 from SupplyChain.tDsdDailyBranchInventory as DOS 
							 Where  DOS.DateID = @DateID 
								And DOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
								And DOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
								And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
								And DOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		 
								Group by DOS.TrademarkID) as DOSTemp   on mb.TrademarkID = DOSTemp.TrademarkID
		Select * 
			from @SupplyChainDsdMostImpactedTrademarksByRegion as mb
				Where mb.DOS is not null	
				Order by mb.DOS Desc
	End
Else If(@MeasureType = 'MinMax')
	Begin
		Update mb
		Set mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle
		from @SupplyChainDsdMostImpactedTrademarksByRegion as mb
		Inner Join (Select TrademarkID
							,((SUm(minMax.IsBelowMin) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxLeft
							,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
							, ((SUm(minMax.IsAboveMax) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxRight
							from SupplyChain.tDsdDailyMinMax as minmax
							 Where  minmax.DateID = @DateID 
							 And minmax.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
							 And minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
							And minmax.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And minmax.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)	
							Group by minmax.TrademarkID
					) as minmaxTemp   on mb.TrademarkID = minmaxTemp.TrademarkID
		Select * 
			from @SupplyChainDsdMostImpactedTrademarksByRegion as mb
				Where mb.MinMaxMiddle is not null	
				Order by mb.MinMaxMiddle
	End


GO
/****** Object:  StoredProcedure [SupplyChain].[pGetDsdOverAllScoresForLanding]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
26.SupplyChain.pGetDsdOverAllScoresForLanding
exec [SupplyChain].[pGetDsdOverAllScoresForLanding] 20141103,'3,4,5', '42,43,44,45,46,47,48,49,50,51,52', '69,192,138,29,232,221,75,9,158,195,3,12,35,129,49,190,184,67', '46,69,138,175,152,118,78,129,86,64,38,44,150,47,70,30,124', 'MinMax'
20141014,'24,25,26,27','69', '325'
exec [SupplyChain].[pGetDsdInventoryBranchMeasuresForLanding] 20141106,'1,2,3,4,5,6,7,8,9,11,12,14','1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,167,168,169,170,172,173,174', '1,3,5,20,22,33,59,35,37,60,44,61,46,49,50,51,65,67,68,34,64,89,173,54,97,129,130,154,187,216,228','22,27,30,33,38,39,44,46,47,51,59,62,63,64,67,68,77,78,79,86,90,94,108,117,124,129,133,134,138,139,140,143,145,146,150,151,152,154','DOS'
select top 10 * from sap.Package
SupplyChain.pGetDsdOverAllScoresForLanding
exec [SupplyChain].[pGetDsdOverAllScoresForLanding] 20141110,'1,5,12','5,11,84,85,160,161','47,97,194','22,32,44,46,47,67,68,78,79,124,129,138,140,150,151,152','OOS'
*/
CREATE PROC [SupplyChain].[pGetDsdOverAllScoresForLanding] (
	@DateID INT
	,@RegionIDs VARCHAR(4000)
	,@BranchIDs varchar(4000)
	,@TrademarkIDs VARCHAR(4000)
	,@PackageIDs VARCHAR(4000)
	,@MeasureType varchar(10)
	,@AggregationID INT = 0
	)
AS
SET NOCOUNT ON;

Declare @SupplyChainDsdOverAllScoresForLanding Table  
			 (  
				 ProductLineID int null
				,ProductLineName varchar(50) null
				,CaseCut int null
				,OOS Decimal(10,1) null
				,DOS Decimal(10,1) null
				,DOSCases int null
				,MinMaxLeft Decimal(10,1) null
				,MinMaxMiddle Decimal(10,1) null
				,MinMaxRight Decimal(10,1) null
				,OOSRed Decimal(10,1) null
				,OOSGreen Decimal(10,1) null
				,DOSRed Decimal(10,1) null
				,DOSGreen Decimal(10,1) null
				,MinMaxRed Decimal(10,1) null
				,MinMaxGreen Decimal(10,1) null
			 )

Declare @SelectedRegionIDs Table
		(
			RegionID int
		)

Declare @SelectedBranchIDs Table
		(
			BranchID int
		)

Declare @SelectedTradeMarkIDs Table
		(
			TradeMarkID int
		)

Declare @SelectedPackageTypeIDs Table
		(
			PackageTypeID int
		)

Insert into @SelectedRegionIDs
Select Value from dbo.Split(@RegionIDs,',')

Insert into @SelectedBranchIDs
Select Value from dbo.Split(@BranchIDs,',')

Insert into @SelectedTradeMarkIDs
Select Value from dbo.Split(@TrademarkIDs,',')


Insert into @SelectedPackageTypeIDs
Select Value from dbo.Split(@PackageIDs,',')

--- These Records are for Product Lines
Insert into @SupplyChainDsdOverAllScoresForLanding (ProductLineID, ProductLineName, OOSRed, OOSGreen, DOSRed, DOSGreen, MinMaxRed, MinMaxGreen)
	Select pl.ProductLineID, pl.ProductLineName,OAT.OverAllOOSLeftThreshold, OAT.OverAllOOSRightThreshold, OAT.OverAllDOSLeftThreshold, OAT.OverAllDOSRightThreshold, OAT.OverAllMinMaxLeftThreshold, OAT.OverAllMinMaxRightThreshold  from SAP.ProductLine as pl cross join SupplyChain.OverAllThreshold as OAT
	Union
	Select -1,'OverAll',OAT.OverAllOOSLeftThreshold, OAT.OverAllOOSRightThreshold, OAT.OverAllDOSLeftThreshold, OAT.OverAllDOSRightThreshold, OAT.OverAllMinMaxLeftThreshold, OAT.OverAllMinMaxRightThreshold  from SupplyChain.OverAllThreshold as OAT
---- This one is for Over All Scores

	If(@MeasureType = 'OOS')
		Begin
			Update mb
			Set mb.OOS = OOSTemp.OOS,
			mb.CaseCut = OOSTemp.CaseCut
				from @SupplyChainDsdOverAllScoresForLanding as mb
				Inner Join (Select ProductLineID, ((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0)) * 100  as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
							SupplyChain.tDsdDailyCaseCut as OOS
							Where  OOS.DateID = @DateID 
							And OOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
							And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
							And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		
							Group by OOS.ProductLineID
						) as OOSTemp on mb.ProductLineID = OOSTemp.ProductLineID
			Update mb
			Set mb.OOS = OOSTemp.OOS,
			mb.CaseCut = OOSTemp.CaseCut,
			mb.ProductLineID = OOSTemp.OverAllID
				from @SupplyChainDsdOverAllScoresForLanding as mb
				Inner Join (Select -1 as OverAllID, ((SUM(oos.CaseCut)*1.0)/NULLIF(sum(Isnull(oos.Quantity, 0)),0)) * 100  as OOS,SUM(Isnull(oos.CaseCut,0)) as CaseCut from		 
							SupplyChain.tDsdDailyCaseCut as OOS
							Where  OOS.DateID = @DateID 
							And OOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
							And OOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
							And OOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
							And OOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)
						) as OOSTemp on mb.ProductLineID = OOSTemp.OverAllID


			 Select * from @SupplyChainDsdOverAllScoresForLanding
		End
	Else If(@MeasureType = 'DOS')
		Begin
			Update mb
				Set mb.DOS = DOSTemp.DaysOfSupply
					,mb.DOSCases = DOSTemp.DOSCases
				from @SupplyChainDsdOverAllScoresForLanding as mb
				Inner Join (Select  ProductLineID,Case When sum(dos.Past31DaysXferOutPlusShipment) = 0 Then 0 Else ((SUM(dos.EndingInventory)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 30 End as DaysOfSupply, SUM(dos.EndingInventory) as DOSCases
							 from SupplyChain.tDsdDailyBranchInventory as DOS 
							 Where  DOS.DateID = @DateID 
									And DOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
									And DOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
									And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
									And DOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		 
									Group by DOS.ProductLineID
							) as DOSTemp   on mb.ProductLineID = DOSTemp.ProductLineID
			Update mb
				Set mb.DOS = DOSTemp.DaysOfSupply
					,mb.DOSCases = DOSTemp.DOSCases
					,mb.ProductLineID = DOSTemp.OverAllID
				from @SupplyChainDsdOverAllScoresForLanding as mb
				Inner Join (Select  -1 as OverAllID,Case When sum(dos.Past31DaysXferOutPlusShipment) = 0 Then 0 Else ((SUM(dos.EndingInventory)*1.0)/NUllIF(sum(dos.Past31DaysXferOutPlusShipment),0)) * 30 End as DaysOfSupply, SUM(dos.EndingInventory) as DOSCases
							 from SupplyChain.tDsdDailyBranchInventory as DOS 
							 Where  DOS.DateID = @DateID 
									And DOS.RegionID in (Select sr.RegionID from @SelectedRegionIDs as sr)
									And DOS.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
									And DOS.TradeMarkID in (Select st.TradeMarkID from @SelectedTradeMarkIDs as st)	
									And DOS.PackageTypeID in (Select sp.PackageTypeID from @SelectedPackageTypeIDs as sp)		 
									Group by DOS.ProductLineID
							) as DOSTemp   on mb.ProductLineID = DOSTemp.OverAllID
			 Select * from @SupplyChainDsdOverAllScoresForLanding
		End
		
	Else If(@MeasureType = 'MinMax')
		Begin
			Update mb
			Set  mb.MinMaxLeft = minmaxTemp.MinMaxLeft
				,mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle
				,mb.MinMaxRight = minmaxTemp.MinMaxRight
			from @SupplyChainDsdOverAllScoresForLanding as mb
			Inner Join (Select   ProductLineID
								,((SUm(minMax.IsBelowMin) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxLeft
								,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
								,((SUm(minMax.IsAboveMax) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxRight
								from SupplyChain.tDsdDailyMinMax as minmax
								 Where  minmax.DateID = @DateID 
										And minmax.RegionID in (Select RegionID from @SelectedRegionIDs)
										And minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
										And minmax.TradeMarkID in (Select TradeMarkID from @SelectedTradeMarkIDs)	
										And minmax.PackageTypeID in (Select PackageTypeID from @SelectedPackageTypeIDs)	
										Group by minmax.ProductLineID
						) as minmaxTemp   on mb.ProductLineID = minmaxTemp.ProductLineID
			Update mb
			Set mb.MinMaxLeft = minmaxTemp.MinMaxLeft
				,mb.MinMaxMiddle = minmaxTemp.MinMaxMiddle
				,mb.MinMaxRight = minmaxTemp.MinMaxRight
				,mb.ProductLineID = minmaxTemp.OverAllID
			from @SupplyChainDsdOverAllScoresForLanding as mb
			Inner Join (Select   -1 as OverAllID
								,((SUm(minMax.IsBelowMin) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxLeft
								,((SUm(minMax.IsCompliant) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxMiddle
								,((SUm(minMax.IsAboveMax) * 1.0 )/ SUM(minMax.IsBelowMin + minMax.IsCompliant + minMax.IsAboveMax))*100 as MinMaxRight
								from SupplyChain.tDsdDailyMinMax as minmax
								 Where  minmax.DateID = @DateID 
										And minmax.RegionID in (Select RegionID from @SelectedRegionIDs)
										And minmax.BranchID in (Select sb.BranchID from @SelectedBranchIDs as sb)
										And minmax.TradeMarkID in (Select TradeMarkID from @SelectedTradeMarkIDs)	
										And minmax.PackageTypeID in (Select PackageTypeID from @SelectedPackageTypeIDs)	
										Group by minmax.ProductLineID
						) as minmaxTemp   on mb.ProductLineID = minmaxTemp.OverAllID
			 Select * from @SupplyChainDsdOverAllScoresForLanding
		End



GO
/****** Object:  StoredProcedure [SupplyChain].[pGetMyPromotion]    Script Date: 12/12/2014 11:13:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [SupplyChain].[pGetMyPromotion] (          
  @LocationId VARCHAR(MAX)       
 ,@TradeMarkId VARCHAR(MAX)        
 ,@PackageId VARCHAR(MAX)        
 ,@TypeId VARCHAR(MAX)        
 ,@bool int = NULL       
 ,@StartDate DATETIME = NULL --= '12/1/2014 12:00:00 AM'--NULL --'11/1/2014 12:00:00 AM' --NULL --'10/1/2014 12:00:00 AM'            
 ,@EndDate DATETIME =NULL --'12/31/2014 12:00:00 AM'--NULL --'11/15/2014 12:00:00 AM' --NULL --'12/31/2014 12:00:00 AM'            
 ,@GSN VARCHAR(20)       
 ,@PersonaID int       
 )          
AS          
BEGIN          
 BEGIN TRY          
  DECLARE @LastweekStartDate DATE          
   ,@LastweekEndDate DATE          
   ,@NextweekStartDate DATE          
   ,@NextweekEndDate DATE          
   ,@ClosedLastweek INT          
   ,@Ongoing INT          
   ,@StartingNextWeek INT          
   ,@SubQuery VARCHAR(max) = ''          
   ,@Query VARCHAR(max) = ''          
   ,@IsMyAccountQuery VARCHAR(max) = ''          
   ,@JOINPromotionGeoHier VARCHAR(max) = '';
          
  CREATE TABLE #Durationtemp (          
   LastweekStartDate DATETIME          
   ,LastweekEndDate DATETIME          
   ,NextweekStartDate DATETIME          
   ,NextweekEndDate DATETIME          
   ,CurrentWeekStart DATETIME          
   ,CurrentWeekEnd DATETIME          
   );          
          
  CREATE TABLE #Counttemp (RecordCount INT);          
          
  CREATE TABLE #PromotionIDtemp (PromotionID INT);          
          
  -----------Last Week Date and Next Week Date Set-------------------                            
  INSERT INTO #Durationtemp (          
   LastweekStartDate          
   ,LastweekEndDate          
   ,NextweekStartDate          
   ,NextweekEndDate          
   ,CurrentWeekStart          
   ,CurrentWeekEnd          
   )          
  SELECT Dateadd(dd, - (Datepart(dw, getdate())) - 5, getdate()) [LastweekStartDate]          
   ,Dateadd(dd, - (Datepart(dw, getdate())) + 1, getdate()) [LastweekEndDate]          
   ,Dateadd(dd, (9 - Datepart(dw, getdate())), getdate()) [NextweekStartDate]          
   ,Dateadd(dd, 15 - (Datepart(dw, getdate())), getdate()) [NextweekEndDate]          
   ,DATEADD(DAY, 1 - DATEPART(WEEKDAY, GETDATE()), CAST(GETDATE() AS DATE)) [CurrentWeekStart]          
   ,DATEADD(DAY, 7 - DATEPART(WEEKDAY, GETDATE()), CAST(GETDATE() AS DATE)) [CurrentWeekEnd];          
          
  -- For Is My Account      
                 
  DECLARE @SPUserPRofileID INT                              
  SELECT @SPUserPRofileID = SPUserprofileid                              
  FROM Person.SPUserPRofile                              
  WHERE GSn = @GSN AND personaid = @PersonaID                             
  SELECT DISTINCT b.LocalChainID                              
   ,b.RegionalChainID                              
   ,b.NationalChainID                              
  INTO #UserAccount                              
  FROM Person.UserAccount a                              
  LEFT JOIN mview.ChainHier b ON (                              
    a.LocalChainID = b.LocalChainID                              
    OR a.RegionalChainID = b.RegionalChainID                              
    OR a.NationalChainID = b.NationalChainID                              
    )                              
  WHERE a.SPUserPRofileID = @SPUserPRofileID       
                  
  ----------------------------------------------------------------------------                            
  ---------Query Prepare regarding LocationID,TradeMarkID,PackageID--------                   
  IF (ISNULL(@bool, 0) <> 0)          
  BEGIN          
   -- Promotion IDs --                  
   DECLARE @LOCAL_startdate DATETIME;          
   DECLARE @LOCAL_enddate DATETIME;          
          
   SET @LOCAL_startdate = @StartDate;          
   SET @LOCAL_enddate = @EndDate;          
          
   INSERT INTO #PromotionIDtemp (PromotionID)          
   SELECT DISTINCT Rprmtn.PromotionID          
   FROM Playbook.Retailpromotion Rprmtn          
   JOIN Playbook.Promotionbrand Pbrand ON Rprmtn.PromotionID = Pbrand.PromotionID          
   JOIN Playbook.promotionPackage Ppackage ON Rprmtn.PromotionID = Ppackage.PromotionID          
   JOIN Playbook.PromotionGeoRelevancy PromGeo ON Rprmtn.PromotionID = PromGeo.PromotionID
   JOIN mview.LocationHier mviewLoc ON PromGeo.RegionID = mviewLoc.RegionId          
    OR PromGeo.BranchId = mviewLoc.BranchId          
    OR PromGeo.BUID = mviewLoc.BUID          
    OR PromGeo.AreaId = mviewLoc.AreaId
   JOIN [Playbook].[PromotionGeoHier] PGeoHier on  PGeoHier.PromotionId = Rprmtn.PromotionID
   WHERE PGeoHier.BranchId = @LocationId          
    AND Pbrand.TrademarkID IN (          
     SELECT value          
     FROM [CDE].[udfSplit](@TradeMarkId, ',')          
     )          
    AND Ppackage.PackageID IN (          
     SELECT value          
     FROM [CDE].[udfSplit](@PackageId, ',')          
     )      
    AND Rprmtn.PromotionStatusID = 4          
    AND (      
      --@LOCAL_startdate BETWEEN Rprmtn.PromotionStartDate AND Rprmtn.PromotionEndDate        
      --OR Rprmtn.PromotionRelevantStartdate BETWEEN @LOCAL_startdate AND @LOCAL_enddate        
      --OR Rprmtn.PromotionRelevantEnddate BETWEEN @LOCAL_startdate AND @LOCAL_enddate           
     Convert(Date,Rprmtn.PromotionStartDate) <= Convert(Date,@LOCAL_enddate)--@LOCAL_enddate /*Quater End Date   PromotionStartDate  */      
     AND Convert(Date,Rprmtn.PromotionEndDate) >= Convert(Date,@LOCAL_startdate )--@LOCAL_startdate /*Quater Start Date  PromotionEndDate */          
     )          
    --IsMyAccount              
    AND (Rprmtn.PromotionGroupID = 1               
    AND 1 = CASE               
      WHEN (SELECT TOP 1 1                     
          FROM PlayBook.PromotionAccountHier AS account                              
          WHERE account.PromotionID = Rprmtn.PromotionID                              
          and account.LocalChainID IN (SELECT uAccount.LocalChainID FROM #UserAccount uAccount)) =1 THEN 1                              
          ELSE 0              
      END               
   )      
                              
   SELECT PromotionID          
   FROM #PromotionIDtemp          
  END          
  ELSE          
   -- Promotion Count --              
  BEGIN          
   SET @IsMyAccountQuery = 'AND (Rprmtn.PromotionGroupID = 1 AND 1 = CASE WHEN (SELECT TOP 1 1 FROM PlayBook.PromotionAccountHier AS account WHERE account.PromotionID = Rprmtn.PromotionID and account.LocalChainID IN (SELECT uAccount.LocalChainID FROM #UserAccount uAccount)) =1 THEN 1 ELSE 0 END )'
   SET @JOINPromotionGeoHier = 'JOIN [Playbook].[PromotionGeoHier] PGeoHier on  PGeoHier.PromotionId = Rprmtn.PromotionID '
          
   IF (Isnull(@LocationId, '') != '0')          
   BEGIN          
    IF (Isnull(@TypeId, '') != '0')          
    BEGIN          
     IF (@TypeId = 1)          
     BEGIN          
      SET @SubQuery += ' and mviewLoc.RegionId IN (SELECT value FROM [CDE].[udfSplit](''' + @LocationId + ''','',''))';          
     END          
     ELSE IF (@TypeId = 2)          
     BEGIN          
      SET @SubQuery += ' and PGeoHier.BranchId IN (SELECT value FROM [CDE].[udfSplit](''' + @LocationId + ''','',''))';          
     END          
    END          
   END          
          
   IF (ISNULL(@TradeMarkId, '') != '0')          
   BEGIN          
    --SET @SubQuery += ' and Pbrand.TrademarkID=' + Convert(VARCHAR(100), @TradeMarkId) + ' ';                        
    SET @SubQuery += ' and Pbrand.TrademarkID IN (SELECT value FROM [CDE].[udfSplit](''' + @TradeMarkId + ''','',''))';          
   END          
          
   IF (ISNULL(@PackageId, '') != '0')          
   BEGIN          
    SET @SubQuery += ' and Ppackage.PackageID IN (SELECT value FROM [CDE].[udfSplit](''' + @PackageId + ''','',''))';          
   END          
   
   IF (@TypeId = 1)          
   BEGIN        
	   SET @Query = ' Select Count(distinct Rprmtn.PromotionID)  from Playbook.Retailpromotion Rprmtn join Playbook.Promotionbrand Pbrand  on Rprmtn.PromotionID=Pbrand.PromotionID  join Playbook.promotionPackage Ppackage on Rprmtn.PromotionID=Ppackage.PromotionID           
	   join Playbook.PromotionGeoRelevancy PromGeo on Rprmtn.PromotionID= PromGeo.PromotionID JOIN mview.LocationHier mviewLoc ON PromGeo.RegionID=mviewLoc.RegionId OR PromGeo.BranchId=mviewLoc.BranchId OR PromGeo.BUID=mviewLoc.BUID OR PromGeo.AreaId=mviewLoc.AreaId            
	   Where Convert(Date,Rprmtn.PromotionEndDate)>=Convert(Date,(Select Top 1 LastweekStartDate from #Durationtemp )) and Convert(Date,Rprmtn.PromotionEndDate)<=Convert(Date,(Select Top 1 LastweekEndDate from #Durationtemp )) and Rprmtn.PromotionStatusID =4'+ @SubQuery + '' + @IsMyAccountQuery + ' ';
   END
   ELSE IF (@TypeId=2)
   BEGIN
	   SET @Query = ' Select Count(distinct Rprmtn.PromotionID)  from Playbook.Retailpromotion Rprmtn join Playbook.Promotionbrand Pbrand  on Rprmtn.PromotionID=Pbrand.PromotionID  join Playbook.promotionPackage Ppackage on Rprmtn.PromotionID=Ppackage.PromotionID           
	   JOIN Playbook.PromotionGeoRelevancy PromGeo on Rprmtn.PromotionID= PromGeo.PromotionID JOIN mview.LocationHier mviewLoc ON PromGeo.RegionID=mviewLoc.RegionId OR PromGeo.BranchId=mviewLoc.BranchId OR PromGeo.BUID=mviewLoc.BUID OR PromGeo.AreaId=mviewLoc.AreaId
	   JOIN [Playbook].[PromotionGeoHier] PGeoHier on  PGeoHier.PromotionId = Rprmtn.PromotionID
	   Where Convert(Date,Rprmtn.PromotionEndDate)>=Convert(Date,(Select Top 1 LastweekStartDate from #Durationtemp )) and Convert(Date,Rprmtn.PromotionEndDate)<=Convert(Date,(Select Top 1 LastweekEndDate from #Durationtemp )) and Rprmtn.PromotionStatusID =4'+ @SubQuery + '' + @IsMyAccountQuery + ' ';
   END
   DELETE          
   FROM #Counttemp          
          
   PRINT @Query;          
          
   INSERT INTO #Counttemp (RecordCount)          
   EXEC (@Query);          
          
   SELECT @ClosedLastweek = RecordCount          
   FROM #Counttemp;          
   
   IF (@TypeId = 1)          
   BEGIN       
	   SET @Query = ' Select Count(distinct Rprmtn.PromotionID)  from Playbook.Retailpromotion Rprmtn join Playbook.Promotionbrand Pbrand on Rprmtn.PromotionID=Pbrand.PromotionID join Playbook.promotionPackage Ppackage on Rprmtn.PromotionID=Ppackage.PromotionID        
	   join Playbook.PromotionGeoRelevancy PromGeo on Rprmtn.PromotionID= PromGeo.PromotionID  JOIN mview.LocationHier mviewLoc ON PromGeo.RegionID=mviewLoc.RegionId OR PromGeo.BranchId=mviewLoc.BranchId OR PromGeo.BUID=mviewLoc.BUID OR PromGeo.AreaId=mviewLoc.AreaId        
	   Where Convert(Date,Rprmtn.PromotionEndDate)>=Convert(Date,(Select Top 1 CurrentWeekStart from #Durationtemp )) and Convert(Date,Rprmtn.PromotionStartDate)<= Convert(Date,(Select Top 1 CurrentWeekEnd from #Durationtemp)) and Rprmtn.PromotionStatusID =4'+@SubQuery + '' + @IsMyAccountQuery + ' ';              
   END
   ELSE IF(@TypeId=2)
   BEGIN
	   SET @Query = ' Select Count(distinct Rprmtn.PromotionID)  from Playbook.Retailpromotion Rprmtn join Playbook.Promotionbrand Pbrand on Rprmtn.PromotionID=Pbrand.PromotionID join Playbook.promotionPackage Ppackage on Rprmtn.PromotionID=Ppackage.PromotionID        
	   JOIN Playbook.PromotionGeoRelevancy PromGeo on Rprmtn.PromotionID= PromGeo.PromotionID  JOIN mview.LocationHier mviewLoc ON PromGeo.RegionID=mviewLoc.RegionId OR PromGeo.BranchId=mviewLoc.BranchId OR PromGeo.BUID=mviewLoc.BUID OR PromGeo.AreaId=mviewLoc.AreaId        
	   JOIN [Playbook].[PromotionGeoHier] PGeoHier on  PGeoHier.PromotionId = Rprmtn.PromotionID
	   Where Convert(Date,Rprmtn.PromotionEndDate)>=Convert(Date,(Select Top 1 CurrentWeekStart from #Durationtemp )) and Convert(Date,Rprmtn.PromotionStartDate)<= Convert(Date,(Select Top 1 CurrentWeekEnd from #Durationtemp)) and Rprmtn.PromotionStatusID =4'+@SubQuery + '' + @IsMyAccountQuery + ' ';
   END       
   DELETE          
   FROM #Counttemp          
          
   PRINT @Query;          
          
   INSERT INTO #Counttemp (RecordCount)          
   EXEC (@Query);          
          
   SELECT @Ongoing = RecordCount          
   FROM #Counttemp;          
   
   IF (@TypeId = 1)          
   BEGIN       
	   SET @Query = ' Select Count(distinct Rprmtn.PromotionID)  from Playbook.Retailpromotion Rprmtn join Playbook.Promotionbrand Pbrand  on Rprmtn.PromotionID=Pbrand.PromotionID  join Playbook.promotionPackage Ppackage on Rprmtn.PromotionID=Ppackage.PromotionID join                       
		Playbook.PromotionGeoRelevancy PromGeo on Rprmtn.PromotionID= PromGeo.PromotionID JOIN mview.LocationHier mviewLoc ON PromGeo.RegionID=mviewLoc.RegionId OR PromGeo.BranchId=mviewLoc.BranchId OR PromGeo.BUID=mviewLoc.BUID OR PromGeo.AreaId=mviewLoc.AreaId       
		Where Convert(Date,Rprmtn.PromotionStartDate)>=Convert(Date,(Select Top 1 NextweekStartDate from #Durationtemp )) and Convert(Date,Rprmtn.PromotionStartDate)<=Convert(Date,(Select Top 1 NextweekEndDate from #Durationtemp )) and Rprmtn.PromotionStatusID= 4' + @SubQuery + '' + @IsMyAccountQuery + ' ';              
   END   
   ELSE IF(@TypeId=2)
   BEGIN
		SET @Query = ' Select Count(distinct Rprmtn.PromotionID)  from Playbook.Retailpromotion Rprmtn join Playbook.Promotionbrand Pbrand  on Rprmtn.PromotionID=Pbrand.PromotionID  join Playbook.promotionPackage Ppackage on Rprmtn.PromotionID=Ppackage.PromotionID
		JOIN Playbook.PromotionGeoRelevancy PromGeo on Rprmtn.PromotionID= PromGeo.PromotionID JOIN mview.LocationHier mviewLoc ON PromGeo.RegionID=mviewLoc.RegionId OR PromGeo.BranchId=mviewLoc.BranchId OR PromGeo.BUID=mviewLoc.BUID OR PromGeo.AreaId=mviewLoc.AreaId
		JOIN [Playbook].[PromotionGeoHier] PGeoHier on  PGeoHier.PromotionId = Rprmtn.PromotionID       
		Where Convert(Date,Rprmtn.PromotionStartDate)>=Convert(Date,(Select Top 1 NextweekStartDate from #Durationtemp )) and Convert(Date,Rprmtn.PromotionStartDate)<=Convert(Date,(Select Top 1 NextweekEndDate from #Durationtemp )) and Rprmtn.PromotionStatusID= 4' + @SubQuery + '' + @IsMyAccountQuery + ' ';              
   END    
   DELETE          
   FROM #Counttemp;          
          
   PRINT @Query;          
          
   INSERT INTO #Counttemp (RecordCount)          
   EXEC (@Query);          
          
   SELECT @StartingNextWeek = RecordCount          
   FROM #Counttemp;          
          
   SELECT @ClosedLastweek [ClosedLastWeekValue]          
    ,@Ongoing [OngoingValue]          
    ,@StartingNextWeek [StartingNextWeekValue]          
  END          
 END TRY          
          
 BEGIN CATCH          
  SELECT Error_Message() [Error Message];          
 END CATCH          
END     
    
--GO          
--  SupplyChain.pGetMyPromotion          
--  @LocationId ='88'          
-- ,@TradeMarkId ='4,5,6,7,11,12,94,95,96,98,104,2,1,3,16,10,19,28,54,97,125,129,130,133,137,154,175,187,192,216,228'          
-- ,@PackageId='3,4,6,8,12,13,17,18,19,20,21,22,24,25,26,27,29,30,31,32,34,38,39,40,41,43,44,46,47,50,51,52,54,55,58,59,60,61,62,63,64,65,66,67,68,71,72,74,77,78,79,80,82,84,85,86,87,88,90,91,92,93,94,95,96,97,98,100,101,103,105,106,108,109,110,112,113,117,118,119,120,124,126,127,128,129,133,134,135,136,137,138,139,140,141,142,143,145,146,150,151,152,153,154,157,158,159,160,162,163,164,165,166,169,172,173,177,179,180'           
-- ,@TypeId=2           
-- ,@bool = 1--NULL           
-- ,@StartDate  ='10/1/2014 12:00:00 AM'--= NULL --= '12/1/2014 12:00:00 AM'--NULL --'11/1/2014 12:00:00 AM' --NULL --'10/1/2014 12:00:00 AM'                
-- ,@EndDate  ='12/31/2014 12:00:00 AM'--=NULL --'12/31/2014 12:00:00 AM'--NULL --'11/15/2014 12:00:00 AM' --NULL --'12/31/2014 12:00:00 AM'                
-- ,@GSN ='tessc001'          
-- ,@PersonaID =6
GO

------------------------
---------------------------------------
ALTER PROCEDURE [ETL].[pAssociateBranchMaterial] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	-------------------------------------------
	-------------------------------------------
	MERGE SAP.BranchMaterial AS bu
		USING (Select BranchID, MaterialID
					From Staging.RMItemMaster ai
					Join SAP.Material bt on ai.ITEM_NUMBER = bt.SAPMaterialID
					Join SAP.Branch b on Left(LOCATION_ID, 4) = b.SAPBranchID ) input
				ON bu.MaterialID = input.MaterialID
				And bu.BranchID = input.BranchID
	WHEN NOT MATCHED By Target THEN
		INSERT(MaterialID, BranchID)
		VALUES(input.MaterialID, input.BranchID)
	WHEN NOT MATCHED By Source THEN
		Delete;

	---Reset SAP.Material ----------------------------
	Update SAP.Material
	Set ActiveInRM = 0, RMStatusSetDate = SYSDATETIME()
	Where MaterialID not in 
	(
		Select Distinct MaterialID
		From SAP.BranchMaterial
	)

	---- Set ------
	Update SAP.Material
	Set ActiveInRM = 1, RMStatusSetDate = SYSDATETIME()
	Where MaterialID In 
	(
		Select Distinct MaterialID
		From SAP.BranchMaterial
	)

	--- Reset SAP.Brand ---
	Update b
	Set ActiveInRM = 0, RMStatusSetDate = SYSDATETIME()
	From SAP.Material m
	Join SAP.Brand b on m.BrandID = b.BrandID
	Where m.ActiveInRM = 0

	--- Set ---
	Update b
	Set ActiveInRM = 1, RMStatusSetDate = SYSDATETIME()
	From SAP.Material m
	Join SAP.Brand b on m.BrandID = b.BrandID
	Where m.ActiveInRM = 1

	--- Reset SAP.TradeMark ---
	Update t
	Set ActiveInRM = 0, RMStatusSetDate = SYSDATETIME()
	From SAP.Brand b 
	Join SAP.TradeMark t on b.TrademarkID = t.TrademarkID
	Where b.ActiveInRM = 0

	--- Set ---
	Update t
	Set ActiveInRM = 1, RMStatusSetDate = SYSDATETIME()
	From SAP.Brand b 
	Join SAP.TradeMark t on b.TrademarkID = t.TrademarkID
	Where b.ActiveInRM = 1

	------------------------------
	Truncate Table SUpplyChain.tRegionBranchTradeMark;

	Insert into SupplyChain.tRegionBranchTradeMark
	Select RegionID, BranchID, TradeMarkID from Mview.BranchBrand Group by RegionID, BranchID, TradeMarkID

End

GO
