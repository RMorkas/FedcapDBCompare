
CREATE FUNCTION [dbo].[getSatisfactoryAttendCreditHours]
(
	@caseId int, @monthDate smalldatetime
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @result int, @isTeenparent int, @SatisfactoryHours int,  @CoreActualHours int, @CoreMin int, @startDate smalldatetime
	SET @result = 0 

	SELECT @isTeenparent = Count(clientCalc.CaseClientId) from dbo.ClientMonthlyCalc clientCalc With(nolock) JOIN 
	dbo.CaseClient CC With(nolock) ON clientCalc.CaseClientId = CC.CaseClientId
	WHERE CC.CaseId = @caseId AND clientCalc.MonthDate = @monthDate
	AND
	clientCalc.IsTeenParentWithNoHSGED = 1

	IF(@isTeenparent = 0)
		RETURN @result

	 SET @startDate = DATEADD(month, DATEDIFF(month, 0, @monthDate), 0)

	Select @SatisfactoryHours = SUM(ScheduledHours) FROM dbo.Schedule schedule With(nolock) JOIN 
	dbo.Company comp With(nolock) ON schedule.CompanyId = comp.CompanyId JOIN 
	CaseClient CC With(nolock) ON
	schedule.ClientId = cc.ClientId 
	where
	cc.CaseId = @caseId
	AND
	schedule.FederalActivityId = 12
	AND
	schedule.IsCoreActivity = 1
	AND
	schedule.IsDeleted = 0
	AND
	(
		(dateadd(day,0,datediff(day,0, schedule.Date))>= dateadd(day,0,datediff(day,0, @startDate))) 
		AND 
		(dateadd(day,0,datediff(day,0, schedule.Date))<= dateadd(day,0,datediff(day,0,@monthDate)))
	)
	AND
	schedule.AttendanceStatus in (1,2,3,5)
	

	Select @CoreActualHours = SUM(ISNULL(ClientCoreActualHours,0)), @CoreMin = CEILING(caseType.MinRequiredCoreAvgHours * 4.33)
	FROM ClientMonthlyCalc as caseCalc With(nolock) join 
		 [dbo].[CaseClient] CC With(nolock) ON caseCalc.CaseClientId = cc.CaseClientId JOIN 
		 [dbo].[Case] CaseTable With(nolock) ON	CaseTable.CaseId = CC.CaseId JOIN 
		 [dbo].[CaseType] caseType With(nolock) ON caseType.CaseTypeId = CaseTable.CaseTypeId JOIN 
		 dbo.Company company With(nolock) ON CaseTable.CompanyId = company.CompanyId
	Where CC.CaseId = @caseId AND caseCalc.MonthDate = @monthDate
	group by MinWage, MinRequiredCoreAvgHours

	
	IF(@SatisfactoryHours >= 87)
	BEGIN
		IF(@CoreMin > @CoreActualHours)
				SET @result = @CoreMin - ISNULL(@CoreActualHours,0)
	END
	RETURN @result
END