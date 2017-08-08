
CREATE  procedure [dbo].[CreateChangeNoteForm]
 as
 begin
 set nocount on
 set transaction isolation level read uncommitted

declare @LastProcessedDate Datetime
set @LastProcessedDate = '1/29/2017' -- default is one day before we went live
select  @LastProcessedDate= isnull(max(dbo.OFI_Interface_ChangeData_Audit.dateadded),'1/29/2016') from dbo.OFI_Interface_ChangeData_Audit -- get the last processed date

--clean up temporary tables
if OBJECT_ID('tempdb..#TranSavedIdtable') is not null  drop table #TranSavedIdtable
if OBJECT_ID('tempdb..#CaseidFullAdresschangetable') is not null  drop table #CaseidFullAdresschangetable
if OBJECT_ID('tempdb..#selectFormdata') is not null  drop table #selectFormdata
if OBJECT_ID('tempdb..#TranclientFullAdresschangetable') is not null  drop table #TranclientFullAdresschangetable
if OBJECT_ID('tempdb..#CaseidFullmailingAdresschangetable') is not null  drop table #CaseidFullMailingAdresschangetable


--case table tableid 17
--client table tableid 3
-- we are not sending to OFI data which were created or updated by any of the interfaces
--we select and send only data which were processed after previouse createchangenoteform run


/*processing of the full address: first get updated client ids. client table has id 3 */
 select distinct clientid, max(t.TranSavedId) as tranid into #CaseidFullAdresschangetable
  from [dbo].[Fed_LogTransactionData] inner join 
  [dbo].[Fed_LogTransaction] t on t.TranSavedId = [dbo].[Fed_LogTransactionData].TranSavedId and tableid =3
  and fieldname in ('streetaddress','city', 'zipcode','apartmentnumber','state') --,'MailingAddressStreet','MailingAddressStreet2','MailingAddressCity','MailingAddressZipCode')  
  and upper(rtrim(isnull(oldvalue,''))) <> upper(rtrim(isnull(newvalue,''))) and (oldvalue is not null or newvalue is not null)
  and isnull([dbo].[Fed_LogTransactionData].SavedBy,'') <> '' and isnull([dbo].[Fed_LogTransactionData].SavedBy,'') not like '%interface%'
  and datediff(d,@LastProcessedDate,[dbo].[Fed_LogTransactionData].savedat) >  0 
  inner join dbo.[client] with (nolock)  on t.PKFieldValue = [dbo].[client].clientId 
  group by clientid
  

 insert into dbo.ClientContact (Companyid,clientid, [IsContact],[Title],
 [ContactTypeId],[ContactMethodId],[ContactDate],[ContactTime]
           ,[IsContactMade],[ContactNote],[GoodCauseReasonId] ,[IsGoodCauseClaimed] ,[IsGoodCauseApproved] ,[GoodCauseDenialNote]
           ,[IsClientAcceptedSendMsg],[MessageId],[NonComplianceLetterId],
		   [FormVersionId],[IsDeleted],[CreatedBy]
           ,[CreatedAt],[UpdatedBy],[UpdatedAt], logtableid)
select distinct 8, sourcet.ClientId, 0,
'Change of address',
  646, null, address1.savedat, address1.savedat,
   null,
    'Address changed From  ' +  rtrim(isnull(address1.OldValue, '')) + ' ' + rtrim(isnull(address2.OldValue,'')) + ' ' + 
 isnull(city.OldValue,'') + ', ' +  isnull([state].oldvalue,'') + ' '  + isnull(zip.oldvalue,'') + ' To ' + 
 isnull(address1.newValue, '') + ' ' + isnull(address2.newValue,'') + ' ' + 
 isnull(city.newValue,'') + ', ' + isnull([state].newvalue,'')  + ' ' + isnull(zip.newvalue,'') as newvalue, null,null,null,null,
   null,null,null,
  3,0,isnull(address1.SavedBy,''),address1.savedat,null,null, address1.TranSavedId

  from #CaseidFullAdresschangetable sourcet inner join  [dbo].[Fed_LogTransactionData] zip  on 
 sourcet.tranid = zip.TranSavedId and zip.fieldname = 'zipcode' 
  inner join 
  [dbo].[Fed_LogTransactionData] address1 on sourcet.tranid = address1.TranSavedId and address1.fieldname = 'StreetAddress'  and isnull([address1].SavedBy,'') not like '%interface%'
	inner join   [dbo].[Fed_LogTransactionData] address2 on sourcet.tranid = address2.TranSavedId and address2.fieldname = 'ApartmentNumber' and isnull([address2].SavedBy,'') not like '%interface%'
 inner join  
  [dbo].[Fed_LogTransactionData] city on sourcet.tranid = city.TranSavedId and city.fieldname = 'city' and isnull([city].SavedBy,'') not like '%interface%'
 inner join  
  [dbo].[Fed_LogTransactionData] [state] on sourcet.tranid = [state].TranSavedId and [state].fieldname = 'state' and isnull([state].SavedBy,'') not like '%interface%'
  and address1.TranSavedId not in (select isnull(logtableid,'') from dbo.ClientContact) 

  --Done with the address processing

--  declare @LastProcessedDate Datetime
--set @LastProcessedDate = '1/29/2017' 
  ---mailing address changes
 
  /*processing of the mailing address: first get updated client ids. client table has id 3 */
select distinct clientid, max(t.TranSavedId) as tranid into #CaseidFullMailingAdresschangetable
  from [dbo].[Fed_LogTransactionData] inner join 
  [dbo].[Fed_LogTransaction] t on t.TranSavedId = [dbo].[Fed_LogTransactionData].TranSavedId and tableid =3
  and fieldname in ('MailingAddressStreet','MailingAddressCity', 'MailingAddressZipCode','MailingAddressStreet2','MailingAddressState')   
  and upper(rtrim(isnull(oldvalue,''))) <> upper(rtrim(isnull(newvalue,''))) and (oldvalue is not null or newvalue is not null)
  and isnull([dbo].[Fed_LogTransactionData].SavedBy,'') <> '' and isnull([dbo].[Fed_LogTransactionData].SavedBy,'') not like '%interface%'
  and datediff(d,@LastProcessedDate,[dbo].[Fed_LogTransactionData].savedat) >  0 
  inner join dbo.[client] with (nolock)  on t.PKFieldValue = [dbo].[client].clientId 
  group by clientid


 
  insert into dbo.ClientContact (Companyid,clientid, [IsContact],[Title],
 [ContactTypeId],[ContactMethodId],[ContactDate],[ContactTime]
           ,[IsContactMade],[ContactNote],[GoodCauseReasonId] ,[IsGoodCauseClaimed] ,[IsGoodCauseApproved] ,[GoodCauseDenialNote]
           ,[IsClientAcceptedSendMsg],[MessageId],[NonComplianceLetterId],
		   [FormVersionId],[IsDeleted],[CreatedBy]
           ,[CreatedAt],[UpdatedBy],[UpdatedAt], logtableid)
select distinct 8, sourcet.ClientId, 0,
'Change of Mailing address',
  646, null, address1.savedat, address1.savedat,
   null,
    'Mailing Address changed From  ' +  rtrim(isnull(address1.OldValue, '')) + ' ' + rtrim(isnull(address2.OldValue,'')) + ' ' + 
 isnull(city.OldValue,'') + ', ' +  isnull([state].oldvalue,'') + ' '  + isnull(zip.oldvalue,'') + ' To ' + 
 isnull(address1.newValue, '') + ' ' + isnull(address2.newValue,'') + ' ' + 
 isnull(city.newValue,'') + ', ' + isnull([state].newvalue,'')  + ' ' + isnull(zip.newvalue,'') as newvalue, null,null,null,null,
   null,null,null,
  3,0,isnull(address1.SavedBy,''),address1.savedat,null,null, address1.TranSavedId

  from #CaseidFullmailingAdresschangetable sourcet inner join  [dbo].[Fed_LogTransactionData] zip  on 
 sourcet.tranid = zip.TranSavedId and zip.fieldname = 'MailingAddresszipcode' 
  inner join 
  [dbo].[Fed_LogTransactionData] address1 on sourcet.tranid = address1.TranSavedId and address1.fieldname = 'MailingAddressStreet'
	inner join   [dbo].[Fed_LogTransactionData] address2 on sourcet.tranid = address2.TranSavedId and address2.fieldname = 'MailingAddressStreet2'
 inner join  
  [dbo].[Fed_LogTransactionData] city on sourcet.tranid = city.TranSavedId and city.fieldname = 'MailingAddresscity'
 inner join  
  [dbo].[Fed_LogTransactionData] [state] on sourcet.tranid = [state].TranSavedId and [state].fieldname = 'MailingAddressstate'
  and address1.TranSavedId not in (select isnull(logtableid,'') from dbo.ClientContact)
  
  --declare @LastProcessedDate Datetime
--set @LastProcessedDate = '1/29/2017' -- default is one day before we went live
--select  @LastProcessedDate= isnull(max(dbo.OFI_Interface_ChangeData_Audit.dateadded),'1/29/2016') from dbo.OFI_Interface_ChangeData_Audit -- get the last processed date
--drop table #TranSavedIdtable
  --Processing phone fields
   --Processing rest of the fields
  --insert into #TranSavedIdtable  (TranSavedId, DataSavedId, oldvalue, NewValue, fieldname, savedby, savedat,PKFieldValue, tableid) 
 select  distinct  t.[TranSavedId], [Fed_LogTransactionData].DataSavedId, isnull(oldvalue,'()') as oldvalue, isnull(newvalue,'()') as newvalue ,case FieldName when
 'casefirstname' then 'Case First Name' when 'caselastname' then 'Case Last Name'  else Fieldname end as Fieldname, 
 [dbo].[Fed_LogTransactionData].SavedBy, 
 [dbo].[Fed_LogTransactionData].savedat,t.PKFieldValue,t.TableId into #TranSavedIdtable
  from [dbo].[Fed_LogTransactionData] inner join 
  [dbo].[Fed_LogTransaction] t on t.TranSavedId = [dbo].[Fed_LogTransactionData].TranSavedId and tableid =3 
  --and fieldname in ('SSN', 'casefirstname','caselastname',  'email', 'DOB') 
  and fieldname in ('email', 'DOB') 
  and isnull(oldvalue,'') <> isnull(newvalue,'') 	 and (oldvalue is not null or newvalue is not null)
  and isnull( [dbo].[Fed_LogTransactionData].SavedBy,'') <> '' and isnull( [dbo].[Fed_LogTransactionData].SavedBy,'') not like '%interface%'
 and datediff(d,@LastProcessedDate,[dbo].[Fed_LogTransactionData].savedat) > =0 
  order by [dbo].[Fed_LogTransactionData].SavedAt
     desc 

insert into #TranSavedIdtable  (TranSavedId, DataSavedId, oldvalue, NewValue, fieldname, savedby, savedat,PKFieldValue, tableid) 
 select  distinct [dbo].[Fed_LogTransactionData].TranSavedId, [dbo].[Fed_LogTransactionData].DataSavedId, isnull([dbo].[ufn_FormatPhone](oldvalue),'()') as oldvalue, 
 isnull([dbo].[ufn_FormatPhone](newvalue),'()') as newvalue ,case FieldName when
 'phonenumber' then 'Home Phone Number' 
 when 'CellPhone' then 'Cell phone number' else Fieldname end as Fieldname, 
 [dbo].[Fed_LogTransactionData].SavedBy, 
 [dbo].[Fed_LogTransactionData].savedat,  t.PKFieldValue, t.TableId

  from [dbo].[Fed_LogTransactionData] inner join 
  [dbo].[Fed_LogTransaction] t on t.TranSavedId = [dbo].[Fed_LogTransactionData].TranSavedId and tableid =3 
  and fieldname in ( 'phonenumber', 'CellPhone') 
  and upper(rtrim(isnull(oldvalue,''))) <> upper(rtrim(isnull(newvalue,''))) and ((oldvalue is not null or newvalue is not null) and newvalue <> '0000000000' )
  and isnull( [dbo].[Fed_LogTransactionData].SavedBy,'') <> '' and isnull( [dbo].[Fed_LogTransactionData].SavedBy,'') not like '%interface%'
 and datediff(d,@LastProcessedDate,[dbo].[Fed_LogTransactionData].savedat) > =0 
   order by [dbo].[Fed_LogTransactionData].SavedAt
    desc 

 


--get TANFFamilySize data which were added to log table adter @LastProcessedDate
insert into #TranSavedIdtable  (TranSavedId, DataSavedId, oldvalue, NewValue, fieldname, savedby, savedat, PKFieldValue, tableid) 
 select  distinct t.TranSavedId, [dbo].[Fed_LogTransactionData].DataSavedId,isnull(oldvalue,'()') as oldvalue, isnull(newvalue,'()') as newvalue ,FieldName, [dbo].[Fed_LogTransactionData].SavedBy, 
 [dbo].[Fed_LogTransactionData].savedat,t.PKFieldValue,t.TableId
  from [dbo].[Fed_LogTransactionData] inner join 
  [dbo].[Fed_LogTransaction] t on t.TranSavedId = [dbo].[Fed_LogTransactionData].TranSavedId and
   tableid = 17 and (fieldname ='TANFFamilySize') -- case table 
  and isnull(oldvalue,'') <> isnull(newvalue,'') 	 and (oldvalue is not null or newvalue is not null)
  and isnull( [dbo].[Fed_LogTransactionData].SavedBy,'') <> '' and isnull( [dbo].[Fed_LogTransactionData].SavedBy,'') not like '%interface%'
  and datediff(d, @LastProcessedDate,[dbo].[Fed_LogTransactionData].savedat) > 0 
   order by [dbo].[Fed_LogTransactionData].SavedAt
     desc 
	

--we are sending only most recent changes
 select max(dataSavedId) as datasavedid, Fieldname,[dbo].client.clientid into #selectFormdata  from
	 [dbo].[Fed_LogTransaction] t
	 inner join dbo.client with (nolock)  on t.PKFieldValue = [dbo].client.clientid 
	   and  (t.tableid =3 )
	inner join #TranSavedIdtable on #TranSavedIdtable.TranSavedId  = t.TranSavedId group by [dbo].client.clientid, fieldname 
	union 
 select max(dataSavedId) as datasavedid,Fieldname,[dbo].[case].caseid  from
	 [dbo].[Fed_LogTransaction] t
	 inner join dbo.[case] with (nolock)  on t.PKFieldValue = [dbo].[case].caseId
	   and  ( t.tableid = 17) --case table 
	inner join #TranSavedIdtable on #TranSavedIdtable.TranSavedId  = t.TranSavedId group by [dbo].[case].caseid, fieldname 

 insert into dbo.ClientContact (Companyid,clientid, [IsContact],[Title],
 [ContactTypeId],[ContactMethodId],[ContactDate],[ContactTime]
           ,[IsContactMade],[ContactNote],[GoodCauseReasonId] ,[IsGoodCauseClaimed] ,[IsGoodCauseApproved] ,[GoodCauseDenialNote]
           ,[IsClientAcceptedSendMsg],[MessageId],[NonComplianceLetterId],
		   [FormVersionId],[IsDeleted],[CreatedBy]
           ,[CreatedAt],[UpdatedBy],[UpdatedAt], logtableid)
		   
 SELECT  distinct dbo.Client.companyid,  dbo.Client.clientid, 0, 'Change of ' + d.fieldname + ' data',
  646, null, convert(varchar(20),d.savedat,101), convert(varchar(20),d.savedat,101),
   null,d.fieldname + ' was changed from ' + isnull(d.oldvalue,'n/a') + ' to ' + isnull(d.newvalue,'n/a'), null,null,null,null,
   null,null,null,
  3,0,t.savedby,convert(varchar(20),t.savedat,101),null,null, d.DataSavedId
	  from  #TranSavedIdtable t
	 inner join dbo.client with (nolock)  on t.PKFieldValue = [dbo].client.clientid 
	   and  t.tableid =3 
	   inner join dbo.Fed_LogTransactionData d on d.TranSavedId = t.TranSavedId
	  inner join  #selectFormdata f on f.datasavedid = d.DataSavedId and d.FieldName = f.Fieldname
	and d.DataSavedId not in (select isnull(logtableid,'') from dbo.ClientContact) and d.fieldname <> 'DOB'


union 
 SELECT  distinct dbo.Client.companyid,  dbo.Client.clientid, 0, 'Change of ' + d.fieldname + ' data',
  646, null, convert(varchar(20),d.savedat,101), convert(varchar(20),d.savedat,101) ,
   null,d.fieldname + ' was changed from ' + case isnull(d.oldvalue,'') when '' then  '()' else convert(varchar(20), cast(d.Oldvalue as datetime),101) end 
    +  ' to ' + case isnull(d.newvalue,'') when '' then  '()' else convert(varchar(20), cast(d.newvalue as datetime),101) end
   , null,null,null,null,
   null,null,null,
  3,0,t.savedby,convert(varchar(20),t.savedat,101),null,null, d.DataSavedId
	  from  #TranSavedIdtable t
	 inner join dbo.client with (nolock)  on t.PKFieldValue = [dbo].client.clientid 
	   and  t.tableid =3 
	   inner join dbo.Fed_LogTransactionData d on d.TranSavedId = t.TranSavedId
	  inner join  #selectFormdata f on f.datasavedid = d.DataSavedId and d.FieldName = f.Fieldname
	and d.DataSavedId not in (select isnull(logtableid,'') from dbo.ClientContact) and d.fieldname = 'DOB'
union
--number of TANF members in the family
SELECT  distinct dbo.[Case].companyid,  dbo.[Case].caseid, 0, 'Change of ' + d.fieldname + ' data',
  646, null, convert(varchar(20),d.savedat,101),convert(varchar(20),d.savedat,101),
   null,d.fieldname + ' was changed from ' + isnull(d.oldvalue,'')  + ' to ' + isnull(d.newvalue,''), null,null,null,null,
   null,null,null,
  3,0,t.savedby,convert(varchar(20),t.savedat,101),null,null, d.DataSavedId
	  from
		#TranSavedIdtable t
	 inner join dbo.[Case] with (nolock)  on t.PKFieldValue = dbo.[Case].Caseid
	   and  t.tableid =17
	inner join dbo.Fed_LogTransactionData d on d.TranSavedId = t.TranSavedId
	inner join dbo.client on dbo.client.ActiveCaseId = dbo.[case].CaseId  
	inner join  #selectFormdata f on f.datasavedid = d.DataSavedId and d.FieldName = f.Fieldname
	and  d.dataSavedId not in (select isnull(logtableid,'') from dbo.ClientContact) 

union
--select * From client where clientid in (13223,
--10668)
--sanction complited orientation and total count < 3
SELECT  distinct  dbo.Client.companyid,  dbo.Client.clientid, 0, 'Sanction Complied',
  646, null,convert(varchar(20), attendedcount1.[Date], 101) , getdate(),null, 
    case isnull(attendedcount1.ClassInstRoomId,0) when 11 then 'Client has attended an orientation appointment on ' + convert(varchar(20), attendedcount1.[Date], 101) else  'Starting '  + convert(varchar(20), attendedcount1.[Date], 101) + ' client demonstrated 3 or more consecutive days of compliance ' end  , 
    null,null,null,null,
   null,null,null,
  3,0,'fedcap\SanctionComplied_Interface',getdate(),null,null,attendedcount1.ScheduleId
  from dbo.schedule as attendedcount1 inner join dbo.client on dbo.client.clientid = attendedcount1.clientid and attendedcount1.isdeleted = 0 
  and attendedcount1.IsVisible = 1  cross apply 

  (select dbo.Client.clientid, min(attendedcount1.StartTime)  as attendancedatetime
	  from dbo.Schedule attendedcount1 inner join dbo.client on dbo.client.clientid =attendedcount1.clientid and SanctionEffectiveDate is not null 
	  and attendedcount1.clientid =  dbo.client.clientid and  attendedcount1.isdeleted =0 and datediff(d,dbo.client.sanctioneffectivedate,attendedcount1.Date) >= 0  AND
(DATEDIFF(d, attendedcount1.Date, GETDATE()) >= 0) and attendedcount1.attendancestatus in (1,2) 
inner join dbo.[case] on  dbo.[case].caseid =dbo.client.activecaseid 

outer apply (select distinct attended.Scheduleid, attended.date  from dbo.schedule attended where 
attended.clientid =  dbo.client.clientid and  attended.isdeleted =0  and (DATEDIFF(d, attended.Date, GETDATE()) >= 0) and 
attended.attendancestatus in (1,2) and  datediff(d,attendedcount1.date, attended.date) > 0 
and attended.ScheduleId <> attendedcount1.scheduleid )  attendedcount2

outer apply (select distinct attended.Scheduleid, attended.date   from dbo.schedule attended where 
attended.clientid =  dbo.client.clientid and  attended.isdeleted =0 and 
(DATEDIFF(d, attended.Date, GETDATE()) >= 0) and attended.attendancestatus in (1,2) and  datediff(d,attendedcount2.date, attended.date) > 0 
and attended.ScheduleId <> attendedcount2.scheduleid and attended.ScheduleId <> attendedcount1.scheduleid)  attendedcount3

--Where dbo.client.Sanction ='Y' and (attended_orientation.ClassInstRoomId = 11) AND 
Where (attendedcount1.ClassInstRoomId = 11 or attendedcount3.ScheduleId is not null and attendedcount2.ScheduleId is not null and attendedcount1.ScheduleId is not null and 
not exists  (select missed.date as totalcountofattended  from dbo.schedule missed  where 
missed.clientid =  dbo.client.clientid and  missed.isdeleted =0 and (datediff(d,attendedcount1.[date],missed.Date) >= 0  and datediff(d,attendedcount2.[date],missed.Date) <= 0  or
datediff(d,attendedcount2.[date],missed.Date) >= 0 ) and datediff(d,attendedcount3.[date],missed.Date) <= 0  and  missed.attendancestatus in (0, 3,4) )) --and dbo.Client.clientid =9843
group by dbo.Client.clientid) as firstattendance where firstattendance.clientid = attendedcount1.clientid 
and datediff(minute, attendedcount1.[starttime], firstattendance.attendancedatetime) = 0 and  attendedcount1.ScheduleId not in (select isnull(logtableid,'') from dbo.ClientContact) 


insert into dbo.ClientContact (Companyid,clientid, [IsContact],[Title],
 [ContactTypeId],[ContactMethodId],[ContactDate],[ContactTime]
           ,[IsContactMade],[ContactNote],[GoodCauseReasonId] ,[IsGoodCauseClaimed] ,[IsGoodCauseApproved] ,[GoodCauseDenialNote]
           ,[IsClientAcceptedSendMsg],[MessageId],[NonComplianceLetterId],
		   [FormVersionId],[IsDeleted],[CreatedBy]
           ,[CreatedAt],[UpdatedBy],[UpdatedAt], logtableid)

select a.*  from  
(select distinct  8 as companyid, sourcet.HRACaseID, 0 as c4,
case isnull(dbo.isplacementupdated(sourcet.PlacementEntryID, hracaseid),0) when 0 then 'New Placement' else 'Updated Placement' end  as c5,
  646 as c6, null as c7, getdate() as c8, getdate() as c9,
   null as c10,
   case isnull(dbo.isplacementupdated(sourcet.PlacementEntryID, hracaseid),0) when 0 then 'New Placement ' else 'Updated Placement ' end  +  'at ' + dbo.Employer.FirstName + '. Salary per hour: ' + cast(sourcet.SalaryPerHour  as varchar(100)) + ' Hours Per Week: ' + cast(sourcet.HoursPerWeek as varchar(100))
	+ '.' + ' Start date: ' + convert(varchar(20), sourcet.JobStart,101)  +  isnull(' End Date: ' + convert(varchar(20), sourcet.EndDate, 101),'') as newplacement,
	 null as c11,null as c12,null as c13,null as c14,
   null as [IsClientAcceptedSendMsg],null as [MessageId],null as [NonComplianceLetterId],
  3 as [FormVersionId],0 as [IsDeleted],'Fedcap/ChangeInterface' as [CreatedBy],getdate() as [CreatedAt],null as [UpdatedBy],null as [UpdatedAt], sourcet.PlacementEntryID as placemententryid

  from [dbo].[PlacementEntry] sourcet inner join  [dbo].[client]   on 
 sourcet.HRACaseID = client.clientid and isnull(sourcet.isdeleted,0) =0
 and clientno not like '%test%' --and datediff(d, sourcet.createdat,getdate()) = 0 
 inner join dbo.Employer on dbo.Employer.EmployerId = sourcet.EmployerId

  ) as    a  
  
 where  not exists
  (select au.contactnote from dbo.ClientContact au where au.clientid = a.hracaseid and (rtrim(au.contactNote) = rtrim(a.newplacement)
  or
  rtrim(au.contactNote) = replace(rtrim(a.newplacement),'Updated', 'New'))
 
  ) --and a.c5 like '%new%' 

  

end





