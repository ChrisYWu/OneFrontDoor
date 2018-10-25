use Portal_Data
Go

Select NationalChainID, NationalChainName, Count(*)
From 
(
	Select Distinct NationalChainID, NationalChainName, ChainHierType
	From MSTR.RevChainImages
) tmp
Group By NationalChainID, NationalChainName
Having Count(*) > 1

Select *
From MSTR.RevChainImages
Where NationalChainID = 190

Select *
From MSTR.RevChainImages
Where NationalChainID = 185




--------------
Select *
From Playbook.PromotionRank

Select PromotionID, Count(*)
From Playbook.PromotionAccount
Group By PromotionID
Having Count(*) > 1

	Select Distinct pa.PromotionID, hier.NationalChainID, hier.RegionalChainID, hier.LocalChainID 
	From PlayBook.PromotionAccount pa
	Join Processing.tChainSeeking hier on pa.NationalChainID = hier.NationalChainID

-- Direct National Chain Translation into National ChainGroup
Select pa.PromotionID, cgnc.ChainGroupID, pa.NationalChainID, null RegionalChainID
From PlayBook.PromotionAccount pa,
     Playbook.ChainGroupNationalChain cgnc
Where cgnc.NationalChainID = pa.NationalChainID 

-- Inferred Regional ChainGroup from National Chain that doesn't make into ChainGroup
Select pa.PromotionID, cgrc.ChainGroupID, pa.NationalChainID, cgrc.RegionalChainID
From PlayBook.PromotionAccount pa,
     Playbook.ChainGroupRegionalChain cgrc,
	 SAP.RegionalChain rc
Where pa.NationalChainID = rc.NationalChainID
And cgrc.RegionalChainID = rc.RegionalChainID

-- 9 National Chains are parent companies
Select Distinct pa.NationalChainID, NationalChainName
From PlayBook.PromotionAccount pa,
     Playbook.ChainGroupRegionalChain cgrc,
	 SAP.RegionalChain rc,
	 SAP.NationalChain nc
Where pa.NationalChainID = rc.NationalChainID
And cgrc.RegionalChainID = rc.RegionalChainID
And nc.NationalChainID = rc.NationalChainID

-- Inferred Regional ChainGroup from National Chain that doesn't make into ChainGroup
Select pa.PromotionID, cglc.ChainGroupID, pa.NationalChainID, cs.RegionalChainID, cs.LocalChainID
From PlayBook.PromotionAccount pa,
     Playbook.ChainGroupLocalChain cglc,
	 Processing.tChainSeeking cs
Where pa.NationalChainID = cs.NationalChainID
And cglc.LocalChainID = cs.LocalChainID

/* 9 National Chains are parent companies
Select Distinct pa.NationalChainID, NationalChainName
From PlayBook.PromotionAccount pa,
     Playbook.ChainGroupLocalChain cglc,
	 Processing.tChainSeeking cs,
	 SAP.NationalChain nc
Where pa.NationalChainID = cs.NationalChainID
And cglc.LocalChainID = cs.LocalChainID
And nc.NationalChainID = pa.NationalChainID
*/

Select *
From MSTR.RevChainImages
Where Chain like '%Albertsons%'


Select *
From MSTR.RevChainImages

Select *
From 
SAP.NationalChain nc,
SAP.RegionalChain rc
Where nc.NationalChainName = rc.RegionalChainName

-------------------------
With RawData As
(
	Select 0 Tier, 'A-0' ID, 'All Chains' Name, null ParentID
	Union
	Select 1, 'N-' + Convert(Varchar, NationalChainID) ID, NationalChainName Name, 'A-0' ParentID
	From SAP.NationalChain nc
	Union
	Select 2, 'R-' + Convert(Varchar, RegionalChainID) ID, RegionalChainName Name, 'N-' + Convert(Varchar, NationalChainID) ParentID
	From SAP.RegionalChain rc
	Union
	Select 3, 'L-' + Convert(Varchar, LocalChainID) ID, LocalChainName Name, 'R-' + Convert(Varchar, RegionalChainID) ParentID
	From SAP.LocalChain lc
),

Candidate As
(
	Select rsource.Tier, rsource.ID, rsource.Name, rsource.ParentID
	From RawData rsource,
		(
			Select Min(Tier) Tier, Name, Count(*) GroupCount
			From RawData
			Group By Name
		) rpicker
	Where rsource.Tier = rpicker.Tier
	And rsource.Name = rpicker.Name
),

GoodCandidate As
(
	Select b.Tier, b.ID, b.Name, c.ParentID, b.ChainGroupID
	From RawData c
	Join 
	(
		Select *
		From Candidate 
		Where ParentID Not In
		(Select ID
		From Candidate)
	) b
	On c.ID = b.ParentID
	Order By b.ID
),

-- So far the only missing one is 'Cs Lowes Foods' which does not have promotion
Broken As
(
	Select 0 Tier, 'A-0' ID, 'All Chains' Name, null ParentID, null ChainGroupID
	Union
	Select Distinct c.Tier, C.ID, C.Name, C.ParentID, rci.ChainID ChainGroupID
	From GoodCandidate c
	Join MSTR.RevChainImages rci on c.Name = rci.Chain Or (ChainHierID = substring(c.ID, 3, 99) And substring(c.ID, 1, 1) = 'L') 
)

Select b.Tier, b.ID, b.Name, c.ParentID, b.ChainGroupID
From GoodCandidate c
Join 
(
	Select *
	From Broken 
	Where ParentID Not In
	(Select ID
	From Broken)
) b
On c.ID = b.ParentID
Order By b.ID

-- So far the only missing one is 'Cs Lowes Foods' which does not have promotion
--Select *
--From MSTR.RevChainImages 
--Where ChainID Not in
--(
--Select rci.ChainID
--From Candidate c
--Join MSTR.RevChainImages rci on c.Name = rci.Chain Or (ChainHierID = substring(c.ID, 3, 99) And substring(c.ID, 1, 1) = 'L') 
--)

--Select c.*, cgnc.ChainGroupID
--From Candidate c
--Join Playbook.ChainGroupNationalChain cgnc
--On substring(c.ID, 3, 20) = cgnc.NationalChainID 
--Where substring(c.ID, 1, 1) = 'N'
--Union
--Select *
--From Playbook.ChainGroupRegionalChain
--Where ChainGroupID Not In
--(
--Select cgrc.ChainGroupID
----Select c.*, cgrc.ChainGroupID
--From Candidate c
--Join Playbook.ChainGroupRegionalChain cgrc
--On substring(c.ID, 3, 20) = cgrc.RegionalChainID 
--Where substring(c.ID, 1, 1) = 'R'
--)
--Order By Name

--Select *
--From Playbook.ChainGroupRegionalChain cgrc

--Select *
--From SAP.RegionalChain
--Where RegionalChainID in
--(481,
--494,
--2,
--331,
--483,
--349,
--521,
--421,
--346,
--530)

Select *
From MSTR.RevChainImages 
--Where 
--(Chain <> NationalChainName
--And Chain <> RegionalChainName
--And Chain <> LocalChainName
--)

--Where RegionalChainID = 2

Select *
From SAP.LocalChain
Where LocalChainID = 652

Select *
From Playbook.PromotionAccount
Where LocalChainID = 652
Or NationalChainID = 208


 

