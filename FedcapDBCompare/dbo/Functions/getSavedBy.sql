



CREATE FUNCTION [dbo].[getSavedBy]
(
	@placemcentId int, @retentionId int , @retentionStatusId int , @retentionStatus int
)
RETURNS nvarchar(max)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @result nvarchar(max)
	SET @result = ''
	
	--Submit to Bill OR Billed OR Resubmit
		IF(@retentionStatus  = 2 OR @retentionStatus = 3 OR @retentionStatus = 4 OR @retentionStatus = 7) 
	BEGIN

		SELECT @result = SaveBy FROM PlacementRetention 
		WHERE PlacementEntryID = @placemcentId 
		AND
		RetentionId = @retentionId 
		AND
		RetentionStatusId = @retentionStatusId
	END
	
	IF(@result IS NULL)
		set @result = ''
	-- Return the result of the function
	RETURN @result

END





