CREATE PROCEDURE [dbo].[RecalculateClientScheduleWorkflow] 
@clientId INT
AS
BEGIN		
	SET NOCOUNT ON;


	DECLARE @orientationScheduledActionId int
	DECLARE @orientationAttendedActionId int
	DECLARE @physicianReviewScheduledActionId int
	DECLARE @physicianReviewAttendedActionId int
	DECLARE @scheduleId int
	DECLARE @scheduleDate datetime
	DECLARE @scheduleCreatedBy varchar(80)

	SELECT @orientationScheduledActionId = WorkflowActionId FROM dbo.WorkflowAction WHERE Code = 'OrientationScheduled'
	SELECT @orientationAttendedActionId = WorkflowActionId FROM dbo.WorkflowAction WHERE Code = 'Orientation'
	SELECT @physicianReviewScheduledActionId = WorkflowActionId FROM dbo.WorkflowAction WHERE Code = 'ClinicalReviewScheduled'	
	SELECT @physicianReviewAttendedActionId = WorkflowActionId FROM dbo.WorkflowAction WHERE Code = 'PhysicianReviewAttended'	

	/* Orientation Scheduled */
	SELECT TOP 1 @scheduleId = schedule.ScheduleId, @scheduleDate = schedule.Date, @scheduleCreatedBy = schedule.CreatedBy
	FROM dbo.Schedule schedule WITH (NOLOCK)
	INNER JOIN dbo.ScheduleClassInstRoom scheduleClassInstRoom WITH (NOLOCK) ON scheduleClassInstRoom.ClassInstRoomId = schedule.ClassInstRoomId
	INNER JOIN dbo.ScheduleClass scheduleClass WITH (NOLOCK) ON scheduleClass.ClassId = scheduleClassInstRoom.ClassId
	WHERE schedule.ClientId = @clientId AND schedule.IsDeleted = 0 AND scheduleClass.ClassDescription LIKE '%Orientation%'
	ORDER BY schedule.Date

	IF (@scheduleId IS NULL)
	BEGIN
			SELECT TOP 1 @scheduleId = schedule.ScheduleId, @scheduleDate = schedule.Date, @scheduleCreatedBy = schedule.CreatedBy
			FROM dbo.Schedule schedule WITH (NOLOCK)
			INNER JOIN dbo.ScheduleEvent scheduleEvent WITH (NOLOCK) ON scheduleEvent.EventId = schedule.EventId
			WHERE schedule.ClientId = @clientId AND schedule.IsDeleted = 0 AND scheduleEvent.EventName LIKE '%Orientation%'
			ORDER BY schedule.Date
	END

	EXEC dbo.ResetClientWorkflowState @clientId, @orientationScheduledActionId, 7, @scheduleId, @scheduleDate, @scheduleCreatedBy

	SET @scheduleId = NULL
	SET @scheduleDate = NULL
	SET @scheduleCreatedBy = NULL

	/* Orientation Attended */
	SELECT TOP 1 @scheduleId = schedule.ScheduleId, @scheduleDate = schedule.Date, @scheduleCreatedBy = schedule.CreatedBy
	FROM dbo.Schedule schedule WITH (NOLOCK)
	INNER JOIN dbo.ScheduleClassInstRoom scheduleClassInstRoom WITH (NOLOCK) ON scheduleClassInstRoom.ClassInstRoomId = schedule.ClassInstRoomId
	INNER JOIN dbo.ScheduleClass scheduleClass WITH (NOLOCK) ON scheduleClass.ClassId = scheduleClassInstRoom.ClassId
	WHERE schedule.ClientId = @clientId AND schedule.IsDeleted = 0 AND schedule.AttendanceStatus IN (1, 2, 3) AND scheduleClass.ClassDescription LIKE '%Orientation%' 
	ORDER BY schedule.Date

	IF (@scheduleId IS NULL)
	BEGIN
			SELECT TOP 1 @scheduleId = schedule.ScheduleId, @scheduleDate = schedule.Date, @scheduleCreatedBy = schedule.CreatedBy
			FROM dbo.Schedule schedule WITH (NOLOCK)
			INNER JOIN dbo.ScheduleEvent scheduleEvent WITH (NOLOCK) ON scheduleEvent.EventId = schedule.EventId
			WHERE schedule.ClientId = @clientId AND schedule.IsDeleted = 0 AND schedule.AttendanceStatus IN (1, 2, 3) AND scheduleEvent.EventName LIKE '%Orientation%'
			ORDER BY schedule.Date
	END
	
	EXEC dbo.ResetClientWorkflowState @clientId, @orientationAttendedActionId, 7, @scheduleId, @scheduleDate, @scheduleCreatedBy	

	/* Clinical Review Scheduled */
	
	/* If the client has medical documentation then process the Physician Review scheduled and attended states */
	IF (dbo.HasMedicalDocumentation(@clientId) = 1)
	BEGIN
		SET @scheduleId = NULL
		SET @scheduleDate = NULL
		SET @scheduleCreatedBy = NULL

		SELECT TOP 1 @scheduleId = schedule.ScheduleId, @scheduleDate = schedule.Date, @scheduleCreatedBy = schedule.CreatedBy
		FROM dbo.Schedule schedule WITH (NOLOCK)
		INNER JOIN dbo.ScheduleEvent scheduleEvent WITH (NOLOCK) ON scheduleEvent.EventId = schedule.EventId
		WHERE schedule.ClientId = @clientId AND schedule.IsDeleted = 0 AND scheduleEvent.EventName = 'Physician Review'
		ORDER BY schedule.Date
	
		EXEC dbo.ResetClientWorkflowState @clientId, @physicianReviewScheduledActionId, 7, @scheduleId, @scheduleDate, @scheduleCreatedBy		

		SET @scheduleId = NULL
		SET @scheduleDate = NULL
		SET @scheduleCreatedBy = NULL

		SELECT TOP 1 @scheduleId = schedule.ScheduleId, @scheduleDate = schedule.Date, @scheduleCreatedBy = schedule.CreatedBy
		FROM dbo.Schedule schedule WITH (NOLOCK)
		INNER JOIN dbo.ScheduleEvent scheduleEvent WITH (NOLOCK) ON scheduleEvent.EventId = schedule.EventId
		WHERE schedule.ClientId = @clientId AND schedule.IsDeleted = 0 AND schedule.AttendanceStatus IN (1, 2, 3) AND scheduleEvent.EventName = 'Physician Review'
		ORDER BY schedule.Date
	
		EXEC dbo.ResetClientWorkflowState @clientId, @physicianReviewAttendedActionId, 7, @scheduleId, @scheduleDate, @scheduleCreatedBy
	END
END