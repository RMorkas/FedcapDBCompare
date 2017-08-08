Create Proc [dbo].[ACC_UserPrivileges]
@companyId int =null
AS
SELECT       data.CompanyName,IsDefault,GroupName, DisablePrivilege ,data.UserID,data.UserName,data.Name, TableName,RecordKeyId
From
				(
		Select * From
					(
					SELECT        dbo.[User].UserID, dbo.[User].UserName, dbo.[User].FirstName + ' ' + dbo.[User].LastName as Name, dbo.[Group].GroupName, Isnull(dbo.[Group].IsDefault,0) as IsDefault, 
											 dbo.Module.ModuleDescription, dbo.Privilege.PrivilegeDescription, dbo.Company.CompanyName,NULL as DisablePrivilege
					FROM            dbo.GroupPrivilege INNER JOIN
											 dbo.Module ON dbo.GroupPrivilege.ModuleId = dbo.Module.ModuleId INNER JOIN
											 dbo.[Group] ON dbo.GroupPrivilege.GroupId = dbo.[Group].GroupId INNER JOIN
											 dbo.[User] ON dbo.[Group].GroupId = dbo.[User].GroupId INNER JOIN
											 dbo.Privilege ON dbo.GroupPrivilege.PrivilegeId = dbo.Privilege.PrivilegeId INNER JOIN
											 dbo.Company ON dbo.[Group].CompanyId = dbo.Company.CompanyId
					Where
					(Module.ModuleName = 'ucFinancialModuleTile')
					AND
					(@companyId IS NULL OR Company.CompanyId = @companyId)
					UNION ALL
					SELECT        dbo.[User].UserID, dbo.[User].UserName, dbo.[User].FirstName + ' ' + dbo.[User].LastName as Name, 'User Level' as GroupName, NULL as IsDefault, 
											 dbo.Module.ModuleDescription, dbo.Privilege.PrivilegeDescription, dbo.Company.CompanyName, ISNULL(dbo.UserPrivileges.DisablePrivilege, 0) AS DisablePrivilege
					FROM            dbo.UserPrivileges INNER JOIN
											 dbo.Module ON dbo.UserPrivileges.ModuleId = dbo.Module.ModuleId INNER JOIN
											 dbo.Privilege ON dbo.UserPrivileges.PrivilegeId = dbo.Privilege.PrivilegeId INNER JOIN
											 dbo.[User] ON dbo.UserPrivileges.UserId = dbo.[User].UserID INNER JOIN
											 dbo.Company INNER JOIN
											 dbo.[Group] ON dbo.Company.CompanyId = dbo.[Group].CompanyId ON dbo.[User].GroupId = dbo.[Group].GroupId

					Where
					(Module.ModuleName = 'ucFinancialModuleTile')
					AND
					(@companyId IS NULL OR Company.CompanyId = @companyId)
					) as users
					
) as data
Left outer join
(
SELECT * 
FROM            dbo.ACC_PrivilegeTable INNER JOIN
                         dbo.ACC_UserPrivilege ON dbo.ACC_PrivilegeTable.Id = dbo.ACC_UserPrivilege.PrivilegeTableId LEFT OUTER JOIN
                         dbo.ACC_Project ON dbo.ACC_UserPrivilege.RecordKeyId = dbo.ACC_Project.ProjectId LEFT OUTER JOIN
                         dbo.ACC_Division ON dbo.ACC_UserPrivilege.RecordKeyId = dbo.ACC_Division.DivisionId LEFT OUTER JOIN
                         dbo.ACC_Company ON dbo.ACC_UserPrivilege.RecordKeyId = dbo.ACC_Company.CompanyId LEFT OUTER JOIN
                         dbo.ACC_Location ON dbo.ACC_UserPrivilege.RecordKeyId = dbo.ACC_Location.LocationId LEFT OUTER JOIN
                         dbo.ACC_LineOfBusiness ON dbo.ACC_UserPrivilege.RecordKeyId = dbo.ACC_LineOfBusiness.LineOfBusinessId LEFT OUTER JOIN
                         dbo.ACC_Account ON dbo.ACC_UserPrivilege.RecordKeyId = dbo.ACC_Account.AccountId LEFT OUTER JOIN
                         dbo.ACC_Department ON dbo.ACC_UserPrivilege.RecordKeyId = dbo.ACC_Department.DepartmentId
)as users
ON  data.UserID = users.UserId