



CREATE FUNCTION [dbo].[ClientAlert_isMissingAssignedStaffMember]
(
	@clientId int
)
RETURNS bit
AS
BEGIN
	
	DECLARE @AssignedStaffMemberId INT
	DECLARE @hasAssignedStaffMember BIT

	SELECT @AssignedStaffMemberId = AssignedStaffMemberId FROM dbo.Client WHERE ClientID = @clientId

	IF @AssignedStaffMemberId IS NULL OR @AssignedStaffMemberId = 0
		SET @hasAssignedStaffMember = 1
	ELSE
		SET @hasAssignedStaffMember = 0

	RETURN @hasAssignedStaffMember
END