CREATE proc [dbo].[ResetOFINonComplianceAfterSanction]
@clientIdFilter int = null
AS
DECLARE @clientId int
DECLARE @maxdatesubmitted datetime
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
DECLARE @sanctionRequestId int

declare @sanctionProcessDays int = 21

SELECT @nonComplianceBranchId = WorkflowBranchId FROM dbo.WorkflowBranch WHERE Code = 'NonCompliance'

SELECT @phoneActionId = WorkflowActionId FROM dbo.WorkflowAction WHERE Code = 'VerbalAttempt'
SELECT @mailActionId = WorkflowActionId FROM dbo.WorkflowAction WHERE Code = 'MailAttempt'
SELECT @homeActionId = WorkflowActionId FROM dbo.WorkflowAction WHERE Code = 'HomeVisit'
SELECT @sanctionRequestId = WorkflowActionId FROM dbo.WorkflowAction WHERE Code = 'SanctionRequest'

DECLARE cursorSchedule CURSOR -- Declare cursor
Dynamic
FOR

	-- Find all clients:
		-- 1. Open cases
		-- 2. In the non-compliance branch (WorkflowBranchId)
		-- 3. Had a sanction request submitted against the client after 21 days
		-- 4. Has not has its outreach attempts reset yet (outreachresetprocessed is null)
		--		or another sanction was submitted after having its outreachattempts reset
		-- 5. Has not had a sanction lifted since the sanction request was submitted
	
	SELECT clientid, maxdatesubmitted
	FROM
		(SELECT
			sanction_audit.clientid, 
			MAX(sanction_audit.datesubmitted) AS maxdatesubmitted
		FROM dbo.OFI_Interface_Sanction_audit sanction_audit
		INNER JOIN dbo.WorkflowClientBranch client_branch ON sanction_audit.clientid = client_branch.ClientId
		INNER JOIN dbo.Client client ON client.ClientId = client_branch.ClientId
		INNER JOIN dbo.[Case] [case] ON [case].CaseId = client.ActiveCaseId
		OUTER APPLY 
			(SELECT MAX(Sanction_EndDate) AS EndDate FROM dbo.ClientSanction WHERE ClientId = client.ClientId AND Sanction_EndDate IS NOT NULL) AS sanction
		WHERE	sanction_audit.datesubmitted IS NOT NULL AND
				sanction_audit.outreachresetprocessed IS NULL AND		
				client_branch.IsActive = 1 AND client_branch.WorkflowBranchId = @nonComplianceBranchId AND [case].StatusId = 'O' AND
				(sanction.EndDate IS NULL OR sanction_audit.datesubmitted > sanction.EndDate) AND
				(@clientIdFilter is null OR client.ClientId = @clientIdFilter)
		GROUP BY sanction_audit.clientid) AS sanctioned_clients
	WHERE DATEDIFF(d, maxdatesubmitted, getdate()) > @sanctionProcessDays

OPEN cursorSchedule -- open the cursor

FETCH NEXT FROM cursorSchedule INTO @clientId, @maxdatesubmitted

WHILE @@FETCH_STATUS = 0
BEGIN
	
	SET @phoneContactId = NULL
	SET @mailContactId = NULL
	SET @homeContactId = NULL

	/* Determine if the previous outreach attempts should be reset */
	SELECT 
		@nonComplianceClientId = Clientid,
		@nonComplianceScheduleId = ScheduleId,
		@phoneContactId = ClientContactId_Voice, 
		@mailContactId = ClientContacId_Mail, 
		@homeContactId = ClientContactId_Home,  
		@nonComplianceGoodCause = ClientContactId_NotApprovedGoodCause
	FROM dbo.CheckForNonCompliance (@clientId)

	/* Make the previous noncompliance activity of the client inactive (reset non-compliance outreach) */
	/* A null id indicates that the outreach type is no longer applicable (because it occurs more than 21 days ago) */
	IF @phoneContactId IS NULL
	BEGIN
		UPDATE dbo.WorkflowClientAction
		SET IsActive = 0, UpdatedAt = GETDATE(), UpdatedBy = 'ResetNonComplianceAfterSanctionProcessingPeriodPrc'
		FROM dbo.WorkflowClientAction ca
		INNER JOIN dbo.WorkflowAction a ON ca.WorkflowActionId = a.WorkflowActionId
		WHERE ca.ClientId = @clientId AND ca.WorkflowActionId = @phoneActionId AND IsActive = 1
	END

	IF @mailContactId IS NULL
	BEGIN
		UPDATE dbo.WorkflowClientAction
		SET IsActive = 0, UpdatedAt = GETDATE(), UpdatedBy = 'ResetNonComplianceAfterSanctionProcessingPeriodPrc'
		FROM dbo.WorkflowClientAction ca
		INNER JOIN dbo.WorkflowAction a ON ca.WorkflowActionId = a.WorkflowActionId
		WHERE ca.ClientId = @clientId AND ca.WorkflowActionId = @mailActionId AND IsActive = 1
	END

	IF @homeContactId IS NULL
	BEGIN
		UPDATE dbo.WorkflowClientAction
		SET IsActive = 0, UpdatedAt = GETDATE(), UpdatedBy = 'ResetNonComplianceAfterSanctionProcessingPeriodPrc'
		FROM dbo.WorkflowClientAction ca
		INNER JOIN dbo.WorkflowAction a ON ca.WorkflowActionId = a.WorkflowActionId
		WHERE ca.ClientId = @clientId AND ca.WorkflowActionId = @homeActionId AND IsActive = 1
	END

	/* Also reset the sanction request step */
	UPDATE dbo.WorkflowClientAction
	SET IsActive = 0, UpdatedAt = GETDATE(), UpdatedBy = 'ResetNonComplianceAfterSanctionProcessingPeriodPrc'
	FROM dbo.WorkflowClientAction ca
	INNER JOIN dbo.WorkflowAction a ON ca.WorkflowActionId = a.WorkflowActionId
	WHERE ca.ClientId = @clientId AND ca.WorkflowActionId = @sanctionRequestId AND IsActive = 1

	/* Indicate that we processed the outreach reset for the client (mark all of the audit records for the client if there are more than one) */
	UPDATE [dbo].[OFI_Interface_Sanction_audit]
	SET outreachresetprocessed = GETDATE()
	WHERE clientid = @clientId AND datesubmitted = @maxdatesubmitted

	FETCH NEXT FROM cursorSchedule INTO @clientId, @maxdatesubmitted
END
CLOSE cursorSchedule -- close the cursor
DEALLOCATE cursorSchedule -- Deallocate the cursor
