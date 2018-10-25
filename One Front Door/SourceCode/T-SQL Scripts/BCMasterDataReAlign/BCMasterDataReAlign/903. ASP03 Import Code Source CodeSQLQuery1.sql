USE [Portal_Data]
GO
/****** Object:  StoredProcedure [ETL].[pImportProductionDownTime]    Script Date: 6/8/2015 1:51:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER Proc [ETL].[pImportProductionDownTime]
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





