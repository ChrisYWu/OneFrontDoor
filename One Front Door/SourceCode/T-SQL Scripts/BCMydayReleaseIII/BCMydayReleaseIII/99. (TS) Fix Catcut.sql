use Portal_Data
Go

Select Distinct Session_Date
From Apacheta.FleetLoader
Order By Session_Date Desc

--The duplicate key value is (20150226, 3, 150, 7214)
exec ETL.pDSDCasecutFilling

Select *
From SupplyChain.tDsdCaseCut
Where AnchorDateID = 20150226
And AggregationID = 3
And BranchID = 150
And MaterialID = 7214

SElect *
From SupplyChain.TimeAggregation

Select *
From Apacheta.FleetLoader
Where Session_Date = '2015-02-26'
And Left(Route_ID, 4) = 1114

Select *
From SupplyChain.tDsdDailyCaseCut
Where DateID Between 20150201 And 20150226
And BranchID = 150
And MaterialID = 7214

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
			Where DateID Between 20150225 And SupplyChain.udfConvertToDateID(GetDate())
		) Anchor on cut.DateID <= Anchor.DateID And cut.DateID >= Anchor.DateID/100*100 + 1
		Group By Anchor.DateID, BranchID ,MaterialID
	) fact
	Join SAP.Branch b on fact.BranchID = b.BranchID
	Left Join SAP.Area a on b.AreaID = a.AreaID
	Join SAP.Material m on fact.MaterialID = m.MaterialID
	Left Join SAP.Brand bd on m.BrandID = bd.BrandID
	Left Join SAP.TradeMark t on bd.TrademarkID = t.TradeMarkID
	Left Join SAP.Package p on m.PackageID = p.PackageID


Select *
From SAP.Material
Where MaterialID = 7214

Select *
From SAP.Brand
Where BrandID in (452, 584)




