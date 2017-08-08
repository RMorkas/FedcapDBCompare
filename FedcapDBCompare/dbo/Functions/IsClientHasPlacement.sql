




CREATE Function [dbo].[IsClientHasPlacement]
(
	@companyId int,
	@monthdate smalldatetime,
	@ClientId int
)
RETURNS bit
AS
BEGIN
DECLARE @count int = 0, @IsClientHasPlacement bit = 0, @startDate smalldatetime

SET @startDate = DATEADD(month, DATEDIFF(month, 0, @monthDate), 0)

select @count = count(PlacementEntryID)
FROM            PlacementEntry
WHERE
CompanyId = @companyId
AND
HRACaseID = @ClientId
AND
ISNULL(IsDeleted,0) = 0
AND
((JobStart <= @monthdate) AND (EndDate is null OR EndDate >= @startDate))

IF(@count > 0)
	SET @IsClientHasPlacement = 1; --Has Placement
ELSE
	SET @IsClientHasPlacement = 0;

Return @IsClientHasPlacement

END
