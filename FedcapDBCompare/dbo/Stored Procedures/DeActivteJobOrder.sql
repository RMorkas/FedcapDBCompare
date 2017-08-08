CREATE proc DeActivteJobOrder
@CompanyId int
as
Update dbo.CV_JobOrder set IsActive = 0
--Select * from CV_JobOrder
where
CompanyId = @CompanyId
AND
Isnull(IsDeleted,0) = 0
AND
Isnull(IsActive,0) = 1
AND
(JobClosingDate IS NOT NULL AND JobClosingDate <= GETDATE())