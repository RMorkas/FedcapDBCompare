CREATE PROCEDURE [dbo].[GetWorkflowPrerequisites] @companyId INT, @clientId INT, @actionCode varchar(50)	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		pa.Code  		
	FROM dbo.WorkflowRule (nolock) w
	INNER JOIN dbo.WorkflowAction (nolock) a ON a.WorkflowActionId = w.WorkflowActionId
	INNER JOIN dbo.WorkflowAction (nolock) pa ON pa.WorkflowActionId = w.WorkflowPrerequisiteActionId
	WHERE w.CompanyId = @companyId AND 
		a.Code = @actionCode

END