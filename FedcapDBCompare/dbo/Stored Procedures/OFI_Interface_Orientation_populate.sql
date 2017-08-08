CREATE  procedure [dbo].[OFI_Interface_Orientation_populate] (@statusmessage varchar(max) output)
as
begin

set nocount on
set transaction isolation level read uncommitted

declare @roomnumber int
set @roomnumber = 11 

-- Attendance Status:  1 Attended; 2 Late; 3 Excused; 4 Absent;


Set @statusmessage = 'ok';

begin try
INSERT INTO [dbo].[OFI_Interface_Orientation_Audit]
           ([OFI_Office]
		   ,[clientid]
           ,[ClientNo]
           ,[CaseNo]
           ,[Date]
           ,[Orientation_Attended]
           ,[New_Orientation_Date]
           ,[Dateadded]
            ,scheduleid,Good_Cause_Notes)
--rescheduled
 
SELECT      distinct  dbo.client.ReferringOfficeNumber as [OFI office], client.ClientId, client.clientno, dbo.OFI_RemoveTempCaseNumber(dbo.[case].caseno),  
missed_orientation.StartTime as [missed date], 'Rescheduled' as [Orientation Attended], 
future_orientation_Data.StartTime as [new orientation date], getdate(),  missed_orientation.ScheduleId,'' as NoteSchedule
FROM  dbo.Schedule missed_orientation with (nolock) inner join dbo.client on dbo.client.clientid =missed_orientation.clientid 
 and clientno not like '%test%' and missed_orientation.isvisible = 1 and missed_orientation.IsDeleted <> 1 
inner join dbo.[case] on  dbo.[case].caseid =dbo.client.activecaseid
and (missed_orientation.ClassInstRoomId = @roomnumber) AND (DATEDIFF(d, missed_orientation.Date, GETDATE()) >= 0) and missed_orientation.attendancestatus =4
and (dbo.[case].StatusId = 'P' or datediff(d,'08/02/2017', missed_orientation.StartTime) >0) 
 and not exists ( select scheduleid from dbo.Schedule attended_orientation with (nolock) where attended_orientation.clientid = missed_orientation.ClientId and 
attended_orientation.ClassInstRoomId = @roomnumber AND DATEDIFF(d, missed_orientation.[date], attended_orientation.[Date])  > 0 and attended_orientation.attendancestatus in (1,2,3) 
and attended_orientation.IsDeleted <> 1  and isnull(attended_orientation.EventId,0) <> 74 )  

and  not exists (select dbo.OFI_Interface_orientation_audit.clientid from dbo.OFI_Interface_orientation_audit with (nolock) where
 dbo.OFI_Interface_orientation_audit.clientid  = missed_orientation.clientid 
 and datediff(d,missed_orientation.StartTime,dbo.OFI_Interface_orientation_audit.date) = 0) 

cross apply 
(select max(future_orientation.Starttime) as StartTime from  dbo.Schedule future_orientation with (nolock)  where 
missed_orientation.clientid = future_orientation.clientid and future_orientation.ClassInstRoomId=@roomnumber 
and isnull(future_orientation.EventId,0) <> 74 and future_orientation.ClassInstRoomId = @roomnumber and future_orientation.IsDeleted <> 1 
and DATEDIFF(d,missed_orientation.[Date], future_orientation.[Date]) > 0
and missed_orientation.ScheduleId <> future_orientation.ScheduleId ) future_orientation_Data
where future_orientation_Data.StartTime is not null 


--not attended
union
SELECT      distinct dbo.client.ReferringOfficeNumber as [OFI office],client.ClientId, dbo.client.clientno, dbo.OFI_RemoveTempCaseNumber(dbo.[case].caseno), 
 missed_orientation.StartTime, 'No'  as [Orientation Attended], 
'' as [new orientation date],getdate(), missed_orientation.ScheduleId,'' as NoteSchedule
FROM  dbo.Schedule missed_orientation with (nolock) inner join dbo.client with (nolock) on dbo.client.clientid =missed_orientation.clientid 
 and clientno not like '%test%' and missed_orientation.isvisible = 1 and missed_orientation.IsDeleted <> 1 
inner join dbo.[case] on  dbo.[case].caseid =dbo.client.activecaseid and (dbo.[case].StatusId = 'P' or datediff(d,'08/02/2017', missed_orientation.StartTime) >0)
Where (missed_orientation.ClassInstRoomId = @roomnumber) AND (DATEDIFF(d, missed_orientation.Date, GETDATE()) >= 0) and missed_orientation.attendancestatus =4
and not exists (select future_orientation.scheduleid from dbo.Schedule future_orientation with (nolock) where future_orientation.IsDeleted <> 1 and 
missed_orientation.clientid = future_orientation.clientid and missed_orientation.companyid =  future_orientation.companyid and 
(DATEDIFF(d,missed_orientation.[Date], future_orientation.[Date]) > 0
and missed_orientation.ScheduleId <> future_orientation.ScheduleId and future_orientation.ClassInstRoomId = @roomnumber)) 
and not exists ( select attended_orientation.scheduleid from dbo.Schedule attended_orientation with (nolock) where attended_orientation.clientid =missed_orientation.clientid and 
attended_orientation.ClassInstRoomId = @roomnumber AND DATEDIFF(d, missed_orientation.[Date],attended_orientation.[Date]) >= 0 and attended_orientation.attendancestatus in (1,2,3) 
and isnull(attended_orientation.EventId,0) <> 74
 and  attended_orientation.IsDeleted <> 1) 
and  not exists (select dbo.OFI_Interface_orientation_audit.clientid from dbo.OFI_Interface_orientation_audit with (nolock)
 where dbo.OFI_Interface_orientation_audit.clientid  = missed_orientation.clientid
 and datediff(d,missed_orientation.StartTime,dbo.OFI_Interface_orientation_audit.date) = 0) 

--exused/good cause
union
SELECT     distinct dbo.client.ReferringOfficeNumber as [OFI office], client.ClientId,  dbo.client.clientno, dbo.OFI_RemoveTempCaseNumber(dbo.[case].caseno),  
missed_orientation.StartTime, 'Good Cause'  as [Orientation Attended], isnull(convert(varchar(30),future_orientation.StartTime,121),'') as [new orientation date],
getdate(),  missed_orientation.ScheduleId, isnull(missed_orientation.ExcuseNote,'')  as NoteSchedule

FROM  dbo.Schedule missed_orientation with (nolocK) inner join dbo.client with (nolocK) on dbo.client.clientid =missed_orientation.clientid 
 and clientno not like '%test%' and missed_orientation.isvisible = 1 and missed_orientation.IsDeleted <> 1 and  missed_orientation.ClassInstRoomId = @roomnumber and 
 DATEDIFF(d, missed_orientation.Date, GETDATE()) >= 0 and missed_orientation.attendancestatus =3

 and not exists ( select attended_orientation.scheduleid from dbo.Schedule attended_orientation with (nolocK) where attended_orientation.clientid = missed_orientation.clientid and 
attended_orientation.ClassInstRoomId = @roomnumber AND attended_orientation.attendancestatus in (1,2,3) and isnull(attended_orientation.EventId,0) <> 74 and  
attended_orientation.IsDeleted <> 1
and  datediff(d,missed_orientation.date,attended_orientation.date) > 0 )  

inner join dbo.[case] with (nolocK) on  dbo.[case].caseid =dbo.client.activecaseid and (dbo.[case].StatusId = 'P' or datediff(d,'08/02/2017', missed_orientation.StartTime) >0)
left join  dbo.Schedule future_orientation with (nolocK) on 
missed_orientation.clientid = future_orientation.clientid and (future_orientation.ClassInstRoomId = @roomnumber and missed_orientation.companyid =  future_orientation.companyid 
and (DATEDIFF(d,missed_orientation.[date], future_orientation.[Date]) > 0 and (DATEDIFF(d,missed_orientation.[date] , future_orientation.[Date]) > 0
and missed_orientation.ScheduleId <> future_orientation.ScheduleId and  future_orientation.IsDeleted <> 1 ))) 
left join dbo.[site] with (nolocK) on  dbo.[site].siteid = dbo.client.ReferringOfficeNumber
Where not exists (select dbo.OFI_Interface_orientation_audit.clientid from dbo.OFI_Interface_orientation_audit with (nolocK)
where dbo.OFI_Interface_orientation_audit.clientid  = missed_orientation.clientid
 and datediff(d,missed_orientation.StartTime,dbo.OFI_Interface_orientation_audit.date) = 0) 

--attended
union
SELECT    distinct dbo.client.ReferringOfficeNumber as [OFI office], client.ClientId,   dbo.client.clientno, dbo.OFI_RemoveTempCaseNumber(dbo.[case].caseno), 
 missed_orientation.StartTime, 'Yes'  as [Orientation Attended], '' as [new orientation date],getdate(),  missed_orientation.ScheduleId,'' as NoteSchedule
FROM  dbo.Schedule missed_orientation with (nolock) inner join dbo.client on dbo.client.clientid =missed_orientation.clientid 
 and clientno not like '%test%' and missed_orientation.isvisible = 1 and missed_orientation.IsDeleted <> 1 
inner join dbo.[case] on  dbo.[case].caseid =dbo.client.activecaseid and (dbo.[case].StatusId = 'P' or datediff(d,'08/02/2017', missed_orientation.StartTime) >0)
Where (missed_orientation.ClassInstRoomId = @roomnumber) AND (DATEDIFF(d, missed_orientation.Date, GETDATE()) >= 0) and missed_orientation.attendancestatus in (1,2) 
and DATEDIFF(d, missed_orientation.Date,getdate()) <= 31
and  not exists (select dbo.OFI_Interface_orientation_audit.clientid from dbo.OFI_Interface_orientation_audit with (nolock)
where dbo.OFI_Interface_orientation_audit.clientid  = missed_orientation.clientid
 and datediff(d,missed_orientation.StartTime,dbo.OFI_Interface_orientation_audit.date) = 0) 

End try
begin catch
  select @statusmessage = ERROR_MESSAGE()
end catch
end


