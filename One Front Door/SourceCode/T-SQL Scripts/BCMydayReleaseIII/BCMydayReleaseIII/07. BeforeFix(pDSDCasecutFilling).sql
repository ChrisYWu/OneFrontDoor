USE [Portal_Data___]
GO
/****** Object:  StoredProcedure [ETL].[pDSDCasecutFilling]    Script Date: 2/27/2015 11:00:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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
		   ,PackageTypeID, 5, Sum(Quantity), Sum(CaseCut)
	From SupplyChain.tDsdDailyCaseCut cut
	Join (
		Select DateID, Date
		From Shared.DimDate 
		Where DateID Between @AffectedMinDateID And SupplyChain.udfConvertToDateID(GetDate())
	) Anchor on cut.DateID <= Anchor.DateID And cut.DateID >= Convert(Int, CONVERT(varchar, DATEADD(d, -6, Anchor.Date),112))
	Group By Anchor.DateID, RegionID, BranchID, ProductLineID
		   ,TradeMarkID
		   ,BrandID
           ,MaterialID
		   ,PackageID
		   ,PackageConfID
		   ,PackageTypeID

	ALTER INDEX [PK_tDsdCaseCut] ON [SupplyChain].[tDsdCaseCut] REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100)

	--- Verify -----------------
	--Select * From SupplyChain.tDsdCaseCut
	---------------------------
End

