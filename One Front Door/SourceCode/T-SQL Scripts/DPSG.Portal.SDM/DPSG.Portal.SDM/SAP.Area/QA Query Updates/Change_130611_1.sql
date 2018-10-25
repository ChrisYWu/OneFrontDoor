--- executed

Use Portal_Data
Go

ALTER Proc [Playbook].[pGetRoutePromotions]
(
	@routeNumber varchar(20),
	@promotionStartDate SmallDateTime
)
As


/*
Declare @startDAte smallDateTime-102601180
Set @startDate = DateAdd(Day, 1, GetDate())

exec Playbook.pGetRoutePromotions @routeNumber = 113301110

      , @promotionStartDate = '06-25-2013'

SELECT * FROM [MVIEW].[AccountRouteSchedule]   WHERE NATIONALCHAINID=99

*/

Set NoCount On;
Declare @PromotionCount int
Declare @AccountPromotions TABLE (
	[PromotionID] [int] NULL,
	[PromotionType] [varchar](185) NOT NULL,
	[PromotionCategory] [varchar](150) NOT NULL,
	[PromotionStartDate] [date] NULL,
	[PromotionEndDate] [date] NULL,
	[PromotionName] [varchar](180) NULL,
	[PromotionPrice] [varchar](150) NULL,
	[PromotionDisplayLocation] [varchar](200) NULL,
	--[promotionDisplayLocationOther] [varchar](200) NULL,
	[ProgramName] [varchar](150) NULL,
	[PromotionRank] [int] NULL,
	[SAPAccountNumber] [bigint] NOT NULL,
	[NationalChainName] [varchar](30) NULL,
	[SAPNationalChainID] [int] NULL,
	[RegionalChainName] [varchar](50) NOT NULL,
	[SAPRegionalChainID] [int] NULL,
	[LocalChainName] [varchar](50) NOT NULL,
	[SAPLocalChainID] [int] NULL,
	[ChannelName] [varchar](50) NULL,
	[SAPChannelID] [varchar](50) NOT NULL,
	[SAPBranchID] [varchar](50) NOT NULL,
	[BranchName] [varchar](50) NULL,
	[AccountID] [int] not NULL,
	[MySplashNetEnabled] [bit] NULL,
    [PromotionDescription] [varchar](250) null
) 
Declare @AccountPromMapping TABLE (
	[SAPAccountNumber] [bigint] NOT NULL,
	[PromotionID] [int] NULL,
	[NationalChainName] [varchar](30) NULL,
	[SAPNationalChainID] [int] NULL,
	[RegionalChainName] [varchar](50) NOT NULL,
	[SAPRegionalChainID] [int] NULL,
	[LocalChainName] [varchar](50) NOT NULL,
	[SAPLocalChainID] [int] NULL,
	[ChannelName] [varchar](50) NULL,
	[SAPChannelID] [varchar](50) NOT NULL,
	[AccountID] [int] NOT NULL
)
Declare @Promotion Table(
	[PromotionID] [int] NULL,
	[PromotionType] [varchar](185) NOT NULL,
	[PromotionCategory] [varchar](150) NOT NULL,
	[PromotionStartDate] [date] NULL,
	[PromotionEndDate] [date] NULL,
	[PromotionName] [varchar](180) NULL,
	[PromotionPrice] [varchar](150) NULL,
	[PromotionDisplayLocation] [varchar](200) NULL,
	--[promotionDisplayLocationOther] [varchar](200) NULL,
	[ProgramName] [varchar](150) NULL,
	[PromotionRank] [int] NULL,
	[NationalChainName] [varchar](30) NULL,
	[SAPNationalChainID] [int] NULL,
	[RegionalChainName] [varchar](50) NOT NULL,
	[SAPRegionalChainID] [int] NULL,
	[LocalChainName] [varchar](50) NOT NULL,
	[SAPLocalChainID] [int] NULL,
	[ChannelName] [varchar](50) NULL,
	[SAPChannelID] [varchar](50) NOT NULL,
	[PromotionDescription] [varchar](250) NOT NULL
)
Declare @PromotionRegional Table(
	[PromotionID] [int] NULL,
	[PromotionType] [varchar](185) NOT NULL,
	[PromotionCategory] [varchar](150) NOT NULL,
	[PromotionStartDate] [date] NULL,
	[PromotionEndDate] [date] NULL,
	[PromotionName] [varchar](180) NULL,
	[PromotionPrice] [varchar](150) NULL,
	[PromotionDisplayLocation] [varchar](200) NULL,
	[ProgramName] [varchar](150) NULL,
	[PromotionRank] [int] NULL,
	[NationalChainName] [varchar](30) NULL,
	[SAPNationalChainID] [int] NULL,
	[RegionalChainName] [varchar](50) NOT NULL,
	[SAPRegionalChainID] [int] NULL,
	[LocalChainName] [varchar](50)  NULL,
	[SAPLocalChainID] [int] NULL,
	--[SPChannelName] [varchar](50) NULL,
	[SAPChannelID] [varchar](50) NULL
)
Declare @PromotionLocal Table(
	[PromotionID] [int] NULL,
	[PromotionType] [varchar](185) NOT NULL,
	[PromotionCategory] [varchar](150) NOT NULL,
	[PromotionStartDate] [date] NULL,
	[PromotionEndDate] [date] NULL,
	[PromotionName] [varchar](180) NULL,
	[PromotionPrice] [varchar](150) NULL,
	[PromotionDisplayLocation] [varchar](200) NULL,
	[ProgramName] [varchar](150) NULL,
	[PromotionRank] [int] NULL,
	[NationalChainName] [varchar](30) NULL,
	[SAPNationalChainID] [int] NULL,
	[RegionalChainName] [varchar](50) NOT NULL,
	[SAPRegionalChainID] [int] NULL,
	[LocalChainName] [varchar](50) NOT NULL,
	[SAPLocalChainID] [int] NULL,
	--[SPChannelName] [varchar](50) NULL,
	[SAPChannelID] [varchar](50)  NULL
)
Declare @PromotionNational Table(
	[PromotionID] [int] NULL,
	[PromotionType] [varchar](185) NOT NULL,
	[PromotionCategory] [varchar](150) NOT NULL,
	[PromotionStartDate] [date] NULL,
	[PromotionEndDate] [date] NULL,
	[PromotionName] [varchar](180) NULL,
	[PromotionPrice] [varchar](150) NULL,
	[PromotionDisplayLocation] [varchar](200) NULL,
	[ProgramName] [varchar](150) NULL,
	[PromotionRank] [int] NULL,
	[NationalChainName] [varchar](30) NULL,
	[SAPNationalChainID] [int] NULL,
	[RegionalChainName] [varchar](50)  NULL,
	[SAPRegionalChainID] [int] NULL,
	[LocalChainName] [varchar](50) NULL,
	[SAPLocalChainID] [int] NULL,
	--[SPChannelName] [varchar](50) NULL,
	[SAPChannelID] [varchar](50)  NULL
)


Declare @PromotionAttachment table(
	[AttachmentType] [varchar](150) NULL,
	[AttachmentURL] [varchar](2500) NULL,
	[AttachmentName] [varchar](200) NULL,
	[AttachmentSize] [int] NULL,
	[AttachmentDocumentID] [nvarchar](50) NULL,
	[PromotionID] [int] NULL,
	[AttachmentDateModified] [datetime] NULL
)
Declare @PromotionPackage table (
	[PromotionID] [int] NULL,
	[PackageID] [int] NOT NULL,
	[SAPPackageID] [varchar](10) NULL,
	[PackageName] [varchar](100) NOT NULL
)
Declare @PromotionBrand TABLE(
	[PromotionID] [int] NULL,
	[SAPBrandID] [varchar](50)  NULL,
	[BrandName] [varchar](128)  NULL,
	[BrandID] [int]  NOT NULL
)



Insert Into @AccountPromotions
Select distinct  P.PromotionID, pt.PromotionType, pc.PromotionCategoryName, p.PromotionStartDate, p.PromotionEndDate, p.PromotionName, p.PromotionPrice,
	-- dl.DisplayLocationName,
	 case when dl.DisplayLocationID  =  23 
			then (select PromotionDisplayLocationOther from playbook.PromotionDisplayLocation where promotionid=p.promotionid)   
		when dl.DisplayLocationID  < 23 then 
			(dl.DisplayLocationName)  
	end 
	,'ProgramName'  as ProgramName,
	--cp.ProgramName,
	pr.[Rank], s.SAPAccountNumber, 
	   s.NationalChainName, s.SAPNationalChainID, s.RegionalChainName
      ,s.SAPRegionalChainID
      ,s.LocalChainName
      ,s.SAPLocalChainID
      ,s.ChannelName
      ,s.SAPChannelID, s.SAPBranchID
      ,s.BranchName,s.Accountid,s.MySplashNetEnabled,P.PROMOTIONDESCRIPTION
From [MView].[AccountRouteSchedule] s
left join Playbook.PromotionAccount pa on (s.NationalChainID = pa.NationalChainID Or s.RegionalChainID = pa.RegionalChainID Or s.LocalChainID = pa.LocalChainID )
left Join Playbook.RetailPromotion p on  p.PromotionID = pa.PromotionID
Join Playbook.PromotionType pt on p.PromotionTypeID = pt.PromotionTypeID
Join Playbook.PromotionCategory pc on p.PromotionCategoryID = pc.PromotionCategoryID
left Join PlayBook.PromotionDisplayLocation pdl on p.PromotionID=pdl.PromotionID
Left Join Playbook.DisplayLocation dl on pdl.DisplayLocationID = dl.DisplayLocationID

--Left Join PlayBook.CorporatePriority cp on cp.CorporatePriorityID = p.CorporatePriorityID
Left Join [PlayBook].[PromotionRank] pr on pr.PromotionID = p.PromotionID 
Where SAPRouteNumber = @routeNumber
and @promotionStartDate between PromotionstartDate and PromotionEndDate
And PromotionEndDate >= GetDate()
And PromotionstartDate <= GetDate()
And PromotionEndDate between CONVERT(VARCHAR(10),GETDATE(),121) and convert(varchar(10),dateadd(day,14,@promotionStartDate),121) 
And PromotionStatusID = 4 -- only approved promotion goes
and GetDate() between PromotionWeekStart and PromotionWeekEnd

--Order By StopSequence

--select * from @AccountPromotions

---- Promotion master

Insert Into @AccountPromMapping
Select SAPAccountNumber, PromotionID, 
NationalChainName,  SAPNationalChainID,  RegionalChainName
      ,SAPRegionalChainID
      ,LocalChainName
      ,SAPLocalChainID, 
	  ChannelName,
      SAPChannelID,
	  AccountID
From @AccountPromotions 
--where MySplashNetEnabled=1





Insert Into @Promotion


Select Distinct PromotionID, PromotionType, PromotionCategory, PromotionStartDate, PromotionEndDate, PromotionName, PromotionPrice, 
	PromotionDisplayLocation, ProgramName,isnull( PromotionRank,0),NationalChainName,SAPNationalChainID,RegionalChainName  ,SAPRegionalChainID,LocalChainName,SAPLocalChainID,ChannelName,
	SAPChannelID,PROMOTIONDESCRIPTION
From @AccountPromotions  
--where MySplashNetEnabled=1

--Insert Into @PromotionNational
--Select Distinct PromotionID, PromotionType, PromotionCategory, PromotionStartDate, PromotionEndDate, PromotionName, PromotionPrice, 
--	PromotionDisplayLocation, ProgramName,isnull( PromotionRank,0),r.NationalChainName ,r.SAPNationalChainID,null as RegionalChainName ,NULL AS SAPRegionalChainID,NULL AS LocalChainName,NULL AS SAPLocalChainID,NULL AS SPChannelName,
--	NULL AS SAPChannelID
--From @AccountPromotions p
--Join [MView].[ChainHier] r on r.SAPNationalChainID=p.SAPNationalChainID
-- where p.PromotionType='National'


--Insert Into @PromotionRegional
--Select Distinct PromotionID, PromotionType, PromotionCategory, PromotionStartDate, PromotionEndDate, PromotionName, PromotionPrice, 
--	PromotionDisplayLocation, ProgramName,isnull( PromotionRank,0),r.NationalChainName,r.SAPNationalChainID,r.RegionalChainName  ,r.SAPRegionalChainID,NULL AS LocalChainName,NULL AS SAPLocalChainID,NULL AS SPChannelName,
--	NULL AS SAPChannelID
--From @AccountPromotions p 
--Join [MView].[ChainHier] r on r.SAPregionalChainID=p.SAPregionalChainID

 -- where p.PromotionType='Regional'


--  Insert Into @PromotionLocal
--Select Distinct PromotionID, PromotionType, PromotionCategory, PromotionStartDate, PromotionEndDate, PromotionName, PromotionPrice, 
--	PromotionDisplayLocation, ProgramName,isnull( PromotionRank,0),r.NationalChainName,r.SAPNationalChainID,r.RegionalChainName  ,r.SAPRegionalChainID,r.LocalChainName,r.SAPLocalChainID,NULL AS SPChannelName,
--	NULL AS SAPChannelID
--From @AccountPromotions p 
--Join [MView].[ChainHier] r on r.SAPLocalChainID=p.SAPLocalChainID

--  where p.PromotionType='Local'







-- Attachments
Insert @PromotionAttachment
Select AttachmentTypeName, pa.AttachmentURL+'/'+pa.AttachmentName as AttachmentURL,AttachmentName, AttachmentSize, AttachmentDocumentID,pa.promotionid,pa.AttachmentDateModified
From Playbook.PromotionAttachment pa
Join Playbook.AttachmentType at on pa.AttachmentTypeID = at.AttachmentTypeID
Join @Promotion p on p.PromotionID = pa.PromotionID
 
--- Promotion Pakcage
Insert @PromotionPackage
Select distinct pr.PromotionID, p.PackageID, p.RMPackageID SAPPackageID, p.PackageName
From Playbook.PromotionPackage pp
Join SAP.Package p on pp.PackageID = p.PackageID
Join @Promotion pr on pr.PromotionID = pp.PromotionID
 
--- Promotion Brand
Insert @PromotionBrand
Select pr.PromotionID, b.SAPBrandID, BrandName,isnull(pb.BrandID,0)
From Playbook.PromotionBrand pb
Join SAP.Brand b on pb.BrandID = b.BrandID
Join @Promotion pr on pr.PromotionID = pb.PromotionID
Insert @PromotionBrand
Select pr.PromotionID, b.SAPTrademarkID, TrademarkName,isnull(pb.BrandID,0)
From Playbook.PromotionBrand pb
Join SAP.TradeMark b on pb.TradeMarkID = b.TradeMarkID
Join @Promotion pr on pr.PromotionID = pb.PromotionID

--------Output --------------
-----------------------------
Select distinct PromotionID,SAPAccountNumber,AccountID
-- NationalChainName, 
-- SAPNationalChainID, 
-- RegionalChainName
      --,SAPRegionalChainID
      --,LocalChainName
      --,SAPLocalChainID, SPChannelName
      --,SAPChannelID
From @AccountPromMapping



Select PromotionID, PromotionType, PromotionCategory, PromotionStartDate, PromotionEndDate, PromotionName, PromotionPrice, 
	PromotionDisplayLocation ,ProgramName, 

PromotionRank,NationalChainName,SAPNationalChainID,RegionalChainName,SAPRegionalChainID
	,LocalChainName,SAPLocalChainID ,SAPChannelID, ChannelName,PromotionDescription

From @Promotion







Select PromotionID,AttachmentType, AttachmentURL, AttachmentName, AttachmentSize, AttachmentDocumentID,AttachmentDateModified From @PromotionAttachment
Select distinct PromotionID, PackageID, SAPPackageID, PackageName From @PromotionPackage
Select distinct PromotionID, SAPBrandID, BrandName,BrandID From @PromotionBrand
Select MydayStatusCode,MydayStatusMessage From PlayBook.MydayStatus
Select @PromotionCount=count(*) From @AccountPromotions



if( @PromotionCount=0)
Select MydayStatusCode,MydayStatusMessage From PlayBook.MydayStatus Where MydayStatusCode='1'
else if ((Select Count(*) from @Promotion) =0)
Select MydayStatusCode,MydayStatusMessage From PlayBook.MydayStatus Where MydayStatusCode='4'
else
Select MydayStatusCode,MydayStatusMessage From PlayBook.MydayStatus Where MydayStatusCode='0'

Select distinct SAPAccountNumber,AccountID,ChannelName From @AccountPromMapping 

-- where PromotionId=1426  
--And MySplashNetEnabled =1   --Currently checking for null(as no data available) but in future it wil be =1 to get the actual data


--select * from @PromotionNational

--select * from @PromotionRegional


--select * from @PromotionLocal





