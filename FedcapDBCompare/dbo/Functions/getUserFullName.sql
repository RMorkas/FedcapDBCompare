CREATE FUNCTION dbo.getUserFullName
(
	@username varchar(50), @companyid int
)
RETURNS varchar(50)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ResultVar varchar(50)


	select @ResultVar = isnull(dbo.[user].firstname + ' ' +   dbo.[user].lastname ,'') 
	from dbo.[group] inner join dbo.[user] on dbo.[user].Username = @username and dbo.[user].GroupId = dbo.[group].GroupId and dbo.[group].CompanyId = @companyid

	-- Return the result of the function
	RETURN @ResultVar

END
