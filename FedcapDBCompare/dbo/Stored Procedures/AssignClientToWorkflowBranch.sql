
CREATE PROCEDURE [dbo].[AssignClientToWorkflowBranch] 
@clientId INT,
@branchId INT,
@sourceTableId INT=NULL,
@sourceRecId INT=NULL
AS
BEGIN	
	DECLARE @workflowBranchId INT, @currentBranchId INT

	SET NOCOUNT ON;

	/* Get current branch (track) of client */
	SELECT TOP 1 @currentBranchId = WorkflowBranchId 
	FROM dbo.WorkflowClientBranch WITH (NOLOCK)
	WHERE ClientId = @clientId AND IsActive = 1
	ORDER BY WorkflowClientBranchId DESC

	/* If the client is already on the branch then exit  */
	IF @currentBranchId IS NOT NULL AND @currentBranchId = @branchId
		RETURN

	/* Make the client's previous branches inactive */
	UPDATE dbo.WorkflowClientBranch
	SET IsActive = 0, LastUpdated = GETDATE()
	WHERE ClientId = @clientId AND IsActive = 1

	INSERT INTO dbo.WorkflowClientBranch (ClientId, WorkflowBranchId, CreatedAt, LastUpdated, IsActive, SourceTableId, SourceRecId)
	VALUES (@clientId, @branchId, GETDATE(), GETDATE(), 1, @sourceTableId, @sourceRecId)

END