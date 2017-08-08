Create PROCEDURE [dbo].[GetAttendanceClassPresent]
	@Date_From DATETIME,
	@Date_To DATETIME
AS
BEGIN

SET NOCOUNT ON;

DECLARE @StartDate DATETIME;
DECLARE @EndDate DATETIME;
SET @StartDate = @Date_From;
SET @EndDate = @Date_To;

SELECT     Scheduling_Event.EventName, WeCARELocations.LocationDesc, HRACases.CaseFirstName, HRACases.CaseSurname, HRACases.HRACaseNumber, 
                      HRACases.Suffix, HRACases.LineNumber, HRACases.SSN, HRACases.CIN, LEFT(CONVERT(VARCHAR, Scheduling_Attendance.Date, 120), 10) as EventDate
FROM         allsector_BTW.fedcapbtw.dbo.WeCARELocations with (nolock) INNER JOIN
                      allsector_BTW.fedcapbtw.dbo.EventLocations with (nolock) ON WeCARELocations.LocationCode = EventLocations.LocationCode INNER JOIN
                      allsector_BTW.fedcapbtw.dbo.Scheduling_Attendance with (nolock) INNER JOIN
                     allsector_BTW.fedcapbtw.dbo.Scheduling_Enrollment with (nolock) ON Scheduling_Attendance.EnrollmentID = Scheduling_Enrollment.ID INNER JOIN
                      allsector_BTW.fedcapbtw.dbo.Scheduling_Event with (nolock) ON Scheduling_Enrollment.EventID = Scheduling_Event.ID ON EventLocations.SiteID = Scheduling_Event.CompanyLocationSiteID INNER JOIN
                      allsector_BTW.fedcapbtw.dbo.HRACases with (nolock) ON Scheduling_Enrollment.CaseID = HRACases.HRACaseID
                      where ([DATE] between @StartDate and @EndDate) and (EventName != '') and (EventName is not null)

END
