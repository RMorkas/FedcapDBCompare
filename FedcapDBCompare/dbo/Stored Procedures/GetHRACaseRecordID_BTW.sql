Create PROCEDURE dbo.[GetHRACaseRecordID_BTW]
@SSN varchar(20),
@CIN varchar(20)
AS
BEGIN
	SET NOCOUNT ON;

	select HRACaseID from allsector_BTW.fedcapbtw.dbo.hracases hra
	where (hra.ssn = @SSN and Len(LTrim(@SSN)) > 0) or (hra.cin = @CIN and Len(LTrim(@SSN)) < 1)
END

