

CREATE PROCEDURE [dbo].[GetEducationPrograms] 
@providerName varchar(100),
@programName varchar(100),
@schoolTypeId int,
@attainmentTypeId int,
@zipCodes varchar(max)
AS
BEGIN	
	SET NOCOUNT ON;

	SELECT
		provider.EducationProviderId,
		provider.Name AS ProviderName,
		program.EducationProgramId,		
		program.ProgramName,		
		s.Item AS SchoolType,
		a.Item AS AttainmentType,
		program.StreetAddress AS StreetAddress,
		program.City AS City,
		program.[State] AS [State],
		program.ZipCode AS ZipCode
	FROM dbo.EducationProgram program WITH (NOLOCK)
	INNER JOIN dbo.EducationProvider provider  WITH (NOLOCK) ON provider.EducationProviderId = program.EducationProviderId
	INNER JOIN dbo.Enumes s WITH (NOLOCK) ON s.EnumId = provider.SchoolTypeId
	LEFT JOIN dbo.Enumes a WITH (NOLOCK) ON a.EnumId = program.AttainmentTypeId	
    WHERE program.IsDeleted = 0 AND provider.IsDeleted = 0 AND
		(LEN(@providerName) = 0 OR provider.Name LIKE @providerName + '%')		
		AND
		(LEN(@programName) = 0 OR program.ProgramName LIKE @programName + '%')		
		AND
		(@schoolTypeId = 0 OR provider.SchoolTypeId = @schoolTypeId)		
		AND
		(@attainmentTypeId = 0 OR program.AttainmentTypeId = @attainmentTypeId)					
		AND
		(LEN(@zipCodes) = 0 OR program.ZipCode IN (SELECT value FROM dbo.SplitStr(@zipCodes, ',')))
END
