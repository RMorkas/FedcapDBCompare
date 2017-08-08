



CREATE proc [dbo].[GenerateHistoricalActivity]
@companyId int
AS


Declare @holidayDate dateTime

Declare @Id int, @clientId int, @federalActivityId int, @startDate smalldatetime, @endDate smalldatetime, @Desc varchar(100), @WeeklyHours int, @AttendanceStatus int,
@ImportedDays int
DECLARE cursorClient CURSOR -- Declare cursor
Local FAST_FORWARD
FOR
	Select HA.Id, c.ClientId, HA.FederalActivityId, HA.StartDate, HA.EndDate, HA.[Description],HA.WeeklyHours, 
	Case 
		When HA.AttendanceType = 'A' then 1
		When HA.AttendanceType = 'EC' then 3
		When HA.AttendanceType = 'H' then 5
	ELSE 1
	END AS AttendanceStatus
	
	FROM dbo.Historical_Activity AS HA with(nolock)
	JOIN dbo.Client c on HA.ClientId = c.ClientNo
	WHERE 
	HA.CompanyId = @companyId
	AND
	ISNULL(HA.IsProcessed,0) = 0
	order by HA.StartDate desc

OPEN cursorClient -- open the cursor

FETCH NEXT FROM cursorClient INTO @Id, @clientId, @federalActivityId, @startDate, @endDate, @Desc, @WeeklyHours, @AttendanceStatus
WHILE @@FETCH_STATUS = 0
BEGIN
	Declare @index int, @diffDays int, @date datetime, @workingDays int, @dailyHours int,@isWeekEnd bit
	--SET @diffDays = DATEDIFF(day,@startDate, @endDate)
	SET @workingDays = 0
	SET @date = @startDate
	While(DATEDIFF(day,@date, @endDate) >= 0)
	BEGIN
		SET @isWeekEnd = case when datepart(dw, @date) = 7 then 1 --SAT
							  when datepart(dw, @date) = 1 then 1 -- SUN
							  ELSE 0
							  END
		IF(@isWeekEnd = 0)
			SET @workingDays = @workingDays + 1
		SET @date = DATEADD(day,1,@date)		
	END
	IF(@workingDays = 0)
		SET @workingDays = 1;
	
	SET @ImportedDays = @workingDays
	SET @dailyHours = (@WeeklyHours/ @ImportedDays);

	SET @date = @startDate
	While(DATEDIFF(day,@date, @endDate) >= 0)
	BEGIN
		SET @isWeekEnd = case when datepart(dw, @date) = 7 then 1 --SAT
							  when datepart(dw, @date) = 1 then 1 -- SUN
							  ELSE 0
							  END
		IF(@isWeekEnd = 0)
		BEGIN
			SET @workingDays = @workingDays - 1	
			
			IF(@workingDays = 0)
				SET @dailyHours = @dailyHours + (@WeeklyHours % @ImportedDays)
				
			Declare @eventId int
			SELECT @eventId = EventId From [dbo].[ScheduleEvent] with(nolock) Where CompanyId = @companyId AND [FederalActivityId] = @federalActivityId AND [EventName] like 'History%'

			Declare @startTime datetime, @endTime Datetime
			Set @startTime = CAST((@date + CAST('09:00:00.000' AS TIME)) as Datetime)
			Set @endTime = DateAdd(Hour, @dailyHours, @startTime)
			

			INSERT INTO dbo.Schedule (CompanyId, SiteId, ClientId, ClassInstRoomId, EventId, EventUserId, ExternalAddress, [DayName], [Date], StartTime, EndTime, ScheduledHours, NoteSchedule, AttendanceStatus,
			AttendanceType, SignInTime, SignOutTime, NoteAttendance, IsDeleted, IsCoreActivity, FederalActivityId, CreatedBy, CreatedAt, UpdatedBy, UpdatedAt, ExcuseNote, IsVisible)
			VALUES(@companyId, NULL, @clientId, NULL, @eventId, NULL, 'N/A', datename(dw,@date), @date, @startTime, @endTime, @dailyHours, @Desc, @AttendanceStatus,
				4, @startTime, @endTime, null, 0, 1, @federalActivityId, 'System', GETDate(), null, null, null, 0)
			
		END
		SET @date = DATEADD(day,1,@date)
	END
	Update Historical_Activity SET IsProcessed = 1
	WHERE Id = @Id

FETCH NEXT FROM cursorClient INTO @Id, @clientId, @federalActivityId, @startDate, @endDate, @Desc, @WeeklyHours, @AttendanceStatus

END
CLOSE cursorClient -- close the cursor
DEALLOCATE cursorClient -- Deallocate the cursor