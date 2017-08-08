



Create FUNCTION [dbo].[getTempComment]
(
	@placemcentId int, @retentionId int , @retentionStatusId int , @retentionStatus int
)
RETURNS nvarchar(max)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @result nvarchar(max)
	SET @result = ''
	
	--Submit to Bill 
		IF(@retentionStatus  = 2) 
	BEGIN

		SELECT top 1 @result = TempComment FROM PlacementRetention 
		WHERE PlacementEntryID = @placemcentId 
		AND
		RetentionId = @retentionId 
		AND
		RetentionStatusId = @retentionStatusId
		order by [Sequence] desc
	END
	
	IF(@result IS NULL)
		set @result = ''
	-- Return the result of the function
	RETURN @result

END




