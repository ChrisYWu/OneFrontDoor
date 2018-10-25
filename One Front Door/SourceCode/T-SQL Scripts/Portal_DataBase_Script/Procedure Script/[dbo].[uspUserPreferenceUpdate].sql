USE [Portal_Data]
GO

/****** Object:  StoredProcedure [dbo].[uspUserPreferenceUpdate]    Script Date: 3/21/2013 6:07:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[uspUserPreferenceUpdate]
@GSN varchar(50),
@PrimaryBranchId int,
@PrimaryBranch [varchar](500) = NULL,
@AdditionalBranch [varchar](5000) = NULL,
@KPI varchar(5000)= null,
@ErrorMessage varchar(200) OUTPUT,
@Error bit OUTPUT

AS
--Begin SP
Begin

Begin try
Begin TRAN
	-- Update UserProfile.SPUserProfile table 
	Update Person.SPUserProfile
	SET PrimaryBranch = @PrimaryBranch, AdditionalBranch = @AdditionalBranch,
	KPI = @KPI where GSN = @GSN
   
	Update Person.UserProfiles
	SET  PrimaryBranchID = @PrimaryBranchId where GSN = @GSN
		
	SET @Error = -1
COMMIT
End Try

--Begin Catch
Begin Catch

	SET @Error = 0
	SET @ErrorMessage = 'Error Occurred in executing uspUserPreferenceUpdate SP'
End Catch;

End
--SP End


GO


