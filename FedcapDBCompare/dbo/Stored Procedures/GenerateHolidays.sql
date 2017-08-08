

CREATE proc [dbo].[GenerateHolidays]
@companyId int
AS
--To stop the procedure.
RETURN 1;

Declare @holidayDate dateTime

DECLARE cursorHoliday CURSOR -- Declare cursor
Dynamic
FOR
	SELECT  HolidayDate FROM dbo.ScheduleHoliday h
	WHERE h.IsDeleted = 0
	AND
	(dateadd(day,0,datediff(day,0,h.HolidayDate))>= dateadd(day,0,datediff(day,0, GETDATE())))

OPEN cursorHoliday -- open the cursor

FETCH NEXT FROM cursorHoliday INTO @holidayDate

WHILE @@FETCH_STATUS = 0
BEGIN
		Declare @clientId int, @countScheduledId int
		DECLARE cursorClient CURSOR -- Declare cursor
		Dynamic
		FOR
		Select ClientId FROM dbo.Client AS C 
		WHERE 
		c.CompanyId = @companyId
		AND
		ISNULL(c.IsDeleted,0) = 0 AND c.ActiveCaseId IS NOT NULL

		OPEN cursorClient -- open the cursor

		FETCH NEXT FROM cursorClient INTO @clientId
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET  @countScheduledId = 0

			SELECT @countScheduledId = COUNT(s.ScheduleId) FROM Schedule s WITH(NOLOCK) 
			WHERE s.CompanyId = @companyId AND ISNULL(s.IsDeleted,0) = 0 AND s.ClientId = @clientId AND s.[Date] = @holidayDate AND s.EventId = 74 --Holiday.

			IF(@countScheduledId = 0)
			BEGIN
				Declare @startTime datetime, @endTime Datetime
				Set @startTime = CAST((@holidayDate + CAST('09:00:00.000' AS TIME)) as Datetime)
				Set @endTime = CAST((@holidayDate + CAST('17:00:00.000' AS TIME)) as Datetime)

				RETRY: -- Label RETRY
				BEGIN TRANSACTION
				BEGIN TRY

					INSERT INTO dbo.Schedule (CompanyId, SiteId, ClientId, ClassInstRoomId, EventId, EventUserId, ExternalAddress, [DayName], [Date], StartTime, EndTime, ScheduledHours, NoteSchedule, AttendanceStatus,
				 AttendanceType, SignInTime, SignOutTime, NoteAttendance, IsDeleted, IsCoreActivity, FederalActivityId, CreatedBy, CreatedAt, UpdatedBy, UpdatedAt, IsVisible)
				 VALUES(@companyId, NULL, @clientId, NULL, 74, NULL, 'N/A', datename(dw,@holidayDate), @holidayDate, @startTime, @endTime, 7, 'Holiday', 5,
					    4, @startTime, @endTime, null, 0, 1, 13, 'System', GETDate(), null, null, 1)

					COMMIT TRANSACTION
				END TRY
				BEGIN CATCH
					PRINT 'Rollback Transaction'
					ROLLBACK TRANSACTION
					IF ERROR_NUMBER() = 1205 -- Deadlock Error Number
					BEGIN
						WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms
						GOTO RETRY -- Go to Label RETRY
					END
				END CATCH
				
			END

			FETCH NEXT FROM cursorClient INTO @clientId

		END
		CLOSE cursorClient -- close the cursor
		DEALLOCATE cursorClient -- Deallocate the cursor

	FETCH NEXT FROM cursorHoliday INTO @holidayDate
END
CLOSE cursorHoliday -- close the cursor
DEALLOCATE cursorHoliday -- Deallocate the cursor