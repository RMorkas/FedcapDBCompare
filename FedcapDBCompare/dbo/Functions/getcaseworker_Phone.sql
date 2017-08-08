
CREATE function [dbo].[getcaseworker_Phone](@clientid int, @companyid int) returns varchar(50)
as 
begin
	 declare @returnphone varchar(50)
	 set @returnphone =''

	 --get the user's phone first
	 select @returnphone =  isnull(dbo.[user].workphone,'')
	 from dbo.[Client] inner join dbo.[user]  on dbo.[client].AssignedStaffMemberId =dbo.[user].UserID  and dbo.[Client].clientid  = @clientid 
	 and dbo.[Client].CompanyId =@companyid

	 --if there is no user's phone get the site's phone
	 if isnull(@returnphone,'') ='' 
	 begin
		select @returnphone = isnull(dbo.[site].SitePhone,'')
		from dbo.[Client] 
		inner join [dbo].[OFI_Sites_Mapping]  m on m.ofi_siteid  = dbo.[client].ReferringOfficeNumber and 
		dbo.[Client].clientid  = @clientid 
		inner join  dbo.[site]  on m.siteid = dbo.[site].siteid 
		and dbo.[Client].CompanyId =8
	 end 

	 return @returnphone
end