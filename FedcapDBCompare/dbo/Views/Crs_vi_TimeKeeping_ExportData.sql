Create VIEW [dbo].[Crs_vi_TimeKeeping_ExportData]
AS

select top 100000 LineOut 
  from [dbo].[Crs_vi_TimeKeeping_ExportData_Base]  with(nolock)
order by cin, ActivityDate,DeleteIndicator desc