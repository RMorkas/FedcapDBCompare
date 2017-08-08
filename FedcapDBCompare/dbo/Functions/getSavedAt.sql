




CREATE FUNCTION [dbo].[getSavedAt]
(
	@placemcentId int, @retentionId int , @retentionStatusId int , @retentionStatus int
)
RETURNS smalldatetime
AS
BEGIN
	-- Declare the return variable here
	DECLARE @result smalldatetime
	--SET smalldatetime = null
	
	--Submit to Bill OR Billed OR Resubmit
	IF(@retentionStatus  = 2 OR @retentionStatus = 3 OR @retentionStatus = 4 OR @retentionStatus = 7) 
	BEGIN

		SELECT @result = SaveAt FROM PlacementRetention 
		WHERE PlacementEntryID = @placemcentId 
		AND
		RetentionId = @retentionId 
		AND
		RetentionStatusId = @retentionStatusId
	END
	
	--IF(@result IS NULL)
	--	set @result = ''
	-- Return the result of the function
	RETURN @result

END






