create  FUNCTION CrS_timekeeping_ActivityStatus
(
	-- Add the parameters for the function here
	@ScheduleID int
)
RETURNS varchar(20)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ReturnStatus varchar(20)  = '' 

	-- Add the T-SQL statements to compute the return value here
	SELECT top 1 @ReturnStatus = status from dbo.CrS_Timekeeping_Export_Audit where scheduleid = @ScheduleID and status ='updated'

	if @ReturnStatus <> 'updated'
		SELECT top 1 @ReturnStatus = status from dbo.CrS_Timekeeping_Export_Audit where scheduleid = @ScheduleID and status <> 'updated' order by id desc 
		return @ReturnStatus

END
