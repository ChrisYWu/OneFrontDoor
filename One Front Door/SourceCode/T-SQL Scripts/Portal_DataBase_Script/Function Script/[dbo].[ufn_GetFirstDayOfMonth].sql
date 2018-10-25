USE [Portal_Data]
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_GetFirstDayOfMonth]    Script Date: 3/21/2013 5:45:59 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[ufn_GetFirstDayOfMonth] ( @pInputDate    DATETIME )
RETURNS DATETIME
BEGIN

    RETURN CAST(CAST(YEAR(@pInputDate) AS VARCHAR(4)) + '/' + 
                CAST(MONTH(@pInputDate) AS VARCHAR(2)) + '/01' AS DATETIME)

END

GO


