
CREATE procedure [dbo].[OFI_Interface_Extension_populate] (@statusmessage varchar(max) output)
as
begin

set nocount on
set transaction isolation level read uncommitted

Set @statusmessage = 'ok';

Begin Try 
insert into  dbo.OFI_Interface_extension_audit
(
      [ClientNo]
       ,[TANF_EXTENSION_TYPE_CD]
	  , TANF_EXTENSION_TYPE_CD_Description
      ,[Proposed_Start]
      ,[Proposed_end]
      ,[Reason_text]
      ,[EXTENSION_REQUEST_DT]
      ,[FEDCAP_APPROVE_DENY_IND]
      ,[Verification_IND]
      ,[Re-consideration_IND],
	   [OFI_Office]
      ,[Clientid]
      ,[Companyid],  [ExtensionRequestid], dateadded, staff_name, staff_phone,imaging_note)

	 SELECT 
	 client.ClientNo,dbo.getExtenstionabrreviation ([ReasonBenefitsExtendedId]) as TANF_EXTENSION_TYPE_CD, 
	 dbo.enumes.Item as TANF_EXTENSION_TYPE_CD_Description, 
       convert(varchar(20),[DateFrom],101)
      ,convert(varchar(20),[DateTo],101),
	   [AdditionalDetails],
	   convert(varchar(20),isnull([dbo].[ClientExtensionRequest].updatedat,[ClientExtensionRequest].CreatedAt),101)
  	  , case [dbo].[ClientExtensionRequest].FedcapDecisionId when 649 then 'Y' else 'N' end  as 'FEDCAP_APPROVE_DENY_IND', 
	  case [dbo].[ClientExtensionRequest].IsVerificationReceived when 1 then 'Y' else 'N' end  as  'Verification_IND', 
	  case [dbo].[ClientExtensionRequest].IsReConsideration when 1 then 'Y' else 'N' end  as 'Re-consideration_IND',   dbo.client.ReferringOfficeNumber as [OFI office],
		dbo.client.clientid, 	[dbo].[ClientExtensionRequest].[CompanyId],
		  [dbo].[ClientExtensionRequest].ExtensionRequestId, getdate(), dbo.getcaseworker_Name(dbo.[client].clientid, 8),
		   dbo.getcaseworker_Phone(dbo.[client].clientid, 8),
isnull('Extension document was attached on ' + convert(varchar(20),i.DocumentDate,101) ,'') as Receipt_Invoice
  
  FROM [dbo].[ClientExtensionRequest]
  inner join dbo.client on client.clientid = [dbo].[ClientExtensionRequest].clientid and dbo.[client].clientno not like '%test%' 
  and isnull([dbo].[ClientExtensionRequest].isdeleted,0) <> 1 
  inner join dbo.enumes on enumes.groupid =637 and dbo.enumes.enumid = [ReasonBenefitsExtendedId]
  inner join dbo.enumes fedcapdecision on fedcapdecision.groupid =648 and fedcapdecision.enumid = [FedcapDecisionId] 
  and not  exists (select dbo.OFI_Interface_extension_audit.[ExtensionRequestid] from dbo.OFI_Interface_extension_audit where
    dbo.OFI_Interface_extension_audit.[ExtensionRequestid] =   [dbo].[ClientExtensionRequest].[ExtensionRequestid])
	left join dbo.SCAN_Images i on i.ID = [dbo].[ClientExtensionRequest].ScanImageId

End try
begin catch
  select @statusmessage = ERROR_MESSAGE()
end catch
end
