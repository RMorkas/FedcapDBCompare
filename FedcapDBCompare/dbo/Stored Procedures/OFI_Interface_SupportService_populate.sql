



CREATE  procedure [dbo].[OFI_Interface_SupportService_populate] (@statusmessage varchar(max) output)
as
begin
set nocount on
set transaction isolation level read uncommitted

Set @statusmessage = 'ok';
Begin Try 


insert into [dbo].[OFI_Interface_SupportService_Audit]
 ([clientNo]           ,[OFI office]           ,[Service_Type_Code]           ,[Item_Service_Type]           ,[Item_CAP_amt]           ,[Frequency]
           ,[Amount]           ,[Child_Being_Served]           ,[Hours]           ,[Start_Dt]           ,[END_Dt]           ,[Estimate]
           ,[Description]           ,[Work_Site]           ,[Provider_Type]           ,[Provider_Vendor_Name]
           ,[Provider_Vendor_Tax_ID_Number]
           ,[Street1]           ,[Street2]           ,[City]           ,[State]           ,[Zip]           ,[Payment_To_Vendor_Flag]
           ,[Requesting Case Manager]           ,[FCAStart_Dt]           ,[FCAEND_Dt]           ,[clientid]
           ,[clientsupportserviceid]           ,[datesubmitted], dateadded,Receipt_Invoice )

SELECT distinct c.ClientNo as [Client_ID],isnull([c].ReferringOfficeNumber,'') as [OFI_Office],  s.Code as Service_Type_Code,s.description as Item_Service_type, isnull(cast(s.ItemCapAmount as  money),'') as Item_CAP_amt,  
 isnull(fr.item,'') as Frequency, isnull(cast(cs.AmountRequested as money),'') as [Amount], isnull(cs.ChildName,'') as Child_Being_Served,
 s.hoursperweekrequired as [Hours], 
 convert(varchar(20),cs.StartDate,101) as [Start_Dt], convert(varchar(20),
 cs.EndDate, 101)  as End_Dt, case cs.isestimate when 1 then 'Y' else 'N' end as Estimate, isnull(cs.ServiceDescription,'') as 'Description',
 rtrim(isnull(cs.WorkSite,'')) as [Work_site],
 isnull(ChildCareProviderType.Description,'') as [Provider Type], isnull(vendorname,'') as [Provider_Vendor_name], isnull(VendorTaxId,'') as [Provider_Vendor Tax ID number], 
 isnull(VendorStreet1,'') as Street1, isnull(VendorStreet2,'') as Street2, isnull(cs.VendorCity,'') as City, isnull(vendorState,'')  as [State], isnull(vendorzipCode,'') as [Zip], 
 case PaymentToVendorFlag when 1 then 'Y' else 'N' end as [Payment to Vendor Flag], 
dbo.getUserFullName(cs.CreatedBy,8) as [Requesting_Cas_Manager], isnull(convert(varchar(20), fca.ActivityStartDate,101),'') as FCA_start_dt
,  isnull(convert(varchar(20), fca.ActivityEndDate, 101),'')  as FCA_end_dt, c.ClientId, cs.clientSupportServiceId, null, getdate(), 
case (Select count(*) from ClientSupportServiceAttachment css with (nolock)  where css.ClientSupportServiceId = cs.clientSupportServiceId)   when 0 then '' else 
'Support Service Receipt/invoice was attached' end  as Receipt_Invoice 

  FROM [dbo].[ClientSupportService] cs inner join dbo.SupportService s on cs.SupportServiceId = s.SupportServiceId and isnull(cs.IsDeleted,0) <> 1
  and (s.ApprovalRequired = 0 Or cs.Approved = 1)
  inner join dbo.client c on c.ClientId =cs.ClientId and c.clientno not like '%test%'
  left outer join dbo.ClientFca fca on fca.ClientId = cs.ClientId and clientfcaid = (select top 1 f.clientfcaid from ClientFca f where f.ClientId = cs.ClientId and 
  datediff(d, cs.EndDate, f.ActivityEndDate) >= 0  order by f.ActivityEndDate desc) 
  left outer join dbo.enumes fr on fr.enumid = FrequencyId
  left join dbo.ChildCareProviderType on ChildCareProviderType.ChildCareProviderTypeId = cs.ChildCareProviderTypeId
 -- Left join dbo.SCAN_Images on  dbo.scan_images.id = cs.scanimageid and cs.scanimageid is not null and dbo.scan_images.DocumentTypeId =301
  where  not  exists (select a.clientsupportserviceid from dbo.OFI_Interface_SupportService_Audit a where a.clientsupportserviceid =  cs.ClientSupportServiceId
 ) 
End try
begin catch
  select @statusmessage = ERROR_MESSAGE()
end catch
end


