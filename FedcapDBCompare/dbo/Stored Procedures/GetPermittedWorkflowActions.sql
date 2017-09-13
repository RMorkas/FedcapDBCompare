CREATE PROCEDURE [dbo].[GetPermittedWorkflowActions] @companyId INT, @clientId INT
AS
BEGIN	
	SET NOCOUNT ON;

	-- Get all workflow actions where the client completed at least one of the required prerequistes specified in
	-- WorkflowRules
    SELECT
	    a.Code,
	    a.Description,
		a.WorkflowActionId,
		a.WorkflowBranchId
    FROM dbo.WorkflowRule (nolock) w
    INNER JOIN dbo.WorkflowAction (nolock) a ON a.WorkflowActionId = w.WorkflowActionId
    INNER JOIN dbo.WorkflowClientAction (nolock) ca ON ca.WorkflowActionId = w.WorkflowPrerequisiteActionId AND ca.ClientId = @clientId AND ca.IsActive = 1 AND ca.IsDeleted = 0
	LEFT JOIN dbo.WorkflowClientBranch (nolock) cb ON cb.ClientId = ca.ClientId AND cb.WorkflowBranchId = w.WorkflowBranchId AND cb.IsActive = 1
    LEFT JOIN dbo.WorkflowClientCondition (nolock) cc ON cc.ClientId = ca.ClientId AND cc.WorkflowConditionId = w.WorkflowConditionId 
    WHERE w.CompanyId = @companyId AND 
	    (w.DaysBeforePending IS NULL OR DATEDIFF(d, ca.CreatedAt, GETDATE()) >= w.DaysBeforePending) AND
		(w.WorkflowConditionId IS NULL OR cc.WorkflowConditionId IS NOT NULL) AND
		(w.WorkflowBranchId IS NULL OR cb.WorkflowBranchId IS NOT NULL) AND 
		w.WorkflowActionId NOT IN -- Filter out actions that the client did not complete at least one of the prerequistes
		(
		    SELECT
			    a.WorkflowActionId			
		    FROM dbo.WorkflowRule (nolock) w
		    INNER JOIN dbo.WorkflowAction (nolock) a ON a.WorkflowActionId = w.WorkflowActionId		
		    LEFT JOIN dbo.WorkflowClientAction (nolock) ca ON ca.WorkflowActionId = w.WorkflowPrerequisiteActionId AND ca.ClientId = @clientId AND ca.IsActive = 1 AND ca.IsDeleted = 0
			LEFT JOIN dbo.WorkflowClientBranch (nolock) cb ON cb.WorkflowBranchId = w.WorkflowBranchId AND cb.ClientId = @clientId AND cb.IsActive = 1
		    LEFT JOIN dbo.WorkflowClientCondition (nolock) cc ON cc.WorkflowConditionId = w.WorkflowConditionId
				AND cc.ClientId = @clientId
		    WHERE w.CompanyId = @companyId AND
			    (w.DaysBeforePending IS NULL OR DATEDIFF(d, ca.CreatedAt, GETDATE()) >= w.DaysBeforePending) AND
				(w.WorkflowConditionId IS NULL OR cc.WorkflowConditionId IS NOT NULL) AND
				(w.WorkflowBranchId IS NULL OR cb.WorkflowBranchId IS NOT NULL) AND 
				ca.WorkflowActionId IS NULL
		)


END