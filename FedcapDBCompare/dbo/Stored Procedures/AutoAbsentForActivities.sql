


CREATE proc [dbo].[AutoAbsentForActivities]
@companyId int
AS
Declare @scheduledId int, @clientId int, @caseStatus varchar(2)

DECLARE cursorSchedule CURSOR -- Declare cursor
Local FAST_FORWARD
FOR

	SELECT        S.ScheduleId, s.ClientId,  dbo.[Case].StatusId
	FROM          dbo.Schedule S with(nolock) LEFT OUTER JOIN
				  dbo.ScheduleClassInstRoom C with(nolock) ON S.ClassInstRoomId = C.ClassInstRoomId LEFT OUTER JOIN
                  dbo.ScheduleEvent E with(nolock) ON S.EventId = E.EventId INNER JOIN
		          dbo.Client with(nolock) ON S.ClientId = dbo.Client.ClientId INNER JOIN
                  dbo.[Case] with(nolock) on dbo.[Case].CaseId = dbo.Client.ActiveCaseId
	WHERE
	S.CompanyId = @companyId AND
	ISNULL(S.IsDeleted,0) = 0 AND
	S.AttendanceStatus = 0 AND
	(dateadd(day,0,datediff(day,0,S.[Date])) = dateadd(day,0,datediff(day,0, GETDATE()))) AND
	(ISNULL(E.IsAutoAbsent,0) = 1 OR ISNULL(C.IsAutoAbsent,0) = 1)
	

OPEN cursorSchedule -- open the cursor

FETCH NEXT FROM cursorSchedule INTO @scheduledId, @clientId, @caseStatus

WHILE @@FETCH_STATUS = 0
BEGIN
	
	UPDATE dbo.Schedule SET AttendanceStatus = 4, AttendanceType = 4, UpdatedBy = 'System', UpdatedAt = GETDATE()
	WHERE dbo.Schedule.ScheduleId = @scheduledId

	IF(Upper(@caseStatus) = 'O')
	BEGIN		
		/* Recalculate non-compliance for client since schedule has changed */
		exec dbo.ResetClientNonComplianceWorkflow @clientId
	END

	FETCH NEXT FROM cursorSchedule INTO @scheduledId, @clientId, @caseStatus
END
CLOSE cursorSchedule -- close the cursor
DEALLOCATE cursorSchedule -- Deallocate the cursor

