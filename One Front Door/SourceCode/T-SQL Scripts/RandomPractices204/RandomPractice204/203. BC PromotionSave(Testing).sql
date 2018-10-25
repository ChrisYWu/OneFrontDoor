USE Portal_Data805
GO

Declare @StartTime DateTime2(7)
Set @StartTime = SYSDATETIME()

exec Playbook.pSaveBCPromotion @PromotionID = 16402
Select '---- @PromotionID = 16402 ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds

exec Playbook.pSaveBCPromotion @PromotionID = 16407
Select '---- @PromotionID = 16407 ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds

exec Playbook.pSaveBCPromotion @PromotionID = 16406
Select '---- @PromotionID = 16406 ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds

exec Playbook.pSaveBCPromotion @PromotionID = 23994
Select '---- @PromotionID = 23994 ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds

exec Playbook.pSaveBCPromotion @PromotionID = 57376
Select '---- @PromotionID = 57376 ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds

exec Playbook.pSaveBCPromotion @PromotionID = 59569
Select '---- @PromotionID = 59569 ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds

exec Playbook.pSaveBCPromotion @PromotionID = 59433
Select '---- @PromotionID = 59433 ----' Debug, replace(convert(varchar(128), cast(DateDiff(MICROSECOND, @StartTime, SysDateTime()) as money), 1), '.00', '') TimeOffSetInMicroSeconds

exec Playbook.pSaveBCPromotion @PromotionID = 16402, @Debug = 1
exec Playbook.pSaveBCPromotion @PromotionID = 59433, @Debug = 1

--- Edge Test Case
exec Playbook.pSaveBCPromotion @PromotionID = 56714, @Debug = 1

Select v.SystemID, v.ZoneID, v.DivisionID, v.RegionID, b.BottlerID, sr.StateRegionID
From BC.vSalesHierarchy v
Join BC.Bottler b on b.BCRegionID = v.RegionID
Join Shared.StateRegion sr on b.State = sr.RegionABRV
Where SystemID in (5, 6,7)
And sr.StateRegionID = 55
Order By RegionID 

Select *
From Playbook.PromotionGeoHier
Where PromotionID = 56714

Select *
From Playbook.PromotionGeoRelevancy
Where PromotionID = 56714
--------------------------

exec Playbook.pSaveBCPromotion @PromotionID = 59520, @Debug = 1

Select *
From Playbook.PromotionGeoRelevancy
Where Coalesce(SystemID, ZoneID, DivisionID, RegionID, 0) > 0
And Coalesce(StateID, 0) > 0

Select * From Playbook.PromotionRegion

Select *
From Playbook.PromotionGeoRelevancy
Where PromotionID = 59433
