CREATE VIEW [dbo].[Search_VW_EducationProgram]
AS
SELECT p.[EducationProgramId], p.ProgramName AS [Name], e.Name AS [ProviderName], p.[StreetAddress], p.[City], s.StateName AS [State], p.[ZipCode]
FROM dbo.EducationProgram p  WITH (NOLOCK)
INNER JOIN dbo.EducationProvider e WITH (NOLOCK) ON e.EducationProviderId = p.EducationProviderId
LEFT JOIN dbo.[State] s WITH (NOLOCK) ON s.StateCode = p.[State]
WHERE p.IsDeleted = 0
