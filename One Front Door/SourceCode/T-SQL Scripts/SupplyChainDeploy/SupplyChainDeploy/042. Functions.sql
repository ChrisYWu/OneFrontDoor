USE [Portal_Data]
GO

/****** Object:  UserDefinedFunction [SupplyChain].[udfConvertToDate]    Script Date: 11/19/2014 4:15:00 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create Function [SupplyChain].[udfConvertToDate]
(
	@DateID int
)
Returns Date
AS
Begin		
	Declare @S varchar(8)
	Declare @Temp varchar(10)
	Set @S = Convert(Varchar, @DateID)
	Set @Temp = Left(@S, 4) + '/' + Substring(@S, 5, 2) + '/' + Right(@S, 2)

	Return Convert(Date, @Temp);
End

GO

/****** Object:  UserDefinedFunction [SupplyChain].[udfConvertToDateID]    Script Date: 11/19/2014 4:15:36 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create Function [SupplyChain].[udfConvertToDateID]
(
	@Date Date
)
Returns Int
AS
Begin		

	Return DatePart(yy, @Date)*10000 + DatePart(m, @Date)*100 + DatePart(d, @Date);
End

GO

