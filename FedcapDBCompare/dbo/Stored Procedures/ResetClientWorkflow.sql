
CREATE PROCEDURE [dbo].[ResetClientWorkflow] 
@clientId INT
AS
BEGIN		
	SET NOCOUNT ON;

	UPDATE dbo.WorkflowClientBranch
	SET IsActive = 0
	WHERE ClientId = @clientId

	UPDATE dbo.WorkflowClientAction
	SET IsActive = 0
	WHERE ClientId = @clientId	
END