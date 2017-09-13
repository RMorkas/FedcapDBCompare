




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getShowRateData]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @date datetime
	set @date=GETDATE()

    Select data.ClientNo as [Referred Clients], data.[Attended Orientation], (case when data.IntakeDate is null then 0 else 1 end) as [Intake Completed],
    (case when data.HasMedDoc=0 then 1 else 0 end) as [Employment Track],(case when data.HasMedDoc=1 then 1 else 0 end) as [Medical Track],
    --(case when data.HasMedDoc is null then 1 else 0 end) as [Track is Pending],
    data.[Attended Orientation Within 3 days], ISNULL(CONVERT(varchar(10),data.[Days from Orientation to Intake]),'N/A') as [Days from Orientation to Intake],
    (case when data.[Post Orientation Attendance Date] is null then 0 else 1 end) as [Engaged in Activity After Orientation],
    (case when data.[Days from Orientation to Next Engagement Excluding Day of Orientation]<=3 then 1 else 0 end)[Engaged in Post Orientation Activity Within 3 days],
    ISNULL(CONVERT(varchar(10),data.[Days from Orientation to Next Engagement Excluding Day of Orientation]),'N/A')[Days from Orientation to Next Engagement],
    data.[Referral Date],
    data.Status,
    data.SiteName

    from 
    (   SELECT 
	   h.ClientId as ClientNo,
	   c.clientid,
	   ISNULL(orientationdate,ImportDate) as [Referral Date],
	   h.CaseStatus,
	   Orientation.Date As [Orientation Attendance Date],
	   (case when Orientation.Date is not null then 1 else 0 end) as [Attended Orientation],
	   (case when datediff(dd,(ISNULL(orientationdate,ImportDate)),Orientation.Date) > 3  or Orientation.Date is  null then 0 else 1 end) as [Attended Orientation Within 3 days],
	   [dbo].[HasMedicalDocumentation](c.ClientId) as HasMedDoc,
	   IntakeDate,
	   DATEDIFF(dd,Orientation.Date,IntakeDate) as [Days from Orientation to Intake],
	   PostOrientationSchedule.Date As [Post Orientation Attendance Date],
	   DATEDIFF(dd,Orientation.Date,PostOrientationSchedule.Date ) as [Days from Orientation to Next Engagement Excluding Day of Orientation],
	   CaseStatusHistory.Status,
	   s.SiteName
	   FROM  Historical_Referral h INNER JOIN Client c ON c.ClientNo = h.ClientId
	   --INNER JOIN [dbo].[Case] ca on c.ActiveCaseId=ca.CaseId
	   outer apply(Select top 1 s.date from Schedule s where 
											  s.ClientId = c.ClientId  
											  and ClassInstRoomId = 11
											  and s.AttendanceStatus in (1,2)
											  and s.IsDeleted <> 1
											  AND DATE < @date
											  order by Date) as Orientation

	   outer apply(Select top 1 s.date from Schedule s where 
											  s.ClientId = c.ClientId 
											  and s.AttendanceStatus in (1,2)
											  and s.Date<@date --Engaged before the end of the month
											  and ISNULL(ClassInstRoomId,0)<>11 --Do we need this?
											  and s.IsDeleted <>1
											  AND DATEDIFF(dd,Orientation.Date,s.DATE)>0 
											  order by s.Date) as PostOrientationSchedule

	   --outer apply(Select top 1 HasMedDoc from ClientIntake I where
				    --						   I.ClientId = c.ClientId
				    --						   AND I.CreatedAt < @date
				    --						   AND I.IsDeleted<>1
				    --						   AND I.ReasonTypeId != 659 --Pending Signature
				    --						   order by CreatedAt  desc) as Track

	   outer apply(Select top 1  CreatedAt as IntakeDate from ClientIntake I where
											  I.ClientId = c.ClientId
											  AND I.IsDeleted<>1
											  AND ((I.ReasonTypeId = 0 and I.Signature != '' and I.Signature != '300D0A300D0A') or I.ReasonTypeId in(658,783))
											  AND I.CreatedAt >= Orientation.Date -5
											  order by CreatedAt) as Intake
	   outer apply (select top 1 * from CaseStatusHistory ch where
										    ch.Caseid=c.ActiveCaseId
										    AND ch.Status_StartDate<= DATEADD(D,-1,@date)
										    AND ISNULL(ch.Status_EndDate,'2050-01-01')>=DATEADD(D,-1,@date)
										    order by ch.id desc)as CaseStatusHistory
	   left outer join Site s on c.SiteId=s.SiteId
	 --where ca.StatusId in ('o','p')
	) as data 
	 where data.[Referral Date] < @date
END