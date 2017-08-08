

CREATE procedure [dbo].[ACFReport_GetDirtyData] (@startdate datetime, @enddate datetime)
as
begin
--declare @startdate datetime
--declare @enddate datetime


--set @startdate = '06/01/2017'
--set @enddate = '06/30/2017'


select 'more than 59 avarage weekly hours'
select distinct clientid,clientno, cast([dbo].[ACF_GetAverageHours](FederalActivityType.FederalActivityId,dbo.client.clientid,@startdate,@enddate,'',4) as float) 

from dbo.client with (nolock) 
inner join [dbo].[Case] on dbo.Client.ActiveCaseId= [dbo].[Case].CaseId
cross join FederalActivityType 
where FederalActivityType.CompanyId in (1,2,3) and 
  cast([dbo].[ACF_GetAverageHours](FederalActivityType.FederalActivityId,dbo.client.clientid,@startdate,@enddate,'',4) as float)  > 59



  select 'more than 4 excused hours'

  select distinct clientid,clientno

from dbo.client with (nolock) 
inner join [dbo].[Case] on dbo.Client.ActiveCaseId= [dbo].[Case].CaseId
cross join FederalActivityType 
where isnull([dbo].[ACF_GetAverageHours](4,dbo.client.clientid,@startdate,@enddate,'excused absence',2),'00') > 4 or 
isnull([dbo].[ACF_GetAverageHours](6,dbo.client.clientid,@startdate,@enddate,'excused absence',2),'00')  > 4 or 
isnull([dbo].[ACF_GetAverageHours](8,dbo.client.clientid,@startdate,@enddate,'excused',2),'00') > 4 or 
isnull([dbo].[ACF_GetAverageHours](7,dbo.client.clientid,@startdate,@enddate,'excused absence',2),'00') > 4 or
isnull([dbo].[ACF_GetAverageHours](9,dbo.client.clientid,@startdate,@enddate,'excused absence',2),'00') >4 or 
isnull([dbo].[ACF_GetAverageHours](10,dbo.client.clientid,@startdate,@enddate,'excused absence',2),'00') > 4 or 
isnull([dbo].[ACF_GetAverageHours](12,dbo.client.clientid,@startdate,@enddate,'excused absence',2),'00') >4 or
isnull([dbo].[ACF_GetAverageHours](11,dbo.client.clientid,@startdate,@enddate,'excused absence',2),'00') >4 


  select 'more than 30 deemed hours'

--  declare @startdate datetime
--declare @enddate datetime


--set @startdate = '04/01/2017'
--set @enddate = '04/30/2017'
  select distinct clientid,caseid, clientno, caseno, dbo.getFLSACreditHours(dbo.[Case].CaseId,@enddate)

from dbo.client with (nolock) 
inner join [dbo].[Case] on dbo.Client.ActiveCaseId= [dbo].[Case].CaseId
cross join FederalActivityType 
where FederalActivityType.CompanyId =8 and 
   dbo.getFLSACreditHours(dbo.[Case].CaseId,@enddate) > 30 and dbo.[case].caseid in (
SELECT [dbo].[CaseStatushistory].[Caseid]
 FROM [dbo].[CaseStatusHistory] where [dbo].[CaseStatusHistory].Status = 'O' and datediff(d,[dbo].[CaseStatusHistory].Status_StartDate, @enddate) >= 0 
  and datediff(d, @startdate, isnull([dbo].[CaseStatusHistory].Status_endDate,'01/01/2020')) >= 0) 
 -- and dbo.IsClientSanction( '03/01/2017',dbo.[case].caseid) =0 
 and datediff(d,@enddate, isnull(client.ExemptionEffectiveDate,'01/01/2020')) > 0 

  end 





