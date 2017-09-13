CREATE PROCEDURE [dbo].[ResetClientNonComplianceWorkflow] 
@clientId INT
AS
BEGIN		
	SET NOCOUNT ON;

	DECLARE @nonComplianceBranchId int
	DECLARE @nonComplianceClientId int
	DECLARE @nonComplianceScheduleId int
	DECLARE @phoneContactId int
	DECLARE @mailContactId int
	DECLARE @homeContactId int
	DECLARE @nonComplianceGoodCause int
	DECLARE @phoneActionId int
	DECLARE @mailActionId int
	DECLARE @homeActionId int
	DECLARE @sanctionRequestActionId int
	DECLARE @absentScheduleDate datetime

	SELECT @nonComplianceBranchId = WorkflowBranchId FROM dbo.WorkflowBranch WHERE Code = 'NonCompliance'
	SELECT @phoneActionId = WorkflowActionId FROM dbo.WorkflowAction WHERE Code = 'VerbalAttempt'
	SELECT @mailActionId = WorkflowActionId FROM dbo.WorkflowAction WHERE Code = 'MailAttempt'
	SELECT @homeActionId = WorkflowActionId FROM dbo.WorkflowAction WHERE Code = 'HomeVisit'
	SELECT @sanctionRequestActionId = WorkflowActionId FROM dbo.WorkflowAction WHERE Code = 'SanctionRequest'

	SELECT 
		@nonComplianceClientId = Clientid,
		@nonComplianceScheduleId = ScheduleId,
		@phoneContactId = ClientContactId_Voice, 
		@mailContactId = ClientContacId_Mail, 
		@homeContactId = ClientContactId_Home,  
		@nonComplianceGoodCause = ClientContactId_NotApprovedGoodCause
	FROM dbo.CheckForNonCompliance (@clientId)

	IF EXISTS (SELECT ClientId FROM dbo.Client WHERE ClientId = @clientId AND SanctionEffectiveDate IS NOT NULL)
	BEGIN
		EXEC dbo.ProcessSanctionAttendedActivityWorkflow @clientId
	END
	ELSE
		BEGIN
			IF @nonComplianceScheduleId IS NULL
				BEGIN
					/* No absent schedule was returned so we can take client out of non-compliance */
					EXEC dbo.RemoveClientFromNonComplianceTrack @clientId
				END
			ELSE
				BEGIN
					/* Absent schedule was returned so client will be assigned to the non-compliance branch */
					EXEC dbo.AssignClientToNonComplianceBranch @clientId, 'Schedule', @nonComplianceScheduleId

					/* Phone outreach */
					EXEC dbo.ResetClientWorkflowState @clientId, @phoneActionId, 14, @phoneContactId, NULL, 'ResetClientNonComplianceWorkflow'
					
					/* Mail outreach */
					EXEC dbo.ResetClientWorkflowState @clientId, @mailActionId, 14, @mailContactId, NULL, 'ResetClientNonComplianceWorkflow'

					/* Home outreach */
					EXEC dbo.ResetClientWorkflowState @clientId, @homeActionId, 14, @homeContactId, NULL, 'ResetClientNonComplianceWorkflow'

					/* See if there was a sanction request sent after the missed activity */
					SELECT @absentScheduleDate = [Date] FROM dbo.Schedule WHERE ScheduleId = @nonComplianceScheduleId

					/* If all of the outreach attempts are complete then see if we need to set the SanctionRequest state to active */
					IF @phoneActionId IS NOT NULL AND @mailActionId IS NOT NULL AND @homeActionId IS NOT NULL AND 
						EXISTS (SELECT Id FROM dbo.OFI_Interface_Sanction_audit WHERE ClientId = @clientId AND datesubmitted > @absentScheduleDate)
					BEGIN
						/* If there was sanction request sent after the missed activity then just set the existing WorkflowClientAction record for 
						the sanction request to active */
						IF EXISTS (SELECT WorkflowClientActionId FROM dbo.WorkflowClientAction WHERE ClientId = @clientId AND WorkflowActionId = @sanctionRequestActionId AND IsActive = 0)
							UPDATE dbo.WorkflowClientAction
							SET IsActive = 1, UpdatedAt = GETDATE(), UpdatedBy = 'ResetClientNonComplianceWorkflow'
							FROM dbo.WorkflowClientAction ca
							WHERE ca.ClientId = @clientId AND ca.WorkflowActionId = @sanctionRequestActionId AND IsActive = 0
					END					
				END
			END
		
END
