





CREATE FUNCTION [dbo].[getEngagmentStatus]
(
	@caseId int, @monthDate smalldatetime , @caseTypeId int = null
)
RETURNS varchar(80)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @result varchar(80), @MaxHourPerDay int
	--SET smalldatetime = null
	IF(@caseTypeId <> 3 AND @caseTypeId <> 4)
		SET @MaxHourPerDay = 8;
	ELSE IF(@caseTypeId = 3 OR @caseTypeId = 4)
		SET @MaxHourPerDay = 16; --TP W/CCS
	
	select  @result =
			Case

				WHEN caseCalc.CaseCountableHours >= caseCalc.CaseRequiredHours 
					THEN 'Met Standard'
				WHEN (caseCalc.CaseRequiredRemainingHours - caseCalc.CaseScheduledRemainingHours) > 0 AND 
					 caseCalc.CaseRequiredRemainingHours > ((caseCalc.RemainingDaysOfTheMonth + 1) * @MaxHourPerDay)
					THEN 'Will Not Meet Standard - Requires Scheduled Hours'
				WHEN (caseCalc.CaseRequiredRemainingHours - caseCalc.CaseScheduledRemainingHours) <= 0 AND
				     (caseCalc.CaseScheduledRemainingHours >= caseCalc.CaseRequiredRemainingHours) AND
					 caseCalc.CaseRequiredRemainingHours > ((caseCalc.RemainingDaysOfTheMonth + 1) * @MaxHourPerDay)
					THEN 'Will Not Meet Standard - Scheduled for Remaining Hours'
			    WHEN (caseCalc.CaseRequiredRemainingHours - caseCalc.CaseScheduledRemainingHours) <= 0 AND 
				     (caseCalc.CaseScheduledRemainingHours >= caseCalc.CaseRequiredRemainingHours)
					Then 'Scheduled to Meet Standard'
				WHEN (caseCalc.CaseRequiredRemainingHours - caseCalc.CaseScheduledRemainingHours) > 0 AND 
					 (caseCalc.CaseRequiredRemainingHours - caseCalc.CaseScheduledRemainingHours) <= ((caseCalc.RemainingDaysOfTheMonth + 1) * @MaxHourPerDay)
					THEN 'Requires Scheduled Hours'
				ELSE 
					'Unknown'
				END
	FROM VW_CaseMonthlyCalc as caseCalc WITH(Nolock)
	Where caseCalc.CaseId = @caseId AND caseCalc.MonthDate = @monthDate


	RETURN @result

END
