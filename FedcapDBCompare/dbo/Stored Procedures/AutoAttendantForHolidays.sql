
Create proc [dbo].[AutoAttendantForHolidays]
@companyId int
AS
Declare @scheduledId int, @clientId int

DECLARE cursorSchedule CURSOR -- Declare cursor
LOCAL FAST_FORWARD
FOR
	SELECT        S.ScheduleId, s.ClientId
	FROM          dbo.Schedule  S WITH(NOLOCK)
	WHERE
	S.CompanyId = @companyId AND
	ISNULL(S.IsDeleted,0) = 0 AND
	ISNULL(S.IsVisible,0) = 1 AND
	S.AttendanceStatus = 0 AND
	(dateadd(day,0,datediff(day,0,S.[Date])) <= dateadd(day,0,datediff(day,0, GETDATE()))) AND
	Exists (Select * from ScheduleHoliday SH With(NOLOCK) where SH.HolidayDate = s.Date)

OPEN cursorSchedule -- open the cursor

FETCH NEXT FROM cursorSchedule INTO @scheduledId, @clientId

WHILE @@FETCH_STATUS = 0
BEGIN
	
	UPDATE dbo.Schedule SET AttendanceStatus = 5, AttendanceType = 4, SignInTime = null, SignOutTime = null, UpdatedBy = 'System', UpdatedAt = GETDATE()
	WHERE dbo.Schedule.ScheduleId = @scheduledId

	/* Recalculate non-compliance for client since schedule has changed */
	exec dbo.ResetClientNonComplianceWorkflow @clientId

	FETCH NEXT FROM cursorSchedule INTO @scheduledId, @clientId
END
CLOSE cursorSchedule -- close the cursor
DEALLOCATE cursorSchedule -- Deallocate the cursor