


CREATE FUNCTION [dbo].[LINC_isContactMadeWithClient]
(
	@clientId int , @date smalldatetime
)
RETURNS nvarchar(10)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @result nvarchar(10),  @count int
	SET @result = ''
	
	select @count = COUNT(*) from LINC_OutreachAttempt as Outreach join 
	dbo.Enumes as enum ON enum.EnumId = Outreach.OutreachOutComeId
	where
	(enum.Item = 'Spoke With Client' OR enum.Item = 'Received Letter' OR enum.Item = 'Received Email')
	AND
	ClientId = @clientId
	AND
	(
		(dateadd(day,0,datediff(day,0, OutreachDate))>= dateadd(day,0,datediff(day,0, DATEADD(month, DATEDIFF(month, 0, @date), 0)))) 
		AND 
		(dateadd(day,0,datediff(day,0, OutreachDate))<= dateadd(day,0,datediff(day,0,@date)))
	)
	IF(@count IS NULL OR @count = 0)
		set @result = 'No'
	ELSE
		set @result = 'Yes'
	-- Return the result of the function
	RETURN @result

END
