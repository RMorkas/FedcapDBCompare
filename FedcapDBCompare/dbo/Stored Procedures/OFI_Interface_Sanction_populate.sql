CREATE procedure [dbo].[OFI_Interface_Sanction_populate] (@statusmessage varchar(max) output)
as
BEGIN
set nocount on
set transaction isolation level read uncommitted


Set @statusmessage = 'ok';
--delete from [OFI_Interface_sanction_audit] -- we do it for testing only. so we generate a full set of data each time
begin try
INSERT INTO [dbo].[OFI_Interface_Sanction_audit]
           ([dateadded]
           ,[clientid]
           ,[OFI office]
           ,[clientNo]
           ,[caseNo]
           ,[non compliance type]
           ,[Date]
           ,[Details of Non Compliance]
		   ,[First Sanction]
           ,[Verbal Contact Date Time]
           ,[Mail Contact Date Time]
           ,[Home Visit Date Time]
           ,[Contact Established]
           ,[Good cause claimed]
           ,[Good cause claimed text]
           ,[Good cause Type]
           ,[Good cause Denial Text]
           ,[Staff member Witness]
           ,[BTC Staff member Phone], scheduleid)
	
SELECT  getdate(), dbo.client.clientid, dbo.client.ReferringOfficeNumber as [OFI office],   dbo.client.clientno,
 dbo.[case].caseno, case isnull(dbo.[client].sanctionhistorycount,0) when 0 then 'B08 Non-Compliance  ASPIRE PaS/TANF  90 days' else 'B09 Non-Compliance  ASPIRE PaS/TANF'
end  as [non compliance type],  convert(varchar(20), missed_appt.[Date],101) as   missed_appt_Date

,isnull(contactphone.ContactNote,'') + isnull(contacthomevisit.ContactNote,'') +  isnull(contactmail.ContactNote,'')  as [Details of Non Compliance]
, case isnull(dbo.[client].sanctionhistorycount,0) when 0 then 'Yes' else 'No' end as [first sanction],
contactphone.ContactTime as [verbal contact date time], contactmail.ContactTime as [mail contact date time], contacthomevisit.ContactTime as [home visit conect attempt date time]
,case isnull(goodcausenotapproved.IsContactMade,0) when 0 then 'No' else 'yes' end as [contact established]
,case isnull(goodcausenotapproved.GoodCauseReasonId,0) when 0 then 'No' else 'yes' end as [good cause claimed],
goodcausenotapproved.goodcauseclaimsnote as [good cause claimed text],
 isnull(dbo.enumes.item,'') as [good cause type], goodcausenotapproved.GoodCauseDenialNote as [good cause denial text],
 dbo.[user].FirstName + ' ' + dbo.[user].LastName as  [Staff Member Witness], 
 dbo.[site].SitePhone as [BTC Staff Member Phone], NonComplianceDetails.ScheduleId
from dbo.Client with (nolock)  cross apply (Select * from [dbo].[OFI_Interface_CheckForNonCompliance](client.ClientId) as details where client.ClientId = details.clientid) NonComplianceDetails

inner join dbo.[case] with (nolock) on  dbo.[case].caseid =dbo.client.activecaseid and dbo.[case].statusid ='O' -- we are sending sanction data for open cases only
inner join [dbo].[OFI_Sites_Mapping] sitemap on sitemap.OFI_SiteID = dbo.client.ReferringOfficeNumber
inner join dbo.[Site] with (nolock)  on dbo.[site].siteid = sitemap.SiteID
inner join dbo.[User] with (nolock)  on  dbo.[User].UserID = dbo.[site].sitemanagerid
inner join dbo.Schedule missed_appt with (nolock)  on missed_appt.ScheduleId =NonComplianceDetails.ScheduleId --and DATEDIFF(hh, missed_appt.[Date], GETDATE()) > 48 
inner join  dbo.ClientContact contactphone  with (nolock) on contactphone.ClientContactId =NonComplianceDetails.ClientContactId_Voice
inner join  dbo.ClientContact contactmail with (nolock) on contactmail.ClientContactId =NonComplianceDetails.ClientContacId_Mail
inner join  dbo.ClientContact contacthomevisit with (nolock) on contacthomevisit.ClientContactId =NonComplianceDetails.ClientContactId_Home
left join  dbo.ClientContact goodcausenotapproved with (nolock) on goodcausenotapproved.ClientContactId =NonComplianceDetails.ClientContactId_NotApprovedGoodCause

 left outer join dbo.enumes with (nolock)  on enumes.groupid =528 and enumid = goodcausenotapproved.GoodCauseReasonId
 --where not exists (select dbo.OFI_Interface_Sanction_audit.id  from dbo.OFI_Interface_Sanction_audit with (nolock) where 
 --dbo.OFI_Interface_Sanction_audit.clientid =missed_appt.clientid and datediff(d,dbo.OFI_Interface_Sanction_audit.datesubmitted, getdate()) <= 21 )
 --and not exists (select lastoutreachattempt.ClientContactId from dbo.clientcontact lastoutreachattempt with (nolock) where lastoutreachattempt.clientid =missed_appt.clientid 
 --and datediff(hh,lastoutreachattempt.ContactDate, getdate()) <= 24   and lastoutreachattempt.ContactTypeId =520) 
 and dbo.client.ExemptionEffectiveDate is null

End try
begin catch
  select @statusmessage = ERROR_MESSAGE()
end catch

end


