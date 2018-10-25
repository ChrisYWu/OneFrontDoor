
------- Done in 121 ----------------
USE [Portal_Data]
GO

CREATE TABLE [MSTR].[TransYTDDay](
	[DayDate] [datetime] NULL,
	[YTD_DayDate] [datetime] NULL,
	[LYTD_Date] [datetime] NULL
) ON [PRIMARY]
GO

Insert Into MSTR.TransYTDDay
Select * from BSCCAP108.Portal_Data.MSTR.TransYTDDay
Go

Create Clustered index CIX_TransYTDDay_DayDate_YTD_DayDate_LYTD_DayDate on MSTR.TransYTDDay(DayDate,YTD_DayDate,LYTD_Date)
Go

----------- 19, done in 121 as well ------
DROP TABLE [MSTR].[DimDay]
GO

CREATE TABLE [MSTR].[DimDay](
	[DayDate] [datetime] NOT NULL,
	[MonthID] [int] NULL,
	[QuarterID] [smallint] NULL,
	[YearID] [smallint] NULL,
	[PrevDayDate] [datetime] NULL,
	[LMDayDate] [datetime] NULL,
	[LQDayDate] [datetime] NULL,
	[LYDayDate] [datetime] NULL,
	[WeekID] [int] NULL,
	[LWDayDate] [datetime] NULL,
	[DayDesc] [varchar](50) NULL
) ON [PRIMARY]
GO

Insert Into MSTR.DimDay
Select * from BSCCAP108.Portal_Data.MSTR.DimDay;
Go

CREATE View [MSTR].[LocationHier]  
As  
Select BUName, SPBUName, SAPBUID, RegionName, SPRegionName,SAPRegionID, AreaName, SAPAreaID, SAPBranchID, BranchName, SPBranchName, bu.BUID, r.RegionID, a.AreaID, b.BranchID  
From SAP.BusinessUnit bu  
 Join SAP.Region r on bu.BUID = r.BUID  
 Join SAP.Area a on r.RegionID = a.RegionID
Join SAP.Branch b on a.AreaID = b.AreaID

GO

ALTER VIEW [MSTR].[ViewOFDDailyMetrics] 
AS SELECT pvt.BranchID,
MetricDate,
RecordDate,
coalesce ([M101],0) as 'SalesQty',
coalesce ([M102],0) as 'PreSales',
coalesce ([M103],0) as 'SalesQtyCNV',
coalesce ([M104],0) as 'LoadOut',
case when datediff(d,metricdate,getdate())=0 then 0 else coalesce([M104],0) end as 'LoadOutHB',
coalesce ([M105],0) as 'CaseCuts',
Abs(coalesce ([M402],0)) as 'BuyBack',
coalesce ([M201],0) as 'ShrinkageQty',
coalesce ([M202],0) as 'BreakageQty',
coalesce ([M203],0) as 'DOS',
Abs(coalesce ([M301],0)) as 'DamagesQty',
Abs(coalesce ([M302],0)) as 'Damages',
coalesce ([M204],0) as 'Shrinkage',
coalesce ([M205],0) as 'Breakage',
coalesce ([M208],0) as 'Inventory',
coalesce ([M401],0) as 'Haulback',
coalesce ([M701],0) as 'ActualStops',
coalesce ([M702],0) as 'PlannedStops',
coalesce ([M703],0) as 'ActualMiles',
coalesce ([M704],0) as 'PlannedMiles',
coalesce ([M705],0) as 'ActualTimeinMins',
coalesce ([M706],0) as 'PlannedTimeinMins',
coalesce ([M801],0) as 'TotalInvoices',
coalesce ([M802],0) as 'OnTimeInvoices'
FROM   (SELECT BranchID,MetricDate,RecordDate,MetricID,[Metric] 
        FROM   [Portal_Data].[mstr].[FactOFDDailyMetrics]
        ) src PIVOT (Max([METRIC])FOR METRICID
        IN ([M101],[M102],[M103],[M104],[M105],[M402],[M201],[M202],[M203],[M204],[M205],[M208],[M301],[M302],[M401],[M701],[M702],[M703],[M704],[M705],[M706],[M801],[M802])) pvt

--LoadOutHB - This calculation is to take into account when there are zero deliveries for today's date
GO

/* Creating Indexes on Transformation Tables */
Create Clustered index CIX_DimDay_DayDate on MSTR.DimDay(DayDate)
Create Clustered index CIX_DimWeek_WeekDate on MSTR.DimWeek(WeekDate)
Create Clustered index CIX_DimQuarter_QuarterDate on MSTR.DimQuarter(QuarterDate)
Create Clustered index CIX_DimYear_YearDate on MSTR.DimYear(YearDate)
Create Clustered index CIX_TransWTDDay_DayDate_WTDDayDate on MSTR.TransWTDDay(DayDate,WTDDayDate)
Create Clustered index CIX_TransMTDDay_DayDate_MTDDayDate on MSTR.TransMTDDay(DayDate,MTDDayDate)
Create Clustered index CIX_TransQTDDay_DayDate_QTDDayDate on MSTR.TransQTDDay(DayDate,QTDDayDate)

Go

------  done in 121 -----------------
/****** Object:  StoredProcedure [MSTR].[pBranchPlanRanking]    Script Date: 9/16/2013 1:34:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Muralidhar Busa>
-- Create date: <09/03/2013,,>
-- Description:	<Branch Plan Ranking update>
-- =============================================
ALTER PROCEDURE [MSTR].[pBranchPlanRanking] (@MonthID Int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	Delete from MSTR.FactMyDayBranchPlanRanking where monthid = @MonthID

	Insert into MSTR.FactMyDayBranchPlanRanking
	(MonthID, VersionID, RouteID, PlanCases, ActualSales, RecordDate)
	select p.monthid, p.versionid, p.routeid,p.plancases,a.actuals, getdate() 
	from
	(
	select fp.*
	FROM MSTR.FactMyDayRoutePlan fp 
		   inner join SAP.Route sr on fp.routeid=sr.routeid
	where fp.monthid = @MonthID and RouteTypeID=0
	)p
	left join
	(
	select rs.RouteID, sum(f.MTDConvertedCases) actuals
	from SAP.RouteSchedule rs 
		   inner join SAP.Route sr on rs.routeid = sr.routeid
		   inner join mstr.FactMyDayCustomer f on f.accountid = rs.accountid
	where f.monthid = @MonthID and RouteTypeID=0
	group by rs.RouteID)a on p.routeid=a.routeid

END


/****** Object:  StoredProcedure [MSTR].[pSpreadBranchPlan]    Script Date: 9/16/2013 1:34:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [MSTR].[pSpreadBranchPlan] (@monthId int) 
AS
BEGIN
set nocount on
/*******************************************************************************************************************  

Description:  This procedure will be run every month to spread the Sales Plan from the DimBranchplan down to the Sales Route level
Schema:  MSTR
--------------------------------------------------------------------------------------------------------------------  
Created By      :  Rajeev Unnikrishnan
Created Date    :  09-April-13
Tracker/Release :  
--------------------------------------------------------------------------------------------------------------------  
------------------------------------------------------------------------------------------------------------  
*********************************************************************************************/

	-- get all the plan versions used by different sales offices
	declare @versions int
	declare @versionid int
	declare @ctr int

	set @versions=0
	set @versionid=0
	set @ctr=0


	-- get the different plans and the plan versions
	create table #BranchPlans (monthid int, versionid int, branchid int, planvolume numeric(18,4))

	insert into #BranchPlans(monthid, versionid, branchid, planVolume)
	select bp.monthid, spv.versionid, bp.branchid, bp.planVolume 
	from MSTR.DimBranchplan bp inner join MSTR.RelMyDaySalesOfficePlanVersion spv on bp.branchid=spv.branchid
	where bp.monthid=@monthid

	-- get all different versions of branch plans - we will need to loop through this
	create table #versions (versionId int)
	insert into #versions
	select distinct versionid from #BranchPlans
	select @ctr=count(*) from #versions


	-- get the actual percent spreads for the routes in the sales offices
	create table #BranchPlanSpreads (branchid int, routeid int, sales numeric(18,4), percentMix numeric(18,10))

	while(@ctr<>0)
	begin
		select top 1 @versionid=versionId from #versions
		insert into #BranchPlanSpreads (branchId, routeid, sales)
		select s.branchid, rs.routeid,sum(f.MTDConvertedCases) sales
		from MSTR.FactMyDayCustomer f 
			inner join sap.routeSchedule rs on f.accountId=rs.accountId
			inner join sap.Route s on rs.RouteID=s.RouteID and s.RouteTypeID = 0
			inner join mstr.RelMyDaySalesOfficePlanVersion sopv on sopv.branchid=s.branchid and sopv.versionid=@versionid
		where MonthID in(select monthid from [MSTR].[udfMonthsForPlanSpread](@versionid))
		group by rs.routeid,s.branchid

		delete from #versions where versionid=@versionId
		select @ctr=count(*) from #versions
	end

	-- update the percentMix 
	update f
	set percentMix=f.sales/NullIf(f1.cs,0)
	from #BranchPlanSpreads f inner join (select branchid, sum(sales) cs from #BranchPlanSpreads group by branchid) f1 on f.branchid=f1.branchid

	

	delete from MSTR.FACTMyDayRoutePlan where monthid=@monthid

	insert into MSTR.FACTMyDayRoutePlan(RouteID, MonthID, VersionID, PlanCases, RecordDate)
	select routeid, @monthid, versionid, sp.percentMix*p.planVolume, getdate()
	from #BranchPlanSpreads sp inner join #BranchPlans p on p.branchid=sp.branchid
	

	drop table #BranchPlans
	drop table #BranchPlanSpreads
	drop table #versions
END
Go




