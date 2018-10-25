use Portal_Data204
Go

--Insert Into [BCMyday].[ManagementPriority]([Description],[StartDate],[EndDate],[ForAllChains],[ForAllBrands],[ForAllPackages],[ForAllBottlers],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--Values ('Maecenas ut dolor nec leo mattis euismod a a turpis.', '2015-01-23', '2015-02-23', 1,1,1,1, 'WUXYX001', '2015-01-20', 'WUXYX001', '2015-01-25')

--Insert Into [BCMyday].[ManagementPriority]([Description],[StartDate],[EndDate],[ForAllChains],[ForAllBrands],[ForAllPackages],[ForAllBottlers],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--Values ('In euismod felis sit amet pharetra tincidunt?', '2015-01-30', '2015-02-28', 1,1,1,1, 'WUXYX001', '2015-01-25', 'WUXYX001', '2015-02-25')

--Insert Into [BCMyday].[ManagementPriority]([Description],[StartDate],[EndDate],[ForAllChains],[ForAllBrands],[ForAllPackages],[ForAllBottlers],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--Values ('Sed non urna eu massa elementum fermentum?', '2015-02-15', '2015-03-07', 0,0,0,0, 'WUXYX001', '2015-01-20', 'WUXYX001', '2015-02-25')

--Insert Into [BCMyday].[ManagementPriority]([Description],[StartDate],[EndDate],[ForAllChains],[ForAllBrands],[ForAllPackages],[ForAllBottlers],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--Values ('Duis eu diam sit amet lectus sollicitudin porttitor ut non metus?', '2015-03-01', '2015-03-15', 0,0,0,0, 'WUXYX001', '2015-02-10', 'WUXYX001', '2015-02-28')

--Insert Into [BCMyday].[ManagementPriority]([Description],[StartDate],[EndDate],[ForAllChains],[ForAllBrands],[ForAllPackages],[ForAllBottlers],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--Values ('Praesent et massa condimentum, malesuada eros eget, elementum nulla?', '2015-02-27', '2015-02-28', 1,1,1,1, 'WUXYX001', '2015-01-20', 'WUXYX001', '2015-02-25')

--Insert Into [BCMyday].[ManagementPriority]([Description],[StartDate],[EndDate],[ForAllChains],[ForAllBrands],[ForAllPackages],[ForAllBottlers],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--Values ('Donec sodales justo ac metus congue ullamcorper?', '2015-03-01', '2015-03-31', 0,0,0,0, 'WUXYX001', '2015-01-20', 'WUXYX001', '2015-02-28')

--Insert Into [BCMyday].[ManagementPriority]([Description],[StartDate],[EndDate],[ForAllChains],[ForAllBrands],[ForAllPackages],[ForAllBottlers],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--Values ('Aliquam nec nisi commodo, fermentum metus at, condimentum erat?', '2015-03-20', '2015-04-20', 0,0,0,0, 'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--Insert Into [BCMyday].[ManagementPriority]([Description],[StartDate],[EndDate],[ForAllChains],[ForAllBrands],[ForAllPackages],[ForAllBottlers],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--Values ('Donec sed orci gravida, rutrum urna quis, pulvinar odio?', '2015-03-2', '2015-04-20', 0,0,0,0, 'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--------------------------------------------------------
--------------------------------------------------------
--------------------------------------------------------
Select t.TrademarkID, TradeMarkName, BrandID, BrandName
From SAP.TradeMark t Join SAP.Brand b on t.TradeMarkID = b.TradeMarkID 
Order By TradeMarkName

--INSERT INTO [BCMyday].[PriorityBrand]([ManagementPriorityID],[TradeMarkID],[BrandID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(3,1,null,'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].[PriorityBrand]([ManagementPriorityID],[TradeMarkID],[BrandID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(3,3,null,'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].[PriorityBrand]([ManagementPriorityID],[TradeMarkID],[BrandID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(3,null,34,'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].[PriorityBrand]([ManagementPriorityID],[TradeMarkID],[BrandID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(3,null,35,'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].[PriorityBrand]([ManagementPriorityID],[TradeMarkID],[BrandID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(3,null,36,'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].[PriorityBrand]([ManagementPriorityID],[TradeMarkID],[BrandID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(3,null,37,'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].[PriorityBrand]([ManagementPriorityID],[TradeMarkID],[BrandID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(5,35,null,'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].[PriorityBrand]([ManagementPriorityID],[TradeMarkID],[BrandID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(5,69,null,'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].[PriorityBrand]([ManagementPriorityID],[TradeMarkID],[BrandID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(5,null,153,'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].[PriorityBrand]([ManagementPriorityID],[TradeMarkID],[BrandID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(5,null,154,'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].[PriorityBrand]([ManagementPriorityID],[TradeMarkID],[BrandID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(5,null,155,'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].[PriorityBrand]([ManagementPriorityID],[TradeMarkID],[BrandID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(5,null,156,'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].[PriorityBrand]([ManagementPriorityID],[TradeMarkID],[BrandID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(5,null,157,'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--Update BCMyday.ManagementPriority
--Set ForAllBottlers = 1, ForAllBrands = 1, ForAllChains = 1, ForAllPackages = 1
--Where ManagementPriorityID = 7

-------------------------------------------------
---- ############################################
Select *
From BC.vSalesHierarchy

Select *
From BCMyday.PriorityBottler

--INSERT INTO [BCMyday].PriorityBottler([ManagementPriorityID], SystemID, ZoneID, DivisionID, RegionID, BottlerID, [CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(3,null,null,null, 36, null,'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].PriorityBottler([ManagementPriorityID], SystemID, ZoneID, DivisionID, RegionID, BottlerID, [CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(3,null,null,null, 37, null,'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].PriorityBottler([ManagementPriorityID], SystemID, ZoneID, DivisionID, RegionID, BottlerID, [CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(3,null,null,null, 38, null,'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].PriorityBottler([ManagementPriorityID], SystemID, ZoneID, DivisionID, RegionID, BottlerID, [CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(3,null,null,10, null, null,'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].PriorityBottler([ManagementPriorityID], SystemID, ZoneID, DivisionID, RegionID, BottlerID, [CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(3,null,null,14, null, null,'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].PriorityBottler([ManagementPriorityID], SystemID, ZoneID, DivisionID, RegionID, BottlerID, [CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(3,null,null,16, null, null,'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].PriorityBottler([ManagementPriorityID], SystemID, ZoneID, DivisionID, RegionID, BottlerID, [CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(5,null,null,null, 72, null,'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].PriorityBottler([ManagementPriorityID], SystemID, ZoneID, DivisionID, RegionID, BottlerID, [CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(5,null,null,null, 73, null,'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].PriorityBottler([ManagementPriorityID], SystemID, ZoneID, DivisionID, RegionID, BottlerID, [CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(5,null,9,null, null, null,'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].PriorityBottler([ManagementPriorityID], SystemID, ZoneID, DivisionID, RegionID, BottlerID, [CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(5,null,null,107, null, null,'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].PriorityBottler([ManagementPriorityID], SystemID, ZoneID, DivisionID, RegionID, BottlerID, [CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(5,null,null,108, null, null,'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].PriorityBottler([ManagementPriorityID], SystemID, ZoneID, DivisionID, RegionID, BottlerID, [CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(5,5,null,null, null, null,'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].PriorityBottler([ManagementPriorityID], SystemID, ZoneID, DivisionID, RegionID, BottlerID, [CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(5,6,null,null, null, null,'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

-------------------------------------------------
---- ############################################
Select n.NationalChainID, n.NationalChainName, r.RegionalChainID, r.RegionalChainName, l.LocalChainID, l.LocalChainName
From SAP.NationalChain n
Join SAP.RegionalChain r on r.NationalChainID = n.NationalChainID
Join SAP.LocalChain l on r.RegionalChainID = l.RegionalChainID
Order By NationalChainName, RegionalChainName, LocalChainName

--INSERT INTO [BCMyday].[PriorityChain]([ManagementPriorityID],[NationalChainID],[RegionalChainID],[LocalChainID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(3, 55, null, null, 'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].[PriorityChain]([ManagementPriorityID],[NationalChainID],[RegionalChainID],[LocalChainID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(3, 172, null, null, 'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].[PriorityChain]([ManagementPriorityID],[NationalChainID],[RegionalChainID],[LocalChainID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(3, null, 97, null, 'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].[PriorityChain]([ManagementPriorityID],[NationalChainID],[RegionalChainID],[LocalChainID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(3, null, 102, null, 'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].[PriorityChain]([ManagementPriorityID],[NationalChainID],[RegionalChainID],[LocalChainID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(3, null, 90, null, 'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].[PriorityChain]([ManagementPriorityID],[NationalChainID],[RegionalChainID],[LocalChainID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(3, null, 119, null, 'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].[PriorityChain]([ManagementPriorityID],[NationalChainID],[RegionalChainID],[LocalChainID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(3, null, null, 752, 'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].[PriorityChain]([ManagementPriorityID],[NationalChainID],[RegionalChainID],[LocalChainID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(3, null, null, 1449, 'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].[PriorityChain]([ManagementPriorityID],[NationalChainID],[RegionalChainID],[LocalChainID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(5, 50, null, null, 'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].[PriorityChain]([ManagementPriorityID],[NationalChainID],[RegionalChainID],[LocalChainID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(5, 12, null, null, 'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].[PriorityChain]([ManagementPriorityID],[NationalChainID],[RegionalChainID],[LocalChainID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(5, null, 70, null, 'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].[PriorityChain]([ManagementPriorityID],[NationalChainID],[RegionalChainID],[LocalChainID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(5, null, 71, null, 'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

--INSERT INTO [BCMyday].[PriorityChain]([ManagementPriorityID],[NationalChainID],[RegionalChainID],[LocalChainID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES(5, null, 443, null, 'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01')

-------------------------------------------------
---- ############################################
Select *
From SAP.Package
Where Active = 1
And PackageName like '12 %'


Select * From [BCMyday].[PriorityPackage]

--INSERT INTO [BCMyday].[PriorityPackage]([ManagementPriorityID],[PackageID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES (2, 64, 'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01') 

--INSERT INTO [BCMyday].[PriorityPackage]([ManagementPriorityID],[PackageID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES (2, 68, 'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01') 

--INSERT INTO [BCMyday].[PriorityPackage]([ManagementPriorityID],[PackageID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES (2, 69, 'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01') 

--INSERT INTO [BCMyday].[PriorityPackage]([ManagementPriorityID],[PackageID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES (2, 75, 'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01') 

--INSERT INTO [BCMyday].[PriorityPackage]([ManagementPriorityID],[PackageID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES (2, 76, 'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01') 

--INSERT INTO [BCMyday].[PriorityPackage]([ManagementPriorityID],[PackageID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES (2, 64, 'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01') 

--INSERT INTO [BCMyday].[PriorityPackage]([ManagementPriorityID],[PackageID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES (2, 68, 'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01') 

--INSERT INTO [BCMyday].[PriorityPackage]([ManagementPriorityID],[PackageID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES (2, 69, 'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01') 

--INSERT INTO [BCMyday].[PriorityPackage]([ManagementPriorityID],[PackageID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES (2, 75, 'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01') 

--INSERT INTO [BCMyday].[PriorityPackage]([ManagementPriorityID],[PackageID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--VALUES (2, 76, 'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01') 

--INSERT INTO [BCMyday].[PriorityPackage]([ManagementPriorityID],[PackageID],[CreatedBy],[Created],[LastModifiedBy],[LastModified])
--Select 5, PackageID, 'WUXYX001', '2015-01-20', 'WUXYX001', '2015-03-01'
--From SAP.Package
--Where Active = 1
--And PackageName like '12 %'


GO






