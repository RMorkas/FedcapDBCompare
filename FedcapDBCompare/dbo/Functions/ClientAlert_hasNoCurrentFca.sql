CREATE FUNCTION [dbo].[ClientAlert_hasNoCurrentFca]
(
	@clientId int
)
RETURNS bit
AS
BEGIN
	
	DECLARE @currentFcaCount INT
	DECLARE @hasNoCurrentFca BIT

	SELECT @currentFcaCount = COUNT(ClientFcaId) FROM dbo.ClientFca
	WHERE ClientId = @clientId AND 
		ActivityStartDate <= CONVERT(date, GETDATE()) AND 
		ActivityEndDate >= CONVERT(date, GETDATE()) AND
		(ReasonTypeId = 0 OR ReasonTypeId = 658 /* Client Signed Paper Copy */)

	IF @currentFcaCount = 0
		SET @hasNoCurrentFca = 1
	ELSE
		SET @hasNoCurrentFca = 0

	RETURN @hasNoCurrentFca
END