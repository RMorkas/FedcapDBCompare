
create function dbo.OFI_RemoveTempCaseNumber (@casenumber as varchar(20)) returns varchar(20)
as
begin
		declare @return as varchar(20)
		if len(@casenumber) < 9
			begin
				set @return =''
			end
		else
			begin
				set @return = @casenumber
			end


		return @return 
end
