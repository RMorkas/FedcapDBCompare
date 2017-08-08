
CREATE procedure [dbo].[OFI_Interface_SupportService_updateAudit]
as
begin
	update [dbo].[OFI_Interface_SupportService_Audit] set datesubmitted = getdate() where datediff(d,dateadded,getdate()) = 0 

	update dbo.ClientSupportService set RequestStatus =4 where (RequestStatus <> 4) and  ClientSupportServiceId in 
	(select [dbo].[OFI_Interface_SupportService_Audit].clientsupportserviceid from [dbo].[OFI_Interface_SupportService_Audit] where datediff(d,datesubmitted,getdate()) = 0 )
	 
	update dbo.ClientSupportService set islocked =1  where (islocked <> 1) and  ClientSupportServiceId in 
	(select [dbo].[OFI_Interface_SupportService_Audit].clientsupportserviceid from [dbo].[OFI_Interface_SupportService_Audit] where datediff(d,datesubmitted,getdate()) = 0 )
end


