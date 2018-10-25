Use Portal_Data
Go

--- Chain Termset
With ChainSet
As
(	Select Distinct NationalChainName, RegionalChainName, LocalChainName
	From MView.ChainHier ch
	Join SAP.Account a on ch.LocalChainID = a.LocalChainID
	Where isnull(a.Active, 0) = 1  -- Cut for only active chains
)
Select NationalChainName, 
			Case 
				When RegionalChainName = LocalChainName And NationalChainName = RegionalChainName Then Null -- Regional Chain shadowed by national chain, e.g. CVS
				When NationalChainName = RegionalChainName Then LocalChainName								-- Promote Local Chain to regional chain e.g. Tmg Tigermarket
				Else RegionalChainName 
			End RegionalChainName,
			Case 
				When RegionalChainName = LocalChainName And NationalChainName = RegionalChainName Then Null -- Local chain shadowed by National chain e.g. CVS
				When NationalChainName = RegionalChainName Then Null								        -- Local Chain is promoted already e.g. All Other
				When LocalChainName = RegionalChainName Then Null								            -- Local Chain shadowed by regional Chain e.g. A&P
				Else LocalChainName
			End LocalChainName
From ChainSet
Order By NationalChainName, RegionalChainName, LocalChainName
Go

--- TradeMark/Brand Termset
Select TradeMarkName, Case When TradeMarkName = BrandName Then Null Else BrandName End BrandName 
From MView.BrandHier h
Order By TradeMarkName, BrandName

--- Channel Termset
Select SuperChannelName, Case When SuperChannelName = ChannelName Then Null else ChannelName End ChannelName 
From MView.ChannelHier h
Order By SuperChannelName, ChannelName

--- Location Termset
Select SPBUName BUName, SPRegionName RegionName, ProfitCenterName BranchName -- Double Bottoms
From SAP.ProfitCenter pc
	Join MView.LocationHier h on h.BranchID = pc.BranchID
Where SPProfitCenterName is not null
Union
Select SPBUName BUName, SPRegionName RegionName, BranchName -- True Branches
From MView.LocationHier h
Where SPBranchName is not null
Order By BUName, RegionName, BranchName 

