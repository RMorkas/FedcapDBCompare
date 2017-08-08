




CREATE FUNCTION [dbo].[getTotalActualHours]
(
	@companyId int, @startDate smalldatetime, @endDate smalldatetime
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @result int
	Select @result = SUM(ScheduledHours) From dbo.Schedule S With(Nolock)
	Where
	s.CompanyId = @CompanyId
	AND
	(
	(dateadd(day,0,datediff(day,0, S.Date))>= dateadd(day,0,datediff(day,0, @StartDate))) 
	AND 
	(dateadd(day,0,datediff(day,0, S.Date))<= dateadd(day,0,datediff(day,0,@endDate)))
	)
	AND
	s.AttendanceStatus in (1,2,3,5) --Attend or excuse or late or holiday
	And
	isnull(s.IsDeleted,0) = 0

	RETURN ISNULL(@result,0)

END






