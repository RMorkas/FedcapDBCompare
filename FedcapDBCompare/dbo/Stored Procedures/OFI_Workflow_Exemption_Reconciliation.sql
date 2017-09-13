CREATE proc [dbo].[OFI_Workflow_Exemption_Reconciliation]
@clientIdFilter int = null /* used for testing a single client - should be null in production job */
AS

DECLARE @clientId INT
DECLARE @nonComplianceBranchId INT
DECLARE @sanctionBranchId INT
DECLARE @sanctionLiftBranchId INT

SELECT @nonComplianceBranchId = WorkflowBranchId FROM dbo.WorkflowBranch WHERE Code = 'NonCompliance'
SELECT @sanctionBranchId = WorkflowBranchId FROM dbo.WorkflowBranch WITH (NOLOCK) WHERE Code = 'Sanction'
SELECT @sanctionLiftBranchId = WorkflowBranchId FROM dbo.WorkflowBranch WITH (NOLOCK) WHERE Code = 'SanctionLift'

/* Take clients currently exempt out of non-compliance */
DECLARE cursorSchedule CURSOR -- Declare cursor
Dynamic
FOR
	-- Find all clients in which today is in the middle of the exemption (start date is before or on today and end date is NULL or after today)
	-- that are in the non-compliance branch ( they will be taken out of the non-compliance branch) 
	SELECT e.ClientId
	FROM dbo.OFI_ExemptionHistory e
	INNER JOIN dbo.WorkflowClientBranch client_branch ON e.ClientId = client_branch.ClientId
	WHERE DATEDIFF(d, e.StartDate, getdate()) >= 0 AND (e.EndDate IS NULL OR DATEDIFF(d, e.EndDate, getdate()) < 0) AND
		client_branch.IsActive = 1 AND client_branch.WorkflowBranchId = @nonComplianceBranchId AND
		(@clientIdFilter IS NULL OR e.ClientId = @clientIdFilter)

OPEN cursorSchedule -- open the cursor

FETCH NEXT FROM cursorSchedule INTO @clientId

WHILE @@FETCH_STATUS = 0
BEGIN
	
	EXEC [dbo].[RemoveClientFromNonComplianceTrack] @clientId

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
