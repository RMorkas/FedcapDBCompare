CREATE PROCEDURE [dbo].[GetWepAssignments] 
@caseNumber varchar(50) =NULL,
@companyId int,
@organizationName varchar(100),
@siteName varchar(100),
@positionTypeId int,
@startDate datetime,
@endDate datetime,
@wepSitePositionId int
AS
BEGIN	
	SET NOCOUNT ON;

	SELECT
		wpa.WepSitePositionAssignmentId,
		wp.WepSitePositionId,
		wo.Name AS OrganizationName,
		ws.SiteName,
		e.Item AS PositionName,
		wp.[Description] AS PositionDescription,
		cases.CaseFirstName + ' ' + cases.CaseSurname AS ClientName,
		wpa.StartDate,
		wpa.EndDate,
		wpa.IsActive,
		totalScheduledHours.TotalHours AS TotalScheduledHours,
		totalAttendedHours.TotalHours AS TotalAttendedHours,
		cases.IsPrivilegeRequired AS IsPrivilegeRequired,
		cases.HRACaseID AS ClientId
	FROM dbo.WepSitePositionAssignment wpa WITH (NOLOCK)
	INNER JOIN dbo.VW_HRACases cases WITH (NOLOCK) ON cases.HRACaseID = wpa.ClientId AND cases.CompanyId = @companyId
	INNER JOIN dbo.WepSitePosition wp WITH (NOLOCK) ON wpa.WepSitePositionId = wp.WepSitePositionId
	INNER JOIN dbo.Enumes e WITH (NOLOCK) ON e.EnumId = wp.PositionTypeId
	INNER JOIN dbo.WepSite ws WITH (NOLOCK) ON ws.WepSiteId = wp.WepSiteId
	INNER JOIN dbo.WepOrganization wo WITH (NOLOCK) ON wo.WepOrganizationId = ws.WepOrganizationId
	CROSS APPLY 
	(
		SELECT SUM(DATEDIFF(hour, StartTime, EndTime)) AS TotalHours FROM dbo.Schedule schedule WITH (NOLOCK)
		WHERE schedule.WepSitePositionAssignmentId = wpa.WepSitePositionAssignmentId AND schedule.IsDeleted = 0
	) totalScheduledHours
	CROSS APPLY 
	(
		SELECT SUM(DATEDIFF(hour, StartTime, EndTime)) AS TotalHours FROM dbo.Schedule schedule WITH (NOLOCK)
		WHERE schedule.WepSitePositionAssignmentId = wpa.WepSitePositionAssignmentId AND schedule.IsDeleted = 0
		AND schedule.AttendanceStatus = 1
	) totalAttendedHours
    WHERE wo.CompanyId = @companyId AND wo.IsDeleted = 0 AND ws.IsDeleted = 0 AND wp.IsDeleted = 0	AND	
		(LEN(@organizationName) = 0 OR wo.Name LIKE @organizationName + '%')		
		AND
		(LEN(@siteName) = 0 OR ws.SiteName LIKE @siteName + '%')		
		AND
		(@positionTypeId = 0 OR wp.PositionTypeId = @positionTypeId)
		AND
		(LEN(@caseNumber) = 0 OR cases.HRACaseNumber = @caseNumber)
		AND
		(@startDate is null OR wpa.StartDate >= @startDate)
		AND
		(@endDate is null OR wpa.EndDate <= @endDate)
		AND
		(@wepSitePositionId = 0 OR wpa.WepSitePositionId = @wepSitePositionId)
	ORDER BY cases.CaseFirstName, wpa.StartDate
END
