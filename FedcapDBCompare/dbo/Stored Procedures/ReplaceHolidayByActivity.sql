
CREATE Proc [dbo].[ReplaceHolidayByActivity]
AS
Declare @count int, @index int, @clientId int, @scheduleid int, @scheduleddatetime datetime
set @count = 0;
set @index = 1;
set @clientId = 0

IF OBJECT_ID('tempdb..#temp') is not null
drop table #temp

SELECT ROW_NUMBER() over( ORDER BY clientId) as id, ClientId into #temp from dbo.Schedule s With(nolock)
where EventId = 74 and CreatedBy = 'System' --and ClientId = 9627
group by ClientId

SELECT @count = Max(id) from #temp
While(@index <= @count)
BEGIN
	SELECT @clientId = ClientId from #temp where Id = @index

	DECLARE cursorSchedule CURSOR -- Declare cursor
	static
	FOR
	SELECT ScheduleId, [Date] From Schedule s With(nolock)
	WHere
	s.ClientId = @clientId AND s.IsDeleted = 0 AND s.IsVisible = 1 AND s.CreatedBy = 'System' AND s.EventId = 74 AND s.[Date] >= '05/01/2017'

	OPEN cursorSchedule -- open the cursor

	FETCH NEXT FROM cursorSchedule INTO @scheduleid, @scheduleddatetime

	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		Declare @SiteId int, @ClassRommId int, @EventId int, @eventUserId int, @ExternalAddress varchar(100), @NoteSchedule  varchar(100), @IScore bit, @federalActivityId int, @Id int
		SET @Id = 0;

		select top 1 @Id = ScheduleId, @SiteId = SiteId, @ClassRommId = ClassInstRoomId, @EventId = EventId, @eventUserId = EventUserId, @ExternalAddress = ExternalAddress, @NoteSchedule = NoteSchedule, 
		@IScore = IsCoreActivity, @federalActivityId = FederalActivityId 
		FROM  dbo.schedule actualactivity with (nolock) 
		WHERE
		actualactivity.clientid = @clientId and --actualactivity.ScheduleId <> @scheduleid and 
		isnull(actualactivity.isdeleted,0) <> 1 and (isnull(actualactivity.eventid,0) <> 74 OR ClassInstRoomId <> 11) AND abs(datediff(d, actualactivity.[date], @scheduleddatetime)) <= 4
		order by abs(datediff(d, actualactivity.[date], @scheduleddatetime)) asc 

		If(@Id > 0)
		BEGIN
			Update dbo.Schedule SET SiteId = @SiteId, ClassInstRoomId = @ClassRommId, EventId = @EventId, EventUserId = @eventUserId, ExternalAddress = @ExternalAddress, NoteSchedule = @NoteSchedule, 
			IsCoreActivity = @IScore, FederalActivityId  = @federalActivityId, AttendanceStatus = 5, AttendanceType = 4, SignInTime = null, SignOutTime = null
			where ScheduleId = @scheduleid
		END
		ELSE
			Update dbo.Schedule SET IsDeleted = 1, UpdatedBy = 'System', UpdatedAt = GETDATE()
			WHERE ScheduleId = @scheduleid


		FETCH NEXT FROM cursorSchedule INTO @scheduleid, @scheduleddatetime
	END
	CLOSE cursorSchedule -- close the cursor
	DEALLOCATE cursorSchedule -- Deallocate the cursor


	SET @index = @index + 1
END
