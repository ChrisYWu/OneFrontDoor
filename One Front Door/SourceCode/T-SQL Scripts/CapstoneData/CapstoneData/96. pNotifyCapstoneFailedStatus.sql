use Portal_DAta_int
Go

If Exists (Select * From sys.procedures Where Object_id = object_id('ETL.pNotifyCapstoneFailedStatus'))
Begin
	Drop Proc ETL.pNotifyCapstoneFailedStatus
End
Go

--exec ETL.pNotifyCapstoneFailedStatus 14
--go
Create Proc ETL.pNotifyCapstoneFailedStatus
	@ObjectCount int
As
Begin
	Declare @ObjectLoadCount int
	Declare @MergedObjectLoadCount int
	Declare @Message varchar(4000)
	Declare @LoadFailedObjects varchar(4000)
	Declare @MergedFailedObjects varchar(4000)
	Declare @BCRegionLoadingStart DateTime2(7)

	Set @LoadFailedObjects = ''
	Set @MergedFailedObjects = ''

	Select @BCRegionLoadingStart = Max(StartDate)
	From ETL.BCDataLoadingLog
	Where TableName = 'BCRegion'

	SELECT @ObjectLoadCount = Count(*)
	FROM ETL.BCDataLoadingLog
	Where LogDate = Convert(date, GetDate())
	And EndDate is not null
	And StartDate >= @BCRegionLoadingStart

	If (@ObjectLoadCount < @ObjectCount)
	Begin
		Set @Message = 'Error: Capstone data load is incomplete for date ' + Convert(varchar, Convert(date, GetDate()));

		Select @LoadFailedObjects = @LoadFailedObjects + TableName + ';'
		FROM ETL.BCDataLoadingLog
		Where LogDate = Convert(date, GetDate())
		And EndDate is null
		And StartDate >= @BCRegionLoadingStart

		Set @Message = @Message + CHAR(13);
		Set @Message = @Message + 'Details: Data load is failed for table(s) ' + @MergedFailedObjects;
	End
	Else 
	Begin
		Select @MergedObjectLoadCount = Count(*)
		FROM ETL.BCDataLoadingLog
		Where LogDate = Convert(date, GetDate())
		And EndDate is not null
		And StartDate >= @BCRegionLoadingStart
		And IsMerged = 1

		If (@MergedObjectLoadCount <> @ObjectCount)
		Begin
			Set @Message = 'Error: Capstone data merge is incomplete for date ' + Convert(varchar, Convert(date, GetDate()));
		
			Select @MergedFailedObjects = @MergedFailedObjects + TableName + ';'
			FROM ETL.BCDataLoadingLog
			Where LogDate = Convert(date, GetDate())
			And EndDate is not null
			And StartDate >= @BCRegionLoadingStart
			And IsMerged <> 1

			Set @Message = @Message + CHAR(13);
			Set @Message = @Message + 'Details: Data merge is incomplete for table(s) ' + @MergedFailedObjects;

		End
	End

	If (@Message is not null)
	Begin
		EXEC msdb.dbo.sp_send_dbmail
			@recipients = 'Chris.Wu@dpsg.com', 
			@body = @Message,
			@subject = 'Capstone Master Data Loading Failed'; 
	End
End

Go