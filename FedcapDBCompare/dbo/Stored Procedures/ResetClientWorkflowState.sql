CREATE PROCEDURE [dbo].[ResetClientWorkflowState] 
@clientId INT, @actionId INT, @sourceTableId INT, @sourceRecId INT, @processName VARCHAR(50)
AS
BEGIN		
	SET NOCOUNT ON;

	/* A null id indicates that the action is no longer applicable */
	IF @sourceRecId IS NULL
		BEGIN
			UPDATE dbo.WorkflowClientAction
			SET IsActive = 0, UpdatedAt = GETDATE(), UpdatedBy = @processName
			FROM dbo.WorkflowClientAction ca
			WHERE ca.ClientId = @clientId AND ca.WorkflowActionId = @actionId AND IsActive = 1
		END
	ELSE
		BEGIN
			IF NOT EXISTS (SELECT WorkflowClientActionId FROM dbo.WorkflowClientAction WHERE ClientId = @clientId AND IsActive = 1 AND WorkflowActionId = @actionId AND SourceTableId = @sourceTableId AND SourceRecId = @sourceRecId)
				BEGIN
					IF EXISTS (SELECT WorkflowClientActionId FROM dbo.WorkflowClientAction WHERE ClientId = @clientId AND IsActive = 0 AND WorkflowActionId = @actionId AND SourceTableId = @sourceTableId AND SourceRecId = @sourceRecId)
						UPDATE dbo.WorkflowClientAction
						SET IsActive = 1, UpdatedAt = GETDATE(), UpdatedBy = @processName
						FROM dbo.WorkflowClientAction ca
						WHERE ca.ClientId = @clientId AND ca.WorkflowActionId = @actionId AND SourceTableId = @sourceTableId AND SourceRecId = @sourceRecId AND IsActive = 0
					ELSE
						INSERT INTO dbo.WorkflowClientAction ([ClientId], [WorkflowActionId], [CreatedBy], [CreatedAt], [SourceTableId], [SourceRecId], [IsActive])
						VALUES (@clientId, @actionId, @processName, GETDATE(), @sourceTableId, @sourceRecId, 1)
				END
		END
END
