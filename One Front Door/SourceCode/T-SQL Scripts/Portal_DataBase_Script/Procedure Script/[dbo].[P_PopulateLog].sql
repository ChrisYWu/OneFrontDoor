USE [Portal_Data]
GO

/****** Object:  StoredProcedure [dbo].[P_PopulateLog]    Script Date: 3/21/2013 5:58:39 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Sumit Kanchan
-- Create date: 18/March/2013
-- Description:	This will insert the error in the error table
-- =============================================
CREATE PROCEDURE [dbo].[P_PopulateLog]
@ErrorMessgae varchar(255),
@ErrorDate datetime,
@ContentID varchar(210),
@ErrorCode varchar(85)

AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Insert into EDGE.ErrorHandler(ErrorCode,ErrorMessgae,ErrorDate,ContentID)
	Values(@ErrorCode,@ErrorMessgae,@ErrorDate,@ContentID)

END

GO


