




CREATE VIEW [dbo].[VW_Cases]
AS
SELECT   distinct    dbo.[Case].CaseId, dbo.[Case].CompanyId, dbo.[Case].IsActive, dbo.[Case].CaseNo, dbo.[Case].CaseTypeId, dbo.[Case].SiteId, dbo.[Case].StartDate, 
                         dbo.[Case].EndDate, dbo.[Case].FoodStampSubsidy, dbo.[Case].TANSubsidy, dbo.[Case].ChildCareSubsidy, dbo.[Case].IsTwoParentCase, 
                         dbo.[Case].IsChildUnderSix, dbo.[Case].CreatedBy, dbo.[Case].CreatedAt, dbo.[Case].StatusId, dbo.[Case].FoodStampFamilySize, dbo.[Case].TANFFamilySize, 
                         dbo.[Case].TANFExtensionHistory, dbo.[Case].UpdatedBy, dbo.[Case].UpdatedAt, ISNULL(clientPrivielege.IsPrivilegeRequired,0)  as IsPrivilegeRequired,
						 dbo.[Case].Suffix, dbo.[Case].LineNumber, StaffName
FROM            dbo.[Case] With(nolock) INNER JOIN
                         dbo.CaseClient With(nolock) ON dbo.[Case].CaseId = dbo.CaseClient.CaseId
						 Outer Apply
						 (
							SELECT Top 1 ISNULL(c.IsPrivilegeRequired,0) AS IsPrivilegeRequired, staff.FirstName + ' ' + staff.LastName as StaffName
							FROM dbo.Client c with(nolock) INNER JOIN
							dbo.CaseClient cc with(nolock) ON c.ClientId = cc.ClientId left outer join
							dbo.[User] staff with(nolock) on c.AssignedStaffMemberId = staff.UserID
							WHERE 
							cc.CaseId = dbo.[Case].CaseId
							AND
							c.CompanyId = CompanyId
						 ) AS clientPrivielege