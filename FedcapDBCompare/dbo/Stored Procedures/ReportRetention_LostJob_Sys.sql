

CREATE PROCEDURE [dbo].[ReportRetention_LostJob_Sys]
	@Date_From DATETIME,
	@Date_To DATETIME,
	@companyId int,
	@RetentionId int
AS
BEGIN

SET NOCOUNT ON;

DECLARE @StartDate datetime, @EndDate datetime

SET @StartDate = @Date_From;
SET @EndDate = @Date_To;

SELECT        dbo.Site.SiteName AS Site, COUNT(dbo.Site.SiteId) AS TotalCount
FROM            dbo.PlacementEntry with(nolock) INNER JOIN
                         dbo.Site ON dbo.PlacementEntry.SiteId = dbo.Site.SiteId INNER JOIN
                         dbo.PlacementPeriod ON dbo.PlacementEntry.PlacementEntryID = dbo.PlacementPeriod.PlacementEntryID INNER JOIN
                         dbo.Enumes ON dbo.PlacementPeriod.PeriodId = dbo.Enumes.EnumId INNER JOIN
						 dbo.Enumes Enume_1 ON dbo.PlacementEntry.BillingTypeId = Enume_1.EnumId 
WHERE       
(PlacementEntry.CompanyId = @companyId)
and 
isnull(PlacementEntry.IsDeleted,0) = 0
AND
(Enume_1.Item NOT LIKE '%Not%') 
AND 
(dbo.Enumes.Item = cast(@RetentionId as varchar(20)))
AND
(ISNULL(dbo.PlacementPeriod.IsLostJob,0) = 1) 
AND 
(ISNULL(dbo.PlacementPeriod.IsReplaced,0) = 0)
AND
(
(dateadd(day,0,datediff(day,0,FIAEntryDate)) >= dateadd(day,0,datediff(day,0, @StartDate)))
AND
(dateadd(day,0,datediff(day,0,FIAEntryDate)) <= dateadd(day,0,datediff(day,0, @EndDate)))
)
Group By SiteName

END



