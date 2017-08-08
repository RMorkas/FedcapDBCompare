

CREATE PROCEDURE [dbo].[ReportRetention_Day1Verified_QEC_CEC_Sys]
	@Date_From DATETIME,
	@Date_To DATETIME,
	@companyId int
AS
BEGIN

SET NOCOUNT ON;

DECLARE @StartDate datetime, @EndDate datetime

SET @StartDate = @Date_From;
SET @EndDate = @Date_To;

select SiteName As Site, Count(dbo.[Site].SiteId) as TotalCount,PlacementSourceId  from PlacementEntry with(nolock) inner join
dbo.[Site] ON PlacementEntry.SiteId = dbo.[Site].SiteId
where
PlacementEntry.CompanyId = @companyId
and 
isnull(PlacementEntry.IsDeleted,0) = 0
AND 
PlacementSourceId in (271, 314)
AND
(
(dateadd(day,0,datediff(day,0,FIAEntryDate)) >= dateadd(day,0,datediff(day,0, @StartDate)))
AND
(dateadd(day,0,datediff(day,0,FIAEntryDate)) <= dateadd(day,0,datediff(day,0, @EndDate)))
)
Group By SiteName , PlacementSourceId

END
