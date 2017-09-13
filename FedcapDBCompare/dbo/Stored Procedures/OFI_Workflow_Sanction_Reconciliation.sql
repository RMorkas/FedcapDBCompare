CREATE proc [dbo].[OFI_Workflow_Sanction_Reconciliation]
@clientIdFilter int = null /* used for testing a single client - should be null in production job */
AS
DECLARE @clientId int
DECLARE @nonComplianceBranchId int
DECLARE @sanctionDecisionId int
DECLARE @sanctionLiftRequestId int
DECLARE @sanctionLiftedId int
DECLARE @lastProcessedDate DATETIME
DECLARE @nonComplianceClientId INT
DECLARE @nonComplianceScheduleId INT
DECLARE @phoneContactId INT
DECLARE @mailContactId INT
DECLARE @homeContactId INT
DECLARE @nonComplianceGoodCause INT
DECLARE @sanctionBranchId INT
DECLARE @sanctionLiftBranchId INT

SELECT @nonComplianceBranchId = WorkflowBranchId FROM dbo.WorkflowBranch WHERE Code = 'NonCompliance'
SELECT @sanctionBranchId = WorkflowBranchId FROM dbo.WorkflowBranch WITH (NOLOCK) WHERE Code = 'Sanction'
SELECT @sanctionLiftBranchId = WorkflowBranchId FROM dbo.WorkflowBranch WITH (NOLOCK) WHERE Code = 'SanctionLift'
SELECT @sanctionDecisionId = WorkflowActionId FROM dbo.WorkflowAction WHERE Code = 'SanctionDecision'
SELECT @sanctionLiftRequestId = WorkflowActionId FROM dbo.WorkflowAction WHERE Code = 'SanctionLiftRequested'
SELECT @sanctionLiftedId = WorkflowActionId FROM dbo.WorkflowAction WHERE Code = 'SanctionLifted'

/* Sanction Decision */
/* Get all sanctions approved by OFI that are not represented in the WorkflowClientAction table as SanctionDecision states */
/* and default the IsActive flag to 0 */
INSERT INTO dbo.WorkflowClientAction (ClientId, WorkflowActionId, CreatedBy, CreatedAt, SourceRecId, IsActive)
	SELECT cs.ClientId, @sanctionDecisionId, 'OFI_Sanction_Workflow_Reconciliation', cs.Sanction_StartDate, cs.Id, 0
	FROM [dbo].[ClientSanction] cs
	LEFT JOIN dbo.WorkflowClientAction wca ON wca.SourceRecId = cs.Id AND wca.WorkflowActionId = @sanctionDecisionId
	WHERE wca.WorkflowClientActionId IS NULL AND cs.Sanction_StartDate IS NOT NULL AND
		(@clientIdFilter IS NULL OR cs.ClientId = @clientIdFilter)	

/* A sanction decision state is active if the start of the sanction approval is before today but the end date is null
and the case of the client is open */
UPDATE dbo.WorkflowClientAction 
SET IsActive = 1, UpdatedBy = 'OFI_Sanction_Workflow_Reconciliation', UpdatedAt = GETDATE()
FROM dbo.WorkflowClientAction wca
INNER JOIN [dbo].[ClientSanction] cs ON wca.SourceRecId = cs.Id AND wca.WorkflowActionId = @sanctionDecisionId
INNER JOIN dbo.Client client on wca.ClientId = client.ClientId
INNER JOIN dbo.[Case] [case] on [case].CaseId = client.ActiveCaseId
WHERE wca.IsActive = 0 AND [case].StatusId = 'O' AND client.ExemptionEffectiveDate IS NULL AND 
		DATEDIFF(d, cs.Sanction_StartDate, GETDATE()) >= 0 AND cs.Sanction_EndDate IS NULL AND
		(@clientIdFilter IS NULL OR wca.ClientId = @clientIdFilter)	

/* Sanction Lift Request */
/* Get all of the sanction lift requests that are not represented in the WorkflowClientAction table as SanctionLiftRequested states */
INSERT INTO dbo.WorkflowClientAction (ClientId, WorkflowActionId, CreatedBy, CreatedAt, SourceRecId, IsActive)
	SELECT changedata.ClientId, @sanctionLiftRequestId, 'OFI_Sanction_Workflow_Reconciliation', changedata.changeDate, changedata.Id, 0
	FROM [dbo].[OFI_Interface_changedata_audit] changedata
	LEFT JOIN dbo.WorkflowClientAction wca ON wca.SourceRecId = changedata.Id AND wca.WorkflowActionId = @sanctionLiftRequestId
	WHERE wca.WorkflowClientActionId IS NULL AND changedata.Sanction_complied_ind = '1' AND
		(@clientIdFilter IS NULL OR changedata.ClientId = @clientIdFilter)	

/* A sanction lift request is active if there were no sanctions with a start date after the lift request (e.g. this lift request is for the
most recent sanction) and the most recent sanction has not expired. That means that the lift request has not yet been accepted 
Also check that the client is currently sanctioned (client.SanctionEffectiveDate IS NOT NULL) */
UPDATE dbo.WorkflowClientAction 
SET IsActive = 1, UpdatedBy = 'OFI_Sanction_Workflow_Reconciliation', UpdatedAt = GETDATE()
FROM dbo.WorkflowClientAction wca
INNER JOIN [dbo].[OFI_Interface_changedata_audit] changedata ON wca.SourceRecId = changedata.Id AND changedata.Sanction_complied_ind = '1'
INNER JOIN dbo.Client client on wca.ClientId = client.ClientId
INNER JOIN dbo.[Case] [case] on [case].CaseId = client.ActiveCaseId
WHERE wca.WorkflowActionId = @sanctionLiftRequestId AND wca.IsActive = 0 AND [case].StatusId = 'O' AND 
		client.ExemptionEffectiveDate IS NULL AND client.SanctionEffectiveDate IS NOT NULL AND
		NOT EXISTS (
			SELECT Id FROM dbo.ClientSanction sanction 
			WHERE sanction.Clientid = wca.ClientId AND (DATEDIFF(d, changedata.changeDate, Sanction_StartDate) > 0 OR
			DATEDIFF(d, sanction.Sanction_EndDate, GETDATE()) > 0)) AND
		(@clientIdFilter IS NULL OR wca.ClientId = @clientIdFilter)		

/* Sanction Lift */
/* Get all of the sanction records where the end date is on or before today
that are not represented in the WorkflowClientAction table as SanctionLifted states */
INSERT INTO dbo.WorkflowClientAction (ClientId, WorkflowActionId, CreatedBy, CreatedAt, SourceRecId, IsActive)
	SELECT sanction.ClientId, @sanctionLiftedId, 'OFI_Sanction_Workflow_Reconciliation', sanction.Sanction_EndDate, sanction.Id, 0
	FROM [dbo].[ClientSanction] sanction
	LEFT JOIN dbo.WorkflowClientAction wca ON wca.SourceRecId = sanction.Id AND wca.WorkflowActionId = @sanctionLiftedId
	WHERE wca.WorkflowClientActionId IS NULL AND DATEDIFF(d, sanction.Sanction_EndDate, GETDATE()) >= 0 AND
		(@clientIdFilter IS NULL OR sanction.ClientId = @clientIdFilter)	

/* Since this stored procedure is part of the OFI_ME_Changes job find the date that the job was last run */
SELECT TOP 1 @lastProcessedDate = CreateDate FROM dbo.Service_Job
WHERE Name = 'FedCapSysBL.OFIFileProcessing.OFI_ME_Changes' AND Processed = 1
ORDER BY CreateDate DESC

/* Take clients  out of non-compliance */
DECLARE cursorSchedule CURSOR -- Declare cursor
Dynamic
FOR
	-- Find all clients had a sanction lifted before the last time this stored proc was processed
	-- and do not currently have another open sanction
	SELECT sanction.ClientId
	FROM dbo.ClientSanction sanction
	WHERE sanction.Sanction_EndDate IS NOT NULL AND 
			(@lastProcessedDate IS NULL OR DATEDIFF(d, @lastProcessedDate, sanction.Sanction_EndDate) >= 0) AND 
			DATEDIFF(d, sanction.Sanction_EndDate, GETDATE()) >= 0 AND 
			NOT EXISTS (SELECT Id FROM dbo.ClientSanction WHERE ClientId = sanction.Clientid AND Sanction_EndDate IS NULL) AND
			(@clientIdFilter IS NULL OR sanction.ClientId = @clientIdFilter)

OPEN cursorSchedule -- open the cursor

FETCH NEXT FROM cursorSchedule INTO @clientId

WHILE @@FETCH_STATUS = 0
BEGIN

	-- If the client does not currently have a missed appointment taken him/her out of the non-compliance track
	SET @nonComplianceScheduleId = NULL

	SELECT 
		@nonComplianceClientId = Clientid,
		@nonComplianceScheduleId = ScheduleId,
		@phoneContactId = ClientContactId_Voice, 
		@mailContactId = ClientContacId_Mail, 
		@homeContactId = ClientContactId_Home,  
		@nonComplianceGoodCause = ClientContactId_NotApprovedGoodCause
	FROM dbo.CheckForNonCompliance (@clientId)
	
	IF (@nonComplianceScheduleId IS NULL)
	BEGIN
		/* Remove from non-compliance track if necessary */
		EXEC [dbo].[RemoveClientFromNonComplianceTrack] @clientId
	END

	/* Clear sanction and sanction lift states */
	UPDATE dbo.WorkflowClientAction
	SET IsActive = 0, UpdatedBy = 'SYSTEM', UpdatedAt = GETDATE()
	FROM dbo.WorkflowClientAction ca
	INNER JOIN dbo.WorkflowAction a ON ca.WorkflowActionId = a.WorkflowActionId
	WHERE ca.ClientId = @clientId AND ca.IsActive = 1 AND 
		(a.WorkflowBranchId = @sanctionBranchId OR a.WorkflowBranchId = @sanctionLiftBranchId)

	FETCH NEXT FROM cursorSchedule INTO @clientId
END
CLOSE cursorSchedule -- close the cursor
DEALLOCATE cursorSchedule -- Deallocate the cursor
