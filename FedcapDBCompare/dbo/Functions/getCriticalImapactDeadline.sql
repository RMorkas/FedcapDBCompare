
CREATE FUNCTION [dbo].[getCriticalImapactDeadline] 
(
	@monthDate smalldatetime , @caseRequiredHours float, @caseTypeId  int =null
)
RETURNS smalldatetime
AS
BEGIN
	-- Declare the return variable here
	DECLARE @result smalldatetime,  @requireDays int =null, @startDate smalldatetime =null, @endDate smalldatetime =null, @workingDays int
	
	IF(@caseTypeId <> 3 AND @caseTypeId <> 4)
		SET @requireDays = CEILING(@caseRequiredHours / 7)
	ELSE IF(@caseTypeId = 3 OR @caseTypeId = 4)
		SET @requireDays = CEILING(@caseRequiredHours / 14) --TP W/CCS

	IF(@requireDays = 0)
		Return null;


	If(@monthDate IS Not NULL AND (Month(@monthDate) <> MONTH(getdate()) OR YEAR(@monthDate) <> YEAR(getdate())))
	BEGIN
			SELECT  @endDate = DATEADD(day, DATEDIFF(day, 0, DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@monthDate)+1,0))), 0)  
			Declare @x int
			select @x =	CASE ((@@DATEFIRST + DATEPART(weekday, @endDate) + (0 % 5)) % 7)
															 WHEN 0 THEN -1 -- the end date on saturday
															 WHEN 1 THEN -2 -- the end date on sunday
															 ELSE 0 END
			SET @endDate = DATEADD(day, @x , @endDate) 
	END 
	ELSE
	BEGIN
		select @endDate = DATEADD(day, DATEDIFF(day, 0, DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1,0))), 0)
		--select @startDate = DATEADD(day, @requireDays * -1,@endDate)
	END

	Set @result = @endDate
	While(@requireDays > 0)
	BEGIN
		Set @result = DATEADD(DAY, -1, @result)
		Declare @y int
		select @y =	CASE ((@@DATEFIRST + DATEPART(weekday, @result) + (0 % 5)) % 7)
														WHEN 0 THEN 1 -- the cirtical deadline on saturday
														WHEN 1 THEN 2 -- the cirtical deadline on sunday
														ELSE 0 END
		if(@y > 0)
		BEGIN
			Set @result = DATEADD(DAY, (@y * -1), @result)
			Set @requireDays = (@requireDays - 1)
		END
		ELSE If(@y = 0)
			Set @requireDays = (@requireDays - 1)
	END

	declare @HolCount int
	SET @HolCount = 0;
	--SELECT @HolCount = COUNT(hol.HolidayId) from ScheduleHoliday hol 
	--Where 
	--(
	--	(dateadd(day,0,datediff(day,0,hol.HolidayDate))>= dateadd(day,0,datediff(day,0, @result))) 
	--	AND 
	--	(dateadd(day,0,datediff(day,0,hol.HolidayDate))<= dateadd(day,0,datediff(day,0, @endDate))) 
	--)

	While(@HolCount >= 1)
	BEGIN
		Set @result = DATEADD(DAY, -1, @result)
		
		select @y =	CASE ((@@DATEFIRST + DATEPART(weekday, @result) + (0 % 5)) % 7)
														WHEN 0 THEN 1 -- the cirtical deadline on saturday
														WHEN 1 THEN 2 -- the cirtical deadline on sunday
														ELSE 0 END
		if(@y > 0)
		BEGIN
			Set @result = DATEADD(DAY, (@y * -1), @result)
			Set @HolCount = (@HolCount - 1)
		END
		ELSE If(@y = 0)
			Set @HolCount = (@HolCount - 1)
	END

	return @result
END