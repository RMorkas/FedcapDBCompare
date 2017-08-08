




CREATE FUNCTION [dbo].[getIsTeenParentWithNoHSGEDCount]
(
	@companyId int, @startDate smalldatetime, @endDate smalldatetime
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @result int
	
	Select @result = COUNT(Client.ClientId) FROM
	(
		SELECT  dbo.Client.ClientId, Count(dbo.Client.ClientId) as MonthCount
		FROM            dbo.Client With(nolock) INNER JOIN
					dbo.CaseClient With(nolock) ON dbo.Client.ClientId = dbo.CaseClient.ClientId INNER JOIN
					dbo.ClientMonthlyCalc With(nolock) ON dbo.CaseClient.CaseClientId = dbo.ClientMonthlyCalc.CaseClientId
		WHERE dbo.ClientMonthlyCalc.IsTeenParentWithNoHSGED = 1
		AND
		dbo.Client.CompanyId = @CompanyId
		AND
		ISNULL(dbo.client.IsDeleted,0) = 0
		AND
		(
		(dateadd(day,0,datediff(day,0, dbo.ClientMonthlyCalc.MonthDate))>= dateadd(day,0,datediff(day,0, @StartDate))) 
		AND 
		(dateadd(day,0,datediff(day,0, dbo.ClientMonthlyCalc.MonthDate))<= dateadd(day,0,datediff(day,0,@EndDate)))
		)
		GROUP BY dbo.Client.ClientId
	) AS Client
	


	RETURN ISNULL(@result,0)

END