CREATE  function [dbo].[ACF_GetAverageHours]


(
    @ActivityID int,
	@clientID int,
	@Startdate DateTime,
	@EndDate DateTime,
	@schedulingStatus varchar(50),
	@precision varchar(4) = 2
)
returns  varchar(2)

as
begin
 
 declare @returnhours varchar(2)
 declare @leadingzeros varchar(20)


-- declare @startdate datetime
--declare @enddate datetime
--declare @activityid varchar(1)
--declare @schedulingstatus varchar(20)

--set @schedulingstatus ='attended'
--set @startdate = '01/01/2017'
--set @enddate = '01/31/2017'
--set @activityid =8

set @leadingzeros = replicate('0', @precision)

  
 select @returnhours=isnull(RIGHT(@leadingzeros + CAST(CEILING(cast(a.totalhours as float)/[dbo].[GetWeeklyCoeff](a.ClientId,@Startdate, @Enddate)) as varchar(20)),@precision),@leadingzeros)--,a.FederalActivityId,a.clientid
  -- from 
  --select  c.clientid, cast(a.totalhours as float)/[dbo].[GetWeeklyCoeff](c.ClientId,@Startdate, @Enddate),
  -- @ActivityID,f.FederalActivityName, @schedulingstatus 
   from 
	 (
	 select sum(scheduledhours) as totalhours,sc.clientid,sc.FederalActivityId from dbo.client with (nolock) inner join dbo.[case] with (nolock)
	 on dbo.client.activecaseid = dbo.[case].[caseid] and dbo.client.clientid =@clientid 
	 inner join  dbo.schedule sc  with (nolock) on sc.clientid = dbo.client.clientid  and sc.IsDeleted <> 1 --and 
	  --datediff(d,dbo.[case].StartDate, sc.[date]) >= 0 
	  --and
	 -- datediff(d, @enddate,isnull(dbo.[case].enddate,'01/01/2050')) >= 0 
  and (datediff(d,@startDate,sc.[date]) >=0  and  datediff(d,sc.[date],@endDate) >=0)  
  and ((sc.AttendanceStatus in (1,2,3,5,0) and @schedulingStatus ='' or 
  AttendanceStatus in (1,2) and @schedulingStatus ='attended' and isnull(sc.eventid,0) <> 74 or
  sc.AttendanceStatus = 3 and @schedulingStatus ='excused absence' and isnull(sc.eventid,0) <> 74 or
 @schedulingStatus ='holiday' and  sc.AttendanceStatus = 5  )
  and (sc.FederalActivityId = @ActivityID)  or  (isnull(sc.eventid,0) =74 and @schedulingStatus ='holiday' and @ActivityID = 
  (select top 1 actualactivity.FederalActivityId from dbo.schedule actualactivity with (nolock) 
  where actualactivity.ClientId = @clientid and isnull(actualactivity.eventid,0) <> 74 and  isnull(ClassInstRoomId,0) <> 11 and actualactivity.isdeleted <> 1 
  order by abs(datediff(d, actualactivity.[date], sc.[date])))))
  group by sc.clientid, sc.FederalActivityId)  a 
 
 -- where a.ClientId in
 --  (
 --select orientation.ClientId  From dbo.Schedule orientation where orientation.ClassInstRoomId =11 and 
 --  (datediff(d,@startdate, orientation.[date]) >= 0 and datediff(d,orientation.[date],@enddate) >= 0 ) and orientation.IsDeleted = 0)

  return @returnhours
end

