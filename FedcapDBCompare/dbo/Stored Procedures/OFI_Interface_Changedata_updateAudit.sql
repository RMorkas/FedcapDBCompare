CREATE procedure [dbo].[OFI_Interface_Changedata_updateAudit]
as
begin
	update dbo.OFI_Interface_changedata_audit set datesubmitted = getdate() where datediff(d,dateadded,getdate()) =0


	update dbo.clientcontact set IsLocked= 1, UpdatedAt =getdate(), UpdatedBy='FEDCAP\change_interface' where isnull(islocked,0) = 0 
	and clientcontactid in 
	(select noteid from dbo.OFI_Interface_ChangeData_Audit where datesubmitted is not null) 

	update dbo.clientcontact set RequestStatus= 1, UpdatedAt =getdate(), UpdatedBy='FEDCAP\change_interface' where isnull(RequestStatus,0) = 0 
	and clientcontactid in 
	(select noteid from dbo.OFI_Interface_ChangeData_Audit where datesubmitted is not null) 
		
	--update dbo.client set sanction ='N' where clientid in (select dbo.OFI_Interface_ChangeData_Audit.clientid  from dbo.OFI_Interface_ChangeData_Audit where Sanction_complied_ind =1 
	--and datediff(d,dateadded,getdate()) = 0 ) and sanction = 'Y'		

end


