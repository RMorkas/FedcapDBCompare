CREATE PROCEDURE [dbo].[ProcessSanctionAttendedActivityWorkflow] 
@clientId INT
AS
BEGIN		

	DECLARE @firstAttenanceScheduleId INT
	DECLARE @secondAttenanceScheduleId INT
	DECLARE @thirdAttenanceScheduleId INT	
	DECLARE @presentAfterSanction1Id int
	DECLARE @presentAfterSanction2Id int
	DECLARE @presentAfterSanction3Id int

	SET NOCOUNT ON

	SELECT @presentAfterSanction1Id = WorkflowActionId FROM dbo.WorkflowAction WHERE Code = 'AttendanceAfterSanction1'
	SELECT @presentAfterSanction2Id = WorkflowActionId FROM dbo.WorkflowAction WHERE Code = 'AttendanceAfterSanction2'
	SELECT @presentAfterSanction3Id = WorkflowActionId FROM dbo.WorkflowAction WHERE Code = 'AttendanceAfterSanction3'

	DECLARE @AttendedActivities TABLE
	(
		FirstScheduleId INT,
		SecondScheduleId INT,
		ThirdScheduleId INT
	)

	IF EXISTS (SELECT ClientId FROM dbo.Client WHERE ClientId = @clientId AND SanctionEffectiveDate IS NOT NULL)
	BEGIN
			INSERT INTO @AttendedActivities
			SELECT TOP 1 
				attendedcount1.ScheduleId AS FirstScheduleId,				
				attendedcount2.ScheduleId AS SecondScheduleId, 
				attendedcount3.ScheduleId AS ThirdScheduleId
			FROM dbo.Schedule attendedcount1 
			INNER JOIN dbo.client ON dbo.client.clientid = attendedcount1.clientid
			OUTER APPLY (select top 1 attended.Scheduleid, attended.date, attended.ClassInstRoomId  
						from dbo.schedule attended 
						where attended.clientid = dbo.client.clientid and attended.isdeleted = 0 and (DATEDIFF(d, attended.Date, GETDATE()) >= 0) and 
							attended.attendancestatus in (1,2) and  datediff(d,attendedcount1.date, attended.date) > 0
						order by attended.date)  attendedcount2			
			OUTER APPLY (select top 1 attended.Scheduleid, attended.date, attended.ClassInstRoomId     
						from dbo.schedule attended 
						where attended.clientid =  dbo.client.clientid and  attended.isdeleted = 0 and 
						(DATEDIFF(d, attended.Date, GETDATE()) >= 0) and attended.attendancestatus in (1,2) and datediff(d,attendedcount2.date, attended.date) > 0
						order by attended.date)  attendedcount3
			WHERE dbo.Client.ClientID = @clientId AND 
				attendedcount1.attendancestatus IN (1,2) AND 
				attendedcount1.IsDeleted = 0 AND 
				DATEDIFF(d, dbo.client.sanctioneffectivedate, attendedcount1.Date) >= 0 AND
				(attendedcount1.ScheduleId is not null 
					and not exists (
						select missed.date as totalcountofattended  
						from dbo.schedule missed  
						where missed.clientid = dbo.client.clientid and 
							missed.isdeleted = 0 and 
							missed.attendancestatus in (3,4) and
							((attendedcount2.[date] is null and attendedcount3.[date] is null and DATEDIFF(mi, attendedcount1.[date], missed.Date) >= 0) or
							(attendedcount2.[date] is not null and attendedcount3.[date] is null and (DATEDIFF(mi, attendedcount1.[date], missed.Date) >= 0 or DATEDIFF(d, attendedcount2.[date], missed.Date) >= 0)) or
							(attendedcount2.[date] is not null and attendedcount3.[date] is not null and (DATEDIFF(mi, attendedcount1.[date], missed.Date) >= 0 or DATEDIFF(d, attendedcount2.[date], missed.Date) >= 0 or datediff(d, attendedcount3.[date], missed.Date) >= 0))))	
				)
			ORDER BY attendedcount1.Date
		
			IF EXISTS (SELECT * FROM @AttendedActivities WHERE FirstScheduleId IS NOT NULL)
			BEGIN
				SELECT	@firstAttenanceScheduleId = FirstScheduleId, 						
						@secondAttenanceScheduleId = SecondScheduleId, 
						@thirdAttenanceScheduleId = ThirdScheduleId					
				FROM @AttendedActivities				

				EXEC dbo.ResetClientWorkflowState @clientId, @presentAfterSanction1Id, 7, @firstAttenanceScheduleId, NULL, 'ProcessSanctionAttendedActivityWorkflow'
				EXEC dbo.ResetClientWorkflowState @clientId, @presentAfterSanction2Id, 7, @secondAttenanceScheduleId, NULL, 'ProcessSanctionAttendedActivityWorkflow'
				EXEC dbo.ResetClientWorkflowState @clientId, @presentAfterSanction3Id, 7, @thirdAttenanceScheduleId, NULL, 'ProcessSanctionAttendedActivityWorkflow'

				RETURN
			END	
					
			EXEC dbo.ResetClientWorkflowState @clientId, @presentAfterSanction1Id, 7, NULL, NULL, 'ProcessSanctionAttendedActivityWorkflow'
			EXEC dbo.ResetClientWorkflowState @clientId, @presentAfterSanction2Id, 7, NULL, NULL, 'ProcessSanctionAttendedActivityWorkflow'
			EXEC dbo.ResetClientWorkflowState @clientId, @presentAfterSanction3Id, 7, NULL, NULL, 'ProcessSanctionAttendedActivityWorkflow'
	END
END