




CREATE FUNCTION [dbo].[getFLSACreditHours]
(
	@caseId int, @monthDate smalldatetime
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @result int, @FLSAActualHours int,  @FLSAMax int, @minAvgHour int, @CoreActualHours int, @CoreMin int
	SET @result = 0

	Select 
	      @FLSAActualHours = SUM(ISNULL(ClientFLSAActualHours,0)), @FLSAMax = CAST((ISNULL(caseCalc.FoodStampSubsidy, 0) + ISNULL(caseCalc.TANSubsidy, 0)) / ISNULL(MinWage, 1) AS Numeric(18, 0)),
		  @CoreActualHours = SUM(ISNULL(ClientCoreActualHours,0)), @CoreMin = CEILING(caseType.MinRequiredCoreAvgHours * 4.33)
	FROM ClientMonthlyCalc as caseCalc WITH(Nolock) join [dbo].[CaseClient] CC WITH(Nolock) ON
		caseCalc.CaseClientId = cc.CaseClientId JOIN [dbo].[Case] CaseTable WITH(Nolock) ON
		CaseTable.CaseId = CC.CaseId JOIN [dbo].[CaseType] caseType WITH(Nolock) ON
		caseType.CaseTypeId = CaseTable.CaseTypeId JOIN dbo.Company company WITH(Nolock) ON
		CaseTable.CompanyId = company.CompanyId
	Where 
	CC.CaseId = @caseId 
	AND 
	caseCalc.MonthDate = @monthDate
	group by caseCalc.FoodStampSubsidy, caseCalc.TANSubsidy,MinWage, MinRequiredCoreAvgHours

	SET @minAvgHour = 87
	IF(@FLSAActualHours >= @FLSAMax)
	BEGIN
		IF(@FLSAMax > 0 AND @FLSAMax < 87)
		BEGIN
			IF(@CoreMin > @CoreActualHours)
				SET @result = @CoreMin - ISNULL(@CoreActualHours,0)
		END
	END
	RETURN @result
END