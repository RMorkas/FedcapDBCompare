CREATE PROCEDURE [dbo].[RemoveClientFromNonComplianceTrack] 
@clientId INT
AS
BEGIN	
	SET NOCOUNT ON;

	DECLARE @nonComplianceBranchId INT
	DECLARE @orientationBranchId INT
	DECLARE @currentBranchId INT
	DECLARE @branchIdToAssign INT

	/* Get Noncompliance branch Id */
	SELECT @nonComplianceBranchId = WorkflowBranchId FROM dbo.WorkflowBranch WITH (NOLOCK) WHERE Code = 'NonCompliance'

	/* Get Orientation branch Id */
	SELECT @orientationBranchId = WorkflowBranchId FROM dbo.WorkflowBranch WITH (NOLOCK) WHERE Code = 'Orientation'

	/* Get current branch (track) of client */
	SELECT TOP 1 @currentBranchId = WorkflowBranchId 
	FROM dbo.WorkflowClientBranch 
	WHERE ClientId = @clientId AND IsActive = 1
	ORDER BY WorkflowClientBranchId DESC

	/* If the client does not currently have a branch or is not in non-cpliance exit */
	IF @currentBranchId IS NULL OR @currentBranchId <> @nonComplianceBranchId
		RETURN

	/* Find the most recent track (branch) record for the client that is not non-compliance */
	SELECT TOP 1 @branchIdToAssign = WorkflowBranchId FROM dbo.WorkflowClientBranch
	WHERE ClientId = @clientId AND WorkflowBranchId <> @nonComplianceBranchId
	ORDER BY WorkflowClientBranchId DESC

	/* If the client is only in the non-compliance branch then assign the client to Orientation */
	IF @branchIdToAssign IS NULL
		SET @branchIdToAssign = @orientationBranchId

	/* Assign the client to the new branch */
	exec dbo.AssignClientToWorkflowBranch @clientId, @branchIdToAssign

	/* Make the previous non-compliance and sanction activity of the client inactive */
	UPDATE dbo.WorkflowClientAction
	SET IsActive = 0, UpdatedBy = 'SYSTEM', UpdatedAt = GETDATE()
	FROM dbo.WorkflowClientAction ca
	INNER JOIN dbo.WorkflowAction a ON ca.WorkflowActionId = a.WorkflowActionId
	WHERE ca.ClientId = @clientId AND ca.IsActive = 1 AND a.WorkflowBranchId = @nonComplianceBranchId

END
