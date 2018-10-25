use Portal_Data
Go

Print 'Insert Data Into Departments'
SET IDENTITY_INSERT [SupplyChain].[Departments] ON 
GO
INSERT [SupplyChain].[Departments] ([DeptID], [DeptName]) VALUES (1, N'Manufacturing')
GO
INSERT [SupplyChain].[Departments] ([DeptID], [DeptName]) VALUES (2, N'Inventory')
GO
SET IDENTITY_INSERT [SupplyChain].[Departments] OFF
GO
Print 'Insert Data Into [SupplyChain].[MeasursType]'
GO
SET IDENTITY_INSERT [SupplyChain].[MeasursType] ON 
GO
INSERT [SupplyChain].[MeasursType] ([MeasursID], [DeptID], [MeasursType]) VALUES (1, 1, N'TME')
GO
INSERT [SupplyChain].[MeasursType] ([MeasursID], [DeptID], [MeasursType]) VALUES (2, 1, N'AFCO')
GO
INSERT [SupplyChain].[MeasursType] ([MeasursID], [DeptID], [MeasursType]) VALUES (3, 1, N'Recordable')
GO
INSERT [SupplyChain].[MeasursType] ([MeasursID], [DeptID], [MeasursType]) VALUES (4, 1, N'Inventory Cases')
GO
INSERT [SupplyChain].[MeasursType] ([MeasursID], [DeptID], [MeasursType]) VALUES (5, 2, N'OOS')
GO
INSERT [SupplyChain].[MeasursType] ([MeasursID], [DeptID], [MeasursType]) VALUES (6, 2, N'DOS')
GO
INSERT [SupplyChain].[MeasursType] ([MeasursID], [DeptID], [MeasursType]) VALUES (7, 2, N'Min/Max')
GO
SET IDENTITY_INSERT [SupplyChain].[MeasursType] OFF

---This will populate the AddressLine1, AddressLine2, City, State, ZIP
Print 'Update SAP.Branch Address1, Address2, City ......'
GO
Update  a
Set Address1 = b.LOCATION_ADDR1, Address2=b.LOCATION_ADDR2,City=b.LOCATION_CITY, State=b.LOCATION_STATE, ZipCode=b.LOCATION_ZIP
 from 
sap.branch a
left join staging.rmlocation b on (a.SAPBranchID = Left(b.Location_ID, 4))

Print 'Update Short Name in Region Table ......'
GO
---This will Update the Short Name in Region Table
Update sap.Region 
Set ShortName = Case When RegionID = 1 Then 'MC'
					 When RegionID = 2 Then 'MS'
					 When RegionID = 3 Then 'PL'
					 When RegionID = 4 Then 'SE'
					 When RegionID = 5 Then 'NY/NJ'
					 When RegionID = 6 Then 'MI'
					 When RegionID = 7 Then 'OV'
					 When RegionID = 8 Then 'NW'
					 When RegionID = 9 Then 'SC'
					 When RegionID = 11 Then 'ST'
					 When RegionID = 12 Then 'TM'
					 When RegionID = 14 Then 'DM'	
					 End

Print 'Update Short Name in BusinessUnit Table ......'
Go
Update SAP.BusinessUnit
Set SortOrder = Case When BUID = 7 then 1
					 When BUID = 1 then 2
					 When BUID = 6 then 3
					 End	





Truncate Table  SupplyChain.RegionThreshold
----Region Level Threshold
Insert into SupplyChain.RegionThreshold
Select RegionID, 2.0, 1.0,15,10,80,90  from SAP.Region
--Select RegionID, Convert(Decimal(5,2), (Sum(CaseCut) * 1.0/SUM(Quantity))*100) + 0.2, Convert(Decimal(5,2), (Sum(CaseCut) * 1.0/SUM(Quantity))*100) - 0.2,0,0,0,0  from SupplyChain.tDsdCaseCut 
--Where AnchorDateID = 20141015
--group by RegionID
--Order by RegionID



--Update rt
--Set RegionDOSLeftThreshold=(Select Case When (Sum(EndingInventoryCapped)*1.0/Sum(Past31DaysXferOutPlusShipment))*31  = 0 Then 10.36   Else (Sum(EndingInventoryCapped)*1.0/Sum(Past31DaysXferOutPlusShipment))*31 + 1.16 End
--							from SupplyChain.tDsdDailyBranchInventory Where DateID = 20141015 And RegionID = rt.RegionID group by RegionID),
--	RegionDOSRightThreshold=(Select Case When (Sum(EndingInventoryCapped)*1.0/Sum(Past31DaysXferOutPlusShipment))*31  = 0 Then 9.16 Else (Sum(EndingInventoryCapped)*1.0/Sum(Past31DaysXferOutPlusShipment))*31 - 1.12 End
--							from SupplyChain.tDsdDailyBranchInventory Where DateID = 20141015 And RegionID = rt.RegionID group by RegionID),
--	RegionMinMaxLeftThreshold=(Select (SUm(IsCompliant) * 1.0 )/ SUM(IsBelowMin + IsCompliant + IsAboveMax)*100 - 5.5 from SupplyChain.tDsdDailyMinMax Where DateID = 20141014 And RegionID = rt.RegionID group by RegionID),
--	RegionMinMaxRightThreshold=(Select (SUm(IsCompliant) * 1.0 )/ SUM(IsBelowMin + IsCompliant + IsAboveMax)*100 + 5.5 from SupplyChain.tDsdDailyMinMax Where DateID = 20141014 And RegionID = rt.RegionID group by RegionID)
--from SupplyChain.RegionThreshold as rt

---OverAll Threshold

Truncate Table SUpplyChain.OverAllThreshold

Insert into SupplyChain.OverAllThreshold
Select 1, (Select SUM(RegionOOSLeftThreshold)/COunt(*) from SupplyChain.RegionThreshold)
		,(Select SUM(RegionOOSRightThreshold)/COunt(*) from SupplyChain.RegionThreshold)
		,(Select SUM(RegionDOSLeftThreshold)/COunt(*) from SupplyChain.RegionThreshold)
		,(Select SUM(RegionDOSRightThreshold)/COunt(*) from SupplyChain.RegionThreshold)
		,(Select SUM(RegionMinMaxLeftThreshold)/COunt(*) from SupplyChain.RegionThreshold)
		,(Select SUM(RegionMinMaxRightThreshold)/COunt(*) from SupplyChain.RegionThreshold)


----ProductLine Threshold

Truncate Table SUpplyChain.ProductLineThreshold

Insert into SupplyChain.ProductLineThreshold
Select ProductLineID, (Select SUM(RegionOOSLeftThreshold)/COunt(*) from SupplyChain.RegionThreshold)
		,(Select SUM(RegionOOSRightThreshold)/COunt(*) from SupplyChain.RegionThreshold)
		,(Select SUM(RegionDOSLeftThreshold)/COunt(*) from SupplyChain.RegionThreshold)
		,(Select SUM(RegionDOSRightThreshold)/COunt(*) from SupplyChain.RegionThreshold)
		,(Select SUM(RegionMinMaxLeftThreshold)/COunt(*) from SupplyChain.RegionThreshold)
		,(Select SUM(RegionMinMaxRightThreshold)/COunt(*) from SupplyChain.RegionThreshold)
		From SAp.ProductLine

----Region ProductLine Threshold

Truncate Table SUpplyChain.RegionProductLineThresholdOverRide

Insert into SupplyChain.RegionProductLineThresholdOverRide
Select r.RegionID, pl.ProductLineID,
((Select Sum(ProductLineOOSLeftThreshold) from SupplyChain.ProductLineThreshold Where ProductLineID= pl.ProductLineID ) + (Select Sum(RegionOOSLeftThreshold) from SupplyChain.RegionThreshold Where RegionID= r.RegionID))/2,
((Select Sum(ProductLineOOSRightThreshold) from SupplyChain.ProductLineThreshold Where ProductLineID= pl.ProductLineID ) + (Select Sum(RegionOOSRightThreshold) from SupplyChain.RegionThreshold Where RegionID= r.RegionID))/2,
((Select Sum(ProductLineDOSLeftThreshold) from SupplyChain.ProductLineThreshold Where ProductLineID= pl.ProductLineID ) + (Select Sum(RegionDOSLeftThreshold) from SupplyChain.RegionThreshold Where RegionID= r.RegionID))/2,
((Select Sum(ProductLineDOSRightThreshold) from SupplyChain.ProductLineThreshold Where ProductLineID= pl.ProductLineID ) + (Select Sum(RegionOOSRightThreshold) from SupplyChain.RegionThreshold Where RegionID= r.RegionID))/2,
((Select Sum(ProductLineMinMaxLeftThreshold) from SupplyChain.ProductLineThreshold Where ProductLineID= pl.ProductLineID ) + (Select Sum(RegionMinMaxLeftThreshold) from SupplyChain.RegionThreshold Where RegionID= r.RegionID))/2,
((Select Sum(ProductLineMinMaxRightThreshold) from SupplyChain.ProductLineThreshold Where ProductLineID= pl.ProductLineID ) + (Select Sum(RegionMinMaxRightThreshold) from SupplyChain.RegionThreshold Where RegionID= r.RegionID))/2
from SAP.Region r Cross Join SAP.ProductLine pl

Go
------------------------------

Insert into Shared.Image
Select 'http://splashnet-qa.dpsg.net/sites/my-images/MasterImages/Trademark/' + ImageURL, 'Trademark' from (
Select 'NoLogoIcon.png' as ImageURL  Union All
Select 'Trademark_700.png'  Union All
Select 'Trademark_A00.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_A06.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_A14.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_B06.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_B20.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_C01.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_C03.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_C04.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_C18.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_C20.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_C28.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_C37.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_D02.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_D03.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_D10.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_F01.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_H02.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_H04.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_H06.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_I00.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_J02.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_J07.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_M06.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_M08.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_N00.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_N02.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_N11.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_O04.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_P02.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_P06.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_P09.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_R03.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_R08.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_S06.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_S09.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_S15.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_S17.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_S19.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_S20.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_S21.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_T00.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_V04.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_V06.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_V12.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_W03.png'  Union All                                                                                                                                                                                                             
Select 'Trademark_Y01.png') as t

Update SAP.TradeMark
Set ImageID = (Select top 1 ImageID from Shared.[Image] Where ImageURL like '%_' + SAPTradeMarkID + '.png')
Where ImageID is  null


Update SAP.TradeMark
Set ImageID = (Select top 1 ImageID from Shared.[Image] Where ImageURL like '%_NoLogoIcon.png')
Where ImageID is null
Go

--------------------------

Update b
Set Longitude = sb.Longitude, Latitude = sb.Latitude
from sap.Branch as b inner join BSCCAP121.Portal_Data.SAP.Branch as sb on b.BranchID = sb.BranchID


Update r
Set Longitude = sr.Longitude, Latitude = sr.Latitude
from sap.Region as r inner join BSCCAP121.Portal_Data.SAP.Region as sr on r.RegionID = sr.RegionID
Go

---------------------------
INSERT [SupplyChain].[tManufacturingMeasures_ToBeDeleted] ([PlantID], [AFCOMDT], [AFCOMDTPY], [RecordableMDT], [RecordableMDTPY], [InvCasesMDT], [InvCasesMDTPy], [AnchorDateID]) VALUES (1, CAST(15.00 AS Decimal(5, 2)), CAST(23.00 AS Decimal(5, 2)), 5, 4, 111200, 120011, 20140924)
GO
INSERT [SupplyChain].[tManufacturingMeasures_ToBeDeleted] ([PlantID], [AFCOMDT], [AFCOMDTPY], [RecordableMDT], [RecordableMDTPY], [InvCasesMDT], [InvCasesMDTPy], [AnchorDateID]) VALUES (2, CAST(15.00 AS Decimal(5, 2)), CAST(23.00 AS Decimal(5, 2)), 5, 4, 111200, 120011, 20140924)
GO
INSERT [SupplyChain].[tManufacturingMeasures_ToBeDeleted] ([PlantID], [AFCOMDT], [AFCOMDTPY], [RecordableMDT], [RecordableMDTPY], [InvCasesMDT], [InvCasesMDTPy], [AnchorDateID]) VALUES (3, CAST(15.00 AS Decimal(5, 2)), CAST(23.00 AS Decimal(5, 2)), 5, 4, 111200, 120011, 20140924)
GO
INSERT [SupplyChain].[tManufacturingMeasures_ToBeDeleted] ([PlantID], [AFCOMDT], [AFCOMDTPY], [RecordableMDT], [RecordableMDTPY], [InvCasesMDT], [InvCasesMDTPy], [AnchorDateID]) VALUES (5, CAST(16.34 AS Decimal(5, 2)), CAST(18.56 AS Decimal(5, 2)), 3, 2, 101200, 100011, 20140924)
GO
INSERT [SupplyChain].[tManufacturingMeasures_ToBeDeleted] ([PlantID], [AFCOMDT], [AFCOMDTPY], [RecordableMDT], [RecordableMDTPY], [InvCasesMDT], [InvCasesMDTPy], [AnchorDateID]) VALUES (7, CAST(16.34 AS Decimal(5, 2)), CAST(18.56 AS Decimal(5, 2)), 3, 2, 101200, 100011, 20140924)
GO
INSERT [SupplyChain].[tManufacturingMeasures_ToBeDeleted] ([PlantID], [AFCOMDT], [AFCOMDTPY], [RecordableMDT], [RecordableMDTPY], [InvCasesMDT], [InvCasesMDTPy], [AnchorDateID]) VALUES (8, CAST(16.34 AS Decimal(5, 2)), CAST(18.56 AS Decimal(5, 2)), 3, 2, 101200, 100011, 20140924)
GO
INSERT [SupplyChain].[tManufacturingMeasures_ToBeDeleted] ([PlantID], [AFCOMDT], [AFCOMDTPY], [RecordableMDT], [RecordableMDTPY], [InvCasesMDT], [InvCasesMDTPy], [AnchorDateID]) VALUES (10, CAST(16.34 AS Decimal(5, 2)), CAST(18.56 AS Decimal(5, 2)), 3, 2, 101200, 100011, 20140924)
GO
INSERT [SupplyChain].[tManufacturingMeasures_ToBeDeleted] ([PlantID], [AFCOMDT], [AFCOMDTPY], [RecordableMDT], [RecordableMDTPY], [InvCasesMDT], [InvCasesMDTPy], [AnchorDateID]) VALUES (12, CAST(19.34 AS Decimal(5, 2)), CAST(17.38 AS Decimal(5, 2)), 2, 5, 130200, 150011, 20140924)
GO
INSERT [SupplyChain].[tManufacturingMeasures_ToBeDeleted] ([PlantID], [AFCOMDT], [AFCOMDTPY], [RecordableMDT], [RecordableMDTPY], [InvCasesMDT], [InvCasesMDTPy], [AnchorDateID]) VALUES (13, CAST(19.34 AS Decimal(5, 2)), CAST(17.38 AS Decimal(5, 2)), 2, 5, 130200, 150011, 20140924)
GO
INSERT [SupplyChain].[tManufacturingMeasures_ToBeDeleted] ([PlantID], [AFCOMDT], [AFCOMDTPY], [RecordableMDT], [RecordableMDTPY], [InvCasesMDT], [InvCasesMDTPy], [AnchorDateID]) VALUES (15, CAST(19.34 AS Decimal(5, 2)), CAST(17.38 AS Decimal(5, 2)), 2, 5, 130200, 150011, 20140924)
GO
INSERT [SupplyChain].[tManufacturingMeasures_ToBeDeleted] ([PlantID], [AFCOMDT], [AFCOMDTPY], [RecordableMDT], [RecordableMDTPY], [InvCasesMDT], [InvCasesMDTPy], [AnchorDateID]) VALUES (16, CAST(19.34 AS Decimal(5, 2)), CAST(17.38 AS Decimal(5, 2)), 2, 5, 130200, 150011, 20140924)
GO
INSERT [SupplyChain].[tManufacturingMeasures_ToBeDeleted] ([PlantID], [AFCOMDT], [AFCOMDTPY], [RecordableMDT], [RecordableMDTPY], [InvCasesMDT], [InvCasesMDTPy], [AnchorDateID]) VALUES (17, CAST(19.34 AS Decimal(5, 2)), CAST(17.38 AS Decimal(5, 2)), 2, 5, 130200, 150011, 20140924)
GO
INSERT [SupplyChain].[tManufacturingMeasures_ToBeDeleted] ([PlantID], [AFCOMDT], [AFCOMDTPY], [RecordableMDT], [RecordableMDTPY], [InvCasesMDT], [InvCasesMDTPy], [AnchorDateID]) VALUES (19, CAST(17.00 AS Decimal(5, 2)), CAST(13.00 AS Decimal(5, 2)), 4, 9, 160200, 180011, 20140924)
GO
INSERT [SupplyChain].[tManufacturingMeasures_ToBeDeleted] ([PlantID], [AFCOMDT], [AFCOMDTPY], [RecordableMDT], [RecordableMDTPY], [InvCasesMDT], [InvCasesMDTPy], [AnchorDateID]) VALUES (20, CAST(17.00 AS Decimal(5, 2)), CAST(13.00 AS Decimal(5, 2)), 4, 9, 160200, 180011, 20140924)
GO
INSERT [SupplyChain].[tManufacturingMeasures_ToBeDeleted] ([PlantID], [AFCOMDT], [AFCOMDTPY], [RecordableMDT], [RecordableMDTPY], [InvCasesMDT], [InvCasesMDTPy], [AnchorDateID]) VALUES (21, CAST(17.00 AS Decimal(5, 2)), CAST(13.00 AS Decimal(5, 2)), 4, 9, 160200, 180011, 20140924)
GO
INSERT [SupplyChain].[tManufacturingMeasures_ToBeDeleted] ([PlantID], [AFCOMDT], [AFCOMDTPY], [RecordableMDT], [RecordableMDTPY], [InvCasesMDT], [InvCasesMDTPy], [AnchorDateID]) VALUES (22, CAST(17.00 AS Decimal(5, 2)), CAST(13.00 AS Decimal(5, 2)), 4, 9, 160200, 180011, 20140924)
GO
INSERT [SupplyChain].[tManufacturingMeasures_ToBeDeleted] ([PlantID], [AFCOMDT], [AFCOMDTPY], [RecordableMDT], [RecordableMDTPY], [InvCasesMDT], [InvCasesMDTPy], [AnchorDateID]) VALUES (26, CAST(17.00 AS Decimal(5, 2)), CAST(17.00 AS Decimal(5, 2)), 4, 4, 160200, 160200, 20140924)
GO
INSERT [SupplyChain].[tManufacturingMeasures_ToBeDeleted] ([PlantID], [AFCOMDT], [AFCOMDTPY], [RecordableMDT], [RecordableMDTPY], [InvCasesMDT], [InvCasesMDTPy], [AnchorDateID]) VALUES (24, CAST(17.00 AS Decimal(5, 2)), CAST(17.00 AS Decimal(5, 2)), 4, 4, 160200, 160200, 20140924)
GO
INSERT [SupplyChain].[tManufacturingMeasures_ToBeDeleted] ([PlantID], [AFCOMDT], [AFCOMDTPY], [RecordableMDT], [RecordableMDTPY], [InvCasesMDT], [InvCasesMDTPy], [AnchorDateID]) VALUES (27, CAST(17.00 AS Decimal(5, 2)), CAST(17.00 AS Decimal(5, 2)), 4, 4, 160200, 160200, 20140924)
GO


