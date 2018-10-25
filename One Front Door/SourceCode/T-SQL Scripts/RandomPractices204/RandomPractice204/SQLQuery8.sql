use Portal_Data805
Go

Select LogID,
	LogDate,
	Duration, 
	GSN, 
	MDate, 
	StartDate, 
	EndDate, 
	NumberOfPromotion,
	NumberOfCurrentPromotion,
	NumberOfRegion,
	NumberOfBottler, NumberOfAttachments, TotalAttachmentSize, NumberOfPromoBottler
From BCMyDay.PromotionRequestLog
