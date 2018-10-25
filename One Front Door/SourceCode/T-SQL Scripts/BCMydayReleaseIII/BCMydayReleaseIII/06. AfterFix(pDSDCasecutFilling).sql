USE [Portal_Data__]
GO
/****** Object:  StoredProcedure [ETL].[pDSDCasecutFilling]    Script Date: 2/27/2015 10:54:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- exec ETL.pDSDCasecutFilling @ParamAffectedMinDateID = 20150225
ALTER Proc [ETL].[pDSDCasecutFilling]
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
	Select fact.DateID, a.RegionID, b.BranchID, 
	t.ProductLineID, bd.TradeMarkID, bd.BrandID,
	m.MaterialID, m.PackageID, p.PackageConfID, p.PackageTypeID, fact.AggregationID, fact.Quantity, fact.CaseCut
	From 
	(
		Select Anchor.DateID, BranchID 
			   ,MaterialID
			   ,3 AggregationID, Sum(Quantity) Quantity, Sum(CaseCut) CaseCut
		From SupplyChain.tDsdDailyCaseCut cut
		Join (
			Select DateID
			From Shared.DimDate 
			Where DateID Between @AffectedMinDateID And SupplyChain.udfConvertToDateID(GetDate())
		) Anchor on cut.DateID <= Anchor.DateID And cut.DateID >= Anchor.DateID/100*100 + 1
		Group By Anchor.DateID, BranchID ,MaterialID
	) fact
	Join SAP.Branch b on fact.BranchID = b.BranchID
	Left Join SAP.Area a on b.AreaID = a.AreaID
	Join SAP.Material m on fact.MaterialID = m.MaterialID
	Left Join SAP.Brand bd on m.BrandID = bd.BrandID
	Left Join SAP.TradeMark t on bd.TrademarkID = t.TradeMarkID
	Left Join SAP.Package p on m.PackageID = p.PackageID

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
	Select fact.DateID, a.RegionID, b.BranchID, 
	t.ProductLineID, bd.TradeMarkID, bd.BrandID,
	m.MaterialID, m.PackageID, p.PackageConfID, p.PackageTypeID, fact.AggregationID, fact.Quantity, fact.CaseCut
	From 
	(
		Select Anchor.DateID, BranchID 
			   ,MaterialID
			   ,4 AggregationID, Sum(Quantity) Quantity, Sum(CaseCut) CaseCut
		From SupplyChain.tDsdDailyCaseCut cut
		Join (
			Select DateID
			From Shared.DimDate 
			Where DateID Between @AffectedMinDateID And SupplyChain.udfConvertToDateID(GetDate())
		) Anchor on cut.DateID <= Anchor.DateID And cut.DateID >= Anchor.DateID/10000*10000 + 1
		Group By Anchor.DateID, BranchID ,MaterialID
	) fact
	Join SAP.Branch b on fact.BranchID = b.BranchID
	Left Join SAP.Area a on b.AreaID = a.AreaID
	Join SAP.Material m on fact.MaterialID = m.MaterialID
	Left Join SAP.Brand bd on m.BrandID = bd.BrandID
	Left Join SAP.TradeMark t on bd.TrademarkID = t.TradeMarkID
	Left Join SAP.Package p on m.PackageID = p.PackageID

	----- Last 7 Days --------------
	--Select DateID, Convert(Int, CONVERT(varchar, DATEADD(d, -6, Date),112)) [7daysago]
	--From Shared.DimDate 
	--Where DateID Between @AffectedMinDateID And SupplyChain.udfConvertToDateID(GetDate())

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
	Select fact.DateID, a.RegionID, b.BranchID, 
	t.ProductLineID, bd.TradeMarkID, bd.BrandID,
	m.MaterialID, m.PackageID, p.PackageConfID, p.PackageTypeID, fact.AggregationID, fact.Quantity, fact.CaseCut
	From 
	(
		Select Anchor.DateID, BranchID 
			   ,MaterialID
			   ,5 AggregationID, Sum(Quantity) Quantity, Sum(CaseCut) CaseCut
		From SupplyChain.tDsdDailyCaseCut cut
		Join (
			Select DateID, Date
			From Shared.DimDate 
			Where DateID Between @AffectedMinDateID And SupplyChain.udfConvertToDateID(GetDate())
		) Anchor on cut.DateID <= Anchor.DateID And cut.DateID >= Convert(Int, CONVERT(varchar, DATEADD(d, -6, Anchor.Date),112))
			Group By Anchor.DateID, BranchID ,MaterialID
	) fact
	Join SAP.Branch b on fact.BranchID = b.BranchID
	Left Join SAP.Area a on b.AreaID = a.AreaID
	Join SAP.Material m on fact.MaterialID = m.MaterialID
	Left Join SAP.Brand bd on m.BrandID = bd.BrandID
	Left Join SAP.TradeMark t on bd.TrademarkID = t.TradeMarkID
	Left Join SAP.Package p on m.PackageID = p.PackageID

	ALTER INDEX [PK_tDsdCaseCut] ON [SupplyChain].[tDsdCaseCut] REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100)

	--- Verify -----------------
	--Select * From SupplyChain.tDsdCaseCut
	---------------------------
End

