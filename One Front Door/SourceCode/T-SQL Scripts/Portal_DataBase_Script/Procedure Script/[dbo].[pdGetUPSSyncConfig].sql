USE [Portal_Data]
GO

/****** Object:  StoredProcedure [dbo].[pdGetUPSSyncConfig]    Script Date: 3/21/2013 6:04:05 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[pdGetUPSSyncConfig] 
@ColumnName varchar(128)=NULL, @SPProperty varchar(128)=NULL
as
select * from Person.UPSSyncConfig 
where ColumnName=@ColumnName and SPProperty=@SPProperty

GO


