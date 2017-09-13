
CREATE PROCEDURE [dbo].[ResetClientWorkflow] 
@clientId INT
AS
BEGIN		
	SET NOCOUNT ON;

	UPDATE dbo.WorkflowClientBranch
	SET IsActive = 0, LastUpdated = GETDATE()
	WHERE ClientId = @clientId

	UPDATE dbo.WorkflowClientAction
	SET IsActive = 0, UpdatedAt = GETDATE(), UpdatedBy = 'ResetClientWorkflow'
	WHERE ClientId = @clientId	

	/* Assign client back to Orientation branch */
	exec dbo.AssignClientToWorkflowBranch @clientId, 8
END