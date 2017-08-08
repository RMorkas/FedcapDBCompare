CREATE  function dbo.getExtenstionabrreviation (@extenstionenum int) returns varchar(100)
as
begin
declare @Extenstionabrreviation varchar(100)
select @Extenstionabrreviation = 
 case @extenstionenum when 638 then 'DIS' 
  when 639 then 'PRG' 
  when 640 then 'CMD' 
  when 641 then 'LOJ' 
  when 642 then 'EMG' 
 when 643 then 'EDU' 
 when 644 then 'WRK' 
   else ''
 end 


 return @Extenstionabrreviation
end