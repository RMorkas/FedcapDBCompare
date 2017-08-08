CREATE FUNCTION [dbo].[LINC_checkOutreachRequirement]
(
	@clientId int , @date smalldatetime
)
RETURNS nvarchar(15)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @result nvarchar(15),  @count int
	SET @result = ''
	
	Declare  @OutCome table
	(
		Id int null,
		Item varchar(100) null
	)

		INSERT into @Outcome select Outreach.OutreachTrackId, enum.Item from LINC_OutreachAttempt as Outreach join 
		dbo.Enumes as enum ON enum.EnumId = Outreach.OutreachOutComeId
		Where
		ClientId = @clientId
		AND
		(
			(dateadd(day,0,datediff(day,0, OutreachDate))>= dateadd(day,0,datediff(day,0, DATEADD(month, DATEDIFF(month, 0, @date), 0)))) 
			AND 
			(dateadd(day,0,datediff(day,0, OutreachDate))<= dateadd(day,0,datediff(day,0,@date)))
		)
	
	Select @count = COUNT(*) from @OutCome As Outcome
	where
	(Outcome.Item = 'Spoke With Client' OR Outcome.Item = 'Received Letter' OR Outcome.Item = 'Received Email')
	
	declare @total int
	Select @total = count(*) from @OutCome

	IF(@count IS NULL OR @count = 0)
		BEGIN
			IF (@total > 1)
				Set @result = 'Yes'
			ELSE
				Set @result = 'No'
		END		
	ELSE
		set @result = 'Yes'

	RETURN @result

END
