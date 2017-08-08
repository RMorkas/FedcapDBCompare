CREATE VIEW [dbo].[Search_VW_EducationProvider]
AS
SELECT p.[EducationProviderId], p.Name AS [Name], p.[StreetAddress], p.[City], s.StateName AS [State], p.[ZipCode]
FROM dbo.EducationProvider p  WITH (NOLOCK)
LEFT JOIN dbo.[State] s WITH (NOLOCK) ON s.StateCode = p.[State]
WHERE p.IsDeleted = 0
