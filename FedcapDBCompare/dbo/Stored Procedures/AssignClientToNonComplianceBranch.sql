CREATE PROCEDURE [dbo].[AssignClientToNonComplianceBranch] 
@clientId INT,
@sourceTable VARCHAR(50)=NULL,
@sourceRecId INT=NULL
AS
BEGIN	
	DECLARE @currentBranchId INT, @nonComplianceBranchId INT, @sourceTableId INT

	SET NOCOUNT ON;

	/* Get Source Table */
	SELECT @sourceTableId = TableId FROM dbo.Fed_LogTables WITH (NOLOCK) WHERE TableName = @sourceTable

	/* Get Noncompliance branch Id */
	SELECT @nonComplianceBranchId = WorkflowBranchId FROM dbo.WorkflowBranch WITH (NOLOCK) WHERE Code = 'NonCompliance'

	/* Get current branch (track) of client */
	SELECT TOP 1 @currentBranchId = WorkflowBranchId 
	FROM dbo.WorkflowClientBranch 
	WHERE ClientId = @clientId AND IsActive = 1
	ORDER BY WorkflowClientBranchId DESC

	/* If the client is already on the noncompliance branch then exit  */
	IF @currentBranchId IS NOT NULL AND @currentBranchId = @nonComplianceBranchId
		RETURN

	/* Make the client's previous branches inactive */
	UPDATE dbo.WorkflowClientBranch
	SET IsActive = 0, LastUpdated = GETDATE()
	WHERE ClientId = @clientId AND IsActive = 1

	/* Move the client to the noncompliance track */
	INSERT INTO dbo.WorkflowClientBranch (ClientId, WorkflowBranchId, CreatedAt, LastUpdated, IsActive, SourceTableId, SourceRecId)
	VALUES (@clientId, @nonComplianceBranchId, GETDATE(), GETDATE(), 1, @sourceTableId, @sourceRecId)

	/* Make the previous noncompliance activity of the client inactive */
	UPDATE dbo.WorkflowClientAction
	SET IsActive = 0, UpdatedAt = GETDATE(), UpdatedBy = 'SYSTEM'
	FROM dbo.WorkflowClientAction ca
	INNER JOIN dbo.WorkflowAction a ON ca.WorkflowActionId = a.WorkflowActionId
	WHERE ca.ClientId = @clientId AND a.WorkflowBranchId = @nonComplianceBranchId AND IsActive = 1

END
