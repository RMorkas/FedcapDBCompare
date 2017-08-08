
CREATE VIEW [dbo].[CrS_vi_TimeKeeping_ExportData_Base]
AS

select e.DTSAssignmentID,cin,'T' as flag,ActivityDate,e.ActivityCode,e.DeleteIndicator,
convert(char(11),right('0000000000'+ convert(varchar(10),e.DTSAssignmentID),10)) + 
convert(char(9),cin) + 
convert(char(2),'T ') + 
convert(char(11),convert(varchar(10), e.[ActivityDate],101)) +  convert(char(3),e.ActivityCode)  + 
convert(char(3),right('00' + convert(varchar(2),(sum(e.ActivityHours))),2),3) + 
convert(char(2),isnull(e.DeleteIndicator,'N')) + space(250) as LineOut


from dbo.Crs_timekeeping_export e with(nolock) 
 --where [status] = 'updated' --and flag = 'T'
group by clientid, DTSAssignmentID,cin,e.[ActivityDate],e.ActivityCode,e.DeleteIndicator


