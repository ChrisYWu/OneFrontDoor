USE [Portal_Data]
GO
/****** Object:  StoredProcedure [ETL].[pMergePlantInventory]    Script Date: 1/8/2015 9:46:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* 
exec ETL.pMergePlantInventory
exec ETL.pMergePlantInventory 1


----- Current Agent Job Steps ------
exec ETL.pMergeDSDDailyBranchInventory
exec ETL.pMergeDSDDailyMinMax
exec ETL.pMergePlantInventory
------------------------------------

select Distinct DateID from SupplyChain.tPlantInventory Order By DateID

*/

ALTER Proc [ETL].[pMergePlantInventory]
(
	@Refreshall bit = 0
)
AS		
	Set NoCount On;
	--Declare @Refreshall int
	--Set @Refreshall = 1

	Declare @ForceDataReload bit
	Declare @MaxDatePlantInventory int
	Declare @MaxDateStaging int

	Select @ForceDataReload = Convert(bit, ConfigValue)
	From Settings.Configuration
	Where ConfigKey = 'ForceSCDataReload'

	Select @MaxDatePlantInventory = Max(DateID) From SupplyChain.tPlantInventory
	Select @MaxDateStaging = Max(CalendarDate) From Staging.BP7DailyPlantInventory

	--- The ForceDataReload flag even suppress @RefreshAll
	If (@ForceDataReload = 0 And (@MaxDatePlantInventory = @MaxDateStaging))
	Begin
		Select 'Early Return' As Result
		Return
	End
	Else
		
	Begin
		--------- ELSE BRANCH --------------
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
		Where SAPSource = 'SP7'

		Insert Into @AllPlant
		Select PlantID, PlantDesc, 1404, SAPSource
		From SupplyChain.Plant
		Where SAPPlantNumber = 1403
		--------------------------------------
		--------------------------------------

		If (@Refreshall = 0) 
		Begin
			Delete cc
			From SupplyChain.tPlantInventory cc
			Where cc.DateID in (
				Select Distinct CalendarDate
				From Staging.BP7DailyPlantInventory
			)
		End
		Else
		Begin
			Truncate Table SupplyChain.tPlantInventory
		End

		Declare @DateRangeInStaging Table
		(
			CalendarDate int
		)
		Insert @DateRangeInStaging
		Select Distinct CalendarDate
		From Staging.BP7DailyPlantInventory

		----------------------------------------------------
		Insert Into SupplyChain.tPlantInventory
		(	
			DateID,
			LYDateID,
			PlantID,
			TradeMarkID,
			BrandID,
			MaterialID,
			PackageID,
			PackageConfID,
			PackageTypeID,
			Quantity,
			TransferOut,
			CustomerShipment
		)
		Select inv.CalendarDate, 
			SupplyChain.udfConvertToDateID(DATEADD(year, -1, SupplyChain.udfConvertToDate(inv.CalendarDate))) LYCalendarDate,
			plt.PlantID, b.TrademarkID, b.BrandID, m.MaterialID, p.PackageID, p.PackageConfID, p.PackageTypeID, 
			Sum(inv.EndingInventory), Sum(inv.TransferOut), Sum(inv.CustomerShipment)
		From SAP.BP7PlantInventory inv
		Join SAP.Material m on inv.SAPMaterialID = m.SAPMaterialNumber
		Join @AllPlant plt on inv.SAPPlantNumber = plt.SAPPlantNumber
		Join SAP.Brand b on m.BrandID = b.BrandID
		Join SAP.Package p on m.PackageID = p.PackageID
		Where 
		(@Refreshall = 1)
		Or
		(CalendarDate in (Select CalendarDate From @DateRangeInStaging))
		Group By inv.CalendarDate, plt.PlantID, b.TrademarkID, b.BrandID, m.MaterialID, p.PackageID, p.PackageConfID, p.PackageTypeID

		Update ty
		Set LYQuantity = ly.Quantity, LYCustomerShipment = ly.CustomerShipment, LYTransferOut = ly.TransferOut
		From SupplyChain.tPlantInventory ty
		Join
		SupplyChain.tPlantInventory ly on ty.LYDateID = ly.DateID And ty.MaterialID = ly.MaterialID and ty.PlantID = ly.PlantID
		Where 
		(@Refreshall = 1)
		Or
		(ty.DateID in (
				Select CalendarDate
				From @DateRangeInStaging
			)
		)
		--------- END OF ELSE BRANCH --------------
	End

Go