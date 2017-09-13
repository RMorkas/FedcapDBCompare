CREATE PROCEDURE [dbo].[ProcessSanctionFollowupWorkflow] 
@clientId INT
AS
BEGIN		

	DECLARE @sanctionDecision INT
	DECLARE @followUpPhoneId INT
	DECLARE @followUpLetterId INT
	DECLARE @companyId INT
	DECLARE @daysBeforePending INT
	DECLARE @sanctionEffectiveDate DATETIME
	DECLARE @phoneContactId INT
	DECLARE @phoneContactDate DATETIME
	DECLARE @letterContactId INT
	DECLARE @letterContactDate DATETIME

	SET NOCOUNT ON

	SELECT @sanctionDecision = WorkflowActionId FROM dbo.WorkflowAction WHERE Code = 'SanctionDecision'
	SELECT @followUpPhoneId = WorkflowActionId FROM dbo.WorkflowAction WHERE Code = 'FollowupPhone'
	SELECT @followUpLetterId = WorkflowActionId FROM dbo.WorkflowAction WHERE Code = 'FollowupLetter'
	
	SELECT @companyId = CompanyId, @sanctionEffectiveDate = SanctionEffectiveDate FROM dbo.Client WHERE ClientId = @clientId

	/* Get the number of days after a Sanction decision that a follow up phone call is requested */
	SELECT @daysBeforePending = ISNULL(DaysBeforePending, 0)
	FROM dbo.WorkflowRule
	WHERE CompanyId = @companyId AND WorkflowActionId = @followUpPhoneId AND WorkflowPrerequisiteActionId = @sanctionDecision

	/* Find Non-compliance or Follow up phone contact records where effective date is @daysBeforePending after sannction effective date */
	SELECT TOP 1 @phoneContactId = ClientContactId, @phoneContactDate = ContactDate 
	FROM dbo.ClientContact 
	WHERE ClientId = @clientId AND ContactTypeId in (520, 534) AND ContactMethodId = 522 AND IsDeleted = 0 AND
				DATEDIFF(d, @sanctionEffectiveDate, [ContactDate]) >= @daysBeforePending
	ORDER BY ContactDate DESC

	EXEC dbo.ResetClientWorkflowState @clientId, @followUpPhoneId, 14, @phoneContactId,  @phoneContactDate, 'ProcessSanctionFollowupWorkflow'

	/* Get the number of days after a follow up phone call that a follow up letter is requested */
	SELECT @daysBeforePending = ISNULL(DaysBeforePending, 0)
	FROM dbo.WorkflowRule
	WHERE CompanyId = @companyId AND WorkflowActionId = @followUpLetterId AND WorkflowPrerequisiteActionId = @followUpPhoneId

	SET @phoneContactDate = NULL
	SELECT @phoneContactDate = CreatedAt FROM dbo.WorkflowClientAction
	WHERE ClientId = @clientId AND WorkflowActionId = @followUpPhoneId AND IsActive = 1

	IF @phoneContactDate IS NOT NULL
		/* Find Non-compliance or Follow up mail contact records where effective date is @daysBeforePending after the follow up phone contact date */
		SELECT TOP 1 @letterContactId = ClientContactId, @letterContactDate = ContactDate
		FROM dbo.ClientContact 
		WHERE ClientId = @clientId AND ContactTypeId in (520, 534) AND ContactMethodId = 525 AND IsDeleted = 0 AND
					DATEDIFF(d, @phoneContactDate, [ContactDate]) >= @daysBeforePending
		ORDER BY ContactDate DESC

	EXEC dbo.ResetClientWorkflowState @clientId, @followUpLetterId, 14, @letterContactId, @letterContactDate, 'ProcessSanctionFollowupWorkflow'	

END