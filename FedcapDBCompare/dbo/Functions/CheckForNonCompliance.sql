
CREATE function [dbo].[CheckForNonCompliance]
(
    @Clientid int
)
returns @NonComplianceDetails table
(
    Clientid int,
	ScheduleId int,
	ClientContactId_Voice int, 
	ClientContacId_Mail int, 
	ClientContactId_Home int,  
	ClientContactId_NotApprovedGoodCause int) 
as
begin	

    insert into @NonComplianceDetails (clientid, ScheduleId, ClientContactId_Voice,ClientContacId_Mail,ClientContactId_Home,ClientContactId_NotApprovedGoodCause)
	
	SELECT  dbo.client.clientid, 
			missed_appt.ScheduleId as missedappointmentid, 
			contactphone.ClientContactId as voicecontactid, 
			contactmail.ClientContactId as mailcontactid,
			contacthomevisit.ClientContactId as homecontactid,  
			goodcauseclaimednotapproveddata.clientcontactid as notapprovedcauseid

from dbo.Client with (nolock) inner join 
--find a missed appointment
dbo.Schedule missed_appt with (nolock)  on  dbo.client.clientid =missed_appt.clientid
and missed_appt.clientid = @Clientid 
 and missed_appt.attendancestatus in (4) -- 4 is not attended 
 and 
 (missed_appt.ScheduleId = (select top 1 mostrecentmissedappt.ScheduleId from dbo.Schedule as mostrecentmissedappt with (nolock) where mostrecentmissedappt.ClientId = missed_appt.ClientId and 
 mostrecentmissedappt.AttendanceStatus = 4 and mostrecentmissedappt.IsDeleted = 0
 
-- Earliest Absent schedule after an attended schedule (up until we submitted a sanction) get earliest absence
and not exists (select scheduleid from dbo.Schedule future_activity with (nolock)  where 
mostrecentmissedappt.clientid = future_activity.clientid and mostrecentmissedappt.companyid =  future_activity.companyid and 
(DATEDIFF(mi,mostrecentmissedappt.[StartTime], future_activity.[StartTime]) >= 0  
and mostrecentmissedappt.ScheduleId <> future_activity.ScheduleId and future_activity.AttendanceStatus in (1,2,3) and isnull(future_activity.EventId, 0) <> 74 ) and future_activity.IsDeleted = 0
)
-- Earliest Absent schedule after a good cause approved contact record
and not exists (select top 1 goodcausedata.ClientContactId from  dbo.ClientContact goodcausedata with (nolock) where
 goodcausedata.clientid = mostrecentmissedappt.clientid and datediff(d, mostrecentmissedappt.Date, goodcausedata.ContactDate) >= 0 and goodcausedata.IsGoodCauseApproved =1 and
   isnull(goodcausedata.IsDeleted,0) = 0)

order by mostrecentmissedappt.[Date]))

-- add case information
inner join dbo.[case] with (nolock) on  dbo.[case].caseid =dbo.client.activecaseid and dbo.[case].statusid ='O' -- we are sending sanction data for open cases only

--find phone contact date
outer apply (select top 1 dbo.ClientContact.ClientContactId,IsContact, IsContactMade, ContactTime,' Phone: ' + ContactNote  as ContactNote  from dbo.ClientContact with (nolock) where dbo.ClientContact.clientid = missed_appt.clientid and 
 datediff(d,missed_appt.[Date],dbo.ClientContact.ContactDate) >= 0 and dbo.ClientContact.IsDeleted = 0 and 
 dbo.ClientContact.ContactMethodId =522 and dbo.ClientContact.ContactTypeId=520 
 order by isnull(dbo.ClientContact.UpdatedAt,dbo.ClientContact.CreatedAt)) as contactphone
--find mail contact date
outer apply (select top 1  contactmail.ClientContactId, ContactTime, IsContact, ' Mail: ' + ContactNote  as ContactNote from dbo.ClientContact contactmail with (nolock) where contactmail.clientid = missed_appt.clientid and 
 datediff(d, missed_appt.[Date],contactmail.ContactDate) >= 0  and contactmail.IsDeleted = 0 and 
 contactmail.ContactMethodId = 525 and contactmail.ContactTypeId=520 
 order by isnull(contactmail.UpdatedAt,contactmail.CreatedAt)) as contactmail
--find home visit date
outer apply (select top 1 dbo.ClientContact.ClientContactId, ContactTime, IsContact, IsContactMade,' Home visit: ' + ContactNote  as ContactNote  from dbo.ClientContact with (nolock)  where  dbo.ClientContact.clientid = missed_appt.clientid and 
 ClientContact.IsDeleted = 0 and
 datediff(d, missed_appt.[Date],dbo.ClientContact.ContactDate) >= 0  and dbo.ClientContact.ContactMethodId =526 and dbo.ClientContact.ContactTypeId=520 
	 
order by isnull(dbo.ClientContact.UpdatedAt,dbo.ClientContact.CreatedAt)) as contacthomevisit
outer apply
 (  --find the most recent contact date of not approved claimed good cause 
select top 1 goodcause.ClientContactId from ClientContact as goodcause with (nolock)  where
goodcause.clientid = missed_appt.clientid and goodcause.IsDeleted = 0
  and isnull(goodcause.IsGoodCauseApproved,0) =0 and goodcause.ContactMethodId in (525,526,522) and goodcause.ContactTypeId=520
 --and goodcause.IsGoodCauseClaimed =1 
 and 
 goodcause.ContactDate >= missed_appt.date
 order by isnull(goodcause.IsGoodCauseClaimed,0) desc, isnull(goodcause.UpdatedAt,goodcause.CreatedAt)) as goodcauseclaimednotapproveddata

 where dbo.Client.ExemptionEffectiveDate is null	-- do not sanction nor send to non-compliance track clients that are exempt

return  
end
