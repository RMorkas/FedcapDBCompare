create  FUNCTION [dbo].[CrS_timekeeping_Status]
(
	-- Add the parameters for the function here
	@ScheduleID int
)
RETURNS @Tk_Status table
(
    Status varchar(500),
	DateTimeStamp DateTime
)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ReturnStatus varchar(500)  = '' 
	DECLARE @ReturnDatetimeStamp DateTime 

	-- Add the T-SQL statements to compute the return value here
	SELECT top 1 @ReturnStatus = status,@ReturnDatetimeStamp = activitydate from dbo.CrS_Timekeeping_Export_Audit where scheduleid = @ScheduleID and status ='updated' order by id  

	if @ReturnStatus <> 'updated'
		SELECT top 1 @ReturnStatus = status,@ReturnDatetimeStamp = activitydate from dbo.CrS_Timekeeping_Export_Audit where scheduleid = @ScheduleID and status <> 'updated' order by id  


	insert into @Tk_Status values (@returnStatus, @ReturnDatetimeStamp) 

	return

END