use Portal_Data
Go

--- Working Table ----
Declare @Mapping Table
(
	BottlerID int,
	StateID int
)

--Insert Into @Mapping
--Select Distinct b.BottlerID, sr.StateRegionID ServingStateID
--From BC.BottlerAccountTradeMark bat
--Join BC.Bottler b on bat.BottlerID = b.BottlerID
--Join SAP.Account a on bat.AccountID = a.AccountID
--Join Shared.StateRegion sr on a.State = sr.RegionABRV
--Where a.CRMActive = 1
--And b.BCRegionID is not null
--And bat.TerritoryTypeID in (10, 11)
--And bat.ProductTypeID = 1

Insert Into @Mapping
Select Distinct b.BottlerID, sr.StateRegionID ServingStateID
From BC.Bottler b 
Join Shared.StateRegion sr on b.State = sr.RegionABRV
Where b.BCRegionID is not null

Select pgr.PromotionID, m.BottlerID
Into #PGR
From Playbook.PromotionGeoRelevancy pgr with (nolock)
Join @Mapping m on pgr.StateId = m.StateID
Where pgr.StateID is not Null

Select Distinct pgh.PromotionID, pgh.BottlerID
Into #ReducedPGR
From 
#PGR pgh,
(
	Select PromotionID, b.TrademarkID
	From Playbook.PromotionBrand pb With (nolock)
	Join SAP.Brand b on (pb.BrandID = b.BrandID)
	Union
	Select PromotionID, TrademarkID
	From Playbook.PromotionBrand With (nolock)) ptm,
(
	Select PromotionID, LocalChainID
	From Playbook.PromotionAccount With (nolock) Where Coalesce(LocalChainID, 0) > 0
	Union
	Select PromotionID, lc.LocalChainID
	From Playbook.PromotionAccount pa With (nolock)
	Join SAP.LocalChain lc on(pa.RegionalChainID = lc.RegionalChainID) Where Coalesce(pa.RegionalChainID, 0) > 0
	Union
	Select PromotionID, lc.LocalChainID
	From Playbook.PromotionAccount pa With (nolock)
	Join SAP.RegionalChain rc on pa.NationalChainID = rc.NationalChainID
	Join SAP.LocalChain lc on rc.RegionalChainID = lc.RegionalChainID Where Coalesce(pa.NationalChainID, 0) > 0
) pc,
BC.tBottlerChainTradeMark tmap With (nolock)
Where ptm.PromotionID = pgh.PromotionID
And pc.PromotionID = pgh.PromotionID
And ptm.PromotionID = pc.PromotionID
And tmap.TerritoryTypeID <> 10
And tmap.ProductTypeID = 1
And tmap.TradeMarkID = ptm.TradeMarkID
And tmap.LocalChainID = pc.LocalChainID
And tmap.BottlerID = pgh.BottlerID

Select Distinct PromotionID
Into #Promotion 
From #ReducedPGR

-- Promotion
Select rp.PromotionID, rp.PromotionName, rp.PromotionStartDate, rp.PromotionEndDate, Case When GetDate() Between PromotionStartDate And PromotionEndDate Then 'Yes' Else 'No' End CurrentPromotion
From Playbook.RetailPromotion rp
Join #Promotion p on rp.PromotionID = p.PromotionId
Order By PromotionID DESC

--- Promotion State
Select rp.PromotionID, rp.PromotionName, sr.RegionABRV StateShort, sr.RegionName State
From Playbook.PromotionGeoRelevancy pgr
Join Playbook.RetailPromotion rp on pgr.PromotionId = rp.PromotionID
Join #Promotion p on pgr.PromotionId = p.PromotionID
Join Shared.StateRegion sr on pgr.StateId = sr.StateRegionID
Order By PromotionID DESC

--- Promotion TM/Brand
Select rp.PromotionID, rp.PromotionName, b.SAPBrandID BrandID, b.BrandName, t.SAPTradeMarkID TradeMarkID, t.TradeMarkName
From Playbook.RetailPromotion rp
Join Playbook.PromotionBrand pb With (nolock) on rp.PromotionID = pb.PromotionID
Join #Promotion p on rp.PromotionId = p.PromotionID
Join SAP.Brand b on pb.BrandID = b.BrandID
Join SAP.Trademark t on b.TradeMarkID = t.TradeMarkID
Union
Select rp.PromotionID, rp.PromotionName, null BrandID, null BrandName, t.SAPTradeMarkID TradeMarkID, t.TradeMarkName
From Playbook.RetailPromotion rp
Join Playbook.PromotionBrand pb With (nolock) on rp.PromotionID = pb.PromotionID
Join #Promotion p on rp.PromotionId = p.PromotionID
Join SAP.Trademark t on pb.TradeMarkID = t.TradeMarkID
Order By PromotionID DESC, TradeMarkName, BrandName

--- Promotion Chain
Select rp.PromotionID, rp.PromotionName, ch.SAPLocalChainID LocalChainID, ch.LocalChainName, ch.SAPRegionalChainID RegionalChainID, 
	ch.RegionalChainName, ch.SAPNationalChainID NationalChainID, ch.NationalChainName
From Playbook.RetailPromotion rp
Join #Promotion p on rp.PromotionId = p.PromotionID
Join Playbook.PromotionAccount pa With (nolock) on rp.PromotionID = pa.PromotionID
Join Mview.ChainHier ch on ch.LocalChainID = pa.LocalChainID
Union
Select Distinct rp.PromotionID, rp.PromotionName, null, null, ch.SAPRegionalChainID RegionalChainID, ch.RegionalChainName, ch.SAPNationalChainID NationalChainID, ch.NationalChainName
From Playbook.RetailPromotion rp
Join #Promotion p on rp.PromotionId = p.PromotionID
Join Playbook.PromotionAccount pa With (nolock) on rp.PromotionID = pa.PromotionID
Join Mview.ChainHier ch on ch.RegionalChainID = pa.RegionalChainID
Union
Select Distinct rp.PromotionID, rp.PromotionName, null, null, null, null, ch.SAPNationalChainID NationalChainID, ch.NationalChainName
From Playbook.RetailPromotion rp
Join #Promotion p on rp.PromotionId = p.PromotionID
Join Playbook.PromotionAccount pa With (nolock) on rp.PromotionID = pa.PromotionID
Join Mview.ChainHier ch on ch.NationalChainID = pa.NationalChainID
Order By PromotionID DESC, NationalChainName, RegionalChainName, LocalChainName

--- Promotion Bottler
Select Distinct rp.PromotionID, rp.PromotionName, BCBottlerID BottlerID, BottlerName, BCRegionID RegionID, RegionName, BCDivisionID DivisionID, DivisionName, BCZoneID, ZoneName, BCSystemID, v.SystemName
From #ReducedPGR pgr
Join Playbook.RetailPromotion rp on pgr.PromotionId = rp.PromotionID
Join bc.vBCBottlerSalesHier v on v.BottlerID = pgr.BottlerID
Order By PromotionID DESC, SystemName, ZoneName, DivisionName, RegionName, BottlerName

Drop Table #PGR
Drop Table #ReducedPGR
Drop Table #Promotion

