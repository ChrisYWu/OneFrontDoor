use Portal_Data
Go

Select Count(*)
From BC.BottlerAccountTrademark



Select *
From BC.BottlerAccountTrademark
Where TrademarkID = 187
And ProductTypeID = 1
And TerritoryTypeID = 11
And LocalChainID = 2151

Select *
From BC.TerritoryMap
Where TrademarkID = 187
And ProductTypeID = 1
And TerritoryTypeID = 11
And PostalCode = '71459'

Select *
From Shared.County
Where BCCountyFIPS = '115'

Select *
From BC.Bottler
Where BottlerID = 6222

Select *
From SAP.LocalChain
Where LocalChainName like '%AAF%'

Select *
From BC.Bottler
Where BottlerName like '%Schilling%'


Use Portal_Data
Go

Select Distinct t.TradeMarkID, t.TradeMarkName, map.BottlerID, BCBottlerID, BottlerName, map.AccountID, LocalchainName, map.ChannelID, a.SAPAccountNumber, a.AccountName, a.PostalCode
--Select *
From BC.BottlerAccountTradeMark map
Join SAP.LocalChain lc on map.LocalChainID = lc.LocalChainID
Join SAP.Trademark t on map.TrademarkID = t.TrademarkID
Join BC.Bottler b on b.BottlerID = map.BottlerID
Join SAP.Account a on a.AccountID = map.AccountID
Where map.BottlerID = 5872
And LocalChainName like '%Albertson%'

Select Distinct map.BottlerID, BCBottlerID, BottlerName, t.TradeMarkID, t.TradeMarkName
From BC.BottlerAccountTradeMark map
Join SAP.LocalChain lc on map.LocalChainID = lc.LocalChainID
Join SAP.Trademark t on map.TrademarkID = t.TrademarkID
Join BC.Bottler b on b.BottlerID = map.BottlerID
Join SAP.Account a on a.AccountID = map.AccountID
Where b.BCRegionID = 74
And LocalChainName like '%Albertson%'
And ProductTypeID = 1
And TerritoryTypeID in (11, 12)


Select *
From BC.Region
Where RegionID = 74


Select count(*)
From BC.BottlerAccountTradeMark map
Join MView.ChainHier ch on map.LocalChainID = ch.LocalChainID
Where BottlerID = 5872
And TrademarkID = 187
And NationalChainID = 172

Select top 100 *
From BC.TerritoryMap


Select *
From Staging.BCTmap

Select *
From SAP.NationalChain
Where NationalChainName like '%Alb%'


Select *
From BC.TerritoryMap m
Where m.BottlerID = 5872
And GetDate() between validfrom and validto



Select TerritoryTypeID, ProductTypeID, b.BottlerID, BCBottlerID, BottlerName, map.AccountID, LocalchainName, map.ChannelID, a.SAPAccountNumber, a.AccountName
From BC.BottlerAccountTradeMark map
Join SAP.LocalChain lc on map.LocalChainID = lc.LocalChainID
Join SAP.Trademark t on map.TrademarkID = t.TrademarkID
Join BC.Bottler b on b.BottlerID = map.BottlerID
Join SAP.Account a on a.AccountID = map.AccountID
Where map.BottlerID = 5872
And LocalChainName like '%Albertson%'


Select top 1 *
From BC.TerritoryMap m
Where m.BottlerID = 5872

Select r.RegionName
From BC.Bottler b
Join BC.Region r on b.BCRegionID = r.RegionID
Where BottlerName like '%Schilling%'

Select *
From Playbook.RetailPromotion
Where PromotionID = 44040

exec BCMyday.pGetPromotionIDsByBottler 5872

Select Distinct TrademarkID, SAPTradeMarkID, TradeMarkName
From BC.tBottlerChainTrademark
Where BottlerID = 5872

--Select *
--From BC.Bottler
--Where BottlerID = 5872

Select *
From PlayBook.RetailPromotion rp
Join PlayBook.PromotionAccountHier pah on rp.PromotionID = pah.PromotionID
Join PlayBook.PromotionGeoHier pgh on rp.PromotionID = pgh.PromotionID

Select *
From SAP.TradeMark
Where TrademarkID = 187

Set NoCount On;
Declare @LastLoadTime DateTime
Declare @LogID bigint 
Declare @OPENQUERY nvarchar(4000)
Declare @RecordCount int
Declare @LastRecordDate DateTime

------------------------------------------------------
------------------------------------------------------
Set @LastLoadTime  = '2013-01-01'

----------------------------------------
Set @OPENQUERY = BC.udf_SetOpenQuery('SELECT 
T.TRADEMARK_ID, T.PROD_TYPE_ID, T.TERR_VW_ID, T.CNTRY_CODE, T.REGION_FIPS, T.CNTY_FIPS, 
	T.POSTAL_CODE, T.BTTLR_ID, T.VLD_FROM_DT, T.VLD_TO_DT, T.ROW_MOD_DT
FROM CAP_ODS.TM_TERRITORY_MAP T', 'COP', @LastLoadTime, 'T')
Set @OPENQUERY = Replace(@OpenQuery, 'Select *', 'Insert Into Staging.BCTMap Select *')
Set @OPENQUERY = Replace(@OpenQuery, 'Where', 'WHERE T.CNTRY_CODE = ''''US'''' 
AND T.PROD_TYPE_ID=''''01'''' AND T.TERR_VW_ID IN (''''11'''', ''''12'''') AND SYSDATE BETWEEN T.VLD_FROM_DT AND T.VLD_TO_DT AND')
----------------------------------------
Exec (@OPENQUERY)





Select *
From Playbook.PromotionAccountHier
Where PromotionID = 44040

Select *
From 


Select *
From Playbook.P


SELECT DISTINCT A.PROMOTIONID AS [PROMOTIONID], CONVERT(INT, C.BOTTLERID) AS [BOTTLERID]
FROM PLAYBOOK.RETAILPROMOTION A WITH ( NOLOCK )
	LEFT JOIN PLAYBOOK.PROMOTIONACCOUNTHIER B WITH ( NOLOCK ) ON A.PROMOTIONID = B.PROMOTIONID 
	LEFT JOIN PLAYBOOK.PROMOTIONGEOHIER C WITH ( NOLOCK ) ON C.PROMOTIONID = A.PROMOTIONID
	LEFT JOIN PLAYBOOK.PROMOTIONBRAND D WITH ( NOLOCK ) ON D.PROMOTIONID = A.PROMOTIONID
	LEFT JOIN SAP.BRAND BRND WITH ( NOLOCK ) ON BRND.BRANDID = D.BRANDID
	JOIN BC.tBottlerChainTrademark TC WITH ( NOLOCK ) ON TC.BOTTLERID = CONVERT(INT,C.BOTTLERID)
							AND TC.TRADEMARKID = CASE
												WHEN ISNULL( D.TRADEMARKID,0 ) = 0 THEN BRND.TRADEMARKID
													ELSE D.TRADEMARKID END
Where tc.BottlerID = 5872
And d.TradeMarkID = 187
Order By PromotionID desc

SELECT DISTINCT A.PROMOTIONID AS [PROMOTIONID],
				CONVERT(INT, C.BOTTLERID) AS [BOTTLERID]
FROM PLAYBOOK.RETAILPROMOTION A WITH ( NOLOCK )
	LEFT JOIN PLAYBOOK.PROMOTIONACCOUNTHIER B WITH ( NOLOCK ) ON A.PROMOTIONID = B.PROMOTIONID 
	LEFT JOIN PLAYBOOK.PROMOTIONGEOHIER C WITH ( NOLOCK ) ON C.PROMOTIONID = A.PROMOTIONID
	LEFT JOIN PLAYBOOK.PROMOTIONBRAND D WITH ( NOLOCK ) ON D.PROMOTIONID = A.PROMOTIONID
	LEFT JOIN SAP.BRAND BRND WITH ( NOLOCK ) ON BRND.BRANDID = D.BRANDID
	JOIN bc.tBottlerChainTrademark TC WITH ( NOLOCK ) ON TC.BOTTLERID = CONVERT(INT,C.BOTTLERID)
							AND TC.TRADEMARKID = CASE
												WHEN ISNULL( D.TRADEMARKID,0 ) = 0 THEN BRND.TRADEMARKID
													ELSE D.TRADEMARKID
												END
							AND TC.LOCALCHAINID = B.LOCALCHAINID
Where tc.BottlerID = 6222
And d.TradeMarkID = 187
Order By PromotionID desc

exec BCMyDay.pGetPromotionIDsByBottler 5872


Select *
From bc.tBottlerChainTrademark
Where BottlerID = 5872
And LocalchainName like 'A%'
