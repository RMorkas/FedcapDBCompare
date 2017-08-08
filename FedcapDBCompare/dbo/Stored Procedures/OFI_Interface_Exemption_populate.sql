CREATE  procedure [dbo].[OFI_Interface_Exemption_populate] (@statusmessage varchar(max) output)
as
begin
set nocount on
set transaction isolation level read uncommitted

Set @statusmessage = 'ok';


begin try
INSERT INTO [dbo].[OFI_Interface_Exemption_Audit]
           ([clientid]
           ,[clientno]
           ,[name]
           ,[Exemption_Type]
           ,[start_dt]
           ,[end_dt]
           ,[BTC Staff Member Name]
           ,[BTC Staff Member Phone]
           ,[OFI office]
           ,[datesubmitted]
           ,[dateadded]
           ,[CFD_Name],ExemptionRequestId, imaging_note)
     
SELECT dbo.[client].clientid,  dbo.[client].clientno, isnull(dbo.[client].CaseFirstName,'') + ' '  + isnull(dbo.[client].CaselastName,'') , dbo.Enumes.Item, 
convert(varchar(20), [dbo].[ExemptionRequest].DateFrom,101), convert(varchar(20), [dbo].[ExemptionRequest].DateTo,101), dbo.getcaseworker_Name(dbo.client.clientid, 8), 
dbo.getcaseworker_Phone(dbo.[client].clientid, 8), isnull(dbo.[client].ReferringOfficeNumber,''),null, getdate(), [dbo].[ExemptionRequest].FamilyMemberName, 
 [dbo].[ExemptionRequest].ExemptionRequestId,
isnull('Exemption document was attached on ' + convert(varchar(20),i.DocumentDate,101) ,'') as Receipt_Invoice 
 FROM [dbo].[ExemptionRequest] inner join dbo.[client] on [dbo].[ExemptionRequest].ClientId = dbo.[client].clientid and 
 isnull([dbo].[ExemptionRequest].isdeleted,0) <> 1 
  inner join dbo.Enumes on dbo.Enumes.groupid =899 and enumid = [ReasonExemptionId]
   and not  exists (select dbo.OFI_Interface_Exemption_Audit.ExemptionRequestId from dbo.OFI_Interface_Exemption_Audit
   where dbo.OFI_Interface_Exemption_Audit.ExemptionRequestId = [dbo].[ExemptionRequest].ExemptionRequestId)
   and dbo.[client].ClientNo not like '%test%' 
    left join dbo.SCAN_Images i on i.ID = [dbo].[ExemptionRequest].ScanImageId
End try
begin catch
  select @statusmessage = ERROR_MESSAGE()
end catch
end
