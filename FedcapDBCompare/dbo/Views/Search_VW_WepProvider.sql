







CREATE VIEW [dbo].[Search_VW_WepProvider]
AS
SELECT p.[WepSiteId], o.Name AS [OrganizationName], o.[CompanyId], p.[SiteName], p.[SiteStreetAddress], p.[SiteCity], s.StateName AS [SiteState], p.[SiteZipCode], p.[IsDeleted]
FROM dbo.WepSite p  WITH (NOLOCK)
LEFT JOIN dbo.WepOrganization o WITH (NOLOCK) ON p.WepOrganizationId = o.WepOrganizationId
LEFT JOIN dbo.[State] s WITH (NOLOCK) ON s.StateCode = p.[SiteState]





