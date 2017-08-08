CREATE function [dbo].[Crs_TImekeeping_CalculateHoursWithLunch] (@Scheduledhours integer) returns integer
as 
begin

 declare @returnvalue integer

 if @Scheduledhours >= 5 
 begin
	set @returnvalue =@Scheduledhours - 1 
 end
else
begin
	set @returnvalue =@Scheduledhours

end

if @returnvalue > 7 
begin
	set @returnvalue = 7 
end

return @returnvalue

end