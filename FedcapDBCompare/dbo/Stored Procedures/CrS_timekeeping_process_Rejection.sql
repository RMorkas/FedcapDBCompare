



CREATE PROCEDURE [dbo].[CrS_timekeeping_process_Rejection] 

@RunDate AS DATETIME


as
begin


Declare @MaxExportDate datetime
Declare @MaxRejectionDate datetime

set @MaxExportDate = (select Max([datetimestamp]) from [dbo].[CrS_Timekeeping_Export])
set @MaxRejectionDate = (select Max([DateTimeStamp]) from [dbo].[CrS_Timekeeping_rejection])

update [dbo].[CrS_Timekeeping_rejection]
set runid = (select MAX(runid) from [dbo].[CrS_Timekeeping_History])
where [DateTimeStamp] = @MaxRejectionDate

update LatestExport
set LatestExport.[status] = 'Rejected', LatestExport.notes = LatestRejection.ErrorDescription 
from
(select [DTSAssignmentID],[CIN],[ActivityCode],[datetimestamp],[activitydate],[Status], notes from [dbo].[CrS_Timekeeping_Export_audit] where [datetimestamp] = @MaxExportDate) LatestExport
inner join (select [DTSAssignmentID],[CIN],[ActivityCode],[datetimestamp],[activitydate],ErrorDescription, Errorcode from [dbo].[CrS_Timekeeping_rejection] where [datetimestamp] = @MaxRejectionDate) LatestRejection
on LatestExport.DTSAssignmentID = LatestRejection.DTSAssignmentID and LatestExport.CIN = LatestRejection.CIN and LatestExport.ActivityCode = LatestRejection.ActivityCode and cast(LatestExport.activitydate as date) = cast (LatestRejection.activitydate as date)
where LatestExport.[status] = 'Updated' 
and LatestRejection.[ErrorCode] is not null


END
