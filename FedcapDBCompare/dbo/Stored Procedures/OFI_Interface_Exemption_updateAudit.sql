CREATE procedure [dbo].[OFI_Interface_Exemption_updateAudit]
as
begin
	update [dbo].[OFI_Interface_Exemption_Audit] set datesubmitted = getdate() where datediff(d,dateadded,getdate()) = 0 

	update dbo.ExemptionRequest set islocked =1, UpdatedAt = getdate(), UpdatedBy='FEDCAP\ExemptionInterface'
	where (isnull(islocked,0)=0) and dbo.ExemptionRequest.ExemptionRequestId in
	(select  [dbo].[OFI_Interface_Exemption_Audit].ExemptionRequestId  from [dbo].[OFI_Interface_Exemption_Audit] with (nolock))

	update dbo.ExemptionRequest set RequestStatus =1, UpdatedAt = getdate(), UpdatedBy='FEDCAP\ExemptionInterface'
	where (isnull(RequestStatus,0) =0) and dbo.ExemptionRequest.ExemptionRequestId in
	(select  [dbo].[OFI_Interface_Exemption_Audit].ExemptionRequestId  from [dbo].[OFI_Interface_Exemption_Audit] with (nolock))
end