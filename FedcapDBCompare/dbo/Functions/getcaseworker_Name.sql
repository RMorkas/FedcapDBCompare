CREATE function dbo.[getcaseworker_Name](@clientid int, @companyid int) returns varchar(50)
as 
begin
	declare @returnname varchar(50)
	set @returnname =''
	select @returnname =  isnull(dbo.[user].FirstName,'') + ' ' +  isnull(dbo.[user].LastName,'')
	 from dbo.[Client] inner join dbo.[user]  on dbo.[client].AssignedStaffMemberId =dbo.[user].UserID  and dbo.[Client].clientid  = @clientid 
	 and dbo.[Client].CompanyId =@companyid

	 return @returnname
end
