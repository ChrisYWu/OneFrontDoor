USE [Portal_Data]
GO

/****** Object:  StoredProcedure [dbo].[pdGetADExtractData]    Script Date: 3/21/2013 6:00:29 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[pdGetADExtractData] @UserID varchar(50)=NULL, @Title varchar(50)=NULL
as
select * from HRStaging.ADExtractData a
where a.UserID=@UserID and a.Title LIKE '%' +@Title + '%' 
and (a.status=3 or a.status=1)

GO


