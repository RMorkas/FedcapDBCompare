CREATE VIEW [dbo].[Search_VW_WepOrganization]
AS
SELECT WepOrganizationId, Name AS [OrganizationName], Director, o.CompanyId, IsDeleted, e.Item AS Industry
FROM dbo.WepOrganization o with(nolock)
INNER JOIN dbo.Enumes e ON e.EnumId = o.IndustryId
