
CREATE FUNCTION [dbo].[LINC_GetOutreachIndex]
(
	@clientId int , @date smalldatetime
)
RETURNS INT
AS
BEGIN
	-- Declare the return variable here
	DECLARE @result INT
		
		Declare  @OutCome table
		(
			rowIndex int null,
			outreachDate smalldatetime null
		)

		INSERT into @Outcome 
		select ROW_NUMBER() Over(PARTITION  BY convert(varchar(7), OutreachDate, 126)  order by outreach.OutreachDate) AS rowIndex ,outreach.OutreachDate FROM LINC_OutreachAttempt as Outreach 
		Where
		ClientId = @clientId
		
		Select @result = RowIndex FROM @OutCome
		WHere
		(dateadd(day,0,datediff(day,0, outreachDate)) = dateadd(day,0,datediff(day,0,@date))) 

	RETURN @result

END
