




create Function [dbo].[IsClientAssignedToWEP]
(
	@monthdate smalldatetime,
	@ClientId int
)
RETURNS bit
AS
BEGIN
DECLARE @count int = 0, @IsClientAssignedToWEP bit = 0, @startDate smalldatetime

SET @startDate = DATEADD(month, DATEDIFF(month, 0, @monthDate), 0)

SELECT    @count =COUNT(dbo.WepSitePositionAssignment.ClientId)
FROM         dbo.WepSitePosition INNER JOIN
             dbo.WepSitePositionAssignment ON dbo.WepSitePosition.WepSitePositionId = dbo.WepSitePositionAssignment.WepSitePositionId
WHERE
ClientId = @ClientId
AND
ISNULL(IsDeleted,0) = 0
AND
((StartDate <= @monthdate) AND (EndDate is null OR EndDate >= @startDate))

IF(@count > 0)
	SET @IsClientAssignedToWEP = 1; --Assigned to WEP
ELSE
	SET @IsClientAssignedToWEP = 0;

Return @IsClientAssignedToWEP

END
