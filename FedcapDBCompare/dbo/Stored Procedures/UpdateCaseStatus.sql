CREATE Proc [dbo].[UpdateCaseStatus]
as

update [Case]

set StatusId = updated.[Status], StartDate = updated.Status_StartDate, EndDate = updated.Status_EndDate

from
(
SELECT *
  FROM [CaseStatusHistory]
  where id in
  (
    select max(id) from [CaseStatusHistory]
    where Status_StartDate < getdate() 
	group by CaseId
  )
) updated

where [Case].CaseId = updated.Caseid
