
CREATE view [dbo].[CrS_vi_TimeKeeping_ExportData_Expanded]
as
select  distinct top 100 percent b.*, i.FirstName,
 i.LastName,
 i.HraCaseNumber,
 i.LineNumber,
 i.Suffix,
 i.HRAIndividualStatus,
 i.ProgramStartDate,
 i.TerminationDate,
 i.SSN,
 i.EBTStartDate,
 i.WorkSiteCode
from dbo.Crs_vi_TimeKeeping_ExportData_base_expanded b  with(nolock) inner join dbo.CrS_timekeeping_Import i  with(nolock) on
     b.dtsassignmentid = i.DTSAssignmentId
order by b.CIN, b.date



