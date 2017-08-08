





CREATE FUNCTION [dbo].[getFLSACreditHoursByClient]
(
	@caseClientId int, @monthDate smalldatetime, @MinWage  Numeric(18, 0), @MinRequiredCoreAvgHours  int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @result int, @FLSAActualHours int,  @FLSAMax int, @minAvgHour int, @CoreActualHours int, @CoreMin int
	SET @result = 0

	Select 
	      @FLSAActualHours = ISNULL(ClientFLSAActualHours,0), @FLSAMax = CAST((ISNULL(caseCalc.FoodStampSubsidy, 0) + ISNULL(caseCalc.TANSubsidy, 0)) / ISNULL(@MinWage, 1) AS Numeric(18, 0)),
		  @CoreActualHours = ISNULL(ClientCoreActualHours,0), @CoreMin = CEILING(@MinRequiredCoreAvgHours * 4.33)
	FROM ClientMonthlyCalc as caseCalc WITH(Nolock) 
	Where 
	caseCalc.CaseClientId = @caseClientId 
	AND 
	caseCalc.MonthDate = @monthDate
	--group by caseCalc.FoodStampSubsidy, caseCalc.TANSubsidy,MinWage, MinRequiredCoreAvgHours

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