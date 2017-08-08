


CREATE Function [dbo].[IsClientExempted]
(
	@monthdate smalldatetime,
	@CaseId int
)
RETURNS bit
AS
BEGIN
DECLARE @count int = 0, @isClientExempted bit = 0

Select @count = count(exemptHistory.ClientId) from dbo.OFI_ExemptionHistory exemptHistory With(nolock) join CaseClient cc WITH(NOlock)
on exemptHistory.ClientId = cc.ClientId
WHERE
cc.CaseId = @CaseId
AND
((StartDate <= @monthdate) AND (EndDate is null OR EndDate >= @monthdate))

IF(@count > 0)
	SET @isClientExempted = 1; --exempted
ELSE
	SET @isClientExempted = 0;

Return @isClientExempted

END