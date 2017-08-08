CREATE procedure [dbo].[OFI_Interface_Extension_updateAudit]
as
begin
	update [dbo].[OFI_Interface_Extension_Audit] set datesubmitted = getdate() where datediff(d,dateadded,getdate()) = 0 

	update dbo.ClientExtensionRequest set islocked =1,UpdatedAt = getdate(), UpdatedBy='FEDCAP\ExtensionInterface'
	where (isnull(islocked,0) = 0) and dbo.ClientExtensionRequest.ExtensionRequestId in
	(select  [dbo].[OFI_Interface_Extension_Audit].ExtensionRequestid  from [dbo].[OFI_Interface_Extension_Audit] with (nolock))

	update dbo.ClientExtensionRequest set RequestStatus =1 ,UpdatedAt = getdate(), UpdatedBy='FEDCAP\ExtensionInterface'
	where (isnull(RequestStatus,0) = 0) and dbo.ClientExtensionRequest.ExtensionRequestId in
	(select  [dbo].[OFI_Interface_Extension_Audit].ExtensionRequestid  from [dbo].[OFI_Interface_Extension_Audit] with (nolock))
end

