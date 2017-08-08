
create VIEW [dbo].[CrS_vi_TimeKeeping_ExportData_Base_Expanded]
AS

select clientid, 
convert(char(11),right('0000000000'+ convert(varchar(10),DTSAssignmentID),10),11) as DTSAssignmentid, 
convert(char(9),cin,9) as CIN,
'T ' as Flag,
convert(char(11),convert(varchar(10), [activityDate],101),11) as [Date],
convert(char(3),ActivityCode ,3) as Activity_Carfare_Code,
convert(char(3),right('00' + convert(varchar(2),sum(ActivityHours),2),3)) as Hours,
isnull(DeleteIndicator,'N') as DeleteIndicator,
'' as NoCarFareReason
  from dbo.CrS_timekeeping_export  with(nolock)
 where [status] = 'updated' 
group by clientid,dbo.CrS_timekeeping_export.DTSAssignmentID,cin,ActivityDate,ActivityCode,DeleteIndicator
--Union
--select caseid, 
--convert(char(11),right('0000000000'+ convert(varchar(10),DTSAssignmentid),10),11)as DTSAssignmentid, 
--convert(char(9),cin,9)as CIN,
--convert(char(2),Flag,2)as Flag,
--convert(char(11),convert(varchar(10), [Date],101),11)as Date,
--convert(char(3), MetroCardCode,3)as Activity_Carfare_Code,
--'00' as Hours,
--isnull(DeleteIndicator, 'N') as DeleteIndicator,
--CarFareReason as NoCarfareReason
-- from dbo.CrS_timekeeping_export  with(nolock)
--where [status] = 'updated' and flag = 'C'



