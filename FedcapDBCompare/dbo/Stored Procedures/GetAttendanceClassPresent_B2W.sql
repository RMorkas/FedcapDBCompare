
CREATE PROCEDURE [dbo].[GetAttendanceClassPresent_B2W]
	@Date_From DATETIME,
	@Date_To DATETIME
AS
BEGIN

SET NOCOUNT ON;

DECLARE @StartDate DATETIME;
DECLARE @EndDate DATETIME;
SET @StartDate = @Date_From;
SET @EndDate = @Date_To;

SELECT   Scheduling_Enrollment.caseid as hraCaseID,   HRACases.CaseFirstName + ', ' +  HRACases.CaseSurname as CaseName, HRACases.SSN, 
		HRACases.CIN,HRACases.HRACaseNumber + '-' + HRACases.Suffix + '-' +  HRACases.LineNumber as CaseNumber, WeCARELocations.LocationDesc as LocationDesc,
					  case Scheduling_Event.EventName when '' then et.description else Scheduling_Event.EventName end as Activity, LEFT(CONVERT(VARCHAR, Scheduling_Attendance.Date, 120), 10) as EventDate
FROM         allsector_BTW.fedcapbtw.dbo.WeCARELocations with (nolock) INNER JOIN
                      allsector_BTW.fedcapbtw.dbo.EventLocations with (nolock) ON WeCARELocations.LocationCode = EventLocations.LocationCode INNER JOIN
                      allsector_BTW.fedcapbtw.dbo.Scheduling_Attendance with (nolock) INNER JOIN
                     allsector_BTW.fedcapbtw.dbo.Scheduling_Enrollment with (nolock) ON Scheduling_Attendance.EnrollmentID = Scheduling_Enrollment.ID INNER JOIN
                      allsector_BTW.fedcapbtw.dbo.Scheduling_Event with (nolock) ON Scheduling_Enrollment.EventID = Scheduling_Event.ID ON EventLocations.SiteID = Scheduling_Event.CompanyLocationSiteID INNER JOIN
                      allsector_BTW.fedcapbtw.dbo.HRACases with (nolock) ON Scheduling_Enrollment.CaseID = HRACases.HRACaseID
					  Inner join allsector_BTW.fedcapbtw.dbo.scheduling_eventtype et on et.id =  Scheduling_Event.eventTypeid
                      where ([DATE] between @StartDate and @EndDate) --and (EventName != '') and (EventName is not null)

END