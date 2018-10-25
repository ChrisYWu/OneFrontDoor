USE [Portal_Data]
GO

/****** Object:  StoredProcedure [dbo].[P_getTimerJOBdetails]    Script Date: 3/21/2013 5:57:27 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE Procedure
[dbo].[P_getTimerJOBdetails]
(
 @timerjob datetime
)


as
begin
/*******************************************************************************************************************  
Description:  This procedure used to display data for TIMER JOB RELATED.  
Schema:  
--------------------------------------------------------------------------------------------------------------------  
Created By      :  Dilip Singh
Created Date    :  15-March-13
Tracker/Release :  
--------------------------------------------------------------------------------------------------------------------  
------------------------------------------------------------------------------------------------------------  
*********************************************************************************************/

create table #displaydata(ProgramNumber int null,StartDate datetime null,ItemID varchar(100) null,EndDate datetime null,
AccountName varchar(150) null,ChannelName varchar(100) null,AttachmentID varchar(120) null,FileName varchar(128) null,
PhysicalFile varbinary(max) null,BrandName varchar(2000) null)

insert into #displaydata(ProgramNumber,StartDate,ItemID,EndDate,AccountName,ChannelName,AttachmentID,FileName,PhysicalFile)

select a.ProgramNumber,a.StartDate,a.ItemID,a.EndDate,b.AccountName,c.ChannelName,d.AttachmentID,
d.FileName,d.PhysicalFile from EDGE.RPLItem a inner join [EDGE].[RPLItemAccount] b
on a.ItemID=b.ItemID
inner join [EDGE].[RPLItemChannel] c
ON  a.ItemID=c.ItemID
inner join [EDGE].[RPLAttachment] d
on a.ItemID=d.ItemID
where a.ModifiedDateUTC >=@timerjob


create table #working1 (ItemID VARCHAR(50) NOT NULL,BrandName varchar(2000) null)
insert into #working1(ItemID,BrandName)
SELECT p1.ItemID,

       stuff( (SELECT ','+BrandName 

               FROM [EDGE].RPLItemBrand p2

               WHERE p2.ItemID = p1.ItemID
              

               ORDER BY BrandName

               FOR XML PATH(''), TYPE).value('.', 'varchar(max)')

            ,1,1,'')

       AS BrandName

      FROM EDGE.RPLItem p1   where   p1.ModifiedDateUTC >=@timerjob   ---@ROUTEDATE

      GROUP BY ItemID ;

update  a
set  a.BrandName=b.BrandName
from #displaydata a inner join #working1 b
on a.ItemID=b.ItemID


select ProgramNumber,StartDate,ItemID,EndDate,AccountName,ChannelName,AttachmentID,FileName,PhysicalFile,BrandName
from #displaydata



end 


GO


