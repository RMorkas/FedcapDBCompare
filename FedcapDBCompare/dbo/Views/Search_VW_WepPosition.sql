
CREATE VIEW [dbo].[Search_VW_WepPosition]
AS
SELECT p.WepSitePositionId, 
	o.Name AS [OrganizationName], 
	o.[CompanyId], 
	r.[SiteName], 
	e.[Item] AS PositionType,
	p.[IsDeleted]
FROM dbo.WepSitePosition p  WITH (NOLOCK)
INNER JOIN dbo.Enumes e WITH (NOLOCK) ON e.EnumId = p.PositionTypeId
INNER JOIN dbo.WepSite r WITH (NOLOCK) ON r.WepSiteId = p.WepSiteId
INNER JOIN dbo.WepOrganization o WITH (NOLOCK) ON r.WepOrganizationId = o.WepOrganizationId