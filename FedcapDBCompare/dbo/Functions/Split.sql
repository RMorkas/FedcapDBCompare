
CREATE Function [dbo].[Split]
(
    @String varchar(max),
	@Delimiter varchar(5),
	@index int
)
returns varchar(60)
AS
BEGIN
declare @SplitLength int , @Value varchar(100)
 while @index > 0
 BEGIN
	select @SplitLength = (case charindex(@Delimiter,@String) when 0 then
    len(@String) else charindex(@Delimiter,@String) -1 end)

	set @index = @index - 1
	IF (@index <> 0)
	BEGIN
	 select @String = (case (len(@String) - @SplitLength) when 0 then  ''
            else right(@String, len(@String) - @SplitLength - 1) end)
			END
 END

 SET @Value = SUBSTRING(@string,1,@SplitLength)

 Return @value
END