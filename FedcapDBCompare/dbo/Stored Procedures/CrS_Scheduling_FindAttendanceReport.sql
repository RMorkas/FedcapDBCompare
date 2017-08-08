




CREATE Proc [dbo].[CrS_Scheduling_FindAttendanceReport] (
@CycleStartDate datetime = null,@CycleendDate datetime = null,
@runid int)
as
begin
SET TRANSACTION ISOLATION LEVEL    READ UNCOMMITTED 
SET NOCOUNT ON
--declare	@CycleStartDate datetime ='06/12/2017'

--declare @Runid int = 6

declare @currentdate datetime = @CycleStartDate


DECLARE @ReportedDates table(
		Thedate datetime primary key,
		DayOfWeek int
	)

-- Fill dates Table:
WHILE datediff(d,@currentdate,@CycleEndDate) >= 0 
begin
	
	if (select count(*) from dbo.ScheduleHoliday where datediff(d,@currentdate, holidaydate)  = 0 ) = 0  and datediff(d,getdate(), @currentdate) <> 0 
	begin
			Insert Into @ReportedDates (thedate, DayOfWeek) values (@currentdate, datepart(weekday, @currentdate))
	end
    set @currentdate = dateadd(d,1,@currentdate)

 end




	--select * From dbo.Crs_timekeeping_export

	delete from dbo.Crs_timekeeping_export


	insert into dbo.Crs_timekeeping_export (
	clientid,
	HraCaseNumber, 
	Suffix,
	LineNumber,
	CIN,
	LastName,
	FirstName,
	JobCode,	
	WorkSiteCode,
	DTSAssignmentID,	
	AssignedHours,
	RequiredHours,
	ActivityDate,
	ActivityHours,
	ActivityCodeID,
	ActivityCode,
	datetimestamp, [Status], DeleteIndicator, CycleStartDate, CycleEndDate, runid, DTSClientID, Scheduleid)
select distinct dbo.Client.ClientId,
		dbo.[case].CaseNo,
		dbo.Client.Suffix,
		dbo.Client.LineNumber,
		ti.CIN,
		dbo.Client.CaseLastName,
		dbo.Client.CaseFirstName,
		ti.AgencyCode,
		ti.WorkSiteCode,
		ti.DTSAssignmentId,
		ti.AssignedHours,
		ti.RequiredHours,
		d.thedate as ActivityDate, 
		dbo.Crs_TImekeeping_CalculateHoursWithLunch(dbo.Schedule.ScheduledHours),
		--case dbo.Schedule.AttendanceStatus when 3 then '33' else  map.FederalActivityId  end as AttendanceReportActivityID,
		--case dbo.Schedule.AttendanceStatus when 3 then 'EDS' else map.ActivityCode end as AttendanceReportActivity, 
		map.FederalActivityId   as AttendanceReportActivityID,
		 map.ActivityCode  as AttendanceReportActivity, 
		getdate() as datetimestamp, 'updated' as [Status],'N' as DeletedIndicator, @CycleStartDate, @CycleEndDate,@runid,client.ClientNo, dbo.Schedule.scheduleid
		 from @ReportedDates d cross join crs_Timekeeping_Import ti inner join 
dbo.Schedule  on dbo.Schedule.ClientID = ti.ClientId and DATEDIFF(d,dbo.Schedule.[Date], d.Thedate) = 0  and  isnull(ti.status,'') <> 'Error'
and isnull(dbo.Schedule.isdeleted,0) = 0 and dbo.Schedule.AttendanceStatus in (1,2) 
 inner join dbo.Client on dbo.client.clientid  = ti.clientid
inner join dbo.[case] on dbo.[case].caseid = dbo.client.ActiveCaseId
--left outer join dbo.scheduleevent ev on ev.eventid =dbo.Schedule.eventid and dbo.Schedule.eventid is not null
--left outer join [dbo].[ScheduleClassInstRoom] on [dbo].[ScheduleClassInstRoom].[ClassInstRoomId] = dbo.Schedule.ClassInstRoomId and dbo.Schedule.ClassInstRoomId is not null inner join 
--dbo.[Scheduleclass] class on class.ClassId =[dbo].[ScheduleClassInstRoom].ClassId 
left outer join [dbo].[FederalActivityType] map on map.FederalActivityId = dbo.Schedule.FederalActivityId or map.FederalActivityId = Schedule.FederalActivityId and map.CompanyId = 9 
where
		(datediff(d,d.thedate,isnull(ti.TerminationDate,'01/01/2050')) > 0 or ti.TerminationDate='')  and datediff(d,ti.ProgramStartDate,d.thedate) >= 0  and 
		DayOfWeek in (2,3,4,5,6) 
	 	and not exists (select te.clientid from dbo.CrS_timekeeping_export te where te.clientid = ti.clientid and datediff(dd, te.activitydate,d.thedate)=0 and 
te.activityhours=dbo.Schedule.ScheduledHours and 
map.FederalActivityId =te.ActivityCodeId and te.status like '%reject%' ) 
and map.FederalActivityId is not null 

delete from CrS_Timekeeping_Export where AssignedHours = 0 



INSERT INTO [dbo].[CrS_Timekeeping_Export] 
(
	clientid,
	HraCaseNumber, 
	Suffix,
	LineNumber,
	CIN,
	LastName,
	FirstName,
	JobCode,	
	WorkSiteCode,
	DTSAssignmentID,	
	AssignedHours,
	RequiredHours,
	ActivityDate,
	ActivityHours,
	ActivityCodeID,
	ActivityCode,
	datetimestamp, [Status], DeleteIndicator, CycleStartDate, CycleEndDate, runid, DTSClientID
                                
)
SELECT distinct au.clientid,
	au.HraCaseNumber, 
	au.Suffix,
	au.LineNumber,
	au.CIN,
	au.LastName,
	au.FirstName,
	au.JobCode,	
	au.WorkSiteCode,
	au.DTSAssignmentID,	
	au.AssignedHours,
	au.RequiredHours,
	convert(varchar(20), au.ActivityDate,101) ,
	au.ActivityHours,
	au.ActivityCodeID,
	au.ActivityCode,
	getdate(), 'Updated', 'Y', au.CycleStartDate, au.CycleEndDate, @runid, au.DTSClientID
FROM dbo.crs_TimeKeeping_Export_Audit au with (nolock) 
inner join dbo.Crs_timekeeping_export te on datediff(d,te.CycleStartDate,au.CycleStartDate) = 0  and te.DTSAssignmentId = au.DTSAssignmentId
 and datediff(d,te.[ActivityDate], au.ActivityDate) =  0 
 and isnull(au.Status,'') <> 'Error'  and isnull(au.Status,'') <> 'rejected' and   isnull(te.DeleteIndicator,'N') <> 'Y' and   isnull(au.DeleteIndicator,'N') <> 'Y' 
 --and datediff(d,te.date, getdate()) > 0   sgl 06-10-2013: commented to execute the second run of DTS BTW process (from VB app, second run requested by HRA) 
 and 
dbo.Timekeeping_DuplicateRecordsCheck(te.DTSAssignmentId,te.ActivityDate) = 1



delete te from dbo.Crs_timekeeping_export te
where  datediff(d,te.ActivityDate,getdate()) > 0 and status ='Updated' and isnull(te.DeleteIndicator,'N') <> 'Y' -- and isnull(te.Deleteflagchanged,'N') <> 'Y' 
and dbo.Timekeeping_DuplicateRecordsCheck(te.DTSAssignmentId,te.ActivityDate) = 0 



 insert into  dbo.Crs_timekeeping_export_audit (
	clientid,
	HraCaseNumber, 
	Suffix,
	LineNumber,
	CIN,
	LastName,
	FirstName,
	JobCode,	
	WorkSiteCode,
	DTSAssignmentID,	
	AssignedHours,
	RequiredHours,
	ActivityDate,
	ActivityHours,
	ActivityCodeID,
	ActivityCode,
	datetimestamp, [Status], DeleteIndicator, CycleStartDate, CycleEndDate, runid, DTSClientID, Scheduleid)
   select clientid,
	HraCaseNumber, 
	Suffix,
	LineNumber,
	CIN,
	LastName,
	FirstName,
	JobCode,	
	WorkSiteCode,
	DTSAssignmentID,	
	AssignedHours,
	RequiredHours,
	ActivityDate,
	ActivityHours,
	ActivityCodeID,
	ActivityCode,
	datetimestamp, [Status], DeleteIndicator, CycleStartDate, CycleEndDate, runid, DTSClientID, Scheduleid from CrS_Timekeeping_Export



end












