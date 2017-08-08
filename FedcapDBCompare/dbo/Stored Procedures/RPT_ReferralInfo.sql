
CREATE PROC [dbo].[RPT_ReferralInfo]
@companyId int,
@jobOrderNo int=null,
@DiscardRefDate bit =null,
@frmRefDate smalldatetime =null,
@toRefDate smalldatetime =null,
@DiscardInterDate bit =null,
@frmInterDate smalldatetime =null,
@toInterDate smalldatetime =null,
@list StringList  READONLY 
AS

Declare @count int
Set @count = (select COUNT(Item) from @list)

SELECT       dbo.CV_JobReferral.JobReferralId, dbo.Employer.FirstName AS EmployerName, RTRIM(dbo.VW_HRACases.CaseSurname) 
                         + ', ' + RTRIM(dbo.VW_HRACases.CaseFirstName) AS ClientName, dbo.VW_HRACases.SSN, dbo.VW_HRACases.CIN, 
                         dbo.VW_HRACases.HRACaseNumber + '-' + dbo.VW_HRACases.Suffix + '-' + dbo.VW_HRACases.LineNumber AS CaseNumber, 
                         CASE WHEN dbo.CV_JobReferral.ResumeId IS NULL THEN dbo.VW_HRACases.Email ELSE dbo.CV_BaseResume.Email END AS Email, 
                         CASE WHEN dbo.CV_JobReferral.ResumeId IS NULL THEN dbo.VW_HRACases.PhoneNumber ELSE dbo.CV_BaseResume.PhoneNumber END AS HomeNumber, 
                         CASE WHEN dbo.CV_JobReferral.ResumeId IS NULL THEN dbo.VW_HRACases.CellPhone ELSE dbo.CV_BaseResume.PhoneNumber END AS PhoneNumber, 
                         dbo.CV_JobOrder.JobOrderTrNo, dbo.CV_JobOrder.JobTitle, dbo.[User].FirstName + ' ' + dbo.[User].LastName AS JobLeadName, dbo.CV_JobOrder.JobOpeningDate, 
                         dbo.Enumes.Item AS EmploymentType, dbo.Sector.SetcorName, dbo.CV_JobReferral.InterviewDate, dbo.CV_JobReferral.InterviewTime, 
                         dbo.CV_JobReferral.CreatedBy, dbo.CV_JobReferral.CreatedAt, 
                         dbo.EmployerLocationContacts.FirstName + ' ' + dbo.EmployerLocationContacts.LastName AS InterviewerName, dbo.EmployerLocationContacts.HomePhone, 
                         dbo.EmployerLocationContacts.CellPhone, dbo.Site.SiteName,Feedback.HasFeedback, Enumes_1.Item As SecurityType,
						 dbo.CV_JobOrder.JobLeadUserId, dbo.CV_JobOrder.JobVisibilityId, dbo.CV_JobOrder.CompanyId,
						 ISNULL(dbo.VW_HRACases.IsPrivilegeRequired,0) AS IsPrivilegeRequired
FROM            dbo.VW_HRACases with(nolock) INNER JOIN
                         dbo.CV_JobReferral with(nolock) ON dbo.VW_HRACases.HRACaseID = dbo.CV_JobReferral.ClientId AND
						 dbo.VW_HRACases.CompanyId =  dbo.CV_JobReferral.CompanyId INNER JOIN
                         dbo.CV_JobOrder with(nolock) ON dbo.CV_JobReferral.JobOrderId = dbo.CV_JobOrder.JobOrderId INNER JOIN
                         dbo.Enumes ON dbo.CV_JobOrder.EmploymentTypeId = dbo.Enumes.EnumId INNER JOIN
                         dbo.Sector ON dbo.CV_JobOrder.SectorId = dbo.Sector.SectorId INNER JOIN
                         dbo.EmployerLocation with(nolock) ON dbo.CV_JobOrder.EmployerLocationId = dbo.EmployerLocation.EmpLocationId INNER JOIN
						 dbo.Employer with(nolock) ON dbo.Employer.EmployerId = dbo.EmployerLocation.EmployerId INNER JOIN
                         dbo.EmployerLocationContacts with(nolock) ON dbo.CV_JobReferral.EmpLocatContactId = dbo.EmployerLocationContacts.EmpLocatContactId LEFT OUTER JOIN
                         dbo.Site ON dbo.CV_JobReferral.SiteId = dbo.Site.SiteId LEFT OUTER JOIN
                         dbo.CV_BaseResume with(nolock) ON dbo.CV_JobReferral.ResumeId = dbo.CV_BaseResume.ResumeId LEFT OUTER JOIN
                         dbo.[User] ON dbo.CV_JobOrder.JobLeadUserId = dbo.[User].UserID LEFT OUTER JOIN
                         dbo.Enumes AS Enumes_1 ON dbo.CV_JobOrder.JobVisibilityId = Enumes_1.EnumId
						 Outer Apply
						 (
							select 
							Case when count(feedbackID) > 0 Then 'Feedback Provided'
							Else '' END as HasFeedback from dbo.CV_JobReferralFeedback as F
							where
							f.JobReferralId = dbo.CV_JobReferral.JobReferralId
						 ) as Feedback
WHERE
--dbo.CV_JobReferral.CompanyId = @companyId
--AND
(@jobOrderNo IS NULL OR dbo.CV_JobOrder.JobOrderTrNo = @jobOrderNo)
AND
(@DiscardRefDate IS NULL OR
(
(dateadd(day,0,datediff(day,0, dbo.CV_JobReferral.CreatedAt))>= dateadd(day,0,datediff(day,0, @frmRefDate))) 
AND 
(dateadd(day,0,datediff(day,0, dbo.CV_JobReferral.CreatedAt))<= dateadd(day,0,datediff(day,0,@toRefDate)))
))
AND
(@DiscardInterDate IS NULL OR
(
(dateadd(day,0,datediff(day,0, dbo.CV_JobReferral.InterviewDate))>= dateadd(day,0,datediff(day,0, @frmInterDate))) 
AND 
(dateadd(day,0,datediff(day,0, dbo.CV_JobReferral.InterviewDate))<= dateadd(day,0,datediff(day,0,@toInterDate)))
))
AND
(@count is null or dbo.CV_JobReferral.SiteId in (select item From @list))
 
--create table #test(
--item nvarchar(60)
--)
--insert #test values(4)
--select * from #test

--select * from Site where SiteId in  (select item from @list)