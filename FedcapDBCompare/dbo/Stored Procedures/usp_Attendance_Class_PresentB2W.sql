CREATE PROCEDURE [dbo].[usp_Attendance_Class_PresentB2W]
	-- Add the parameters for the stored procedure here
	@Date_From varchar(10),
	@Date_To varchar(10)
	
	--@Date_From datetime,
	--@Date_To datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	EXEC('
SELECT     Scheduling_Event.EventName, WeCARELocations.LocationDesc, HRACases.CaseFirstName, HRACases.CaseSurname, HRACases.HRACaseNumber, 
                      HRACases.Suffix, HRACases.LineNumber, HRACases.SSN, Scheduling_Attendance.Date
FROM         dbo.WeCARELocations with (nolock) INNER JOIN
                      dbo.EventLocations with (nolock) ON dbo.WeCARELocations.LocationCode = dbo.EventLocations.LocationCode INNER JOIN
                      dbo.Scheduling_Attendance with (nolock) INNER JOIN
                      dbo.Scheduling_Enrollment with (nolock) ON dbo.Scheduling_Attendance.EnrollmentID = dbo.Scheduling_Enrollment.ID INNER JOIN
                      dbo.Scheduling_Event with (nolock) ON dbo.Scheduling_Enrollment.EventID = dbo.Scheduling_Event.ID ON dbo.EventLocations.SiteID = dbo.Scheduling_Event.CompanyLocationSiteID INNER JOIN
                      dbo.HRACases with (nolock) ON dbo.Scheduling_Enrollment.CaseID = dbo.HRACases.HRACaseID
                      where  
DATE between ? and ?', @Date_From, @Date_To) AT Allsector_BTW
END
