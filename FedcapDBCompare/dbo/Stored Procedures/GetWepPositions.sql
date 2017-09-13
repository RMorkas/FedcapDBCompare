CREATE PROCEDURE [dbo].[GetWepPositions] 
@companyId int,
@organizationName varchar(100),
@siteName varchar(100),
@positionTypeId int,
@accessible bit,
@elevator bit,
@zipCodes varchar(max),
@wepSitePositionId int
AS
BEGIN	
	SET NOCOUNT ON;

	SELECT
		wo.WepOrganizationId,
		wo.Name AS OrganizationName,
		wp.WepSiteId,
		wp.WepSitePositionId,
		ws.SiteName,
		e.Item AS PositionType,
		wp.[Description],
		ISNULL(wp.NumberOfSlots, 0) AS NumberOfSlots,
		ISNULL(assignments.AssignmentCount, 0) AS TakenSlots,
		ISNULL(languages.Languages, '') AS Languages,
		CAST(CASE WHEN mous.MouCount > 0 THEN 1 ELSE 0 END AS BIT) AS HasMou
	FROM dbo.WepSitePosition wp WITH (NOLOCK)
	INNER JOIN dbo.Enumes e WITH (NOLOCK) ON e.EnumId = wp.PositionTypeId
	INNER JOIN dbo.WepSite ws WITH (NOLOCK) ON ws.WepSiteId = wp.WepSiteId
	INNER JOIN dbo.WepOrganization wo WITH (NOLOCK) ON wo.WepOrganizationId = ws.WepOrganizationId
	CROSS APPLY
	(
		SELECT COUNT(WepSitePositionAssignmentId) AS AssignmentCount
		FROM dbo.WepSitePositionAssignment wa WITH (NOLOCK)
		WHERE wa.WepSitePositionId = wp.WepSitePositionId AND wa.IsActive = 1
	) AS assignments
	CROSS APPLY
	(
		SELECT ISNULL(stuff((SELECT ',' + e.Item FROM dbo.WepSitePositionLanguage wl WITH (NOLOCK)
		INNER JOIN dbo.Enumes e WITH (NOLOCK) ON e.EnumId = wl.LanguageId
		WHERE wl.WepSitePositionId = wp.WepSitePositionId FOR XML PATH(''), TYPE).value('.', 'varchar(max)'),1,1,''), '') AS Languages
	) AS languages
	CROSS APPLY
	(
		SELECT COUNT(WepSiteMouAttachmentId) AS MouCount
		FROM dbo.WepSiteMouAttachment wm WITH (NOLOCK)
		WHERE wm.WepSiteId = wp.WepSiteId AND wm.IsDeleted = 0
	) AS mous
    WHERE wo.CompanyId = @companyId AND wo.IsDeleted = 0 AND ws.IsDeleted = 0 AND wp.IsDeleted = 0	AND	
		(LEN(@organizationName) = 0 OR wo.Name LIKE @organizationName + '%')		
		AND
		(LEN(@siteName) = 0 OR ws.SiteName LIKE @siteName + '%')		
		AND
		(@positionTypeId = 0 OR wp.PositionTypeId = @positionTypeId)		
		AND
		(ISNULL(@accessible, 0) = 0 OR ws.IsAccessibleLocation = @accessible)		
		AND
		(ISNULL(@elevator, 0) = 0 OR ws.HasElevator = @elevator)		
		AND
		(LEN(@zipCodes) = 0 OR ws.SiteZipCode IN (SELECT value FROM dbo.SplitStr(@zipCodes, ',')))
		AND
		(@wepSitePositionId = 0 OR wp.WepSitePositionId = @wepSitePositionId)
END
