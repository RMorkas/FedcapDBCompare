CREATE  FUNCTION [dbo].[getTotalPayment]
(
	@Clientid int, @StartDate smalldatetime , @endDate smalldatetime
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @result float
	SET @result = 0
	
	DECLARE @NumberOfdaysinMonth int
	DECLARE @NumberOfWeeksinMonth float
	DECLARE @Firstdayofmonth datetime
	DECLARE @jobStart datetime
	Declare @jobend datetime
	Declare @salaryperhour float
	declare @HoursPerWeek float
	Declare @calculationStartdate datetime
	Declare @calculationEnddate datetime


DECLARE db_cursor CURSOR FOR  
SELECT jobstart, enddate,salaryperhour,HoursPerWeek 
  FROM [dbo].[PlacementEntry] where hracaseid =@clientid  and isnull(IsDeleted,0) <> 1 and 
   datediff(d,jobstart,@endDate) >=0  and (enddate is null or datediff(d,@StartDate, enddate) >=0 )



OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @jobstart, @jobend,@salaryperhour,@HoursPerWeek 

WHILE @@FETCH_STATUS = 0   
BEGIN   

	Set @calculationEnddate = @enddate
	SEt @calculationstartdate = @startdate

	if datediff(d, @startdate,@jobStart) > 0  set @calculationStartdate = @jobStart
	if datediff(d, @jobend,@enddate) > 0  set @calculationEnddate = @jobend

	--set @Firstdayofmonth = cast(month(@calculationstartdate) as varchar(10)) + '/01/' + cast(year(@calculationstartdate) as varchar(10)) 

	--if datediff(d, @enddate,@jobend) > 0 
	--begin
	--		 set @calculationEnddate = @jobend
	--end
	--else 
	--begin
	--	 set @calculationEnddate = dateadd(month, 1, @Firstdayofmonth)
	--end

	set  @NumberOfdaysinMonth = datediff(day, @calculationstartdate , @calculationEnddate) + 1 
	set  @NumberOfWeeksinMonth = @NumberOfdaysinMonth/7
      
	  set @result = @result + isnull(@salaryperhour,0) * isnull(@HoursPerWeek,0) * @NumberOfWeeksinMonth
      FETCH NEXT FROM db_cursor INTO @jobstart, @jobend,@salaryperhour,@HoursPerWeek  
END   

CLOSE db_cursor   
DEALLOCATE db_cursor

return round(@result,0)
END
