

CREATE Function [dbo].[HasMedicalDocumentation]
(
	@clientId int
)
RETURNS bit
AS
BEGIN
DECLARE @count int = 0, @HasMedicalDocumentation bit = 0

/* Does the client have the following:
	1. A completed intake
	2. The most recent signed intake has HasMedDoc = 1 (specifically indicated that medical documation has been provided)
	3. If the version of that intake is 30 or higher then there must be an attachment (ClientIntakeAttachment)
	4. If the version of the intake is less than 30 then the client must have Support Medical Documentation (DocumentTypeId = 249)
*/
select @count = count(intake.ClientIntakeId) from dbo.ClientIntake intake
left join dbo.ClientIntakeAttachment attachment on attachment.ClientIntakeId = intake.ClientIntakeId
left join dbo.SCAN_Images [image] on [image].HRACaseId = intake.ClientId and [image].DocumentTypeId = 249 and isnull([image].IsDeleted, 0) = 0
where intake.HasMedDoc = 1 and 
	((attachment.ClientIntakeAttachmentId is not null and intake.FormVersionId >= 30) or ([image].ID is not null and intake.FormVersionId < 30)) and 
	intake.ClientIntakeId in 
		(select max(ClientIntakeId) as ClientIntakeId from dbo.ClientIntake intake
		 where intake.IsDeleted = 0 and intake.ClientId = @clientId and 
			((intake.ReasonTypeId = 0 and intake.Signature != '' and intake.Signature != '300D0A300D0A') or intake.ReasonTypeId = 658 ))

IF(@count > 0)
	SET @HasMedicalDocumentation = 1;
ELSE
	SET @HasMedicalDocumentation = 0;

Return @HasMedicalDocumentation

END