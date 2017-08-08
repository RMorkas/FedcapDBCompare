
CREATE PROCEDURE [dbo].[GetUncompletedWorkflowPrerequisites] @companyId INT, @clientId INT, @actionCode varchar(50)	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT DISTINCT
	    pa.Description
    FROM dbo.WorkflowRule w
    INNER JOIN dbo.WorkflowAction a ON a.WorkflowActionId = w.WorkflowActionId
    INNER JOIN dbo.WorkflowAction pa ON pa.WorkflowActionId = w.WorkflowPrerequisiteActionId
    LEFT JOIN dbo.WorkflowClientAction ca ON ca.WorkflowActionId = w.WorkflowPrerequisiteActionId AND ca.ClientId = @clientId AND ca.IsActive = 1 AND ca.IsDeleted = 0
	LEFT JOIN dbo.WorkflowClientBranch cb ON cb.ClientId = @clientId AND cb.WorkflowBranchId = w.WorkflowBranchId AND cb.IsActive = 1
    LEFT JOIN dbo.WorkflowClientCondition cc ON cc.ClientId = @clientId AND cc.WorkflowConditionId = w.WorkflowConditionId
    WHERE w.CompanyId = @companyId AND 
		a.Code = @actionCode AND 
		(w.WorkflowConditionId IS NULL OR cc.WorkflowConditionId IS NOT NULL) AND 
		(w.WorkflowBranchId IS NULL OR cb.WorkflowBranchId IS NOT NULL)  AND
		ca.WorkflowActionId IS NULL

END