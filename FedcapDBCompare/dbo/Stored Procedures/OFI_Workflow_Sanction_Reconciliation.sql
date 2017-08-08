CREATE proc [dbo].[OFI_Workflow_Sanction_Reconciliation]
@clientIdFilter int = null /* used for testing a single client - should be null in production job */
AS
DECLARE @clientId int
DECLARE @nonComplianceBranchId int

SELECT @nonComplianceBranchId = WorkflowBranchId FROM dbo.WorkflowBranch WHERE Code = 'NonCompliance'

/* Sanction Approved */
/* Get all sanctions approved by OFI that are not represented (WorkflowActionId = 83) in the WorkflowClientAction table */
/* and default the IsActive flag to 0 */
INSERT INTO dbo.WorkflowClientAction (ClientId, WorkflowActionId, CreatedBy, CreatedAt, SourceRecId, IsActive)
	SELECT cs.ClientId, 83, 'OFI_Sanction_Workflow_Reconciliation', cs.Sanction_StartDate, cs.Id, 0
	FROM [dbo].[ClientSanction] cs
	LEFT JOIN dbo.WorkflowClientAction wca ON wca.SourceRecId = cs.Id AND wca.WorkflowActionId = 83
	WHERE wca.WorkflowClientActionId IS NULL AND cs.Sanction_StartDate IS NOT NULL AND
		(@clientIdFilter IS NULL OR cs.ClientId = @clientIdFilter)	

/* A sanction state is active if the start is before today but the end date is null or after today */
UPDATE dbo.WorkflowClientAction
SET IsActive = 1, UpdatedBy = 'OFI_Sanction_Workflow_Reconciliation', UpdatedAt = GETDATE()
FROM dbo.WorkflowClientAction wca
INNER JOIN [dbo].[ClientSanction] cs ON wca.SourceRecId = cs.Id AND wca.WorkflowActionId = 83
WHERE wca.IsActive = 0 AND DATEDIFF(d, cs.Sanction_StartDate, getdate()) >= 0 AND 
		(cs.Sanction_EndDate IS NULL OR DATEDIFF(d, cs.Sanction_EndDate, getdate()) < 0) AND
		(@clientIdFilter IS NULL OR wca.ClientId = @clientIdFilter)	

/* A sanction state is no longer active if there is a sanction request sent for the client later on */
UPDATE dbo.WorkflowClientAction
SET IsActive = 0, UpdatedBy = 'OFI_Sanction_Workflow_Reconciliation', UpdatedAt = GETDATE()
FROM dbo.WorkflowClientAction wca
WHERE wca.WorkflowActionId = 83	AND wca.IsActive = 1 AND 
	EXISTS (SELECT id FROM dbo.OFI_Interface_Sanction_audit sanction_request
			WHERE sanction_request.ClientId = wca.ClientId AND CONVERT(date, DATEADD(d, 1, wca.CreatedAt)) < CONVERT(date, sanction_request.datesubmitted)) AND
	(@clientIdFilter IS NULL OR wca.ClientId = @clientIdFilter)

/* Sanction Lift Requested */
/* Get all sanctions left requests sent to OFI that are not represented (WorkflowActionId = 84) in the WorkflowClientAction table */
/* Default IsActive to 0 */
INSERT INTO dbo.WorkflowClientAction (ClientId, WorkflowActionId, CreatedBy, CreatedAt, SourceRecId, IsActive)
	SELECT c.clientid, 84, 'OFI_Sanction_Workflow_Reconciliation', c.datesubmitted, c.id, 0
	FROM dbo.OFI_Interface_ChangeData_Audit c 
	LEFT JOIN dbo.WorkflowClientAction wca ON wca.SourceRecId = c.Id AND wca.WorkflowActionId = 84
	WHERE c.sanction_complied_ind = 1 AND wca.WorkflowClientActionId IS NULL AND
	(@clientIdFilter IS NULL OR c.ClientId = @clientIdFilter)

/* A sanction lift request state is active if the client has an active sanction before the sanction lift request */
UPDATE dbo.WorkflowClientAction
SET IsActive = 1, UpdatedBy = 'OFI_Sanction_Workflow_Reconciliation', UpdatedAt = GETDATE()
FROM dbo.WorkflowClientAction wca
INNER JOIN dbo.Client c ON c.ClientId = wca.ClientId
WHERE wca.WorkflowActionId = 84	AND wca.IsActive = 0 AND wca.CreatedAt > c.SanctionEffectiveDate AND
	(@clientIdFilter IS NULL OR wca.ClientId = @clientIdFilter)

/* A sanction lift request state is no longer active if the client no longer has an active sanction before the sanction lift request */
UPDATE dbo.WorkflowClientAction
SET IsActive = 0, UpdatedBy = 'OFI_Sanction_Workflow_Reconciliation', UpdatedAt = GETDATE()
FROM dbo.WorkflowClientAction wca
INNER JOIN dbo.Client c ON c.ClientId = wca.ClientId
WHERE wca.WorkflowActionId = 84	AND wca.IsActive = 1 AND (c.SanctionEffectiveDate IS NULL OR wca.CreatedAt < c.SanctionEffectiveDate) AND
	(@clientIdFilter IS NULL OR wca.ClientId = @clientIdFilter)

/* Sanction Lifted */
/* Get all sanctions lifted by OFI (when end date is not null and has passed) that are not represented (WorkflowActionId = 85) 
in the WorkflowClientAction table */
INSERT INTO dbo.WorkflowClientAction (ClientId, WorkflowActionId, CreatedBy, CreatedAt, SourceRecId, IsActive)
	SELECT cs.ClientId, 85, 'OFI_Sanction_Workflow_Reconciliation', cs.Sanction_EndDate, cs.Id, 0
	FROM [dbo].[ClientSanction] cs
	LEFT JOIN dbo.WorkflowClientAction wca ON wca.SourceRecId = cs.Id AND wca.WorkflowActionId = 85
	WHERE wca.WorkflowClientActionId IS NULL AND 
		(cs.Sanction_EndDate IS NOT NULL AND DATEDIFF(d, cs.Sanction_EndDate, GETDATE()) >= 0) AND
		(@clientIdFilter IS NULL OR cs.ClientId = @clientIdFilter)
