

CREATE PROCEDURE [dbo].[GetPermittedActivityActions] 
@companyId INT,
@caseNumber varchar(50) =NULL,
@ssn varchar(10) =NULL,
@frmDate smalldatetime =NULL,
@toDate smalldatetime =NULL,
@workflowActionIds varchar(50) =NULL,
@caseManagerId	int =NULL,
@siteId	int =NULL,
@caseStatus varchar(10) =NULL
AS
BEGIN	
	SET NOCOUNT ON;

	-- Get all workflow actions where the client completed at least one of the required prerequistes specified in
	-- WorkflowRules
    SELECT
		client.CaseFirstName , client.CaseLastName, client.ClientNo, Client.Suffix , client.LineNumber,
		client.SSN, 
	    a.Code,
	    a.Description,
		MAX(ca.CreatedAt) as CreatedAt,
		null as UserId,
		ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') as CaseWorker,
		a.WorkflowActionId,
		a.WorkflowBranchId,
		ISNULL(s.SiteName, '') as SiteName,
		client.IsPrivilegeRequired,
		MAX(cb.CreatedAt) as BranchCreatedAt,
		case_def.InternalDescription as CaseStatus, client.ClientId,
		ISNULL(client.StreetAddress, '') + ' ' + ISNULL(client.ApartmentNumber, '') + ', ' + ISNULL(client.City, '') + ', ' 
			+  ISNULL(client.State, '') + ' ' + ISNULL(client.ZipCode, '') as [Address]
    FROM   dbo.WorkflowClientAction ca WITH (NOLOCK)
       INNER JOIN dbo.WorkflowRule wr WITH (NOLOCK) ON ca.WorkflowActionId = wr.WorkflowPrerequisiteActionId 
	   INNER JOIN dbo.VW_HRACases cases WITH (NOLOCK) ON cases.HRACaseID = ca.ClientId AND cases.CompanyId = @companyId
	   INNER JOIN dbo.Client client WITH (NOLOCK) ON client.ClientId = ca.ClientId AND client.CompanyId = @companyId
	   INNER JOIN dbo.WorkflowAction a WITH (NOLOCK) on a.WorkflowActionId = wr.WorkflowActionId
	   LEFT JOIN dbo.WorkflowClientBranch cb WITH (NOLOCK) on cb.WorkflowBranchId = wr.WorkflowBranchId AND cb.ClientId = ca.ClientId AND cb.IsActive = 1
	   LEFT JOIN dbo.WorkflowClientCondition cc WITH (NOLOCK) ON cc.ClientId = ca.ClientId AND cc.WorkflowConditionId = wr.WorkflowConditionId
	   LEFT JOIN dbo.[User] u WITH (NOLOCK) ON u.UserID = client.AssignedStaffMemberId
	   LEFT JOIN dbo.[Site] s WITH (NOLOCK) ON s.SiteId = client.SiteId
	   LEFT JOIN dbo.[Case] c WITH (NOLOCK) ON c.CaseId = client.ActiveCaseId
	   LEFT JOIN dbo.[CaseStatus_Def] case_def WITH (NOLOCK) ON case_def.InternalStatusCode = c.StatusId AND case_def.CompanyId = @companyId
	   --INNER JOIN dbo.[Group] g on u.GroupId = g.GroupId AND g.CompanyId = @companyId
    WHERE wr.CompanyId = @companyId AND ca.IsActive = 1 AND ca.IsDeleted = 0 AND
	    (wr.DaysBeforePending IS NULL OR DATEDIFF(d, ca.CreatedAt, GETDATE()) >= wr.DaysBeforePending) AND
		(wr.WorkflowConditionId IS NULL OR cc.WorkflowConditionId IS NOT NULL) AND
		(wr.WorkflowBranchId IS NULL OR cb.WorkflowBranchId IS NOT NULL) AND 
		wr.WorkflowActionId NOT IN -- filter out actions the client already completed
		(
		    	SELECT        dbo.WorkflowClientAction.WorkflowActionId --, dbo.WorkflowRule.WorkflowBranchId--, dbo.WorkflowClientAction.ClientId
				FROM            dbo.WorkflowClientAction  WITH (NOLOCK)
				WHERE WorkflowClientAction.ClientId = client.ClientId AND IsActive = 1 AND IsDeleted = 0

		) AND
		wr.WorkflowActionId NOT IN -- Filter out actions that the client did not complete at least one of the prerequistes
		(
		    SELECT
			    a.WorkflowActionId			
		    FROM dbo.WorkflowRule w WITH (NOLOCK)
		    INNER JOIN dbo.WorkflowAction a WITH (NOLOCK) ON a.WorkflowActionId = w.WorkflowActionId		
		    LEFT JOIN dbo.WorkflowClientAction ca WITH (NOLOCK) ON ca.WorkflowActionId = w.WorkflowPrerequisiteActionId AND ca.ClientId = client.ClientId AND ca.IsActive = 1 AND ca.IsDeleted = 0
			LEFT JOIN dbo.WorkflowClientBranch cb WITH (NOLOCK) ON cb.WorkflowBranchId = w.WorkflowBranchId AND cb.ClientId = client.ClientId AND cb.IsActive	= 1	    
		    WHERE w.CompanyId = @companyId AND
			    (w.DaysBeforePending IS NULL OR DATEDIFF(d, ca.CreatedAt, GETDATE()) >= w.DaysBeforePending) AND
				(w.WorkflowConditionId IS NULL OR cc.WorkflowConditionId IS NOT NULL) AND
				(w.WorkflowBranchId IS NULL OR cb.WorkflowBranchId IS NOT NULL) AND 
				ca.WorkflowActionId IS NULL
		) AND
		(@caseNumber IS NULL OR cases.HRACaseNumber = @caseNumber)		
		AND
		(@ssn IS NULL OR client.SSN like '%' + @ssn + '%')
		AND
		(LEN(@workflowActionIds) = 0 OR a.WorkflowActionId IN (SELECT value FROM dbo.SplitStr(@workflowActionIds, ',')))
		AND
		(@caseManagerId IS NULL OR @caseManagerId = 0 OR client.AssignedStaffMemberId = @caseManagerId)
		AND
		(@siteId IS NULL OR @siteId = 0 OR client.SiteId = @siteId)
		AND
		(@caseStatus IS NULL OR @caseStatus = '' OR CHARINDEX(UPPER(c.StatusId), UPPER(@caseStatus)) > 0)
	GROUP BY client.CaseFirstName , client.CaseLastName, client.ClientNo, Client.Suffix , client.LineNumber,
	client.SSN, a.Code, a.Description, u.FirstName, u.LastName, client.StreetAddress, client.ApartmentNumber, client.City, client.State, client.ZipCode,
		a.WorkflowActionId, a.WorkflowBranchId, s.SiteName, client.IsPrivilegeRequired, case_def.InternalDescription, client.ClientId

END