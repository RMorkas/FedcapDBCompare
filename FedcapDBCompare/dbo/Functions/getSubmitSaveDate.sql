


Create FUNCTION [dbo].[getSubmitSaveDate]
(
	@placemcentId int, @retentionId int , @retentionStatusId int
)
RETURNS DATETIME
AS
BEGIN
	-- Declare the return variable here
	DECLARE @result DATETIME
	SET @result = NULL
	
	SELECT @result = SaveAt FROM PlacementRetention 
	WHERE PlacementEntryID = @placemcentId 
	AND
	RetentionId = @retentionId 
	AND
	RetentionStatusId = @retentionStatusId
	
	
	-- Return the result of the function
	RETURN @result

END



