CREATE  procedure [dbo].[OFI_Interface_ChangeData_populate] (@statusmessage varchar(max) output)
as
begin
set nocount on
set transaction isolation level read uncommitted

Set @statusmessage = 'ok';
Begin Try 

exec [dbo].[CreateChangeNoteForm]
insert into dbo.OFI_Interface_changedata_audit
([OFI office]
      ,[changeDate]
      ,[clientno]
      ,[Note]
      ,[Sanction_complied_ind]
      ,[Sanction_complied_Dt]
      ,[Updated_ChangeEnd_Dt], dateadded, noteid, clientid, Imaging_Note)
--for placements we need to check for employment verification scanned documents 
SELECT   distinct isnull(client.ReferringOfficeNumber,'') as [OFI office], dbo.ClientContact.ContactDate, dbo.client.clientno, dbo.ClientContact.ContactNote, 
 case dbo.clientcontact.Title when 'Sanction Complied' then '1' else '' end as [Sanction_complied_ind], case dbo.clientcontact.Title when 'Sanction Complied' 
 then dbo.ClientContact.ContactDate else '' end [Sanction_complied_Dt], 
 '' as [Sanction_complied_Dt],   getdate(), dbo.ClientContact.ClientContactId,dbo.Client.clientid, 
 isnull(dbo.SCAN_DocTypes.[description] + ' document was scanned on ' + convert(varchar(20), dbo.SCAN_Images.DocumentDate,101),'')
from dbo.ClientContact inner join dbo.Client on
 dbo.ClientContact.clientid =Client.clientid and isnull(contactnote,'') like  'New Placement at%'  and dbo.client.ClientNo not like '%test%' and isnull(dbo.clientcontact.IsDeleted,0) <> 1 
  and  dbo.ClientContact.ContacttypeId =646 and dbo.ClientContact.ContactNote not like '%to 0000000000' and dbo.ClientContact.ContactNote not like '%to (000) 000-0000'
 and not  exists (select dbo.OFI_Interface_changedata_audit.noteid from dbo.OFI_Interface_changedata_audit where dbo.OFI_Interface_changedata_audit.noteid =  dbo.ClientContact.ClientContactId)
 left join dbo.SCAN_Images on dbo.SCAN_Images.HRACaseId = dbo.Client.clientid  --Employment Job Start Verification 
 and dbo.SCAN_Images.ID in (select top 1 s.id from dbo.SCAN_Images s where s.HRACaseId =dbo.Client.clientid and s.DocumentTypeId in (283) and
  datediff(d, s.DocumentDate,dbo.ClientContact.CreatedAt) >= 0 
  and datediff(d,s.DocumentDate,dbo.ClientContact.CreatedAt) <=7 order by datediff(d,s.DocumentDate,dbo.ClientContact.CreatedAt)) 
 inner join dbo.SCAN_DocTypes on dbo.SCAN_DocTypes.id = dbo.SCAN_Images.DocumentTypeId

 union

 SELECT   distinct isnull(client.ReferringOfficeNumber,'') as [OFI office], dbo.ClientContact.ContactDate, dbo.client.clientno, dbo.ClientContact.ContactNote, 
 case dbo.clientcontact.Title when 'Sanction Complied' then '1' else '' end as [Sanction_complied_ind], case dbo.clientcontact.Title when 'Sanction Complied' then dbo.ClientContact.ContactDate else '' end [Sanction_complied_Dt], 
 '' as [Sanction_complied_Dt],   getdate(), dbo.ClientContact.ClientContactId,dbo.Client.clientid,''
from dbo.ClientContact inner join dbo.Client on
 dbo.ClientContact.clientid =Client.clientid and isnull(contactnote,'') <> '' and isnull(contactnote,'') not like  'New Placement at%'  and dbo.client.ClientNo not like '%test%' and isnull(dbo.clientcontact.IsDeleted,0) <> 1 
  and  dbo.ClientContact.ContacttypeId =646 and dbo.ClientContact.ContactNote not like '%to 0000000000' and dbo.ClientContact.ContactNote not like '%to (000) 000-0000'
 and not  exists (select dbo.OFI_Interface_changedata_audit.noteid from dbo.OFI_Interface_changedata_audit where dbo.OFI_Interface_changedata_audit.noteid =  dbo.ClientContact.ClientContactId
 ) 

 
End try
begin catch
  select @statusmessage = ERROR_MESSAGE()
end catch
end




