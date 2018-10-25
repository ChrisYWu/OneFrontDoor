Use Portal_Data
Go

--Update Shared.DimDate
--Set 
--Last31DaysBeginingDateID = [SupplyChain].[udfConvertToDateID](DateAdd(dd,-30,[Date]))
--Go

------------------------------------
Declare Date_Cursor Cursor For
Select Distinct Session_Date
From [BSCCAP121].[Portal_Data].[Apacheta].[FleetLoader]

Declare @CurrentDate Date

Open Date_Cursor
Fetch Next From Date_Cursor Into @CurrentDate

While @@Fetch_Status = 0
Begin
	Select @CurrentDate [ProcessingDate];

	INSERT INTO [Apacheta].[FleetLoader]
	Select *
	From [BSCCAP121].[Portal_Data].[Apacheta].[FleetLoader]
	Where Session_Date = @CurrentDate

	Fetch Next From Date_Cursor Into @CurrentDate
End

Close Date_Cursor
Deallocate Date_Cursor
Go

-------------------------------
Declare @CurrentDate varchar(50)

Declare Date_Cursor Cursor For
Select Distinct CalendarDate
From [BSCCAP121].[Portal_Data].[SAP].[BP7PlantInventory]

Open Date_Cursor
Fetch Next From Date_Cursor Into @CurrentDate

While @@Fetch_Status = 0
Begin
	Select @CurrentDate [ProcessingDate];

	INSERT INTO [SAP].[BP7PlantInventory]
	Select *
	From [BSCCAP121].[Portal_Data].[SAP].[BP7PlantInventory]
	Where CalendarDate = @CurrentDate

	Fetch Next From Date_Cursor Into @CurrentDate
End

Close Date_Cursor
Deallocate Date_Cursor
Go

------------------------
--INSERT INTO [Apacheta].[OriginalOrder]
--Select *
--From [BSCCAP121].[Portal_Data].[Apacheta].[OriginalOrder]
--GO

-------------------------
Declare @CurrentDate varchar(50)

Declare Date_Cursor Cursor For
Select Distinct CalendarDate
From [BSCCAP121].[Portal_Data].[SAP].[BP7SalesOfficeInventory]

Open Date_Cursor
Fetch Next From Date_Cursor Into @CurrentDate

While @@Fetch_Status = 0
Begin
	Select @CurrentDate [ProcessingDate];

	INSERT INTO [SAP].[BP7SalesOfficeInventory]
	Select *
	From [BSCCAP121].[Portal_Data].[SAP].[BP7SalesOfficeInventory]
	Where CalendarDate = @CurrentDate

	Fetch Next From Date_Cursor Into @CurrentDate
End

Close Date_Cursor
Deallocate Date_Cursor
Go

---------------------------
Declare @CurrentDate varchar(50)

Declare Date_Cursor Cursor For
Select Distinct CalendarDate
From [BSCCAP121].[Portal_Data].[SAP].[BP7SalesOfficeMinMax]

Open Date_Cursor
Fetch Next From Date_Cursor Into @CurrentDate

While @@Fetch_Status = 0
Begin
	Select @CurrentDate [ProcessingDate];

	INSERT INTO [SAP].[BP7SalesOfficeMinMax]
	Select *
	From [BSCCAP121].[Portal_Data].[SAP].[BP7SalesOfficeMinMax]
	Where CalendarDate = @CurrentDate

	Fetch Next From Date_Cursor Into @CurrentDate
End

Close Date_Cursor
Deallocate Date_Cursor
Go

--- Install the package and run the script?


---- Plant Inventory is working with raw data, no merging logic or filling logic
