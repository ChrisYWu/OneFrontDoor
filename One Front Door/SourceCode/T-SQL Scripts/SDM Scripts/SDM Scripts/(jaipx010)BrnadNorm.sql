use portal_data
go
/*
Select distinct FranchisorID, Franchisor
From BWStaging.MaterialBrandPKG where FranchisorID <>'#'


--Declare Franchisor Table
use portal_data
go

declare @F table
(
FranchisorID varchar(50),
Franchisor nvarchar(200)
)

insert @F
Select distinct FranchisorID, Franchisor
From BWStaging.MaterialBrandPKG where FranchisorID <>'#'

merge SAP.Franchisor as F
using (select FranchisorID,Franchisor from @F) as input
on F.FranchisorID=input.FranchisorID
when Matched then
update set F.Franchisor=dbo.udf_TitleCase(input.Franchisor)
when not matched by Target then 
insert (FranchisorID,Franchisor)
values (Input.FranchisorID, dbo.udf_TitleCase(input.Franchisor));
Go
--- Bev Type

use portal_data
go
*/
declare @B table
(
FranchisorID varchar(50),
BevTypeID varchar(50),
BevType nvarchar(200)
)

insert @B
Select distinct FranchisorID, BevTypeID,BevType
From BWStaging.MaterialBrandPKG where FranchisorID <>'#'



merge SAP.BevType as BT
using (select B.BevTypeID,B.BevType, sf.FranchisorID from @B B join sap.Franchisor SF on B.FranchisorID=sf.FranchisorID ) as input
on BT.BevTypeID=input.BevTypeID AND BT.FranchisorID=input.FranchisorID
when Matched then
update set BT.BevType=dbo.udf_TitleCase(input.BevType)
when not matched by Target then 
insert (FranchisorID,BevTypeID,BevType)
values (input.FranchisorID, input.BevTypeID,dbo.udf_TitleCase(input.BevType));
Go

--- TradeMark 
use portal_data
go
declare @T table
(
BevTypeID varchar(50),
TradeMarkID varchar(50),
TradeMark nvarchar(200)
)

insert @T
Select distinct BevTypeID, TradeMarkID,TradeMark
From BWStaging.MaterialBrandPKG where BevTypeID <>'#'

merge SAP.TradeMark as TM

using (select distinct T.TradeMarkID,T.TradeMark, sf.BevTypeID from @T T join sap.BevType SF on T.BevTypeID=sf.BevTypeID ) as input

on TM.TradeMarkID=input.TradeMarkID AND TM.BevTypeID=input.BevTypeID

when Matched then

update set TM.TradeMark=dbo.udf_TitleCase(input.TradeMark)

when not matched by Target then 

insert (BevTypeID,TradeMarkID,TradeMark)

values (input.BevTypeID, input.TradeMarkID,dbo.udf_TitleCase(input.TradeMark));
Go

--Brand
use portal_data
go
declare @BrandTemp table
(
TradeMarkID varchar(50),
BrandID varchar(50),
Brand nvarchar(200)
)

insert @BrandTemp
Select distinct TradeMarkID, BrandID,Brand
From BWStaging.MaterialBrandPKG where TrademarkID <>'#'

merge SAP.Brand as BM

using (select distinct T.BrandID,T.Brand, sf.TrademarkID from @BrandTemp T join sap.Trademark SF on T.TrademarkID=sf.TrademarkID ) as input

on BM.SAPBrandID=input.BrandID --AND BM.TrademarkID=input.TrademarkID

when Matched then

update set BM.BrandName=dbo.udf_TitleCase(input.Brand)

when not matched by Target then 

insert (SAPBrandID,BrandName,TradeMarkID)

values (input.BrandID, dbo.udf_TitleCase(input.Brand),input.TradeMarkID);
Go

--Flavor

use portal_data
go
declare @FlavorTemp table
(
BrandID varchar(50),
FlavorID varchar(50),
Flavor nvarchar(200)
)

insert @FlavorTemp
Select distinct BrandID, FlavorID,Flavor
From BWStaging.MaterialBrandPKG where BrandID <>'#'


merge SAP.Flavor as BF

using (select distinct T.FlavorID,T.Flavor, sf.SAPBrandID from @FlavorTemp T join sap.Brand SF on T.BrandID=sf.SAPBrandID) as input

on BF.FlavorID=input.FlavorID and  BF.BrandID=input.SAPBrandID

when Matched then

update set BF.flavor=dbo.udf_TitleCase(input.Flavor)

when not matched by Target then 

insert (FlavorID,Flavor,BrandID)

values (input.FlavorID, dbo.udf_TitleCase(input.Flavor),input.SAPBrandID);
Go


--Package Type

use portal_data
go
declare @PackTemp table
(
FlavorID varchar(50),
PackTypeID varchar(50),
PackType nvarchar(200)
)

insert @PackTemp
Select distinct flavorID,packtypeid,packtype 
From BWStaging.MaterialBrandPKG where flavorID <>'#'

--select distinct T.PackTypeId,T.PackType, sf.flavorid from @PackTemp T join sap.Flavor SF on T.flavorID=sf.flavorID

merge SAP.packagetype as BF

using (select distinct T.PackTypeId,T.PackType, sf.flavorid from @PackTemp T join sap.Flavor SF on T.flavorID=sf.flavorID) as input

on BF.PackTypeID=input.PackTypeID and BF.flavorID=input.flavorID

when Matched then

update set BF.PackageTypeName=dbo.udf_TitleCase(input.packtype)

when not matched by Target then 

insert (Packtypeid,PackageTypeName,flavorID)

values (input.packtypeid, dbo.udf_TitleCase(input.packtype),input.flavorID);
Go

-- PackConfig
insert SAP.PackageConf
Select distinct packconfid,packconf , packtypeID
From BWStaging.MaterialBrandPKG where packtypeID <>'#'


--Account

