

CREATE FUNCTION [dbo].[getRemainingDays] 
(
	@monthDate datetime =null
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @result int,  @startDate datetime =null, @endDate datetime =null

	
	If(@monthDate IS Not NULL AND (Month(@monthDate) > MONTH(getdate()) OR YEAR(@monthDate) > YEAR(getdate())))
	BEGIN
			SELECT @startDate = DATEADD(month, DATEDIFF(month, 0, @monthDate), 0),
				   @endDate = DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@monthDate)+1,0)) 
		--Return 0;
	END 
	ELSE If(@monthDate IS Not NULL AND (Month(@monthDate) < MONTH(getdate()) OR YEAR(@monthDate) < YEAR(getdate())))
	BEGIN
			
		Return 0;
	END 
	ELSE
	BEGIN
		select @startDate = DATEADD(day,1, GETDATE()),  
			   @endDate = DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1,0))
	END
	
	--SELECT @result = datediff(dd, @startDate, @endDate) + case when datepart(dw, @startDate) = 7 then 1 else 0 end - (datediff(wk, @startDate, @endDate) * 2) -
	--				 case when datepart(dw, @startDate) = 1 then 1 else 0 end +
	--				 case when datepart(dw, @endDate) = 1 then 1 else 0 end
	
	Declare @index int, @diffDays int, @date datetime
	--SET @diffDays = DATEDIFF(day,@startDate, @endDate)
	SET @index = 0;
	Set @result = 0;
	SET @date = @startDate
	While(DATEDIFF(day,@date, @endDate) >= 0)
	BEGIN
		DECLARE @isWeekEnd bit
		SET @isWeekEnd = case when datepart(dw, @date) = 7 then 1 --SAT
							  when datepart(dw, @date) = 1 then 1 -- SUN
							  ELSE 0
							  END
		IF(@isWeekEnd = 0)
		BEGIN
			SET @result = @result + 1
		END
		SET @date = DATEADD(day,1,@date)		
		SET @index = @index + 1;
	END

	
	--declare @HolCount int
	--SELECT @HolCount = COUNT(hol.HolidayId) from ScheduleHoliday hol 
	--Where 
	--(
	--	(dateadd(day,0,datediff(day,0,hol.HolidayDate))>= dateadd(day,0,datediff(day,0, @startDate))) 
	--	AND 
	--	(dateadd(day,0,datediff(day,0,hol.HolidayDate))<= dateadd(day,0,datediff(day,0, @endDate))) 
	--)

	
	--SET @result = @result - @HolCount
	IF(@result < 0)
		Set @result = 0
	return @result
END

