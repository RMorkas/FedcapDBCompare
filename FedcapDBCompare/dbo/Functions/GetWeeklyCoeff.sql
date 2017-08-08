
CREATE function [dbo].[GetWeeklyCoeff](@clientid int, @startdate datetime,@endDate datetime) returns Float
--function used in caluclating avarage hours per wekk
as 
begin
	Declare @calculationStartdate datetime
	Declare @calculationEnddate datetime
	Declare @OpenCase datetime
	Declare @CloseCase datetime
	Declare @NumberOfdaysinMonth float
	Declare @NumberOfWeeksinMonth Float

	--select @OpenCase=isnull(dbo.[case].StartDate,'01/01/1900'),@CloseCase=isnull(dbo.[case].EndDate,'01/01/2030')  from dbo.[case] inner join dbo.client on 
	--client.ActiveCaseId = dbo.[case].caseid and client.clientid = @clientid

	Set @calculationEnddate = @enddate
	SEt @calculationstartdate = @startdate

	--if datediff(d, @startdate,@OpenCase) > 0  set @calculationStartdate = @OpenCase
	--if datediff(d,@CloseCase,@enddate) > 0  set @calculationEnddate = @CloseCase
 
 	set  @NumberOfdaysinMonth = datediff(day, @calculationstartdate , @calculationEnddate) + 1 
	set  @NumberOfWeeksinMonth = @NumberOfdaysinMonth/7.0
	return @NumberOfWeeksinMonth

end