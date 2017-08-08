CREATE procedure [dbo].[OFI_Interface_Sanction_updateAudit]
as
begin
	Declare @SanctionWorkflowActionId int
		
	SELECT @SanctionWorkflowActionId=WorkflowActionId FROM dbo.WorkflowAction WHERE Code = 'SanctionRequest'
	--select @SanctionWorkflowActionId


	--updating status of sanction requests audit table
	update [dbo].[OFI_Interface_Sanction_Audit] set datesubmitted = getdate() where
		 datediff(d,dateadded,getdate()) = 0 and datesubmitted is null 

	--updating state machine with new sanction requests
	INSERT INTO dbo.WorkflowClientAction (clientid, workflowactionid, createdby, createdat)
	select  clientId, @SanctionWorkflowActionId, 'SanctionProcess', dbo.OFI_Interface_Sanction_audit.datesubmitted
	from dbo.OFI_Interface_Sanction_audit 
	-- we need to check that the client/action/date was not posted to state machine 
	where dbo.OFI_Interface_Sanction_audit.datesubmitted is not null and not exists 
				(select workflowclientactionid from dbo.WorkflowClientAction existingactions 
				where existingactions.clientid = dbo.OFI_Interface_Sanction_audit.clientid and existingactions.workflowactionid = @SanctionWorkflowActionId 
				and datediff(d,existingactions.CreatedAt,dbo.OFI_Interface_Sanction_audit.datesubmitted) = 0 )

end