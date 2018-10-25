use Portal_Data
Go

Declare @Output Table
(
	PromotionID int,
	Name varchar(500),
	StartDate DateTime,
	EndDate DateTime,
	IsCurrent bit,
	States varchar(500) null,
	BottlersInStates varchar(2000) null,
	BottlersInStatesCount int null,
	BottlersDistributeToStates varchar(200) null,
	BottlersDistributeToStatesCount int null
)

Declare @Mapping Table
(
	BottlerID int,
	StateID int
)

Insert Into @Mapping
Select Distinct b.BottlerID, sr.StateRegionID ServingStateID
From BC.BottlerAccountTradeMark bat
Join BC.Bottler b on bat.BottlerID = b.BottlerID
Join SAP.Account a on bat.AccountID = a.AccountID
Join Shared.StateRegion sr on a.State = sr.RegionABRV
Where a.CRMActive = 1
And b.BCRegionID is not null
And bat.TerritoryTypeID in (10, 11)
And bat.ProductTypeID = 1

Insert Into @Output
Select Distinct rp.PromotionID, rp.PromotionName, rp.PromotionStartDate, rp.PromotionEndDate, 
	Case When GetDate() Between rp.PromotionStartDate And rp.PromotionEndDate Then 1 Else 0 End IsCurrentPromotion, null, null, null, null, null
From Playbook.RetailPromotion rp
Join Playbook.PromotionGeoRelevancy pgr on rp.PromotionID = pgr.PromotionId
Join Shared.StateRegion sr on pgr.StateId = sr.StateRegionID
And pgr.StateId is not null
And rp.PromotionID > 62000
Order By rp.PromotionStartDate, rp.PromotionName

Declare @StateConcat Varchar(500)
Declare @ResidentBottlerConcat Varchar(2500)
Declare @DistributionBottlerConcat Varchar(2500)
Declare @pID int
Declare @cnt int
DECLARE db_cursor CURSOR FOR  
SELECT PromotionID From @Output  

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @pID  

WHILE @@FETCH_STATUS = 0  
BEGIN  
	Declare @Bttlr Table
	(
		BottlerID int,
		BottlerName varchar(200)
	)

	Set @StateConcat = ''

	Select @StateConcat += sr.RegionABRV + ','
	From Playbook.PromotionGeoRelevancy pgr
	Join Shared.StateRegion sr on pgr.StateId = sr.StateRegionID
	Where PromotionID = @pID

	Update @Output
	Set States = Substring(@StateConcat, 1, DataLength(@StateConcat) - 1)
	Where PromotionID = @pID

	-------------
	Select *
	From [dbo].[Split](Substring(@StateConcat, 1, DataLength(@StateConcat) - 1), ',') 

	Insert Into @Bttlr
	Select Distinct BCBottlerID, b.BottlerName
	From BC.Bottler b
	Join [dbo].[Split](Substring(@StateConcat, 1, DataLength(@StateConcat) - 1), ',') states on b.State = states.Value
	Join BC.BottlerAccountTradeMark bat on b.BottlerID = bat.BottlerID
	Where b.BCRegionID is not null

	Select @cnt = count(*)
	From @Bttlr

	Set @ResidentBottlerConcat = ''
	Select @ResidentBottlerConcat += '[' + Convert(varchar, BottlerID) + ']' + BottlerName + ';'
	From @Bttlr

	Select @cnt, @ResidentBottlerConcat

	Delete @Bttlr

	Insert Into @Bttlr
	Select Distinct BCBottlerID, b.BottlerName
	From BC.Bottler b
	Join BC.BottlerAccountTrademark bat on b.BottlerID = bat.BottlerID
	Join SAP.Account a on bat.AccountID = a.AccountID
	Join [dbo].[Split](Substring(@StateConcat, 1, DataLength(@StateConcat) - 1), ',') states on a.State = states.Value
	Where b.BCRegionID is not null

	Select @cnt = count(*)
	From @Bttlr

	Set @DistributionBottlerConcat = ''
	Select @DistributionBottlerConcat += '[' + Convert(varchar, BottlerID) + ']' + BottlerName + ';'
	From @Bttlr

	Select @cnt, @ResidentBottlerConcat

	-------------

	FETCH NEXT FROM db_cursor INTO @pID  

END  

CLOSE db_cursor  
DEALLOCATE db_cursor

Select * From @Output

