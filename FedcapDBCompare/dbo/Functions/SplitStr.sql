


CREATE function [dbo].[SplitStr]
(
    @String nvarchar(max),
	@Delimiter varchar(5)
)
returns @SplittedValues table
(
    Id int primary key IDENTITY ,
	value varchar(50)
)
as
begin
    declare @SplitLength int

    while len(@String) > 0
    begin 
        select @SplitLength = (case charindex(@Delimiter,@String) when 0 then
            len(@String) else charindex(@Delimiter,@String) -1 end)
 
        insert into @SplittedValues (value)
        select substring(@String,1,@SplitLength) 
    
        select @String = (case (len(@String) - @SplitLength) when 0 then  ''
            else right(@String, len(@String) - @SplitLength - 1) end)
    end 
return  
end