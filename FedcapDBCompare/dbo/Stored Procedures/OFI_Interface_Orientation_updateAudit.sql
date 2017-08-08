CREATE procedure [dbo].[OFI_Interface_Orientation_updateAudit]
as
begin
	update [dbo].[OFI_Interface_Orientation_Audit] set datesubmitted = getdate() where datediff(d,dateadded,getdate()) = 0 
end