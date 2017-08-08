
CREATE Proc [dbo].[getClientNotExempted]
@monthdate smalldatetime,
@CaseId int,
@CaseClientIdout int output
AS
Declare @clientID int = 0, @caseClientId int = 0

Select @caseClientId = cc.CaseClientId, @clientID = cc.ClientId from CaseClient cc WITH(NOlock)
Where 
cc.CaseId = @CaseId
AND
NOT Exists (Select  ClientId from dbo.OFI_ExemptionHistory exemptHistory With(nolock) 
WHERE
exemptHistory.ClientId = cc.ClientId
AND
((StartDate <= @monthdate) AND (EndDate is null OR EndDate >= @monthdate))
)

SET @CaseClientIdout = @caseClientId

select * from ClientMonthlyCalc cmc with(nolock)
where cmc.CaseClientId = @caseClientId
And
MonthDate = @monthdate

